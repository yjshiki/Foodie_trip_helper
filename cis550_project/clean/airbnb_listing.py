s = input()
try:
	while True:
		s = input()
		s = s[s.find("\t") + 1:]
		print(s)
except:
	pass