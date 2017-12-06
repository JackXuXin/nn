local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")


local MsgWorker = {}

local handler = nil
local sleeping = false
local buff = {}

function MsgWorker.init(name, func)
	assert(func, "handler func is nil!")
	sleeping = false
	buff = {}
	handler = func
	message.registerHandle(name, MsgWorker.dispatch)
end

function MsgWorker.clear()
	buff = {}
	scheduler.clear()
end

function MsgWorker.dispatch(name, msg)
	if handler == nil then
		print("handler is nil for msg:"..tostring(name))
		return
	end

	if name == "_13Shui.SendCard" then
		print("------------十三水手牌-------------")
		dump(msg.cardvalues)
		print("-------------------------")
	end

	if sleeping or #buff > 0 then
		--print("buffering msg:", name)
		buff[#buff+1] = {name=name, msg=msg}
	else
		handler(name, msg)
	end
end

function MsgWorker.sleep(seconds)
	if handler == nil then
		print("handler is nil")
		return
	end
	sleeping = true
	if seconds ~= nil then
		scheduler.performWithDelay(MsgWorker.wakeup, seconds)
	end
end

function MsgWorker.wakeup()
	if handler == nil then
		print("handler is nil")
		return
	end
	sleeping = false
	while #buff > 0 do
		local top = table.remove(buff, 1)
		if top ~= nil then
			print("wakeup msg:", top.name)
			handler(top.name, top.msg)
		end
		if sleeping then
			break
		end
	end
end

return MsgWorker
