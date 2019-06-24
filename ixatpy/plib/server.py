import socket
import hashlib
from base64 import b64encode, b64decode, decodestring
import json
import select
from sys import exit, argv, maxsize, stdout
from os import listdir, sep, getpid, path
from threading import Thread, activeCount, RLock
from gc import collect
from time import sleep, time
from traceback import print_exc, format_exc
import queue
import random
from binascii import crc32
from binascii import Error as BAError
import datetime
import logging
from math import pow, ceil, floor


class Server():

	def __init__(self):
		self.startTime = time()
		self.socket = None
		self.connection = {"ip": "0.0.0.0", "port": 1204}
		self.clients = []
		self.gcThread = None
		self.handlers = {}

		self.folders = ["commands", "handlers"]
		self.policyFile = '<cross-domain-policy><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>'
		self.specialBans = [134, 136, 140, 152, 162, 176, 184, 236]
		self.gameBans = [134, 136, 140, 152, 162, 236]

		self.debug = True
		self.LastChat = {}
		self.argv = argv
		self.setup()

		self.ConnectTime = {}
		self.Protected = {}

		self.queue = queue.Queue()
		self.rlock = RLock()
		self.rlock2 = RLock()
		self.packetThread = Thread(target=self.handleQueue)
		# self.packetThread.daemon = True
		self.packetThread.start()
		
	def auto_init(self):
		self.run()

	def setup(self):
		try:
			self.loadFolders()
			self.getConfig()
		except:
			self.write(format_exc())
			exit()

	def json_load(self, s=""):
		try:
			return json.loads(s)
		except:
			return None

	def getConfig(self):
		database.query('update `server` set `ipc`=' + str(config.CONN_PORT))
		self.config = database.fetchArray("SELECT * FROM `server` limit 0, 1")[0]
		self.config["staff"] = json.loads(self.config["staff"])
		self.config["vols"] = json.loads(self.config["vols"])
		self.config["ipbans"] = json.loads(self.config["ipbans"])
		self.config["blockedixats"] = json.loads(self.config["blockedixats"])
		self.config["connections"] = int(self.config["max_per_ip"])
		self.config["hugs"] = []

		spowers = database.fetchArray("select `id` from `powers` WHERE `hugs` != '';")
		for power in spowers:
			if int(power['id']) < 0:
				power['id'] = str(abs(int(power['id'])) + config.X_CUSTOM_OFFSET)
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

		for i, userid in enumerate(self.config["vols"]):
			self.config["vols"][i] = int(userid)

		#PWR_MAX_INDEX = database.fetch('SELECT `id` FROM `powers` ORDER BY `id` DESC LIMIT 1;')
		#config.PWR_MAX_INDEX = (int(PWR_MAX_INDEX[0]['id']) >> 5) + 1
			
	def getGroupPowers(self):
		spowers = database.fetchArray("select `id` from `powers` WHERE `group`=1")
		groupList = []
		for power in spowers:
			if int(power['id']) < 0:
				power['id'] = str(abs(int(power['id'])) + config.X_CUSTOM_OFFSET)
			groupList.append(power['id'])
		
		return groupList

	def loadFolders(self):
		self.handlers = {}
		for folder in self.folders:
			dir = config.FILE_PATH + sep + folder
			for file in listdir(dir):
				try:
					id, extension, py = file.split('.')
					try:
						with open(dir + sep + file) as fh:
							addHandler = "self.handlers[id + ':' + extension] = " + id + extension.capitalize()
							code = compile("@st_time\r\n" + fh.read() + "\r\n" + addHandler, '<string>', 'exec')
							exec(code)
							fh.close()
					except:
						self.write("File: " + id, "Error")
						self.write(format_exc())
				except:
					self.write("Invalid file: " + file, "Error")
					self.write(format_exc())

	def call(self, name='', type='', *extArgs):
		if name + ':' + type in self.handlers.keys():
			try:
				self.handlers[name + ':' + type](*extArgs)
				return True
			except:
				self.write(format_exc())
		return False

	def connect(self):
		try:
			if self.socket != None:
				try:
					self.socket.shutdown(2)
					self.socket.close()
				except:
					pass
					
			self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.SOL_TCP)
			self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
			#self.socket.setblocking(0)
			self.socket.bind((config.CONN_IP, config.CONN_PORT))
			self.socket.listen(socket.SOMAXCONN)
			
			self.start_time = time()
			self.write("Server started on {ip}:{port}".format(
				**{"ip": config.CONN_IP, "port": config.CONN_PORT}), "Server")
			"""
			except socket.error:
				exit("It looks like the port you are trying to bind to is busy.")
			"""
		except:
			self.write(format_exc())
			exit()

	def startgbc(self):
		while True:
			try:
				sleep(10)
				collect()
				KeepAlive = database.fetchArray("SHOW DATABASES;")
			except:	
				#self.loadDatabase()
				self.write(format_exc())
				pass

	def handleQueue(self):
		while True:
			try:
				data = self.queue.get()
				#self.write(str(data), "x")
				type = data[0]
				if type == 0:
					client = data[1]
					packet = data[2]
					
					if client.RapidMessageCheck(None, 0.1, 0, 0, 1):
						return client.send_xml('m', {'t': 'Packet Blocked due to limit', 'u': '0', 's': '0'})
						
					#logging.info(str(packet.tag) + " - " + str(packet.attrib))
					client.handle(packet.tag, packet.attrib)
					client.userTick()
				elif type == 1:
					client = data[1]
					client.joinRoom(True, False, True)
					#client.sentJ2 = True
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
				self.write(format_exc())
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

	def webSocketHandshake(self, part=""):
		try:
			sha1 = hashlib.sha1()
			sha1.update(part.encode("utf-8"))
			sha1.update(config.WS_MAGIC.encode('utf-8'))
			accept = (b64encode(sha1.digest())).decode("utf-8", "ignore")
			return accept
		except:
			return False

	def base64encode(self, string):
		return b64encode(str(string).encode()).decode()

	def base64decode(self, b64):
		try:
			if len(b64) % 4 != 0:
				return b64
			return decodestring(b64)
		except:
			#self.write(format_exc())
			try:
				return b64decode(str(b64).encode()).decode()
			except:
				#self.write(format_exc())
				return b64

	def DecodePowers(self, p, dO=""):
		powers = {}
		if len(p) > 0:
			for d, z in enumerate(p.split("|")):
				if len(z) == 0:
					continue
				p = "{0:#b}".format(int(z))[2:]
				for i, c in enumerate(list(p[::-1])):
					if c == "1":
						id_ = i + (d * 32)
						#if id_ > 640:
						#	id_ = 640 - id_
						powers[str(id_)] = 1
		if len(dO) > 0:
			for p in dO.split("|"):
				if len(p) == 0:
					continue
				id_, count = p.split("=")
				#if int(id_) > 640:
				#	id_ = str(640 - int(id_))
				powers[id_] += int(count)
		return powers

	def EncodePowers(self, powers):
		dO = []
		if len(powers) == 0:
			return ["", ""]

		min_ = min(list(map(int, powers.keys())))
		if min_ < 0:
			for x in range(1, abs(min_) + 1):
				if str(-x) in powers.keys():
					powers[str(x + 640)] = powers[str(-x)]
					del powers[str(-x)]

		new_powers = [0] * (int(ceil(int(max(list(map(int, powers.keys())))) / 32)) + 1)

		for power, amount in powers.items():
			new_powers[int(floor(int(power) / 32))] |= int(pow(2, int(power) % 32))
			if int(amount) > 1:
				dO.append(str(power) + "=" + str(int(amount) - 1))

		return ["|".join(map(str, new_powers)), "|".join(dO)]

	def AddUserPower(self, uid, pid, count = 1):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		if type(userpowers) != dict:
			userpowers = {}
		if int(pid) < 0:
			pid = str(abs(int(pid)) + 640)
		if str(pid) in userpowers:
			userpowers[str(pid)] += int(count)
		else:
			userpowers[str(pid)] = int(count)

		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def AddUserPowers(self, uid, parray, count = 1):#make it so you can add different count for each pid
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		for pid in parray:
			if int(pid) < 0:
				pid = str(abs(int(pid)) + 640)
			if str(pid) in userpowers:
				userpowers[str(pid)] += count
			else:
				userpowers[str(pid)] = count

		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def SetUserPower(self, uid, pid, count = 1):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		if int(pid) < 0:
			pid = str(abs(int(pid)) + 640)
		userpowers[str(pid)] = count

		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def SetUserPowers(self, uid, userpowers = []):
		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def RemUserPower(self, uid, pid):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		if int(pid) < 0:
			pid = str(abs(int(pid)) + 640)
		if str(pid) in userpowers:
			if userpowers[str(pid)] > 1:
				userpowers[str(pid)] -= 1
			else:
				del userpowers[str(pid)]

		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def RemUserPowers(self, uid, parray):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		for pid in parray:
			if int(pid) < 0:
				pid = str(abs(int(pid)) + 640)
			if str(pid) in userpowers:
				if userpowers[str(pid)] > 1:
					userpowers[str(pid)] -= 1
				else:
					del userpowers[str(pid)]
				
		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def DelUserPower(self, uid, pid):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		if int(pid) < 0:
			pid = str(abs(int(pid)) + 640)
		if str(pid) in userpowers:
			del userpowers[str(pid)]
				
		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def DelUserPowers(self, uid, parray):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
		for pid in parray:
			if int(pid) < 0:
				pid = str(abs(int(pid)) + 640)
			if str(pid) in userpowers:
				del userpowers[str(pid)]
				
		powers, dO = self.EncodePowers(userpowers)

		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": powers, "dO": dO})

	def ClearUserPower(self, uid):
		database.query("UPDATE `users` SET `powers`=%(powers)s, `dO`=%(dO)s WHERE `id`=%(uid)s", {"uid": str(uid), "powers": "", "dO": ""})

	def GetUserPower(self, uid):
		userpowers = database.fetchArray("SELECT `powers`,`dO` FROM `users` WHERE `id`=%(uid)s", {"uid": str(uid)})
		userpowers = self.DecodePowers(userpowers[0]['powers'], userpowers[0]['dO'])
			
		if type(userpowers) != type({}):
			userpowers = {}
		return userpowers
		
	def decodeUserPowers(self, powers):
		userpowers = json.loads(powers)
		if type(userpowers) != type({}):
			userpowers = {}
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

	def stribet(self, s, start, end):
		try:
			return s[s.find(start)+len(start):s.rfind(end)]
		except:
			return False

	def getUpTime(self):
		t = int(time() - self.startTime)
		days = int(t / 86400)
		hour = int(t / 3600)
		min  = int((t / 60) % 60)
		sec  = int(t % 60)
		res  = ""
		if days > 0: res += str(days) + " days, "
		if hour > 0: res += str(days) + " hours, "
		if min > 0: res += str(days) + " minutes, "
		if sec > 0: res += str(days) + " seconds, "
		
		return res
			
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
			if id in self.LastChat and id != 804:
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

	def BlastRand(self):
		MyRand = self.startTime + random.random()
		Rand = (time() + MyRand) % 1000
		return str(int(Rand))

	def doLogin(self, user = "", password = "", RL = True, checkPw = False):
		##if user == 'Techy':
			##return self.doLogin2(user, password, RL, checkPw)
		vals = {}
		p = {}
		pp = ''
		dO = ''
		powerO = ''
		username = user
		if not user or user == "" or user == False:
			return False
		usr = database.fetchArray('select `id`, `username`, `password`, `xats`, `days`, `d0`, `d2`, `torched`, `k`, `k2`, `k3` from `users` where `username`= %(username)s', {"username": user})
		try:
			if not usr or (checkPw and not database.validate(password, usr[0]['password'])):
				return False
				
			if int(usr[0]['d2']) == 0:
				bride = ""
			else:
				bride = usr[0]['d2']
			if int(usr[0]['days']) > time():
				self.DelUserPowers(usr[0]['id'], [0, 95])
				upowers = self.GetUserPower(usr[0]['id'])
				spowers = database.fetchArray('select `id`, `limited`, `p` from `powers` where `name` not like \'%(Undefined)%\';')
				allArray = []
				epArray = []
				myArray = []
				for power in spowers:
					if int(power['id']) < 0:
						power['id'] = str(abs(int(power['id'])) + config.X_CUSTOM_OFFSET)
					section = int(power['id']) >> 5
					subid = int(pow(2, int(power['id']) % 32))
					vals[int(power['id'])] = ['p' + str(section), subid]
					p['p' + str(section)] = 0
					if int(power['p']) == 1:
						if int(power['limited']) == 0:
							allArray.append(power['id'])
						epArray.append(power['id'])

				if int(usr[0]['torched']) != 1:
					for pid, pcount in upowers.items():
						if int(pcount) >= 1 and int(pid) in vals.keys():
							try:
								vals[int(pid)][0]
							except:
								self.write(format_exc())
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
					if not str(v) in myArray:
						GiveEp = False

						if v in allArray:
							GiveAll = False
							break

				parray = []
				if GiveEp == True:
					p["p2"] |= 2147483648
					parray.append(95)

				if GiveAll == True:
					p["p0"] |= 1
					parray.append(0)

				if len(parray) > 0:
					self.AddUserPowers(usr[0]['id'], parray)

				for i,u in p.items():
					pp += " d" + str(int(i[1:]) + int(4)) + '="' + str(p[i]) + '"'

			key = self.phash("md5", str(time()) + password)
			if RL:
				R = ' RL="1"'
				keyUpdate = ""
			else:
				R = ' loginkey="' + key + '"'
				keyUpdate = ", `loginkey`= %(key)s"
			database.query("update `users` set `dO`= %(powerO)s" + keyUpdate +" where `username`= %(username)s", {"powerO": powerO, "key": key, "username": usr[0]['username']})
			return '<v' + R + ' i="' + str(usr[0]['id']) + '" c="' + str(usr[0]['xats']) + '" dt="0" n="' + usr[0]['username'] + '" k1="' + str(usr[0]['k']) + '" k2="' + str(usr[0]['k2']) + '" k3="' + str(usr[0]['k3']) + '" d0="' + str(usr[0]['d0']) + '" d1="' + str(usr[0]['days']) + '" d2="' + str(bride) + '" d3=""' + str(pp) + ' dx="' + str(usr[0]['xats']) + '" dO="' + str(powerO) + '" PowerO="' + str(powerO) + '" />'
		except:
			self.write(format_exc())
			return False

	def doLogin2(self, user = "", password = "", RL = True, checkPw = False):
		username = user
		if not user or user == "" or user == False:
			return False
		usr = database.fetchArray('select `id`, `username`, `password`, `xats`, `days`, `d0`, `d2`, `torched`, `k`, `k2`, `k3` from `users` where `username`= %(username)s', {"username": user})
		try:
			if not usr or (checkPw and not database.validate(password, usr[0]['password'])):
				return False
			usr = usr[0]
			v = {
				"i": usr["id"],
				"n": usr["username"],
				"d0": usr["d0"],
				"dt": 0,
				"k2": usr["k2"],
				"k3": usr["k3"],
				"k1": usr["k"],
				"c": usr["xats"]
			}
				
			if int(usr['days']) > time():
				v["d1"] = usr["days"]

				self.DelUserPowers(usr['id'], [0, 95])
				power_bits = {'d' + str(i + 4): 0 for i in range(config.PWR_MAX_INDEX + 1)}
				power_over = ""
				allpowers, everypower = True, True

				storeList = {
					power["id"]: power for power in \
						database.fetchArray('select `id`, `limited` from `powers` where `p`=1 and `name` not like \'%(Undefined)%\';')
				}

				userPowers = self.GetUserPower(usr['id'])
				for powerId in storeList:
					power = storeList[powerId]

					if str(power["id"]) in userPowers:
						power_bits["d" + str(int(power["id"] / 32) + 4)] |= int(pow(2, int(power['id']) % 32))

						if userPowers[str(power["id"])] > 1:
							power_over += str(power["id"]) + "=" + str(userPowers[str(power["id"])] - 1) + "|" 

					else:
						if int(power['limited']) == 0:
							allpowers = False

						everypower = False

				parray = []
				if everypower:
					power_bits["d" + str(4 + int(95 / 32))] |= (2 ** (95 % 32))
					from operator import itemgetter
					min_key, _ = min(userPowers.items(), key=itemgetter(1))
					if userPowers[str(min_key)] > 1:
						power_over += "95=" + str(userPowers[str(min_key)] - 1) + "|" 
					parray.append(95)

				if allpowers:
					power_bits["d4"] |= 1
					parray.append(0)

				if len(parray) > 0:
					self.AddUserPowers(usr['id'], parray)

				for d in power_bits:
					if power_bits[d]:
						v[d] = power_bits[d]

				if power_over:
					v["dO"] = power_over

			if usr["xats"]:
				v["dx"] = usr["xats"]

			if usr["d2"]:
				v["d2"] = usr["d2"]

			v["d3"] = int(time()) >> 8

			key = self.phash("md5", str(time()) + password)
			if RL:
				v["RL"] = 1;
				keyUpdate = ""
			else:
				v["loginkey"] = key;
				keyUpdate = ", `loginkey`= %(key)s"

			database.query("update `users` set `dO`= %(powerO)s" + keyUpdate +" where `username`= %(username)s", {"powerO": power_over, "key": key, "username": usr['username']})
			logging.info(self.build_xml("v", v))
			return self.build_xml("v", v)
		except:
			self.write(format_exc())
			return False

	@st_time
	def build_xml(self, type='m', attributes=None, sort=None):
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
			self.write("Client.buildPacket Packet integrity check failed.", "Client")

		return packet+'/>'

	def write(self, string="", title="Server"):
		if True or Config.DEBUG_OUTPUT:
			print(str("[" + title.lower().capitalize() + "] " + str(string)).encode("utf-8", "replace").decode("utf-8", "replace"))
			stdout.flush()

	'''
	'' Write error to log file // future MySQL '''
	def writeDebug(self, debugLvl, data):
		if debugLvl & config.DEBUGLVL:
			if config.DEBUGLVL & config.DEBUG_ADDTIMESTAMP:
				data = "[" + str(int(time())) + "] " + data
				
				
			if config.DEBUGLVL & config.DEBUG_PRINT:
				print(data)
				
				
			if config.DEBUGLVL & config.DEBUG_FILE:
				if not hasattr(self, "debugFh"):
					self.debugFh = open(path.dirname(path.realpath(__file__)) + "/debug.log", "ab")
					self.debugFh.write(bytes("\r\nLogging started at " + str(int(time())) + "\r\n", "utf-8"))
				
				self.debugFh.write(bytes(data + "\r\n", "utf-8"))
				self.debugFh.flush()
			
			elif hasattr(self, "debugFh"):
				self.debugFh.close()
				del self.debugFh
				
				
			if config.DEBUGLVL & config.DEBUG_MYSQL:
				pass # write to mysql

	def hasServerMinRank(self, uid, min = 'staff'):
		if uid in self.config["staff"]:
			return True

		if min == 'vols':
			if uid in self.config["vols"]:
				return True

			return False

		return False

	def shutdown_socket(self, sock):
		try:
			sock.shutdown(2)
		except OSError:
			pass
		except:
			self.write(format_exc())

	def checkConnections(self):
		with self.rlock:
			for client in self.clients:
				try:
					if not client.online and ((time() - client.connecttime) >= 5):
						try:
							client.socket.shutdown(2)
							client.socket.close()
						except:
							pass
						self.clients.remove(client)
						continue
					if client.disconnected or client.SignedOut or client.duplicate:
						if client.online and not client.duplicate or client.online and client.duplicate and client.null:
							client.sendRoom('<l u="' + str(client.info["id"]) + '" />', True)
							if client.registered:
								client.updateTimeOnline()
							try:
								client.socket.shutdown(2)
								client.socket.close()
							except:
								pass
						self.clients.remove(client)
				except Exception as e:
					pass

	def acceptConnections(self, bool=False):
		self.pending = {}

		while True:
			try:
				#self.select = select.select([self.socket], [], [], 0.01)
				if True:
				#if self.select[0]:
					sock, address = self.socket.accept()
					self.pending[sock] = address[0]

					if address[0] in self.config["ipbans"]:
						raise Exception("IP BANNED")

					clients = self.clients
					connections = 0

					for client in clients:
						if client.connection["ip"] == address[0] and client.online:
							connections += 1

					for pending_address in self.pending.items():
						if address[0] is pending_address:
							connections += 1

					if connections >= self.config["connections"]:
						del self.pending[sock]
						sock.shutdown(2)
						sock.close()
						continue
					elif len(self.clients) >= 900:
						del self.pending[sock]
						sock.shutdown(2)
						sock.close()
						continue
					elif sock != None:
						#self.write("Client accepted [" + address[0] + ":" + str(address[1]) + "] Total Clients: " + str(len(self.clients)) + " Debug: " + str(connections), "Server")
						del self.pending[sock]
						self.queue.put([2, sock, address])
						#client = Client(sock, address, self)
						#self.clients.append(client)
						#client.start()
			except KeyboardInterrupt:
				exit()
				break
			except:
				try:
					del self.pending[sock]
				except:
					pass
				self.write(format_exc())
				pass

	def run(self):
		if Config.DEBUG_OUTPUT:
			self.write("Debug mode enabled.")

		self.connect()
		gbc = Thread(target=self.startgbc)
		gbc.daemon = True
		gbc.start()
		self.acceptConnections()

		"""
		self.socket.close()
		exit()
		"""
