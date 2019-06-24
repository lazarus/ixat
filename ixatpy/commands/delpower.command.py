def delpowerCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		if len(args) == 3:
			_user = server.database.fetchArray('select `username`, `id`, `password` from `users` where `username`=%(un)s', {'un': args[1]})
			power = server.database.fetchArray('select `id` from `powers` where `name`=%(pn)s', {'pn': args[2]})

			if len(_user) == 1 and len(power) == 1:
				server.DelUserPower(_user[0]['id'], power[0]['id'])
				online = server.getUserByID(_user[0]['id'], client.info['chat'])
				if online != False:
					online.sendPacket(server.doLogin(_user[0]['username'], _user[0]['password']))