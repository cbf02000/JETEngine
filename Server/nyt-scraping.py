import sys
import urllib2
import urllib
from nytimesarticle import articleAPI
import time

api = articleAPI('a3de91f34b805b03d5b06d3478813176:4:72566137')


#articles = api.search( fq = {'source':'The New York Times', 'news_desk':'Travel', 'headline':'36 Hours'}, fl = {'web_url', 'headline'}, page = 0)
#print articles
	
#data = urllib.urlencode(values)
#req = urllib2.Request(url, data)
#response = urllib2.urlopen(req)
#the_page = response.read()	
#print the_page

for i in range(0,71):
	articles = api.search( fq = {'source':'The New York Times', 'news_desk':'Travel', 'headline':'36 Hours'}, fl = ['web_url', 'headline'], page = i)
	print articles
	filename = str(i) + '.json'
	f = open(filename, 'w')
	f.write(str(articles))
	f.close
	time.sleep(1)
#	print url
#	response = urllib2.urlopen(url)
#	html = response.read()
#	print html