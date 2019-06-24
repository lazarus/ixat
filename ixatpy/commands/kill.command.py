def killCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            kill = server.getUserByID(args[1], client.info["chat"])
            kill.send_xml('logout')
            kill.disconnect()
            client.send_xml('m', {'t': 'ID killed.', 'u': '0'})
        except:
            client.send_xml('m', {'t': 'There was an error trying to kill that ID', 'u': '0'})
