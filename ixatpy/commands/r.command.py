def rCommand(args, client):
    from traceback import format_exc

    if server.hasServerMinRank(client.info["id"]):
        try:
            database.query('delete from `ranks` where `chatid`= %(chatid)s and `userid`= %(userid)s', {
                           "chatid": client.info['chat'], "userid": client.info['id']})
            if (len(args) == 2):
                ranks = {
                    'guest': 5,
                    'member': 3,
                    'moderator': 2,
                    'mod'		: 2,
                    'owner': 4,
                    'main': 1,
                }
                rank = ranks[args[1]]
                database.query('insert into `ranks` (`userid`, `chatid`, `f`) values(%(userid)s, %(chatid)s, %(f)s);', {
                               "userid": client.info['id'], "chatid": client.info['chat'], "f": rank})
                # client.relogin()
                client.joinRoom(False, True)
        except:
            print(format_exc())
            pass
