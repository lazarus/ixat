def apHandler(packet, client, server):
	if not client.online or client.info['banned'] or not client.registered:
		return
	attr = packet
	try:
		float(attr['a'])
		float(attr['p'])
	except:
		return
	p = attr['p']
	a = attr['a']
	power = server.database.fetchArray('select count(*) from `powers` where `id`=%(p)s and `group`=1', {"p": p})
	if len(power) == 0:
		# Power isn't group / not found
		client.send('<n t="That is NOT a group power..." />')
	else:
		if not client.hasPower(int(p), True):
			return client.send('<n t="You don\'t have this power..." />')
		if a == '1':
		# Assign power
			power = server.database.fetchArray('select count(*) from `group_powers` where `power`=%(p)s and `assignedBy`=%(assignedby)s', {"p": p, "assignedby": client.info["id"]})
			if not client.info["id"] in server.config["staff"] and power[0]['count(*)'] > 0:
				# You have already assigned that power somewhere
				return client.send('<ap p="' + str(p) + '" r="3" />')
			power = server.database.fetchArray('select count(*) from `group_powers` where `chat`= %(chat)s and `power`= %(p)s', {"chat": client.info["group"], "p": p})
			if power[0]['count(*)'] > 0:
			# Group already has the power assigned
				client.send('<ap p="' + str(p) + '" r="4" />')
			else:
				server.database.query('replace into `group_powers`(`chat`, `power`, `assignedBy`) values(%(chat)s, %(p)s, %(assignedby)s);', {"chat": client.info["group"], "p": p, "assignedby": client.info["id"]})
				client.send('<ap p="' + str(p) + '" r="1" />')
		elif a == '0':
			power = server.database.fetchArray('select count(*) from `group_powers` where `power`=%(p)s and `assignedBy`=%(assignedby)s and `chat`= %(chat)s', {"p": p, "assignedby": client.info["id"], "chat": client.info["group"]})
			if power[0]['count(*)'] == 0:
				# Power hasn't been assigned ^-^
				client.send('<ap p="' + str(p) + '" r="2" />')
			else:
				chat = server.database.fetchArray('select * from `chats` where `id`=%(id)s;', {"id":client.info["id"]})
				server.database.query('delete from `group_powers` where `assignedBy`=%(assignedby)s and `chat`=%(chat)s and `power`=%(p)s', {"assignedby": client.info["id"], "chat": client.info["group"], "p": p})
				client.send('<ap p="' + str(p) + '" r="0" />')
