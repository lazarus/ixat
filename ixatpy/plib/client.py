import socket
from xml.etree import ElementTree as etree
from xml.sax.saxutils import quoteattr
from threading import Thread
from time import time, sleep, process_time
from re import escape
from traceback import print_exc, format_exc, format_stack
from sys import stdout
from random import randint
import select
import json
from plib.parser import Parser
import queue
import logging
from socket import SO_ERROR
from math import floor
import struct
from math import pow
import array

class Client(Thread):

	def __init__(self, sock, address, parent):
		Thread.__init__(self)
		
		sock.setblocking(0)
		sock.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
		sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPIDLE, 1)
		sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPINTVL, 3)
		sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPCNT, 5)

		self.data = ""

		self.connecttime = time()
		self.SignedOut = False
		self.gotTickled = False
		self.sendTo = None
		self.socket = None
		self.connection = {}
		self.disconnected = False
		self.online = False
		self.policy = False
		self.sentY = False
		self.sentJ2 = False
		self.duplicate = False
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
		
		self.wType = 0
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

		#Newly Added
		self.talked = False
		self.isSpectator = False
		self.jinx = ""
		self.jinxMain = ""
		self.mob = False
		self.RateInfo = None

		#Techy's
		self.GameRace = {60189:{},60193:{},60195:{},60201:{},60225:{},60239:{},60247:{},60257:{}}

		#Group Control
		self.hasGControl = False
		
		self.groupControl = {}

		#WebSocket
		self.webSocket = -1
	
	@st_time
	def bcmod(self, left=0, mod=0):
		return int(left) % int(mod)

	@st_time
	def send_xml(self, node, attr=None, sort=None, how=False, exclude_or_online=False, excludeid=0):	
		if node == '':
			return False
		data = self.buildPacket(node, attr, sort)
		if how == 1:
			self.sendRoom(data, exclude_or_online, excludeid)
		elif how == 2:
			self.sendAll(data, exclude_or_online)
		else:
			self.send(data)
		
	@st_time
	def send(self, packet, tries=0, wsOpcode=WebSocket2.OPCODES["text"]):
		if self.socket.fileno() == -1 or tries > 10:
			self.shutdown()
			self.socket.close()
		
		try:
			if not packet:
				return
				#raise Exception("Bad packet")
			elif self.webSocket:
				packets = packet.split("\x00")
				for packet in packets:
					#server.write([packet, wsOpcode], "websocket packet")
					self.websock.on_message(packet.encode(), self.wsOpcode if self.wsOpcode else wsOpcode)
					#self.socket.send(websocket.encode(packet))
			else:
				self.socket.sendall(bytes((packet + chr(0)).encode("utf-8", "ignore")))
		except(BrokenPipeError, TypeError):
			server.write("This fukin client shit broke fam (disconnected, but packet tried to send anyway). ", self.connection["ip"] + ":" + str(self.connection["port"])+", ID: " + str(self.info["id"]) + ", FileNo: " + str(self.socket.fileno()))
			#print(packet.encode("utf-8", "ignore"))
			#server.write(format_exc())
		except OSError:
			pass
		except:
			server.write("client.send  " + format_exc(), "Client")
			self.send(packet, tries + 1)

	def send2(self, data):
		#server.write("to ws: %s" % data, "sadasdsadas")
		self.socket.send(data)
	
	@st_time
	def sendPacket(self, packet):
		self.send(packet)
	
	@st_time
	def strip_u(self, userId):
		return userId[: (userId + '_').find('_')]
			
	@st_time
	def resetOnlineTime(self, hreset=True):
		if hreset:
			self.joinedTime = int(time())
		self.logoutTime = int(time())
		self.timeOnline = (self.logoutTime - self.joinedTime)
		self.joinedTime = int(time())
	
	@st_time
	def updateTimeOnline(self):
		if self.online and self.registered:
			self.resetOnlineTime(False)
			for user in server.clients:
				if user.online and user.registered and user.info['id'] == self.info['id'] and user.connection['port'] != self.connection['port']:
					user.resetOnlineTime(False)
					if user.timeOnline >= self.timeOnline:
						self.timeOnline = user.timeOnline
			if self.timeOnline != 0:
				database.query('update `users` set time_online=time_online+%(to)s WHERE `id`=%(id)s', {'to': self.timeOnline, 'id': self.info['id']})
	
	@st_time
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

		'''
		'' testing packet integrity '''
		try:
			test = etree.fromstring(packet + '/>')
		except:
			server.write("Client.buildPacket Packet integrity check failed.", "Client")

		return packet+'/>'
	
	@st_time
	def hasPower(self, PowerID=0, MustBeEnabled=True):
		if not self.gotPowers:
			return False
		section = int(PowerID) >> 5
		subid = int(pow(2, int(PowerID) % 32))
		if MustBeEnabled == True:
			if section in self.EnabledPowers and self.EnabledPowers[section] & subid:
				return True
		else:
			if self.loadedIndex[section] & subid:
				return True
		return False
	
	@st_time
	def getUserPowers(self):
		self.gotPowers = False
		self.loadedPowers = {}
		self.loadedIndex = {}
		self.info["powers"] = {}
		powers = database.fetchArray('select id from `powers` where `name` not like \'%(Undefined)%\';')
		userpowers = server.GetUserPower(self.info["id"])
		for power in powers:
			if int(power['id']) < 0:
				power['id'] = str(abs(int(power['id'])) + config.X_CUSTOM_OFFSET)
			section = int(power["id"]) >> 5
			subid = int(pow(2, int(power['id']) % 32))
			self.loadedPowers[int(power["id"])] = {"section":section, "subid":subid}
			if not self.loadedPowers[int(power["id"])]["section"] in self.loadedIndex.keys():
				self.loadedIndex[self.loadedPowers[int(power["id"])]["section"]] = 0

		self.EnabledPowers = {}
		if int(self.userInfo['torched']) == 1:
			return self.loadedIndex
		if int(self.info["id"]) == 804:
			for power in powers:
				if int(power['id']) < 0:
					power['id'] = str(abs(int(power['id'])) + config.X_CUSTOM_OFFSET)
				section = int(power["id"]) >> 5
				subid = int(pow(2, int(power['id']) % 32))
				try:
					if section in self.EnabledPowers.keys():
						self.EnabledPowers[section] |= subid
					else:
						self.EnabledPowers[section] = subid
				except:
					self.EnabledPowers[section] = 0

				if(self.loadedIndex[section] & subid) == 0:
					self.loadedIndex[section] |= subid
		else:
			for power in userpowers:
				if int(power) < 0:
					power = str(abs(int(power)) + config.X_CUSTOM_OFFSET)
				section = int(power) >> 5
				subid = int(pow(2, int(power) % 32))
				try:
					if section in self.EnabledPowers.keys():
						self.EnabledPowers[section] |= subid
					else:
						self.EnabledPowers[section] = subid
				except:
					self.EnabledPowers[section] = 0
				if(self.loadedIndex[section] & subid) == 0:
					self.loadedIndex[section] |= subid
					if 'm'+str(section) in self.joinData.keys() and int(self.joinData['m'+str(section)]) & int(subid):
						self.EnabledPowers[section] -= int(subid)
				else:
					return [-1]

		self.gotPowers = True
		# skeleton response {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0}
		return self.loadedIndex
			
	@st_time
	def getGroupPowers(self):
		gp = database.fetchArray("SELECT power FROM `group_powers` WHERE `assignedBy`=%(id)s", {"id": self.info["id"]})
		list = {}
		if len(gp) > 0:
			for row in gp:
				if row['power'] in list.keys():
					list[row['power']] += 1
				else:
					list[row['power']] = 1
					
			return list
			
		return False
	
	@st_time
	def Assigned(self, powerid):
		try:
			float(powerid)
		except:
			power = database.fetchArray("SELECT id FROM `powers` WHERE 'name'=%(name)s", {"name": powerid})
			if not len(power):
				return False
			else:
				if int(power[0]['id']) < 0:
					power[0]['id'] = str(abs(int(power[0]['id'])) + config.X_CUSTOM_OFFSET)
				powerid = power[0]['id']

		assigned = database.fetchArray("SELECT power FROM `group_powers` WHERE `chat`=%(group)s AND `power`=%(id)s AND `enabled`=1", {"group": self.info["group"], "id": powerid})
		if len(assigned) > 0:
			return True
		else:
			return False
	
	@st_time
	def WriteEvent(self, i=-1, j=-1, Room=-1, Mode=False, Seconds=False, text=False, Power=False):
		if Mode == "mM":
			Mode = "mo"

		p = {
			"time"  : time(),
			"roomid": int(Room)
		}

		if i != -1:
			p["id"] = int(self.info["id"])
			p["ip"] = self.connection["ip"]
			if self.registered:
				p["iname"] = self.info["username"]

		if j != -1:
			try:
				user = server.getUserByID(int(j), int(self.info["chat"]))
				p["jd"] = user.info["id"]
				p["jp"] = user.connection["ip"]
				if user.registered:
					p["jname"] = user.info["username"]
			except:
				p["jd"] = j
		else: # ID passed down
			p["jd"] = j

		if text:
			p["text"] = text[:100]
		if Seconds:
			p["secs"] = Seconds
		if Power:
			p["power"] = Power
		
		p["mode"] = Mode

		database.insert("events", p)
	
	def handle(self, tag="m", attributes=None):
		try:
			with server.rlock:
				if tag[0] == "w":
					attributes = {"v": int(tag[1:])}
					tag = "w"
				tag = tag.lower()

				if tag == "globalmessage":
					if self.connection["ip"] in config.X_BYPASS_IPS:
						tag = "globalMessage"
						server.call(tag, "handler", attributes, self)
						return True
					print(self.connection["ip"])
				'''		
				if self.connection["ip"] == "127.0.0.1" and tag == "globalmessage":
					tag = "globalMessage"
					server.call(tag, "handler", attributes, self)
					return True
				'''
				if tag in config.X_BYPASS_PACKETS and self.online == False:
					if tag != "policy-file-request":
						server.call(tag, "handler", attributes, self)
						return True
					elif tag == "policy-file-request" and self.policy == False and self.online == False:
						self.policy = True
						self.send(server.policyFile)
						return True
					else:
						return False
				elif tag + ":handler" in server.handlers.keys() and self.online is True:
					server.call(tag, "handler", attributes, self)
					return True
				else:
					server.write("Non-Bypass packet: " + tag)
					server.write(attributes)
					return False
		except:
			server.write(format_exc())
			return False
	
	@st_time
	def parse(self, packet):
		try:
			if config.DEBUGLVL & config.DEBUGLVL_RECV:
				server.writeDebug(0x7ffffff, "Recieved " + str(packet))
				
			if str(packet[:2]) == "<f" or 't="/back"' in str(packet):
				parser = Parser()
				parser.feed(packet)
				#self.handle(parser.tag, parser.attrib)
				server.queue.put([0, self, parser])
			else:
				xml = etree.XML(packet)
				server.queue.put([0, self, xml])
				#self.handle(xml.tag, xml.attrib)
		except:
			print("Bad packet: " + packet.encode('utf-8', 'replace'))
			server.write(format_exc())
			pass
				
	@st_time
	def userTick(self):
		'''protect checker'''
		if 'chat' in self.info:#maybe they sent a packet that hasnt initilized the user class
			if int(self.info['chat']) in server.Protected:
				if floor((server.Protected[int(self.info['chat'])]['end'] - time()) / 60) <= 0:
					self.send_xml('m', {'t': 'Protect Deactivated!(' + str(server.Protected[int(self.info['chat'])]['id']) + ')', 'u': '0'}, None, 1)
					del server.Protected[int(self.info['chat'])]
		'''add other shit'''
		return
	
	@st_time
	def notice(self, string="", notice=False):
		if not notice:
			self.send_xml('n', {'t': (str(string))})
		elif notice:
			self.send_xml('m', {'t': (str(string)), 'u': '0'})
	
	@st_time
	def escape(self, string=""):
		return quoteattr(string)
	
	@st_time
	def sendMessage(self, message=""):
		if message == '':
			return

		for user in server.clients:
			if user.online and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"] and user.info["id"] != self.info["id"] and not user.info["Banished"]:
				try:
					if user.info['members_only'] and user.info['rank'] == 5:
						continue
					user.send_xml("m", {"t": message, "u": self.info["id"], "T": str(int(time())), "i": 0, "r": self.info["chat"]}, ["t","u","T","i","r"])
				except:
					pass
	
	@st_time
	def sendRoom(self, packet="", exclude=False, excludeid=0):
		for user in server.clients:
			if user.online and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"] and not user.info["Banished"]:
				if exclude == True and user.info["id"] == self.info["id"] or int(excludeid) == int(user.info["id"]):
					pass
				else:
					if not self.hidden or self.hidden and (self.info['rank'] == user.info['rank'] or server.higherRank(user.info['rank'], self.info['rank'])):
						user.send(packet)
	
	@st_time
	def sendApp(self, appId, appAction, exclude=False, excludeid=0):
		for user in server.clients:
			if user.online and user.info["chat"] == self.info["chat"] and user.info["app"] == self.info["app"] and user.info["pool"] == self.info["pool"] and not user.info["Banished"]:
				if exclude == True and user.info["id"] == self.info["id"] or int(excludeid) == int(user.info["id"]):
					pass
				else:
					if not self.hidden or self.hidden and (self.info['rank'] == user.info['rank'] or server.higherRank(user.info['rank'], self.info['rank'])):
						user.send_xml('x', {'i': str(appId), 't': str(appAction), 'u': str(self.info['id'])})
	
	@st_time
	def sendLive(self, packet=""):
		for user in server.clients:
			if user.online and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"] and not user.info["Banished"] and user.info['rank'] in [1, 4]:
				user.send(packet)
	
	@st_time
	def sendAll(self, packet="", online=False):
		for user in server.clients:
			if (online and user.online) or ((not online and not user.online) or user.online):
				user.send(packet)
	
	@st_time
	def sendFriends(self):
		user = database.fetchArray('select friends from `users` where `id`= %(id)s', {"id": str(self.info['id'])})
		if len(user) > 0:
			try:
				friends = json.loads(user[0]['friends'])
			except:
				return #no friends
			ids = ', '.join(map(str, friends))
			users = database.fetchArray('SELECT id, username FROM users WHERE id IN (' + ids + ')')
			if len(users) > 0:
				for u in users:
					self.notice('_/b ' + str(u['id']) + ' ' + u['username'] + ';==', True)
					#self.send('<c t="/b ' + str(u['id']) + ' ' + u['username'] + ';==" u="0" />')
					
	@st_time
	def buildI(self, chatFlag = 0):
		try:
			i = {'b':''}
			
			if self.wType != 0:
				i['w'] = str(self.wType)
			if self.customPawn != "":
				i['pawn'] = self.customPawn
			if self.customCyclePawn != "":
				i['cyclepawn'] = self.customCyclePawn
				
			i['b'] += self.groupInfo["bg"] + ';='
			i['b'] += self.attachedInfo["name"] + ';='
			i['b'] += str(self.attachedInfo["id"]) + ';='
			
			if len(self.groupInfo['langdef']) > 2 and self.groupInfo['langdef'] != "en":
				i['b'] += self.groupInfo['langdef'] + ';='
			else:
				i['b'] += ';='
				
			i['b'] += self.groupInfo["radio"] + ';='
			i['b'] += self.groupInfo["button"]
			i['f'] = str(chatFlag)
			i['f2'] = str(self.info['flags'])
			i['v'] = 3
			i['r'] = str(self.info["rank"])
			i['cb'] = str(self.loginTime)
			
			if len(str(self.groupInfo['bot'])) > 0:
				i['B'] = str(self.groupInfo['bot'])
			if len(self.info['jinx']) > 0:
				i['j'] = str(self.info['jinx']) 
		
			return self.buildPacket('i', i)
		except:
			server.write("<i />: " + format_exc())
			return self.buildPacket('i', {"b": "", "f": 0, "f2": 0, "cb": str(self.loginTime)})
					
	@st_time
	def buildGp(self):
		try:
			Already = []
			Enabled = []
			assigned = database.fetchArray("SELECT power, enabled FROM `group_powers` WHERE `chat`=%(chat)s", {"chat": self.info["group"]})
			group = self.groupInfo
			GroupPowersX = [0 for i in range(config.PWR_MAX_INDEX)]
			self.GroupPowers = [0 for i in range(config.PWR_MAX_INDEX)]

			for row in assigned:
				if row['power'] not in Already:
					if row['enabled'] == 1:
						Enabled.append(row['power'])
					subid = int(pow(2, int(row['power']) % 32))
					section = int(row['power']) >> 5
					GroupPowersX[section] |= subid
					Already.append(row['power'])

			for i in range(config.PWR_MAX_INDEX):
				self.GroupPowers[i] = str(GroupPowersX[i])
			
			gp = {}
			gp['p'] = "|".join(self.GroupPowers)
			dct = {74:'gline', 80:'gcontrol', 90:'bad', 92:'horrorflix', 96:'winterflix', 98:'feastflix',
				100:'link', 102:'loveflix', 112:'announce', 114:'pools', 148:'spookyflix', 156:'santaflix',
				180:'gsound', 246:'darts', 256:'zwhack', 278:'springflix', 300:'summerflix'};
			for key, value in dct.items():
				if int(key) in Enabled and group[value] != None:
					gp['g' + str(key)] = group[value]

			g106 = "#"
			if 106 in Enabled and group['gscol'] != None:
				g106 = ("%s" %(group['gscol'])) + g106
			if 130 in Enabled and group['gback'] != None:
				g106 += group['gback']
			if g106 != "#":
				gp['g106'] = g106
			
			return self.buildPacket('gp', gp)
		except:
			server.write("<gp />: " + format_exc())
			return self.buildPacket('gp', {'p': '0|0|0|0|0|0|0|0|0|0|0|0|0|0|0'})
	
	@st_time
	def signOut(self, close=True, e = None):
		self.SignedOut = True
		if not e:
			e = "E06"
			#chat errors on no e.attribute.e for <logout
		try:
			self.send("<logout e=\"" + e + "\" />")
			if close == True:
				self.disconnect()
		except:
			server.write("signOut(self)\n" + format_exc())
			pass
	
	@st_time
	def disconnect(self):
		try:
			self.disconnected = True
			self.shutdown()
			self.socket.close()
		except:
			server.write("disconnect(self)\n" + format_exc())
			pass
	
	@st_time
	def pools(self):
		pools = {0: 0}

		if len(self.GroupPools):
			for pool in self.GroupPools:
				pools[int(pool)] = 0

		for user in server.clients:
			try:
				if user.online and user.info['chat'] == self.info['chat']:
					if user.info['pool'] in pools.keys():
						pools[user.info['pool']] += 1
					else:
						pools[user.info['pool']] = 1
			except:
				continue

		return pools
	
	@st_time
	def getPool(self, pool = 0, clickedPool = False, Limit = False):
		usersInPool = 0

		if(str(pool) in self.GroupPools):
			if Limit:
				return self.getPool(int(pool) + 1, False, True)
				
			rankpool = json.loads(self.groupInfo['pools'].replace("'", '"'))
			rnk = self.gcontrolToRank(rankpool['rnk']) if self.gcontrolToRank(rankpool['rnk']) != False else config.POOL_RANK
			brk = self.gcontrolToRank(rankpool['brk']) if self.gcontrolToRank(rankpool['brk']) != False else config.POOL_BANNED

			#Save querys
			asgn114 = self.Assigned(114)
			if pool == 1:
				if asgn114:
					if self.info["rank"] in self.minRankToArray(rnk):
						if clickedPool == False:
							return self.getPool(int(pool) + 1, False)
						return 1
			elif pool == 2:
				if asgn114 and self.Assigned(126):
					if self.info["rank"] in self.minRankToArray(brk) or self.info['banned']:
						if clickedPool == False and not self.info['banned']:
							return self.getPool(int(pool) + 1, False)
						return 2
			return self.getPool(0)

		if not pool in self.pools().keys() and not Limit:
			return self.getPool(0, clickedPool)

		for user in server.clients:
			if user.online and user.info['chat'] == self.info['chat'] and user.info['pool'] == pool and self.info['id'] != user.info['id']:
				usersInPool += 1

		if usersInPool >= config.X_MAX_POOL:
			pool += 1
			return self.getPool(pool, False, True)

		return pool
	
	@st_time
	def getClients(self):
		return server.clients
	
	@st_time
	def getSpectators(self, room):
		spectators = 1
		for user in server.clients:
			try:
				if user.online and user.info['chat'] == room and user.isSpectator:
					spectators += 1
			except:
				continue

		return str(spectators)
	
	@st_time
	def relogin(self):
		_user = database.fetchArray('select username, password from `users` where `id`= %(id)s', {"id": self.info['id']})
		self.send(server.doLogin(_user[0]['username'], _user[0]['password']))
		self.disconnect()
	
	@st_time
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
	
	@st_time
	def KickAll(self, room, kPool, kFlags = False):
		'''
		KICKALL_GUEST 0x100
		KICKALL_REG 0x200
		KICKALL_MUTE 0x300
		KICKALL_BAN 0x400
		'''
		for user in server.clients:
			
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

			user.send_xml('logout', {'e': 'E33'})
	
	@st_time
	def gcontrolToRank(self, rank):
		''' MAIN = 1, OWNER = 4, MOD = 2, MEM = 3, GUEST = 5 '''
		if not rank:
			return 5

		rank = int(rank)
		if rank == 0:#N/A
			return 5
		elif rank == 2:#Guest
			return 5
		elif rank == 3:#Temp Member(Currently returns default)
			return 3
		elif rank == 5:#Member
			return 3
		elif rank == 7:#Temp Moderator(Currently returns default)
			return 2
		elif rank == 8:#Moderator
			return 2
		elif rank == 10:#Temp Owner(Currently returns default)
			return 4
		elif rank == 11:#Owner
			return 4
		elif rank == 14:#Main Owner
			return 1

		return 5
	
	@st_time
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
	
	@st_time
	def hasMinRank(self, rank, min):	
		if isinstance(min, str):
			min = self.groupControl[min]
			
		if rank in self.minRankToArray(self.gcontrolToRank(min)):	
			return True
			
		return False
		
	@st_time
	def setGroupControl(self):
		self.groupControl = config.GCONTROL_DEFAULTS
		try:
			groupInfo = database.fetchArray("SELECT gcontrol FROM `chats` WHERE id = %(id)s", {"id":self.info["chat"]})[0]
			gControl = groupInfo['gcontrol']
			
			if gControl == "" or self.Assigned(80) == False:
				return
				
			gControl = json.loads(gControl.replace("'", '"'))
			for key in gControl:
				self.groupControl[key] = gControl[key]
					
			self.hasGControl = True
		except:
			
			server.write(format_exc())
			return

		return	
		
	@st_time
	def setGroupControl2(self):
		if self.Assigned(80) == False:
			return
		try:
			groupInfo = database.fetchArray("SELECT gcontrol FROM `chats` WHERE id = %(id)s", {"id":self.info["chat"]})[0]
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
			if 'bst' in gControl:
				self.blastAnimation = int(gControl['bst'])
			if 'p' in gControl:
				self.protect_minRank = self.gcontrolToRank(gControl['p']) if self.gcontrolToRank(gControl['p']) != False else self.protect_minRank
			if 'pd' in gControl:
				self.protectDefault = int(gControl['pd'])
			if 'pt' in gControl:
				self.protectTime = float(gControl['pt'])
			if 'ssb' in gControl:
				self.canSilentBan_minRank = self.gcontrolToRank(gControl['ssb']) if self.gcontrolToRank(gControl['ssb']) != False else self.canSilentBan_minRank	
			if 'cbs' in gControl:
				self.cantBeSilentBanned_minRank = self.gcontrolToRank(gControl['cbs']) if self.gcontrolToRank(gControl['cbs']) != False else self.cantBeSilentBanned_minRank

			self.hasGControl = True
		except:
			server.write(format_exc())
			return

		return
	
	@st_time
	def DoJinx(self):
		return
		
	def RapidMessageCheck(self, Msg, Typed, ip, UserId, RoomId):
		return False
		FloodThreshold = 50.0
		MemberFloodTrust = 4.0
		
		MaxMinChars = (30.0 * 10.0)
		
		IsMessage = True if Msg and Msg[0:1] != '/' else False
		
		if UserId == 0 and RoomId == 0:
			return False
			
		if Msg: # Msg given so count and add chars typed
			if Msg[0] == '/':
				Typed += 1.0 # if / then just use 1 for now
			else:
				Typed += len(Msg)
		
		#if RoomId and ('rank' in self.info and self.info["rank"] in self.minRankToArray(3)):
			#Typed /= MemberFloodTrust
			
		if Typed < 0.1:
			Typed = 0.1 # limit to 100 per s
			
		if self.RateInfo == None: # its full so realloc
			self.RateInfo = {'ID': '0', 'Time': 0, 'CharsTyped': 0, 'MessageTime': 0}
			#RedoRateCache(); # full realloc ?
			#RateInfo = (RateCache_t*)Xht_Locate(RateCache, &Id)

		if not self.RateInfo:
			return False # should always be true :)
		#return False
		CurrentTime = int(time())
		self.RateInfo['ID'] = str(UserId) + str(RoomId) # Start new entry if empty
		if self.RateInfo['Time'] == 0:
			self.RateInfo['Time'] = CurrentTime
			Typed = -MaxMinChars # benefit of doubt

		self.RateInfo['CharsTyped'] += Typed
		self.RateInfo['CharsTyped'] -= (CurrentTime - self.RateInfo['Time']) * 10.0 # allow 10 chars per sec
		if self.RateInfo['CharsTyped']	< -MaxMinChars * 2.0:
			self.RateInfo['CharsTyped'] = -MaxMinChars * 2.0

		if IsMessage and self.RateInfo['CharsTyped'] < 0.0:
			self.RateInfo['CharsTyped'] = 0.0 # if they typed a message set them back to zero

		if self.RateInfo['CharsTyped']	> MaxMinChars:
			self.RateInfo['CharsTyped'] = MaxMinChars # max 30s block

		self.RateInfo['Time'] = CurrentTime

		if self.RateInfo['CharsTyped'] > FloodThreshold:
			if self.RateInfo['MessageTime'] < (CurrentTime - 1): # max once every 2s
				self.send_xml('m', {'t': 'Limit: ' + str(int(self.RateInfo['CharsTyped'] / 10)) + 's', 'u': '0', 's': '0'})
				self.RateInfo['MessageTime'] = CurrentTime
			return True

		return False
	
	@st_time
	def joinRoom(self, reload = True, reload2 = False, load1 = False):
		if int(self.joinData["u"]) == 99: #For Raven
			return
		#server.write("Start Join Room", "benchmark")
		start = process_time()
		# user info
		messagesStore = {"users":{}, "messages":[]}
		self.online = False
		packet = self.joinData
		self.info["id"] = int(packet["u"])
		self.info["name"] = server.base64decode(str(packet["n"]))
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
		self.wType = 0
		'''
		for blocked in server.config["blockedixats"]:
			if blocked in self.info["home"].lower().replace(" ", "") or "23.ip-5-196-225" in self.info["home"].lower().replace(" ", ""):
				self.info["home"] = ""
		'''
		# build u packet
		with measureTime("Load Info"):
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
					self.userInfo = database.fetchArray("SELECT torched, username, password, trolls, custpawn, custcyclepawn, d2, d0, xats, dO, days FROM users WHERE " + query, bind)
					if not len(self.userInfo):
						raise Exception("Deleted toon")
					self.userInfo = self.userInfo[0]
					self.null = False
				else:
					if int(self.yPacket["u"]) != 0:
						raise Exception("u != id")
					self.info["id"] = int(str(int(time())) + str(randint(0, 1000)))
					self.userInfo = {}
					self.null = True
			except Exception as e:
				#server.write("joinRoom() - Please relogin to start chatting. (1) - ID: " + str(self.info["id"]) + " Query: " + query + " - " + str(bind) + "\n" + format_exc())
				#print("This is most likely due to the fact we deleted old toons, can likely be ignored unless ID is registered.")
				self.notice("You have an invalid id. Please relogin to start chatting. (1)")
				self.signOut()
				return

		myPowers = {}
		#pCount = int(database.fetchArray('SELECT id FROM `powers` ORDER BY `id` DESC LIMIT 1;')[0]['id']) >> 5
		#pCount = int(database.fetchArray('select count(distinct `section`) as `count` from `powers`;')[0]['count'])
		with measureTime("Power Checks"):
			for index in range(0, config.PWR_MAX_INDEX):
				try:
					myPowers[index] = int(packet["d" + str(index + 4)])
					if "N" not in packet.keys():
						self.notice("Please relogin to start chatting. (1:1)")
						self.signOut()
						return
				except:
					myPowers[index] = 0

			powers = {}
			myPowers2 = myPowers.copy()
			if "N" in packet.keys():
				self.info["q"] = 3
				powers = self.getUserPowers()

				if int(self.info["id"]) != 804:
					if powers[0] is -1:
						self.notice("Please relogin to start chatting. (2)")
						self.signOut()
						return
					for key in powers:
						myPowers2[key] -= powers[key]
						if myPowers2[key] != 0:
							if self.userInfo['torched'] == 1:
								return self.send(server.doLogin(self.userInfo['username'], self.userInfo['password']))
							else:
								return self.send(server.doLogin(self.userInfo['username'], self.userInfo['password']))
								#self.notice("Please relogin to start chatting.")
								#self.signOut()
							return
						elif powers[key] != myPowers[key]:
							if self.userInfo['torched'] == 1:
								return self.send(server.doLogin(self.userInfo['username'], self.userInfo['password']))
							else:
								return self.send(server.doLogin(self.userInfo['username'], self.userInfo['password']))
								#self.notice("Please relogin to start chatting.")
								#self.signOut()
							return

		if int(self.yPacket['r']) != int(self.info["chat"]):
			self.notice("Please relogin to start chatting. (4)")
			self.signOut()
			return

		with measureTime("Trolls"):
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

		with measureTime("Group Info"):
			# group info
			try:
				self.groupInfo = database.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":self.info["chat"]})[0]
				self.info["group"] = self.groupInfo["name"]
				try:
					self.rankInfo = database.fetchArray("SELECT * FROM `ranks` WHERE chatid = %(chatid)s and userid = %(userid)s", {"chatid": self.info["chat"], "userid": self.info["id"]})[0]
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
							database.query("UPDATE `ranks` set `f`=%(f)s, `tempend`=0 WHERE chatid=%(chatid)s and userid=%(userid)s", {"f": self.info["rank"], "chatid": self.info["chat"], "userid": self.info["id"]})
							self.info['temp'] = 0
					else:
						self.info['temp'] = 0
				except:
					self.info["rank"] = 5
			except:
				server.write("joinRoom() - Chat not found.\n" + format_exc())
				self.notice("Chat not found.")
				self.signOut()
				return

		with measureTime("Set Group control"):
			'''Handle gControl'''
			self.setGroupControl()

		with measureTime("Initial Group Setup"):
			if int(self.groupInfo['flag']) & 0x200000:
				chatFlag |= 0x200000
				self.info['live_mode'] = True
				if int(self.info["rank"]) == 5:
					self.isSpectator = True

			self.info["flags"] = 0
			if self.info['temp'] != 0:
				self.info['flags'] |= config.U_TEMP
			chatFlag |= 64

			#self.info["flags"] += 64  # isGroup
			self.info["rank2"] = self.info["rank"]
			if int(self.info["id"]) in config.X_BOTS:
				self.info['flags'] |= config.U_BOT
			elif self.mob:
				self.info['flags'] |= config.U_MOBILE
				
			if hasattr(self, 'rankInfo'):
				if float(self.rankInfo['sinbin']) - time() > 0:
					self.info['flags'] |= config.U_SINBIN
					self.info["sinbinned"] = True
				elif int(self.rankInfo['sinbin']) != 0:
					database.query("update `ranks` set `sinbin` = 0 where `userid` = %(id)s", {"id": self.info["id"]})
			bans = database.fetchArray("SELECT * FROM `bans` WHERE chatid = %s and userid = %s or ip = %s and chatid = %s", (str(self.info["chat"]), str(packet["u"]), str(self.connection["ip"]), str(self.info["chat"])))
			self.info["banned"] = False
			self.info['gamebanned'] = False
			self.info["rc_bannedtime"] = 0
			self.info["jinx"] = ""

		with measureTime("Hush"):
			try:
				Hush = json.loads(self.groupInfo['hush'])
				hushedRank = int(Hush["rank"])
				hushedTime = int(Hush["time"])
				self.info['HushedTime'] = int(int(hushedTime))
				if self.info['HushedTime'] - int(time()) > 0:
					if not server.higherRank(self.info['rank'], hushedRank) and self.info['rank'] != hushedRank:
						if not self.isGagged:
							self.isGagged = True
							self.info["flags"] |= config.U_GAGGED
						self.send_xml('m', {'t': '/p0,' + str(self.info['HushedTime'] - int(time())), 'd': '0'})
					else:
						self.info['HushedTime'] = 0
				if self.info['rank'] in [1, 4]:
					self.info['info']['/h'] = "_/h " + str(Hush["userid"])
			except:
				pass

		bannedTime = 0
		bannedParam = ""
		bannedType = ""
		bannedSend = ""

		with measureTime("Bans"):
			for ban in bans:
				if ban["special"] == 0 and int(self.info["rank"]) != 1:
					bannedTime = float(ban["unbandate"]) - float(time())
					bannedParam = "/" + ban["type"] + str(int(bannedTime))
					bannedType = ban["type"]
				elif ban["special"] != 0 and int(self.info["id"]) == int(ban["userid"]):
					if ban["type"] == "gd":
						if int(ban["special"]) == 264:
							self.info["flags"] |= config.U_BADGE
						elif not self.info["flags"] & config.U_BADGE:
							self.info["flags"] |= config.U_DUNCE
					elif ban["type"] == "gn":
						self.info["flags"] |= config.U_NAUGHTY
						self.info["Naughty"] = True
						self.info["NaughtyTime"] = int(time())
						if not self.isGagged:
							self.isGagged = True
							self.info["flags"] |= config.U_GAGGED
						self.send_xml('m', {'t': '/p0,30', 'd': '0'})
					elif ban["type"] == "gg":
						if (float(ban["unbandate"]) - time()) > 0:
							if not self.isGagged:
								self.isGagged = True
								self.info["flags"] |= config.U_GAGGED
							self.info['GaggedTime'] = float(ban["unbandate"])
							self.send('m', {'t': '/p0,' + str(self.info['GaggedTime'] - float(time())), 'd': '0'})
						else:
							database.query("delete from `bans` where chatid=%(chatid)s and special=41 and userid=%(userid)s", {"chatid": self.info["chat"], "userid": self.info['id']})
					elif ban["type"] == "gy":
						self.info["flags"] |= config.U_YELLOW
					elif ban["type"] == "gr":
						self.info["rc_bannedtime"] = float(ban["unbandate"]) - float(time())
						self.info["redcard"] = True
						self.info["flags"] |= config.U_RED
					elif ban["type"][0:2] == "gj":
						if (float(ban["unbandate"]) - float(time())) > 0:
							self.info["jinx"] = ban["type"][2:]
						else:
							database.query("delete from `bans` where chatid=%(chatid)s and special=422 and userid=%(userid)s", {"chatid": self.info["chat"], "userid": self.info['id']})
					else:
						if int(ban['special']) in server.gameBans:
							bannedTime = float(ban["unbandate"]) - float(time())
							bannedParam = "/" + ban["type"] + str(int(ban["unbandate"]))
							bannedType = ban["type"]
							self.info['gamebanned'] = True
							self.info['app'] = int(ban["special"])
						self.wType = ban["special"]

		Muted = False

		with measureTime("More bans"):
			if bannedTime > 0:
				self.info["banned"] = True
				self.info["flags"] |= 16
				#self.info["rank2"] += 16
				if bannedType != "gm":
					cPacket = {'d': str(self.info['id']), 't': bannedParam, 'u': '0'}
					if self.wType == 0 and bannedTime > 3600 and self.Assigned(70):
						self.info["Banished"] = True
						self.info["flags"] |= config.U_BANISH
					if self.wType != 0 and self.wType in server.gameBans:
						cPacket['w'] = str(self.wType)
					self.send_xml('c', cPacket)
				else:
					Muted = True
			else:
				self.info["banned"] = False
				if bannedParam != "":
					database.query("delete from `bans` where chatid=%(chatid)s and special=0 and ip=%(ip)s", {"chatid": self.info["chat"], "ip": self.connection["ip"]})

				if "b" in packet.keys():
					self.send_xml('c', {'d': str(self.info["id"]), 't': '/u', 'u': '0'})

		PoolSatisfied = False
		self.GroupPools = []

		with measureTime("Pool Stuff"):
			if self.Assigned(114):
				RankPool = "1"
				if self.Assigned(126) and self.wType == 0:
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
						
		self.RapidMessageCheck(None, 20.0, 0, 0, int(self.info['chat'])) # count this as a message

		with measureTime("Initial u packet"):
			if "away" in self.info:
				if self.info["away"] == True:
					self.info["flags"] |= config.U_AWAY
			self.joinData["pool"] = self.info["pool"]

			self.userPacket = "<u "
			self.customPawn = ""
			self.customCyclePawn = ""

			if self.wType != 0:
				self.info['app'] = int(self.wType)
				self.userPacket += 'w="' + str(self.wType) + '" '

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

			self.info["flags"] |= self.info["rank2"]
			
			if "N" in packet.keys() and self.null == False:
				self.info["flags"] |= 32

			self.userPacket += 'f="' + str(self.info["flags"]) + '" '
			#self.userPacket += 'flag="' + str(self.info["flags"]) + '" '

			#self.userPacket += 'rank="' + str(self.info["rank2"]) + '" '
			self.userPacket += 'u="' + str(self.info["id"]) + '" '

			if "N" in packet.keys() and self.null == False:
				self.userPacket += 'N="' + self.info["username"] + '" '

			# nickname info
			self.userPacket += 'n=' + quoteattr(self.info["name"]) + ' '
			self.userPacket += 'a=' + quoteattr(self.info["avatar"]) + ' '
			self.userPacket += 'h=' + quoteattr(self.info["home"]) + ' '

			#if self.info['app'] != 0:
			#	self.userPacket += 'x="' + str(self.info['app']) + '" '

			if int(self.info["id"]) != 804 and not self.webSocket:
				if "d2" in packet.keys() and int(self.userInfo["d2"]) != 0 and "N" in packet.keys() and self.null == False and "d0" in packet.keys():
					if int(self.userInfo["d2"]) == int(packet["d2"]) and int(self.userInfo["d0"]) == int(packet["d0"]):
						self.userPacket += 'd0="' + str(int(self.userInfo["d0"])) + '" '
						self.userPacket += 'd2="' + str(self.userInfo["d2"]) + '" '
					else:
						self.notice("Please relogin to start chatting. (5)")
						self.signOut()
						return
				elif "d2" in packet.keys():
					self.notice("Please relogin to start chatting. (6)")
					self.signOut()
					return

			self.userPacket += 'v="2" '
			self.userPacket += 'q="' + str(self.info["q"]) + '" '

			if len(self.info['jinx']) > 0:
				self.userPacket += 'j="'+str(self.info['jinx'])+'" '

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
				database.query("update `chats` set `flag`=%(flag)s where `id`=%(id)s", {"id": self.info['chat'], "flag":updatedFlags})
				for user in server.clients:
					try:
						if user.info['chat'] == self.info['chat'] and self.info['id'] != user.info['id']:
							user.send_xml('logout', {'e': 'E33'})
					except:
						server.write("joinRoom() - Logout E33.\n" + format_exc())
						pass

				#self.KickAll(self.info['chat'], -1)

			try:
				self.attachedInfo = database.fetchArray('SELECT `id`,`name` FROM `chats` WHERE `name`=%(name)s', {"name": self.groupInfo['attached']})[0]
				#self.info['flags'] += 2
				chatFlag |= 2
			except:
				self.attachedInfo = {"id": "", "name": ""}

			if self.info['rank'] in [1, 4] and self.hasPower(29, True) and not self.hidden:
				self.info['flags'] |= config.U_INVISIBLE
				chatFlag |= config.U_INVISIBLE
				self.hidden = True
			else:
				self.hidden = False

			if int(self.groupInfo['flag']) & 0x20000:#DefNoSound
				chatFlag |= 0x20000
				#self.info['flags'] += 0x20000

			if int(self.groupInfo['flag']) & 0x800:#NoSmilieLine
				chatFlag |= 0x800
				#self.info['flags'] += 0x800

		with measureTime("Send chat info"):
			self.send(self.buildI(chatFlag) + chr(0) + self.buildGp())

			if len(self.pools()) > 1 and self.info['live_mode'] == False:
				pools = self.pools().keys()
				pools2 = []
				for pool in pools:
					pools2.append(str(pool))
				self.send_xml('w', {'v': str(self.info["pool"]) + ' ' + str(" ".join(sorted(pools2)))})
			else:
				self.send_xml('w', {'v': '0'})

		sendUsers = []
		hiddenUsers = []

		with measureTime("Offline Messages"):
			offlineMessages = database.fetchArray('SELECT * FROM `pvtlog` WHERE recipient=%(id)s AND `offline`=1', {"id": self.info['id']})
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
						offlineMessage += 'n=' + quoteattr(server.base64decode(str(omessage['nickname']))) + ' '
					if omessage['avatar'] != '':
						offlineMessage += 'a=' + quoteattr(str(omessage['avatar'])) + ' '
					if omessage['homepage'] != '':
						offlineMessage += 'h=' + quoteattr(str(omessage['homepage'])) + ' '
					offlineMessage += '/>'
					self.send(offlineMessage)
					database.query('update `pvtlog` set offline=0 WHERE id=%(id)s', {"id": omessage['id']})

		messagesSend = []

		if self.info["id"] > time():
			# Fuck that foreign kid bringing 800 nulls from his website
			nb = "Be sure to register to get full benefits of using powers, gifts, and much more!"
			self.notice(nb + " the login / register / profile page.", True)
			#self.send("<dup />")
			self.send("<logout e=\"E06\" />")
			#self.signOut()
			self.disconnect()

		with measureTime("Get old stuff"):
			for user in server.clients:
				try:
					if user.online == True and user.info["chat"] == self.info["chat"] and user.info["pool"] == self.info["pool"]:
						#if (user.info["id"] == self.info["id"]) or user.null == True and self.null == True and user.connection["ip"] == self.connection["ip"]:
						if (user.info["id"] == self.info["id"]):
							user.duplicate = True
							#user.notice("You were kicked because user:" + str(user.info['id']) + " matches self:" + str(self.info['id']), True)
							#user.send("<dup />")
							self.signOut()
							user.updateTimeOnline()
							user.disconnect()
						elif (reload == True or reload2 == True) and user.info["id"] != self.info["id"]:
							if self.info['rank'] == user.info['rank'] or not self.hidden or server.higherRank(user.info['rank'], self.info['rank']):
								if not user.info["Banished"] or user.info["Banished"] and self.info["rank"] in [1, 2, 4]:
									# temporary
									end = "/>"
									if self.info['app'] != 0:
										end = 'x="' + str(self.info['app']) + '" ' + end
									user.send(self.userPacket + end)
							if self.online == False and reload2 == False:
								if user.info['rank'] == self.info['rank'] or not user.hidden or server.higherRank(self.info['rank'], user.info['rank']):
									if not self.info["Banished"] or self.info["Banished"] and user.info["rank"] in [1, 2, 4]:
										#temporary
										end = "s=\"1\" />"
										if user.info['app'] != 0:
											end = 'x="' + str(user.info['app']) + '" ' + end
										sendUsers.append(user.userPacket + end)
										#messagesSend.append(user.userPacket + end)
										if user.hidden:
											hiddenUsers.append(user.info['id'])
							if user.info["typing"]:
								#sendUsers.append('<m t="/RTypeOn" u="' + str(user.info["id"]) + '" />')
								messagesSend.append('<m t="/RTypeOn" u="' + str(user.info["id"]) + '" />')
				except:
					#self.notice("Error, please tell the admins that you had this popup.")
					continue


		with measureTime("Send Users"):
			#meh
			if len(sendUsers) > 0:
				self.send(chr(0).join(sendUsers))

		NoStore = False
		if int(self.groupInfo['flag']) & 0x100:
			NoStore = True

		with measureTime("Get offline stuff 2.0"):
			if reload == True and self.info['pool'] == 0 and not self.info["Banished"] and NoStore == False:
				messages = database.fetchArray('SELECT * FROM `messages` where id = %(id)s AND port = %(port)s and pool = %(pool)s AND visible=1 ORDER BY `mid` DESC LIMIT 0,14;',
														   {"id": self.info['chat'], "pool": self.info["pool"], "port": config.CONN_PORT})
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
							user = server.getUserByID(int(message['uid']), self.info['chat'])
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

			messagesSend.append('<m t=' + quoteattr('/s' + self.groupInfo['sc']) + ' u="0" />')
			# self.send('<m t="/s' + self.groupInfo['sc'] + '" u="0" />')
		
		with measureTime("Send offline messages?"):
			if len(messagesSend) > 0:
				try:
					if True:
						if self.info['members_only'] and self.info['rank'] == 5:
							pass
						else:
							self.send(chr(0).join(messagesSend))
				except:
					server.write("joinRoom() - Send messages.\n" + format_exc())
					pass

		with measureTime("Ending stuff"):
			if int(self.info['chat']) in server.Protected and not self.hidden:
				ptime = floor((server.Protected[int(self.info['chat'])]['end'] - time()) / 60)
				if ptime > 0:
					self.send_xml('m', {'u': '0',  't': 'Protect Activated! - for the next ' + str(ptime) + ' minutes.(' + str(server.Protected[int(self.info['chat'])]['id']) + ')'})

			if self.null == False:
				database.query('update `users` set nickname=%(nickname)s, avatar=%(avatar)s, url=%(url)s, connectedlast=%(cl)s WHERE id=%(id)s', {"nickname": server.base64encode(self.info['name']), "avatar": self.info["avatar"], "url": self.info["home"], "cl": self.connection["ip"], "id":self.info["id"]})

			if self.null:
				nb = "Be sure to register to get full benefits of using powers, gifts, and much more!"
				self.notice(nb + " http://ixat.io/profile")
				self.notice(nb + " the login / register / profile page.", True)
				self.notice("You can get xats by simply being online once you are registered. Type ~to or qto in the chat to see the xats that you have earned.")

			if self.online == False:
				if not self.sentJ2:
					if self.info['live_mode']:
						self.send_xml('u', {'u': '4294967295', 'n': self.getSpectators(self.info["chat"])}, None, 1)

					#server.write("Client.joinRoom sending 'done'", "Client")
					self.send_xml('done')
					self.joinedTime = int(time())
					self.sentJ2 = True

				self.online = True

			self.info['KeepPool'] = False
			server.LastChat[self.info["id"]] = self.info["chat"]
		end = process_time()
		#server.write("End Join Room. Elapsed time: " + str(end - start), "benchmark")
			
	@st_time
	def mask(self, packet):
		length = len(packet)

		if length < 126:
			return struct.pack('CC', 0x80 | (0x1 & 0x0f), length) + packet
		elif length < 65536:
			return struct.pack('CCn', 0x80 | (0x1 & 0x0f), 126, length) + packet
		else:
			return struct.pack('CCNN', 0x80 | (0x1 & 0x0f), 127, length) + packet
			
	@st_time
	def unmask(self, packet):
		try:
			length = ord(packet[:1]) & 127
			if length == 126:
				masks = packet[4:4]
				data = packet[8:]
			elif length == 127:
				masks = packet[10:4]
				data = packet[14:]
			else:
				masks = packet[2:4]
				data = packet[6:]

			response = ''
			dlength  = len(data);
			for i in range(0, dlength + 1):
				response += str(data[:i] ^ masks[:(i % 4)])

			if response == '':
				return False
			
			return response
		except:
			return False
			
	@st_time
	def shutdown(self):
		"""
		if self.connection["ip"] == "":
			print("Shutdown Stack Trace: (NOT AN ERROR)")
			server.write(''.join(format_stack()))
		"""
		server.shutdown_socket(self.socket)
		
	def run(self):

		self.is_filtered = False
		self.packets = []

		while True:
			try:
				if self.SignedOut or self.disconnected:
					raise Exception("Signed out")
				if self.socket.fileno() == -1:
					raise Exception("Disconnected, fileno -1")
				if self.policy == True:
					raise Exception("Policy Request is True")

				self.select = select.select([self.socket], [], [], 0.01)

				if self.select[0]:
					if self.webSocket == -1:

						self.websock = WebSocket2(self.socket, send_proxy = self.send2)

						x = self.websock.read()

						if x == None and not (self.websock._flags & WebSocket2.B_HANDSHAKE_COMPLETE):
							self.data = self.websock._buffer.decode("utf-8", "ignore")
							self.webSocket = False
						else:
							self.webSocket = True
							continue

					elif self.webSocket == True:
						self.data, self.wsOpcode = self.websock.read()
						self.data = self.data.decode("utf-8", "ignore") + "\000"
					else:
						recv = self.socket.recv(config.RECV_BUFFER_SIZE)

						self.data += recv.decode("utf-8", "ignore")

					self.packets = [item for item in self.packets if item[0] > time()]

					if not self.data:
						raise Exception("Disconnected, no data.")
					if self.connection["ip"] in server.config["ipbans"]:
						raise Exception("IP BANNED: " + self.connection["ip"])

					i = self.data.find("\0")
					#Shutdown socket if packet > recv size
					while i !=-1:
						if not self.registered and len(self.packets) > 20 and not self.is_filtered:
							self.is_filtered = True
							raise Exception("Filtered. " + str(self.info["id"]) + " - " + str(len(self.packets)))

						packet = self.data[:i].replace("", "")
						self.data = self.data[i+1:]

						if packet[:1] == "<":
							self.packets.append( (time() + 5, packet) )
							self.activeTime = time()
							self.parse(packet)
						else:
							raise Exception("Not XML: [" + packet +"]")

						i = self.data.find("\0")
					if i != -1 and self.online and self.registered:
						self.updateTimeOnline()
			except BlockingIOError:
				server.write(format_exc())
				continue
			except BaseException as e:
				self.SignedOut = True
				#server.write("Client closed [" + self.connection["ip"] + ":" + str(self.connection["port"]) + "] -> " + format_exc(), "Server")
				self.disconnected = True
				server.checkConnections()
				break
