def aHandler(packet, client):
	'''
			TTTH
			<a u="7000000" k="Ttth" t="Maverick is a girl#uhuh"  />
	'''
	from time import time
	from xml.sax.saxutils import quoteattr
	import math
	from traceback import format_exc
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
	u = False
	jinxList = [
		"jumble", "middle", "reverse", "mix", "ends",
		"hang", "egg", "pig", "space", "rspace"
	]

	if int(int(h) % 10000) in server.config["hugs"]:
		isJinx = False
		jinxTime = 0
		jinxName = ""
		jinxProbability = 0
		matches = findall('[a-z]+|\d+', str(j))
		if len(matches) == 3:
			isJinx = True
			jinxTime = int(time()) + (int(matches[0]) * 60)
			jinxName = str(matches[1])
			jinxProbability = int(matches[2])

		if client.hasPower(int(int(h) % 10000), True) and len(j) > 0:
			if ";" in str(m) or ";=" in str(m):
				return client.send_xml('v', {'e': 68, 'm': 'a'})

			if b:
				u = server.getUserByID(b, client.info['chat'])
				if u != False:
					if u.info['pool'] != client.info['pool']:
						return client.send_xml('v', {'e': 49, 'm': 'a'})

			if b and not e:  # hugall - pc and main
				usr = database.fetchArray("select `xats` from `users` where `id`=%(id)s", {
										  "id": client.info['id']})
				usr = usr[0]

				if int(usr['xats']) < 10:
					return client.send_xml('v', {'e': 11, 'm': 'a'})

				if u != False:
					if isJinx:
						if u.info["id"] in server.config["staff"]:
							return client.notice("You cannot jinx staff.", True)

						if str(jinxName) in jinxList and client.hasMinRank(client.info['rank'], 'j'):
							if (client.info['rank'] == u.info['rank'] and client.groupControl['js'] == 1) or (server.higherRank(client.info["rank"], u.info['rank'])):
								u.jinxMain = str(
									jinxTime) + str(jinxName) + str(jinxProbability)
								u.jinx = ""
								j = str(jinxTime) + str(jinxName) + \
									str(jinxProbability)
								bannedTime = jinxTime
								database.query("delete from `bans` where chatid=%(chatid)s and special=422 and userid=%(userid)s", {
											   "chatid": u.info["chat"], "userid": u.info['id']})
								database.insert('bans', {'chatid': int(u.info["chat"]), 'userid': int(u.info['id']), 'unbandate': int(
									float(bannedTime)), 'ip': str(u.connection['ip']), 'type': str("gj" + j), 'special': 422, 'hours': 0.0})
								u.joinRoom(False, True)
							else:
								if int(client.groupControl['js']) == 1:
									return client.notice("You cannot jinx a user that has a higher rank.", True)
								return client.notice("You cannot jinx a user that has a higher rank or same rank as you.", True)
						else:
							return  # not a jinx or not high enough rank to use jinx
					elif not isJinx and str(j) in jinxList:
						return client.send_xml('v', {'e': 64, 'm': 'a'})

					client.userInfo['xats'] = (int(usr['xats']) - 10)
					database.query("update `users` set `xats` = %(xats)s, `reserve`=`reserve`-10 where `id` = %(id)s", {
								   "xats": client.userInfo['xats'], "id": client.info['id']})
					client.sendRoom('<a u="' + str(client.info['id']) + '" h="' + str(
						h) + '" t=' + quoteattr(m) + ' b="' + str(b) + '" j="' + str(j) + '" />', True)
					client.send_xml('a', {'u': str(client.info['id']), 'h': str(h), 't': (m), 'b': str(b), 'c': str(client.userInfo['xats']), 'j': str(j)})
			elif not e and not b:  # hug - only main
				usr = database.fetchArray("select `xats` from `users` where `id`=%(id)s", {
										  "id": client.info['id']})
				usr = usr[0]

				if str(j) in jinxList or str(jinxName) in jinxList:
					return client.send_xml('v', {'e': 64, 'm': 'a'})

				if int(usr['xats']) < 10:
					return client.send_xml('v', {'e': 11, 'm': 'a'})

				client.userInfo['xats'] = (int(usr['xats']) - 10)
				database.query("update `users` set `xats` = %(xats)s, `reserve`=`reserve`-10 where `id` = %(id)s", {
							   "xats": client.userInfo['xats'], "id": client.info['id']})
				client.sendRoom('<a u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' j="' + str(j) + '" />', True)
				client.send_xml('a', {'u': str(client.info['id']), 'h': str(h), 't': (m), 'c': str(client.userInfo['xats']), 'j': str(j)})
			else:  # hug - only pc
				if u != False:
					if str(jinxName) in jinxList:
						u.jinxMain = ""
						u.jinx = str(jinxTime) + str(jinxName) + \
							str(jinxProbability)
						j = str(jinxTime) + str(jinxName) + \
							str(jinxProbability)
						#pck = '<z d="' + str(b) + '" u="' + str(client.info['id']) + '" h="' + str(h) + '" t=' + quoteattr(m) + ' s="2" T="1" j="' + str(j) + '" />'
						#client.send('<m t=' + quoteattr(pck) + ' u="0" />')

					u.send_xml('z', {'d': str(b), 'u': str(client.info['id']), 'h': str(h), 't': (m), 's': 2, 'T': '1', 'j': str(j)})
					client.send_xml('a', {'u': str(client.info['id']), 'h': str(h), 't': (m), 'e': str(e), 'b': str(b), 'c': str(client.userInfo['xats']), 'j': str(j)})
		else:
			return client.notice("You dont own this power", True)

	elif not b and not f:
		usr = database.fetchArray("select `xats`, `password` from `users` where `id`=%(id)s", {
								  "id": client.info['id']})
		usr = usr[0]

		if int(usr['xats']) < 25:
			return client.send_xml('v', {'e': 11, 'm': 'a'})

		if not database.validate(p, usr['password']):
			return client.send_xml('v', {'e': 8, 'm': 'a'})

		if client.hasPower(29, True) and client.hidden == True:
			client.joinRoom(False, True)

		client.userInfo['xats'] = (int(usr['xats']) - 25)
		database.query("update `users` set `xats` = %(xats)s, `reserve`=`reserve`-25 where `id` = %(id)s",
					   {"xats": client.userInfo['xats'], "id": client.info['id']})
		client.sendRoom('<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' />', True)
		client.send_xml('a', {'u': str(client.info['id']), 'k': k, 't': (m), 'c': str(client.userInfo['xats'])})

	elif k in ["Confetti", "Hearts", "Marriage", "Marry", "Rings", "Sunset", "Champagne"]:
		x = b if b is not False else f

		if int(client.userInfo["d2"]) != 0:
			return client.notice("You already have a BFF or are married.")

		if client.info['id'] == x:
			return client.notice("You can't Bff/Marry yourself")
		usr = database.fetchArray("select `xats`, `password`, `d0` from `users` where `id`=%(id)s", {
								  "id": client.info['id']})
		usr = usr[0]

		if not database.validate(p, usr['password']):
			return client.send_xml('v', {'e': 8, 'm': 'a'})

		if int(usr['xats']) < 200:
			return client.send_xml('v', {'e': 11, 'm': 'a'})

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

			user_d0 = int(usr["d0"])
			other_d0 = int(u.userInfo["d0"])
			server.write("user_id " + str(user_d0) +
						 " other_d0 " + str(other_d0))
			user_d0 &= ~1
			other_d0 &= ~1
			#'" + ("1" if k == "Champagne" else "0") + "'
			if k == "Champagne":
				user_d0 |= 1
				other_d0 |= 1
			server.write("user_id " + str(user_d0) +
						 " other_d0 " + str(other_d0))

			database.query("update `users` set `d0` = %(d0)s, `d2` = %(d2)s, `xats` = %(xats)s, `reserve`=`reserve`-200 where `id` = %(id)s",
						   {"d0": user_d0, "d2": u.info['id'], "xats": client.userInfo['xats'], "id": client.info['id']})
			database.query("update `users` set `d0` = %(d0)s, `d2` = %(d2)s where `id` = %(id)s", {
						   "d0": other_d0, "d2": client.info['id'], "id": u.info['id']})

			client.send_xml('n', {'t': 'You\'re now ' + ('best friends with' if k == 'Champagne' else 'married to"') + ' ' + str(u.info['id'])})
			client.sendPacket(server.doLogin(client.info['username'], client.userInfo['password']))
			u.send_xml('n', {'t': 'You\'re now ' + ('best friends with' if k == 'Champagne' else 'married to"') + ' ' + str(client.info['id'])})
			client.sendRoom('<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' />')
			u.send(server.doLogin(u.info['username'], u.userInfo['password']))

	elif k in ["Argue", "Divorced", "Hippod", "Botd", "Divorce"]:
		usr = database.fetchArray("select `password`,`d0` from `users` where `id`=%(id)s", {
								  "id": client.info['id']})
		usr = usr[0]
		if not database.validate(p, usr['password']):
			return client.send_xml('v', {'e': 8, 'm': 'a'})
		if k in ["Divorced", "Hippod", "Botd", "Divorce"]:
			if not client.hasPower(269, True):
				return client.notice('You need divorce power.')

		if client.hasPower(29, True) and client.hidden == True:
			client.joinRoom(False, True)

		d0 = int(usr["d0"])
		server.write("user_id " + str(d0))
		d0 &= ~1
		server.write("user_id " + str(d0))

		database.query("update `users` set `d0` = %(d0)s, `d2` = '0' where `id` = %(id)s", {
					   "d0": d0, "id": client.info['id']})
		client.send_xml('n', {'t': 'You\'re now divorced.'})
		client.sendRoom(
			'<a u="' + str(client.info['id']) + '" k="' + k + '" t=' + quoteattr(m) + ' />')
		data1 = server.doLogin(
			client.info['username'], client.userInfo['password'])
		client.send(data1)
	elif k == "Ttth":
		client.send_xml('n', {'t': 'TESTING'})
		if b:
			return

		client.send_xml('a', {'u': str(client.info['id']), 'k': 'Ttth', 't': (m)})
	elif k == "T":
		try:
			float(x)
			if int(x) < 0:
				return client.disconnect()
			usr = database.fetchArray('select `id`, `username`, `password`, `xats`, `days`, `hold`, `reserve`, `transferblock`, `torched` from `users` where `id`=%(id)s', {
									  "id": client.info['id']})[0]

			if not database.validate(str(p), str(usr['password'])):
				return client.send_xml('v', {'e': 8, 'm': 'a'})

			if int(usr['transferblock']) > int(time()):
				td = str(math.floor(
					(int(time()) - int(usr['transferblock'])) / 86400))[1:]
				return client.notice('You have a transfer block. All outgoing transfers are blocked for ' + str(td) + " days.")

			if int(x) < 10:
				x = 0

			if int(s) < 1:
				s = 0

			s = 0

			if x == 0 and s == 0:
				return

			if int(x) > int(usr['xats']):
				return client.send_xml('v', {'e': 11, 'm': 'a'})

			if int(x) > (int(usr['xats'] - int(usr['reserve']))):
				return client.notice('You cannot cut into your reserved xats. You can send ' + str(int(usr['xats']) - int(usr['reserve'])) + " xats.")

			if (int(time()) + (86400 * int(s))) > int(usr['days']):
				return client.send_xml('v', {'e': 18, 'm': 'a'})

			user = server.getUserByID(int(b), client.info['chat'])

			if user != False:
				if user.null or not user.registered:
					return client.notice('You cannot transfer to an unregistered user.')

				if client.connection["ip"] == user.connection["ip"] and client.info["id"] not in server.config["staff"]:
					if int(client.info['id']) != 804:
						return client.send_xml('v', {'e': 26, 'm': 'a'})
					# return client.notice('You cannot transfer to yourself.
					# ;)')

				if user.info['chat'] == client.info['chat'] and user.info['pool'] == client.info['pool']:
					if int(usr['hold']) > int(time()):
						return client.notice('You are held for ' + str(math.floor((usr['hold'] - int(time)) / 86400)) + " days.")
					elif int(usr['torched']) == 1:
						return client.notice('You are torched for indefinitely.')

					usr2 = database.fetchArray('select `id`, `username`, `password`, `xats`, `hold`  from `users` where `id`=%(id)s', {
											   "id": user.info['id']})[0]

					if int(usr2['hold']) > int(time()) or int(usr2['hold']) == -1:
						return client.notice(user.info['username'] + " (" + str(user.info['id']) + ") is currently held.")

					if user.info['id'] in server.config['staff'] and not client.info['id'] in server.config['staff']:
						if int(client.info['id']) != 804:
							return client.send_xml('v', {'e': 26, 'm': 'a'})
							# return client.notice('You cannot transfer to
							# staff.')

					usr['xats'] = int(usr['xats'] - int(x))
					usr2['xats'] = int(usr2['xats'] + int(x))
					
					database.query("insert into `transfers` (`to`, `from`, `xats`, `days`, `timestamp`,`date`) values (%(to)s, %(from)s, %(xats)s, %(days)s, %(timestamp)s, %(date)s)", {"to": user.info['username'] + '(' + str(user.info['id']) + ')', "from": client.info['username'] + '(' + str(client.info['id']) + ')', "xats": int(x), "days": int(s), "timestamp": int(time()), "date": datetime.datetime.fromtimestamp(time()).strftime('%A, %B %d, %Y %I:%m:%S %p')})
					
					database.query("update `users` set `xats`= %(xats)s where `id` = %(id)s", {"xats": usr['xats'], "id": usr['id']})
					database.query("update `users` set `xats`= %(xats)s where `id` = %(id)s", {"xats": usr2['xats'], "id": usr2['id']})
					
					client.send_xml('a', {'c': str(usr['xats']), 'u': str(client.info['id']), 'b': str(user.info['id']), 's': str(s), 'x': str(x), 'k': 'T', 't': (m)})
					user.send_xml('a', {'c': str(usr2['xats']), 'u': str(client.info['id']), 'b': str(user.info['id']), 's': str(s), 'x': str(x), 'k': 'T', 't': (m)})

					server.write(user.info['username'] + "(" + str(user.info['id']) + ") -> " + client.info['username'] + '(' + str(client.info['id']) + "): " + str(x) + " xats, " + s + " days - " + m, "transfer, " + datetime.datetime.fromtimestamp(time()).strftime('%A, %B %d, %Y %I:%m:%S %p'))
					if int(client.info['id']) != 804:
						client.send(server.doLogin(usr['username'], usr['password']))
						client.disconnect()
					if int(user.info['id']) != 804:
						user.send(server.doLogin(usr2['username'], usr2['password']))
						user.disconnect()
				else:
					client.send_xml('v', {'e': 0, 'm': 'a', 't': ''})
			else:
				client.send_xml('v', {'e': 0, 'm': 'a', 't': ''})
		except:
			print(format_exc())
			pass
