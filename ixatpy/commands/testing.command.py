def testingCommand(args, client):
    if server.hasServerMinRank(client.info["id"]):
        # client.sendFriends()
        server.write(json.dumps(server.config, default=lambda o: o.__dict__ if hasattr(
            o, "__dict__") else str(o), sort_keys=True, indent=4), "test")
