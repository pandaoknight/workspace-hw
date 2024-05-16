import os
import base64
import json
from PIL import Image

def encode_image_to_base64(image_path):
    """Convert image file to base64 encoded string"""
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def save_base64_images(directory, output_file):
    """Process and save all images base64 in the directory to a file"""
    with open(output_file, 'w') as file:
        for filename in os.listdir(directory):
            if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
                file_path = os.path.join(directory, filename)
                image_base64 = encode_image_to_base64(file_path)
                file.write(json.dumps({"image": image_base64}) + "\n")

# Usage
images_directory = './reshaped_png'
output_file = './base64_encoded_images.txt'
save_base64_images(images_directory, output_file)

