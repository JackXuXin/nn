
local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local comUtil = require("app.Common.util")

local util = require("app.Games.HkFiveCard.util")
local uiPlayerInfos = require("app.Games.HkFiveCard.uiPlayerInfos")

local scheduler = vars.scheduler
local TIME_GAP = consts.TIME_GAP

local scene = nil
local jettonMgr = {}

function jettonMgr:init(tableScene)
	scene = tableScene
	self.ui_pool_jettons = {}
	return self
end

function jettonMgr:clear()
	
end

-- ------------------------------ action of jetton ------------------------------
function jettonMgr:throwBaseJetton(seatId, val)
	print("seatId:"..seatId.." throw base jetton:"..val)
	local ui_body = uiPlayerInfos.ui_infos[seatId].ui_body
	local body_x = ui_body:getPositionX()
	local body_y = ui_body:getPositionY()

	local cnt = 0
	local ui_jettons = {}
	local pick_info_list = util.jettonPickForVal(val)
	for _, pick_info in pairs(pick_info_list) do
		for i = 1, pick_info.jettonCnt do
			local ui_jet = display.newSprite(util.jetton_frames[pick_info.jettonIdx])
			ui_jet:setPosition(body_x, body_y+4*cnt)
			scene.root:addChild(ui_jet)
			cnt = cnt + 1
			ui_jettons[cnt] = ui_jet
		end
	end

	for _, ui_jet in pairs(ui_jettons) do
		ui_jet:moveTo(TIME_GAP.THROW_JETS, util.randPoolX(), util.randPoolY())
		self.ui_pool_jettons[#self.ui_pool_jettons+1] = ui_jet
	end
end

function jettonMgr:pushJettonPile(seatId, val)
	if val <= 0 then
		print("pusth jetton failed! val is:", val)
		return 
	end

	local ui_user_info = uiPlayerInfos.ui_infos[seatId]
	local body_x = ui_user_info.ui_body:getPositionX()
	local body_y = ui_user_info.ui_body:getPositionY()

	local ui_chip_in = ui_user_info.lb_cur_chip_in
	local chip_in_x = ui_chip_in:getPositionX()
	local chip_in_y = ui_chip_in:getPositionY()
	chip_in_x, chip_in_y = util.reRotate(chip_in_x, chip_in_y, ui_chip_in:getRotation())

	local cnt = 0
	local ui_jettons = {} -- current pile
	local pick_info_list = util.jettonPickForVal(val)
	for _, pick_info in pairs(pick_info_list) do
		for i = 1, pick_info.jettonCnt do
			local ui_jet = display.newSprite(util.jetton_frames[pick_info.jettonIdx])
			ui_jet:setPosition(body_x, body_y+4*cnt)
			scene.root:addChild(ui_jet)
			cnt = cnt + 1
			ui_jettons[#ui_jettons+1] = ui_jet
			table.insert(ui_user_info.ui_jettons, ui_jet) -- together
		end
	end

	local num_font_h = 1.5*ui_user_info.lb_cur_chip_in:getCascadeBoundingBox().size.height
	for _, ui_jet in pairs(ui_jettons) do
		ui_jet:moveTo(TIME_GAP.PUSH_JETTON, ui_jet:getPositionX()+chip_in_x, 
					ui_jet:getPositionY()+chip_in_y+num_font_h)
	end
	scheduler.performWithDelay(function()
		uiPlayerInfos:updateChip(seatId)
	end, TIME_GAP.PUSH_JETTON)
end

function jettonMgr:setJettonPile(seatId, val)
	if val <= 0 then
		print("pusth jetton failed! val is:", val)
		return 
	end

	local ui_user_info = uiPlayerInfos.ui_infos[seatId]
	local body_x = ui_user_info.ui_body:getPositionX()
	local body_y = ui_user_info.ui_body:getPositionY()

	local ui_chip_in = ui_user_info.lb_cur_chip_in
	local num_font_h = 1.5*ui_user_info.lb_cur_chip_in:getCascadeBoundingBox().size.height
	local chip_in_x = ui_chip_in:getPositionX()
	local chip_in_y = ui_chip_in:getPositionY()
	chip_in_x, chip_in_y = util.reRotate(chip_in_x, chip_in_y, ui_chip_in:getRotation())

	local cnt = 0
	local ui_jettons = {} -- current pile
	local pick_info_list = util.jettonPickForVal(val)
	for _, pick_info in pairs(pick_info_list) do
		for i = 1, pick_info.jettonCnt do
			local ui_jet = display.newSprite(util.jetton_frames[pick_info.jettonIdx])
			ui_jet:setPosition(body_x+chip_in_x, body_y+4*cnt+chip_in_y+num_font_h)
			scene.root:addChild(ui_jet)
			cnt = cnt + 1
			ui_jettons[#ui_jettons+1] = ui_jet
			table.insert(ui_user_info.ui_jettons, ui_jet) -- together
		end
	end
end

-- the jetton pile int the front of player to jetton pool 
function jettonMgr:jettonPiles2Pool()
	-- print("take pushed jetton to pool")
	local px = nil
	local py = nil
	for i = 1, consts.MAX_PLAYER_NUM do
		-- printf("collect seat:%d", i)
		for _, ui_jet in pairs(uiPlayerInfos.ui_infos[i].ui_jettons) do
			px = util.randPoolX()
			py = util.randPoolY()
			-- print("px py:", px, py, ui_jet:getPosition())
			-- print(ui_jet:getParent():getPosition())
			ui_jet:moveTo(TIME_GAP.JETS_TO_POOL, px, py)
			self.ui_pool_jettons[#self.ui_pool_jettons+1] = ui_jet
		end
		uiPlayerInfos.ui_infos[i].ui_jettons = {}
		uiPlayerInfos.ui_infos[i].lb_cur_chip_in:setVisible(false)
	end
end

function jettonMgr:setJettonPool(val)
	local cnt = 0
	local ui_jettons = {} -- current pile
	local pick_info_list = util.jettonPickForVal(val)
	for _, pick_info in pairs(pick_info_list) do
		for i = 1, pick_info.jettonCnt do
			local px = util.randPoolX()
			local py = util.randPoolY()
			local ui_jet = display.newSprite(util.jetton_frames[pick_info.jettonIdx], px, py)
			scene.root:addChild(ui_jet)
			self.ui_pool_jettons[#self.ui_pool_jettons+1] = ui_jet
		end
	end
end

-- jetton to winner 
function jettonMgr:poolJettons2Player(seatId)
	local ui_body = uiPlayerInfos.ui_infos[seatId].ui_body
	local body_x = ui_body:getPositionX()
	local body_y = ui_body:getPositionY()

	for k, ui_jet in pairs(self.ui_pool_jettons) do
		scheduler.performWithDelay(function()
			local action = cc.Sequence:create(
				cc.MoveTo:create(TIME_GAP.POOL_TO_PLAYER, cc.p(body_x, body_y)), 
				cc.CallFunc:create(function() 
					ui_jet:removeFromParent()
				end)
			)
		    transition.execute(ui_jet, action)
		end, 0.0125*k)
	end
	self.ui_pool_jettons = {}
end

return jettonMgr