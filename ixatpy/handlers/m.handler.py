def mHandler(packet, client, server):
	import time
	import json

	if client.null:
		return
	elif client.online:
		if client.info["banned"]:
			return
		message = str(packet["t"])
		if message[0:1] == '/':
			if message[0:3] == "/ka" and client.info['rank'] in client.minRankToArray(client.kickAll_minRank) and client.hasPower(244, True):
				'''
				KICKALL_GUEST 0x100
				KICKALL_REG 0x200
				KICKALL_MUTE 0x300
				KICKALL_BAN 0x400
				'''
				KickAllFlags = 0x100
				KickAllPool = int(client.info['pool'])
				if 'p' in message:
					KickAllPool = -1#all pools
				if 'r' in message:
					KickAllFlags += 0x200
				if 'm' in message:
					KickAllFlags += 0x300
				if 'b' in message:
					KickAllFlags += 0x400

				try:
					client.KickAll(client.info['chat'], KickAllPool, KickAllFlags)
					client.sendRoom('<m t="' + str(message) + '" u="' + str(client.info['id']) + '" d="1" />')
				except Exception as e:
					client.sendRoom('<m t="'+e+'" u="0" />')

			elif message[0:2] == "/h" and client.info['rank'] in [1, 4] and client.hasPower(51, True):
				Hush = {"message":"", "seconds":"", "time": 0, "userid": client.info['id'], "rank": client.info['rank']}
				isMessage = False
				for char in message[2:]:
					try:
						if not isMessage:
							float(char)
							Hush["seconds"] += str(char)
						else:
							raise("isMessage")
					except:
						isMessage = True
						if char != " ":
							Hush["message"] += str(char)
				if len(str(Hush["seconds"])) == 0:
					Hush["seconds"] = "60"
				if len(str(Hush["message"])) == 0:
					Hush["message"] = " for no reason."
				else:
					Hush["message"] = ". Reason: " + str(Hush["message"])

				if client.hidden:
					client.info['KeepPool'] = True
					client.joinRoom(False, True)

				client.sendRoom('<m t="(HUSH#w' + str(int(Hush["seconds"])) + '#)I have hushed the chat for ' + str(int(Hush["seconds"])) + " seconds" + str(Hush["message"]) + '" u="' + str(client.info['id']) + '" />')
				server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'message': '(HUSH#w' + str(int(Hush["seconds"])) + '#)I have hushed the chat for ' + str(int(Hush["seconds"])) + " seconds" + str(Hush["message"]) + '', 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info["pool"], 'port': str(server.connection['port'])})
				Hush["time"] = int(int(time.time()) + int(Hush["seconds"]))
				server.database.query("UPDATE `chats` SET `hush` = %(hush)s WHERE `id` = %(id)s", {'hush': json.dumps(Hush), "id": client.info['chat']})
				Users = server.clients
				for user in Users:
					if user.info['chat'] == client.info['chat'] and not server.higherRank(user.info['rank'], client.info['rank']) and client.info['rank'] != user.info['rank']:
						"""
						if user.hidden:
							user.hidden = False
						elif not user.hidden and user.hasPower(29, True):
							user.hidden = True
						user.joinRoom(False, True)
						"""
						user.disconnect()
			elif message[0:3] == '/ri' and client.info["rank"] in client.minRankToArray(client.canRankLock_minRank):
				ranklock = server.json_load(server.database.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":client.info["chat"]})[0]['ranklock'])
				if ranklock == None:
					return client.notice("There are no ranklocked users.", True)
				ranklocked = ""
				for rlduserid, rldrank in ranklock.items():
					ranklocked += str(rlduserid) + ": " + str(rldrank) + " | "
				client.notice(ranklocked[:-2], True)
			elif message[0:2] == '/r' and client.info["rank"] in client.minRankToArray(client.canRankLock_minRank) and client.hasPower(391, True):
				try:
					ranklockdata = message[2:256].strip().split(" ")
					rlduserid = str(int(ranklockdata[0].strip()))
					rldrank = str(ranklockdata[1]).lower()
					if not rldrank in ['guest', 'member', 'moderator', 'owner', 'off']:
						return client.notice("Rank does not exist.", True)
					ranklock = server.json_load(server.database.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":client.info["chat"]})[0]['ranklock'])
					if ranklock == None:
						ranklock = {}
					try:
						targetRank = int(server.database.fetchArray("SELECT * FROM `ranks` WHERE chatid=%(chatid)s and userid=%(userid)s", {"chatid": client.info["chat"], "userid": rlduserid})[0]["f"])
					except:
						targetRank = 5
					if (rldrank == "owner" and client.info['rank'] == 4) or (targetRank == 1) or (targetRank == 4 and client.info['rank'] == 4):
						return
					import json
					if rldrank == 'off' and rlduserid in ranklock.keys():
						del ranklock[rlduserid]
					else:
						ranklock[rlduserid] = rldrank
						server.database.query('delete from `ranks` where `userid`=%(userid)s and `chatid`=%(chatid)s', {"userid": rlduserid, "chatid": client.info["chat"]})
						server.database.query('insert into `ranks`(`userid`, `chatid`, `f`, `sinbin`) values(%(userid)s, %(chatid)s, %(f)s, 0);', {"userid": rlduserid, "chatid": client.info["chat"], "f": {"guest": 5, "member": 3, "moderator": 2, "owner": 4}[rldrank]})
					server.database.query("update `chats` set `ranklock` = %(rl)s where `id` = %(id)s", {"rl": json.dumps(ranklock), "id": client.info["chat"]})
					client.notice(str(rlduserid) + " ranklock: " + str(rldrank), True)
					targetUser = server.getUserByID(rlduserid, client.info['chat'])
					if targetUser != False and targetUser.info["chat"] == client.info["chat"]:
						pool = targetUser.getPool(targetUser.info['pool'], True)
						targetUser.info['ChangePool'] = int(pool)
						if pool != targetUser.info['pool']:
							targetUser.sendRoom('<l u="' + str(targetUser.info['id']) + '" />')
							targetUser.joinRoom(True, False)
						else:
							targetUser.joinRoom(False, True)
				except:
					client.notice("You must use that command in this format: /r [userid] [rank]", True)
			elif message[0:2] == '/i':
				if client.info['temp'] != 0:
					timex = round(float(float(client.info['temp'] - time.time()) / 3600), 2)
					if timex >= 0:
						client.info['info']['temp'] = "_/temp " + str(timex) + " hours"
				if len(client.info['info']) > 0:
					client.send('<m t="' + " ".join(client.info['info'].values()) + '" u="0" />')
			elif (message == '/RTypeOn' or message == '/RTypeOff') and client.hasPower(172, True):
				if client.hidden:
					client.info['KeepPool'] = True
					client.joinRoom(False, True)
				client.info["typing"] = (message == '/RTypeOn')
				client.sendMessage(message)
			elif message == '/away' and not client.info["away"] and client.hasPower(144, True):
				client.info["away"] = True
				if client.hasPower(29, True) and client.hidden == True:
					client.hidden = False # masked hidden
				elif client.hasPower(29, True) and client.hidden == False:
					client.hidden = True
				client.info['KeepPool'] = True
				client.joinRoom(False, True)
			elif message == '/back' and client.info["away"] and client.hasPower(144, True):
				client.info["away"] = False
				if client.hasPower(29, True) and client.hidden == True:
					client.hidden = False # masked hidden
				elif client.hasPower(29, True) and client.hidden == False:
					client.hidden = True
				client.info['KeepPool'] = True
				client.joinRoom(False, True)
				
			elif message[0:3] == '/go':
				name = message[3:].replace(" ", "")
				if len(name) < 1:
					return
				
				if name.isdigit():
					chat = server.database.fetchArray("SELECT * FROM `chats` WHERE 'id'=%(id)s", {"id": name})
				else:
					chat = server.database.fetchArray("SELECT * FROM `chats` WHERE 'name'=%(name)s", {"name": name})
					
				if not len(chat):
					return
				else:
					client.sendRoom('<l u="' + str(client.info['id']) + '"/>')
					client.send('<q r="' + str(chat[0]['id']) + '" u="' + str(client.info['id']) + '"/>')
					client.info['chat'] = str(chat[0]['id'])
					client.joinRoom(True)
			elif message[0:2] == '/g' and client.hasPower(32, True) and client.info["rank"] != 5:
				if client.info['chat'] is 1:
					return client.notice('Guestself is disabled in Lobby. MEMBER HERE IS A PRIVILEGE, EMBRACE IT.')
				if client.hidden:
					client.info['KeepPool'] = True
				server.database.query('delete from `ranks` where `userid`=%(userid)s and `chatid`=%(chatid)s', {"userid": client.info["id"], "chatid": client.info["chat"]})
				client.joinRoom(False, True)
			elif message[0:2] == '/s' and client.info['rank'] in client.minRankToArray(client.setScroller_minRank):
				if client.hidden:
					client.info['KeepPool'] = True
					client.joinRoom(False, True)
				scroll = message[2:256]
				server.database.query("update `chats` set `sc` = %(sc)s, `ch` = %(ch)s where `id` = %(id)s", {"sc": scroll, "ch": client.info["id"], "id": client.info["chat"]})
				clients = server.clients
				for _client in clients:
					if _client.info['chat'] == client.info['chat'] and client.info['pool'] == _client.info['pool'] and _client.info['rank'] in [1, 2, 4]:
						_client.send('<m t="/s' + str(scroll) + '" u="' + str(client.info["id"]) + '" />')
						_client.info['info']['/s'] = "_/s " + str(client.info['id'])
					elif _client.info['chat'] == client.info['chat'] and _client.info['rank'] in [1, 2, 4]:
						_client.send('<m t="/s' + str(scroll) + '" u="0" />')
						_client.info['info']['/s'] = "_/s " + str(client.info['id'])
			elif message[0:2] == '/d' and client.info["rank"] in [1, 2, 4]: # delete messages
				if client.hidden:
					client.info['KeepPool'] = True
					client.joinRoom(False, True)
				mid = int(message[2:256])
				server.database.query('update `messages` set visible=0 where id = %(id)s and mid = %(mid)s and port = %(port)s', {"id": client.info['chat'], "mid": int(mid), "port": server.connection['port']})
				client.sendRoom('<m t="/d' + str(int(mid)) + '" u="0" T="' + str(int(time.time())) + '" r="' + str(client.info['chat']) + '" />')
		else:
			if len(message) > 0:
				if client.info['members_only'] and client.info['rank'] == 5:
					return client.notice("Your message did not send because you're not a member.", True)
				if client.info['redcard']:
					banned = ((client.info["rc_bannedtime"] - (float(time.time()) - client.info["joinTime"])) * client.redCardFactor)
					bannedfor = float(time.time()) + banned
					server.database.query("delete from `bans` where chatid=%(chatid)s and userid=%(userid)s and special=%(special)s", {"chatid": client.info["chat"], "userid": client.info['id'], "special": 367})
					server.database.insert('bans', {'chatid': client.info["chat"], 'userid': client.info["id"], 'unbandate': bannedfor, 'ip': client.connection['ip'], 'type': "g", 'special': 0})
					server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': int(client.info['id']), 'uid2': int(client.info['id']), 'message': "/gr" + str(int(banned)), 'reason': "(redcard)", 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info["pool"], 'port': str(server.connection['port'])})
					oldpool = client.info["pool"]
					client.sendRoom('<m t="' + '/gr' + str(int(banned)) + '" p="(redcard)" u="' + str(client.info['id']) + '" d="' + str(client.info['id']) + '" />', True)
					client.sendRoom('<l u="' + str(client.info['id']) + '" />')
					client.joinRoom(False, True)
					newpool = client.info["pool"]
					if oldpool != newpool:
						client.send('<m t="' + '/gr' + str(int(banned)) + '" p="(redcard#)" u="' + str(client.info['id']) + '" d="' + str(client.info['id']) + '" />')
					return
				if client.info['GaggedTime'] != 0:
					if (client.info['GaggedTime'] - time.time()) > 0:
						return client.send('<m t="You\'re still gagged" u="0" />')
				if client.info['HushedTime'] != 0:
					if (client.info['HushedTime'] - time.time()) > 0:
						return client.send('<m t="You\'re still hushed." u="0" />')

				if client.info["Naughty"]:
					nt = int(time.time()) - client.info["NaughtyTime"]
					if (nt < 30):
						return client.send('<m t="You still have ' + str(30 - nt) + ' seconds before you can chat again. [Naughtystep]" u="0" />')
					client.info["NaughtyTime"] = int(time.time())

				for blocked in server.config["blockedixats"]:
					if blocked in str(message).lower().replace(" ", "") or "23.ip-5-196-225" in str(message).lower().replace(" ", ""):
						server.database.insert('advertisers', {'sender': int(client.info['id']), 'message': str(message), 'chatid': int(client.info['chat'])})
						client.sendRoom('<m t="I tried to advertise an ixat." u="' + str(client.info['id']) + '" i="0" />')
						return client.send('<m t="You will not advertise Welzy\'s deluded ixat." u="0" />') if blocked == "bruuuh" else client.send('<m t="You will not advertise an ixat." u="0" />')

				if client.info['rank'] == 5 and "l" in packet.keys() and int(packet["l"]) == 1:
					return client.send('<m t="Guests cannot post links." u="0" />')

				if client.hidden:
					client.info['KeepPool'] = True
					client.joinRoom(False, True)

				try:
					commandcodes = ["q", "~"]
					command = message.split(" ")
					try:
						commandcode = str(command[0][0]).lower()
					except:
						commandcode = ""
					try:
						commandcode2 = str(command[0][1]).lower()
					except:
						commandcode2 = ""
					startat = 1
					send = True

					if client.info['id'] in server.config["staff"]:
						if commandcode in commandcodes:
							if commandcode2 == "z" or commandcode == commandcode2:
								startat = 2
								send = False

					if send:
						if client.info['live_mode'] == True and client.info['rank'] == 5:
							reg = ''
							if "N" in client.info.keys():
								reg = 'N="' + str(client.info['N']) + '" '
							client.sendLive('<x i="40000" ' + str(reg) + 't="' + str(message) + '" u="' + str(client.info['id']) + '" q="1" n="' + str(client.info['name']) + '" a="' + str(client.info['avatar']) + '" h="' + str(client.info['home']) + '" v="0" />')
						else:
							client.sendMessage(message)
						#client.sendRoom('<x H="3883216726" j="32651" i="40000" t="' + str(message) + '" u="17092" q="1" n="' + client.info['name'] + '" a="' + client.info['avatar'] + '" h="" v="0" />')
						#client.sendRoom('<m t="'+message+'" u="'+str(client.info['id'])+'" i="0" />')
						server.database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'message': str(message), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info["pool"], 'port': str(server.connection['port'])})

					if commandcode in commandcodes:
						#if commandcode2 == "z" or commandcode == commandcode2:
						server.write(client.info['username'] + "(" + str(client.info['id']) + ") used command: [" + command[0][startat:].lower() + "], RAW: [" + message + "]", "Commands")
						server.call(command[0][startat:].lower(), "command", command, client, server)
				except:
					pass

					if client.info["Naughty"]:
						client.info['KeepPool'] = True
						client.joinRoom(False, True)
