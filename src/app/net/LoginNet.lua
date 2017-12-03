local LoginNet = class("LoginNet", function (  )
	return {}
end)

local net = require("framework.cc.net.init")
require("framework.cc.utils.bit")
local crypt = require("crypt")
local Account = import("..models.Account")

function LoginNet:ctor()
	local time = net.SocketTCP.getTime()
	print("socket time:" .. time)
  
	local socket = net.SocketTCP.new()
	socket:setName("LoginTcp")
	-- socket:setTickTime(1)
	socket:setReconnTime(6)
	socket:setConnFailTime(4)
	socket:addEventListener(net.SocketTCP.EVENT_DATA, handler(self, self.receive))
	socket:addEventListener(net.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose))
	socket:addEventListener(net.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed))
	socket:addEventListener(net.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected))
	socket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.error))
	self.socket = socket

end

function LoginNet:login( openid, assessToken, callback )
	print("loginNet connectting")
	self.socket:connect(loginserver.ip, loginserver.port)
	self.callback = callback

	self.openid = openid
	self.assessToken = assessToken
	self.platform = device.platform
end

function LoginNet:send( text )
	self.socket:send(text.."\n")
end

local function unpack_line(text)
	local from = text:find("\n", 1, true)
	if from then
		return text:sub(1, from-1), text:sub(from+1)
	end
	return nil, text
end

function LoginNet:encode_token()
	print(self.openid, self.platform, self.assessToken)
	return string.format("%s@%s:%s",
		crypt.base64encode(self.openid),
		crypt.base64encode(self.platform),
		crypt.base64encode(self.assessToken))
end

function LoginNet:receive( event )
	local result
	result, last = unpack_line(event.data)
	if not result then
		return 
	end

	if self.clientkey == nil then
		print("base64 = ",result)
		self.challenge = crypt.base64decode(result)
		self.clientkey = crypt.randomkey()
		print("clientkey = ", crypt.base64encode(crypt.dhexchange(self.clientkey)) )
		self:send(crypt.base64encode(crypt.dhexchange(self.clientkey)))
	elseif self.clientkey ~= nil and self.secret == nil then
		self.secret = crypt.dhsecret(crypt.base64decode(result), self.clientkey)
		print("sceret is ", crypt.hexencode(self.secret))

		local hmac = crypt.hmac64(self.challenge, self.secret)
		self:send(crypt.base64encode(hmac))

		local etoken = crypt.desencode(self.secret, self:encode_token())
		local b = crypt.base64encode(etoken)
		self:send(b)
	else
		print(result)
		local code = tonumber(string.sub(result, 1, 3))
		local subid = crypt.base64decode(string.sub(result, 5))
		print("login ok, subid=", subid)
		local account = Account.new({
            openid = self.openid,
            secret = self.secret,
            subid = subid,
            platform = self.platform,
            assessToken = self.assessToken
        })
        print(assessToken, self.assessToken)
        app:setObject("account", account)
        self.callback(code)
        self.socket:close()
	end
end

function LoginNet:tcpClose(  )
	print("close in loginNet")
end

function LoginNet:tcpClosed(  )
	print("closed")
end

function LoginNet:tcpConnected(  )
	print("connected")
end

function LoginNet:error(  )
	print("error")
end

return LoginNet.new()