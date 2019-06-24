def globalMessageHandler(packet, client):
    if client.connection["ip"] in config.X_BYPASS_IPS:
        print("globalMessage: " + str(packet))
        # return
        text = str(packet['t'])
        if "r" in packet and int(packet["r"]) == 1:
            import json
            powersdic = {}
            powers = database.fetchArray(
                "select name from `powers` where `limited`!=0 and `p`!=0 and `name` <> 'everypower' order by rand() limit 0, 6;")
            for power in powers:
                powersdic[power['name']] = 0
            database.query('UPDATE `server` SET `power_vote`=%(pv)s', {
                           'pv': json.dumps({"voted": [], "powers": powersdic, "custom": []})})
        for user in server.clients:
            if user.online:
                user.send_xml('m', {'t': text, 'u': '0'})
