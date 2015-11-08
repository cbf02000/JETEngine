#!/bin/env python
# -*- coding: utf-8 -*-
import tornado.ioloop
import tornado.web
import json
import os
import sys
import cgi
import urllib
import urllib2
from flightaware import flightaware
from hotels import hotelsearch

class HotelHandler(tornado.web.RequestHandler): 
	def get(self):
		self.set_header("Content-Type", 'application/json; charset="utf-8"')
		airport_code = self.get_argument('airport', True)
		arrival_time = self.get_argument('arrival_time', True)
		jsontxt = hotelsearch(airport_code,arrival_time)
		self.write(jsontxt)
		
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
		root_o = json.loads(jsontxt)
		origCity = root_o["city"]
		print origCity
		imgurl_orig = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=" + urllib.quote(origCity, safe='') + "&rsz=8"
		r_o1 = urllib2.urlopen(imgurl_orig)
		root_o1 = json.loads(r_o1.read())

		imgurl_o_0 = root_o1["responseData"]["results"][0]["url"]
		imgurl_o_1 = root_o1["responseData"]["results"][1]["url"]
		imgurl_o_2 = root_o1["responseData"]["results"][2]["url"]
		imgAppJson = ', "cityImageURL":["%s","%s","%s"]}' % (imgurl_o_0, imgurl_o_1, imgurl_o_2)
		returnJsonText = jsontxt[:-1] + imgAppJson
		print returnJsonText
		#my_json = json.dumps(jsontxt, ensure_ascii=False)
		self.write(returnJsonText)
       
application = tornado.web.Application([
    (r"/nearest_airport.cgi", MainHandler),
    (r"/flight.cgi", FlightHandler),
    (r"/hotel.cgi", HotelHandler)
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()