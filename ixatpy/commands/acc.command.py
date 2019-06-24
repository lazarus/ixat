def accCommand(args, client):
    from urllib.request import urlopen
    import json
    if server.hasServerMinRank(client.info["id"]) or client.info["id"] == 25:
        ip = ""
        try:
            args[1]
            try:
                account = database.fetchArray(
                    'select id, connectedlast from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid": args[1]})[0]
                ip = account["connectedlast"]
            except:
                # return client.notice("No accounts under that ID/Username
                # exist.", True)
                ip = server.getUserByID(args[1], client.info['chat']).connection["ip"]
            if not ip:
                return client.notice("User is not online/doesn't exist", True)
            if int(account['id']) in config.X_DEVS and int(account["id"]) != int(client.info["id"]):
                return client.notice("I'd rather you not.", True)
            response = urlopen("http://ip-api.com/json/" + ip)
            whois = json.loads(response.read().decode("UTF-8"))
            whois2 = ', '.join('{}: {}'.format(key.upper(), val)
                               for key, val in whois.items())
            accounts = database.fetchArray('select id, username, email from `users` where `connectedlast`=%(cl)s', {
                                           "cl": account['connectedlast']})
            if len(accounts) >= 1:
                listaccounts = []
                for user in accounts:
                    if len(user['username']) >= 1:
                        listaccounts.append(
                            user['username'] + " [" + str(user['id']) + "]")
                if len(listaccounts) >= 1:
                    t = str(len(listaccounts)) + " Account(s): " + \
                        " | ".join(listaccounts)
                    client.notice(t, True)
                else:
                    client.notice("No accounts found.", True)
        except:
            return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)
