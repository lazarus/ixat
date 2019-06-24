def accountsCommand(args, client, server):
    if client.info["id"] in server.config["staff"]:
        try:
            args[1]
            try:
                account = server.database.fetchArray('select * from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid":args[1]})[0]
            except:
                return client.notice("No accounts under that ID/Username exist.", True)
            accounts = server.database.fetchArray('select * from `users` where `connectedlast`=%(cl)s', {"cl":account['connectedlast']})
            if len(accounts) >= 1:
                listaccounts = []
                for user in accounts:
                    if len(user['username']) >= 1:
                        listaccounts.append(user['username'] + " [" + str(user['id']) + "]")
                if len(listaccounts) >= 1:
                    t = str(len(listaccounts)) + " Account(s): " + " | ".join(listaccounts)
                    if client.info['id'] in [1, 3, 4] and int(account['id']) not in [1, 5, 10]:
                        t = "Connected Last IP: " + account['connectedlast'] + " | " + t
                    client.notice(t, True)
                else:
                    client.notice("No accounts found.", True)
        except:
            return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)
