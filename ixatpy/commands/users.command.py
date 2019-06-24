def usersCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        count = 0

        for user in server.clients:
            if user.online:
                count += 1

        client.send_xml('m', {'t': str(count) + ' connections online.', 'u': '0'})
