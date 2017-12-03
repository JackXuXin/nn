
local RoomItemNode = class("RoomItemNode", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

local sdk = require("app.models.SDKInterface")

function RoomItemNode:ctor(_,roomInfo)
	self.roomInfo = roomInfo

	self.roomNumber = cc.uiloader:seekNodeByNameFast(self, "roomNumber")
	self.seatCount = cc.uiloader:seekNodeByNameFast(self, "seatCount")
	self.round = cc.uiloader:seekNodeByNameFast(self, "round")
	cc.uiloader:seekNodeByNameFast(self, "invite"):onButtonClicked(handler(self, self.invite))

	self.roomNumber:setString("房间号："..roomInfo.table_code)
	self.seatCount:setString( roomInfo.playerCount.."人（共"..roomInfo.seatCount.."座）" )
	self.round:setString("局数："..roomInfo.round.."局")
end

function RoomItemNode:invite(  )
	sdk.requestWChatFriend({
		max_player = self.roomInfo.seatCount, 
		table_code = self.roomInfo.table_code, 
		round = self.roomInfo.round,
		paymode = 2, 
		room_type = "局"})
end


return RoomItemNode
