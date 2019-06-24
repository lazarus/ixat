def huHandler(packet, client, server):
	from time import time
	import logging
	logging.basicConfig(filename='/root/Dropbox/ixatpy/errors.txt', level=logging.DEBUG)
	CurrentTime = int(time())
	UserNo = packet['u'] if 'u' in packet else False
	ChatNo = packet['c'] if 'c' in packet else False
	BanTime = int(packet['t']) if 't' in packet else False
	StartTime = int(packet['s']) if 's' in packet else False
	Power = int(packet['w']) if 'w' in packet else False
	
	if UserNo is False or ChatNo is False or Power is False or StartTime is False:
		return
		
	j = server.getUserByID(str(UserNo), str(ChatNo))

	if Power not in server.gameBans: 
		return
		
	dbInfo = server.database.fetchArray('select * from `bans` where `chatid`=%(r)s and `userid`=%(userid)s;', {"r": ChatNo, "userid": UserNo})	
	if not len(dbInfo):
		return
		
	if dbInfo[0]['type'] != 'g':
		return
		
	if int(dbInfo[0]['special']) != Power:
		return
	'''
	Check if the ban time is the same as in db
	'''
	
	server.database.query('delete from `bans` where `chatid`=%(r)s and `userid`=%(userid)s or `ip`=%(ip)s;', {"r": ChatNo, "userid": UserNo, "ip": j.connection['ip']})
	j.info['GameBanData'] = []
	
	Buf = "<c u=\"0\" d=\"" + str(UserNo) + "\" t=\"/u\" />" # "<c u=\"0\" d=\"%ld\" t=\"/u\" />" % (UserNo)
	j.sendPacket(Buf)
	j.joinRoom(False, True)
	
	TimeLeft = BanTime - StartTime
	
	if TimeLeft < 0: 
		TimeLeft = 0
		
	TimeLeft2 = TimeLeft

	TimeLeft = (TimeLeft * 1000) / 3600

	n = 0
	while TimeLeft >= 100:
		TimeLeft = (TimeLeft + 5) / 10
		n += 1
		
	while n > 0:
		TimeLeft *= 10
		n -= 1
	
	Buf2 = "%f" % (TimeLeft / 1000.0)
	
	''' NEEDS FIXING
	p = Buf2 + len(Buf2) - 1
	n = 0 # 1 = looking for .
	while p[0]:
		n = n or p[0] != '0' # start scanning for . ?
		if n == 0:
			p[0] = 0;
			if p[-1] == '.':
				p[-1] = 0
				break
		else
			if p[0] == '.':	# . to , to avoid it being a link :S
				p[0] = '.'
				break
		p -= 1
	'''
	
	GameTime = CurrentTime - StartTime
	if GameTime	< 0: 
		GameTime = 1
		
	Buf = "<m d=\"" + str(UserNo) + "\" u=\"" + str(UserNo) + "\" t=\"/u\" p=\"" + str(Power) + "," + str(GameTime) + "," + str(Buf2) + "\" />" #"<m d=\"%ld\" u=\"%ld\" t=\"/u\" p=\"%u,%u,%s\" />" % (UserNo, UserNo, Power, GameTime, Buf2)
	logging.debug("BUF1'2 " + str(Buf))
	j.sendRoom(Buf, False)	
	
	''' For Events
	Buf2 = "%u" % (GameTime)

	WriteEvent(-1, j, ChatNo, UserNo, TimeLeft2, Buf2, Power)
	'''