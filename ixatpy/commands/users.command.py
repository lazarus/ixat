def usersCommand(args, client, server):
	if client.info["id"] in server.config["staff"] or client.info["id"] in server.config["helpers"]:
		count = 0

		for user in server.clients:
			if user.online:
				count += 1

		client.send('<m t="' + str(count) + ' connections online." u="0" />')