def rollCommand(args, client):
    from random import randint
    d1, d2 = [randint(1, 6), randint(1, 6)]
    chance = randint(1, 100)
    if chance <= 40:
        client.send_xml('m', {'t': '40% chance executed.', 'u': '0'}, None, 1)
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
    client.send_xml('m', {'t': displayroll + ' = ' + str(outcome), 'u': '0'}, None, 1)
