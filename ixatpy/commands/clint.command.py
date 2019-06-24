def clintCommand(args, client, server):
	try:
		color = str(int("0x" + str(args[1]), 16))
		client.sendRoom('<m t="Test: ' + color + '" u="0" />')
	except ValueError:
		client.sendRoom('<m t="Value error." u="0" />')