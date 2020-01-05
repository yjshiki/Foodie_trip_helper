while True:
	s = input()
	print("LOAD DATA LOCAL INFILE \'dataset/" + s + "\' INTO TABLE " + s[:-4] + " FIELDS TERMINATED BY \',\' ENCLOSED BY \'\"\';")
