from socket import socket, AF_INET, SOCK_STREAM
from mysql import connector as mysql_connect
from re import findall as researchall
from json import dumps, loads
from random import randint, shuffle
from time import time
from math import floor

def init():
	with open('/root/Dropbox/ixatpy/config.php') as configfile:
		cfg = configfile.read()
		configfile.close()
		dbinfo = researchall("([0-3]) \=\> '(.*?)'", cfg)
		dbinfo = [i[1] for i in dbinfo]

	db = mysql_connect.connect(**{'host': dbinfo[0], 'user': dbinfo[1], 'password': dbinfo[2], 'charset': 'utf8'})
	cursor = db.cursor()
	cursor.execute("use `" + dbinfo[3] + "`;")

	"""
	cursor.execute("select * from `powers` where `limited`!=0 and `p`!=0 and `id`>0 and `name` <> 'everypower' order by rand() limit 0, 1;")
	row = cursor.fetchone()
	
	power = {}
	for (i, u) in enumerate(cursor.column_names):
		power[u] = row[i]
	"""

	cursor.execute("select * from `server`")
	row = cursor.fetchone()
	power = {}
	for (i, u) in enumerate(cursor.column_names):
		power[u] = row[i]
	power_vote = loads(power["power_vote"])
	winners = []
	votes = -1
	for i, p in enumerate(power_vote["powers"]):
		if float(power_vote["powers"][p]) >= float(votes):
			if float(power_vote["powers"][p]) > float(votes):
				winners = []
				votes = float(power_vote["powers"][p])
			winners.append(p)
	shuffle(winners)
	cursor.execute('select * from `powers` where `name`="' + winners[0] + '"')
	row = cursor.fetchone()
	power = {}
	for (i, u) in enumerate(cursor.column_names):
		power[u] = row[i]
	release = {'id': power['id'], 'time': int(time())}
	cursor.execute('select `power_release`, `ipc` from `server`;')
	fetch = cursor.fetchone()
	last, connect = (loads(fetch[0]), fetch[1])
	amount = int(floor(randint(1, 6) + votes))

	try:
		sock = socket(AF_INET, SOCK_STREAM)
		sock.settimeout(3)
		sock.connect(('127.0.0.1', int(connect)))
		sock.sendall('<globalmessage t="' + str(amount) + ' ' + power['name'] + '&apos;s have been released" r="1" />\0')
		sock.close()
	except:
		pass

	cursor.execute("update `powers` set `amount`=0 where `id`=%s;", (last['id'],))
	cursor.execute("update `powers` set `amount`=%s where `id`=%s;", (int(amount), power['id'],))
	cursor.execute("update `server` set `power_release`=%s;", (dumps(release),))
	cursor.close()
	db.commit()

if __name__ == "__main__":
	init()