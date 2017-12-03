
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- display FPS stats on screen
DEBUG_FPS = false

-- dump memory info every 10 seconds
DEBUG_MEM = false

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

loginserver = {
	ip = "47.100.117.210",
	port = 6001
}

gateserver = {
	ip = "47.100.117.210",
	port = 7001
}

gameSceneConfig = {}
gameSceneConfig[108] = "6jtScene"
lobbySceneName = "LobbyScene"
loginSceneName = "LoginScene"

TEST_FLAG = false
HOTFIX_ON_MAC = false