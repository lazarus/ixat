def chatusersCommand(args, client, server):
	if client.info["id"] in server.config["staff"] or client.info["id"] in server.config["helpers"]:
		groups = {}
		output = ""
		ucount = 0
		unique = []
		for user in server.clients:
			if user.online:
				if not user.info['id'] in unique:
					unique.append(user.info['id'])
				if not user.info['group'] in groups.keys():
					groups[user.info['group']] = 1
				else:
					groups[user.info['group']] += 1
				ucount += 1
		for i, gn in enumerate(groups):
			output += str(gn) + '[' + str(groups[gn]) + '] | '
		client.send('<m t="Unique ' + str(len(unique)) + ' | Total ' + str(ucount) + ' | ' + output[0:-3] + '" u="0" />')