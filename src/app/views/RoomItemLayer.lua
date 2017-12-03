
local RoomItemLayer = class("RoomItemLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

function RoomItemLayer:ctor(_,roomInfo)
	self.roomInfo = roomInfo

	self.roomNumber = cc.uiloader:seekNodeByNameFast(self, "roomNumber")
	self.seatCount = cc.uiloader:seekNodeByNameFast(self, "seatCount")
	self.round = cc.uiloader:seekNodeByNameFast(self, "round")

	self.roomNumber:setString("房间号："..roomInfo.table_code)
	self.seatCount:setString( roomInfo.playerCount.."人（共"..roomInfo.seatCount.."座）" )
	self.round:setString("局数："..roomInfo.round.."局")
end


return RoomItemLayer
