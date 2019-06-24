def scCommand(args, client, server):
	code = list("yffffffff")
	parsedCode = ""
	modes = ["n", "l", "q", "i", "o"]
	i = 0
	if code[0] == "y":
		for l in code:
			if i % 8 == 7:
				if not l in modes:
					l = "l"
			parsedCode += l
			i += 1