local MJSetting = class("MJSetting",function()
    return display.newSprite()
end)
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local Share = require("app.User.Share")

local background
local showButton
local hideButton
local openSound
local closeSound
local outButton
local shareButton

function MJSetting:ctor()
    background = display.newSprite("ShYMJ/img_GameUI_LeftTopBg.png")
    :pos(display.right - 50, display.top + 90)
    :addTo(self)

    openSound = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_yinliang_kq_normal.png", pressed = "ShYMJ/button_yinliang_kq_selected.png" })
    :onButtonClicked(function()
            self:onSoundButton(true)
     end)
    :pos(36, 90)
    :hide()
    :addTo(background)

    closeSound = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_yinliang_gb_normal.png", pressed = "ShYMJ/button_yinliang_gb_selected.png" })
    :onButtonClicked(function()
            self:onSoundButton(false)
     end)
    :pos(36, 90)
    :hide()
    :addTo(background)

    outButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit_normal.png", pressed = "ShYMJ/button_quit_selected.png" })
    :onButtonClicked(function()
            self:onLeaveButton()
     end)
    :pos(36, 30)
    :hide()
    :addTo(background)

    showButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccdown_norma.png", pressed = "ShYMJ/button_ccdown_norma.png" })
    :onButtonClicked(function()
            self:onShowButton(true)
     end)
    :pos(36, 30)
    :addTo(background)

    hideButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_ccup_norma.png", pressed = "ShYMJ/button_ccup_norma.png" })
    :onButtonClicked(function()
            self:onShowButton(false)
     end)
    :pos(36, 140)
    :hide()
    :addTo(background)

    shareButton = cc.ui.UIPushButton.new({ normal = "Image/Share/end/fenxiang1.png", pressed = "Image/Share/end/fenxiang2.png" })
    :onButtonClicked(function()
            self:onShareButton()
     end)
    :pos(display.left+39, display.cy)
    :hide()
    :addTo(self)
end

function MJSetting:onSoundButton(sound)
    if sound then
        openSound:hide()
        closeSound:show()
    else
        closeSound:hide()
        openSound:show()
    end
    self.callBack:onSound(sound)
end

function MJSetting:onShowButton(show)
    if show then
        showButton:hide()
        hideButton:show()
        openSound:show()
        closeSound:show()
        outButton:show()
        background:pos(display.right - 50, display.top - 30)
    else
        hideButton:hide()
        showButton:show()
        openSound:hide()
        closeSound:hide()
        outButton:hide()
        background:pos(display.right - 50, display.top + 90)
    end
end

function MJSetting:onLeaveButton()

    -- exit reminder
    MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()
            -- send leave table msg to server then quit table
            self.callBack:onLeave()
        end)
    :addTo(self)
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