def powerCommand(args, client):
        try:
            p = args[1]
        except:
            return client.send_xml('m', {'t': 'Proper usage: ~power [str]', 'u': '0'})
        power = database.fetchArray('select id, name, topsh from `powers` where `' + (
            "id" if p.isdigit() else "name") + '`=%(power)s', {'power': p})
        s = "Not found in the database."
        if(len(power) == 1):
            powerarr = power[0]
            s = str(powerarr["name"]).lower().capitalize() + \
                "[" + str(powerarr["id"]) + "] Found."
            if(len(powerarr["topsh"]) > 0):
                topsh = powerarr["topsh"].split(",")
                if(len(topsh) > 0):
                    s = s + " Smilies: "
                    for power in topsh:
                        s = s + "(" + power.upper() + "#) "
        client.send_xml('m', {'t': s, 'u': '0'})
