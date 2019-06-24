def ghostCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        if client.info["id"] in config.X_DEVS:
            try:
                _user = args[1]
                del args[1]
                del args[0]
                message = " ".join(args)
            except:
                return client.send_xml('m', {'t': 'Usage: qghost USERNAME MESSAGE', 'u': '0'})

            uRow = database.fetchArray('select `id` from `users` where `username`= %(username)s', {"username": _user})

            if len(uRow) == 1:
                try:
                    '''
                    if uRow[0]['id'] in config.X_DEVS:
                            return client.send('<m t="Sorry the only staff you can scare is Daniel ;)" u="0" />')
                    '''
                    user = server.getUserByID(uRow[0]['id'], client.info['chat'])
                    if user != False:
                        user.send_xml('mt', {'t':  message})
                        client.send_xml('m', {'t': 'Mission Complete', 'u': '0'})
                    else:
                        client.send_xml('m', {'t': 'User not in this chat or is offline', 'u': '0'})
                except:
                    return client.send_xml('m', {'t': 'Error', 'u': '0'})
            else:
                client.send_xml('m', {'t': 'User Not Found', 'u': '0'})
        else:
            client.send_xml('m', {'t': 'We dont have this command sorry', 'u': '0'})