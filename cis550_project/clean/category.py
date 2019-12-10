print("id,category")

s = str(input())

while True:
	try:
		line = str(input())
		data = line.split(",")
		business_id = data[0]
		categories = data[-1].split(";")
		for category in categories:
			print(business_id + "," + category)
	except:
		break