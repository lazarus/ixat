def usHandler(packet, client, server):
	'''
	FOR SETSCROLLER API 
	'''
	t = packet['t'] if 't' in packet else False
	k = packet['k'] if 'k' in packet else False
	c = packet['c'] if 'c' in packet else False
	if t and k and c:
		group = server.database.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":str(c)})
		if not len(group):
			return
			
		if str(k) != "K#DF7N57*Y%fS7y%": #KOREAN # DRIP FRUIT 7 NUT 5 7 * YELP % fruit SKYPE 7 yelp %
			return
			
		scroll = str(t)[2:256]
		server.database.query("update `chats` set `sc` = %(sc)s, `ch` = %(ch)s where `id` = %(id)s", {"sc": scroll, "ch": "0", "id": str(c)})
		for _client in server.clients:
			if str(_client.info['chat']) == str(c):
				#_client.send('<m t="SetScroller API Initiated: ' + scroll + '" u="0" />')
				_client.send('<m t="/s' + str(scroll) + '" u="0" />')
				_client.info['info']['/s'] = "_/s 0"	
		
	return