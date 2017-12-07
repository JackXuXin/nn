--
-- Author: K
-- Date: 2017-01-03 16:00:26
-- 通信封装
--

local DDZ_Message = {}

local message = require("app.net.Message")			    --通信

function DDZ_Message.dispatchGame(dealName)
	message.dispatchGame(dealName)
end

function DDZ_Message.dispatchPrivateRoom(dealName,tab)
	message.dispatchPrivateRoom(dealName,tab)
end

function DDZ_Message.sendMessage(dealName,data,describe)
	if describe then
		print(describe)
	end
	

	message.sendMessage(dealName,data)
end

return DDZ_Message