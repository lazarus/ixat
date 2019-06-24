def relogCommand(args, client, server):
	if client.online and client.registered:
		try:
			args[1] = args[1]
		except:
			args.append(client.info['username'])

		try:
			if client.info["id"] in server.config["staff"]:
				args[1] = args[1]
			else:
				args[1] = client.info['username']
			_user = server.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": args[1]})
			online = server.getUserByID(_user[0]['id'], client.info['chat'])

			if (online != False):
				online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
		except:
			pass