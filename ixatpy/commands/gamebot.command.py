def gamebotCommand(args, client):
    if len(args) == 3 and server.hasServerMinRank(client.info["id"]):
        if args[1].lower() == "doodle":
            if args[2].lower() == "start":
                client.send_xml('g', {'u': '804', 'x': '60189'}, None, 1)
                client.send_xml('x', {'i': '60189', 'u':'804', 't': '1,play,30,Lisa Simpson,0,'}, None, 1)
                client.send_xml('m', {'t': 'DoodleRace has started with word: Lisa Simpson.', 'u': '804', 'i': '0'}, None, 1)
                client.GameRace[60189] = {}
            elif args[2].lower() == "rate":
                client.send_xml('x', {'i': '60189', 'u': '804', 't': '1,rate,10'}, None, 1)
            elif args[2].lower() == "finish":
                scores = {}
                for (uid, arr) in client.GameRace[60189].items():
                    score = 0
                    x = 0
                    for v in arr.values():
                        for v2 in v.values():
                            score += v2
                            x = x + 1

                    scores[uid] = score / x

                results = []
                winning = {}
                for (u, sco) in scores.items():
                    result.append(u + "=" + sco)
                    if not winning[1] or score > winning[1]['score']:
                        winning[1] = {'user': u, 'score': score}
                    elif not winning[2] or score > winning[2]['score']:
                        winning[2] = {'user': u, 'score': score}
                    elif not winning[3] or score > winning[3]['score']:
                        winning[3] = {'user': u, 'score': score}

                winners = ""
                if len(winning) >= 1:
                    winners += server.getUserByID(int(winning[1]['user']), client.info["chat"]).info[
                        'username'] + ' (' . winning[1]['user'] + ') gets gold (goldm#). '
                if len(winning) >= 2:
                    winners += server.getUserByID(int(winning[2]['user']), client.info["chat"]).info[
                        'username'] + ' (' . winning[2]['user'] + ') gets silver (silverm#). '
                if len(winning) == 3:
                    winners += server.getUserByID(int(winning[3]['user']), client.info["chat"]).info[
                        'username'] + ' (' . winning[3]['user'] + ') gets bronze (bronzem#). '
                scores = ''.join(results)

                client.send_xml('x', {'i': '60189', 'u': '804', 't': '1,results,60,' + str(scores)})
                if winners == "":
                    client.send_xml('m', {'t': 'Nobody\'s playing so... I\'m outa here!', 'u': '804', 'i': '0'})
                    client.send_xml('x', {'i': '60189', 'u': '804', 't': '1,idle'})
                    client.send_xml('l', {'u': '804'})
                    client.GameRace[60189] = {}
                    return

                client.send_xml('m', {'t': str(winners), 'u': '804', 'i': '0'})
                return
            elif args[2].lower() == "bot":
                client.send_xml('u', {'cb': '0', 'rank': '1', 'f': '8227', 'p0': '536869887', 'p1': '2147483639', 'p2': '2147483606', 'p3': '2147483647', 'p4': '2113929215', 'p5': '2147483647', 'p6': '2147483647', 'p7': '2147483647', 'p8': '2147483647', 'p9': '2147483647', 'p10': '2147483647', 'p11': '2147483647', 'p12': '2147483647', 'N': 'GameBot', 'u': '804', 'q': '3', 'n': 'GameBot', 'a': '(bot1)', 'h': '', 'v': '0'}, None, 1)
                client.send_xml('m', {'t': 'GameBot is ready to serve (DoodleRace#). Type !start OR !start fish etc', 'u': '804', 'i': '0'}, None, 1)
                client.GameRace[60189] = {}
            elif args[2].lower() == "leave":
                client.send_xml('m', {'t': 'GameBot has been stopped by ' + server.getUserByID(client.info["id"], client.info["chat"]).info['username'] + ' (' + str(client.info["id"]) + ') (BYE#).', 'u': '804', 'i': '0'}, None, 1)
                client.send_xml('l', {'u': '804'}, None, 1)
                client.GameRace[60189] = {}

        elif args[1].lower() == "snake":
            if args[2].lower() == "start":
                client.send_xml('g', {'u': '804', 'x': '60195'}, None, 1)
                client.send_xml('x', {'i': '60195', 'u': '804', 't': '3,play,60, 1826500484, 1, 0,'}, None, 1)
                client.send_xml('m', {'t': 'SnakeRace has started.', 'u': '804', 'i': '0'}, None, 1)
                client.GameRace[60195] = {}
            elif args[2].lower() == "restart":
                client.send_xml('g', {'u': '804', 'x': '60189'}, None, 1)
                client.send_xml('x', {'i': '60195', 'u': '804', 't': '3,replay,60, 1826500484, 1, 0,'}, None, 1)
                client.send_xml('m', {'t': 'SnakeRace has restarted.', 'u': '804', 'i': '0'}, None, 1)
                client.GameRace[60195] = {}
            elif args[2].lower() == "bot":
                client.send_xml('u', {'cb': '0', 'rank': '1', 'f': '8227', 'p0': '536869887', 'p1': '2147483639', 'p2': '2147483606', 'p3': '2147483647', 'p4': '2113929215', 'p5': '2147483647', 'p6': '2147483647', 'p7': '2147483647', 'p8': '2147483647', 'p9': '2147483647', 'p10': '2147483647', 'p11': '2147483647', 'p12': '2147483647', 'N': 'GameBot', 'u': '804', 'q': '3', 'n': 'GameBot', 'a': '(bot1)', 'h': '', 'v': '0'}, None, 1)
                client.send_xml('m', {'t': 'GameBot is ready to serve (SnakeRace#). Type !start OR !start fish etc', 'u': '804', 'i': '0'}, None, 1)
                client.GameRace[60195] = {}
            elif args[2].lower() == "leave":
                client.send_xml('m', {'t': 'GameBot has been stopped by ' + server.getUserByID(client.info["id"], client.info["chat"]).info['username'] + ' (' + str(client.info["id"]) + ') (BYE#).', 'u': '804', 'i': '0'}, None, 1)
                client.send_xml('l', {'u': '804'}, None, 1)
                client.GameRace[60195] = {}
