
local PlayerInfoInResult = class("PlayerInfoInResult", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")

function PlayerInfoInResult:ctor(_,player,rank)
	-- self.roomNumber = cc.uiloader:seekNodeByNameFast(self, "roomNumber")
	-- self.payType = cc.uiloader:seekNodeByNameFast(self, "payType")
	-- self.round = cc.uiloader:seekNodeByNameFast(self, "round")
	self.first = cc.uiloader:seekNodeByNameFast(self, "first")
	self.first:setVisible(false)
	self:setTotalScore(player.totalScore)
	self:setRank(rank)
	self.name = cc.uiloader:seekNodeByNameFast(self, "name")
	self.name:setString(player.name)
	self.id = cc.uiloader:seekNodeByNameFast(self, "id")
	self.id:setString(player.id)
end

function PlayerInfoInResult:showValidScore(  )
	self.winScore:setString("得分："..self.resultData.winnerScore)
	self.loseScore:setString("得分："..self.resultData.loserScore)
end

function PlayerInfoInResult:showPlayers( players )
	local winners = {}
	local losers = {}

	dump(self.resultData, "data")
	table.walk(players, function ( player, index )
		if self.resultData.scores[index] > 0 then
			table.insert(winners, player)
		else
			table.insert(losers, player)
		end
	end)

	table.walk(winners, function ( winner, index )
		winner:addTo(self):pos(100 + index * 120, 200)
	end)

	table.walk(losers, function ( loser, index )
		loser:addTo(self):pos(600 + index * 120, 200)
	end)
end

function PlayerInfoInResult:setRank( rank )
	if rank == 1 then
		self.first:setVisible(true)
		return
	end

	local label = CCSUILoader:createLabelAtlas({
        stringValue = ""..rank,
        charMapFileData = {path = "Image/rank_num.png"},
        itemWidth = 22,
        itemHeight = 30,
        startCharMap = 0,
        width = 22,
        height = 30,
        anchorPointX = 0.5,
        anchorPointY = 0.5,
        x = 40,
        y = 40})
    label:addTo(self)
end

function PlayerInfoInResult:setTotalScore( totalScore )
	local path
	local prefix 
	if totalScore > 0 then
		prefix = display.newSprite("Image/jiahao.png")
		path = "Image/winner_total_num.png"
	else
		prefix = display.newSprite("Image/jianhao.png")
		path = "Image/loser_total_num.png"
	end

	-- totalScore =  15
	local label = CCSUILoader:createLabelAtlas({
        stringValue = totalScore,
        charMapFileData = {path = path},
        itemWidth = 22,
        itemHeight = 30,
        startCharMap = 0,
        width = 22,
        height = 30,
        anchorPointX = 0.5,
        anchorPointY = 0.5,
        x = 350,
        y = 40})
    label:addTo(self)
    prefix:addTo(self):pos(320, 40)
end



return PlayerInfoInResult
