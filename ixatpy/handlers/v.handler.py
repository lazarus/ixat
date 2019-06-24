def vHandler(packet, client):
    import logging

    success = 0
    n = str(packet['n']) if 'n' in packet else False
    p = packet['p'].replace("$", "") if 'p' in packet else False

    if int(client.yPacket["r"]) == 9 and p == '0':
        _user = database.fetchArray('select username, password from `users` where `id`=%(id)s and `connectedlast`=%(ip)s', {
                                    'id': int(n), 'ip': str(client.connection['ip'])})
        if _user != False:
            success = 1
            v = server.doLogin(_user[0]['username'], _user[0]['password'], False)
            client.send(v)
            client.send_xml('ldone')
        else:
            client.send_xml('v', {'e': '8'})
    else:
        if not client.online:
            v = server.doLogin(n, p, False, True)

            if v:
                success = 1
                client.send(v)
                if int(client.yPacket["r"]) == 8:
                    _user = database.fetchArray('select id, nickname, avatar, url from `users` where `username`=%(username)s', {'username': n})
                    client.send_xml('i', {'r': '8'})
                    client.send_xml('c', {'t': '/b ' + str(_user[0]["id"]) + ",0,0," + server.base64decode(str(_user[0]["nickname"])) + "," + str(_user[0]["avatar"]) + "," + str(_user[0]["url"]) + ',0,0'})
                    client.send_xml('done')
            else:
                client.send_xml('v', {'e': '8'})

    from time import time
    database.query("INSERT INTO `loginlogs` (`ip`,`from`,`username`,`success`,`time`) values (%(ip)s, 'v_packet', %(user)s, %(success)s, %(time)s)", {
                   "ip": client.connection["ip"], "user": n, "success": success, "time": int(time())})
