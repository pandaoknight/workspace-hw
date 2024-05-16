#-*- encoding: utf-8 -*-
from fastapi import FastAPI, HTTPException
import uvicorn
from mindspore import load_checkpoint, load_param_into_net
from typing import Dict
import traceback
import mindspore as ms
import mindspore.dataset as ds
import mindspore.dataset.vision as vision
import mindspore.dataset.transforms as transforms
from mindspore import dtype as mstype
from mindspore import Tensor
from typing import Type, Union, List, Optional
import numpy as np
import os
import base64
import cv2
import json
import argparse

from typing import Type, Union, List, Optional
import mindspore.nn as nn
from mindspore.common.initializer import Normal

# 初始化卷积层与BatchNorm的参数
weight_init = Normal(mean=0, sigma=0.02)
gamma_init = Normal(mean=1, sigma=0.02)


class ResidualBlockBase(nn.Cell):
    expansion: int = 1  # 最后一个卷积核数量与第一个卷积核数量相等

    def __init__(self,
                 in_channel: int,
                 out_channel: int,
                 stride: int = 1,
                 norm: Optional[nn.Cell] = None,
                 down_sample: Optional[nn.Cell] = None) -> None:
        super(ResidualBlockBase, self).__init__()
        if not norm:
            self.norm = nn.BatchNorm2d(out_channel)
        else:
            self.norm = norm

        self.conv1 = nn.Conv2d(in_channel, out_channel, kernel_size=3, stride=stride, weight_init=weight_init)
        self.conv2 = nn.Conv2d(in_channel, out_channel, kernel_size=3, weight_init=weight_init)
        self.relu = nn.ReLU()
        self.down_sample = down_sample

    def construct(self, x):
        """ResidualBlockBase construct."""
        identity = x  # shortcuts分支

        out = self.conv1(x)  # 主分支第一层：3*3卷积层
        out = self.norm(out)
        out = self.relu(out)
        out = self.conv2(out)  # 主分支第二层：3*3卷积层
        out = self.norm(out)

        if self.down_sample is not None:
            identity = self.down_sample(x)
        out += identity  # 输出为主分支与shortcuts之和
        out = self.relu(out)

        return out


class ResidualBlock(nn.Cell):
    expansion = 4  # 最后一个卷积核的数量是第一个卷积核数量的4倍

    def __init__(self,
                 in_channel: int,
                 out_channel: int,
                 stride: int = 1,
                 down_sample: Optional[nn.Cell] = None) -> None:
        super(ResidualBlock, self).__init__()

        self.conv1 = nn.Conv2d(in_channel, out_channel, kernel_size=1, weight_init=weight_init)
        self.norm1 = nn.BatchNorm2d(out_channel)
        self.conv2 = nn.Conv2d(out_channel, out_channel, kernel_size=3, stride=stride, weight_init=weight_init)
        self.norm2 = nn.BatchNorm2d(out_channel)
        self.conv3 = nn.Conv2d(out_channel, out_channel * self.expansion, kernel_size=1, weight_init=weight_init)
        self.norm3 = nn.BatchNorm2d(out_channel * self.expansion)

        self.relu = nn.ReLU()
        self.down_sample = down_sample

    def construct(self, x):

        identity = x  # shortscuts分支

        out = self.conv1(x)  # 主分支第一层：1*1卷积层
        out = self.norm1(out)
        out = self.relu(out)
        out = self.conv2(out)  # 主分支第二层：3*3卷积层
        out = self.norm2(out)
        out = self.relu(out)
        out = self.conv3(out)  # 主分支第三层：1*1卷积层
        out = self.norm3(out)

        if self.down_sample is not None:
            identity = self.down_sample(x)

        out += identity  # 输出为主分支与shortcuts之和
        out = self.relu(out)

        return out


def make_layer(last_out_channel,
               block: Type[Union[ResidualBlockBase, ResidualBlock]],
               channel: int,
               block_nums: int,
               stride: int = 1):
    down_sample = None  # shortcuts分支

    if stride != 1 or last_out_channel != channel * block.expansion:

        down_sample = nn.SequentialCell([
            nn.Conv2d(last_out_channel,
                      channel * block.expansion,
                      kernel_size=1,
                      stride=stride,
                      weight_init=weight_init),
            nn.BatchNorm2d(channel * block.expansion, gamma_init=gamma_init)
        ])

    layers = []
    layers.append(block(last_out_channel, channel, stride=stride, down_sample=down_sample))

    in_channel = channel * block.expansion
    # 堆叠残差网络
    for _ in range(1, block_nums):

        layers.append(block(in_channel, channel))

    return nn.SequentialCell(layers)


class ResNet(nn.Cell):

    def __init__(self, block: Type[Union[ResidualBlockBase, ResidualBlock]], layer_nums: List[int], num_classes: int,
                 input_channel: int) -> None:
        super(ResNet, self).__init__()

        self.relu = nn.ReLU()
        # 第一个卷积层，输入channel为3（彩色图像），输出channel为64
        self.conv1 = nn.Conv2d(3, 64, kernel_size=7, stride=2, weight_init=weight_init)
        self.norm = nn.BatchNorm2d(64)
        # 最大池化层，缩小图片的尺寸
        self.max_pool = nn.MaxPool2d(kernel_size=3, stride=2, pad_mode='same')
        # 各个残差网络结构块定义
        self.layer1 = make_layer(64, block, 64, layer_nums[0])
        self.layer2 = make_layer(64 * block.expansion, block, 128, layer_nums[1], stride=2)
        self.layer3 = make_layer(128 * block.expansion, block, 256, layer_nums[2], stride=2)
        self.layer4 = make_layer(256 * block.expansion, block, 512, layer_nums[3], stride=2)
        # 平均池化层
        self.avg_pool = nn.AvgPool2d()
        # flattern层
        self.flatten = nn.Flatten()
        # 全连接层
        self.fc = nn.Dense(in_channels=input_channel, out_channels=num_classes)

    def construct(self, x):

        x = self.conv1(x)
        x = self.norm(x)
        x = self.relu(x)
        x = self.max_pool(x)

        x = self.layer1(x)
        x = self.layer2(x)
        x = self.layer3(x)
        x = self.layer4(x)

        x = self.avg_pool(x)
        x = self.flatten(x)
        x = self.fc(x)

        return x


def parse_args():
    parser = argparse.ArgumentParser(description="ICM algorithms server script.")
    parser.add_argument(
        "--config",
        default="/data/sdv1/zhoutianqi/mindspore_resnet/infer.json",
        help="Hyper parameter config path.",
    )
    args = parser.parse_args()
    return args


# os.environ['CUDA_VISIBLE_DEVICES'] = "3"

args = parse_args()
with open(args.config, "r") as f:
    infer_json = json.load(f)

ckpt = infer_json.get("load_from").replace("pth", "ckpt")
# ckpt = infer_json.get("load_from")
port = infer_json.get("service").get("port")
host = infer_json.get("service").get("ip")

app = FastAPI()

classes = ["airplane", "automobile", "bird", "cat", "deer", "dog", "frog", "horse", "ship", "truck"]
categories = [{
    "id": 0,
    "name": "airplane"
}, {
    "id": 1,
    "name": "automobile"
}, {
    "id": 2,
    "name": "bird"
}, {
    "id": 3,
    "name": "cat"
}, {
    "id": 4,
    "name": "deer"
}, {
    "id": 5,
    "name": "dog"
}, {
    "id": 6,
    "name": "frog"
}, {
    "id": 7,
    "name": "horse"
}, {
    "id": 8,
    "name": "ship"
}, {
    "id": 9,
    "name": "truck"
}]


def base642img(data_bs64):
    data_bs64 = base64.b64decode(data_bs64)
    image_array = np.frombuffer(data_bs64, dtype=np.uint8)
    image = cv2.imdecode(image_array, 1)
    return image


def preprocess(img):
    # 使用vision模块进行前处理
    trans = [
        vision.Resize((32, 32)),
        vision.Rescale(1.0 / 255.0, 0.0),
        vision.Normalize([0.4914, 0.4822, 0.4465], [0.2023, 0.1994, 0.2010]),
        vision.HWC2CHW()
    ]
    trans = transforms.Compose(trans)

    img = Tensor(trans(img)[None, ...])
    return img


def _resnet(model_url: str, block: Type[Union[ResidualBlockBase, ResidualBlock]], layers: List[int], num_classes: int,
            pretrained: bool, pretrained_ckpt: str, input_channel: int):
    model = ResNet(block, layers, num_classes, input_channel)

    if pretrained:
        # 加载预训练模型
        # download(url=model_url, path=pretrained_ckpt, replace=True)
        param_dict = load_checkpoint(pretrained_ckpt)
        load_param_into_net(model, param_dict)

    return model


def resnet50(num_classes: int = 1000, pretrained: bool = False,ckpt =ckpt):
    "ResNet50模型"
    resnet50_url = "https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/notebook/models/application/resnet50_224_new.ckpt"
    resnet50_ckpt = ckpt
    return _resnet(resnet50_url, ResidualBlock, [3, 4, 6, 3], num_classes, pretrained, resnet50_ckpt, 2048)


net = resnet50(10,ckpt = ckpt)
param_dict = ms.load_checkpoint(ckpt)
ms.load_param_into_net(net, param_dict)
net.set_train(False) 

@app.get("/infer")
async def get_text():
    result_out = {}
    result_out["code"] = 200
    result_out["msg"] = "Server is health"
    return result_out

@app.post("/infer")
async def post_text(data: Dict):
    try:
        out_dict = {}
        result_out = {}
        input = data["image"]
        input = base642img(input)
        input = preprocess(input)
        result = net(input)
        pred = np.argmax(result.asnumpy(), axis=1)
        out_dict["images"] = [{"fileName": "0", "annotations": {"imgCategory": [int(pred)]}}]
        out_dict["categories"] = categories
        result_out["content"] = out_dict
        result_out["code"] = "200"
        result_out["msg"] = "success"
        return result_out
    except Exception as e:
        exc_type = type(e).__name__
        exc_msg = str(e)
        exc_traceback = traceback.format_exc()

        error_detail = {
            "error_type": exc_type,
            "error_message": exc_msg,
            "traceback": exc_traceback,
        }

        raise HTTPException(status_code=500, detail=error_detail)


if __name__ == "__main__":
    print("*" * 20, "start", "*" * 20)
    uvicorn.run(app='inference:app', host=host, port=port, reload=False, workers=1) 

