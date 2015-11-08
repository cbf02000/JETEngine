#!/bin/env python
# -*- coding: utf-8 -*-
import tornado.ioloop
import tornado.web
import json
import os
import sys
import cgi
import urllib2
from flightaware import flightaware

class FlightHandler(tornado.web.RequestHandler): 
	def get(self):
		self.set_header("Content-Type", 'application/json; charset="utf-8"')
		airport_code = self.get_argument('airport', True)
		jsontxt = flightaware(airport_code)
		
		#url = "http://www.flightstats.com/go/FlightStatus/flightStatusByAirport.do?airport=SFO&airportQueryDate=2015-11-07&airportQueryTime=16"
		#response = urllib2.urlopen(url)
		#html = response.read()
		self.write(jsontxt)

class MainHandler(tornado.web.RequestHandler):
	def get(self):
		self.set_header("Content-Type", 'application/json; charset="utf-8"')
		lon = self.get_argument('lon', True)
		lat = self.get_argument('lat', True)
		url = "https://airport.api.aero/airport/nearest/" + lat + "/" + lon + "?user_key=72963f44671d7039fe893d82903bc457"
		print url
		response = urllib2.urlopen(url)
		html = response.read()
		jsontxt = html[html.find("airports")+11:-3]
		#my_json = json.dumps(jsontxt, ensure_ascii=False)
		self.write(jsontxt)
       
application = tornado.web.Application([
    (r"/nearest_airport.cgi", MainHandler),
    (r"/flight.cgi", FlightHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()