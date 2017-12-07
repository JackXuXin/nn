--
-- Author: peter
-- Date: 2017-04-21 14:36:18
--

local message = require("app.net.Message")			    --通信

local WRNN_Message = {}

function WRNN_Message.dispatchGame(dealName,describe,gameScene)
	print(describe)

	if "room.LeaveGame" == dealName then
		gameScene:clearScene()
	end

	message.dispatchGame(dealName)
end

function WRNN_Message.dispatchPrivateRoom(dealName,describe,gameScene)
	print(describe)

	if "room.LeaveGame" == dealName then
		gameScene:clearScene()
	end
	message.dispatchPrivateRoom(dealName)
end

function WRNN_Message.sendMessage(dealName,data,describe)
	print(describe)

	message.sendMessage(dealName,data)
end

return WRNN_Message