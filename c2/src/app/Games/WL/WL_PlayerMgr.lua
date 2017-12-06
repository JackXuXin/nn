--
-- Author: peter
-- Date: 2017-03-10 16:35:19
--
local lg = require("app.Games.WL.lg_dywl")

local gameScene = nil

local HANDOUT_CARD_OFFSET = {
	{640,302}, {1040,406}, {640,600}, {273,406}
}

local TOUR_NUMBER_OFFSET = {
	{211,140}, {1054,437}, {760,600}, {211,437}
}

local WL_PlayerMgr = {}

function WL_PlayerMgr:init(scene)
	gameScene = scene

	self.playerInfos = {}	 --桌子上所有玩家的信息

	self.CountDown_labels = {}	   --倒计时数字
	self.CountDown_progress = {}   --倒计时背景	
	self.Player_Handout_Card = {}  --桌子上玩家们打出的牌
	self.Tour_Num_Sprite = {} 	   --玩家游数

	self.LastCardInfos = {}  --上一次玩家出的牌信息
end

function WL_PlayerMgr:clear()
end

--[[
	* 玩家坐下
	* @param table data  玩家数据
	* @return table 玩家信息
--]]
function WL_PlayerMgr:playerSeatDown(data)
	--创建一个玩家信息对象
	local playerInfo = gameScene.WL_PlayerInfo.new(data)
	self.playerInfos[data.seat] = playerInfo

	--显示玩家的UI信息
	gameScene.WL_uiPlayerInfos:showPlayerInfoUI(playerInfo)
end

--[[
	* 玩家准备
	* @param number seatId  玩家椅子号
	* @param boolean flag  显示状态
--]]
function WL_PlayerMgr:playerReady(seatId,flag)
	local user_ui_info =  gameScene.WL_uiPlayerInfos.ui_infos[seatId]

	--设置为已准备
	if flag then
		self.playerInfos[seatId]:setReadyState(1)
	end

	--显示准备标示
	user_ui_info.k_sp_ready:setVisible(flag)
end

--[[
	* 玩家离开
	* @param number seatId  玩家椅子号
--]]
function WL_PlayerMgr:playerLeave(seatId)
	if seatId == 1 then
		gameScene.seatIndex = 0 
		gameScene.session = 0
	end

	gameScene.WL_uiPlayerInfos.ui_infos[seatId].ui_body:setVisible(false)
	self.playerInfos[seatId] = nil
end

--[[
	* 玩家开始出牌
	* @param number seatId  玩家椅子号
	* @param table curCard  本轮桌子上最大的牌
--]]
function WL_PlayerMgr:playerStartChuPai(seatId,curCard)
	--显示倒计时
	self:showPlayerTimer(seatId)
	--清理上次出的牌
	self:showPlayerChuPaiUI(seatId)

	if seatId == 1 then
		curCard = gameScene.WL_Util.conversionCardInfoForm(curCard)
		--获取到提示的牌
		gameScene.WL_uiOperates:getTiShiCardInfos(curCard)
	end
end

--[[
	* 显示游数
	* @param number seatId  玩家椅子号
	* @param number winNum  上中下游
--]]
function WL_PlayerMgr:showTourNumSprite(seatId,winNum)
	if winNum <= 0 then
		return 
	end

	--显示游
	local path = gameScene.WL_Const.PATH["IMG_TOUR_NUM_" .. winNum]
	self.Tour_Num_Sprite[seatId] = display.newSprite(path, TOUR_NUMBER_OFFSET[seatId][1], TOUR_NUMBER_OFFSET[seatId][2])
	gameScene.root:addChild(self.Tour_Num_Sprite[seatId],2000)
end

--[[
	* 玩家结束出牌
	* @param number seatId  玩家椅子号
	* @param table handoutCard  出牌信息
	* @param number winNum  上中下游
--]]
function WL_PlayerMgr:playerEndChuPai(seatId,handoutCard,winNum)
	--关闭倒计时
	self:showPlayerTimer(seatId,0)
	--显示打出的牌
	self:showPlayerChuPaiUI(seatId,handoutCard)
	--显示游数
	self:showTourNumSprite(seatId,winNum)

	if seatId == 1 then
		gameScene.WL_uiOperates:showOperates_01(false)
		gameScene.WL_uiOperates:showOperates_02(false)
	end
end

--[[
	* 显示玩家出牌UI  如果参数 cardInfos 是 nil 功能则是清理上次玩家出的牌
	* @param number seatId  玩家椅子号
	* @param table cardInfos 打出去的牌信息
--]]
function WL_PlayerMgr:showPlayerChuPaiUI(seatId,cardInfos)
	if not self.Player_Handout_Card[seatId] then
		self.Player_Handout_Card[seatId] = {}
	end

	for k,v in ipairs(self.Player_Handout_Card[seatId]) do
		v:removeFromParent()
	end

	self.Player_Handout_Card[seatId] = {}

	if not cardInfos then
		return 
	end

	if #cardInfos == 0 then  --要不起
		local pass = display.newSprite(gameScene.WL_Const.PATH.TX_PASS)
		if seatId == 2 then
			pass:setAnchorPoint(cc.p(1,0.5))
		elseif seatId == 4 then
			pass:setAnchorPoint(cc.p(0,0.5))
		else
			pass:setAnchorPoint(cc.p(0.5,0.5))
		end
		pass:setPosition(cc.p(HANDOUT_CARD_OFFSET[seatId][1],HANDOUT_CARD_OFFSET[seatId][2]))
		gameScene.root:addChild(pass, 10)
		table.insert(self.Player_Handout_Card[seatId],pass)

		--音效
		if self.playerInfos[seatId]:getSex() == 1 then --女
			gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_FEMALE_NO)
		else
			gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_MALE_NO)
		end

		return 
	end

	--创建打出去的牌 
	for _,cardInfo in ipairs(cardInfos) do
		local ui_card = gameScene.WL_Card.new(cardInfo)
		table.insert(self.Player_Handout_Card[seatId],ui_card)
	end

	--排序
	gameScene.WL_Util.sortCards(self.Player_Handout_Card[seatId])

	--转换牌信息
	cardInfos = gameScene.WL_Util.conversionCardInfoForm(cardInfos)

	--删掉自己手里打出去的牌
	if seatId == 1 then
		gameScene.WL_CardMgr:removeNumCards(cardInfos)
	end

	--显示在正确的位置上
	local scale = 0.6
	local length = #cardInfos   --每行的长度
	local row = math.floor(length / 11)   --超过10张牌  两行显示 每行8张
	local pos = cc.p(HANDOUT_CARD_OFFSET[seatId][1],HANDOUT_CARD_OFFSET[seatId][2])
	local CARD_HEIGHT_DISTANCE = 42 --牌高间距

	if row > 0 then
		length = 8
	end
	if seatId == 3 or seatId == 1 then
		pos = gameScene.WL_Util.getCardSortPos(length,scale,pos)
	elseif seatId == 2 then
		pos.x = pos.x - ((length - 1) * gameScene.WL_Const.CARD_WIDTH_DISTANCE + gameScene.WL_Const.CARD_WIDTH/2) * scale
	end
	pos.y = pos.y + row * CARD_HEIGHT_DISTANCE

	local X = pos.x
	local Y = pos.y
	local crucialIndex = 1

	if row > 0 then
		crucialIndex = 9
	end

	for index,ui_card in ipairs(self.Player_Handout_Card[seatId]) do
		if row > 0 and index == 9 then
			X = pos.x
			Y = pos.y - row * CARD_HEIGHT_DISTANCE
		end

		ui_card:setAnchorPoint(cc.p(0.5,0.5))
		ui_card:setScale(scale)
		ui_card:pos(X,Y)
		X = X + gameScene.WL_Const.CARD_WIDTH_DISTANCE * scale
		ui_card:setLocalZOrder(pos.x)
		gameScene.root:addChild(ui_card)


		--牌数字
		if index == crucialIndex then
			local cardNum = ui_card:getCardNum()
			local cardLength = #self.Player_Handout_Card[seatId]
			if cardLength >= 4 and cardNum <= 13 then
				local ui_cardNum = cc.LabelAtlas:_create()
    			ui_cardNum:setAnchorPoint(cc.p(0.5,0.5))
    			ui_cardNum:initWithString(
            	tostring(#self.Player_Handout_Card[seatId]),
            	gameScene.WL_Const.PATH.TX_CARD_NUM,
            	21,
            	26,
            	string.byte('0'))

    			if cardLength > 9 then
    				ui_cardNum:setScale(0.75)
    			end

				--ui_cardNum:setPosition(cc.p(ui_card:getContentSize().width-12,ui_card:getContentSize().height-10))
				if cardNum == 11 or cardNum == 12 or cardNum == 13 then
					ui_cardNum:setPosition(cc.p(19,65))
				else
					ui_cardNum:setPosition(cc.p(19,25))
				end

				ui_card:add(ui_cardNum)
			end
		end
	end

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_OUT_CARD)


	local soundName = ""
	if self.playerInfos[seatId]:getSex() == 1 then --女
		soundName = "WL_SOUND_FEMALE_"
	else
		soundName = "WL_SOUND_MALE_"
	end

	local LastCardType = lg.getCardType(self.LastCardInfos)

	--播放音效 动画
	if lg.getCardType(cardInfos) == "single" then
		soundName = soundName .."SINGLE_" .. cardInfos[1].num
	elseif lg.getCardType(cardInfos) == "double" then
		soundName = soundName .."DOUBLE_" .. cardInfos[1].num
	elseif lg.getCardType(cardInfos) == "trible" then
		if LastCardType == "trible" then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "AAA"
		end
	elseif lg.getCardType(cardInfos) == "bomb" or lg.getCardType(cardInfos) == "rewardBomb"	then
		gameScene.WL_ActionMgr:playBombAction()

		if LastCardType == "bomb" or LastCardType == "rewardBomb" then
			soundName = soundName .. "YOU"
		else
			soundName = soundName .. "BOMB"
		end	
	end

	self.LastCardInfos = cardInfos

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath[soundName])
end

--[[
	* 倒计时
	* @param number seatId  计时玩家椅子号
	* @param number countDown  倒数时间
--]]
function WL_PlayerMgr:showPlayerTimer(seatId,countDown)
	local ui_body =  gameScene.WL_uiPlayerInfos.ui_infos[seatId].ui_body
	countDown = countDown or gameScene.openCardTime

	if self.CountDown_labels[seatId] then
		self.CountDown_labels[seatId]:removeFromParent()
		self.CountDown_labels[seatId] = nil
	end

	if self.CountDown_progress[seatId] then
		self.CountDown_progress[seatId]:removeFromParent()
		self.CountDown_progress[seatId] = nil
	end

	ui_body:stopAllActions()

	if countDown == 0 then
		return 
	end

	if self.playerInfos[seatId].isTuoGuan then
		countDown = 3
	end

	--数字
    self.CountDown_labels[seatId] = cc.LabelAtlas:_create()
    self.CountDown_labels[seatId]:initWithString(
            tostring(countDown),
            "Image/WL/gameui/ta_GameUI_Time_Number.png",
            22,
            30,
            string.byte('0'))
    self.CountDown_labels[seatId]:setPosition(cc.p(70,93))
    self.CountDown_labels[seatId]:setAnchorPoint(cc.p(0.5,0.5))
    ui_body:addChild(self.CountDown_labels[seatId],2)

    --背景
	self.CountDown_progress[seatId] = display.newProgressTimer("Image/WL/gameui/img_height_countDown_BG.png",display.PROGRESS_TIMER_RADIAL)
	
	self.CountDown_progress[seatId]:setPercentage(100)
	self.CountDown_progress[seatId]:setScaleX(-1)
	self.CountDown_progress[seatId]:setAnchorPoint(0.5,0.5)
	self.CountDown_progress[seatId]:setPosition(cc.p(70,93))
	ui_body:addChild(self.CountDown_progress[seatId],1)
	self.CountDown_progress[seatId]:runAction(cca.progressTo(countDown,0))

	--定时器
    ui_body:schedule(function()

    	countDown = countDown - 1

    	self.CountDown_labels[seatId]:setString(tostring(countDown))

    	if countDown == 0 then
    		self.CountDown_labels[seatId]:removeFromParent()
    		self.CountDown_progress[seatId]:removeFromParent()
    		self.CountDown_labels[seatId] = nil
    		self.CountDown_progress[seatId] = nil
    		ui_body:stopAllActions()
    	end
    end,1.0)


    local frames = display.newFrames("Flame_%02d.png", 1, 16)
	local animation = display.newAnimation(frames, 0.1)
	local animate = cca.animate(animation)

	local LieHuo = display.newSprite("#Flame_01.png", self.CountDown_progress[seatId]:getContentSize().width/2, self.CountDown_progress[seatId]:getContentSize().height-5)
	LieHuo:addTo(self.CountDown_progress[seatId])
	LieHuo:runAction(cca.repeatForever(animate))

	local sequenceMove = nil
	--长 宽 边长
	local width = self.CountDown_progress[seatId]:getContentSize().width
	local height = self.CountDown_progress[seatId]:getContentSize().height
	local length = width*2 + height*2
	--时间
	local time = countDown

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

	LieHuo:runAction(sequenceMove)
end

--[[
	* 获取玩家信息
	* @param number seatId  获取玩家信息的椅子号
	* @return table 玩家信息
--]]
function WL_PlayerMgr:getPlayerInfoWithSeatID(seatId)
	return self.playerInfos[seatId]
end

--[[
	* 设置玩家托管状态
	* @param number seatId  椅子号
	* @param boolean flag 开启状态
--]]
function WL_PlayerMgr:setPlayerTuoGuanState(seatId, flag)
	--显示托管标示
	gameScene.WL_uiPlayerInfos:showQuXiaoTuoGuanUI(seatId, flag)

	--设置托管状态
	self.playerInfos[seatId]:setTuoGuan(flag)

	--显示取消托管按钮
	if seatId == 1 then
		gameScene.WL_uiOperates:showQuXiaoTuoGuanBtn(flag)

		--设置触摸状态
		gameScene.WL_CardTouchMgr:setRootTouchEnabled(not flag)
	end
end

--[[
	* 隐藏已经出完牌玩家的 手牌 游数 牌背
	* @param number seatId  椅子号
--]]
function WL_PlayerMgr:hidePlayerChuPaiUI(seatId)
	gameScene.WL_uiPlayerCardBack:hidePlayerCardBack(seatId)

	for _,ui_card in ipairs(self.Player_Handout_Card[seatId]) do
		ui_card:setVisible(false)
	end
end

--[[
	* 隐藏所有玩家 准备 标示
--]]
function WL_PlayerMgr:hidePlayerAllReadyTitle()
	for i=1,gameScene.WL_Const.MAX_PLAYER_NUMBER do
		self:playerReady(i,false)
	end
end

--[[
	* 清理桌子上玩家打出的手牌
	* @param boolean isClearAll  是否清理全部桌子上的牌
--]]
function WL_PlayerMgr:clearTableCards(isClearAll)
	for index,ui_cards in pairs(self.Player_Handout_Card) do
		if isClearAll then
			for _,ui_card in ipairs(ui_cards) do
				ui_card:removeFromParent()
			end
			self.Player_Handout_Card[index] = {}
		else
			--只清理手里还有牌的玩家
			if gameScene.WL_uiPlayerCardBack:getPlayerCardNum(index) ~= 0 then
				for _,ui_card in ipairs(ui_cards) do
					ui_card:removeFromParent()
				end
				self.Player_Handout_Card[index] = {}
			end
		end
	end
end

--[[
	* 清理游的标示
--]]
function WL_PlayerMgr:clearTourNumSprite()
	for index,ui_Tour in pairs(self.Tour_Num_Sprite) do
		ui_Tour:removeFromParent()
	end

	self.Tour_Num_Sprite = {}
end

--[[
	* 清理本轮最大牌
--]]
function WL_PlayerMgr:setLastCardNil()
	self.LastCardInfos = {}
end

return WL_PlayerMgr