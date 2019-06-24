def kissCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            k, t = args[1].lower().capitalize(), " " .join(args[2:])
            if len(t) is 0:
                raise ValueError
        except:
            return client.send_xml('m', {'t': 'You must set arguments.', 'u': '0'})
        client.send_xml('a', {'u': str(client.info['id']), 'k': k, 't': t}, None, 1)
