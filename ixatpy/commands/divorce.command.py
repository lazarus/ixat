def divorceCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            uname = args[1]
        except:
            return client.send_xml('m', {'t': 'Sorry', 'u': '0'})

        try:
            _user = database.fetchArray(
                'select id, username, password, d2 from `users` where `username`= %(username)s', {"username": uname})
            if int(_user[0]['d2']) == 0 or uname in server.config["staff"]:
                return client.send_xml('m', {'t': 'Sorry', 'u': '0'})
            database.query("update `users` set `d0` = '0', `d2` = '0' where `id` = %(id)s", {
                           "id": _user[0]['id']})
            online = server.getUserByID(_user[0]['id'], client.info['chat'])
            if (online != False):
                online.send_xml('a', {'u': str(_user[0]['id']), 'k': 'Divorced', 't': 'Cuz youre a nigga'}, None, 1)
                online.send_xml('a', {'u': str(_user[0]['id']), 'k': 'Divorced', 't': 'Cuz youre a nigga'})
                online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
        except:
            pass
