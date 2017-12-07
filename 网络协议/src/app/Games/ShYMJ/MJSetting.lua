local MJSetting = class("MJSetting",function()
    return display.newSprite()
end)
local GamePopBoxLayer = require("app.layers.GamePopBoxLayer")
local sound = require("app.Games.ShYMJ.MJSound")
local sound_common = require("app.Common.sound_common")
local util = require("app.Common.util")
local message = require("app.net.Message")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")

local background
local showButton
local hideButton
local openSound
local closeSound
local outButton
local jieSanButton
local shareButton
local isOpenBg = false
local isOn = true

function MJSetting:ctor()
    background = display.newSprite("ShYMJ/img_GameUI_LeftTopBg.png")
    :pos(display.right + 270/2, display.cy)
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

    outButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit_normal.png", pressed = "ShYMJ/button_quit_normal.png" })
    :onButtonClicked(
        function()
            self:onLeaveButton()
        end)
    :pos(135+53, display.height-40-110)
    -- :hide()
    :addTo(background)
    util.BtnScaleFun(outButton)

    jieSanButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/btn_dissolution_01.png", pressed = "ShYMJ/PrivateRoom/btn_dissolution_01.png" })
    :pos(135+53, display.height-110-40-90)
    -- :hide()
    :addTo(background)
    util.BtnScaleFun(jieSanButton)

    local ruleBtn = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_RuleBtn.png", pressed = "ShYMJ/btn_RuleBtn.png" })
    :onButtonClicked(
         function()
                self:showRuleMenu()
         end)
    :pos(135+53, display.height-40-110-180)
    -- :hide()
    :addTo(background)
    util.BtnScaleFun(ruleBtn)

    showButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccdown_norma.png", pressed = "ShYMJ/button_ccdown_norma.png" })
    :onButtonClicked(
        function()

            self:onShowButton(isOn)
        end)
    :pos(display.right - 50,662)
    :addTo(self)
    util.BtnScaleFun(showButton)

    -- hideButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccup_norma.png", pressed = "ShYMJ/button_ccup_norma.png" })
    -- :onButtonClicked(function()
    --         self:onShowButton(false)
    --  end)
    -- :pos(41-3, 207+60)
    -- -- :hide()
    -- :addTo(background)
    -- util.BtnScaleFun(hideButton)

    -- shareButton = cc.ui.UIPushButton.new({ normal = "Image/Share/end/fenxiang1.png", pressed = "Image/Share/end/fenxiang2.png" })
    -- :onButtonClicked(function()
    --         self:onShareButton()
    --  end)
    -- :pos(display.left+39, display.cy)
    -- :hide()
    -- :addTo(self)
    self:onSoundButton(app.constant.voiceOn)
end

function MJSetting:onSoundButton(open)
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

function MJSetting:IsOnShow()
    return isOn
end

function MJSetting:setOnShow()
    isOn = true
end

function MJSetting:onShowButton(show)

     if isOpenBg then

        return
     end

    local  action = cc.MoveTo:create(0.3, cc.p(display.right - 270/2, display.cy))
    local  actionr = cc.MoveTo:create(0.3, cc.p(display.right + 270/2, display.cy))

    if show == true then
        isOpenBg = true
        background:show()
        showButton:setButtonImage(cc.ui.UIPushButton.NORMAL, "ShYMJ/button_ccup_norma.png")
        showButton:setButtonImage(cc.ui.UIPushButton.PRESSED, "ShYMJ/button_ccup_norma.png")
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
        showButton:setButtonImage(cc.ui.UIPushButton.NORMAL, "ShYMJ/button_ccdown_norma.png")
        showButton:setButtonImage(cc.ui.UIPushButton.PRESSED, "ShYMJ/button_ccdown_norma.png")
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

    -- if show then
    --     showButton:hide()
    --     background:show()
    -- else
    --     showButton:show()
    --     background:hide()
    -- end
    self:onSoundButton(app.constant.voiceOn)
end

function MJSetting:onLeaveButton()

     -- exit reminder
    local pop = nil
        pop = GamePopBoxLayer.new("Image/PrivateRoom/tipImg/img_TextLeaveRoom.png", app.lang.exit_tips,
        GamePopBoxLayer.ConfirmTable, true, nil, function ()

            pop:removeFromParent()
            pop = nil

            sound_common.confirm()
            -- send leave table msg to server then quit table
            self.callBack:onLeave()
        end)
    :addTo(self.callBack,1200)

end

function MJSetting:showRuleMenu()

    print("showRuleMenu----")

    sound_common.menu()
    local ruleLayer = cc.uiloader:load("Layer/Game/GameRuleLayer_2.json"):addTo(self.callBack,1100)
    -- local popBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.RuleLayer, "PopBoxNode")
    -- util.setMenuAni(popBoxNode)
    self.ruleLayer = ruleLayer

    local popBoxNode = cc.uiloader:seekNodeByNameFast(ruleLayer, "PopBoxNode")
    popBoxNode:setScale(0)
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
    CardList:show()
end

function MJSetting:allowShare(allow)
    if allow then
        --shareButton:show()
    else
        --shareButton:hide()
    end
end

function MJSetting:onShareButton()
    Share.createGameShareLayer():addTo(self)
end

function MJSetting:clear()
    background = nil
    showButton = nil
    hideButton = nil
    openSound = nil
    closeSound = nil
    outButton = nil
    shareButton = nil
    jieSanButton = nil
end

function MJSetting:restart()
end

function MJSetting:init(callback)
    self.callBack = callback
    if jieSanButton ~= nil then
         jieSanButton:onButtonClicked(
         function()
           local layer
           layer = GamePopBoxLayer.new("Image/PrivateRoom/tipImg/img_TextDisscus1.png", app.lang.room_dissolution,
               GamePopBoxLayer.ConfirmDefault, true, nil, function ()
                   layer:removeFromParent()
                   message.sendMessage("game.DismissGameReq", {
                            session = self.callBack.room_Session,
                            privateid = self.callBack.table_code,
                            seat = self.callBack.seat_Index,
                        })
                   sound_common.confirm()
               end)
           :addTo(self.callBack,1200)
         end)
    end

    return self
end

return MJSetting