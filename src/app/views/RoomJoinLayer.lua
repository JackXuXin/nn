
local RoomJoinLayer = class("RoomJoinLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)
local privateRoomController = require("app.controllers.PrivateRoomController")

function RoomJoinLayer:ctor()
	for i=0,9 do
		local buttonName = "num_"..i
		cc.uiloader:seekNodeByName(self, buttonName):addNodeEventListener(cc.NODE_TOUCH_EVENT, self:getButtonClickFun(buttonName))
	end

	display.newRect(cc.rect(0, 0, 1280, 720),{fillColor = cc.c4f(0,0,0,0.5)}):addTo(self, -1)

	for i=1,6 do
		cc.uiloader:seekNodeByName(self, "loc_"..i):setString("")
	end

	cc.uiloader:seekNodeByName(self, "delete"):onButtonClicked(handler(self, self.delete))
	cc.uiloader:seekNodeByName(self, "rewrite"):onButtonClicked(handler(self, self.rewrite))
	cc.uiloader:seekNodeByName(self, "close"):onButtonClicked(handler(self, self.close))

	self.curLoc = 0
	self.tableCode = ""
end

function RoomJoinLayer:close(  )
	self:removeSelf()
end

function RoomJoinLayer:delete(  )
	if self.curLoc ~= 0 then
		cc.uiloader:seekNodeByName(self, "loc_"..self.curLoc):setString("")
		self.tableCode = self.tableCode:sub(1, -2)
		self.curLoc = self.curLoc - 1
	end
end

function RoomJoinLayer:rewrite(  )
	self.curLoc = 0
	self.tableCode = ""
	for i=1,6 do
		cc.uiloader:seekNodeByName(self, "loc_"..i):setString("")
	end
end

function RoomJoinLayer:getButtonClickFun( buttonName )
	return function (  )
		local _, number = string.match(buttonName, "([^_]*)_([^_]*)")
		self.curLoc = self.curLoc + 1
		cc.uiloader:seekNodeByName(self, "loc_"..self.curLoc):setString(""..number)
		self.tableCode = self.tableCode..number

		if self.curLoc == 6 then
			-- for i=1,6 do
			-- 	self.tableCode = self.tableCode..cc.uiloader:seekNodeByName(self, "loc_"..i):getString()
			-- end
			privateRoomController:enter(self.tableCode)
		end
	end
end

return RoomJoinLayer
