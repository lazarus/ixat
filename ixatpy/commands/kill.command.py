def killCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			kill = server.getUserByID(args[1], client.info["chat"])
			kill.send('<logout />')
			kill.disconnect()
			client.send('<m t="ID killed." u="0" />')
		except:
			client.send('<m t="There was an error trying to kill that ID." u="0" />')