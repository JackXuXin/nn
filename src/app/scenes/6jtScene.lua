local TableScene = class("TableScene", function ()
    return display.newScene("TableScene")
end)

local GateNet = require("app.net.GateNet")

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")
local lg = require("app.models.lg_6jt")

function TableScene:ctor( num )
	self.scene  = cc.uiloader:load("Scene/6jtScene.json"):addTo(self)
	print("tablescene num = ", num)
end

function TableScene:onEnter(  )
	
	-- 
	self.privateRoomController = require ("app.controllers.PrivateRoomController")
	if TEST_FLAG then
		require("app.controllers.6jtController"):register(self, true)
	end
	-- self:onMork()
	self.privateRoomController:register(self)
	self:onInit()
	-- self.background:removeSelf()
	-- self.background = display.newSprite("Image/game_scene.png")
	-- self.background:addTo(self.scene, -4):pos(640,360)

	
	if TEST_FLAG then
		self.gameController:test()
	end

end

function TableScene:onInit(  )
	self.playerViews = {}
	self.players = {}
	self.curcard = {}
	self.outcardsViews = {}
	require("app.controllers.ResourceController"):loadPlist("Animation", "blueeffect")
	require("app.controllers.ResourceController"):loadPlist("Animation", "redeffect")
	require("app.controllers.ResourceController"):loadPlist("Animation", "bomb")
	require("app.controllers.ResourceController"):loadPlist("Animation", "bigBomb")
	require("app.controllers.ResourceController"):loadPlist("Animation", "sequence")
	require("app.controllers.ResourceController"):loadPlist("Animation", "singleSequence")

	self.gameController = require ("app.controllers.6jtController")
	self.gameController:register(self)
	-- self:addSelf({name = app.userInfo.nickname}, self.privateRoomController.tableInfo.seatid)
	self:setSelfSeat()
	self.privateRoomController:queryTablePlayer()


	self.sysinfo = app:createView("SysinfoLayer", "Layer/SysinfoLayer.json", {}):addTo(self)
	self.sysinfo:pos(10, 690)

	self.gameinfo = app:createView("GameinfoLayer", "Layer/GameinfoLayer.json", {}):addTo(self)
	self.gameinfo:pos(5, 600)

	self:addBtnPressFun("handout", handler(self, self.handoutBtnClicked))
	self:addBtnPressFun("pass", handler(self, self.passBtnClicked))
	self:addBtnPressFun("remind", handler(self, self.remindBtnClicked))
	self:hideButton()

	self.handoutBtn:setButtonEnabled(false)

	
	self:setGameinfo(self.privateRoomController.tableInfo)
	
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.clickTable))

	self.tableScoreTitle = cc.uiloader:seekNodeByNameFast(self.scene, "zhoumainfen")
	self.tableScoreTitle:hide()

	self.background = cc.uiloader:seekNodeByNameFast(self.scene, "game_scene")
	cc.uiloader:seekNodeByNameFast(self.scene, "menu"):onButtonClicked(handler(self, self.showMenu))
end

function TableScene:onSelfJoinTable( tablePlayers )
	self.start = false
	self.privateRoomController:ready()
	self:initTablePlayers(tablePlayers)
end

function TableScene:onReconnect( tablePlayers )
	self:initGameStartScene()
	self.gameController:queryScene()
	self.start = true
	self:initTablePlayers(tablePlayers)
end

function TableScene:initTablePlayers( tablePlayers )
	table.walk(tablePlayers, function ( playerInfo )
		self:addPlayer(playerInfo, playerInfo.seat)
	end)
end


function TableScene:showMenu(  )
	if tolua.isnull(self.menu) then
		self.menu = app:createView("GameMenuLayer", "Layer/MenuLayer.json", self.start):addTo(self, 3)
		self.menu:pos(965, 415)
	else
		self.menu:removeSelf()
		self.menu = nil
	end
end

function TableScene:initGameStartScene(  )
	-- self.tableScoreTitle:show()
	walk(self.playerViews, function ( _, playerView )
		-- playerView:initScoreText()
		playerView:showLeastcardsNum()
	end)
end

function TableScene:onJoin( player, seat )
	self:addPlayer(player, seat)
end


function TableScene:scoreBelongTo( player )
	if self.tableScore then
		local curScore = tostring(self.tableScore:getString())
		self:setTableScore(0)
		print("curScore = ", curScore)
		self.playerViews[player]:addGameScore(curScore)
	end
end

function TableScene:setPlayerGameInfo( playerGameInfo )
	local seat = playerGameInfo.seat

	self.playerViews[seat]:addGameScore(playerGameInfo.score)
	self.playerViews[seat]:setCardNum(playerGameInfo.leastCardNum)
	self.playerViews[seat]:setTeam(seat % 2 == 0 and "blue" or "red")
	self.playerViews[seat]:setTotalScore(self.privateRoomController:getPlayer(seat).gold)
	self:setOutcards(seat, playerGameInfo.outcards, true)
	if playerGameInfo.isFirst then
		self.playerViews[seat]:setFirstOut()
	end
end

function TableScene:addTotalScore( seat, score )
	self.playerViews[seat]:addTotalScore(score)
end

function TableScene:clickTable( event )
	if event.name == "began" and self.handcardsView then
		self.handcardsView:resetSelect()
		if self.menu then
			self.menu:removeSelf()
			self.menu = nil
		end
	elseif event.name == "ended" then
		print("ended out")
	end

	return true
end

function TableScene:createCardsLayer( cards )
	if cards == nil then
		cards = {}
	end
	local cardsLayer = app:createView("CardLayer", cards, true):addTo(self)
	if #cards < 18 and #cards ~= 0 then
		local handcardsViewWidth = cardsLayer:getWidth()
		cardsLayer:setAnchorPoint(0.5,0.5)
		cardsLayer:pos(125 - (640 - handcardsViewWidth)/2, display.height - 638)
	else
		cardsLayer:pos(255,display.height - 638)
	end
	return cardsLayer
end

function TableScene:addBtnPressFun( buttonName, handler )
	local btn = cc.uiloader:seekNodeByNameFast(self.scene, buttonName)

	btn:addNodeEventListener(cc.NODE_TOUCH_EVENT, self:getButtonPressFun(btn))
	btn:onButtonClicked(handler)
	self[buttonName.."Btn"] = btn
	btn:zorder(100)
end

local headPos = {}
headPos[0] = {15, 20}
headPos[1] = {1157, 259}
headPos[2] = {1157, 441}
headPos[3] = {489, 542}
headPos[4] = {15, 441}
headPos[5] = {15, 259}

function TableScene:getSeatPosIndex( seat )
	local posIndex = seat - self.seat 
	posIndex = posIndex < 0 and (posIndex + 6) or posIndex
	return posIndex
end

function TableScene:addPlayer( playerInfo, seat )
	dump(playerInfo, "add plrayer")
	local playerView = app:createView("GameUserinfoLayer", "Layer/PlayerinfoLayer.json", playerInfo, self:getSeatPosIndex(seat)):addTo(self)
	local posIndex = self:getSeatPosIndex(seat)
	local x,y = headPos[posIndex][1], headPos[posIndex][2]
	playerView:pos(x, y)
	self.playerViews[seat] = playerView
	self.players[seat] = playerInfo
	playerView:addTotalScore(playerInfo.gold)

	-- print("add players")
end

function TableScene:playerRecconect( seat )
	print("reconnect", seat)
end

function TableScene:playerDisconnect( seat )
	print("disconnect", seat)
end

function TableScene:showDismissRoomReq(  )
	app:createView("RoomDismissReqLayer", "Layer/DismissRoomReqLayer.json"):addTo(self)
end

function TableScene:showDismissRoomRep( reqSeat )
	local playerCpys = {}
	table.walk(self.playerViews, function ( playerView, index )
		-- if reqSeat ~= index then
			table.insert(playerCpys, playerView:copy())
		-- end
	end)
	print("showDismissRoomRep = ", self.seat)
	self.dismissRep = app:createView(
		"RoomDismissRepLayer", 
		"Layer/DismissRoomRepLayer.json", 
		false, playerCpys, self.seat, self.players[reqSeat]):addTo(self)
end

function TableScene:endRoomRep( seat, agree )
	self.dismissRep:respond(seat, agree)
end

function TableScene:delPlayer( seat )
	if self.playerViews[seat] and not self.start then
		self.playerViews[seat]:removeSelf()
		self.playerViews[seat] = nil
		self.players[seat] = nil
	elseif self.start then
		print("game already start, not del player")
	else
		printf("del seat %d is empty", seat)
	end
end

-- function TableScene:addSelf( playerInfo, seat )
-- 	self.seat = seat 
-- 	self:addPlayer(playerInfo, seat)
-- end

function TableScene:setSelfSeat(  )
	self.seat = self.privateRoomController.tableInfo.seatid
	print("setSelfSeat = ", self.seat)
end

function TableScene:getButtonPressFun( button )
	return function ( event )
		if event.name == "began" then  
        	button:setScale(0.9)  
        elseif event.name == "moved" then  
           -- sprite:setPosition(cc.p(x,y))               
        elseif event.name == "ended" then  
            button:setScale(1)    
        end  
          
    	return true  
	end
end

function TableScene:setTableScore( score )
	if not self.tableScore then
		self.tableScore = CCSUILoader:createLabelAtlas({
	        stringValue = ""..score,
	        charMapFileData = {path = "Image/fen.png"},
	        itemWidth = 23,
	        itemHeight = 30,
	        startCharMap = 0,
	        width = 23,
	        height = 30,
	        anchorPointX = 0.5,
	        anchorPointY = 0.5,
	        x = 690,
	        y = 390})
    	self.tableScore:addTo(self)
    end

	if score > 0 then
		self.tableScoreTitle:setVisible(true)
		self.tableScore:setVisible(true)
	    self.tableScore:setString(""..score)
	else
		if self.tableScore then
			self.tableScore:setVisible(false)
		end
		self.tableScoreTitle:setVisible(false)
		self.tableScore:setString("0")
	end

end

function TableScene:setGameinfo( gameInfo )
	self.gameinfo:set(gameInfo)
end

function TableScene:addPlayers( ok, msg )
	-- dump(msg, "players in table")
end

function TableScene:hideButton(  )
	self.handoutBtn:hide()
	self.passBtn:hide()
	self.remindBtn:hide() 
end

function TableScene:showButton(  )
	self.handoutBtn:show()
	self:onSelectCardFinish(self.handcardsView:getSelectedCards())
	-- self.handoutBtn:setButtonEnabled(false)
	self.passBtn:show()
	self.remindBtn:show()
	if self.curcard.cards == nil then
		self.passBtn:setButtonEnabled(false)
	else
		self.passBtn:setButtonEnabled(true)
	end

	print("button zorder = ", self.passBtn:getGlobalZOrder())
end

function TableScene:deleteHandcard( cardsDelete )
	local cards = self.handcardsView:deleteCards(cardsDelete)
	if cards == nil or #cards == 0  then
		return
	end
	self.handcardsView:removeSelf()
	self.handcardsView = self:createCardsLayer(cards)

	if #cards < 18 then
		local handcardsViewWidth = self.handcardsView:getWidth()
		self.handcardsView:setAnchorPoint(0.5,0.5)
		local x,y = self.handcardsView:getPosition()
		print(x,y, handcardsViewWidth)
		self.handcardsView:pos(125 - (640 - handcardsViewWidth)/2, y)
	end
end

function TableScene:handoutBtnClicked(  )
	local selectedCards = self.handoutcards
	dump(selectedCards, "selectedCards")

	self:hideButton()
	self.gameController:handout(selectedCards)
	
	self.remindResult = nil
end

function TableScene:onSelectCardFinish( selectCards )
	 local remindResult 

	 dump(self.curcard, "onSelectFinish")
	 if self.curcard.cards == nil then
	 	remindResult = lg.getCardTypeForClient(selectCards)
	 else
		remindResult = lg.remind(self.curcard.cards, selectCards)
	end

	 local canAllHandout = exist(remindResult, function ( handoutCards )
	 	return #handoutCards == #selectCards
	 end)

	 if #remindResult ~= 0 and canAllHandout then
	 	self.handoutcards = remindResult[canAllHandout]
	 	self.handoutBtn:setButtonEnabled(true)
	 else
	 	self.handoutBtn:setButtonEnabled(false)
	 end
	 	
end

function TableScene:passBtnClicked(  )
	-- self:multiRemind()
	self.gameController:handout({})
	self:hideButton()
	self.handcardsView:resetSelect()

	self.remindResult = nil
end

function TableScene:setHandcard( cards )
	cards = lg.sort(cards)
	self.handcardsView = self:createCardsLayer(cards)
	self.playerViews[self.seat]:setCardNum(#cards)
end

function TableScene:getRemindResult(  )
	return lg.remind(self.curcard.cards, self.handcardsView.cards) 
end

function TableScene:remindBtnClicked(  )
	if self.remindResult == nil then
		self.remindResult = self:getRemindResult()
		if #self.remindResult == 0 then
			self:passBtnClicked()
			return
		end
		self.curRemindIndex = 1
	end

	self.handcardsView:resetSelect()
	self.handcardsView:selectCards(self.remindResult[self.curRemindIndex])
	self.handoutcards = self.remindResult[self.curRemindIndex]
	self.curRemindIndex = self.curRemindIndex + 1
	if self.curRemindIndex > #self.remindResult then
		self.curRemindIndex = 1
	end

	self.handoutBtn:setButtonEnabled(true)
	-- self.handcardsView:selectCards({{num = 3, color = 2},{num = 3, color = 2}})
end

function TableScene:multiRemind( remindCards )
	local sprite = display.newSprite()
	sprite:addTo(self):pos(display.width/2, 297)
	local y = 0
	table.walk(remindCards, function ( cards )
		local remindCardsLayer = app:createView("CardLayer", cards):addTo(sprite):pos(0,y)
		remindCardsLayer:scale(0.6)
		y = y + 80
		remindCardsLayer:setTouchEnabled(true)
		remindCardsLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
			remindCardsLayer:scale(1.0)

			local outCards = app:createView("CardLayer", remindCardsLayer.cards):addTo(self)
			local outCardsWidth = outCards:getWidth()
			dump(outCardsWidth, "outCardsWidth")
			outCards:pos(display.width/2 - outCardsWidth/2, 297)
			self:hideButton()
			local cards = self.handcardsView:getLeastCards()
			self.handcardsView:removeSelf()
			self.handcardsView = self:createCardsLayer(cards)
		end)
	end)
end

local handoutCardPos = {}
handoutCardPos[0] = {640, 297}
handoutCardPos[1] = {1004.5, 337}
handoutCardPos[2] = {1004.5, 518}
handoutCardPos[3] = {706, 627}
handoutCardPos[4] = {225.5, 518}
handoutCardPos[5] = {225.5, 337}

function TableScene:handoutCard( seat, cards, curPlayer )
	self.playerViews[seat]:delCardNum(#cards)
	self:setOutcards(seat, cards)
	if seat == self.seat then
		self:deleteHandcard(cards)
	end

	print("seat = ", seat)
	self:delBetweenOutcards(seat, curPlayer)

	if self.outcardsViews[seat] then
		
		local cardNum = self.playerViews[seat]:getCardNum()
		if cardNum < 3 then
			self:playWarmingSound(cardNum)
		end

		if self.playerViews[seat]:getCardNum() == 0 then
			self.playerViews[seat]:outAllCards()
			if self.lastOut == nil then
				self.playerViews[seat]:setFirstOut()
			end
			self.lastOut = seat
		end
	end

	self.playerViews[seat]:handoutFinish()
	self:setCurHandout(curPlayer)
end

function TableScene:playWarmingSound( cardNum )
	audio.playSound("Sound/Woman_baojing"..cardNum..".mp3")
end

function TableScene:delBetweenOutcards( seat, curPlayer )
	local nextSeat = modeRingNum(6, seat + 1)
	while nextSeat ~= curPlayer do
		if self.outcardsViews[nextSeat] then
			self.outcardsViews[nextSeat]:removeSelf()
			self.outcardsViews[nextSeat] = nil
		end
		nextSeat = modeRingNum(6, nextSeat + 1)
	end
end

function TableScene:setCurHandout( curPlayer )
	self.curHandout = curPlayer

	self.playerViews[curPlayer]:handout()

	if self.outcardsViews[curPlayer] then
		self.outcardsViews[curPlayer]:removeSelf()
		self.outcardsViews[curPlayer] = nil
	end

	if self.seat == self.curHandout then
		self:showButton()
	end
end

function TableScene:needSpecialAnimation( cards )
	local cardType = lg.getCardType(cards)
	return exist({"fly", "doubleSequence", "tribleSequence", "tribleAndDouble", "bomb", "singleSequence"}, function ( needSpecialShowType )
		return needSpecialShowType == cardType
	end)
end

local specialShowName = {}
specialShowName["fly"] = {name = "sequence", size = 27}
specialShowName["doubleSequence"] = {name = "sequence", size = 27}
specialShowName["tribleSequence"] = {name = "sequence", size = 27}
specialShowName["tribleAndDouble"] = {name = "sequence", size = 27}
specialShowName["singleSequence"] = {name = "singleSequence", size = 34}
specialShowName["bomb"] = {name = "bomb", size = 6}
specialShowName["bigBomb"] = {name = "bigBomb", size = 6}


function TableScene:specialAnimation( cards, outcardsView )
	local spcialShowType = lg.getCardType(cards)
	local cardWidth = 122

	local animate 
	local specialSprite
	local specialAnimationName 
	if spcialShowType == "bomb" then
		if lg.getBombSize(cards) > 6 then
			specialAnimationName = "bigBomb"
		else
			specialAnimationName = "bomb"
		end
	else
		specialAnimationName = spcialShowType
	end

	local specialAnimation = specialShowName[specialAnimationName]
	local animate = require("app.controllers.ResourceController"):getAnimation(specialAnimation.name, specialAnimation.size, 0.1)
	local specialSprite = display.newSprite("#"..specialAnimation.name.."_1.png")
	specialSprite:playAnimationOnce(animate, true)
	specialSprite:addTo(outcardsView)

	local outCardsWidth = outcardsView:getWidth()
	specialSprite:pos(outCardsWidth/2 - cardWidth/2 , 0)
	-- specialSprite:pos(0 , 0)
end

function TableScene:passAnimation( seat )
	local spcialShowType = lg.getCardType(cards)
	local specialShowSprite = display.newSprite("Image/buyao_tishi.png")

	local posIndex = self:getSeatPosIndex(seat)
	specialShowSprite:addTo(self.scene):pos(handoutCardPos[posIndex][1], handoutCardPos[posIndex][2])
	local seq = transition.sequence({
		cc.MoveBy:create(0.5, cc.p(0,20)),
		cc.MoveBy:create(0.5, cc.p(0, -20))})
	transition.execute(specialShowSprite, seq,{delay = 0, onComplete = handler(specialShowSprite, specialShowSprite.removeSelf)})
end

function TableScene:setOutcards( seat, cards, reScene )
	if self.outcardsViews[seat] and seat ~= self.seat then
		self.outcardsViews[seat]:removeSelf()
		self.outcardsViews[seat] = nil
	end

	if cards ~= nil and #cards > 0 then
		local posIndex = self:getSeatPosIndex(seat)
		local outcardsView = app:createView("CardLayer", cards):addTo(self.scene)
		-- outcardsView:zorder(-1)
		local x,y = handoutCardPos[posIndex][1], handoutCardPos[posIndex][2]
		local cardWidth = 122
		print("width = ",outcardsView:getWidth())
		if posIndex == 1 or posIndex == 2 then
			x = x - outcardsView:getWidth() + cardWidth
		elseif posIndex == 0 then
			x = x - outcardsView:getWidth()/2 + cardWidth/2
		end
		print("outcardsView pos = ",x,y)
		outcardsView:pos(x, y)
		self.outcardsViews[seat] = outcardsView
		
		print("outcardsView zorder = ", outcardsView:getGlobalZOrder())
		-- outcardsView:setGlobalZOrder(100)

		if not reScene then
			if self:needSpecialAnimation(cards) then
				self:specialAnimation(cards, outcardsView)
			end

		end
	else
		if not reScene then
			
		end
	end
end

function TableScene:playPassSound(  )
	local passSoundIndex = math.random(1,3)
	audio.playSound("Sound/Woman_buyao"..passSoundIndex..".mp3")
	print("Sound/Woman_buyao"..passSoundIndex..".mp3")
end

local specialShowSound = {}
-- specialShowSound["doubleSequence"] = "Sound/Woman_shunzi.mp3"
-- specialShowSound["tribleSequence"] = "Sound/Woman_shunzi.mp3"
specialShowSound["singleSequence"] = "Sound/Woman_shunzi.mp3"
specialShowSound["bomb"] = "Sound/Woman_zhadan.mp3"
specialShowSound["tribleAndDouble"] = "Sound/Woman_sandaiyidui.mp3"
-- specialShowSound["fly"] = "Sound/Woman_sandaiyidui.mp3"

local nomalSound = {}
nomalSound["single"] = "Sound/Woman_"
nomalSound["double"] = "Sound/Woman_dui"
nomalSound["trible"] = "Sound/Woman_tuple"

function TableScene:getSoundFileByCards( cards )
	local cardType = lg.getCardType(cards)
	print(cardType)
	if specialShowSound[cardType] then
		return specialShowSound[cardType]
	else
		if nomalSound[cardType] then
			return nomalSound[cardType]..cards[1].num..".mp3"
		else
			return nil
		end
	end
end

function TableScene:playOutcardsSound( cards )
	local soundIndex = math.random(1,4)
	local cardType = lg.getCardType(cards)
	dump(self.curcard, "curcard in sound")
	if soundIndex == 4 or cardType == "bomb" or self.curcard.cards == nil  then
		local soundFile = self:getSoundFileByCards(cards)
		if soundFile ~= nil then
			audio.playSound(soundFile)
		end
	else
		audio.playSound("Sound/Woman_dani"..soundIndex..".mp3")
	end

	if lg.getCardType(cards) ~= "bomb" then
		audio.playSound("Sound/Special_give.mp3")
	else
		audio.playSound("Sound/Special_Bomb.mp3")
	end
end

function TableScene:setCurcard( curcard )
	self.curcard = curcard
	dump(self.curcard, "setCurcard")
end

function TableScene:setHandout( seat )
	print("curHandout = ", self.curHandout)
	self.playerViews[self.curHandout]:handout()
	if self.seat == seat then
		self:showButton()
	end
end

function TableScene:createUpcardsBeforeTeam( teamCards )
	assert(#teamCards == 6, "teamCards len not 6")

	local cardsTmp = {}
	local cardIndexs = {}
	local i = 0
	while i == 6 do
		local randomNum = math.random(1,56)
		if not cardIndexs[randomNum] then
			cardIndexs[randomNum] = true
			i = i + 1
		end
	end

	local teamCardIndex = 1
	for i=1,56 do
		local backCard
		if cardIndexs[i] then
			backCard = app:createView("Card", teamCards[teamCardIndex])
			teamCardIndex = teamCardIndex + 1
		else
			backCard = display.newSprite("Image/card/up_card.png")
		end

		if openIndex and i > openIndex then
			backCard:addTo(self):pos( (i - 1 + teamCardIndex - 1)*12 + 288.5, 395)
		else
			backCard:addTo(self):pos((i - 1)*12 + 288.5, 395)
		end
		table.insert(cardsTmp, backCard)
	end

	return cardsTmp
end

function TableScene:createUpcards( num, openCard )
	local cardsTmp = {}

	local openIndex
	if openCard then
		openIndex = openCard.index
	end

	for i=1,num do
		local backCard
		if openIndex == i then
			backCard = app:createView("Card", openCard.card)
			openCard.upCard = backCard
		else
			backCard = display.newSprite("Image/card/up_card.png")
		end

		if openIndex and i > openIndex then
			backCard:addTo(self):pos(i*12 + 288.5, 395)
		else
			backCard:addTo(self):pos((i - 1)*12 + 288.5, 395)
		end
		table.insert(cardsTmp, backCard)
	end

	return cardsTmp
end

function TableScene:removeAllUpcards( upCards )
	table.walk(upCards, function ( card )
		card:removeSelf()
	end)
end

function TableScene:drawTeamCardAnimation( cardInfo, cardsTmp, seatOffset )
	if seatOffset > 5 then
		return
	end

	local cardIndex = math.random(1, #cardsTmp)
	local action = cc.MoveTo:create(0.5, cc.p(handoutCardPos[seatOffset][1], handoutCardPos[seatOffset][2]))
	seq = transition.sequence({action})
	local selectedTeamCard = cardsTmp[cardIndex]
	table.remove(cardsTmp, cardIndex)
	transition.execute(selectedTeamCard, seq,{delay = 0, onComplete = function ( card )
		local x,y = card:getPosition()
		local seatid = self.seat + seatOffset 
		seatid = seatid > 6 and seatid - 6 or seatid
		local teamCard = app:createView("Card", cardInfo.cards[seatid]):addTo(self)
		teamCard:pos(x,y)
		-- dump(self.players, "player "..seatid)
		self.players[seatid].teamCard = teamCard

		card:removeSelf()
		
		self:drawTeamCardAnimation(cardInfo, cardsTmp, seatOffset + 1)

		if seatOffset == 5 then
			self:removeAllUpcards(cardsTmp)
			self:movePlayerByTeamCards(cardInfo, cardsTmp)
		end
	end})
end

function TableScene:drawTeam( cardInfo )
	local cardsTmp = self:createUpcards(56)
	self:drawTeamCardAnimation(cardInfo, cardsTmp, 0)

end

function TableScene:movePlayerByTeamCards( cardInfo, upCards )
	local playerViewsTmp = {}
	local playersTmp = {}
	local newSelfSeat
	table.walk(cardInfo.red, function ( seat, index )
		local originSeat = seat 
		local newSeat = index*2 - 1

		playerViewsTmp[newSeat] = self.playerViews[originSeat]
		self.playerViews[originSeat]:setTeam("red")
		self.playerViews[originSeat]:setTotalScore(self.players[originSeat].gold)
		playersTmp[newSeat] = self.players[originSeat]
		if originSeat == self.seat and not newSelfSeat then
			newSelfSeat = newSeat
			self.seat = newSelfSeat
		end
	end)

	table.walk(cardInfo.blue, function ( seat, index )
		local originSeat = seat 
		local newSeat = index*2

		playerViewsTmp[newSeat] = self.playerViews[originSeat]
		self.playerViews[originSeat]:setTeam("blue")
		self.playerViews[originSeat]:setTotalScore(self.players[originSeat].gold)
		playersTmp[newSeat] = self.players[originSeat]
		if originSeat == self.seat and not newSelfSeat then
			newSelfSeat = newSeat
			self.seat = newSelfSeat
		end
	end)
	self.players = playersTmp
	self.playerViews = playerViewsTmp
	if newSelfSeat then
		self.seat = newSelfSeat
	end

	local moveFinishCount = 0
	table.walk(self.playerViews, function ( playerView, index )
		local posIndex = index - self.seat
		posIndex = posIndex < 0 and (posIndex + 6) or posIndex
		local playerMoveAction = cc.MoveTo:create(2, cc.p(headPos[posIndex][1], headPos[posIndex][2]))
		local playerMoveSeq = transition.sequence({playerMoveAction})
		transition.execute(playerView, playerMoveSeq)

		local teamCardMoveAction = cc.MoveTo:create(2, cc.p(handoutCardPos[posIndex][1], handoutCardPos[posIndex][2]))
		local teamCardMoveSeq = transition.sequence({teamCardMoveAction})
		transition.execute(self.players[index].teamCard, teamCardMoveSeq, {onComplete = function ( teamCard )
			teamCard:removeSelf()
			moveFinishCount = moveFinishCount + 1
			if moveFinishCount == 6 then
				if self.gameController.openCardIndex then
					local selfCards = self.gameController.dealCards

					-- table.sort(selfCards, function ( a, b )
					-- 	if a.num ~= b.num then
					-- 		local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
					-- 		return cardcomparetable[a.num] < cardcomparetable[b.num]
					-- 	else
					-- 		return a.color < b.color 
					-- 	end
					-- end)

					self.curHandout = self.gameController.curHandout
					dump(self.gameController.openCard, "openCard "..self.gameController.openCardIndex)
					self:removeOpenCardFromHandcard(selfCards, self.gameController.openCard)

					self:deal(selfCards, {card = self.gameController.openCard, index = self.gameController.openCardIndex})
					self:symmetricLeastcardPos()
				end
			end
		end})
	end)
end

function TableScene:removeOpenCardFromHandcard( selfCards, openCard )
	if self.seat == self.curHandout then
		local index = exist(selfCards, function ( dealCard )
			return dealCard.num == openCard.num and dealCard.color == openCard.color
		end)
		table.remove(selfCards, index)
	end
end

function TableScene:symmetricLeastcardPos( )
	print("self.seat = ", self.seat)
	table.walk(self.playerViews, function ( player, seat )
		local pos = self:getSeatPosIndex(seat)
		if pos == 1 or pos == 2 then
			player:symmetricPos("left")
		else
			player:symmetricPos("right")
		end
	end)
end


function TableScene:setPlayers( playersInfo )
	
end

function TableScene:showLeastcardsNum(  )
	table.walk(self.playerViews, function ( playerView )
		playerView:showLeastcardsNum()
	end)
end

function TableScene:deal( cards, openCardInfo  )
	local upCards = self:createUpcards(54, openCardInfo)

	self.dispatchAudioHandle = audio.playSound("Sound/Special_Dispatch.mp3", true)
	self.handcardsView = self:createCardsLayer({})
	self:dealAnimation(0, upCards, cards, openCardInfo)

	self:showLeastcardsNum()
end

function TableScene:onUpcardMoveComplete( upCard )
	if self.seat == self.curHandout then
		self.handcardsView:insertCard(upCard)
	end
	upCard:removeSelf()
	self:zeroScore()
	self.tableScoreTitle:show()

	if self.gameController.gameResult then
		self:showGameResult(self.gameController.gameResult)
	else
		self:startGame()
	end

	self.handcardsView:sort()
end

function TableScene:endGame(  )
	self.handcardsView:removeSelf()
	table.walk(self.playerViews, function ( playerView )
		playerView:setCardNum(0)
		playerView:handoutFinish()
		playerView:resetFirstOut()
		playerView:setGameScore(0)
	end)

	self.start = false
	self.tableScoreTitle:setVisible(false)
	self:hideButton()
end

function TableScene:moveUpcardToPlayer( openCardInfo )
	dump(openCardInfo, "openCardInfo")
	local posIndex = self.curHandout - self.seat
	posIndex = posIndex < 0 and (6 + posIndex) or posIndex

	if self.curHandout ~= self.seat then
		local headSize = self.playerViews[1]:getContentSize()
		local upCardMoveAction = cc.MoveTo:create(1, cc.p(headPos[posIndex][1] + headSize.width/2, headPos[posIndex][2] + headSize.height/2))
		local upCardMoveSeq = transition.sequence({upCardMoveAction})
		return transition.execute(openCardInfo.upCard, upCardMoveSeq, {onComplete = handler(self, self.onUpcardMoveComplete)})
	else
		local handcardX, handcardY = self.handcardsView:getPosition()
		local innerX, innerY = self.handcardsView:getCardLocationByValue(openCardInfo.card)
		-- print("inner = ",innerX, innerY)
		local upCardMoveAction = cc.MoveTo:create(1, cc.p(handcardX + innerX, handcardY + innerY))
		local upCardMoveSeq = transition.sequence({upCardMoveAction})
		return transition.execute(openCardInfo.upCard, upCardMoveSeq, {onComplete = handler(self, self.onUpcardMoveComplete)})
	end
end

function TableScene:refreshTableInfo(  )
	self.gameinfo:refresh()
	table.walk(self.playerViews, function ( playerView )
		playerView:init()
	end)

	table.walk(self.outcardsViews, function ( outcardsView, index )
		outcardsView:removeSelf()
		self.outcardsView[index] = nil
	end)
	
	self.tableScoreTitle:setVisible(false)
end

function TableScene:startGame(  )
	self.start = true

	self.curcard = {}
	table.walk(self.playerViews, function ( playerView )
		playerView:showLeastcardsNum()
	end)
	self:setHandout(self.curHandout)

	self.lastOut = nil
end

function TableScene:dealAnimation( index,upCards,cards, openCardInfo )
	if index == 36 then
		audio.stopSound(self.dispatchAudioHandle)
		return self:moveUpcardToPlayer(openCardInfo)
	end

	local finishCount = 1
	for i=0,5 do
		local desPos 
		if i == 0 then
			local innerX, innerY = self.handcardsView:getCurDealcardPos()
			local handcardsX, handcardsY = self.handcardsView:getPosition()
			desPos = cc.p(handcardsX + innerX, handcardsY + innerY)
		else
			desPos = cc.p(handoutCardPos[i][1], handoutCardPos[i][2] )
		end
		self.playerViews[ (i + self.seat > 6) and (self.seat + i - 6) or (self.seat + i)]:addCardNum(1)

		local upCard
		-- print(#upCards, openCardInfo.index)
		if (self.seat + i)%6 == self.curHandout%6 and 
			(openCardInfo.index and (#upCards == openCardInfo.index or #upCards - 1 == openCardInfo.index))  then
			upCard = app:createView("Card", openCardInfo.card)
			upCard.openCard = true
			openCardInfo.upCard = upCard 
			openCardInfo.index = nil
			print("openCard")
			if self.seat == self.curHandout then
				desPos = cc.p(handoutCardPos[0][1], handoutCardPos[0][2])
				dump(desPos, "self upcard pos")
			end
		else
			upCard = display.newSprite("Image/card/up_card.png")
		end
		upCard:addTo(self):pos(upCards[#upCards]:getPosition())

		local cardMoveAction = cc.MoveTo:create(0.1, desPos)
		local cardMoveSeq = transition.sequence({cardMoveAction})

		transition.execute(upCard, cardMoveSeq, {delay = 0.05 * i,onComplete = function ( dealCard )
			if not dealCard.openCard then
				dealCard:removeSelf()
			end

			if i == 0 and cards[index + 1] then
				self.handcardsView:addCard(cards[index + 1])
			end

			finishCount = finishCount + 1
			if finishCount == 6 then
				upCards[#upCards]:removeSelf()
				table.remove(upCards)
				if index % 2 == 0 then
					upCards[#upCards]:removeSelf()
					table.remove(upCards)
				end

				self:dealAnimation(index + 1, upCards, cards, openCardInfo)
			end
		end})
	end
end

function TableScene:addScore( score )
	local curScorer = tonumber(self.tableScore:getString())
	self:setTableScore(curScorer + score)
end

function TableScene:zeroScore(  )
	self:setTableScore(0)
end

function TableScene:setGameScore( seat, score )
	self.playerViews[seat]:setGameScore(score)
end

function TableScene:showGameResult( gameResultData, isReconnect )
	if not isReconnect then
		table.walk(gameResultData.scores, function ( score, seat )
			self:addTotalScore(seat, score)
			self.players[seat].gold = self.players[seat].gold + score
			-- self:setGameScore(seat,gameResultData.inScores[seat])
		end)
	end

	local playersCpy = {}
	table.walk(self.playerViews, function ( player, seat )
		table.insert(playersCpy, player:copy())
	end)

	app:createView(
		"GameResultLayer", 
		"Layer/GameResultLayer.json", 
		isReconnect, 
		playersCpy, gameResultData):addTo(self)

	if not isReconnect then
		self:endGame()
	end

	self.gameController.gameResult = nil

end

function TableScene:showRoomResult(  )
	local playerViewsCpy = {}
	table.walk(self.playerViews, function ( playerView )
		local cpy = playerView:copy()
		cpy.totalScore = playerView:getTotalScore()
		table.insert(playerViewsCpy, cpy)
	end)

	dump(playerViewsCpy, "players in showRoomResult 1")
	table.sort(playerViewsCpy, function ( player1, player2 )
		return player1.totalScore > player2.totalScore
	end)


	dump(playerViewsCpy, "players in showRoomResult 2")
	table.map(playerViewsCpy, function ( playerView )
		playerView.name = playerView.name:getString()
		return playerView
	end)

	dump(playerViewsCpy, "players in showRoomResult 3")
	self.roomResultLayer = app:createView("RoomResultLayer", "Layer/RoomResultLayer.json", playerViewsCpy):addTo(self)
end

function TableScene:againRoomSuccess(  )
	self.roomResultLayer:removeSelf()
	self.privateRoomController:ready()
	table.walk(self.playerViews, function ( playerView )
		playerView:setTotalScore(0)
	end)

	table.walk(self.players, function ( player )
		player.gold = 0
	end)

	self.privateRoomController:zeroRound()
end

function TableScene:roomFeeHasPayed(  )
	if not tolua.isnull(self.roomResultLayer) then
		self.roomResultLayer:switchRoomAgainButton()
	else
		self.canAgain = true
	end 
end


return TableScene