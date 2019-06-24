def globalMessageHandler(packet, client, server):
	if client.connection["ip"] == "127.0.0.1":
		text = str(packet['t'])
		if "r" in packet and int(packet["r"]) == 1:
			import json
			powersdic = {}
			powers = server.database.fetchArray("select * from `powers` where `limited`!=0 and `p`!=0 and `id`>0 and `name` <> 'everypower' order by rand() limit 0, 6;")
			for power in powers:
				powersdic[power['name']] = 0
			server.database.query('UPDATE `server` SET `power_vote`=%(pv)s', {'pv': json.dumps( {"voted": [], "powers": powersdic, "custom": []} )})
			text += " | Powers to vote on have been refreshed. Type ~pvote status to see what you can vote on. Type ~pvote vote [power] to vote on that power."
		for user in server.clients:
			if user.online:
				user.send('<m t="' + text + '" u="0" />')