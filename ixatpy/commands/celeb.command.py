def celebCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			args[1] = args[1]
		except:
			args.append(client.info['username'])

		d0 = 0
		try:
			_user = server.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": args[1]})
			online = server.getUserByID(_user[0]['id'], client.info['chat'])
			d0 = int(_user[0]['d0'])
			if int(_user[0]['d0']) & 1 << 21: #or int(_user[0]['d0']) & 1 << 24:
				d0 &= ~1 << 21#celeb
				if(int(_user[0]['d0']) & 1 << 24):#Protect gifts flag
					d0 |= 1 << 24
				client.send('<m u="0" t="' + args[1] + ' is no longer a Celebrity" />');
			else:
				d0 |= 1 << 21
				if(int(_user[0]['d0']) & 1 << 24):#Protect gifts flag
					d0 |= 1 << 24
				client.send('<m u="0" t="' + args[1] + ' is now a Celebrity" />');
				
			server.database.query('update `users` set `d0`=%(d0)s where `username`= %(username)s', {"d0":str(d0), "username": args[1]})	
				
			if (online != False):
				online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
		except:
			pass
