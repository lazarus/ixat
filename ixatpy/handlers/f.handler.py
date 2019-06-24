def fHandler(packet, client):
    import logging
    #logging.info(str(packet))
    if client.online:
        if "o" in packet:  # legacy
            friends = packet["o"].split(" ")
            online = []
            for user in server.clients:
                if user.online and (user.info["id"] != client.info["id"] and str(user.info["id"]) in friends and not str(user.info["id"]) in online):
                    # if not (user.hidden and user.info['chat'] ==
                    # client.info['chat'] and user.info['pool'] ==
                    # client.info['pool']):
                    if not user.hidden:
                        online.append(str(user.info["id"]))
            if len(online) > 0:
                client.send_xml('f', {'v': ','.join(online)})
        else:
            friends = []
            for id in packet:
                if id.isnumeric():
                    friends.append(id)

            online = []
            for user in server.clients:
                if user.online and (user.info["id"] != client.info["id"] and str(user.info["id"]) in friends and not str(user.info["id"]) in online):
                    # if not (user.hidden and user.info['chat'] ==
                    # client.info['chat'] and user.info['pool'] ==
                    # client.info['pool']):
                    if not user.hidden:
                        if user.info["id"] in server.config["staff"]:
                            # Available
                            online.append("0" + str(user.info["id"]))
                        else:
                            online.append(str(user.info["id"]))
            if len(online) > 0:
                client.send_xml('f', {'v': ','.join(online)})
