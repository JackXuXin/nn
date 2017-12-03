local function enterStartScene(  )
    if device.platform == "mac" and not HOTFIX_ON_MAC then
        if TEST_FLAG then
            app:enterScene("6jtScene")
        else
            app:enterScene("LoginScene")
        end
    else
        app:enterScene("LoginScene")
    end
end

local function addSearchPath(  )
    local writePath = cc.FileUtils:getInstance():getWritablePath() 
    cc.FileUtils:getInstance():addSearchPath(writePath .. "hotupdate/res/")
    cc.FileUtils:getInstance():addSearchPath(writePath .. "hotupdate/src/")
    cc.FileUtils:getInstance():addSearchPath(writePath .. "hotupdate") 
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath(writePath .. "src")
end

local function initComponent(  )
	app.gateNet = require("app.net.GateNet")
    app.loginNet = require("app.net.LoginNet")
	app.gameData = require("app.models.GameData")
end 

function appInit(  )
	addSearchPath()
	initComponent()
	enterStartScene()
end

