def pHandler(packet, client):
    import time
    import cgi
    from traceback import print_exc

    userIsOffline = False

    if client.null == True:
        client.signOut()
        return
    if not client.online:
        return

    if not "u" in packet or not "t" in packet:
        return

    f = 10.0
    p2 = packet['t']
    if p2[0:1] == '/' and p2[1:1] != 'b': # high rate if / apart from friend add 
        f = 1.0
    else:
        if int(client.info["id"]) in config.X_BOTS:
            p2 = None
            f = 10.0 # allow bots to spam thier users 

    if client.RapidMessageCheck(p2, f, 0, packet['u'], 0):
        return client.send_xml('m', {'t': 'Packet Blocked due to limit', 'u': '0', 's': '0'}) # PrivateMessage

    try:
        _user = server.getUserByID(packet['u'], client.info['chat'])
        if not _user:
            userIsOffline = True

        if client.hidden:
            client.info['KeepPool'] = True
            client.joinRoom(False, True)

        if (packet['t'] == '/RTypeOn' or packet['t'] == '/RTypeOff') and client.hasPower(172, True):
            if not userIsOffline:
                return _user.send_xml('p', {'u': str(client.info['id']), 't': (packet['t']), 'd': str(_user.info['id'])})

        elif packet['t'][0:1] == '/':
            if client.info["Naughty"]:
                return
            if userIsOffline:
                return
            if client.info['temp'] != 0 and (client.info['temp'] - float(time.time())) < 0:
                return client.disconnect()

            """

			/x	- AdminMessage
			/nb	- DoBadge
			/mo	- MakeTempOwn
			/mb	- MakeTempMember
			/m	- MakeTempMod
			/n	- MakeSinBin

			"""

            if packet['t'][1:3] == 'nb':
                try:
                    if not client.hasPower(264, True):
                        return

                    if client.info["id"] == _user.info["id"] and False:
                        return

                    packet["t"] = packet["t"][:80]

                    if not client.hasMinRank(client.info["rank"], 'bdg'):
                        return

                    badge_action = "1"

                    if not _user.info["flags"] & config.U_BADGE:
                        client.send_xml('m', {'p': (str(packet['t'][3:])), 't': '/gd', 'w': 264, 'u': str(client.info["id"]), 'd': str(_user.info["id"])}, None, 1)
                        database.insert('bans', {
                            'chatid': int(_user.info["chat"]),
                            'userid': int(_user.info["id"]),
                            'unbandate': 0,
                            'ip': str(_user.connection["ip"]),
                            'type': 'gd',
                            'special': 264,
                            'hours': 0
                        })
                    else:
                        database.query('delete from `bans` where chatid=%(chatid)s and type="gd" and userid=%(userid)s', {
                                       "chatid": _user.info["chat"], "userid": _user.info["id"]})
                        badge_action = "2"

                    client.WriteEvent(client.info["id"], _user.info["id"], client.info[
                                      "chat"], "b" + badge_action, 0, packet["t"][3:], 264)

                    return _user.joinRoom(False, True)
                except:
                    print(format_exc())
                    return

            elif packet['t'][1:3] == 'mo':
                if not client.hasPower(79, True):
                    return
                # main only
                if client.info["rank"] != 1 or server.higherRank(client.info['rank'], _user.info['rank'], True) == False or client.info['rank'] == _user.info['rank']:
                    return
                try:
                    temptime = packet['t'][3:10]
                    temptime2 = float(temptime) * 60 * 60
                    if int(temptime) > 24 or int(temptime) < 1:
                        raise ValueError
                except:
                    return client.notice("Please use the following format\n/mo2.5 for 2.5 hours\nMax: 24\nMin: 1")
                # {"userid": _user.info['id'], "chatid": client.info['chat']:}
                database.query('DELETE FROM `ranks` WHERE `userid`=%(userid)s AND `chatid`=%(chatid)s', {
                               "userid": _user.info['id'], "chatid": client.info['chat']})
                database.insert('ranks', {'userid': _user.info['id'], 'chatid': client.info[
                                'chat'], 'f': 4, 'tempend': (float(time.time()) + float(temptime) * 60 * 60)})
                client.send_xml('m', {'u': str(client.info["id"]), 'd': str(_user.info['id']), 't': '/m', 'p': 'o' + str(temptime2), 'i': '0'}, None, 1)
                client.WriteEvent(client.info["id"], _user.info[
                                  "id"], client.info["chat"], "mo", temptime, 0, 0)
                database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/m', 'reason': 'o' + str(temptime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info[
                                'avatar'], 'time': str(int(time.time())), 'pool': '0', 'ip': (client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))])), 'port': str(config.CONN_PORT)})
                return _user.joinRoom(False, True)

            elif packet['t'][1:3] == 'mb':
                if client.info['sinbinned'] or client.info["banned"]:
                    return
                if userIsOffline:
                    return
                if not client.hasPower(61, True):
                    return
                # main only
                if client.info["rank"] not in [1, 4, 2] or server.higherRank(client.info['rank'], _user.info['rank'], True) == False or client.info['rank'] == _user.info['rank']:
                    return
                try:
                    temptime = packet['t'][3:10]
                    temptime2 = float(temptime) * 60 * 60
                    if int(temptime) > 24 or int(temptime) < 1:
                        raise ValueError
                except:
                    # client.notice("Please use the following format\n/me2.5 for 2.5 hours\nMax: 24\nMin: 1")
                    return
                database.query('DELETE FROM `ranks` WHERE `userid`=%(userid)s AND `chatid`=%(chatid)s', {
                               "userid": _user.info['id'], "chatid": client.info['chat']})
                database.insert('ranks', {'userid': _user.info['id'], 'chatid': client.info[
                                'chat'], 'f': 3, 'tempend': (float(time.time()) + float(temptime) * 60 * 60)})
                client.send_xml('m', {'u': str(client.info["id"]), 'd': str(_user.info['id']), 't': '/m', 'p': 'e' + str(temptime2), 'i': '0'}, None, 1)
                client.WriteEvent(client.info["id"], _user.info[
                                  "id"], client.info["chat"], "mb", temptime, 0, 0)
                database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/m', 'reason': 'e' + str(temptime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info[
                                'avatar'], 'time': str(int(time.time())), 'pool': '0', 'ip': (client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))])), 'port': str(config.CONN_PORT)})
                return _user.joinRoom(False, True)

            elif packet['t'][1:2] == 'm':
                if client.info['sinbinned'] or client.info["banned"]:
                    return
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
                    # client.notice("Please use the following format\n/m2.5 for 2.5 hours\nMax: 24\nMin: 1")
                    return
                database.query('DELETE FROM `ranks` WHERE `userid`=%(userid)s AND `chatid`=%(chatid)s', {
                               "userid": _user.info['id'], "chatid": client.info['chat']})
                database.insert('ranks', {'userid': _user.info['id'], 'chatid': client.info[
                                'chat'], 'f': 2, 'tempend': (float(time.time()) + float(temptime) * 60 * 60)})
                client.send_xml('m', {'u': str(client.info["id"]), 'd': str(_user.info['id']), 't': '/m', 'p': 'm' + str(temptime2), 'i': '0'}, None, 1)
                client.WriteEvent(client.info["id"], _user.info[
                                  "id"], client.info["chat"], "mm", temptime, 0, 0)
                database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/m', 'reason': 'm' + str(temptime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info[
                                'avatar'], 'time': str(int(time.time())), 'pool': '0', 'ip': (client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))])), 'port': str(config.CONN_PORT)})
                return _user.joinRoom(False, True)

            elif packet['t'][1:2] == 'n':
                if not client.hasPower(33, True):
                    return
                if client.info['sinbinned'] or client.info["banned"]:
                    return
                if _user.info['rank'] == 2 and server.higherRank(client.info['rank'], _user.info['rank'], True):
                    try:
                        sinbintime = packet['t'][2:10]
                        sinbintime2 = float(sinbintime) * 60 * 60
                        if sinbintime2 > 86400.0 or sinbintime2 < 61.2:
                            raise ValueError
                        sinbinnedTime = float(time.time()) + sinbintime2
                        database.query("update `ranks` set `sinbin` = %(time)s where `chatid` = %(chatid)s and `userid` = %(id)s", {
                                       "time": sinbinnedTime, "chatid": client.info["chat"], "id": _user.info["id"]})
                        client.send_xml('m', {'u': str(client.info["id"]), 'd': str(_user.info['id']), 't': '/n', 'p': 'n' + str(sinbintime2), 'i': '0'}, None, 1)
                        database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'uid2': int(_user.info['id']), 'message': '/n', 'reason': 'n' + str(sinbintime2), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info[
                                        'avatar'], 'time': str(int(time.time())), 'pool': client.info['pool'], 'ip': (client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))])), 'port': str(config.CONN_PORT)})
                        client.WriteEvent(client.info["id"], _user.info["id"], client.info[
                                          "chat"], "sb", sinbinnedTime, 0, 0)
                        return _user.joinRoom(False, True)
                    except:
                        # client.notice("Please use the following format\n/n2.5 for 2.5 hours\nMax: 24\nMin: 0.017")
                        return

        else:
            if not 's' in packet:
                packet['s'] = '1'
            if str(packet['s']) is '1':
                pm = 'PM'
            elif str(packet['s']) is '2':
                pm = 'PC'
            else:
                pm = 'PM'
            for blocked in server.config["blockedixats"]:
                if blocked in str(packet['t']).lower().replace(" ", "") or "23.ip-5-196-225" in str(packet['t']).lower().replace(" ", ""):
                    database.insert('advertisers', {'sender': int(client.info['id']), 'recipient': int(_user.info[
                                    'id']), 'message': str(packet['t']), 'chatid': int(client.info['chat']), 'msgtype': str(pm)})
                    return client.send_xml('m', {'t': 'I tried to advertise an ixat in PRIVATE CHAT man, seriously? What was I thinking?', 'u': str(client.info['id']), 'i': '0'}, None, 1)
            if userIsOffline:
                return
            offline = 0
            if True or not client.info["id"] in server.config["staff"] and not int(packet['u']) in server.config["staff"]:
                database.insert('pvtlog', {'sender': int(client.info['id']), 'recipient': int(packet['u']), 'message': str(packet['t']), 'msgtype': str(pm), 'date': int(time.time()), 'offline': offline, 'ip': (
                    client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))]))})
            if not userIsOffline:
                _user.send_xml('p', {'u': str(client.info['id']), 't': (packet['t']), 's': str(packet['s']), 'd': str(_user.info['id'])})
    except:
        print(format_exc())
        pass
