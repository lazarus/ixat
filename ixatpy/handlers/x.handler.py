def xHandler(packet, client, server):
	from math import floor
	import logging
	if client.online:
		AppID = int(packet["i"])
		AppID2 = str(packet["i"])
		client.info['app'] = AppID
		if AppID2[0] == "5":  # GameBans
			GameBanID = int(AppID2[2:])
			if client.Assigned(GameBanID):
				if client.info['banned']:
					GameData = str(packet['t'])
					gdsplit = GameData.split(',')
					if gdsplit[0] == "0":
						client.info['GameBanID'] = GameBanID
						client.info['GameBanData'] = [GameData]
					else:
						client.info['GameBanID'] = GameBanID
						client.info['GameBanData'].append(GameData)
					client.sendRoom('<x t="' + str(GameData) + '" i="50' + str(GameBanID) + '" u="' + str(client.info['id']) + '" />')
				else:
					client.sendRoom('<x t="" i="50' + str(GameBanID) +  '" u="' + str(client.info['id']) + '" />')
					for user in server.clients:
						if client.info['chat'] == user.info['chat'] and client.info['pool'] == user.info['pool']:
							if user.info['GameBanData'] != []:
								for GameBanData in user.info['GameBanData']:
									client.send('<x t="' + str(GameBanData).strip(",") + '" i="50' + str(user.info['GameBanID']) + '" u="' + str(user.info['id']) + '" />')
			return
		if client.info['banned']:
			return
		if AppID == 30008 and 'u' in packet and 'd' in packet and 't' in packet and client.info['id'] in server.config["staff"]:
			tradee = server.getUserByID(int(packet['d']), int(client.info['chat']))
			trade = packet['t'].split(',')
			logging.basicConfig(filename='/root/Dropbox/ixatpy/errors.txt', level=logging.DEBUG)
			logging.debug(packet)
			try:
				if tradee is not False:
					if packet['t'][:1] == "T":
						if 'trade' in tradee.info and client.info['id'] in tradee.info['trade']:
							if len(trade) == 4:
								tdata = trade[1].split(';')
								tusr2 = trade[2].split(';')

								if len(tdata) == 3 and len(tusr2) == 3:
									if not server.is_numeric(tdata[0]) or not server.is_numeric(tdata[1]):
										return
									elif not server.database.validate(trade[3], client.userInfo['password']):
										client.send('<x i="30008" t="E,8,1" />')
										tradee.send('<x i="30008" t="E,1,8" />')
									elif int(tdata[0]) > int(client.userInfo['xats']) or int(tdata[0]) < 0:
										client.send('<x i="30008" t="E,11,1" />')
										tradee.send('<x i="30008" t="E,1,11" />')
									elif int(tdata[1]) > int(client.userInfo['days']) or int(tdata[1]) < 0:
										client.send('<x i="30008" t="E,18,1" />')
										tradee.send('<x i="30008" t="E,1,18" />')
									else:
										if tusr2 != tradee.info['trade'][client.info['id']][1] or tdata != tradee.info['trade'][client.info['id']][2]:
											client.send('<n t="An error occured while trading, did something change?" />')
											tradee.send('<n t="An error occured while trading, did something change?" />')
											return
										else:
											reset0 = server.database.fetchArray("select `xats`, `days`, `connectedlast` from `users` where `id`=%(id)s", {"id": client.info['id']})
											reset1 = server.database.fetchArray("select `xats`, `days`, `connectedlast` from `users` where `id`=%(id)s", {"id": tradee.info['id']})
											
											if reset0[0]['connectedlast'] == reset1[0]['connectedlast'] and client.info['id'] not in server.config["staff"] and tradee.info['id'] not in server.config["staff"]:
												client.send('<x i="30008" t="E,32,1" />')
												tradee.send('<x i="30008" t="E,1,32" />')
												return;
											
											client.userInfo['xats'] = int(reset0[0]['xats'])
											tradee.userInfo['xats'] = int(reset1[0]['xats'])
											client.userInfo['days'] = floor((reset0[0]['days'] - time()) / 86400 + 0.3)
											tradee.userInfo['days'] = floor((reset1[0]['days'] - time()) / 86400 + 0.3)

											u1p = server.GetUserPower(client.info["id"])
											u2p = server.GetUserPower(tradee.info["id"])

											u1trade = tdata[2].split('|')
											u2trade = tradee.info['trade'][client.info["id"]][1][2].split('|')
											u1p0 = u1p
											u2p0 = u2p

											for u in u1trade:
												power = u.split('=')
												if len(power) == 2:
													if power[0] in u1p and u1p[power[0]] >= int(power[1]):
														u1p[power[0]] -= int(power[1])
														if power[0] in u2p:
															u2p[power[0]] += int(power[1])
														else:
															u2p[power[0]] = int(power[1])
													else:
														client.send('<x i="30008" t="E,33,1" />')
														tradee.send('<x i="30008" t="E,1,33" />')
														return
											for u in u2trade:
												power = u.split('=')
												if len(power) == 2:
													if power[0] in u2p and u2p[power[0]] >= int(power[1]):
														u2p[power[0]] -= int(power[1])
														if power[0] in u1p:
															u1p[power[0]] += int(power[1])
														else:
															u1p[power[0]] = int(power[1])
													else:
														tradee.send('<x i="30008" t="E,33,1" />')
														client.send('<x i="30008" t="E,1,33" />')
														return

											client.userInfo['xats'] += int(tradee.info['trade'][client.info['id']][1][0])
											tradee.userInfo['xats'] -= int(tradee.info['trade'][client.info['id']][1][0])

											client.userInfo['xats'] -= int(tdata[0])
											tradee.userInfo['xats'] += int(tdata[0])

											client.userInfo['days'] -= int(tdata[1])
											tradee.userInfo['days'] += int(tdata[1])

											tradee.userInfo['days'] -= int(tradee.info['trade'][client.info['id']][1][1])
											client.userInfo['days'] += int(tradee.info['trade'][client.info['id']][1][1])

											u1d = time() + (client.userInfo['days'] * 86400)
											u2d = time() + (tradee.userInfo['days'] * 86400)

											server.database.query("update `users` set `xats` = %(xats)s where `id` = %(id)s", {"xats": client.userInfo['xats'], "id": client.info['id']})
											server.database.query("update `users` set `xats` = %(xats)s where `id` = %(id)s", {"xats": tradee.userInfo['xats'], "id": tradee.info['id']})

											for id, count in u1p.items():
												if count < 1:
													server.DelUserPower(client.info['id'], id)
												elif id in u1p0:
													server.SetUserPower(client.info['id'], id, count)
												else:
													server.AddUserPower(client.info['id'], id, count)

											for id, count in u2p.items():
												if count < 1:
													server.DelUserPower(tradee.info['id'], id)
												elif id in u2p0:
													server.SetUserPower(tradee.info['id'], id, count)
												else:
													server.AddUserPower(tradee.info['id'], id, count)

										tradee.send('<x i="30008" t="E" />')
										client.send('<x i="30008" t="E" />')

										server.sendOpenChats(client.info['id'], server.doLogin(client.info['username'], client.userInfo['password']))
										server.sendOpenChats(tradee.info['id'], server.doLogin(tradee.info['username'], tradee.userInfo['password']))
								else:
									pass
							else:
								pass
						else:
							trade = packet['t'].split(',')
							if len(trade) == 4:
								tdata = trade[1].split(';')
								tdu2 = trade[2].split(';')

								if len(tdata) == 3 and len(tdu2) == 3:
									if not server.is_numeric(tdata[0]) or not server.is_numeric(tdata[1]):
										client.send('<n t="An error occured while trading, did something change?" />')
										tradee.send('<n t="An error occured while trading, did something change?" />')
										return
									elif not server.database.validate(trade[3], client.userInfo['password']):
										client.send('<x i="30008" t="E,8,1" />')
										tradee.send('<x i="30008" t="E,1,8" />')
									elif int(tdata[0]) > int(client.userInfo['xats']) or int(tdata[0]) < 0:
										client.send('<x i="30008" t="E,11,1" />')
										tradee.send('<x i="30008" t="E,1,11" />')
									else:
										if 'trade' not in client.info:
											client.info['trade'] = {}
										client.info['trade'][int(tradee.info['id'])] = [trade, tdata, tdu2]
					else:
						tradee.send(tradee.buildPacket('x', packet))
				else:
					#client.send('<m t="Failed at 1" u="0" />')
					pass
			except Exception:
				logging.exception(str(packet))
		elif AppID == 20010:
			appAction = str(packet["t"])
			user = server.getUserByID(int(packet["d"]), client.info["chat"])
			if user is not False and user.info['chat'] == client.info['chat'] and user.info['pool'] == client.info['pool']:
				user.send('<x i="20010" u="' + str(client.info['id']) + '" d="' + str(user.info['id']) + '" t="' + str(appAction) + '" />')
		elif AppID2[0] == "6":  # GameRaces
			# GameRace =
			# {60189:{},60193:{},60195:{},60201:{},60225:{},60239:{},60247:{},60257:{}}
			# this needs to be added to the server
			RaceData = str(packet["t"])
			rdsplit = RaceData.split(',')
			if AppID == 60189:  # Doodlerace
				if RaceData == "AQA=":
					client.GameRace[AppID][int(packet["u"])] = {'scores': {}}
				if len(rdsplit) > 1:
					if rdsplit[1] == "play":
						client.sendRoom('<x i="' + str(AppID) + '" t="1,rate,60" u="804" />', True)
					elif rdsplit[1] == "rate":
						if RaceData == "2,rate," or len(rdsplit) != 3 or rdsplit[2] == "" or rdsplit[2] == null:
							scores = {}
							for (uid, arr) in client.GameRace[AppID].items():
								score = 0
								x = 0
								for v in arr.values():
									for v2 in v.values():
										score += v2
										x = x + 1

								scores[uid] = score / x

							results = []
							winning = {}
							for (u, sco) in scores.items():
								results.append(u + "=" + sco)
								if not winning[1] or score > winning[1]['score']:
									winning[1] = {'user': u, 'score': score}
								elif not winning[2] or score > winning[2]['score']:
									winning[2] = {'user': u, 'score': score}
								elif not winning[3] or score > winning[3]['score']:
									winning[3] = {'user': u, 'score': score}

							winners = ""
							if len(winning) >= 1:
								winners += server.getUserByID(int(winning[1]['user']), client.info["chat"]).info['username'] + ' (' . winning[1]['user'] + ') gets gold (goldm#). '
							if len(winning) >= 2:
								winners += server.getUserByID(int(winning[2]['user']), client.info["chat"]).info['username'] + ' (' . winning[2]['user'] + ') gets silver (silverm#). '
							if len(winning) == 3:
								winners += server.getUserByID(int(winning[3]['user']), client.info["chat"]).info['username'] + ' (' . winning[3]['user'] + ') gets bronze (bronzem#). '
							scores = ''.join(results)

							client.send('<x i="60189" u="804" t="1,results,60,' + str(scores) + '"  />')
							if winners == "":
								client.send('<m t="Nobody\'s playing so... I\'m outa here!" u="804" i="0" />')
								client.send('<x i="60189" u="804" t="1,idle" />')
								client.send('<l u="804" />')
								client.GameRace[AppID] = {}
								return

							client.send('<m t="' + str(winners) + '" u="804" i="0" />')
							return
						scoring = rdsplit[2].split("=")
						client.GameRace[AppID][scoring[0]]['scores'].append(scoring[1])
					elif rdsplit[1] == "results":
						client.send('<g u="804" x="60189" />')
						client.send('<x i="60189" u="804" t="1,play,60,Lisa Simpson,0," />')
						client.send('<m t="DoodleRace has started with word: Techy Is Lame. " u="804" i="0" />')
					else:
						client.GameRace[AppID][int(packet["u"])] = {'scores': {}}
				else:
					appAction = str(packet["t"])
					client.sendRoom('<x i="' + str(AppID) + '" t="' + str(appAction) + '" u="' + str(client.info['id']) + '" />', True)

			if AppID == 60193:  # MatchRace
				return
			if AppID == 60195:  # Snakerace
				if RaceData == "AQA=":
					client.GameRace[AppID][int(packet["u"])] = {'scores': {}}
				if len(rdsplit) > 1:
					if rdsplit[1] == "play":
						client.sendRoom('<x i="' + str(AppID) + '" t="3,play,60, 1826500484, 1, 0," u="804" />', True)
					elif rdsplit[1] == "replay":
						client.sendRoom('<x i="' + str(AppID) + '" t="3,replay,60, 1826500484, 1, 0," u="804" />', True)
					else:
						client.GameRace[AppID][int(packet["u"])] = {'scores': {}}
				else:
					appAction = str(packet["t"])
					client.sendRoom('<x i="' + str(AppID) + '" t="' + str(appAction) + '" u="' + str(client.info['id']) + '" />', True)
			if AppID == 60201:
				return
		elif AppID == 40000:
			reg = ''
			if "N" in client.info.keys():
				reg = 'N="' + str(client.info['N']) + '" '
			if "t" in packet.keys() and packet['t'][0:1] == '/':
				if packet["t"][0:2] == "/m":
					# do somehting <x j="32748" i="40000" u="638877683" t="/m"
					# p="e" />.
					return
				elif packet["t"][0:2] == "/g":
					# do something else <x j="32748" i="40000" u="638877683"
					# t="/m" p="e" />.
					return
				return

			# if str(client.info['id']) != str(packet['u'])
			client.sendLive('<x H="3883216726" j="32651" i="' + str(AppID) + '" ' + str(reg) + 't="' + str(packet['t']) + '" u="' + str(client.info['id']) + '" q="1" n="' + str(client.info['name']) + '" a="' + str(client.info['avatar']) + '" h="' + str(client.info['home']) + '" v="0" />')
		else:
			appAction = str(packet["t"])
			client.sendRoom('<x i="' + str(AppID) + '" t="' + str(appAction) + '" u="' + str(client.info['id']) + '" />', True)
