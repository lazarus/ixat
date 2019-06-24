def pvoteCommand(args, client):
    try:
        com = args[1].lower()
    except:
        com = ""

    if server.hasServerMinRank(client.info["id"]):
        if com == "refresh":
            import json
            powersdic = {}
            powers = database.fetchArray(
                "select name from `powers` where `limited`!=0 and `p`!=0 and and `name` <> 'everypower' order by rand() limit 0, 6;")
            for power in powers:
                powersdic[power['name']] = 0
            database.query('UPDATE `server` SET `power_vote`=%(pv)s', {
                           'pv': json.dumps({"voted": [], "powers": powersdic, "custom": []})})
            client.send_xml('m', {'t': 'Power vote system refreshed.', 'u': '0'})

    if client.registered and (com == "vote" or com == "status"):
        import json
        power_vote = json.loads(database.fetchArray(
            'select power_vote from `server`;')[0]['power_vote'])
        powers = power_vote['powers']
        if com == "status":
            p = ""
            for power in powers.keys():
                p += power + ": " + str(powers[power]) + ", "
            client.send_xml('m', {'t': '[Power: votes]: ' + p.strip(", "), 'u': '0'})
        elif com == "vote":
            if not client.info['id'] in power_vote['voted']:
                power = str(args[2].lower())
                myRow = database.fetchArray('select xats from `users` where `id`= %(id)s', {
                                            "id": client.info['id']})[0]
                xats = myRow['xats']
                #referrals = int(myRow['referrals'])
                # if referrals < 1:
                # return client.send('<m t="To vote you must have at least 1
                # referral." u="0" />')
                try:
                    cost = database.fetchArray("select cost from `powers` where `name` = %(power)s and `limited`!=0 and `p`!=0 and `name` <> 'blackfriday'", {
                                               "power": power})[0]['cost']
                except:
                    return client.send_xml('m', {'t': 'Power wasn\'t a power or isn\'t limited.', 'u': '0'})
                if int(xats) < int(cost):
                    return client.send_xml('m', {'t': 'You cannot vote on a power you cannot buy.', 'u': '0'})
                if not power in powers.keys():
                    powersarr = []
                    powers2 = database.fetchArray(
                        "select name from `powers` where `limited`!=0 and `p`!=0 and `name` <> 'everypower'")
                    for powerx in powers2:
                        powersarr.append(powerx['name'])
                    if power in powersarr:
                        powers[power] = 0
                        power_vote['powers'][power] = 0
                        power_vote['custom'].append(power)
                    else:
                        return client.send_xml('m', {'t': 'Power wasn\'t a power or isn\'t limited.', 'u': '0'})
                if power in powers.keys():
                    if not power in power_vote['custom']:
                        power_vote['powers'][power] += 1
                    else:
                        power_vote['powers'][power] += 0.5
                    power_vote['voted'].append(client.info['id'])
                    database.query('UPDATE `server` SET `power_vote`=%(pv)s', {
                                   'pv': json.dumps(power_vote)})
                    client.send_xml('m', {'t': 'You have voted on ' + power + '.', 'u': '0'})
                else:
                    client.send_xml('m', {'t': 'Custom power voting still being worked on.', 'u': '0'})
            else:
                client.send_xml('m', {'t': 'You have already voted on a power to release.', 'u': '0'})
