
local GameResultLayer = class("GameResultLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")

function GameResultLayer:ctor(_,isReconnect,players,resultData)
	-- self.roomNumber = cc.uiloader:seekNodeByNameFast(self, "roomNumber")
	-- self.payType = cc.uiloader:seekNodeByNameFast(self, "payType")
	-- self.round = cc.uiloader:seekNodeByNameFast(self, "round")

	self.resultData = resultData
	self.privateRoomController = require("app.controllers.PrivateRoomController")

	self.winScore = cc.uiloader:seekNodeByNameFast(self, "winScore")
	self.loseScore = cc.uiloader:seekNodeByNameFast(self, "loseScore")
	display.newRect(cc.rect(0, 0, 1280, 720),{fillColor = cc.c4f(0,0,0,0.5)}):addTo(self, -1)
	self.isReconnect = isReconnect
	self:setRound(isReconnect and self.privateRoomController.tableInfo.curround - 1 or self.privateRoomController.tableInfo.curround)
	self:showPlayers(players)
	-- self:showValidScore()

	self.readyBtn = cc.uiloader:seekNodeByNameFast(self, "ready")
	self.readyBtn:onButtonClicked(handler(self, self.ready))
end

function GameResultLayer:ready(  )
	if not self.isReconnect then
		self.privateRoomController:endGame()
	end
	if require("app.controllers.PrivateRoomController"):isOver() then
		print("isOver")
		self:getParent():showRoomResult()
	else
		require("app.controllers.PrivateRoomController"):ready()
		self:getParent():refreshTableInfo()
	end
	self:removeSelf()
end

-- function GameResultLayer:showValidScore(  )
-- 	self.winScore:setString("得分："..self.resultData.winScore)
-- 	self.loseScore:setString("得分："..self.resultData.loseScore)
-- end

function GameResultLayer:showPlayers( players )
	local red = {}
	local blue = {}

	local redScore = 0
	local blueScore = 0
	dump(self.resultData, "data")
	table.walk(players, function ( player, index )
		player:setResultScore(self.resultData.scores[index])
		if player.firstOut then
			player:setResultFirstOut()
		end

		if player.team == "red" then
			table.insert(red, player)
			redScore = redScore + self.resultData.scores[index]
		else
			table.insert(blue, player)
			blueScore = blueScore + self.resultData.scores[index]
		end
	end)

	local winners,losers
	if redScore > blueScore then
		winners = red 
		losers = blue
	else
		winners = blue
		losers = red
	end

	table.walk(winners, function ( winner, index )
		winner:addTo(self):pos(100 + index * 120, 250)
	end)

	table.walk(losers, function ( loser, index )
		loser:addTo(self):pos(600 + index * 120, 250)
	end)
end

function GameResultLayer:setRound( round )
	local label = CCSUILoader:createLabelAtlas({
        stringValue = ""..round,
        charMapFileData = {path = "Image/round_num.png"},
        itemWidth = 48,
        itemHeight = 79,
        startCharMap = 0,
        width = 48,
        height = 79,
        anchorPointX = 0.5,
        anchorPointY = 0.5,
        x = 635,
        y = 610})
    label:addTo(self)
end



return GameResultLayer
