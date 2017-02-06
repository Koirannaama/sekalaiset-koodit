from http.server import BaseHTTPRequestHandler, HTTPServer

class scoreServerRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

        scores = "Here be scores (eventually)"
        self.wfile.write(bytes(scores, "utf8"))
        return

def run():
    print("starting score server")
    address = ("127.0.0.1", 8081)
    httpd = HTTPServer(address, scoreServerRequestHandler)
    print("running score server")
    httpd.serve_forever()

run()
