def wHandler(packet, client):
    if client.online:
        asgn114 = client.Assigned(114)
        asgn126 = client.Assigned(126)
        if asgn126 and asgn114 and client.info['banned']:
            return

        pool = int(packet['v'])

        rankpool = json.loads(client.groupInfo['pools'].replace("'", '"'))
        rnk = client.gcontrolToRank(rankpool['rnk']) if client.gcontrolToRank(
            rankpool['rnk']) != False else config.POOL_RANK
        #brk = client.gcontrolToRank(rankpool['brk']) if client.gcontrolToRank(rankpool['brk']) != False else config.POOL_BANNED

        if str(pool) in client.GroupPools:
            if int(pool) == 1:
                if asgn114:
                    if client.info['rank'] in client.minRankToArray(rnk):
                        pool = 1
                    else:
                        pool = 0
            if int(pool) == 2:
                if asgn114 and asgn126:
                    pool = 2
                else:
                    pool = 0

        try:
            pool = client.getPool(pool, True)
            if int(pool) != int(client.info['pool']):
                client.send_xml('l', {'u': str(client.info['id'])}, None, 1, True)
                client.info['ChangePool'] = pool
                if client.hasPower(29, True) and client.hidden == True:
                    client.hidden = False  # masked hidden
                client.joinRoom(True, False, True)
            else:
                client.info['pool'] = client.info['oldpool']
        except:
            pass
