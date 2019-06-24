def wHandler(packet, client, server):
	if client.online:
		if client.Assigned(114) and client.Assigned(126) and client.info['banned']:
			return

		pool = int(packet['v'])

		if str(pool) in client.GroupPools:
			if int(pool) == 1:
				if client.Assigned(114):
					if client.info['rank'] in [1, 2, 4]:
						pool = 1
					else:
						pool = 0
			if int(pool) == 2:
				if client.Assigned(114) and client.Assigned(126):
					pool = 2
				else:
					pool = 0

		try:
			pool = client.getPool(pool, True)
			if int(pool) != int(client.info['pool']):
				client.sendRoom('<l u="' + str(client.info['id']) + '" />', True)
				client.info['ChangePool'] = pool
				if client.hasPower(29, True) and client.hidden == True:
					client.hidden = False # masked hidden
				client.joinRoom(True, False, True)
			else:
				client.info['pool'] = client.info['oldpool']
		except:
			pass
