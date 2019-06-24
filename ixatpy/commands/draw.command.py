def drawCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		from random import shuffle
		store = server.clients
		shuffle(store)
		del args[0]

		try:
			x = args[0]
		except:
			args = ["nothing"]

		prize = " ".join(args)
		for user in store:
			if user.online == True and not user.info["id"] in server.config['staff'] and not user.info["id"] in server.config['helpers']:
				return client.sendAll('<m t="' + user.info['username'] + '(' + str(user.info['id']) + ') wins ' + prize + '." u="0" />', True)