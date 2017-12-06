--
-- Author: peter
-- Date: 2017-02-22 17:20:38
--

local gameScene = nil

local SRDDZ_uiPlayerCardBack = {}

function SRDDZ_uiPlayerCardBack:init(scene)
	gameScene = scene

	self.k_playerCardBack = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_playerCardBack")
	self.k_playerCardBack:setVisible(false)
end

function SRDDZ_uiPlayerCardBack:clear()
	self.k_playerCardBack = nil
end


--[[
	* 设置其他玩家牌的显示
	* @param boolean flag  显示状态
--]]
function SRDDZ_uiPlayerCardBack:setPalyerCardStage(flag)
	if flag then
		cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_4"):setString("")
		cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_3"):setString("")
		cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_2"):setString("")
	end

	self.k_playerCardBack:setVisible(flag)
end

--[[
	* 刷新其他玩家的牌数显示
	* @param number seatId  对应的 椅子号 2-4
	* @param number cardNum 手牌数
--]]
function SRDDZ_uiPlayerCardBack:udpatePlayerCardNum(seatId,cardNum)
	if seatId == 1 then
		return
	end

	cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_" .. seatId):setString(tostring(cardNum))
end

return SRDDZ_uiPlayerCardBack