local SSSScene = package.loaded["app.scenes.SSSScene"] or {}

local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local util = require("app.Common.util")
local sound_common = require("app.Common.sound_common")

--[[ --
    * 重新显示图层
--]]
local function _repeat_show_layer(self)
    self.uiRule:show()
    util.setMenuAniEx(self.uiRule.nd_all)
    self.uiRule.cb_wanfa:setButtonSelected(true)
end

--[[ --
    * 创建菜单按钮
--]]
local function _create_ment_button(self)
    local group = RadioButtonGroup.new()
    
    --选择菜单
    local function select_ment(button)
        if button == self.uiRule.cb_wanfa then
            cc.uiloader:seekNodeByNameFast(self.uiRule, "scroll_rule"):show()
            cc.uiloader:seekNodeByNameFast(self.uiRule, "img_caozuo"):hide()
        else
            cc.uiloader:seekNodeByNameFast(self.uiRule, "scroll_rule"):hide()
            cc.uiloader:seekNodeByNameFast(self.uiRule, "img_caozuo"):show()
        end
    end

    local cb_info = {
        [1] = {off = "Image/SSS/rule/cb_wanfa_1.png", on = "Image/SSS/rule/cb_wanfa_2.png", x = -398.08, y = 194.40},
        [2] = {off = "Image/SSS/rule/cb_caozuo_1.png", on = "Image/SSS/rule/cb_caozuo_2.png", x = -398.08, y = 102.26}
    }
    for i=1,2 do
        local cb_button = cc.ui.UICheckBoxButton.new({
            off = cb_info[i].off,
            off_pressed = cb_info[i].on,
            off_disabled = cb_info[i].off,
            on = cb_info[i].on,
            on_pressed = cb_info[i].on,
            on_disabled = cb_info[i].on,
        })
            :pos(cb_info[i].x,cb_info[i].y)
            :addTo(self.uiRule.nd_all)

        group:addButtons({[cb_button] = select_ment})

        if i == 1 then
            self.uiRule.cb_wanfa = cb_button
            cb_button:setButtonSelected(true)
        end
    end
end

--[[ --
    * 显示规则
--]]
function SSSScene:showGameRule()
    if self.uiRule then
        _repeat_show_layer(self)
        return
    end

    local ruleLayer = cc.uiloader:load("Layer/Game/SSS/RuleLayer.json"):addTo(self,1100)
    self.uiRule = ruleLayer
    self.uiRule.nd_all = cc.uiloader:seekNodeByNameFast(ruleLayer, "nd_all")
    util.setMenuAniEx(self.uiRule.nd_all)

    --创建菜单按钮
    _create_ment_button(self)

    --关闭按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(ruleLayer, "btn_exit"))
        :onButtonClicked(function ( event )
            sound_common.confirm()
            ruleLayer:hide()
        end)
end

return SSSScene