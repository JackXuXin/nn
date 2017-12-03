local LoginController = class("LoginController", function ()
    return {}
end)

function LoginController:ctor(  )
    app.gateNet = require("app.net.GateNet")
    app.loginNet = require("app.net.LoginNet")
end

function LoginController:login( openid, assessToken )
    print("LoginController", assessToken)
	app.loginNet:login( openid, assessToken, handler(self, self.loginCallback))
    self.kick = false
end

function LoginController:loginCallback( code )
	if code == 200 then
        app.gateNet:connect(handler(self,self.gateOkCallback))
    else
        self.authFail = true
        print(LOGIN_ERROR_MSG[code])
    end
end

function LoginController:gateOkCallback(  )
	app.gateNet:registerHandler("Kick", handler(self, self.kick))
	app:enterScene(lobbySceneName)
end

function LoginController:kick(  )
	app:enterScene(loginSceneName)
    self.kick = true
end


return LoginController