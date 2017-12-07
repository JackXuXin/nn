local MJPlayers = class("MJPlayers",function()
    return display.newSprite()
end)

local util = require("app.Common.util")

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

local leftName
local rightName
local topName
local bottomName

local leftScore
local rightScore
local topScore
local bottomScore

local leftReady
local rightReady
local topReady
local bottomReady

local bankerSprite
local nanSprite
local xiSprite
local beiSprite

local tuoguanLayer
local tuoguanButton

local leftTuoguan
local rightTuoguan
local topTuoguan

local mopaoButton
local bumopaoButton

local leftMopao
local rightMopao
local topMopao
local bottomMopao

function MJPlayers:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 85, 70))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_daocpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(85*(j-1), 66*(i-1), 85, 66))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_daocpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(51*(j-1), 64*(i-1), 51, 64))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_ready.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_ready.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitPlayer.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 221, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitPlayer.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_zhuang.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_zhuang.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_nan.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_nan.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_xi.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_xi.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_bei.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_bei.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitDian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 10, 9))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitDian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_EmptyDian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 10, 9))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_EmptyDian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tuoguan_zhi.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 117, 68))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tuoguan_zhi.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/icon_mo.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/icon_mo.png")

    bankerSprite = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
    :hide()
    :addTo(self)
    nanSprite = display.newSprite("#ShYMJ/img_GameUI_nan.png")
    :hide()
    :addTo(self)
    xiSprite = display.newSprite("#ShYMJ/img_GameUI_xi.png")
    :hide()
    :addTo(self)
    beiSprite = display.newSprite("#ShYMJ/img_GameUI_bei.png")
    :hide()
    :addTo(self)
    
    leftMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self)
    rightMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self)
    topMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self)
    bottomMopao = display.newSprite("#ShYMJ/icon_mo.png")
    :hide()
    :addTo(self)

    startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_kaishi_normal.png", pressed = "ShYMJ/button_kaishi_selected.png" })
    :onButtonClicked(function()
            self:onStartButton()
     end)
    :pos(display.cx, display.bottom + 120)
    :hide()
    :addTo(self)

    mopaoButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_mo_0.png", pressed = "ShYMJ/btn_mo_1.png" })
    :onButtonClicked(function()
            self:onMopaoButton(1)
     end)
    :pos(display.cx-100, display.bottom + 120)
    :hide()
    :addTo(self)

    bumopaoButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_bumo_0.png", pressed = "ShYMJ/btn_bumo_1.png" })
    :onButtonClicked(function()
            self:onMopaoButton(0)
     end)
    :pos(display.cx+100, display.bottom + 120)
    :hide()
    :addTo(self)


    hunButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_hun_normal.png", pressed = "ShYMJ/ani_special_hun_selected.png" })
    :onButtonClicked(function()
            self:onHunButton()
     end)
    :pos(display.right-273, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    dropButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_cancel_normal.png", pressed = "ShYMJ/ani_special_cancel_selected.png" })
    :onButtonClicked(function()
            self:onDropButton()
     end)
    :pos(display.right-91, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    leftCombin = display.newSprite("ShYMJ/img_hint_background_chi.png")
    :pos(display.right-91-6*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)
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

    centerCombin = display.newSprite("ShYMJ/img_hint_background_chi.png")
    :pos(display.right-91-5*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)
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

    rightCombin = display.newSprite("ShYMJ/img_hint_background_chi.png")
    :pos(display.right-91-4*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)
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

    pengCombin = display.newSprite("ShYMJ/img_hint_background_peng.png")
    :pos(display.right-91-3*182, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)
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
        gangCombin[i] = display.newSprite("ShYMJ/img_hint_background_gang.png")
        :pos(display.right-91-2*182, display.bottom + 250)
        -- :setScale(182/288)
        :hide()
        :addTo(self)
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
        angangCombin[i] = display.newSprite("ShYMJ/img_hint_background_gang.png")
        :pos(display.right-91-2*182, display.bottom + 250)
        -- :setScale(182/288)
        :hide()
        :addTo(self)
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

    leftName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    :pos(display.left+30, display.cy+34)
    :setRotation(90)
    :addTo(self)
    leftName:setAnchorPoint(0.5, 0.5)

    leftScore = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :pos(display.left+30, display.cy+34)
    :setRotation(90)
    :addTo(self)
    leftScore:setAnchorPoint(0.5, 0.5)

    rightName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    :pos(display.right-30, display.cy+34)
    :setRotation(270)
    :addTo(self)
    rightName:setAnchorPoint(0.5, 0.5)

    rightScore = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :pos(display.right-30, display.cy+34)
    :setRotation(270)
    :addTo(self)
    rightScore:setAnchorPoint(0.5, 0.5)

    topName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    :pos(display.cx, display.top-20)
    :addTo(self)
    topName:setAnchorPoint(0.5, 0.5)

    topScore = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :pos(display.cx, display.top-20)
    :addTo(self)
    topScore:setAnchorPoint(0.5, 0.5)

    bottomName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    :pos(display.cx, display.bottom+18)
    :addTo(self)
    bottomName:setAnchorPoint(0.5, 0.5)

    bottomScore = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :pos(display.cx, display.bottom+18)
    :addTo(self)
    bottomScore:setAnchorPoint(0.5, 0.5)


    leftReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(display.cx-200, display.cy+34)
    :hide()
    :addTo(self)
    rightReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(display.cx+200, display.cy+34)
    :hide()
    :addTo(self)
    topReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(display.cx, display.cy+34+180)
    :hide()
    :addTo(self)
    bottomReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(display.cx, display.cy+34-180)
    :hide()
    :addTo(self)
    display.newSprite("#ShYMJ/img_GameUI_WaitPlayer.png")
    :pos(39, 80)
    :addTo(bottomReady)

    local frame1 = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_GameUI_WaitDian.png")
    local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_GameUI_EmptyDian.png")
    local dian = display.newSprite("#ShYMJ/img_GameUI_WaitDian.png")
    :pos(155, 70.0)
    :addTo(bottomReady)
    local frames = {frame1, frame1, frame1, frame2}
    local animation = cc.Animation:createWithSpriteFrames(frames, 0.5)
    local animate = cc.Animate:create(animation);
    dian:runAction(cc.RepeatForever:create(animate))

    dian = display.newSprite("#ShYMJ/img_GameUI_WaitDian.png")
    :pos(165, 70.0)
    :addTo(bottomReady)
    frames = {frame2, frame1, frame1, frame2}
    animation = cc.Animation:createWithSpriteFrames(frames, 0.5)
    animate = cc.Animate:create(animation);
    dian:runAction(cc.RepeatForever:create(animate))

    dian = display.newSprite("#ShYMJ/img_GameUI_WaitDian.png")
    :pos(175, 70.0)
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
    :pos(display.left + 120, display.cy + 34)
    :hide()
    :addTo(self)
    rightTuoguan = display.newSprite("#ShYMJ/img_tuoguan_zhi.png")
    :pos(display.right - 120, display.cy + 34)
    :hide()
    :addTo(self)
    topTuoguan = display.newSprite("#ShYMJ/img_tuoguan_zhi.png")
    :pos(display.cx, display.top - 90)
    :hide()
    :addTo(self)
end

function MJPlayers:addCombin(combin, index)
    local card = 16*4 + 8
    if combin == "left" then
        local sprite = display.newSprite()
        :pos(180, 60)
        :addTo(leftCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower1=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
        :pos(-70,-12)
        :addTo(sprite)
        local flower=display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42, 44)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "center" then
        local sprite = display.newSprite()
        :pos(180, 60)
        :addTo(centerCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
        :pos(-70,-12)
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42, 44)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "right" then
        local sprite = display.newSprite()
        :pos(180, 60)
        :addTo(rightCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
        :pos(-70,-12)
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42, 44)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "peng" then
        local sprite = display.newSprite()
        :pos(180, 60)
        :addTo(pengCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "angang" then
        local sprite = display.newSprite()
        :pos(180, 60)
        :addTo(angangCombin[index])
        local temp =  display.newSprite("#ShYMJ/img_spe_backcard.png")
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_backcard.png")
        :pos(-60,0)
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_backcard.png")
        :pos(60,0)
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
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
        :pos(180, 60)
        :addTo(gangCombin[index])
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(0,16)
        :addTo(sprite)
        local flower3 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 50)
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

function MJPlayers:setPlayer(direct, name, score, sex, viptype)
    name = util.checkNickName(name)
    local str = string.format("[%s]", util.toDotNum(score))
    if direct == "left" then
        leftName:setString(name)
        leftScore:setString(str)
        local height1 = leftName:getBoundingBox().height
        local height2 = leftScore:getBoundingBox().height
        leftName:pos(display.left+30, display.cy+34+(height1+height2)/2-height1/2)
        leftScore:pos(display.left+30, display.cy+34-(height1+height2)/2+height2/2-5)

--modify by whb 161031
   if viptype > 0 then
      leftName:setColor(cc.c3b(251, 132, 132))
   end
--modify end

    elseif direct == "right" then
        rightName:setString(name)
        rightScore:setString(str)
        local height1 = rightName:getBoundingBox().height
        local height2 = rightScore:getBoundingBox().height
        rightName:pos(display.right-30, display.cy+34-(height1+height2)/2+height1/2)
        rightScore:pos(display.right-30, display.cy+34+(height1+height2)/2-height2/2+5)

--modify by whb 161031
   if viptype > 0 then
      rightName:setColor(cc.c3b(251, 132, 132))
   end
--modify end
    elseif direct == "top" then
        topName:setString(name)
        topScore:setString(str)
        local width1 = topName:getBoundingBox().width
        local width2 = topScore:getBoundingBox().width
        topName:pos(display.cx-(width1+width2)/2+width1/2, display.top-20)
        topScore:pos(display.cx+(width1+width2)/2-width2/2+5, display.top-20)

--modify by whb 161031
   if viptype > 0 then
      topName:setColor(cc.c3b(251, 132, 132))
   end
--modify end


       -- topName:setColor(cc.c3b(255, 0, 0))
    elseif direct == "bottom" then

print("eeeeeee---------")
 --modify by whb 161031
   if viptype > 0 then
      bottomName:setColor(cc.c3b(251, 132, 132))
   end
--modify end
        bottomName:setString(name)
        bottomScore:setString(str)
        local width1 = bottomName:getBoundingBox().width
        local width2 = bottomScore:getBoundingBox().width
        bottomName:pos(display.cx-(width1+width2)/2+width1/2, display.bottom+18)
        bottomScore:pos(display.cx+(width1+width2)/2-width2/2+5, display.bottom+18)
    end
    playerSex[direct] = sex
end

function MJPlayers:clearPlayer(direct)
    if direct == "left" then
        leftName:setString("")
        leftScore:setString("")
    elseif direct == "right" then
        rightName:setString("")
        rightScore:setString("")
    elseif direct == "top" then
        topName:setString("")
        topScore:setString("")
    elseif direct == "bottom" then
        bottomName:setString("")
        bottomScore:setString("")
    end
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

function MJPlayers:setBanker(direct,max_player)
    if direct == "left" then
        local lheight = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
        bankerSprite:pos(display.left+30, display.cy+34+lheight/2+25)
        bankerSprite:show()
        local rheight = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
        xiSprite:pos(display.right-30, display.cy+34-rheight/2-25)
        xiSprite:show()
        if max_player > 2 then
            local bwidth = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
            nanSprite:pos(display.cx-bwidth/2-25, display.bottom+18)
            nanSprite:show()
            local twidth = topName:getBoundingBox().width + topScore:getBoundingBox().width
            beiSprite:pos(display.cx-twidth/2-25, display.top-20)
            beiSprite:show()
        end
    elseif direct == "right" then
        local rheight = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
        bankerSprite:pos(display.right-30, display.cy+34-rheight/2-25)
        bankerSprite:show()
        local lheight = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
        xiSprite:pos(display.left+30, display.cy+34+lheight/2+25)
        xiSprite:show()
        if max_player > 2 then
            local bwidth = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
            beiSprite:pos(display.cx-bwidth/2-25, display.bottom+18)
            beiSprite:show()
            local twidth = topName:getBoundingBox().width + topScore:getBoundingBox().width
            nanSprite:pos(display.cx-twidth/2-25, display.top-20)
            nanSprite:show()
        end
    elseif direct == "top" then
        if max_player > 2 then
            local rheight = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
            beiSprite:pos(display.right-30, display.cy+34-rheight/2-25)
            beiSprite:show()
            local lheight = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
            nanSprite:pos(display.left+30, display.cy+34+lheight/2+25)
            nanSprite:show()
        end
        local bwidth = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
        xiSprite:pos(display.cx-bwidth/2-25, display.bottom+18)
        xiSprite:show()
        local twidth = topName:getBoundingBox().width + topScore:getBoundingBox().width
        bankerSprite:pos(display.cx-twidth/2-25, display.top-20)
        bankerSprite:show()
    elseif direct == "bottom" then
        if max_player > 2 then
            local rheight = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
            nanSprite:pos(display.right-30, display.cy+34-rheight/2-25)
            nanSprite:show()
            local lheight = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
            beiSprite:pos(display.left+30, display.cy+34+lheight/2+25)
            beiSprite:show()
        end
        local bwidth = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
        bankerSprite:pos(display.cx-bwidth/2-25, display.bottom+18)
        bankerSprite:show()
        local twidth = topName:getBoundingBox().width + topScore:getBoundingBox().width
        xiSprite:pos(display.cx-twidth/2-25, display.top-20)
        xiSprite:show()
    else
        bankerSprite:hide()
        nanSprite:hide()
        xiSprite:hide()
        beiSprite:hide()
    end
end


function MJPlayers:setMopao(direct)
    if direct == "left" then
        local height = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
        leftMopao:pos(display.left+30, display.cy+34-height/2-25)
        leftMopao:show()
    elseif direct == "right" then
        local height = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
        rightMopao:pos(display.right-30, display.cy+34+height/2+25)
        rightMopao:show()
    elseif direct == "top" then
        local width = topName:getBoundingBox().width + topScore:getBoundingBox().width
        topMopao:pos(display.cx+width/2+25, display.top-20)
        topMopao:show()
    elseif direct == "bottom" then
        local width = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
        bottomMopao:pos(display.cx+width/2+25, display.bottom+18)
        bottomMopao:show()
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

function MJPlayers:setManager(manage, direct)
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

        if not allow then
            sprite[#sprite+1] = self:setCombin("drop", 0, 0, 0)
        end
        
        local num = 4 
        count = #sprite
        for i = 1, count do
            local cur = count + 1 - i
            if i < num + 1 then
                sprite[cur]:pos(display.right-160-(i-1)*320, display.bottom + 280)
                sprite[cur]:show()
            else
                sprite[cur]:pos(display.right-160-(num-1)*320, display.bottom + 280 + (i-num)*180)
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

     leftScore = nil
     rightScore = nil
     topScore = nil 
     bottomScore = nil

     leftReady = nil
     rightReady = nil
     topReady = nil
     bottomReady = nil

     bankerSprite = nil
     nanSprite = nil
     xiSprite = nil
     beiSprite = nil

     tuoguanLayer = nil
     tuoguanButton = nil
     leftTuoguan = nil
     rightTuoguan = nil
     topTuoguan = nil

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
    nanSprite:hide()
    xiSprite:hide()
    beiSprite:hide()
    self:clearManager()
    leftMopao:hide()
    rightMopao:hide()
    topMopao:hide()
    bottomMopao:hide()
end

return MJPlayers