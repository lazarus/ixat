import socket
import hashlib
import json
import select
from sys import exit, argv, maxsize
from os import listdir, sep, getpid
from threading import Thread, activeCount, RLock
from gc import collect
from time import sleep, time
from traceback import print_exc
import queue
from plib.client import Client
from plib.mysql import furrydb
import random
from binascii import crc32


class Server():
	def __init__(self, filepath):
		self.socket = None
		self.connection = {"ip": "0.0.0.0", "port": 1204}
		self.clients = []
		self.gcThread = None
		self.scriptLocation = ""
		self.handlers = {}
		self.folders = ["commands", "handlers"]
		self.policyFile = '<cross-domain-policy><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>'
		self.specialBans = [134, 136, 140, 152, 162, 176, 184, 236]
		self.gameBans = [134, 136, 140, 152, 162, 236]
		self.authorizedBots = [6, 804, 854]
		self.debug = True
		self.LastChat = {}
		self.databaseinfo = {}
		self.scriptLocation = filepath
		self.argv = argv
		self.setup()

		self.ConnectTime = {}

		self.queue = queue.Queue()
		self.packetThread = Thread(target=self.handleQueue)
		# self.packetThread.daemon = True
		self.packetThread.start()
		self.run()

	def loadSettings(self):
		self.settings = json.load(open(self.scriptLocation + sep + "settings.json", "r"))
		self.connection = self.settings["connection"]
		self.databaseinfo = self.settings["database"]

	def setup(self):
		try:
			self.loadSettings()
			self.loadFolders()
			self.loadDatabase()
			self.getConfig()
		except:
			print_exc()
			exit()

	def loadDatabase(self):
		self.database = furrydb(host=self.databaseinfo["host"], port=self.databaseinfo["port"], user=self.databaseinfo["user"], password=self.databaseinfo["password"], table=self.databaseinfo["table"], pool=self.databaseinfo["poolsize"])

	def json_load(self, s=""):
		try:
			return json.loads(s)
		except:
			return None

	def getConfig(self):
		self.database.query('update `server` set `ipc`=' + str(self.connection["port"]))
		self.config = self.database.fetchArray("SELECT * FROM `server` limit 0, 1")[0]
		self.config["staff"] = json.loads(self.config["staff"])
		self.config["helpers"] = json.loads(self.config["helpers"])
		self.config["ipbans"] = json.loads(self.config["ipbans"])
		self.config["blockedixats"] = json.loads(self.config["blockedixats"])
		self.config["connections"] = int(self.config["max_per_ip"])
		self.config["hugs"] = []
		
		spowers = self.database.fetchArray("select * from `powers` WHERE `hugs` != '';")
		for power in spowers:
			self.config["hugs"].append(power['id'])
			''' maybe needed if they change hugs
			id = power['id']
			hugs = power['hugs'].split(',')
			for i in range(0, len(hugs)):
				if i > 0:
					id += 10000
					
				self.config["hugs"].append(id)
			'''

		for i, userid in enumerate(self.config["staff"]):
			self.config["staff"][i] = int(userid)

		for i, userid in enumerate(self.config["helpers"]):
			self.config["helpers"][i] = int(userid)

	def loadFolders(self):
		self.handlers = {}
		for folder in self.folders:
			dir = self.scriptLocation + sep + folder
			for file in listdir(dir):
				id, extension, py = file.split('.')
				try:
					with open(dir + sep + file) as fh:
						addHandler = "self.handlers[id + ':' + extension] = " + id + extension.capitalize()
						code = compile(fh.read() + "\r\n" + addHandler, '<string>', 'exec')
						exec(code)
						fh.close()
				except:
					self.write("File: " + id, "Error")
					print_exc()

	def call(self, name='', type='', *extArgs):
		if name + ':' + type in self.handlers.keys():
			try:
				self.handlers[name + ':' + type](*extArgs)
			except:
				print_exc()

	def connect(self):
		try:
			if self.socket != None:
				try:
					self.socket.shutdown(1)
					self.socket.close()
				except:
					pass
			self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.SOL_TCP)
			self.socket.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
			self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
			self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
			self.socket.bind((self.connection["ip"], self.connection["port"]))
			self.socket.listen(0)
			#self.socket.setblocking(0)
			self.write("Server started on {ip}:{port}".format(
				**{"ip": self.connection["ip"], "port": self.connection["port"]}), "Server")
		except:
			print_exc()
			exit()

	def startgbc(self):
		while True:
			try:
				sleep(10)
				collect()
				KeepAlive = self.database.fetchArray("SHOW DATABASES;")
			except:
				self.loadDatabase()

	def handleQueue(self):
		while True:
			try:
				data = self.queue.get()
				type = data[0]
				if type == 0:
					client = data[1]
					packet = data[2]
					client.handle(packet.tag, packet.attrib)
				elif type == 1:
					client = data[1]
					client.joinRoom(True, False, True)
					client.sentJ2 = True
				elif type == 2:
					sock = data[1]
					address = data[2]
					client = Client(sock, address, self)
					self.clients.append(client)
					client.start()
				elif type == 3:
					client = data[1]
					packet = data[2]
					client.socket.send(packet)
				self.queue.task_done()
			except:
				print_exc()
				self.queue.task_done()
				continue

	def phash(self, hash_type="", string=""):
		try:
			h = hashlib.new(hash_type)
			h.update(str(string).encode("utf-8", "ignore"))
			h = h.hexdigest()
			return h
		except:
			return False
			
	def AddUserPower(self, uid, pid, count = 1):
		userpowers = self.database.fetchArray("SELECT `powers` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = json.loads(userpowers[0]['powers'])
		if str(pid) in userpowers:
			userpowers[str(pid)] += count
		else:
			userpowers[str(pid)] = count
			
		self.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": json.dumps(userpowers)})	
		
	def SetUserPower(self, uid, pid, count = 1):
		userpowers = self.database.fetchArray("SELECT `powers` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = json.loads(userpowers[0]['powers'])
		userpowers[str(pid)] = count
		self.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": json.dumps(userpowers)})
			
	def RemUserPower(self, uid, pid):
		userpowers = self.server.database.fetchArray("SELECT `powers` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = json.loads(userpowers[0]['powers'])
		if str(pid) in userpowers:
			if userpowers[str(pid)] > 1:
				userpowers[str(pid)] -= 1
			else:
				del userpowers[str(pid)]
		
		self.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": json.dumps(userpowers)})	
	
	def DelUserPower(self, uid, pid):
		userpowers = self.database.fetchArray("SELECT `powers` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = json.loads(userpowers[0]['powers'])
		if str(pid) in userpowers:
			del userpowers[str(pid)]
		
		self.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": json.dumps(userpowers)})
				
	def ClearUserPower(self, uid):
		self.database.query("UPDATE `users` SET `powers`=%(powers)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": "[]"})	
		
	def GetUserPower(self, uid):
		userpowers = self.database.fetchArray("SELECT `powers` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = json.loads(userpowers[0]['powers'])		
		return userpowers	

	def sendOpenChats(self, id, packet):
		for user in self.clients:
			if user.online:
				if user.info['id'] == int(id):
					user.send(packet)
			
	def phpcrc32(self, data=""):
		try:
			return (crc32(bytes(data, encoding="UTF-8")))
		except:
			return False
			
	def is_numeric(self, s):
		try:
			float(s)
			return True
		except ValueError:
			pass
	 
		try:
			import unicodedata
			unicodedata.numeric(s)
			return True
		except (TypeError, ValueError):
			pass
			
		return False			

	def getUserByID(self, id=0, chat=None):
		try:
			id = int(str(id).split('_')[0])

			if id == 0 or id == 2:
				return False

			for user in self.clients:
				if 'id' in user.info:
					if str(user.info["id"]) == str(id) and (chat == None or str(user.info["chat"]) == str(chat)):
						if user.online:
							return user

			# fallback
			if id in self.LastChat:
				chat = self.LastChat[id]
				for user in self.clients:
					if user.info["id"] == id:
						if user.online:
							return user
			return False
		except:
			return False

	def higherRank(self, rank1=0, rank2=0, minMod=False):
		if rank1 == rank2:
			return False
		order = [1,2,3,4]
		if int(rank1) in order and not int(rank2) in order:
			return True
		elif rank1 == 1:
			return True
		elif rank1 == 4 and rank2 != 1:
			return True
		elif rank1 == 2 and rank2 != 1 and rank2 != 4:
			return True
		elif minMod == True:
			return False
		elif rank1 == 3 and rank2 != 1 and rank2 != 4 and rank2 != 2:
			return True
		return False
		
	def BlastCargo(self, rank=""):
		if rank == 5:
			return "r"
		elif rank == 4:
			return "M"
		elif rank == 3:
			return "e"
		elif rank == 2:
			return "m"
		elif rank == 1:
			return "X"
		return "0x009900"

	def BlastCor(self, rank=""):
		if rank == 5:
			return "0x009900"
		elif rank == 4:
			return "0xFF9900"
		elif rank == 3:
			return "0x3366FF"
		elif rank == 2:
			return "0xFFFFFF"
		elif rank == 1:
			return "X"
		return "0x009900"

	def doLogin(self, user = "", password = "", RL = True):
		vals = {}
		p = {}
		pp = ''
		dO = ''
		powerO = ''
		username = user
		user = self.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": user})
		#if int(user[0]['id']) in self.authorizedBots:
			#return self.doBotLogin(user, password, RL)	
		try:
			if int(user[0]['d2']) == 0:
				bride = ""
			else:
				bride = user[0]['d2']
			if int(user[0]['days']) > time():
				self.DelUserPower(user[0]['id'], 95)
				self.DelUserPower(user[0]['id'], 0)
				upowers = self.GetUserPower(user[0]['id'])
				spowers = self.database.fetchArray('select * from `powers` where `name` not like \'%(Undefined)%\';')
				allArray = []
				epArray = []
				myArray = []
				for power in spowers:
					vals[int(power['id'])] = [power['section'], int(power['subid'])]
					p[power['section']] = 0
					if int(power['p']) == 1:
						if int(power['limited']) == 0:
							allArray.append(power['id'])
						epArray.append(power['id'])

				if not int(user[0]['torched']) == 1:
					for pid, pcount in upowers.items():
						if int(pcount) >= 1 and int(pid) in vals.keys():
							try:
								vals[int(pid)][0]
							except:
								print_exc()
								continue
							db = ""
							if int(pcount) > 1:
								db = (int(pcount) - 1)
							else:
								db = 1
							myStr = str(pid) + '=' + str(db) + '|'
							p[vals[int(pid)][0]] |= int(vals[int(pid)][1])
							dO += myStr
							if int(pcount) > 1:
								powerO += myStr
							myArray.append(pid)

				GiveEp = True
				GiveAll = True

				for v in epArray:
					if str(v) in myArray and GiveEp != False:
						GiveEp = True
					else:
						GiveEp = False

					if v in allArray:
						if str(v) in myArray and GiveAll != False:
							GiveAll = True
						else:
							GiveAll = False

				if GiveEp == True:
					section = 95 >> 5
					subid = 2 ** (95 % 32)
					p["p"+str(section)] += subid
					#p["p2"] = 2147483647
					self.AddUserPower(user[0]['id'], 95)

				if GiveAll == True:
					section = 0 >> 5
					subid = 2 ** (0 % 32)
					p["p"+str(section)] += subid
					#p["p2"] |= 1
					self.AddUserPower(user[0]['id'], 0)

				for i,u in enumerate(p):
					pp += " d" + str(int(i) + int(4)) + '="' + str(p["p" + str(i)]) + '"'

			key = self.phash("md5", str(time()) + password)
			if RL == True:
				R = ' RL="1"'
				keyUpdate = ""
			else:
				R = ' loginkey="' + key + '"'
				keyUpdate = ", `loginkey`= %(key)s"
			self.database.query("update `users` set `dO`= %(powerO)s" + keyUpdate +" where `username`= %(username)s", {"powerO": powerO, "key": key, "username": user[0]['username']})
			return '<v' + R + ' i="' + str(user[0]['id']) + '" c="' + str(user[0]['xats']) + '" dt="0" n="' + user[0]['username'] + '" k1="' + str(user[0]['k']) + '" k2="' + str(user[0]['k2']) + '" k3="' + str(user[0]['k3']) + '" d0="' + str(user[0]['d0']) + '" d1="' + str(user[0]['days']) + '" d2="' + str(bride) + '" d3=""' + str(pp) + ' dx="' + str(user[0]['xats']) + '" dO="' + str(powerO) + '" PowerO="' + str(powerO) + '" />'
		except:
			print_exc()
			return False	
	
	def doBotLogin(self, user = "", password = "", RL = True):
		pp = ''
		powerO = ''
		username = user
		user = self.database.fetchArray('select * from `users` where `username`= %(username)s', {"username": user})
		try:
			if int(user[0]['id']) not in self.authorizedBots:
				return '<v e="8" />'
				
			if int(user[0]['d2']) == 0:
				bride = ""
			else:
				bride = user[0]['d2']
				
			#spowers = self.database.fetchArray('select * from `powers` where `name` not like \'%(Undefined)%\';')
			pCount = int(self.database.fetchArray('select count(distinct `section`) as `count` from `powers`;')[0]['count'])
			for index in range(0, pCount):
				if index == (pCount - 1):
					subid = self.database.fetchArray('SELECT distinct `subid` FROM `powers` where `section`=%(section)s ORDER BY `subid` DESC limit 1;', {"section":"p" + str(index)})[0]['subid']
					pp += ' d' + str(index + 4) + '="'+str(subid)+'"'
				else:
					pp += ' d' + str(index + 4) + '="2147483647"'
			
			#lastSection = int(spowers[0]['section'].replace('p', '')) + 5
			#for x in range(4, lastSection):
				#pp += ' d' + str(x) + '="2147483647"'

			key = self.phash("md5", str(time()) + password)
			self.database.query("update `users` set `dO`= %(powerO)s, `loginkey`= %(key)s where `username`= %(username)s", {"powerO": powerO, "key": key, "username": user[0]['username']})
			if RL == True:
				R = ' RL="1"'
			else:
				R = ' loginkey="' + key + '"'
			return '<v' + R + ' i="' + str(user[0]['id']) + '" c="' + str(user[0]['xats']) + '" dt="0" n="' + user[0]['username'] + '" k1="' + str(user[0]['k']) + '" k2="' + str(user[0]['k2']) + '" k3="' + str(user[0]['k3']) + '" d0="' + str(user[0]['d0']) + '" d1="' + str(user[0]['days']) + '" d2="' + str(bride) + '" d3=""' + str(pp) + ' dx="' + str(user[0]['xats']) + '" dO="" PowerO="" />'
		except:
			print_exc()
			return False			
			
	def write(self, string="", title="Server"):
		if self.debug == True:
			print(str("[" + title.lower().capitalize() + "] " + str(string)).encode("utf-8", "replace").decode("utf-8", "replace"))

	def checkConnections(self):

		"""
		ct = self.ConnectTime
		try:
			for i, ip in enumerate(ct):
				if float(time()) - float(ct[ip]) >= 10:
					del self.ConnectTime[ip]
		except:
			pass
		"""

		for client in self.clients:
			try:
				if not client.online and ((time() - client.connecttime) >= 5):
					try:
						client.socket.shutdown(1)
						client.socket.close()
					except:
						pass
					self.clients.remove(client)
					continue
				if client.disconnected or client.SignedOut or client.duplicate:
					if client.online and not client.duplicate or client.online and client.duplicate and client.null:
						client.sendRoom('<l u="' + str(client.info["id"]) + '" />')
						if client.registered:
							client.updateTimeOnline()
						try:
							client.socket.shutdown(1)
							client.socket.close()
						except:
							pass
					self.clients.remove(client)
			except Exception as e:
				pass

	def acceptConnections(self, bool=False):
		while True:
			try:
				self.select = select.select([self.socket], [], [], 0.01)
				if self.select[0]:
					sock, address = self.socket.accept()

					if address[0] in self.config["ipbans"]:
						raise Exception("IP BANNED")

					clients = self.clients
					connections = 0

					for client in clients:
						if client.connection["ip"] == address[0] and client.online:
							connections += 1

					if connections >= self.config["connections"]:
						sock.shutdown(1)
						continue
					elif len(self.clients) >= 900:
						sock.shutdown(1)
						continue
					elif sock != None:
						self.write("Client accepted [" + address[0] + ":" + str(address[1]) + "] Total Clients: " + str(len(self.clients)) + " Debug: " + str(connections), "Server")
						#self.queue.put([2, sock, address])
						client = Client(sock, address, self)
						self.clients.append(client)
						client.start()
			except KeyboardInterrupt:
				exit()
				break
			except:
				pass

	def run(self):
		if self.debug == True:
			self.write("Debug mode enabled.")
		self.connect()
		th = Thread(target=self.startgbc)
		th.daemon = True
		th.start()
		th2 = Thread(target=self.acceptConnections)
		th2.daemon = True
		th2.start()

		"""
		self.socket.close()
		exit()
		"""
