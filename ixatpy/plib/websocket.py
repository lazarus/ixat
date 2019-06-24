class WebSocket:
	
	@staticmethod
	def read_message(socket):
		try:
			b1, b2 = socket.recv(2)
		except:
			b1, b2 = 0, 0

		fin 	= b1 & Config.FIN
		opcode	= b1 & Config.OPCODE
		masked	= b2 & Config.MASKED
		payload_length = b2 & Config.PAYLOAD_LEN

		if not b1:
			raise Exception("Client closed connection.")
		if opcode == Config.OPCODE_CLOSE_CONN:
			raise Exception("Client asked to close connection.")
		if not masked:
			raise Exception("Client must always be masked.")
		if opcode == Config.OPCODE_CONTINUATION:
			raise Exception("Continuation frames are not supported.")
		elif opcode == Config.OPCODE_BINARY:
			raise Exception("Binary frames are not supported.")
		elif opcode != Config.OPCODE_TEXT: # the only one we wanna do stuff with
			raise Exception("Unknown opcode &#x." + opcode)

		if payload_length == 126:
			payload_length = struct.unpack(">H", socket.recv(2))[0]
		elif payload_length == 127:
			payload_length = struct.unpack(">Q", socket.recv(8))[0]

		masks = socket.recv(4)
		decoded = ""
		for char in socket.recv(payload_length):
			char ^= masks[len(decoded) % 4]
			decoded += chr(char)
		return decoded

	@staticmethod
	def encode(message, opcode=Config.OPCODE_TEXT):
		"""
		Important: Fragmented(=continuation) messages are not supported since
		their usage cases are limited - when we don't know the payload length.
		"""

		# Validate message
		if isinstance(message, bytes):
			message = message.decode('utf-8')  # this is slower but ensures we have UTF-8
			if not message:
				raise Exception("Can\'t send message, message is not valid UTF-8")
				return False
		elif isinstance(message, str) or isinstance(message, unicode):
			pass
		else:
			raise Exception('Can\'t send message, message has to be a string or bytes. Given type is %s' % type(message))
			return False

		header  = bytearray()
		payload = message.encode('UTF-8')
		payload_length = len(payload)

		# Normal payload
		if payload_length <= 125:
			header.append(Config.FIN | opcode)
			header.append(payload_length)

		# Extended payload
		elif payload_length >= 126 and payload_length <= 65535:
			header.append(Config.FIN | opcode)
			header.append(Config.PAYLOAD_LEN_EXT16)
			header.extend(struct.pack(">H", payload_length))

		# Huge extended payload
		elif payload_length < 18446744073709551616:
			header.append(Config.FIN | opcode)
			header.append(Config.PAYLOAD_LEN_EXT64)
			header.extend(struct.pack(">Q", payload_length))

		else:
			raise Exception("Message is too big. Consider breaking it into chunks.")
			return

		return(header + payload)