from os import path, getpid
from plib.mysql import Database
from sys import stdout
from time import time, sleep, process_time
import logging, re, json
from contextlib import contextmanager

logging.basicConfig(filename=path.dirname(path.realpath(__file__)) + '/errors.txt', level=logging.DEBUG, filemode='w')
'''
'' Get settings.json '''
try:
	settings = json.load(open(path.dirname(path.realpath(__file__)) + "/" + "settings.json", "r"))
		
	globals()["database"] = Database(
		settings['database']["host"], 
		settings['database']["port"], 
		settings['database']["user"], 
		settings['database']["password"], 
		settings['database']["table"], 
		settings['database']["poolsize"]
	)
except:
	exit("Couldn't load settings.json or database")

def st_time(func):
	"""
		st decorator to calculate the total time of a func
	"""

	def st_func(*args, **keyArgs):
		t1 = process_time()
		r = func(*args, **keyArgs)
		t2 = process_time()
		dif = t2 - t1
		if dif > 0.09 and Config.DEBUG_OUTPUT:
			print("Function=%s%s, %s, Time=%.10f" % (func.__name__, args, keyArgs, dif))
			stdout.flush()
		return r

	return st_func
	
@contextmanager  
def measureTime(title):
	t1 = process_time()
	yield
	t2 = process_time()
	if Config.DEBUG_OUTPUT:
		print("%s: %0.10f seconds elapsed" % (title, t2-t1))
		stdout.flush()


def load_ext(fileName):
	with open(fileName) as fh:
		code = compile(fh.read(), fileName, "exec")
		exec(code, globals())
		
try:
	load_ext(path.dirname(path.realpath(__file__)) + '/plib/config.py')
	load_ext(path.dirname(path.realpath(__file__)) + '/plib/wswrapper.py')
	load_ext(path.dirname(path.realpath(__file__)) + '/plib/server.py')		
	load_ext(path.dirname(path.realpath(__file__)) + '/plib/client.py')

	globals()["config"] = Config()
	#globals()["websocket"] = WebSocket2()
	config.FILE_PATH = path.dirname(path.realpath(__file__))
	config.CONN_IP = settings['connection']['ip']
	config.CONN_PORT = settings['connection']['port']

	globals()["server"] = Server()

	if __name__ == "__main__":
		with open(config.FILE_PATH + '/pid.txt', 'w') as f:
			f.write(str(getpid()))
		server.auto_init()
except Exception as e:
	print(e)
	stdout.flush()