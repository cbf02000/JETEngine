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
	
	path = 'url.txt'
	rows = csv.DictReader(open(path), delimiter = '\t')
	articles = []
	for row in rows:
		
		#print row["code"]
		if row["code"] == airportCode_icao:
			articles.append(row)
	if len(articles) == 0:
		return '{"code":"none","url":"none","title":"none","city":"none"}'
	else:
		jsontxt = '{"code":"%s","url":"%s","title":"%s","city":"%s"}' % (articles[0]["code"], articles[0]["url"], articles[0]["title"], articles[0]["city"])
		return jsontxt
			
print articlesearch("KSFO")
	
