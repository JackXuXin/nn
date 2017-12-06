--
-- Author: peter
-- Date: 2017-03-13 14:12:14
--

local lg = require("app.Games.WL.lg_dywl")

local gameScene = nil

--排序的方式
local SORT_MODE = false

local WL_CardMgr = {}

function WL_CardMgr:init(scene)
	gameScene = scene

	self.ui_cards = {}
end

function WL_CardMgr:clear()
	SORT_MODE = false
end

--[[
	* 发牌
	* @param table cards 自己手牌的信息
	* @param number callPlayer 发牌结束第一个出牌的玩家椅子号
--]]
function WL_CardMgr:sendPlayerCard(cards,callPlayer)
	local count = 0

	local function onSendCard(dt)
		count = count + 1

		for seat=1,gameScene.WL_Const.MAX_PLAYER_NUMBER do
			if seat == 1 then
				--创建牌
				local ui_card = gameScene.WL_Card.new(table.remove(cards,1))
				self.ui_cards[#self.ui_cards + 1] = ui_card

				--从大到小排序
				gameScene.WL_Util.sortCards(self.ui_cards)
				--刷新位置
				self:updatePlayerCardsPosition()

				gameScene.root:add(ui_card)
			else
				--刷新牌数
				gameScene.WL_uiPlayerCardBack:udpatePlayerCardNum(seat,count)
			end
		end

		if count == 54 then
			print("发牌结束")

			--停止定时器
			gameScene.root:stopAllActions()

			--停止所有音效
			audio.stopAllSounds()

			--显示每张牌的牌数
			self:showCardStatistics()

			--允许触摸
			gameScene.WL_CardTouchMgr:setRootTouchEnabled(true)

			--显示本轮总分
			gameScene.WL_uiTableInfos:showRoundScore(true)

			--开始出牌
			gameScene.WL_PlayerMgr:playerStartChuPai(callPlayer)

			--结束发牌音效
			audio.stopAllSounds()

			--显示排序按钮
			gameScene.WL_uiOperates:showPaiXuBtn(true)
		end
	end

	gameScene.WL_uiPlayerCardBack:showPlayerCardBack(true)
	gameScene.root:schedule(onSendCard,0.04)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_DISPATCH)

end

--[[
	* 恢复场景发牌
	* @param table cards 自己手牌的信息
--]]
function WL_CardMgr:sendPlayerCard2(cards)
	--创建手牌
	for k,v in ipairs(cards) do
		local ui_card = gameScene.WL_Card.new(v)
		self.ui_cards[#self.ui_cards + 1] = ui_card
		gameScene.root:add(ui_card)
	end

	--从大到小排序
	gameScene.WL_Util.sortCards(self.ui_cards)
	--刷新位置
	self:updatePlayerCardsPosition()
end

--[[
	* 刷新玩家牌位置
--]]
function WL_CardMgr:updatePlayerCardsPosition()
	--每行最大手牌数
	local rowNum  = 27
	--手牌中心X中心点
	local rowCenter = 685
	--第一行Y坐标
	local row1Y = 155
	--第二行Y坐标
	local row2Y = 50

	--排序的手牌数 最大为 rowNum
	local cardNum = #self.ui_cards
	if cardNum > rowNum then
		cardNum = rowNum
	end

	--居中
	if cardNum <= 24 then
		rowCenter = 640
	end

	local pos = gameScene.WL_Util.getCardSortPos(cardNum,1,cc.p(rowCenter,row1Y))

	for index,ui_card in ipairs(self.ui_cards) do
		local count = index

		ui_card:setCardSuoTou()
		ui_card:setLocalZOrder(index)
		if index > rowNum then
			index = index - rowNum
			pos.y = row2Y
		end
		ui_card:setPosition(pos.x + index * gameScene.WL_Const.CARD_WIDTH_DISTANCE,pos.y)

		--设置触摸范围
		if ui_card == self.ui_cards[#self.ui_cards] or index == 27 then  --最后一张牌的触摸范围是整张牌
			ui_card.touchRect = cc.rect(ui_card:getPositionX()-gameScene.WL_Const.CARD_WIDTH/2,ui_card:getPositionY()-gameScene.WL_Const.CATD_HEIGHT/2,
				gameScene.WL_Const.CARD_WIDTH,gameScene.WL_Const.CATD_HEIGHT)
		else
			ui_card.touchRect = cc.rect(ui_card:getPositionX()-gameScene.WL_Const.CARD_WIDTH/2,ui_card:getPositionY()-gameScene.WL_Const.CATD_HEIGHT/2,
				gameScene.WL_Const.CARD_WIDTH_DISTANCE,gameScene.WL_Const.CATD_HEIGHT)
		end

		local ui_cardNum = ui_card:getChildByName("ui_cardNum")
		if ui_cardNum then
			--大于27在 第二排
    		if count > 27 then
    			ui_cardNum:setPosition(cc.p(23,45))
    		else
    			ui_cardNum:setPosition(cc.p(23,70))
    		end
		end
	end
end

--[[
	* 设置自己的所有牌缩头
--]]
function WL_CardMgr:setPlayerAllCardSuoTou()
	for _,ui_card in ipairs(self.ui_cards) do
		ui_card:setCardSuoTou()
		ui_card:setColor(gameScene.WL_Const.CARD_RELEASE_COLOR)
	end
end

--[[
	* 设置相同牌值的牌露头  其余的牌缩头
	* @param table cardInfo 露头的牌信息
--]]
function WL_CardMgr:setPlayerCardLuTou(num)
	self:setPlayerAllCardSuoTou()

	local TiShiCard = {}

	--是否手里有王炸
	local isFriedKing = false
	local count = 0

	if num >= 14 then
		for _,ui_card in ipairs(self.ui_cards) do
			if ui_card:getCardNum() >= 14  then
				count = count + 1
			end
		end
	end

	if count >= 4 then
		isFriedKing = true
	end

	for _,ui_card in ipairs(self.ui_cards) do
		if num >= 14 and isFriedKing then
			if ui_card:getCardNum() >= 14 then
				ui_card:setCardLuTou()
				table.insert(TiShiCard,{num = ui_card:getCardNum(),color = ui_card:getCardColor()})
			end
		else
			if ui_card:getCardNum() == num then
				ui_card:setCardLuTou()
				table.insert(TiShiCard,{num = ui_card:getCardNum(),color = ui_card:getCardColor()})
			end
		end
	end

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_HIT_CARD)

	return TiShiCard
end

--[[
	* 获取玩家牌信息
	* @return table 玩家牌信息
--]]
function WL_CardMgr:getPlayerAllCardInfos()
	local cardInfos = {}

	for _,ui_card in ipairs(self.ui_cards) do
		table.insert(cardInfos,{num = ui_card:getCardNum(),color = ui_card:getCardColor()})
	end

	return cardInfos
end

--[[
	* 获取当前选中的牌信息
	* @param number InfoType 返回牌的信息类型  1 = 两个字段表示  2 = 一个字段表示  牌信息
	* @return table 当前选中的牌信息
--]]
function WL_CardMgr:getPlayerLuTuoCardInfos(InfoType)
	InfoType = InfoType or 1

	local cardInfos = {}

	for _,ui_card in ipairs(self.ui_cards) do
		if ui_card:isCardLuTou() then
			if InfoType == 1 then
				table.insert(cardInfos,{num = ui_card:getCardNum(),color = ui_card:getCardColor()})
			elseif InfoType == 2 then
				local num = ui_card:getCardNum() + ui_card:getCardColor() * 16
				table.insert(cardInfos,num)
			end
		end
	end

	return cardInfos
end

--[[
	* 删除掉与参数num相同牌值的牌
	* @param table cardInfos 打出的牌信息
--]]
function WL_CardMgr:removeNumCards(cardInfos)
	local num = cardInfos[1].num

	for _,cardInfo in ipairs(cardInfos) do
		for index,ui_card in ipairs(self.ui_cards) do
			if cardInfo.num == ui_card:getCardNum() and cardInfo.color == ui_card:getCardColor() then
				ui_card:removeFromParent()
				table.remove(self.ui_cards,index)
				break
			end
		end
	end

	 self:updatePlayerCardsPosition()
end

--[[
	* 删除掉所有手牌
--]]
function WL_CardMgr:removeAllCards()
	for _,ui_card in pairs(self.ui_cards) do
		ui_card:removeFromParent()
	end

	self.ui_cards = {}
end

--[[
	* 重新排序手牌
--]]
function WL_CardMgr:sortHandWithMode()
	if SORT_MODE then
		gameScene.WL_Util.sortCards(self.ui_cards)
	else
		lg.sortByCardType(self.ui_cards)
	end

	SORT_MODE = not SORT_MODE
end

--[[
	* 显示手牌每张牌的牌数
--]]
function WL_CardMgr:showCardStatistics()
	local Statistics = {}

	--统计相同牌值的牌有多少张
	for i=1,#self.ui_cards do
		local num = self.ui_cards[i].num
		if Statistics[num] then
			Statistics[num].count =  Statistics[num].count + 1
		else
			Statistics[num] = {}
			Statistics[num].ui_card = self.ui_cards[i]
			Statistics[num].count = 1
			Statistics[num].index = i
		end
	end

	--显示每张牌数
	for _,v in pairs(Statistics) do
		if v.count >= 4 then
			--牌数字
    		local ui_cardNum = cc.LabelAtlas:_create()
    		ui_cardNum:setAnchorPoint(cc.p(0.5,0.5))
    		ui_cardNum:setScale(0.8)
    		ui_cardNum:initWithString(
    		        tostring(v.count),
    		        gameScene.WL_Const.PATH.TX_CARD_NUM,
    		        21,
    		        26,
    		        string.byte('0'))
	
    		--大于27在 第二排
    		if v.index > 27 then
    			ui_cardNum:setPosition(cc.p(21,45))
    		else
    			ui_cardNum:setPosition(cc.p(21,70))
    		end
	
    		ui_cardNum:setName("ui_cardNum")
    		v.ui_card:addChild(ui_cardNum)
		end
	end
end

return WL_CardMgr