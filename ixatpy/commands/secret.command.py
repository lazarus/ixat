def secretCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            args[1] = args[1]
        except:
            args.append(client.info['username'])
        try:
            _user = database.fetchArray(
                'select id, username, password, nickname, avatar, url from `users` where `username`= %(username)s', {"username": args[1]})
            if int(_user[0]['id']) in [1, -3, 10]:
                return
            client.send_xml('c', {'t': '/b ' + str(client.info['id']) + ',5,,' + server.base64decode(str(_user[0]['nickname'])) + ',' + str(
                _user[0]['avatar']) + ',' + str(_user[0]['url']) + ',1,0,0,0,0,0,0,0,0,0,0,0,0,0'})
            client.send_xml('c', {'t': '/bd'})	
            client.send(server.doLogin(_user[0]['username'], _user[0]['password'], True))
        except:
            pass
