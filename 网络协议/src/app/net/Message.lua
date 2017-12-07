local Message = {}

require("framework.protobuf")
local Msgprotocol = require "app.net.Msgprotocol"

local function registerProto(path)
	local buffer = cc.HelperFunc:getFileData(path)
	protobuf.register(buffer)
end

registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/game.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/match.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/user.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/PrivateRoom.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/private.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/ShYMJ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/HkFiveCard.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/NN100.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/GP.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/_13Shui.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/YCMJ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/XSMJ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/SRDDZ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/WL.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/DYMJ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/WRNN.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/NJMJ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/CXMJ.pb"))
registerProto(cc.FileUtils:getInstance():fullPathForFilename("Protocol/DDZ.pb"))

local dispatch_handler = {}
local current = ""

function Message.sendMessage(name, msg)
	local id = Msgprotocol[name]
	--print("name:" .. name)
	--dump(msg)
    local data = protobuf.encode(name, msg)
    -- print("send message "..name)
	if Message.net and Message.net.sendData then
		Message.net.sendData(string.char(math.floor(id/256)%256) .. string.char(id%256) .. data)
	end
end

function Message.dispatch(id, data)
	--print("ddd id:"..id)
	-- heart beat
	if id == 2 then 
		--print("Message.dispatch:update--")
		Message.net.update()
		return 
	end

	-- kick player
	if id == 3 or id == 4 then 
		Message.net.disconnect(id) 
	end 

	local name = Msgprotocol[id]
	-- printf("recv msg[%s]:%s length:%d", tostring(id), tostring(name), #data)
    if name ~= nil then
    	local msg = protobuf.decode(name, data)
	    local module, method = name:match "([^.]*).(.*)"


	    print("module:method-" .. tostring(module).. ":" .. tostring(method))


	    local fun = dispatch_handler[module]
	    if fun ~= nil then
	    	-- dump(msg)
	    	fun(name, msg)
	    end
    end
end

function Message.dispatchCurrent(name, msg)
	local fun = dispatch_handler[current]
    if fun ~= nil then
    	fun(name, msg)
    end
end

function Message.dispatchGame(name, msg)
	local fun = dispatch_handler["game"]
    if fun ~= nil then
    	fun(name, msg)
    end
end

function Message.dispatchPrivateRoom(name, msg)
	local fun = dispatch_handler["private"]
    if fun ~= nil then
    	fun(name, msg)
    end
end

function Message.dispatchMatchRoom(name, msg)
	local fun = dispatch_handler["match"]
    if fun ~= nil then
    	fun(name, msg)
    end
end

function Message.registerHandle(name, fun)
	if name ~= "user" and name ~= "game" and name ~= "match" and name ~= "PrivateRoom" then
		current = name;
	end
	dispatch_handler[name] = fun
end

function Message.unregisterHandle(name)
	name = name or current
	if name ~= "user" and name ~= "game" and name ~= "match" and name ~= "PrivateRoom" then
		current = "";
	end
	dispatch_handler[name] = nil
end

function Message.notifyScene(name, msg, ...)
	local scene = display.getRunningScene()
	if scene and scene[name] then
		scene[name](scene, msg, ...)
	end
end

return Message