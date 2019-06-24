class Config:
	'''
	'' Connection Info '''
	CONN_IP = "0.0.0.0"
	CONN_PORT = 337
	'''
	'' Server Configuration '''
	FILE_PATH = ""
	RECV_BUFFER_SIZE = 4096
	MAX_PKT_LENGTH = RECV_BUFFER_SIZE
	DEBUG_OUTPUT = False
	
	MAX_CLIENTS = 900
	MAX_CLIENTS_PER_IPV4 = 16
	
	SO_KEEPALIVE = 1
	TCP_KEEPIDLE = 1 # Activate after TCP_KEEPIDLE seconds
	TCP_KEEPINTVL = 3 # Keepalive ping every y seconds
	TCP_KEEPCNT = 5 # Close socket after z failed pings
	
	'''
	'' Debug Levels '''
	DEBUG_NONE = 0
	DEBUG_ADDTIMESTAMP = 1
	DEBUG_PRINT = 2
	DEBUG_FILE = 4
	DEBUG_MYSQL = 8
	
	DEBUGLVL_TICK = 16
	DEBUGLVL_NOTE = 32
	DEBUGLVL_WARNING = 64
	DEBUGLVL_CRITICAL = 128
	
	DEBUGLVL_SEND = 256
	DEBUGLVL_RECV = 512
	
	
	DEBUGLVL = DEBUG_ADDTIMESTAMP | DEBUGLVL_NOTE | DEBUGLVL_WARNING | DEBUGLVL_CRITICAL | DEBUG_FILE
	
	'''
	'' Xat Constants '''
	X_COMMAND_PREFIXS = ["q", "~"]
	X_COMMAND_PREFIX_HIDDEN = "z"
	X_COMMAND_ALIAS = {
		"cl": "clear",
		"re": "relog",
		"rl": "server reload",
		"w": "whois",
		"v": "pvote vote",
		"vs": "pvote status",
		"to": "timeonline",
		"ep": "set everypower",
		"reload": "server reload",
		"restart": "server restart",
		"stop": "server stop",
		"resetconfig": "server reload",
		"hugs": "server hugs",
		"mysql": "server mysql",
		"notice": "server notice",
		"addxats": "add xats",
		"addxat": "add xats",
		"addpower": "add power",
		"sx": "set xats",
		"setxats": "set xats",
		"setid": "set id",
		"reserve": "set reserve",
		"name": "set name",
		"everypower": "set everypower",
		"nopowers": "set nopowers",
		"torch": "set torch",
		"torch2": "set torch2",
		"untorch": "set untorch",
		"activate": "set activate",
		"rid": "roomisdead",
		"client": "roomisdead updateclient",
		"8ball": "misc 8ball",
		"eightball": "misc 8ball",
		"fact": "misc fact",
		"randomfact": "misc fact",
		"fortune": "misc fortune",
		"slots": "misc slots",
		"dice": "misc dice",
		"prem": "pawn remove",
		"changename": "set name",
		"cname": "set name",
		"butthole": "misc 8ball",
		"celeb": "set celebrity",
		"delxats": "del xats",
		"delpower": "del power"
	}
	X_HIDE_COMMANDS = True
	X_J2_REQUIRED_KEYS = ["k", "c", "u", "n", "a", "h", "f", "y"]
	X_BANTIME_FOREVER = 0x7fffffff
	X_MAX_POOL = 50
	X_BYPASS_PACKETS = ["y", "j2", "v", "policy-file-request", "g", "gb", "h", "us", "hu"]
	X_BYPASS_AUTH = [-3, 1, 10, 804, 854, 6];
	X_BYPASS_IPS = ["127.0.0.1", "173.193.20.16"];
	X_BOTS = [804, 854]
	X_DEVS = [-3, 1, 10, -1]
	
	X_MOB_Z = 5774356866 # (squareroot * 2)
	X_MOB_VERSION = "m1.9.2,3"

	X_CUSTOM_OFFSET = 640

	PWR_MAX_INDEX = 25
	
	'''
	'' User Flag bits '''
	B_GUEST      = 0
	B_MEMBER     = 2
	B_MOD        = 4
	B_SUPER      = 8
	B_OWNER      = 16
	B_BANNED     = 64
	B_FOREVER    = 128
	B_GAGGED     = 0x200 
	B_MUTED      = 0x400 
	B_DUNCE      = 0x1000
	B_BADGE      = 0x2000
	B_NAUGHTY    = 0x3000
	B_YELLOW     = 0x4000
	B_DUNCE_BITS = 0x3000
	B_ALL_POWERS = 0x20000000
	B_INVISIBLE  = 0x40000000
	B_SINBIN     = 0x80000000

	'''
	'' Bits2 '''
	B_BOT           = 0x200
	B_PUZZLE_BANNED = 0x100000
	B_AWAY          = 0x200000
	B_NOT_BANNED    = 0x400000

	'''
	'' <u <i message flags '''
	U_OWNER       = 1
	U_MOD         = 2
	U_MEMBER      = 3
	U_SUPER       = 4
	U_ALREADYON   = 8
	U_BANNED      = 0x10
	U_VIP         = 0x20
	U_FOREVER     = 0x40
	U_HAS_PROFILE = 0x80
	U_GAGGED      = 0x100
	U_SINBIN      = 0x200
	U_INVISIBLE   = 0x400
	U_MOBILE      = 0x800
	U_BANISH      = 0x1000
	U_BOT         = 0x2000
	U_AWAY        = 0x4000
	U_DUNCE       = 0x8000
	U_TYPING      = 0x10000
	U_NOT_BANNED  = 0x20000
	U_BADGE       = 0x40000
	U_NAUGHTY     = 0x80000
	U_YELLOW      = 0x100000
	U_RED         = 0x200000
	U_TEMP        = 0x400000
	
	'''
	'' Future flags ''
					0x00000
					0x1000000
					0x2000000
					0x4000000
					0x8000000
					0x10000000
					0x20000000
					0x40000000
	'''
	
	'''
	'' Power stuff '''
	POOL_RANK = 2
	POOL_BANNED = 2
	
	GCONTROL_DEFAULTS = {
		'mg': 7, #makeGuest_minRank
		'mb': 8, #makeMember_minRank
		'mm': 11, #makeModerator_minRank
		'kk': 7, #kick_minRank
		'bn': 7, #ban_minRank
		'ubn': 7, #unBan_minRank
		'mbt': 6, #maxBan_mod
		'obt': 0, #maxBan_owner
		'ss': 10, #setScroller_minRank
		'dnc': 14, #canBeDunced_minRank
		'bdg': 10, #canBadge_minRank
		'ns': 7, #canNaughtyStep_minRank
		'yl': 7, #canYellowCard_minRank
		'rc': 7, #canRedCard_minRank
		'rf': 6, #redCardFactor
		'ka': 10, #kickAll_minRank
		'rl': 11, #canRankLock_minRank
		'sme': 7, #canSilentMember_minRank
		'bst': 0, #blastAnimation
		'p': 10, #protect_minRank
		'pd': 1, #protectDefault
		'pt': 1, #protectTime
		'ssb': 99, #canSilentBan_minRank
		'cbs': 0, #cantBeSilentBanned_minRank
		'j': 2, #canJinx_minRank
		'js': 0, #canJinxSameRank
		'mmt': 1, #maxMuteTime
		'cm': 11 #canMute_minRank
	}

	'''
	'' WebSocket Stuff '''
	FIN    = 0x80
	RSV	   = 0x70
	OPCODE = 0x0f
	MASKED = 0x80
	PAYLOAD_LEN = 0x7f
	PAYLOAD_LEN_EXT16 = 0x7e
	PAYLOAD_LEN_EXT64 = 0x7f

	OPCODE_CONTINUATION = 0x0
	OPCODE_TEXT         = 0x1
	OPCODE_BINARY       = 0x2
	OPCODE_CLOSE_CONN   = 0x8
	OPCODE_PING         = 0x9
	OPCODE_PONG         = 0xA
	OPCODE_CONTROL      = [0x08, 0x09, 0x0a]

	OPCODES = [OPCODE_CONTINUATION, OPCODE_TEXT, OPCODE_BINARY, OPCODE_CLOSE_CONN, OPCODE_PING, OPCODE_PONG, OPCODE_CONTROL]

	WS_SECRET	= "2cyVmdyVmLvNmbpZ1Zis3chRmZiYSXh5HclBmboQWa05HKhB2YltFdisSddJSK=k"
	WS_MAGIC	= "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
	
	'''
	'' Other Stuff '''
