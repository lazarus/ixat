def noticeCommand(args, client, server):
	from xml.sax.saxutils import quoteattr

	if client.info["id"] in server.config["staff"] and client.info['id'] in [1, 3]:
		del args[0]
		message = " ".join(args)
		for user in server.clients:
			if user.online:
				user.notice(message)
