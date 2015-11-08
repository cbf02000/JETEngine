import os
import sys
import glob
import json

filenames = glob.glob("/home/ec2-user/server-side/json/*.json")

for filename in filenames:
	f = open(filename, 'r')
	jsonData = json.load(f)
	print json.dumps(jsonData, sort_keys = True, indent = 4)
	f.close()
