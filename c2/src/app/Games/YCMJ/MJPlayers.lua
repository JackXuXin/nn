local MJPlayers = class("MJPlayers",function()
    return display.newSprite()
end)

local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")

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

local leftHeadFrameBg
local rightHeadFrameBg
local topHeadFrameBg
local bottomHeadFrameBg


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

local AddCardLayer--要牌
local editBox2

-- local mopaoButton
-- local bumopaoButton

-- local leftMopao
-- local rightMopao
-- local topMopao
-- local bottomMopao

function MJPlayers:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 74))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_daocpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(60*(j-1), 48*(i-1), 60, 48))
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
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(56*(j-1), 69.2*(i-1), 56, 69.2))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_ready.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_ready.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitPlayer.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 307, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitPlayer.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_zhuang.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
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

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/icon_mo.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/icon_mo.png")
    
    -- leftMopao = display.newSprite("#ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)
    -- rightMopao = display.newSprite("#ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)
    -- topMopao = display.newSprite("#ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)
    -- bottomMopao = display.newSprite("#ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)

    -- mopaoButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_mo_0.png", pressed = "ShYMJ/btn_mo_1.png" })
    -- :onButtonClicked(function()
    --         self:onMopaoButton(1)
    --  end)
    -- :pos(display.cx-100, display.bottom + 120)
    -- :hide()
    -- :addTo(self)

    -- bumopaoButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_bumo_0.png", pressed = "ShYMJ/btn_bumo_1.png" })
    -- :onButtonClicked(function()
    --         self:onMopaoButton(0)
    --  end)
    -- :pos(display.cx+100, display.bottom + 120)
    -- :hide()
    -- :addTo(self)

    --add head bg
    local basePos_leftHead_x = 80
    local basePos_leftHead_y = display.cy
    local basePos_rightHead_x = display.width - 80
    local basePos_rightHead_y = display.cy
    local basePos_topHead_x = 280
    local basePos_topHead_y = display.height - 100
    local basePos_bottomHead_x = 80
    local basePos_bottomHead_y = 100

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
    local pos_y_offset = 30
    local scale_head = 0.568
    leftHeadFrameBg = display.newSprite()
    :pos(basePos_leftHead_x,basePos_leftHead_y + pos_y_offset)
    :addTo(self)
    :hide()

    rightHeadFrameBg = display.newSprite()
    :pos(basePos_rightHead_x,basePos_rightHead_y + pos_y_offset)
    :addTo(self)
    :hide()

    topHeadFrameBg = display.newSprite()
    :pos(basePos_topHead_x,basePos_topHead_y + pos_y_offset)
    :addTo(self)
    :hide()

    bottomHeadFrameBg = display.newSprite()
    :pos(basePos_bottomHead_x,basePos_bottomHead_y + pos_y_offset)
    :addTo(self)
    :hide()

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

    pos_y_offset = -35

    leftName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=20, text="", align=align})
    :pos(basePos_leftHead_x,basePos_leftHead_y + pos_y_offset)
    --:setRotation(90)
    :addTo(self)
    leftName:setAnchorPoint(0.5, 0.5)

    rightName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=20, text="", align=align})
    :pos(basePos_rightHead_x,basePos_rightHead_y + pos_y_offset)
    --:setRotation(270)
    :addTo(self)
    rightName:setAnchorPoint(0.5, 0.5)

    topName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=20, text="", align=align})
    :pos(basePos_topHead_x,basePos_topHead_y + pos_y_offset)
    :addTo(self)
    topName:setAnchorPoint(0.5, 0.5)

    bottomName = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=20, text="", align=align})
    :pos(basePos_bottomHead_x,basePos_bottomHead_y + pos_y_offset)
    :addTo(self)
    bottomName:setAnchorPoint(0.5, 0.5)

    pos_y_offset = -63
    local pos_x_offset = 7

    leftScore = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    :pos(basePos_leftHead_x + pos_x_offset,basePos_leftHead_y + pos_y_offset)
    --:setRotation(90)
    :addTo(self)
    leftScore:setAnchorPoint(0.5, 0.5)

    rightScore = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    :pos(basePos_rightHead_x + pos_x_offset,basePos_rightHead_y + pos_y_offset)
    --:setRotation(270)
    :addTo(self)
    rightScore:setAnchorPoint(0.5, 0.5)

    topScore = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    :pos(basePos_topHead_x + pos_x_offset,basePos_topHead_y + pos_y_offset)
    :addTo(self)
    topScore:setAnchorPoint(0.5, 0.5)

    bottomScore = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
    :pos(basePos_bottomHead_x + pos_x_offset,basePos_bottomHead_y + pos_y_offset)
    :addTo(self)
    bottomScore:setAnchorPoint(0.5, 0.5)

    

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
    :addTo(self)
    rightReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_rightHead_x,basePos_rightHead_y)
    :hide()
    :addTo(self)
    topReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_topHead_x,basePos_topHead_y)
    :hide()
    :addTo(self)
    bottomReady = display.newSprite("ShYMJ/img_GameUI_ready.png")
    :pos(basePos_bottomHead_x, basePos_bottomHead_y)
    :hide()
    :addTo(self)
    display.newSprite("#ShYMJ/img_GameUI_WaitPlayer.png")
    :pos(560, 100)
    :addTo(bottomReady)

    bankerSprite = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
    :hide()
    :addTo(self,1000)

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






    --要牌器
    AddCardLayer =display.newLayer()
    -- :pos(display.width/2,display.height/2)
    :addTo(self)
    :hide()
   
    local cardtext
    

    editBox2= ccui.EditBox:create(cc.size(400,96), "Image/Logon/input.png")  --输入框尺寸，背景图片
    editBox2:setPosition(display.cx, display.cy)
    -- editBox2:anch(cc.p(0.5,0.5))
    editBox2:setFontSize(26)
    editBox2:setFontColor(cc.c3b(255,255,255))
    editBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND ) --输入键盘返回类型，done，send，go等
    -- editBox2:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --输入模型，如整数类型，URL，电话号码等，会检测是否符合

    editBox2:registerScriptEditBoxHandler(
        function(event,sender) 
            if event == "began" then
                printf("editBox1 event return : %s", sender:getText())
            elseif event == "ended" then
                -- cardtext:setString(editbox:getText())
                cardtext=sender:getText()
                printf("editBox1 event return : %s", sender:getText())
            elseif event == "return" then

                cardtext=sender:getText()
                printf("editBox1 event return : %s", sender:getText())
                
            elseif event == "changed" then
                printf("editBox1 event return : %s", sender:getText())
            else
                printf("EditBox event %s", tostring(event))
            end
    end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    AddCardLayer:addChild(editBox2)
    -- editBox2:setHACenter() --输入的内容锚点为中心，与anch不同，anch是用来确定控件位置的，而这里是确定输入内容向什么方向展开(。。。说不清了。。自己测试一下)



    local AddCardYWButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_hun_normal.png", pressed = "ShYMJ/ani_special_hun_selected.png" })
    :onButtonClicked(function()
        print("yaopai1")
            if cardtext=="" or cardtext==nil then
                --todo
                print("yaopai2")
                self.callBack:AddCardYW({1})
            else
                print("yaopai3")
                local card = string.split(cardtext, ",")
                self.callBack:AddCardYW(card)
                self:addCardYouWant(0) ---隐藏请求发牌
            end
            
            
     end)
    :pos(display.width/2+350,display.height/2)
    :show()
    :addTo(AddCardLayer)

end

--要牌器
function MJPlayers:addCardYouWant(num)
    if num>0 then
        AddCardLayer:show()
        editBox2:show()
    else
        AddCardLayer:hide()
        editBox2:hide()
    end
end


function MJPlayers:addCombin(combin, index)
    local card = 16*4 + 8
    if combin == "left" then
        local sprite = display.newSprite()
        :pos(150, 60)
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
        :pos(42, 48)
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
        :pos(150, 60)
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
        :pos(42, 48)
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
        :pos(150, 60)
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
        :pos(42, 48)
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
        :pos(150, 60)
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
        :pos(150, 60)
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
        :pos(150, 60)
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

function MJPlayers:getHead(direct)
    return playerHead[direct]
end
function MJPlayers:getWeixinHead(direct)
    return playerImage_weixin[direct]
end

function MJPlayers:setPlayer(direct, name, score, sex, viptype, imageid)
    name = util.checkNickName(name)
    print(direct, name, score, sex, viptype)
    print("setPlayer--imageid,",imageid)
    local str = string.format("%s", util.num2str_text(score))
    --set head
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    playerHead[direct] = image
    if imageid and imageid ~="" then
        --todo
        playerImage_weixin[direct] = imageid
    end
    local rect = cc.rect(0, 0, 188, 188)
    local frame_head = cc.SpriteFrame:create(image, rect)

    -- local image_framebg = AvatarConfig:getAvatarBG(sex, score, viptype,1)
    -- local rectbg = cc.rect(0, 0, 105, 105)
    -- local frame_headbg = cc.SpriteFrame:create(image_framebg, rectbg)

    if direct == "left" then
        leftName:setString(name)
        leftScore:setString(str)
        leftHeadBg:show()
        leftHead:show()
        leftHead:setSpriteFrame(frame_head)

        leftHeadFrameBg:show()
        --leftHeadFrameBg:setSpriteFrame(frame_headbg)
       --modify by whb 161031
        if viptype > 0 then
           leftName:setColor(cc.c3b(255, 0, 0))
        end
       --modify end
        --设置微信头像
        util.setHeadImage(self, imageid, leftHead, image, 1)


    elseif direct == "right" then
        rightName:setString(name)
        rightScore:setString(str)
        rightHeadBg:show()
        rightHead:show()
        rightHead:setSpriteFrame(frame_head)
        rightHeadFrameBg:show()
        --rightHeadFrameBg:setSpriteFrame(frame_headbg)
        --modify by whb 161031
           if viptype > 0 then
              rightName:setColor(cc.c3b(255, 0, 0))
           end
        --modify end

        --设置微信头像
        util.setHeadImage(self, imageid, rightHead, image, 2)

    elseif direct == "top" then
        topName:setString(name)
        topScore:setString(str)
        topHeadBg:show()
        topHead:show()
        topHead:setSpriteFrame(frame_head)
        topHeadFrameBg:show()
        --topHeadFrameBg:setSpriteFrame(frame_headbg)
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
        bottomName:setString(name)
        bottomScore:setString(str)
        bottomHeadBg:show()
        bottomHead:show()
        bottomHead:setSpriteFrame(frame_head)
        bottomHeadFrameBg:show()
        --bottomHeadFrameBg:setSpriteFrame(frame_headbg)

        --设置微信头像
         util.setHeadImage(self, imageid, bottomHead, image, 4)
        
    end

    leftHeadFrameBg:hide()
    rightHeadFrameBg:hide()
    topHeadFrameBg:hide()
    bottomHeadFrameBg:hide()
    
    playerSex[direct] = sex
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

function MJPlayers:clearPlayer(direct)
     print("MJPlayers:clearPlayer--,",direct)
    if direct == "left" then
        leftName:setString("")
        leftScore:setString("")
        leftHead:hide()
        leftHeadBg:hide()
        leftHeadFrameBg:hide()
        util.setImageNodeHide(self, 1)
    elseif direct == "right" then
        rightName:setString("")
        rightScore:setString("")
        rightHead:hide()
        rightHeadBg:hide()
        rightHeadFrameBg:hide()
        util.setImageNodeHide(self, 2)
    elseif direct == "top" then
        topName:setString("")
        topScore:setString("")
        topHead:hide()
        topHeadBg:hide()
        topHeadFrameBg:hide()
        util.setImageNodeHide(self, 3)
    elseif direct == "bottom" then
        bottomName:setString("")
        bottomScore:setString("")
        bottomHead:hide()
        bottomHeadBg:hide()
        bottomHeadFrameBg:hide()
        util.setImageNodeHide(self, 4)
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

function MJPlayers:setBanker(direct,islian)
    --是否连庄
    if islian>1 then
        --todo
        print("连庄")
        bankerSprite:setTexture("ShYMJ/img_GameUI_lian_zhuang.png")
    else
        print("正常庄")
        bankerSprite:setTexture("ShYMJ/img_GameUI_zhuang.png")
    end

    local target
    if direct == "left" then
        target = leftHeadBg
        bankerSprite:show()
    elseif direct == "right" then
        target = rightHeadBg
        bankerSprite:show()
    elseif direct == "top" then
        target = topHeadBg
        bankerSprite:show()
    elseif direct == "bottom" then
        target = bottomHeadBg
        bankerSprite:show()
    else
        bankerSprite:hide()
    end
    if target then
        bankerSprite:setPosition(cc.p(target:getPositionX() + 60,target:getPositionY() + 83))
    end
end


-- function MJPlayers:setMopao(direct)
--     if direct == "left" then
--         local height = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
--         leftMopao:pos(display.left+30, display.cy+34-height/2-25)
--         leftMopao:show()
--     elseif direct == "right" then
--         local height = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
--         rightMopao:pos(display.right-30, display.cy+34+height/2+25)
--         rightMopao:show()
--     elseif direct == "top" then
--         local width = topName:getBoundingBox().width + topScore:getBoundingBox().width
--         topMopao:pos(display.cx+width/2+25, display.top-20)
--         topMopao:show()
--     elseif direct == "bottom" then
--         local width = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
--         bottomMopao:pos(display.cx+width/2+25, display.bottom+18)
--         bottomMopao:show()
--     end
-- end

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
    --要牌器
    AddCardLayer:hide()
    editBox2:hide()
    -- mopaoButton:hide()
    -- bumopaoButton:hide()
end

-- function MJPlayers:onMopaoButton(select)
--     mopaoButton:hide()
--     bumopaoButton:hide()
--     self.callBack:onSelectInfo(select)
-- end

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

-- function MJPlayers:allowMopao()
--     mopaoButton:show()
--     bumopaoButton:show()
-- end

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

     tuoguanLayer = nil
     tuoguanButton = nil
     leftTuoguan = nil
     rightTuoguan = nil
     topTuoguan = nil

    leftHeadBg = nil
    rightHeadBg = nil
    topHeadBg = nil
    bottomHeadBg = nil

    leftHeadFrameBg = nil
    rightHeadFrameBg = nil
    topHeadFrameBg = nil
    bottomHeadFrameBg = nil

    leftHead = nil
    rightHead = nil
    topHead = nil
    bottomHead = nil

    playerHead = {}
    playerImage_weixin = {}

     ---要牌器
     AddCardLayer =nil
     editBox2 =nil
     -- mopaoButton = nil
     -- bumopaoButton = nil

     -- leftMopao = nil 
     -- rightMopao = nil
     -- topMopao = nil
     -- bottomMopao = nil
end

function MJPlayers:restart()
    self:hideAllButton()
    bankerSprite:hide()
    self:clearManager()
    -- leftMopao:hide()
    -- rightMopao:hide()
    -- topMopao:hide()
    -- bottomMopao:hide()

     --要牌器
    AddCardLayer:hide()
    editBox2:hide()
end

return MJPlayers