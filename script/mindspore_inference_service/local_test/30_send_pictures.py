import os
import base64
from PIL import Image
import requests
import json

def encode_image_to_base64(image_path):
    """Convert image file to base64 encoded string"""
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def send_image_as_base64(url, image_base64):
    """Send POST request containing base64 encoded image"""
    headers = {'Content-Type': 'application/json'}
    #payload = json.dumps({"pic": image_base64})
    payload = json.dumps({"image": image_base64})
    response = requests.post(url, headers=headers, data=payload)
    try:
        # Attempt to print JSON response
        response_json = response.json()
        print(json.dumps(response_json, indent=4))  # Format and print JSON like jq
    except json.JSONDecodeError:
        # Print raw response if not in JSON format
        print(response.text)
    return response

def process_images(directory, url):
    """Process and send all images in the directory"""
    if not os.listdir(directory):
        print("No images found in the directory.")
        return

    for filename in os.listdir(directory):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            file_path = os.path.join(directory, filename)
            print(f"Processing and sending {filename}...")
            image_base64 = encode_image_to_base64(file_path)
            response = send_image_as_base64(url, image_base64)
            print(f"Sent {filename}, server responded with status code {response.status_code}.")

# Usage
images_directory = './reshaped_png'
#post_url = 'http://localhost:8888/'  # Change to your target URL
#post_url = 'http://localhost:8888/'  # Change to your target URL
post_url = "http://101.204.146.85:31000/icaplat-predict/rest/v1/serving/online/PICTURE_CLASSIFY/infer/r3b9ac9fa"
post_url = "http://100.86.125.50:80/infer"
process_images(images_directory, post_url)
