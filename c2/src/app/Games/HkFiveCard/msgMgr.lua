local message = require("app.net.Message")
local msgWorker = require("app.net.MsgWorker")

local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")
local util = require("app.Games.HkFiveCard.util")

local scheduler = vars.scheduler
local TIME_GAP = consts.TIME_GAP

local _toSubSeatId = util.toSubSeatId
local _suitAndNumber = util.suitAndNumber

-- init on InitGameScenes
local _session = nil

-- NOTE: initialize belows in init()
local scene = nil
local uiSettings = nil
local uiTableInfos = nil
local uiOperates = nil
local uiResults = nil
local uiPlayerInfos = nil
local playerMgr = nil
local cardMgr = nil
local jettonMgr = nil

local msgMgr = {}
local roomMsg = {} -- client room manage this message type
local gameMsg = {}
local hkfcMsg = {}

local handlers = {game=gameMsg, room=roomMsg, HkFiveCard=hkfcMsg}


function msgMgr:init(tableScene)
	scene = tableScene

	uiSettings = require("app.Games.HkFiveCard.uiSettings")
	uiTableInfos = require("app.Games.HkFiveCard.uiTableInfos")
	uiOperates = require("app.Games.HkFiveCard.uiOperates")
	uiResults = require("app.Games.HkFiveCard.uiResults")
	uiPlayerInfos = require("app.Games.HkFiveCard.uiPlayerInfos")

	playerMgr = require("app.Games.HkFiveCard.playerMgr")
	cardMgr = require("app.Games.HkFiveCard.cardMgr")
	jettonMgr = require("app.Games.HkFiveCard.jettonMgr")
end

function msgMgr:clear()
	
end

-- ------------------------------ room msg ------------------------------
function roomMsg.InitGameScenes(msg)
	-- dump(msg)
	util.setMyServerSeat(msg.seat)
	_session = msg.session
	vars.watching = msg.watching
end

function roomMsg.EnterGame(msg)

	print("HKFIVE-roomMsg.EnterGame")
	dump(msg)
	local seatId = _toSubSeatId(msg.seat)
	local player = msg.player
--modify by whb 161031
    --viptype
    local viptype = 0
    if player.viptype ~= nil then
    	viptype = player.viptype
    end
    print("roomMsg.EnterGame-viptype:" .. viptype)

    print("roomMsg.EnterGame-imageid:" .. player.imageid)

	playerMgr:playerSeatDown(seatId, player.name, checkint(player.gold), viptype, player.sex, player.imageid)
--modigy end
	if not vars.watching then -- if onlooker receive this msg, game already started.
		playerMgr:playerReady(seatId, player.ready~=0)
	end
end

function roomMsg.StartGame(msg)
	-- dump(msg)
end

function roomMsg.LeaveGame(msg)
	-- dump(msg)
	print("roomMsg.LeaveGame:" .. msg.seat)
	local seatId = _toSubSeatId(msg.seat)

	if scene and seatId == 1 and not vars.watching then
		--TODO: kick out, may gold not enough, need pop info
		--TODO: need a new kick out protocol, or leave reason
		-- msgMgr:sendExitTable()
		return
	end

	playerMgr:playerLeave(seatId)
end

function roomMsg.ReadyRep(msg) -- personally
	-- dump(msg)
	print("room msg: ready response...", msg.result)
	if msg.result ~= 0 then
		-- dump(msg)
		print("ready failed!!!")
		return
	end
	-- playerMgr:playerReady(1, true) -- room.ready will send yet
end

function roomMsg.Ready(msg) -- boardcast
	printf("room msg: seat_%d ready !", msg.seat)
	local seatId = _toSubSeatId(msg.seat)
	playerMgr:playerReady(seatId, true)
end


-- ------------------------------ HkFiveCard msg ------------------------------
function hkfcMsg.UpdateGameInfo(msg)
	-- dump(msg)
	vars.max_chip = msg.params1[1]
	vars.base_chip = msg.params1[2]
	vars.op_time_cd = msg.params1[3]
	vars.tax_rate = msg.params1[4]/100.0
	vars.room_gold = msg.params1[5]
end

function hkfcMsg.SyncGameData(msg)
	--HACK: do not print this, crashed when client reconnected.
	-- dump(msg, "sync data") 
	
	vars.game_status = (msg.status == 1)
	vars.raise_options = msg.odds

	local opseat = _toSubSeatId(msg.opseat)
	print("opseat:", opseat)
	local pool_jettons = 0
	for _, v in pairs(msg.players) do
		local seat = _toSubSeatId(v.seatid)
		local p = vars.players[seat]
		assert(p, "seat:"..tostring(seat).." player is nil.")
		p.ingame = (v.ingame == 1)
		p.giveup = (v.giveup == 1)
		p.showhand = (v.showhand == 1)
		p.prechip = v.prechip
		p.curchip = v.curchip
		p.cards = v.cards
		pool_jettons = pool_jettons + v.prechip
		for _, card in pairs(v.cards) do
			cardMgr:setPlayerCard(seat, _suitAndNumber(card))
		end
		jettonMgr:setJettonPile(seat, v.curchip)
		playerMgr:playerReady(seat, false)
		playerMgr:playerActive(seat, opseat == seat, msg.optime)
		uiPlayerInfos:updateChip(seat)
	end
	jettonMgr:setJettonPool(pool_jettons)

	if opseat == 1 and not vars.watching and vars.players[1].ingame then
		uiOperates:showOpPanel(true, msg.oplist)
	end

	if vars.game_status then 
		uiOperates:showReadyBtn(false)
	end

	uiTableInfos:update()
end

function hkfcMsg.OperateRep(msg)
	-- dump(msg)

	-- show previous player action
	local seatId = _toSubSeatId(msg.seatid)
	local player = vars.players[seatId]
	assert(player)

	local incVal = msg.curchip - player.curchip 
	playerMgr:dispatchPlayAction(seatId, msg.optype, incVal)
	-- update player info
	player:raiseTo(msg.curchip)
	print("OperateRep curchip:" .. tostring(msg.curchip))
	vars.last_chip = msg.curchip

	-- change active player, if game not over.
	local opseat = 0
	if msg.askseatid and msg.askseatid ~= 0 then
		opseat = _toSubSeatId(msg.askseatid)
	end
	for i, v in pairs(vars.players) do
		playerMgr:playerActive(i, opseat == i)
	end
	if opseat == 1 and not vars.watching and vars.players[1].ingame then
		uiOperates:showOpPanel(true, msg.oplist)
	end

	uiTableInfos:update()
end

function hkfcMsg.AddCard(msg)
	-- dump(msg)
	
	-- set delay info
	local delay = 0

	-- reset info
	vars.last_chip = 0
	uiOperates:showOpPanel(false)

	if msg.index == 1 then -- fist round
		print("first round!!!", msg.cardid)
		cardMgr:clearAllCards()
		uiResults:showGameResult(false)
		scene:onGameStart()
		vars.game_status = true
		vars.raise_options = msg.odds
		for k, v in pairs(msg.cardids) do -- send the first card
			local seatId = _toSubSeatId(k)
			if v ~= 0 then
				-- printf("seatId:%d vars.base_chip:%d", seatId, vars.base_chip)
				playerMgr:playerReady(seatId, false)
				jettonMgr:throwBaseJetton(seatId, vars.base_chip) -- play animation
				local player = vars.players[seatId]
				player.prechip = vars.base_chip
				player.ingame = true
				uiPlayerInfos:updateChip(seatId)
				if seatId == 1 then
					table.insert(player.cards, msg.cardid)
					player.private_card = msg.cardid
				else
					table.insert(player.cards, 0)
				end
				-- printf("delay send seat:%d card.", seatId)
				scheduler.performWithDelay(function()
					cardMgr:sendCard2Player(seatId, _suitAndNumber(player.cards[1]))
				end, delay)
				delay = delay + TIME_GAP.SEND_CARD
			else
				vars.players[seatId] = nil
			end
		end
		uiTableInfos:update()
	else
		scheduler.performWithDelay(function()
			jettonMgr:jettonPiles2Pool()
		end, TIME_GAP.PUSH_JETTON+0.1) -- after the last player jetton pushed.
		-- before send card, collect jettons to pool
		delay = delay + TIME_GAP.PUSH_JETTON+TIME_GAP.JETS_TO_POOL+0.1
	end

	for k, v in pairs(msg.cardids) do -- send the all visible card
		local seat = _toSubSeatId(k)
		if v ~= 0 then
			local player = vars.players[seat]
			player:newRound()
			table.insert(player.cards, v)
			scheduler.performWithDelay(function()
				cardMgr:sendCard2Player(seat, _suitAndNumber(v))
			end, delay)
			delay = delay + TIME_GAP.SEND_CARD
		end
		playerMgr:playerActive(seat, msg.askseatid == k)
	end

	if _toSubSeatId(msg.askseatid) == 1 and not vars.watching and vars.players[1].ingame then
		scheduler.performWithDelay(function()
			uiOperates:showOpPanel(true, nil)
		end, delay)
	end

	msgWorker.sleep(delay)
end

function hkfcMsg.ShowCard(msg)
	-- dump(msg)
	uiOperates:showOpPanel(false)
	local seatId = _toSubSeatId(msg.seatid)
	cardMgr:showPrivateCard(seatId, _suitAndNumber(msg.cardids[1]))
end

function hkfcMsg.SetCards(msg)
	-- dump(msg) -- for test, maybe
end

function hkfcMsg.ReconnectRep(msg)
	-- dump(msg) --TODO: ...
end

function hkfcMsg.TalkNtf(msg)
	-- dump(msg) -- for players talking, maybe
end

function hkfcMsg.SettleAccount(msg)
	-- dump(msg)

	-- unnecessary, but force fixed.
	uiOperates:showOpPanel(false)

	local win_seat = _toSubSeatId(msg.winseatid)
	
	local delay = TIME_GAP.PUSH_JETTON + 0.1 -- + sendDelay
	scheduler.performWithDelay(function()
		jettonMgr:jettonPiles2Pool()
	end, delay)

	delay = delay + TIME_GAP.JETS_TO_POOL*2
	scheduler.performWithDelay(function()
		jettonMgr:poolJettons2Player(win_seat)
	end, delay)

	-- set game result layer data
	for k, v in pairs(msg.goldchanges) do
		local seat = _toSubSeatId(k)
		local player = vars.players[seat]
		if player and player.ingame then
			player:setScore(v, vars.tax_rate)
			uiPlayerInfos:showSeatInfo(seat, true)
		end
	end	
	for k, v in pairs(msg.cardtypes) do
		local seat = _toSubSeatId(k)
		local player = vars.players[seat]
		if player and player.ingame then
			player.card_type = app.lang.card_types[v]
			cardMgr:showPlayerCardType(seat, v)
		end
	end
	uiResults:showGameResult(true, win_seat)
	scene:onGameEnd()

	local player = vars.players[1]
	-- reshow ready button
	if not vars.watching and player then --and player.gold >= vars.room_gold then
		delay = delay + TIME_GAP.POOL_TO_PLAYER
		scheduler.performWithDelay(function()
			uiOperates:showReadyBtn(true)
		end, delay)
	end
	-- reset data for game restart
	vars.game_status = false
	for _, v in pairs(vars.players) do
		if v then v:reset() end
	end

	msgWorker.sleep(delay)
end


-- ------------------------------ msg manager ------------------------------
function msgMgr:sendMsg(name, msg)
	msg.session = _session
	message.sendMessage(name, msg)
end

function msgMgr:sendLeaveGame()
	message.dispatchGame("room.LeaveGame")
	scene = nil
end

function msgMgr:sendExitTable()
	message.dispatchGame("room.ExitTable")
	scene = nil
end

function msgMgr:sendReadyRequest()
	message.dispatchGame("room.ReadyReq")
end

function msgMgr:sendOpReq(msg)
	self:sendMsg("HkFiveCard.OperateReq", msg)
end

function msgMgr:dispatch(name, msg)
	if scene == nil then
		print("this msgMgr's scene is nil !!!")
		return
	end

	local clsName, funcName = name:match "([^.]*).(.*)"
	-- printf("msg %s got %s:%s", name, clsName, funcName)
	-- dump(msg)
	assert(handlers[clsName], clsName .. " handler not exist!")
	if handlers[clsName] then
		-- dump(handlers[clsName])
		assert(handlers[clsName][funcName], clsName.."Mgr have no func: "..funcName)
		handlers[clsName][funcName](msg)
		--NOTE: sometims have no stack traceback infomations
		-- xpcall(handlers[clsName][funcName], debug.traceback, msg) 
	end
end

return msgMgr