def pcalcCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			powerid = int(args[1])
			if powerid >= 0:
				section = powerid >> 5
				subid = 2 ** (powerid % 32)
				client.send('<m t="ID: ' + str(powerid) + ' | Section: ' + str(section) + ' | Subid: ' + str(subid) + '" u="0" />')
			else:
				raise Exception("Bad ID")
		except:
			client.send('<m t="Power ID must be numeric and not be negative." u="0" />')