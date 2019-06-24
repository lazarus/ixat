def pHandler(packet, client, server):
	import time, cgi
	from traceback import print_exc
	from xml.sax.saxutils import quoteattr
	userIsOffline = False
	if client.null == True:
		client.signOut()
	elif client.online == True:
		try:
			_user = server.getUserByID(packet['u'], client.info['chat'])
			if not _user:
				userIsOffline = True

			if client.hidden:
				client.info['KeepPool'] = True
				client.joinRoom(False, True)

			if (packet['t'] == '/RTypeOn' or packet['t'] == '/RTypeOff') and client.hasPower(172, True):
				if not userIsOffline:
					return _user.send('<p u="' + str(client.info['id']) + '" t=' + quoteattr(packet['t']) + ' d="' + str(_user.info['id']) + '" />')
			elif packet['t'][0:1] == '/':
				if userIsOffline:
					return
				if client.info['temp'] != 0 and (client.info['temp'] - float(time.time())) < 0:
					return client.disconnect()
				if packet['t'][1:2] == 'n':
					if _user.info['rank'] == 2 and server.higherRank(client.info['rank'], _user.info['rank'], True):
						if not client.hasPower(33, True):
							return
						try:
							sinbintime = packet['t'][2:10]
							sinbintime2 = float(sinbintime) * 60 * 60
							if sinbintime2 > 86400.0 or sinbintime2 < 61.2:
								raise ValueError
							sinbinnedTime = float(time.time()) + sinbintime2
							server.database.query("update `ranks` set `sinbin` = %(time)s where `chatid` = %(chatid)s and `userid` = %(id)s", {"time": sinbinnedTime, "chatid": client.info["chat"], "id": _user.info["id"]})
							client.sendRoom('<m u="' + str(client.info["id"]) + '" d="' + str(_user.info['id']) + '" t="/n" p="n' + str(sinbintime2) + '" i="0" />')
							server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/n', 'reason': 'n' + str(sinbintime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info['pool'], 'port': str(server.connection['port'])})
							return _user.joinRoom(False, True)
						except:
							return client.notice("Please use the following format\n/n2.5 for 2.5 hours\nMax: 24\nMin: 0.017")
				if packet['t'][1:3] == 'mo':
					if not client.hasPower(79, True):
						return
					if client.info["rank"] != 1 or server.higherRank(client.info['rank'], _user.info['rank'], True) == False or client.info['rank'] == _user.info['rank']:#main only
						return
					try:
						temptime = packet['t'][3:10]
						temptime2 = float(temptime) * 60 * 60
						if int(temptime) > 24 or int(temptime) < 1:
							raise ValueError
					except:
						return client.notice("Please use the following format\n/mo2.5 for 2.5 hours\nMax: 24\nMin: 1")
					# {"userid": _user.info['id'], "chatid": client.info['chat']:}
					server.database.query('DELETE FROM `ranks` WHERE `userid`=%(userid)s AND `chatid`=%(chatid)s', {"userid": _user.info['id'], "chatid": client.info['chat']})
					server.database.insert('ranks', {'userid': _user.info['id'], 'chatid': client.info['chat'], 'f': 4, 'tempend': (float(time.time()) + float(temptime) * 60 * 60)})
					client.sendRoom('<m u="' + str(client.info["id"]) + '" d="' + str(_user.info['id']) + '" t="/m" p="o' + str(temptime2) + '" i="0" />')
					server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/m', 'reason': 'o' + str(temptime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': '0', 'port': str(server.connection['port'])})
					return _user.joinRoom(False, True)
				elif packet['t'][1:3] == 'me':
					if client.info['sinbinned']:
						return
					if userIsOffline:
						return
					if not client.hasPower(61, True):
						return
					if client.info["rank"] not in [1, 4, 2] or server.higherRank(client.info['rank'], _user.info['rank'], True) == False or client.info['rank'] == _user.info['rank']:#main only
						return
					try:
						temptime = packet['t'][3:10]
						temptime2 = float(temptime) * 60 * 60
						if int(temptime) > 24 or int(temptime) < 1:
							raise ValueError
					except:
						return client.notice("Please use the following format\n/me2.5 for 2.5 hours\nMax: 24\nMin: 1")
					server.database.query('DELETE FROM `ranks` WHERE `userid`=%(userid)s AND `chatid`=%(chatid)s', {"userid": _user.info['id'], "chatid": client.info['chat']})
					server.database.insert('ranks', {'userid': _user.info['id'], 'chatid': client.info['chat'], 'f': 3, 'tempend': (float(time.time()) + float(temptime) * 60 * 60)})
					client.sendRoom('<m u="' + str(client.info["id"]) + '" d="' + str(_user.info['id']) + '" t="/m" p="e' + str(temptime2) + '" i="0" />')
					server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/m', 'reason': 'e' + str(temptime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': '0', 'port': str(server.connection['port'])})
					return _user.joinRoom(False, True)
				elif packet['t'][1:2] == 'm':
					if userIsOffline:
						return
					if not client.hasPower(11, True):
						return
					if client.info["rank"] not in [1, 4] or server.higherRank(client.info['rank'], _user.info['rank'], True) == False or client.info['rank'] == _user.info['rank']:
						return
					try:
						temptime = packet['t'][2:10]
						temptime2 = float(temptime) * 60 * 60
						if int(temptime) > 24 or int(temptime) < 1:
							raise ValueError
					except:
						return client.notice("Please use the following format\n/m2.5 for 2.5 hours\nMax: 24\nMin: 1")
					server.database.query('DELETE FROM `ranks` WHERE `userid`=%(userid)s AND `chatid`=%(chatid)s', {"userid": _user.info['id'], "chatid": client.info['chat']})
					server.database.insert('ranks', {'userid': _user.info['id'], 'chatid': client.info['chat'], 'f': 2, 'tempend': (float(time.time()) + float(temptime) * 60 * 60)})
					client.sendRoom('<m u="' + str(client.info["id"]) + '" d="' + str(_user.info['id']) + '" t="/m" p="m' + str(temptime2) + '" i="0" />')
					server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/m', 'reason': 'm' + str(temptime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': '0', 'port': str(server.connection['port'])})
					return _user.joinRoom(False, True)
				elif packet['t'][1:3] == 'nb':
					if userIsOffline:
						return
					if not client.hasPower(264, True):
						return
						
					if client.info['rank'] not in client.minRankToArray(client.canBadge_minRank):
						return
					if server.higherRank(client.info['rank'], _user.info['rank'], True) == False or client.info['rank'] == _user.info['rank']:
						return
					#_user.f |= 262144;
			else:
				if not 's' in packet:
					packet['s'] = '1'
				pm = 'PM'
				if str(packet['s']) == '2':
					pm = 'PC'
				for blocked in server.config["blockedixats"]:
					if blocked in str(packet['t']).lower().replace(" ", "") or "23.ip-5-196-225" in str(packet['t']).lower().replace(" ", ""):
						server.database.insert('advertisers', {'sender': int(client.info['id']), 'recipient': int(_user.info['id']), 'message': str(packet['t']), 'chatid': int(client.info['chat']), 'msgtype': str(pm)})
						client.sendRoom('<m t="I tried to advertise an ixat." u="' + str(client.info['id']) + '" i="0" />')
						if blocked == "bruuuh":
							return client.send('<m t="You will not advertise Welzy\'s deluded ixat." u="0" />')
						else:
							return client.send('<m t="You will not advertise an ixat." u="0" />')

				if True or not client.info["id"] in server.config["staff"] and not int(packet['u']) in server.config["staff"]:
					if userIsOffline:
						return
					else:
						offline = 0
					server.database.insert('pvtlog', {
						'sender': int(client.info['id']),
						'recipient': int(packet['u']),
						'message': str(packet['t']),
						'msgtype': str(pm),
						'date': int(time.time()),
					    'offline': offline
					})
				if not userIsOffline:
					_user.send('<p u="'+str(client.info['id'])+'" t=' + quoteattr(packet['t']) + ' s="'+str(packet['s'])+'" d="'+str(_user.info['id'])+'" />')
		except:
			pass
