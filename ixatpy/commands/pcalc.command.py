def pcalcCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            powerid = int(args[1])
            if powerid >= 0:
                section = powerid >> 5
                subid = 2 ** (powerid % 32)
                client.send_xml('m', {'t': 'ID: ' + str(powerid) + ' | Section: ' + str(section) + ' | Subid: ' + str(subid), 'u': '0'})
            else:
                raise Exception("Bad ID")
        except:
            client.send_xml('m', {'t': 'Power ID must be numeric and not be negative.', 'u': '0'})
