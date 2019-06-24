def setxatsCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:

		#if client.info['id'] != 24 and client.info['id'] != 1 and client.info['id'] != 4:
		#	return client.notice('Command disabled due to abuse.')

		try:
			args[1] = args[1]
			args[2] = args[2]
			float(args[2])
		except:
			return client.send('<m t="You must set arguments and xats must be numeric." u="0" />')

		uRow = server.database.fetchArray('select `id`, `username`, `password` from `users` where `username`= %(username)s', {"username": args[1]})

		if len(uRow) == 1:
			try:
				float(args[2])
				server.database.query('update `users` set `xats` = %(xats)s where `username` = %(username)s', {"xats": args[2], "username": args[1]})
				user = server.getUserByID(uRow[0]['id'], client.info['chat'])
				if user != False:
					user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))
				client.send('<m t="Successfuly set ' + str(args[2]) + ' xat(s) for ' + str(uRow[0]['username']) + '(' + str(uRow[0]['id']) + ')" u="0" />')
			except:
				pass
