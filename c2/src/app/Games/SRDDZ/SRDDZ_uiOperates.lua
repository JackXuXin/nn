--
-- Author: peter
-- Date: 2017-02-17 13:52:38
--
local util = require("app.Common.util")

local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
local SRDDZ_Message = require("app.Games.SRDDZ.SRDDZ_Message")

local lg = require("app.Games.SRDDZ.lg_4ddz")

local gameScene = nil

--BTN
local BTN_BuJiao = "k_btn_BuJiao"	 --不叫
local BTN_YiFen = "k_btn_YiFen"		 --一分
local BTN_ErFen = "k_btn_ErFen"		 --二分
local BTN_SanFen = "k_btn_SanFen"	 --三分

local BTN_BuChu = "k_btn_BuChu"		 --不出
local BTN_TiShi = "k_btn_TiShi"		 --提示
local BTN_ChuPai = "k_btn_ChuPai"	 --出牌

local BTN_YaoBuQi = "k_btn_YaoBuQi"	 --要不起

local SRDDZ_uiOperates = {}

function SRDDZ_uiOperates:init(scene)
	gameScene = scene

	self.sortType = false

	self.TiShiCardInfo = {}

	self.k_btn_start_ready = cc.uiloader:seekNodeByNameFast(scene.root, "k_btn_start_ready")
	self.k_btn_start_ready:setLocalZOrder(10)
	self.k_btn_start_ready:onButtonClicked(handler(self,self.clickStartReady))
	self.k_btn_start_ready:setVisible(false)

	self.k_btn_invitation_ready = cc.uiloader:seekNodeByNameFast(scene.root, "k_btn_invitation_ready")
	self.k_btn_invitation_ready:setLocalZOrder(10)
	self.k_btn_invitation_ready:onButtonClicked(handler(self,self.clickInvitationReady))
	self.k_btn_invitation_ready:setVisible(false)

	self.k_btn_QuXiaoTuoGuan = cc.uiloader:seekNodeByNameFast(scene.root, "k_btn_QuXiaoTuoGuan")
	self.k_btn_QuXiaoTuoGuan:setLocalZOrder(10)
	self.k_btn_QuXiaoTuoGuan:onButtonClicked(handler(self,self.clickQuXiaoTuoGuan))
	self.k_btn_QuXiaoTuoGuan:setVisible(false)

	self.k_btn_PaiXu = cc.uiloader:seekNodeByNameFast(scene.root, "k_btn_PaiXu")
	self.k_btn_PaiXu:setLocalZOrder(10)
	self.k_btn_PaiXu:onButtonClicked(handler(self,self.clickPaiXu))
	self.k_btn_PaiXu:setVisible(false)
	self.k_player_op_panel_01 = cc.uiloader:seekNodeByNameFast(scene.root, "k_player_op_panel_01")
	self.k_player_op_panel_01:setVisible(false)

	self.k_player_op_panel_02 = cc.uiloader:seekNodeByNameFast(scene.root, "k_player_op_panel_02")
	self.k_player_op_panel_02:setVisible(false)
	
	self.k_player_op_panel_03 = cc.uiloader:seekNodeByNameFast(scene.root, "k_player_op_panel_03")
	self.k_player_op_panel_03:setVisible(false)

	self.op_btns = {
		{
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_01, BTN_BuJiao):onButtonClicked(handler(self,self.clickBuJiao)),
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_01, BTN_YiFen):onButtonClicked(handler(self,self.clickYiFen)),
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_01, BTN_ErFen):onButtonClicked(handler(self,self.clickErFen)),
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_01, BTN_SanFen):onButtonClicked(handler(self,self.clickSanFen))
		},
		{
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_02, BTN_BuChu):onButtonClicked(handler(self,self.clickBuChu)),
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_02, BTN_TiShi):onButtonClicked(handler(self,self.clickTiShi)),
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_02, BTN_ChuPai):onButtonClicked(handler(self,self.clickChuPai))
		},
		{
			cc.uiloader:seekNodeByNameFast(self.k_player_op_panel_03, BTN_YaoBuQi):onButtonClicked(handler(self,self.clickYaoBuQi))
		}
	}
end

function SRDDZ_uiOperates:clear()
	self.TiShiCardInfo = {}

	self.k_btn_start_ready = nil
	self.k_btn_invitation_ready = nil
	self.k_btn_QuXiaoTuoGuan = nil

	self.k_player_op_panel_01 = nil
	self.k_player_op_panel_02 = nil
	self.k_player_op_panel_03 = nil
	self.op_btns = {}
	
	self.sortType = false
end

--[[
	* click开始游戏
--]]
function SRDDZ_uiOperates:clickStartReady()
	SRDDZ_Message.dispatchGame("room.ReadyReq",SRDDZ_Const.REQUEST_INFO_00)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click邀请好友
--]]
function SRDDZ_uiOperates:clickInvitationReady()

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click取消托管
--]]
function SRDDZ_uiOperates:clickQuXiaoTuoGuan()
	SRDDZ_Message.sendMessage("SRDDZ.CancelTuoGuanReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
	},SRDDZ_Const.REQUEST_INFO_06)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end
--[[
	* click排序
--]]
function SRDDZ_uiOperates:clickPaiXu()
	local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards

	if self.sortType then
		SRDDZ_Util.SortCards(1,ui_cards,"m_num","m_color")
	else
		lg.sortByCardType(ui_cards)
	end

	self.sortType = not self.sortType

	gameScene.SRDDZ_CardMgr:updatePlayerCardsPosition()

	if SRDDZ_Util.isChuPai then
		gameScene.SRDDZ_PlayerMgr:showPlayerChuPai(gameScene.SRDDZ_PlayerMgr.PinningCardInfo)
	end
end

--[[
	* click不叫
--]]
function SRDDZ_uiOperates:clickBuJiao()
	SRDDZ_Message.sendMessage("SRDDZ.CallScoreReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		score = 0
	},SRDDZ_Const.REQUEST_INFO_02)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click一分
--]]
function SRDDZ_uiOperates:clickYiFen()
	SRDDZ_Message.sendMessage("SRDDZ.CallScoreReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		score = 1
	},SRDDZ_Const.REQUEST_INFO_02)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click二分
--]]
function SRDDZ_uiOperates:clickErFen()
	SRDDZ_Message.sendMessage("SRDDZ.CallScoreReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		score = 2
	},SRDDZ_Const.REQUEST_INFO_02)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click三分
--]]
function SRDDZ_uiOperates:clickSanFen()
	SRDDZ_Message.sendMessage("SRDDZ.CallScoreReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		score = 3
	},SRDDZ_Const.REQUEST_INFO_02)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click不出
--]]
function SRDDZ_uiOperates:clickBuChu()
	gameScene.SRDDZ_CardMgr:setPlayerCardAllSuoTou()

	SRDDZ_Message.sendMessage("SRDDZ.HandoutReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		handoutCard = {}
	},SRDDZ_Const.REQUEST_INFO_03)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click提示
--]]
function SRDDZ_uiOperates:clickTiShi()
	if #self.TiShiCardInfo == 0 or not self.TiShiCardInfo.index then
		return 
	end

	local TiShiCard = self.TiShiCardInfo[self.TiShiCardInfo.index]
	dump(TiShiCard,"点击提示给我的牌index是" .. self.TiShiCardInfo.index)
	self.TiShiCardInfo.index = self.TiShiCardInfo.index + 1
	if self.TiShiCardInfo.index > #self.TiShiCardInfo then
		self.TiShiCardInfo.index = 1
	end

	gameScene.SRDDZ_CardMgr:setPlayerCardAllSuoTou()
	gameScene.SRDDZ_CardMgr:setPlayerCardLuTou(TiShiCard)
	gameScene.SRDDZ_PlayerMgr:showPlayerChuPai(gameScene.SRDDZ_CardTouchMsg.PinningCardInfo)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click出牌
--]]
function SRDDZ_uiOperates:clickChuPai()
	SRDDZ_Message.sendMessage("SRDDZ.HandoutReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		handoutCard = gameScene.SRDDZ_CardMgr:getPlayerLuTouCards(2)
	},SRDDZ_Const.REQUEST_INFO_04)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* click要不起
--]]
function SRDDZ_uiOperates:clickYaoBuQi()

	self.k_player_op_panel_03:stopAllActions()

	SRDDZ_Message.sendMessage("SRDDZ.HandoutReq",{
		session = SRDDZ_Util.session,
		seatid = SRDDZ_Util.seatIndex,
		handoutCard = {}
	},SRDDZ_Const.REQUEST_INFO_05)

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

--[[
	* 设置准备按钮显示状态
	* param boolean flag 显示状态
--]]
function SRDDZ_uiOperates:setReadyBtnState(flag)
	if self.k_btn_start_ready and self.k_btn_invitation_ready then
		self.k_btn_start_ready:setVisible(flag)
--		self.k_btn_invitation_ready:setVisible(flag)

		if not flag then
			self.k_btn_start_ready = nil
			self.k_btn_invitation_ready = nil
			util.SetRequestBtnHide()
		else
			util.SetRequestBtnShow()
		end
	end
end

--[[
	* 设置取消托管按钮显示状态
	* param boolean flag 显示状态
--]]
function SRDDZ_uiOperates:setQuXiaoTuoGuanBtnState(flag)
	self.k_btn_QuXiaoTuoGuan:setVisible(flag)
end

--[[
	* 不叫 ，一，二，三分 按钮，显示 And 点击 状态
	* param boolean flag 显示状态
	* param table touchState 按钮是否可点击
--]]
function SRDDZ_uiOperates:setOpPanel_1(flag,touchState)
	touchState = touchState or {true,true,true,true}

	if flag then
		for k,v in ipairs(self.op_btns[1]) do
			if touchState[k] then
				v:setButtonEnabled(true)
			else
				v:setButtonEnabled(false)
			end
		end
	end

	self.k_player_op_panel_01:setVisible(flag)
end

--[[
	* 不出，提示，出牌 按钮，显示 And 点击 状态
	* param boolean flag 显示状态
	* param table touchState 按钮是否可点击
--]]
function SRDDZ_uiOperates:setOpPanel_2(flag,touchState)
	touchState = touchState or {true,true,false}

	if flag then
		for k,v in ipairs(self.op_btns[2]) do
			if touchState[k] then
				v:setButtonEnabled(true)
			else
				v:setButtonEnabled(false)
			end
		end
	end

	SRDDZ_Util.isChuPai = flag
	self.k_player_op_panel_02:setVisible(flag)
end

--[[
	* 要不起 按钮，显示 And 点击 状态
	* param boolean flag 显示状态
	* param table touchState 按钮是否可点击
--]]
function SRDDZ_uiOperates:setOpPanel_3(flag,touchState)
	touchState = touchState or {true}

	if flag then
		for k,v in ipairs(self.op_btns[3]) do
			if touchState[k] then
				v:setButtonEnabled(true)
			else
				v:setButtonEnabled(false)
			end
		end
	end

	if flag then
		gameScene.SRDDZ_CardTouchMsg:setRootTouchEnabled(false)
		gameScene.SRDDZ_CardMgr:setPlayerCardAllSuoTou()
		gameScene.SRDDZ_PlayerMgr:showPlayerHowever(true)
	else
		gameScene.SRDDZ_PlayerMgr:showPlayerHowever(false)
		gameScene.SRDDZ_CardTouchMsg:setRootTouchEnabled(true)
	end

	--3秒不点要不起 就自动不出
	if flag then
		self.k_player_op_panel_03:performWithDelay(
			function() 
				SRDDZ_Message.sendMessage("SRDDZ.HandoutReq",{
					session = SRDDZ_Util.session,
					seatid = SRDDZ_Util.seatIndex,
					handoutCard = {}
				},SRDDZ_Const.REQUEST_INFO_05)
			end
		, 3)
	end

	self.k_player_op_panel_03:setVisible(flag)
end

return SRDDZ_uiOperates