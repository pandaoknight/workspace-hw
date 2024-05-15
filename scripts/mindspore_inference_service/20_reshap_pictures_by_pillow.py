import os
from PIL import Image

def crop_to_square(image):
    """裁剪图像至中心正方形"""
    width, height = image.size
    min_dim = min(width, height)
    left = (width - min_dim) / 2
    top = (height - min_dim) / 2
    right = (width + min_dim) / 2
    bottom = (height + min_dim) / 2
    return image.crop((left, top, right, bottom))

def resize_and_save(image, size, save_path):
    """调整图像大小并保存"""
    image = image.resize((size, size), Image.ANTIALIAS)
    image.save(save_path)

def process_images(input_dir, output_dir):
    """处理输入目录中的所有图像"""
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for filename in os.listdir(input_dir):
        print("Processing: ", filename)
        if filename.lower().endswith('.jpg'):
            file_path = os.path.join(input_dir, filename)
            image = Image.open(file_path)
            image = crop_to_square(image)

            # 保存64x64版本
            resize_and_save(image, 64, os.path.join(output_dir, filename.replace('.jpg', '_64x64.png')))
            # 保存32x32版本
            resize_and_save(image, 32, os.path.join(output_dir, filename.replace('.jpg', '_32x32.png')))

# 用法
input_directory = './original_jpg'
output_directory = './reshaped_png'
process_images(input_directory, output_directory)
