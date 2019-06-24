def idleCommand(args, client):
    MULTIPLIER = 2.5

    if server.hasServerMinRank(client.info["id"]) and (client.info['id'] == 1 or client.info["id"] == -3):
        from math import trunc
        txe = lambda x, r: (x * (r * 15) if r > 0 else x * 5)
        query = database.fetchArray(
            "select id, time_online from `users` where `time_online`>0")
        for i, n in enumerate(query):
            time_online, referrals = int(query[i]['time_online']), 0
            time_online2 = txe(trunc(time_online / (100 / MULTIPLIER)), referrals)
            time_online3 = round(
                ((time_online / (100 / MULTIPLIER)) - trunc(time_online / (100 / MULTIPLIER))) * 100)
            if time_online2 > 0:
                database.query('update `users` set `xats`=xats+%(xats)s, `time_online`=%(leftover)s where `id`=%(id)s', {
                               "xats": time_online2, "leftover": time_online3, "id": query[i]['id']})
        for user in server.clients:
            if user.online and user.registered:
                user.resetOnlineTime(True)
        client.send_xml('m', {'t': 'Everyone has been given their zats from timeonline; relog to see your xats by doing qrelog. Thank you for being afk, and earning zats.', 'u': '0'}, None, 2, True)
