def delCommand(args, client):
	if server.hasServerMinRank(client.info["id"]):
		try:
			com = args[1].lower()
		except:
			return

		del args[1]

		args = (" ".join(args)).split(" ")

		if com == "xats":
			if len(args) == 3:
				try:
					try:
						float(args[2])
					except:
						client.send_xml('m', {'t': 'Xats must be numeric.', 'u': '0'})
					_user = database.fetchArray('select `id`, `username`, `password` from `users` where `username`=%(un)s', {'un': args[1]})

					if len(_user) == 1:
						database.query('update `users` set `xats`=`xats`-%(xats)s where `username`=%(username)s', {"xats": args[2], "username": _user[0]['username']})

						online = server.getUserByID(_user[0]['id'], client.info['chat'])
						if online != False:
							online.sendPacket(server.doLogin(_user[0]['username'], _user[0]['password']))
						client.send_xml('m', {'t': 'Successfuly removed ' + str(args[2]) + ' xat(s) from ' + str(_user[0]['username']) + '(' + str(_user[0]['id']) + ')', 'u': '0'})
				except:
					pass

		if com == "power":
			if len(args) == 3:
				_user = database.fetchArray('select `username`, `id`, `password` from `users` where `username`=%(un)s', {'un': args[1]})
				power = database.fetchArray('select `id` from `powers` where `name`=%(pn)s', {'pn': args[2]})

				if len(_user) == 1 and len(power) == 1:
					if int(power[0]['id']) < 0:
						power[0]['id'] = str(abs(int(power[0]['id'])) + config.X_CUSTOM_OFFSET)
					server.DelUserPower(_user[0]['id'], power[0]['id'])
					online = server.getUserByID(_user[0]['id'], client.info['chat'])
					if online != False:
						online.sendPacket(server.doLogin(_user[0]['username'], _user[0]['password']))