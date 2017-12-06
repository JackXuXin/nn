--
-- Author: peter
-- Date: 2017-03-10 20:14:03
--

local message = require("app.net.Message")			    --通信

local WL_Message = {}

function WL_Message.dispatchGame(dealName,describe)
	print(describe)

	message.dispatchGame(dealName)
end

function WL_Message.sendMessage(dealName,data,describe)
	print(describe)

	message.sendMessage(dealName,data)
end

return WL_Message