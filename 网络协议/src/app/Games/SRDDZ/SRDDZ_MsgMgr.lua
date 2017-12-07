--
-- Author: peter
-- Date: 2017-02-17 13:09:12
--

local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")

local gameScene = nil  --游戏场景
local session = 0    --数据校验

local roomMsg = {}
local srddzMsg = {}

local handlers = {room=roomMsg, SRDDZ=srddzMsg}

local SRDDZ_MsgMgr = {}

function SRDDZ_MsgMgr:init(scene)
	gameScene = scene
end

function SRDDZ_MsgMgr:clear()

end

-- ------------------------------ 四人斗地主消息 回复------------------------------
--[[
	* 开局发牌
	* @param table msg  消息数据
--]]
function srddzMsg.Deal(msg)
	print("游戏开始发牌")

	msg.callPlayer = SRDDZ_Util.convertSeatToPlayer(msg.callPlayer)

	--基础分 地主牌
	gameScene.SRDDZ_uiTableInfos:setDiFen(msg.baseScore)
	gameScene.SRDDZ_uiTableInfos:setJiaoFen(0)
	gameScene.SRDDZ_uiTableInfos:setDiZhuCardsShowState(true)
	--最大出牌时间
	SRDDZ_Util.openCardTime = msg.openCardTime
	--开局
	gameScene.SRDDZ_PlayerMgr:Opening()
	--发牌
	gameScene.SRDDZ_CardMgr:sendPlayerCard(msg.cardOfDeal,msg.callPlayer)
end

--[[
	* 叫分请求回复
	* @param table msg  消息数据
--]]
function srddzMsg.CallScoreRep(msg)
	msg.seatid = SRDDZ_Util.convertSeatToPlayer(msg.seatid)
	msg.curCallPlayer = SRDDZ_Util.convertSeatToPlayer(msg.curCallPlayer)

	--关闭倒计时
	gameScene.SRDDZ_PlayerMgr:showPlayerTimer(msg.seatid,0)

	--隐藏叫分按钮
	if msg.seatid == 1 then
		gameScene.SRDDZ_uiOperates:setOpPanel_1(false)
	end

	if msg.result == 1 then --游戏开始
		print("叫分结束")

		gameScene.SRDDZ_PlayerMgr:removeAllPlayerScore()
		--显示地主的叫分
		if msg.seatid ~= 1 then
			gameScene.SRDDZ_PlayerMgr:showPlayerScore(msg.seatid,msg.score)
		end
	else  --继续叫分
		--显示叫分
		gameScene.SRDDZ_PlayerMgr:showPlayerScore(msg.seatid,msg.score)
		gameScene.SRDDZ_PlayerMgr:showPlayerScore(msg.curCallPlayer)

		--显示倒计时
		gameScene.SRDDZ_PlayerMgr:showPlayerTimer(msg.curCallPlayer)

		--显示叫分按钮
		if msg.curCallPlayer == 1 then
			local touchState = {true,true,true,true}
	
			if msg.bMustCall then  --手里有两个王必须叫三分
				touchState = {false,false,false,true}
			elseif msg.result == 2 then  --最后一个人必须叫 2 or 3分
				touchState = {false,false,true,true}
			else
				for i=1,msg.multiple do
					touchState[i+1] = false
				end
			end
	
			gameScene.SRDDZ_uiOperates:setOpPanel_1(true,touchState)
		end
	end

	--叫的分数显示
	if msg.score ~= 0 then
		gameScene.SRDDZ_uiTableInfos:setJiaoFen(msg.score)
	end

	--播放音效
	if gameScene.SRDDZ_PlayerMgr:getPlayerInfoWithSeatID(msg.seatid).sex == 1 then  --女
		gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath["SRDDZ_SOUND_FEMALE_JIAOFEN_" .. msg.score])
	else
		gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath["SRDDZ_SOUND_MALE_JIAOFEN_" .. msg.score])
	end
end

--[[
	* 游戏开始
	* @param table msg  消息数据
--]]
function srddzMsg.GameBegin(msg)
	--显示排序按钮
	print("显示排序按钮")
	cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_PaiXu"):setVisible(true)

	msg.landlord = SRDDZ_Util.convertSeatToPlayer(msg.landlord)

	--显示地主的8张牌正面
	gameScene.SRDDZ_uiTableInfos:setDiZhuCardsShowState(true,msg.landlordCard)

	--显示地主身份
	gameScene.SRDDZ_PlayerMgr:showPlayerLandlordIdentity(msg.landlord,msg.landlordCard)
	
	--刷新地主手牌数
	gameScene.SRDDZ_uiPlayerCardBack:udpatePlayerCardNum(msg.landlord,33)

	--显示倒计时
	gameScene.SRDDZ_PlayerMgr:showPlayerTimer(msg.landlord,30)

	--显示出牌
	if msg.landlord == 1 then
		gameScene.SRDDZ_PlayerMgr:showPlayerChuPaiState()
	end
end

--[[
	* 有玩家打出了牌
	* @param table msg  消息数据
--]]
function srddzMsg.HandoutRep(msg)
	gameScene.SRDDZ_PlayerMgr:removeAllPlayerScore()

	msg.seatid = SRDDZ_Util.convertSeatToPlayer(msg.seatid)
	msg.handoutPlayer = SRDDZ_Util.convertSeatToPlayer(msg.handoutPlayer)

	--刷新牌数
	gameScene.SRDDZ_uiPlayerCardBack:udpatePlayerCardNum(msg.seatid,msg.cardNum)
	--显示出的牌
	gameScene.SRDDZ_PlayerMgr:ShowPlayerChuPaiUI(msg.seatid,msg.handoutCard,true)

	if msg.cardNum ~= 0 then
		--清理当前出牌玩家上次出的牌
		gameScene.SRDDZ_PlayerMgr:ShowPlayerChuPaiUI(msg.handoutPlayer)
	end

	--隐藏出牌玩家的 出牌按钮
	if msg.seatid == 1 then
		gameScene.SRDDZ_uiOperates:setOpPanel_2(false)
		gameScene.SRDDZ_uiOperates:setOpPanel_3(false)
	end

	gameScene.SRDDZ_CardTouchMsg.PinningCardInfo = {}

	--关闭倒计时
	gameScene.SRDDZ_PlayerMgr:showPlayerTimer(msg.seatid,0)

	--游戏结束
	if msg.cardNum ==0 then 
		return 
	end

	--显示倒计时
	gameScene.SRDDZ_PlayerMgr:showPlayerTimer(msg.handoutPlayer)

	--显示当前出牌玩家的按钮
	if msg.handoutPlayer == 1 then
		gameScene.SRDDZ_PlayerMgr:showPlayerChuPaiState(msg.curCard)
	end
end

--[[
	* 结算
	* @param table msg  消息数据
--]]
function srddzMsg.Result(msg)
	--隐藏排序按钮
	cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_PaiXu"):setVisible(false)
	
	--隐藏其他玩家的手牌
	gameScene.SRDDZ_uiPlayerCardBack:setPalyerCardStage(false)

	-- --清理所有桌子上打出的牌
	-- gameScene.SRDDZ_PlayerMgr:clearAllPlayerCards(false)

	--显示其他玩家剩余的手牌正面
	local allCards = {}

	for k,v in ipairs(msg.records) do
		--排序从大到小
		local cards = SRDDZ_Util.conversionCardInfoForm(v.cards)
		SRDDZ_Util.SortCards(1,cards,"num","color")
		allCards[k] = cards

		v.seat = SRDDZ_Util.convertSeatToPlayer(k)
		v.name = gameScene.SRDDZ_PlayerMgr:getPlayerInfoWithSeatID(v.seat).mName

		if #cards == 0 then
			--清理所有桌子上打出的牌
			gameScene.SRDDZ_PlayerMgr:clearAllPlayerCards(false,v.seat)
		end
	end

	gameScene.SRDDZ_PlayerMgr:showPlayerResultsCards(allCards)

	--隐藏 取消托管 按钮
	cc.uiloader:seekNodeByName(gameScene.root, "k_btn_QuXiaoTuoGuan"):setVisible(false)

	--显示结算界面
	gameScene.SRDDZ_uiResults:showGameResult(true,msg)
end

--[[
	* 叫分场景恢复
	* @param table msg  消息数据
--]]
function srddzMsg.CallScoreSence(msg)
	gameScene.SRDDZ_uiOperates:setReadyBtnState(false)

	SRDDZ_Util.openCardTime = msg.openCardTime

	--当前叫分玩家的 椅子号
	local curPlayerSeatID = SRDDZ_Util.convertSeatToPlayer(msg.curPlayer)

	--低分 8张牌
	gameScene.SRDDZ_uiTableInfos:setDiFen(msg.baseScore)
	gameScene.SRDDZ_uiTableInfos:setJiaoFen(msg.multiple)
	gameScene.SRDDZ_uiTableInfos:setDiZhuCardsShowState(true)

	--倒计时时间
	gameScene.SRDDZ_PlayerMgr:showPlayerTimer(curPlayerSeatID, msg.timeRelease)

	--手牌 
	gameScene.SRDDZ_CardMgr:sendPlayerCard2(msg.handcard)

	--其他玩家叫分数
	for k,v in ipairs(msg.playerState) do
		local seat = SRDDZ_Util.convertSeatToPlayer(k)

		if seat ~= 1 then
			if v >= 0 then
				gameScene.SRDDZ_PlayerMgr:showPlayerScore(seat,v)
			end
		else
			if curPlayerSeatID ~= 1 then
				if v >= 0 then
					gameScene.SRDDZ_PlayerMgr:showPlayerScore(seat,v)
				end
			end
		end
	end

	if curPlayerSeatID == 1 then
		--自己叫分状态
		local touchState = {true,true,true,true}
		
		if msg.multiple == 4 then  --手里有两个王必须叫三分
			touchState = {false,false,false,true}
		elseif msg.multiple == 5 then  --最后一个人必须叫 2 or 3分
			touchState = {false,false,true,true}
		else
			for i=1,msg.multiple do
				touchState[i+1] = false
			end
		end
		
		gameScene.SRDDZ_uiOperates:setOpPanel_1(true,touchState)
	end
end

--[[
	* 游戏场景恢复
	* @param table msg  消息数据
--]]
function srddzMsg.GamingSence(msg)
	--显示排序按钮
	cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_PaiXu"):setVisible(true)

	gameScene.SRDDZ_uiOperates:setReadyBtnState(false)

	SRDDZ_Util.openCardTime = msg.openCardTime

	--当前出牌玩家的 椅子号
	local curPlayerSeatID = SRDDZ_Util.convertSeatToPlayer(msg.curPlayer)

	--低分 8张牌
	gameScene.SRDDZ_uiTableInfos:setDiFen(msg.baseScore)
	gameScene.SRDDZ_uiTableInfos:setJiaoFen(msg.multiple)
	gameScene.SRDDZ_uiTableInfos:setDiZhuCardsShowState(true,msg.landlordCards)

	--倒计时时间
	gameScene.SRDDZ_PlayerMgr:showPlayerTimer(curPlayerSeatID, msg.timeRelease)

	--手牌 
	gameScene.SRDDZ_CardMgr:sendPlayerCard2(msg.handcard)
	gameScene.SRDDZ_uiPlayerCardBack:setPalyerCardStage(true)

	--每个玩家的状态
	for k,v in ipairs(msg.players) do
		local seat = SRDDZ_Util.convertSeatToPlayer(k)

		--刷新手牌数
		gameScene.SRDDZ_uiPlayerCardBack:udpatePlayerCardNum(seat,v.cardNum)

		--显示地主身份
		if v.bIsLandlord == 1 then
			gameScene.SRDDZ_PlayerMgr:showPlayerLandlordIdentity(seat)
		end

		--玩家出过牌
		if v.state ~= 4 then
			if not v.handoutCards or #v.handoutCards == 0 then  --上次出了 不出
				gameScene.SRDDZ_PlayerMgr:ShowPlayerChuPaiUI(seat,{})
			else  										    --上次出了 牌
				gameScene.SRDDZ_PlayerMgr:ShowPlayerChuPaiUI(seat,v.handoutCards)
			end
		end

		--玩家正在托管状态
		if v.state == 3 then
			gameScene.SRDDZ_PlayerMgr:setPlayerTuoGuanState(seat,true)
		end
	end

	--如果轮到自己出牌
	if curPlayerSeatID == 1 then
		--清理上次出的牌
		gameScene.SRDDZ_PlayerMgr:ShowPlayerChuPaiUI(curPlayerSeatID)

		--如果没有在托管状态
		gameScene.SRDDZ_PlayerMgr:showPlayerChuPaiState(msg.curCard)
	end
end

--[[
	* 开启托管
	* @param table msg  消息数据
--]]
function srddzMsg.TuoGuan(msg)
	msg.seatid = SRDDZ_Util.convertSeatToPlayer(msg.seatid)

	gameScene.SRDDZ_PlayerMgr:setPlayerTuoGuanState(msg.seatid,true)
end

--[[
	* 取消托管
	* @param table msg  消息数据
--]]
function srddzMsg.CancelTuoGuanRep(msg)
	msg.seatid = SRDDZ_Util.convertSeatToPlayer(msg.seatid)
	msg.curPlayer = SRDDZ_Util.convertSeatToPlayer(msg.curPlayer)

	local isTuoGuan = gameScene.SRDDZ_PlayerMgr:getPlayerInfoWithSeatID(msg.seatid).mIsTuoGuan

	if isTuoGuan then
		gameScene.SRDDZ_PlayerMgr:setPlayerTuoGuanState(msg.seatid,false)

		gameScene.SRDDZ_PlayerMgr:showPlayerTimer(msg.seatid,msg.timeRelease)
	end

	if msg.curPlayer == 1 and msg.seatid == 1 then
		gameScene.SRDDZ_PlayerMgr:showPlayerChuPaiState(msg.curCard)
	end
end

-- ------------------------------ 框架消息 回复------------------------------
--[[
	* 初始化游戏
	* @param table msg  消息数据
--]]
function roomMsg.InitGameScenes(msg)
	print("初始化游戏场景")

	SRDDZ_Util.seatIndex = msg.seat
	SRDDZ_Util.session = msg.session
    session = msg.session

    if msg.watching then
       gameScene.SRDDZ_uiOperates:setReadyBtnState(false)
    end
end

--[[
	* 有玩家进入桌子
	* @param table msg  消息数据
--]]
function roomMsg.EnterGame(msg)
	msg.seat = SRDDZ_Util.convertSeatToPlayer(msg.seat)

	print("椅子号: " .. msg.seat .. " 的玩家进入")

	--玩家坐下
	local playerInfo = gameScene.SRDDZ_PlayerMgr:playerSeatDown(msg)

	local viptype = 0
    if msg.player.viptype ~= nil then 
        viptype = msg.player.viptype
    end

	--显示玩家UI信息
	gameScene.SRDDZ_uiPlayerInfos:showPlayerInfoUI(msg.seat, playerInfo, viptype)
end

--[[
	* 有玩家离开桌子
	* @param table msg  消息数据
--]]
function roomMsg.LeaveGame(msg)
	msg.seat = SRDDZ_Util.convertSeatToPlayer(msg.seat)
	print("椅子号: " .. msg.seat .. " 的玩家离开")
	gameScene.SRDDZ_PlayerMgr:playerLeave(msg.seat)
end

--[[
	* 准备请求的个人回复
	* @param table msg  消息数据
--]]
function roomMsg.ReadyRep(msg)
end

--[[
	* 有玩家准备游戏
	* @param table msg  消息数据
--]]
function roomMsg.Ready(msg)
	msg.seat = SRDDZ_Util.convertSeatToPlayer(msg.seat)
	print("椅子号: " .. msg.seat .. " 的玩家已准备游戏")
	gameScene.SRDDZ_PlayerMgr:playerReady(msg.seat,true)

	if msg.seat == 1 then
		gameScene.SRDDZ_uiTableInfos:showWaitState(true)
		if gameScene.SRDDZ_uiResults:isVisible() then
			gameScene.SRDDZ_PlayerMgr:clearAllPlayerCards(true)
			gameScene.SRDDZ_uiResults:showGameResult(false)
		end

		gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_READY)
	end
end


function SRDDZ_MsgMgr:dispatchMessage(name,msg)
	if msg then
        dump(msg, name)
    else
        print("error: 调用 SRDDZ_MsgMgr:dispatchMessage 方法时 参数msg ~= true  name = " .. name)
    end

	if gameScene == nil then
		print("error: 调用 SRDDZ_MsgMgr:dispatchMessage 方法时 gameScene == nil")
		return 
	end

	local clsName, funcName = name:match "([^.]*).(.*)"

	assert(handlers[clsName], "error: 调用 SRDDZ_MsgMgr:dispatchMessage 方法时 handlers[clsName] ~= true")
	if handlers[clsName] then
		assert(handlers[clsName], "error: 调用 SRDDZ_MsgMgr:dispatchMessage 方法时 handlers[clsName][funcName] ~= true")

		--如果是游戏消息则校验数据
		if clsName == "SRDDZ" then
			if session == msg.session then
				handlers[clsName][funcName](msg)
			end
		else
			handlers[clsName][funcName](msg)
		end

	end
end

return SRDDZ_MsgMgr