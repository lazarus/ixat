def blahCommand(args, client):
    from traceback import print_exc
    from sys import stdout

    if server.hasServerMinRank(client.info["id"]):
        try:
            name = client.info["name"].encode(
                'utf-8').decode('latin-1').encode("unicode_escape")

            print(name)

            stdout.flush()

            database.query('update `users` set nickname=%(nickname)s WHERE id=%(id)s', {
                           "nickname": server.base64encode(name), "id": client.info["id"]})
        except:
            server.write(format_exc(), "Blah")
