from xml.etree import ElementTree as etree
from xml.sax.saxutils import quoteattr
from threading import Thread
from time import time, sleep
from re import escape
from traceback import print_exc
from random import randint
import select
import json
from plib.parser import Parser

class Client(Thread):
	def __init__(self, sock, address, parent):
		Thread.__init__(self)

		self.connecttime = time()
		self.SignedOut = False
		self.gotTickled = False
		self.sendTo = None
		self.server = None
		self.socket = None
		self.connection = {}
		self.bytes = 4096
		self.disconnected = False
		self.online = False
		self.policy = False
		self.signInPackets = ["y", "j2", "v", "policy-file-request", "g", "gb", "h", "us", "hu", "webapi"]
		self.sentY = False
		self.sentJ2 = False
		self.duplicate = False
		self.poolLimit = 50
		self.clickedPool = False
		self.lastPool = 0
		self.yPacket = {"r": 0, "u": -1}
		self.joinedTime = 0

		self.info = {}
		self.info["chat"] = -1
		self.info["away"] = False
		self.info["typing"] = False
		self.info["pool"] = 0
		self.info["ChangePool"] = -1
		self.info["KeepPool"] = False
		self.info['info'] = {}
		self.info['temp'] = 0
		self.info["app"] = 0
		self.info['sinbinned'] = False
		self.info['members_only'] = False
		self.info['live_mode'] = False
		self.info["redcard"] = False
		self.info["joinTime"] = 0
		self.info["test"] = False

		self.registered = False
		self.hidden = False
		self.activeTime = int(time())
		self.gotPowers = False
		self.EnabledPowers = {}
		self.joinData = {}
		self.loginTime = 0
		self.setDaemon(True)
		self.socket = sock
		self.connection = {"ip": address[0], "port": address[1]}
		self.server = parent

		# April Fools
		self.canChat = False

		#Newly Added
		self.talked = False
		self.isSpectator = False;
		self.jinx = ""
		self.jinxMain = ""

		#Techy's
		self.GameRace = {60189:{},60193:{},60195:{},60201:{},60225:{},60239:{},60247:{},60257:{}}

		#Group Control
		self.hasGControl = False
		self.setScroller_minRank = 4
		self.kick_minRank = 2
		self.unBan_minRank = 2
		self.ban_minRank = 2
		self.canRedCard_minRank = 2
		self.canYellowCard_minRank = 2
		self.canNaughtyStep_minRank = 2
		self.canBadge_minRank = 4
		self.canBeDunced_minRank = 2
		self.canSilentMember_minRank = 4
		self.canRankLock_minRank = 4
		self.kickAll_minRank = 4
		self.makeGuest_minRank = 2
		self.makeMember_minRank = 2
		self.makeModerator_minRank = 4
		self.redCardFactor = 6
		self.maxBan_owner = 0
		self.maxBan_mod = 6
		self.canJinx_minRank = 2
		self.canJinxSameRank = False


	def bcmod(self, left=0, mod=0):
		return int(left) % int(mod)

	def send(self, packet, tries=0):
		try:
			if tries == 24:
				return
			self.socket.send(bytes((packet + chr(0)).encode("utf-8")))
			#self.server.queue.put([3, self, bytes((packet + chr(0)).encode("utf-8"))])
			# self.server.write("[SEND] " + packet)
		except:
			self.send(packet, tries + 1)

	def sendPacket(self, packet):
		self.send(packet)

	def resetOnlineTime(self, hreset=True):
		if hreset:
			self.joinedTime = int(time())
		self.logoutTime = int(time())
		self.timeOnline = (self.logoutTime - self.joinedTime)
		self.joinedTime = int(time())

	def updateTimeOnline(self):
		if self.online and self.registered:
			self.resetOnlineTime(False)
			for user in self.server.clients:
				if user.online and user.registered and user.info['id'] == self.info['id'] and user.connection['port'] != self.connection['port']:
					user.resetOnlineTime(False)
					if user.timeOnline >= self.timeOnline:
						self.timeOnline = user.timeOnline
			if self.timeOnline != 0:
				self.server.database.query('update `users` set time_online=time_online+%(to)s WHERE `id`=%(id)s', {'to': self.timeOnline, 'id': self.info['id']})

	def buildPacket(self, type='m', attributes=None, sort=None):
		if attributes == None:
			attributes = {'t':'', 'u':'0', 'i':'0'}
		if sort == None:
			sort = []
		if type == '':
			return ''
		if len(attributes) == 0:
			return '<' + str(type) + ' />'
		packet = '<' + str(type) + ' '
		if len(sort) == 0:
			for i in attributes:
				packet += i + '=' + quoteattr(str(attributes[i])) + ' '
		else:
			fulfilled = []
			for i in sort:
				if not i in attributes:
					continue
				fulfilled.append(i)
				packet += i + '=' + quoteattr(str(attributes[i])) + ' '
			for i in attributes:
				if not i in fulfilled:
					packet += i + '=' + quoteattr(str(attributes[i])) + ' '
		return packet+'/>'

	def hasPower(self, PowerID=0, MustBeEnabled=True):
		if not self.gotPowers:
			return False
		section = PowerID >> 5
		subid = 2 ** (PowerID % 32)
		if MustBeEnabled == True:
			if section in self.EnabledPowers and self.EnabledPowers[section] & subid:
				return True
		else:
			if self.loadedIndex[section] & subid:
				return True
		return False

	def getUserPowers(self):
		#if int(self.info["id"]) in self.server.authorizedBots:
			#return self.getBotPowers()
		self.gotPowers = False
		self.loadedPowers = {}
		self.loadedIndex = {}
		self.info["powers"] = {}
		powers = self.server.database.fetchArray('select * from `powers` where `name` not like \'%(Undefined)%\';')
		userpowers = self.server.GetUserPower(self.info["id"])
		for power in powers:
			self.loadedPowers[int(power["id"])] = {"section":int(power["section"].strip("p")), "subid":int(power["subid"])}
			if not self.loadedPowers[int(power["id"])]["section"] in self.loadedIndex.keys():
				self.loadedIndex[self.loadedPowers[int(power["id"])]["section"]] = 0
		self.EnabledPowers = {}
		if int(self.userInfo['torched']) == 1:
			return self.loadedIndex
		for power in userpowers:
			section = int(power) >> 5
			subid = 2 ** (int(power) % 32)
			try:
				if section in self.EnabledPowers.keys():
					self.EnabledPowers[section] += subid
				else:
					self.EnabledPowers[section] = subid
			except:
				self.EnabledPowers[section] = 0

			if(self.loadedIndex[section] & subid) == 0:
				self.loadedIndex[section] += subid
				if 'm'+str(section) in self.joinData.keys() and int(self.joinData['m'+str(section)]) & int(subid):
					self.EnabledPowers[section] -= int(subid)
			else:
				return [-1]

		self.gotPowers = True
		# skeleton response {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0}
		return self.loadedIndex

	def getBotPowers(self):
		self.gotPowers = False
		self.loadedPowers = {}
		self.loadedIndex = {}
		self.info["powers"] = {}
		powers = self.server.database.fetchArray("select * from `powers`;")
		self.EnabledPowers = {}
		for power in powers:
			self.loadedPowers[int(power["id"])] = {"section":int(power["section"].strip("p")), "subid":int(power["subid"])}
			if not self.loadedPowers[int(power["id"])]["section"] in self.loadedIndex.keys():
				self.loadedIndex[self.loadedPowers[int(power["id"])]["section"]] = 0

		if int(self.userInfo['torched']) == 1:
			return self.loadedIndex

		for power in powers:
			section = int(power["section"].strip("p"))
			subid = int(power["subid"])
			if subid > 2147483647:
				continue
			try:
				if section in self.EnabledPowers.keys():
					self.EnabledPowers[section] |= int(subid)
				else:
					self.EnabledPowers[section] = int(subid)
			except:
				self.EnabledPowers[section] = 0

			if(self.loadedIndex[section] & int(subid)) == 0:
				self.loadedIndex[section] |= int(subid)
				if 'm'+str(section) in self.joinData.keys() and int(self.joinData['m'+str(section)]) & int(subid):
					self.EnabledPowers[section] &= ~int(subid)
			else:
				return [-1]

		self.gotPowers = True
		# skeleton response {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0}
		return self.loadedIndex

	def Assigned(self, powerid):
		try:
			float(powerid)
		except:
			power = self.server.database.fetchArray("SELECT * FROM `powers` WHERE 'name'=%(name)s", {"name": powerid})
			if not len(power):
				return False
			else:
				powerid = power[0]['id']

		assigned = self.server.database.fetchArray("SELECT * FROM `group_powers` WHERE `chat`=%(group)s AND `power`=%(id)s AND `enabled`=1", {"group": self.info["group"], "id": powerid})
		if len(assigned) > 0:
			return True
		else:
			return False

	def handle(self, tag="m", attributes=None):
		try:
			if tag[0] == "w":
				attributes = {"v": int(tag[1:])}
				tag = "w"
			tag = tag.lower()

			if self.connection["ip"] == "127.0.0.1" and tag == "globalmessage":
				tag = "globalMessage"
				self.server.call(tag, "handler", attributes, self, self.server)
				return True

			if tag in self.signInPackets and self.online == False:
				if tag != "policy-file-request":
					self.server.call(tag, "handler", attributes, self, self.server)
					return True
				elif tag == "policy-file-request" and self.policy == False and self.online == False:
					self.policy = True
					self.send(self.server.policyFile)
					return True
				else:
					return False
			elif tag + ":handler" in self.server.handlers.keys() and self.online is True:
				self.server.call(tag, "handler", attributes, self, self.server)
				return True
			else:
				return False
		except:
			print_exc()
			return False

	def parse(self, packet):
		try:
			if packet[:2] == "<f":
				parser = Parser()
				parser.feed(packet)
				self.handle(parser.tag, parser.attrib)
			else:
				xml = etree.XML(packet)
				#self.server.queue.put([0, self, xml])
				self.handle(xml.tag, xml.attrib)
		except:
			pass

	def notice(self, string="", notice=False):
		if not notice:
			self.send('<n t=' + quoteattr(str(string)) + ' />')
		elif notice:
			self.send('<m t=' + quoteattr(str(string)) + ' u="0" />')

	def escape(self, string=""):
		return quoteattr(string)

	def sendMessage(self, message=""):
		if message == '':
			return

		for user in self.server.clients:
			if user.online and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"] and user.info["id"] != self.info["id"] and not user.info["Banished"]:
				try:
					if user.info['members_only'] and user.info['rank'] == 5:
						continue
					user.send(self.buildPacket("m", {"t":message, "u":self.info["id"], "T":str(int(time())),"i":0,"r":self.info["chat"]}, ["t","u","T","i","r"]))
				except:
					pass

	def sendRoom(self, packet="", exclude=False, excludeid=0):
		for user in self.server.clients:
			if user.online and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"] and not user.info["Banished"]:
				if exclude == True and user.info["id"] == self.info["id"] or int(excludeid) == int(user.info["id"]):
					pass
				else:
					if not self.hidden or self.hidden and (self.info['rank'] == user.info['rank'] or self.server.higherRank(user.info['rank'], self.info['rank'])):
						user.send(packet)

	def sendLive(self, packet=""):
			for user in self.server.clients:
				if user.online and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"] and not user.info["Banished"] and user.info['rank'] in [1, 4]:
					user.send(packet)

	def sendAll(self, packet="", online=False):
		for user in self.server.clients:
			if (online and user.online) or ((not online and not user.online) or user.online):
				user.send(packet)

	def buildGp(self):
		try:
			Already = []
			Enabled = []
			assigned = self.server.database.fetchArray("SELECT * FROM `group_powers` WHERE `chat`=%(chat)s", {"chat": self.info["group"]})
			group = self.groupInfo
			lastId = self.server.database.fetchArray("SELECT * FROM `powers` ORDER BY `id` DESC LIMIT 1;")
			maxSect = int(lastId[0]['section'].replace("p", "")) + 1
			GroupPowersX = [0 for i in range(maxSect)]
			self.GroupPowers = []

			for row in assigned:
				if row['power'] not in Already:
					if row['enabled'] == 1:
						Enabled.append(row['power'])
					subid = 2 ** (int(row['power']) % 32)
					section = int(row['power']) >> 5
					GroupPowersX[section] += subid
					Already.append(row['power'])

			for i in GroupPowersX:
				self.GroupPowers.append(str(i))

			GroupPowers = "|".join(self.GroupPowers)
			gp  = "<gp "
			gp += 'p="' + GroupPowers + '" '
			gp += "g80=\"{'mm':'14','mbt':48,'ss':'14','prm':'14','dnc':'14','bdg':'8'}\" "
			gp += "g246=\"{'dt':70,'v':1}\" "
			gp += "g256=\"{'rnk':'2','dt':65,'rt':15,'rc':'1','tg':200,'v':1}\" "
			dct = {74:'gline', 90:'bad', 92:'horrorflix', 96:'winterflix', 98:'feastflix', 100:'link', 102:'loveflix', 112:'announce', 114:'pools', 148:'spookyflix', 156:'santaflix', 180:'gsound', 278:'springflix', 300:'summerflix'};
			for key, value in dct.items():
				if int(key) in Enabled and group[value] != None:
					gp += 'g' + str(key) + '="' + group[value] + '" '

			g106 = "#"
			if group['gscol'] != None:
				g106 = ("%s" %(group['gscol'])) + g106
			if group['gback'] != None:
				g106 += group['gback']
			if g106 != "#":
				gp += 'g106="' + g106 + '" '

			gp += "/>"
			return gp
		except:
			return '<gp p="0|0|0|0|0|0|0|0|0|0|0|0|0|0|0" />'

	def signOut(self, close=True):
		self.SignedOut = True
		try:
			self.send("<logout />")
			if close == True:
				self.disconnect()
		except:
			pass

	def disconnect(self):
		try:
			self.disconnected = True
			self.socket.close()
			self.socket.shutdown(1)
		except:
			pass

	def pools(self):
		pools = {0: 0}

		if len(self.GroupPools):
			for pool in self.GroupPools:
				pools[int(pool)] = 0

		for user in self.server.clients:
			try:
				if user.online and user.info['chat'] == self.info['chat']:
					if user.info['pool'] in pools.keys():
						pools[user.info['pool']] += 1
					else:
						pools[user.info['pool']] = 1
			except:
				continue

		return pools

	def getPool(self, pool = 0, clickedPool = False, Limit = False):
		usersInPool = 0

		if(str(pool) in self.GroupPools):
			if Limit:
				return self.getPool(int(pool) + 1, False, True)

			if pool == 1:
				if self.Assigned(114):
					if self.info["rank"] in [1, 2, 4]:
						if clickedPool == False:
							return self.getPool(int(pool) + 1, False)
						return 1
			elif pool == 2:
				if self.Assigned(114) and self.Assigned(126):
					if self.info["rank"] in [1, 2, 4] or self.info['banned']:
						if clickedPool == False and not self.info['banned']:
							return self.getPool(int(pool) + 1, False)
						return 2
			return self.getPool(0)

		if not pool in self.pools().keys() and not Limit:
			return self.getPool(0, clickedPool)

		for user in self.server.clients:
			if user.online and user.info['chat'] == self.info['chat'] and user.info['pool'] == pool and self.info['id'] != user.info['id']:
				usersInPool += 1

		if usersInPool >= self.poolLimit:
			pool += 1
			return self.getPool(pool, False, True)

		return pool

	def getClients(self):
		return self.server.clients

	def getSpectators(self, room):
		spectators = 1
		for user in self.server.clients:
			try:
				if user.online and user.info['chat'] == room and user.isSpectator:
					spectators += 1
			except:
				continue

		return str(spectators)

	def relogin(self):
		_user = self.server.database.fetchArray('select * from `users` where `id`= %(id)s', {"id": self.info['id']})
		self.send(self.server.doLogin(_user[0]['username'], _user[0]['password']))
		self.disconnect()

	def fixFloat(self, x=0.0):
		try:
			num = float(x)
			numSplit = str(num).split(".")
			if len(numSplit) == 2:
				if numSplit[1] == "0":
					num = numSplit[0]
			return num
		except ValueError:
			return 0.0

	def KickAll(self, room, kPool, kFlags = False):
		'''
		KICKALL_GUEST 0x100
		KICKALL_REG 0x200
		KICKALL_MUTE 0x300
		KICKALL_BAN 0x400
		'''
		for user in self.server.clients:
			if kFlags:
				if (kFlags & 0x100) and user.info['rank'] != 5:
					continue # only guests
				if not (kFlags & 0x200) and user.registered == True:
					continue # dont kick regged
				if (kFlags & 0x300) and user.talked == True:
					continue # dont kick talkers
				if (kFlags & 0x400) and user.info["banned"] == False:
					continue # only banned

			if user.info['chat'] != room:
				continue

			if int(user.info['pool']) not in [-1, kPool]:
				continue

			user.send('<logout e="E33" />')

	def gcontrolToRank(self, rank):
		''' MAIN = 1, OWNER = 4, MOD = 2, MEM = 3, GUEST = 5 '''
		if not rank:
			return False

		rank = int(rank)
		if rank == 0:#N/A
			return False
		elif rank == 2:#Guest
			return 5
		elif rank == 3:#Temp Member(Currently returns default)
			return False
		elif rank == 5:#Member
			return 3
		elif rank == 7:#Temp Moderator(Currently returns default)
			return False
		elif rank == 8:#Moderator
			return False
		elif rank == 10:#Temp Owner(Currently returns default)
			return False
		elif rank == 11:#Owner
			return 4
		elif rank == 14:#Main Owner
			return 1

		return False

	def minRankToArray(self, rank):
		''' MAIN = 1, OWNER = 4, MOD = 2, MEM = 3, GUEST = 5 '''
		rank = int(rank)
		if rank == 1:
			return [1]
		elif rank == 4:
			return [1, 4]
		elif rank == 2:
			return [1, 2, 4]
		elif rank == 3:
			return [1, 2, 3, 4]
		elif rank == 5:
			return [1, 2, 3, 4, 5]

		return [1]

	def setGroupControl(self):
		if self.Assigned(80) == False:
			return
		try:
			groupInfo = self.server.database.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":self.info["chat"]})[0]
			gControl = groupInfo['gcontrol']
			if gControl == "":
				return

			gControl = json.loads(gControl.replace("'", '"'))

			if 'mg' in gControl:
				self.makeGuest_minRank = self.gcontrolToRank(gControl['mg']) if self.gcontrolToRank(gControl['mg']) != False else self.makeGuest_minRank
			if 'mb' in gControl:
				self.makeMember_minRank = self.gcontrolToRank(gControl['mb']) if self.gcontrolToRank(gControl['mb']) != False else self.makeMember_minRank
			if 'mm' in gControl:
				self.makeModerator_minRank = self.gcontrolToRank(gControl['mm']) if self.gcontrolToRank(gControl['mm']) != False else self.makeModerator_minRank
			if 'kk' in gControl:
				self.kick_minRank = self.gcontrolToRank(gControl['kk']) if self.gcontrolToRank(gControl['kk']) != False else self.kick_minRank
			if 'bn' in gControl:
				self.ban_minRank = self.gcontrolToRank(gControl['bn']) if self.gcontrolToRank(gControl['bn']) != False else self.ban_minRank
			if 'ubn' in gControl:
				self.unBan_minRank = self.gcontrolToRank(gControl['ubn']) if self.gcontrolToRank(gControl['ubn']) != False else self.unBan_minRank
			if 'mbt' in gControl:
				self.maxBan_mod = int(gControl['mbt'])
			if 'obt' in gControl:
				self.maxBan_owner = int(gControl['obt'])
			if 'ss' in gControl:
				self.setScroller_minRank = self.gcontrolToRank(gControl['ss']) if self.gcontrolToRank(gControl['ss']) != False else self.setScroller_minRank
			if 'dnc' in gControl:
				self.canBeDunced_minRank = self.gcontrolToRank(gControl['dnc']) if self.gcontrolToRank(gControl['dnc']) != False else self.canBeDunced_minRank
			if 'bdg' in gControl:
				self.canBadge_minRank = self.gcontrolToRank(gControl['bdg']) if self.gcontrolToRank(gControl['bdg']) != False else self.canBadge_minRank
			if 'ns' in gControl:
				self.canNaughtyStep_minRank = self.gcontrolToRank(gControl['ns']) if self.gcontrolToRank(gControl['ns']) != False else self.canNaughtyStep_minRank
			if 'yl' in gControl:
				self.canYellowCard_minRank = self.gcontrolToRank(gControl['yl']) if self.gcontrolToRank(gControl['yl']) != False else self.canYellowCard_minRank
			if 'rc' in gControl:
				self.canRedCard_minRank = self.gcontrolToRank(gControl['rc']) if self.gcontrolToRank(gControl['rc']) != False else self.canRedCard_minRank
			if 'rf' in gControl:
				self.redCardFactor = int(gControl['rf'])
			if 'ka' in gControl:
				self.kickAll_minRank = self.gcontrolToRank(gControl['ka']) if self.gcontrolToRank(gControl['ka']) != False else self.kickAll_minRank
			if 'rl' in gControl:
				self.kickAll_minRank = self.gcontrolToRank(gControl['rl']) if self.gcontrolToRank(gControl['rl']) != False else self.canRankLock_minRank
			if 'sme' in gControl:
				self.kickAll_minRank = self.gcontrolToRank(gControl['sme']) if self.gcontrolToRank(gControl['sme']) != False else self.canSilentMember_minRank

			self.hasGControl = True
		except:
			print_exc()
			return

		return
		
	def DoJinx(self):
		return

	def joinRoom(self, reload = True, reload2 = False, load1 = False):
		# user info
		messagesStore = {"users":{}, "messages":[]}
		self.online = False
		packet = self.joinData
		self.info["id"] = int(packet["u"])
		self.info["name"] = str(packet["n"])
		self.info["avatar"] = str(packet["a"])
		self.info["home"] = str(packet["h"])
		self.info["q"] = 0
		self.info["typing"] = False
		self.info['info'] = {}
		self.info["Naughty"] = False
		self.info['GaggedTime'] = 0
		self.info['HushedTime'] = 0
		self.info["Banished"] = False
		self.info['temp'] = 0
		self.info['GameBanID'] = 0
		self.info['GameBanData'] = []
		self.info["sinbinned"] = False
		self.info["redcard"] = False
		self.registered = False
		self.isGagged = False
		self.isSpectator = False
		chatFlag = 0
		'''
		for blocked in self.server.config["blockedixats"]:
			if blocked in self.info["home"].lower().replace(" ", "") or "23.ip-5-196-225" in self.info["home"].lower().replace(" ", ""):
				self.info["home"] = ""
		'''
		# build u packet
		
		if self.connection["ip"] == "104.1.40.245":
			self.notice("Stop coming here, Phin.")
			self.signOut()
			return
		
		try:
			if self.info["id"] != 2:
				bind = {}
				self.info["k"] = int(packet["k"])
				query = "id = %(id)s and k = %(k)s"
				bind["id"] = self.info["id"]
				bind["k"] = self.info["k"]
				if "N" in packet.keys():
					self.registered = True
					self.info["username"] = str(packet["N"])
					self.info["k3"] = int(packet["k3"])
					bind["username"] = self.info["username"]
					bind["k3"] = self.info["k3"]
					query += " and username = %(username)s and k3 = %(k3)s"
					self.info["q"] = 1
				else:
					self.info["username"] = ""
				if int(self.yPacket["u"]) != int(self.info["id"]):
					raise Exception("u != id")
				self.userInfo = self.server.database.fetchArray("SELECT * FROM `users` WHERE " + query, bind)[0]
				self.null = False
			else:
				if int(self.yPacket["u"]) != 0:
					raise Exception("u != id")
				self.info["id"] = int(str(int(time())) + str(randint(0, 1000)))
				self.userInfo = {}
				self.null = True
		except:
			self.notice("Please relogin to start chatting.")
			self.signOut()
			return

		myPowers = {}
		pCount = int(self.server.database.fetchArray('select count(distinct `section`) as `count` from `powers`;')[0]['count'])

		for index in range(0, pCount):
			try:
				myPowers[index] = int(packet["d" + str(index + 4)])
				if "N" not in packet.keys():
					self.notice("Please relogin to start chatting.")
					self.signOut()
					return
			except:
				myPowers[index] = 0

		powers = {}
		myPowers2 = myPowers.copy()
		if "N" in packet.keys():
			self.info["q"] = 3
			powers = self.getUserPowers()
			if powers[0] is -1:
				self.notice("Please relogin to start chatting.")
				self.signOut()
				return
			for key in powers:
				myPowers2[key] -= powers[key]
				if myPowers2[key] != 0:
					if self.userInfo['torched'] == 1:
						return self.send(self.server.doLogin(self.userInfo['username'], self.userInfo['password']))
					else:
						return self.send(self.server.doLogin(self.userInfo['username'], self.userInfo['password']))
						#self.notice("Please relogin to start chatting.")
						#self.signOut()
					return
				elif powers[key] != myPowers[key]:
					if self.userInfo['torched'] == 1:
						return self.send(self.server.doLogin(self.userInfo['username'], self.userInfo['password']))
					else:
						return self.send(self.server.doLogin(self.userInfo['username'], self.userInfo['password']))
						#self.notice("Please relogin to start chatting.")
						#self.signOut()
					return

		if int(self.yPacket['r']) != int(self.info["chat"]):
			self.notice("Please relogin to start chatting. 4")
			self.signOut()
			return

		try:
			self.info['trolls'] = json.loads(self.userInfo['trolls'])
			for i, info in enumerate(self.info['trolls']):
				if info == "nickname": # legacy
					info = "name"
				self.info[info] = self.info['trolls'][info]
		except ValueError:
			self.info['trolls'] = None
			pass
		except KeyError:
			self.info['trolls'] = None
			pass

		# group info
		try:
			self.groupInfo = self.server.database.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":self.info["chat"]})[0]
			self.info["group"] = self.groupInfo["name"]
			try:
				self.rankInfo = self.server.database.fetchArray("SELECT * FROM `ranks` WHERE chatid = %(chatid)s and userid = %(userid)s", {"chatid": self.info["chat"], "userid": self.info["id"]})[0]
				self.info["rank"] = int(self.rankInfo['f'])
				if self.rankInfo['tempend'] != 0:
					self.info['temp'] = float(self.rankInfo["tempend"])
					if (self.info['temp'] - float(time())) <= 0:
						if self.info["rank"] == 4:  # was owner
							self.info["rank"] = 2  # now moderator
						elif self.info["rank"] == 2:  # was moderator
							self.info["rank"] = 3  # now member
						elif self.info["rank"] == 3:  # was member
							self.info["rank"] = 5  # now guest
						self.server.database.query("UPDATE `ranks` set `f`=%(f)s, `tempend`=0 WHERE chatid=%(chatid)s and userid=%(userid)s", {"f": self.info["rank"], "chatid": self.info["chat"], "userid": self.info["id"]})
				else:
					self.info['temp'] = 0
			except:
				self.info["rank"] = 5
		except:
			self.notice("Chat not found.")
			self.signOut()
			return

		'''Handle gControl'''
		self.setGroupControl()

		if int(self.groupInfo['flag']) & 0x200000:
			chatFlag |= 0x200000
			self.info['live_mode'] = True
			if int(self.info["rank"]) == 5:
				self.isSpectator = True

		self.info["flags"] = 0
		chatFlag |= 64
		#self.info["flags"] += 64  # isGroup
		self.info["rank2"] = self.info["rank"]
		if int(self.info["id"]) in self.server.authorizedBots and int(self.info["id"]) != 6:
			self.info['flags'] += 0x2000
		if hasattr(self, 'rankInfo'):
			if float(self.rankInfo['sinbin']) - time() > 0:
				self.info['flags'] += 0x0200
				self.info["sinbinned"] = True
			elif int(self.rankInfo['sinbin']) != 0:
				self.server.database.query("update `ranks` set `sinbin` = 0 where `userid` = %(id)s", {"id": self.info["id"]})
		bans = self.server.database.fetchArray("SELECT * FROM `bans` WHERE chatid = %s and userid = %s or ip = %s and chatid = %s", (str(self.info["chat"]), str(packet["u"]), str(self.connection["ip"]), str(self.info["chat"])))
		self.info["banned"] = False
		self.info['gamebanned'] = False
		self.info["rc_bannedtime"] = 0

		try:
			Hush = json.loads(self.groupInfo['hush'])
			hushedRank = int(Hush["rank"])
			hushedTime = int(Hush["time"])
			self.info['HushedTime'] = int(int(hushedTime))
			if self.info['HushedTime'] - int(time()) > 0:
				if not self.server.higherRank(self.info['rank'], hushedRank) and self.info['rank'] != hushedRank:
					if not self.isGagged:
						self.isGagged = True
						self.info["flags"] += 256
					self.send('<m t="/p0,' + str(self.info['HushedTime'] - int(time())) + '" d="0" />')
				else:
					self.info['HushedTime'] = 0
			if self.info['rank'] in [1, 4]:
				self.info['info']['/h'] = "_/h " + str(Hush["userid"])
		except:
			pass

		bannedTime = 0
		bannedParam = ""
		bannedType = ""
		wType = 0
		bannedSend = ""

		for ban in bans:
			if ban["special"] == 0 and int(self.info["rank"]) != 1:
				bannedTime = float(ban["unbandate"]) - float(time())
				bannedParam = "/" + ban["type"] + str(int(bannedTime))
				bannedType = ban["type"]
			elif ban["special"] != 0 and int(self.info["id"]) == int(ban["userid"]):
				if ban["type"] == "gd":
					self.info["flags"] += 32768
				elif ban["type"] == "gn":
					self.info["flags"] += 524288
					self.info["Naughty"] = True
					self.info["NaughtyTime"] = int(time())
					if not self.isGagged:
						self.isGagged = True
						self.info["flags"] += 256
					self.send('<m t="/p0,30" d="0" />')
				elif ban["type"] == "gg":
					if (float(ban["unbandate"]) - time()) > 0:
						if not self.isGagged:
							self.isGagged = True
							self.info["flags"] += 256
						self.info['GaggedTime'] = float(ban["unbandate"])
						self.send('<m t="/p0,' + str(self.info['GaggedTime'] - float(time())) + '" d="0" />')
					else:
						self.server.database.query("delete from `bans` where chatid=%(chatid)s and special=41 and userid=%(userid)s", {"chatid": self.info["chat"], "userid": self.info['id']})
				elif ban["type"] == "gy":
					self.info["flags"] += 0x100000
				elif ban["type"] == "gr":
					self.info["rc_bannedtime"] = float(ban["unbandate"]) - float(time())
					self.info["redcard"] = True
					self.info["flags"] += 2097152
				else:
					if int(ban['special']) in self.server.gameBans:
						bannedTime = float(ban["unbandate"]) - float(time())
						bannedParam = "/" + ban["type"] + str(int(ban["unbandate"]))
						bannedType = ban["type"]
						self.info['gamebanned'] = True
						self.info['app'] = int(ban["special"])
					wType = ban["special"]

		Muted = False

		if bannedTime > 0:
			self.info["banned"] = True
			self.info["rank2"] += 16
			if bannedType != "gm":
				cPacket = '<c d="' + str(self.info["id"]) + '" t="' + bannedParam + '" u="0" '
				if wType == 0 and bannedTime > 3600 and self.Assigned(70):
					self.info["Banished"] = True
					self.info["flags"] += 0x1000
				if wType != 0 and wType in self.server.gameBans:
					cPacket += 'w="' + str(wType) + '" '
				self.send(cPacket + '/>')
			else:
				Muted = True
		else:
			self.info["banned"] = False
			if bannedParam != "":
				self.server.database.query("delete from `bans` where chatid=%(chatid)s and special=0 and ip=%(ip)s", {"chatid": self.info["chat"], "ip": self.connection["ip"]})

			if "b" in packet.keys():
				self.send('<c d="' + str(self.info["id"]) + '" t="/u" u="0" />')

		PoolSatisfied = False
		self.GroupPools = []

		if self.Assigned(114):
			RankPool = "1"
			if self.Assigned(126) and wType == 0:
				RankPool = "2 " + RankPool
				if self.info['banned'] and not Muted:
					PoolSatisfied = True
					self.info['pool'] = 2

			self.GroupPools = RankPool.split(" ")

		if not PoolSatisfied:
			if self.info['ChangePool'] != -1:
				self.info['pool'] = 0
				self.info['pool'] = self.getPool(self.info['ChangePool'], True)
				self.info['ChangePool'] = -1
			else:
				if "pool" in packet.keys():
					pool = int(packet["pool"])
				else:
					pool = 0

				if not self.info['KeepPool']:
					self.info['pool'] = 0
					self.info["pool"] = self.getPool(pool)

		if "away" in self.info:
			if self.info["away"] == True:
				self.info["flags"] += 0x4000
		self.joinData["pool"] = self.info["pool"]

		if len(self.pools()) > 1 and self.info['live_mode'] == False:
			pools = self.pools().keys()
			pools2 = []
			for pool in pools:
				pools2.append(str(pool))
			self.send('<w v="' + str(self.info["pool"]) + ' ' + str(" ".join(sorted(pools2))) + '" />')
		else:
			self.send('<w v="0" />')

		self.userPacket = "<u "
		self.customPawn = ""
		self.customCyclePawn = ""

		if wType != 0:
			self.info['app'] = int(wType)
			self.userPacket += 'w="' + str(wType) + '" '

		if "custpawn" in self.userInfo.keys():
			if self.userInfo["custpawn"] != "off" and self.userInfo["custpawn"] != "":
				self.customPawn = self.userInfo["custpawn"].strip("#")
				self.userPacket += 'pawn="' + self.customPawn + '" '

		if "custcyclepawn" in self.userInfo.keys():
			if self.userInfo["custcyclepawn"] != "off" and self.userInfo["custcyclepawn"] != "":
				self.customCyclePawn = self.userInfo["custcyclepawn"]
				self.userPacket += 'cyclepawn="' + self.customCyclePawn + '" '

		"""
		for key in powers:
			value = powers[key]
			if int(value) != 0:
				if 'm'+str(key) in self.joinData:
					value -= int(self.joinData['m'+str(key)])
				if value < 0 or value > 2147483647:
					value = 0
				self.userPacket += 'p' + str(key) + '="' + str(value) + '" '
			self.EnabledPowers[key] = value
		"""

		for key in self.EnabledPowers:
			# if(ep) SockInfo[i].PowersF[95/32] |= 1<<(95%32); // give them everypower
			self.userPacket += 'p' + str(key) + '="' + str(self.EnabledPowers[key]) + '" '

		self.info["flags"] += self.info["rank2"]

		self.userPacket += 'f="' + str(self.info["flags"]) + '" '
		self.userPacket += 'flag="' + str(self.info["flags"]) + '" '

		self.userPacket += 'rank="' + str(self.info["rank2"]) + '" '
		self.userPacket += 'u="' + str(self.info["id"]) + '" '

		if "N" in packet.keys() and self.null == False:
			self.userPacket += 'N="' + self.info["username"] + '" '

		# nickname info
		self.userPacket += 'n=' + quoteattr(self.info["name"]) + ' '
		self.userPacket += 'a=' + quoteattr(self.info["avatar"]) + ' '
		self.userPacket += 'h=' + quoteattr(self.info["home"]) + ' '

		if self.info['app'] != 0:
			self.userPacket += 'x="' + str(self.info['app']) + '" '

		#hasGifts = self.server.database.fetchArray("select * from `gifts` where `b`=%(b)s", {"b": self.info["id"]})

		if "d2" in packet.keys() and int(self.userInfo["d2"]) != 0 and "N" in packet.keys() and self.null == False:
			if int(self.userInfo["d2"]) == int(packet["d2"]) and int(self.userInfo["d0"]) == int(packet["d0"]):
				#if len(hasGifts) > 0:
					#self.userInfo["d0"] |= 1<<24
				self.userPacket += 'd0="' + str(int(self.userInfo["d0"])) + '" '
				self.userPacket += 'd2="' + str(self.userInfo["d2"]) + '" '
			else:
				self.notice("Please relogin to start chatting.")
				self.signOut()
				return
		elif "d2" in packet.keys():
			self.notice("Please relogin to start chatting.")
			self.signOut()
			return

		self.userPacket += 'v="2" '
		self.userPacket += 'q="' + str(self.info["q"]) + '" '
		
		if len(self.jinx) > 0:
			self.userPacket += 'j="'+str(self.jinx)+'" '
			
		#self.userPacket += 'j="1576454400jumble100" '

		self.info['userPacket'] = self.userPacket
		self.info['members_only'] = False
		if int(self.groupInfo['flag']) & 128:
			chatFlag |= 128
			#self.info['flags'] += 128
			self.info['members_only'] = True
		else:
			self.info['members_only'] = False

		if int(self.groupInfo['flag']) & 0x80000 and self.info['rank'] == 1:
			updatedFlags = self.groupInfo['flag']
			updatedFlags &= ~0x80000
			self.server.database.query("update `chats` set `flag`=%(flag)s where `id`=%(id)s", {"id": self.info['chat'], "flag":updatedFlags})
			for user in self.server.clients:
				if user.info['chat'] == self.info['chat'] and self.info['id'] != user.info['id']:
					user.send('<logout e="E33" />')

			#self.KickAll(self.info['chat'], -1)

		try:
			self.attachedInfo = self.server.database.fetchArray('SELECT `id`,`name` FROM `chats` WHERE `name`=%(name)s', {"name": self.groupInfo['attached']})[0]
			#self.info['flags'] += 2
			chatFlag |= 2
		except:
			self.attachedInfo = {"id": "", "name": ""}

		if self.info['rank'] in [1, 4] and self.hasPower(29, True) and not self.hidden:
			self.info['flags'] += 0x0400
			chatFlag |= 0x0400
			self.hidden = True
		else:
			self.hidden = False

		if int(self.groupInfo['flag']) & 0x20000:#DefNoSound
			chatFlag |= 0x20000
			#self.info['flags'] += 0x20000

		if int(self.groupInfo['flag']) & 0x800:#NoSmilieLine
			chatFlag |= 0x800
			#self.info['flags'] += 0x800

		self.infoPacket = "<i "
		if wType != 0:
			self.infoPacket += 'w="' + str(wType) + '" '
		if self.customPawn != "":
			self.infoPacket += 'pawn="' + self.customPawn + '" '
		if self.customCyclePawn != "":
			self.infoPacket += 'cyclepawn="' + self.customCyclePawn + '" '
		self.infoPacket += 'b="' + self.groupInfo["bg"] + ';=' + self.attachedInfo["name"] + ';=' + str(self.attachedInfo["id"]) + ';=;=' + self.groupInfo["radio"] + ';=' + self.groupInfo["button"] + '" '
		self.infoPacket += 'f="' + str(chatFlag) + '" '
		self.infoPacket += 'f2="' + str(self.info['flags']) + '" '
		self.infoPacket += 'v="3" '
		self.infoPacket += 'r="' + str(self.info["rank"]) + '" '
		self.infoPacket += 'cb="' + str(self.loginTime) + '" '
		if len(str(self.groupInfo['bot'])) > 0:
			self.infoPacket += 'B="' + str(self.groupInfo['bot']) + '" '
		if len(self.jinxMain) > 0:
			self.infoPacket += 'j="'+str(self.jinxMain)+'" '
		self.infoPacket += '/>'

		#if self.hidden:
		#	self.info["flags"] -= 1024

		self.send(self.infoPacket + chr(0) + self.buildGp())

		sendUsers = []
		hiddenUsers = []

		offlineMessages = self.server.database.fetchArray('SELECT * FROM `pvtlog` WHERE recipient=%(id)s', {"id": self.info['id']})
		for omessage in offlineMessages:
			if omessage['msgtype'] == "PC" and int(omessage['offline']) == 1:
				offlineMessage = '<p o="1" '
				offlineMessage += 'u="' + str(omessage['sender']) + '" '
				offlineMessage += 't=' + quoteattr(omessage['message']) + ' '
				offlineMessage += 's="2" '
				offlineMessage += 'd="' + str(self.info['id']) + '" '
				offlineMessage += 'T="' + str(omessage['date']) + '" '
				if omessage['username'] != '':
					offlineMessage += 'N=' + quoteattr(str(omessage['username'])) + ' '
				if omessage['nickname'] != '':
					offlineMessage += 'n=' + quoteattr(str(omessage['nickname'])) + ' '
				if omessage['avatar'] != '':
					offlineMessage += 'a=' + quoteattr(str(omessage['avatar'])) + ' '
				if omessage['homepage'] != '':
					offlineMessage += 'h=' + quoteattr(str(omessage['homepage'])) + ' '
				offlineMessage += '/>'
				self.send(offlineMessage)
				self.server.database.query('update `pvtlog` set offline=0 WHERE id=%(id)s', {"id": omessage['id']})

		for user in self.server.clients:
			if user.online == True and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"]:
				try:
					if (user.info["id"] == self.info["id"]) or user.null == True and self.null == True and user.connection["ip"] == self.connection["ip"]:
						user.duplicate = True
						user.send("<dup />")
						user.updateTimeOnline()
						user.disconnect()
					elif (reload == True or reload2 == True) and user.info["id"] != self.info["id"]:
						if self.info['rank'] == user.info['rank'] or not self.hidden or self.server.higherRank(user.info['rank'], self.info['rank']):
							if not user.info["Banished"] or user.info["Banished"] and self.info["rank"] in [1, 2, 4]:
								user.send(self.userPacket + "/>")
						if self.online == False and reload2 == False:
							if user.info['rank'] == self.info['rank'] or not user.hidden or self.server.higherRank(self.info['rank'], user.info['rank']):
								if not self.info["Banished"] or self.info["Banished"] and user.info["rank"] in [1, 2, 4]:
									sendUsers.append(user.userPacket + "s=\"1\" />")
									if user.hidden:
										hiddenUsers.append(user.info['id'])
						if user.info["typing"]:
							sendUsers.append('<m t="/RTypeOn" u="' + str(user.info["id"]) + '" />')
				except:
					print_exc()
					pass

		if len(sendUsers) > 0:
			self.send(chr(0).join(sendUsers))
		messagesSend = []

		NoStore = False
		if int(self.groupInfo['flag']) & 0x100:
			NoStore = True

		if reload == True and self.info['pool'] == 0 and not self.info["Banished"] and NoStore == False:
			messages = self.server.database.fetchArray('SELECT * FROM `messages` where id = %(id)s AND port = %(port)s and pool = %(pool)s ORDER BY `mid` DESC LIMIT 0,14;',
			                                           {"id": self.info['chat'], "pool": self.info["pool"], "port": self.server.connection['port']})
			offlineUsers = {}
			for index,i in enumerate(messages):
				message = messages[len(messages)-index-1]
				if message['uid2'] == 0:
					if int(message['visible']) == 1:
						attributes = {"u":message['uid'], "n":message['name'],  "a":message['avatar'], "s":1}
						sort = ["u", "a" "n", "s"]
						try:
							if len(message['registered']) > 0:
								attributes["N"] = message['registered']
								sort.append("N")
						except:
							pass
						packet = '<m t=' + quoteattr(str(message['message'])) + ' u="' + str(message['uid']) + '" i="' + str(message['mid']) + '" s="1" />'
						user = self.server.getUserByID(int(message['uid']), self.info['chat'])
						if user == False:
							offline = True
						elif user != False and self.info['chat'] != user.info['chat'] or user != False and self.info['chat'] == user.info['chat'] and self.info['pool'] == user.info['pool'] and user.hidden and user.info['id'] not in hiddenUsers:
							offline = True
						else:
							offline = False
						if offline:
							offlineUsers[message['uid']] = [attributes, sort]
						messagesSend.append(packet)
				else:
					if int(message['visible']) == 1:
						banParams = ""
						if len(message['reason']) > 0:
							banParams += 'p=' + quoteattr(message['reason']) + ' '
						banParams += 't="' + message['message'] + '" '
						if message['special'] != 0:
							banParams += 'w="' + str(message['special']) + '" '
						banParams += 'u="' + str(message['uid']) + '" '
						banParams += 'd="' + str(message['uid2']) + '" '
						banParams += 'i="' + str(message['mid']) + '" '
						banParams += 's="1" '
						#self.send('<m ' + banParams + '/>')
						messagesSend.append('<m ' + banParams + '/>')

			offlinePacket = []

			for i, user in enumerate(offlineUsers):
				offline = offlineUsers[user]
				offlinePacket.append(self.buildPacket("o", offline[0], offline[1]))

			if len(offlinePacket) > 0:
				self.send(chr(0).join(offlinePacket))

		if int(self.groupInfo['ch']) != 0:
			if self.info['rank'] in [1, 4]:
				self.info['info']['/s'] = "_/s " + str(self.groupInfo['ch'])

			messagesSend.append('<m t="/s' + self.groupInfo['sc'] + '" u="0" />')
			# self.send('<m t="/s' + self.groupInfo['sc'] + '" u="0" />')

		if len(messagesSend) > 0:
			if self.info['members_only'] and self.info['rank'] == 5:
				pass
			else:
				self.send(chr(0).join(messagesSend))

		if self.null == False:
			self.server.database.query('update `users` set nickname=%(nickname)s, avatar=%(avatar)s, url=%(url)s, connectedlast=%(cl)s WHERE id=%(id)s', {"nickname": self.info['name'], "avatar": self.info["avatar"], "url": self.info["home"], "cl": self.connection["ip"], "id":self.info["id"]})

		if self.null:
			nb = "Be sure to register as obtaining unregistered userids are disabled. You can register by filling out the registration form on"
			self.notice(nb + " http://ixat.io/profile")
			self.notice(nb + " the login / register / profile page.", True)

		if self.online == False:
			if not self.sentJ2:
				if self.info['live_mode']:
					self.sendRoom('<u u="4294967295" n="' + self.getSpectators(self.info["chat"]) + '" />')
				self.send('<done />')
				self.joinedTime = int(time())
				self.sentJ2 = True
			self.online = True

		self.info['KeepPool'] = False
		self.server.LastChat[self.info["id"]] = self.info["chat"]

	def run(self):
		self.socket.setblocking(0)

		while True:
			try:
				try:
					if self.SignedOut or self.disconnected:
						raise Exception("Signed out")
					self.select = select.select([self.socket], [], [], 0.01)

					if self.select[0]:
						self.data = bytes.decode(self.socket.recv(self.bytes), "utf-8")
						try:
							if not self.data:
								raise Exception("Disconnected")
							if self.connection["ip"] in self.server.config["ipbans"]:
								raise Exception("IP BANNED")
							psplit = self.data.replace("", "").split(chr(0), 6)
							if len(psplit) >= 1:
								for packet in psplit:
									if packet != "":
										if packet[:1] == "<":
											#if self.online == True and self.info["id"] == 4:
											#	self.send('<m t=' + quoteattr(packet) + ' u="0" />')
											self.activeTime = time()
											self.parse(packet)
										else:
											raise Exception("Not XML")
									#if self.policy == True:
									#	raise Exception("policy")
								if self.online and self.registered:
									self.updateTimeOnline()
							else:
								raise Exception("...")
						except BaseException as e:
							raise Exception("Error: " + str(e))
				except BlockingIOError:
					continue
				except BaseException as e:
					raise Exception(e)
			except BaseException as e:
				self.SignedOut = True
				self.server.write("Client closed [" + self.connection["ip"] + ":" + str(self.connection["port"]) + "] -> " + str(e), "Server")
				self.disconnected = True
				self.server.checkConnections()
				break