
local util = require("app.Common.util")

local MiddlePopBoxLayer = class("MiddlePopBoxLayer", function ()
    return cc.uiloader:load("Layer/MiddlePopBoxLayer.json")
end)

local sound_common = require("app.Common.sound_common")

MiddlePopBoxLayer.ConfirmDefault = "default"
MiddlePopBoxLayer.ConfirmTable = "table"
MiddlePopBoxLayer.ConfirmSingle = "single"

function MiddlePopBoxLayer:ctor(title, content, confirmStyle, isAnimation, AnimationCallback, confirmCallback, cancelCallback)
    local node = cc.uiloader:seekNodeByNameFast(self, "Node")

    cc.uiloader:seekNodeByNameFast(self, "Image_1"):setLayoutSize(934, 538)

    local close = function ()
        self:removeFromParent()
        sound_common.cancel()
    end

    if isAnimation then
        node:setScale(0)
        transition.scaleTo(node, {
            scale = 1, 
            easing = "backOut",
            time = app.constant.lobby_popbox_trasition_time,
            onComplete = AnimationCallback,
        })
    end

    -- cc.uiloader:seekNodeByNameFast(self, "Title")
    --     :setString(title or "")
    local title_sprite = cc.uiloader:seekNodeByNameFast(self, "Image_Title")
    local s = display.newSprite("Image/Public/tip_title.png")
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(self, "Content")
        :setString(content or "")
    -- cc.uiloader:seekNodeByNameFast(self, "Close")
    --     :onButtonClicked(close)
    
    local confirm, cancel
    if not confirmStyle or confirmStyle == MiddlePopBoxLayer.ConfirmDefault then
        confirm = cc.ui.UIPushButton.new({ 
            normal = "Image/Public/Button_ConfirmRed_0.png", 
            pressed = "Image/Public/Button_ConfirmRed_0.png", 
            disabled = "Image/Public/Button_ConfirmRed_0.png", 
        }):addTo(node)
        confirm:setPosition(cc.p(-130, -125))

        cancel = cc.ui.UIPushButton.new({ 
            normal = "Image/Public/Button_CancelRed_0.png", 
            pressed = "Image/Public/Button_CancelRed_1.png", 
            disabled = "Image/Public/Button_CancelRed_0.png", 
        }):addTo(node)
        cancel:setPosition(cc.p(130, -125))
    elseif confirmStyle == MiddlePopBoxLayer.ConfirmTable then
        confirm = cc.ui.UIPushButton.new({ 
            normal = "Image/Public/Button_ConfirmRed_0.png", 
            pressed = "Image/Public/Button_ConfirmRed_0.png", 
            disabled = "Image/Public/Button_ConfirmRed_0.png", 
        }):addTo(node)
        confirm:setPosition(cc.p(-130, -125))

        cancel = cc.ui.UIPushButton.new({ 
            normal = "Image/Public/Button_CancelRed_0.png", 
            pressed = "Image/Public/Button_CancelRed_1.png", 
            disabled = "Image/Public/Button_CancelRed_0.png", 
        }):addTo(node)
        cancel:setPosition(cc.p(130, -125))
    elseif confirmStyle == MiddlePopBoxLayer.ConfirmSingle then
        cancel = cc.ui.UIPushButton.new({ 
            normal = "Image/Public/Button_ConfirmRed_0.png", 
            pressed = "Image/Public/Button_ConfirmRed_0.png", 
            disabled = "Image/Public/Button_ConfirmRed_0.png",
        }):addTo(node)
        cancel:setPosition(cc.p(0, -125))
    end

    if cancel then
        if cancelCallback then
            cancel:onButtonClicked(cancelCallback)
        else
            cancel:onButtonClicked(close)
        end

         util.BtnScaleFun(cancel)
    end
    if confirm and confirmCallback then
        confirm:onButtonClicked(confirmCallback)

        util.BtnScaleFun(confirm)
    end
end

return MiddlePopBoxLayer