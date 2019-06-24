def rcCommand(args, client, server):
    from random import randint
    try:
        rr = int(args[1])
        if rr > 25:
            rr = 1
    except:
        rr = 1
    for i in range(rr):
        rc = ["%06x" % randint(0, 0xFFFFFF), "%06x" % randint(0, 0xFFFFFF)]
        link = "http://zatbots.com/rc.php?glow=" + rc[0] + "&color=" + rc[1]
        client.notice('(glow#' + rc[0] + '#' + rc[0] + ' ) - ' + link + '', True)
