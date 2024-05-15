import tornado.ioloop
import tornado.web
import json
import logging
import base64
import io
import mindspore.dataset as ds
from mindspore.dataset import vision
from mindspore import dtype as mstype
from PIL import Image
import numpy as np

# Define the helper function for base64 to dataset conversion
def base64_to_mindspore_dataset(base64_str, resize):
    # Decode the base64 string
    image_data = base64.b64decode(base64_str)
    image = Image.open(io.BytesIO(image_data))

    # Convert to ndarray and reshape according to MindSpore's requirement
    image = np.array(image.resize((resize, resize)))
    image = np.transpose(image, (2, 0, 1))  # HWC to CHW
    image = image.astype(np.float32)
    #image = (image - np.array([0.4914, 0.4822, 0.4465]) * 255) / (np.array([0.2023, 0.1994, 0.2010]) * 255)
    mean = np.array([0.4914, 0.4822, 0.4465])[:, np.newaxis, np.newaxis] * 255
    std = np.array([0.2023, 0.1994, 0.2010])[:, np.newaxis, np.newaxis] * 255
    image = (image - mean) / std

    # Create a MindSpore dataset from the single image
    image = np.expand_dims(image, axis=0)  # Add batch dimension
    dataset = ds.NumpySlicesDataset(data=image, column_names=["image"], shuffle=False)
    return dataset

# Define the Tornado request handler
class MainHandler(tornado.web.RequestHandler):
    def post(self):
        response_data = {}
        try:
            data = json.loads(self.request.body)
            if 'pic' in data:
                base64_str = data['pic']
                # Convert the base64 string to a MindSpore dataset
                dataset = base64_to_mindspore_dataset(base64_str, resize=32)
                # Get the number of images and image shape from the dataset
                num_images = dataset.get_dataset_size()
                image_shape = dataset.output_shapes()[0]
                logging.info(f"Number of images: {num_images}, Image shape: {image_shape}")
                response_data['num_images'] = num_images
                response_data['image_shape'] = image_shape
            else:
                logging.info("No 'pic' field found in the JSON data.")
                response_data['error'] = "No 'pic' field found in the JSON data."
        except json.JSONDecodeError:
            logging.error("Invalid JSON data.")
            self.set_status(400)
            self.finish({"error": "Invalid JSON data"})
            return
        
        # Send the response data as JSON
        self.write(response_data)

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    app = make_app()
    app.listen(8888)
    print("Server is running on http://localhost:8888")
    tornado.ioloop.IOLoop.current().start()

