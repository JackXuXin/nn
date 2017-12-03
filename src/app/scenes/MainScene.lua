
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
local LoginNet = require("app.net.LoginNet")
local GateNet = require("app.net.GateNet")

function MainScene:ctor()
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
    self.loginNet = LoginNet.new("hello", "password", "sample")
end

function MainScene:onEnter()
	self.loginNet:login(handler(self, self.loginCallback))
end

function MainScene:loginCallback( code )
	if code == 200 then
		self.gateNet = GateNet.new()
		self.gateNet:connect(handler(self,self.gateCallback))
	else
		print(LOGIN_ERROR_MSG[code])
	end
end

function MainScene:gateCallback(  )
	self.gateNet:send_request("echo", 0)
end

function MainScene:onExit()
end

return MainScene
