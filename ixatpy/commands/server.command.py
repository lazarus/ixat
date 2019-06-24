def serverCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        try:
            com = args[1].lower()
        except:
            com = ""

        del args[1]

        args = (" ".join(args)).split(" ")

        """
        time_online = database.fetchArray("select time_online from `users` where `id`=%(id)s", {"id": client.info['id']})[0]['time_online']
            client.send('<m t="' + str(time_online) + '" u="0" />')
        """
        if com == "test":
            powers = database.fetchArray(
                "select name from `powers` where `limited`!=0 and `p`!=0 and `name` <> 'everypower' order by rand() limit 0, 6;")
            for power in powers:
                client.send_xml('m', {'t': power['name'], 'u': '0'})
        elif com == "staff":
            client.send_xml('m', {'t': ",".join([str(x) for x in server.config["staff"]]), 'u': '0'})
        elif com == "restart":
            from os import system
            import signal
            if len(args) > 1 and str(args[1]) == "dropbox":
                #Restart Dropbox
                client.send_xml('m', {'t': 'Restarting Dropbox!', 'u': '0'})
                try:
                    system("dropbox start")
                except BaseException as e:
                    client.send_xml('m', {'t': str(e), 'u': '0'})
            else:
                try:
                    for user in server.clients:
                        if user.online and user.registered:
                            user.updateTimeOnline()
                    system(
                        "kill -9 " + str(getpid()) + "; nohup python3.5 "+config.FILE_PATH+"/server.py > "+config.FILE_PATH+"/log.txt 2>&1 &")
                except BaseException as e:
                    client.send_xml('m', {'t': str(e), 'u': '0'})
        elif com == "die" or com == "kill" or com == "stop":
            import os
            import signal
            for user in server.clients:
                if user.online and user.registered:
                    user.updateTimeOnline()
            os.kill(os.getpid(), signal.SIGABRT)
        elif com == "reset" or com == "reload":
            from os import path
            connection = [config.CONN_IP, config.CONN_PORT]

            load_ext(config.FILE_PATH + '/plib/config.py')
            globals()["config"] = Config()

            config.FILE_PATH = path.dirname(path.realpath(__file__))
            config.CONN_IP = connection[0]
            config.CONN_PORT = connection[1]

            load_ext(config.FILE_PATH + '/plib/client.py')
            server.loadFolders()
            server.getConfig()
            client.send_xml('m', {'t': 'Classes, Handlers, Commands and Config has been reloaded.', 'u': '0'})
        elif com == "hugs":
            hugids = ','.join(map(str, server.config["hugs"]))
            hugsList = []
            powers = database.fetchArray(
                "SELECT `id`, `name` FROM `powers` WHERE `id` IN (" + hugids + ")")
            for hug in powers:
                hugsList.append(hug['name'])

            hugs = ', '.join(hugsList)
            client.send_xml('m', {'t': 'Hugs currently loaded on the server: ' + hugs, 'u': '0'})
        elif com in ['db', 'database', 'sql', 'mysql']:
            if client.info["id"] in config.X_DEVS:
                import math
                import time
                t_seconds = (time.time() - server.start_time)
                t_days = math.floor(t_seconds / 86400)
                t_hours = math.floor(t_seconds / 3600) % 24
                t_minutes = math.floor(t_seconds / 60) % 60
                t_str = str(t_days) + " D : " + str(t_hours) + " H : " + \
                    str(t_minutes) + " M : " + \
                    str(math.floor(t_seconds % 60)) + " S"
                client.notice(str(database.queries) +
                              ' queries made since server started', True)
                client.notice(t_str, True)

        elif com == "notice":
            from xml.sax.saxutils import quoteattr

            if client.info['id'] in config.X_DEVS:
                del args[0]
                message = " ".join(args)
                for user in server.clients:
                    if user.online:
                        user.notice(message)
        elif com == "help" or com == "info":
            client.send_xml('m', {'t': 'You can reload commands, handlers and reset the config with ' + args[0][0] + 'server [reset/reload]', 'u': '0'})
            client.send_xml('m', {'t': 'You can restart the server with ' + args[0][0] + 'server restart', 'u': '0'})
            client.send_xml('m', {'t': 'You can kill the server with ' + args[0][0] + 'server [die/kill/stop]', 'u': '0'})
        else:
            client.send_xml('m', {'t': 'Commands are ' + args[0][0] + 'server [reset/reload] [opt]', 'u': '0'})
            client.send_xml('m', {'t': 'e.g. ' + args[0][0] + 'server reload', 'u': '0'})
