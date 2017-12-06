local MJPlayers = class("MJPlayers",function()
    return display.newSprite()
end)

local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local startButton
local hunButton
local dropButton
local leftCombin
local centerCombin
local rightCombin
local pengCombin
local gangCombin = {}
local angangCombin = {}
local flowerCombin = {}
local cardCombin = {}
local playerSex = {}

local leftHeadBg
local rightHeadBg
local topHeadBg
local bottomHeadBg

--local leftHeadFrameBg
--local rightHeadFrameBg
--local topHeadFrameBg
--local bottomHeadFrameBg

local playerHead = {} --头像的表
local playerImage_weixin = {} --微信头像的表

local leftHead
local rightHead
local topHead
local bottomHead

local leftName
local rightName
local topName
local bottomName

local leftNameBg
local rightNameBg
local topNameBg
local bottomNameBg

local leftScore
local rightScore
local topScore
local bottomScore

local leftReady
local rightReady
local topReady
local bottomReady

local bankerSprite
local tuoguanLayer
local tuoguanButton

local leftTuoguan
local rightTuoguan
local topTuoguan

local leftLostLine
local rightLostLine
local topLostLine
local downLostLine

local mopaoButton
local bumopaoButton

local leftMopao
local rightMopao
local topMopao
local bottomMopao

local leftHua
local rightHua
local topHua
local bottomHua

local flowerArray_L = {}
local flowerArray_R = {}
local flowerArray_U = {}
local flowerArray_D = {}

local leftEmoBtn
local rightEmoBtn
local topEmoBtn
local emoBgLayer

local lastPos
local cureHead
local eHeadInfo = { left = {}, right = {}, top = {}, bottom = {} }
local uidText

function MJPlayers:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 74))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 74))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_daocpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(60*(j-1), 48*(i-1), 60, 48))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_daocpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard_h.png")


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(56*(j-1), 69.2*(i-1), 56, 69.2))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_ready.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 71, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_ready.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitPlayer.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 307, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitPlayer.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_zhuang.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 49))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_zhuang.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitDian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 16, 16))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitDian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_EmptyDian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 10, 9))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_EmptyDian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tuoguan_zhi.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 117, 68))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tuoguan_zhi.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_LostLine.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 68, 45))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_LostLine.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/icon_mo.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 49))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/icon_mo.png")

    leftMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self,1000)
    rightMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self,1000)
    topMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self,1000)
    bottomMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self,1000)

    mopaoButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_mo_0.png", pressed = "ShYMJ/btn_mo_0.png" })
    :onButtonClicked(function()
            self:onMopaoButton(1)
     end)
    :pos(display.cx-150, display.bottom + 120)
    :hide()
    :addTo(self)

    util.BtnScaleFun(mopaoButton)

    bumopaoButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_bumo_0.png", pressed = "ShYMJ/btn_bumo_0.png" })
    :onButtonClicked(function()
            self:onMopaoButton(0)
     end)
    :pos(display.cx+150, display.bottom + 120)
    :hide()
    :addTo(self)

    util.BtnScaleFun(bumopaoButton)

    --add head bg
    local basePos_leftHead_x = 62
    local basePos_leftHead_y = display.cy+48
    local basePos_rightHead_x = display.width - 70
    local basePos_rightHead_y = display.cy+78
    --local basePos_topHead_x = 331
    local basePos_topHead_x = display.width-260
    local basePos_topHead_y = display.height - 70
    local basePos_bottomHead_x = 62
    local basePos_bottomHead_y = 210

    leftHeadBg = display.newSprite("ShYMJ/head_bg.png")
    :pos(basePos_leftHead_x,basePos_leftHead_y)
    :addTo(self)
    :hide()

    rightHeadBg = display.newSprite("ShYMJ/head_bg.png")
    :pos(basePos_rightHead_x,basePos_rightHead_y)
    :addTo(self)
    :hide()

    topHeadBg = display.newSprite("ShYMJ/head_bg.png")
    :pos(basePos_topHead_x,basePos_topHead_y)
    :addTo(self)
    :hide()

    bottomHeadBg = display.newSprite("ShYMJ/head_bg.png")
    :pos(basePos_bottomHead_x,basePos_bottomHead_y)
    :addTo(self)
    :hide()

    --frame bg
    local pos_y_offset = 15
    local scale_head = 0.42

    --add head
    leftHead = display.newSprite()
    :pos(basePos_leftHead_x,basePos_leftHead_y + pos_y_offset)
    :addTo(self)
    :scale(scale_head)

    rightHead = display.newSprite()
    :pos(basePos_rightHead_x,basePos_rightHead_y + pos_y_offset)
    :addTo(self)
    :scale(scale_head)

    topHead = display.newSprite()
    :pos(basePos_topHead_x,basePos_topHead_y + pos_y_offset)
    :addTo(self)
    :scale(scale_head)

    bottomHead = display.newSprite()
    :pos(basePos_bottomHead_x,basePos_bottomHead_y + pos_y_offset)
    :addTo(self)
    :scale(scale_head)

    pos_y_offset = 11
    leftLostLine = display.newSprite("#ShYMJ/img_LostLine.png")
    :pos(basePos_leftHead_x,basePos_leftHead_y + pos_y_offset)
    :addTo(self,leftHead:getLocalZOrder()+100)
    :hide()
   -- :scale(scale_head)

    rightLostLine = display.newSprite("#ShYMJ/img_LostLine.png")
    :pos(basePos_rightHead_x,basePos_rightHead_y + pos_y_offset)
    :addTo(self,rightHead:getLocalZOrder()+100)
    :hide()
    --:scale(scale_head)

    topLostLine = display.newSprite("#ShYMJ/img_LostLine.png")
    :pos(basePos_topHead_x,basePos_topHead_y + pos_y_offset)
    :addTo(self,topHead:getLocalZOrder()+100)
    :hide()
   -- :scale(scale_head)

    downLostLine = display.newSprite("#ShYMJ/img_LostLine.png")
    :pos(basePos_bottomHead_x,basePos_bottomHead_y + pos_y_offset)
    :addTo(self,bottomHead:getLocalZOrder()+100)
    :hide()
   --:scale(scale_head)

    pos_y_offset = -16

    leftNameBg = display.newSprite("ShYMJ/img_NameBg.png")
    :setAnchorPoint(cc.p(0.5,0.5))
    :pos(basePos_leftHead_x,basePos_leftHead_y + pos_y_offset)
    :addTo(self,10)
    :hide()
    leftName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    --:setRotation(90)
    :addTo(leftNameBg)
    :pos(39,9)
    leftName:setAnchorPoint(0.5, 0.5)

    rightNameBg = display.newSprite("ShYMJ/img_NameBg.png")
    :pos(basePos_rightHead_x,basePos_rightHead_y + pos_y_offset)
    :setAnchorPoint(cc.p(0.5,0.5))
    :addTo(self,10)
    :hide()
    rightName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    --:setRotation(270)
    :addTo(rightNameBg)
    :pos(39,9)
    rightName:setAnchorPoint(0.5, 0.5)

    topNameBg = display.newSprite("ShYMJ/img_NameBg.png")
    :pos(basePos_topHead_x,basePos_topHead_y + pos_y_offset)
    :setAnchorPoint(cc.p(0.5,0.5))
    :addTo(self,10)
    :hide()

    topName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    :addTo(topNameBg)
    :pos(39,9)
    topName:setAnchorPoint(0.5, 0.5)

    bottomNameBg = display.newSprite("ShYMJ/img_NameBg.png")
    :pos(basePos_bottomHead_x,basePos_bottomHead_y + pos_y_offset)
    :setAnchorPoint(cc.p(0.5,0.5))
    :addTo(self,10)
    :hide()

    bottomName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    :addTo(bottomNameBg)
    :pos(39,9)
    bottomName:setAnchorPoint(0.5, 0.5)

    pos_y_offset = -46
    local pos_x_offset = 0

    leftScore = cc.ui.UILabel.new({color=cc.c3b(243,217,38), size=19, text="", align=align})
    :pos(basePos_leftHead_x + pos_x_offset,basePos_leftHead_y + pos_y_offset)
    --:setRotation(90)
    :addTo(self)
    leftScore:setAnchorPoint(0.5, 0.5)

    rightScore = cc.ui.UILabel.new({color=cc.c3b(243,217,38), size=19, text="", align=align})
    :pos(basePos_rightHead_x + pos_x_offset,basePos_rightHead_y + pos_y_offset)
    --:setRotation(270)
    :addTo(self)
    rightScore:setAnchorPoint(0.5, 0.5)

    topScore = cc.ui.UILabel.new({color=cc.c3b(243,217,38), size=19, text="", align=align})
    :pos(basePos_topHead_x + pos_x_offset,basePos_topHead_y + pos_y_offset)
    :addTo(self)
    topScore:setAnchorPoint(0.5, 0.5)

    bottomScore = cc.ui.UILabel.new({color=cc.c3b(243,217,38), size=19, text="", align=align})
    :pos(basePos_bottomHead_x + pos_x_offset,basePos_bottomHead_y + pos_y_offset)
    :addTo(self)
    bottomScore:setAnchorPoint(0.5, 0.5)

    --hua layoutBg
    pos_x_offset = -45
    pos_y_offset = -95
    leftHua = cc.uiloader:load("Node/TipHua14.json")
    :pos(basePos_leftHead_x + pos_x_offset,basePos_leftHead_y + pos_y_offset)
    :addTo(self,3)
    :hide()
    cc.uiloader:seekNodeByNameFast(leftHua, "Body_bg"):hide()
    cc.uiloader:seekNodeByNameFast(leftHua, "hua_Num"):setString("0")
    local hua_btn = cc.uiloader:seekNodeByNameFast(leftHua, "Button_Hua")
    local hua_btn2 = cc.uiloader:seekNodeByNameFast(leftHua, "Button_Hua_0")
    hua_btn:onButtonPressed( function (event)  hua_btn2:setScale(hua_btn2:getScaleX()*0.88)   end)
    hua_btn:onButtonRelease( function (event)  hua_btn2:setScale(1.0)  end)
    hua_btn:onButtonClicked(function ()
                self:openHuaBg(4)
             end)
    hua_btn2:onButtonClicked(function ()
                self:openHuaBg(4)
             end)
    util.BtnScaleFun(hua_btn2)

    pos_x_offset = 0
    rightHua = cc.uiloader:load("Node/TipHua2.json")
    :pos(basePos_rightHead_x + pos_x_offset,basePos_rightHead_y + pos_y_offset)
    :addTo(self,3)
    :hide()
    cc.uiloader:seekNodeByNameFast(rightHua, "Body_bg"):hide()
    cc.uiloader:seekNodeByNameFast(rightHua, "hua_Num"):setString("0")
    local hua_btn = cc.uiloader:seekNodeByNameFast(rightHua, "Button_Hua")
    local hua_btn2 = cc.uiloader:seekNodeByNameFast(rightHua, "Button_Hua_0")
    hua_btn:onButtonPressed( function (event)  hua_btn2:setScale(hua_btn2:getScaleX()*0.88)   end)
    hua_btn:onButtonRelease( function (event)  hua_btn2:setScale(1.0)  end)
    hua_btn:onButtonClicked(function ()
                self:openHuaBg(2)
             end)
    hua_btn2:onButtonClicked(function ()
                self:openHuaBg(2)
             end)
    util.BtnScaleFun(hua_btn2)

    pos_x_offset = 0
    topHua = cc.uiloader:load("Node/TipHua3.json")
    :pos(basePos_topHead_x + pos_x_offset,basePos_topHead_y + pos_y_offset)
    :addTo(self,3)
    :hide()
    cc.uiloader:seekNodeByNameFast(topHua, "Body_bg"):hide()
    cc.uiloader:seekNodeByNameFast(topHua, "hua_Num"):setString("0")
    local hua_btn = cc.uiloader:seekNodeByNameFast(topHua, "Button_Hua")
    local hua_btn2 = cc.uiloader:seekNodeByNameFast(topHua, "Button_Hua_0")
    hua_btn:onButtonPressed( function (event)  hua_btn2:setScale(hua_btn2:getScaleX()*0.88)   end)
    hua_btn:onButtonRelease( function (event)  hua_btn2:setScale(1.0)  end)
    hua_btn:onButtonClicked(function ()
                self:openHuaBg(3)
             end)
    hua_btn2:onButtonClicked(function ()
                self:openHuaBg(3)
             end)
    util.BtnScaleFun(hua_btn2)

    pos_x_offset = 45
    pos_y_offset = -65
    bottomHua = cc.uiloader:load("Node/TipHua14.json")
    :pos(basePos_bottomHead_x + pos_x_offset,basePos_bottomHead_y + pos_y_offset)
    :addTo(self,3)
    :hide()
    cc.uiloader:seekNodeByNameFast(bottomHua, "Body_bg"):hide()
    cc.uiloader:seekNodeByNameFast(bottomHua, "hua_Num"):setString("0")
    local hua_btn = cc.uiloader:seekNodeByNameFast(bottomHua, "Button_Hua")
    local hua_btn2 = cc.uiloader:seekNodeByNameFast(bottomHua, "Button_Hua_0")
    hua_btn.index = 1
    hua_btn:onButtonPressed( function (event)  hua_btn2:setScale(hua_btn2:getScaleX()*0.88)   end)
    hua_btn:onButtonRelease( function (event)  hua_btn2:setScale(1.0)  end)
    hua_btn:onButtonClicked(function ()
                self:openHuaBg(1)
             end)
    hua_btn2:onButtonClicked(function ()
                self:openHuaBg(1)
             end)
    util.BtnScaleFun(hua_btn2)

    startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_kaishi_normal.png", pressed = "ShYMJ/button_kaishi_selected.png" })
    :onButtonClicked(function()
            self:onStartButton()
     end)
    :pos(display.cx + 150, display.bottom + 120)
    :hide()
    :addTo(self)

    leftReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_leftHead_x,basePos_leftHead_y)
    :hide()
    :addTo(self,leftHead:getLocalZOrder()+101)
    rightReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_rightHead_x,basePos_rightHead_y)
    :hide()
    :addTo(self,rightHead:getLocalZOrder()+101)
    topReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_topHead_x,basePos_topHead_y)
    :hide()
    :addTo(self,topHead:getLocalZOrder()+101)
    bottomReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_bottomHead_x, basePos_bottomHead_y)
    :hide()
    :addTo(self,bottomHead:getLocalZOrder()+101)
    display.newSprite("#ShYMJ/img_GameUI_WaitPlayer.png")
    :pos(560, 100)
    :addTo(bottomReady)

    --初始化表情资源
    self:initEmotion()

    bankerSprite = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
    :hide()
    :addTo(self,2)

    hunButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_hun_normal.png", pressed = "ShYMJ/ani_special_hun_selected.png" })
    :onButtonClicked(function()
            self:onHunButton()
     end)
    :pos(display.right-303, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    dropButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_cancel_normal.png", pressed = "ShYMJ/ani_special_cancel_selected.png" })
    :onButtonClicked(function()
            self:onDropButton()
     end)
    :pos(display.right-131, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    leftCombin = display.newSprite("ShYMJ/img_hint_background.png")
    :pos(display.right-91-6*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    local hit_chi_left = display.newSprite("ShYMJ/img_hint_background_chi.png")
    :pos(0,128)
    :addTo(leftCombin)
    hit_chi_left:setLocalZOrder(2)

    self:addCombin("left")
    leftCombin:setTouchEnabled(true)
    leftCombin:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            if leftCombin:hitTest(cc.p(event.x, event.y), false) then
                self:onCombinButton("left")
            end
        end
    end)

    centerCombin = display.newSprite("ShYMJ/img_hint_background.png")
    :pos(display.right-91-5*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    local hit_chi_center = display.newSprite("ShYMJ/img_hint_background_chi.png")
    :pos(0,128)
    :addTo(centerCombin)
    hit_chi_center:setLocalZOrder(2)

    self:addCombin("center")
    centerCombin:setTouchEnabled(true)
    centerCombin:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            if centerCombin:hitTest(cc.p(event.x, event.y), false) then
                self:onCombinButton("center")
            end
        end
    end)

    rightCombin = display.newSprite("ShYMJ/img_hint_background.png")
    :pos(display.right-91-4*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    local hit_chi_right = display.newSprite("ShYMJ/img_hint_background_chi.png")
    :pos(0,128)
    :addTo(rightCombin)
    hit_chi_right:setLocalZOrder(2)

    self:addCombin("right")
    rightCombin:setTouchEnabled(true)
    rightCombin:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            if rightCombin:hitTest(cc.p(event.x, event.y), false) then
                self:onCombinButton("right")
            end
        end
    end)

    pengCombin = display.newSprite("ShYMJ/img_hint_background.png")
    :pos(display.right-91-3*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    local hit_peng = display.newSprite("ShYMJ/img_hint_background_peng.png")
    :pos(0,128)
    :addTo(pengCombin)
    hit_peng:setLocalZOrder(2)

    self:addCombin("peng")
    pengCombin:setTouchEnabled(true)
    pengCombin:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            if pengCombin:hitTest(cc.p(event.x, event.y), false) then
                self:onCombinButton("peng")
            end
        end
    end)

    for i = 1, 3 do
        gangCombin[i] = display.newSprite("ShYMJ/img_hint_background.png")
        :pos(display.right-91-2*182, display.bottom + 250)
        -- :setScale(182/288)
        :hide()
        :addTo(self)

        local hit_gang = display.newSprite("ShYMJ/img_hint_background_gang.png")
        :pos(0,128)
        :addTo(gangCombin[i])
        hit_gang:setLocalZOrder(2)

        self:addCombin("gang", i)
        gangCombin[i]:setTouchEnabled(true)
        gangCombin[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                return true
            elseif event.name == "ended" then
                if gangCombin[i]:hitTest(cc.p(event.x, event.y), false) then
                    self:onCombinButton("gang", i)
                end
            end
        end)
    end

    for i = 1, 3 do
        angangCombin[i] = display.newSprite("ShYMJ/img_hint_background.png")
        :pos(display.right-91-2*182, display.bottom + 250)
        -- :setScale(182/288)
        :hide()
        :addTo(self)

        local hit_angang = display.newSprite("ShYMJ/img_hint_background_gang.png")
        :pos(0,128)
        :addTo(angangCombin[i])
        hit_angang:setLocalZOrder(2)

        self:addCombin("angang", i)
        angangCombin[i]:setTouchEnabled(true)
        angangCombin[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                return true
            elseif event.name == "ended" then
                if angangCombin[i]:hitTest(cc.p(event.x, event.y), false) then
                    self:onCombinButton("gang", i)
                end
            end
        end)
    end

    local frame1 = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_GameUI_WaitDian.png")
    local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_GameUI_EmptyDian.png")
    local dian = display.newSprite("#ShYMJ/img_GameUI_WaitDian.png")
    :pos(730, 85.0)
    :addTo(bottomReady)
    local frames = {frame1, frame1, frame1, frame2}
    local animation = cc.Animation:createWithSpriteFrames(frames, 0.5)
    local animate = cc.Animate:create(animation);
    dian:runAction(cc.RepeatForever:create(animate))

    dian = display.newSprite("#ShYMJ/img_GameUI_WaitDian.png")
    :pos(755, 85.0)
    :addTo(bottomReady)
    frames = {frame2, frame1, frame1, frame2}
    animation = cc.Animation:createWithSpriteFrames(frames, 0.5)
    animate = cc.Animate:create(animation);
    dian:runAction(cc.RepeatForever:create(animate))

    dian = display.newSprite("#ShYMJ/img_GameUI_WaitDian.png")
    :pos(780, 85.0)
    :addTo(bottomReady)
    frames = {frame2, frame2, frame1, frame2}
    animation = cc.Animation:createWithSpriteFrames(frames, 0.5)
    animate = cc.Animate:create(animation);
    dian:runAction(cc.RepeatForever:create(animate))

    tuoguanLayer = display.newSprite("ShYMJ/img_tuoguan_bg.png")
    :pos(display.cx, display.bottom + 94)
    :hide()
    :addTo(self)
    tuoguanButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_tuoguan_but_normal.png", pressed = "ShYMJ/button_tuoguan_but_selected.png" })
    :onButtonClicked(function()
            self:onManagerButton()
     end)
    :pos(display.cx, 94)
    :addTo(tuoguanLayer)
    display.newSprite("ShYMJ/img_tuoguan_notify.png")
    :pos(display.cx, 220)
    :addTo(tuoguanLayer)

    leftTuoguan = display.newSprite("#ShYMJ/img_tuoguan_zhi.png")
    :pos(display.left + 180, display.cy + 34)
    :hide()
    :addTo(self)
    rightTuoguan = display.newSprite("#ShYMJ/img_tuoguan_zhi.png")
    :pos(display.right - 180, display.cy + 34)
    :hide()
    :addTo(self)
    topTuoguan = display.newSprite("#ShYMJ/img_tuoguan_zhi.png")
    :pos(display.cx, display.top - 90)
    :hide()
    :addTo(self)


    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_Buhua.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 39, 59))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_Buhua.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_Buhua_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 39, 59))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_Buhua_h.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX_Hua.png")
    --124X111
    for i = 1, 3 do
        for j = 1, 4 do
            if i == 1 and j < 4 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 39*(i-1), 31, 39))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 4*16+4+j))
            elseif i == 2 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 39*(i-1), 31, 39))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+j))
            elseif i == 3 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 39*(i-1), 31, 39))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+4+j))
            end
        end
    end

end

function MJPlayers:initEmotion()

    local basePos_leftHead_x = 62
    local basePos_leftHead_y = display.cy+48
    local basePos_rightHead_x = display.width - 70
    local basePos_rightHead_y = display.cy+78
    --local basePos_topHead_x = 331
    local basePos_topHead_x = display.width-260
    local basePos_topHead_y = display.height - 70
    local basePos_bottomHead_x = 62
    local basePos_bottomHead_y = 210
    local pos_x_offset = 45
    local pos_y_offset = 22
    local scale_head = 0.42

    local rect = cc.rect(0, 0, 188, 188)
    
    emoBgLayer = display.newSprite("Image/PrivateRoom/img_EmoBg.png")
    :pos(basePos_leftHead_x+pos_x_offset+34,basePos_leftHead_y + pos_y_offset)
    :hide()
    :addTo(self, 11)
    :setTouchEnabled(true)

    cureHead = display.newSprite()
    :pos(55,206)
    :show()
    :addTo(emoBgLayer)
    :scale(scale_head)

    uidText = cc.ui.UILabel.new({
            color = cc.c3b(245,222,183),
            size = 30,
            text = "ID：",
        })
    :addTo(emoBgLayer)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(55+46,206)

    leftEmoBtn = cc.ui.UIPushButton.new({ normal = "Image/PrivateRoom/btn_GiftEmo.png", pressed = "Image/PrivateRoom/btn_GiftEmo.png" })
    :onButtonClicked(
        function()

            local visible = emoBgLayer:isVisible()
            emoBgLayer:setPosition(cc.p(basePos_leftHead_x+pos_x_offset+2,basePos_leftHead_y + pos_y_offset))
            local curPos = emoBgLayer:getPositionY()
            if curPos == lastPos then
                emoBgLayer:setVisible(not visible)
            else
                emoBgLayer:setVisible(true)
            end
            emoBgLayer:setAnchorPoint(cc.p(0,0.5))
            lastPos = curPos
            local beginPos = cc.p(basePos_bottomHead_x, basePos_bottomHead_y)
            local endPos = cc.p(basePos_leftHead_x, basePos_leftHead_y)
            util.showEmotionsLayer(self.callBack, emoBgLayer, "left")
            if emoBgLayer:isVisible() then

                local imageid = eHeadInfo["left"].imageid
                local image = eHeadInfo["left"].image
                local uid = eHeadInfo["left"].uid

                local frame_head = cc.SpriteFrame:create(image, rect)
                cureHead:setSpriteFrame(frame_head)

                print("imageid = ", imageid)
                print("image = ", image)
                print("uid = ", uid)
                local uidStr = "ID：" .. uid
                uidText:setString(uidStr)

                util.setImageNodeHide(emoBgLayer, 102)
                util.setImageNodeHide(emoBgLayer, 103)
                util.setHeadImage(emoBgLayer, imageid, cureHead, image, 101)
            end

         end)
    :pos(basePos_leftHead_x-pos_x_offset+15,basePos_leftHead_y + pos_y_offset+25)
    :hide()
    :addTo(self,11)

    rightEmoBtn = cc.ui.UIPushButton.new({ normal = "Image/PrivateRoom/btn_GiftEmo.png", pressed = "Image/PrivateRoom/btn_GiftEmo.png" })
    :onButtonClicked(
        function()
            local visible = emoBgLayer:isVisible()
            emoBgLayer:setPosition(cc.p(basePos_rightHead_x-pos_x_offset-34,basePos_rightHead_y + pos_y_offset))
            local curPos = emoBgLayer:getPositionY()
            if curPos == lastPos then
                emoBgLayer:setVisible(not visible)
            else
                emoBgLayer:setVisible(true)
            end
            --emoBgLayer:setVisible(not visible)
            emoBgLayer:setAnchorPoint(cc.p(1,0.5))
            lastPos = curPos
            local beginPos = cc.p(basePos_bottomHead_x, basePos_bottomHead_y)
            local endPos = cc.p(basePos_rightHead_x, basePos_rightHead_y)
            util.showEmotionsLayer(self.callBack, emoBgLayer, "right")
             if emoBgLayer:isVisible() then

                local imageid = eHeadInfo["right"].imageid
                local image = eHeadInfo["right"].image
                local uid = eHeadInfo["right"].uid

                local uidStr = "ID：" .. uid
                uidText:setString(uidStr)
                local frame_head = cc.SpriteFrame:create(image, rect)
                cureHead:setSpriteFrame(frame_head)

                util.setImageNodeHide(emoBgLayer, 101)
                util.setImageNodeHide(emoBgLayer, 103)
                util.setHeadImage(emoBgLayer, imageid, cureHead, image, 102)
            end
         end)
    :pos(basePos_rightHead_x-pos_x_offset,basePos_rightHead_y + pos_y_offset+25)
    :hide()
    :addTo(self,11)

    topEmoBtn = cc.ui.UIPushButton.new({ normal = "Image/PrivateRoom/btn_GiftEmo.png", pressed = "Image/PrivateRoom/btn_GiftEmo.png" })
    :onButtonClicked(
        function()
            local visible = emoBgLayer:isVisible()
            emoBgLayer:setPosition(cc.p(basePos_topHead_x-pos_x_offset-34,basePos_topHead_y + pos_y_offset-85))
            local curPos = emoBgLayer:getPositionY()
            if curPos == lastPos then
                emoBgLayer:setVisible(not visible)
            else
                emoBgLayer:setVisible(true)
            end
           -- emoBgLayer:setVisible(not visible)
            emoBgLayer:setAnchorPoint(cc.p(1,0.5))
            lastPos = curPos
            local beginPos = cc.p(basePos_bottomHead_x, basePos_bottomHead_y)
            local endPos = cc.p(basePos_topHead_x, basePos_topHead_y)
            util.showEmotionsLayer(self.callBack, emoBgLayer, "top")
            if emoBgLayer:isVisible() then

                local imageid = eHeadInfo["top"].imageid
                local image = eHeadInfo["top"].image
                local uid = eHeadInfo["top"].uid

                local uidStr = "ID：" .. uid
                uidText:setString(uidStr)
                local frame_head = cc.SpriteFrame:create(image, rect)
                cureHead:setSpriteFrame(frame_head)

                print("imageid = ", imageid)
                print("image = ", image)
                print("uid = ", uid)

                util.setImageNodeHide(emoBgLayer, 101)
                util.setImageNodeHide(emoBgLayer, 102)
                util.setHeadImage(emoBgLayer, imageid, cureHead, image, 103)
            end
         end)
    :pos(basePos_topHead_x-pos_x_offset,basePos_topHead_y + pos_y_offset+15)
    :hide()
    :addTo(self,11)

    util.BtnScaleFun(leftEmoBtn)
    util.BtnScaleFun(rightEmoBtn)
    util.BtnScaleFun(topEmoBtn)
end

function MJPlayers:playEmotion(index, fromDirect, toDirect)

    local basePos_leftHead_x = 62
    local basePos_leftHead_y = display.cy+48
    local basePos_rightHead_x = display.width - 70
    local basePos_rightHead_y = display.cy+78
    --local basePos_topHead_x = 331
    local basePos_topHead_x = display.width-260
    local basePos_topHead_y = display.height - 70
    local basePos_bottomHead_x = 62
    local basePos_bottomHead_y = 210

    local beginPos = cc.p(basePos_bottomHead_x, basePos_bottomHead_y)
    local endPos = cc.p(basePos_rightHead_x, basePos_rightHead_y)

    if fromDirect == "left" then
        beginPos = cc.p(basePos_leftHead_x, basePos_leftHead_y)
    elseif fromDirect == "right" then
        beginPos = cc.p(basePos_rightHead_x, basePos_rightHead_y)
    elseif fromDirect == "top" then
        beginPos = cc.p(basePos_topHead_x, basePos_topHead_y)
    elseif fromDirect == "bottom" then
        beginPos = cc.p(basePos_bottomHead_x, basePos_bottomHead_y)
    end

    if toDirect == "left" then
        endPos = cc.p(basePos_leftHead_x, basePos_leftHead_y)
    elseif toDirect == "right" then
        endPos = cc.p(basePos_rightHead_x, basePos_rightHead_y)
    elseif toDirect == "top" then
        endPos = cc.p(basePos_topHead_x, basePos_topHead_y)
    elseif toDirect == "bottom" then
        endPos = cc.p(basePos_bottomHead_x, basePos_bottomHead_y)
    end

    util.RunEmotionInfo(self.callBack, index, beginPos, endPos)
end

function MJPlayers:openHuaBg(index)
    print("button.index = ",index)

    if index == 1 then
        local bh = cc.uiloader:seekNodeByNameFast(bottomHua, "Body_bg")
        local visible = bh:isVisible()
        bh:setVisible(not visible)

    elseif index == 2 then
        local rh = cc.uiloader:seekNodeByNameFast(rightHua, "Body_bg")
        local visible = rh:isVisible()
        rh:setVisible(not visible)
    elseif index == 3 then
        local th = cc.uiloader:seekNodeByNameFast(topHua, "Body_bg")
        local visible = th:isVisible()
        th:setVisible(not visible)
    else
        local lh = cc.uiloader:seekNodeByNameFast(leftHua, "Body_bg")
        local visible = lh:isVisible()
        lh:setVisible(not visible)
    end
end

function MJPlayers:HideAllHuaBg()

    self:HideEmoBgLayer()

    if bottomHua == nil or rightHua == nil or topHua == nil or leftHua == nil then
        return
    end

    local bh = cc.uiloader:seekNodeByNameFast(bottomHua, "Body_bg")
    bh:hide()

    local rh = cc.uiloader:seekNodeByNameFast(rightHua, "Body_bg")
    rh:hide()

    local th = cc.uiloader:seekNodeByNameFast(topHua, "Body_bg")
    th:hide()

    local lh = cc.uiloader:seekNodeByNameFast(leftHua, "Body_bg")
    lh:hide()
end

function MJPlayers:HideEmoBgLayer()

    if emoBgLayer == nil then
        return
    end

    emoBgLayer:hide()
end


function MJPlayers:addCombin(combin, index)
    local card = 16*4 + 8
    local offX = 2
    local offY = 4
    local scale = 0.95
    local img_mydaopai_cpg = "#ShYMJ/img_mydaopai_cpg"
    img_mydaopai_cpg = getUsedSrc(img_mydaopai_cpg)
    local img_spe_card = "#ShYMJ/img_spe_card"
    img_spe_card = getUsedSrc(img_spe_card)
    print("img_spe_card = ",img_spe_card)
    print("combin,index",combin,index)
    if combin == "left" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(leftCombin)
        local temp =  display.newSprite(img_spe_card)
        :addTo(sprite)
        local flower1=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_mydaopai_cpg)
        :pos(-70+2,-12+2)
        :addTo(sprite)
        :setScale(scale)
        local flower=display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42-offX, 48)
        :addTo(temp)
        :setScale(1.2)
        temp =  display.newSprite(img_spe_card)
        :pos(60-1,0)
        :addTo(sprite)
        local flower2=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "center" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(centerCombin)
        local temp =  display.newSprite(img_spe_card)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_mydaopai_cpg)
        :pos(-70+2,-12+2)
        :addTo(sprite)
        :setScale(scale)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42-offX, 48)
        :addTo(temp)
        :setScale(1.2)
        temp =  display.newSprite(img_spe_card)
        :pos(60-1,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "right" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(rightCombin)
        local temp =  display.newSprite(img_spe_card)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_mydaopai_cpg)
        :pos(-70+2,-12+2)
        :addTo(sprite)
        :setScale(scale)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42-offX, 48)
        :addTo(temp)
        :setScale(1.2)
        temp =  display.newSprite(img_spe_card)
        :pos(60-1,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "peng" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(pengCombin)
        local temp =  display.newSprite(img_spe_card)
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_spe_card)
        :pos(-60+1,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_spe_card)
        :pos(60-1,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "angang" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(angangCombin[index])
        local img_spe_backcard = "#ShYMJ/img_spe_backcard"
        img_spe_backcard = getUsedSrc(img_spe_backcard)
        local temp =  display.newSprite(img_spe_backcard)
        :addTo(sprite)
        temp =  display.newSprite(img_spe_backcard)
        :pos(-60,0)
        :addTo(sprite)
        temp =  display.newSprite(img_spe_backcard)
        :pos(60,0)
        :addTo(sprite)
        temp =  display.newSprite(img_spe_card)
        :pos(0,24)
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        if index == 1 then
            flowerCombin[combin] = {flower}
        else
            flowerCombin[combin][index] = flower
        end
    elseif combin == "gang" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(gangCombin[index])
        local temp =  display.newSprite(img_spe_card)
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_spe_card)
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_spe_card)
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        temp =  display.newSprite(img_spe_card)
        :pos(0,16)
        :addTo(sprite)
        local flower3 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50+offY)
        :addTo(temp)
        if index == 1 then
            flowerCombin[combin] = {{flower, flower1, flower2, flower3}}
        else
            flowerCombin[combin][index] = {flower, flower1, flower2, flower3}
        end
    end
end

function MJPlayers:init(callback)
    self.callBack = callback
    return self
end

function MJPlayers:getSex(direct)
    return playerSex[direct]
end

function MJPlayers:getHead(direct)
    return playerHead[direct]
end
function MJPlayers:getWeixinHead(direct)
    return playerImage_weixin[direct]
end

function MJPlayers:setGameRound(gameround)
    if  self.info == nil then
        return
    end
    local roundText = self.info:getChildByTag(99)
    if roundText ~= nil then
        app.constant.gameround = gameround
        roundText:setString(tostring(gameround) .. "/" .. app.constant.curRoomRound .. "局")
    end
end

function MJPlayers:setPlayer(direct, name, score, sex, viptype, imageid, uid)
    name = util.checkNickName(name)
    print(direct, name, score, sex, viptype, uid)
    print("setPlayer--imageid,",imageid)
    print("setPlayer--score,",score)
    local str = string.format("%s", util.num2str_text(score))
    --set head
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    playerHead[direct] = image


    if imageid and imageid ~="" then
        --todo
        playerImage_weixin[direct] = imageid
        eHeadInfo[direct].imageid = imageid
    else
        playerImage_weixin[direct] = nil
        eHeadInfo[direct].imageid = nil
    end
    local rect = cc.rect(0, 0, 188, 188)
    local frame_head = cc.SpriteFrame:create(image, rect)

    eHeadInfo[direct].uid = uid
    eHeadInfo[direct].image = image
    -- local image_framebg = AvatarConfig:getAvatarBG(sex, score, viptype,1)
    -- local rectbg = cc.rect(0, 0, 105, 105)
    -- local frame_headbg = cc.SpriteFrame:create(image_framebg, rectbg)


    if direct == "left" then
        leftNameBg:show()
        leftName:setString(name)
        leftScore:setString(str)
        leftHeadBg:show()
        leftHead:show()
        leftHead:setSpriteFrame(frame_head)
        -- leftHua:show()
        leftEmoBtn:show()
       --modify by whb 161031
        if viptype > 0 then
           leftName:setColor(cc.c3b(255, 0, 0))
        end
       --modify end
        --设置微信头像

        util.setHeadImage(self, imageid, leftHead, image, 1)
    elseif direct == "right" then
        rightName:setString(name)
        rightNameBg:show()
        rightScore:setString(str)
        rightHeadBg:show()
        rightHead:show()
        rightHead:setSpriteFrame(frame_head)
        -- rightHua:show()
        rightEmoBtn:show()
        --modify by whb 161031
           if viptype > 0 then
              rightName:setColor(cc.c3b(255, 0, 0))
           end
        --modify end

        --设置微信头像
        util.setHeadImage(self, imageid, rightHead, image, 2)

    elseif direct == "top" then
        topName:setString(name)
        topNameBg:show()
        topScore:setString(str)
        topHeadBg:show()
        topHead:show()
        topHead:setSpriteFrame(frame_head)
        -- topHua:show()
        topEmoBtn:show()
        --modify by whb 161031
           if viptype > 0 then
              topName:setColor(cc.c3b(255, 0, 0))
           end
        --modify end

        --设置微信头像
         util.setHeadImage(self, imageid, topHead, image, 3)

       -- topName:setColor(cc.c3b(255, 0, 0))
    elseif direct == "bottom" then

         --modify by whb 161031
           if viptype > 0 then
              bottomName:setColor(cc.c3b(255, 0, 0))
           end
        --modify end
        bottomNameBg:show()
        bottomName:setString(name)
        bottomScore:setString(str)
        bottomHeadBg:show()
        bottomHead:show()
        bottomHead:setSpriteFrame(frame_head)
        -- bottomHua:show()

        --设置微信头像
        util.setHeadImage(self, imageid, bottomHead, image, 4)
    end

    playerSex[direct] = sex
end

function MJPlayers:countAllFlower(direct)
    if direct == "left" then
        local count = #flowerArray_L
        local allCount = 0
        for i = 1, count do
            allCount = allCount + flowerArray_L[i].num
        end
        return allCount

    elseif direct == "right" then
        local count = #flowerArray_R
        local allCount = 0
        for i = 1, count do
            allCount = allCount + flowerArray_R[i].num
        end
        return allCount

    elseif direct == "top" then
        local count = #flowerArray_U
        local allCount = 0
        for i = 1, count do
            allCount = allCount + flowerArray_U[i].num
        end
        return allCount
    elseif direct == "bottom" then
        local count = #flowerArray_D
        local allCount = 0
        for i = 1, count do
            allCount = allCount + flowerArray_D[i].num
        end
        return allCount
    end
end

function MJPlayers:countFlower(card, direct)
    if direct == "left" then

        local count = #flowerArray_L
        for i = 1, count do
            if flowerArray_L[i].val == card then
                flowerArray_L[i].num = flowerArray_L[i].num+1
                flowerArray_L[i].hua_label:setString(tostring(flowerArray_L[i].num))
                local all = self:countAllFlower(direct)
                self:upDateHuaBg(direct, all)
                return true
            end
        end

        return false

    elseif direct == "right" then
        local count = #flowerArray_R
        for i = 1, count do
            if flowerArray_R[i].val == card then
                flowerArray_R[i].num = flowerArray_R[i].num+1
                flowerArray_R[i].hua_label:setString(tostring(flowerArray_R[i].num))
                local all = self:countAllFlower(direct)
                self:upDateHuaBg(direct, all)
                return true
            end
        end

        return false

    elseif direct == "top" then
        local count = #flowerArray_U
        for i = 1, count do
            if flowerArray_U[i].val == card then
                flowerArray_U[i].num = flowerArray_U[i].num+1
                flowerArray_U[i].hua_label:setString(tostring(flowerArray_U[i].num))
                local all = self:countAllFlower(direct)
                self:upDateHuaBg(direct, all)
                return true
            end
        end

        return false

    elseif direct == "bottom" then
        local count = #flowerArray_D
        for i = 1, count do
            if flowerArray_D[i].val == card then
                flowerArray_D[i].num = flowerArray_D[i].num+1
                flowerArray_D[i].hua_label:setString(tostring(flowerArray_D[i].num))
                local all = self:countAllFlower(direct)
                self:upDateHuaBg(direct, all)
                return true
            end
        end

        return false
    end

end

function MJPlayers:addFlower(card, direct)

    local num = 6
    local isHas = self:countFlower(card, direct)
    if isHas == true then
        return
    end
    local imgName = "#ShYMJ/img_Buhua"
    imgName = getUsedSrc(imgName)
    local offX = 7
    local offY = -1
    local scale = 0.9

    print("addFlower-direct = ",direct)

    if direct == "left" then

        local bg = cc.uiloader:seekNodeByNameFast(leftHua, "Body_bg")

        local count = #flowerArray_L
        local dis = math.floor(count/num)
        local sprite = display.newSprite(imgName)
        :pos(38+(count%num)*36, 143-dis*83.82)
        :addTo(bg)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
        :pos(12+offX, 23+offY)
        :addTo(sprite)
        :setScale(scale)

        local label_Num = cc.LabelAtlas:_create()
        label_Num:initWithString(
            tostring(1),
            "Image/HuaTip/img_HuaNum.png",
            20,
            22,
            string.byte('0'))
        label_Num:setAnchorPoint(cc.p(0.5,0.5))
        label_Num:setPosition(cc.p(19.50,-14.50))
        label_Num:setString(tostring(1))
        label_Num:addTo(sprite)
        table.insert(flowerArray_L, count+1, {val=card, num=1, hua_label=label_Num})

    elseif direct == "right" then

        local bg = cc.uiloader:seekNodeByNameFast(rightHua, "Body_bg")
        local count = #flowerArray_R
        self:upDateHuaBg(direct, count)
        local dis = math.floor(count/num)
        local sprite = display.newSprite(imgName)
        :pos(38+(count%num)*36, 143-dis*83.82)
        :addTo(bg)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
        :pos(12+offX, 23+offY)
        :addTo(sprite)
        :setScale(scale)

        local label_Num = cc.LabelAtlas:_create()
        label_Num:initWithString(
            tostring(1),
            "Image/HuaTip/img_HuaNum.png",
            20,
            22,
            string.byte('0'))
        label_Num:setAnchorPoint(cc.p(0.5,0.5))
        label_Num:setPosition(cc.p(19.50,-14.50))
        label_Num:setString(tostring(1))
        label_Num:addTo(sprite)
        table.insert(flowerArray_R, count+1, {val=card, num=1, hua_label=label_Num})

    elseif direct == "top" then

        local bg = cc.uiloader:seekNodeByNameFast(topHua, "Body_bg")
        local count = #flowerArray_U
        local dis = math.floor(count/num)
        local sprite = display.newSprite(imgName)
        :pos(30+(count%num)*36, 143-dis*83.82)
        :addTo(bg)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
        :pos(12+offX, 23+offY)
        :addTo(sprite)
        :setScale(scale)

        local label_Num = cc.LabelAtlas:_create()
        label_Num:initWithString(
            tostring(1),
            "Image/HuaTip/img_HuaNum.png",
            20,
            22,
            string.byte('0'))
        label_Num:setAnchorPoint(cc.p(0.5,0.5))
        label_Num:setPosition(cc.p(19.50,-14.50))
        label_Num:setString(tostring(1))
        label_Num:addTo(sprite)
        table.insert(flowerArray_U, count+1, {val=card, num=1, hua_label=label_Num})

    elseif direct == "bottom" then

        local bg = cc.uiloader:seekNodeByNameFast(bottomHua, "Body_bg")
        local count = #flowerArray_D
        local dis = math.floor(count/num)
        local sprite = display.newSprite(imgName)
        :pos(38+(count%num)*36, 143-dis*83.82)
        :addTo(bg)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
        :pos(12+offX, 23+offY)
        :addTo(sprite)
        :setScale(scale)

        local label_Num = cc.LabelAtlas:_create()
        label_Num:initWithString(
            tostring(1),
            "Image/HuaTip/img_HuaNum.png",
            20,
            22,
            string.byte('0'))
        label_Num:setAnchorPoint(cc.p(0.5,0.5))
        label_Num:setPosition(cc.p(19.50,-14.50))
        label_Num:setString(tostring(1))
        label_Num:addTo(sprite)
        table.insert(flowerArray_D, count+1, {val=card, num=1, hua_label=label_Num})
    end

    local all = self:countAllFlower(direct)
    self:upDateHuaBg(direct, all)
end

function MJPlayers:getHuaCards(cards, direct)

    local count = #cards
    for i = 1, count do
        if cards[i] >= 16*4+5 then
            self:addFlower(cards[i], direct)
        end
    end

end

--刷新花的数据
function MJPlayers:upDateHuaBg(direct,num)
    if direct == "left" then
        cc.uiloader:seekNodeByNameFast(leftHua, "hua_Num"):setString(tostring(num))
    elseif direct == "right" then
        cc.uiloader:seekNodeByNameFast(rightHua, "hua_Num"):setString(tostring(num))

    elseif direct == "top" then
        cc.uiloader:seekNodeByNameFast(topHua, "hua_Num"):setString(tostring(num))

    elseif direct == "bottom" then
        cc.uiloader:seekNodeByNameFast(bottomHua, "hua_Num"):setString(tostring(num))

    end
end

--私人开房中刷新分数
function MJPlayers:updateScore(direct,score)
    local str = string.format("%s", util.num2str_text(score))

    if direct == "left" then
        leftScore:setString(str)
    elseif direct == "right" then
        rightScore:setString(str)
    elseif direct == "top" then
        topScore:setString(str)
    elseif direct == "bottom" then
        bottomScore:setString(str)
    end
end

function MJPlayers:clearHua(direct)

     if direct == "left" then
        if leftHua == nil then
            return
        end
        cc.uiloader:seekNodeByNameFast(leftHua, "Body_bg"):removeAllChildren()
        cc.uiloader:seekNodeByNameFast(leftHua, "hua_Num"):setString("0")
        leftHua:hide()
    elseif direct == "right" then
        if rightHua == nil then
            return
        end
        cc.uiloader:seekNodeByNameFast(rightHua, "Body_bg"):removeAllChildren()
        cc.uiloader:seekNodeByNameFast(rightHua, "hua_Num"):setString("0")
        rightHua:hide()
    elseif direct == "top" then
        if topHua == nil then
            return
        end
        cc.uiloader:seekNodeByNameFast(topHua, "Body_bg"):removeAllChildren()
        cc.uiloader:seekNodeByNameFast(topHua, "hua_Num"):setString("0")
        topHua:hide()
    elseif direct == "bottom" then
        if bottomHua == nil then
            return
        end
        cc.uiloader:seekNodeByNameFast(bottomHua, "Body_bg"):removeAllChildren()
        cc.uiloader:seekNodeByNameFast(bottomHua, "hua_Num"):setString("0")
        bottomHua:hide()
    end

end

function MJPlayers:clearPlayer(direct)

     print("MJPlayers:clearPlayer--,",direct)
    if direct == "left" then
        leftName:setString("")
        leftScore:setString("")
        leftHead:hide()
        leftHeadBg:hide()
        leftNameBg:hide()
        leftEmoBtn:hide()
       -- leftHeadFrameBg:hide()
        util.setImageNodeHide(self, 1)

    elseif direct == "right" then
        rightName:setString("")
        rightScore:setString("")
        rightHead:hide()
        rightHeadBg:hide()
        rightNameBg:hide()
        rightEmoBtn:hide()
       -- rightHeadFrameBg:hide()
        util.setImageNodeHide(self, 2)
    elseif direct == "top" then
        topName:setString("")
        topScore:setString("")
        topHead:hide()
        topHeadBg:hide()
        topNameBg:hide()
        topEmoBtn:hide()
       -- topHeadFrameBg:hide()
        util.setImageNodeHide(self, 3)
    elseif direct == "bottom" then
        bottomName:setString("")
        bottomScore:setString("")
        bottomHead:hide()
        bottomHeadBg:hide()
        bottomNameBg:hide()
        --bottomHeadFrameBg:hide()
        util.setImageNodeHide(self, 4)
    end
    if emoBgLayer ~= nil then
        util.setImageNodeHide(emoBgLayer, 101)
        util.setImageNodeHide(emoBgLayer, 102)
        util.setImageNodeHide(emoBgLayer, 103)
    end
    self:clearHua(direct)
end

function MJPlayers:setState(direct, ready)
    if direct == "left" then
        if ready then
            leftReady:show()
        else
            leftReady:hide()
        end
    elseif direct == "right" then
        if ready then
            rightReady:show()
        else
            rightReady:hide()
        end
    elseif direct == "top" then
        if ready then
            topReady:show()
        else
            topReady:hide()
        end
    elseif direct == "bottom" then
        if ready then
            bottomReady:show()
        else
            bottomReady:hide()
        end
    end
end

function MJPlayers:setBanker(direct,islian)
    --是否连庄
    if islian ~= nil and islian>0 then
        --todo
        print("连庄")
        bankerSprite:setTexture("ShYMJ/img_GameUI_lian_zhuang.png")
    else
        print("正常庄")
        bankerSprite:setTexture("ShYMJ/img_GameUI_zhuang.png")
    end

    local target
    if direct == "left" then
        target = leftHead
        bankerSprite:show()
    elseif direct == "right" then
        target = rightHead
        bankerSprite:show()
    elseif direct == "top" then
        target = topHead
        bankerSprite:show()
    elseif direct == "bottom" then
        target = bottomHead
        bankerSprite:show()
    else
        bankerSprite:hide()
    end
    if target then
        bankerSprite:setPosition(cc.p(target:getPositionX() + 45,target:getPositionY() + 40))
    end
end


function MJPlayers:setMopao(direct)

    local target
    if direct == "left" then
        target = leftHead
        leftMopao:show()
        leftMopao:setPosition(cc.p(target:getPositionX() - 45,target:getPositionY() + 40))
    elseif direct == "right" then
        target = rightHead
        rightMopao:show()
        rightMopao:setPosition(cc.p(target:getPositionX() - 45,target:getPositionY() + 40))
    elseif direct == "top" then
        target = topHead
        topMopao:show()
        topMopao:setPosition(cc.p(target:getPositionX() - 45,target:getPositionY() + 40))
    elseif direct == "bottom" then
        target = bottomHead
        bottomMopao:show()
        bottomMopao:setPosition(cc.p(target:getPositionX() - 45,target:getPositionY() + 40))
    end

end

function MJPlayers:clearState()
    leftReady:hide()
    rightReady:hide()
    topReady:hide()
    bottomReady:hide()
end

function MJPlayers:hideAllButton()
    startButton:hide()
    hunButton:hide()
    dropButton:hide()
    leftCombin:hide()
    centerCombin:hide()
    rightCombin:hide()
    pengCombin:hide()
    for i = 1, #gangCombin do
         gangCombin[i]:hide()
    end
    for i = 1, #angangCombin do
        angangCombin[i]:hide()
    end
    mopaoButton:hide()
    bumopaoButton:hide()
end

function MJPlayers:onMopaoButton(select)
    mopaoButton:hide()
    bumopaoButton:hide()
    self.callBack:onSelectInfo(select)
end

function MJPlayers:onStartButton()
    startButton:hide()
    self.callBack:onStart()
    util.SetRequestBtnHide()
end

function MJPlayers:onHunButton()
    self:hideAllButton()
    self.callBack:onHuCard()
end

function MJPlayers:onDropButton()
    self:hideAllButton()
    self.callBack:onIgnoreCard()
end

function MJPlayers:onManagerButton()
    tuoguanButton:hide()
    self.callBack:onCanelManager()
end

function MJPlayers:onCombinButton(combin, index)
    self:hideAllButton()
    if combin == "gang" then
        self.callBack:onCombinCard(combin, cardCombin[combin][index])
    else
        self.callBack:onCombinCard(combin, cardCombin[combin])
    end
end

function MJPlayers:setReady(manage, direct)
    print("MJPlayers:setManager = ",manage)
    if direct == "left" then
        if manage then
            leftReady:show()
        else
            leftReady:hide()
        end
    elseif direct == "right" then
        if manage then
            rightReady:show()
        else
            rightReady:hide()
        end
    elseif direct == "top" then
        if manage then
            topReady:show()
        else
            topReady:hide()
        end
    elseif direct == "bottom" then
        if manage then
            downReady:show()
        else
            downReady:hide()
        end
    end
end

function MJPlayers:setManager(manage, direct)
    print("MJPlayers:setManager = ",manage)
    if direct == "left" then
        if manage then
            leftLostLine:show()
        else
            leftLostLine:hide()
        end
    elseif direct == "right" then
        if manage then
            rightLostLine:show()
        else
            rightLostLine:hide()
        end
    elseif direct == "top" then
        if manage then
            topLostLine:show()
        else
            topLostLine:hide()
        end
    elseif direct == "bottom" then
        if manage then
            downLostLine:show()
            --tuoguanLayer:show()
        else
            downLostLine:hide()
            --tuoguanLayer:hide()
        end
    end
end

function MJPlayers:setManagerEx(manage, direct)
    if direct == "left" then
        if manage then
            leftTuoguan:show()
        else
            leftTuoguan:hide()
        end
    elseif direct == "right" then
        if manage then
            rightTuoguan:show()
        else
            rightTuoguan:hide()
        end
    elseif direct == "top" then
        if manage then
            topTuoguan:show()
        else
            topTuoguan:hide()
        end
    elseif direct == "bottom" then
        if manage then
            tuoguanButton:show()
            tuoguanLayer:show()
        else
            tuoguanButton:hide()
            tuoguanLayer:hide()
        end
    end
end

function MJPlayers:showHua(seats)
    print(seats,"seats")

    if topHua == nil or bottomHua == nil or leftHua == nil or rightHua == nil then
            return
    end

    topHua:show()
    bottomHua:show()

    if seats ~= 2 then
        leftHua:show()
        rightHua:show()
    end
end

function MJPlayers:clearManager()
    self:setManager(false, "left")
    self:setManager(false, "right")
    self:setManager(false, "top")
    self:setManager(false, "bottom")
end

function MJPlayers:setCombin(combin, card, out, index)

    if combin == "left" then
        local flower = flowerCombin[combin]
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_daocpg%d.png", card)))
        flower[2]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card+1)))
        flower[3]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card+2)))
        cardCombin[combin] = card
        return leftCombin
    elseif combin == "center" then
        local flower = flowerCombin[combin]
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_daocpg%d.png", card)))
        flower[2]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card-1)))
        flower[3]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card+1)))
        cardCombin[combin] = card
        return centerCombin
    elseif combin == "right" then
        local flower = flowerCombin[combin]
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_daocpg%d.png", card)))
        flower[2]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card-2)))
        flower[3]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card-1)))
        cardCombin[combin] = card
        return rightCombin
    elseif combin == "peng" then
        local flower = flowerCombin[combin]
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        flower[2]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        flower[3]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        cardCombin[combin] = card
        return pengCombin
    elseif combin == "gang" then
        if index == 1 then
            cardCombin[combin] = {}
        end
        cardCombin[combin][index] = card
        if out > 0 then
            local flower = flowerCombin[combin][index]
            for i = 1, #flower do
                flower[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
            end
            return gangCombin[index]
        else
            local flower = flowerCombin["angang"]
            flower[index]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
            return angangCombin[index]
        end
    elseif combin == "hun" then
        return hunButton
    elseif combin == "drop" then
        return dropButton
    end
end

function MJPlayers:allowCombin(combin, allow)
    -- print("MJPlayers:allowCombin:" .. tostring(allow))
    self:hideAllButton()
    local count = #combin
    if count > 0 then
        local sprite = {}
        local check = {"right", "center", "left", "peng", "gang", "hun"}
        for i = 1, #check do
            local index = 0
            for j = 1, count do
                if check[i] == combin[j].combin then
                    index = index + 1
                    if index > 3 then
                        break
                    end
                    sprite[#sprite+1] = self:setCombin(combin[j].combin, combin[j].card, combin[j].out, index)
                    if check[i] ~= "gang" then
                        break
                    end
                end
            end
        end

        local drop_x = 0
        if not allow then
            sprite[#sprite+1] = self:setCombin("drop", 0, 0, 0)
            drop_x = 90
        end
        local num = 4
        count = #sprite
        for i = 1, count do
            local cur = count + 1 - i
            if i < num + 1 then
                --最后的取消按钮左移
                if i == 1 then
                    sprite[cur]:pos(display.right-160-(i-1)*320 - drop_x, display.bottom + 280)
                else
                    sprite[cur]:pos(display.right-160-(i-1)*320, display.bottom + 280)
                end

                sprite[cur]:show()
            else
                --最后的取消按钮左移
                if i == 1 then
                    sprite[cur]:pos(display.right-160-(num-1)*320 - drop_x, display.bottom + 280)
                else
                    sprite[cur]:pos(display.right-160-(i-1)*320, display.bottom + 280)
                end
                sprite[cur]:show()
            end
        end
    end
end

function MJPlayers:allowReady()
    startButton:show()

    util.SetRequestBtnShow()
end

function MJPlayers:allowMopao()
    mopaoButton:show()
    bumopaoButton:show()
end

function MJPlayers:clearFlowArray()

    leftHua = nil
    rightHua = nil
    topHua = nil
    bottomHua = nil
    flowerArray_L = {}
    flowerArray_R = {}
    flowerArray_U = {}
    flowerArray_D = {}

    leftEmoBtn = nil
    rightEmoBtn = nil
    topEmoBtn = nil
    emoBgLayer = nil
    cureHead = nil
    -- eHeadInfo = {}
    eHeadInfo = { left = {}, right = {}, top = {}, bottom = {} }
    uidText = nil

end

function MJPlayers:clear()
     startButton = nil
     hunButton = nil
     dropButton = nil
     leftCombin = nil
     centerCombin = nil
     rightCombin = nil
     pengCombin = nil
     gangCombin = {}
     angangCombin = {}
     flowerCombin = {}
     cardCombin = {}
     playerSex = {}

     leftName = nil
     rightName = nil
     topName = nil
     bottomName = nil

     leftNameBg = nil
     rightNameBg = nil
     topNameBg = nil
     bottomNameBg = nil

     leftScore = nil
     rightScore = nil
     topScore = nil
     bottomScore = nil

     leftReady = nil
     rightReady = nil
     topReady = nil
     bottomReady = nil

     leftLostLine = nil
     rightLostLine = nil
     topLostLine = nil
     downLostLine = nil

     bankerSprite = nil

     tuoguanLayer = nil
     tuoguanButton = nil
     leftTuoguan = nil
     rightTuoguan = nil
     topTuoguan = nil

    leftHeadBg = nil
    rightHeadBg = nil
    topHeadBg = nil
    bottomHeadBg = nil

    leftHead = nil
    rightHead = nil
    topHead = nil
    bottomHead = nil

    self:clearFlowArray()

    playerHead = {}
    playerImage_weixin = {}

     mopaoButton = nil
     bumopaoButton = nil

     leftMopao = nil
     rightMopao = nil
     topMopao = nil
     bottomMopao = nil
end

function MJPlayers:restart()
    self:hideAllButton()
    bankerSprite:hide()
    self:clearManager()
    leftMopao:hide()
    rightMopao:hide()
    topMopao:hide()
    bottomMopao:hide()

    cc.uiloader:seekNodeByNameFast(leftHua, "Body_bg"):removeAllChildren()
    cc.uiloader:seekNodeByNameFast(leftHua, "hua_Num"):setString("0")

    cc.uiloader:seekNodeByNameFast(rightHua, "Body_bg"):removeAllChildren()
    cc.uiloader:seekNodeByNameFast(rightHua, "hua_Num"):setString("0")

    cc.uiloader:seekNodeByNameFast(topHua, "Body_bg"):removeAllChildren()
    cc.uiloader:seekNodeByNameFast(topHua, "hua_Num"):setString("0")

    cc.uiloader:seekNodeByNameFast(bottomHua, "Body_bg"):removeAllChildren()
    cc.uiloader:seekNodeByNameFast(bottomHua, "hua_Num"):setString("0")

    flowerArray_L = {}
    flowerArray_R = {}
    flowerArray_U = {}
    flowerArray_D = {}

end

return MJPlayers
