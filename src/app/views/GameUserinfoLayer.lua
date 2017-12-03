
local GameUserinfoLayer = class("GameUserinfoLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)
local privateRoomController = require("app.controllers.PrivateRoomController")
local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")

function GameUserinfoLayer:ctor(layerFile ,playerInfo, index)
	self.playerInfo = playerInfo
	local name = playerInfo.name
	self.layerFile = layerFile
	self.name = cc.uiloader:seekNodeByNameFast(self, "name")
	self.name:setString(name)
	self.nameOriginX,self.nameOriginY = self.name:getPosition()

	self.touyou = cc.uiloader:seekNodeByNameFast(self, "touyou")
	self.touyou:hide()

	self.owner = cc.uiloader:seekNodeByNameFast(self, "fangzhu")
	self.owner:hide()

	self.crown = cc.uiloader:seekNodeByNameFast(self, "crown")
	self.crown:hide()

	self.head = cc.uiloader:seekNodeByNameFast(self, "head")
	self:setHead(playerInfo.headimgurl)
	self.totalScore = cc.uiloader:seekNodeByNameFast(self, "totalScore")
	self.totalScore:hide()
	self.curScore = 0
	-- local nameX, nameY = self.totalScore:getPosition()
	-- self.name:pos(nameX, nameY)

	self.score = cc.uiloader:seekNodeByNameFast(self, "score")
	local totalScoreX, totalScoreY = self.score:getPosition()
	-- self.score:pos(totalScoreX, nameY)

	self.cardNum = cc.uiloader:seekNodeByNameFast(self, "zhangshukuang")
	self.cardNumSide = "right"
	self.cardNum:hide()
	-- print("hide card num")
	self.cardNumText = cc.ui.UILabel.new(
		{
			font="UIFont.fnt",
			color=cc.c3b(255,255,255),
			size=20, 
			text="0",
			align=cc.ui.TEXT_ALIGN_CENTER
		})
	local cardNumSize = self.cardNum:getContentSize()
	local cardNumTextSize = self.cardNumText:getContentSize()
    self.cardNumText:addTo(self.cardNum):pos(cardNumSize.width/2 - cardNumTextSize.width/2, cardNumSize.height/2)
    -- self.cardNumText:pos

	if index == 1 or index == 2 then
		self:symmetricPos("left")
	end
end

function GameUserinfoLayer:setHead( headimgurl )
	if headimgurl == nil then
		return 
	end
	
	local default_head = cc.uiloader:seekNodeByNameFast(self, "wenxin_head")
	app:createView("NetSprite", headimgurl, default_head:getContentSize(), function ( headImg )
		headImg:setAnchorPoint(0, 0)
      	headImg:pos(0,0)
	end):addTo(default_head)
end

function GameUserinfoLayer:symmetricPos( side )
	if self.cardNumSide == side then
		return 
	else
		local x,y = self.cardNum:getPosition()
		local scoreX, scoreY = self.totalScore:getPosition()
		self.cardNum:pos(2*scoreX - x,y)
		self.cardNumSide = side

		local touyouX, touyouY = self.touyou:getPosition()
		self.touyou:pos(2*scoreX - touyouX,touyouY)
	end
end

function GameUserinfoLayer:init(  )
	self.touyou:hide()
	self.firstOut = false
	self.score:setString("抓分：0")
	-- self:handoutFinish()
	self.curScore = 0
end

function GameUserinfoLayer:initScoreText(  )
	if tolua.isnull(self.totalScoreText) then
		local scoreSize = self.totalScore:getContentSize()
		self.totalScoreText = cc.ui.UILabel.new(
			{
				font="UIFont.fnt",
				color=cc.c3b(255,255,255),
				size=20, 
				text="",
				align=display.CENTER,
				x = scoreSize.width/2,
				y = scoreSize.height/2
			})
	   	self.totalScoreText:addTo(self.totalScore)
	   	print("init text total score")
	else
		print("init text already exist")
	end
end

-- function GameUserinfoLayer:setTotalScore( score )
-- 	local scoreSize = self.totalScore:getContentSize()
--    	self.totalScoreText:setString(""..score)
--    	self.totalScoreText:pos(scoreSize.width/2 - self.totalScoreText:getContentSize().width/2, scoreSize.height/2)
-- end

function GameUserinfoLayer:setTeam( team )
	self.team = team
	if team == "blue" then
		
		local scoreX, scoreY = self.totalScore:getPosition()
		self.totalScore:removeSelf()
		self.totalScore = display.newSprite("Image/blue_score.png") 
		self.totalScore:addTo(self):pos(scoreX, scoreY)

		self.name:pos(self.nameOriginX, self.nameOriginY)
	elseif team == "red" then
		
		local scoreX, scoreY = self.totalScore:getPosition()
		self.totalScore:removeSelf()
		self.totalScore = display.newSprite("Image/red_score.png") 
		self.totalScore:addTo(self):pos(scoreX, scoreY)

		self.name:pos(self.nameOriginX, self.nameOriginY)
	end

	self:initScoreText()
end

function GameUserinfoLayer:gameStart(  )
	-- self:initScoreText()
end


function GameUserinfoLayer:showLeastcardsNum(  )
	self.cardNum:show() 
	print("show least cards")
end

function GameUserinfoLayer:handout(  )
	self.handoutEffectSprite = display.newSprite("#"..self.team.."effect_1.png")
	local animate = require("app.controllers.ResourceController"):getAnimation(self.team.."effect", 12, 0.1)
	self.handoutEffectSprite:playAnimationForever(animate, 0.08)

	local headSize = self.head:getContentSize()
	self.handoutEffectSprite:addTo(self.head):pos(headSize.width/2, headSize.height/2 + 15)
end

function GameUserinfoLayer:addGameScore( score )
	local gameScoreString = ""
	self.curScore = self.curScore + score
	if self.curScore >= 0 then
		gameScoreString = "抓分："..self.curScore
	else
		gameScoreString = "抓分："..self.curScore
	end
	self.score:setString(gameScoreString)
	
end

function GameUserinfoLayer:setGameScore( score )
	local gameScoreString = ""
	self.curScore = score
	if self.curScore >= 0 then
		gameScoreString = "抓分："..self.curScore
	else
		gameScoreString = "抓分："..self.curScore
	end
	self.score:setString(gameScoreString)
	
end

function GameUserinfoLayer:setResultFirstOut(  )
	self:handout()
	self.crown:setVisible(true)
	cc.uiloader:seekNodeByNameFast(self, "touyou_label1"):setVisible(true)
	print("first Out")
end

function GameUserinfoLayer:outAllCards(  )
	self.cardNum:setVisible(false)
end

function GameUserinfoLayer:setResultScore( score )
	local path
	local prefix 
	if score > 0 then
		prefix = display.newSprite("Image/jiahao.png")
		path = "Image/winner_total_num.png"
	else
		prefix = display.newSprite("Image/jianhao.png")
		path = "Image/loser_total_num.png"
	end

	local label = CCSUILoader:createLabelAtlas({
        stringValue = score,
        charMapFileData = {path = path},
        itemWidth = 22,
        itemHeight = 30,
        startCharMap = 0,
        width = 22,
        height = 30,
        anchorPointX = 0.5,
        anchorPointY = 0.5,
        x = 60,
        y = 30})
    label:addTo(self)
    prefix:addTo(self):pos(30,30)
    print("set result score")
end

function GameUserinfoLayer:handoutFinish(  )
	if not tolua.isnull(self.handoutEffectSprite) then
		self.handoutEffectSprite:removeSelf()
	else
		print("self.handoutEffectSprite is nil")
	end
end

function GameUserinfoLayer:setFirstOut(  )
	self.firstOut = true
	self.touyou:setVisible(true)
	self.cardNum:hide()
	self.crown:setVisible(true)
end

function GameUserinfoLayer:resetFirstOut(  )
	self.firstOut = false
	self.touyou:setVisible(false)
	self.crown:setVisible(false)
end

function GameUserinfoLayer:addCardNum( num )
	local cardNum = tonumber(self.cardNumText:getString())
	cardNum = cardNum + num
	self:setCardNum(cardNum)
end

function GameUserinfoLayer:delCardNum( num )
	self:addCardNum(-num)
end

function GameUserinfoLayer:setCardNum( num )
	local cardNum = num
	self.cardNumText:setString(""..cardNum)
	local cardNumSize = self.cardNum:getContentSize()
	local cardNumTextSize = self.cardNumText:getContentSize()
    self.cardNumText:pos(cardNumSize.width/2 - cardNumTextSize.width/2, cardNumSize.height/2)
end

function GameUserinfoLayer:getCardNum(  )
	return tonumber(self.cardNumText:getString())
end

function GameUserinfoLayer:getTotalScore(  )
	return tonumber(self.totalScoreText:getString())
end

function GameUserinfoLayer:setTotalScore( score )
	self.totalScoreText:setString(""..score)
end

function GameUserinfoLayer:addTotalScore( score )
	if self.totalScoreText ~= nil then
		local curScore = tostring(self.totalScoreText:getString())
		curScore = curScore + score

		print("curScore = ", curScore, "score = ", score)
		self.totalScoreText:setString(""..curScore)
	end
end

function GameUserinfoLayer:copy(  )
	local cpyLayer = app:createView("GameUserinfoLayer", self.layerFile, self.playerInfo)
	cpyLayer.firstOut = self.firstOut
	cpyLayer.team = self.team
	cpyLayer.score:setVisible(false)
	local name = self.name:getString()
	cpyLayer.name:setString(name)

	return cpyLayer
end

return GameUserinfoLayer
