local MJSetting = class("MJSetting",function()
    return display.newSprite()
end)
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local Share = require("app.User.Share")
local sound = require("app.Games.NJMJ.MJSound")
local sound_common = require("app.Common.sound_common")
local util = require("app.Common.util")

local background
local showButton
local hideButton
local openSound
local closeSound
local outButton
local shareButton

function MJSetting:ctor()
    background = display.newSprite("ShYMJ/img_GameUI_LeftTopBg.png")
    :pos(display.right - 50, display.top - 140)
    :addTo(self)
    :hide()

    openSound = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_yinliang_kq_normal.png", pressed = "ShYMJ/button_yinliang_kq_selected.png" })
    :onButtonClicked(function()
            self:onSoundButton(false)
     end)
    :pos(41, 120)
    -- :hide()
    :addTo(background)

    closeSound = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_yinliang_gb_normal.png", pressed = "ShYMJ/button_yinliang_gb_selected.png" })
    :onButtonClicked(function()
            self:onSoundButton(true)
     end)
    :pos(41, 120)
    -- :hide()
    :addTo(background)

    outButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit_normal.png", pressed = "ShYMJ/button_quit_selected.png" })
    :onButtonClicked(function()
            self:onLeaveButton()
     end)
    :pos(41, 50)
    -- :hide()
    :addTo(background)

    showButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccdown_norma.png", pressed = "ShYMJ/button_ccdown_norma.png" })
    :onButtonClicked(function()
            self:onShowButton(true)
     end)
    :pos(display.right - 50,662)
    :addTo(self)

    hideButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccup_norma.png", pressed = "ShYMJ/button_ccup_norma.png" })
    :onButtonClicked(function()
            self:onShowButton(false)
     end)
    :pos(41, 207)
    -- :hide()
    :addTo(background)

    -- shareButton = cc.ui.UIPushButton.new({ normal = "Image/Share/end/fenxiang1.png", pressed = "Image/Share/end/fenxiang2.png" })
    -- :onButtonClicked(function()
    --         self:onShareButton()
    --  end)
    -- :pos(display.left+39, display.cy)
    -- :hide()
    -- :addTo(self)
    -- self:onSoundButton(app.constant.voiceOn)  --要解开
end

function MJSetting:onSoundButton(open)
    if open then
        closeSound:hide()
        openSound:show()
    else
        openSound:hide()
        closeSound:show()
    end
    app.constant.voiceOn = open
    util.GameStateSave("voiceOn",app.constant.voiceOn)
    sound.setState(open)
    sound_common.setVoiceState(app.constant.voiceOn)
end

function MJSetting:onShowButton(show)
    if show then
        showButton:hide()
        -- hideButton:show()
        -- openSound:show()
        -- closeSound:show()
        -- outButton:show()
        -- background:pos(display.right - 50, display.top - 90)
        background:show()
    else
        -- hideButton:hide()
        showButton:show()
        -- openSound:hide()
        -- closeSound:hide()
        -- outButton:hide()
        -- background:pos(display.right - 50, display.top + 90)
        background:hide()
    end
    self:onSoundButton(app.constant.voiceOn)
end

function MJSetting:onLeaveButton()

    -- exit reminder
    MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()
            sound_common.confirm()
            -- send leave table msg to server then quit table
            self.callBack:onLeave()
        end)
    :addTo(self.callBack)
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
end

function MJSetting:restart()
end

function MJSetting:init(callback)
    self.callBack = callback
    return self
end

return MJSetting