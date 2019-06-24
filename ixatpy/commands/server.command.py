def serverCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			com = args[1].lower()
		except:
			com = ""
		"""
		time_online = server.database.fetchArray("select time_online from `users` where `id`=%(id)s", {"id": client.info['id']})[0]['time_online']
			client.send('<m t="' + str(time_online) + '" u="0" />')
		"""
		if com == "test":
			powers = server.database.fetchArray("select * from `powers` where `limited`!=0 and `p`!=0 and `id`>0 and `name` <> 'everypower' order by rand() limit 0, 6;")
			for power in powers:
				client.send('<m t="' + power['name'] + '" u="0" />')
		elif com == "restart":
			from os import system
			import signal
			try:
				for user in server.clients:
					if user.online and user.registered:
						user.updateTimeOnline()
				system("killall python3.5; nohup python3.5 /root/Dropbox/ixatpy/server.py > /root/Dropbox/ixatpy/log.txt 2>&1 &")
			except BaseException as e:
				client.send('<m t="' + str(e) + '" u="0" />')
		elif com == "die" or com == "kill" or com == "stop":
			import os
			import signal
			for user in server.clients:
				if user.online and user.registered:
					user.updateTimeOnline()
			os.kill(os.getpid(), signal.SIGABRT)
		elif com == "reset" or com == "reload":
			server.loadFolders()
			server.getConfig()
			client.send('<m t="Commands/handlers/config reloaded." u="0" />')
		elif com == "help" or com == "info":
			client.send('<m t="You can reload commands, handlers and reset the config with ' + args[0][0] + 'server [reset/reload]" u="0" />')
			client.send('<m t="You can restart the server with ' + args[0][0] + 'server restart" u="0" />')
			client.send('<m t="You can kill the server with ' + args[0][0] + 'server [die/kill/stop]" u="0" />')
		else:
			client.send('<m t="Commands are ' + args[0][0] + 'server [reset/reload] [opt]" u="0" />')
			client.send('<m t="e.g. ' + args[0][0] + 'server reload" u="0" />')
