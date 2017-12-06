--
-- Author: peter
-- Date: 2017-03-10 19:54:48
--

local scheduler = require("framework.scheduler")

local lg = require("app.Games.WL.lg_dywl")
local util = require("app.Common.util")

local gameScene = nil

local TiShiCardInfo = {}  --获取到提示牌的信息

local pinningCardInfos = {}  --本轮桌子上最大的牌

local WL_uiOperates = {}

function WL_uiOperates:init(scene)
	gameScene = scene

	--准备按钮
	self.k_btn_start_ready = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_start_ready")
	self.k_btn_start_ready:setVisible(false)
	self.k_btn_start_ready:onButtonClicked(handler(self,self.clickStartReady))

	--出牌 提示按钮显示
	self.k_nd_operation_01 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_operation_01")
	self.k_nd_operation_01:setVisible(false)

	--要不起 按钮显示
	self.k_nd_operation_02 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_operation_02")
	self.k_nd_operation_02:setVisible(false)
	self.k_nd_operation_02:setLocalZOrder(2000)

	--出牌按钮
	self.k_btn_ChuPai = cc.uiloader:seekNodeByName(self.k_nd_operation_01, "k_btn_ChuPai")
	self.k_btn_ChuPai:setButtonEnabled(false)
	self.k_btn_ChuPai:onButtonClicked(handler(self,self.clickChuPai))

	--提示按钮
	self.k_btn_TiShi = cc.uiloader:seekNodeByName(self.k_nd_operation_01, "k_btn_TiShi")
	self.k_btn_TiShi:onButtonClicked(handler(self,self.clickTiShi))

	--要不起按钮
	self.k_btn_YaoBuQi = cc.uiloader:seekNodeByName(self.k_nd_operation_02, "k_btn_YaoBuQi")
	self.k_btn_YaoBuQi:onButtonClicked(handler(self,self.clickYaoBuQi))

	--取消托管按钮
	self.k_btn_QuXiaoTuoGuan = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_QuXiaoTuoGuan")
	self.k_btn_QuXiaoTuoGuan:onButtonClicked(handler(self,self.clickQuXiaoTuoGuan))
	self.k_btn_QuXiaoTuoGuan:setVisible(false)
	self.k_btn_QuXiaoTuoGuan:setLocalZOrder(2000)

	--排序按钮
	self.k_btn_PaiXu = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_PaiXu")
	self.k_btn_PaiXu:onButtonClicked(handler(self,self.clickPaiXu))
	self.k_btn_PaiXu:setVisible(false)
end

function WL_uiOperates:clear()
	self.k_nd_operation_02:stopAllActions()
	TiShiCardInfo = {}
	pinningCardInfos = {}
end

--[[
	* 显示 准备按钮
	* @param bool flag  显示状态
--]]
function WL_uiOperates:showStartReady(flag)
	self.k_btn_start_ready:setVisible(flag)
	if not flag then
		util.SetRequestBtnHide()
	else
		util.SetRequestBtnShow()
	end
end

--[[
	* 刷新出牌按钮状态
--]]
function WL_uiOperates:updateEnabledState(cardInfos)
	if not self.k_nd_operation_01:isVisible() then
		return 
	end

	cardInfos = cardInfos or gameScene.WL_CardMgr:getPlayerLuTuoCardInfos()

	dump(pinningCardInfos,"lg.compare_ 参数1")
	dump(cardInfos,"lg.compare_ 参数2")

	--判断选中的牌 是否 大过桌子上的牌
	self.k_btn_ChuPai:setButtonEnabled(lg.compare_(pinningCardInfos,cardInfos))
end

--[[
	* 显示提示,出牌按钮
	* @param bool flag  显示状态
	* @param table curCard  本轮桌子上最大的牌
--]]
function WL_uiOperates:showOperates_01(flag,curCard)
	if self.k_nd_operation_01:isVisible() == flag then
		return 
	end

	self.k_nd_operation_01:setVisible(flag)

	if flag then
		--刷新出牌按钮状态
		self:updateEnabledState()
	end

	-- if flag then
	-- 	--提示 
	-- 	self:clickTiShi()

	-- 	scheduler.performWithDelayGlobal(function() 
	-- 		gameScene.WL_Message.sendMessage("WL.HandoutReq",{
	-- 		session = gameScene.session,
	-- 		seatid = gameScene.seatIndex,
	-- 		handoutCard = gameScene.WL_CardMgr:getPlayerLuTuoCardInfos(2)
	-- 		},gameScene.WL_Const.REQUEST_INFO_04)
	-- 	end,0.1)
	-- end
end

--[[
	* 显示 要不起
	* @param bool flag  显示状态
--]]
function WL_uiOperates:showOperates_02(flag)
	if self.k_nd_operation_02:isVisible() == flag then
		return 
	end

	if flag then
		--关闭触摸
		gameScene.WL_CardTouchMgr:setRootTouchEnabled(false)
	end

	self.k_nd_operation_02:setVisible(flag)

	if flag then
		self.k_nd_operation_02:performWithDelay(
			function() 
				gameScene.WL_Message.sendMessage("WL.HandoutReq",{
					session = gameScene.session,
					seatid = gameScene.seatIndex,
					handoutCard = {}
				},gameScene.WL_Const.REQUEST_INFO_05)
		
				--开启触摸
				gameScene.WL_CardTouchMgr:setRootTouchEnabled(true)
			end,3.0)
	end
end

--[[
	* 显示操作
--]]
function WL_uiOperates:showOperates()
	--如果自己在托管状态就直接返回
	if gameScene.WL_PlayerMgr:getPlayerInfoWithSeatID(1):getTuoGuan() then
		return
	end

	if #TiShiCardInfo == 0 then
		--显示要不起按钮
		self:showOperates_02(true)

		-- scheduler.performWithDelayGlobal(function() 
		-- 	gameScene.WL_Message.sendMessage("WL.HandoutReq",{
		-- 	session = gameScene.session,
		-- 	seatid = gameScene.seatIndex,
		-- 	handoutCard = {}
		-- 	},gameScene.WL_Const.REQUEST_INFO_05)
		-- end,0.1)
	else
		--显示出牌按钮
		self:showOperates_01(true,curCard)
	end
end

--[[
	* 获取提示牌的信息
	* @param table curCard  --本轮桌子上最大的牌
--]]
function WL_uiOperates:getTiShiCardInfos(curCard)
	dump(curCard,"lg.remind 参数1")
	dump(gameScene.WL_CardMgr:getPlayerAllCardInfos(),"lg.remind 参数2")

	TiShiCardInfo = {}
	TiShiCardInfo = lg.remind(curCard,gameScene.WL_CardMgr:getPlayerAllCardInfos())
	TiShiCardInfo.index = 1

	dump(TiShiCardInfo,"得到的全部提示牌")

	pinningCardInfos = curCard

	--如果自己在托管状态就直接返回
	if gameScene.WL_PlayerMgr:getPlayerInfoWithSeatID(1):getTuoGuan() then
		return
	end

	self:showOperates()
end

--[[
	* 显示 取消托管按钮
	* @param bool flag  显示状态
--]]
function WL_uiOperates:showQuXiaoTuoGuanBtn(flag)
	self.k_btn_QuXiaoTuoGuan:setVisible(flag)
end

--[[
	* 显示 排序按钮
	* @param bool flag  显示状态
--]]
function WL_uiOperates:showPaiXuBtn(flag)
	self.k_btn_PaiXu:setVisible(flag)
end

-- ------------------------------ 按钮的回调方法 ------------------------------

--[[
	* 提示按钮回调
--]]
function WL_uiOperates:clickTiShi()
	print("点击了提示按钮")

	if #TiShiCardInfo == 0 or not TiShiCardInfo.index then
		return 
	end

	local TiShiCard = TiShiCardInfo[TiShiCardInfo.index]
	dump(TiShiCard,"点击提示给我的牌index是" .. TiShiCardInfo.index)
	TiShiCardInfo.index = TiShiCardInfo.index + 1
	if TiShiCardInfo.index > #TiShiCardInfo then
		TiShiCardInfo.index = 1
	end

	--提示的牌露头
	local cardInfos = gameScene.WL_CardMgr:setPlayerCardLuTou(TiShiCard.num)
	--刷新出牌状态
	self:updateEnabledState(cardInfos)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BEHAVIOR)
end

--[[
	* 出牌按钮回调
--]]
function WL_uiOperates:clickChuPai()
	print("点击了出牌按钮")

	gameScene.WL_Message.sendMessage("WL.HandoutReq",{
		session = gameScene.session,
		seatid = gameScene.seatIndex,
		handoutCard = gameScene.WL_CardMgr:getPlayerLuTuoCardInfos(2)
	},gameScene.WL_Const.REQUEST_INFO_04)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BEHAVIOR)
end

--[[
	* 要不起按钮回调
--]]
function WL_uiOperates:clickYaoBuQi()
	print("点击了要不起按钮")

	self.k_nd_operation_02:stopAllActions()

	gameScene.WL_Message.sendMessage("WL.HandoutReq",{
		session = gameScene.session,
		seatid = gameScene.seatIndex,
		handoutCard = {}
	},gameScene.WL_Const.REQUEST_INFO_05)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BEHAVIOR)

	--开启触摸
	gameScene.WL_CardTouchMgr:setRootTouchEnabled(true)
end

--[[
	* 开始游戏按钮回调
--]]
function WL_uiOperates:clickStartReady()
	print("点击了准备按钮")

	gameScene.WL_Message.dispatchGame("room.ReadyReq",gameScene.WL_Const.REQUEST_INFO_00)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BEHAVIOR)
end

--[[
	* 取消托管按钮回调
--]]
function WL_uiOperates:clickQuXiaoTuoGuan()
	print("点击了取消托管按钮")

	gameScene.WL_Message.sendMessage("WL.CancelTuoGuanReq",{
		session = gameScene.session,
		seatid = gameScene.seatIndex,
	},gameScene.WL_Const.REQUEST_INFO_06)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BEHAVIOR)
end

--[[
	* click排序
--]]
function WL_uiOperates:clickPaiXu()
	gameScene.WL_CardMgr:sortHandWithMode()

	gameScene.WL_CardMgr:updatePlayerCardsPosition()

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BEHAVIOR)
end

return WL_uiOperates