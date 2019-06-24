def configCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			com = args[1].lower()
		except:
			com = ""

		if com == "reset" or com == "reload":
			server.getConfig()
			client.sendRoom('<m t="Configuration has been reloaded." u="0" />')
		elif com == "help" or com == "info":
			client.send('<m t="You can reset the config with ' + args[0][0] + 'config [reset/reload]" u="0" />')
		else:
			client.send('<m t="Commands are ' + args[0][0] + 'config [reset/reload] [opt]" u="0" />')
			client.send('<m t="e.g. ' + args[0][0] + 'config reset" u="0" />')