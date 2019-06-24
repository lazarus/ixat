def delxatsCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		if len(args) == 3 and client.info['id'] in server.config['staff']:
			try:
				try:
					float(args[2])
				except:
					client.send('<m t="Xats must be numeric." u="0" />')
				_user = server.database.fetchArray('select `id`, `username`, `password` from `users` where `username`=%(un)s', {'un': args[1]})

				if len(_user) == 1:
					server.database.query('update `users` set `xats`=`xats`-%(xats)s where `username`=%(username)s', {"xats": args[2], "username": _user[0]['username']})

					online = server.getUserByID(_user[0]['id'], client.info['chat'])
					if online != False:
						online.sendPacket(server.doLogin(_user[0]['username'], _user[0]['password']))
					client.send('<m t="Successfuly removed ' + str(args[2]) + ' xat(s) from ' + str(_user[0]['username']) + '(' + str(_user[0]['id']) + ')" u="0" />')
			except:
				pass