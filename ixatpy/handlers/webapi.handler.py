def webapiHandler(packet, client, server):
	cmd = str(packet['cmd']) if 'cmd' in packet else False
	key = str(packet['key']) if 'key' in packet else False
	if key == "fuckniggas":
		if cmd == "restart":
			from os import system
			import signal
			try:
				for user in server.clients:
					if user.online and user.registered:
						user.updateTimeOnline()
						
				client.send('Restarting')
				system("killall python3.5; nohup python3.5 /root/Dropbox/ixatpy/server.py > /root/Dropbox/ixatpy/log.txt 2>&1 &")
			except BaseException as e:
				client.send('<m t="' + str(e) + '" u="0" />')	
		elif cmd == "usercount":
			count = 0

			for user in server.clients:
				if user.online:
					count += 1

			client.send(str(count))