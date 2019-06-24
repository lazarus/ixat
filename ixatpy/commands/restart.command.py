def restartCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		server.call("server", "command", ["~server", "restart"], client, server)