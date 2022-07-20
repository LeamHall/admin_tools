#!/usr/bin/env python

# name:     httpd_server.py
# version:  0.0.1
# date:     20220720
# author:   Leam Hall
# desc:     Demo httpd server

## NOTES
# Defaults to localhost, port 8080


from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib import parse
import json 

class GetHandler(BaseHTTPRequestHandler):
  def do_GET(self): 
    style = ''
    parsed_path = parse.urlparse(self.path)
    style_array = parsed_path.query.split('=') 
    if len(style_array) > 1:
      style = style_array[1]
    self.send_response(200)

    if style == "text":
      # curl localhost:8080?style=text
      self.send_header('Content-Type', 'text/plain; charset=utf-8')
      message = "Howest now, yon traveller, weary and in need of rest?\n\n"
      self.end_headers()
      self.wfile.write(message.encode('utf-8'))
    elif style == "json":
      # curl localhost:8080?style=json
      self.send_header('Content-Type', 'application/json')
      self.end_headers()
      jData = json.dumps({'greeting': 'Howest now, ', 'identifier': 'yon weary traveller?'})
      self.wfile.write(jData.encode(encoding='utf-8'))
    else:
      # curl localhost:8080
      self.send_header('Content-Type', 'text/plain; charset=utf-8')
      message = "Wotcher?\n\n"
      self.end_headers()
      self.wfile.write(message.encode('utf-8'))
      

if __name__ == '__main__':
  server = HTTPServer(('127.0.0.1', 8080), GetHandler)
  print("serving the universe...")
  server.serve_forever()
