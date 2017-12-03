
local RoomDismissRepLayer = class("RoomDismissRepLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")  
local scheduler = require(cc.PACKAGE_NAME..".scheduler")

function RoomDismissRepLayer:ctor(_,isReconnect,players, selfSeat, reqPlayer)
	self.seat = selfSeat
	self.isReconnect = isReconnect
	self.players = players
	self.reqPlayer = reqPlayer
	self.time = 120

	self.timeNode = cc.uiloader:seekNodeByNameFast(self, "time")
	cc.uiloader:seekNodeByNameFast(self, "title"):setString("玩家 "..reqPlayer.name.." 申请解散房间")

	self.privateRoomController = require("app.controllers.PrivateRoomController")
	display.newRect(cc.rect(0, 0, 1280, 720),{fillColor = cc.c4f(0,0,0,0.5)}):addTo(self, -1)
	self:showPlayers(players)
	dump(self.players, "players in ctor")

	local agreeBtn = cc.uiloader:seekNodeByNameFast(self, "agree")
	local disAgreeBtn = cc.uiloader:seekNodeByNameFast(self, "disAgree")
	if selfSeat == reqPlayer.seat then
		self:hideButton()
	else
		agreeBtn:onButtonClicked(handler(self, self.agree))
		disAgreeBtn:onButtonClicked(handler(self, self.disAgree))
	end

	self:startTimer()

end

function RoomDismissRepLayer:hideButton(  )
	local agreeBtn = cc.uiloader:seekNodeByNameFast(self, "agree")
	local disAgreeBtn = cc.uiloader:seekNodeByNameFast(self, "disAgree")
	agreeBtn:setVisible(false)
	disAgreeBtn:setVisible(false)
end

function RoomDismissRepLayer:startTimer(  )
	self.timeNode:schedule(handler(self, self.tick), 1)
end

function RoomDismissRepLayer:tick(  )
	self.time = self.time - 1

	if self.time < 0 then
		app:enterScene("LobbyScene")
	else
		self.timeNode:setString("倒计时"..self.time.."秒")
	end
end

function RoomDismissRepLayer:agree(  )
	self.privateRoomController:endRoomRespond(self.seat, true)
	self:hideButton()
end

function RoomDismissRepLayer:disAgree(  )
	print("disagree")
	self.privateRoomController:endRoomRespond(self.seat, false)
	self:hideButton()
end

function RoomDismissRepLayer:showPlayers(players)
	local index = 1
	table.walk(players, function ( player, seat )
		player.head:setVisible(false)
		if seat ~= self.reqPlayer.seat then
			self.players[seat] = app:createView("PlayerInfoInDismiss", player)
			self.players[seat]:addTo(self):pos(295 + index * 100, 280)
			index = index + 1
		end 
	end)
end

function RoomDismissRepLayer:respond( seat, agree )
	dump(self.players, "players in respond")
	if agree then
		self.players[seat]:agree()
	else
		self.players[seat]:disAgree()
		scheduler.performWithDelayGlobal(function (  )
			self:removeSelf()
			print("removeSelf")
		end, 2)
	end
end


return RoomDismissRepLayer
