def globalCommand(args, client):
    from xml.sax.saxutils import quoteattr

    if server.hasServerMinRank(client.info["id"]):
        del args[0]
        message = " ".join(args)
        for user in server.clients:
            if user.online:
                user.notice(message, True)
