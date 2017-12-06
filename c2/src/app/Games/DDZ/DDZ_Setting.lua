local DDZ_Setting = class("DDZ_Setting",function()
    return display.newSprite()
end)
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
-- local GamePopBoxLayer = require("app.layers.GamePopBoxLayer")
local Share = require("app.User.Share")
local sound = require("app.Games.DDZ.DDZ_Audio")
local sound_common = require("app.Common.sound_common")
local message = require("app.net.Message")
local util = require("app.Common.util")
local errorLayer = require("app.layers.ErrorLayer")

local background
local showButton
local hideButton
local openSound
local closeSound
local outButton
local shareButton

local usefulSoundBtn    --常用语按钮
local usefulNode        --常用语节点
local usefulTest        --常用语
local flag = true              --是否显示常用语界面
local isOpenBg = false
local isOn = true

function DDZ_Setting:ctor()

    background = display.newSprite("Image/DDZ/setting/setting_bg.png")
    :pos(display.right + 155/2, display.top - 198)
    :addTo(self)
    :hide()
    background:setTouchEnabled(true)
    background:setTouchSwallowEnabled(true)

    -- openSound = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_yinliang_kq_normal.png", pressed = "ShYMJ/button_yinliang_kq_selected.png" })
    -- :onButtonClicked(function()
    --         self:onSoundButton(false)
    --  end)
    -- :pos(41-3, 120+60)
    -- -- :hide()
    -- :addTo(background)

    -- closeSound = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_yinliang_gb_normal.png", pressed = "ShYMJ/button_yinliang_gb_selected.png" })
    -- :onButtonClicked(function()
    --         self:onSoundButton(true)
    --  end)
    -- :pos(41-3, 120+60)
    -- -- :hide()
    -- :addTo(background)

    outButton = cc.ui.UIPushButton.new({ normal = "Image/DDZ/setting/button_quit_normal.png", pressed = "Image/DDZ/setting/button_quit_normal.png" })
    :onButtonClicked(
        function()
            self:onLeaveButton()
        end)
    :pos(155/2, 155)
    -- :hide()
    :addTo(background)
    util.BtnScaleFun(outButton)

    jieSanButton = cc.ui.UIPushButton.new({ normal = "Image/DDZ/setting/btn_dissolution_01.png", pressed = "Image/DDZ/setting/btn_dissolution_01.png" })
    :pos(155/2, 95)
    -- :hide()
    :addTo(background)
    util.BtnScaleFun(jieSanButton)

    local ruleBtn = cc.ui.UIPushButton.new({ normal = "Image/DDZ/setting/btn_RuleBtn.png", pressed = "Image/DDZ/setting/btn_RuleBtn.png" })
    :onButtonClicked(
         function()
                self:showRuleMenu()
         end)
    :pos(155/2, 35)
    -- :hide()
    :addTo(background)
    util.BtnScaleFun(ruleBtn)

    showButton = cc.ui.UIPushButton.new({ normal = "Image/DDZ/setting/button_ccdown_norma.png", pressed = "Image/DDZ/setting/button_ccdown_norma.png" })
    :onButtonClicked(
        function()

            self:onShowButton(isOn)
        end)
    :pos(display.right - 48,670)
    :addTo(self)
    util.BtnScaleFun(showButton)

    -- hideButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccup_norma.png", pressed = "ShYMJ/button_ccup_selected.png" })
    -- :onButtonClicked(function()
    --         self:onShowButton(false)
    --  end)
    -- :pos(41-3, 207+60)
    -- -- :hide()
    -- :addTo(background)

    

    self:onSoundButton(app.constant.voiceOn)
end

--[[
--常用语按钮回调
function DDZ_Setting:usefulSoundClick()
    if flag then
        --按钮不能触摸
        usefulSoundBtn:setTouchEnabled(false)
        
        usefulNode = display.newNode()
        :pos(460,0)
        :addTo(self)

        local imgBg = display.newScale9Sprite()
        :setScale9Enabled(true)
        :setContentSize(1280,720)
        -- :setColor(cc.c3b(130,130,130))
        :setPosition(1280/2,720/2)
        :addTo(usefulNode,1)
        :setTouchEnabled(true)
        :setTouchSwallowEnabled(true) -- 是否吞噬事件，默认值为 true
        :setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) 
        :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            
            usefulSoundBtn:setTouchEnabled(false)
            if usefulNode then
            --执行隐藏动画效果
                local moveAction = cc.MoveBy:create(0.5,cc.p(460, 0))
                local FadeOutAction =cc.FadeOut:create(0.5)
                local spawn2 = cc.Spawn:create(FadeOutAction,moveAction)
                transition.execute(usefulNode, spawn2, {
                    onComplete = function ()
                    if usefulNode~=nil then
                        usefulNode:removeFromParent()
                        usefulSoundBtn:setTouchEnabled(true)    --动作执行完成，按钮可以触摸
                        flag = not flag
                        self.callBack:setliaotianSpriteShow(true)
                    end
                end
                })
            
            
            end
            return true
        end)

    

        --listview背景
        ccui.ImageView:create("ShYMJ/LYMJ/ListView_Bg.png")
        -- :setContentSize(380,495)
        :setScaleX(0.8)
        :pos(display.right-190,display.cy)
        :addTo(usefulNode)



        local listView = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        -- bg = "ShYMJ/LYMJ/ListView_Bg.png",ListView_Bg
        bgScale9 = true,
        viewRect = cc.rect(display.right-380, 0, 480, 700),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        scrollbarImgV = "ShYMJ/LYMJ/bar.png"}
        -- :onTouch(handler(self, self.touchListener))
        :setTouchEnabled(true)
        -- :pos(display.right-212, display.top-400)
        :setTouchSwallowEnabled(false) -- 是否吞噬事件，默认值为 true
        :addTo(usefulNode,20)
        
        for i=1,4 do
            local item = listView:newItem()
            local content = ccui.ImageView:create()
            :setContentSize(480,150)
            item:addContent(content)
            item:setItemSize(510, 150)
            for j=1,3 do
                local biaoqingBtn = display.newSprite(string.format("ShYMJ/LYMJ/%d.png",((i-1)*3)+j))
                biaoqingBtn:setScale(0.8)
                biaoqingBtn:setAnchorPoint(0.5,0.5)
                biaoqingBtn:pos(130/2+(j-1)*120,150/2)
                biaoqingBtn:setTouchEnabled(true)
                biaoqingBtn:setTouchSwallowEnabled(false)
                biaoqingBtn:addTo(content)
                biaoqingBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                    if event.name == "began" then
                        biaoqingBtn.x = event.x
                        biaoqingBtn.y = event.y
                        biaoqingBtn:setScale(0.6)
                        return true
                    elseif event.name == "moved" then

                    elseif event.name == "ended" then
                        -- print("座位移动ended")
                        biaoqingBtn:setScale(0.8)
                        if biaoqingBtn:hitTest(cc.p(event.x, event.y), false) and math.abs(biaoqingBtn.x-event.x)<20 and  math.abs(biaoqingBtn.y-event.y)<20 then
                            print("点击了",((i-1)*3)+j)

                            self:biaoqingBtnClick(((i-1)*3)+j)
                        end
                    end
                end)
                


                

                cc.ui.UILabel.new({
                text = usefulTest[((i-1)*3)+j], 
                size = 20, 
                color = cc.c3b(0,178,128),
                })
                :setAnchorPoint(0.5,0.5)
                :setPosition(130/2+(j-1)*120,0)
                :addTo(content)

            end


            listView:addItem(item)
        end
        listView:reload()

        --执行弹出动画效果
        local FadeInAction=cc.FadeIn:create(0.5)
        local moveAction = cc.MoveBy:create(0.5,cc.p(-460, 0))
        local spawn1 = cc.Spawn:create(FadeInAction,moveAction)
        transition.execute(usefulNode, spawn1, {
                onComplete = function ()
                    flag = not flag
                    usefulSoundBtn:setTouchEnabled(true)    --动作执行完成，按钮可以触摸
                    self.callBack:setliaotianSpriteShow(false)
                end
            })
        

    else
        usefulSoundBtn:setTouchEnabled(false)
        if usefulNode then
            --执行隐藏动画效果
            local moveAction = cc.MoveBy:create(0.5,cc.p(460, 0))
            local FadeOutAction =cc.FadeOut:create(0.5)
            local spawn2 = cc.Spawn:create(FadeOutAction,moveAction)
            transition.execute(usefulNode, spawn2, {
                onComplete = function ()
                    if usefulNode~=nil then
                        usefulNode:removeFromParent()
                        usefulSoundBtn:setTouchEnabled(true)    --动作执行完成，按钮可以触摸
                        flag = not flag
                        self.callBack:setliaotianSpriteShow(true)
                    end
                end
            })
            
            
        end
    end
    
end

function DDZ_Setting:biaoqingBtnClick(id)
    self.callBack:Chat(1,id)
end
]]

function DDZ_Setting:showRuleMenu()

    print("showRuleMenu----")

    sound_common.menu()
    local ruleLayer = cc.uiloader:load("Layer/Game/GameRuleLayer_3.json"):addTo(self.callBack,1100)
    
    self.ruleLayer = ruleLayer
    

    
    local popBoxNode = cc.uiloader:seekNodeByNameFast(ruleLayer, "PopBoxNode")
    -- util.setMenuAni(popBoxNode)
    popBoxNode:setScale(0)

    local title = cc.uiloader:seekNodeByNameFast(ruleLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/Lobby/ruleImg/img_RuleTitle.png",cc.rect(0,0,77,38))
    title:setSpriteFrame(frame)
    

    

    transition.scaleTo(popBoxNode, {
        scale = 1,
        time = app.constant.lobby_popbox_trasition_time,
        onComplete = function ()

        end
    })

    local close = cc.uiloader:seekNodeByNameFast(ruleLayer, "Close")
    :onButtonClicked(
        function ()

          self.ruleLayer:removeFromParent()
          self.ruleLayer = nil
          sound_common:cancel()

        end)
    util.BtnScaleFun(close)

    local CardList = cc.uiloader:seekNodeByNameFast(ruleLayer, "CardList")
    

    if self.callBack.maxPlayer >3 then
        cc.uiloader:seekNodeByNameFast(CardList, "Image_3"):setVisible(true)
        cc.uiloader:seekNodeByNameFast(CardList, "Image_2"):setVisible(false)
        cc.uiloader:seekNodeByNameFast(CardList, "Image_1"):setVisible(false)
        -- CardList:setContentSize(900,980)
    elseif self.callBack.maxCards == 108 then
        cc.uiloader:seekNodeByNameFast(CardList, "Image_2"):setVisible(true)
        cc.uiloader:seekNodeByNameFast(CardList, "Image_3"):setVisible(false)
        cc.uiloader:seekNodeByNameFast(CardList, "Image_1"):setVisible(false)
        -- CardList:setContentSize(900,1000)
    else
        cc.uiloader:seekNodeByNameFast(CardList, "Image_1"):setVisible(true)
        cc.uiloader:seekNodeByNameFast(CardList, "Image_3"):setVisible(false)
        cc.uiloader:seekNodeByNameFast(CardList, "Image_2"):setVisible(false)
        -- CardList:setContentSize(900,1620)
    end
    CardList:show()
end

function DDZ_Setting:onSoundButton(open)
    -- if open then
    --     closeSound:hide()
    --     openSound:show()
    -- else
    --     openSound:hide()
    --     closeSound:show()
    -- end
    app.constant.voiceOn = open
    util.GameStateSave("voiceOn",app.constant.voiceOn)
    sound.setState(open)
    sound_common.setVoiceState(app.constant.voiceOn)
end

function DDZ_Setting:onShowButton(show)
    print("isOpenBg",isOpenBg)
    if isOpenBg then

        return
     end

    local  action = cc.MoveTo:create(0.3, cc.p(display.right - 155/2, display.top - 198))
    local  actionr = cc.MoveTo:create(0.3, cc.p(display.right + 155/2, display.top - 198))

    if show == true then
        isOpenBg = true
        background:show()
        showButton:setButtonImage(cc.ui.UIPushButton.NORMAL, "Image/DDZ/setting/button_ccup_norma.png")
        showButton:setButtonImage(cc.ui.UIPushButton.PRESSED, "Image/DDZ/setting/button_ccup_norma.png")
        transition.execute(background, action, {
        easing = "sineIn",
        onComplete = function()
            isOn = false
            isOpenBg = false
            print("move completed")
        end,
    })
    else
        isOpenBg = true
        showButton:setButtonImage(cc.ui.UIPushButton.NORMAL, "Image/DDZ/setting/button_ccdown_norma.png")
        showButton:setButtonImage(cc.ui.UIPushButton.PRESSED, "Image/DDZ/setting/button_ccdown_norma.png")
        transition.execute(background, actionr, {
        easing = "sineInOut",
        onComplete = function()
            isOpenBg = false
            isOn = true
            background:hide()
            print("move completed111")
        end,
    })
    end

    self:onSoundButton(app.constant.voiceOn)
end

function DDZ_Setting:onLeaveButton()

    
    MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()
            sound_common.confirm()
            
            self.callBack:onLeave()
        end)
    :addTo(self)


end

function DDZ_Setting:allowShare(allow)
    if allow then
        --shareButton:show()
    else
        --shareButton:hide()
    end
end

function DDZ_Setting:onShareButton()
    Share.createGameShareLayer():addTo(self)
end

function DDZ_Setting:setOnShow()
    isOn = true
end

function DDZ_Setting:clear()
    background = nil
    showButton = nil
    hideButton = nil
    openSound = nil
    closeSound = nil
    outButton = nil
    shareButton = nil

    usefulSoundBtn = nil    --常用语按钮
    
    usefulNode = nil       --常用语节点
    usefulTest = nil       --常用语
    flag = true              --是否显示常用语界面
    self:setOnShow()
end

function DDZ_Setting:restart()
end

function DDZ_Setting:init(callback)
    self.callBack = callback
    if jieSanButton ~= nil then
         jieSanButton:onButtonClicked(
         function()
            
            local layer
            layer = MiddlePopBoxLayer.new(app.lang.system, app.lang.room_dissolution, 
                MiddlePopBoxLayer.ConfirmDefault, true, nil, function ()
                    layer:removeFromParent()
                    message.sendMessage("game.DismissGameReq", {
                                session = self.callBack.roomSession,
                                privateid = self.callBack.table_code,
                                seat = self.callBack.seatIndex,
                    })
                    sound_common.confirm()
                end)
            :addTo(self.callBack,10)
         end)

    end
    return self
end

return DDZ_Setting