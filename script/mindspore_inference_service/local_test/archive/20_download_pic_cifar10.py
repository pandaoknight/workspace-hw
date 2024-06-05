from download import download
import numpy as np
from PIL import Image

def download_cifar10():
    url = "https://mindspore-website.obs.cn-north-4.myhuaweicloud.com/notebook/datasets/cifar-10-binary.tar.gz"
    download(url, "./datasets-cifar10-bin", kind="tar.gz", replace=False)

def unpickle(file):
    import pickle
    with open(file, 'rb') as fo:
        dict = pickle.load(fo, encoding='bytes')
    return dict

def load_cifar10_batch(file):
    with open(file, 'rb') as f:
        data = np.frombuffer(f.read(), dtype=np.uint8)
    labels = data[::3073]  # 每3073字节取出的第一个字节为标签
    images = data[1:].reshape((10000, 3072)).reshape((10000, 3, 32, 32)).transpose(0, 2, 3, 1)
    return images, labels

def save_images(images, labels, num_images):
    for i in range(num_images):
        img = Image.fromarray(images[i])
        img.save(f'image_{i+1}_{labels[i]}.png')

# Download and extract CIFAR-10 dataset
download_cifar10()

# Load the first batch
images, labels = load_cifar10_batch('datasets-cifar10-bin/cifar-10-batches-bin/data_batch_1.bin')

# Save the first 5 images
save_images(images, labels, 5)
