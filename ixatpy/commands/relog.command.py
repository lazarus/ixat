def relogCommand(args, client):
    if client.online and client.registered and not client.null:
        try:
            args[1] = args[1]
        except:
            args.append(client.info['username'])

        try:
            if server.hasServerMinRank(client.info["id"]):
                args[1] = args[1]
            else:
                args[1] = client.info['username']
            _user = database.fetchArray(
                'select id, username, password from `users` where `username`=%(username)s or `id`=%(username)s', {"username": args[1]})
            online = server.getUserByID(_user[0]['id'], client.info['chat'])

            if (online != False):
                online.send(server.doLogin(_user[0]['username'], _user[0]['password']))
        except:
            pass
