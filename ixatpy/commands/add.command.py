def addCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            com = args[1].lower()
        except:
            return

        del args[1]

        args = (" ".join(args)).split(" ")

        if com == "xats":
            try:
                args[1] = args[1]
                args[2] = args[2]
                float(args[2])
            except:
                return client.send_xml('m', {'t': 'You must set arguments and xats must be numeric', 'u': '0'})

            uRow = database.fetchArray(
                'select `id`, `username`, `password` from `users` where `username`= %(username)s', {"username": args[1]})

            if len(uRow) == 1:
                try:
                    float(args[2])
                    database.query('update `users` set `xats` = `xats`+%(xats)s where `username` = %(username)s', {
                                   "xats": args[2], "username": args[1]})
                    user = server.getUserByID(uRow[0]['id'], client.info['chat'])
                    if user != False:
                        user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))
                    client.send_xml('m', {'t': 'Successfuly added ' + str(args[2]) + ' xat(s) to ' + str(uRow[0]['username']) + '(' + str(uRow[0]['id']) + ')', 'u': '0'})
                except:
                    pass
        if com == "power":
            if len(args) >= 3:
                try:
                    count = int(args[3])
                    # if count <= 0:
                    #	return
                except:
                    count = 1
                _user = database.fetchArray(
                    'select `username`, `id`, `password` from `users` where `username`=%(un)s', {'un': args[1]})
                power = database.fetchArray(
                    'select `id` from `powers` where `name`=%(pn)s', {'pn': args[2]})

                if len(_user) == 1 and len(power) == 1:
                    if int(power[0]['id']) < 0:
                        power[0]['id'] = str(abs(int(power[0]['id'])) + config.X_CUSTOM_OFFSET)
                    server.AddUserPower(_user[0]['id'], power[0]['id'], count)
                    online = server.getUserByID(_user[0]['id'], client.info['chat'])
                    if online != False:
                        online.sendPacket(server.doLogin(_user[0]['username'], _user[0]['password']))
