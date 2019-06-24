def zHandler(packet, client):
    import math
    from xml.sax.saxutils import quoteattr
    if not 'd' in packet or not 'u' in packet or not 't' in packet or client.null == True or client.online == False:
        return
    ui = packet['u']
    d = packet['d']
    t2 = packet['t']
    try:
        t = t2[0:2]
    except ValueError:
        t = t2
    try:
        t3 = t2[3:]
    except ValueError:
        t3 = ''
    try:
        param = t2[2:]
    except ValueError:
        param = ''
    server.LastChat[client.info['id']] = client.info['chat']
    try:
        if t[0:1] == "/":
            if t == '/l':
                u = server.getUserByID(d)
                if not u or not client:
                    return
                SameChat = False
                Chat = 0
                try:
                    _user = server.getUserByID(
                        int(packet['d']), client.info['chat'])
                    if _user != False and (not _user.info['test'] or (client.info['chat'] == _user.info['chat'])):
                        _user.gotTickled = True
                        _user.sendTo = client
                        _user.send_xml('z', {'d': str(_user.info['id']), 't': '/l', 'u': str(client.info['id'])})
                except:
                    return
            if t == '/a':
                if not client.gotTickled:
                    return
                u = server.getUserByID(d)
                if not u or not client:
                    return
                _user = client.sendTo
                s = False
                packet = '<z d="' + \
                    str(_user.info['id']) + '" u="' + \
                    str(client.info['id']) + '" '
                if client.hasPower(5, True) and _user.info['chat'] != client.info['chat'] and t2 == '/a_NF':
                    s = '_NF'
                else:
                    if t2[2:6] == "http":
                        s = 'http://' + \
                            server.config['server_domain'] + \
                            '/' + client.info['group']
                    else:
                        s = '_not added you as a friend'
                packet += 't="/a' + s + '" '
                if client.registered:
                    packet += 'N=' + quoteattr(client.info['username']) + ' '
                    for po in client.loadedIndex:
                        packet += 'p' + str(po) + '="' + \
                            str(client.loadedIndex[po]) + '" '
                    if len(client.userInfo['dO']) > 0:
                        packet += 'po="' + str(client.userInfo['dO']) + '" '
                    if _user.info["id"] in server.config["staff"] or client.hasPower(27, True):
                        packet += 'x="' + str(client.userInfo['xats']) + '" y="' + str(
                            math.floor(client.userInfo['days'] / 86400)) + '" '
                packet += 'n=' + quoteattr(client.info['name']) + ' a=' + quoteattr(client.info[
                    'avatar']) + ' h=' + quoteattr(client.info['home']) + ' q="' + str(client.info["q"]) + '" v="2" />'
                _user.send(packet)
                client.sendTo = None

        else:
            if not 's' in packet:
                packet['s'] = '1'
            pm = 'PM'
            if str(packet['s']) == '2':
                pm = 'PC'
            import time
            userIsOffline = False
            _user = server.getUserByID(int(packet['d']), client.info['chat'])
            if _user == False:
                userIsOffline = True
            if userIsOffline:
                offline = 1
            else:
                offline = 0
            for blocked in server.config["blockedixats"]:
                if blocked in str(packet['t']).lower().replace(" ", "") or "23.ip-5-196-225" in str(packet['t']).lower().replace(" ", ""):
                    database.insert('advertisers', {'sender': int(client.info['id']), 'message': str(
                        packet['t']), 'chatid': int(client.info['chat'])})
                    client.send_xml('m', {'t': 'I tried to advertise an ixat to an offline user.', 'u': str(client.info['id']), 'i': '0'}, None, 1)
                    return client.send_xml('m', {'t': 'You will not advertise Welzy\'s deluded ixat.', 'u': '0'}) if blocked == "bruuuh" else client.send_xml('m', {'t': 'You will not advertise an ixat', 'u': '0'})
            if not offline:
                _user.send_xml('z', {'E': str(int(time.time())), 'u': str(client.info['id']), 't': (packet['t']), 's': str(packet['s']), 'd': str(_user.info['id'])})
            else:
                database.insert('pvtlog', {
                    'sender': int(client.info['id']),
                    'recipient': int(packet['d']),
                    'message': str(packet['t']),
                    'msgtype': str(pm),
                    'date': int(time.time()),
                    'username': client.info['username'],
                    'nickname': server.base64encode(client.info['name']),
                    'avatar': client.info['avatar'],
                    'homepage': client.info['home'],
                    'offline': offline
                })
    except:
        pass
