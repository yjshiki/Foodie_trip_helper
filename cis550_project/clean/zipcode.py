def clean(s):
	s = s.replace("\"", "")
	s = s.replace("\r", "")
	s = s.replace(" ", "")
	return s

print("Zipcode,Borough,Neighborhood")
try:
	while True:
		line = input()
		tokens = line.split(",")
		zipcodes = tokens[2:]
		# print(zipcodes)
		# zipcodes = zipcodes.split(",")
		for zipcode in zipcodes:
			zipcode = clean(zipcode)
			# print(zipcode)
			print(zipcode + "," + tokens[0] + "," + tokens[1])
except:
	pass

