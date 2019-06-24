def whoisCommand(args, client):
    from urllib.request import urlopen
    import json
    if server.hasServerMinRank(client.info["id"]) and int(client.info["id"]) not in [7]:
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
            client.notice("WHOIS: " + str(whois2), True)
            accounts = database.fetchArray('select id, username, email from `users` where `connectedlast`=%(cl)s', {
                                           "cl": account['connectedlast']})
            if len(accounts) >= 1:
                listaccounts = []
                for user in accounts:
                    if len(user['username']) >= 1:
                        listaccounts.append(
                            user['username'] + " [" + str(user['id']) + "] Email: " + user['email'])
                if len(listaccounts) >= 1:
                    t = str(len(listaccounts)) + " Account(s): " + \
                        " | ".join(listaccounts)
                    if client.info['id'] in [1, -3, 10]:
                        t = "Connected Last IP: " + \
                            account['connectedlast'] + " | " + t
                    client.notice(t, True)
                else:
                    client.notice("No accounts found.", True)
        except:
            return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)
