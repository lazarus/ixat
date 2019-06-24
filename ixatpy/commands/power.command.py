def powerCommand(args, client, server):
    if client.info["id"] in server.config["staff"]:
        try:
            p = args[1]
        except:
            return client.send('<m t="Proper usage: ~power [str]" u="0" />')
        power = server.database.fetchArray('select * from `powers` where `' + ("id" if p.isdigit() else "name") + '`=%(power)s', {'power': p})
        s = "Not found in the database."
        if(len(power) == 1):
            powerarr = power[0]
            s = str(powerarr["name"]).lower().capitalize() + "[" + str(powerarr["id"]) + "] Found."
            if(len(powerarr["topsh"]) > 0):
                topsh = powerarr["topsh"].split(",")
                if(len(topsh) > 0):
                    s = s + " Smilies: "
                    for power in topsh:
                        s = s + "(" + power.upper() + "#) "
        client.send('<m t="' + s + '" u="0" />')
