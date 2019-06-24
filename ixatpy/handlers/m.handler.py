def mHandler(packet, client):
    import time
    import json
    import os

    if client.null:
        return
    elif client.online:
        if client.info["banned"]:
            return

        message = str(packet["t"])

        if client.info['away'] and message != '/back':
            return

        if client.RapidMessageCheck(message, 10.0, 0, client.info['id'], int(client.info['chat'])):
            return client.send_xml('m', {'t': 'Packet Blocked due to limit', 'u': '0', 's': '0'}) # limit messages

        if message[0:1] == '/':
            if message[0:3] == "/ka" and client.hasMinRank(client.info['rank'], 'ka') and client.hasPower(244, True):
                '''
                KICKALL_GUEST 0x100
                KICKALL_REG 0x200
                KICKALL_MUTE 0x300
                KICKALL_BAN 0x400
                '''
                KickAllFlags = 0x100
                KickAllPool = int(client.info['pool'])
                if 'p' in message:
                    KickAllPool = -1  # all pools
                if 'r' in message:
                    KickAllFlags += 0x200
                if 'm' in message:
                    KickAllFlags += 0x300
                if 'b' in message:
                    KickAllFlags += 0x400

                try:
                    client.KickAll(
                        client.info['chat'], KickAllPool, KickAllFlags)
                    client.send_xml('m', {'t': str(message), 'u': str(client.info['id']), 'd': '1'}, None, 1)
                except Exception as e:
                    client.send_xml('m', {'t': e, 'u': '0'}, None, 1)

                client.WriteEvent(
                    client.info["id"], -1, client.info["chat"], "ka", 0, message[3:], 0)

            elif message[0:2] == "/h" and client.info['rank'] in [1, 4] and client.hasPower(51, True):
                Hush = {"message": "", "seconds": "", "time": 0,
                        "userid": client.info['id'], "rank": client.info['rank']}
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

                client.send_xml('m', {'t': '(HUSH#w' + str(int(Hush["seconds"])) + '#)I have hushed the chat for ' + str(int(Hush["seconds"])) + " seconds" + str(Hush["message"]), 'u': str(client.info['id'])}, None, 1)
                database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'message': '(HUSH#w' + str(int(Hush["seconds"])) + '#)I have hushed the chat for ' + str(int(Hush["seconds"])) + " seconds" + str(Hush["message"]) + '', 'name': client.info['name'], 'registered': client.info[
                                'username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info["pool"], 'port': str(config.CONN_PORT), 'ip': (client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))]))})
                Hush["time"] = int(int(time.time()) + int(Hush["seconds"]))
                database.query("UPDATE `chats` SET `hush` = %(hush)s WHERE `id` = %(id)s", {
                               'hush': json.dumps(Hush), "id": client.info['chat']})
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
                client.WriteEvent(
                    client.info["id"], -1, client.info["chat"], "hu", Hush["seconds"], 0, 0)
            elif message[0:3] == '/ri' and client.hasMinRank(client.info['rank'], 'rl'):
                ranklock = server.json_load(database.fetchArray(
                    "SELECT `ranklock` FROM `chats` WHERE id = %(id)s", {"id": client.info["chat"]})[0]['ranklock'])
                if ranklock == None:
                    return client.notice("There are no ranklocked users.", True)
                ranklocked = ""
                for rlduserid, rldrank in ranklock.items():
                    ranklocked += str(rlduserid) + ": " + str(rldrank) + " | "
                client.notice(ranklocked[:-2], True)
            elif message[0:2] == '/r' and client.hasMinRank(client.info['rank'], 'ka') and client.hasPower(391, True):
                try:
                    ranklockdata = message[2:256].strip().split(" ")
                    rlduserid = str(int(ranklockdata[0].strip()))
                    rldrank = str(ranklockdata[1]).lower()
                    if not rldrank in ['guest', 'member', 'moderator', 'owner', 'off']:
                        return client.notice("Rank does not exist.", True)
                    ranklock = server.json_load(database.fetchArray(
                        "SELECT `ranklock` FROM `chats` WHERE id = %(id)s", {"id": client.info["chat"]})[0]['ranklock'])
                    if ranklock == None:
                        ranklock = {}
                    try:
                        targetRank = int(database.fetchArray("SELECT `f` FROM `ranks` WHERE chatid=%(chatid)s and userid=%(userid)s", {
                                         "chatid": client.info["chat"], "userid": rlduserid})[0]["f"])
                    except:
                        targetRank = 5
                    if (rldrank == "owner" and client.info['rank'] == 4) or (targetRank == 1) or (targetRank == 4 and client.info['rank'] == 4):
                        return
                    import json
                    if rldrank == 'off' and rlduserid in ranklock.keys():
                        del ranklock[rlduserid]
                    else:
                        ranklock[rlduserid] = rldrank
                        database.query('delete from `ranks` where `userid`=%(userid)s and `chatid`=%(chatid)s', {
                                       "userid": rlduserid, "chatid": client.info["chat"]})
                        database.query('insert into `ranks`(`userid`, `chatid`, `f`, `sinbin`) values(%(userid)s, %(chatid)s, %(f)s, 0);', {
                                       "userid": rlduserid, "chatid": client.info["chat"], "f": {"guest": 5, "member": 3, "moderator": 2, "owner": 4}[rldrank]})
                    database.query("update `chats` set `ranklock` = %(rl)s where `id` = %(id)s", {
                                   "rl": json.dumps(ranklock), "id": client.info["chat"]})
                    client.notice(str(rlduserid) +
                                  " ranklock: " + str(rldrank), True)
                    targetUser = server.getUserByID(
                        rlduserid, client.info['chat'])
                    if targetUser != False and targetUser.info["chat"] == client.info["chat"]:
                        pool = targetUser.getPool(
                            targetUser.info['pool'], True)
                        targetUser.info['ChangePool'] = int(pool)
                        if pool != targetUser.info['pool']:
                            targetUser.send_xml('l', {'u': str(targetUser.info['id'])}, None, 1)
                            targetUser.joinRoom(True, False)
                        else:
                            targetUser.joinRoom(False, True)
                except:
                    client.notice(
                        "You must use that command in this format: /r [userid] [rank]", True)
            elif message[0:2] == '/i':
                if client.info['temp'] != 0:
                    timex = round(
                        float(float(client.info['temp'] - time.time()) / 3600), 2)
                    if timex >= 0:
                        client.info['info']['temp'] = "_/temp " + \
                            str(timex) + " hours"
                if len(client.info['info']) > 0:
                    info = client.info['info']
                    if int(client.info['chat']) in server.Protected:
                        info['/p'] = "_/p " + \
                            str(server.Protected[
                                int(client.info['chat'])]['id'])
                    client.send_xml('m', {'t': " ".join(client.info['info'].values()), 'u': '0'})
            elif (message == '/RTypeOn' or message == '/RTypeOff') and client.hasPower(172, True):
                if client.hidden:
                    client.info['KeepPool'] = True
                    client.joinRoom(False, True)
                client.info["typing"] = (message == '/RTypeOn')
                client.sendMessage(message)
            elif message == '/away' and not client.info["away"] and client.hasPower(144, True):
                client.info["away"] = True
                if client.hasPower(29, True) and client.hidden == True:
                    client.hidden = False  # masked hidden
                elif client.hasPower(29, True) and client.hidden == False:
                    client.hidden = True
                client.info['KeepPool'] = True
                client.joinRoom(False, True)
            elif message == '/back' and client.info["away"] and client.hasPower(144, True):
                client.info["away"] = False
                if client.hasPower(29, True) and client.hidden == True:
                    client.hidden = False  # masked hidden
                elif client.hasPower(29, True) and client.hidden == False:
                    client.hidden = True
                client.info['KeepPool'] = True
                client.joinRoom(False, True)

            elif message[0:3] == '/go':
                name = message[3:].replace(" ", "")
                if len(name) < 1:
                    client.notice("NO NAME")
                    return

                if name.isdigit():
                    chat = database.fetchArray(
                        "SELECT `id` FROM `chats` WHERE id=%(id)s", {"id": name})
                elif name[0:3] == 'xat' and name[3:].isdigit():
                    name = name[3:]
                    chat = database.fetchArray(
                        "SELECT `id` FROM `chats` WHERE id=%(id)s", {"id": name})
                else:
                    chat = database.fetchArray(
                        "SELECT `id` FROM `chats` WHERE name=%(name)s", {"name": name})

                if not chat:
                    client.notice("NO CHAT: [" + name + "]")
                    return
                else:
                    client.send_xml('l', {'u': str(client.info['id'])}, None, 1)
                    client.send_xml('q', {'qt': 'Q12', 'r': str(chat[0]['id']), 'd2': '0', 'p2': ''})
                    #client.info['chat'] = str(chat[0]['id'])
                    #client.yPacket['r'] = str(chat[0]['id'])
					#<q qt=\"Q12\" r=\"%d\" d2=\"%d\" p2=\"%s\" />
                    #client.send('<q r="' + str(chat[0]['id']) + '" u="' + str(client.info['id']) + '"/>')
                    #client.joinRoom(True)
            elif message[0:2] == '/g' and client.hasPower(32, True) and client.info["rank"] != 5:
                if client.hidden:
                    client.info['KeepPool'] = True
                database.query('delete from `ranks` where `userid`=%(userid)s and `chatid`=%(chatid)s', {
                               "userid": client.info["id"], "chatid": client.info["chat"]})
                client.WriteEvent(
                    client.info["id"], -1, client.info["chat"], "gs", 0, 0, 0)
                client.joinRoom(False, True)
            elif message[0:2] == '/s' and client.hasMinRank(client.info['rank'], 'ss'):
                if client.hidden:
                    client.info['KeepPool'] = True
                    client.joinRoom(False, True)
                scroll = message[2:256]
                database.query("update `chats` set `sc` = %(sc)s, `ch` = %(ch)s where `id` = %(id)s", {
                               "sc": scroll, "ch": client.info["id"], "id": client.info["chat"]})
                clients = server.clients
                for _client in clients:
                    if _client.info['chat'] == client.info['chat'] and client.info['pool'] == _client.info['pool'] and _client.info['rank'] in [1, 2, 4]:
                        _client.send_xml('m', {'t': '/s' + str(scroll), 'u': str(client.info["id"])})
                        _client.info['info']['/s'] = "_/s " + \
                            str(client.info['id'])
                    elif _client.info['chat'] == client.info['chat'] and _client.info['rank'] in [1, 2, 4]:
                        _client.send_xml('m', {'t': '/s' + str(scroll), 'u': '0'})
                        _client.info['info']['/s'] = "_/s " + \
                            str(client.info['id'])
                client.WriteEvent(
                    client.info["id"], -1, client.info["chat"], "ss", 0, scroll, 0)
            elif message[0:2] == '/d' and client.info["rank"] in [1, 2, 4]:  # delete messages
                if client.hidden:
                    client.info['KeepPool'] = True
                    client.joinRoom(False, True)
                mid = int(message[2:256])
                database.query('update `messages` set visible=0 where id = %(id)s and mid = %(mid)s and port = %(port)s', {
                               "id": client.info['chat'], "mid": int(mid), "port": config.CONN_PORT})
                client.send_xml('m', {'t': '/d' + str(int(mid)), 'u': '0', 'T': str(int(time.time())), 'r': str(client.info['chat'])}, None, 1)
            elif message[0:2] == '/p' and client.hasMinRank(client.info['rank'], 'p'):
                cmd = ""
                try:
                    cmd = message[2]
                except:
                    pass

                if int(client.info['chat']) in server.Protected:
                    if time.time() - server.Protected[int(client.info['chat'])]['start'] < 15:
                        '''
                        left = int(15 - (time.time() - server.Protected[int(client.info['chat'])]['start']))
                        return client.send('<m u="0" t="Protection cant be disabled for ' + str(left) + ' seconds" />')
                        '''
                        return
                    del server.Protected[int(client.info['chat'])]
                    client.send_xml('m', {'u': '0', 't': 'Protect Deactivated!(' + str(client.info['id']) + ')'}, None, 1)
                else:
                    parr = {'1': 'default', '2': 'g',
                            '3': 'c', '4': 'r', '5': 'm'}
                    ptype = parr[str(client.groupControl['pd'])]
                    ptime = time.time() + (int(client.groupControl['pt']) * 3600)
                    if cmd == 'm' or cmd == '5':
                        ptype = 'm'
                    elif cmd == 'r' or cmd == '4':
                        ptype = 'r'
                    elif cmd == 'c' or cmd == '3':
                        ptype = 'c'
                    elif cmd == 'g' or cmd == '2':
                        ptype = 'g'

                    server.Protected[int(client.info['chat'])] = {"start": time.time(
                    ), "end": ptime, "type": ptype, 'id': client.info['id']}
                    if ptype == 'default':
                        client.send_xml('m', {'u': '0', 't': 'Protect Activated! - for the next ' + str(int(int(client.groupControl['pt']) * 60)) + ' minutes.(' + str(client.info['id']) + ')'}, None, 1)
                    else:
                        client.send_xml('m', {'u': '0', 't': 'Protect Activated! /p' + ptype + '(' + str(client.info['id']) + ')'}, None, 1)

        else:
            if len(message) > 0:
                if client.info['members_only'] and client.info['rank'] == 5:
                    return
                if client.info['redcard']:
                    banned = ((client.info[
                              "rc_bannedtime"] - (float(time.time()) - client.info["joinTime"])) * int(client.groupControl['rf']))
                    bannedfor = float(time.time()) + banned
                    database.query("delete from `bans` where chatid=%(chatid)s and userid=%(userid)s and special=%(special)s", {
                                   "chatid": client.info["chat"], "userid": client.info['id'], "special": 367})
                    database.insert('bans', {'chatid': client.info["chat"], 'userid': client.info[
                                    "id"], 'unbandate': bannedfor, 'ip': client.connection['ip'], 'type': "g", 'special': 0})
                    database.insert('messages', {'visible': '1', 'id': str(client.info['chat']), 'uid': int(client.info['id']), 'uid2': int(client.info['id']), 'message': "/gr" + str(int(banned)), 'reason': "(redcard)", 'name': client.info[
                                    'name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info["pool"], 'ip': client.connection["ip"], 'port': str(config.CONN_PORT)})
                    oldpool = client.info["pool"]
                    client.send_xml('m', {'t': '/gr' + str(int(banned)), 'p': '(redcard)', 'u': str(client.info['id']), 'd': str(client.info['id'])}, None, 1, True)
                    client.send_xml('l', {'u': str(client.info['id'])}, None, 1)
                    client.joinRoom(False, True)
                    newpool = client.info["pool"]
                    if oldpool != newpool:
                        client.send_xml('m', {'t': '/gr' + str(int(banned)), 'p': '(redcard#)', 'u': str(client.info['id']), 'd': str(client.info['id'])})
                    return
                if client.info['GaggedTime'] != 0:
                    if (client.info['GaggedTime'] - time.time()) > 0:
                        return client.send_xml('m', {'t': 'You\'re still gagged', 'u': '0'})
                if client.info['HushedTime'] != 0:
                    if (client.info['HushedTime'] - time.time()) > 0:
                        return client.send_xml('m', {'t': 'You\'re still hushed.', 'u': '0'})

                if client.info["Naughty"]:
                    nt = int(time.time()) - client.info["NaughtyTime"]
                    if (nt < 30):
                        return client.send_xml('m', {'t': 'You still have ' + str(30 - nt) + ' seconds before you can chat again. [Naughtystep]', 'u': '0'})
                    client.info["NaughtyTime"] = int(time.time())

                if False:
                    for blocked in server.config["blockedixats"]:
                        if blocked in str(message).lower().replace(" ", "") or "23.ip-5-196-225" in str(message).lower().replace(" ", ""):
                            database.insert('advertisers', {'sender': int(client.info['id']), 'message': str(
                                message), 'chatid': int(client.info['chat'])})
                            client.send_xml('m', {'t': 'I tried to advertise an ixat.', 'u': str(client.info['id']), 'i': '0'}, None, 1)
                            return client.send_xml('m', {'t': 'You will not advertise Welzy\'s deluded ixat.', 'u': '0'}) if blocked == "bruuuh" else client.send_xml('m', {'t': 'You will not advertise an ixat.', 'u': '0'})

                if client.info['rank'] == 5 and "l" in packet.keys() and int(packet["l"]) == 1:
                    return client.send_xml('m', {'t': 'Guests cannot post links.', 'u': '0'})

                '''
                check if atleast member
                check if bot already in chat
                check if on app
                check if app is game
                check if user has power
                '''
                try:
                    app = int(client.info['app'])
                    isApp = app > 60000 and client.hasPower(
                        (app % 10000) - 1, True)
                    hasRank = client.hasMinRank(client.info['rank'], 3)
                    botInRoom = server.getUserByID(804, client.info['chat'])
                    isAssigned = client.Assigned((app % 10000) - 1)

                    # and isAssigned and isApp and hasRank and botInRoom is
                    # False:
                    if message[0:4].lower() == '!bot':
                        try:
                            lang = message.split(" ")[1].lower().strip()
                        except:
                            lang = "en"

                        if len(lang) < 2:
                            lang = "en"
                        cInfo = client.info
                        #test = os.system("php /root/gamebot/GameBot.php 1 10 60193 0 3 randomstring >/root/gamebot/g.txt 2>&1 &")
                        os.system("php /root/gamebot/GameBot.php " + str(cInfo['chat']) + " " + str(cInfo['id']) + " " + str(
                            cInfo['app']) + " " + str(cInfo['pool']) + " 3 " + str(lang[0:2]) + " >/root/gamebot/g.txt 2>&1 &")
                        client.send_xml('m', {'t': '[' + lang.upper() + ']Gamebot should of started', 'u': '0'})
                    elif message[0:4] == '!bot' and botInRoom:
                        client.send_xml('m', {'t': 'GameBot already started', 'u': '0'})
                    elif message[0:4] == '!bot' and hasRank is False:
                        client.send_xml('m', {'t': 'not high enough rank', 'u': '0'})
                    elif message[0:4] == '!bot' and isApp is False:
                        client.send_xml('m', {'t': 'Not on game app or dont have power', 'u': '0'})
                    elif message[0:4] == '!bot' and isAssigned is False:
                        client.send_xml('m', {'t': 'power needed not assigned', 'u': '0'})
                except:
                    pass

                if client.hidden:
                    client.info['KeepPool'] = True
                    client.joinRoom(False, True)

                try:
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
                    alias = False

                    if client.info['id'] in server.config["staff"]:
                        if commandcode in config.X_COMMAND_PREFIXS:
                            if commandcode2 == config.X_COMMAND_PREFIX_HIDDEN or commandcode == commandcode2:
                                startat = 2
                                send = False

                    if send:
                        if client.info['live_mode'] == True and client.info['rank'] == 5:
                            reg = ''
                            if "N" in client.info.keys():
                                reg = 'N="' + str(client.info['N']) + '" '
                            client.sendLive('<x i="40000" ' + str(reg) + 't="' + str(message) + '" u="' + str(client.info['id']) + '" q="1" n="' + str(
                                client.info['name']) + '" a="' + str(client.info['avatar']) + '" h="' + str(client.info['home']) + '" v="0" />')
                        else:
                            client.sendMessage(message)
                        #client.sendRoom('<x H="3883216726" j="32651" i="40000" t="' + str(message) + '" u="17092" q="1" n="' + client.info['name'] + '" a="' + client.info['avatar'] + '" h="" v="0" />')
                        #client.sendRoom('<m t="'+message+'" u="'+str(client.info['id'])+'" i="0" />')
                        database.insert('messages',
                                        {'visible': '1', 'id': str(client.info['chat']), 'uid': str(client.info['id']), 'message': str(message), 'name': client.info['name'], 'registered': client.info['username'], 'avatar': client.info['avatar'], 'time': str(int(time.time())), 'pool': client.info["pool"], 'ip': (client.connection["ip"] if not client.info["id"] in server.config["staff"] else ".".join([y if x in [0, 3] else "***" for x, y in enumerate(client.connection["ip"].split("."))])), 'port': str(config.CONN_PORT)})

                    if commandcode in config.X_COMMAND_PREFIXS:
                        if command[0][startat:].lower() in config.X_COMMAND_ALIAS:
                            alias = True
                            command[0] = str(
                                command[0][0:startat]) + config.X_COMMAND_ALIAS[command[0][startat:].lower()]
                            # allows alias with spaces to work
                            command = (" ".join(command)).split(" ")
                        # if commandcode2 == "z" or commandcode ==
                        # commandcode2:

                        if len(command[0][startat:]) < 1:
                            return

                        writemsg = client.info['username'] + "(" + str(client.info['id']) + ") used command: [" + command[
                            0][startat:].lower() + "], RAW: [" + message + "]"
                        if alias:
                            writemsg += ", Alias: [" + \
                                (" ".join(command)) + "]"

                        sCall = server.call(
                            command[0][startat:].lower(), "command", command, client)
                        if not sCall:
                            writemsg = client.info['username'] + "(" + str(client.info['id']) + ") used an invalid command: [" + command[
                                0][startat:].lower() + "], RAW: [" + message + "]"
                            client.send_xml('m', {'t': 'We dont have this command sorry', 'u': '0'})

                        server.write(writemsg, "Commands")
                except:
                    pass

                    if client.info["Naughty"]:
                        client.info['KeepPool'] = True
                        client.joinRoom(False, True)
