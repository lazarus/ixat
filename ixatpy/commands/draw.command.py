def drawCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        from random import shuffle
        store = server.clients
        shuffle(store)
        del args[0]

        try:
            x = args[0]
        except:
            args = ["nothing"]

        prize = " ".join(args)
        for user in store:
            if user.online == True and not user.info["id"] in server.config['staff'] and user.registered and user.info['chat'] == client.info['chat']:
                return client.send_xml('m', {'t': user.info['username'] + '(' + str(user.info['id']) + ') wins ' + prize + '.', 'u': '0'}, None, 2, True)

        return client.sendxml('m', {'t': 'There is no winner', 'u': '0'}, None, 2, True)
