
local RoomDismissReqLayer = class("RoomDismissReqLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")

function RoomDismissReqLayer:ctor(_,isReconnect,players)
	display.newRect(cc.rect(0, 0, 1280, 720),{fillColor = cc.c4f(0,0,0,0.5)}):addTo(self, -1)
	cc.uiloader:seekNodeByNameFast(self, "yes"):onButtonClicked(handler(self, self.yes))
	self.privateRoomController = require("app.controllers.PrivateRoomController")
end

function RoomDismissReqLayer:yes(  )
	self.privateRoomController:dismissRequest()
	self:removeSelf()
end

function RoomDismissReqLayer:respond( seat, agree )
	if agree then
		self.players[seat]:agree()
	else
		self.players[seat]:disAgree()
	end
end




return RoomDismissReqLayer
