--
-- Author: peter
-- Date: 2017-02-17 13:51:13
--

 --    self.openCardTime = 0      --最大出牌时间
 --    self.baseScore = 0      --开局的底分
 --    self.multiple = 0      --当前的倍数

local SRDDZ_PlayerInfo = require("app.Games.SRDDZ.SRDDZ_PlayerInfo")
local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
local SRDDZ_Card = require("app.Games.SRDDZ.SRDDZ_Card")

local lg = require("app.Games.SRDDZ.lg_4ddz")

local PATH = SRDDZ_Const.PATH

local gameScene = nil

local CARD_YES = 1 	--上次行为信息是 牌
local CARD_NO  = 2 	--上次行为信息不是 牌

local TIMER_OFFSET = {
	{129,60}, {70,93}, {129,60}, {70,93}
}

local SCORE_OFFSET = {
	{640,250}, {970,402}, {640,520}, {316,402}
}

local LANDLORD_OFFSET = {
	{125,289}, {1151,507}, {623,690}, {125,507}
}

local HANDOUT_CARD_OFFSET = {
	{640,270}, {1000,410}, {640,510}, {273,410}
}

local RESULTS_CARD_OFFSET = {
	{640,270}, {1090,410}, {640,520}, {223,410}
}

local resultsCards = {}  --结算的时候显示在桌子上的牌

local SRDDZ_PlayerMgr = {}

function SRDDZ_PlayerMgr:init(scene)
	gameScene = scene

	self.playerInfos = {}	 --桌子上所有玩家的信息
	self.CountDown_labels = {}   --倒计时数字
	self.CountDown_progress = {}   --倒计时底图
	self.Player_Score = {}	 	  --玩家叫的分数
	self.Player_Handout_Card = {}  --玩家打出去的牌
	self.Landlord_Identity = nil
	self.landlord = 0  --地主椅子号

	self.However = nil   --打不过上家

	self.pinningCardInfo = {}  --上个出牌玩家打出的牌信息
end

function SRDDZ_PlayerMgr:clear()
	self.playerInfos = {}	 --桌子上所有玩家的信息
	self.CountDown_labels = {}
	self.CountDown_progress = {}
	self.Player_Score = {}
	self.Player_Handout_Card = {}  --玩家打出去的牌

	self.However = nil

	self.pinningCardInfo = {}  --上个出牌玩家打出的牌信息

	resultsCards = {}
end

--[[
	* 玩家坐下
	* @param table data  玩家数据
	* @return table 玩家信息
--]]
function SRDDZ_PlayerMgr:playerSeatDown(data)
	self.playerInfos[data.seat] = SRDDZ_PlayerInfo.new(data)

 	--显示已准备
	if self.playerInfos[data.seat].ready == 1 then  
		self:playerReady(self.playerInfos[data.seat].seat,true)
	else
		self:playerReady(self.playerInfos[data.seat].seat,false)
	end

	--如果是自己 显示开始游戏按钮
	if data.seat == 1 and self.playerInfos[data.seat].ready == 0 then
		gameScene.SRDDZ_uiOperates:setReadyBtnState(true)
	end

	return self.playerInfos[data.seat]
end

--[[
	* 玩家离开
	* @param number seatID  玩家椅子号
--]]
function SRDDZ_PlayerMgr:playerLeave(seatID)
	if seatID == 1 then
		SRDDZ_Util.seatIndex = 0 
		SRDDZ_Util.session = 0
	end

	--如果是地主 清理地主帽子
	if self.landlord == seatID then
		if self.Landlord_Identity then
			self.Landlord_Identity:removeFromParent()
			self.Landlord_Identity = nil
		end
	end

	gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID].ui_body:setVisible(false)
--	self.playerInfos[seatID] = nil
end

--[[
	* 玩家准备
	* @param number seatID  玩家椅子号
--]]
function SRDDZ_PlayerMgr:playerReady(seatID,flag)
	local user_ui_info =  gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID]

	if flag then
		cc.uiloader:seekNodeByNameFast(user_ui_info.ui_body, "k_sp_ready"):setVisible(flag)

		self.playerInfos[seatID].ready = 1

		--如果是自己 隐藏 准备按钮
		if seatID == 1 then
			gameScene.SRDDZ_uiOperates:setReadyBtnState(false)
		end
	else
		cc.uiloader:seekNodeByNameFast(user_ui_info.ui_body, "k_sp_ready"):setVisible(flag)
	end
end

--[[
	* 获取玩家信息
	* @param number seatID  获取玩家信息的椅子号
	* @return table 玩家信息
--]]
function SRDDZ_PlayerMgr:getPlayerInfoWithSeatID(seatID)
	return self.playerInfos[seatID]
end

--[[
	* 开局
--]]
function SRDDZ_PlayerMgr:Opening()
	gameScene.SRDDZ_uiTableInfos:showWaitState(false)
	for i=1,SRDDZ_Const.MAX_PLAYER_NUMBER do
		self:playerReady(i,false)
	end
end

--[[
	* 倒计时
	* @param number seatID  计时玩家椅子号
	* @param number countDown  倒数时间
--]]
function SRDDZ_PlayerMgr:showPlayerTimer(seatID,countDown)
	local ui_body =  gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID].ui_body
	countDown = countDown or SRDDZ_Util.openCardTime

	if self.CountDown_labels[seatID] then
		self.CountDown_labels[seatID]:removeFromParent()
		self.CountDown_labels[seatID] = nil
	end

	if self.CountDown_progress[seatID] then
		self.CountDown_progress[seatID]:removeFromParent()
		self.CountDown_progress[seatID] = nil
	end

	ui_body:stopAllActions()

	if countDown == 0 then
		return 
	end

	if self.playerInfos[seatID].mIsTuoGuan then
		countDown = 3
	end

	--数字
    self.CountDown_labels[seatID] = cc.LabelAtlas:_create()
    self.CountDown_labels[seatID]:initWithString(
            tostring(countDown),
            "Image/SRDDZ/gameui/ta_GameUI_Time_Number.png",
            22,
            30,
            string.byte('0'))
    self.CountDown_labels[seatID]:setPosition(cc.p(TIMER_OFFSET[seatID][1],TIMER_OFFSET[seatID][2]))
    self.CountDown_labels[seatID]:setAnchorPoint(cc.p(0.5,0.5))
    ui_body:addChild(self.CountDown_labels[seatID],2)

    --背景
    if seatID == 1 or seatID == 3 then
		self.CountDown_progress[seatID] = display.newProgressTimer("Image/SRDDZ/gameui/img_width_countDown_BG.png",display.PROGRESS_TIMER_RADIAL)
	else
		self.CountDown_progress[seatID] = display.newProgressTimer("Image/SRDDZ/gameui/img_height_countDown_BG.png",display.PROGRESS_TIMER_RADIAL)
	end
	self.CountDown_progress[seatID]:setPercentage(100)
	self.CountDown_progress[seatID]:setScaleX(-1)
	self.CountDown_progress[seatID]:setAnchorPoint(0.5,0.5)
	self.CountDown_progress[seatID]:setPosition(cc.p(TIMER_OFFSET[seatID][1],TIMER_OFFSET[seatID][2]))
	ui_body:addChild(self.CountDown_progress[seatID],1)
	self.CountDown_progress[seatID]:runAction(cca.progressTo(countDown,0))

	--定时器
    ui_body:schedule(function()

    	countDown = countDown - 1

    	self.CountDown_labels[seatID]:setString(tostring(countDown))

    	if countDown == 0 then
    		self.CountDown_labels[seatID]:removeFromParent()
    		self.CountDown_progress[seatID]:removeFromParent()
    		self.CountDown_labels[seatID] = nil
    		self.CountDown_progress[seatID] = nil
    		ui_body:stopAllActions()
    	end
    end,1.0)


    local frames = display.newFrames("Flame_%02d.png", 1, 16)
	local animation = display.newAnimation(frames, 0.1)
	local animate = cca.animate(animation)

	local LieHuo = display.newSprite("#Flame_01.png", self.CountDown_progress[seatID]:getContentSize().width/2, self.CountDown_progress[seatID]:getContentSize().height-5)
	LieHuo:addTo(self.CountDown_progress[seatID])
	LieHuo:runAction(cca.repeatForever(animate))

	local sequenceMove = nil
	--长 宽 边长
	local width = self.CountDown_progress[seatID]:getContentSize().width
	local height = self.CountDown_progress[seatID]:getContentSize().height
	local length = width*2 + height*2
	--时间
	local time = countDown

	-- local moveBy_01 = cca.moveBy(time*(width/2/length) * 0.83, -(width/2)+5, 0)
	-- local moveBy_02 = cca.moveBy(time*(height/length) * 1.4, 0, -height+5)
	-- local moveBy_03 = cca.moveBy((time*(width/length)/2) * 0.75, (width-8)/2, 0)
	-- local moveBy_04 = cca.moveBy((time*(width/length)/2) * 0.85, (width-8)/2, 0)
	-- local moveBy_05 = cca.moveBy(time*(height/length) * 1.3, 0, height-5)
	-- local moveBy_06 = cca.moveBy(time*(width/2/length) * 0.9, -(width/2)+5, 0)

	if seatID == 1 or seatID == 3 then
		local moveBy_01 = cca.moveBy(time*(width/2/length) * 0.83, -(width/2)+5, 0)
		local moveBy_02 = cca.moveBy((time*(height/length)/2) * 1.3, 0, -((height)/2))
		local moveBy_03 = cca.moveBy((time*(height/length)/2) * 1.8, 0, -((height-10)/2))
		local moveBy_04 = cca.moveBy((time*(width/length)*0.25) * 0.55, (width-8)*0.3, 0)
		local moveBy_05 = cca.moveBy((time*(width/length)*0.7) * 0.85, (width-8)*0.7, 0)
		local moveBy_06 = cca.moveBy((time*(height/length)/2) * 0.6, 0, height*0.3)
		local moveBy_07 = cca.moveBy((time*(height/length)/2) * 2.25, 0, height*0.7-5)
		local moveBy_08 = cca.moveBy(time*(width/2/length) * 0.77, -(width/2)+5, 0)
	
		sequenceMove = cca.seq{moveBy_01,moveBy_02,moveBy_03,moveBy_04,moveBy_05,moveBy_06,moveBy_07,moveBy_08}
	else
		local moveBy_01 = cca.moveBy(time*(width/2/length)*1.1, -(width/2)+5, 0)
		local moveBy_02 = cca.moveBy((time*(height/length)*0.3)*0.8, 0, -(height*0.3))
		local moveBy_03 = cca.moveBy((time*(height/length)*0.7), 0, -((height-10)*0.7))
		local moveBy_04 = cca.moveBy((time*(width/length)*0.25) * 0.7, (width-8)*0.25, 0)
		local moveBy_05 = cca.moveBy((time*(width/length)*0.7)*1.3, (width-2)*0.7, 0)
		local moveBy_06 = cca.moveBy((time*(height/length)*0.25) * 0.6, 0, height*0.25)
		local moveBy_07 = cca.moveBy((time*(height/length)*0.75) * 1.1, 0, height*0.75-8)
		local moveBy_08 = cca.moveBy((time*(width/2/length) * 0.4) * 0.7, -(width*0.2), 0)
		local moveBy_09 = cca.moveBy((time*(width/2/length) * 0.6), -(width*0.3)+7, 0)
	
		sequenceMove = cca.seq{moveBy_01,moveBy_02,moveBy_03,moveBy_04,moveBy_05,moveBy_06,moveBy_07,moveBy_08,moveBy_09}
	end

	LieHuo:runAction(sequenceMove)
end

--[[
	* 玩家叫分
	* @param number seatID  叫分玩家椅子号
	* @param number score  分数
--]]
function SRDDZ_PlayerMgr:showPlayerScore(seatID,score)
	if self.Player_Score[seatID] then
		self.Player_Score[seatID]:removeFromParent()
		self.Player_Score[seatID] = nil
	end

	if not score then
		return 
	end

	self.Player_Score[seatID] = display.newSprite(PATH["TX_SCORE_" .. score])
	self.Player_Score[seatID]:setAnchorPoint(cc.p(0.5,0.5))
	self.Player_Score[seatID]:setPosition(cc.p(SCORE_OFFSET[seatID][1],SCORE_OFFSET[seatID][2]))
	gameScene.root:addChild(self.Player_Score[seatID])
end

--[[
	* 删除所有玩家行为信息
--]]
function SRDDZ_PlayerMgr:removeAllPlayerScore()
	for k,v in pairs(self.Player_Score) do
		v:removeFromParent()
	end

	self.Player_Score = {}
end

--[[
	* 显示地主身份
	* @param number seatID 地主椅子号
	* @param table cards 地主得到的牌信息
--]]
function SRDDZ_PlayerMgr:showPlayerLandlordIdentity(seatID,cards)
	if self.Landlord_Identity then
		self.Landlord_Identity:removeFromParent()
		self.Landlord_Identity = nil
	end

	self.landlord = seatID
	
	self.playerInfos[seatID].mIsLandlord = true

	--地主标示
	self.Landlord_Identity = display.newSprite(PATH.IMG_LANDLORD_IDENTITY)
	self.Landlord_Identity:setAnchorPoint(cc.p(0.5,0.5))
	self.Landlord_Identity:setPosition(cc.p(LANDLORD_OFFSET[seatID][1],LANDLORD_OFFSET[seatID][2]))
	gameScene.root:addChild(self.Landlord_Identity)

	if seatID == 1 and cards then
		local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID].ui_cards

		for k,v in ipairs(cards) do
			local card = SRDDZ_Card.new(SRDDZ_Util.getCardNumAndColor(v))
			ui_cards[#ui_cards + 1] = card
			gameScene.root:add(card)
		end
	
		SRDDZ_Util.SortCards(1,ui_cards,"m_num","m_color")
		gameScene.SRDDZ_CardMgr:updatePlayerCardsPosition()
	end
end


--[[
	* 显示玩家要不起
--]]
function SRDDZ_PlayerMgr:showPlayerYaoBuQi()
	--如果正在托管直接返回
	if gameScene.SRDDZ_PlayerMgr.playerInfos[1].mIsTuoGuan then
		return 
	end
	
	gameScene.SRDDZ_CardTouchMsg:setRootTouchEnabled(false)
	gameScene.SRDDZ_CardMgr:setPlayerCardAllSuoTou()
	self:showPlayerHowever(true)
	gameScene.SRDDZ_uiOperates:setOpPanel_3(true)
end

--[[
	* 显示玩家出牌
	* @param table cards 要管得牌信息
--]]
function SRDDZ_PlayerMgr:showPlayerChuPai(cards)
	--如果正在托管直接返回
	if gameScene.SRDDZ_PlayerMgr.playerInfos[1].mIsTuoGuan then
		return 
	end

	local touchState = {true,true,true}

	cards = cards or {}
	if #cards == 0 then
		touchState[1] = false
	end

	local LuTouCards = gameScene.SRDDZ_CardMgr:getPlayerLuTouCards()

	--如果露头的牌长度为0  or  露头的牌是错误的牌型
	if #LuTouCards == 0 or not lg.getCardType(LuTouCards) then
		touchState[3] = false
		gameScene.SRDDZ_uiOperates:setOpPanel_2(true,touchState)
		return 
	end

	--如果露头的牌型 大的过 桌面上得牌型
	if lg.compare(LuTouCards,cards) then
		touchState[3] = true
		gameScene.SRDDZ_uiOperates:setOpPanel_2(true,touchState)
	else
		touchState[3] = false
		gameScene.SRDDZ_uiOperates:setOpPanel_2(true,touchState)
	end
end

--[[
	* 轮到自己出牌
	* @param table cards 要管得牌信息
--]]
function SRDDZ_PlayerMgr:showPlayerChuPaiState(cards)
	--如果正在托管直接返回
	if gameScene.SRDDZ_PlayerMgr.playerInfos[1].mIsTuoGuan then
		return 
	end

	--转换成牌两个字段
	if cards then
		cards = SRDDZ_Util.conversionCardInfoForm(cards)
	else
		cards = {}
	end

	--获取提示牌
	gameScene.SRDDZ_CardTouchMsg.PinningCardInfo = cards
	self.PinningCardInfo = cards
	gameScene.SRDDZ_uiOperates.TiShiCardInfo = lg.remind(cards,gameScene.SRDDZ_uiPlayerInfos:getPlayerCardInfos())
	gameScene.SRDDZ_uiOperates.TiShiCardInfo.index = 1

	dump(gameScene.SRDDZ_uiOperates.TiShiCardInfo,"得到的全部提示牌")

	--显示按钮
	if #gameScene.SRDDZ_uiOperates.TiShiCardInfo == 0 then --没有打过桌子上的牌
		self:showPlayerYaoBuQi()
	else
		self:showPlayerChuPai(cards)
	end
end

--[[
	* 显示玩家打出去的牌
	* @param number seatID 地主椅子号
	* @param table cards 打出去的牌
	* @param boox isPlaySound 是否播放音效（场景恢复的时候不需要播放音效）
--]]
function SRDDZ_PlayerMgr:ShowPlayerChuPaiUI(seatID,cards,isPlaySound)
	if not self.Player_Handout_Card[seatID] then
		self.Player_Handout_Card[seatID] = {}
	end

	for k,v in ipairs(self.Player_Handout_Card[seatID]) do
		v:removeFromParent()
		v = nil
	end

	self.Player_Handout_Card[seatID] = {}

	if not cards then
		return 
	end

	if #cards == 0 then  --不出
		local pass = display.newSprite(PATH.TX_PASS)
		pass:setAnchorPoint(cc.p(0.5,0.5))
		pass:setPosition(cc.p(HANDOUT_CARD_OFFSET[seatID][1],HANDOUT_CARD_OFFSET[seatID][2]))
		gameScene.root:addChild(pass, 10)
		table.insert(self.Player_Handout_Card[seatID],pass)

		gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_FEMALE_NO)
		return 
	end


	cards = SRDDZ_Util.conversionCardInfoForm(cards)

	if seatID == 1 then
		local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID].ui_cards

		for k,v in ipairs(cards) do
			for kk,vv in ipairs(ui_cards) do
				if v.num == vv:getCardNum() and v.color == vv:getCardColor() then
					table.insert(self.Player_Handout_Card[seatID],vv)
		--			vv:setLocalZOrder(10000)
					table.remove(ui_cards,kk)
					break
				end
			end
		end

		local scale = 0.75
		local pos = cc.p(HANDOUT_CARD_OFFSET[seatID][1],HANDOUT_CARD_OFFSET[seatID][2])
		pos = SRDDZ_Util.getCardSortPos(#cards,scale,pos)

		for k,v in ipairs(self.Player_Handout_Card[seatID]) do

			--添加地主标示
			if self.playerInfos[seatID].mIsLandlord then
				if k == #self.Player_Handout_Card[seatID] then
					local Landlord_Mark = display.newSprite(PATH.IMG_LANDLORD_Mark)
					Landlord_Mark:setAnchorPoint(cc.p(1,1))
					local size = v:getContentSize()
					Landlord_Mark:setPosition(cc.p(size.width,size.height))
					v:addChild(Landlord_Mark)
				end
			end

			v:setPosition(pos)
			v:setScale(scale)
			pos.x = pos.x + SRDDZ_Const.CARD_WIDTH_DISTANCE * scale
		end
 	
 		--如果是按 牌型大小排序的话 就重新排序一次sortType
 		if gameScene.SRDDZ_uiOperates.sortType then
 			local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID].ui_cards
 			lg.sortByCardType(ui_cards)
 		end

		gameScene.SRDDZ_CardMgr:updatePlayerCardsPosition()

	else
		local scale = 0.75
		local pos = cc.p(HANDOUT_CARD_OFFSET[seatID][1],HANDOUT_CARD_OFFSET[seatID][2])
		if seatID == 3 then
			pos = SRDDZ_Util.getCardSortPos(#cards,scale,pos)
		elseif seatID == 2 then
			pos.x = pos.x - ((#cards - 1) * SRDDZ_Const.CARD_WIDTH_DISTANCE + SRDDZ_Const.CARD_WIDTH/2) * scale
		end
		for k,v in ipairs(cards) do
			local card = SRDDZ_Card.new(v.num,v.color)
			card:setAnchorPoint(cc.p(0.5,0.5))

			--添加地主标示
			if self.playerInfos[seatID].mIsLandlord then
				if k == #cards then
					local Landlord_Mark = display.newSprite(PATH.IMG_LANDLORD_Mark)
					Landlord_Mark:setAnchorPoint(cc.p(1,1))
					local size = card:getContentSize()
					Landlord_Mark:setPosition(cc.p(size.width,size.height))
					card:addChild(Landlord_Mark)
				end
			end

			card:setScale(scale)
			card:setPosition(pos)
			pos.x = pos.x + SRDDZ_Const.CARD_WIDTH_DISTANCE * scale
			card:setLocalZOrder(pos.x)
			gameScene.root:addChild(card)
			table.insert(self.Player_Handout_Card[seatID],card)
		end
	end

	if not isPlaySound then  --如果不需要播放音效直接返回
		return 
	end

	local isEqually = true
	if #cards == #self.pinningCardInfo then
		for index=1,#cards do
			if cards[index].num ~= self.pinningCardInfo[index].num or
				cards[index].color ~= self.pinningCardInfo[index].color then
				isEqually = false
				break
			end
		end
	else
		isEqually = false
	end

	local soundName = ""
	if self.playerInfos[seatID].sex == 1 then  -- 女
		soundName = "SRDDZ_SOUND_FEMALE_"
	else
		soundName = "SRDDZ_SOUND_MALE_"
	end

	--判断牌型播放音效
	if lg.getCardType(cards) == "single" then   --单张
		soundName = soundName .. "SINGLE_" .. cards[1].num
	elseif lg.getCardType(cards) == "double" then   --对子
		local num = cards[1].num
		if cards[1].num ~= cards[2].num then
			if cards[1].num > cards[2].num then
				num = cards[2].num
			else
				num = cards[1].num
			end
		end
		soundName = soundName .. "DOUBLE_" .. num
	elseif lg.getCardType(cards) == "trible" then   --三张
		if lg.getCardType(self.pinningCardInfo) == "trible" and not isEqually then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "AAA"
		end
	elseif lg.getCardType(cards) == "tribleAndDouble" then   --三带二
		if lg.getCardType(self.pinningCardInfo) == "tribleAndDouble" and not isEqually then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "AAABB"
		end
	elseif lg.getCardType(cards) == "doubleSequence" then   --连队
		if lg.getCardType(self.pinningCardInfo) == "doubleSequence" and not isEqually then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "AABBCC"
		end
	elseif lg.getCardType(cards) == "tribleSequence" then   --三连
		if lg.getCardType(self.pinningCardInfo) == "tribleSequence" and not isEqually then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "AAABBB"
		end
	elseif lg.getCardType(cards) == "bomb" then   --炸弹
		gameScene.SRDDZ_ActionMgr:playBombAction()
		if lg.getCardType(self.pinningCardInfo) == "bomb" and not isEqually then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "BOMB"
		end
	elseif lg.getCardType(cards) == "kingBomb" then   --天王炸弹
		gameScene.SRDDZ_ActionMgr:playKingBombAction()
		if lg.getCardType(self.pinningCardInfo) == "kingBomb" and not isEqually then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "ROCKET"
		end
	end

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath[soundName])
end

--[[
	* 清理所有玩家打出去的牌 与 手牌
	* @param bool isAllClear 是否全部清理
	* @param number seatId  保留上次玩家出牌UI 的椅子号
--]]
function SRDDZ_PlayerMgr:clearAllPlayerCards(isAllClear,seatId)
	seatId = seatId or 0

	--清理所有玩家上次打出的牌
	for seat,cards in pairs(self.Player_Handout_Card) do
		if seat ~= seatId then
			for k,card in ipairs(cards) do
				card:removeFromParent()
			end
			self.Player_Handout_Card[seat] = {}
		end
	end

	if seatId == 0 then
		self.Player_Handout_Card = {}
	end

	if not isAllClear then
		return 
	end

	--清理结算显示的牌
	for k,card in ipairs(resultsCards) do
		card:removeFromParent()
	end

	resultsCards = {}

	--清理手牌
	gameScene.SRDDZ_CardMgr:clearPlayerCards()

	--清理身份
	if self.Landlord_Identity then
		self.Landlord_Identity:removeFromParent()
		self.Landlord_Identity = nil
	end

	--隐藏地主的8张牌
	gameScene.SRDDZ_uiTableInfos:setDiZhuCardsShowState(false)
end

--[[
	* 显示结算玩家牌
	* param table cards 显示牌的数据
--]]
function SRDDZ_PlayerMgr:showPlayerResultsCards(cards)
	-- cards = cards or {{},
	-- {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33},
	-- {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33},
	-- {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33},
	-- }

	resultsCards = {}
	local scale = 0.6
	local numRow = 11
	for k,v in ipairs(cards) do
		v.seat = SRDDZ_Util.convertSeatToPlayer(k)
		if v.seat ~= 1 then
			local pos = cc.p(RESULTS_CARD_OFFSET[v.seat][1],RESULTS_CARD_OFFSET[v.seat][2])
			if v.seat == 3 then
				pos = SRDDZ_Util.getCardSortPos(numRow,scale,pos)
			elseif v.seat == 2 then
				pos.x = pos.x - ((numRow - 1) * SRDDZ_Const.CARD_WIDTH_DISTANCE + SRDDZ_Const.CARD_WIDTH/2) * scale
			end
	
			if v.seat ~= 3 then
				pos.y = pos.y + (math.ceil(#v / numRow) - 1) * SRDDZ_Const.CARD_HEIGHT_DISTANCE * scale
			end

			for index,card in ipairs(v) do
				local ui_card = SRDDZ_Card.new(card.num,card.color)
				ui_card:setScale(scale)
				resultsCards[#resultsCards+1] = ui_card
				ui_card:setPosition(pos)
				pos.x = pos.x + SRDDZ_Const.CARD_WIDTH_DISTANCE * scale

				if (index % numRow) == 0 then
					if v.seat == 2 then
						pos.x = RESULTS_CARD_OFFSET[v.seat][1] - ((numRow - 1) * SRDDZ_Const.CARD_WIDTH_DISTANCE + SRDDZ_Const.CARD_WIDTH/2) * scale
					elseif v.seat == 3 then
						pos.x = SRDDZ_Util.getCardSortPos(numRow,scale,cc.p(RESULTS_CARD_OFFSET[v.seat][1],RESULTS_CARD_OFFSET[v.seat][2])).x
					else
						pos.x = RESULTS_CARD_OFFSET[v.seat][1]
					end

					pos.y = pos.y - SRDDZ_Const.CARD_HEIGHT_DISTANCE * scale
				end

				gameScene.root:addChild(ui_card, 100)
			end
		end
	end
end


--[[
	* 显示没有牌能够大过上家
	* param boolean flag 显示状态
--]]
function SRDDZ_PlayerMgr:showPlayerHowever(flag)
	if not self.However then
		self.However = display.newSprite(PATH.TX_HOWEVER)
		self.However:setLocalZOrder(2000)
		self.However:setPosition(cc.p(640,100))
		gameScene.root:addChild(self.However)
	end

	self.However:setVisible(flag)
end

--[[
	* 设置玩家托管状态
	* param boolean flag 开启状态
--]]
function SRDDZ_PlayerMgr:setPlayerTuoGuanState(seatID,flag)
	ui_body = gameScene.SRDDZ_uiPlayerInfos.ui_infos[seatID].ui_body

	--托管图标
	cc.uiloader:seekNodeByName(ui_body, "k_sp_Trusteeship"):setVisible(flag)

	--托管状态
	self.playerInfos[seatID].mIsTuoGuan = flag

	--取消托管按钮
	if seatID == 1 then
		cc.uiloader:seekNodeByName(gameScene.root, "k_btn_QuXiaoTuoGuan"):setLocalZOrder(2000)
		cc.uiloader:seekNodeByName(gameScene.root, "k_btn_QuXiaoTuoGuan"):setVisible(flag)

		--触摸状态
		gameScene.SRDDZ_CardTouchMsg:setRootTouchEnabled(not flag)
	end
end

--[[
	* 是否已经全部准备
	* return boolean 状态
--]]
function SRDDZ_PlayerMgr:isPlayerAllReady()
	local count = 0
	for k,v in pairs(self.playerInfos) do
		count = count + 1
	end

	if count ~= 4 then
		return false
	end

	for k,v in ipairs(self.playerInfos) do
		if v.ready == 0 then
			return false
		end
	end

	return true
end

return SRDDZ_PlayerMgr