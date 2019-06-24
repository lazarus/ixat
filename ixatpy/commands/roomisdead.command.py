def roomisdeadCommand(args, client):
    from traceback import print_exc

    if server.hasServerMinRank(client.info["id"]):
        for user in server.clients:
            if user.online == True and client.info['chat'] == user.info['chat']:
                try:
                    args[1] = args[1]
                    user.send_xml('rl')
                except:
                    user.disconnect()
