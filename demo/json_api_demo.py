#!/usr/bin/env python3

# name:     json_api_demo.py
# version:  0.0.1
# date:     20220720
# author:   Leam Hall
# desc:     Demo httpd server

## NOTES
# Defaults to localhost, port 8080
# systemD notes from https://martinberoiz.org/2019/03/10/how-to-write-systemd-daemons-using-python/

## Writing a systemD service
# file: /etc/systemd/system/pyhttpd.service
# [Unit]
# Description=Python based HTTPD
# After=network.target

# [Service]
# Type=simple
# ExecStart=<rootdir>/httpd_server.py &
# Restart=always-failure


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

        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        output = { 'control_node': ['one', 'two', 'three'] }
        #jData = json.dumps({'greeting': 'Howest now, ', 'identifier': 'yon weary traveller?'})
        jData = json.dumps(output)
        self.wfile.write(jData.encode(encoding='utf-8'))
            

if __name__ == '__main__':
    server = HTTPServer(('127.0.0.1', 8080), GetHandler)
    print("serving the universe...")
    server.serve_forever()
