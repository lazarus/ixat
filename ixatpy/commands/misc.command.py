def miscCommand(args, client):
	from random import choice
	from urllib.request import urlopen
	
	type = 2 if server.hasServerMinRank(client.info["id"]) else 0
	
	try:
		com = args[1].lower()
	except:
		com = ""

	del args[1]

	args = (" ".join(args)).split(" ")

	if com == "8ball":
		res = ["Yup!", "Of Course!", "I don't think so", "I doubt it 3:", "Maybe", "Keep your hopes up!"]
		client.send_xml('m', {'t': random.choice(res), 'u': '0'}, None, type)
	elif com == "fact":
		site = urlopen("http://randomfunfacts.com/")
		fact = server.stribet(site.read().decode("UTF-8", "replace"), '<i>', '</i>')
		if not fact:
			client.send_xml('m', {'t': 'Couldnt retrieve a random fact atm.', 'u': '0'})
		else:
			client.send_xml('m', {'t': fact, 'u': '0'}, None, type)
	elif com == "dice":
		client.send_xml('m', {'t': 'You rolled a ' + str(random.randint(1, 6)), 'u': '0'}, None, type)
	elif com == "fortune":
		site = urlopen("http://www.fortunecookiemessage.com/")
		fortune = server.stribet(site.read().decode("UTF-8", "replace"), 'class="cookie-link">', '</a>').replace('<p>', '').replace('</p>', '')
		if not fortune:
			client.send_xml('m', {'t': 'Couldnt retrieve a fortune atm.', 'u': '0'})
		else:
			client.send_xml('m', {'t': fortune, 'u': '0'}, None, type)
	elif com == "slots":
		smilies = ['(slotban#)', '(slotbar#)', '(cherries#)', '(orange2#)', '(plum2#)', '(seven#)']
		difficulty = {'easy': 2, 'hard': 4, 'expert': 5, 'extreme': 6, 'impossible': 7, 'gg': 10}
		smiliecount = 3 if not (len(args) > 1 and str(args[1]) in difficulty) else difficulty[str(args[1])]
		spun = [random.choice(smilies) for i in range(smiliecount)]
		
		client.send_xml('m', {'t': 'Spinning: ' + ' | '.join(['(rolling#)'] * smiliecount), 'u': '0'}, None, type)
		client.send_xml('m', {'t': 'You have spun: ' + ' | '.join(spun) + ' and ' + ('Won (clap#)' if len(list(set(spun))) == 1 else 'Lost :P'), 'u': '0'}, None, type)
	else:
		client.send_xml('m', {'t': 'PLACEHOLDER ERROR', 'u': '0'})