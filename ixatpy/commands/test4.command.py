def test4Command(args, client, server):
	#test = server.database.query("select `powers` from `users` WHERE `id`=%(uid)s", {"uid": client.info['id']})
	#server.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": '854', "powers": test[0]['powers']})
	client.notice("(Y#)", True)
