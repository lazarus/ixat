def gcontrolCommand(args, client, server):
	if client.info["id"] in server.config["staff"]:
		try:
			if client.hasGControl:
				client.notice("Scroller:" + str(client.setScroller_minRank) + " Kick:" + str(client.kick_minRank) + " Unban:" + str(client.unBan_minRank) + " Ban:" + str(client.ban_minRank) + " RedC:" + str(client.canRedCard_minRank) + " YellowC:" + str(client.canYellowCard_minRank) + " NaughtyS:" + str(client.canNaughtyStep_minRank) + " Badge:" + str(client.canBadge_minRank) + " Dunce:" + str(client.canBeDunced_minRank) + " KickAll:" + str(client.kickAll_minRank) + " MakeG:" + str(client.makeGuest_minRank) + " MakeMe:" + str(client.makeMember_minRank) + " MakeMo:" + str(client.makeModerator_minRank) + " RedCF:" + str(client.redCardFactor) + " MaxBO :" + str(client.maxBan_owner) + " MaxBM:" + str(client.maxBan_mod), True)
			else:
				client.notice("GControl is not setup", True)
		except:
			client.notice("Something went wrong", True)