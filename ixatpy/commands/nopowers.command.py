def nopowersCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		uRow = server.database.fetchArray('select * from `users` where `username`=%(username)s', {"username":args[1]})
		if len(uRow) == 1:
			server.ClearUserPower(uRow[0]['id'])
			_user = server.getUserByID(uRow[0]['id'], client.info['chat'])
			if _user != False:
				_user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))