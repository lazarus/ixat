def clearCommand(args, client):
    if server.hasServerMinRank(client.info["id"], 'volunteers'):
        database.query('update `messages` set `visible`=0 where `id`= %(id)s and `port` = %(port)s', {
                       "id": client.info["chat"], "port": config.CONN_PORT})
        client.send_xml('m', {'t': 'Messages cleared, reload the chat to see results.', 'u': '0'})
