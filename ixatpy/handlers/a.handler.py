def aHandler(packet, client, server):
	from time import time
	from xml.sax.saxutils import quoteattr
	import math
	from traceback import print_exc
	import datetime
	from re import findall

	if client.null or not client.online or client.info['banned'] or not client.registered:
		return

	x = packet['x'] if 'x' in packet else False
	s = packet['s'] if 's' in packet else False
	b = packet['b'] if 'b' in packet else False
	m = packet['m'] if 'm' in packet else ""
	p = packet['p'] if 'p' in packet else False
	k = packet['k'] if 'k' in packet else False
	f = packet['f'] if 'f' in packet else False
	h = packet['h'] if 'h' in packet else False
	e = packet['e'] if 'e' in packet else False
	j = packet['j'] if 'j' in packet else ""
	jinxList = ["jumble", "middle", "reverse", "mix", "ends"]

	if int(int(h) % 10000) in server.config["hugs"]:
		jinxTime = 0
		jinxName = ""
		jinxProbability = 0
		matches = findall('[a-z]+|\d+', str(j))
		if len(matches) == 3:
			jinxTime = int(time()) + (int(matches[0]) * 60)
			jinxName = str(matches[1])
			jinxProbability = int(matches[2])
			
		if client.hasPower(int(int(h) % 10000), True) and len(j) > 0:
			if b and not e:#hugall - pc and main
				usr = server.database.fetchArray("select * from `users` where `id`=%(id)s", {"id": client.info['id']})
				usr = usr[0]

				if int(usr['xats']) < 10:
					return client.send('<v e="11" m="a" />')
					
				client.userInfo['xats'] = (int(usr['xats']) - 10)
				
				u = server.getUserByID(b, client.info['chat'])
				if u != False:
					if str(jinxName) in jinxList:
						u.jinxMain = str(jinxTime) + str(jinxName) + str(jinxProbability)
						u.jinx = ""
						j = str(jinxTime) + str(jinxName) + str(jinxProbability)

				server.database.query("update `users` set `xats` = %(xats)s, `reserve`=`reserve`-10 where `id` = %(id)s", {"xats": client.userInfo['xats'], "id": client.info['id']})
				client.sendRoom('<a u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' j="' + str(j) + '" />', True)
				client.send('<a u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' b="' + str(b) + '" c="' + str(client.userInfo['xats']) + '" j="' + str(j) + '" />')	
			elif not e and not b:#hug - only main
				usr = server.database.fetchArray("select * from `users` where `id`=%(id)s", {"id": client.info['id']})
				usr = usr[0]

				if str(j) in jinxList or str(jinxName) in jinxList:
					return client.send('<v e="64" m="a" />')
					
				if int(usr['xats']) < 10:
					return client.send('<v e="11" m="a" />')
					
				client.userInfo['xats'] = (int(usr['xats']) - 10)
				server.database.query("update `users` set `xats` = %(xats)s, `reserve`=`reserve`-10 where `id` = %(id)s", {"xats": client.userInfo['xats'], "id": client.info['id']})
				client.sendRoom('<a u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' j="' + str(j) + '" />', True)
				client.send('<a u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' c="' + str(client.userInfo['xats']) + '" j="' + str(j) + '" />')
			else:#hug - only pc	
				u = server.getUserByID(b, client.info['chat'])
				if u != False:
					if str(jinxName) in jinxList:
						u.jinxMain = ""
						u.jinx = str(jinxTime) + str(jinxName) + str(jinxProbability)
						j = str(jinxTime) + str(jinxName) + str(jinxProbability)
						
					u.send('<z d="' + str(b) + '" u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' s="2" T="1" j="' + str(j) + '" />')
					client.send('<a u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' e="' + str(e) + '" b="' + str(b) + '" c="' + str(client.userInfo['xats']) + '" j="' + str(j) + '" />')	
		else:
			return client.notice("You dont own this power", True)

	elif not b and not f:
		usr = server.database.fetchArray("select * from `users` where `id`=%(id)s", {"id": client.info['id']})
		usr = usr[0]

		if int(usr['xats']) < 25:
			return client.send('<v e="11" m="a" />')

		if not server.database.validate(p, usr['password']):
			return client.send('<v e="8" m="a" />')

		if client.hasPower(29, True) and client.hidden == True:
			client.joinRoom(False, True)

		client.userInfo['xats'] = (int(usr['xats']) - 25)
		server.database.query("update `users` set `xats` = %(xats)s, `reserve`=`reserve`-25 where `id` = %(id)s", {"xats": client.userInfo['xats'], "id": client.info['id']})
		client.sendRoom('<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' />', True)
		client.send('<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' c="' + str(client.userInfo['xats']) + '" />')

	elif k == "Confetti" or k == "Hearts" or k == "Champagne":
		x = b if b is not False else f

		if int(client.userInfo["d2"]) != 0:
			return client.notice("You already have a BFF or are married.")

		if client.info['id'] == x:
			return client.notice("You can't Bff/Marry yourself")
		usr = server.database.fetchArray("select * from `users` where `id`=%(id)s", {"id": client.info['id']})
		usr = usr[0]

		if not server.database.validate(p, usr['password']):
			return client.send('<v e="8" m="a" />')

		if int(usr['xats']) < 200:
			return client.send('<v e="11" m="a" />')

		u = server.getUserByID(x, client.info['chat'])

		if u != False:
			if not u.registered:
				return client.notice("You can't BFF/Marry an unregistered user.")
			if u.hasPower(99, True):
				return client.notice(u.info['username'] + ' (' + str(u.info['id']) + ') has single power.')
			if u.userInfo["d2"] != 0:
				return client.notice("User has a BFF or is already married.")

			if client.hasPower(29, True) and client.hidden == True:
				client.joinRoom(False, True)

			client.userInfo['xats'] = (int(usr['xats']) - 200)
			server.database.query("update `users` set `d0` = '" + ("1" if k == "Champagne" else "0") + "', `d2` = %(d2)s, `xats` = %(xats)s, `reserve`=`reserve`-200 where `id` = %(id)s", {"d2": u.info['id'], "xats": client.userInfo['xats'], "id": client.info['id']})
			server.database.query("update `users` set `d0` = '" + ("1" if k == "Champagne" else "0") + "', `d2` = %(d2)s where `id` = %(id)s", {"d2": client.info['id'], "id": u.info['id']})

			data1 = server.doLogin(client.info['username'], client.userInfo['password'])
			data2 = server.doLogin(u.info['username'], u.userInfo['password'])
			client.send('<n t="You\'re now ' + ('best friends with' if k == "Champagne" else "married to") + ' ' + str(u.info['id']) + '" />')
			client.sendPacket(data1)
			u.send('<n t="You\'re now ' + ('best friends with' if k == "Champagne" else "married to") + ' ' + str(client.info['id']) + '" />')
			u.send(data2)

	elif k == "Argue" or k == "Divorced" or k == "Hippod" or k == "Botd" or k == "Divorce":
		usr = server.database.fetchArray("select * from `users` where `id`=%(id)s", {"id": client.info['id']})
		usr = usr[0]
		if not server.database.validate(p, usr['password']):
			return client.send('<v e="8" m="a" />')
		if k != "Argue":
			if k == "Divorced" or k == "Hippod" or k == "Botd" or k == "Divorce":
				if not client.hasPower(269, True):
					return client.notice('You need divorce power.')

		if client.hasPower(29, True) and client.hidden == True:
			client.joinRoom(False, True)

		server.database.query("update `users` set `d0` = '0', `d2` = '0' where `id` = %(id)s", {"id": client.info['id']})
		client.send('<n t="You\'re now divorced." />')
		client.sendRoom('<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' />', True)
		client.send('<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' />')
		data1 = server.doLogin(client.info['username'], client.userInfo['password'])
		client.send(data1)
	elif k == "T":
		try:
			float(x)
			if int(x) < 0:
				return client.disconnect()
			usr = server.database.fetchArray('select * from `users` where `id`=%(id)s', {"id": client.info['id']})[0]

			if not server.database.validate(str(p), str(usr['password'])):
				return client.send('<v e="8" m="a" />')

			if int(usr['transferblock']) > int(time()):
				td = str(math.floor((int(time()) - int(usr['transferblock'])) / 86400))[1:]
				return client.notice('You have a transfer block. All outgoing transfers are blocked for ' + str(td) + " days.")

			if int(x) < 10:
				x = 0

			if int(s) < 1:
				s = 0

			s = 0

			if x == 0 and s == 0:
				return

			if int(x) > int(usr['xats']):
				return client.send('<v e="11" m="a" />')

			if int(x) > (int(usr['xats'] - int(usr['reserve']))):
				return client.notice('You cannot cut into your reserved xats. You can send ' + str(int(usr['xats']) - int(usr['reserve'])) + " xats.")

			if (int(time()) + (86400 * int(s))) > int(usr['days']):
				return client.send('<v e="18" m="a" />')

			user = server.getUserByID(int(b), client.info['chat'])

			if user != False:
				if user.null or not user.registered:
					return client.notice('You cannot transfer to an unregistered user.')

				if client.connection["ip"] == user.connection["ip"]:
					return client.notice('You cannot transfer to yourself. ;)')

				if user.info['chat'] == client.info['chat'] and user.info['pool'] == client.info['pool']:
					if int(usr['hold']) > int(time()):
						return client.notice('You are held for ' + str(math.floor((usr['hold'] - int(time)) / 86400)) + " days.")
					elif int(usr['torched']) == 1:
						return client.notice('You are torched for indefinitely.')

					usr2 = server.database.fetchArray('select * from `users` where `id`=%(id)s', {"id": user.info['id']})[0]

					if int(usr2['hold']) > int(time()) or int(usr2['hold']) == -1:
						return client.notice(user.info['username'] + " (" + str(user.info['id']) + ") is currently held.")

					if user.info['id'] in server.config['staff'] and not client.info['id'] in server.config['staff']:
						return client.notice('You cannot transfer to staff.')

					usr['xats'] = int(usr['xats'] - int(x))
					usr2['xats'] = int(usr2['xats'] + int(x))
					server.database.query("insert into `transfers` (`to`, `from`, `xats`, `days`, `timestamp`,`date`) values (%(to)s, %(from)s, %(xats)s, %(days)s, %(timestamp)s, %(date)s)", {"to": user.info['username'] + '(' +  str(user.info['id']) + ')', "from": client.info['username'] + '(' +  str(client.info['id']) + ')', "xats": int(x), "days": int(s), "timestamp": int(time()), "date": datetime.datetime.fromtimestamp(time()).strftime('%A, %B %d, %Y %I:%m:%S %p')})
					server.database.query("update `users` set `xats`= %(xats)s where `id` = %(id)s", {"xats": usr['xats'], "id": usr['id']})
					server.database.query("update `users` set `xats`= %(xats)s where `id` = %(id)s", {"xats": usr2['xats'], "id": usr2['id']})
					client.send('<a c="' + str(usr['xats']) + '" u="' + str(client.info['id']) + '" b="' + str(user.info['id']) + '" s="' + str(s) + '" x="' + str(x) + '" k="T" t=' + quoteattr(m) + ' />')
					user.send('<a c="' + str(usr2['xats']) + '" u="' + str(client.info['id']) + '" b="' + str(user.info['id']) + '" s="' + str(s) + '" x="' + str(x) + '" k="T" t=' + quoteattr(m) + ' />')
					client.send(server.doLogin(usr['username'], usr['password']))
					client.disconnect()
					user.send(server.doLogin(usr2['username'], usr2['password']))
					user.disconnect()
				else:
					client.send('<v e="0" m="a" t="" />')
			else:
				client.send('<v e="0" m="a" t="" />')
		except:
			print_exc()
			pass