def huHandler(packet, client):
    from time import time
    import logging
    logging.basicConfig(
        filename='/root/Dropbox/ixatpy/errors.txt', level=logging.DEBUG)
    CurrentTime = int(time())
    userNo = packet['u'] if 'u' in packet else False
    chatNo = packet['c'] if 'c' in packet else False
    banTime = int(packet['t']) if 't' in packet else False
    startTime = int(packet['s']) if 's' in packet else False
    Power = int(packet['w']) if 'w' in packet else False

    if userNo is False or chatNo is False or Power is False or startTime is False:
        return

    j = server.getUserByID(str(userNo), str(chatNo))

    if Power not in server.gameBans:
        return

    dbInfo = database.fetchArray('select type, special from `bans` where `chatid`=%(r)s and `userid`=%(userid)s;', {
                                 "r": chatNo, "userid": userNo})
    if not len(dbInfo):
        return

    if dbInfo[0]['type'] != 'g':
        return

    if int(dbInfo[0]['special']) != Power:
        return
    '''
	Check if the ban time is the same as in db
	'''

    database.query('delete from `bans` where `chatid`=%(r)s and (`userid`=%(userid)s or `ip`=%(ip)s) and `special`=%(power)s;', {
                   "r": chatNo, "userid": userNo, "ip": j.connection['ip'], "power": Power})
    j.info['GameBanData'] = []

    j.send_xml('c', {'u': '0', 'd': str(userNo), 't': '/u'})
    j.joinRoom(False, True)

    timeLeft = banTime - startTime
    timeLeft = 0 if timeLeft < 0 else round(timeLeft / 3600)
    gameTime = int(time.time()) - startTime
    if gameTime < 0:
        gameTime = 0

    j.send_xml('m', {'d': str(userNo), 'u': str(userNo), 't': '/u', 'p': str(Power) + ',' + str(gameTime) + ',' + str(timeLeft)}, None, 1, False)
