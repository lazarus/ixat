def globalCommand(args, client, server):
	from xml.sax.saxutils import quoteattr

	if client.info["id"] in server.config["staff"]:
		del args[0]
		message = " ".join(args)
		for user in server.clients:
			if user.online:
				user.notice(message, True)
