import sys
from suds import null, WebFault
from suds.client import Client
import logging
import json
import urllib
import urllib2
import random
import unirest
import csv

# These code snippets use an open-source library.
def articlesearch(airportCode_icao):
	
	path = '/home/ec2-user/server-side/url.txt'
	rows = csv.DictReader(open(path), delimiter = '\t')
	articles = []
	
	username = 'tamori'
	apiKey = '7d7c51dff7c200bd3ee9c484605f0e29dd6746d7'
	url = 'http://flightxml.flightaware.com/soap/FlightXML2/wsdl'

	logging.basicConfig(level=logging.INFO)
	api = Client(url, username=username, password=apiKey)
	
	# Get the flights enroute
	result = api.service.AirportInfo(airportCode_icao)
	#print result
	loca = result['location']
	name = result['name']
	print loca, name
	
	for row in rows:
		#print row["code"]
		if row["code"] == airportCode_icao:
			articles.append(row)
	if len(articles) == 0:
		url_trip = "http://www.tripadvisor.com/Search?q=" + urllib.quote(loca, safe='')
		jsontxt = '{"code":"%s","url":"%s","title":"%s","city":"%s"}' % (airportCode_icao, url_trip, 'tripadvisor Search', loca)
	else:
		jsontxt = '{"code":"%s","url":"%s","title":"%s","city":"%s"}' % (articles[0]["code"], articles[0]["url"], articles[0]["title"], articles[0]["city"])
	return jsontxt
			
print articlesearch("KSFO")
	
