
local PlayerInfoInDismiss = class("PlayerInfoInDismiss", function(playerViewInGame)
    return playerViewInGame
end)

local CCSUILoader = require("src.framework.cc.uiloader.CCSUILoader")

function PlayerInfoInDismiss:ctor()
	
end

function PlayerInfoInDismiss:agree(  )
	display.newSprite("Image/ture_label.png"):addTo(self):pos(50,30)
end

function PlayerInfoInDismiss:disAgree(  )
	display.newSprite("Image/false_label.png"):addTo(self):pos(50,30)
end



return PlayerInfoInDismiss
