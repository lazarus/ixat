import socket
import struct
import hashlib
import base64
import codecs


'''
'' Socket Wrapper for people who don't want to rely on twisted/tornado
'' @Author Skylar Flare
''
'' If you're going to use non-blocking sockets, please overwrite send_proxy
'' with something like the example below where sends = {socket: queue}
'' Make sure when using a proxy, you check for B_KILL_AFTER_SENDALL in _flags.
''
''     def send(sock, data):
''         sends[sock].put(data)
''
''     sock = WebSocket(your_client_socket, send_proxy = send)
''
''     if sock in select([], [sock], [], None):
''         sock.send(sends[sock].get()) '''



class WebSocket2(object):
	
	
	# Settings for socket
	MAX_BUFFER_SIZE = 2147483647#8192
	READ_BUFFER_LEN = 1024
	
	
	'''
	'' Managed exception '''
	class Exception(Exception):
		status = 1002
		reason = None
		
		EX_HTTP = "HTTP"
		EX_WEBSOCKET = "WebSocket"
		
		def __init__(self, type, status, reason):
			self.type   = type
			self.status = status
			self.reason = reason
		
		def __str__(self):
			return self.reason
	
	
	# WebSocket Status Codes
	B_NONE = 0x00
	B_RAW  = 0x01
	B_HANDSHAKE_COMPLETE = 0x02
	B_FRAGMENTATION_STARTED = 0x04
	B_KILL_AFTER_SENDALL = 0x08
	
	
	# WebSocket Opcodes
	OPCODES = {
		"stream": 0x00,
		"text": 0x01,
		"binary": 0x02,
		"close": 0x08,
		"ping": 0x09,
		"pong": 0x0a,
		"control": (0x08, 0x09, 0x0a)
	}
	
	
	# Status Codes
	VALID_STATUS_CODES = [1000, 1001, 1002, 1003, 1007, 1008, 1009, 1010, 1011, 3000, 3999, 4000, 4999]
	
	
	'''
	'' Initialize the wrapper and create buffer '''
	def __init__(self, _socket, send_proxy = None):
		self._sock   = _socket
		self._flags  = WebSocket2.B_NONE
		self._send_bytes = send_proxy
		
		# Buffers
		self._buffer = bytearray()
		self._frag_buffer  = bytearray()
		self._frag_decoder = codecs.getincrementaldecoder("utf-8")()
		self._frag_opcode  = None
		self._headers      = {}
	
	
	'''
	'' Proxy any normal socket functions to our parent '''
	def __getattr__(self, attr_name):
		return getattr(self._sock, attr_name)
	
	
	'''
	'' Callback function when a WebSocket frame has been finished '''
	def on_message(self, byte_data, message_type):
		self._sendall(self._ws_encode(True, message_type, byte_data))
	#	raise NotImplementedError
	
	
	'''
	'' High wrapper to send data '''
	def _sendall(self, bytes):
		if self._send_bytes:
			self._send_bytes(bytes)
		
		else:
			self.sendall(bytes)
			
			if self._flags & WebSocket2.B_KILL_AFTER_SENDALL:
				self.shutdown(socket.SHUT_RDWR)
	
	
	'''
	'' Handle recv on socket, will raise socket.error if socket disconnects.
	'' This function returning None does NOT mean the socket has disconnected. '''
	def read(self):
		try:
			if self._flags & WebSocket2.B_HANDSHAKE_COMPLETE:
				# Buffer any data we can
				recv = self._sock.recv(WebSocket2.READ_BUFFER_LEN)
				
				if not recv:
					raise socket.error("Socket disconnected while reading")
				
				self._buffer.extend(recv)
				
				# Parse Frames
				for B_FIN, OPCODE, PL_LEN, byte_data in iter(self._parse_frame, [None] * 4):
					# Client requested close
					if OPCODE == WebSocket2.OPCODES["close"]:
						status, reason, length = 1000, b"", len(byte_data)
						
						if length >= 2:
							status = struct.unpack_from("!H", byte_data[:2])[0]
							status = status if (status in WebSocket2.VALID_STATUS_CODES) else 1002
							reason = byte_data[2:]
							reason.decode("utf-8")
						
						elif length == 1:
							status = 1002
						
						raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, status, reason)
					
					# Start / Part of a fragmented message
					if B_FIN == 0:
						# Start a fragment stream
						if OPCODE != WebSocket2.OPCODES["stream"]:
							if OPCODE in WebSocket2.OPCODES["control"]:
								raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002, 
									"Control messages can't be fragmented")
								
							# Reset our flags and buffer
							self._frag_decoder.reset()
							self._flags |= WebSocket2.B_FRAGMENTATION_STARTED
							self._frag_opcode = OPCODE
							
							# Attempt to decode if it's a text frame
							if OPCODE == WebSocket2.OPCODES["text"]:
								self._frag_decoder.decode(byte_data, final = False)
							
							# Append to our frag buffer
							self._frag_buffer.clear()
							self._frag_buffer.extend(byte_data)
							
						# Extend a fragmented message without initializing frag
						elif not (self._flags & WebSocket2.B_FRAGMENTATION_STARTED):
							raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002,
								"Recieved fragment extention before fragment start")
						
						# Extend a fragmented message
						else:
							# Attempt to decode text frames
							if self._frag_opcode == WebSocket2.OPCODES["text"]:
								self._frag_decoder.decode(byte_data, final = False)
							
							# Extend our buffer
							self._frag_buffer.extend(byte_data)
					
					# End of a fragmented message
					elif OPCODE == WebSocket2.OPCODES["stream"]:
						if not(self._flags & WebSocket2.B_FRAGMENTATION_STARTED):
							raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002,
								"Recieved fragment extention before fragment start")
						
						# Attempt to decode if it's a text frame
						if self._frag_opcode == WebSocket2.OPCODES["text"]:
							self._frag_decoder.decode(byte_data, final = True)
						
						# Extend our buffer
						self._frag_buffer.extend(byte_data)
						
						# Call our callback
						#self.on_message(self._frag_buffer, self._frag_opcode)
						return self._frag_buffer, self._frag_opcode
					
					elif OPCODE == WebSocket2.OPCODES["ping"]:
						self._sendall(self._ws_encode(True, WebSocket2.OPCODES["pong"], byte_data))
					
					elif OPCODE == WebSocket2.OPCODES["pong"]:
						pass
					
					elif (self._flags & WebSocket2.B_FRAGMENTATION_STARTED):
							raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002,
								"Recieved fragment extention before fragment start")
					
					# Recieved a regular message
					else:
						# Attempt to decode if it's a text frame
						if OPCODE == WebSocket2.OPCODES["text"]:
							byte_data.decode("utf-8")
						
						# Callback
						#self.on_message(byte_data, OPCODE)
						return byte_data, OPCODE
			
			elif self._flags & WebSocket2.B_RAW:
				#self.on_message(byte_data, None)
				return byte_data, None
			
			else:
				self._parse_http_header()
			
		except WebSocket2.Exception as exc:
			if exc.type == WebSocket2.Exception.EX_WEBSOCKET:
				self._close_ws(exc.status, exc.reason)
			
			else:
				response = "HTTP/1.1 " + str(exc.status) + " Bad Request\r\n\r\n" + exc.reason
				self._flags |= WebSocket2.B_KILL_AFTER_SENDALL
				self._sendall(response.encode("utf-8"))
		
		except UnicodeDecodeError:
			self._close_ws(1007, "Invalid UTF-8 Data")
	
	
	'''
	'' Send a closing frame as well as close the socket '''
	def _close_ws(self, status = 1000, reason = "", mask = False):
		close_msg = bytearray()
		close_msg.extend(struct.pack("!H", status))
		
		if isinstance(reason, str):
			close_msg.extend(reason.encode("utf-8"))
		else:
			close_msg.extend(reason)
		
		self._flags |= WebSocket2.B_KILL_AFTER_SENDALL
		self._sendall(self._ws_encode(True, WebSocket2.OPCODES["close"], close_msg, mask))
	
	
	
	'''
	'' Encode data to be sent over a WebSocket '''
	def _ws_encode(self, B_FIN, OPCODE, data, mask = False):
		header, body = bytearray(), bytearray()
		b0, b1 = 0, 0
		
		if B_FIN:
			b0 |= 0x80
		
		b0 |= OPCODE
		header.append(b0)
		
		if mask:
			b1 |= 0x80
		
		length = len(data)
		if length <= 125:
			b1 |= length
			header.append(b1)
		
		elif length >= 126 and length <= 65535:
			b1 |= 126
			header.append(b1)
			header.extend(struct.pack("!H", length))
		
		else:
			b1 |= 127
			header.append(b1)
			header.extend(struct.pack("!Q", length))
		
		body.extend(header)
		
		if mask:
			mask_bits = struct.pack("!I", random.getrandombits(32))
			body.extend(mask_bits)
			data = [b ^ mask_bits[i % 4] for i, b in enumerate(data)]
			
		body.extend(data)
		
		return body
		
		
	'''
	'' Parse a WebSocket frame '''
	def _parse_frame(self):
		# Make sure we have enough data to continue
		if len(self._buffer) < 2:
			return [None] * 4
		
		# Header
		B_FIN  = self._buffer[0] & 0x80
		B_RSV  = self._buffer[0] & 0x70
		OPCODE = self._buffer[0] & 0x0f
		B_MASK = self._buffer[1] & 0x80
		B_LEN  = self._buffer[1] & 0x7f
		
		# RSV Must be 0
		if B_RSV != 0:
			raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002, "RSV must be 0")
		
		# Opcode must be valid
		if (not OPCODE in WebSocket2.OPCODES.values()):
			raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002, "Unknown Opcode")
		
		# Length must be less than 126 if ping/pong
		if OPCODE in WebSocket2.OPCODES["control"] and B_LEN > 125:
			raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1002, "Control frames can't exceed 125 bytes")
		
		# Calculate Length
		PL_LEN = B_LEN
		MASK_START = DATA_START = 2
		
		if B_LEN == 126:
			if len(self._buffer) < 4:
				return [None] * 4
			
			PL_LEN = struct.unpack("!H", self._buffer[2:4])[0]
			MASK_START = DATA_START = 4
		
		elif B_LEN == 127:
			if len(self._buffer) < 10:
				return [None] * 4
			
			PL_LEN = struct.unpack("!Q", self._buffer[2:10])[0]
			MASK_START = DATA_START = 10
		
		# Make sure payload is not larger than our max buffer
		if PL_LEN > WebSocket2.MAX_BUFFER_SIZE:
			raise WebSocket2.Exception(WebSocket2.Exception.EX_WEBSOCKET, 1009, "Payload is too large")
		
		# Let's find our mask
		MASK_KEYS = [0] * 4
		
		if B_MASK == 128:
			if len(self._buffer) < MASK_START + 4:
				return [None] * 4
			
			DATA_START = MASK_START + 4
			MASK_KEYS  = [self._buffer[i] for i in range(MASK_START, MASK_START + 4)]
		
		# Do we have enough data to continue?
		if PL_LEN > len(self._buffer) - DATA_START:
			return [None] * 4
		
		byte_data = bytearray(PL_LEN)
		
		if B_MASK == 128:
			for i in range(PL_LEN):
				byte_data[i] = self._buffer[DATA_START + i] ^ MASK_KEYS[i % 4]
		else:
			for i in range(PL_LEN):
				byte_data[i] = self._buffer[DATA_START + i]
		
		if len(self._buffer) > DATA_START + PL_LEN:
			#print(self._buffer)
			self._buffer = self._buffer[DATA_START + PL_LEN:]
		
		else:
			self._buffer.clear()
		
		return B_FIN, OPCODE, PL_LEN, byte_data
	
	
	'''
	'' Read from the initial HTTP header, if not HTTP, drop connection.
	'' Check for GET /raw-socket HTTP/1.1 '''
	def _parse_http_header(self):
		# Buffer any recv data we need
		recv = self._sock.recv(WebSocket2.READ_BUFFER_LEN)
		
		if not recv:
			raise socket.error("Socket disconnected during handshake")
		
		self._buffer.extend(recv)
		
		
		# Make sure we have the entire header and it ends with \r\n\r\n
		if self._buffer[-4:] == b"\r\n\r\n":
			# Parse HTTP headers into a neat array
			if self._buffer[:32] == b"GET /raw-socket HTTP/1.1\r\n\r\n":
				self._flags |= WebSocket2.B_RAW
			
			else:
				for header in self._buffer.split(b"\r\n"):
					header_args = header.split(b": ", 1)
					
					if len(header_args) == 2:
						self._headers[header_args[0].decode("utf-8")] = header_args[1]
				
				# Make sure we have Sec-WebSocket-Key
				if not ("Sec-WebSocket-Key" in self._headers):
					raise WebSocket2.Exception(WebSocket2.Exception.EX_HTTP, 400, "Sec-WebSocket-Key was not provided.")
				
				# Calculate the WS Challenge
				ws_magic = b"258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
				ws_challenge_response = self._headers["Sec-WebSocket-Key"] + ws_magic
				ws_challenge_response = hashlib.sha1(ws_challenge_response).digest()
				ws_challenge_response = base64.b64encode(ws_challenge_response)
				
				# Construct and send our response
				ws_headers = b"HTTP/1.1 101 Switching Protocols\r\n" + \
					b"Upgrade: WebSocket\r\n" + \
					b"Connection: Upgrade\r\n" + \
					b"Sec-WebSocket-Accept: " + ws_challenge_response + b"\r\n" + \
					b"\r\n"
				
				self._sendall(ws_headers)
				self._flags |= WebSocket2.B_HANDSHAKE_COMPLETE
				
			self._buffer.clear()