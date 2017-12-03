
local RoomResultLayer = class("RoomResultLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")

function RoomResultLayer:ctor(_,players)
	dump(players, "players in roomResult")
	display.newRect(cc.rect(0, 0, 1280, 720),{fillColor = cc.c4f(0,0,0,0.5)}):addTo(self, -1)
	self:showPlayers(players)

	self.quit = cc.uiloader:seekNodeByNameFast(self, "quit")
	self.quit:onButtonClicked(function (  )
		print("quit()")
		app:enterScene("LobbyScene")
	end)

	self.continue = cc.uiloader:seekNodeByNameFast(self, "continue")
	self.continue:onButtonClicked(handler(self, self.continueClicked))
end

function RoomResultLayer:continueClicked(  )
	print("on continue")
	require("app.controllers.PrivateRoomController"):againRoom()
end

function RoomResultLayer:quit(  )
	print("quit")
	app:enterScene("LobbyScene")
end

function RoomResultLayer:switchRoomAgainButton(  )
	
end

function RoomResultLayer:showPlayers( players )
	table.walk(players, function ( player, rank )
		dump(rank, "rank")
		app:createView("PlayerInfoInResult", "Layer/PlayerInfoInResult.json", player, rank)
			:addTo(self)
			:pos(rank % 2 == 0 and 650 or 185, 460 - ( math.floor((rank + 1)/2))*100 )
	end)
end




return RoomResultLayer
