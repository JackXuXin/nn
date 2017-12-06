require("config")
require("cocos.init")
require("framework.init")

if not DEVELOPMENT then
    print = function ( ... ) end
elseif device.platform == "android" then
    print = release_print
elseif device.platform == "mac" or device.platform == "windows" then
    logger = require("utils.logger")
end

local MyApp = class("MyApp", cc.mvc.AppBase)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

MyApp.lang = nil

function MyApp:ctor()
    MyApp.super.ctor(self)
    -- local director = cc.Director:getInstance()
    -- director:setAnimationInterval(1.0 / 40)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")

    math.newrandomseed()

    -- Timer
    MyApp.timer = require(cc.PACKAGE_NAME .. ".cc.utils.Timer").new()
    MyApp.timer:start()

    -- app constant
    MyApp.constant = require("app.Constant")

    -- app constant
    MyApp.userdata = require("app.UserData")

    -- multi-language support
    local language = cc.Application:getInstance():getCurrentLanguage()
    print("language", language)
    MyApp.lang = require("app.language.zh")

    self:enterScene("LoginScene", nil, "fade", 0.5)
end

function MyApp:onEnterBackground()
    print("onEnterBackground11---------")
end

function MyApp:onEnterForeground()
    print("onEnterForeground11---------")
end

-- function MyApp:exit()
--     print("MyApp:exit-----")
--     MyApp.super.exit()
-- end

function MyApp:restart()
    -- clear packages
    local reglist = {"^app%.", "^framework%.", "^cocos%.", "^utils%.", "^config$"}
    for k,v in pairs(package.loaded) do
        for _,v in ipairs(reglist) do
            if string.find(k, v) then
                package.loaded[k] = nil
                _G[k] = nil
                break
            end
        end
    end

    -- clear global variables
    if logger then
        logger.reset()
    end

    for k,v in pairs(package.loaded) do
        print(k)
    end

    print("restart-----src/main---")

    package.loaded["src/main"] = nil

    require "src/main"

    print("restart-----2222---")

end

-- save did not clean up scenes
MyApp.scenes = {}
setmetatable(MyApp.scenes, {__mode = "kv"})

return MyApp
