local SSSScene = package.loaded["app.scenes.SSSScene"] or {}

local util = require("app.Common.util")
local sound_common = require("app.Common.sound_common")

--[[ --
    * 重新显示图层
--]]
local function _repeat_show_layer(self, info, callback)
    --提示信息
    cc.uiloader:seekNodeByNameFast(self.uiPrompt, "tx_info"):setString(info)
    --回调方法
    self.uiPrompt.callback = callback
    --动画显示
    self.uiPrompt:show()
    util.setMenuAniEx(self.uiPrompt.nd_all)
end

--[[ --
    * 显示提示信息
--]]
function SSSScene:showPromptLayer(info, callback)
    if self.uiPrompt then
        _repeat_show_layer(self, info, callback)
        return
    end

    local promptLayer = cc.uiloader:load("Layer/Game/SSS/PromptLayer.json"):addTo(self, 1001)
    self.uiPrompt = promptLayer

    --动画显示
    self.uiPrompt.nd_all = cc.uiloader:seekNodeByNameFast(promptLayer, "nd_all")
    util.setMenuAniEx(self.uiPrompt.nd_all)

    --回调方法
    promptLayer.callback = callback

    --提示信息
    cc.uiloader:seekNodeByNameFast(promptLayer, "tx_info"):setString(info)

    --确定按钮
    cc.uiloader:seekNodeByNameFast(promptLayer, "btn_ok")
        :onButtonClicked(function ()
            sound_common.confirm()
            if promptLayer.callback then
                promptLayer.callback()
            end
            promptLayer:hide()
        end)

    --取消按钮
    cc.uiloader:seekNodeByNameFast(promptLayer, "btn_cancel")
        :onButtonClicked(function ()
            sound_common.confirm()            
            promptLayer:hide()
        end)
end

return SSSScene