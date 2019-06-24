def xHandler(packet, client):
    from math import floor
    from time import time
    import logging
    if client.online:
        if client.null:
            return
        AppID = int(packet["i"])
        AppID2 = str(packet["i"])

        if ("t" in packet and packet["t"] == "") or AppID != client.info["app"]:
            client.send_xml('g', {'u': str(client.info['id']), 'x': str(AppID)}, None, 1)

        client.info['app'] = AppID
        if AppID == 30008:  # Log trade packet
            logging.debug(packet)
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
                    #client.sendRoom('<x t="' + str(GameData) + '" i="50' + str(GameBanID) + '" u="' + str(client.info['id']) + '" />')
                    client.sendApp('50' + str(GameBanID), str(GameData))
                else:
                    #client.sendRoom('<x t="" i="50' + str(GameBanID) +  '" u="' + str(client.info['id']) + '" />')
                    client.sendApp('50' + str(GameBanID), "")
                    for user in server.clients:
                        if client.info['chat'] == user.info['chat'] and client.info['pool'] == user.info['pool']:
                            if user.info['GameBanData'] != []:
                                for GameBanData in user.info['GameBanData']:
                                    client.send_xml('x', {'t': str(GameBanData).strip(","), 'i': '50' + str(user.info['GameBanID']), 'u': str(user.info['id'])})
            return
        if client.info['banned']:
            return
        if AppID == 30008 and 'u' in packet and 'd' in packet and 't' in packet:
            tradee = server.getUserByID(int(packet['d']), int(client.info['chat']))
            trade = packet['t'].split(',')
            """
			TODO? - FOR BETTER ERROR MANAGEMENT:
																0	 1    2     3
			Could even store it in the client.info['trade'] = [..., ..., ..., ErrNo(, Held/Reserve_Variable)]
			to make it a little better? then we wouldn't have to tradee.send('<error packet />')
			just be like:
			
			if client.info['trade'][int(tradee.info['id'])][3] != 0: #
				send_error_packet(), but reverse order
				return
				
			### Other potential ways: ###
			
			try:
				held_or_reserve = 0#pick a better name lmao
				
				do_the_normal_stuff()
				
				if they dont pass this check:
					raise Exception(8)
				elif they dont pass this one:
					raise Exception(11)
				elif ...
					raise Exception(...)
				elif theyre reserved:
					held_or_reserve = 50000 #i guess
					raise Exception(24) #will this work?
			catch BaseException as e: #hopefully this only catches purposely raised errors?
				client.send('<x i="30008" u="' + str(tradee.info['id']) + '" d="' + str(client.info['id']) + '" t="E,'+ str(e) +',1,'+ str(held_or_reserve) +'" />')
				tradee.send('<x i="30008" u="' + str(client.info['id']) + '" d="' + str(tradee.info['id']) + '" t="E,1,'+ str(e) +','+ str(held_or_reserve) +'" />')
			catch Exception as e:
				raise(e) #not our exception to handle here. do we even need this part?
			
			### Or this ###
			
			for x in range(0, 1): #loop only once
				ErrNo = 0
				held_or_reserve = 0#pick a better name lmao
				
				do_the_normal_stuff()
				
				if they dont pass this check:
					ErrNo = 8
					break
				elif they dont pass this one:
					ErrNo = 11
					break
				elif ...
					ErrNo = ...
					break
				elif theyre reserved:
					ErrNo = 24
					held_or_reserve = 50000 #number of xats
					break
					
				...
				
				if ErrNo != 0:
					client.send('<x i="30008" u="' + str(tradee.info['id']) + '" d="' + str(client.info['id']) + '" t="E,'+ str(ErrNo) +',1,'+ str(held_or_reserve) +'" />')
					tradee.send('<x i="30008" u="' + str(client.info['id']) + '" d="' + str(tradee.info['id']) + '" t="E,1,'+ str(ErrNo) +','+ str(held_or_reserve) +'" />')
				
			"""
            try:
                if tradee is not False:
                    if packet['t'][:1] == "T":  # Trade was accepted by client
                        if 'trade' in tradee.info and client.info['id'] in tradee.info['trade']:
                            if len(trade) == 4:
                                tdata = trade[1].split(';')
                                tusr2 = trade[2].split(';')

                                if len(tdata) == 3 and len(tusr2) == 3:
                                    if not server.is_numeric(tdata[0]) or not server.is_numeric(tdata[1]):
                                        return
                                    elif not database.validate(trade[3], client.userInfo['password']):
                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,8,1,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,8,0'})
                                    elif int(tdata[0]) > int(client.userInfo['xats']) or int(tdata[0]) < 0:
                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,11,1,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,11,0'})
                                    elif int(tdata[1]) > int(client.userInfo['days']) or int(tdata[1]) < 0:
                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,18,1,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,18,0'})
                                    else:
                                        if tusr2 != tradee.info['trade'][client.info['id']][1] or tdata != tradee.info['trade'][client.info['id']][2]:
                                            client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,31,1,0'})
                                            tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,31,1,0'})
                                            return
                                        else:
                                            reset0 = database.fetchArray("select `xats`, `days`, `connectedlast`, `powers`, `dO`, `transferblock`, `hold`, `reserve`, `torched` from `users` where `id`=%(id)s", {"id": client.info['id']})
                                            reset1 = database.fetchArray("select `xats`, `days`, `connectedlast`, `powers`, `dO`, `transferblock`, `hold`, `reserve`, `torched` from `users` where `id`=%(id)s", {"id": tradee.info['id']})

                                            if reset0[0]['connectedlast'] == reset1[0]['connectedlast'] and client.info['id'] not in server.config["staff"] and tradee.info['id'] not in server.config["staff"]:
                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,32,1,0'})
                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,32,0'})
                                                return

                                            if not client.registered:
                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,10,1,0'})
                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,10,0'})
                                                return

                                                #torched = 55 or 99
                                            if int(reset0[0]['torched']) == 1:
                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,99,1,0'})
                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,99,0'})
                                                return

                                            if not tradee.registered:
                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,10,1,0'})
                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,10,0'})
                                                return

                                            if int(reset1[0]['torched']) == 1:
                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,1,99,0'})
                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,99,1,0'})
                                                return

                                            client.userInfo['xats'] = int(reset0[0]['xats'])
                                            tradee.userInfo['xats'] = int(reset1[0]['xats'])

                                            u1p = server.DecodePowers(reset0[0]['powers'], reset0[0]['dO'])
                                            u2p = server.DecodePowers(reset1[0]['powers'], reset1[0]['dO'])

                                            u1trade = tdata[2].split('|')
                                            u2trade = tradee.info['trade'][client.info["id"]][1][2].split('|')

                                            '''
												this code is because cryo found out that if someone is reserved 
												and you try to send somehting to them without them sending anything 
												it says you cant but it should let you
											'''
                                            if trade[1] != "0;0;":
                                                if int(reset0[0]['transferblock']) > int(time()):
                                                    held = str(floor((int(time()) - int(reset0[0]['transferblock'])) / 86400))[1:]
                                                    client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,24,1,' + str(held)})
                                                    tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,24,' + str(held)})
                                                    return

                                                if int(reset0[0]['hold']) > int(time()):
                                                    held = str(floor((reset0[0]['hold'] - int(time)) / 86400))
                                                    client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,24,1,' + str(held)})
                                                    tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,24,' + str(held)})
                                                    return

                                                if int(tdata[0]) > (int(reset0[0]['xats'] - int(reset0[0]['reserve']))):
                                                    reduce = int(tdata[0]) - (int(reset0[0]['xats']) - int(reset0[0]['reserve']))
                                                    client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,38,1,' + str(reduce)})
                                                    tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,38,' + str(reduce)})
                                                    return

                                            if trade[2] != "0;0;":
                                                if int(reset1[0]['transferblock']) > int(time()):
                                                    held = str(floor((int(time()) - int(reset1[0]['transferblock'])) / 86400))[1:]
                                                    client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,1,24,' + str(held)})
                                                    tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,24,1,' + str(held)})
                                                    return

                                                if int(reset1[0]['hold']) > int(time()):
                                                    held = str(floor((reset1[0]['hold'] - int(time)) / 86400))
                                                    client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,24,1,' + str(held)})
                                                    tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,24,' + str(held)})
                                                    return

                                                if int(tradee.info['trade'][client.info['id']][1][0]) > (int(reset1[0]['xats'] - int(reset1[0]['reserve']))):
                                                    reduce = int(tradee.info['trade'][client.info['id']][1][0]) - (int(reset1[0]['xats']) - int(reset1[0]['reserve']))
                                                    client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,1,38,' + str(reduce)})
                                                    tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,38,1,' + str(reduce)})
                                                    return

                                            gp1 = tradee.getGroupPowers()
                                            gp2 = client.getGroupPowers()
                                            groupList = server.getGroupPowers()

                                            for u in u1trade:
                                                power = u.split('=')
                                                if len(power) == 2:

                                                    if int(power[0]) in [0, 81, 95]:
                                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,43,1,0'})
                                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,43,0'})
                                                        return

                                                    if power[0] in u1p and u1p[power[0]] >= int(power[1]):
                                                        if gp1 and int(power[0]) in groupList:
                                                            if int(power[0]) in gp1 and int(power[1]) >= int(gp1[int(power[0])]):
                                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,41,1,0'})
                                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,41,0'})
                                                                return

                                                        u1p[power[0]] -= int(power[1])

                                                        if u1p[power[0]] < 1:
                                                            del u1p[power[0]]

                                                        if power[0] in u2p:
                                                            u2p[power[0]] += int(power[1])
                                                        else:
                                                            u2p[power[0]] = int(power[1])
                                                    else:
                                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,33,1,0'})
                                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,33,0'})
                                                        return

                                            for u in u2trade:
                                                power = u.split('=')
                                                if len(power) == 2:

                                                    if int(power[0]) in [0, 81, 95]:
                                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,1,43,0'})
                                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,43,1,0'})
                                                        return

                                                    if power[0] in u2p and u2p[power[0]] >= int(power[1]):
                                                        if gp2 and int(power[0]) in groupList:
                                                            if int(power[0]) in gp2 and int(power[1]) >= int(gp2[int(power[0])]):
                                                                client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,1,41,0'})
                                                                tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,41,1,0'})
                                                                return

                                                        u2p[power[0]] -= int(power[1])

                                                        if u2p[power[0]] < 1:
                                                            del u2p[power[0]]

                                                        if power[0] in u1p:
                                                            u1p[power[0]] += int(power[1])
                                                        else:
                                                            u1p[power[0]] = int(power[1])
                                                    else:
                                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,1,33,0'})
                                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,33,1,0'})
                                                        return

                                            client.userInfo['xats'] += int(tradee.info['trade'][client.info['id']][1][0])
                                            tradee.userInfo['xats'] -= int(tradee.info['trade'][client.info['id']][1][0])

                                            client.userInfo['xats'] -= int(tdata[0])
                                            tradee.userInfo['xats'] += int(tdata[0])

                                            u1powers, u1dO = server.EncodePowers(u1p)
                                            u2powers, u2dO = server.EncodePowers(u2p)

                                            database.query("update `users` set `xats`=%(xats)s, `powers`=%(powers)s, `dO`=%(dO)s where `id` = %(id)s", {"xats": client.userInfo['xats'], "powers": u1powers, "dO": u1dO, "id": client.info['id']})
                                            database.query("update `users` set `xats`=%(xats)s, `powers`=%(powers)s, `dO`=%(dO)s where `id` = %(id)s", {"xats": tradee.userInfo['xats'], "powers": u2powers, "dO": u2dO, "id": tradee.info['id']})

                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,0,0,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,0,0,0'})

                                        server.sendOpenChats(client.info['id'], server.doLogin(client.info['username'], client.userInfo['password']))
                                        server.sendOpenChats(tradee.info['id'], server.doLogin(tradee.info['username'], tradee.userInfo['password']))

                                        client.send_xml('ldone')
                                        tradee.send_xml('ldone')
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
                                        client.send_xml('n', {'t': 'An error occured while trading, did something change?'})
                                        tradee.send_xml('n', {'t': 'An error occured while trading, did something change?'})
                                        return
                                    elif not database.validate(trade[3], client.userInfo['password']):
                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,8,1,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,8,0'})
                                    elif int(tdata[0]) > int(client.userInfo['xats']) or int(tdata[0]) < 0:
                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,11,1,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,11,0'})
                                    elif int(tdata[1]) > int(client.userInfo['days']) or int(tdata[1]) < 0:
                                        client.send_xml('x', {'i': 30008, 'u': str(tradee.info['id']), 'd': str(client.info['id']), 't': 'E,18,1,0'})
                                        tradee.send_xml('x', {'i': 30008, 'u': str(client.info['id']), 'd': str(tradee.info['id']), 't': 'E,1,18,0'})
                                    else:
                                        if 'trade' not in client.info:
                                            client.info['trade'] = {}
                                        client.info['trade'][int(tradee.info['id'])] = [trade, tdata, tdu2]
                    else:
                        tradee.send_xml('x', packet)
                else:
                    #client.send('<m t="Failed at 1" u="0" />')
                    pass
            except Exception:
                logging.exception(str(packet))
        elif AppID == 20010 and "d" in packet:
            appAction = str(packet["t"])
            user = server.getUserByID(int(packet["d"]), client.info["chat"])
            if user is not False and user.info['chat'] == client.info['chat'] and user.info['pool'] == client.info['pool']:
                user.send_xml('x', {'i': 20010, 'u': str(client.info['id']), 'd': str(user.info['id']), 't': str(appAction)})
        elif AppID2[0] == "6" and client.info['id'] == 804:  # GameRaces
            # GameRace =
            # {60189:{},60193:{},60195:{},60201:{},60225:{},60239:{},60247:{},60257:{}}
            # this needs to be added to the server
            if 'd' in packet:
                duser = server.getUserByID(int(packet['d']), int(client.info['chat']))
                duser.send_xml('x', packet)
            else:
                client.send_xml('x', packet, None, 1, True)
            return
            '''
			RaceData = str(packet["t"])
			rdsplit = RaceData.split(',')
			if AppID == 60189:  # Doodlerace
				if RaceData == "AQA=":
					client.GameRace[AppID][int(packet["u"])] = {'scores': {}}
				if len(rdsplit) > 1:
					if rdsplit[1] == "play":
						client.sendRoom('<x i="' + str(AppID) + '" t="1,rate,60" u="804" />', True)
					elif rdsplit[1] == "rate":
						if RaceData == "2,rate," or len(rdsplit) != 3 or rdsplit[2] == "" or rdsplit[2] == None:
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
			'''
        elif AppID == 40000:
            reg = ''
            if "N" in client.info.keys():
                reg = 'N="' + str(client.info['N']) + '" '
            if "t" in packet.keys() and packet['t'][0:1] == '/' and packet['t'][1:4] != 'RType':
                if packet["t"][0:2] == "/m":
                    # do somehting <x j="32748" i="40000" u="638877683" t="/m"
                    # p="e" />.
                    return
                elif packet["t"][0:2] == "/g":
                    # <x j="32751" i="40000" u="638877683" t="/g3600" /> recv
                    # <k i="32751" d="638877683" /> send
                    user = server.getUserByID(int(packet["d"]), client.info["chat"])
                    if user != False:
                        user.send_xml('k', {'i': packet['j'], 'd': packet['u']})

                    return
                return

            # if str(client.info['id']) != str(packet['u'])
            client.sendLive('<x H="3883216726" j="32651" i="' + str(AppID) + '" ' + str(reg) + 't="' + str(packet['t']) + '" u="' + str(client.info['id']) + '" q="1" n="' + str(client.info['name']) + '" a="' + str(client.info['avatar']) + '" h="' + str(client.info['home']) + '" v="0" />')
        else:
            appAction = str(packet["t"])
            #client.sendRoom('<x i="' + str(AppID) + '" t="' + str(appAction) + '" u="' + str(client.info['id']) + '" />', True)
            client.sendApp(AppID, appAction, True)
