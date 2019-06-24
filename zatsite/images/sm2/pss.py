from urllib import urlretrieve, urlopen
from threading import Thread, activeCount
from time import sleep
from os import remove
from json import loads

#lol = "summerflix"
lol = "ribunny,riangry,riback,ridance,ridizzy,riears,rieat,rihaha,rijoy,rikiss,rilove,risad,rithink,riyes"

def download(sName):
	while True:
		try:
			#print "http://www.xatech.com/images/sm2/" + sName + ".swf"
			urlretrieve("http://www.xatech.com/images/sm2/" + sName + ".swf", "/root/Dropbox/zatsite/images/sm2/" + sName + ".swf")
			break
		except Exception, e:
			print e
			pass
	


try:
	i = 0
	pss = lol.split(',')
	while i < len(pss):
		while activeCount() < 100 and i < len(pss):
			if not pss[i].isdigit():
				Thread(target = download, args = [pss[i]]).start()
				print i, '/', len(pss)
			i += 1
		
		sleep(1)
except Exception, e:
	print e
