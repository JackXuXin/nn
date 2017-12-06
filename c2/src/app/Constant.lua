return
{
	-- login cmd
	login_game = "login",
	login_qq = "loginQQ",
	login_weixin = "loginWeixin", 

	-- time
	network_loading = 16,
	lobby_popbox_trasition_time = 0.1,
	hotfix_time = 2592000,

	-- channel
	channel_game = "game",
	channel_weixin = "weixin",
	channel_qq = "qq",

	-- file
	account_history = "AccountHistory",
	account_history_upper = 10,
	screenshot_file = "ScreenShot.png",

	-- input length
	default_length = 20,
	gold_length = 12,
	id_length = 10,

	-- global
	m_curYvID = 0,
	show_leaveTip = false,
	countTime = 60,
	cur_GameID = 0,
	cur_RoomID = 0,
	hot_Finish = false,
    
    newChatNum = 0,
	isOpenYvSys = true,
    isLoginGame = false,
	isLoginChat = false,
	friendMax = 50,
	curFriendNum = 0,
	chatType = 0,
	chatMsg_length = 15,
	isRequesting = 0,
	isShowChat = false,
	nChatUid = 0,
	isInvite = false,
	isReuqestWchat = 0,
	enterGameUInfo = {},
	requestWchatInfo = {},
	requestInfo = { uid = 0, nickname = "魔渡众生", gameid = 101, roomid = 0, tableid = 0, seatid = 0, password = "1", session = 0},
	wChatInfo = { icon = nil, nick = nil, sex = nil },

	autoLogin = false,   --点击账号登录时，是否自动登录   --后面要修改  true为自动登录 发布时改为true 
	musicOn = true,		--大厅音乐开启
	voiceOn = true,		--大厅音效开启
	femaleOn = true,    --女生配音开启

	isturn = false,
	--是否是微信登录
	isWchatLogin = false,
	isRelogin = false,
	isReChangeNick = false,
	isOpening = false,
	isReconnectGame = false,
	delayTime = 50,
	lastNetState = 0,
	curRoomRound = 0,
	gameround = 0,
	userProtocol = "Rule/userProtocol",
}