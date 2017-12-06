--
-- Author: K
-- Date: 2016-11-29 17:32:55
--

local GamePlayer = class("GamePlayer")

local define = require("app.Games.GP.Define")

local message = require("app.net.Message")
local AvatarConfig = require("app.config.AvatarConfig")
local Card = require("app.Games.GP.Card")
local util = require("app.Common.util")

local GP_Audio = require("app.Games.GP.GP_Audio")

require("app.Games.GP.lg_gp")

local PinningCardInfo = {}    --玩家要去管得牌
local selectCardInfo = {}  --玩家要出的牌
local TiShiCardInfo = {}   --所有可以提示的牌型

function GamePlayer:create(playerInfo,sceneSelf)
	local bRet = GamePlayer.new()
	bRet:init(playerInfo,sceneSelf)
	return bRet
end

function GamePlayer:ctor()
	self.m_playerInfo = nil  	--玩家信息
	self.m_Cards = {}     		--玩家手牌
	self.m_UINode = nil   		--展示玩家信息UI的节点
	self.m_sceneSelf = nil 		--游戏场景
	self.m_isTuoGuan = false    --是否开启托管
end

-- start --

--------------------------------
-- 初始化玩家信息
-- @function init
-- @param table playerInfo{       			玩家信息  
-- 					"player" = {
-- 					    "gold"    = "14111"
-- 					    "name"    = "用户00013918"
-- 					    "ready"   = 0
-- 					    "sex"     = 1
-- 					    "viptype" = 0
--						"ready"   = 0  --1等于已准备
-- 					}
-- 				"seat"   = 2
--				}
-- @param userdata sceneSelf   				游戏场景

-- end --

function GamePlayer:init(playerInfo,sceneSelf)
	self.m_playerInfo = playerInfo
	self.m_sceneSelf  = sceneSelf
	print("playerInfo.seat = " .. playerInfo.seat)
	self.m_UINode = cc.uiloader:seekNodeByNameFast(sceneSelf.root, "k_nd_player" .. playerInfo.seat)

	--昵称
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_tx_NiCheng"):setString(util.checkNickName(self.m_playerInfo.player.name))
	--金币
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_tx_JinBi"):setString(self.m_playerInfo.player.gold)
	--头像
	self:setTouXiang()

	--隐藏已准备
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBei"):setVisible(false)
	--隐藏不出文字
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChu"):setVisible(false)

	--如果是自己 隐藏出牌等等按钮
	if self.m_playerInfo.seat == 1 then
		-----清理按钮的监听
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Chupai"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuan"):removeAllEventListeners()
    	-------------------------

		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerXingWei"):setVisible(false)
    	--监听准备按钮
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):onButtonClicked(handler(self,self.clickReady))
    	--监听 出牌 提示 不出 按钮 
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Chupai"):onButtonClicked(handler(self,self.clickChuPai))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):onButtonClicked(handler(self,self.clickTiShi))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):onButtonClicked(handler(self,self.clickBuChu))
    	--监听取消托管按钮  并  隐藏
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuan"):onButtonClicked(handler(self,self.clickQuXiaoTuoGuan))
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuan"):setVisible(false)
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuan"):setLocalZOrder(20)
    	--隐藏大不过文字
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(false)
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setLocalZOrder(20)
	else 
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerPai"):setVisible(false)
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_NaoZhong"):setVisible(false)
	end

	--设置是否已经准备
	self:setPlayerReadyState(self.m_playerInfo.player.ready)

	--显示玩家UINode 当椅子上没有人的时候  UINode 是隐藏的
	self.m_UINode:setVisible(true)
end

-- start --

--------------------------------
-- 出牌请求
-- @function clickChuPai

-- end --
function GamePlayer:clickChuPai()
	self:hideChuPai()

	message.sendMessage("GP.HandoutReq", {
		session = self.m_sceneSelf.tableSession,
		seatid  = self.m_sceneSelf.seatIndex,
		handoutcard = selectCardInfo
	})

	GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_BEHAVIOR)
end

-- start --

--------------------------------
-- 出牌成功显示出牌
-- @function clickChuPai
-- @param table cards      打出去的牌
-- @param number cardNum   出牌的玩家所剩的手牌数

-- end --
function GamePlayer:ChuPai(cards,cardNum)
	GamePlayer.clearData()

	local hitCardsCount = #self.m_sceneSelf.HitCards
	--删除上家出得牌
	for k,v in ipairs(self.m_sceneSelf.HitCards) do
		v:removeFromParent()
	end
	self.m_sceneSelf.HitCards = {}

	--不出
	if #cards == 0 then
		--显示不出
		self:setBuChuTextShowState(true)
		--播放不出音效
		if self.m_playerInfo.player.sex == 1 then  --女
			GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_FEMALE_NO)
		else  --男
			GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_MALE_NO)
		end
		return 
	end

	if self.m_playerInfo.seat == 1 then  -- 自己出牌
		--删除手里打出去的牌
		for k,v in ipairs(cards) do
			for kk,vv in ipairs(self.m_Cards) do
				if v.num == vv:getNum() and v.color == vv:getCardColor() then
					vv:removeFromParent()
					table.remove(self.m_Cards,kk)
					break
				end
			end
		end
		self:sortCardPoint()
	else   --对手出牌
		--删除手里打出去的牌
		if #self.m_Cards - #cards == cardNum then
			for i=1,#cards do
				if self.m_Cards[1] ~= nil then
					self.m_Cards[1]:removeFromParent()
					table.remove(self.m_Cards,1)
				end
			end
		else
			print("发生了手牌数不匹配的异常情况")
			for i=1,#self.m_Cards - cardNum do
				if self.m_Cards[1] ~= nil then
					self.m_Cards[1]:removeFromParent()
					table.remove(self.m_Cards,1)
				end
			end
		end

		self:sortCardPoint()
	end

	local X = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_ChuPaiWeiZhi" .. self.m_playerInfo.seat):getPositionX()
	local Y = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_ChuPaiWeiZhi" .. self.m_playerInfo.seat):getPositionY()

	local scaleCoefficient = 0.7
	local width = (#cards * define.cardWidthDistance + define.cardWidth - define.cardWidthDistance) * scaleCoefficient
	X = (X - width / 2) + (define.cardWidth*scaleCoefficient) / 2

	--从大到小排序
	self.m_sceneSelf:SortCards(1,cards)

	--显示要出的牌
	local bg = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_BeiJing")
	for k,v in ipairs(cards) do
		local card = Card.new()
		card:setNum(v.num)
		card:setCardColor(v.color)
		card:showFront()

		card:setPosition(cc.p(X,Y))
		X = X + define.cardWidthDistance * scaleCoefficient
		card:setScale(0.7)
		card:setLocalZOrder(k)
		card:addTo(bg)
		table.insert(self.m_sceneSelf.HitCards,card)
	end

	GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_OUT_CARD)

	local soundName = "GP_SOUND_"
	if self.m_playerInfo.player.sex == 1 then  --女
		soundName = soundName .. "FEMALE_"
	else  --男
		soundName = soundName .. "MALE_"
	end

    --获取出牌的牌型
	local PaiXing = gp_getCardtype(cards)
	if PaiXing == "bomb" or PaiXing == "bombandsingle" then        	---炸弹
		self:playZhaDanAction()

		soundName = soundName .. "BOMB"
	elseif PaiXing == "sequences" then       						---顺子	
		self:playShunZiAction()

		soundName = soundName .. "SEQUENCES"
	elseif PaiXing == "doublesequences" then  						---连对
		self:playLianDuiAction()

		soundName = soundName .. "DOUBLESEQUENCES"
	elseif PaiXing == "triblesequences" then 		  				---三连
		self:playSanLianAction()

		soundName = soundName .. "TRIBLESEQUENCES"
	elseif PaiXing == "single" then  								---单牌
		soundName = soundName .. "SINGLE_" .. tostring(cards[1].num)
	elseif PaiXing == "double" then 								---对子
		soundName = soundName .. "DOUBLE_" .. tostring(cards[1].num)
	elseif PaiXing == "trible" then 								---三张
		soundName = soundName .. "TRIBLE"
	elseif PaiXing == "captive" then  								---三带
		soundName = soundName .. "CAPTIVE"
	end

	if PaiXing ~= "single" and PaiXing ~= "double" then
		if hitCardsCount ~= 0 then
			if self.m_playerInfo.player.sex == 1 then  --女
				GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_FEMALE_YOU)
			else  --男
				GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_MALE_YOU)
			end
		else
			GP_Audio.playSoundWithPath(GP_Audio.preloadResPath[soundName])
		end
	else
		GP_Audio.playSoundWithPath(GP_Audio.preloadResPath[soundName])
	end
end


-- start --

--------------------------------
-- 设置出牌按钮状态 选择的牌打过对家的时候 才会可点击
-- @function setChuPaiBtnState

-- end --
function GamePlayer:setChuPaiBtnState(isEnabled)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Chupai"):setButtonEnabled(isEnabled)
end

-- start --

--------------------------------
-- 提示
-- @function clickTiShi

-- end --
function GamePlayer:clickTiShi()
	--如果正在托管或没有牌大过对方就执行不出
	if self:isTuoGuanEnabled() or #TiShiCardInfo == 0 then

		self:hideChuPai()

		message.sendMessage("GP.HandoutReq", {
			session = self.m_sceneSelf.tableSession,
			seatid  = self.m_sceneSelf.seatIndex,
			handoutcard = nil
		})

		return 
	end

	for k,v in ipairs(self.m_Cards) do
		if v:isCardLuTou() then
			v:selectCardSuoTou()
			print("牌缩头——1")
		end
	end

	local TiShiCard = TiShiCardInfo[TiShiCardInfo.TiShiIndex]
	dump(TiShiCard,"点击提示给我的牌index是" .. TiShiCardInfo.TiShiIndex)
	TiShiCardInfo.TiShiIndex = TiShiCardInfo.TiShiIndex + 1
	print("index + 1 之后的等于 = " .. TiShiCardInfo.TiShiIndex)
	if TiShiCardInfo.TiShiIndex > #TiShiCardInfo then
		TiShiCardInfo.TiShiIndex = 1
	end
	
	for k,v in ipairs(TiShiCard) do
		for kk,vv in ipairs(self.m_Cards) do
			if v.num == vv:getNum() and v.color == vv:getCardColor() then
				vv:selectCardLuTou()
				print("牌露头")
			end
		end
	end

	self:addSelectCard()

	GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_BEHAVIOR)
end

-- start --

--------------------------------
-- 不出
-- @function clickBuChu

-- end --
function GamePlayer:clickBuChu()
	print("是不是3秒之后被调用")

	self:hideChuPai()

	message.sendMessage("GP.HandoutReq", {
		session = self.m_sceneSelf.tableSession,
		seatid  = self.m_sceneSelf.seatIndex,
		handoutcard = nil
	})

	GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_BEHAVIOR)
end

-- start --

--------------------------------
-- 取消托管
-- @function clickQuXiaoTuoGuan
-- #param table event   事件信息

-- end --
function GamePlayer:clickQuXiaoTuoGuan(event)
	event.target:setVisible(false)

	message.sendMessage("GP.CancelTuoGuanReq", {
		session = self.m_sceneSelf.tableSession,
		seatid  = self.m_sceneSelf.seatIndex,
	})
end

-- start --

--------------------------------
-- 设置托管状态
-- @function setTuoGuanState
-- #param bool isTuoGuan   托管状态

-- end --

function GamePlayer:setTuoGuanState(isTuoGuan)
	self.m_isTuoGuan = isTuoGuan
	if self.m_playerInfo.seat == 1 then    --如果托管的是自己
		if self.m_isTuoGuan then 	--开启托管
			self.m_sceneSelf.root:setTouchEnabled(false) --关闭选牌触摸

			for k,v in ipairs(self.m_Cards) do
				if v:isCardLuTou() then  --牌被选择
					v:selectCardSuoTou()   --缩头
					print("牌值：" .. v:getNum())
					print("牌缩头——2")
				end
	
				v:setColor(define.cardSelectColor)
			end
	
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuan"):setVisible(true)  --显示托管按钮
			self:setTouXiang()  --设置为托管头像
	
		else 						--取消托管
			for k,v in ipairs(self.m_Cards) do
				v:setColor(define.cardReleaseColor)
				self:setTouXiang()  --设置为默认头像
			end

			self.m_sceneSelf.root:setTouchEnabled(true)	--开启选牌触摸
		end
	else    --如果托管的是别人 只需要设置一下托管头像
		self:setTouXiang()  --设置头像
	end
end

-- start --

--------------------------------
-- 是否开启托管
-- @function isTuoGuanEnabled

-- end --
function GamePlayer:isTuoGuanEnabled()
	return self.m_isTuoGuan
end

-- start --

--------------------------------
-- 设置头像
-- @function setTouXiang

-- end --

function GamePlayer:setTouXiang()
	if self.m_isTuoGuan then  --设置托管头像
		local por = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_TouXiang")
		local farme = cc.SpriteFrame:create("Image/GP/img_JiQiRenTouXiang.png",cc.rect(0,0,98,98))
    	por:setSpriteFrame(farme)
    	por:setScale(1)
	else   --设置默认头像
		local image = AvatarConfig:getAvatar(self.m_playerInfo.player.sex, self.m_playerInfo.player.gold, 0)
    	local rect = cc.rect(0, 0, 150, 150)
    	local frame = cc.SpriteFrame:create(image, rect)
    	local por = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_TouXiang")
    	por:setSpriteFrame(frame)
    	por:setScale(0.666666667)
	end
end

-- start --

--------------------------------
-- 是否正在出牌
-- @function isShowChuPai
-- @param table cards    上家出的牌 如果为nil 表示上家没有出牌

-- end --

function GamePlayer:isShowChuPai()
	return cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerXingWei"):isVisible()
end

-- start --

--------------------------------
-- 显示出牌
-- @function showChuPai
-- @param number time     倒计时时间
-- @param table cards    上家出的牌 如果为nil 表示上家没有出牌

-- end --
function GamePlayer:showChuPai(time,cards)
	--要管的牌 
	if cards ~= nil then
		for k,v in ipairs(cards) do
			local cardInfo = {}
			cardInfo.num = v.num
			cardInfo.color = v.color
			table.insert(PinningCardInfo,cardInfo)
		end
	end

	dump(PinningCardInfo,"需要我管得牌")

	--我自己的手牌
	local allCard = {}
	for k,v in ipairs(self.m_Cards) do
		local cardInfo = {}
		cardInfo.num = v:getNum()
		cardInfo.color = v:getCardColor()
		table.insert(allCard,cardInfo)
	end

	--获取提示的牌型
	TiShiCardInfo = gp_Remind(PinningCardInfo,allCard)
	TiShiCardInfo.TiShiIndex = 1
	dump(TiShiCardInfo,"获取到提示的牌index是" .. TiShiCardInfo.TiShiIndex)
	if #TiShiCardInfo == 0 then  --手里没有能大过对方的牌
		self.m_sceneSelf.root:setTouchEnabled(false)  --关闭选牌触摸
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(true) --显示没有牌大过对方
		if not self:isTuoGuanEnabled() then
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):performWithDelay(handler(self,self.clickBuChu), 3)
		end
		self:setChuPaiBtnState(false)	 --禁用出牌按钮

		for k,v in ipairs(self.m_Cards) do
			if v:isCardLuTou() then
				v:selectCardSuoTou()
				print("牌缩头——3")
			end
			v:setColor(define.cardSelectColor)
		end
	else
		--添加选择的牌
     	self:addSelectCard()
	end

	--如果正在托管就禁用所有按钮
	if self:isTuoGuanEnabled() then
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setButtonEnabled(false)  --禁用不出按钮
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):setButtonEnabled(false)  --禁用提示按钮

		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setVisible(false)	--隐藏不出按钮
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):setVisible(false)	--隐藏提示按钮
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Chupai"):setVisible(false)	--隐藏出牌按钮
	else
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setButtonEnabled(true)  --开启不出按钮
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):setButtonEnabled(true)  --开启提示按钮

		if #PinningCardInfo == 0 then
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setButtonEnabled(false)  --禁用不出按钮
		else
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setButtonEnabled(true)  --开启不出按钮
		end

		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setVisible(true)	--显示不出按钮
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):setVisible(true)	--显示提示按钮
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Chupai"):setVisible(true)	--显示出牌按钮
	end

	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerXingWei"):setVisible(true)	--显示出牌的UI

	local DaoJiShi = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_DaoJiShi")
	if not time then
		if self:isTuoGuanEnabled() then
			time = 3
		else
			time = self.m_sceneSelf.DaoJiShiTime
		end
	end
	DaoJiShi:setString(tostring(time))

	local function onDaoShiJi(dt)
		local num = tonumber(DaoJiShi:getString()) - 1
		if num == 0 then
			self.m_UINode:stopAllActions() 	--停止定时器
		end

		if num < 4 then
			GP_Audio.playDaoJiShiSound()
		end

		DaoJiShi:setString(tostring(num))

		if gp_canAllhandout(allCard) then --如果手里剩下最后一个牌型 并且比桌子上得牌大  3秒后帮玩家出牌
			if not self:isTuoGuanEnabled() then  --如果玩家没有开启托管
				if num + 3 == time then  --如果倒计时过了3秒
					selectCardInfo = allCard
					self:clickChuPai()
				end
			end
		end
	end

	self.m_UINode:stopAllActions() 	--停止定时器
	self.m_UINode:schedule(onDaoShiJi,1.0)
end

-- start --

--------------------------------
-- 隐藏出牌
-- @function hideChuPai

-- end --
function GamePlayer:hideChuPai()
	if not cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerXingWei"):isVisible() then  --如果没有显示出牌UI就直接返回
		return 
	end

	if #TiShiCardInfo == 0 then
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):stopAllActions()
	end

	GP_Audio.stopDaoJiShiSound()

	self.m_UINode:stopAllActions() 	--停止定时器

	if not self:isTuoGuanEnabled() then
		for k,v in ipairs(self.m_Cards) do
			v:setColor(define.cardReleaseColor)
		end
		self.m_sceneSelf.root:setTouchEnabled(true)  --开启选牌触摸
	end

	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(false)	--隐藏没有牌大过对方
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):setButtonEnabled(true)  	--开启提示按钮

	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerXingWei"):setVisible(false)  --隐藏出牌的UI
end

-- start --

--------------------------------
-- 是否正在等待被人出牌
-- @function isShowDengDaiChuPai

-- end --

function GamePlayer:isShowDengDaiChuPai()
	return cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_NaoZhong"):isVisible()
end

--------------------------------
-- 显示等待别人出牌的定时器
-- @function showDengDaiChuPai
-- @param number time     倒计时时间

-- end --
function GamePlayer:showDengDaiChuPai(time)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_NaoZhong"):setVisible(true)

	local DaoJiShi = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_DaoJiShi")
	if not time then
		if self:isTuoGuanEnabled() then
			time = 3
		else
			time = self.m_sceneSelf.DaoJiShiTime
		end
	end
	DaoJiShi:setString(tostring(time))

	local function onDaoShiJi(dt)
		local num = tonumber(DaoJiShi:getString()) - 1
		if num == 0 then
			self.m_UINode:stopAllActions()  --停止定时器
		end

		DaoJiShi:setString(tostring(num))
	end

	self.m_UINode:stopAllActions()  --停止定时器
	self.m_UINode:schedule(onDaoShiJi,1.0)
end

-- start --

--------------------------------
-- 隐藏等待出牌的倒计时
-- @function hideDengDaiChuPai

-- end --
function GamePlayer:hideDengDaiChuPai()
	if not cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_NaoZhong"):isVisible() then
		return 
	end

	self.m_UINode:stopAllActions()  --停止定时器
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_NaoZhong"):setVisible(false)  --隐藏倒数UI
end

-- start --

--------------------------------
-- 发牌
-- @function sendCard
-- @param Card card    							牌
-- @param function cardSendFinishedCallback     发牌动画结束回调

-- end --
function GamePlayer:sendCard(card,cardSendFinishedCallback)
	--发牌到手里
	table.insert(self.m_Cards,card)
	self:sortCardPoint()
	card:setVisible(true)
	cardSendFinishedCallback()

	-- local FaPaiWeiZhi = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_PaiWeiZhi" .. self.m_playerInfo.seat)

	-- local action = cc.Sequence:create(
 --        cc.MoveTo:create(0.1, cc.p(FaPaiWeiZhi:getPosition())), 
 --        cc.CallFunc:create(cardSendFinishedCallback)
 --    )
	-- card:runAction(action)
end

-- start --

--------------------------------
-- 排序手牌大小顺序和位置
-- @function sortCardPoint
-- @param table event    事件信息

-- end --
function GamePlayer:sortCardPoint()

	self.m_sceneSelf:SortCardsEx(1,self.m_Cards)

	local X = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_PaiWeiZhi" .. self.m_playerInfo.seat):getPositionX()  --排序的原点
	local Y = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_PaiWeiZhi" .. self.m_playerInfo.seat):getPositionY()  --排序的原点

	if self.m_playerInfo.seat == 1 then
		local width = #self.m_Cards * define.cardWidthDistance + define.cardWidth - define.cardWidthDistance
		X = (X - width / 2) + define.cardWidth / 2

		for k,v in ipairs(self.m_Cards) do

			v:setPosition(cc.p(X,Y))
			X = X + define.cardWidthDistance
			v:setLocalZOrder(k)

			--显示正面
			v:showFront()

			--设置触摸范围
			if v == self.m_Cards[#self.m_Cards] then  --最后一张牌的触摸范围是整张牌
				v.m_touchRect = cc.rect(v:getPositionX()-define.cardWidth/2,v:getPositionY()-define.cardHeight/2,
					define.cardWidth,define.cardHeight)
			else
				v.m_touchRect = cc.rect(v:getPositionX()-define.cardWidth/2,v:getPositionY()-define.cardHeight/2,
					define.cardWidthDistance,define.cardHeight)
			end
		end
	else
		local scaleCoefficient = 0.65
		local width = (#self.m_Cards * define.cardWidthDistance + define.cardWidth - define.cardWidthDistance) * scaleCoefficient
		X = (X + width / 2) - (define.cardWidth*scaleCoefficient) / 2

		for k,v in ipairs(self.m_Cards) do
			v:setPosition(cc.p(X,Y))
			X = X - (define.cardWidthDistance * scaleCoefficient)
			v:setLocalZOrder(k)
			v:setScale(scaleCoefficient)
		end

		--显示剩余牌数
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerPai"):setVisible(true)
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_ShengPaiShu"):setString(tostring(#self.m_Cards))
	end
end

-- start --

--------------------------------
-- 准备  点击之后隐藏按钮 发送准备协议
-- @function clickReady
-- @param table event    事件信息

-- end --
function GamePlayer:clickReady(event)
	if event ~= nil then
		event.target:setVisible(false)
	end
    message.dispatchGame("room.ReadyReq")

    GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_READY)
end

-- start --

--------------------------------
-- 设置玩家是否已经准备  显示隐藏已准备文字图片
-- @function setPlayerReadyState

-- end --
function GamePlayer:setPlayerReadyState(ready)
	self.m_playerInfo.player.ready = ready
	if ready == 1 then  -- 已经准备
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBei"):setVisible(true)
	else 				--还没有准备
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBei"):setVisible(false)
	end
end

-- start --

--------------------------------
-- 退出房间
-- @function OutRoot

-- end --
function GamePlayer:OutRoot()
	for k,v in ipairs(self.m_Cards) do  --清理牌
		if v then
			v:removeFromParent()
		end
	end

 	--隐藏玩家信息 等待下一个玩家进入 重新设置
	self.m_UINode:setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_PlayerPai"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_NaoZhong"):setVisible(false)
end

-- start --

--------------------------------
-- 添加选择要出的牌 判断是否能大过对家
-- @function addSelectCard

-- end --
function GamePlayer:addSelectCard()
	selectCardInfo = {}
	for k,v in ipairs(self.m_Cards) do
		if v:isCardLuTou() then
			local cardInfo = {}
			cardInfo.num = v:getNum()
			cardInfo.color = v:getCardColor()
			table.insert(selectCardInfo,cardInfo)
		end
	end

	if #selectCardInfo == 0 then
		print("没有选择要出的牌禁用了出牌按钮")
		self:setChuPaiBtnState(false)
		return 
	end

	if #PinningCardInfo ~= 0 then
		if gp_cardCompare(selectCardInfo,PinningCardInfo) then
			print("选择的牌可以出开启了出牌按钮")
			self:setChuPaiBtnState(true)
		else
			print("选择的牌不可以出禁用了出牌按钮")
			self:setChuPaiBtnState(false)
		end
	else
		if gp_getCardtype(selectCardInfo) ~= "errorcardtype" then    --如果没有要去管得牌 并且 选择的牌型是正确的
			print("没有需要管得牌选择的牌型是正确的开启了出牌按钮")
			self:setChuPaiBtnState(true)
		else
			print("没有需要管得牌选择的牌型是错误的禁用了出牌按钮")
			self:setChuPaiBtnState(false)
		end
	end

	GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_HIT_CARD)
end

-- start --

--------------------------------
-- 结算
-- @function Result

-- end --
function GamePlayer:Result()
	if self.m_playerInfo.seat == 1 then
		if self:isTuoGuanEnabled() then
			self:setTuoGuanState(false)
		end

		if self:isShowChuPai() then
			self:hideChuPai()
		end
	else
		if self:isShowDengDaiChuPai() then
			self:hideDengDaiChuPai()
		end
	end
end

-- start --

--------------------------------
-- 设置不出文字显示状态
-- @function Result

-- end --

function GamePlayer:setBuChuTextShowState(state)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChu"):setVisible(state)
end

-- start --

--------------------------------
-- 智能提取 顺子 连队
-- @function Result

-- end --
function GamePlayer:ZhiNengTiQu(selectCard)
	for k,v in ipairs(self.m_Cards) do
		if v:isCardLuTou() then
			return false
		end
	end

	local TiQuCard = {}
	for k,v in ipairs(selectCard) do
		local card = {}
		card.num = v:getNum()
		card.color = v:getCardColor()
		table.insert(TiQuCard,card)
	end

	--提取
	local cards = gp_findSequence(PinningCardInfo,TiQuCard)
	if cards == nil or #cards == 0 then
		dump(cards,"没有找到智能提取的牌")
		return  false
	end

	dump(cards,"智能提取的牌")
    for k,v in ipairs(selectCard) do
    	v:setColor(define.cardReleaseColor)

    	for kk,vv in ipairs(cards) do
    		if v:getNum() == vv.num and v:getCardColor() == vv.color then
    			v:selectCardLuTou()
    			print("拍露头")
    		end
    	end
    end

  	--添加选择的牌
  	self:addSelectCard()

	return true
end

-- start --

--------------------------------
-- 清理牌相关数据
-- @function clearData

-- end --
function GamePlayer.clearData()
	PinningCardInfo = {}    --玩家要去管得牌
	selectCardInfo = {}  --玩家要出的牌
	TiShiCardInfo = {}   --所有可以提示的牌型
end

-- start --

--------------------------------
-- 播放顺子动画
-- @function playShunZiAction

-- end --
function GamePlayer:playShunZiAction()
	local node = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_ChuPaiWeiZhi" .. self.m_playerInfo.seat)

	--爆炸
	local function BaoZhaAction()
		local BaoZha = display.newSprite("Image/GP/texiao/img_GuangQuan01.png")
		BaoZha:addTo(node)

		local animation = cc.Animation:create()
		for i=2,5 do
			local sprite = display.newSprite("Image/GP/texiao/img_GuangQuan0" .. i .. ".png")
			animation:addSpriteFrame(sprite:getSpriteFrame())
		end
		animation:setDelayPerUnit(0.1)
		local action = cc.Animate:create(animation)
		BaoZha:runAction(cc.Sequence:create(action,cc.CallFunc:create(function () node:removeAllChildren() end)))
	end

	--文字
	local function WenZiAction()
		local Guang = display.newSprite("Image/GP/texiao/img_ShunZiDi.png")
--		Guang:pos(Guang:getPositionX()-250-Guang:getContentSize().width/2,Guang:getPositionY())
		Guang:pos(Guang:getPositionX()-220,Guang:getPositionY())
		Guang:setAnchorPoint(cc.p(0,0.5))
		Guang:setScaleX(0.1)
		Guang:addTo(node)

		local WenZi = display.newSprite("Image/GP/texiao/tx_ShunZi.png")
		WenZi:pos(WenZi:getPositionX()-150,WenZi:getPositionY())
		WenZi:addTo(node,10)

		Guang:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1),cc.RemoveSelf:create(true),cc.CallFunc:create(BaoZhaAction)))
		WenZi:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveTo:create(0.18,cc.p(0,0)))))
	end

	--低杠
	local DiGang = display.newSprite("Image/GP/texiao/img_Di.png")
	DiGang:pos(DiGang:getContentSize().width/2 * -1,DiGang:getPositionY())
	DiGang:setAnchorPoint(cc.p(0,0.5))
	DiGang:setScaleX(0.1)
	DiGang:addTo(node)
	local sequence = cc.Sequence:create(cc.ScaleTo:create(0.1,1),cc.RemoveSelf:create(true),cc.CallFunc:create(WenZiAction))
	DiGang:runAction(sequence)

end

-- start --

--------------------------------
-- 播放三连动画
-- @function playSanLianAction

-- end --
function GamePlayer:playSanLianAction()
	local node = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_ChuPaiWeiZhi" .. self.m_playerInfo.seat)

	--爆炸
	local function BaoZhaAction()
		local BaoZha = display.newSprite("Image/GP/texiao/img_GuangQuan01.png")
		BaoZha:addTo(node)

		local animation = cc.Animation:create()
		for i=2,5 do
			local sprite = display.newSprite("Image/GP/texiao/img_GuangQuan0" .. i .. ".png")
			animation:addSpriteFrame(sprite:getSpriteFrame())
		end
		animation:setDelayPerUnit(0.1)
		local action = cc.Animate:create(animation)
		BaoZha:runAction(cc.Sequence:create(action,cc.CallFunc:create(function () node:removeAllChildren() end)))
	end

	--文字
	local function WenZiAction()
		local Guang = display.newSprite("Image/GP/texiao/img_ShunZiDi.png")
		Guang:pos(Guang:getPositionX()-220,Guang:getPositionY())
		Guang:setAnchorPoint(cc.p(0,0.5))
		Guang:setScaleX(0.1)
		Guang:addTo(node)

		local WenZi = display.newSprite("Image/GP/texiao/tx_SanLian.png")
		WenZi:pos(WenZi:getPositionX()-150,WenZi:getPositionY())
		WenZi:addTo(node,10)

		Guang:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1),cc.RemoveSelf:create(true),cc.CallFunc:create(BaoZhaAction)))
		WenZi:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveTo:create(0.18,cc.p(0,0)))))
	end

	--低杠
	local DiGang = display.newSprite("Image/GP/texiao/img_Di.png")
	DiGang:pos(DiGang:getContentSize().width/2 * -1,DiGang:getPositionY())
	DiGang:setAnchorPoint(cc.p(0,0.5))
	DiGang:setScaleX(0.1)
	DiGang:addTo(node)
	local sequence = cc.Sequence:create(cc.ScaleTo:create(0.1,1),cc.RemoveSelf:create(true),cc.CallFunc:create(WenZiAction))
	DiGang:runAction(sequence)
end

-- start --

--------------------------------
-- 播放连对动画
-- @function playLianDuiAction

-- end --
function GamePlayer:playLianDuiAction()
	local node = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_ChuPaiWeiZhi" .. self.m_playerInfo.seat)

	--连
	local Lian = display.newSprite("Image/GP/texiao/tx_Lian.png")
	Lian:pos(-150,0)
	--对
	local Dui = display.newSprite("Image/GP/texiao/tx_Dui.png")
	Dui:pos(150,0)

	Lian:addTo(node,10)
	Dui:addTo(node,10)

	local lian_action_1 = cc.EaseBackInOut:create(cc.MoveBy:create(0.2,cc.p(108,0)))
	local lian_move_1 = cc.MoveBy:create(0.5,cc.p(-50,0))
	local lian_move_2 = cc.Sequence:create(cc.RotateTo:create(0.1,-20),cc.RotateTo:create(0.1,20))
	local lian_action_2 = cc.Spawn:create(lian_move_1,cc.Repeat:create(lian_move_2,3))

	local dui_action_1 = cc.EaseBackInOut:create(cc.MoveBy:create(0.2,cc.p(-108,0)))
	local dui_move_1 = cc.MoveBy:create(0.5,cc.p(50,0))
	local dui_move_2 = cc.Sequence:create(cc.RotateTo:create(0.1,20),cc.RotateTo:create(0.1,-20))
	local dui_action_2 = cc.Spawn:create(dui_move_1,cc.Repeat:create(dui_move_2,3))

	Lian:runAction(cc.Sequence:create(lian_action_1,lian_action_2,cc.RemoveSelf:create(true)))
	Dui:runAction(cc.Sequence:create(dui_action_1,dui_action_2,cc.RemoveSelf:create(true)))

	local BaoZha = display.newSprite("Image/GP/texiao/img_GuangQuan01.png")
	BaoZha:addTo(node)

	local animation = cc.Animation:create()
	for i=2,5 do
		local sprite = display.newSprite("Image/GP/texiao/img_GuangQuan0" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.1)
	local action = cc.Animate:create(animation)
	BaoZha:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),action,cc.RemoveSelf:create(true)))
end

-- start --


--------------------------------
-- 播放炸弹动画
-- @function playZhaDanAction

-- end --
function GamePlayer:playZhaDanAction()
	--炸弹
	local ZhaDan = display.newSprite("Image/GP/texiao/img_ZhaDan.png")
	ZhaDan:pos(display.cx,display.height+ZhaDan:getContentSize().height/2)
	ZhaDan:addTo(self.m_sceneSelf.root,100)

	--爆炸动画
	local function BaoZhaAction()
		ZhaDan:stopAllActions()
		ZhaDan:removeFromParent()

		local BaoZha = display.newSprite("Image/GP/texiao/img_BaoZha_01.png")
		BaoZha:setAnchorPoint(cc.p(0.5,0))
		BaoZha:pos(display.cx, display.cy*0.7)
		BaoZha:addTo(self.m_sceneSelf.root,10)

		ZhaDan = display.newSprite("Image/GP/texiao/tx_ZhaDan.png")
		ZhaDan:pos(display.cx, display.cy*0.85)
		ZhaDan:setScaleX(0.1)
		ZhaDan:addTo(self.m_sceneSelf.root,10)
		ZhaDan:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.6,1)),cc.ScaleTo:create(0.05,0.01,1),cc.RemoveSelf:create(true)))
	
		local animation = cc.Animation:create()
		for i=2,9 do
			local sprite = display.newSprite("Image/GP/texiao/img_BaoZha_0" .. i .. ".png")
			animation:addSpriteFrame(sprite:getSpriteFrame())
		end
		animation:setDelayPerUnit(0.1)
		local action = cc.Animate:create(animation)
		BaoZha:runAction(cc.Sequence:create(action,cc.RemoveSelf:create(true)))

		GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_BOOM)
	end

	local ZhaDan_Action_1 = cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(display.cx,display.cy*0.7)),cc.CallFunc:create(BaoZhaAction))
	local ZhaDan_Action_2 = cc.Repeat:create(cc.RotateBy:create(0.2,100),5)
	
	ZhaDan:runAction(cc.Spawn:create(ZhaDan_Action_1,ZhaDan_Action_2))
end

-- start --


--------------------------------
-- 播放全关特效
-- @function playZhaDanAction

-- end --
function GamePlayer:playQuanGuanAction()
	--全关
	local QuanGuan = display.newSprite("Image/GP/texiao/img_QuanGuan_1.png")
	QuanGuan:setPosition(cc.p(display.cx,display.cy))
	QuanGuan:setScale(0.01)

	local SuoFang = nil
	local DongHua = nil
	local YinShen = nil
	local sequence = nil

	SuoFang = cc.ScaleTo:create(0.2,1)
	local animation = cc.Animation:create()
	for i=2,15 do
		local sprite = display.newSprite("Image/GP/texiao/img_QuanGuan_" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.06)
	DongHua = cc.Animate:create(animation)
	YinShen = cc.FadeOut:create(0.3)
	sequence = cc.Sequence:create(SuoFang,DongHua,YinShen,cc.RemoveSelf:create(true))
	self.m_sceneSelf.root:add(QuanGuan,2001)
	QuanGuan:runAction(sequence)
end

return GamePlayer