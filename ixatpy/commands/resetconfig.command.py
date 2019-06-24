def resetconfigCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		server.call("config", "command", ["~config", "reload"], client, server)