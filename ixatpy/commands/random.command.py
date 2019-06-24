def randomCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		from os import system
		system("python " + server.scriptLocation + "/root/Dropbox/ixatpy/release.py")