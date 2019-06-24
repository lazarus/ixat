def idleCommand(args, client, server):
	if client.info["id"] in server.config["staff"] and client.info['id'] == 1:
		from math import trunc
		txe = lambda x, r: (x * (r * 20) if r > 0 else x * 10)
		query = server.database.fetchArray("select * from `users` where `time_online`>0")
		for i, n in enumerate(query):
			time_online, referrals = int(query[i]['time_online']), int(query[i]['referrals'])
			time_online2 = txe(trunc(time_online / 100), referrals)
			time_online3 = round(((time_online / 100) - trunc(time_online / 100)) * 100)
			if time_online2 > 0:
				server.database.query('update `users` set `xats`=xats+%(xats)s, `time_online`=%(leftover)s where `id`=%(id)s', {"xats": time_online2, "leftover": time_online3, "id": query[i]['id']})
		for user in server.clients:
			if user.online and user.registered:
				user.resetOnlineTime(True)
		client.sendAll('<m t="Everyone has been given their ixats in ~to, relog to see your xats." u="0" />', True)