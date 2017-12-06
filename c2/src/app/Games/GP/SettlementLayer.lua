local message = require("app.net.Message")
local util = require("app.Common.util")

local SettlementLayer =  class("SettlementLayer",function()
		return cc.uiloader:load("Layer/Game/GP/SettlementLayer.json")
	end)

-- start --

--------------------------------
-- 创建一个结算图层
-- @function create
-- @param userdata  sceneSelf    	 当前场景
-- @param table SettlementInfo   	 结算信息

-- end --

function SettlementLayer:create(sceneSelf,SettlementInfo)
	local layer = SettlementLayer.new()
	layer:init(sceneSelf,SettlementInfo)
	return layer
end

-- start --

--------------------------------
-- 构造函数   定义一些成员变量
-- @function ctor

-- end --

function SettlementLayer:ctor()
	self.m_sceneSelf = nil
end

-- start --

--------------------------------
-- 创建一个结算图层
-- @function init
-- @param userdata  sceneSelf    	 当前场景
-- @param table SettlementInfo   	 结算信息

-- end --

function SettlementLayer:init(sceneSelf,SettlementInfo)
	self.m_sceneSelf = sceneSelf

	--根据结算信息刷新UI
	for k,v in ipairs(SettlementInfo.records) do
		print("结算的倍数：" .. v.multiplenum)
		cc.uiloader:seekNodeByNameFast(self, "k_tx_playerCardNum_" .. k):setString(v.cardleastnum)
		cc.uiloader:seekNodeByNameFast(self, "k_tx_playerBeiZhu_" .. k):setString(v.multiplenum)
		local score = tonumber(v.score)
		if score > 0 then
		 	score = '+' .. tostring(score)
		 else
		 	score = tostring(score)
		end 
		cc.uiloader:seekNodeByNameFast(self, "k_tx_playerJieSuan_" .. k):setString(score)
	end

	cc.uiloader:seekNodeByNameFast(self, "k_tx_playerName_1"):setString(util.checkNickName(SettlementInfo.YingJiaName))
	cc.uiloader:seekNodeByNameFast(self, "k_tx_playerName_2"):setString(util.checkNickName(SettlementInfo.ShuJiaName))

	--监听按钮事件
	cc.uiloader:seekNodeByNameFast(self, "k_btn_TuiChu"):onButtonClicked(handler(self,self.clickTuiChu))
	cc.uiloader:seekNodeByNameFast(self, "k_btn_ZaiLai"):onButtonClicked(handler(self,self.clickZaiLai))
end

-- start --

--------------------------------
-- 退出房间 按钮回调
-- @function clickTuiChu

-- end --
function SettlementLayer:clickTuiChu()
--	self.m_sceneSelf:quitRoot()
	message.dispatchGame("room.LeaveGame")
	self:removeFromParent()
end

-- start --

--------------------------------
-- 再来一局 按钮回调
-- @function clickTuiChu

-- end --
function SettlementLayer:clickZaiLai()
	self.m_sceneSelf:againStart()
	self:removeFromParent()
end

return SettlementLayer