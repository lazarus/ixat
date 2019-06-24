from urllib import urlretrieve, urlopen
from threading import Thread, activeCount
from time import sleep
from os import remove
from json import loads

lol = "ad,ae,af,ag,ai,aland,al,am,an,ao,ar,as,at,au,aw,az,ba,bb,bd,be,bf,bg,bh,bj,bm,bn,bo,br,bs,bt,bw,by,bz,ca,ch,ci,cl,cm,cn,co,cq,cr,cu,cv,cy,cz,de,dj,dk,dm,do,dpr,dz,ec,ee,en,es,et,fi,fj,fk,fm,fo,fr,ga,gb,gd,ge,gh,gi,gl,gm,gn,gq,gr,gt,guernsey,gu,gy,hk,hn,ht,hu,id,ie,il,in,iq,ir,isleofman,is,it,jersey,jm,jo,jp,jr,ke,kg,kh,kr,kw,ky,kz,la,lb,lc,li,lk,lr,ls,lt,lu,lv,ly,mc,md,mg,mk,ml,mm,mn,mp,mt,mu,mv,mw,mx,my,mz,na,ne,ng,ni,nl,no,np,nz,om,pa,pe,pf,pg,ph,pk,pl,pr,ps,pt,py,qa,redcross,ro,rs,ru,rw,sa,scotland,sc,sd,se,sg,si,sk,sm,sn,so,sr,sv,sy,sz,tc,tg,th,tj,tn,tr,tt,tv,tw,tz,ua,ug,us,uy,uz,vc,ve,vg,vi,vn,wales,ye,za,zm,zw"

def download(sName):
	while True:
		try:
			#print "http://xat.com/images/sm2/flag/" + sName + ".swf"
			urlretrieve("http://xat.com/images/sm2/flag/" + sName + ".swf", "./flag/" + sName + ".swf")
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
