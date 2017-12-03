
local GameinfoLayer = class("GameinfoLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

function GameinfoLayer:ctor(_,param)
	self.roomNumber = cc.uiloader:seekNodeByNameFast(self, "roomNumber")
	self.payType = cc.uiloader:seekNodeByNameFast(self, "payType")
	self.round = cc.uiloader:seekNodeByNameFast(self, "round")
	self.param = param
end

function GameinfoLayer:set( param )
	self.roomNumber:setString("房间号："..param.table_code)
	if param.mode == 1 then
		self.payType:setString("支付方式：房主支付")
	elseif param.mode == 2 then
		self.payType:setString("支付方式：AA支付")
	end

	self.round:setString("局数："..param.curround.."/"..param.gameround)
end

function GameinfoLayer:refresh(  )
	local param = require("app.controllers.PrivateRoomController").tableInfo
	self.round:setString("局数："..param.curround.."/"..param.gameround)
end



return GameinfoLayer
