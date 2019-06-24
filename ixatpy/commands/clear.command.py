def clearCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		server.database.query('update `messages` set `visible`=0 where `id`= %(id)s and `port` = %(port)s', {"id":client.info["chat"], "port":server.connection["port"]})
		client.send('<m t="Messages cleared, reload the chat to see results." u="0" />')