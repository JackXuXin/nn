--
-- Author: peter
-- Date: 2017-04-20 16:49:05
--

local WRNN_Const = require("app.Games.WRNN.WRNN_Const")
local util = require("app.Common.util")

local gameScene = nil

-- colors 
local COLOR_YELLOW = cc.c3b(240,214,56)  --胜利
local COLOR_BLUE = cc.c3b(0,246,255)  --失败
local COLOR_WHITE = cc.c3b(255,255,255)  --正常

local win_frame = cc.SpriteFrame:create(WRNN_Const.PATH.IMG_RESULT_WIN, cc.rect(0,0,1278, 626))
local lose_frame = cc.SpriteFrame:create(WRNN_Const.PATH.IMG_RESULT_LOSE, cc.rect(0,0,1278, 626))
local flat_frame = cc.SpriteFrame:create(WRNN_Const.PATH.IMG_RESULT_FLAT, cc.rect(0,0,1278, 626))
cc.SpriteFrameCache:getInstance():addSpriteFrame(win_frame, "wrnn_win_frame")
cc.SpriteFrameCache:getInstance():addSpriteFrame(lose_frame, "wrnn_lose_frame")
cc.SpriteFrameCache:getInstance():addSpriteFrame(flat_frame, "wrnn_flat_frame")

local WRNN_uiResults = {}

function WRNN_uiResults:init(scene)
	gameScene = scene

	self.k_nd_layer_result = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_layer_result")
	self.k_nd_layer_result:setVisible(false)
	self.k_nd_layer_result:setLocalZOrder(2001)

	self.k_btn_TuiChuFangJian = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_TuiChuFangJian")
	self.k_btn_TuiChuFangJian:onButtonClicked(handler(self,self.clickTuiChu))

	self.k_btn_ZaiLaiYiJu = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_ZaiLaiYiJu")
	self.k_btn_ZaiLaiYiJu:onButtonClicked(handler(self,self.clickJiXu))

	self.ui_banker = nil
	self.ui_results_info_BG = nil
end

function WRNN_uiResults:clear()
	if self.ui_banker then
		self.ui_banker:removeFromParent()
	end

	if self.ui_results_info_BG then
		self.ui_results_info_BG:removeFromParent()
	end
end

--[[
	* click退出房间
--]]
function WRNN_uiResults:clickTuiChu()
	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
	
	gameScene.WRNN_Message.dispatchGame("room.LeaveGame",gameScene.WRNN_Const.REQUEST_INFO_01,gameScene)
end

--[[
	* click再来一局
--]]
function WRNN_uiResults:clickJiXu()
	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)

	if gameScene.seatIndex == 0 and gameScene.session == 0 then
        gameScene.WRNN_Message.dispatchGame("room.LeaveGame",gameScene.WRNN_Const.REQUEST_INFO_01,gameScene)
        return 
    end

	gameScene.WRNN_Message.dispatchGame("room.ReadyReq",gameScene.WRNN_Const.REQUEST_INFO_00)
end

--[[
	* 显示游戏结果
	* *param bool flag 显示状态
	* @param table records 结算的信息数据
	* @param number banker 庄家椅子号
--]]
function WRNN_uiResults:showGameResult(flag,records,banker)
	if not flag then
		self.k_nd_layer_result:setVisible(flag)

		if self.ui_banker then
			self.ui_banker:removeFromParent()
			self.ui_banker = nil
		end

		if self.ui_results_info_BG then
			self.ui_results_info_BG:removeFromParent()
			self.ui_results_info_BG = nil
		end

		return 
	end

	--如果是旁观 隐藏再来一局按钮
	if gameScene.watching then
		self.k_btn_ZaiLaiYiJu:setVisible(false)
		self.k_btn_TuiChuFangJian:setPositionX(display.width/2)
	end

	for i=1,5 do
		local ui_record = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_player_result_" .. i)
		ui_record:setVisible(false)
	end

	local k_img_Settlement_BG = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_img_Settlement_BG")

	local count = 1
	local soundName = ""
	for _,resultsInfo in pairs(records) do
		local ui_record = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_player_result_" .. count)
		ui_record:setVisible(true)

		--名字
		local ui_name = cc.uiloader:seekNodeByName(ui_record, "k_player_name")
		ui_name:setString(util.checkNickName(resultsInfo.name))
		ui_name:setColor(COLOR_WHITE)

		--牌类型
		local ui_cardType = cc.uiloader:seekNodeByName(ui_record, "k_Player_cardType")
		local spriteframe = display.newSprite(gameScene.WRNN_Const.PATH["TX_CARD_TYPE_" .. resultsInfo.cardtype])
		ui_cardType:setSpriteFrame(spriteframe:getSpriteFrame())

		--分数
		local ui_score =  cc.uiloader:seekNodeByName(ui_record, "k_player_total_score")
		ui_score:setString(tostring(resultsInfo.gold))
		ui_score:setColor(COLOR_WHITE)

		--庄家标示
		if banker == resultsInfo.seatid then
			local pos = cc.p(ui_name:getPosition())
			local size = ui_name:getContentSize()
	
			if self.ui_banker then
				self.ui_banker:removeFromParent()
				self.ui_banker = nil
			end

			self.ui_banker = display.newSprite(gameScene.WRNN_Const.PATH.IMG_BANKER)
			self.ui_banker:setAnchorPoint(cc.p(1,0.5))
			self.ui_banker:setPosition(cc.p(pos.x-size.width/2-9,pos.y+3))
			ui_record:addChild(self.ui_banker)
			self.ui_banker:setScale(0.75)
		end

		--胜负
		if resultsInfo.seatid == 1 then
			if resultsInfo.gold > 0 then --赢
				soundName = gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_WIN

				ui_name:setColor(COLOR_YELLOW)
				ui_score:setColor(COLOR_YELLOW)
				k_img_Settlement_BG:setSpriteFrame(display.newSpriteFrame("wrnn_win_frame"))

				self.ui_results_info_BG = display.newSprite(gameScene.WRNN_Const.PATH.IMG_RESULT_YELLOW_BG, ui_cardType:getPositionX(), ui_cardType:getPositionY()):addTo(ui_record)
			elseif resultsInfo.gold == 0 then --平 没参与下注
				k_img_Settlement_BG:setSpriteFrame(display.newSpriteFrame("wrnn_flat_frame"))
			else 	--输 
				soundName = gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_LOSE

				ui_name:setColor(COLOR_BLUE)
				ui_score:setColor(COLOR_BLUE)
				k_img_Settlement_BG:setSpriteFrame(display.newSpriteFrame("wrnn_lose_frame"))

				self.ui_results_info_BG = display.newSprite(gameScene.WRNN_Const.PATH.IMG_RESULT_BLUE_BG, ui_cardType:getPositionX(), ui_cardType:getPositionY()):addTo(ui_record)
			end
		end

		count = count + 1
	end

	self.k_nd_layer_result:performWithDelay(
		function()
			self.k_nd_layer_result:setVisible(flag)

			if soundName ~= "" then
				gameScene.WRNN_Audio.playSoundWithPath(soundName)
			end
		end,1)
end

--[[
	* 结算界面显示状态
	* *param bool 显示状态
--]]
function WRNN_uiResults:isVisible()
	return self.k_nd_layer_result:isVisible()
end


return WRNN_uiResults