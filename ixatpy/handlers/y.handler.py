def yHandler(packet, client, server):
	from random import randint, shuffle
	from time import time
	from json import dumps

	if client.sentY != True:
		client.handshake = {}
		client.yo1 = "auth2,auth,cb,Y,fuckm1,fuckm2,huem3,huem4,q,y,k,k3,d1,z,p,c,b,r,f,e,u".split(",")
		client.yo2 = "dO,sn,dx,dt,N,n,a,h,v,cv".split(",")
		shuffle(client.yo1)
		shuffle(client.yo2)
		client.ma = [
			randint(0, 32),
			randint(32, 64),
			randint(64, 128),
			randint(128, 256)
		]
		yKeys = {
			"loginKey": ["i", randint(10000000, 99999999)],
			"loginShift": ["s", randint(2, 5)],
			"loginTime": ["c", int(time())],
			"loginAuth": ["k", int(time())],
			"loginMA": ["a", dumps(client.ma, separators=(',', ':'))],
			"bitmap": ["p", "100_100_5_13376924"],
			"j2order": ["o", dumps([client.yo1, client.yo2]).replace('"', "&quot;")]
		}

		packetSend = "<y "
		for value in yKeys.items():
			setattr(client, value[0], value[1][1])
			client.handshake[value[1][0]] = value[1][1]
			packetSend += '{attribute}="{value}" '.format(**{"attribute": value[1][0], "value": value[1][1]})
		packetSend += "/>"
		client.yPacket = packet
		client.send(packetSend)
	client.sentY = True
# <y a="[31,58,90,222]" c="1447431724" i="46705019" o="[[&quot;y&quot;, &quot;f&quot;, &quot;p&quot;, &quot;fuckm2&quot;, &quot;cb&quot;, &quot;d1&quot;, &quot;k&quot;, &quot;fuckm1&quot;, &quot;u&quot;, &quot;k3&quot;, &quot;z&quot;, &quot;huem4&quot;, &quot;q&quot;, &quot;r&quot;, &quot;e&quot;, &quot;Y&quot;, &quot;c&quot;, &quot;auth2&quot;, &quot;b&quot;, &quot;huem3&quot;, &quot;auth&quot;], [&quot;sn&quot;, &quot;N&quot;, &quot;v&quot;, &quot;dO&quot;, &quot;cv&quot;, &quot;a&quot;, &quot;n&quot;, &quot;h&quot;, &quot;dt&quot;, &quot;dx&quot;]]" s="5" k="1447431724" p="100_100_5_13376924" />
