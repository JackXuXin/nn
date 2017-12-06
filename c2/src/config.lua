-- development switch
DEVELOPMENT = true   --false 打开热更，true关闭

-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- display FPS stats on screen
DEBUG_FPS = false

-- dump memory info every 10 seconds
DEBUG_MEM = false
DEBUG_MEM_INTERVAL = 10

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "landscape"

-- design resolution
CONFIG_SCREEN_WIDTH  = 1280
CONFIG_SCREEN_HEIGHT = 720
-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "EXACT_FIT"

-- channel_id--不同平台对应唯一渠道号，请参照渠道管理文档-"1.0.0.8"

--"3550"-旺旺余姚，“3551”－旺旺慈溪，“3552”－旺旺东阳，“3553”－旺旺绍兴，“1801”－旺旺金陵
CONFIG_APP_CHANNEL = "3550"

CONFIG_VERSION_ID = "1.0.0.0"

-- login server
LOGIN_SERVER = {
	-- ip = "127.0.0.1", -- window must be this
	-- ip = "app.gametea.me",
	 ip = "tt.gametea.me",
	-- ip = "ky13.gametea.me",
	-- ip = "wwsx.gametea.me",
	-- ip = "tt.wangwang68.com",
	-- ip = "app.wangwang68.com",
	port = 6001,
}

-- gate server
GATE_SERVER = {
	-- ip = "127.0.0.1", -- window must be this
	-- ip = "app.gametea.me",
	 ip = "tt.gametea.me",
	-- ip = "ky13.gametea.me",
	-- ip = "wwsx.gametea.me",
    -- ip = "tt.wangwang68.com",
	-- ip = "app.wangwang68.com",
	port = 7001,
}
