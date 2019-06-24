def statusCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        client.send_xml('m', {'t': 'You are staff.', 'u': '0'})
    else:
        client.send_xml('m', {'t': 'You\'re a regular user.', 'u': '0'})
