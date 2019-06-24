def everypowerCommand(args, client, server):
	if client.info["id"] in server.config["staff"] and client.info['id'] in [1, 3, 5, 10]:
		uRow = server.database.fetchArray('select * from `users` where `username`=%(username)s', {"username":args[1]})
		if len(uRow) == 1:
			powers = server.database.fetchArray('select `id`, `name` from `powers` where `p`=1 AND `name` not like \'%(Undefined)%\' and `subid`<2147483647;');
			ep = {}
			for power in powers:
				try:
					float(power['name'])
				except:
					ep[str(power['id'])] = 1
			uid = str(uRow[0]['id'])
			server.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": uid, "powers": json.dumps(ep)})
			_user = server.getUserByID(uRow[0]['id'], client.info['chat'])
			if _user != False:
				_user.send(server.doLogin(uRow[0]['username'], uRow[0]['password']))
