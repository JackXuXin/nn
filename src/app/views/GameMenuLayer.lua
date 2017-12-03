
local GameMenuLayer = class("GameMenuLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local privateRoomController = require("app.controllers.PrivateRoomController")

function GameMenuLayer:ctor(_,start)
	if start then
		cc.uiloader:seekNodeByNameFast(self, "exit"):setVisible(false)
	else
	 	cc.uiloader:seekNodeByNameFast(self, "exit"):onButtonClicked(handler(self, self.exit))
	end
	cc.uiloader:seekNodeByNameFast(self, "rule"):onButtonClicked(handler(self, self.rule))
	cc.uiloader:seekNodeByNameFast(self, "setting"):onButtonClicked(handler(self, self.setting))
	cc.uiloader:seekNodeByNameFast(self, "dismiss"):onButtonClicked(handler(self, self.dismiss))
end

function GameMenuLayer:exit(  )
	privateRoomController:leave()
	app:enterScene("LobbyScene")
end

function GameMenuLayer:rule(  )
	self:removeSelf()
end

function GameMenuLayer:setting(  )
	self:removeSelf()
end

function GameMenuLayer:dismiss(  )
	self:getParent():showDismissRoomReq()
	self:removeSelf()
end


return GameMenuLayer
