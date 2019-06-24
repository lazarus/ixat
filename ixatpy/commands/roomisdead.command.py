def roomisdeadCommand(args, client, server):
	from traceback import print_exc

	if client.info["id"] in server.config["staff"]:
		for user in server.clients:
			if user.online == True and client.info['chat'] == user.info['chat']:
				user.disconnect()
