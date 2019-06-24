from socket import socket, AF_INET, SOCK_STREAM
from mysql  import connector as mysql_connect
from re     import findall as reSearchAll
from json   import dumps, loads
from random import randint
from time   import time

def init():
	with open('/root/Dropbox/ixatpy/config.php') as configFile:
		cfg = configFile.read()
		configFile.close()
		dbInfo = reSearchAll("([0-3]) \=\> '(.*?)'", cfg)
		dbInfo = [i[1] for i in dbInfo]
	
	db = mysql_connect.connect(**{'host': dbInfo[0], 'user': dbInfo[1], 'password': dbInfo[2], 'charset': 'utf8'})
	
	cursor = db.cursor()
	cursor.execute("use `" + dbInfo[3] + "`;")
	
	cursor.execute("select * from `powers` where `limited`!=0 and `p`!=0 and `id`>0 and `name` <> 'everypower' order by rand() limit 0, 1;")
	row = cursor.fetchone()
	
	power = {}
	for (i, u) in enumerate(cursor.column_names):
		power[u] = row[i]
	
	release = {'id': power['id'], 'time': int(time())}
	
	cursor.execute('select `power_release`, `ipc` from `server`;')
	fetch = cursor.fetchone()
	last, connect = (loads(fetch[0]), fetch[1])
	
	amount = randint(1, 6)
	
	try:
		sock = socket(AF_INET, SOCK_STREAM)
		sock.settimeout(3)
		sock.connect(('127.0.0.1', int(connect)))
		sock.sendall('<globalMessage t="' + str(amount) + ' ' + power['name'] + '&apos;s have been released" />\0')
		sock.close()
	except:
		pass
	
	cursor.execute("update `powers` set `amount`=0 where `id`=%s;", (last['id'],))
	cursor.execute("update `powers` set `amount`=%s where `id`=%s;", (amount, power['id'],))
	cursor.execute("update `server` set `power_release`=%s;", (dumps(release),))
	cursor.close()
	db.commit()
	
	
init()