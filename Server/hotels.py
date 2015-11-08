import sys
from suds import null, WebFault
from suds.client import Client
import logging
import json
import urllib
import urllib2
import random
import unirest

# These code snippets use an open-source library.
def hotelsearch(airportCode_icao, arrivalTime_Unix):

	username = 'tamori'
	apiKey = '7d7c51dff7c200bd3ee9c484605f0e29dd6746d7'
	url = 'http://flightxml.flightaware.com/soap/FlightXML2/wsdl'

	logging.basicConfig(level=logging.INFO)
	api = Client(url, username=username, password=apiKey)
	
	# Get the flights enroute
	result = api.service.AirportInfo(airportCode_icao)
	#print result
	lat = result['latitude']
	lon = result['longitude']
	
	hotel_url = "https://zilyo.p.mashape.com/search?guests=1&latitude=" + str(lat) +"&longitude=" + str(lon) + "&maxdistance=60&provider=airbnb%2Chomeway%2Ctrabelmob"
	response = unirest.get(hotel_url,
	  headers={
	    "X-Mashape-Key": "vioOCtwq7UmshHlopZxhqdqacfI7p16ejBHjsnJPBH0Ff9Dfp0",
	    "Accept": "application/json"
	  }
	)
	checkin_Time = int(arrivalTime_Unix)
	checkoutTime = checkin_Time + 60*60*24*2
	results = response.body["result"]
	available_hotel_id = []
	for result in results:
		available_times = result["availability"]
		for i, available_time in enumerate(available_times):
			if available_time["start"] < checkin_Time and checkoutTime < available_time["end"]:
				available_hotel_id.append(i)
	
	result_rand = results[available_hotel_id[random.randint(0,len(available_hotel_id)-1)]]
	hotel_latLng = result_rand["latLng"]
	hotel_photo = result_rand["photos"][0]["medium"]
	hotel_loc = result_rand["location"]["all"]
	hotel_prov_url = result_rand["provider"]["url"]
	hotel_name = result_rand["attr"]["heading"]
	jsontxt = '{"hotel_name":"%s","hotel_latLng":[%f,%f],"hotel_photo":"%s","hotel_addr":"%s","hotel_prov_url":"%s"}'%(hotel_name,hotel_latLng[0],hotel_latLng[1],hotel_photo,hotel_loc,hotel_prov_url)
	
	return jsontxt
	

#print hotelsearch("KSFO", "1446950717")