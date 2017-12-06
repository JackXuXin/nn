--
-- Author: whb
-- Date: 2017-01-18 13:17:10
--
local RequestLayer = class("RequestLayer", function ()
    return cc.uiloader:load("Layer/ChatMenu/RequestLayer.json")
end)

local sound_common = require("app.Common.sound_common")

RequestLayer.ConfirmDefault = "default"
RequestLayer.ConfirmTable = "table"
RequestLayer.ConfirmSingle = "single"

function RequestLayer:ctor(title, content, confirmStyle, isAnimation, AnimationCallback, confirmCallback, cancelCallback)
    local node = cc.uiloader:seekNodeByNameFast(self, "Image_Bg")
    local scale = 1.0
    if node ~= nil then
        scale = node:getScale()
    end

    local close = function ()
        app.constant.isRequesting = 0
        self:removeFromParent()
        sound_common.cancel()
    end

    if isAnimation then
        node:setScale(0)
        transition.scaleTo(node, { 
            scale = scale, 
            easing = "backOut",
            time = app.constant.lobby_popbox_trasition_time*2,
            onComplete = AnimationCallback,
        })
    end

    -- cc.uiloader:seekNodeByNameFast(self, "Title")
    --     :setString(title or "")
    local text_Cotent = cc.uiloader:seekNodeByNameFast(self, "Text_Cotent")
        :setString(content or "")
    if content == nil then

    	text_Cotent:hide()

    end
    -- cc.uiloader:seekNodeByNameFast(self, "Close")
    --     :onButtonClicked(close)

    local confirm, cancel, sure, reqImg, tipImg

    confirm = cc.uiloader:seekNodeByNameFast(self, "Button_Ragree")
    cancel = cc.uiloader:seekNodeByNameFast(self, "Button_Rrefuse")
    sure = cc.uiloader:seekNodeByNameFast(self, "Button_Sure")
    reqImg = cc.uiloader:seekNodeByNameFast(self, "Image_5")
    tipImg = cc.uiloader:seekNodeByNameFast(self, "Image_Attention")

    
    if not confirmStyle or confirmStyle == RequestLayer.ConfirmDefault then
        reqImg:show()
        confirm:show()
        cancel:show()
        sure:hide()
        tipImg:hide()

    elseif not confirmStyle or confirmStyle == RequestLayer.ConfirmSingle then
        reqImg:hide()
        confirm:hide()
        cancel:hide()
        sure:show()
        tipImg:show()

    end

    if cancel then
        if cancelCallback then
            cancel:onButtonClicked(cancelCallback)
            -- sound_common.cancel()
        else
            cancel:onButtonClicked(close)
        end

    end
    if confirm and confirmCallback then
        confirm:onButtonClicked(confirmCallback)
        -- sound_common.confirm()
    end

     if sure then
       
        sure:onButtonClicked(close)
    end
end

return RequestLayer