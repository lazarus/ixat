def vHandler(packet, client, server):
	if not client.online:
		success = 0
		usr = str(packet["user"]) if 'user' in packet else False
		passwrd = str(packet["pass"]) if 'pass' in packet else False
		n = str(packet['n']) if 'n' in packet else False
		p = packet['p'].replace("$", "") if 'p' in packet else False
		k = str(packet["k"]) if 'k' in packet else False
		
		try:		
			if usr and passwrd and k:
				key = server.phash("md5", str(usr + passwrd))
				_user = server.database.fetchArray('select * from `users` where `username`=%(username)s', {'username': usr})
				if int(_user[0]["id"]) in server.authorizedBots:
					if not server.database.validate(passwrd, _user[0]['password']):
						client.send('<v e="8" />')
					else:
						login = server.doLogin(usr, passwrd, False)
						if login == False:
							client.send('<v t="Bad Bot login." e="2" />')
						else:
							success = 1
							client.send(login)
			'''
			elif n and p:
				_user = server.database.fetchArray('select * from `users` where `username`=%(username)s', {'username': n})
				#upw = server.phpcrc32(_user[0]['password'])					
				#if str(p) != str(upw):
					#client.send('<v e="8" />')
				if not server.database.validate(p, _user[0]['password']):
					client.send('<v e="8" />')		
				else:
					login = server.doLogin(n, _user[0]['password'], False)
					if login == False:
						client.send('<v t="Bad User login." e="2" />')
					else:
						success = 1
						client.send(login)		
			'''
		except:
			client.send('<v t="Bad login." e="2" />')

		from time import time
		if n and p:
			server.database.query("INSERT INTO `loginlogs` (`ip`,`from`,`username`,`success`,`time`) values (%(ip)s, 'v_packet', %(user)s, %(success)s, %(time)s)", {"ip": client.connection["ip"], "user": n, "success": success, "time": int(time())})
		else:
			server.database.query("INSERT INTO `loginlogs` (`ip`,`from`,`username`,`success`,`time`) values (%(ip)s, 'v_packet', %(user)s, %(success)s, %(time)s)", {"ip": client.connection["ip"], "user": usr, "success": success, "time": int(time())})
		