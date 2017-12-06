--
-- Author: peter
-- Date: 2017-03-10 11:17:18
--

local gameScene = nil  --游戏场景
local session = 0    --数据校验

local seatTour = 0
local seatRecord = 0

local roomMsg = {}
local wlMsg = {}

local hideTourCards = {}

local handlers = {room=roomMsg, WL=wlMsg}

local WL_MsgMgr = {}

function WL_MsgMgr:init(scene)
	gameScene = scene
	hideTourCards = {}
end

function WL_MsgMgr:clear()
	seatTour = 0
	seatRecord = 0
end

-- ------------------------------ 乌龙消息 回复------------------------------
--[[
	* 开局发牌
	* @param table msg  消息数据
--]]
function wlMsg.Deal(msg)
	hideTourCards = {}

	print("游戏开始发牌")

	msg.callPlayer = gameScene.WL_Util.convertSeatToPlayer(msg.callPlayer)

	--底分
	gameScene.WL_uiTableInfos:setDiFen(msg.baseScore)
	--最大出牌时间
	gameScene.openCardTime = msg.openCardTime
	--隐藏等待其他玩家
	gameScene.WL_uiTableInfos:showWaitState(false)
	--隐藏所有玩家准备标示
	gameScene.WL_PlayerMgr:hidePlayerAllReadyTitle()
	--显示所有玩家奖金背景
	gameScene.WL_uiPlayerInfos:showAllPlayerTitle(true)
	--发牌
	gameScene.WL_CardMgr:sendPlayerCard(msg.cardOfDeal,msg.callPlayer)
end

--[[
	* 出牌回复
	* @param table msg  消息数据
--]]
function wlMsg.HandoutRep(msg)
	local seatid = gameScene.WL_Util.convertSeatToPlayer(msg.seatid)
	local handoutPlayer = gameScene.WL_Util.convertSeatToPlayer(msg.handoutPlayer)

	-- if seatRecord == handoutPlayer then
	-- 	if seatTour ~= 0 then
	-- 		--隐藏牌
	-- 		gameScene.WL_PlayerMgr:hidePlayerChuPaiUI(seatTour)
	-- 		seatRecord = 0
	-- 		seatTour = 0
	-- 	end
	-- end

	-- if msg.winNum == 1 or msg.winNum == 2 then
	-- 	if seatTour ~= 0 then
	-- 		--隐藏牌
	-- 		gameScene.WL_PlayerMgr:hidePlayerChuPaiUI(seatTour)
	-- 	end

	-- 	seatTour = seatid
	-- 	seatRecord = handoutPlayer
	-- elseif msg.winNum == 3 then
	-- 	seatRecord = 0
	-- 	seatTour = 0
	-- end

	if hideTourCards[handoutPlayer] then
		if hideTourCards[handoutPlayer].seatTour ~= 0 then
			--隐藏牌
			gameScene.WL_PlayerMgr:hidePlayerChuPaiUI(hideTourCards[handoutPlayer].seatTour)
		end

		hideTourCards[handoutPlayer] = nil
	end

	if msg.winNum == 1 or msg.winNum == 2 then
		if msg.winNum == 2 then
			if hideTourCards[seatid] then
				if hideTourCards[seatid].seatTour ~= 0 then
					--隐藏牌
					gameScene.WL_PlayerMgr:hidePlayerChuPaiUI(hideTourCards[seatid].seatTour)
				end
		
				hideTourCards[seatid] = nil
			end
		end

		hideTourCards[handoutPlayer] = {}
		hideTourCards[handoutPlayer].seatTour = seatid
	end

	print(seatid .. " 号玩家打出来牌，下一位出牌的玩家是 " .. handoutPlayer)

	gameScene.WL_PlayerMgr:playerEndChuPai(seatid,msg.handoutCard,msg.winNum)

	--msg.result == 2 的时候  本局已经结束无需继续出牌
	if msg.result ~= 2 then
		gameScene.WL_PlayerMgr:playerStartChuPai(handoutPlayer,msg.curCard)
	end

	--刷新手牌数
	gameScene.WL_uiPlayerCardBack:udpatePlayerCardNum(seatid,msg.cardNum)

	--刷新奖金
	gameScene.WL_uiPlayerInfos:updateBonus(seatid,msg.bonus)

	--刷新本轮当前总分
	gameScene.WL_uiTableInfos:updateRoundScore(msg.score)
end

--[[
	* 本轮结算
	* @param table msg  消息数据
--]]
function wlMsg.RoundSettle(msg)
	local winner = gameScene.WL_Util.convertSeatToPlayer(msg.winner)

	print("本轮出牌结束胜利的玩家是 " .. winner)

	--刷新本轮当前总分
	gameScene.WL_uiTableInfos:updateRoundScore(0)

    --得分
    gameScene.WL_uiTableInfos:showScoreAction(winner,msg.winScore)

	--刷新Player本局总得分
	gameScene.WL_uiPlayerInfos:updateFinalScore(winner,msg.finalScore)

	--清理本轮最大牌
	gameScene.WL_PlayerMgr:setLastCardNil()
end

--[[
	* 本局结算
	* @param table msg  消息数据
--]]
function wlMsg.Result(msg)

	print("本局游戏结算")
	--隐藏其他玩家的手牌
	gameScene.WL_uiPlayerCardBack:showPlayerCardBack(false)

	--清理所有桌子上打出的牌
	gameScene.WL_PlayerMgr:clearTableCards(false)

	--显示其他玩家剩余的手牌正面
	for seat,playerRecordInfo in ipairs(msg.records) do
		playerRecordInfo.seat = gameScene.WL_Util.convertSeatToPlayer(seat)
		playerRecordInfo.name = gameScene.WL_PlayerMgr:getPlayerInfoWithSeatID(playerRecordInfo.seat):getName()

		if #playerRecordInfo.cards ~= 0 then
			if playerRecordInfo.seat ~= 1 then
				gameScene.WL_PlayerMgr:showPlayerChuPaiUI(playerRecordInfo.seat,playerRecordInfo.cards)
			end
		end
	end

	--隐藏 取消托管 按钮
	gameScene.WL_uiOperates:showQuXiaoTuoGuanBtn(false)

	--隐藏排序按钮
	gameScene.WL_uiOperates:showPaiXuBtn(false)

	--显示结算界面
	gameScene.WL_uiResults:showGameResult(true,msg.records)
end

--[[
	* 场景恢复
	* @param table msg  消息数据
--]]
function wlMsg.GamingSence(msg)
	print("开始场景恢复")
	local curPlayer = gameScene.WL_Util.convertSeatToPlayer(msg.curPlayer)

	--开启触摸
	gameScene.WL_CardTouchMgr:setRootTouchEnabled(true)

	--隐藏开始游戏按钮
	gameScene.WL_uiOperates:showStartReady(false)

	--赋值倒计时时间
	gameScene.openCardTime = msg.openCardTime

	--显示倒计时
	gameScene.WL_PlayerMgr:showPlayerTimer(curPlayer,msg.timeRelease)

	--显示底分
	gameScene.WL_uiTableInfos:setDiFen(msg.baseScore)

	--当前总分
	gameScene.WL_uiTableInfos:showRoundScore(true)
	gameScene.WL_uiTableInfos:updateRoundScore(msg.score)

	--自己的手牌
	gameScene.WL_CardMgr:sendPlayerCard2(msg.handCard)

	--显示每张牌的牌数
	gameScene.WL_CardMgr:showCardStatistics()

	--显示牌背
	gameScene.WL_uiPlayerCardBack:showPlayerCardBack(true)

	--显示所有玩家奖金背景
	gameScene.WL_uiPlayerInfos:showAllPlayerTitle(true)

	--显示排序按钮
	gameScene.WL_uiOperates:showPaiXuBtn(true)

	--如果当前出牌的玩家是自己
	if curPlayer == 1 then
		local curCard = gameScene.WL_Util.conversionCardInfoForm(msg.curCard)
		gameScene.WL_uiOperates:getTiShiCardInfos(curCard)
	end

	--每个玩家的信息状态
	for seat,playerState in ipairs(msg.players) do
		local seatid = gameScene.WL_Util.convertSeatToPlayer(seat)

		--刷新手牌数
		gameScene.WL_uiPlayerCardBack:udpatePlayerCardNum(seatid,playerState.cardNum)

		--奖金数
		gameScene.WL_uiPlayerInfos:updateBonus(seatid,playerState.bonus)

		--得分
		gameScene.WL_uiPlayerInfos:updateFinalScore(seatid,playerState.score)

		--玩家状态
		if playerState.state == 3 then    --正在托管
			gameScene.WL_PlayerMgr:setPlayerTuoGuanState(seatid,true)
		end

		--桌面上的牌
		if playerState.state ~= 4 and seatid ~= curPlayer then
			gameScene.WL_PlayerMgr:showPlayerChuPaiUI(seatid, playerState.handoutCards)
		end

		--显示一二三游
		if playerState.state == 5 or playerState.state == 6 or playerState.state == 7 then
			gameScene.WL_PlayerMgr:showTourNumSprite(seatid, playerState.state-4)
			gameScene.WL_PlayerMgr:hidePlayerChuPaiUI(seatid)
		end
	end
end

--[[
	* 开启托管
	* @param table msg  消息数据
--]]
function wlMsg.TuoGuan(msg)
	local seatid = gameScene.WL_Util.convertSeatToPlayer(msg.seatid)
	print(seatid .. "号玩家开启了托管")
	gameScene.WL_PlayerMgr:setPlayerTuoGuanState(seatid,true)
end

--[[
	* 取消托管
	* @param table msg  消息数据
--]]
function wlMsg.CancelTuoGuanRep(msg)
	local seatid = gameScene.WL_Util.convertSeatToPlayer(msg.seatid)
	local curPlayer = gameScene.WL_Util.convertSeatToPlayer(msg.curPlayer)
	print(seatid .. "号玩家取消了托管")

	--取消托管
	gameScene.WL_PlayerMgr:setPlayerTuoGuanState(seatid,false)

	--显示倒计时
	gameScene.WL_PlayerMgr:showPlayerTimer(seatid, msg.timeRelease)

	--如果自己正在出牌 显示操作按钮
	if curPlayer == 1 and seatid == 1 then
		gameScene.WL_uiOperates:showOperates()
	end
end

-- ------------------------------ 框架消息 回复------------------------------
--[[
	* 初始化游戏
	* @param table msg  消息数据
--]]
function roomMsg.InitGameScenes(msg)
	print("初始化游戏场景")

	--旁观玩家  隐藏掉开始按钮等等
    if msg.watching then
    	return 
    end

	gameScene.seatIndex = msg.seat
	gameScene.session = msg.session

	gameScene.WL_uiOperates:showStartReady(true)
end

--[[
	* 有玩家进入桌子
	* @param table msg  消息数据
--]]
function roomMsg.EnterGame(msg)
	msg.seat = gameScene.WL_Util.convertSeatToPlayer(msg.seat)

	print("椅子号: " .. msg.seat .. " 的玩家进入")

	--玩家坐下
	local playerInfo = gameScene.WL_PlayerMgr:playerSeatDown(msg)
end

--[[
	* 有玩家离开桌子
	* @param table msg  消息数据
--]]
function roomMsg.LeaveGame(msg)
	msg.seat = gameScene.WL_Util.convertSeatToPlayer(msg.seat)
	print("椅子号: " .. msg.seat .. " 的玩家离开")
	gameScene.WL_PlayerMgr:playerLeave(msg.seat)
end

--[[
	* 准备请求的个人回复
	* @param table msg  消息数据
--]]
function roomMsg.ReadyRep(msg)
	--隐藏准备按钮
	gameScene.WL_uiOperates:showStartReady(false)

	--再来一局清理上一局的信息
	if gameScene.WL_uiResults:isVisible() then

		--清理桌子上的牌
		gameScene.WL_PlayerMgr:clearTableCards(true)

		--清理游数
		gameScene.WL_PlayerMgr:clearTourNumSprite()

		--隐藏本轮分
		gameScene.WL_uiTableInfos:showRoundScore(false)

		--清理低分
		gameScene.WL_uiTableInfos:setDiFen("")

		--手里手牌
		gameScene.WL_CardMgr:removeAllCards()

		--隐藏结算界面
		gameScene.WL_uiResults:showGameResult(false)
	end

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_READY)
end

--[[
	* 有玩家准备游戏
	* @param table msg  消息数据
--]]
function roomMsg.Ready(msg)
	msg.seat = gameScene.WL_Util.convertSeatToPlayer(msg.seat)
	print("椅子号: " .. msg.seat .. " 的玩家已准备游戏")

	--显示准备标示
	gameScene.WL_PlayerMgr:playerReady(msg.seat,true)

	if msg.seat == 1 then
		--显示等待其他玩家
		gameScene.WL_uiTableInfos:showWaitState(true)
	end
end


function WL_MsgMgr:dispatchMessage(name,msg)
	if msg then
        dump(msg, name)
    else
        print("error: 调用 WL_MsgMgr:dispatchMessage 方法时 参数msg ~= true  name = " .. name)
    end

	local clsName, funcName = name:match "([^.]*).(.*)"
	if handlers[clsName] then
		--如果是游戏消息则校验数据
		if clsName == "WL" then
			if gameScene.session == msg.session then
				handlers[clsName][funcName](msg)
			end
		else
			handlers[clsName][funcName](msg)
		end
	end
end

return WL_MsgMgr