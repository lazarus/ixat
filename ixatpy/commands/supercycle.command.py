def supercycleCommand(args, client, server):
	from random import randint, choice
	tiers = randint(2, 4)
	code = "y"
	x = 0
	while x < tiers:
		s = ["%06x" % randint(0, 0xFFFFFF), choice(["n", "l", "q", "i", "o"])]
		frames = randint(0, 71)
		code += s[0]
		x += 1
		if x != tiers:
			code += s[1] + str(frames)
	client.sendRoom('<m t="(smile#' + code + '#) [Server generated message]" u="854" i="0" />')
