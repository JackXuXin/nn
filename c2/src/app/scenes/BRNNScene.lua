local BRNNScene = class("BRNNScene", function()
	require("app.Games.BRNN.msgMgr")
	require("app.Games.BRNN.chipIn")
	require("app.Games.BRNN.openCard")
	require("app.Games.BRNN.other")
    return display.newScene("BRNNScene")
end)

local msgWorker = require("app.net.MsgWorker")
local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local PreloadRes = require("app.config.PreloadRes")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local crypt = require("crypt")
local util = require("app.Common.util")

function BRNNScene:ctor()
	self.handlers = {}
	self:clear()

	util.loadImagesAsyn(PreloadRes.BRNNRes, function ()
		self.params.preload = true
	end)

	display.addSpriteFrames("Image/BRNN/Player/chouma.plist", "Image/BRNN/Player/chouma.png")

	msgWorker.init("NN100", handler(self, self.dispatch))

	self:addSettingLayer()

	self:changeRoleLayer()

end

function BRNNScene:onEnter()

end

function BRNNScene:onEnterTransitionFinish()

end

function BRNNScene:onExit()
	self:clear()
end

function BRNNScene:clearHandlers(handler)
	for k,v in pairs(self.handlers) do
		if not handler or handler == v then
			scheduler.unscheduleGlobal(v)
			self.handlers[k] = nil
		end
	end
end

function BRNNScene:clear()
	self:clearHandlers()

	self.params = {
		preload = false,
		roomId = nil,
		session = nil,
		seat = nil,
		isBanker = false,
		banker = nil,
		bankerList = nil,
		minGold = nil,
		rank = nil,
		history = nil,
		historyGameId = nil, -- last request history game id
		status = 0, -- 0, init; 1, begin chip in; 2, begin play; 3, game end;
		gameId = 0, -- increase 1 per game
		gold = 0,
		entered = false,
	}
	self.gameInfo = {
		clear = function (self)
			self.selectedBet = self.selectedBet or 0
			self.timeout = 0
			self.leftChips = 0
			self.chips = {0, 0, 0, 0}
			self.playerSumChip = 0
			self.playerChips = {0, 0, 0, 0}
			self.cards = {}
			self.cardtypes = {}
			self.result = nil
			self:clearCardHeapSprite()
			self:clearCardsSprites()
			self:clearBetsSprites()
		end,

		clearCardHeapSprite = function (self)
			if self.cardHeapSprite ~= nil then
				self.cardHeapSprite:removeFromParent()
				self.cardHeapSprite = nil
			end
		end,

		clearCardsSprites = function (self, index)
			if self.cardsSprites then
				for i,v in pairs(self.cardsSprites) do
					if not index or i == index then
						for _,sp in ipairs(v) do
							sp:removeFromParent()
						end
						self.cardsSprites[i] = {}
					end
				end
			else
				self.cardsSprites = {{}, {}, {}, {}, {}}
			end
		end,

		clearBetsSprites = function (self)
			if self.betsSprites then
				for _,v in ipairs(self.betsSprites) do
					v:removeFromParent()
				end
			end
			self.betsSprites = {}
		end
	}
	self.gameInfo:clear()

	audio.stopAllSounds()
	audio.stopMusic()
end

function BRNNScene:changeRoleLayer()
	local layer
	if self.params.isBanker then
		layer = cc.uiloader:load("Layer/Game/BRNN/BankerLayer.json")
	else
		layer = cc.uiloader:load("Layer/Game/BRNN/PlayerLayer.json")
	end
	layer:addTo(self, -2)

	if self.roleLayer then
		self.roleLayer:removeFromParent()
	end
	self.roleLayer = layer

	-- function buttons
	local history = cc.uiloader:seekNodeByNameFast(layer, "History")
	if history then
		history:onButtonClicked(handler(self, self.showHistoryLayer))
	end

	local rank = cc.uiloader:seekNodeByNameFast(layer, "Rank")
	if rank then
		rank:onButtonClicked(handler(self, self.showRankLayer))
	end

	local help = cc.uiloader:seekNodeByNameFast(layer, "Help")
	if help then
		help:onButtonClicked(handler(self, self.showHelpLayer))
	end

	local applyBanker = cc.uiloader:seekNodeByNameFast(layer, "ApplyBanker")
	if applyBanker then
		applyBanker:onButtonClicked(handler(self, self.showBankerList))
	end

	local giveUpBanker = cc.uiloader:seekNodeByNameFast(layer, "GiveUpBanker")
	if giveUpBanker then
		giveUpBanker:onButtonClicked(handler(self, self.giveUpBanker))
	end

	-- tian di xuan huang
	self.roleLayer.betsPool = {}
	table.insert(self.roleLayer.betsPool, cc.uiloader:seekNodeByNameFast(layer, "Tian"))
	table.insert(self.roleLayer.betsPool, cc.uiloader:seekNodeByNameFast(layer, "Di"))
	table.insert(self.roleLayer.betsPool, cc.uiloader:seekNodeByNameFast(layer, "Xuan"))
	table.insert(self.roleLayer.betsPool, cc.uiloader:seekNodeByNameFast(layer, "Huang"))
	for i,v in ipairs(self.roleLayer.betsPool) do
		v:onButtonClicked(function ()
			self:AskBet(i)
		end)
	end

	-- bets
	self.roleLayer.selectBets = {}
	table.insert(self.roleLayer.selectBets, cc.uiloader:seekNodeByNameFast(layer, "Counter100") or nil)
	table.insert(self.roleLayer.selectBets, cc.uiloader:seekNodeByNameFast(layer, "Counter1000") or nil)
	table.insert(self.roleLayer.selectBets, cc.uiloader:seekNodeByNameFast(layer, "Counter10000") or nil)
	table.insert(self.roleLayer.selectBets, cc.uiloader:seekNodeByNameFast(layer, "Counter100000") or nil)
	table.insert(self.roleLayer.selectBets, cc.uiloader:seekNodeByNameFast(layer, "Counter1000000") or nil)
	table.insert(self.roleLayer.selectBets, cc.uiloader:seekNodeByNameFast(layer, "Counter5000000") or nil)
	for i,v in ipairs(self.roleLayer.selectBets) do
		v:onButtonClicked(function ()
			self:setSelectedBet(i)
		end)
	end

	-- labels
	self.roleLayer.status = cc.uiloader:seekNodeByNameFast(self.roleLayer, "Status")
	self.roleLayer.textLeftBets = cc.uiloader:seekNodeByNameFast(layer, "Text_LeftBets")
	self.roleLayer.leftBets = cc.uiloader:seekNodeByNameFast(layer, "LeftBets")
	self.roleLayer.otherBets = {}
	table.insert(self.roleLayer.otherBets, cc.uiloader:seekNodeByNameFast(layer, "Tian_Bets"))
	table.insert(self.roleLayer.otherBets, cc.uiloader:seekNodeByNameFast(layer, "Di_Bets"))
	table.insert(self.roleLayer.otherBets, cc.uiloader:seekNodeByNameFast(layer, "Xuan_Bets"))
	table.insert(self.roleLayer.otherBets, cc.uiloader:seekNodeByNameFast(layer, "Huang_Bets"))
	self.roleLayer.playerBets = {}
	table.insert(self.roleLayer.playerBets, cc.uiloader:seekNodeByNameFast(layer, "Player_Tian_Bets"))
	table.insert(self.roleLayer.playerBets, cc.uiloader:seekNodeByNameFast(layer, "Player_Di_Bets"))
	table.insert(self.roleLayer.playerBets, cc.uiloader:seekNodeByNameFast(layer, "Player_Xuan_Bets"))
	table.insert(self.roleLayer.playerBets, cc.uiloader:seekNodeByNameFast(layer, "Player_Huang_Bets"))

	self:setSelectedBet(1)
	self:updatePlayerInfo()
	self:updateBankerInfo()
end

function BRNNScene:updatePlayerInfo()
	local Player = app.userdata.Player
	local playerGold = cc.uiloader:seekNodeByNameFast(self.roleLayer, "PlayerGold")
	playerGold:setString(util.toDotNum(self.params.gold))

	local playerName = cc.uiloader:seekNodeByNameFast(self.roleLayer, "PlayerName")
	playerName:setString(util.checkNickName(Player.nickname))

--modify by whb 161031
    if Player.viptype > 0 then
       playerName:setColor(cc.c3b(251, 132, 132))
    end
--modify end

	local playerAvatar = cc.uiloader:seekNodeByNameFast(self.roleLayer, "PlayerAvatar")
	--modify by whb 161028
    local image = AvatarConfig:getAvatar(Player.sex, Player.gold, Player.viptype)
    --modify end
	local rect = cc.rect(0, 0, 188, 188)
	local newAvatar = cc.SpriteFrame:create(image, rect)
	local size = playerAvatar:getContentSize()
	playerAvatar:setSpriteFrame(newAvatar)
	playerAvatar:setContentSize(size)
	playerAvatar:setCapInsets(rect)
end

function BRNNScene:updateBankerInfo()
	local bankerInfo = cc.uiloader:seekNodeByNameFast(self.roleLayer, "Banker_Info")
	if not bankerInfo then
		return
	end

	local waitBanker = cc.uiloader:seekNodeByNameFast(self.roleLayer, "Text_WaitBanker")
	if not self.params.banker or self.params.banker.uid == 0 then
		if waitBanker then
			waitBanker:show()
		end
		bankerInfo:hide()
	else
		if waitBanker then
			waitBanker:hide()
		end
		bankerInfo:show()
		local bankerName = cc.uiloader:seekNodeByNameFast(bankerInfo, "BankerName")
		bankerName:setString(util.checkNickName(crypt.base64decode(self.params.banker.nickname)) or "")

--modify by whb 161031
    if self.params.banker.viptype ~= nil and self.params.banker.viptype > 0 then
       bankerName:setColor(cc.c3b(251, 132, 132))
    end
--modify end

		local bankerGold = cc.uiloader:seekNodeByNameFast(bankerInfo, "BankerGold")
		bankerGold:setString(util.toDotNum(self.params.banker.gold))

		local bankerRecord = cc.uiloader:seekNodeByNameFast(bankerInfo, "BankerRecord")
		bankerRecord:setString(util.toDotNum(self.params.banker.score))

		local bankerAvatar = cc.uiloader:seekNodeByNameFast(self.roleLayer, "BankerAvatar")
--modify by whb 161031
    local viptype = 0
    if self.params.banker.viptype ~= nil then
    	viptype = self.params.banker.viptype
    end

    local image = AvatarConfig:getAvatar(self.params.banker.sex, self.params.banker.gold, viptype)
--modify end
		local rect = cc.rect(0, 0, 188, 188)
		local newAvatar = cc.SpriteFrame:create(image, rect)
		local size = bankerAvatar:getContentSize()
		bankerAvatar:setSpriteFrame(newAvatar)
		bankerAvatar:setContentSize(size)
		bankerAvatar:setCapInsets(rect)
	end
end

function BRNNScene:beginCountDown()
	self:clearHandlers(self.handlers.timeHandler)

	local function setCountDownText()
		local panel = cc.uiloader:seekNodeByNameFast(self.roleLayer, "CountDownPanel")
		panel:removeAllChildren()
		self:createTimeSprite(panel, self.gameInfo.timeout)
	end

	setCountDownText()
	self.handlers.timeHandler = scheduler.scheduleGlobal(function ()
		self.gameInfo.timeout = self.gameInfo.timeout - 1
		if self.gameInfo.timeout < 0 then
			self:clearHandlers(self.handlers.timeHandler)
			return
		end

		setCountDownText()

		if self.gameInfo.timeout <= 4 and self.params.status == 1 then
			self:playSounds("Sound/BRNN/left_4s.mp3")
		end
	end, 1)
end

function BRNNScene:createTimeSprite(parent, time)
	if not self.params.preload then
		return
	end

	local sprites = {}
	repeat
		local t = time % 10
		time = math.floor(time / 10)

		local scores = PreloadRes.BRNNResName.Scores
		table.insert(sprites, display.newSprite(util.getSpriteFrameFromCache(scores, PreloadRes.BRNNRes[scores], t + 1)))
	until time <= 0

	local size = parent:getContentSize()
	local cx, cy = size.width / 2, size.height / 2
	local width = 22 * #sprites
	for i,v in ipairs(sprites) do
		v:addTo(parent):setPosition(cx + width / 2 - 11 - 22 * (i - 1), cy)
	end
end

return BRNNScene