local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Message = require("app.Games.SRDDZ.SRDDZ_Message")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
local util = require("app.Common.util")

local scheduler = require("framework.scheduler")
local PATH = SRDDZ_Const.PATH

-- colors 
local COLOR_YELLOW = cc.c3b(255,255,0)
local COLOR_WHITE = cc.c3b(255,255,255)

local win_frame = cc.SpriteFrame:create(PATH.IMG_RESULT_WIN, cc.rect(0,0,1280, 720))
local lose_frame = cc.SpriteFrame:create(PATH.IMG_RESULT_LOSE, cc.rect(0,0,1280, 720))
cc.SpriteFrameCache:getInstance():addSpriteFrame(win_frame, "stddz_win_frame")
cc.SpriteFrameCache:getInstance():addSpriteFrame(lose_frame, "stddz_lose_frame")

local gameScene = nil
local SRDDZ_uiResults = {}

function SRDDZ_uiResults:init(scene)
	gameScene = scene

	self.k_nd_layer_result = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_layer_result")
	self.k_nd_layer_result:setVisible(false)
	self.k_nd_layer_result:setLocalZOrder(2001)

	self.k_btn_TuiChuFangJian = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_btn_TuiChuFangJian")
	self.k_btn_TuiChuFangJian:onButtonClicked(function() self:clickTuiChu() end)

	self.k_btn_ZaiLaiYiJu = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_btn_ZaiLaiYiJu")
	self.k_btn_ZaiLaiYiJu:onButtonClicked(function() self:clickJiXu() end)

	self.Landlord_Identity = nil

	return self
end

function SRDDZ_uiResults:clear()
	self.k_nd_layer_result = nil
	self.k_btn_TuiChuFangJian = nil
	self.k_btn_ZaiLaiYiJu = nil
	self.Landlord_Identity = nil
end

--[[
	* click退出房间
--]]
function SRDDZ_uiResults:clickTuiChu()
	SRDDZ_Message.dispatchGame("room.LeaveGame")

	--停止所有音效
	audio.stopAllSounds()
	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_QUIT)
end

--[[
	* click再来一局
--]]
function SRDDZ_uiResults:clickJiXu()
	if SRDDZ_Util.seatIndex == 0 and SRDDZ_Util.session == 0 then
        SRDDZ_Message.dispatchGame("room.LeaveGame")
        return 
    end
	SRDDZ_Message.dispatchGame("room.ReadyReq",SRDDZ_Const.REQUEST_INFO_00)

	--停止所有音效
	audio.stopAllSounds()
	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_CONTINUE)
end

--[[
	* 显示游戏结果
	* *param bool flag 显示状态
	* @param table msg 结算的信息数据
--]]
function SRDDZ_uiResults:showGameResult(flag,msg)
	if not flag then
		if self.Landlord_Identity then
			self.Landlord_Identity:removeFromParent()
			self.Landlord_Identity = nil
		end
		self.k_nd_layer_result:setVisible(flag)
		return 
	end

	local k_la_Panel_result = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_la_Panel_result")
	local k_sp_Settlement_BG = cc.uiloader:seekNodeByName(k_la_Panel_result, "k_sp_Settlement_BG")

	for k,v in ipairs(msg.records) do
		local k_la_player_result = cc.uiloader:seekNodeByName(k_la_Panel_result, "k_la_player_result_" .. k)

		--名字
		local ui_name = cc.uiloader:seekNodeByName(k_la_player_result,"k_tx_player_name")
		ui_name:setString(util.checkNickName(v.name))
		ui_name:setColor(COLOR_WHITE)

		--低分
		local ui_baseScore = cc.uiloader:seekNodeByName(k_la_player_result,"k_tx_player_Rate")
		ui_baseScore:setString(tostring(v.baseScore))
		ui_baseScore:setColor(COLOR_WHITE)

		--分数
		local ui_score = cc.uiloader:seekNodeByName(k_la_player_result,"k_tx_player_score")
		ui_score:setString(tostring(v.score))
		ui_score:setColor(COLOR_WHITE)

		--叫分
		local ui_multiple = cc.uiloader:seekNodeByName(k_la_player_result,"k_tx_player_multiple")
		ui_multiple:setString(tostring(v.multiple))
	--	ui_multiple:setString(gameScene.SRDDZ_uiTableInfos.k_tx_JiaoFen:getString())
		ui_multiple:setColor(COLOR_WHITE)

		--输赢
		if v.seat == 1 then
			if v.score > 0 then --赢
				k_sp_Settlement_BG:setSpriteFrame(display.newSpriteFrame("stddz_win_frame"))
				gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_SUCCESS)
			else --输
				k_sp_Settlement_BG:setSpriteFrame(display.newSpriteFrame("stddz_lose_frame"))
				gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_FAIL)
			end

			ui_name:setColor(COLOR_YELLOW)
			ui_baseScore:setColor(COLOR_YELLOW)
			ui_score:setColor(COLOR_YELLOW)
			ui_multiple:setColor(COLOR_YELLOW)
		end

		--如果是地主
		if v.bLandlord then
			local pos = cc.p(ui_name:getPosition())
			local size = ui_name:getContentSize()

			self.Landlord_Identity = display.newSprite(PATH.IMG_LANDLORD_IDENTITY)
			self.Landlord_Identity:setAnchorPoint(cc.p(1,0.5))
			self.Landlord_Identity:setPosition(cc.p(pos.x-size.width/2-6,pos.y))
			k_la_player_result:addChild(self.Landlord_Identity)
		end
	end

	scheduler.performWithDelayGlobal(
		function()
	self.k_nd_layer_result:setVisible(flag)
		end,4)
end

--[[
	* 结算界面显示状态
	* *param bool 显示状态
--]]
function SRDDZ_uiResults:isVisible()
	return self.k_nd_layer_result:isVisible()
end

return SRDDZ_uiResults