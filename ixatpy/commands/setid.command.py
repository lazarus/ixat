def setidCommand(args, client, server):
	if client.info["id"] in server.config["staff"] and client.info['id'] in [1, 3, 5]:
		try:
			args[1] = args[1]
			args[2] = args[2]
		except:
			return client.send('<m t="You must set arguments." u="0" />')
		_user = server.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": args[1]})
		_test = server.database.fetchArray('select * from `users` where `id`= %(id)s', {"id": args[2]})
		try:
			x = _test[0]
			return client.sendRoom('<m t="Dude that ID is taken by ' + _test[0]['username'] + '" u="0" />')
		except:
			pass
		try:
			x = _user[0]
		except:
			return client.sendRoom('<m t="That username doesn\'t exist" u="0" />')
		query  = server.database.fetchArray("SHOW TABLE STATUS WHERE name='users';")
		auto_increment = query[0]['Auto_increment']
		if int(auto_increment) < int(args[2]):
			client.send('<m t="You cannot set an ID larger than ' + str(auto_increment) + '." u="0" />')
			return
		server.database.query('update `users` set `id`=%(id)s where `id`=%(id2)s',{"id":args[2], "id2": _user[0]['id']})
		server.database.query('update `ranks` set `userid`=%(id)s where `userid`=%(id2)s',{"id":args[2], "id2": _user[0]['id']})
		online = server.getUserByID(_user[0]['id'], client.info['chat'])
		if online != False:
			online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
