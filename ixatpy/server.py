from os import path, getpid
from plib.server import Server

if __name__ == "__main__":
	with open('pid.txt', 'w') as f:
		f.write(str(getpid()))
	server = Server(path.dirname(path.realpath(__file__)))