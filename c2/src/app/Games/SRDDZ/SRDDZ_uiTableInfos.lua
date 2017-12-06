--
-- Author: peter
-- Date: 2017-02-22 18:11:15
--

local SRDDZ_Card = require("app.Games.SRDDZ.SRDDZ_Card")
local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")

local gameScene = nil

local SRDDZ_uiTableInfos = {}

function SRDDZ_uiTableInfos:init(scene)
	gameScene = scene

	self.k_tx_DiFen = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_tx_DiFen")
	self.k_tx_JiaoFen = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_tx_JiaoFen")

	self.k_nd_DengDai = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_DengDai")
	self.k_nd_DengDai:setVisible(false)

	self.TableCards = {}

	for i=1,8 do
		local card = SRDDZ_Card.new()
		self.TableCards[#self.TableCards + 1] = card
		card:setScale(SRDDZ_Const.CARD_SCALE)
		card:setVisible(false)
		gameScene.root:add(card)
	end

	local pos = cc.p(120,652)
	pos = SRDDZ_Util.getCardSortPos(#self.TableCards,SRDDZ_Const.CARD_SCALE,pos)
	for k,v in ipairs(self.TableCards) do
		v:setLocalZOrder(pos.x)
		v:setPosition(pos)
		pos.x = pos.x + SRDDZ_Const.CARD_WIDTH_DISTANCE * SRDDZ_Const.CARD_SCALE
	end

end

function SRDDZ_uiTableInfos:clear()
	self.TableCards = {}
	self.k_tx_DiFen = nil
	self.k_tx_JiaoFen = nil
end

--[[
	* 设置地主牌显示状态
	* @param boolean flag  显示状态
	* @param table cardInfos 牌值 and 花色
--]]
function SRDDZ_uiTableInfos:setDiZhuCardsShowState(flag,cardInfos)
	if cardInfos and flag then
		--转换 排序 数据
		cardInfos = SRDDZ_Util.conversionCardInfoForm(cardInfos)
		SRDDZ_Util.SortCards(1,cardInfos,"num","color")
	end

	for k,v in ipairs(self.TableCards) do
		v:setVisible(flag)

		if cardInfos then 
			v:showFront(cardInfos[k].num,cardInfos[k].color) --显示正面
		else
			v:showLast() --显示反面
		end
	end

	--设置低分
	if not flag then
		self.k_tx_DiFen:setString("")
		self.k_tx_JiaoFen:setString("")
	end
end

--[[
	* 设置底分
	* @param number num 底分
--]]
function SRDDZ_uiTableInfos:setDiFen(num)
	self.k_tx_DiFen:setString(tostring(num))
end

--[[
	* 设置叫分
	* @param number num 叫分
--]]
function SRDDZ_uiTableInfos:setJiaoFen(num)
	self.k_tx_JiaoFen:setString(tostring(num))
end

--[[
	* 显示等待其他玩家准备状态
	* @param boolean flag  显示状态
--]]
function SRDDZ_uiTableInfos:showWaitState(flag)
	if not self.k_nd_DengDai then
		return
	end

	--如果都准备了就返回
	if flag then
		if gameScene.SRDDZ_PlayerMgr:isPlayerAllReady() then
			return 
		end
	end

	if flag then
		for i=1,3 do
			cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. i):setVisible(false)
		end

		--执行点点点动画
		local count = 0
		self.k_nd_DengDai:schedule(
			function()
				count = count + 1
				if count > 3 then
					for i=1,3 do
						cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. i):setVisible(false)
					end
					count = 0
					return
				end

				cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. count):setVisible(true)

			end,0.4)
	else
		self.k_nd_DengDai:stopAllActions()
	end

	self.k_nd_DengDai:setVisible(flag)
end

return SRDDZ_uiTableInfos