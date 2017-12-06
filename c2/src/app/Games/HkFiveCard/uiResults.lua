local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local util = require("app.Games.HkFiveCard.util")
local utilComm = require("app.Common.util")
local Share = require("app.User.Share")

local PATH = consts.PATH

-- colors 
local COLOR_YELLOW = cc.c3b(255,255,0)
local COLOR_WHITE = cc.c3b(255,255,255)


local win_frame = cc.SpriteFrame:create(PATH.IMG_RESULT_WIN, cc.rect(0,0,1278, 584))
local lose_frame = cc.SpriteFrame:create(PATH.IMG_RESULT_LOSE, cc.rect(0,0,1278, 584))
cc.SpriteFrameCache:getInstance():addSpriteFrame(win_frame, "win_frame")
cc.SpriteFrameCache:getInstance():addSpriteFrame(lose_frame, "lose_frame")


local scene = nil
local uiResults = {}

function uiResults:init(tableScene)
	scene = tableScene

	--NOTE: may generate it dynamically ?
	self.layer_result = cc.uiloader:seekNodeByNameFast(scene.root, "layer_result")
	self.layer_result:setVisible(false)
	self.layer_result:setLocalZOrder(100)

	-- self.btn_share = cc.uiloader:seekNodeByName(self.layer_result, "Button_share")
	-- self.btn_share:onButtonClicked(function() self:clickShare() end)
	-- self.btn_share:hide()

	-- win or lose
	self.win_or_lose = cc.uiloader:seekNodeByName(self.layer_result, "Settlement_BG")

	-- details
	self.ui_results = {}
	for i = 1, consts.MAX_PLAYER_NUM do 
		local ui_result = cc.uiloader:seekNodeByName(self.layer_result, "player_result_"..i)
		self.ui_results[i] = {
			ui_body = ui_result,
			lb_name = cc.uiloader:seekNodeByName(ui_result, "player_name"),
			lb_type = cc.uiloader:seekNodeByName(ui_result, "player_type"),
			lb_score = cc.uiloader:seekNodeByName(ui_result, "player_score"),
		}
	end

	return self
end

function uiResults:clear()
	
end

function uiResults:clickShare()
	Share.createGameShareLayer():addTo(scene)
end

function uiResults:showGameResult(flag, win_seat)
	print("show game result:", flag)
	if not flag then
		-- close immediately
		self.layer_result:setVisible(false) 
		return
	end

	local soud_path = nil
	if win_seat == 1 then
		soud_path = PATH.WAV_GAME_WIN
		self.win_or_lose:setSpriteFrame(display.newSpriteFrame("win_frame"))
	else
		soud_path = PATH.WAV_GAME_LOSE
		self.win_or_lose:setSpriteFrame(display.newSpriteFrame("lose_frame"))
	end

	-- set result informations
	local idx = 1 -- the index of result list
	for seat = 1, consts.MAX_PLAYER_NUM do 
		local player = vars.players[seat] --HACK: player offline/give_up ... 
		if player and player.ingame then
			printf("seat:%d name:%s", seat, player.name)
			self.ui_results[idx].ui_body:setVisible(true)
			self.ui_results[idx].lb_name:setString(utilComm.checkNickName(player.name))
			self.ui_results[idx].lb_type:setString(player.card_type)
			self.ui_results[idx].lb_score:setString(player.score)
			if seat == win_seat then
				self.ui_results[idx].lb_name:setTextColor(COLOR_YELLOW)
				self.ui_results[idx].lb_type:setTextColor(COLOR_YELLOW)
				self.ui_results[idx].lb_score:setTextColor(COLOR_YELLOW)
			else
				self.ui_results[idx].lb_name:setTextColor(COLOR_WHITE)
				self.ui_results[idx].lb_type:setTextColor(COLOR_WHITE)
				self.ui_results[idx].lb_score:setTextColor(COLOR_WHITE)
			end
			idx = idx + 1
		end
	end
	-- set other items of result list invisible
	for i = idx, consts.MAX_PLAYER_NUM do
		self.ui_results[i].ui_body:setVisible(false)
	end

	self.layer_result:setVisible(true)
	util.playSound(soud_path)
end

return uiResults