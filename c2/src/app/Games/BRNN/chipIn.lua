local BRNNScene = package.loaded["app.scenes.BRNNScene"] or {}

local util = require("app.Common.util")
local BRNNConfig = require("app.Games.BRNN.BRNNConfig")
local TipLayer = require("app.layers.TipLayer")

local Player = app.userdata.Player

function BRNNScene:setSelectedBet(index)
	local maxBet = math.min(self.gameInfo.leftChips, checkint(Player.gold) / 5 - self.gameInfo.playerSumChip)

	if not index then
		if self.gameInfo.selectedBet <= maxBet then
			return
		end
		index = #BRNNConfig.BetsConfig
	end

	local bet = BRNNConfig.BetsConfig[index]
	if not bet then
		return
	end

	if bet.gold > maxBet then
		local index = 1
		for i=#BRNNConfig.BetsConfig,1,-1 do
			if BRNNConfig.BetsConfig[i].gold < maxBet then
				index = i
				break
			end
		end
		bet = BRNNConfig.BetsConfig[index]
	end

	if bet and self.gameInfo.selectedBet ~= bet.gold then
		local betSprite = cc.uiloader:seekNodeByNameFast(self.roleLayer, bet.sprite)
		local bgSprite = cc.uiloader:seekNodeByNameFast(self.roleLayer, "Counter_Background")
		if betSprite and bgSprite then
			bgSprite:setPosition(betSprite:getPosition())
			self.gameInfo.selectedBet = bet.gold
			self:playSounds("Sound/BRNN/click_chouma.mp3")
		end
	end
end

function BRNNScene:beginChipIn()
	if self.resultLayer then
		self.resultLayer:removeFromParent()
		self.resultLayer = nil
	end

	self.roleLayer.textLeftBets:hide()
	self.roleLayer.leftBets:hide()
	for _,v in ipairs(self.roleLayer.otherBets) do
		v:hide()
	end
	for _,v in ipairs(self.roleLayer.playerBets) do
		v:hide()
	end

	self:beginCountDown()
	cc.uiloader:seekNodeByNameFast(self.roleLayer, "Status"):setString(app.lang.chip_in_time)

	self:playSounds("Sound/BRNN/start.mp3")

	self:updateBets()

	-- tip
	if not self.isBanker then
		TipLayer.new(app.lang.please_chip_in):addTo(self):setPosition(display.cx, display.cy)
	end

	-- update banker list
	if self.bankerListLayer then
		self:BankerListReq()
	end

	-- update rank list
	if self.rankLayer then
		self:RankListReq()
	end

	-- update history list
	if self.historyLayer and self.params.historyGameId ~= self.params.gameId then
		self:HistoryReq()
	end
end

function BRNNScene:updateBets(idx, val)
	if self.params.status == 1 and self.params.banker and self.params.banker.uid ~= 0 then
		self.roleLayer.textLeftBets:show()
		self.roleLayer.leftBets:show()
		self.roleLayer.leftBets:setString(util.toDotNum(self.gameInfo.leftChips))
	end

	for i,v in ipairs(self.roleLayer.otherBets) do
		if self.gameInfo.chips[i] > 0 then
			v:show()
			v:setString(util.toDotNum(self.gameInfo.chips[i]))
		end
	end

	for i,v in ipairs(self.roleLayer.playerBets) do
		if self.gameInfo.playerChips[i] > 0 then
			v:show()
			v:setString(util.toDotNum(self.gameInfo.playerChips[i]))
		end
	end

	if idx and val then
		local bets = {}
		for i=#BRNNConfig.BetsConfig,1,-1 do
			if val <= 0 then
				break
			end
			local num = math.floor(val / BRNNConfig.BetsConfig[i].gold)
			for j=1,num do
				table.insert(bets, BRNNConfig.BetsConfig[i].image)
			end
			val = val - num * BRNNConfig.BetsConfig[i].gold
		end

		if #bets <= 0 then
			return
		end

		local pool = self.roleLayer.betsPool[idx]
		if pool then
			local poolX, poolY = pool:getPosition()
			local poolSize = pool:getContentSize()
			local rect = cc.rect(poolX - poolSize.width / 2 + 50, poolY - poolSize.height / 2 + 50, 
				poolSize.width - 100, poolSize.height - 100)

			for _,v in ipairs(bets) do
				local randomX = math.random(rect.x, rect.x + rect.width)
				local randomY = math.random(rect.y, rect.y + rect.height)
				local bet = display.newSprite(v):addTo(self, -1)
				bet:setPosition(randomX, randomY)
				bet:setScale(0.5)
				table.insert(self.gameInfo.betsSprites, bet)
			end

			self:playSounds("Sound/BRNN/click_bet.mp3")
		end
	end

	self:setSelectedBet()
end

return BRNNScene