local _6jtController = class("_6jtController", function ()
    return {}
end)

function _6jtController:register( viewHandler )
	self.viewHandler = viewHandler
	app.gateNet:registerHandler("DrawTeam", handler(self.viewHandler, self.viewHandler.drawTeam))
	app.gateNet:registerHandler("Deal", handler(self, self.deal))
	app.gateNet:registerHandler("OpenCardInfo", handler(self, self.openCardInfo))
	app.gateNet:registerHandler("Handout", handler(self, self.handoutRep))
	app.gateNet:registerHandler("GameResult", handler(self, self.GameResult))
end

function _6jtController:SceneInfo( ok, msg )
	walk(msg.players, function (_, player )
		self.viewHandler:setPlayerGameInfo(player)
	end)

	self.viewHandler:setHandcard(msg.handcards)
	self.viewHandler:setCurcard(msg.curcard)
	self.viewHandler:setTableScore(msg.tableScore)
	self.viewHandler:setCurHandout(msg.curPlayer)
	self.viewHandler:showLeastcardsNum()

	if msg.state == "internal" then
		local privateRoomController = require("app.controllers.PrivateRoomController")
		app.gateNet:call("QueryGameResult", {addr = privateRoomController.tableInfo.table_addr}, handler(self, self.GameResultCallback))
	end
end

function _6jtController:deal( msg )
	self.dealCards = msg.cards
	self.curHandout = msg.curPlayer
end

function _6jtController:openCardInfo( msg )
	self.openCardIndex = msg.index
	self.openCard = msg.card
end

function _6jtController:handoutRep( msg )
	self.viewHandler:setTableScore(msg.score)

	if msg.cards == nil or #msg.cards == 0 then
		self.viewHandler:playPassSound(msg.cards)
		self.viewHandler:passAnimation(msg.seat)
	else
		self.viewHandler:playOutcardsSound(msg.cards)
	end

	self.viewHandler:setCurcard(msg.curcard)
	self.viewHandler:handoutCard( msg.seat, msg.cards, msg.curPlayer)

	if msg.roundWinner then
		self.viewHandler:scoreBelongTo(msg.roundWinner)
	end
end

function _6jtController:handout( cards )
	local privateRoomController = require("app.controllers.PrivateRoomController")
	app.gateNet:execute("Handout", {addr = privateRoomController.tableInfo.table_addr, cards = cards})
end

function _6jtController:GameResult( msg )
	if self.viewHandler.start then
		self.viewHandler:showGameResult(msg)
	else
		self.gameResult = msg
	end
end

function _6jtController:GameResultCallback( ok, msg )
	-- msg.scores = {0,0,0,0,0,0}	-- 场景重现的时候已经加载过玩家的总分了，这里就不需要再计算了，故全部置为0
	return self.viewHandler:showGameResult(msg, true)
end

function _6jtController:queryScene(  )
	local privateRoomController = require("app.controllers.PrivateRoomController")
	app.gateNet:call("QueryGamescene", {addr = privateRoomController.tableInfo.table_addr}, handler(self, self.SceneInfo))
end

local _6jtTest = class("_6jtTest", function ()
    return {}
end)

function _6jtTest:register( viewHandler )
	self.viewHandler = viewHandler
	self:mork()
	viewHandler.gameController = self
end

function _6jtTest:mork(  )
	self.viewHandler.cards = {
		{num = 3, color = 2},{num = 3, color = 2},{num = 3, color = 2},{num = 3, color = 2},
		{num = 13, color = 2},{num = 13, color = 3},{num = 13, color = 3},{num = 13, color = 2},
		{num = 4, color = 2},{num = 4, color = 2},{num = 4, color = 2},{num = 4, color = 2},
		{num = 7, color = 2},{num = 8, color = 2},{num = 9, color = 0},{num = 10, color = 1},
		{num = 11, color = 2},{num = 12, color = 2},{num = 12, color = 2},{num = 12, color = 2},
		{num = 1, color = 0}, {num = 1, color = 2},{num = 1, color = 2},{num = 1, color = 2},
		{num = 2, color = 2},{num = 2, color = 2},{num = 2, color = 2},{num = 2, color = 2},
		{num = 5, color = 2},{num = 5, color = 2},{num = 5, color = 2},{num = 5, color = 2},
		{num = 2, color = 2},{num = 14, color = 4},{num = 15, color = 5},{num = 15, color = 5}
	}

	-- self.curcard.cards = {{num = 3, color = 2},{num = 3, color = 2}}

	-- self:setTableScore(100)
	self.viewHandler.seat = 3
	app.userInfo = {}
	app.userInfo.nickname = "test"
	self.viewHandler.privateRoomController.tableInfo = {}
	self.viewHandler.privateRoomController.tableInfo.seatid = 3
	self.viewHandler.privateRoomController.tableInfo.table_code = "111111"
	self.viewHandler.privateRoomController.tableInfo.mode = 1
	self.viewHandler.privateRoomController.tableInfo.gameround = 10
	self.viewHandler.privateRoomController.tableInfo.curround = 1

	-- self:addPlayer({name = "kingsss3", team = "blue"}, 3)
	self.viewHandler:addPlayer({name = "kingsss6", gold = 1},  6)
	self.viewHandler:addPlayer({name = "kingsss5", gold = 1}, 5)
	self.viewHandler:addPlayer({name = "kingsss4", gold = 1}, 4)
	self.viewHandler:addPlayer({name = "kingsss2", gold = 1}, 2)
	self.viewHandler:addPlayer({name = "kingsss1", gold = 1}, 1)
	self.viewHandler:addPlayer({name = "kingsss3", gold = 1}, 3)

	-- self.curHandout = 4

	self.dealCards = self.viewHandler.cards
	self.curHandout = 4
	self.openCard = {num = 1, color = 0} 
	self.openCardIndex = 8
	-- self.handcardsView = self:createCardsLayer()
end


function _6jtTest:test(  )
	local openCard = {}
	openCard.card = {num = 1, color = 3}
	openCard.player = 3
	openCard.openCardIndex = 55

	print("drawing")
	-- self.viewHandler:drawTeam({cards = {
	-- 	{color=2, num=2},{color=2, num=4},{color=2, num=5},
	-- 	{color=2, num=6},{color=2, num=12},{color=2, num=1}
	-- }, blue={2, 3, 4}, red={1, 5, 6}})
	-- self:deal(self.cards, openCard)

	-- self:setTableScore(20)
	-- self:scoreBelongTo(3)

	self.viewHandler.playerViews[1]:setTeam("red")
	self.viewHandler.playerViews[2]:setTeam("blue")
	self.viewHandler.playerViews[3]:setTeam("red")
	self.viewHandler.playerViews[4]:setTeam("blue")
	self.viewHandler.playerViews[5]:setTeam("red")
	self.viewHandler.playerViews[6]:setTeam("blue")
	self.viewHandler.playerViews[1].firstOut = true
	-- self.viewHandler:showGameResult({scores = {1,-1,1,-1,1,-1}, winnerScore = 200, loserScore = 120})

	-- self.viewHandler:showRoomResult()
	self.viewHandler:showDismissRoomRep(2)
	-- self.viewHandler:endRoomRep(1, true)
	-- self.viewHandler:endRoomRep(2, false)
end

function _6jtTest:handoutRep( msg )
	self.viewHandler:setTableScore(msg.score)
	self.viewHandler:handoutCard( msg.seat, msg.cards, msg.curPlayer)
	-- self.viewHandler:setCurcard(msg.curcard)
	if msg.roundWinner then
		self.viewHandler:scoreBelongTo(msg.roundWinner)
	end
end

function _6jtTest:handout( cards )
	self:handoutRep({score = 20, roundWinner = 1, cards = cards, curPlayer = 4, seat = 6})
	self.viewHandler:addTotalScore(1, 1)
	-- self.viewHandler:setTableScore(20)
end


if TEST_FLAG then
	return _6jtTest:new()
else
	return _6jtController:new()
end