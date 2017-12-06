local BRNNScene = package.loaded["app.scenes.BRNNScene"] or {}

local BRNNConfig = require("app.Games.BRNN.BRNNConfig")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local util = require("app.Common.util")
local Share = require("app.User.Share")
local msgWorker = require("app.net.MsgWorker")

function BRNNScene:beginOpenCard(isShowCard)
	self.roleLayer.textLeftBets:hide()
	self.roleLayer.leftBets:hide()

	self:clearHandlers()
	self:beginCountDown()

    print("isShowCard:", isShowCard)
	print("beginOpenCard:self.gameInfo.timeout:".. self.gameInfo.timeout)

	if isShowCard and self.gameInfo.timeout >= 16 then
		self.roleLayer.status:setString(app.lang.deal_card)
		self:dealCards()
		self.handlers.openHandler = scheduler.performWithDelayGlobal(function ()
			self.roleLayer.status:setString(app.lang.open_card)
			self:openCards()
		end, 7)

		self.handlers.resultHandler = scheduler.performWithDelayGlobal(handler(self, self.checkShowResult), self.gameInfo.timeout - 5)
	else
		self.roleLayer.status:setString(app.lang.open_card)
		self:checkShowResult()
	end
end

function BRNNScene:dealCards(round, seat)
	round = round or 1
	seat = seat or 1

	if round == 1 and seat == 1 then
		self.gameInfo:clearCardHeapSprite()
		self.gameInfo:clearCardsSprites()
	end

	if seat > 5 then
		round = round + 1
		seat = 1
	end

	if round > 5 then
		if self.gameInfo.cardHeapSprite then
			self.gameInfo.cardHeapSprite:removeFromParent()
			self.gameInfo.cardHeapSprite = nil
		end
		return
	end

	if not self.gameInfo.cardHeapSprite then
		self.gameInfo.cardHeapSprite = display.newSprite("Image/BRNN/game_pai02.png", 500, 645):addTo(self, -1)
	end

	local card = display.newSprite("Image/BRNN/game_pai02.png", 500, 645):addTo(self, -1)
	table.insert(self.gameInfo.cardsSprites[seat], card)

	local moveAction = cca.moveTo(0.1, BRNNConfig.DealCardPosition[seat].x, BRNNConfig.DealCardPosition[seat].y)
	local rotateAction = cca.rotateTo(0.1, 180)
	transition.execute(card, cca.spawn({ moveAction, rotateAction }), {
		onComplete = function ()
			for i,v in ipairs(self.gameInfo.cardsSprites[seat]) do
				local x, y = v:getPosition()
				local dstX = x - 20
				if v ~= card then
					transition.moveTo(v, { x = dstX, time = 0.1 })
				else
					transition.moveTo(v, { x = dstX, time = 0.1, onComplete = function ()
						self:dealCards(round, seat + 1)
					end })
				end
			end
		end
	})
	self:playSounds("Sound/BRNN/send_card.mp3")
end

function BRNNScene:openCards(seat)

	local function parseCardId(cardId)
		return math.floor(cardId / 10), cardId % 10
	end

	seat = seat or 1

	if seat > 5 then
		return
	end

	self.gameInfo:clearCardHeapSprite()
	self.gameInfo:clearCardsSprites(seat)
	for round=1,5 do
		local x, y = BRNNConfig.OpenCardPosition[seat].x - (5-round-1)*40, BRNNConfig.OpenCardPosition[seat].y
		local cardId = self.gameInfo.cards[(seat-1)*5+round]
		if not cardId then
			cardId = 0
		end

		local number, suit = parseCardId(cardId)
		local card
		if number == 14 then
			if suit == 0 then
				card = display.newSprite("Image/BRNN/card/img_Card_Card4E.png", x, y):addTo(self, -1)
			else
				card = display.newSprite("Image/BRNN/card/img_Card_Card4F.png", x, y):addTo(self, -1)
			end
		elseif number == 0 then
			card = display.newSprite("Image/BRNN/card/game_pai02.png", x, y):addTo(self, -1)
		else
			card = display.newSprite("Image/BRNN/card/img_Card_BK.png", x, y):addTo(self, -1)
			local n = display.newSprite(string.format("Image/BRNN/card/img_Card_%d.png", number), 15, 65):addTo(card)
			n:setAnchorPoint(cc.p(0.5, 1))
			n:setScale(0.6)
			if suit == 0 or suit == 2 then
				n:setColor(cc.c3b(173, 14, 17))
			else
				n:setColor(cc.c3b(0, 0, 0))
			end
			local s = display.newSprite(string.format("Image/BRNN/card/img_Card_Color_%d.png", suit), 15, 5):addTo(card)
			s:setAnchorPoint(cc.p(0.5, 0))
		end
		card:setScale(1.2)
		table.insert(self.gameInfo.cardsSprites[seat], card)
	end

	local cardType = self.gameInfo.cardtypes[seat]
	if cardType and BRNNConfig.CardType[cardType] then
		local type = display.newSprite(BRNNConfig.CardType[cardType], 
			BRNNConfig.OpenCardPosition[seat].x - 50, 
			BRNNConfig.OpenCardPosition[seat].y - 70)
		:addTo(self, -1)
		table.insert(self.gameInfo.cardsSprites[seat], type)
	end

	self:playSounds("Sound/BRNN/open_card.mp3")

	self.handlers.openHandler = scheduler.performWithDelayGlobal(function ()
		self:openCards(seat + 1)
	end, 0.5)
end

function BRNNScene:showResult()

	printf("showResult:self.gameInfo.result:")
	if not self.gameInfo.result then
		return
	end

	printf("showResult:---------------")
	
	if not self.resultLayer then
		self.resultLayer = cc.uiloader:load("Layer/Game/BRNN/ResultLayer.json"):addTo(self)

		local function close()
			self.resultLayer:removeFromParent()
			self.resultLayer = nil
		end

		local background = cc.uiloader:seekNodeByNameFast(self.resultLayer, "Background")
		background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			close()
			return true
		end)
		cc.uiloader:seekNodeByNameFast(self.resultLayer, "Close"):onButtonClicked(close)

		self.resultLayer.rank = {}
		for i=1,5 do
			local rank = {}
			table.insert(self.resultLayer.rank, rank)
			table.insert(rank, cc.uiloader:seekNodeByNameFast(self.resultLayer, "Result_Rank_Name_"..i))
			table.insert(rank, cc.uiloader:seekNodeByNameFast(self.resultLayer, "Result_Rank_Gold_"..i))
		end
		self.resultLayer.playerResult = cc.uiloader:seekNodeByNameFast(self.resultLayer, "Player_Result")
		self.resultLayer.playerBet = cc.uiloader:seekNodeByNameFast(self.resultLayer, "Player_Bet")
		self.resultLayer.bankerResult = cc.uiloader:seekNodeByNameFast(self.resultLayer, "Banker_Result")

		cc.uiloader:seekNodeByNameFast(self.resultLayer, "Share")
			:onButtonClicked(function ()
				Share.createGameShareLayer():addTo(self)
			end)
			:hide()
	end

	for i=1,5 do
		local nicknameLabel = self.resultLayer.rank[i][1]
		local gainLabel = self.resultLayer.rank[i][2]
		if self.gameInfo.result.winners and self.gameInfo.result.winners[i] then
			nicknameLabel:show()
			gainLabel:show()

			nicknameLabel:setString(i .. "   " .. util.checkNickName(crypt.base64decode(self.gameInfo.result.winners[i].nickname)) or "")
			gainLabel:setString(util.toDotNum(self.gameInfo.result.winners[i].gain))
		else
			nicknameLabel:hide()
			gainLabel:hide()
		end
	end

	self.resultLayer.playerResult:setString(util.toDotNum(self.gameInfo.result.yourgain))
	self.resultLayer.playerBet:setString(util.toDotNum(self.gameInfo.result.yourbet))
	self.resultLayer.bankerResult:setString(util.toDotNum(self.gameInfo.result.bankergain))

	if checkint(self.gameInfo.result.yourgain) > 0 then
		self:playSounds("Sound/BRNN/win.mp3")
	elseif checkint(self.gameInfo.result.yourgain) < 0 then
		self:playSounds("Sound/BRNN/lose.mp3")
	end
end

function BRNNScene:checkShowResult()

	if self.params.status == 3 then

		print("status3:" .. self.params.status)
		self:showResult()
		self:updateBankerInfo()
		self:updatePlayerInfo()
	else
		print("status:" .. self.params.status)
		self.params.status = 3
	end
end

return BRNNScene