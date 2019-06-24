def setCommand(args, client):
	from math import pow
	if server.hasServerMinRank(client.info["id"]):
		try:
			com = args[1].lower()
		except:
			return

		del args[1]
		args = (" ".join(args)).split(" ")

		if com == "xats":
			try:
				args[1] = args[1]
				args[2] = args[2]
				float(args[2])
			except:
				return client.send_xml('m', {'t': 'You must set arguments and xats must be numeric.', 'u': '0'})

			uRow = database.fetchArray(
				'select `id`, `username`, `password` from `users` where `username`= %(username)s', {"username": args[1]})

			if len(uRow) == 1:
				try:
					float(args[2])
					database.query('update `users` set `xats` = %(xats)s where `username` = %(username)s', {
								   "xats": args[2], "username": args[1]})
					user = server.getUserByID(uRow[0]['id'], client.info['chat'])
					if user != False:
						user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))
					client.send_xml('m', {'t': 'Successfuly set ' + str(args[2]) + ' xat(s) for ' + str(
						uRow[0]['username']) + '(' + str(uRow[0]['id']) + ')', 'u': '0'})
				except:
					pass

		if com == "id":
			if client.info['id'] in config.X_DEVS:
				try:
					args[1] = args[1]
					args[2] = args[2]
				except:
					return client.send_xml('m', {'t': 'You must set arguments.', 'u': '0'})
				_user = database.fetchArray(
					'select id, username, password, d2 from `users` where `username`= %(username)s', {"username": args[1]})
				_test = database.fetchArray(
					'select username from `users` where `id`= %(id)s', {"id": args[2]})
				try:
					x = _test[0]
					return client.send_xml('m', {'t': 'Dude that ID is taken by ' + _test[0]['username'], 'u': '0'}, None, 1)
				except:
					pass
				try:
					x = _user[0]
				except:
					return client.send_xml('m', {'t': 'That username doesn\'t exist', 'u': '0'})
				query = database.fetchArray("SHOW TABLE STATUS WHERE name='users';")
				auto_increment = query[0]['Auto_increment']
				if int(auto_increment) < int(args[2]):
					client.send_xml('m', {'t' : 'You cannot set an ID larger than ' + str(auto_increment) + '.', 'u': '0'})
					return
				database.query('update `users` set `id`=%(id)s where `id`=%(id2)s', {
							   "id": args[2], "id2": _user[0]['id']})
				database.query('update `ranks` set `userid`=%(id)s where `userid`=%(id2)s', {
							   "id": args[2], "id2": _user[0]['id']})
				database.query('update `users` set `d2`=%(id)s where `d2`=%(id2)s', {
							   "id": args[2], "id2": _user[0]["id"]})
				online = server.getUserByID(_user[0]['id'], client.info['chat'])
				if online != False:
					online.send(server.doLogin(_user[0]['username'], _user[0]['password']))

		if com == "name":
			if client.info['id'] in config.X_DEVS:
				try:
					args[1] = args[1]
					args[2] = args[2]
				except:
					return client.send_xml('m', {'t': 'You must set arguments.', 'u': '0'})
				_user = database.fetchArray(
					'select id, username, password from `users` where `username`= %(username)s', {"username": args[1]})
				_test = database.fetchArray(
					'select username from `users` where `username`= %(id)s', {"id": args[2]})
				try:
					x = _test[0]
					return client.send_xml('m', {'t': 'Dude that name is taken by ' + _test[0]['username'], 'u': '0'}, None, 1)
				except:
					pass
				try:
					x = _user[0]
				except:
					return client.send_xml('m', {'t': 'That username doesn\'t exist', 'u': '0'})

				database.query('update `users` set `username`=%(id)s where `id`=%(id2)s', {
							   "id": args[2], "id2": _user[0]['id']})
				
				online = server.getUserByID(_user[0]['id'], client.info['chat'])
				if online != False:
					online.send(server.doLogin(_user[0]['username'], _user[0]['password']))

		if com == "nopowers":
			try:
				args[1] = args[1]
			except:
				args.append(client.info['username'])
			uRow = database.fetchArray(
				'select id, username, password from `users` where `username`=%(username)s', {"username": args[1]})
			if len(uRow) == 1:
				server.ClearUserPower(uRow[0]['id'])
				_user = server.getUserByID(uRow[0]['id'], client.info['chat'])
				if _user != False:
					_user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))

		if com == "everypower":
			if client.info['id'] in config.X_DEVS:
				uRow = database.fetchArray(
					'select id, username, password from `users` where `username`=%(username)s', {"username": args[1]})
				if len(uRow) == 1:
					powers = database.fetchArray(
						'select `id`, `name` from `powers` where `p`=1 AND `name` not like \'%(Undefined)%\';')
					ep = {}
					try:
						count = int(args[2])
					except:
						count = 1
					for power in powers:
						if int(power['id']) < 0:
							power['id'] = str(abs(int(power['id'])) + config.X_CUSTOM_OFFSET)
						if int(pow(2, int(power['id']) % 32)) < 2147483647:
							try:
								float(power['name'])
							except:
								ep[str(power['id'])] = count
					uid = str(uRow[0]['id'])
					powers, dO = server.EncodePowers(ep)
					database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {
								   "uid": uid, "powers": powers, "dO": dO})
					_user = server.getUserByID(uRow[0]['id'], client.info['chat'])
					if _user != False:
						_user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))

		if com == "torch":
			try:
				args[1]
				try:
					account = database.fetchArray(
						'select id, username, password from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid": args[1]})[0]
				except:
					return client.notice("No accounts under that ID/Username exist.", True)
				database.query('update `users` set `torched`=1 where `id`=%(id)s', {"id": account['id']})
				for user in server.clients:
					if user.info['id'] == account['id']:
						user.send(server.doLogin(account['username'], account['password']))
				client.notice(account['username'] + " [" + str(account['id']) + "] has been torched.")
			except:
				return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)

		if com == "torch2":
			try:
				args[1]
				try:
					account = database.fetchArray(
						'select id, username from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid": args[1]})[0]
				except:
					return client.notice("No accounts under that ID/Username exist.", True)
				database.query('update `users` set `torched`=2 where `id`=%(id)s', {"id": account['id']})
				client.notice(account['username'] + " [" + str(account['id']) + "] has been xatspace torched.")
			except:
				return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)

		if com == "untorch":
			try:
				args[1]
				try:
					account = database.fetchArray(
						'select id, username, password from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid": args[1]})[0]
				except:
					return client.notice("No accounts under that ID/Username exist.", True)
				database.query('update `users` set `torched`=0 where `id`=%(id)s', {"id": account['id']})
				for user in server.clients:
					if user.info['id'] == account['id']:
						user.send(server.doLogin(account['username'], account['password']))
				client.notice(account['username'] + " [" + str(account['id']) + "] has been untorched.")
			except:
				return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)

		if com == "activate":
			try:
				args[1]
				try:
					account = database.fetchArray(
						'select id, username from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid": args[1]})[0]
				except:
					return client.notice("No accounts under that ID/Username exist.", True)
				database.query('update `users` set `activated`=1 where `id`=%(id)s', {"id": account['id']})
				client.notice(account['username'] + " [" + str(account['id']) + "] has been activated.")
			except:
				return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)
				
		if com == "custpawn":
			try:
				args[1]
				try:
					account = database.fetchArray(
						'select id, username from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid": args[1]})[0]
				except:
					return client.notice("No accounts under that ID/Username exist.", True)
				database.query('update `users` set `custpawn`=off where `id`=%(id)s', {"id": account['id']})
				client.notice(account['username'] + " [" + str(account['id']) + "] now has custom pawn enabled.")
			except:
				return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)

		if com == "celebrity":
			try:
				args[1] = args[1]
			except:
				args.append(client.info['username'])

			d0 = 0
			try:
				_user = database.fetchArray(
					'select id, username, password, d0 from `users` where `username`= %(username)s', {"username": args[1]})
				online = server.getUserByID(_user[0]['id'], client.info['chat'])
				d0 = int(_user[0]['d0'])
				# or int(_user[0]['d0']) & 1 << 24:
				if int(_user[0]['d0']) & 1 << 21:
					d0 &= ~1 << 21  # celeb
					if(int(_user[0]['d0']) & 1 << 24):  # Protect gifts flag
						d0 |= 1 << 24
					client.send_xml('m', {'t': args[1] + ' is no longer a Celebrity', 'u': '0'})
				else:
					d0 |= 1 << 21
					if(int(_user[0]['d0']) & 1 << 24):  # Protect gifts flag
						d0 |= 1 << 24
					client.send_xml('m', {'t': args[1] + ' is now a Celebrity', 'u': '0'})

				database.query('update `users` set `d0`=%(d0)s where `username`= %(username)s', {
							   "d0": str(d0), "username": args[1]})

				if (online != False):
					online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
			except:
				pass

		if com == "reserve":
			try:
				args[1] = args[1]
				args[2] = args[2]
				float(args[2])
			except:
				return client.send_xml('m', {'t': 'You must set arguments and reserve must be numeric.', 'u': '0'})

			uRow = database.fetchArray(
				'select `id`, `username`, `password` from `users` where `username`= %(username)s', {"username": args[1]})

			if len(uRow) == 1:
				try:
					float(args[2])
					database.query('update `users` set `reserve` = %(xats)s where `username` = %(username)s', {
								   "xats": args[2], "username": args[1]})
					client.send_xml('m', {'t': 'Successfuly set ' + str(args[2]) + ' reserve(s) for ' + str(
						uRow[0]['username']) + '(' + str(uRow[0]['id']) + ')', 'u': '0'})
				except:
					pass
