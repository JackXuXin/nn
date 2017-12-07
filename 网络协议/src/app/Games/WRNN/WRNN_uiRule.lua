--
-- Author: peter
-- Date: 2017-04-26 15:32:58
--
local util = require("app.Common.util")
local gameScene = nil

local WRNN_uiRule = {}

function WRNN_uiRule:init(scene)
	gameScene = scene

	self.k_nd_layer_rule = cc.uiloader:seekNodeByNameFast(gameScene.root, "RuleLayer")
	self.k_nd_layer_rule:setVisible(false)
	self.k_nd_layer_rule:setLocalZOrder(4002)

	-- self.k_nd_layer_rule:setTouchEnabled(true)
	-- self.k_nd_layer_rule:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	-- self.k_nd_layer_rule:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.layerTouchEventListevent))

    local closeButton = cc.uiloader:seekNodeByNameFast(self.k_nd_layer_rule, "BtnCloseRule")
    util.BtnScaleFun(closeButton)
    closeButton:onButtonClicked(function() 

       self.k_nd_layer_rule:setVisible(false)

     end)
end



--[[
	* 显示游戏规则
	* *param bool flag 显示状态
--]]
function WRNN_uiRule:showGameRule(flag)

	self.k_nd_layer_rule:setVisible(flag)
end


--[[设置规则信息]]
function WRNN_uiRule:setRuleInfo(cfg)

    local Text_BankerType = cc.uiloader:seekNodeByNameFast(self.k_nd_layer_rule, "Text_BankerType")     --庄家类型
    local Text_BaseScore = cc.uiloader:seekNodeByNameFast(self.k_nd_layer_rule, "Text_BaseScore")       --底分
    local Text_ScoreRule = cc.uiloader:seekNodeByNameFast(self.k_nd_layer_rule, "Text_ScoreRule")       --翻倍规则
    local Text_RoomPayType = cc.uiloader:seekNodeByNameFast(self.k_nd_layer_rule, "Text_RoomPayType")   --房费类型
    local Text_Special = cc.uiloader:seekNodeByNameFast(self.k_nd_layer_rule, "Text_Special")           --特殊玩法

    
    Text_BankerType:setString(cfg.baker_type)
    Text_BaseScore:setString(cfg.baseScore)
    Text_ScoreRule:setString(cfg.doubletype)
    Text_RoomPayType:setString(cfg.paymode)  
    Text_Special:setString(cfg.special)
  
end









--[[
	* 图层点击事件监听
	* @param table event 事件信息
--]]
function WRNN_uiRule:layerTouchEventListevent(event)
	if event.name == "began" then

		self.k_nd_layer_rule:setVisible(false)
		self.k_nd_layer_rule:setTouchEnabled(false)
		-- local rect = cc.uiloader:seekNodeByName(self.k_nd_layer_rule, "k_sp_rule"):getBoundingBox()
		-- if not cc.rectContainsPoint(rect,cc.p(event.x,event.y)) then
		-- 	self.k_nd_layer_rule:setVisible(false)
		-- end
	end
end

function WRNN_uiRule:clear()
end

return WRNN_uiRule