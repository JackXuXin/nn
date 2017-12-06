--
-- Author: peter
-- Date: 2017-02-17 13:11:27
--

local SRDDZ_Card = require("app.Games.SRDDZ.SRDDZ_Card")
local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")

local gameScene = nil

local PLAYER_CARD_OFFSET = {
	{624,-95},{-60,30},{285,30},{176,30}
}

local SRDDZ_CardMgr = {}

function SRDDZ_CardMgr:init(scene)
	gameScene = scene
end

function SRDDZ_CardMgr:clear()
end

--[[
	* 发牌
	* @param table cards 自己手牌的信息
	* @param number callPlayer 发牌结束第一个叫分的玩家椅子号
--]]
function SRDDZ_CardMgr:sendPlayerCard(cards,callPlayer)

	local count = 0
	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
	local function onSendCard(dt)
		count = count + 1

		for i=1,SRDDZ_Const.MAX_PLAYER_NUMBER do
			if i == 1 then
				--创建牌
				local card = SRDDZ_Card.new(SRDDZ_Util.getCardNumAndColor(table.remove(cards,1)))
				ui_cards[#ui_cards + 1] = card

				--从大到小排序
				SRDDZ_Util.SortCards(1,ui_cards,"m_num","m_color")
				--刷新位置
				self:updatePlayerCardsPosition()

				gameScene.root:add(card)
			else
				--刷新牌数
				gameScene.SRDDZ_uiPlayerCardBack:udpatePlayerCardNum(i,count)
			end
		end

		if count == 25 then
			print("发牌结束")

			--停止定时器
			gameScene.root:stopAllActions()

			--停止所有音效
			audio.stopAllSounds()

			--允许触摸
			gameScene.SRDDZ_CardTouchMsg:setRootTouchEnabled(true)

			--显示倒计时
			gameScene.SRDDZ_PlayerMgr:showPlayerTimer(callPlayer)

			--开始叫分
			if callPlayer == 1 then
				gameScene.SRDDZ_uiOperates:setOpPanel_1(true)
			end
		end
	end

	gameScene.SRDDZ_uiPlayerCardBack:setPalyerCardStage(true)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_DISPATCH)
	gameScene.root:schedule(onSendCard,0.07)
end

--[[
	* 发牌(场景恢复)
	* @param table cards 自己手牌的信息
--]]
function SRDDZ_CardMgr:sendPlayerCard2(cards)
	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
	
	--创建手牌
	for k,v in ipairs(cards) do
		local ui_card = SRDDZ_Card.new(SRDDZ_Util.getCardNumAndColor(v))
		ui_cards[#ui_cards + 1] = ui_card
		gameScene.root:add(ui_card)
	end

	--从大到小排序
	SRDDZ_Util.SortCards(1,ui_cards,"m_num","m_color")
	--刷新位置
	self:updatePlayerCardsPosition()
end

--[[
	* 刷新玩家牌位置
--]]
function SRDDZ_CardMgr:updatePlayerCardsPosition()
	local ui_body = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_body
	local pos = cc.p(ui_body:getPosition())
	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards

	pos = SRDDZ_Util.getCardSortPos(#ui_cards,1,cc.p(pos.x+PLAYER_CARD_OFFSET[1][1],pos.y+PLAYER_CARD_OFFSET[1][2]))
	for k,v in ipairs(ui_cards) do
		v:setCardSuoTou()
		v:setLocalZOrder(pos.x)
		v:setPosition(pos)
		pos.x = pos.x + SRDDZ_Const.CARD_WIDTH_DISTANCE

		--设置触摸范围
		if v == ui_cards[#ui_cards] then  --最后一张牌的触摸范围是整张牌
			v.m_touchRect = cc.rect(v:getPositionX()-SRDDZ_Const.CARD_WIDTH/2,v:getPositionY()-SRDDZ_Const.CATD_HEIGHT/2,
				SRDDZ_Const.CARD_WIDTH,SRDDZ_Const.CATD_HEIGHT)
		else
			v.m_touchRect = cc.rect(v:getPositionX()-SRDDZ_Const.CARD_WIDTH/2,v:getPositionY()-SRDDZ_Const.CATD_HEIGHT/2,
				SRDDZ_Const.CARD_WIDTH_DISTANCE,SRDDZ_Const.CATD_HEIGHT)
		end
	end
end

--[[
	* 设置自己的所有牌缩头
--]]
function SRDDZ_CardMgr:setPlayerCardAllSuoTou()
	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards

	for k,v in ipairs(ui_cards) do
		v:setCardSuoTou()
		v:setColor(SRDDZ_Const.CARD_RELEASE_COLOR)
	end
end

--[[
	* 设置牌露头
	* @param table cards 露头的牌信息
	* @param table selectCards 已经选择的牌信息
--]]
function SRDDZ_CardMgr:setPlayerCardLuTou(cards,selectCards)
	local ui_cards = {}
	if selectCards then
		ui_cards = selectCards
	else
		ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
	end

	for k,cardInfo in ipairs(cards) do
		for kk,card in ipairs(ui_cards) do
			if card:getCardNum() == cardInfo.num and card:getCardColor() == cardInfo.color then
				if not card:isCardLuTou() then
					card:setCardLuTou()
					break
				end
			elseif card:getCardColor() == cardInfo.color and card:getCardColor() >= 4 then
				if not card:isCardLuTou() then
					card:setCardLuTou()
					break
				end
			end
		end
	end
end

--[[
	* 获取露头的牌的信息
	* @param number InfoType 返回牌的信息类型  1 = 两个字段表示  2 = 一个字段表示  牌信息
	* @return table cards 露头的牌的信息
--]]
function SRDDZ_CardMgr:getPlayerLuTouCards(InfoType)
	InfoType = InfoType or 1

	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
	local cards = {}

	for k,v in ipairs(ui_cards) do
		if v:isCardLuTou() then
			if InfoType == 1 then
				table.insert(cards,{num = v:getCardNum(),color = v:getCardColor()})
			elseif InfoType == 2 then
				local num = v:getCardNum() + v:getCardColor() * 16
				table.insert(cards,num)
			end
		end
	end

	return cards
end

--[[
	* 清理玩家手牌
--]]
function SRDDZ_CardMgr:clearPlayerCards()
	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards

	for k,card in ipairs(ui_cards) do
		card:removeFromParent()
	end

	gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards = {}
end

return SRDDZ_CardMgr