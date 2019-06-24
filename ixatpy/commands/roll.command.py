def rollCommand(args, client, server):
	from random import randint
	d1, d2 = [randint(1, 6), randint(1, 6)]
	chance = randint(1, 100)
	if chance <= 40:
		client.sendRoom('<m t="40% chance executed." u="0" />')
		d1, d2 = [d1 * 4, d2 * 4]
	displayroll = str(d1) + ' + ' + str(d2)
	try:
		speed = int(args[1])
		if speed != 0:
			displayroll += ' + ' + str(speed)
	except:
		speed = 0
	outcome = d1 + d2 + speed
	if outcome < 0:
		outcome = 0
	client.sendRoom('<m t="' + displayroll + ' = ' + str(outcome) + '" u="0" />')