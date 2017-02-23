from http.server import BaseHTTPRequestHandler, HTTPServer
import cgi
import json

def getScores():
    file = open("scores.json")
    data = file.read()
    file.close()
    return data

def saveScore(score):
    scoreData = getScores()
    scores = json.loads(scoreData)
    scoreList = scores["scores"]
    scoreList.append(score)

    file = open("scores.json", "w")
    json.dump(scores, file)
    file.close()

class scoreServerRequestHandler(BaseHTTPRequestHandler):

    def createScoreResponse(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()

        scores = getScores()
        self.wfile.write(bytes(scores, "utf8"))

    def do_GET(self):
        self.createScoreResponse()
        return

    def do_POST(self):
        length = int(self.headers["content-length"])
        data = self.rfile.read(length)
        newScore = json.loads(data.decode("utf-8"))
        saveScore(newScore)
        self.createScoreResponse()
        return

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header("Access-Control-Expose-Headers", "Access-Control-Allow-Origin")
        self.send_header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
        self.end_headers()

        #scores = getScores()
        self.wfile.write(bytes("{}", "utf8"))
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
