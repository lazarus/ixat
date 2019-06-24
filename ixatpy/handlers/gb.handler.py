def gbHandler(packet, client):
    him = server.getUserByID(int(packet['u']), int(packet['r']))
    if(client.online is False and him != False and him.online and not him.null):
        ban = database.fetchArray('select `unbandate` from `bans` where `chatid`=%(r)s and (`userid`=%(id)s or `ip`=%(ip)s) and `special`=%(special)s;', {
                                  "r": packet['r'], "id": him.info['id'], "ip": him.connection['ip'], "special": packet["w"]})
        import base64
        from time import time
        usf = base64.b64encode(
            (str(packet['w']) + str(packet['d']) + str(packet['h'])).encode("utf-8")).decode("utf-8")
        duration = int(packet['d'])
        hashs = server.phash("sha1", usf)
        if(len(ban) > 0 and packet['k'] == hashs):
            if int(packet['w']) in server.gameBans:
                v = str(packet['w']) + ',' + \
                    str(duration) + ',' + str(packet['h'])
                database.query('delete from `bans` where `chatid`=%(r)s and (`userid`=%(userid)s or `ip`=%(ip)s) and `special`=%(special)s;', {
                               "r": packet['r'], "userid": him.info['id'], "ip": him.connection['ip'], "special": packet["w"]})
                him.info['GameBanData'] = []
                him.send_xml('c', {'u': '0', 'd': str(him.info['id']), 't': '/u'})
                him.send_xml('m', {'d': str(him.info['id']), 'u': str( him.info['id']), 't': '/u', 'p':str(v)}, None, 1, False)
                him.WriteEvent(-1, him.info["id"], him.info["chat"], "u", time() - int(ban[0]["unbandate"]), packet["h"], packet["w"])
                him.joinRoom(False, True)
