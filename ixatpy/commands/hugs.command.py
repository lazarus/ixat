def hugsCommand(args, client, server):
	hugids = ','.join(server.config["hugs"])
	hugsList = []
	powers = server.database.fetchArray("SELECT `id`, `name` FROM `powers` WHERE `id` IN ("+hugids+")")
	for hug in powers:
		hugsList.append(hug['name'])
		
	hugs = ', '.join(hugsList)
	client.send('<m t="Hugs currently loaded on the server: '+hugs+'" u="0" />')