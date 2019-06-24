def pawnCommand(args, client):
	if server.hasServerMinRank(client.info["id"]):
		try:
			if server.hasServerMinRank(client.info["id"]):
				if str(args[1]).lower() == "remove" or str(args[1]).lower() == "delete":
					code = args[2]
					spawns = json.loads(server.config["special_pawns"])
					pawns = {}
					pawns['time'] = 1576454400
					for key, value in spawns.items():
						if str(key) != 'time' and str(key) != '!' and str(key) != str(code):
							pawns[str(key)] = value

					pawns['!'] = [999, '']

					client.send_xml('m', {'t': "Removed pawn code '" + str(code) + "'.", 'u': '0'})
					database.query("UPDATE `server` SET `special_pawns`= %(pwns)s", {"pwns": json.dumps(pawns)})
				else:
					id = args[1]
					code = args[2]
					name = args[3]

					spawns = json.loads(server.config["special_pawns"])
					pawns = {}
					pawns['time'] = 1576454400
					for key, value in spawns.items():
						if str(key) != 'time' and str(key) != '!':
							pawns[str(key)] = value

					pawns[str(code)] = [int(id), str(name)]
					pawns['!'] = [999, '']

					client.send_xml('m', {'t': str(name[0].upper() + name[1:].lower()) + " pawn as '" + str(
						code) + "' added requiring powerid '" + str(id) + "'.", 'u': '0'})

					database.query("UPDATE `server` SET `special_pawns`= %(pwns)s", {"pwns": json.dumps(pawns)})
		except:
			client.send_xml('m', {'t': 'There was a problem editing that pawn.', 'u': '0'})