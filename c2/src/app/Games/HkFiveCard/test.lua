local util = require("app.Games.HkFiveCard.util")

local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local playerMgr = require("app.Games.HkFiveCard.playerMgr")
local cardMgr = require("app.Games.HkFiveCard.cardMgr")
local jettonMgr = require("app.Games.HkFiveCard.jettonMgr")

local uiPlayerInfos = require("app.Games.HkFiveCard.uiPlayerInfos")
local uiOperates = require("app.Games.HkFiveCard.uiOperates")

local PATH = consts.PATH
local TIME_GAP = consts.TIME_GAP

local scene = nil
local test = {}

function test:init(tableScene)
	scene = tableScene
end

local function drawPoolRange()
	print("display:", display.width, display.height)
	local pool_x, pool_y = util.poolPos()
	print("pool_x y:", pool_x, pool_y)
	local pool_w, pool_h = util.poolWH()
	print("pool_w h:", pool_w, pool_h)
	local ui_pool = display.newScale9Sprite(PATH.IMG_DEFAULT, pool_x, pool_y, cc.size(pool_w, pool_h))
	ui_pool:setOpacity(50)
	ui_pool:setAnchorPoint(0.0,0.0)
	scene.root:addChild(ui_pool)
end

function test:common()
	print("common test.")

	for i = 1, consts.MAX_PLAYER_NUM do
		uiPlayerInfos.ui_infos[i].ui_body:setVisible(true)
	end

	drawPoolRange()


	local function testShowPlayerReady()
		for i = 1, consts.MAX_PLAYER_NUM do
			playerMgr:playerReady(i, true)
			scheduler.performWithDelay(function()
				playerMgr:playerReady(i, false)
			end, 3)
		end
	end
	testShowPlayerReady()


	local function testDispatchCards()
		local cnt = 0
		for k = 1, 5 do 
			for i = 1, consts.MAX_PLAYER_NUM do 
				scheduler.performWithDelay(function()
					cardMgr:sendCard2Player(i, math.random(1,4), math.random(1,13))
				end, TIME_GAP.SEND_CARD*cnt)
				cnt = cnt + 1
			end
		end
		scheduler.performWithDelay(function()
			cardMgr:turnBackAllCard(1)
		end, 8)
	end
	testDispatchCards()


	local function testMoveJetton()
		assert(jettonMgr, "jettonMgr is nil")
		for i = 1, consts.MAX_PLAYER_NUM do
			jettonMgr:throwBaseJetton(i, 1004)
		end
		-- scene:pushJettonPile(5, 123456)
		for i = 1, consts.MAX_PLAYER_NUM do
			scheduler.performWithDelay(function()
				jettonMgr:pushJettonPile(i, 123456*i)
			end, i*0.2)
		end
		scheduler.performWithDelay(function()
			jettonMgr:jettonPiles2Pool()
		end, 2.5)
		scheduler.performWithDelay(function()
			jettonMgr:poolJettons2Player(1)
		end, 3)
	end
	testMoveJetton()
	scheduler.schedule(function(dt)
		testMoveJetton()
	end, 5)


	local function testShowCardType()
		for i = 1, consts.MAX_PLAYER_NUM do
			cardMgr:showPlayerCardType(i, i)
			scheduler.performWithDelay(function()
				cardMgr:showPlayerCardType(i, nil)
			end, 3)
		end
	end
	scheduler.performWithDelay(function()
		testShowCardType()
	end, 8)


	local function testSwitchPlayer()
		local pre_seat = 1
		playerMgr:playerActive(pre_seat, true)
		scheduler.schedule(function(dt)
			local cur_seat = util.nextSeat(pre_seat)
			playerMgr:playerActive(pre_seat, false)
			playerMgr:playerActive(cur_seat, true)
			playerMgr:playerReady(pre_seat, false)
			playerMgr:playerReady(cur_seat, true)
			playerMgr:playerRaise(cur_seat, 100)
			playerMgr:showPlayerTimer(cur_seat, 5)
			pre_seat = cur_seat
		end, 0.5)
	end
	testSwitchPlayer()


	--TEST waiting words show ...
	scene:showWaiting(true)
	-- scheduler.performWithDelay(function()
	-- 	scene:waiting(false)
	-- end, 3.5)


	--TEST player action pop 
	playerMgr:showPlayerActionPop(1)
end


-- ------------------------------ process simulate -----------------------------------
function isAllPlayerPushJettons()
	local cnt = 0
	for i = 1, consts.MAX_PLAYER_NUM do
		-- printf("collect seat:%d", i)
		if #uiPlayerInfos.ui_infos[i].ui_jettons > 0 then
			cnt = cnt + 1
		end
	end
	return uiPlayerInfos:visibleCnt() == cnt
end


local state = "wait"
local GAME = {}

local is_all_ready = false
function GAME.wait()
	-- print("game waiting... ")
	if not is_all_ready then -- check players all ready
		if uiPlayerInfos:visibleCnt() < 2 then
			-- print("player not enough")
			return
		end
		local cnt = 0 -- valid ready player
		for i = 1, consts.MAX_PLAYER_NUM do
			if uiPlayerInfos.ui_infos[i].img_ready then
				cnt = cnt + 1
			end
		end
		if cnt < 2 or cnt ~= uiPlayerInfos:visibleCnt() then
			-- print("not all on table player ready yet... ")
			return
		end
		is_all_ready = true
		state = "start"
		for i = 1, consts.MAX_PLAYER_NUM do 
			playerMgr:playerReady(i, false)
		end
	end
end

function GAME.start()
	-- print("game start.")
	for i = 1, consts.MAX_PLAYER_NUM do
		if uiPlayerInfos:visible(i) then
			jettonMgr:throwBaseJetton(i, 1004)
		end
	end
	local cnt = 0
	for k = 1, 2 do -- send 2 cards
		for i = 1, consts.MAX_PLAYER_NUM do 
			if uiPlayerInfos:visible(i) then
				scheduler.performWithDelay(function()
					cardMgr:sendCard2Player(i, math.random(1,4), math.random(1,13))
				end, TIME_GAP.SEND_CARD*cnt)
				cnt = cnt + 1
			end
		end
	end
	state = "process"
end

local pre_seat = nil
local cur_seat = 1
local player_op_done = true
function GAME.process()
	-- print("game processing...", pre_seat, cur_seat)
	if not player_op_done then
		-- print("waiting for player opreating...", cur_seat)
		return 
	end

	-- check if all palyer jetton on table
	if isAllPlayerPushJettons() then
		-- do not move piles to pool immediately
		scheduler.performWithDelay(function()
			jettonMgr:jettonPiles2Pool()
		end, 2)
	end

	if pre_seat then
		-- print("active pre_seat:", pre_seat)
		playerMgr:playerActive(pre_seat, false)
	end
		-- print("active cur_seat:", cur_seat)
	playerMgr:playerActive(cur_seat, true)
	if cur_seat == 1 then 
		state = "tester"
		return
	end
	player_op_done = false
	scheduler.performWithDelay(function()
		--TODO: ... player do something...
		playerMgr:playerRaise(cur_seat, 66666)
		pre_seat = cur_seat
		cur_seat = nextValidPlayer(cur_seat)
		player_op_done = true
	end, math.random(1,2.5))
end

function GAME.tester()
	-- tester doing...
end

function nextValidPlayer(cur_seat)
	local next_seat = cur_seat
	for i = 1, consts.MAX_PLAYER_NUM do
		next_seat = util.nextSeat(next_seat)
		if uiPlayerInfos:visible(next_seat) then
			break
		end
	end
	return next_seat
end

-- ------------------------------ msg alfter clicked -----------------------------------
function test:sendMsg(cmd, ...)
	local CMD = {}

	function CMD.ready()
		playerMgr:playerReady(1, true)
	end

	function CMD.raise(val)
		print("cmd raise:", val)
		playerMgr:playerRaise(1, val)
	end

	function CMD.norase()
		playerMgr:playerNoRaise(1)
	end

	function CMD.follow(val)
		playerMgr:playerFollow(1, val)
	end

	function CMD.showhand(val)
		playerMgr:playerShowhand(1, val)
	end

	function CMD.giveup()
		playerMgr:playerGiveup(1)
		jettonMgr:poolJettons2Player(1)
	end

	CMD[cmd](...)

	if cmd ~= "ready" then
		state = "process"
		pre_seat = 1
		cur_seat = nextValidPlayer(pre_seat)
		player_op_done = true
	end
end

function test:process()
	print("process test.")

	-- drawPoolRange()

	-- act by server msg below
	playerMgr:playerSeatDown(1) -- you are first player
	scheduler.performWithDelay(function() -- other players seat down
		for i = 2, consts.MAX_PLAYER_NUM do
			-- if i == 5 then 
				playerMgr:playerSeatDown(i)
				scheduler.performWithDelay(function()
					playerMgr:playerReady(i, true)
				end, i*0.5)
			-- end
		end
	end, 2)

	scheduler.schedule(function()
		GAME[state]()
	end, 0.5)

end


return test