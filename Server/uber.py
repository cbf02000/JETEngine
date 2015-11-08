import requests

def uber_estimate_time(start_lat, start_long, dest_lat, dest_long):
	url = 'https://api.uber.com/v1/estimates/time'
	#url = 'https://login.uber.com/oauth/v2/authorize'
	parameters = {
	    'server_token': 'aSfmb6XBbRlJ1-I1W0JYG3AzqD5b6HPWkChtm3B2',
	    'start_latitude': start_lat,
	    'start_longitude': start_long,
	}
	
	response = requests.get(url, params=parameters)
	
	data = response.json()
	print data
	products = data["times"]
	
	for product in products:
		if product['display_name'] == 'uberX':
			estimate_time = product['estimate']
	
	print estimate_time
	
	url_g = 'https://maps.googleapis.com/maps/api/distancematrix/json'
	origins = '%s,%s'%(start_lat, start_long)
	destinations = '%s,%s'%(dest_lat, dest_long)
	parameters_g = {
	    'origins': origins,
	    'destinations': destinations,
	    'key': 'AIzaSyAWvPq59JI3twHnjPAVcOK8moOF2fXuihM',
	    'mode': 'driving'
	}
	
	response_g = requests.get(url_g, params=parameters_g)
	
	data_g = response_g.json()
	print data_g
	travel_time = data_g["rows"][0]["elements"][0]["duration"]["value"]
	print travel_time
	
	jsontxt = '{ "uber_estimate_sec": %d, "travel_estimate_sec": %d}' % (int(estimate_time), int(travel_time))
	print jsontxt
	return jsontxt

uber_estimate_time('37.6223933','-122.4114655','37.4687316','-122.2045152')