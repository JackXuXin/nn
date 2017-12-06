local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local UserMessage = require("app.net.UserMessage")
local util = require("app.Common.util")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local ProgressLayer = require("app.layers.ProgressLayer")
local ErrorLayer = require("app.layers.ErrorLayer")
local web = require("app.net.web")
local crypt = require("crypt")
local scheduler = require("framework.scheduler")
local Share = require("app.User.Share")
local sound_common = require("app.Common.sound_common")

local guideInfo = require("app.Guide")

local PlatConfig = require("app.config.PlatformConfig")

local Account = app.userdata.Account

local opened = false
local geted = false
local getServerTimeBack = false

local progressLayer

--查询签到、补助结果
local QueryInfoData = {}
--获取服务器时间
local ServerTime = nil

local function closeProgressLayer()
    if not progressLayer then
        return
    end
    ProgressLayer.removeProgressLayer(progressLayer)
    progressLayer = nil
end

local function addProgressLayer(parent, text)
    if progressLayer then
        closeProgressLayer()
    end
    local f
    if text then
        f = function() 
            ErrorLayer.new(text):addTo(parent)
        end
    else
        f = function() end
    end
    progressLayer = ProgressLayer.new(app.lang.default_loading, app.constant.network_loading, f):addTo(parent)
end

function LobbyScene:showFreeGold()
    sound_common.menu()
    print("showFreeGold:------")
    --add by whb 0918
    self:closeGuideLayer("guide_FreeGold")
    --add end
    QueryInfoData = {}
    addProgressLayer(self, app.lang.network_disabled)

    local freeLayer = cc.uiloader:load("Platform_Src/FreeGoldLayer.json"):addTo(self.scene)

    self.scene.freeLayer = freeLayer

    self.scene.freeLayer.panel = cc.uiloader:seekNodeByNameFast(freeLayer, "Panel_List")
    self.scene.freeLayer.panel:setVisible(false)

--modify by whb 0324
    local Text_9 = cc.uiloader:seekNodeByNameFast(freeLayer, "Text_9")
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    Text_9:setString(platConfig.freeGoldLayer_Text_9)

    local Text_12 = cc.uiloader:seekNodeByNameFast(freeLayer, "Text_12")
    Text_12:hide()
--modify end

    -- cc.uiloader:seekNodeByNameFast(freeLayer, "Title")
    --     :setString(app.lang.free_gold)
    local title_sprite = cc.uiloader:seekNodeByNameFast(freeLayer, "Image_Title")
    local s = display.newSprite("Image/FreeGold/freegold_title.png")
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(freeLayer, "Close")
        :onButtonClicked(function ()

            self:onFreeGoldRemoved()
            --add by whb 0914
            self:addGuideLayer(guideInfo.guideMenu[1])
            --add end

        end)

    local isShow = false

    local popBoxNode = cc.uiloader:seekNodeByNameFast(freeLayer, "PopBoxNode")
    popBoxNode:setScale(0)
    transition.scaleTo(popBoxNode, {
        scale = 1, 
        time = app.constant.lobby_popbox_trasition_time,
        onComplete = function ()
            opened = true
            if geted and getServerTimeBack then
                self:updateFreeGoldUI()
                self.scene.freeLayer.panel:setVisible(true)

            end
        end
    })

    self.scene.freeLayer.btnSign = cc.uiloader:seekNodeByNameFast(freeLayer, "Button_Sign")
        :onButtonClicked(handler(self, self.showSign))

    -- cc.uiloader:seekNodeByNameFast(freeLayer, "Button_Promote")
    --     :onButtonClicked(function ()
    --             self:onFreeGoldRemoved()
    --             self:showHonor()
    --         end)
    self.scene.freeLayer.btnGetGold = cc.uiloader:seekNodeByNameFast(freeLayer, "Button_Give")
    self.scene.freeLayer.btnGetGold:onButtonClicked(function ()
            --self:showGetGold(2000)
            UserMessage.GrantReq()
        end)
    cc.uiloader:seekNodeByNameFast(freeLayer, "Button_Atten")
        :onButtonClicked(function ()
                self:onFreeGoldRemoved()
                Share.createLobbyAttenLayer():addTo(self.scene)
            end)
    cc.uiloader:seekNodeByNameFast(freeLayer, "Button_Share")
        :onButtonClicked(function ()
                self:onFreeGoldRemoved()
                Share.createLobbyShareLayer():addTo(self.scene)
            end)
    -- self.scene.freeLayer.textSignGold = cc.uiloader:seekNodeByNameFast(freeLayer, "AtlasLabel_Sign")
    -- self.scene.freeLayer.textReliefGold = cc.uiloader:seekNodeByNameFast(freeLayer, "AtlasLabel_Give")
    self.scene.freeLayer.textReliefLeftTimes = cc.uiloader:seekNodeByNameFast(freeLayer, "AtlasLabel_LeftTimes")
    -- self.scene.freeLayer.textShareGold = cc.uiloader:seekNodeByNameFast(freeLayer, "AtlasLabel_Share")

    UserMessage.FreeGoldQueryReq()

    web.getServerTime(function (time)

        ServerTime = os.date("*t", time)

        dump(ServerTime)

        getServerTimeBack = true
        if geted and opened then
            self:updateFreeGoldUI()
            self.scene.freeLayer.panel:setVisible(true)
        end

    end)

end


function LobbyScene:updateFreeGoldUI()

    -- self.scene.freeLayer.textSignGold:setString(tostring(QueryInfoData.signin_gold or 0))
    -- self.scene.freeLayer.textReliefGold:setString(tostring(QueryInfoData.grant_gold or 0))
    -- self.scene.freeLayer.textShareGold:setString(tostring(QueryInfoData.share_gold or 0))

    if QueryInfoData.signin_today then

        self.scene.freeLayer.btnSign:setButtonImage("normal", "Image/FreeGold/btn_signed_0.png", true)
        self.scene.freeLayer.btnSign:setButtonImage("pressed", "Image/FreeGold/btn_signed_1.png", true)

    end

    -- test
    QueryInfoData.residual_grant_count = QueryInfoData.residual_grant_count or 0
    if QueryInfoData.residual_grant_count <= 0 then
        self.scene.freeLayer.btnGetGold:setButtonEnabled(false)
        self.scene.freeLayer.textReliefLeftTimes:setVisible(false)
    else
        self.scene.freeLayer.textReliefLeftTimes:setString(tostring(QueryInfoData.residual_grant_count))
    end

     self:addGuideLayer(guideInfo.guideMenu[2])
end

function LobbyScene:showSign()

     --add by whb 0919
     self:closeGuideLayer("guide_Sign")
     --add end

    local signLayer = cc.uiloader:load("Layer/Lobby/SignLayer.json"):addTo(self.scene)
    self.scene.signLayer = signLayer

    -- cc.uiloader:seekNodeByNameFast(signLayer, "Title")
    --     :setString(app.lang.sign)

    local title_sprite = cc.uiloader:seekNodeByNameFast(signLayer, "Image_Title")
    local s = display.newSprite("Image/FreeGold/sign_title.png")
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(signLayer, "Close")
        :onButtonClicked(function ()
            signLayer:removeFromParent()
            self.scene.signLayer = nil
            opened = false
            geted = false
        end)

    local popBoxNode = cc.uiloader:seekNodeByNameFast(signLayer, "PopBoxNode")
    popBoxNode:setScale(0)
    transition.scaleTo(popBoxNode, {
        scale = 1, 
        time = app.constant.lobby_popbox_trasition_time,
        onComplete = function ()
            
        end
    })

    --local dayOf = os.date("*t")
    --dump(dayOf)
    local _month = ServerTime.month
    cc.uiloader:seekNodeByNameFast(signLayer, "Text_Month")
        :setString(tostring(_month) .. "月")

    cc.uiloader:seekNodeByNameFast(signLayer, "AtlasLabel_Days")
        :setString(tostring(QueryInfoData.continuous_signin_count or 0))

    local panelSign = cc.uiloader:seekNodeByNameFast(signLayer, "Panel_Sign")
    local panelSignedList = cc.uiloader:seekNodeByNameFast(signLayer, "Panel_SignList")
    --test
    -- QueryInfoData.signin_today = true
    -- QueryInfoData.signin_days = {1,12,13,16,20,22,23,25,27,28,30}

    if QueryInfoData.signin_today then
        self:displaySignList()
    else
        panelSign:setVisible(true)
        panelSignedList:setVisible(false)

        QueryInfoData.signin_gold = QueryInfoData.signin_gold or 0

        cc.uiloader:seekNodeByNameFast(signLayer, "Text_7")
        :setString("今日可领取" .. QueryInfoData.signin_gold .. "旺豆")

        cc.uiloader:seekNodeByNameFast(signLayer, "Button_Sign")
        :setButtonLabelString("normal","点击领取" .. QueryInfoData.signin_gold .. "旺豆")
        :onButtonClicked(function ()
            UserMessage.SignReq()
        end)
    end

end

function LobbyScene:displaySignList()
    local panelSign = cc.uiloader:seekNodeByNameFast(self.scene.signLayer, "Panel_Sign")
    local panelSignedList = cc.uiloader:seekNodeByNameFast(self.scene.signLayer, "Panel_SignList")
    -- body
    panelSign:setVisible(false)
    panelSignedList:setVisible(true)

    --本月多少天
    local daysOfMonth = os.date("%d",os.time({year=ServerTime.year,month=ServerTime.month+1,day=0}))
    --本月1号周几
    local wdayThisMonth = os.date("%w",os.time({year=ServerTime.year,month=ServerTime.month,day=1}))
    --今天几号
    local today = ServerTime.day

    for i = 0,daysOfMonth - 1 do
        local signedDay = cc.ui.UILabel.new({
            color = cc.c3b(42,42,42), 
            size = 26, 
            text = tostring(i + 1), 
        })
        :addTo(panelSignedList)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(cc.p((math.mod((wdayThisMonth + i), 7) - 3) * 124, (3 - math.floor((wdayThisMonth + i) / 7)) * 45))

        if i + 1 < tonumber(today) then
            signedDay:setTextColor(cc.c3b(255,50,0))
        end

        for k,v in pairs(QueryInfoData.signin_days) do
            if i + 1 == v then
                local signed = display.newSprite("Image/FreeGold/img_sign.png")
                signed:setPosition(cc.p((math.mod((wdayThisMonth + i), 7) - 3) * 124, (3 - math.floor((wdayThisMonth + i) / 7)) * 45))
                panelSignedList:addChild(signed)
            end
        end

    end
end

function LobbyScene:SigninInfoRep(msg)
    print("LobbyScene:SigninInfoRep")
    dump(msg)
    for k,v in pairs(msg) do
        QueryInfoData[k] = v
    end

    if self.scene.freeLayer ~= nil then

        geted = true
        if opened and getServerTimeBack then
            self:updateFreeGoldUI()
            if self.scene.freeLayer ~= nil then
                self.scene.freeLayer.panel:setVisible(true)
            end
        end
        closeProgressLayer()
    end

     self:IsShowWelfarePoint()

end

function LobbyScene:SigninRep(msg)
    print("LobbyScene:SigninRep")
    if msg.result == 0 then     --success
        self:showGetGold(tonumber(msg.addgold))

        local today = tonumber(ServerTime.day)
        QueryInfoData.signin_days = QueryInfoData.signin_days or {}
        dump(QueryInfoData.signin_days)
        table.insert(QueryInfoData.signin_days,today)
        dump(QueryInfoData.signin_days)
        self:displaySignList()

        QueryInfoData.continuous_signin_count = QueryInfoData.continuous_signin_count + 1
        cc.uiloader:seekNodeByNameFast(self.scene.signLayer, "AtlasLabel_Days")
            :setString(tostring(QueryInfoData.continuous_signin_count or 0))

        QueryInfoData.signin_gold = 0
        QueryInfoData.signin_today = true
        self:updateFreeGoldUI()

         --显示福利红点
        self:IsShowWelfarePoint()

    else    --fail
        ErrorLayer.new(app.lang.sign_error):addTo(self.scene)
    end

end

function LobbyScene.ShareGameRep(msg)
    print("LobbyScene.ShareGameRep--")

    if msg.result == 0 then
       
       QueryInfoData.share_gold = 0
       --显示福利红点
        self:IsShowWelfarePoint()

    end
    --dump(msg)
end

--是否显示福利红点
function LobbyScene:IsShowWelfarePoint()
    print("LobbyScene:Welf--")
    local isShow = false
    --print("signin_today,residual_grant_count,share_gold",QueryInfoData.signin_today,QueryInfoData.residual_grant_count,QueryInfoData.share_gold)
    if QueryInfoData.signin_today == false or QueryInfoData.residual_grant_count > 0 or tonumber(QueryInfoData.share_gold) > 0 then

       isShow = true

    end

    local btnFreeGold = cc.uiloader:seekNodeByNameFast(self.scene, "FreeGold")

    if btnFreeGold ~= nil then


        local Img_ChatTip_0 = cc.uiloader:seekNodeByNameFast(self.scene, "Img_ChatTip_0")

        if Img_ChatTip_0 ~= nil then

            Img_ChatTip_0:setVisible(isShow)

        end

    end

end


function LobbyScene:GetGrantRep(msg)
    print("LobbyScene:GetGrantRep")
    if msg.result == 0 then     --success
        self:showGetGold(tonumber(msg.addgold))

        msg.residual_grant_count = msg.residual_grant_count or 0
        if msg.residual_grant_count <= 0 then
            self.scene.freeLayer.btnGetGold:setButtonEnabled(false)
            self.scene.freeLayer.textReliefLeftTimes:setVisible(false)
        else
            self.scene.freeLayer.textReliefLeftTimes:setString(tostring(msg.residual_grant_count))
        end

        QueryInfoData.residual_grant_count = msg.residual_grant_count
       --显示福利红点
        self:IsShowWelfarePoint()

    elseif msg.result == 1 then
        ErrorLayer.new(app.lang.grant_error_1):addTo(self.scene)
    elseif msg.result == 2 then
        ErrorLayer.new(app.lang.grant_error_2):addTo(self.scene)
    else    --fail
        ErrorLayer.new(app.lang.grant_error):addTo(self.scene)
    end

end

function LobbyScene:showGetGold(gold)
    -- body
    local layer = display.newLayer()
    self.scene:addChild(layer)

    local bgSprite = display.newSprite("Image/HonorLayer/tip_service_bg.png")
    bgSprite:setPosition(cc.p(display.width / 2,display.height / 2))
    layer:addChild(bgSprite)

    local labelGet = cc.ui.UILabel.new({
            color = cc.c3b(255,255,255), 
            size = 36, 
            text = "恭喜获得：", 
        })
        :addTo(layer)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :pos(display.width / 2 + 20,display.height / 2 + 20)

    local goldIcon = display.newSprite("Image/FreeGold/FreeGold_GoldIcon.png")
    goldIcon:setPosition(cc.p(display.width / 2 - 100,display.height / 2 - 30))
    layer:addChild(goldIcon)

    local labelGold = cc.LabelAtlas:_create()
    labelGold:initWithString(
            tostring(gold or 0),
            "Image/FreeGold/FreeGold_Num.png",
            25,
            28,
            string.byte('0'))
    labelGold:setPosition(cc.p(display.width / 2 - 50,display.height / 2 - 30))
    labelGold:setAnchorPoint(cc.p(0,0.5))
    layer:addChild(labelGold)

    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            if layer then
                layer:removeFromParent()
                layer = nil
            end
            return false
        end
    end)

    local sequence = transition.sequence({cc.DelayTime:create(2.0),cc.FadeOut:create(0.5)})
    transition.execute(layer, sequence,{
        scale = 1, 
        time = app.constant.lobby_popbox_trasition_time,
        onComplete = function ()
            if layer then
                layer:removeFromParent()
                layer = nil
            end
        end
    })
    bgSprite:runAction(sequence:clone())
    goldIcon:runAction(sequence:clone())
    labelGold:runAction(sequence:clone())
    labelGet:runAction(sequence:clone())

end

function LobbyScene:onFreeGoldRemoved()
    self.scene.freeLayer:removeFromParent()
    self.scene.freeLayer = nil
    opened = false
    geted = false
end

function LobbyScene:getTxtLayer()

     textLayer = cc.uiloader:seekNodeByNameFast(self.scene, "Txt_Num")
     imgInfo = cc.uiloader:seekNodeByNameFast(self.scene, "Img_Info")

     print("LobbyScene:imgInfo:",imgInfo)

end

return LobbyScene