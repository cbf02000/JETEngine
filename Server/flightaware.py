#!/usr/bin/python

import sys
from suds import null, WebFault
from suds.client import Client
import logging
import json
import urllib2
import random


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
	jsontxt = '{ "ident":"%s", "aircrafttype":"%s", "filed_departuretime":%d, "estimatedarrivaltime":%d, "origin":"%s", "destination":"%s", "originName":"%s", "originCity":"%s", "destinationName":"%s", "destinationCity":"%s"}' % (flights['ident'],flights['aircrafttype'],flights['filed_departuretime'],flights['estimatedarrivaltime'],flights['origin'],flights['destination'],flights['originName'],flights['originCity'],flights['destinationName'],flights['destinationCity'])
	print jsontxt
	return jsontxt


	#print "Aircraft en route to KSMO:"
	#for flight in flights:
	#    print "%s (%s) \t%s (%s)" % ( flight['ident'], flight['aircrafttype'],
	#                                  flight['originName'], flight['origin'])

flightaware('SFO')