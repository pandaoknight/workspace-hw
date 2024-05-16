import tornado.ioloop
import tornado.web
import json
import logging

class MainHandler(tornado.web.RequestHandler):
    def post(self):
        response_data = {}
        try:
            data = json.loads(self.request.body)
            if isinstance(data, dict):
                for key, value in data.items():
                    value_str = str(value)[:50]
                    logging.info(f"Param: {key}, Value: {value_str}")
                    response_data[key] = value_str
            else:
                logging.info("Received data is not a JSON object")
                self.set_status(400)
                self.finish({"error": "Invalid JSON data"})
                return
        except json.JSONDecodeError:
            for key, value in self.request.arguments.items():
                value_str = str(value[0].decode())[:50]
                logging.info(f"Param: {key}, Value: {value_str}")
                response_data[key] = value_str
        
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

