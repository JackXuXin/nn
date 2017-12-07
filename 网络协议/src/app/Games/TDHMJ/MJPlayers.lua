local MJPlayers = class("MJPlayers",function()
    return display.newSprite()
end)

local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
-- local sound = require("app.Games.TDHMJ.MJSound")

--时间调度器
-- local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
--local scheduler = require("app.Common.LocalScheduler")
-- local downTimer 
-- local _Num
-- local downTimerNum
-- local downTimerBG
-- local directTimer


local AddCardLayer--要牌
local editBox2
local cardtext


local startButton
local hunButton
local TingButton
local dropButton

local pengCombin
local gangCombin

local bugangCombin = {}
local angangCombin = {}
local chiCombin = {}
local flowerCombin = {} --只有多个同时存在，才用表结构
flowerCombin["angang"] = {}
flowerCombin["bugang"] = {}
flowerCombin["chi"] = {}
local cardCombin = {}
cardCombin["angang"] = {}
cardCombin["bugang"] = {}
cardCombin["chi"] = {}
local playerSex = {}


local playerHead = {} --头像的表

local leftHeadBg
local rightHeadBg
local topHeadBg
local bottomHeadBg

local leftHeadFrameBg
local rightHeadFrameBg
local topHeadFrameBg
local bottomHeadFrameBg

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
-- local nanSprite
-- local xiSprite
-- local beiSprite

local tuoguanLayer
local tuoguanButton

local leftTuoguan
local rightTuoguan
local topTuoguan

-- local mopaoButton
-- local bumopaoButton

-- local leftMopao
-- local rightMopao
-- local topMopao
-- local bottomMopao
--花牌的个数
-- local flower_left
-- local flower_right
-- local flower_top
-- local flower_bottom
-- local flower_text1
-- local flower_text2
-- local flower_text3
-- local flower_text4
-- local flower_num={}
--比下胡
local bixiahu_Sp


--下鱼子界面
-- local fishLayer
-- local fishBtnlist={}

function MJPlayers:ctor()
    print("MJPlayers:ctorkjkh 只调用一次")
    -- local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg.png")
    -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 85, 70))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_daocpg.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(85*(j-1), 66*(i-1), 85, 66))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_daocpg%d.png", i*16+j))
    --     end
    -- end
    
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(56*(j-1), 69.2*(i-1), 56, 69.2))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_ready.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 40))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_ready.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitPlayer.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 307, 54))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitPlayer.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_zhuang.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_zhuang.png")
    -- -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_nan.png")
    -- -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    -- -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_nan.png")
    -- -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_xi.png")
    -- -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    -- -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_xi.png")
    -- -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_bei.png")
    -- -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    -- -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_bei.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitDian.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 16, 16))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitDian.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_EmptyDian.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 10, 9))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_EmptyDian.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tuoguan_zhi.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 117, 68))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tuoguan_zhi.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/bixiahu.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 92, 38))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/bixiahu.png")
    

    -- bankerSprite = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
    -- :hide()
    -- :addTo(self)
    -- nanSprite = display.newSprite("#ShYMJ/img_GameUI_nan.png")
    -- :hide()
    -- :addTo(self)
    -- xiSprite = display.newSprite("#ShYMJ/img_GameUI_xi.png")
    -- :hide()
    -- :addTo(self)
    -- beiSprite = display.newSprite("#ShYMJ/img_GameUI_bei.png")
    -- :hide()
    -- :addTo(self)
    


    --添加头像背景
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

    --玩家名称
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
    --玩家分数
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

    --庄家图标
    bankerSprite = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
    :hide()
    :addTo(self)
    --开始按钮
    startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_kaishi_normal.png", pressed = "ShYMJ/button_kaishi_selected.png" })
    :onButtonClicked(function()
            self:onStartButton()
     end)
    :pos(display.cx + 150, display.bottom + 120)
    :hide()
    :addTo(self)
    --准备显示
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



    --花牌数目
    -- flower_left =  display.newSprite("ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)

    -- flower_text1=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    --     :pos(60, 30)--30
    --     :addTo(flower_left)
    -- flower_text1:setAnchorPoint(0.5, 1)


    -- flower_right = display.newSprite("ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)

    -- flower_text2=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    -- :pos(60, 8)--10
    -- :addTo(flower_right)
    -- flower_text2:setAnchorPoint(0.5, 0)


    -- flower_top =   display.newSprite("ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)

    -- flower_text3=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    -- :pos(50, 20)   
    -- :addTo(flower_top)
    -- flower_text3:setAnchorPoint(0, 0.5)


    -- flower_bottom = display.newSprite("ShYMJ/icon_mo.png")
    -- :hide()
    -- :addTo(self)

    -- flower_text4=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=24, text="", align=align})
    -- :pos(50, 20)
    -- :addTo(flower_bottom)
    -- flower_text4:setAnchorPoint(0, 0.5)
    
    
    --比下胡
    bixiahu_Sp = display.newSprite("#ShYMJ/NJResult/bixiahu.png")
    :setScale(0.8)
    :hide()
    :pos(display.right-240,display.top-55)
    :addTo(self)

    
    --------------------------下鱼子界面------------------------------
    
    ----------------------------------------------------------------
    

    --要牌器
    AddCardLayer =display.newLayer()
    -- :pos(display.width/2,display.height/2)
    :addTo(self)
    :hide()
    -- cardtext = cc.ui.UILabel.new({text = "123123", size = 14, color = display.COLOR_BLACK})
    --     :pos(display.width/2-130,display.height/2+100)
    --     :setScale(6)
    --     :addTo(AddCardLayer)
    local cardtext
    -- editBox2 = cc.ui.UIInput.new({
    --     image = "Image/Logon/input.png",
    --     size = cc.size(400, 96),
    --     x = display.cx,
    --     y = display.cy,
    --     listener = function(event, editbox2)
    --         if event == "began" then
    --             printf("editBox1 event return : %s", editbox2:getText())
    --         elseif event == "ended" then
    --             -- cardtext:setString(editbox:getText())
    --             cardtext=editbox2:getText()
    --             printf("editBox1 event return : %s", editbox2:getText())
    --         elseif event == "return" then

    --             cardtext=editbox2:getText()
    --             printf("editBox1 event return : %s", editbox2:getText())
                
    --         elseif event == "changed" then
    --             printf("editBox1 event return : %s", editbox2:getText())
    --         else
    --             printf("EditBox event %s", tostring(event))
    --         end
    --     end
    -- })
    -- editBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    -- editBox2:setPosition(display.width/2,display.height/2)
    -- editBox2:hide()
    -- AddCardLayer:addChild(editBox2)

    

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

    
    







    --胡牌
    hunButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_hun_normal.png", pressed = "ShYMJ/ani_special_hun_selected.png" })
    :onButtonClicked(function()
            -- sound.combinCard("hun",playerSex["bottom"],0)
            self:onHunButton()
     end)
    :pos(display.right-303, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)

    --听牌
    TingButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_ting_normal.png", pressed = "ShYMJ/ani_special_ting_normal.png" })
    :onButtonClicked(function()
            -- sound.combinCard("hun",playerSex["bottom"],0)
            self:onTingButton()
     end)
    :pos(display.right-303, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)
    --弃牌按钮
    dropButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/ani_special_cancel_normal.png", pressed = "ShYMJ/ani_special_cancel_selected.png" })
    :onButtonClicked(function()
            self:onDropButton()
     end)
    :pos(display.right-131, display.bottom + 250)
    -- :setScale(182/288)
    :hide()
    :addTo(self)
    
    --碰
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
                -- sound.combinCard("peng",playerSex["bottom"],0)
                self:onCombinButton("peng")
            end
        end
    end)
    for i = 1, 3 do
        --吃
        chiCombin[i] = display.newSprite("ShYMJ/img_hint_background.png")
        :pos(display.right-91-3*182, display.bottom + 250)
        -- :setScale(182/288)
        :hide()
        :addTo(self)

        local hit_chi = display.newSprite("ShYMJ/img_hint_background_chi.png")
        :pos(0,128)
        :addTo(chiCombin[i])
        hit_chi:setLocalZOrder(2)

        self:addCombin("chi")
        chiCombin[i]:setTouchEnabled(true)                   
        chiCombin[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                return true
            elseif event.name == "ended" then
                if chiCombin[i]:hitTest(cc.p(event.x, event.y), false) then
                -- sound.combinCard("peng",playerSex["bottom"],0)
                    self:onCombinButton("chi")
                end
            end
        end)
    end

    --杠
    
    gangCombin = display.newSprite("ShYMJ/img_hint_background.png")
    :pos(display.right-91-2*182, display.bottom + 250)
        -- :setScale(182/288)
    :hide()
    :addTo(self)

    local hit_gang = display.newSprite("ShYMJ/img_hint_background_gang.png")
    :pos(0,128)
    :addTo(gangCombin)
    hit_gang:setLocalZOrder(2)

    self:addCombin("gang", i)
    gangCombin:setTouchEnabled(true)                   
    gangCombin:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            if gangCombin:hitTest(cc.p(event.x, event.y), false) then
                    -- sound.combinCard("gang",playerSex["bottom"],0)
                self:onCombinButton("gang", i)
            end
        end
    end)
    
--补杠
    for i = 1, 3 do
        bugangCombin[i] = display.newSprite("ShYMJ/img_hint_background.png")
        :pos(display.right-91-2*182, display.bottom + 250)
        -- :setScale(182/288)
        :hide()
        :addTo(self)

        local hit_gang = display.newSprite("ShYMJ/img_hint_background_gang.png")
        :pos(0,128)
        :addTo(bugangCombin[i])
        hit_gang:setLocalZOrder(2)

        self:addCombin("bugang", i)
        bugangCombin[i]:setTouchEnabled(true)                   
        bugangCombin[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                return true
            elseif event.name == "ended" then
                if bugangCombin[i]:hitTest(cc.p(event.x, event.y), false) then
                    -- sound.combinCard("gang",playerSex["bottom"],0)
                    self:onCombinButton("bugang", i)
                end
            end
        end)
    end

    --暗杠
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
                    -- sound.combinCard("gang",playerSex["bottom"],0)
                    self:onCombinButton("angang", i)
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

   

end
-----------------------------------
function MJPlayers:SetBixiahu(var)

    if var==2 then
        bixiahu_Sp:show()
    else
        bixiahu_Sp:hide()
    end
end
--重置花牌数目
function MJPlayers:ReSetFlowerNum()
    
    -- flower_num["left"]=0
    -- flower_num["right"]=0
    -- flower_num["top"]=0
    -- flower_num["bottom"]=0
    -- flower_text1:setString("")
    -- flower_text2:setString("")
    -- flower_text3:setString("")
    -- flower_text4:setString("")
end

function MJPlayers:SetFlowerNum(combin, index)
    print("SetFlowerNum---------:")

    -- flower_num[combin]=index+flower_num[combin]
    
    -- if combin == "left" then
    --     local height = leftName:getBoundingBox().height + leftScore:getBoundingBox().height
    --     flower_left:pos(display.left+30, display.cy+34-height/2-25)
    --     flower_left:show()
    --     flower_left:setRotation(90)

       
    --     flower_text1:setString(string.format(" X %d", flower_num[combin]))
    -- elseif combin == "right" then
    --     local height = rightName:getBoundingBox().height + rightScore:getBoundingBox().height
    --     flower_right:pos(display.right-30, display.cy+34+height/2+25)
    --     flower_right:show()
    --     flower_right:setRotation(270)
        
    --     flower_text2:setString(string.format(" X %d", flower_num[combin]))
    -- elseif combin == "top" then
    --     local width = topName:getBoundingBox().width + topScore:getBoundingBox().width
    --     flower_top:pos(display.cx+width/2+25, display.top-20)
    --     flower_top:show()
        
    --     flower_text3:setString(string.format(" X %d", flower_num[combin]))
    -- elseif combin == "bottom" then
    --     local width = bottomName:getBoundingBox().width + bottomScore:getBoundingBox().width
    --     flower_bottom:pos(display.cx+width/2+25, display.bottom+18)
    --     flower_bottom:show()
        
    --     flower_text4:setString(string.format(" X %d", flower_num[combin]))
    -- end
    
end
---------------------------------------
function MJPlayers:addCombin(combin, index)
    local card = 16*4 + 8
    
    if combin == "peng" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(pengCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        flowerCombin[combin] = {flower, flower1, flower2}
    elseif combin == "chi" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(pengCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        flowerCombin[combin][index] = {flower, flower1, flower2}
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
        :pos(30, 54)
        :addTo(temp)
        -- if index == 1 then
        --     flowerCombin[combin] = {flower}
        -- else

        --     flowerCombin[combin][index] = {flower}
        -- end
        -- flowerCombin[combin]={}
        flowerCombin[combin][index] = {flower}
        -- table.insert(flowerCombin[combin],{flower})
    elseif combin == "gang" then
        print("addCombin杠 " ..card)
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(gangCombin)
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(0,16)
        :addTo(sprite)
        local flower3 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        
        flowerCombin[combin] = {flower, flower1, flower2, flower3}
        
    elseif combin == "bugang" then
        local sprite = display.newSprite()
        :pos(150, 60)
        :addTo(bugangCombin[index])
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(-60,0)
        :addTo(sprite)
        local flower1 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(60,0)
        :addTo(sprite)
        local flower2 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(0,16)
        :addTo(sprite)
        local flower3 = display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
        :pos(30, 54)
        :addTo(temp)

        -- if index == 1 then
        --     flowerCombin[combin] = {flower, flower1, flower2, flower3}
        --     print("输出补杠1" ..type(flowerCombin[combin][1]))
        --     print("输出补杠2" ..type(flowerCombin[combin][2]))
        --     print("输出补杠3" ..type(flowerCombin[combin][3]))
        --     print("输出补杠4" ..type(flowerCombin[combin][4]))
        -- else
        -- flowerCombin[combin]={}
        flowerCombin[combin][index] = {flower, flower1, flower2, flower3}
        -- end
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

function MJPlayers:setPlayer(direct, name, score, sex, viptype)
    name = util.checkNickName(name)
    local str = string.format("%s", util.num2str_text(score))  --要解开
    -- local str = string.format("%s", score)
    --set head
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    playerHead[direct] = image
    local rect = cc.rect(0, 0, 188, 188)
    local frame_head = cc.SpriteFrame:create(image, rect)

    -- local image_framebg = AvatarConfig:getAvatarBG(sex, score, viptype,1)  --要解开
    -- -- local image_framebg = AvatarConfig:getAvatar(sex, score, viptype,1)
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


       -- topName:setColor(cc.c3b(255, 0, 0))
    elseif direct == "bottom" then

print("eeeeeee---------")
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
       -- bottomHeadFrameBg:setSpriteFrame(frame_headbg)
    end

    leftHeadFrameBg:hide()
    rightHeadFrameBg:hide()
    topHeadFrameBg:hide()
    bottomHeadFrameBg:hide()
    playerSex[direct] = sex
end

function MJPlayers:clearPlayer(direct)
    if direct == "left" then
        leftName:setString("")
        leftScore:setString("")
        leftHead:hide()
        leftHeadBg:hide()
        leftHeadFrameBg:hide()
    elseif direct == "right" then
        rightName:setString("")
        rightScore:setString("")
        rightHead:hide()
        rightHeadBg:hide()
        rightHeadFrameBg:hide()
    elseif direct == "top" then
        topName:setString("")
        topScore:setString("")
        topHead:hide()
        topHeadBg:hide()
        topHeadFrameBg:hide()
    elseif direct == "bottom" then
        bottomName:setString("")
        bottomScore:setString("")
        bottomHead:hide()
        bottomHeadBg:hide()
        bottomHeadFrameBg:hide()
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
    elseif direct == "all" then
        if ready then
            leftReady:show()
            rightReady:show()
            topReady:show()
            bottomReady:show()
        else
            leftReady:hide()
            rightReady:hide()
            topReady:hide()
            bottomReady:hide()
        end
    end
end

function MJPlayers:setBanker(direct)
    print("庄家图标1")
    local target
    if direct == "left" then
        print("庄家图标2")
        target = leftHeadBg
        bankerSprite:show()
        -- bankerSprite:setPosition(80+60,display.cy+83)
    elseif direct == "right" then
        print("庄家图标3")
        target = rightHeadBg
        bankerSprite:show()
        -- bankerSprite:setPosition(display.width-80+60,display.cy+83)
    elseif direct == "top" then
        print("庄家图标4")
        target = topHeadBg
        bankerSprite:show()
        -- bankerSprite:setPosition(280+60,display.height-100+83)
    elseif direct == "bottom" then
        print("庄家图标5")
        target = bottomHeadBg
        bankerSprite:show()
        -- bankerSprite:setPosition(80+60,100+83)
    else
        print("庄家图标6")
        bankerSprite:hide()
    end
    if target then
        print("庄家图标7 x:" ..target:getPositionX() .."y:" ..target:getPositionY())
        bankerSprite:setPosition(cc.p(target:getPositionX() + 60,target:getPositionY() + 83))
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
    TingButton:hide()
    dropButton:hide()
    -- leftCombin:hide()
    -- centerCombin:hide()
    -- rightCombin:hide()
    pengCombin:hide()
    
    gangCombin:hide()
    
    for i = 1, #angangCombin do
        angangCombin[i]:hide()
    end
    for i = 1, #bugangCombin do
         bugangCombin[i]:hide()
    end
    
end



function MJPlayers:onStartButton()
    startButton:hide()
    
    print("准备开始游戏++++onStartButton")
    self.callBack:onStart()
    util.SetRequestBtnHide()
end

function MJPlayers:onHunButton() --胡牌按钮回调
    self:hideAllButton()
    self.callBack:onHuCard()
end

function MJPlayers:onTingButton() --听牌按钮回调
    self:hideAllButton()
    self.callBack:onTingCard()
end

function MJPlayers:onDropButton() --放弃按钮回调
    self:hideAllButton()
    self.callBack:onIgnoreCard()
end



function MJPlayers:onManagerButton()
    tuoguanButton:hide()
    self.callBack:onCanelManager()
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
function MJPlayers:onCombinButton(combin, index)
    self:hideAllButton()
    if combin=="angang" or combin=="bugang" then
        print("发送碰杠胡操作1++")
        self.callBack:onCombinCard(combin, cardCombin[combin][index])
    elseif  combin=="chi" then
        self.callBack:onCombinCard(combin, cardCombin[combin][index],cardCombin[combin]["chi"])
    else
        print("发送碰杠胡操作4++")
        self.callBack:onCombinCard(combin, cardCombin[combin])
    end
    
end

function MJPlayers:setManager(manage, direct)
    print("托管1")
    if direct == "left" then
        if manage then
             print("托管2")
            leftTuoguan:hide()
        else
             print("托管3")
            leftTuoguan:show()
            
        end
    elseif direct == "right" then
        if manage then
             print("托管4")
            rightTuoguan:hide()
        else
            print("托管42")
            rightTuoguan:show()
            
        end
    elseif direct == "top" then
        if manage then
             print("托管5")
            topTuoguan:hide()
        else
             print("托管6")
            topTuoguan:show()
            
        end

    elseif direct == "bottom" then
        if manage then
             print("托管7")
            tuoguanButton:hide()
            tuoguanLayer:hide()
        else
             print("托管8")
            tuoguanButton:show()
            tuoguanLayer:show()
            
        end
    end
end

function MJPlayers:clearManager()
    self:setManager(true, "left")
    self:setManager(true, "right")
    self:setManager(true, "top")
    self:setManager(true, "bottom")
end

function MJPlayers:setCombin(combin, card, index,chi)--index 代表可以杠的数目  out 0或1
    
    if combin == "peng" then
        local flower = flowerCombin[combin]
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        flower[2]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        flower[3]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        cardCombin[combin] = card
        return pengCombin
    elseif combin == "chi" then
        local flower = flowerCombin[combin]
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card[1])))
        flower[2]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card[2])))
        flower[3]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card[3])))
        cardCombin[combin][index] = card
        cardCombin[combin]["chi"] = chi
        return chiCombin[index]
    elseif combin == "gang" then
        print("明杠操作1 "  ..card)
        cardCombin[combin] = card
        print("明杠操作2 "  ..card)
        local flower = flowerCombin[combin]
        print("明杠操作3 "  ..card)
        for i = 1, #flower do
            print("明杠操作4 "  ..card)
            flower[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        end
        print("明杠操作5 "  ..card)
        return gangCombin
    elseif combin == "angang" then
        local flower
        print("暗杠操作1 "  ..card)
        
        print("暗杠操作3 "  ..card)

        cardCombin[combin][index] = card
        flower = flowerCombin[combin][index]
        print("暗杠操作4 "  ..card)
        flower[1]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        print("暗杠操作5 "  ..card)
        return angangCombin[index]
    elseif combin == "bugang" then
        local flower
        print("补杠操作1 "  ..card)
        
        
        print("补杠操作3 "  ..card)
        cardCombin[combin][index] = card
        flower = flowerCombin[combin][index]

        print("补杠操作4 "  ..card)
        print("排数：" ..#flower)
        for i = 1, #flower do
            print("leixing" ..type(flower[i]))
            print("补杠操作5 "  ..card)
            flower[i]:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
        end
        return bugangCombin[index]
    elseif combin == "hun" then
        return hunButton
    elseif combin == "Ting" then
        return TingButton
    elseif combin == "drop" then
        return dropButton
    end
end

function MJPlayers:allowTing() --允许听牌操作
    
    self:hideAllButton()
    local index = 0
    local sprite = {}

    --添加放弃按钮
    index = index + 1
    sprite[#sprite+1] = self:setCombin("drop", 1, 1)

    --添加听牌按钮
    index = index + 1
    sprite[#sprite+1] = self:setCombin("Ting", 1, 1)

    
     
    local count = #sprite
    for i = 1, count do
        sprite[i]:pos(display.right-160-(i-1)*200, display.bottom + 280)
        sprite[i]:show()
        
    end        
end

function MJPlayers:allowCombin(combinTab)
    print("----------------------")
    dump(combinTab)
    print("----------------------")
    self:hideAllButton()
    local index = 0
    local sprite = {}
    
    print(type(combinTab.an_gang))
    print(type(combinTab.bu_gang))
    print(type(combinTab.ming_gang))
    print("-------------------------------aa")
    if combinTab.an_gang ~= nil and type(combinTab.an_gang)=="table" and #combinTab.an_gang>0 then

        print("暗杠的值 " )
        dump(combinTab.an_gang)
        local num =#combinTab.an_gang
        for i=1, num do
            index = index + 1
            print("暗杠" ..i)
            sprite[#sprite+1] = self:setCombin("angang", combinTab.an_gang[i], i)
        end
    end
    if combinTab.ming_gang ~=nil and combinTab.ming_gang>0 and combinTab.ming_gang<72 then --
        print("明杠的值 " ..combinTab.ming_gang)
        index = index + 1
        sprite[#sprite+1] = self:setCombin("gang", combinTab.ming_gang, 1)
            
    end
   if combinTab.bu_gang ~= nil and type(combinTab.bu_gang)=="table" and #combinTab.bu_gang>0 then --

        print("补杠的值 " )
        dump(combinTab.bu_gang)
        local num =#combinTab.bu_gang
        for i=1, num do
            index = index + 1
            sprite[#sprite+1] = self:setCombin("bugang", combinTab.bu_gang[i],i)
        end
    end
    --吃牌
    if combinTab.chi_combins~=nil and type(combinTab.chi_combins)=="table" and #combinTab.chi_combins>0 then --
        
        index = index + 1
        for i=1,#combinTab.chi_combins do
            dump(combinTab.chi_combins,"吃的牌", 2)
            sprite[#sprite+1] = self:setCombin("chi", combinTab.chi_combins[i], i,combinTab.chi)
        end
        
        
    end
    if combinTab.peng~=nil and combinTab.peng>0 and combinTab.peng<72 then --
        
        index = index + 1
        print("碰的值： " ..combinTab.peng)
        sprite[#sprite+1] = self:setCombin("peng", combinTab.peng, 1)
        
    end
    if combinTab.hu==1 then
        index = index + 1
        sprite[#sprite+1] = self:setCombin("hun", 1, 1)
    end
    local drop_x = 0
    if combinTab.ignore==1 then
        index = index + 1
        sprite[#sprite+1] = self:setCombin("drop", 1, 1)
        drop_x = 90
    end
    local num = 4 
    local count = #sprite
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

function MJPlayers:allowReady()
    startButton:show()
end

function MJPlayers:allowMopao()
    -- mopaoButton:show()
    -- bumopaoButton:show()
end

function MJPlayers:clear()
     startButton = nil
     hunButton = nil
     TingButton = nil
     dropButton = nil
     
     pengCombin = nil
     gangCombin = nil
     bugangCombin = {}
     angangCombin = {}
     flowerCombin = {}
     flowerCombin["angang"] = {}
     flowerCombin["bugang"] = {}
     cardCombin = {}
     cardCombin["angang"] = {}
     cardCombin["bugang"] = {}
     playerSex = {}
     playerHead = {}


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
     -- nanSprite = nil
     -- xiSprite = nil
     -- beiSprite = nil

     tuoguanLayer = nil
     tuoguanButton = nil
     leftTuoguan = nil
     rightTuoguan = nil
     topTuoguan = nil

     bixiahu_Sp=nil

     -- flower_left = nil
     -- flower_right = nil
     -- flower_top = nil
     -- flower_bottom = nil
     -- flower_text1 =nil
     -- flower_text2 =nil
     -- flower_text3 =nil
     -- flower_text4 =nil
     -- flower_num ={}

     ---要牌器
     AddCardLayer =nil
     editBox2 =nil
end

function MJPlayers:restart()
    self:hideAllButton()
    bankerSprite:hide()
    -- nanSprite:hide()
    -- xiSprite:hide()
    -- beiSprite:hide()
    self:clearManager()
   

    -- flower_left:hide()
    -- flower_right:hide()
    -- flower_top:hide()
    -- flower_bottom:hide()

    self:ReSetFlowerNum()--重新设置花牌的数目

  
    --要牌器
    AddCardLayer:hide()
    editBox2:hide()

end

return MJPlayers