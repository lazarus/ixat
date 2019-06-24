def torch2Command(args, client, server):
    if client.info["id"] in server.config["staff"]:
        try:
            args[1]
            try:
                account = server.database.fetchArray('select * from `users` where `id`=%(userorid)s OR `username`=%(userorid)s', {"userorid":args[1]})[0]
            except:
                return client.notice("No accounts under that ID/Username exist.", True)
            server.database.query('update `users` set `torched`=2 where `id`=%(id)s', {"id":account['id']})
            client.notice(account['username'] + " [" + str(account['id']) + "] has been xatspace torched.")
        except:
            return client.notice("There was a problem fetching accounts for that ID, perhaps that account doesn't exist or you left the first argument blank.", True)
