def toCommand(args, client, server):
	from math import trunc
	txe = lambda x, r: (x * (r * 20) if r > 0 else x * 200)
	fmt = lambda x: format(x, ",d")
	query = server.database.fetchArray("select referrals, time_online from `users` where `id`=%(id)s", {"id": client.info['id']})
	time_online, referrals = int(query[0]['time_online']), int(query[0]['referrals'])
	time_online2 = txe(trunc(time_online / 100), referrals)
	time_online3 = round(((time_online / 100) - trunc(time_online / 100)) * 100)
	string = "You will get " + str(time_online2) + " ixats for being online for " + str(time_online) + " seconds."
	if referrals > 0:
		string += " You have " + str(referrals) + " referrals."
	client.send('<m t="' + str(string) + '" u="0" />')