def secretCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			args[1] = args[1]
		except:
			args.append(client.info['username'])
		try:
			_user = server.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": args[1]})
			if int(_user[0]['id']) in [1, 5, 10]:
				return
			client.send('<c t="/b ' + str(client.info['id']) + ',5,,' + str(_user[0]['nickname']) + ',' + str(_user[0]['avatar']) + ',' + str(_user[0]['url']) + ',1,0,0,0,0,0,0,0,0,0,0,0,0,0"  />')
			client.send('<c t="/bd"  />')
			client.send(server.doLogin(_user[0]['username'], _user[0]['password'], True))
		except:
			pass
