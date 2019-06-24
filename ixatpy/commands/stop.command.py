def stopCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		server.call("server", "command", ["~server", "stop"], client, server)