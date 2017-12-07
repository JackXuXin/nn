local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local PlayerInfo = require("app.Games.HkFiveCard.PlayerInfo")
local util = require("app.Games.HkFiveCard.util")

local uiPlayerInfos = require("app.Games.HkFiveCard.uiPlayerInfos")
local uiOperates = require("app.Games.HkFiveCard.uiOperates")

local cardMgr = require("app.Games.HkFiveCard.cardMgr")
local jettonMgr = require("app.Games.HkFiveCard.jettonMgr")

local scheduler = vars.scheduler
local PATH = consts.PATH

-- timer count down
local TIME_CD_PLAYER_OP = 30
local TIME_CD_OP_WARN = 5

-- index of op font frame
local OP_FONT_IDX_NO_RAISE = 1
local OP_FONT_IDX_FOLLOW = 2
local OP_FONT_IDX_RAISE = 3
local OP_FONT_IDX_SHOWHAND = 4
local OP_FONT_IDX_GIVEUP = 5

-- key:val as seatId:pop_frames_idx
local OP_POP_IDX_MAP = {3,5,2,4,1} 

-- image adjust
local OP_POP_OFFSET = {
	--{-75/2,52*2}, {-75*1.2,52*5}, {75*3.8,52/1.5}, {-75/1.6,52/1.5}, {75*1.2,52/1.6}
	{210,115}, {-70,175}, {-70,175}, {215,175}, {215,175}
}
local TIMER_OFFSET = {
--	{-20*1.7,30*1.25}, {-20*2.5,30*8.5}, {20*12.5,30}, {-20*1.7,30}, {20*1.25,30*0.75}
--	{213,97}, {99,160}, {98,160}, {98,160}, {98,160}
	{118,60}, {58,93}, {58,93}, {58,93}, {58,93}
}
local IMG_READY_OFFSET = {
	{-57/2,74}, {-74-57/2,-31/2}, {229+57/2,-15}, {-31,-15}, {74+57/2,31/2}	
}


local scene = nil
local playerMgr = {}

function playerMgr:init(tableScene)
	scene = tableScene
	self.ticker_handles = {}
	self.progress = {}

	display.addSpriteFrames("Image/HkFiveCard/gameui/LieHuo/LieHuo.plist","Image/HkFiveCard/gameui/LieHuo/LieHuo.pvr.ccz")

	return self
end

function playerMgr:clear()
	display.removeSpriteFramesWithFile("Image/HkFiveCard/gameui/LieHuo/LieHuo.plist","Image/HkFiveCard/gameui/LieHuo/LieHuo.pvr.ccz")
end

-- ------------------------------ on player action ------------------------------
function playerMgr:playerSeatDown(seatId, name, gold, viptype, sex, imageid)
	name = name or "unnamed"
	gold = gold or -1

	print("playerSeatDown-viptype:" .. viptype)
	vars.players[seatId] = PlayerInfo:new(name, gold, viptype, sex, imageid)

	uiPlayerInfos:showSeatInfo(seatId, true)

	if seatId == 1 then
		if not vars.watching then
			uiOperates:showReadyBtn(true)
			if uiPlayerInfos:visibleCnt() == 1 then
				scene:showWaiting(true)
			end
		end
	else -- not self seat down
		scene:showWaiting(false)
	end
end

function playerMgr:playerReady(seatId, flag)
	print("ready player:", seatId, flag)
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	-- remove the older image
	-- if user_ui_info.img_ready then
	-- 	-- user_ui_info.img_ready:setVisible(false)

	-- 	user_ui_info.img_ready:removeFromParent()
	-- 	user_ui_info.img_ready = nil
	-- end

	-- if flag then
	-- 	local x, y = user_ui_info.ui_body:getPosition()
	-- 	local img_ready = display.newSprite(PATH.IMG_READY)
	-- 	img_ready:setPosition(x+IMG_READY_OFFSET[seatId][1], y+IMG_READY_OFFSET[seatId][2])
	-- 	user_ui_info.img_ready = img_ready
	-- 	-- scene:addChild(img_ready)
	-- 	scene.root:addChild(img_ready)
	-- 	if seatId == 1 then
	-- 		uiOperates:showReadyBtn(false)
	-- 	end
	-- end
	
	if flag then
		cc.uiloader:seekNodeByNameFast(user_ui_info.ui_body, "ready"):setVisible(true)

		if seatId == 1 then
			uiOperates:showReadyBtn(false)
		end
	else
		cc.uiloader:seekNodeByNameFast(user_ui_info.ui_body, "ready"):setVisible(false)
	end
end

function playerMgr:playerActive(seatId, flag, timeLeft)
	-- print("active seatId:", seatId)
	-- indicate player operating...
	uiPlayerInfos.ui_infos[seatId].img_user_playing:setVisible(flag)
	-- set timer and show timer tick ...
	if flag then
		self:showPlayerTimer(seatId, timeLeft or vars.op_time_cd)
	else
		self:showPlayerTimer(seatId, 0)
	end
end

-- ------------------------------ play action ------------------------------
function playerMgr:playerRaise(seatId, val)
	-- print("on player raise")

	util.playSound(PATH.WAV_RAISE_SCORE)
	self:showPlayerActionPop(seatId, OP_FONT_IDX_RAISE)
	jettonMgr:pushJettonPile(seatId, val)

	if seatId == 1 then
		uiOperates:showOpPanel(false)
	end
end

function playerMgr:playerFollow(seatId, val)
	-- print("on player follow")

	util.playSound(PATH.WAV_FOLLOW)
	self:showPlayerActionPop(seatId, OP_FONT_IDX_FOLLOW)
	jettonMgr:pushJettonPile(seatId, val)

	if seatId == 1 then
		uiOperates:showOpPanel(false)
	end
end

function playerMgr:playerGiveup(seatId)
	print("on player giveup seatId:", seatId)

	util.playSound(PATH.WAV_GIVE_UP)
	self:showPlayerActionPop(seatId, OP_FONT_IDX_GIVEUP)
	cardMgr:turnBackAllCard(seatId)

	if seatId == 1 then
		uiOperates:showOpPanel(false)
	end
	print("on player giveup done seatId:", seatId)
end

function playerMgr:playerNoRaise(seatId)
	-- print("on player no raise")

	util.playSound(PATH.WAV_NO_RAISE)
	self:showPlayerActionPop(seatId, OP_FONT_IDX_NO_RAISE)

	if seatId == 1 then
		uiOperates:showOpPanel(false)
	end
end

function playerMgr:playerShowhand(seatId, val)
	-- print("on player showhand")

	util.playSound(PATH.WAV_SHOW_HAND)
	self:showPlayerActionPop(seatId, OP_FONT_IDX_SHOWHAND)
	jettonMgr:pushJettonPile(seatId, val)

	local BaoZha = display.newSprite("Image/HkFiveCard/gameui/tksj_001.png",display.cx, display.cy)
	scene.root:addChild(BaoZha)

	local animation = cc.Animation:create()
	for i=2,5 do
		local sprite = display.newSprite("Image/HkFiveCard/gameui/tksj_00" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.1)
	local action = cc.Animate:create(animation)
	BaoZha:runAction(cc.Sequence:create(action,cc.CallFunc:create(function () 
		BaoZha:removeFromParent()
		end)))

	-- show words in the center of table
	local img_showhand = display.newSprite(PATH.IMG_SHOW_HAND, display.cx, display.cy)
	scene.root:addChild(img_showhand)
	scheduler.performWithDelay(function()
		img_showhand:removeFromParent()
	end, 1.5)
	if seatId == 1 then
		uiOperates:showOpPanel(false)
	end
end

-- 1:加注 2:跟注 3:弃牌 4:过牌 5:showhand
local _op_func_name = {'playerRaise', 'playerFollow', 'playerGiveup', 'playerNoRaise', 'playerShowhand'}
function playerMgr:dispatchPlayAction(seatId, opType, opVal)
	local f = assert(playerMgr[_op_func_name[opType]], "opType:"..opType.." invalid!")
	printf("seatId:%d %s %d", seatId, _op_func_name[opType], opVal)
	f(self, seatId, opVal)
end

-- ------------------------------ others ------------------------------
function playerMgr:playerLeave(seatId)
	print("player leave game seatId:", seatId)
	if seatId == 1 then
		print("yourself!")
		return
	end
	if not vars.game_status or not vars.players[seatId].ingame then
		uiPlayerInfos.ui_infos[seatId].ui_body:setVisible(false)
		vars.players[seatId] = nil --TODO: may just set it leave/not in game, don't set to nil
		if uiPlayerInfos:visibleCnt() == 1 then
			scene:showWaiting(true)
		end
	else
		--TODO: ...
	end
end

--NOTE: action pop is attached on ui_body, so it visible as ui_body visibility
function playerMgr:showPlayerActionPop(seatId, actionIdx)
	-- print("show player action pop")
	local ui_body = uiPlayerInfos.ui_infos[seatId].ui_body
	local body_x = ui_body:getPositionX()
	local body_y = ui_body:getPositionY()

	local resIndex = 0
	if seatId ~= 2 and seatId ~= 3 then  -- 135
		if actionIdx == 4  then  --梭哈
			resIndex = 5
		elseif actionIdx == 5 then --弃牌
			resIndex = 3
		else  	-- 不加 跟注 加注
			resIndex = 1
		end
	else  -- 246
		if actionIdx == 4  then  --梭哈
			resIndex = 6
		elseif actionIdx == 5 then --弃牌
			resIndex = 4
		else  	-- 不加 跟注 加注
			resIndex = 2
		end
	end

	local action_pop = display.newSprite(util.action_bg_frames[resIndex])
	local pop_width = action_pop:getCascadeBoundingBox().size.width
	local pop_height = action_pop:getCascadeBoundingBox().size.height

	action_pop:setPosition(body_x+OP_POP_OFFSET[seatId][1], body_y+OP_POP_OFFSET[seatId][2])
	-- add font to pop
	local action_font = display.newSprite(util.action_font_frames[actionIdx])
	if seatId ~= 2 and seatId ~= 3 then  -- 135
		action_font:setPosition(pop_width/2.0*1.15, pop_height/2.0*1.15)
	else
		action_font:setPosition(pop_width/2.0*0.85, pop_height/2.0*1.15)
	end
	action_pop:addChild(action_font)
	-- show seconds then removed 
	scene.root:addChild(action_pop)
	scheduler.performWithDelay(function()
		action_pop:removeFromParent()
	end, 1.5)
	-- print("show player action done!!!!")
end

function playerMgr:showPlayerTimer(seatId, countDown)
	if vars.watching then
		return
	end

	if countDown == nil then
		countDown = TIME_CD_PLAYER_OP
	end
	if countDown > 99 then 
		countDown = 99
	end

	-- stop older timer
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	if self.ticker_handles[seatId] then
		scheduler.unschedule(self.ticker_handles[seatId])
		self.ticker_handles[seatId] = nil
		if user_ui_info.tick_number1 then
			user_ui_info.tick_number1:removeFromParent()
		end
		if user_ui_info.tick_number2 then
			user_ui_info.tick_number2:removeFromParent()
		end

	end

	if self.progress[seatId] then
		self.progress[seatId]:stopAllActions()
		self.progress[seatId]:removeFromParent()
		self.progress[seatId] = nil
	end

	-- stop warn sound
	-- if self.warn_sound_handle then
	-- 	audio.stopSound(self.warn_sound_handle)
	-- 	self.warn_sound_handle = nil
	-- end

	if countDown <= 0 then
		return
	end

	local ui_body = user_ui_info.ui_body
	local body_x = ui_body:getPositionX()
	local body_y = ui_body:getPositionY()
	local tick_number1 = display.newSprite(util.time_num_frames[math.floor(countDown/10)])
	local tick_number2 = display.newSprite(util.time_num_frames[countDown%10])
	local number_width = tick_number1:getCascadeBoundingBox().size.width
	local number_height = tick_number1:getCascadeBoundingBox().size.height

	tick_number1:setPosition(body_x+TIMER_OFFSET[seatId][1], body_y+TIMER_OFFSET[seatId][2])
	tick_number2:setPosition(tick_number1:getPositionX()+number_width, tick_number1:getPositionY())
	user_ui_info.tick_number1 = tick_number1
	user_ui_info.tick_number2 = tick_number2

	scene.root:addChild(tick_number1)
	scene.root:addChild(tick_number2)

	self.ticker_handles[seatId] = scheduler.schedule(function(dt)
		countDown = countDown - 1
		-- if not self.warn_sound_handle and countDown <= TIME_CD_OP_WARN then
		-- 	self.warn_sound_handle = util.playSound(PATH.WAV_GAME_WARN, true)
		-- end
		tick_number1:setSpriteFrame(util.time_num_frames[math.floor(countDown/10)])
		tick_number2:setSpriteFrame(util.time_num_frames[countDown%10])
		if countDown == 0 then 
			tick_number1:removeFromParent()
			tick_number2:removeFromParent()
			if self.ticker_handles[seatId] then
				scheduler.unschedule(self.ticker_handles[seatId])
				self.ticker_handles[seatId] = nil
			end
			
			-- if self.warn_sound_handle then
			-- 	audio.stopSound(self.warn_sound_handle)
			-- 	self.warn_sound_handle = nil
			-- end

			if self.progress[seatId] then
				self.progress[seatId]:stopAllActions()
				self.progress[seatId]:removeFromParent()
				self.progress[seatId] = nil
			end
		end 
	end, 1.0)

	if seatId == 1 then
		self.progress[seatId] = display.newProgressTimer("Image/HkFiveCard/gameui/wodaojishi.png",display.PROGRESS_TIMER_RADIAL)
	else
		self.progress[seatId] = display.newProgressTimer("Image/HkFiveCard/gameui/tadaojishi.png",display.PROGRESS_TIMER_RADIAL)
	end
	self.progress[seatId]:setPercentage(100)
	self.progress[seatId]:setScaleX(-1)
	self.progress[seatId]:setAnchorPoint(1,0)
	ui_body:addChild(self.progress[seatId])
	self.progress[seatId]:runAction(cca.progressTo(countDown,0))

	local frames = display.newFrames("LieHuo_%02d.png", 1, 16)
	local animation = display.newAnimation(frames, 0.1)
	local animate = cca.animate(animation)

	local LieHuo = display.newSprite("#LieHuo_01.png", self.progress[seatId]:getContentSize().width/2, self.progress[seatId]:getContentSize().height-5)
	LieHuo:addTo(self.progress[seatId])
	LieHuo:runAction(cca.repeatForever(animate))

	local sequenceMove = nil
	--长 宽 边长
	local width = self.progress[seatId]:getContentSize().width
	local height = self.progress[seatId]:getContentSize().height
	local length = width*2 + height*2
	--时间
	local time = countDown

	-- local moveBy_01 = cca.moveBy(time*(width/2/length) * 0.83, -(width/2)+5, 0)
	-- local moveBy_02 = cca.moveBy(time*(height/length) * 1.4, 0, -height+5)
	-- local moveBy_03 = cca.moveBy((time*(width/length)/2) * 0.75, (width-8)/2, 0)
	-- local moveBy_04 = cca.moveBy((time*(width/length)/2) * 0.85, (width-8)/2, 0)
	-- local moveBy_05 = cca.moveBy(time*(height/length) * 1.3, 0, height-5)
	-- local moveBy_06 = cca.moveBy(time*(width/2/length) * 0.9, -(width/2)+5, 0)

	if seatId == 1 then
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

return playerMgr