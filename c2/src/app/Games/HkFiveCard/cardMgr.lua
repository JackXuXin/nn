local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local util = require("app.Games.HkFiveCard.util")
local uiPlayerInfos = require("app.Games.HkFiveCard.uiPlayerInfos")

local scheduler = vars.scheduler
local TIME_GAP = consts.TIME_GAP
local PATH = consts.PATH


local PLAYER_CARD_OFFSET = {
	{50,180},{-230,120},{50,-90},{50,-90},{110,-100}
}
local CARD_TYPE_OFFSET = {
	{115,74*2.5}, {-74-100,115}, {115,-100}, {115,-100}, {74+100,-115}
}

local small_card_factor = 8/9.0
local CARD_ZOOM_FACTOR = {
	1, small_card_factor, small_card_factor, small_card_factor, small_card_factor
}


local scene = nil
local cardMgr = {}

function cardMgr:init(tableScene)
	scene = tableScene
	return self
end

function cardMgr:clear()
	
end

-- ------------------------------ action of card ------------------------------
function cardMgr:setFlipCard(ui_card, front_frame, back_frame)
	local is_card_front = false
	if self.flip_timer_handle then
		scheduler.unschedule(self.flip_timer_handle)
		self.flip_timer_handle = nil
	end
	ui_card:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		is_card_front = not is_card_front -- switched
		if is_card_front then
			ui_card:setSpriteFrame(front_frame)
			self.flip_timer_handle = scheduler.performWithDelay(function()
				ui_card:setSpriteFrame(back_frame)
				is_card_front = false
			end, 3) -- show the front of card just seconds.
		else
			ui_card:setSpriteFrame(back_frame)
			if self.flip_timer_handle then 
				scheduler.unschedule(self.flip_timer_handle)
				self.flip_timer_handle = nil
			end
		end
	end)
	ui_card:setTouchEnabled(true)
end

function cardMgr:sendCard2Player(seatId, suit, number)
	-- printf("send seat:%d card suit:%d number:%d", seatId, suit, number)
	util.playSound(PATH.WAV_SEND_CARD)
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	local body_x = user_ui_info.ui_body:getPositionX()
	local body_y = user_ui_info.ui_body:getPositionY()

	local front_frame = util.cardFrame(suit, number)
	local back_frame = util.cardBackFrame()
	local d_x, d_y = util.dealerPos()
	local ui_card = display.newSprite(back_frame, d_x, d_y)
	if seatId ~= 1 then
		ui_card:setScale(0.625) -- zoom card size
	end
--	ui_card:setScale(CARD_ZOOM_FACTOR[seatId]) -- zoom card size
	scene.root:addChild(ui_card)

	local card_num = #user_ui_info.ui_cards
	if seatId == 1 and card_num == 0 and not vars.watching then
		self:setFlipCard(ui_card, front_frame, back_frame)
	end
	user_ui_info.ui_cards[card_num+1] = ui_card

	local gap = 33*CARD_ZOOM_FACTOR[seatId]
	if seatId == 1 then
		gap = 50*CARD_ZOOM_FACTOR[seatId]
	end

	-- local dest_x = body_x + PLAYER_CARD_OFFSET[seatId][1]
	-- local dest_y = body_y + PLAYER_CARD_OFFSET[seatId][2]

	local cardPos = cc.p(cc.uiloader:seekNodeByNameFast(scene.root, "player_cardPos_" .. seatId):getPosition())

	-- ui_card:moveTo(TIME_GAP.CARD_FLY, dest_x+card_num*30, dest_y)
	local action = cc.Sequence:create(
	--	cc.MoveTo:create(TIME_GAP.CARD_FLY, cc.p(dest_x+card_num*gap, dest_y)), 

		cc.MoveTo:create(TIME_GAP.CARD_FLY, cc.p(cardPos.x+card_num*gap, cardPos.y)), 
		cc.CallFunc:create(function() 
			if card_num ~= 0 then
				-- show card suit and number
				ui_card:setSpriteFrame(front_frame)
			end
		end)
	)
    transition.execute(ui_card, action)
end

function cardMgr:setPlayerCard(seatId, suit, number)
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	local body_x = user_ui_info.ui_body:getPositionX()
	local body_y = user_ui_info.ui_body:getPositionY()

	local card_num = #user_ui_info.ui_cards
	local front_frame = util.cardFrame(suit, number)
	local back_frame = util.cardBackFrame()

	local gap = 33*CARD_ZOOM_FACTOR[seatId]
	if seatId == 1 then
		gap = 50*CARD_ZOOM_FACTOR[seatId]
	end

	-- local dest_x = body_x + PLAYER_CARD_OFFSET[seatId][1]
	-- local dest_y = body_y + PLAYER_CARD_OFFSET[seatId][2]

	local cardPos = cc.p(cc.uiloader:seekNodeByNameFast(scene.root, "player_cardPos_" .. seatId):getPosition())

--	local ui_card = display.newSprite(back_frame, dest_x+card_num*gap, dest_y)
	local ui_card = display.newSprite(back_frame, cardPos.x+card_num*gap, cardPos.y)
	if seatId ~= 1 then
		ui_card:setScale(0.625) -- zoom card size
	end
--	ui_card:setScale(CARD_ZOOM_FACTOR[seatId]) -- zoom card size
	scene.root:addChild(ui_card)

	if seatId == 1 and card_num == 0 and not vars.watching then
		self:setFlipCard(ui_card, front_frame, back_frame)
	end
	user_ui_info.ui_cards[card_num+1] = ui_card
	
	-- show card suit and number
	if card_num ~= 0 then
		ui_card:setSpriteFrame(front_frame)
	end
end

function cardMgr:showPlayerCardType(seatId, cardType)
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	if cardType == nil or cardType <= 0 then
		if user_ui_info.img_card_type then
			user_ui_info.img_card_type:removeFromParent()
			user_ui_info.img_card_type = nil
		end
		return
	end

--	local x, y = user_ui_info.ui_body:getPosition()

	local cardPos = cc.p(cc.uiloader:seekNodeByNameFast(scene.root, "player_cardPos_" .. seatId):getPosition())

	local paixing_bg = display.newSprite("Image/HkFiveCard/gameui/paixing_bg.png")
	paixing_bg:setAnchorPoint(cc.p(0.5,0))
	if seatId == 1 then
		paixing_bg:setPosition(cardPos.x, cardPos.y-161/2)
	else
		paixing_bg:setPosition(cardPos.x+117*(1-0.625)/2, cardPos.y-161*0.625/2)
	end
	paixing_bg:setLocalZOrder(1) -- must beyond the card

	local frame = util.card_type_frames[cardType]
	local img_card_type = display.newSprite(frame)
	img_card_type:setPosition(cc.p(paixing_bg:getContentSize().width/2,paixing_bg:getContentSize().height/2))
	img_card_type:addTo(paixing_bg)

--	img_card_type:setPosition(x+CARD_TYPE_OFFSET[seatId][1], y+CARD_TYPE_OFFSET[seatId][2])
--	img_card_type:setLocalZOrder(1) -- must beyond the card
--	user_ui_info.img_card_type = img_card_type
	user_ui_info.img_card_type = paixing_bg
--	scene.root:addChild(img_card_type)
	scene.root:addChild(paixing_bg)
end

function cardMgr:showPrivateCard(seatId, suit, number)
	print("show private card:", suit, number)
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	local front_frame = util.cardFrame(suit, number)
	local ui_card = user_ui_info.ui_cards[1]
	ui_card:setSpriteFrame(front_frame)
	if seatId == 1 then
		print("remove ui_card listener of touch...")
		ui_card:removeNodeEventListener(cc.NODE_TOUCH_EVENT)
		ui_card:setTouchEnabled(false)
		if self.flip_timer_handle then
			scheduler.unschedule(self.flip_timer_handle)
			self.flip_timer_handle = nil
		end
	end
end

function cardMgr:turnBackAllCard(seatId)
	local user_ui_info = uiPlayerInfos.ui_infos[seatId]
	local back_frame = util.cardBackFrame()
	for k, ui_card in pairs(user_ui_info.ui_cards) do
		if k == 1 and seatId == 1 and not vars.watching then
			ui_card:removeTouchEvent()
		end
		ui_card:setSpriteFrame(back_frame)
	end
end

function cardMgr:clearAllCards()
	for i = 1, consts.MAX_PLAYER_NUM do
		local ui_info = uiPlayerInfos.ui_infos[i]
		if ui_info ~= nil then 
			for k, v in pairs(ui_info.ui_cards) do
				if v ~= nil then
					v:removeFromParent()
				end
			end
			ui_info.ui_cards = {}
		end	
		self:showPlayerCardType(i, nil)
	end
end


return cardMgr