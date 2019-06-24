def divorceCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			uname = args[1]
		except:
			return client.send('<m u="0" t="Sorry" />')

		try:
			_user = server.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": uname})
			if int(_user[0]['d2']) == 0 or uname in server.config["staff"]:
				return client.send('<m u="0" t="Sorry" />')
			server.database.query("update `users` set `d0` = '0', `d2` = '0' where `id` = %(id)s", {"id": _user[0]['id']})
			online = server.getUserByID(_user[0]['id'], client.info['chat'])
			if (online != False):
				online.sendRoom('<a u="' + str(_user[0]['id']) + '" k="Divorced" t="Cuz your a nigga" />', True)
				online.send('<a u="' + str(_user[0]['id']) + '" k="Divorced" t="Cuz your a nigga" />')
				online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
		except:
			pass
