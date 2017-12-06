--
-- Author: peter
-- Date: 2017-04-21 09:45:57
--

local gameScene = nil

--庄家标示位置
local bankerSignPos = {
	{229,107},
	{1062,380},
	{840,594},
	{744,655},
	{448,600},
	{215,375},
}

--抢庄标示位置
local robBankerSignPos = {
	{275,65},
	{1015,317},
	{928,465},
	{639,530},
	{346,462},
	{260,319},
	
}

--筹码标示位置
local chipStartPos = {
	{87,58},
	{1193,366},
	{1193,575},
	{87,575},
	{87,366},
	{87,366},
}



local WRNN_PlayerMgr = {}

function WRNN_PlayerMgr:init(scene)
	gameScene = scene

	self.playerInfos = {}	 --桌子上所有玩家的信息
	self.CountDown_labels = {}	   --倒计时数字
--	self.CountDown_progress = {}   --倒计时背景	
	self.betChips = {}  --下注筹码精灵
	self.robBankerState = {}  --抢庄状态UI
	self.ui_banker = nil  --庄家标示
end

function WRNN_PlayerMgr:clear()
end

--[[
	* 玩家坐下
	* @param table data  玩家数据
	* @return table 玩家信息
--]]
function WRNN_PlayerMgr:playerSeatDown(data)
	--创建一个玩家信息对象
	local playerInfo = gameScene.WRNN_PlayerInfo.new(data)
	self.playerInfos[data.seat] = playerInfo

	--显示玩家的UI信息
	gameScene.WRNN_uiPlayerInfos:showPlayerInfoUI(playerInfo)
end

--[[
	* 玩家离开
	* @param number seatId  玩家椅子号
--]]
function WRNN_PlayerMgr:playerLeave(seatId)
	if seatId == 1 and not gameScene.watching then
		gameScene.seatIndex = 0 
		gameScene.session = 0
	end

--	gameScene.WRNN_uiPlayerInfos.ui_infos[seatId].ui_body:setVisible(false)
	gameScene.WRNN_uiPlayerInfos:hidePlayerInfoUI(seatId)
	--self.playerInfos[seatId] = nil
end

--[[
	* 玩家准备
	* @param number seatId  玩家椅子号
	* @param boolean flag  显示状态
--]]
function WRNN_PlayerMgr:playerReady(seatId,flag)
	local user_ui_info = gameScene.WRNN_uiPlayerInfos.ui_infos[seatId]

	--设置为已准备
	if flag then
		self.playerInfos[seatId]:setReadyState(1)
	end

	--显示准备标示
	user_ui_info.k_sp_ready:setVisible(flag)
end

--[[
	* 显示玩家下注分数
	* @param number seatId  玩家椅子号
	* @param bool flag  显示状态
	* @param number betNum  显示状态
--]]
function WRNN_PlayerMgr:showPlayerBetNum(seatId,flag,betNum)
	betNum = betNum or 0

	local user_ui_info =  gameScene.WRNN_uiPlayerInfos.ui_infos[seatId]

	user_ui_info.k_sp_XiaZhuBG:setVisible(flag)
	user_ui_info.k_tx_XiaZhu_Num:setVisible(flag)
	user_ui_info.k_sp_GoldIcon:setVisible(flag)

	user_ui_info.k_tx_XiaZhu_Num:setString(gameScene.WRNN_Util.num2str(betNum))
  

   

end

--[[
	* 倒计时
	* @param number seatId  计时玩家椅子号
	* @param number countDown  倒数时间
--]]
function WRNN_PlayerMgr:showPlayerTimer(seatId,countDown)
	print("显示倒计时:" .. seatId,gameScene.watching,gameScene.status,countDown)

	--未参与游戏
	if not gameScene.watching then
		if seatId == 1 and gameScene.status ~= 0 then
			return 
		end
	end

	local ui_body = gameScene.WRNN_uiPlayerInfos.ui_infos[seatId].ui_body
	countDown = countDown or 0

	-- if self.CountDown_labels[seatId] then
	-- 	self.CountDown_labels[seatId]:removeFromParent()
	-- 	self.CountDown_labels[seatId] = nil
	-- end

	-- if self.CountDown_progress[seatId] then
	-- 	self.CountDown_progress[seatId]:removeFromParent()
	-- 	self.CountDown_progress[seatId] = nil
	-- end

	--ui_body:stopAllActions()

	if countDown == 0 then
		return 
	end

	local res_countDown_path = ""
	local X,Y

    if seatId == 1 then
    	res_countDown_path = gameScene.WRNN_Const.PATH.IMG_WIDTH_COUNTDOWN_BG
    	X = 129
    	Y = 60
    else
    	res_countDown_path = gameScene.WRNN_Const.PATH.IMG_HEIGHT_COUNTDOWN_BG
    	X = 70
    	Y = 93
    end

	-- --数字
 --    self.CountDown_labels[seatId] = cc.LabelAtlas:_create()
 --    self.CountDown_labels[seatId]:initWithString(
 --            tostring(countDown),
 --           	gameScene.WRNN_Const.PATH.TX_GAME_TIME_NUMBER,
 --            22,
 --            30,
 --            string.byte('0'))
 --    self.CountDown_labels[seatId]:setPosition(cc.p(X,Y))
 --    self.CountDown_labels[seatId]:setAnchorPoint(cc.p(0.5,0.5))
 --    ui_body:addChild(self.CountDown_labels[seatId],1)

    --背景
	-- self.CountDown_progress[seatId] = display.newProgressTimer(res_countDown_path,display.PROGRESS_TIMER_RADIAL)
	
	-- self.CountDown_progress[seatId]:setPercentage(100)
	-- self.CountDown_progress[seatId]:setScaleX(-1)
	-- self.CountDown_progress[seatId]:setAnchorPoint(0.5,0.5)
	-- self.CountDown_progress[seatId]:setPosition(cc.p(X,Y))
	-- ui_body:addChild(self.CountDown_progress[seatId],1)
	-- self.CountDown_progress[seatId]:runAction(cca.progressTo(countDown,0))

	--定时器
    -- ui_body:schedule(function()

    -- 	countDown = countDown - 1
    	
    -- 	--self.CountDown_labels[seatId]:setString(tostring(countDown))

    -- 	if countDown == 0 then
    -- 		--self.CountDown_labels[seatId]:removeFromParent()
    -- 		--self.CountDown_progress[seatId]:removeFromParent()
    -- 		--self.CountDown_labels[seatId] = nil
    -- 		--self.CountDown_progress[seatId] = nil
    -- 		--ui_body:stopAllActions()
    -- 	end
    -- end,1.0)

 
 --    local frames = display.newFrames("Flame_%02d.png", 1, 16)
	-- local animation = display.newAnimation(frames, 0.1)
	-- local animate = cca.animate(animation)

	-- local LieHuo = display.newSprite("#Flame_01.png", self.CountDown_progress[seatId]:getContentSize().width/2, self.CountDown_progress[seatId]:getContentSize().height-5)
	-- LieHuo:addTo(self.CountDown_progress[seatId])
	-- LieHuo:runAction(cca.repeatForever(animate))

	-- local sequenceMove = nil
	-- --长 宽 边长
	-- local width = self.CountDown_progress[seatId]:getContentSize().width
	-- local height = self.CountDown_progress[seatId]:getContentSize().height
	-- local length = width*2 + height*2
	-- --时间
	-- local time = countDown

	-- if seatId == 1 then
	-- 	local moveBy_01 = cca.moveBy(time*(width/2/length) * 0.83, -(width/2)+5, 0)
	-- 	local moveBy_02 = cca.moveBy((time*(height/length)/2) * 1.3, 0, -((height)/2))
	-- 	local moveBy_03 = cca.moveBy((time*(height/length)/2) * 1.8, 0, -((height-10)/2))
	-- 	local moveBy_04 = cca.moveBy((time*(width/length)*0.25) * 0.55, (width-8)*0.3, 0)
	-- 	local moveBy_05 = cca.moveBy((time*(width/length)*0.7) * 0.85, (width-8)*0.7, 0)
	-- 	local moveBy_06 = cca.moveBy((time*(height/length)/2) * 0.6, 0, height*0.3)
	-- 	local moveBy_07 = cca.moveBy((time*(height/length)/2) * 2.25, 0, height*0.7-5)
	-- 	local moveBy_08 = cca.moveBy(time*(width/2/length) * 0.77, -(width/2)+5, 0)
	
	-- 	sequenceMove = cca.seq{moveBy_01,moveBy_02,moveBy_03,moveBy_04,moveBy_05,moveBy_06,moveBy_07,moveBy_08}
	-- else
	-- 	local moveBy_01 = cca.moveBy(time*(width/2/length)*1.1, -(width/2)+5, 0)
	-- 	local moveBy_02 = cca.moveBy((time*(height/length)*0.3)*0.8, 0, -(height*0.3))
	-- 	local moveBy_03 = cca.moveBy((time*(height/length)*0.7), 0, -((height-10)*0.7))
	-- 	local moveBy_04 = cca.moveBy((time*(width/length)*0.25) * 0.7, (width-8)*0.25, 0)
	-- 	local moveBy_05 = cca.moveBy((time*(width/length)*0.7)*1.3, (width-2)*0.7, 0)
	-- 	local moveBy_06 = cca.moveBy((time*(height/length)*0.25) * 0.6, 0, height*0.25)
	-- 	local moveBy_07 = cca.moveBy((time*(height/length)*0.75) * 1.1, 0, height*0.75-8)
	-- 	local moveBy_08 = cca.moveBy((time*(width/2/length) * 0.4) * 0.7, -(width*0.2), 0)
	-- 	local moveBy_09 = cca.moveBy((time*(width/2/length) * 0.6), -(width*0.3)+7, 0)
	
	-- 	sequenceMove = cca.seq{moveBy_01,moveBy_02,moveBy_03,moveBy_04,moveBy_05,moveBy_06,moveBy_07,moveBy_08,moveBy_09}
	-- end

	-- LieHuo:runAction(sequenceMove)

   
end

--[[
	* 下注
	* @param number seatId  椅子号
	* @param number betGold  下注金额
	* @param bool isRecovery  是不是恢复场景
--]]
function WRNN_PlayerMgr:showPlayerBetGold(seatId,betGold,isRecovery)
	--显示筹码
	local betRect = gameScene.WRNN_uiOperates.k_img_Bet_Rect:getBoundingBox()

	local X = chipStartPos[seatId][1]
	local Y = chipStartPos[seatId][2]
	local rand_X = math.random(betRect.x+30,betRect.x + betRect.width-30)
	local rand_Y = math.random(betRect.y+30,betRect.y + betRect.height-30)
	local time = math.random(5,9) * 0.1

	local chip = display.newSprite(gameScene.WRNN_Const.PATH["IMG_CHIP_" .. betGold]):addTo(gameScene.root)
	chip:setScale(0.5)

	if isRecovery then
		chip:pos(rand_X,rand_Y)
	else
		chip:pos(X,Y)
		local sequence = cca.seq({cca.moveTo(time, rand_X, rand_Y),cca.cb(function() 
			--gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_BET)
		 end)})
		chip:runAction(sequence)
	end

 	table.insert(self.betChips,chip)
end

--[[
	* 获取玩家金币
	* @param number seatId  椅子号
--]]
function WRNN_PlayerMgr:getPlayerGold(seatId)
	return self.playerInfos[seatId]:getGold()
end
function WRNN_PlayerMgr:setPlayerGold(seatId,gold)
	return self.playerInfos[seatId]:setGold(gold)
end

--[[
	* 获取玩家名字
	* @param number seatId  椅子号
--]]
function WRNN_PlayerMgr:getPlayerName(seatId)
	return self.playerInfos[seatId]:getName()
end

--[[
	* 获取玩家信息
	* @param number seatId  获取玩家信息的椅子号
	* @return table 玩家信息
--]]
function WRNN_PlayerMgr:getPlayerInfoWithSeatID(seatId)
	return self.playerInfos[seatId]
end

--[[
	* 清理筹码
--]]
function WRNN_PlayerMgr:clearAllChip()
	for _,ui_chip in pairs(self.betChips) do
		ui_chip:removeFromParent()
	end

	self.betChips = {}
end

--[[
	* 显示庄家标示
	* @param number seatId  椅子号
	* @param bool flag  显示状态
--]]
function WRNN_PlayerMgr:showBankerMark(seatId,bei,flag)

    if flag then
		    	if self.ui_banker then
					self.ui_banker:removeFromParent()
					self.ui_banker = nil
				end

			self.ui_banker = display.newSprite(gameScene.WRNN_Const.PATH.IMG_BANKER,640,360):addTo(gameScene.root)
			self.ui_banker:setLocalZOrder(11)
		    if bei and bei >0 and bei <= 4 then
		    	 local s = string.format("res/Image/WRNN/gameui/qz_fanbei_%d.png",bei)
		    	local fanbei = display.newSprite(s):addTo(self.ui_banker)
		    	fanbei:pos(90,30)
		    end

			local user_ui_info =  gameScene.WRNN_uiPlayerInfos.ui_infos[seatId].ui_body
		    local move = cc.MoveTo:create(0.5,cc.p(bankerSignPos[seatId][1],bankerSignPos[seatId][2]))
		    transition.execute(self.ui_banker, move)

	else
		if self.ui_banker then
					self.ui_banker:removeFromParent()
					self.ui_banker = nil
		end
    end

	

end

--[[
	* 显示抢庄状态
	* @param number seatId  椅子号
	* @param bool flag  是否抢庄
--]]
function WRNN_PlayerMgr:showRobBankerState(seatId,flag)
	local ui_state = nil

	print("抢庄 状态  "  .. flag)

    if flag  == 0  then  --不抢
       ui_state = display.newSprite(gameScene.WRNN_Const.PATH.TX_GAME_UI_BUQING)
    else
    	if gameScene.roominfo.banker_type == 4 then -- 明牌抢庄      
           local s = string.format("res/Image/WRNN/gameui/qz_fanbei_%d.png",flag)
           ui_state = display.newSprite(s)

    	else
    	   ui_state = display.newSprite(gameScene.WRNN_Const.PATH.TX_GAME_UI_QIANG)
    	end

    end

	ui_state:pos(robBankerSignPos[seatId][1],robBankerSignPos[seatId][2])
	ui_state:addTo(gameScene.root)

	table.insert(self.robBankerState,ui_state)
end

--[[
	* 清理抢庄状态
--]]
function WRNN_PlayerMgr:clearRobBankerState()
	print("-----清理抢庄状态-----")
	for _,ui_state in pairs(self.robBankerState) do
		ui_state:removeFromParent()
	end

	self.robBankerState = {}
end

--[[
	* 清理所有庄家记录
--]]
function WRNN_PlayerMgr:clearAllBankerSign()
	for _,playerInfo in pairs(self.playerInfos) do
		playerInfo:setBankerIdentity(false)
	end
end

--[[
	* 清理不在游戏中的玩家信息
	* @param table inGamePlayers 正在游戏的玩家椅子号
--]]
function WRNN_PlayerMgr:clearNotinvolvedPlayerInfo(inGamePlayers)
	for i=1,6 do
		--是否参与游戏
		local isGameInvoleve = false

		if self.playerInfos[i] then
			for _,seat in pairs(inGamePlayers) do
				seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)
				--该椅子号的玩家正在参与游戏
				if i == seat then
					isGameInvoleve = true
				end
			end
		end

		if not isGameInvoleve then
			self.playerInfos[i] = nil
		end
	end
end

return WRNN_PlayerMgr