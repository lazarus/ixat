def renewCommand(args, client):
    from random import randint
    if server.hasServerMinRank(client.info["id"]):
        newk = randint(-1000000, 1000000)
        newk2 = randint(-1000000, 1000000)
        newk3 = randint(-1000000, 1000000)
        uid = client.info["id"]
        database.query('update `users` set `k`=%(k1)s, `k2`=%(k2)s, `k3`=%(k3)s where `id`=%(uid)s', {
                       "k1": newk, "k2": newk2, "k3": newk3, "uid": uid})
        _user = database.fetchArray(
            'select `id`, `username`, `password` from `users` where `id`=%(uid)s', {'uid': uid})
        online = server.getUserByID(_user[0]['id'], client.info['chat'])
        if online != False:
            online.sendPacket(server.doLogin(
                _user[0]['username'], _user[0]['password'], False))
            client.notice("Your User info has been changed.", True)
