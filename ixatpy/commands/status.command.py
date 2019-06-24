def statusCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		client.send('<m t="You\'re an owner." u="0" />')
	elif client.info["id"] in server.config["helpers"]:
		client.send('<m t="You\'re a helper." u="0" />')
	else:
		client.send('<m t="You\'re a regular user." u="0" />')