import sys
import urllib2
import urllib
from nytimesarticle import articleAPI
import time
import requests
import json

api = articleAPI('a3de91f34b805b03d5b06d3478813176:4:72566137')

filename = "url.txt"
f = open(filename, 'w')
# To get JSON File written the url of "36 Hours" articles and save to file named [0-70].json
for i in range(0,71):
	articles = api.search( fq = {'source':'The New York Times', 'news_desk':'Travel', 'headline':'36 Hours'}, fl = ['web_url', 'headline'], page = i)
	print articles
	for article in articles['response']['docs']:
		url = article['web_url']
		title = article['headline']['main']
		#print url
		if url.find('video') == -1 and url.find('interactive') == -1 and url.find('slideshow') == -1 and title.find('36 Hours in') != -1:
			#print article['headline']['main']
			#print article['web_url']
			try:
				start = article['headline']['main'].find("36 Hours in") + 12
				if article['headline']['main'].find(":") == -1:
					end = len(article['headline']['main'])
				else:
					end = article['headline']['main'].find(":")
					
				url_g = 'https://maps.googleapis.com/maps/api/geocode/json'
				parameters_g = {
				    'address': article['headline']['main'][start:end],
				    'key': 'AIzaSyDB0pbrCkKlacgpc9-2lun552rQJccKcK8'
				}
				
				response_g = requests.get(url_g, params=parameters_g)
				
				data_g = response_g.json()
				print data_g
				lat = data_g["results"][0]["geometry"]["location"]["lat"]
				lng = data_g["results"][0]["geometry"]["location"]["lng"]
	
				url = "https://airport.api.aero/airport/nearest/" + str(lat) + "/" + str(lng) + "?user_key=72963f44671d7039fe893d82903bc457"
				print url
				response = urllib2.urlopen(url)
				html = response.read()
				jsontxt = html[html.find("airports")+11:-3]
				root_o = json.loads(jsontxt)
				iata_code = root_o["code"]
							
				#http://iatacodes.org/api/v2/airports?code=CDG
				url_iata = "http://iatacodes.org/api/v2/airports?api_key=dbe3515a-5702-4ab2-a979-3033e2114d58&code="+iata_code
				print url
				#try:
				r = urllib2.urlopen(url_iata)
				root = json.loads(r.read())
				print 'icao=' + root['response'][0]['icao']
				#except:
				#	print "error"
				icao = root['response'][0]['icao']

				f.write("'" + article['web_url'] + "','" + article['headline']['main'] + "','" + article['headline']['main'][start:end] + "','" + str(lat) + "','" + str(lng) + "','" + icao +"'\n")
			except:
				print "ERROR"
	#filename = str(i) + '.json'
	#f = open(filename, 'w')
	#f.write(str(articles))
	#f.close
	time.sleep(1)
	
f.close()
