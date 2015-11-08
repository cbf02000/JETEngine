#!/usr/bin/python

import sys
from suds import null, WebFault
from suds.client import Client
import logging
import json
import urllib
import urllib2
import random
from nyt_36hours import articlesearch

username = 'tamori'
apiKey = '7d7c51dff7c200bd3ee9c484605f0e29dd6746d7'
url = 'http://flightxml.flightaware.com/soap/FlightXML2/wsdl'

def flightaware(IATACode):
	username = 'tamori'
	apiKey = '7d7c51dff7c200bd3ee9c484605f0e29dd6746d7'
	url = 'http://flightxml.flightaware.com/soap/FlightXML2/wsdl'

	#http://iatacodes.org/api/v2/airports?code=CDG
	url_iata = "http://iatacodes.org/api/v2/airports?api_key=dbe3515a-5702-4ab2-a979-3033e2114d58&code="+IATACode
	print url
	#try:
	r = urllib2.urlopen(url_iata)
	root = json.loads(r.read())
	print 'icao=' + root['response'][0]['icao']
	#except:
	#	print "error"
	icao = root['response'][0]['icao']
	
	#Get News
	newsjson = articlesearch(icao)[1:-1]
	
	logging.basicConfig(level=logging.INFO)
	api = Client(url, username=username, password=apiKey)
	#print api
	
	# Get the weather
	#result = api.service.Metar('KAUS')
	#print result
	
	# Get the flights enroute
	result = api.service.Scheduled(icao, 20, '', 40)
	#print result
	flights = result['scheduled'][random.randint(0,10)]
	origName = flights['originCity']
	destName = flights['destinationCity']
	print origName, destName
	
	imgurl_orig = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=" + urllib.quote(origName, safe='') + "&rsz=8"
	imgurl_dest = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=" + urllib.quote(destName, safe='') + "&rsz=8"
	r_o = urllib2.urlopen(imgurl_orig)
	root_o = json.loads(r_o.read())
	r_d = urllib2.urlopen(imgurl_dest)
	root_d = json.loads(r_d.read())
	imgurl_o_0 = root_o["responseData"]["results"][0]["url"]
	imgurl_o_1 = root_o["responseData"]["results"][1]["url"]
	imgurl_o_2 = root_o["responseData"]["results"][2]["url"]
	imgurl_d_0 = root_d["responseData"]["results"][0]["url"]
	imgurl_d_1 = root_d["responseData"]["results"][1]["url"]
	imgurl_d_2 = root_d["responseData"]["results"][2]["url"]
	#print imgurl_orig
	#print imgurl_dest
	#print imgurl_dest
	newsjson = articlesearch(flights['destination'])[1:-1]
	
	jsontxt = '{ "ident":"%s", "aircrafttype":"%s", "filed_departuretime":%d, "estimatedarrivaltime":%d, "origin":"%s", "destination":"%s", "originName":"%s", "originCity":"%s", "destinationName":"%s", "destinationCity":"%s", "origCityImgUrl":["%s", "%s", "%s"], "destCityImgUrl":["%s","%s","%s"], %s}' % (flights['ident'],flights['aircrafttype'],flights['filed_departuretime'],flights['estimatedarrivaltime'],flights['origin'],flights['destination'],flights['originName'],flights['originCity'],flights['destinationName'],flights['destinationCity'],imgurl_o_0,imgurl_o_1,imgurl_o_2,imgurl_d_0,imgurl_d_1,imgurl_d_2, newsjson)
	print jsontxt
	return jsontxt


	#print "Aircraft en route to KSMO:"
	#for flight in flights:
	#    print "%s (%s) \t%s (%s)" % ( flight['ident'], flight['aircrafttype'],
	#                                  flight['originName'], flight['origin'])

flightaware('SFO')