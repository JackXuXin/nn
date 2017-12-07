--
-- Author: peter
-- Date: 2017-03-10 19:17:20
--

local gameScene = nil

local WL_uiPlayerCardBack = {}

function WL_uiPlayerCardBack:init(scene)
	gameScene = scene

	self.k_playerCardBack = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_playerCardBack")
	self.k_playerCardBack:setVisible(false)
end

function WL_uiPlayerCardBack:clear()
end

--[[
	* 设置其他玩家牌的显示
	* @param boolean flag  显示状态
--]]
function WL_uiPlayerCardBack:showPlayerCardBack(flag)
	if flag then
		for i=2,4 do 
			cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_sp_CardBack_Player_" .. i):setVisible(true)
			cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_" .. i):setString("")
		end
	end

	self.k_playerCardBack:setVisible(flag)
end

--[[
	* 隐藏牌背 牌数
	* @param number seatId  对应的 椅子号 2-4
--]]
function WL_uiPlayerCardBack:hidePlayerCardBack(seatId)
	if seatId <= 1 then
		return 
	end

	cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_sp_CardBack_Player_" .. seatId):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_" .. seatId):setString("")
end


--[[
	* 刷新其他玩家的牌数显示
	* @param number seatId  对应的 椅子号 2-4
	* @param number cardNum 手牌数
--]]
function WL_uiPlayerCardBack:udpatePlayerCardNum(seatId,cardNum)
	if seatId <= 1 then
		return
	end

	cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_" .. seatId):setString(tostring(cardNum))
end

--[[
	* 获取玩家剩余手牌数
	* @param number seatId  对应的 椅子号 2-4
	* @return number  手牌数
--]]
function WL_uiPlayerCardBack:getPlayerCardNum(seatId)
	if seatId == 1 then
		return #gameScene.WL_CardMgr.ui_cards
	end

	return tonumber(cc.uiloader:seekNodeByNameFast(self.k_playerCardBack, "k_ta_CardNum_Player_" .. seatId):getString())
end



return WL_uiPlayerCardBack