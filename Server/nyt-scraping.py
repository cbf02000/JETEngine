import sys
import urllib2
import urllib
from nytimesarticle import articleAPI
import time

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
				f.write("'" + article['web_url'] + "','" + article['headline']['main'] + "'\n")
			except:
				print "ERROR"
	#filename = str(i) + '.json'
	#f = open(filename, 'w')
	#f.write(str(articles))
	#f.close
	time.sleep(1)
	
f.close()
