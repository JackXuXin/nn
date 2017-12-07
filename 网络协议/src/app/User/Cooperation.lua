local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local util = require("app.Common.util")
local errorLayer = require("app.layers.ErrorLayer")
local sound_common = require("app.Common.sound_common")

function LobbyScene:showCooperation()
    local cooperationLayer = cc.uiloader:load("Layer/Lobby/CooperationLayer.json"):addTo(self.scene)
    self.cooperationLayer = cooperationLayer
    sound_common.menu()
    util.setMenuAniEx(cc.uiloader:seekNodeByNameFast(cooperationLayer, "nd_all"))

    local nd_info = cc.uiloader:seekNodeByNameFast(cooperationLayer, "nd_info")
    local nd_rule = cc.uiloader:seekNodeByNameFast(cooperationLayer, "nd_rule"):hide()
    local nd_guide = cc.uiloader:seekNodeByNameFast(cooperationLayer, "nd_guide"):hide()

    --复选按钮
    local cb_Join = cc.uiloader:seekNodeByNameFast(cooperationLayer, "cb_Join")
        :onButtonStateChanged(function( event)

        end)

    --申请加盟按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(cooperationLayer, "btn_join"))
        :onButtonClicked(function ( event )
            if cb_Join:isButtonSelected() then  --同意协议
                nd_info:hide()
                nd_guide:show()
            else
                errorLayer.new("请阅读并同意合作协议！"):addTo(cooperationLayer)
            end
        end)

    
    local webview

    --关闭按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(cooperationLayer, "btn_exit"))
        :onButtonClicked(function ( event )
            sound_common:cancel()
            if nd_rule:isVisible() then
                nd_info:show()
                nd_rule:hide()
                webview:removeSelf()
                webview = nil
                return
            end
            cooperationLayer:removeSelf()
        end)

    --协议按钮
    cc.uiloader:seekNodeByNameFast(cooperationLayer, "btn_rule")
        :onButtonClicked(function ( event )
            if device.platform ~= "android" and device.platform ~= "ios" then
                return
            end

            nd_info:hide()
            nd_rule:show()

            local content = cc.uiloader:seekNodeByNameFast(cooperationLayer, "la_rule_box")
            webview = ccexp.WebView:create()
            content:addChild(webview)
            webview:setVisible(true)
            webview:setScalesPageToFit(true)
            webview:setContentSize(cc.size(content:getContentSize().width,content:getContentSize().height)) -- 一定要设置大小才能显示
            webview:reload()
            webview:setAnchorPoint(cc.p(0, 0))
            webview:setPosition(0, 0)

            local rule = "Rule/agent.html"
            -- webview:loadFile(rule)

            if device.platform == "android" then
                local basePath = "assets"
                local filePath = cc.FileUtils:getInstance():fullPathForFilename(rule)
                print("filePath:" .. tostring(filePath))
                local resultPath = rule
                if string.sub(filePath,1,string.len(basePath)) ~= basePath then
                    resultPath = "file://" .. filePath
                end
                print("resultPath22:" .. tostring(resultPath))
                webview:loadFile(resultPath)
            else
                webview:loadFile(rule)
            end
        end)
end

return LobbyScene