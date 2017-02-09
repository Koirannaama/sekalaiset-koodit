from http.server import BaseHTTPRequestHandler, HTTPServer

def getScores():
    file = open("scores.json")
    return file.read()

class scoreServerRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

        scores = getScores()
        self.wfile.write(bytes(scores, "utf8"))
        return

def run():
    print("starting score server")
    address = ("127.0.0.1", 8081)
    httpd = HTTPServer(address, scoreServerRequestHandler)
    print("running score server")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("closing server")
        httpd.socket.close()
run()
