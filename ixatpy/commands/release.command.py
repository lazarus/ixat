def releaseCommand(args, client, server):
	from random import randint
	if client.info["id"] in server.config["staff"]:
		try:
			power = args[1]
			
			if power == 'all':
				try:
					args[2] = args[2]
				except:
					args.append(str(randint(1, 10)))
					
				amount = args[2]
				
				server.database.query("UPDATE `powers` SET `amount`= `amount` + " + amount + " WHERE `limited`='1' and `p`='1'")
					
				for user in server.clients:
					if user.online:
						user.send('<m t="' + amount + ' of all limited powers released! [Released by: '+ client.info['username'] +']" u="0" i="0" />')
				return		
			if power == 'rand':
				rand = server.database.fetchArray("SELECT * FROM `powers` WHERE `limited`='1';")
				power = rand[0]['name']
				try:
					args[2] = args[2]
				except:
					args.append(str(randint(1, 10)))
					
			amount = args[2]
			
			server.database.query("UPDATE `powers` SET `amount`= %(amount)s WHERE `name` = %(name)s", {"amount": amount, "name": power})
			for user in server.clients:
				if user.online:
					user.send('<m t="' + amount + ' ' + power + '[s] released! [Released by: '+ client.info['username'] +']" u="0" i="0" />')
		except:
			client.send('<m t="There was a problem releasing that power." u="0" />')
