local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local net = require("framework.cc.net.init")
local LoginNet = require("app.net.LoginNet")
local GateNet = require("app.net.GateNet")
local UserMessage = require("app.net.UserMessage")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local ProgressLayer = require("app.layers.ProgressLayer")
local ErrorLayer = require("app.layers.ErrorLayer")
local web = require("app.net.web")
local PreloadRes = require("app.config.PreloadRes")
local util = require("app.Common.util")
local crypt = require("crypt")
local GameState = require("framework.cc.utils.GameState")
local sound_common = require("app.Common.sound_common")
local PlatConfig = require("app.config.PlatformConfig")
local msgMgr = require("app.room.msgMgr")
local message = require("app.net.Message")
local NetSprite = require("app.config.NetSprite")
local isUpFailed = false
local isSelect = true
local strUser = ""

LoginScene.accountHistory = nil

local passwordCryptKey = "jnKey890"
local Account = app.userdata.Account

local function encodePwd(pwd)
    if not pwd or pwd == "" then
        return ""
    end

    local ret = crypt.desencode(passwordCryptKey, pwd)
    local ret = crypt.base64encode(ret)
    return ret
end

local function decodePwd(pwd)
    if not pwd or pwd == "" then
        return ""
    end

    local ret = crypt.base64decode(pwd)
    ret = crypt.desdecode(passwordCryptKey, ret)
    return ret
end

function LoginScene:ctor()

    -- local textTable = {{text="杠开", color=cc.c3b(31, 173, 157)}, {text="2", color=cc.c3b(221, 150, 68)}, {text="番", color=cc.c3b(31, 173, 157)}}
    -- util.setRichText(self, cc.p(200, 360), textTable, 400, 40, 22)

--clear
    util.DestroyChatVoiceLayer()
--end
    util.GameStateInit()
    sound_common.setVoiceState(app.constant.voiceOn)
    sound_common.setMusicState(app.constant.musicOn)
    -- init
    app.userdata:clear()

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)

    if platConfig.loadingImg ~= nil  then

        util.preDownloading(self, "loadingImage")

    end

    if not self.class.accountHistory then
        self:readAccountHistory()
    end

    self.scene  = cc.uiloader:load("Scene/LoginScene.json"):addTo(self)

    -- self.scene.background = cc.uiloader:seekNodeByNameFast(self.scene, "Background");
    -- self.scene.background:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.hideAccountList))


    -- local Image_logo = cc.uiloader:seekNodeByNameFast(self.scene, "Image_logo");

    -- local logosprite = display.newSprite(platConfig.Image_logo) --创建下载成功的sprite
    -- local texture = logosprite:getTexture()--获取纹理
    -- local logosize = texture:getContentSize()

    -- print("logosize:",logosize.width, logosize.height)

    -- Image_logo:setLayoutSize(logosize.width, logosize.height)
    -- Image_logo:setTexture(platConfig.Image_logo)

    app.constant.show_leaveTip = false

    local loginWeixin = cc.uiloader:seekNodeByNameFast(self.scene, "LoginWeixin")
    local login = cc.uiloader:seekNodeByNameFast(self.scene, "Login")
    
    --local  btn_Publick = cc.uiloader:seekNodeByNameFast(self.scene, "btn_Publick")
    if device.platform ~= "mac" then
        login:hide()
        login:setPosition(640,194)
        loginWeixin:hide()
        loginWeixin:setPosition(640,194)
        if CONFIG_APP_CHANNEL=="3552" or CONFIG_APP_CHANNEL=="3556" then
           -- btn_Publick:hide()
        end
    end

    login:onButtonClicked(function (event)
        if isSelect == false then
            ErrorLayer.new(app.lang.not_login, nil, nil, nil):addTo(self)
            return
        end

        if app.constant.autoLogin and self.class.accountHistory[1] then
            --dump(self.class.accountHistory)
            local account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password

            if account ~= nil and account ~= "" and password ~= nil and password ~= "" then
                print("auto---login--1111--")
                self:login({
                    channel = app.constant.channel_game,
                    account = account,
                    password = password,
                })
            else
                self:createLoginLayer()
            end
        else
            self:createLoginLayer()
        end
    end)

    --加载loading界面

    if platConfig.loadingImg ~= nil  then

        local isLoading = cc.UserDefault:getInstance():getBoolForKey("loading")

        print("isLoading = ", isLoading)

        if isLoading == nil or isLoading == false then

            self:setLoadingLayer()

            cc.UserDefault:getInstance():setBoolForKey("loading", true)


            local isLoading2 = cc.UserDefault:getInstance():getBoolForKey("loading")

            print("isLoading111 = ", isLoading2)

        end

    end

    local path = cc.FileUtils:getInstance():fullPathForFilename(app.constant.userProtocol)
    local file = cc.FileUtils:getInstance():getStringFromFile(path)

    if not file then
        return
    end

   --  local path2 = cc.FileUtils:getInstance():fullPathForFilename("Rule/badword")
   --   print("login_path2 = ",path2)
   -- local file2 = cc.HelperFunc:getFileData(path2)


   -- print("login_file = ",file2)

    strUser = file

end

function LoginScene:onEnter()

    --断线重连后，进入登录界面清理语音资源
    util.CloseChannel()
    --end
    util.unscheduleMatch()
end

function LoginScene:onExit()

    if self.loginRequest then

         scheduler.unscheduleGlobal(self.loginRequest)
        self.loginRequest = nil

    end
    strUser = ""

    util.clearActivityImage(self, 1)

end

function LoginScene:onCleanup()
    -- display.removeUnusedSpriteFrames()
end

function Notification()

    print("Notification--------")

    saveLoginfo("account111:,password111:")

    local account,password = "",""


     if self.class.accountHistory[1] then

            account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password
     end

    saveLoginfo("account:,password:"..account.."p"..password)

    local astr = string.len(account)
    local pstr = string.len(password)

    if astr>0 and pstr>0 then

        scene:login({
            channel = app.constant.channel_game,
            account = account,
            password = password,
        })

    else

        --saveLoginfo("account:,password2222:")

        scene:loginWeixin()

    end

end

function LoginScene:RequestFromWChat()

    --print("G_RequestFromWChat:test",self.info)

    local gameid, roomid, uid, session, tableid, seatid, password

    if device.platform == "android" then
        param = json.decode(self.info)
        xmlPath = param.path

    else
        param = self.info
    end

    --dump(self.info)

        gameid = param.gameid
        roomid = param.roomid
        uid = param.uid
        session = param.session
        tableid = param.tableid
        seatid = param.seatid
        password = param.password
       -- print("G_RequestFromWChat:",param.gameid)

    if gameid == 0 or gameid == "0" or uid == 0 or uid =="0" then

        return

    end


    local roomNid = tonumber(roomid)
    if roomNid == 0 then

        -- saveLoginfo("RequestFromWChatce------" .. uid)

        app.constant.isInvite = true

        app.constant.nChatUid = tonumber(uid)

        if  app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)

            return

        end

        print("RequestFromWChat:uid", uid)

        SetInvitation()

    else

        app.constant.isReuqestWchat = 1

        print("RequestFromWChat:", gameid, roomid, uid, session, tableid, seatid, password)

        app.constant.requestWchatInfo.session = tonumber(session)
        app.constant.requestWchatInfo.tableid = tonumber(tableid)
        app.constant.requestWchatInfo.password = password
        app.constant.requestWchatInfo.roomid = tonumber(roomid)
        app.constant.requestWchatInfo.gameid = tonumber(gameid)

        if app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)
            app.constant.isReuqestWchat = 2
            return

        end

        local scene = display.getRunningScene()

        print("RequestFromWChat:", scene.name)

        if scene.name == "LoginScene" then

             local account,password = "",""

             if self.class.accountHistory[1] then

                    account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password
             end

            --saveLoginfo("account:,password:"..account.."p"..password)

            local astr = string.len(account)
            local pstr = string.len(password)

            if astr>0 and pstr>0 then

                scene:login({
                    channel = app.constant.channel_game,
                    account = account,
                    password = password,
                })

            else

                --saveLoginfo("account:,password2222:")

                scene:loginWeixin()

            end


        elseif scene.name ~= "LobbyScene" and  scene.name ~= "RoomScene" then

            local curGameID =  app.constant.cur_GameID
            local cur_RoomID = app.constant.cur_RoomID

            if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                app.constant.isReuqestWchat = 0

                return

            end


            message.dispatchGame("room.LeaveGame", {})

            -- local session = msgMgr:get_room_session()
            -- message.sendMessage("game.LeaveRoomReq", {session=session})
            -- app:enterScene("LobbyScene", nil, "fade", 0.5)

        elseif scene.name == "RoomScene" then

            local curGameID =  app.constant.cur_GameID
            local cur_RoomID = app.constant.cur_RoomID

            if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                app.constant.isReuqestWchat = 3
                selectEnterGameScene()

            else

                local session = msgMgr:get_room_session()
                message.sendMessage("game.LeaveRoomReq", {session=session})
                app:enterScene("LobbyScene", nil, "fade", 0.5)

                app.constant.isReuqestWchat = 2

            end

        elseif scene.name == "LobbyScene" then

            app.constant.isReuqestWchat = 2

            setEnterScene()

        end
        -- if g_watching == false then

        --     util.CloseChannel()

        -- end

    end

end

function LoginScene:init()
    local progressLayer
    local popbox = nil

    -- functions declare
    local createPopbox
    local start
    local getRealIp
    local checkUpdate
    local getTags
    local hotfix
    local virPercent = 0
    local failCount = 0
    local  BigUpdate = false

    -- functions definition
    createPopbox = function (callback)
        if not popbox then
            popbox = MiddlePopBoxLayer.new(app.lang.system, app.lang.network_invalid,
                MiddlePopBoxLayer.ConfirmSingle, false, nil, nil, function ()
                    sound_common.confirm()
                    popbox:removeFromParent()
                    popbox = nil
                    if callback then
                        callback()
                    end
                end)
            :addTo(self.scene)
            --cc.uiloader:seekNodeByNameFast(popbox, "Close"):hide()
        end
    end

    start = function ()

        if popbox ~= nil then

            popbox:removeFromParent()
            popbox = nil

        end
        ProgressLayer.removeProgressLayer(progressLayer)
        progressLayer = nil
        progressLayer = ProgressLayer.new(app.lang.resource_loading, nil, function ()

            if BigUpdate == false then
            createPopbox(start)
            end

        end)
        :addTo(self.scene)
        print("getRealIp")
        getRealIp()
    end

    getRealIp = function ()
    --modify by whb 161020
        local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/realip?version="..
                    util.getVersion().."&platform="..device.platform.."&app_channel="..CONFIG_APP_CHANNEL

        if progressLayer == nil then

            progressLayer = ProgressLayer.new(app.lang.resource_loading, -1)
                :addTo(self.scene)
        end
    --modify end
        print("url:"..url)
        local request = network.createHTTPRequest(function (event)
            local result = web.checkResponse(event)
            print("result:"..result)
            if result == 0 then
                return
            elseif result == -1 then
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                createPopbox(getRealIp)
                --checkUpdate()
                return
            end

            local response = event.request:getResponseString()
            response = json.decode(response)
            if response.login_ip then
                LOGIN_SERVER.ip = response.login_ip
            end
            if response.login_port then
                LOGIN_SERVER.port = response.login_port
            end
            if response.gate_ip then
                GATE_SERVER.ip = response.gate_ip
            end
            if response.gate_port then
                GATE_SERVER.port = response.gate_port
            end
            print("real response:", response)
            print("real ip", LOGIN_SERVER.ip..":"..LOGIN_SERVER.port, GATE_SERVER.ip..":"..GATE_SERVER.port)
            checkUpdate()
        end, url, "GET")
        request:start()
    end

    checkUpdate = function ()

     print("checkUpdate---:")
    --modify by whb 161020
        local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/update?version="..
                    util.getVersion().."&platform="..device.platform.."&app_channel="..CONFIG_APP_CHANNEL

        if progressLayer == nil then

            progressLayer = ProgressLayer.new(app.lang.resource_loading, -1)
                :addTo(self.scene)
        end
   --modify end
        local request = network.createHTTPRequest(function (event)
            local result = web.checkResponse(event)
            print("re:"..result)
            if result == 0 then
                return
            elseif result == -1 then
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                createPopbox(checkUpdate)
                --getTags()
                return
            end

            local response = event.request:getResponseString()
            if response ~= "" then
                local updateUrl = response:urldecode()

                local updateLayer = cc.uiloader:load("Layer/Login/UpdateLayer.json"):addTo(self.scene)
                -- cc.uiloader:seekNodeByNameFast(updateLayer, "Title"):setString(app.lang.update)

                local title_sprite = cc.uiloader:seekNodeByNameFast(updateLayer, "Image_Title")
                local s = display.newSprite("Image/Public/tip_title.png")
                local frame = s:getSpriteFrame()
                title_sprite:setSpriteFrame(frame)

                cc.uiloader:seekNodeByNameFast(updateLayer, "Close"):hide()
                cc.uiloader:seekNodeByNameFast(updateLayer, "Update")
                    :onButtonClicked(function ()
                        device.openURL(updateUrl)
                    end)

                BigUpdate = true

                return
            end

            getTags()
        end, url, "GET")
        request:start()
    end

    getTags = function ()
    --modify by whb 161020

        local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/tags?version="..
                    util.getVersion().."&platform="..device.platform.."&app_channel="..CONFIG_APP_CHANNEL
        print("tags:" .. url)

        if progressLayer == nil then

            progressLayer = ProgressLayer.new(app.lang.resource_loading, -1)
                :addTo(self.scene)
        end
   --modify end
        local request = network.createHTTPRequest(function (event)
            local result = web.checkResponse(event)
            print("r:"..result)
            if result == 0 then
                return
            elseif result == -1 then
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                createPopbox(getTags)
                --self:updateLoginTypes()
                return
            end

            local response = event.request:getResponseString()
            if response ~= "" then
                Account.tags = json.decode(response)
                dump(Account.tags,"kaiguan:")
                -- DEVELOPMENT because quick-cocos2dx AssertManager will triger one "assert" in debug mode
                if DEVELOPMENT or Account.tags.not_hotfix == "1" then
                    ProgressLayer.removeProgressLayer(progressLayer)
                    progressLayer = nil
                    self:updateLoginTypes()
                else
                    hotfix()
                end
            end
        end, url, "GET")
        request:start()
    end


    hotfix = function ()

        local lastHotState = cc.UserDefault:getInstance():getIntegerForKey("HotState")
        local begin = false
        local function handleAssetsManagerEx(event)
            if (cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE == event:getEventCode()) then
                print("已经是最新版本了，进入游戏主界面")
                cc.UserDefault:getInstance():setIntegerForKey("HotState", 1)
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                self:updateLoginTypes()
            end

            if (cc.EventAssetsManagerEx.EventCode.NEW_VERSION_FOUND == event:getEventCode()) then
                print("发现新版本，开始升级")

                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil

                progressLayer = ProgressLayer.new(app.lang.hotfix_begin, -1)
                :addTo(self.scene)

                if lastHotState ~= 0 then

                    cc.UserDefault:getInstance():setIntegerForKey("HotState", 0)

                end

                -- progressLayer = ProgressLayer.new(app.lang.hotfix_begin, hotfix_time, function ()


                --     ProgressLayer.removeProgressLayer(progressLayer)
                --     progressLayer = nil
                --     print("timeout-progressLayer:", progressLayer)

                --     createPopbox(start)
                -- end)
                -- :addTo(self.scene)
            end

            if (cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION == event:getEventCode()) then
                print("更新进度=" .. event:getPercent() .." ".. event:getMessage())
                print(type(event:getMessage()))

                print(tostring(begin))
                if event:getMessage() ~= "" then
                    begin = true
                end
                if begin and progressLayer then

                    if popbox ~= nil then

                        popbox:removeFromParent()
                        popbox = nil

                    end

                    local percent = tonumber(event:getPercentByFile())
                    local  a = app.lang.hotfix_process .. math.floor(percent) .. "%"
                    -- if percent == 0 and virPercent <= 93 then

                    --    virPercent = virPercent + 1

                    -- end

                    -- if percent < virPercent then
                    --     a = app.lang.hotfix_process .. math.floor(virPercent)
                    -- end

                    print("percent---:",  percent)
                    if progressLayer ~= nil then
                        print("a:", a)
                       progressLayer:setText(a)
                    end
                end
            end

            if (cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED == event:getEventCode()) then
                print("更新完毕，重新启动")

                cc.UserDefault:getInstance():setIntegerForKey("HotState", 1)
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil

                cc.UserDefault:getInstance():setBoolForKey("loading", true)

                if self.loadingLayer == nil then

                    ErrorLayer.new(app.lang.hotfix_successful, nil, nil, function ()

                        app:restart()

                    end):addTo(self)

                else

                    local a = cc.UserDefault:getInstance():getBoolForKey("loading")

                    print("isLoading222 = ", a)

                    self.needRestart = true

                end

            end

            if (cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST == event:getEventCode()) then
                print("发生错误:本地找不到manifest文件")
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                ErrorLayer.new(app.lang.hotfix_error, nil, nil, function ()
                    app:exit()
                end):addTo(self)

            end

            if (cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST == event:getEventCode()) then
                print("发生错误:下载manifest文件失败")
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                createPopbox(hotfix)

            end

            if (cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST == event:getEventCode()) then
                print("发生错误:解析manifest文件失败")
                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil
                createPopbox(hotfix)

            end


            if (cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED == event:getEventCode()) then

                 print("下载更新失败的文件")

                failCount = failCount + 1
                if (failCount < 5) then
                    assetsManagerEx:downloadFailedAssets()
                else
                    print("Reach maximum fail count, exit update process")
                    failCount = 0

                     ProgressLayer.removeProgressLayer(progressLayer)
                     progressLayer = nil

                    app:restart()
                end


            elseif (cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING == event:getEventCode()) then
                print("发生错误:更新失败")

                ProgressLayer.removeProgressLayer(progressLayer)
                progressLayer = nil

                 -- local new_version = device.writablePath.."new_version/"
                 -- print("new_version:" .. new_version)
                 -- cc.FileUtils:getInstance():removeDirectory(new_version)

                 -- print("发生错误:删掉下载未完成的new_version")

                 isUpFailed = true

                 local dispatcher = cc.Director:getInstance():getEventDispatcher()

                 dispatcher:removeEventListener(self.listenUpdate)

                --createPopbox(hotfix)

                hotfix()

            end
        end

        local hotTip = app.lang.hotfix_ready
--更新失败，删掉未更新完成的new_version
        if isUpFailed == true then

             local new_version = device.writablePath.."new_version/"
             print("new_version:" .. new_version)
             cc.FileUtils:getInstance():removeDirectory(new_version)

             print("发生错误:删掉下载未完成的new_version")

             hotTip = app.lang.hotfix_again

        end

        ProgressLayer.removeProgressLayer(progressLayer)
        progressLayer = nil
        progressLayer = ProgressLayer.new(hotTip, nil, function ()
            createPopbox(hotfix)

            if self.listenUpdate ~= nil then

                local dispatcher = cc.Director:getInstance():getEventDispatcher()
                dispatcher:removeEventListener(self.listenUpdate)

            end

        end)
        :addTo(self.scene)

        local storagePath = device.writablePath.."new_version"
        local assetsManagerEx = cc.AssetsManagerEx:create("version/project.manifest", storagePath)
        assetsManagerEx:retain()


        local localManifest = assetsManagerEx:getLocalManifest()

        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        local eventListenerAssetsManagerEx = cc.EventListenerAssetsManagerEx:create(assetsManagerEx, handleAssetsManagerEx)
        self.listenUpdate = eventListenerAssetsManagerEx
        dispatcher:addEventListenerWithFixedPriority(eventListenerAssetsManagerEx, 1)


        assetsManagerEx:update()
        print("update start")

        -- local tempPath = device.writablePath.."new_version/project.manifest.temp"

        -- if tempPath ~= nil then

        --      local new_version = device.writablePath.."new_version/"
        --      cc.FileUtils:getInstance():removeDirectory(new_version)

        --      print("准备更新:删掉下载未完成的new_version")

        -- end

        --local localManifest = assetsManagerEx:getLocalManifest()
    end

    -- disabled input
    -- self.scene.accountInput:setTouchEnabled(false)
    -- self.scene.passwordInput:setTouchEnabled(false)

    -- trigger sounds
    audio.setSoundsVolume(0)
    audio.playSound("Sound/HkFiveCard/SEND_CARD.wav")
    scheduler.performWithDelayGlobal(function ()
        audio.setSoundsVolume(1)
    end, 0.5)

    -- startgg
    --if app.constant.isturn then

        start()

    --end

    print("App_Channel:" .. CONFIG_APP_CHANNEL)

    --add by whb 161019
    local text_Name = cc.ui.UILabel.new({text = "v"..CONFIG_VERSION_ID, size = 20, color = cc.c3b(255,255,255)})
    text_Name:setOpacity(160)
    text_Name:addTo(self.scene)
    -- text_Name:setAnchorPoint(text_HororName:getAnchorPoint())
    -- local  rect = text_Name:getBoundingBox()
    --text_Name:setPosition(display.right-rect.width-15, display.top-20)
    text_Name:setPosition(15, 20)

    --end by whb


     -- print("Version:" .. localManifest:getVersion())
end

function LoginScene:onEnterTransitionFinish()

    --if device.platform == "android" then

    local progressLayer = nil
    progressLayer = ProgressLayer.new(app.lang.resource_loading, nil, nil)
    :addTo(self.scene)

    local aniHandler = scheduler.performWithDelayGlobal(
    function ()

        ProgressLayer.removeProgressLayer(progressLayer)
        progressLayer = nil
        self:init()

    end, 0.5)
    --end

    --self:init()
    local netState = network.getInternetConnectionStatus()
    app.constant.lastNetState = netState

    --提前获取活动图
    util.preDownActivety(self, "activity1")

    self.loginRequest = scheduler.scheduleGlobal(function()

        if app.constant.hot_Finish == false then

           return

        end


        if app.constant.isInvite == false then

             function callback(param)

            --print("shareWeixin:gameid--")

            self.info = param

            self:RequestFromWChat()

           end
            if device.platform == "ios" then
                 luaoc.callStaticMethod("WeixinSDK", "loginReady", { callback = callback})
            -- elseif device.platform == "android" then
            --     luaj.callStaticMethod("app/WeixinSDK", "loginReady", { callback })
            end

        end

        --saveLoginfo("onEnterTransitionFinish------" .. tostring(app.constant.isInvite))

        if app.constant.isInvite or app.constant.isReuqestWchat == 2 then

            local account,password = "",""

             if self.class.accountHistory[1] then

                    account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password
             end

            local astr = string.len(account)
            local pstr = string.len(password)

            if astr>0 and pstr>0 then

                --saveLoginfo("account:,password111:")

                    self:login({
                    channel = app.constant.channel_game,
                    account = account,
                    password = password,
                })

            else

                self:loginWeixin()

            end

            app.constant.isLoginGame = true

            scheduler.unscheduleGlobal(self.loginRequest)
            self.loginRequest = nil

         end

        end, 0.5)

--测试
    -- local url = "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/96"
    -- local icontest = NetSprite.new(url):addTo(self):align(display.CENTER,0,0)
    -- icontest:setPosition(640,360)
    -- icontest:setScale(0.2)
--end

-- ---测试 http请求网络图片 的代码
--    local function HttpRequestCompleted(statusCode,tagNum,image)
--         print("图片数据请求结果 statusCode:"..statusCode.."  tag:"..tagNum)

-- ---200表示获取网络图片成功，否则失败
--         if statusCode==200 then

--             print("HttpRequestCompleted---------")

--             local texture=cc.Texture2D:new()
--             texture:initWithImage(image)
--             local sp_goodsItem=cc.Sprite:createWithTexture(texture)  --直接创建请求的网络图片精灵，不用再保存到本地，很方便的

--         end

--     end

--      ---最后一个参数是tag值，缺省是-1，这个参数与回调函数HttpRequestCompleted的第2个参数对应
--      yvcc.HclcData:sharedHD():requestGoodsImageFromWeb("http://h.hiphotos.baidu.com/zhidao/pic/item/5bafa40f4bfbfbed0470471b78f0f736afc31fac.jpg",HttpRequestCompleted,123)

        -- local isWeiIcon = util.isWeiIcon("http://wx.qlogo.cn/mmopen/BmTDvkQTDBkKqLgEaSlCflPEkkqvfRXDiblicgSqPYIIvCkUxgMiarnsKVCr6vJcvDUhohfsyHRYESx8bsIcfqPLdYLfBgq8XpC/0")

        -- print("isWeiIcon = ",isWeiIcon)
end

function LoginScene:showPublicInfo()

    util.setPublickInfoLayer(self, nil)

end

function LoginScene:updateLoginTypes()
    -- self.scene.accountInput:setTouchEnabled(true)
    -- self.scene.passwordInput:setTouchEnabled(true)

    print("updateLoginTypes-----")

    cc.UserDefault:getInstance():setBoolForKey("loading", false)

    local  btn_Publick = cc.uiloader:seekNodeByNameFast(self.scene, "btn_Publick")

    local loginWeixin = cc.uiloader:seekNodeByNameFast(self.scene, "LoginWeixin")

    local login = cc.uiloader:seekNodeByNameFast(self.scene, "Login")

    --提审时显示登录按钮，金陵不显示登录按钮
    if Account.tags.account_login_tag == "1" then
        print("登录开关的值：1")
        login:show()
        login:setPosition(640,194)
    elseif Account.tags.account_login_tag == "0" and device.platform ~= "mac" then
        print("登录开关的值：2")
        login:hide()
    end
    print("登录开关的值：3" ..device.platform)

    if Account.tags.weixin_login_tag == "1" then
        loginWeixin:show()
        if device.platform ~= "mac" then
            --todo
            loginWeixin:setPosition(640,194)
        end
        loginWeixin:onButtonClicked(handler(self, self.loginWeixin))
        local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
        if btn_Publick ~= nil and platConfig.publick_btn == nil then

            btn_Publick:show()
            btn_Publick:onButtonClicked(handler(self, self.showPublicInfo))
        end
    else
        loginWeixin:hide()

        if btn_Publick ~= nil then
            btn_Publick:hide()
        end
    end

    util.BtnScaleFun(login)
    util.BtnScaleFun(loginWeixin)

    app.constant.hot_Finish = true


    if Account.tags.recharge_tag ~= "1" then

        login:setPosition(640,194)
    else

        login:setPosition(440,194)

    end

    local Button_Kuang = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Kuang")
    local img_dui = cc.uiloader:seekNodeByNameFast(self.scene, "img_dui")
    local Button_User = cc.uiloader:seekNodeByNameFast(self.scene, "Button_User")

    if img_dui ~= nil then
        img_dui:setVisible(isSelect)
    end
    if Button_Kuang ~= nil then
        Button_Kuang:onButtonClicked(
        function ()
            local isVisible = not isSelect
            img_dui:setVisible(isVisible)
            isSelect = img_dui:isVisible()
        end)
    end
    if Button_User ~= nil then
        Button_User:onButtonClicked(
        function ()
            self:showUserLayer()
        end)
    end

    util.BtnScaleFun(Button_User)
    -- Button_Kuang:hide()
    -- img_dui:hide()
    -- Button_User:hide()


    function callback(param)

      --  print("shareWeixin:gameid--")

        self.info = param

        self:RequestFromWChat()

    end
        -- if device.platform == "ios" then

        -- luaoc.callStaticMethod("WeixinSDK", "loginReady", { callback = callback})

    if device.platform == "android" then

        luaj.callStaticMethod("app/WeixinSDK", "loginReady", { callback })

    end
end

function LoginScene:createLoginLayer()

    if app.constant.isOpening == true then
          return
    end

    self.loginLayer = cc.uiloader:load("Layer/Login/LoginLayer.json"):addTo(self)

    local popBoxNode = cc.uiloader:seekNodeByNameFast(self.loginLayer, "PopBoxNode")
    util.setMenuAni(popBoxNode)

    local title = cc.uiloader:seekNodeByNameFast(self.loginLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/Logon/Login_Logo.png",cc.rect(0,0,144,37))
    title:setSpriteFrame(frame)

    local close = cc.uiloader:seekNodeByNameFast(self.loginLayer, "Close")
    close:onButtonClicked(function ()
        self:destroyLoginLayer()
        sound_common.cancel()
    end)

    util.BtnScaleFun(close)

    self.loginLayer.downList = cc.uiloader:seekNodeByNameFast(self.loginLayer, "DownList");
    self.loginLayer.downList:onButtonClicked(handler(self, self.showAccountList))

    self.loginLayer.upList = cc.uiloader:seekNodeByNameFast(self.loginLayer, "UpList");
    self.loginLayer.upList:onButtonClicked(handler(self, self.hideAccountList))

    self.loginLayer.accountList = cc.uiloader:seekNodeByNameFast(self.loginLayer, "AccountList");
    self:initAccountList()

    self.loginLayer.rememberPassword = cc.uiloader:seekNodeByNameFast(self.loginLayer, "RememberPassword");

    local accountInputPanel = cc.uiloader:seekNodeByNameFast(self.loginLayer, "AccountInputPanel")
    self.loginLayer.accountInput = util.createInput(accountInputPanel, { color = cc.c4b(255,255,255, 255) })
    local passwordInputPanel = cc.uiloader:seekNodeByNameFast(self.loginLayer, "PasswordInputPanel")
    self.loginLayer.passwordInput = util.createInput(passwordInputPanel, { password = true, color = cc.c4b(255,255,255, 255) })
    if self.class.accountHistory[1] then
        self.loginLayer.accountInput:setString(self.class.accountHistory[1].account)
        self.loginLayer.passwordInput:setString(self.class.accountHistory[1].password)
    end

    local deletePassword = cc.uiloader:seekNodeByNameFast(self.loginLayer, "DeletePassword");
    deletePassword:onButtonClicked(function ()
        self.loginLayer.passwordInput:setString("")
    end)

    local login = cc.uiloader:seekNodeByNameFast(self.loginLayer, "Button_Login");
    login:onButtonClicked(function (event)
        print("begin--click---0000--")
        local account, password = self.loginLayer.accountInput:getString(), self.loginLayer.passwordInput:getString()
        self:login({
            channel = app.constant.channel_game,
            account = account,
            password = password,
        })
    end)

    util.BtnScaleFun(login)

    local regist = cc.uiloader:seekNodeByNameFast(self.loginLayer, "Button_Regist");
    regist:onButtonClicked(function (event)
        self:destroyLoginLayer()
        self:createRegisterLayer()
    end)

    util.BtnScaleFun(regist)


end

function LoginScene:createRegisterLayer()
    self.registerLayer = cc.uiloader:load("Layer/Login/RegisterLayer.json"):addTo(self)

    -- title
    local title = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/Logon/Regist_Logo.png",cc.rect(0,0,145,37))
    title:setSpriteFrame(frame)

    -- close self
    local close = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Close")
    close:onButtonClicked(function ()
        self:destroyRegisterLayer()
        sound_common.cancel()
    end)

    local text_Zengsong = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Text_zengsong")

    -- password show or not
    local accountInputPanel = cc.uiloader:seekNodeByNameFast(self.registerLayer, "AccountInputPanel")
    self.registerLayer.accountInput = util.createInput(accountInputPanel, {color = cc.c4b(255,255,255, 255)})

    -- if DEVELOPMENT then
    --     self.registerLayer.accountInput:setString("account" .. os.time())
    -- end

    local passwordInputPanel = cc.uiloader:seekNodeByNameFast(self.registerLayer, "PasswordInputPanel")
    local passwordInput = util.createInput(passwordInputPanel, {password = true})
    self.registerLayer.passwordInput = passwordInput
    passwordInput:setTextColor(cc.c4b(255,255,255, 255))
    -- if DEVELOPMENT then
    --     self.registerLayer.passwordInput:setString("password" .. os.time())
    -- end

    local showPassword = cc.uiloader:seekNodeByNameFast(self.registerLayer, "ShowPassword")
    showPassword:onButtonClicked(function ()
        passwordInput:setPasswordEnabled(showPassword:isButtonSelected())
        passwordInput:setString(passwordInput:getString())
    end)


--modify by whb 161213
    local iphoneInputPanel = cc.uiloader:seekNodeByNameFast(self.registerLayer, "IphoneInputPanel")
    local iphoneInput = util.createInput(iphoneInputPanel)
    self.registerLayer.iphoneInput = iphoneInput

     local codeInputPanel = cc.uiloader:seekNodeByNameFast(self.registerLayer, "CodeInputPanel")
    local codeInput = util.createInput(codeInputPanel)
    self.registerLayer.codeInput = codeInput

     local btn_SendMess = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Button_Send")
    btn_SendMess:onButtonClicked(handler(self, self.SendMessage))
     self.registerLayer.btn_SendMess = btn_SendMess
    --  local btn_ReSend = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Button_ReSend")
    -- btn_ReSend:onButtonClicked(handler(self, self.SendMessage))
    -- self.registerLayer.btn_ReSend = btn_ReSend
    local txt_Count = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Text_Count")
    self.registerLayer.txt_Count = txt_Count

    if app.constant.countTime > 0 and codeScheduler ~= nil then

         local strTime =  "重发(" .. app.constant.countTime .. "秒)"
         self.registerLayer.txt_Count:setString(strTime)

        self:BeginInCount()

    end

--modify end

    local register = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Register")
    register:onButtonClicked(handler(self, self.registerOnClick))

     local Image_1 = cc.uiloader:seekNodeByNameFast(self.registerLayer, "Image_1")

     if Account.tags.recharge_tag == "1" then

        if text_Zengsong then
            text_Zengsong:show()
        end

    else

        if text_Zengsong then
            text_Zengsong:hide()
        end

        if Image_1 then

            Image_1:setTexture("Image/Logon/Regist_BGtest.png")
            showPassword:setPositionY(-10)
            local xI = showPassword:getPositionX()
            showPassword:setPositionX(xI+80)
            btn_SendMess:hide()
            local x0 = Image_1:getPositionX()
            Image_1:setPositionX(x0+80)
            accountInputPanel:setPositionY(70.40)
            local x = accountInputPanel:getPositionX()
            accountInputPanel:setPositionX(x+80)
            passwordInputPanel:setPositionY(-13.19)
            local x2 = passwordInputPanel:getPositionX()
            passwordInputPanel:setPositionX(x2+80)
            register:setPositionY(-185)
            iphoneInputPanel:hide()
            codeInputPanel:hide()
            txt_Count:hide()

        end

    end

end

--用户协议界面
function LoginScene:showUserLayer()

    if app.constant.isOpening == true then
      return
    end

    sound_common.menu()
    local userLayer = cc.uiloader:load("Layer/Lobby/UserLayer.json"):addTo(self.scene)
    local popBoxNode = cc.uiloader:seekNodeByNameFast(userLayer, "PopBoxNode")
    util.setMenuAni(popBoxNode)
    self.scene.userLayer = userLayer

    local title = cc.uiloader:seekNodeByNameFast(userLayer, "Image_Title")
    local s = display.newSprite("Image/Lobby/img_UserTitle.png")
    local frame = s:getSpriteFrame()
    title:setSpriteFrame(frame)
    local ScrollView_5 = cc.uiloader:seekNodeByNameFast(userLayer, "ScrollView_5")
    local Text_14 = cc.uiloader:seekNodeByNameFast(userLayer, "Text_14")
    ScrollView_5:hide()

    local close = cc.uiloader:seekNodeByNameFast(userLayer, "Close")
    :onButtonClicked(
        function ()

          userLayer:removeFromParent()
          userLayer = nil
          self.scene.userLayer = nil
          sound_common:cancel()

        end)
    util.BtnScaleFun(close)

    scheduler.performWithDelayGlobal(
        function ()
             local ScrollView_5 = cc.uiloader:seekNodeByNameFast( self.scene.userLayer, "ScrollView_5")
             local Text_14 = cc.uiloader:seekNodeByNameFast( self.scene.userLayer, "Text_14")
             ScrollView_5:show()
             Text_14:setString(strUser)
        end, 0.4)
end

function LoginScene:destroyLoginLayer()
    self.loginLayer:removeFromParent(true)
    self.loginLayer = nil
end

function LoginScene:destroyRegisterLayer()
    --self.scene.accountInput:setTouchEnabled(true)
    --self.scene.passwordInput:setTouchEnabled(true)

    self.registerLayer:removeFromParent(true)
    self.registerLayer = nil
end

function LoginScene:updateCount()

    app.constant.countTime = app.constant.countTime - 1

    if self.registerLayer == nil then
        return
    end

    local strTime =  "重发(" .. app.constant.countTime .. "秒)"
    self.registerLayer.txt_Count:setString(strTime)

    if app.constant.countTime <= 0 then

        scheduler.unscheduleGlobal(codeScheduler)
        codeScheduler = nil
        app.constant.countTime = 60
        -- if self.registerLayer.btn_ReSend ~= nil then
        --     self.registerLayer.btn_ReSend:show()
        -- end
        if self.registerLayer.btn_SendMess ~= nil then
            self.registerLayer.btn_SendMess:show()
        end

        self.registerLayer.txt_Count:setString("重发(60秒)")
        self.registerLayer.txt_Count:hide()

    end
    --print("11111----")
end

function LoginScene:BeginInCount()

    if self.registerLayer.btn_SendMess ~= nil then
            self.registerLayer.btn_SendMess:hide()
        end

        -- if self.registerLayer.btn_ReSend ~= nil then
        --     self.registerLayer.btn_ReSend:hide()
        -- end

        if codeScheduler ~= nil then
                scheduler.unscheduleGlobal(codeScheduler)
                codeScheduler = nil
        end

        if self.registerLayer.txt_Count ~= nil then
            self.registerLayer.txt_Count:show()
        end

        codeScheduler = scheduler.scheduleGlobal(handler(self, self.updateCount), 1.0)

end

function LoginScene:SendMessage()

   local iphoneInput = self.registerLayer.iphoneInput
   local iphone = iphoneInput:getString()

   local err
    if not iphone or #iphone == 0 then
        err = app.lang.iphone_nil
    elseif #iphone ~= 11 or string.find(iphone, "[%D]") then
        print("iphone:" .. tostring(iphone))
        err = app.lang.iphone_error
    end

    iphoneInput:setTouchEnabled(false)

     if err then

        ErrorLayer.new(err, nil, nil, function ()

            iphoneInput:setTouchEnabled(true)

        end):addTo(self)
    else

         self:BeginInCount()

         self:getCode({

                mobile = iphone,
            },
            app.lang.register_loading, app.lang.getCode_error, function ()

            iphoneInput:setTouchEnabled(true)

        end)

    end


end

function LoginScene:registerOnClick()
    local accountInput, passwordInput, iphoneInput, codeInput = self.registerLayer.accountInput, self.registerLayer.passwordInput, self.registerLayer.iphoneInput, self.registerLayer.codeInput
    local account, password, iphone, code = accountInput:getString(), passwordInput:getString(), iphoneInput:getString(), codeInput:getString()

    local err = self:checkInput(account, password, iphone, code, true)

    err = self:checkInput(account, password)

    -- if Account.tags.recharge_tag == "1" then

    --     err = self:checkInput(account, password, iphone, code, true)
    --    -- err = self:checkInput(account, password)

    -- else

    --     err = self:checkInput(account, password)

    -- end

    app.constant.isRelogin = true

    iphoneInput:setTouchEnabled(false)
    codeInput:setTouchEnabled(false)

    if err then
        accountInput:setTouchEnabled(false)
        passwordInput:setTouchEnabled(false)

        ErrorLayer.new(err, nil, nil, function ()
            accountInput:setTouchEnabled(true)
            passwordInput:setTouchEnabled(true)
            iphoneInput:setTouchEnabled(true)
            codeInput:setTouchEnabled(true)
        end):addTo(self)
    else
        accountInput:setTouchEnabled(false)
        passwordInput:setTouchEnabled(false)

        self:auth({
                cmd = "register",
                channel = app.constant.channel_game,
                account = account,
                password = password,

 --modify by whb 161019
                app_channel = CONFIG_APP_CHANNEL,
                --add 1221
                mobile = iphone,
                code = code
--modify end
            },
            app.lang.register_loading, app.lang.register_error, function ()
            accountInput:setTouchEnabled(true)
            passwordInput:setTouchEnabled(true)
            iphoneInput:setTouchEnabled(true)
            codeInput:setTouchEnabled(true)
        end)
    end
end

function LoginScene:login(params)

    self:hideAccountList()

    local accountInput, passwordInput
    if self.loginLayer then
        accountInput, passwordInput = self.loginLayer.accountInput, self.loginLayer.passwordInput
        accountInput:setTouchEnabled(false)
        passwordInput:setTouchEnabled(false)
    end

    app.constant.isRelogin = true

    params.cmd = "login"

    --add by whb 161019
    params.app_channel = CONFIG_APP_CHANNEL

    print("click--login----")
    --add by end
    self:auth(params, app.lang.login_loading, app.lang.login_error, function ()
        if self.loginLayer then
            accountInput:setTouchEnabled(true)
            passwordInput:setTouchEnabled(true)
        end
    end)
end

function LoginScene:loginWeixin()

    if isSelect == false then
        ErrorLayer.new(app.lang.not_login, nil, nil, nil):addTo(self)
        return
    end

    app.constant.isRelogin = true

    local progressLayer = ProgressLayer.new(app.lang.login_loading, nil, function ()
                ErrorLayer.new(app.lang.network_disabled, nil, nil, errorLayerCallBack):addTo(self)
            end)
        :addTo(self)

--test get weixin headImage
    local getWChatImage = function (access_token, openid)

        local url = "https://api.weixin.qq.com/sns/userinfo?access_token="..access_token.."&openid="..openid

        print("url:"..url)
        local request = network.createHTTPRequest(function (event)
            local result = web.checkResponse(event)
            print("result:"..result)
            if result == 0 then
                return
            elseif result == -1 then
                return
            end

            local response = event.request:getResponseString()
            response = json.decode(response)
            local nick = nil
            local headIcon = nil
            local sex = nil
            if response.headimgurl then
                headIcon = response.headimgurl
            end

            if response.nickname then
                nick = response.nickname
            end

            if response.sex then
                sex = response.sex
            end


           print("wChat response:", response)
           print("wChat:info-", nick..":"..headIcon .. ":" .. sex)
           -- local len = #nick
           --  for i=1,len do

           --      local curByte = string.byte(nick, i)
           --      print("nick-byte:", i .. ":" .. curByte)

           --  end

            app.constant.wChatInfo.icon = headIcon
            -- if device.platform == "android" then

            --     app.constant.wChatInfo.nick = util.filter_spec_chars(nick)

            -- else

                app.constant.wChatInfo.nick = nick

            --end

            print("new--nickname---", app.constant.wChatInfo.nick)
            if sex == 1 then
                sex = 2
            else
                sex = 1
            end
            app.constant.wChatInfo.sex = sex

        end, url, "GET")
        request:start()
      end

    --如果已经登陆过就直接登陆不在调用第三方SDK
    local refresh_token = util.read_wx_refresh_token()
    if refresh_token ~= nil and refresh_token ~= "" then

        local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
        local appid = platConfig.wChat_Appid
        local grant_type = "refresh_token"
        local url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=" .. appid .. "&grant_type=" .. grant_type .. "&refresh_token=" .. refresh_token

        local request = network.createHTTPRequest(
            function (event)
                local result = web.checkResponse(event)
                print("result:"..result)
                if result == 0 then
                    return
                elseif result == -1 then
                    return
                end

                local param = event.request:getResponseString()
                param = json.decode(param)

                if param.errcode ~= nil then
                    --抹掉refresh_token
                    util.write_wx_refresh_token()
                    return self:loginWeixin()
                end

                --local result = param.result or 0
                local access_token = param.access_token or ""
                local expires_in = param.expires_in or 0
                local refresh_token = param.refresh_token or ""
                local openid = param.openid or ""

                if progressLayer ~= nil then
                    ProgressLayer.removeProgressLayer(progressLayer)
                    progressLayer = nil
                end

                 print("loginWeixin", result, access_token, expires_in, refresh_token, openid)
                if #openid > 0 and #access_token > 0 then
                    self:login({
                        channel = app.constant.channel_weixin,
                        account = openid,
                        password = access_token,
                        expires_in = expires_in,
                        refresh_token = refresh_token,
                    })

                     app.constant.isReChangeNick = false

                     app.constant.isWchatLogin = true
                     getWChatImage(access_token, openid)
                --end

                end

                --获取微信名称头像之后登陆游戏
                --getWChatImage(access_token,expires_in,refresh_token,openid)

            end, url, "GET")

        request:start()
        return
    end

    function callback(param)
        if device.platform == "android" then
            param = json.decode(param)
            if param.result == 1002 then
                param.result = 0
            end
        end

        if progressLayer ~= nil then
            ProgressLayer.removeProgressLayer(progressLayer)
            progressLayer = nil
        end

        local result = param.result or 0
        local access_token = param.access_token or ""
        local expires_in = param.expires_in or 0
        local refresh_token = param.refresh_token or ""
        local openid = param.openid or ""
        print("loginWeixin", result, access_token, expires_in, refresh_token, openid)
        if result == 0 and #openid > 0 and #access_token > 0 then
            self:login({
                channel = app.constant.channel_weixin,
                account = openid,
                password = access_token,
                expires_in = expires_in,
                refresh_token = refresh_token,
            })

            --refresh_token 记录在本地
             util.write_wx_refresh_token(refresh_token)

             app.constant.isReChangeNick = true
             app.constant.isWchatLogin = true
             getWChatImage(access_token, openid)
        --end

        end
    end

    if device.platform == "ios" then
        luaoc.callStaticMethod("WeixinSDK", "login", { callback = callback})
    elseif device.platform == "android" then
        luaj.callStaticMethod("app/WeixinSDK", "login", { callback })
    end
end

function LoginScene:loginQQ()
    function callback(param)
        if device.platform == "android" then
            param = json.decode(param)
            if param.result == 1002 then
                param.result = 0
            end
        end

        param = checktable(param)
        local result = param.result or 0
        local id = param.id or ""
        local token = param.token or ""
        local time = param.time or 0
        print("loginQQ", result, id)
        if result == 0 and #id > 0 then
            self:login({
                channel = app.constant.channel_qq,
                account = id,
                password = token,
                time = time,
            })
        end
    end

    if device.platform == "ios" then
        luaoc.callStaticMethod("TencentSDK", "login", { callback = callback })
    elseif device.platform == "android" then
        luaj.callStaticMethod("app/QQSDK", "login", { callback })
    end
end

function LoginScene:registerXPush()
    function callback(param)
        if device.platform == "android" then
            param = json.decode(param)
        end

        param = checktable(param)
        local result = param.result
        print("registerXPush =", result)

    end

    local params = {}

     params.account = Account.uid .. ""

     print("registerXPush-uid:",Account.uid)


    if device.platform == "ios" then

         params.callback = callback
         luaoc.callStaticMethod("XgSdk", "registerXPush", params)

    elseif device.platform == "android" then

        local str = json.encode(params)
        luaj.callStaticMethod("app/XingePush", "registerXPush", { str, callback })

    end
end

--[[
    params 必须有:
    cmd : register, login 第三方渠道只能用login
    channel : game, qq, weixin 等渠道
    account : 账号
    password : 密码
--]]
function LoginScene:auth(params, loading, failure, errorLayerCallBack)
    if params.cmd == "login" and (params.channel == app.constant.channel_game or #params.account == 0) then
        local err = self:checkInput(params.account, params.password)
        if err then
            app.constant.autoLogin = false
            ErrorLayer.new(err, nil, nil, errorLayerCallBack):addTo(self)
            return
        end
    end


    local progressLayer = ProgressLayer.new(loading, nil, function ()
                ErrorLayer.new(app.lang.network_disabled, nil, nil, errorLayerCallBack):addTo(self)
                print("LoginScene:auth----")
                GateNet.disconnect()
            end)
        :addTo(self)

    function loginCallback(ok, msg)
        if not ok then
            print("failed:", failure .. (msg or ""))
  --modify by whb

            if msg ~= nil then
                ErrorLayer.new( msg, nil, nil, errorLayerCallBack):addTo(self)
            else
                ErrorLayer.new(failure .. (msg or ""), nil, nil, errorLayerCallBack):addTo(self)
            end
  --end

           -- ErrorLayer.new(failure .. (msg or ""), nil, nil, errorLayerCallBack):addTo(self)
            ProgressLayer.removeProgressLayer(progressLayer)
            progressLayer = nil

            app.constant.autoLogin = false
        else
            GateNet.connect(function (ok, msg)
                if ok then
                    if params.channel == "game" then
                        if self.loginLayer then
                            if self.loginLayer.rememberPassword:isButtonSelected() then
                                app.constant.autoLogin = true
                                self:addAccountHistory(params.account, params.password)
                            else
                                app.constant.autoLogin = false
                                self:addAccountHistory(params.account, "")
                            end
                        else
                            if app.constant.autoLogin then

                            else

                            end
                        end
                        self:saveAccountHistory()

                    end
                    -- enter Lobby
                    ProgressLayer.removeProgressLayer(progressLayer)
                    progressLayer = nil

                    local PRMessage = require("app.net.PRMessage")
                    PRMessage.PrivateRoomConfigReq()

                    --注册启动推送
                    self:registerXPush()

                    app:enterScene("LobbyScene", nil, "fade", 0.5)
                else
                   -- if tostring(msg) ~= "104" then
                   print("login_error = ",msg)
                        ProgressLayer.removeProgressLayer(progressLayer)
                        progressLayer = nil
                        ErrorLayer.new(app.lang.gate_error .. (msg or ""), nil, nil, errorLayerCallBack):addTo(self)
                    --end

                end
            end)
        end
    end

    print("LoginNet.auth---getServerTime--")
    LoginNet.auth(loginCallback, params)
end

function LoginScene:getCode(params, loading, failure, errorLayerCallBack)


    local progressLayer = ProgressLayer.new(loading, nil, function ()
                ErrorLayer.new(app.lang.network_disabled, nil, nil, errorLayerCallBack):addTo(self)
                GateNet.disconnect()
            end)
        :addTo(self)

    function getCodeCallback(ok, msg)
        if not ok then
            print("failed:", failure .. (msg or ""))

            if msg ~= nil then
                ErrorLayer.new( msg, nil, nil, errorLayerCallBack):addTo(self)
            else
                ErrorLayer.new(failure .. (msg or ""), nil, nil, errorLayerCallBack):addTo(self)
            end

            ProgressLayer.removeProgressLayer(progressLayer)
            progressLayer = nil
        else

            ErrorLayer.new(app.lang.sendCode_ok, nil, nil, errorLayerCallBack, 1):addTo(self)

            ProgressLayer.removeProgressLayer(progressLayer)
                    progressLayer = nil
        end
    end

    LoginNet.getCode(getCodeCallback, params)
end

function LoginScene:showAccountList()
    if not self.loginLayer or self.loginLayer.accountList:isVisible() then
        return
    end

    self.loginLayer.upList:show()
    self.loginLayer.downList:hide()
    self.loginLayer.accountList:show()

    self.loginLayer.accountInput:setTouchEnabled(false)
    self.loginLayer.passwordInput:setTouchEnabled(false)
end

function LoginScene:hideAccountList()
    if not self.loginLayer or not self.loginLayer.accountList:isVisible() then
        return
    end
    self.loginLayer.upList:hide()
    self.loginLayer.downList:show()
    self.loginLayer.accountList:hide()

    self.loginLayer.accountInput:setTouchEnabled(true)
    self.loginLayer.passwordInput:setTouchEnabled(true)
end

function LoginScene:checkInput(account, password, iphone, code, isRegister)
    local err
    if not account or #account == 0 then
        err = app.lang.account_nil
    elseif #account < 6 or #account > 20 or string.find(account, "[%W]") then
        err = app.lang.account_error
    elseif not password or #password == 0 then
        err = app.lang.password_nil
    elseif #password < 6 or #password > 20 or string.find(password, "[%W]") then
        err = app.lang.password_error
    elseif isRegister == true and (not iphone or #iphone == 0) then
        err = app.lang.iphone_nil
    elseif isRegister == true and (#iphone ~= 11 or string.find(iphone, "[%D]")) then
        err = app.lang.iphone_error
    elseif isRegister == true and (not code or #code == 0) then
        err = app.lang.code_nil
    elseif isRegister == true and (#code ~= 6 or string.find(code, "[%D]")) then
        err = app.lang.code_error
    end
    return err
end

function LoginScene:initAccountList()
    local list = self.loginLayer.accountList
    list:getScrollNode():removeAllChildren()
    list:scrollTo(list:getCascadeBoundingBox().x - 10, list:getCascadeBoundingBox().y - 320)

    local x = list:getCascadeBoundingBox().width / 2
    local height = list:getCascadeBoundingBox().height
    print("x:" .. x)
    print("height:" .. height)
    --hit item
    list:onScroll(function (event)
        if event.name == "clicked" then
            for i,v in ipairs(list:getScrollNode():getChildren()) do
                if v:hitTest(cc.p(event.x,event.y)) then
                    self:hideAccountList()
                    self.loginLayer.accountInput:setString(self.class.accountHistory[i].account)
                    self.loginLayer.passwordInput:setString(self.class.accountHistory[i].password)
                    break
                end
            end
        end
    end)

    if self.class.accountHistory then
        --dump(self.class.accountHistory)
        for i,v in ipairs(self.class.accountHistory) do

            local bg = display.newScale9Sprite("Image/Logon/inputbg.png", -420,250 - i * 86,cc.size(420, 82))
                :addTo(list:getScrollNode())
            bg:setAnchorPoint(0.5,0.5)

            local contentSize = bg:getContentSize()
            print("iiiiiii list:" .. contentSize.width)
            -- account name
            local label = display.newTTFLabel({
                text = v.account,
                size = 30,
                valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
                x = contentSize.width / 2,
                y = contentSize.height / 2,
                dimensions = cc.size(contentSize.width - 100, contentSize.height),
                color = cc.c4b(171,96,58, 255),
            })
            :addTo(bg)

            -- delete button
            cc.ui.UIPushButton.new({
                normal = "Image/Logon/delete_0.png",
                pressed = "Image/Logon/delete_1.png",
                disabled = "Image/Logon/delete_0.png",
            })
            :addTo(bg)
            :setPosition(contentSize.width - 40, contentSize.height / 2)
            :onButtonClicked(function()
                table.remove(self.class.accountHistory, i)
                self:initAccountList()
            end)
        end
    end
    print("children:" .. tostring(#list:getScrollNode():getChildren()))
end

function LoginScene:addAccountHistory(account, password)
    if not account or account == "" then
        return
    end

    if not self.class.accountHistory then
        self.class.accountHistory = {}
    end

    local history = self.class.accountHistory
    local old
    for i,v in ipairs(history) do
        if v.account == account then
            v.password = password
            old = v
            table.remove(history, i)
            break
        end
    end

    old = old or {account = account, password = password}
    table.insert(history, 1, old)

    for i=11,#history do
        table.remove(history)
    end
end

function LoginScene:saveAccountHistory()
    if not self.class.accountHistory then
        return
    end

    local file = io.open(device.writablePath .. app.constant.account_history, "w+")
    if not file then
        return
    end

    file:write(tostring(util.getVersion()) .. "\n")
    for i,v in ipairs(self.class.accountHistory) do
        if i > app.constant.account_history_upper then
            break
        end

        local record = self.class.accountHistory[i]
        file:write(record.account .. "=" .. encodePwd(record.password) .. "\n")
    end
    file:close()
end

function LoginScene:readAccountHistory()
    self.class.accountHistory = {}

    local file = io.open(device.writablePath .. app.constant.account_history, "r")
    if not file then
        file = io.open(device.writablePath .. app.constant.account_history, "w")
        file:close()
        return
    end

    local clear, checked
    for line in file:lines() do
        if not checked then
            if line ~= tostring(util.getVersion()) then
                clear = true
                break
            end
            checked = true
        end

        local account, password = string.match(line, "([^=]*)=(.*)")
        if account and account ~= "" then
            table.insert(self.class.accountHistory, {
                account = account,
                password = decodePwd(password),
            })
        end
    end
    file:close()

    if clear then
        file = io.open(device.writablePath .. app.constant.account_history, "w+")
        file:close()
    end
end

function G_RequestFromWChat(info)

 local gameid, roomid, uid, session, tableid, seatid, password

    if device.platform == "android" then
        param = json.decode(info)
        gameid = param.gameid
        roomid = param.roomid
        uid = param.uid
        session = param.session
        tableid = param.tableid
        seatid = param.seatid
        password = param.password
       -- print("G_RequestFromWChat:",param.gameid)
    end

    if gameid == 0 or gameid == "0" or uid == 0 or uid =="0" then

        return

    end


     local roomNid = tonumber(roomid)
    if roomNid == 0 then

       -- saveLoginfo("RequestFromWChatce------" .. uid)

         app.constant.isInvite = true

         app.constant.nChatUid = tonumber(uid)

         if  app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)

             return

         end

         print("RequestFromWChat:uid", uid)

         SetInvitation()

    else

         app.constant.isReuqestWchat = 1

         print("RequestFromWChat:", gameid, roomid, uid, session, tableid, seatid, password)

         app.constant.requestWchatInfo.session = tonumber(session)
         app.constant.requestWchatInfo.tableid = tonumber(tableid)
         app.constant.requestWchatInfo.password = password
         app.constant.requestWchatInfo.roomid = tonumber(roomid)
         app.constant.requestWchatInfo.gameid = tonumber(gameid)

          if app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)
             app.constant.isReuqestWchat = 2
             return

         end

         local scene = display.getRunningScene()

         print("RequestFromWChat:", scene.name)

         if scene.name == "LoginScene" then

           -- local account, password = scene.scene.accountInput:getString(), scene.scene.passwordInput:getString()

            local account,password = "",""

             if self.class.accountHistory[1] then

                    account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password
             end

            --saveLoginfo("account:,password:"..account.."p"..password)

            local astr = string.len(account)
            local pstr = string.len(password)

            if astr>0 and pstr>0 then

                    scene:login({
                    channel = app.constant.channel_game,
                    account = account,
                    password = password,
                })

            else

                --saveLoginfo("account:,password2222:")

                scene:loginWeixin()

            end


         elseif scene.name ~= "LobbyScene" and  scene.name ~= "RoomScene" then

             local curGameID =  app.constant.cur_GameID
             local cur_RoomID = app.constant.cur_RoomID

            if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                app.constant.isReuqestWchat = 0

                return

            end


             message.dispatchGame("room.LeaveGame", {})

             -- local session = msgMgr:get_room_session()
             -- message.sendMessage("game.LeaveRoomReq", {session=session})
             -- app:enterScene("LobbyScene", nil, "fade", 0.5)

         elseif scene.name == "RoomScene" then

             local curGameID =  app.constant.cur_GameID
             local cur_RoomID = app.constant.cur_RoomID

             if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                 app.constant.isReuqestWchat = 3
                 selectEnterGameScene()

             else

                 local session = msgMgr:get_room_session()
                 message.sendMessage("game.LeaveRoomReq", {session=session})
                 app:enterScene("LobbyScene", nil, "fade", 0.5)

                 app.constant.isReuqestWchat = 2

             end

         elseif scene.name == "LobbyScene" then

             app.constant.isReuqestWchat = 2

              setEnterScene()

         end
         -- if g_watching == false then

         --     util.CloseChannel()

         -- end

    end

end

function LoginScene:message(name, msg, ...)
end

function LoginScene:destroyLoadingLayer()

    print("clickloading-------")
    self.loadingLayer:removeFromParent(true)
    self.loadingLayer = nil

    if self.needRestart == true then

        print("restart game-----")

        self.needRestart = false

        app:restart()

    end
end

function LoginScene:setLoadingLayer()
   self.loadingLayer = cc.uiloader:load("Layer/Lobby/LoadingLayer.json"):addTo(self)

    local lastloadRand = cc.UserDefault:getInstance():getIntegerForKey("LoadRand")

    local sprite_Jump = cc.uiloader:seekNodeByNameFast(self.loadingLayer, "Sprite_Jump")
     :setTouchEnabled(true)

    local to1 = cc.ProgressTo:create(6, 0)

    local left = cc.ProgressTimer:create(cc.Sprite:create("Image/Lobby/img_LoadPro.png"))
      -- 设置进度计时的类型，这里是绕圆心
      left:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)

      local size = sprite_Jump:getContentSize()
      -- 设置显示位置
      left:setPosition(cc.p(size.width/2, size.height/2))
      -- 运行动作
      --left:runAction(cc.RepeatForever:create(to1))
      left:addTo(sprite_Jump)
      left:setReverseDirection(true)
      left:setPercentage(100)

      transition.execute(left, to1, {
        delay = 0,
        easing = nil,
        onComplete = function()
           if lastloadRand ~= nil and lastloadRand > 0 then
                util.clearActivityImage(self, 100+lastloadRand)
            end
            self:destroyLoadingLayer()
        end,
    })

     sprite_Jump:addNodeEventListener(cc.NODE_TOUCH_EVENT,
        function (event)
        --local x, y, prevX, prevY = event.x, event.y, event.prevX, event.prevY
            if event.name == "began" then
                sprite_Jump:setScale(0.9)
            elseif event.name == "ended" then
                sprite_Jump:setScale(1)
                if lastloadRand ~= nil and lastloadRand > 0 then
                    util.clearActivityImage(self, 100+lastloadRand)
                end
                self:destroyLoadingLayer()
            end

        return true
    end)
    local sprite_Gg = cc.uiloader:seekNodeByNameFast(self.loadingLayer, "Sprite_Gg")

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)

    local urlStr = platConfig.loadingImg[lastloadRand]
    local image = "Platform_Src/Image/loading.png"

    util.setActivityImage(sprite_Gg:getParent(), urlStr, sprite_Gg, image, 100+lastloadRand, nil, "loadingImage")

    sprite_Jump:setLocalZOrder(100)

   -- sprite_Gg:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.hideAccountList))

end

return LoginScene
