def timeonlineCommand(args, client):
	MULTIPLIER = 2.5

	from math import trunc, floor
	import time
	txe = lambda x, r: (x * (r * 15) if r > 0 else x * 5)
	fmt = lambda x: format(x, ",d")
	query = database.fetchArray(
		"select time_online from `users` where `id`=%(id)s", {"id": client.info['id']})
	time_online, referrals = int(query[0]['time_online']), 0
	time_online2 = txe(trunc(time_online / (100 / MULTIPLIER)), referrals)
	t_days = floor(time_online / 86400)
	t_hours = floor(time_online / 3600) % 24
	t_minutes = floor(time_online / 60) % 60
	t_str = str(t_days) + " day(s), " + str(t_hours) + " hour(s), " + str(t_minutes) + \
		" minute(s), and " + str(floor(time_online % 60)) + " second(s)"
	#string = "You will get " + str(time_online2) + " zats for being online for " + str(time_online) + " seconds."
	string = "You will get " + \
		str(time_online2) + " xats for being online for " + t_str
	if referrals > 0:
		string += " You have " + str(referrals) + " referrals."

	client.send_xml('m', {'t': str(string), 'u': '0'})
