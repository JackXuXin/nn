--
-- Author: peter
-- Date: 2017-02-17 13:16:15
--

local message = require("app.net.Message")			    --通信

local SRDDZ_Message = {}

function SRDDZ_Message.dispatchGame(dealName,describe)
	print(describe)

	message.dispatchGame(dealName)
end

function SRDDZ_Message.sendMessage(dealName,data,describe)
	print(describe)

	message.sendMessage(dealName,data)
end

return SRDDZ_Message