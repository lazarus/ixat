from threading import BoundedSemaphore
from string import ascii_letters
from hashlib import sha1, sha512
from random import random, randint

from mysql import connector
import hashlib


class Database:
	args = None

	def __init__(self, host='localhost', port=3306, user='root', password='', table='', pool=1):
		if self.args == None:
			self.args = {
				'host': host,
				'port': port,
				'user': user,
				'password': password,
				'database': table,
				'charset': 'utf8',
				'autocommit': True
			}

			self.poolSize = pool
		else:
			for i in range(0, self.poolSize):
				try:
					self.pool[i].close()
				except:
					pass
		self.data = {"chat": {}}
		self.pool = []
		self.sema = BoundedSemaphore(value=self.poolSize)
		self.queries = 0
		self.assigned = 0
		for i in range(0, self.poolSize):
			cn = connector.connect(**self.args)
			
			cursor = cn.cursor()
			"""
			cursor.execute('SET NAMES utf8mb4;')
			cursor.execute("SET CHARACTER SET utf8mb4;")
			cursor.execute("SET character_set_connection=utf8mb4;")
			"""
			self.pool.append({'index': i, 'busy': False, 'link': cn})
			
		self.fetch = self.fetchArray

	def connectLink(self, index):
		try:
			self.pool[index]['link'].close()
		except:
			pass
		self.pool[index]['link'] = connector.connect(**self.args)

	def fetchLink(self):
		self.sema.acquire()
		for i in range(0, self.poolSize):
			if self.pool[i]['busy'] == False:
				self.pool[i]['busy'] = True
				return self.pool[i]
		self.sema.release()
		return False

	def releaseLink(self, index):
		if self.pool[index]['busy']:
			# If the connection reset, semaphore is also reset
			self.pool[index]['busy'] = False
			self.sema.release()

	def fetchArray(self, query='', bind=None):
		cn = self.fetchLink()
		select = []
		try:
			cursor = cn['link'].cursor()
			cursor.execute(query, bind)
			if hasattr(cursor, 'fetchall'):
				fetch = [cursor.fetchall(), cursor.column_names]
				for selRow in fetch[0]:
					columns = {}
					for (rKey, key) in enumerate(fetch[1]):
						columns[key] = selRow[rKey]
					select.append(columns)
			cursor.close()
			self.queries += 1
		except connector.errors.OperationalError:
			self.connectLink(cn['index'])
		except:
			self.connectLink(cn['index'])
		# print(format_exc())

		self.releaseLink(cn['index'])
		return select

	def query(self, query, bind=None):
		cn = self.fetchLink()
		try:
			cursor = cn['link'].cursor()
			cursor.execute(query, bind)
			if cursor != False:
				cursor.close()
			self.queries += 1
		except connector.errors.OperationalError:
			self.connectLink(cn['index'])
		except:
			self.connectLink(cn['index'])
		# print(format_exc())

		self.releaseLink(cn['index'])

	def insert(self, table, insert):
		query = 'insert into `' + table + '`(%s) values(%s);'
		ikeys, idata, items = '', '', []
		for key in insert:
			ikeys += '`' + key + '`, '
			idata += '%s, '
			items.append(insert[key])
		self.query(str(query % (ikeys[:-2], idata[:-2])), items)

	def loadChat(self, chatid=1):
		try:
			if chatid in self.data["chat"].keys():
				if not "UpdateToken" in self.data["chat"][chatid].keys():
					return self.data["chat"][chatid]
			self.data["chat"][chatid] = self.fetchArray("SELECT * FROM `chats` WHERE id = %(id)s", {"id":chatid})[0]
			return self.data["chat"][chatid]
		except:
			return None

	@staticmethod
	def hash(str, rawsalt = ''):
		if len(rawsalt) == 0:
			letters = 'abcdefghijklmnopqrstuvwxyz0123456789'
			rawsalt = ''.join([letters[randint(0, 35)] for i in range(((len(str) % 3) + 1) * 5)])

		loc = [sha1(rawsalt.encode("utf-8")).hexdigest(), sha1(str.encode("utf-8")).hexdigest(), '']
		loc[2] = ''.join([loc[2] + loc[0][i] + loc[1][i] for i in range(0, len(loc[0]))])
		hashx = sha512(loc[2].encode("utf-8")).hexdigest()

		split = (len(str) << 2) % 128
		return hashx[:split] + rawsalt + hashx[split:]

	@staticmethod
	def validate(test, hash):
		if not test:
			return False
		strl = (len(test) << 2) % 128
		salt = hash[strl : strl + ((len(test) % 3) + 1) * 5]
		return True if Database.hash(test, salt) == hash else False

	@staticmethod
	def rand(length = 32):
		letter = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
		return ''.join([letter[randint(0, 61)] for i in range(0, length)])
"""
	@staticmethod
	def hash(data, salt='', intl=0, size=0, wrap=0):
		if salt == '' or intl == 0 or size == 0 or wrap == 0:
			ascl = len(ascii_letters) - 1
			intl = int(random() * 64) + 32
			size = int(random() * 32) + 32
			wrap = int(random() * 30) + 2
			for i in range(0, size):
				salt += ascii_letters[int(random() * ascl)]

		hash = data
		for i in range(0, wrap):
			str0 = sha1(data.encode('ascii')).hexdigest()
			str1 = sha1(data.encode('ascii')).hexdigest()
			hash = ''  # intl
			for u in range(0, len(str0)):
				hash += str0[i] + str1[i]
			hash = sha512(hash.encode('ascii')).hexdigest()

		return chr(intl) + chr(size) + chr(wrap) + hash[:intl] + salt + hash[intl + size:]

	@staticmethod
	def check(real, test):
		nsIntl = ord(real[0])
		nsSize = ord(real[1])
		nsWrap = ord(real[2])
		nsSalt = real[nsIntl + 3: nsIntl + 3 + nsSize]
		nsTest = furrydb.hash(test, nsSalt, nsIntl, nsSize, nsWrap)
		return real == nsTest
"""
