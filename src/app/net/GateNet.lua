local GateNet = class("GateNet", function (  )
	return {}
end)

local net = require("framework.cc.net.init")
local ByteArray = require("framework.cc.utils.ByteArray")
local scheduler = require(cc.PACKAGE_NAME..".scheduler")
require("pack")

local sproto = require "sproto"
local sprotoloader = require "sprotoloader"
local proto = require("app.net.proto")

function GateNet:ctor(  )
  
	local socket = net.SocketTCP.new()
	socket:setName("GateTcp")
	socket:setReconnTime(6)
	socket:setConnFailTime(4)
	socket:addEventListener(net.SocketTCP.EVENT_DATA, handler(self, self.receive))
	socket:addEventListener(net.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose))
	socket:addEventListener(net.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed))
	socket:addEventListener(net.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected))
	socket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.connectFailed))
	self.socket = socket
	self.index = 1

	sprotoloader.save(proto.c2s, 1)
	sprotoloader.save(proto.s2c, 2)

	self.session = 1
	self.callBlock = {}
	self.callReturn = {}
	self.msgMap = {}
	self.serverMap = {}
	self.heartbeatIndex = 0

	self:registerHandler("ServerAddr", handler(self, self.setServerAddr))
end

function GateNet:reconnect(  )
	print("reconnect tiaojian = ", app.loginController.kick, self.authFailed, self.isconnect )
	if not app.loginController.kick and not self.authFailed and not self.isconnect then
		print("reconnect")
		scheduler.performWithDelayGlobal(function (  )
			self:connect(self.gateOkCallback)
		end, 1)
	end
end

function GateNet:connectFailed(  )
	self.isconnect = false
	self:reconnect()
end

function GateNet:checkHeadbeat(  )
	if os.time() - self.lastHeartbeatTime >= 15 then
		self:call("Heartbeat", {index = self.heartbeatIndex}, handler(self, self.heartBack))
		self.heartbeatIndex = self.heartbeatIndex + 1
		self.lastHeartbeatTime = os.time()
	end
end

function GateNet:heartBack( ok, msg )
	-- print("heartbeat back")
end

function GateNet:send( pack )
	if not self.isconnect then
		print("net disconnect")
		return
	end
	-- print("pack len = ", #pack)
	local buff = string.char(math.floor(#pack/256)%256) .. string.char(#pack%256) .. pack
	self.socket:send(buff)
	self.lastHeartbeatTime = os.time()
end

function GateNet:tcpClose(  )
	scheduler.unscheduleGlobal(self.heartbeatHandle)
	print("close in gateNet")
end

function GateNet:tcpClosed(  )
	print("close by server")
	scheduler.unscheduleGlobal(self.heartbeatHandle)

	self.isconnect = false
	self:reconnect()
end

function GateNet:connect( gateOkCallback )
	print("someby call connect")
	self.socket:connect(gateserver.ip, gateserver.port)
	self.gateOkCallback = gateOkCallback
end

function GateNet:auth(  )
	local account = app:getObject("account")
	local key = account:getKey()
	local ok,result = self:call("Handshake", {key = key}, handler(self, self.authResult))
end

function GateNet:startCheckHearbeat(  )
	self.heartbeatHandle = scheduler.scheduleGlobal(handler(self, self.checkHeadbeat), 10)
	self.lastHeartbeatTime = os.time()
end

function GateNet:setServerAddr( servers )
	-- dump(servers, "set serverMap")
	table.walk(servers.addrs, function ( server )
		self.serverMap[server.name] = server.addr
	end)
	dump(self.serverMap, "self.serverMap")
	self.gateOkCallback()
end

function GateNet:getAddr( serverName )
	return self.serverMap[serverName]
end

function GateNet:authResult( ok, result )
	if ok and result.result == "success" then
		print("gate login success")
		self:startCheckHearbeat()
		-- self:call("ServerAddr",{}, handler(self, self.setServerAddr))
	elseif ok and result.result ~= "success" then
		self.authFailed = true
		print(result.result)
	else
		print("gate login error")
	end
end

function GateNet:call( name, args, callback )
	if not self.isconnect then
		print("gate net disconnect")
		return
	end

	local curSession = self.session

	if self.packer then
		self:send(self.packer(name,args,curSession))
		self.session = self.session + 1
		self.callReturn[curSession] = callback
		dump(args, "call "..name.." "..curSession)
		scheduler.performWithDelayGlobal(function (  )
			if self.callReturn[curSession] then
				print("call failed session = ", curSession)
				self.callReturn[curSession](false)
				print("session "..curSession.." timeout")
			end
		end, 3)
	else
		print("packer is nil")
	end
end

function GateNet:execute( name, args )
	if not self.isconnect then
		print("gate net disconnect")
		return
	end
	
	dump(args, "excute "..name)
	if self.packer then
		self:send(self.packer(name,args))
	else
		print("packer is nil")
	end
end

function GateNet:callTimeout(  )
	
end

function GateNet:receive( event )
	self.gateBuff = (self.gateBuff or "") .. event.data
	local len = #self.gateBuff
    while (len > 2) do
        local size = 256 * self.gateBuff:byte(1) + self.gateBuff:byte(2)
        if (len < 2 + size) then
            return
        end

        local type,session,result = self.host:dispatch(self.gateBuff:sub(3, 2+size), s)
        self.gateBuff = self.gateBuff:sub(3 + size, #self.gateBuff)
        len = #self.gateBuff

		dump(result, type.." "..session)
		if type == "RESPONSE" then
			if self.callReturn[session] then
				self.callReturn[session](true, result)
				self.callReturn[session] = nil
			else
				print("empty response")
			end
		elseif type == "REQUEST" then
			local name = session
			local args = result
			if self.msgMap[name] then
				self.msgMap[name](args)
			else
				print("no handler msg ", name)
			end
		end

    end
end

function GateNet:tcpConnected()
	print("gate connected")
	self.host = sprotoloader.load(2):host "package"
	self.packer = self.host:attach(sprotoloader.load(1))
	self.isconnect = true
	self:auth()
	
end

function GateNet:registerHandler( name, fun )
	self.msgMap[name] = fun
end

local gateNet 
local function getGateNet(  )
	if gateNet == nil then
		gateNet = GateNet:new()
	end
	print("local net yeah")
	return gateNet
end

return getGateNet()