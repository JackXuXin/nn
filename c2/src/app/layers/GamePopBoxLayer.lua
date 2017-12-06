
local util = require("app.Common.util")

local GamePopBoxLayer = class("GamePopBoxLayer", function ()
    return cc.uiloader:load("Layer/GamePopBoxLayer.json")
end)

local sound_common = require("app.Common.sound_common")

GamePopBoxLayer.ConfirmDefault = "default"
GamePopBoxLayer.ConfirmTable = "table"
GamePopBoxLayer.ConfirmSingle = "single"

function GamePopBoxLayer:ctor(title, content, confirmStyle, isAnimation, AnimationCallback, confirmCallback, cancelCallback)
    local node = cc.uiloader:seekNodeByNameFast(self, "Node")

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

    local title_sprite = cc.uiloader:seekNodeByNameFast(self, "Image_Title")
    local s = nil
    if title ~= nil then
        s = display.newSprite(title)
    else
        s = display.newSprite("Image/Public/tip_title.png")
    end
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(self, "Content")
        :setString(content or "")
    -- cc.uiloader:seekNodeByNameFast(self, "Close")
    --     :onButtonClicked(close)
    
    local confirm, cancel
    if not confirmStyle or confirmStyle == GamePopBoxLayer.ConfirmDefault then
        confirm = cc.ui.UIPushButton.new({ 
            normal = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
            pressed = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
            disabled = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
        }):addTo(node)
        confirm:setPosition(cc.p(-130, -125))

        cancel = cc.ui.UIPushButton.new({ 
            normal = "Image/PrivateRoom/tipImg/btn_GameCancel.png", 
            pressed = "Image/PrivateRoom/tipImg/btn_GameCancel.png", 
            disabled = "Image/PrivateRoom/tipImg/btn_GameCancel.png", 
        }):addTo(node)
        cancel:setPosition(cc.p(130, -125))
    elseif confirmStyle == GamePopBoxLayer.ConfirmTable then
        confirm = cc.ui.UIPushButton.new({ 
            normal = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
            pressed = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
            disabled = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
        }):addTo(node)
        confirm:setPosition(cc.p(-130, -125))

        cancel = cc.ui.UIPushButton.new({ 
            normal = "Image/PrivateRoom/tipImg/btn_GameCancel.png", 
            pressed = "Image/PrivateRoom/tipImg/btn_GameCancel.png", 
            disabled = "Image/PrivateRoom/tipImg/btn_GameCancel.png", 
        }):addTo(node)
        cancel:setPosition(cc.p(130, -125))
    elseif confirmStyle == GamePopBoxLayer.ConfirmSingle then
        cancel = cc.ui.UIPushButton.new({ 
            normal = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
            pressed = "Image/PrivateRoom/tipImg/btn_GameSure.png", 
            disabled = "Image/PrivateRoom/tipImg/btn_GameSure.png",
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

return GamePopBoxLayer