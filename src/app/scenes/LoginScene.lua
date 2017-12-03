local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

local LoginController = require("app.controllers.LoginController")
local GameData = import("..models.GameData")

function LoginScene:ctor()
    self.scene  = cc.uiloader:load("Scene/LoginScene.json"):addTo(self)
    self.loginController = LoginController:new(self)
    app.loginController = self.loginController
end

function LoginScene:onEnterTransitionFinish()

    local loginWeixin = cc.uiloader:seekNodeByNameFast(self.scene, "LoginWeixin")
    loginWeixin:onButtonClicked(handler(self, self.loginWeixin))

    self.inputText = cc.uiloader:seekNodeByNameFast(self.scene, "name")
end



function LoginScene:onExit()

end

function LoginScene:onLoginWeixin( param )
    dump(param, "loginweixin")

    if device.platform == "android" then
        param = json.decode(param)
        dump(param, "loginweixin after decode")
    end
    -- local openid, refresh_token 
    -- if app.gameData:get(open)
    self.loginController:login(param.openid, param.access_token)
    -- app.gameData:set("openid", param.openid)
    -- app.gameData:set("refresh_token", param.refresh_token)
end

function LoginScene:loginWeixin(  )
    if device.platform == "mac" then
        local username = self.inputText:getString()
        self.loginController:login(username.."_mac", "password")
    else
        if device.platform == "mac" then
            luaoc.callStaticMethod("WeixinSDK", "login", { callback = handler(self, self.onLoginWeixin)})
        elseif device.platform == "android" then
            luaj.callStaticMethod("app/WeixinSDK", "login", { handler(self, self.onLoginWeixin) })
        end
    end
end

return LoginScene
