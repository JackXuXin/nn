local HkFiveCardScene = class("HkFiveCardScene", function()
    return display.newScene("HkFiveCardScene")
end)

local msgWorker = require("app.net.MsgWorker")

local consts = require("app.Games.HkFiveCard.constants")
local var = require("app.Games.HkFiveCard.variables")

local util = require("app.Games.HkFiveCard.util")

local utilCom = require("app.Common.util")
local Share = require("app.User.Share")

local uiSettings = require("app.Games.HkFiveCard.uiSettings")
local uiTableInfos = require("app.Games.HkFiveCard.uiTableInfos")
local uiOperates = require("app.Games.HkFiveCard.uiOperates")
local uiResults = require("app.Games.HkFiveCard.uiResults")
local uiPlayerInfos = require("app.Games.HkFiveCard.uiPlayerInfos")
local playerMgr = require("app.Games.HkFiveCard.playerMgr")
local cardMgr = require("app.Games.HkFiveCard.cardMgr")
local jettonMgr = require("app.Games.HkFiveCard.jettonMgr")
local msgMgr = require("app.Games.HkFiveCard.msgMgr")

local test = require("app.Games.HkFiveCard.test")

local PATH = consts.PATH
local scheduler = var.scheduler

-- static function of this scene
function HkFiveCardScene.preload()
	print("HkFiveCardScene preloading...")

	-- util.preload()
end

function HkFiveCardScene:ctor()
    print("HkFiveCardScene ctor():", tostring(self.class.__cname))
    self.root = cc.uiloader:load("Scene/HkFiveCardScene.json"):addTo(self)

    self.img_waiting_words = nil

	-- -- settings UI
    uiSettings:init(self)
    -- left top: game table info
	uiTableInfos:init(self)
	-- operation UI
	uiOperates:init(self)
	-- game result UI
	uiResults:init(self)
	-- players UI infomations of every seat
	uiPlayerInfos:init(self)

	-- action managers
	playerMgr:init(self)
	cardMgr:init(self)
	jettonMgr:init(self)

	msgMgr:init(self)

	-- -- test:init(self)

	msgWorker.init("HkFiveCard", handler(msgMgr, msgMgr.dispatch))
	msgWorker.sleep()

	print("fivecard---")

	if utilCom.UserInfo.watching == false then

         -- 设置语音聊天按钮
         utilCom.SetVoiceBtn(self,self.root)

    end

    print("uiSettings:",uiSettings)

    Share.SetGameShareBtn(true, self, display.right-69, display.bottom+140)

    print("fivecard111111---")

end

function HkFiveCardScene:onEnter()
	print("HkFiveCardScene:onEnter")

	-- util.test()
	-- test:common()
	-- test:process()
end

function HkFiveCardScene:onEnterTransitionFinish()
	print("HkFiveCardScene:onEnterTransitionFinish")
	msgWorker.wakeup()
end

function HkFiveCardScene:onExit()
	print("HkFiveCardScene:onExit")
	
	--停止所有音效
	audio.stopAllSounds()

	self.img_waiting_words = nil
	
	scheduler.clear()
	util.clear()

    uiSettings:clear()
	uiTableInfos:clear()
	uiOperates:clear()
	uiResults:clear()
	uiPlayerInfos:clear()

	playerMgr:clear()
	cardMgr:clear()
	jettonMgr:clear()
	msgMgr:clear()

	msgWorker.clear()

	--清理数据
	var.players = {}
end

-- ------------------------------ game process ------------------------------
function HkFiveCardScene:onGameStart()
	print("on game start")
	util.playSound(PATH.WAV_GAME_START)
end

function HkFiveCardScene:onGameEnd()
	print("on game end")
	util.playSound(PATH.WAV_GAME_END)
end


-- ------------------------------ scene show ------------------------------
function HkFiveCardScene:showWaiting(flag)
	if not flag then
		if self.img_waiting_words then 
			self.img_waiting_words:setVisible(false)
			if self.waiting_timer_handle then
				scheduler.unschedule(self.waiting_timer_handle)
			end
		end
		return
	end
	if not self.img_waiting_words then
		local words = display.newSprite(PATH.IMG_WAITING_WORDS, display.cx, display.cy)
		local dots = {}
		local dx = words:getCascadeBoundingBox().size.width
		for i = 1, 3 do 
			local dot = display.newSprite(PATH.IMG_WAITING_DOT, 0, 0)
			dot:setPositionX(dx + dot:getCascadeBoundingBox().size.width*i)
			dot:setPositionY(dot:getCascadeBoundingBox().size.height)
			dots[i] = dot
			words:addChild(dot)
		end
		self.root:addChild(words)
		self.img_waiting_words = words
		self.img_waiting_dots = dots
	else
		self.img_waiting_words:setVisible(true)
	end
	local idx = 0
	local show_list_set = {{false,false,false}, {true,false,false}, {true,true,false}, {true,true,true}}
	self.waiting_timer_handle = scheduler.schedule(function()
		idx = idx % 4 + 1
		local show_list = show_list_set[idx]
		for i = 1, 3 do 
			self.img_waiting_dots[i]:setVisible(show_list[i])
		end
	end, 0.5)
end


return HkFiveCardScene
