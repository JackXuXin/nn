--
-- Author: K
-- Date: 2016-12-27 10:23:09
-- 游戏玩家类 DDZ_GamePlayer
--

local DDZ_GamePlayer = class("DDZ_GamePlayer")

local DDZ_Card = require("app.Games.DDZ.DDZ_Card")
local DDZ_Const = require("app.Games.DDZ.DDZ_Const")
local AvatarConfig = require("app.config.AvatarConfig")
local DDZ_Message = require("app.Games.DDZ.DDZ_Message")
local scheduler = require("framework.scheduler")        --定时器
local DDZ_Audio = require("app.Games.DDZ.DDZ_Audio")
local util = require("app.Common.util")

require("app.Games.DDZ.lg_ddz")

local selectCards = {}	 --触摸选择的牌
local PinningCardInfo = {}  --要管得牌
local TiShiCardInfo = {}  --提示的牌型
local LuTouCardInfo = {}  --已经露头正准备出得牌
local sendPlayersCard = {[1] = {},[2] = {},[3] = {},[4] = {}}   --桌子上 每个玩家打出去的牌
local Jiao_rule = {[1] = {1,2,3},[2] = {1,3,5},[3] = {1,2,3},}  --叫分规则，分别对应3人一副牌，3人2副牌，4人2副牌

local chupaiCard = {} --延迟出的牌
-- local weixinImage = {}



local scoreTab = {
    zero = 0,
	one = 1,
	two = 2,
	three = 3,
}

-- start --

--------------------------------
-- 创建一个玩家
-- @function create
-- @rerutn  玩家对象

-- end --
function DDZ_GamePlayer:create(playerInfo,sceneSelf,seatIndex)
	local bRet = DDZ_GamePlayer.new()
	bRet:init(playerInfo,sceneSelf,seatIndex)
	return bRet
end

-- start --

--------------------------------
-- 构造函数
-- @function ctor

-- end --
function DDZ_GamePlayer:ctor()
	self.m_playerInfo = nil  	--玩家信息
	self.m_UINode = nil 		--展示玩家信息UI的节点
	self.m_Cards = {}     		--玩家手牌
	self.m_sceneSelf = nil 		--游戏场景
	self.m_isTuoGuan = false    --是否开启托管

	self.sortCardBtnFlag = false   -- true代表纵向方向，false代表水平
    -- self.maxCards = nil           --所有的牌  54  108
    self.isDiZhu = nil
 
end

-- start --

--------------------------------
-- 对象初始化
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
function DDZ_GamePlayer:init(playerInfo,sceneSelf,seatIndex)
	self.m_playerInfo = playerInfo
	self.m_sceneSelf  = sceneSelf
	self.m_UINode = cc.uiloader:seekNodeByNameFast(sceneSelf.root, "k_nd_player" .. playerInfo.seat)
	self.seat = playerInfo.seat
	self.seatIndex = seatIndex
	self.m_UINode:setVisible(true)
	self.m_playerInfo.player.name = util.checkNickName(self.m_playerInfo.player.name,10)
	--裁剪多出的名字
	local name_str = self.m_playerInfo.player.name
	--昵称
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_tx_NiCheng"):setString(name_str)
	--金币
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_tx_JinBi"):setString(self.m_playerInfo.player.gold)
	--头像
	self:setTouXiang()

	--隐藏身份
	self:setPlayerIdentity(false)

	--设置准备状态
	-- self:setPlayerReadyState(self.m_playerInfo.player.ready)

	--隐藏不出 不抢 抢地主文字
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChuWenZi"):setVisible(false)

	self:hideQiangDiZhuState()
	-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuQiangWenZi"):setVisible(false)
	-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_QiangDiZhuWenZi"):setVisible(false)
	-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuJiaoWenZi"):setVisible(false)
	-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_JiaoDiZhuWenZi"):setVisible(false)


	--如果是自己 隐藏出牌 抢地主 托管 大不上
	if self.m_playerInfo.seat == 1 then
		self.m_UINode:setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY+100) 
		-- cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_PaiWeiZhi"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY+101) 
		-- cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_ChuPaiWeiZhi"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY+102) 
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setVisible(false) 		--隐藏出牌
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_QiangDiZhuXingWei"):setVisible(false)		--隐藏叫分
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuanQuXiao"):setVisible(false)		--隐藏取消托管
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(false)		--隐藏打不上文字

		--删除按钮监听
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuanQuXiao"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuJiao"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_1"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_2"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_3"):removeAllEventListeners()
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_YaoBuQi"):removeAllEventListeners()
    	--
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "sortCard_Btn"):removeAllEventListeners()

		--按钮监听
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):onButtonClicked(handler(self,self.clickZhunBei))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):onButtonClicked(handler(self,self.clickChuPai))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_TiShi"):onButtonClicked(handler(self,self.clickTiShi))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):onButtonClicked(handler(self,self.clickBuChu))

    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "sortCard_Btn"):onButtonClicked(handler(self,self.sortCardBtnClick))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "sortCard_Btn"):show()
    	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(self.m_UINode, "sortCard_Btn"))

    	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuanQuXiao"):onButtonClicked(handler(self,self.clickTuoGuanQuXiao))
    	--抢地主
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuJiao"):onButtonClicked(handler(self,self.clickBuQiang))
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_1"):onButtonClicked(function ()
    				self:clickQiangDiZhu(Jiao_rule[self.m_sceneSelf.rule_type][1])
    			end)
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_2"):onButtonClicked(function ()
    				self:clickQiangDiZhu(Jiao_rule[self.m_sceneSelf.rule_type][2])
    			end)
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_3"):onButtonClicked(function ()
    				self:clickQiangDiZhu(Jiao_rule[self.m_sceneSelf.rule_type][3])
    			end)
    	self:setJiaoBtn()      --修改叫分按钮纹理
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_YaoBuQi"):onButtonClicked(handler(self,self.clickBuChu))
    else
    	--隐藏倒计时
    	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):setVisible(false)
	end
end

-------------------------------------------------------表情------------------------------------------------------------------
function DDZ_GamePlayer:getHeadIconPos(seat)
	-- local x = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_TouXiang"):getPositionX()
	-- local y = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_TouXiang"):getPositionY()
	local x = self.m_UINode:getPositionX()
	local y = self.m_UINode:getPositionY()
	print("getHeadIconPosx",x)
	print("getHeadIconPosy",y)
	-- local pos = self.m_sceneSelf.root:convertToWorldSpace(cc.p(x, y))
	-- print("posx",pos.x)
	-- print("posy",pos.y)
	return cc.p(x,y)
end
--获取头像的中心位置

function DDZ_GamePlayer:setManager(flag)
	if flag then
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_LostLine"):setVisible(true)
	else
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_LostLine"):setVisible(false)
	end
	
end
 	
-------------------------------------------------------------------------------------------------------------------------



function DDZ_GamePlayer:setJiaoBtn()
	if self.m_sceneSelf.rule_type == 2 then
		local button_2 = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_2")
		button_2:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/Image/DDZ/btn_jiao_3_1.png")
        button_2:setButtonImage(cc.ui.UIPushButton.PRESSED, "res/Image/DDZ/btn_jiao_3_2.png")
        button_2:setButtonImage(cc.ui.UIPushButton.DISABLED, "res/Image/DDZ/btn_jiao_3_3.png")

        local button_3 = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_3")
		button_3:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/Image/DDZ/btn_jiao_5_1.png")
        button_3:setButtonImage(cc.ui.UIPushButton.PRESSED, "res/Image/DDZ/btn_jiao_5_2.png")
        button_3:setButtonImage(cc.ui.UIPushButton.DISABLED, "res/Image/DDZ/btn_jiao_5_3.png")
		
	else
		local button_2 = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_2")
		button_2:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/Image/DDZ/btn_jiao_2_1.png")
        button_2:setButtonImage(cc.ui.UIPushButton.PRESSED, "res/Image/DDZ/btn_jiao_2_2.png")
        button_2:setButtonImage(cc.ui.UIPushButton.DISABLED, "res/Image/DDZ/btn_jiao_2_3.png")

        local button_3 = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_3")
		button_3:setButtonImage(cc.ui.UIPushButton.NORMAL, "res/Image/DDZ/btn_jiao_3_1.png")
        button_3:setButtonImage(cc.ui.UIPushButton.PRESSED, "res/Image/DDZ/btn_jiao_3_2.png")
        button_3:setButtonImage(cc.ui.UIPushButton.DISABLED, "res/Image/DDZ/btn_jiao_3_3.png")
	end
end



--刷新玩家分数
--设置游戏当前底分
function DDZ_GamePlayer:setGold(gold)
    self.m_playerInfo.player.gold = gold
    cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_tx_JinBi"):setString(self.m_playerInfo.player.gold)
end
--***************************************************  按钮的回调事件方法  **************************************************************************

-- start --

--------------------------------
-- 玩家行为的按钮监听回调

-- end --

function DDZ_GamePlayer:clickZhunBei()  	--准备
	print("点击了一次准备按钮")

	-- util.requestBtn:hide()--隐藏邀请好友按钮
    -- DDZ_Message.dispatchGame("room.ReadyReq")
    DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_READY)
end
function DDZ_GamePlayer:FapaiOver() --发牌结束
	print("发牌结束")
	DDZ_Message.sendMessage("DDZ.DealOver", {
		session = self.m_sceneSelf.tableSession,
	})
end
function DDZ_GamePlayer:clickChuPai()  		--出牌
	print("点击了一次出牌按钮")

	-- dump(LuTouCardInfo,"出的牌是")
	-- dump(self:changeCard(LuTouCardInfo),"出的牌是")

	if #LuTouCardInfo == 0 then
		return
	end
	DDZ_Message.sendMessage("DDZ.Out", {
		session = self.m_sceneSelf.tableSession,
		seat  = self.m_sceneSelf.seatIndex,
		cards = self:changeCard(LuTouCardInfo),
		remain = 0,
		bei = 0,
	},DDZ_Const.REQUEST_INFO_04)
	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
end
function DDZ_GamePlayer:changeCard(card)
	local cardTab = {}
	for i=1,#card do
		table.insert(cardTab,#cardTab+1,card[i].num+card[i].color*16)
	end
	return cardTab
end


function DDZ_GamePlayer:clickTiShi()  		--提示
	print("点击了一次提示按钮")

	self:setPlayerCardAllSuoTou()

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
	if #PinningCardInfo == 0  then


		local TiQuCard = {}
		for k,v in ipairs(self.m_Cards) do
			table.insert(TiQuCard,{num = v:getCardNum(),color = v:getCardColor()})
		end
		self.m_sceneSelf:SortCards(1,TiQuCard)
		TiQuCard = cleaeBomp(TiQuCard)

		--提取
		local cards = DDZ_findSequence(PinningCardInfo,TiQuCard)

		if cards == nil or #cards == 0 or DDZ_GetCardType(cards) == "errorcardtype" then
			dump(cards,"没有找到智能提取的牌")
			--当提取不到顺子、连队时，取不为炸弹的最小的数
			cards = {}
			for i,v in ipairs(TiQuCard) do
				if v.num == TiQuCard[#TiQuCard].num then
					table.insert(cards,v)
				end
			end
		end

		dump(cards,"智能提取的牌")
		self:XZPlayerCardLuTuo(cards,self.m_Cards)
	    for k,v in ipairs(self.m_Cards) do
	    	v:setColor(DDZ_Const.CARD_RELEASE_COLOR)

	    	for kk,vv in ipairs(cards) do
	    		if v:getCardNum() == vv.num and v:getCardColor() == vv.color and v.index == vv.index then
	    			if not self.sortCardBtnFlag then
		        		v:setCardLuTou()
		        	else
		        		v:setCardLuTou(1)
		        	end
	    			-- print("牌露头")
	    			break
	    		end
	    	end
	    end
	else
		local TiShiCard = TiShiCardInfo[TiShiCardInfo.TiShiIndex]
		dump(TiShiCard,"点击提示给我的牌index是" .. TiShiCardInfo.TiShiIndex)
		TiShiCardInfo.TiShiIndex = TiShiCardInfo.TiShiIndex + 1
		if TiShiCardInfo.TiShiIndex > #TiShiCardInfo then
			TiShiCardInfo.TiShiIndex = 1
		end

		self:setPlayerCardLuTuo(TiShiCard)
		
	end
	self:addLuTouCards()
end

function DDZ_GamePlayer:clickBuChu()  		--不出 和 要不起
	print("点击了一次不出按钮")
	self:setPlayerCardAllSuoTou()
	DDZ_Message.sendMessage("DDZ.Pass", {
		session = self.m_sceneSelf.tableSession,
		seat  = self.m_sceneSelf.seatIndex,
	},DDZ_Const.REQUEST_INFO_05)

	if cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):isVisible() then
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):stopAllActions()
	end

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
end

function DDZ_GamePlayer:clickTuoGuanQuXiao()  		--托管取消
	print("点击了一次托管取消按钮")

	DDZ_Message.sendMessage("DDZ.Manage", {
		session = self.m_sceneSelf.tableSession,
		seat  = self.m_sceneSelf.seatIndex,
		state = 0,
	},DDZ_Const.REQUEST_INFO_03)

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
end

function DDZ_GamePlayer:clickBuQiang()  		--不抢
	print("点击了一次不抢按钮")

	DDZ_Message.sendMessage("DDZ.Call", {
		session = self.m_sceneSelf.tableSession,
		seat  = self.m_sceneSelf.seatIndex,
		score = 0,
	},DDZ_Const.REQUEST_INFO_001)

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
end

function DDZ_GamePlayer:clickQiangDiZhu(score)  		--抢地主
	print("点击了一次抢地主按钮",score)

	DDZ_Message.sendMessage("DDZ.Call", {
		session = self.m_sceneSelf.tableSession,
		seat  = self.m_sceneSelf.seatIndex,
		score = score,
	})

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
	--
	-- self:hideAllJiaoBtn()
end

-- function DDZ_GamePlayer:hideAllJiaoBtn()
-- 	if self.m_playerInfo.seat == 1 then
-- 		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuJiao"):setVisible(false)
-- 		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_1"):setVisible(false)
-- 		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_2"):setVisible(false)
-- 		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_Jiao_3"):setVisible(false)
-- 	end
-- end

-- function DDZ_GamePlayer:clickYaoBuQi()  --要不起 = 不出

-- end

--***************************************************  排序相关方法  **************************************************************************

function DDZ_GamePlayer:setSortCardBtnVisible(flag)  		
	if flag then
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "sortCard_Btn"):setVisible(true)
	else
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "sortCard_Btn"):setVisible(false)
	end
	-- self.maxCards = maxCardNum
end

--排序按钮回调
function DDZ_GamePlayer:sortCardBtnClick()  
	
	self.sortCardBtnFlag = not self.sortCardBtnFlag
	self:updateCardPostion()
	self:setPlayerCardAllSuoTou()
	-- self:updateChupaiNode()
	-- for k,v in pairs(self.m_Cards) do
	-- 	if self.sortCardBtnFlag then
	-- 		v:setCardSelectState(1)
	-- 	else
	-- 		v:setCardSelectState(0)
	-- 	end
	-- end
	
	
end
--当点击排序按钮时，其他相关节点位置发生的改动
function DDZ_GamePlayer:updateChupaiNode()

	if self.sortCardBtnFlag then
		if self.m_playerInfo.seat == 1 then
			local card_Num_Tab = {}
			local card_Num = 0
			local sum = 0
			for k,v in pairs(self.m_Cards) do
				if v:getCardNum() ~= card_Num then
					card_Num = v:getCardNum()
					sum = sum + 1
					card_Num_Tab[sum] = 1
				else
					card_Num_Tab[sum] = card_Num_Tab[sum]+1
				end
			end

			local maxCard_Num = 0
			for k,v in pairs(card_Num_Tab) do
				if v> maxCard_Num then
					maxCard_Num = v
				end
			end
			local pai_y = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_PaiWeiZhi"):getPositionY()
			local pos_y =  pai_y + (DDZ_Const.CATD_HEIGHT/2) *self.m_sceneSelf.cardScale + (maxCard_Num-1) * DDZ_Const.CARD_HEIGHT_DISTANCE - 140

			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setPosition(590,pos_y)	
			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setLocalZOrder(10000)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_QiangDiZhuXingWei"):setPositionY(pos_y)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_JiaoDiZhu_XingWei"):setPositionY(pos_y)

			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_DengDaiZhunBei"):setPositionY(pos_y-45)

			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):setPositionY(pos_y-45+88)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChuWenZi"):setPositionY(pos_y)
			
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_ChuPaiWeiZhi"):setPositionY(pos_y-45+285)
			
			

			
		end
	else
		if self.m_playerInfo.seat == 1 then
			local pos_y = 45
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setPosition(590,pos_y)	
			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setLocalZOrder(10000)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_QiangDiZhuXingWei"):setPositionY(pos_y)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_JiaoDiZhu_XingWei"):setPositionY(pos_y)

			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "img_DengDaiZhunBei"):setPositionY(780)
			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):setPositionY(88)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChuWenZi"):setPositionY(205)
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_ChuPaiWeiZhi"):setPositionY(285)

		end
	end

end

function DDZ_GamePlayer:updateCardPostion()
	print("发牌的玩家椅子号 = " .. self.m_playerInfo.seat)
	print("pai",#self.m_Cards)
	local scale = 0.9
	

	if self.m_playerInfo.seat == 1 then  --刷新自己的牌
		if self.sortCardBtnFlag then
			
			
			--纵向排序
			DDZ_Const.CARD_WIDTH_DISTANCE = 55
			DDZ_Const.CARD_HEIGHT_DISTANCE = 40
			--记录下相同牌值的牌的数目
			local card_Num_Tab = {}
			local card_Num = 0
			local sum = 0
			for k,v in pairs(self.m_Cards) do
				if v:getCardNum() ~= card_Num then
					card_Num = v:getCardNum()
					sum = sum + 1
					card_Num_Tab[sum] = 1
				else
					card_Num_Tab[sum] = card_Num_Tab[sum]+1
				end
			end
			local pos = self:getCardSortPos(#card_Num_Tab,scale,"k_nd_player" .. self.m_playerInfo.seat .."_PaiWeiZhi")
			-- --牌的起始位置
			-- local card_start_posX = pos.x - ((sum-1)*DDZ_Const.CARD_WIDTH_DISTANCE + DDZ_Const.CARD_WIDTH*self.m_sceneSelf.cardScale)/2
			-- --牌的终止位置
			-- local card_end_posX = pos.x + ((sum-1)*DDZ_Const.CARD_WIDTH_DISTANCE + DDZ_Const.CARD_WIDTH*self.m_sceneSelf.cardScale)/2

			
			local card_index = 1
			for i=1,#card_Num_Tab do
				for j=1,card_Num_Tab[i] do
					local cardPosX = pos.x + (i-1)*DDZ_Const.CARD_WIDTH_DISTANCE
					local cardPosY = pos.y + (card_Num_Tab[i]-j-2) * DDZ_Const.CARD_HEIGHT_DISTANCE+90
					self.m_Cards[card_index]:setPosition(cc.p(cardPosX,cardPosY))
					self.m_Cards[card_index]:setScale(self.m_sceneSelf.cardScale)
					self.m_Cards[card_index]:setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY+100+card_index)
					self.m_Cards[card_index]:setVisible(true)

					card_index = card_index + 1
				end
			end
			local card_index = 1
			for i=1,#card_Num_Tab do
				for j=1,card_Num_Tab[i] do
					-- local cardPosX = card_start_posX + i * DDZ_Const.CARD_WIDTH * self.m_sceneSelf.cardScale
					
					-- print("输出当前牌的坐标：",cardPosX,cardPosY)
					
					local rect_x = self.m_Cards[card_index]:getPositionX() - DDZ_Const.CARD_WIDTH/2 * self.m_sceneSelf.cardScale
					local rect_y = self.m_Cards[card_index]:getPositionY() - DDZ_Const.CATD_HEIGHT/2 * self.m_sceneSelf.cardScale
					local rect_width = DDZ_Const.CARD_WIDTH_DISTANCE
					local rect_height = DDZ_Const.CARD_HEIGHT_DISTANCE
					if card_index~=#self.m_Cards then
						if j~= card_Num_Tab[i] then
							--不是最下面一行情况y的坐标
							rect_y = self.m_Cards[card_index]:getPositionY() + DDZ_Const.CATD_HEIGHT/2 * self.m_sceneSelf.cardScale - DDZ_Const.CARD_HEIGHT_DISTANCE
							local next_card = nil
							local next_index = nil
							if card_Num_Tab[i+1] then
								next_index = card_Num_Tab[i+1]
							else
								next_index = 1000
							end
							if self.m_Cards[next_index+card_index] then
								next_card = self.m_Cards[next_index+card_index]
							end
							--获取最近的一张牌
							if next_card then
								local z = 1
								while next_card ~= nil and next_card:getPositionY() ~= self.m_Cards[card_index]:getPositionY() and next_index ~= 1000 do
									
									if card_Num_Tab[i+1+z] then
										next_index = next_index + card_Num_Tab[i+1+z]
									else
										next_index = 1000
										break
									end
									if self.m_Cards[next_index+card_index] then
										next_card = self.m_Cards[next_index+card_index]
									else
										next_card = nil
										break
									end
									z=z+1
								end
								if next_card then
									--todo
									-- print("第",card_index,"张")
									-- print("next_card_x",next_card:getPositionX())
									-- print("self.m_Cards_x",self.m_Cards[card_index]:getPositionX())
									-- print("next_card_y",next_card:getPositionY())
									-- print("self.m_Cards_y",self.m_Cards[card_index]:getPositionY())
									if next_card:getPositionY() == self.m_Cards[card_index]:getPositionY() then
										if next_card:getPositionX()-self.m_Cards[card_index]:getPositionX() >= DDZ_Const.CARD_WIDTH* self.m_sceneSelf.cardScale then
											rect_width = DDZ_Const.CARD_WIDTH* self.m_sceneSelf.cardScale
										else
											rect_width = next_card:getPositionX()-self.m_Cards[card_index]:getPositionX()
										end
									else
										rect_width = DDZ_Const.CARD_WIDTH* self.m_sceneSelf.cardScale
									end
								else
									rect_width = DDZ_Const.CARD_WIDTH* self.m_sceneSelf.cardScale
								end
							else
							    --只要不是最后一行，都将宽设置为牌宽，后面在触摸事件中通过优先级区分出最上面的那一层
								rect_width = DDZ_Const.CARD_WIDTH* self.m_sceneSelf.cardScale
							end
						else
							--最下面一行
							rect_height = DDZ_Const.CATD_HEIGHT * self.m_sceneSelf.cardScale
						end
					else
						--最后一张牌
						rect_width  = DDZ_Const.CARD_WIDTH* self.m_sceneSelf.cardScale
						rect_height = DDZ_Const.CATD_HEIGHT * self.m_sceneSelf.cardScale
					end

					-- print("第",card_index,"张")
					-- print("self.m_Cards_x",self.m_Cards[card_index]:getPositionX())
					-- print("self.m_Cards_y",self.m_Cards[card_index]:getPositionY())
					-- print("触摸区域")
					-- print("rect_x:",rect_x)
					-- print("rect_y:",rect_y)
					-- print("rect_width:",rect_width)
					-- print("rect_height:",rect_height)

					
					self.m_Cards[card_index].m_touchRect = cc.rect(rect_x,rect_y,
						rect_width,rect_height)
					card_index = card_index+1

				end
			end
		else
			-- DDZ_Const.CARD_WIDTH_DISTANCE = 25

			DDZ_Const.CARD_WIDTH_DISTANCE = self:getCardWidthDistance()

			local pos = self:getCardSortPos(#self.m_Cards,scale,"k_nd_player" .. self.m_playerInfo.seat .."_PaiWeiZhi") 
			-- pos.x = pos.x + 400
			     
			--横向
			for k,v in ipairs(self.m_Cards) do
				if not self.sortCardBtnFlag then
	        		v:setCardSuoTou()
	        	else
	        		v:setCardSuoTou(1)
	        	end
				v:setScale(scale)
				v:setPosition(cc.p(pos.x,pos.y))
				v:setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY+100+pos.x)
				pos.x = pos.x + DDZ_Const.CARD_WIDTH_DISTANCE
				v:setVisible(true)

				--设置触摸范围
				if v == self.m_Cards[#self.m_Cards] then  --最后一张牌的触摸范围是整张牌
					v.m_touchRect = cc.rect(v:getPositionX()-DDZ_Const.CARD_WIDTH/2*scale,v:getPositionY()-DDZ_Const.CATD_HEIGHT/2*scale,
						DDZ_Const.CARD_WIDTH*scale,DDZ_Const.CATD_HEIGHT*scale)
				else
					v.m_touchRect = cc.rect(v:getPositionX()-DDZ_Const.CARD_WIDTH/2*scale,v:getPositionY()-DDZ_Const.CATD_HEIGHT/2*scale,
						DDZ_Const.CARD_WIDTH_DISTANCE,DDZ_Const.CATD_HEIGHT*scale)
				end
			end
		end
	else  --刷新其他玩家的牌
		DDZ_Const.CARD_WIDTH_DISTANCE = 25
		local pos = self:getCardSortPos(#self.m_Cards,scale,"k_nd_player" .. self.m_playerInfo.seat .."_PaiWeiZhi")
		for k,v in ipairs(self.m_Cards) do
			v:setScale(0.5)
			v:setPosition(pos)
			v:setLocalZOrder(pos.y)
			-- print("pos.y",pos.y)
			pos.y = pos.y - 0.5
			v:setVisible(true)
			
		end
	end
	--设置地主图标
	self:setDiZhuIcon()
	--更新其他按钮的位置
	self:updateChupaiNode()
end
function DDZ_GamePlayer:setDiZhuIcon(cards)
	if cards then
		-- dump(cards, "cards")
		print("#cards",#cards)
		for i=1,#cards do
			if self.m_playerInfo.seat ~= 2 then
				if self.isDiZhu and i==#cards then
					cards[i]:ShowDiZu(true)
				else
					cards[i]:ShowDiZu(false)
				end
			else
				if self.isDiZhu and i==1 then
					cards[i]:ShowDiZu(true)
				else
					cards[i]:ShowDiZu(false)
				end
			end
		end
	else
		if self.m_playerInfo.seat == 1 then
			for i=1,#self.m_Cards do
				if self.isDiZhu and i==#self.m_Cards then
					self.m_Cards[i]:ShowDiZu(true)
				else
					self.m_Cards[i]:ShowDiZu(false)
				end
			end
		end
	end
end
function DDZ_GamePlayer:getCardWidthDistance()
	local width = display.width - 40 - DDZ_Const.CARD_WIDTH*self.m_sceneSelf.cardScale
	local card_width = width/(#self.m_Cards-1)
	if card_width>55 then
		return 55
	end
	return card_width
end
--时刻更新牌的数目
function DDZ_GamePlayer:updateCardNum()

end




--***************************************************  排序相关方法  **************************************************************************




--***************************************************  出牌的相关方法  **************************************************************************

-- start --

--------------------------------
-- 出牌动画
-- @function runChuPaiAction
-- @param table cards 打出去的手牌

-- end --
function DDZ_GamePlayer:runChuPaiAction(cards,isRunAction,PaiXing,curCard)
	-- dump(cards, "runChuPaiAction:")
	print("牌：：",cards[1].m_num)
	print("weizhi ",self.m_playerInfo.seat)
	isRunAction = false
	local scale = 0.6
	local time = 0
	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi"):setVisible(true)

	local pos = self:getCardSortPos(#cards,scale,"k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi")
	if self.m_playerInfo.seat == 1 then
		self.m_sceneSelf:SortCards(1,cards)
		local width = ((#cards-1) * 20) + DDZ_Const.CARD_WIDTH * scale
		pos.x = 0 - width / 2 - DDZ_Const.CARD_WIDTH * scale / 2+DDZ_Const.CARD_WIDTH/2
		for k,v in ipairs(cards) do
			if isRunAction then
				local moveAction = cc.MoveTo:create(time,pos)
				pos.x = pos.x + 20
				local scaleAction = cc.ScaleTo:create(time,scale)
				v:runAction(cc.EaseSineIn:create(cc.Spawn:create(moveAction,scaleAction)))
			else

				
				local card = DDZ_Card:create(v.num,v.color)
				card:setScale(scale)
				card:setPosition(cc.p(pos.x,0))
				card:setVisible(true)
				card:setLocalZOrder(k+1000)
				
				cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_ChuPaiWeiZhi"):add(card)
				table.insert(sendPlayersCard[self.m_playerInfo.seat],card)
		

				-- v:setScale(scale)
				-- v:setPosition(cc.p(pos.x,0))
				-- v:setVisible(true)
				-- v:setLocalZOrder(k+1000)
				
				pos.x = pos.x + 20
			end
			-- print("self.m_playerInfo.seat::",self.m_playerInfo.seat)
			-- print("posX:",v:getPositionX())
			-- print("posY:",v:getPositionY())
			-- print("visbile",v:isVisible())
			-- print("出的牌信息Color：：",v:getCardColor())
			-- print("出的牌信息Num：：",v:getCardNum())
			-- print("层级：",v:getLocalZOrder())
		end
	elseif self.m_playerInfo.seat == 2 then
		local width = ((#cards-1) * 20) + DDZ_Const.CARD_WIDTH * scale
		pos.x = 0 - width / 2 - DDZ_Const.CARD_WIDTH * scale / 2+DDZ_Const.CARD_WIDTH/2
		self.m_sceneSelf:SortCards(2,cards)
		for k,v in ipairs(cards) do
			if isRunAction then
				local moveAction = cc.MoveTo:create(time,pos)
				pos.x = pos.x - DDZ_Const.CARD_WIDTH_DISTANCE * scale
				local scaleAction = cc.ScaleTo:create(time,scale)
				v:runAction(cc.EaseSineIn:create(cc.Spawn:create(moveAction,scaleAction)))
			else
				local card = DDZ_Card:create(v.num,v.color)
				card:setScale(scale)
				-- card:setPosition(pos)
				card:setPosition(cc.p(pos.x,0))
				card:setVisible(true)
				card:setLocalZOrder(1000-k)
				-- cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_BeiJing"):add(card)
				cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi"):add(card)
				table.insert(sendPlayersCard[self.m_playerInfo.seat],card)

				-- v:setScale(scale)
				-- v:setPosition(pos)
				-- v:setVisible(true)
				-- v:setLocalZOrder(1000-k)
				pos.x = pos.x - 20
			end
			-- print("self.m_playerInfo.seat::",self.m_playerInfo.seat)
			-- print("posX:",v:getPositionX())
			-- print("posY:",v:getPositionY())
			-- print("visbile",v:isVisible())
			-- print("出的牌信息Color：：",v:getCardColor())
			-- print("出的牌信息Num：：",v:getCardNum())
			-- print("层级：",v:getLocalZOrder())
		end
	else
		if self.m_playerInfo.seat == 4 then
			local width = ((#cards-1) * 20) + DDZ_Const.CARD_WIDTH * scale
			pos.x = 0 - width / 2 - DDZ_Const.CARD_WIDTH * scale / 2+DDZ_Const.CARD_WIDTH/2
		else
			pos.x = 0
		end
		
		self.m_sceneSelf:SortCards(1,cards)

		for k,v in ipairs(cards) do
			if isRunAction then
				local moveAction = cc.MoveTo:create(time,pos)
				pos.x = pos.x + DDZ_Const.CARD_WIDTH_DISTANCE * scale
				local scaleAction = cc.ScaleTo:create(time,scale)
				v:runAction(cc.EaseSineIn:create(cc.Spawn:create(moveAction,scaleAction)))
			else
				local card = DDZ_Card:create(v.num,v.color)
				card:setScale(scale)
				-- card:setPosition(pos)
				card:setPosition(cc.p(pos.x,0))
				card:setVisible(true)
				card:setLocalZOrder(1000+k)
				-- cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_BeiJing"):add(card)
				cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi"):add(card)
				table.insert(sendPlayersCard[self.m_playerInfo.seat],card)

				-- v:setScale(scale)
				-- v:setPosition(pos)
				-- v:setVisible(true)
				-- v:setLocalZOrder(1000+k)
				pos.x = pos.x + 20
			end
			-- print("self.m_playerInfo.seat::",self.m_playerInfo.seat)
			-- print("posX:",v:getPositionX())
			-- print("posY:",v:getPositionY())
			-- print("visbile",v:isVisible())
			-- print("出的牌信息Color：：",v:getCardColor())
			-- print("出的牌信息Num：：",v:getCardNum())
			-- print("层级：",v:getLocalZOrder())
		end
	end
	self:setDiZhuIcon(sendPlayersCard[self.m_playerInfo.seat])
	chupaiCard = {}
	chupaiCard = copy_table(cards)
	
	--延时播放动画
	scheduler.performWithDelayGlobal(function()
		DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_OUT_CARD)

		if PaiXing then
			local soundName = "DDZ_SOUND_"
			if self.m_playerInfo.player.sex == 1 then  --女
				soundName = soundName .. "FEMALE_"
			else  --男
				soundName = soundName .. "MALE_"
			end
		
			--获取出牌的牌型
			if PaiXing == "bomb" or PaiXing == "bomb_5"  or PaiXing == "bomb_6" or PaiXing == "bomb_7" or PaiXing == "bomb_8" then        								---炸弹
				self:playZhaDanAction()
		
				soundName = soundName .. "BOMB"
			elseif PaiXing == "sequence" then       						---顺子
				self:playShunZiAction(#chupaiCard,scale)
		
				soundName = soundName .. "SEQUENCES"
			elseif PaiXing == "doublesequence" then  						---连对
				self:playLianDuiAction(#chupaiCard,scale)
		
				soundName = soundName .. "AABBCC"
			elseif PaiXing == "triblesequence" or 
				   PaiXing == "planeInSingle" or
				   PaiXing == "planeInDouble" then 		  				---飞机 飞机带单 飞机带对
	
				self:playFeiJiAction(#chupaiCard,scale)
		
				soundName = soundName .. "AAABBB"
			elseif PaiXing == "single" then  								---单牌
				soundName = soundName .. "SINGLE_" .. tostring(chupaiCard[1].num)
			elseif PaiXing == "double" then 								---对子
				soundName = soundName .. "DOUBLE_" .. tostring(chupaiCard[1].num)
			elseif PaiXing == "trible" then 								---三张
				soundName = soundName .. "AAA"
			elseif PaiXing == "rocket" or PaiXing == "rocket_3" then 								---火箭
				self:playHuoJianAction()
		
				soundName = soundName .. "ROCKET"
			elseif PaiXing == "tribleandsingle" then 						---三带1
				soundName = soundName .. "AAAB"
			elseif PaiXing == "tribleanddouble" then 						---三带2
				soundName = soundName .. "AAABB"
			elseif PaiXing == "bombandtwosingle" or 
				   PaiXing == "bombandtwodouble" then 						---四带二单	四带俩对
	
				soundName = soundName .. "AAAABB"
			end

			print("播放资源的路径 = " .. soundName)

			if PaiXing ~= "single" and PaiXing ~= "double" then
				for k,v in ipairs(sendPlayersCard) do
					if k ~= self.m_playerInfo.seat then
						if #v ~= 0 then
							if self.m_playerInfo.player.sex == 1 then  --女
								DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_YOU)
							else  --男
								DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_YOU)
							end
							return 
						end
					end
				end

				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath[soundName])

				-- if #curCard ~= 0 then
				-- 	if self.m_playerInfo.player.sex == 1 then  --女
				-- 		DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_YOU)
				-- 	else  --男
				-- 		DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_YOU)
				-- 	end
				-- else
				-- 	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath[soundName])
				-- end
			else
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath[soundName])
			end
		end
	end, time)
end

-- start --

--------------------------------
-- 出牌
-- @function ChuPai
-- @param table cards 打出去的手牌信息

-- end --
function DDZ_GamePlayer:ChuPai(cards,curCard,card_Num_web)
	-- dump("DDZ_GamePlayer:ChuPai:",cards)
	-- print(#cards)
	-- print(#curCard)
	PinningCardInfo = {}  --要管的牌
	TiShiCardInfo = {}  --提示的牌型
	LuTouCardInfo = {}  --已经露头正准备出得牌

	for k,v in ipairs(sendPlayersCard[self.m_playerInfo.seat]) do
		if v~=nil and type(v) == "userdata" then
			v:removeFromParent()
			v = nil
		end
	end

	sendPlayersCard[self.m_playerInfo.seat] = {}

	if #cards == 0 then  --不出
--		sendPlayersCard[self.m_playerInfo.seat] = {}
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChuWenZi"):setVisible(true) --显示不出
		if self.m_playerInfo.seat == 1 then  --隐藏大不上文字
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(false)
		end

		--播放不出音效
		if self.m_playerInfo.player.sex == 1 then  --女
			DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_NO)
		else
			DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_NO)
		end

		return 
	end

	--从大到小排序 出的牌信息
	self.m_sceneSelf:SortCards(1,cards)

	--获取到要出的牌 存放到 sendPlayersCard[self.m_playerInfo.seat]
	if self.m_playerInfo.seat == 1 then
		-- dump(cards,"cards::::")
		-- for k,v in ipairs(cards) do
		-- 	local card = DDZ_Card:create(v.num,v.color)
		-- 	card:setScale(0.1)
		-- 	-- card:setPosition(cc.p(self.m_UINode:getPosition()))
		-- 	-- cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_ChuPaiWeiZhi"):setVisible(true)
		-- 	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player1_ChuPaiWeiZhi"):add(card)
		-- 	table.insert(sendPlayersCard[self.m_playerInfo.seat],card)
		-- end
		if card_Num_web ~= #self.m_Cards then
			for k,v in ipairs(cards) do
				for kk,vv in ipairs(self.m_Cards) do
					if v.num == vv:getCardNum() and v.color == vv:getCardColor() then
						-- table.insert(sendPlayersCard[self.m_playerInfo.seat],vv)
						vv:setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY-1)
						vv:setColor(DDZ_Const.CARD_RELEASE_COLOR)
						vv:removeFromParent()
						vv = nil
						table.remove(self.m_Cards,kk)
						break
					end
				end
			end
		end
	else
		for k,v in ipairs(cards) do
			-- local card = DDZ_Card:create(v.num,v.color)
			-- card:setScale(0.1)
			-- card:setPosition(cc.p(self.m_UINode:getPosition()))
			-- cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_BeiJing"):add(card)
			-- table.insert(sendPlayersCard[self.m_playerInfo.seat],card)

			--删除牌
			-- print("删除了一张 index = " .. #self.m_Cards .. "的牌")
			if self.m_Cards[#self.m_Cards] then
				self.m_Cards[#self.m_Cards]:removeFromParent()
				self.m_Cards[#self.m_Cards] = nil
			end
			
		end
	end

	local PaiXing = DDZ_GetCardType(cards)

	--执行出牌动画
	self:runChuPaiAction(cards,true,PaiXing,curCard)

	if self.m_playerInfo.seat == 1 then
		-- self:updatePosition() --重新排序位置
		self:updateCardPostion()
	end
end

-- start --

--------------------------------
-- 添加已经露头要准备出的牌 判断是否能大过上家
-- @function addLuTouCard

-- end --
function DDZ_GamePlayer:addLuTouCards()
	LuTouCardInfo = {}

	for k,v in ipairs(self.m_Cards) do
		if v:isCardLuTou() then
			table.insert(LuTouCardInfo,{num = v:getCardNum(),color = v:getCardColor()})
		end
	end

	if #LuTouCardInfo == 0 then
		print("没有选择要出的牌禁用了出牌按钮")
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):setButtonEnabled(false)
		return 
	end
	-- dump(LuTouCardInfo, "选中的牌LuTouCardInfo：")
	-- dump(PinningCardInfo, "PinningCardInfo：")
	if #PinningCardInfo ~= 0 then
		if DDZ_cardCompare(LuTouCardInfo,PinningCardInfo) then
			print("选择的牌可以出开启了出牌按钮")
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):setButtonEnabled(true)
		else
			print("选择的牌不可以出禁用了出牌按钮")
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):setButtonEnabled(false)
		end
	else
		if DDZ_GetCardType(LuTouCardInfo) ~= "errorcardtype" then    --如果没有要去管得牌 并且 选择的牌型是正确的
			print("没有需要管得牌选择的牌型是正确的开启了出牌按钮")
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):setButtonEnabled(true)
		else
			print("没有需要管得牌选择的牌型是错误的禁用了出牌按钮")
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ChuPai"):setButtonEnabled(false)
		end
	end
end

function DDZ_GamePlayer:hideAllchupaiState()
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChuWenZi"):setVisible(false)
	
end
-- start --
function DDZ_GamePlayer:hideGameXingWei()
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setVisible(false)
end

function DDZ_GamePlayer:hideDaojishi()
	if cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai") then
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):setVisible(false)
	end
	
end
--------------------------------
-- 清理上次出的牌
-- @function clearLastCards

-- end --
function DDZ_GamePlayer:clearLastCards()
	print("self.m_playerInfo.seat",self.m_playerInfo.seat)
	-- dump("self.m_playerInfo.seat",self.m_playerInfo[self.m_playerInfo.seat])
	if #sendPlayersCard[self.m_playerInfo.seat]~=0 then
	
		for k,v in ipairs(sendPlayersCard[self.m_playerInfo.seat]) do
			print(k,v)
		end
	end
	print(#sendPlayersCard[self.m_playerInfo.seat])
	if #sendPlayersCard[self.m_playerInfo.seat] == 0 then
		--隐藏不出
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuChuWenZi"):setVisible(false)
	else
		--删除上次出的牌
		for k,v in ipairs(sendPlayersCard[self.m_playerInfo.seat]) do
			if v~=nil and type(v) == "userdata" then
				v:removeFromParent()
				v = nil
			end
		end

		sendPlayersCard[self.m_playerInfo.seat] = {}
	end
end

-- start --

--------------------------------
-- 是否正在出牌
-- @function isShowChuPai

-- end --

function DDZ_GamePlayer:isShowChuPai()
	return cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):isVisible()
end

-- start --

--------------------------------
-- 显示出牌
-- @function showChuPai
-- @param number time  --倒计时时间

-- end --
function DDZ_GamePlayer:showChuPai(time,cards)
	if cards ~= nil then
		PinningCardInfo = cards
	end

	-- dump(PinningCardInfo,"需要我管得牌")

	--获取提示牌型
	TiShiCardInfo = self:getTiShiPaiXing()
	if #TiShiCardInfo == 0 then    --没有牌能大过桌子上得牌
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_YaoBuQi"):setVisible(true)
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_YaoDeQi"):setVisible(false)

		--没有能大过桌子上的牌3秒后自动不出
		if not self:isTuoGuanEnabled() then
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):performWithDelay(handler(self,self.clickBuChu), 3)
		end

		-- 禁用屏蔽点击 显示 大不过
		self:setPlayerCardTouchEnabled(false)
	else
		self:addLuTouCards()

		if #PinningCardInfo == 0 then  --桌子上没有需要去管得牌 禁用不出按钮
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setButtonEnabled(false)
		end

		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_YaoBuQi"):setVisible(false)
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_YaoDeQi"):setVisible(true)
	end

	local timeStr = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_ChuPaiDaoJiShi")
	if self:isTuoGuanEnabled() then
		time = 3
	end
	timeStr:setString(tostring(time))

	local function onDaoJiShi(dt)
		local num = tonumber(timeStr:getString()) - 1
		timeStr:setString(tostring(num))

		--播放倒计时音效
		if num < 4 and num > 0 then
			-- DDZ_Audio.playDaoJiShiSound()
		end

		if num == 0 or num == nil or num <0 then
			-- DDZ_Audio.stopDaoJiShiSound()
			-- print("停止倒计时")
			self.m_UINode:stopAllActions()
			
		end
	end
	self.m_UINode:schedule(onDaoJiShi,1)    --启动定时器

	--如果玩家正在托管 隐藏所有按钮 只显示倒计时
	if self:isTuoGuanEnabled() then
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_YaoBuQi"):setVisible(false)
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_YaoDeQi"):setVisible(false)
	end

	--显示出牌
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setVisible(true)
end

-- start --

--------------------------------
-- 隐藏出牌
-- @function hideChuPai

-- end --
function DDZ_GamePlayer:hideChuPai()
	-- DDZ_Audio.stopDaoJiShiSound()
	self.m_UINode:stopAllActions()
	if not self:isTuoGuanEnabled() then
		self:setPlayerCardTouchEnabled(true)	 -- 恢复触摸
	end
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuChu"):setButtonEnabled(true)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setVisible(false)
end

-- start --

--------------------------------
-- 是否正在等待被人出牌
-- @function isShowDengDaiChuPai

-- end --

function DDZ_GamePlayer:isShowDengDaiChuPai()
	return cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):isVisible()
end

-- start --

--------------------------------
-- 显示等待出牌
-- @function showDengDaiChuPai
-- @param number time  --倒计时时间

-- end --
function DDZ_GamePlayer:showDengDaiChuPai(time)
	local timeStr = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_DaoJiShi")
	if self:isTuoGuanEnabled() then
		time = 3
	end
	timeStr:setString(tostring(time))

	local function onDaoJiShi(dt)
		local num = tonumber(timeStr:getString()) - 1
		timeStr:setString(tostring(num))

		if num == 0 then
			self.m_UINode:stopAllActions()
		end
	end

	self.m_UINode:schedule(onDaoJiShi,1)    --启动定时器
	--显示倒计时
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):setVisible(true)
end

-- start --

--------------------------------
-- 隐藏等待出牌
-- @function hideDengDaiChuPai

-- end --
function DDZ_GamePlayer:hideDengDaiChuPai()
	self.m_UINode:stopAllActions()
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):setVisible(false)
end


--***************************************************  抢地主相关方法  **************************************************************************

-- start --

--------------------------------
-- 显示抢地主状态
-- @function showQiangDiZhuState
-- @param number called  0 = 不抢  1 = 抢

-- end --
function DDZ_GamePlayer:showQiangDiZhuState(score)

	self:hideQiangDiZhuState()
	if score == scoreTab.zero then  --不叫
		
			-- cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuQiangWenZi"):setVisible(false)
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuJiaoWenZi"):setVisible(true)

			if self.m_playerInfo.player.sex == 1 then  --女
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_BUJIAO)
			else
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_BUJIAO)
			end
		
	elseif score == scoreTab.one then  --不抢  -- 抢

		
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_Jiao_1"):setVisible(true)
			
	
			if self.m_playerInfo.player.sex == 1 then  --女
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_QIANG)
			else
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_QIANG)
			end
	elseif score == scoreTab.two then  --不抢  -- 抢

		
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_Jiao_2"):setVisible(true)
			
	
			if self.m_playerInfo.player.sex == 1 then  --女
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_QIANG)
			else
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_QIANG)
			end
	elseif score == scoreTab.three then  --不抢  -- 抢

		
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_Jiao_3"):setVisible(true)
			
	
			if self.m_playerInfo.player.sex == 1 then  --女
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FEMALE_QIANG)
			else
				DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_MALE_QIANG)
			end
		
	end
end

-- start --

--------------------------------
-- 隐藏抢地主状态
-- @function hideQiangDiZhuState

-- end --

function DDZ_GamePlayer:hideQiangDiZhuState()
	-- print("隐藏叫分状态")
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_BuJiaoWenZi"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_Jiao_1"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_Jiao_2"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_Jiao_3"):setVisible(false)
end

-- start --

--------------------------------
-- 显示抢地主
-- @function showQiangDiZhu
-- @param number time  --倒计时时间

-- end --
function DDZ_GamePlayer:showQiangDiZhu(time,multiple)
	local timeStr = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_QiangFenDaoJiShi")
	timeStr:setString(tostring(time))

	local function onDaoJiShi(dt)
		local num = tonumber(timeStr:getString()) - 1
		timeStr:setString(tostring(num))
		if num == 0 then
			self.m_UINode:stopAllActions()
	--		self:clickBuQiang()
		end
	end

	self.m_UINode:schedule(onDaoJiShi,1)    --启动定时器

	-- if self.m_sceneSelf.multiple > 0 then   --显示抢地主
	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_QiangDiZhu"):setButtonImage("normal","Image/DDZ/btn_QiangDiZhu01.png")
	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_QiangDiZhu"):setButtonImage("pressed","Image/DDZ/btn_QiangDiZhu02.png")

	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuQiang"):setButtonImage("normal","Image/DDZ/btn_BuQiang01.png")
	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuQiang"):setButtonImage("pressed","Image/DDZ/btn_BuQiang02.png")
	-- else  --显示叫地主
	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_QiangDiZhu"):setButtonImage("normal","Image/DDZ/btn_JiaoDiZhu01.png")
	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_QiangDiZhu"):setButtonImage("pressed","Image/DDZ/btn_JiaoDiZhu02.png")

	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuQiang"):setButtonImage("normal","Image/DDZ/btn_BuJiao01.png")
	-- 	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_BuQiang"):setButtonImage("pressed","Image/DDZ/btn_BuJiao02.png")
	-- end

	-- print("显示抢地主")
	--显示抢地主
	local k_nd_QiangDiZhuXingWei = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_QiangDiZhuXingWei")
	k_nd_QiangDiZhuXingWei:setVisible(true)
	if multiple == 0 then
		cc.uiloader:seekNodeByNameFast(k_nd_QiangDiZhuXingWei,"k_btn_Jiao_1"):setButtonEnabled(true)
		cc.uiloader:seekNodeByNameFast(k_nd_QiangDiZhuXingWei,"k_btn_Jiao_2"):setButtonEnabled(true)
		
	elseif multiple == Jiao_rule[self.m_sceneSelf.rule_type][1] then
		cc.uiloader:seekNodeByNameFast(k_nd_QiangDiZhuXingWei,"k_btn_Jiao_1"):setButtonEnabled(false)
		cc.uiloader:seekNodeByNameFast(k_nd_QiangDiZhuXingWei,"k_btn_Jiao_2"):setButtonEnabled(true)
	elseif multiple == Jiao_rule[self.m_sceneSelf.rule_type][2] then
		cc.uiloader:seekNodeByNameFast(k_nd_QiangDiZhuXingWei,"k_btn_Jiao_1"):setButtonEnabled(false)
		cc.uiloader:seekNodeByNameFast(k_nd_QiangDiZhuXingWei,"k_btn_Jiao_2"):setButtonEnabled(false)
	end
end

-- start --

--------------------------------
-- 隐藏抢地主
-- @function hideQiangDiZhu

-- end --
function DDZ_GamePlayer:hideQiangDiZhu()
	-- print("隐藏抢地主")
	self.m_UINode:stopAllActions()
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_QiangDiZhuXingWei"):setVisible(false)
end

-- start --

--------------------------------
-- 显示等待抢地主
-- @function showDengDaiJiaoFen
-- @param number time  --倒计时时间

-- end --
function DDZ_GamePlayer:showDengDaiQiangDiZhu(time)
	-- print("倒计时的时间",time)
	local timeStr = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_ta_DaoJiShi")
	timeStr:setString(tostring(time))

	local function onDaoJiShi(dt)
		local num = tonumber(timeStr:getString()) - 1
		timeStr:setString(tostring(num))
		if num == 0 then
			self.m_UINode:stopAllActions()
		end
	end

	self.m_UINode:schedule(onDaoJiShi,1)    --启动定时器
	--显示倒计时
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):setVisible(true)
end

-- start --

--------------------------------
-- 隐藏等待抢地主
-- @function hideDengDaiQiangDiZhu

-- end --
function DDZ_GamePlayer:hideDengDaiQiangDiZhu()
	self.m_UINode:stopAllActions()
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DengDai"):setVisible(false)
end

--***************************************************  操作玩家牌的相关方法  **************************************************************************

-- start --

--------------------------------
-- 获取手牌和出牌的排序位置
-- @function getCardSortPos
-- @param number cardNum 要排序位置的牌数
-- @param number scale 排序的缩放比例
-- @param string originName 要排序的牌原点节点名字

-- end --
function DDZ_GamePlayer:getCardSortPos(cardNum,scale,originName)
	local FaPaiWeiZhi = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root,originName)
	local X = FaPaiWeiZhi:getPositionX()
	local Y = FaPaiWeiZhi:getPositionY()

	if self.m_playerInfo.seat == 1 then
		if cardNum-1 ~= 0 then
			local width = ((cardNum-1) * DDZ_Const.CARD_WIDTH_DISTANCE) + DDZ_Const.CARD_WIDTH * scale
			X = X - width / 2 + DDZ_Const.CARD_WIDTH * scale / 2
		end
	end

	return cc.p(X,Y)
end

-- start --

--------------------------------
-- 刷新牌位置
-- @function updatePosition

-- end --
function DDZ_GamePlayer:updatePosition()
	-- print("发牌的玩家椅子号 = " .. self.m_playerInfo.seat)
	local scale = 0.9
	local pos = self:getCardSortPos(#self.m_Cards,scale,"k_nd_player" .. self.m_playerInfo.seat .."_PaiWeiZhi")

	if self.m_playerInfo.seat == 1 then  --刷新自己的牌
		for k,v in ipairs(self.m_Cards) do
			if not self.sortCardBtnFlag then
	        	v:setCardSuoTou()
	        else
	        	v:setCardSuoTou(1)
	        end
			v:setScale(scale)
			v:setPosition(cc.p(pos.x,pos.y))
			v:setLocalZOrder(pos.x)
			pos.x = pos.x + DDZ_Const.CARD_WIDTH_DISTANCE * scale
			v:setVisible(true)

			--设置触摸范围
			if v == self.m_Cards[#self.m_Cards] then  --最后一张牌的触摸范围是整张牌
				v.m_touchRect = cc.rect(v:getPositionX()-DDZ_Const.CARD_WIDTH/2*scale,v:getPositionY()-DDZ_Const.CATD_HEIGHT/2*scale,
					DDZ_Const.CARD_WIDTH*scale,DDZ_Const.CATD_HEIGHT*scale)
			else
				v.m_touchRect = cc.rect(v:getPositionX()-DDZ_Const.CARD_WIDTH/2*scale,v:getPositionY()-DDZ_Const.CATD_HEIGHT/2*scale,
					DDZ_Const.CARD_WIDTH_DISTANCE*scale,DDZ_Const.CATD_HEIGHT*scale)
			end
		end
	else  --刷新其他玩家的牌
		for k,v in ipairs(self.m_Cards) do
			v:setScale(0.5)
			v:setPosition(pos)
			v:setLocalZOrder(pos.y)
			pos.y = pos.y - 0.5
			v:setVisible(true)
		end
	end
end

-- start --

--------------------------------
-- 发牌
-- @function FaPai
-- @DDZ_Card card   发给自己的牌

-- end --
function DDZ_GamePlayer:FaPai(card,cardSendFinishedCallback)
	--存到自己手里
	if card ~= nil then
		table.insert(self.m_Cards,card)
	end
	--排序
	if self.m_playerInfo.seat == 1 then
		--todo
		self.m_sceneSelf:SortCardsEx(1,self.m_Cards)
	end
	--如果不是自己更新牌数
	if self.m_playerInfo.seat ~= 1 then
		-- print("更新了 " .. self.m_playerInfo.seat .. " 椅子玩家的牌数")
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_ta_PaiShu" .. self.m_playerInfo.seat):setString(tostring(#self.m_Cards))
	else  --显示正面
		card:showFront()
		card:setScale(0.6)
		
	end
	--更新位置
	-- self:updatePosition()
	self:updateCardPostion()

	if cardSendFinishedCallback then
		cardSendFinishedCallback()
	end
end

-- start --

--------------------------------
-- 获取提示牌型
-- @function getTiShiPaiXing

-- end --
function DDZ_GamePlayer:getTiShiPaiXing()
	--我自己的手牌
	local allCard = {}
	for k,v in ipairs(self.m_Cards) do
		local cardInfo = {}
		cardInfo.num = v:getCardNum()
		cardInfo.color = v:getCardColor()
		if cardInfo.color == 4 then
			-- print("王的牌值 = " .. cardInfo.num)
		end
		table.insert(allCard,cardInfo)
	end

	--获取提示的牌型
	local CardInfo = DDZ_remind(PinningCardInfo,allCard)
	dump(CardInfo, "提示的牌型")
	CardInfo.TiShiIndex = 1

	return CardInfo
end

-- start --

--------------------------------
-- 设置玩家手牌全部缩头
-- @function setPlayerCardAllSuoTou

-- end --
function DDZ_GamePlayer:setPlayerCardAllSuoTou()

	for k,v in ipairs(self.m_Cards) do
		if not self.sortCardBtnFlag then
	        v:setCardSuoTou()
	    else
	        v:setCardSuoTou(1)
	    end
        
    end
    selectCards = {}
end

-- start --

--------------------------------
-- 设置玩家一部分牌露头
-- @function setPlayerCardLuTuo

-- end --
function DDZ_GamePlayer:setPlayerCardLuTuo(cards)
	if cards ==nil or #cards == 0 then
		return
	end
	if self.m_Cards==nil or #self.m_Cards == 0  then
		return
	end
	if self.m_playerInfo.seat ~= 1 then
		return
	end
	self:XZPlayerCardLuTuo(cards,self.m_Cards)

	for k,v in ipairs(cards) do
		for kk,vv in ipairs(self.m_Cards) do
			if v.num == vv.m_num and v.color == vv.m_color and v.index == vv.index  then
				
				if not self.sortCardBtnFlag then
	        		vv:setCardLuTou()
	        	else
	        		vv:setCardLuTou(1)
	        	end
	        	break
			end
		end
	end
	
end

--
-- start --
function DDZ_GamePlayer:XZPlayerCardLuTuo(cards,m_Cards)
	print("XZPlayerCardLuTuo")
	-- dump(cards, "cards")
	-- dump(m_Cards, "m_Cards")
	
	if #cards ~=0 then
		
		self.m_sceneSelf:SortCards(1,cards)
		local  card_Tab = {num = 0, color = 0}
		for k,v in pairs(cards) do
			if v.num ~= card_Tab.num or v.color ~= card_Tab.color then
				card_Tab.num = v.num
				card_Tab.color = v.color
				v.index = 1
			else
				v.index = 2
			end
		end
	end
	
	if #m_Cards ~= 0 then
		self.m_sceneSelf:SortCardsEx(1,m_Cards)
		local  card_Tab = {num = 0, color = 0}
		for k,v in pairs(m_Cards) do
			if v.m_num ~= card_Tab.num or v.m_color ~= card_Tab.color then
				card_Tab.num = v.m_num
				card_Tab.color = v.m_color
				v.index = 1
			else
				v.index = 2
			end
			print("m_num",v.m_num)
			print("m_color",v.m_color)
			print("index",v.index)
		end
	end

end



--------------------------------
-- 设置玩家手牌可触摸状态
-- @function setPlayerCardLuTuo

-- end --
function DDZ_GamePlayer:setPlayerCardTouchEnabled(isEnabled)
	if isEnabled == self.m_sceneSelf.root:isTouchEnabled() then
		return 
	end

	self.m_sceneSelf.root:setTouchEnabled(isEnabled)

	if isEnabled then
		for k,v in ipairs(self.m_Cards) do
			v:setColor(DDZ_Const.CARD_RELEASE_COLOR)
		end
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(false)
	else
		self:setPlayerCardAllSuoTou()

		for k,v in ipairs(self.m_Cards) do
			v:setColor(DDZ_Const.CARD_SELECT_COLOR)
		end
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(true)
	end
end

-- start --

--------------------------------
-- 清理玩家手牌

-- end --
function DDZ_GamePlayer:clearPlayerCards()
	for k,v in ipairs(self.m_Cards) do
		v:removeFromParent()
		v = nil
	end

	self.m_Cards = {}
end

-- start --

--------------------------------
-- 清理游戏数据

-- end --
function DDZ_GamePlayer:clearGameData()
	print("DDZ_GamePlayer:clearGameData")
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_GameXingWei"):setVisible(false) 		--隐藏出牌
	cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_nd_QiangDiZhuXingWei"):setVisible(false)		--隐藏叫分
	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuanQuXiao"):setVisible(false)		--隐藏取消托管
	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_img_DaBuGuo"):setVisible(false)		--隐藏打不上文字

	selectCards = {}	 --触摸选择的牌
	PinningCardInfo = {}  --要管得牌
	TiShiCardInfo = {}  --提示的牌型
	LuTouCardInfo = {}  --已经露头正准备出得牌
	for k,v in pairs(sendPlayersCard) do
		if #v >0 then
			for kk,vv in pairs(v) do
				vv:removeFromParent()
				vv = nil
			end
		end
		
	end
	sendPlayersCard = {[1] = {},[2] = {},[3] = {},[4] = {}}   --桌子上 每个玩家打出去的牌
end

--***************************************************  其他的一些方法  **************************************************************************

-- start --

--------------------------------
-- 插入上次出的牌  为恢复场景准备
-- @function insertLastCards
-- @param table lastCards  要添加的牌

-- end --
function DDZ_GamePlayer:insertLastCards(lastCards)
	-- print("insertLastCards")
	-- sendPlayersCard[self.m_playerInfo.seat] = lastCards

	-- --刷新位置
	-- self:runChuPaiAction(lastCards)
end


-- start --

--------------------------------
-- 显示别人的手牌
-- @function setPlayerIdentity
-- @param table cardInfos  玩家的牌信息 牌值花色

-- end --
function DDZ_GamePlayer:showPlayerCards(cardInfos)
--	dump(cardInfos,"玩家 " .. self.m_playerInfo.seat .. " 要显示的牌数据")
	if cardInfos ==nil or #cardInfos ==0 then
		return 
	end
	-- dump(cardInfos,"玩家 " .. self.m_playerInfo.seat .. " 要显示的牌数据")
	-- --显示牌
	for k,v in ipairs(self.m_Cards) do
		if k<=#cardInfos then
			v:setCardNum(cardInfos[k].num)
			v:setCardColor(cardInfos[k].color)
			v:showFront()
		end
		
	end

	--刷新位置
	local pos = self:getCardSortPos(#self.m_Cards,0.5,"k_nd_player" .. self.m_playerInfo.seat .. "_PaiXianShiWeiZhi")
	cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_ta_PaiShu" .. self.m_playerInfo.seat):setVisible(false)
	if self.m_playerInfo.seat~=1 then
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi"):setVisible(false)
	end
	

	local index = 0
	local x = 0
	local y = 0
	local Z = 10000
	for k,v in ipairs(self.m_Cards) do
		if k<= #cardInfos then
		
			index = k
			index = index - 1
			index = index % 5
			x = pos.x +  index * 30 * 0.5
			-- if self.m_playerInfo.seat == 2 then
			-- 	x = pos.x +  index * DDZ_Const.CARD_WIDTH_DISTANCE * 0.5 * -1
			-- --	v:setLocalZOrder(Z-k)
			-- else
			-- 	x = pos.x +  index * DDZ_Const.CARD_WIDTH_DISTANCE * 0.5
			-- --	v:setLocalZOrder(k)
			-- end

			y = pos.y - 24 * math.floor((k-1) / 5)
			v:setLocalZOrder(k)
			v:setPosition(cc.p(x,y))
		end
	end
end

-- start --

--------------------------------
-- 获取玩家名字
-- @function setPlayerIdentity
-- @return 玩家名字

-- end --
function DDZ_GamePlayer:getPlayerName()
	return self.m_playerInfo.player.name
end

-- start --

--------------------------------
-- 获取玩家手牌数
-- @function getPlayerCardNum
-- @return 玩家手牌数

-- end --
function DDZ_GamePlayer:getPlayerCardNum()
	return #self.m_Cards
end

-- start --

--------------------------------
-- 设置玩家身份
-- @function setPlayerIdentity
-- @param bool isShow   --身份是否显示
-- @param bool isDiZhu  --是否是地主

-- end --
function DDZ_GamePlayer:setPlayerIdentity(isShow,isDiZhu)
	if isShow then
		if isDiZhu then
			self.isDiZhu = true
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DiZhuMaoZi"):setVisible(true)
		else
			self.isDiZhu = false
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_NongMinMaoZi"):setVisible(true)
		end
	else
		self.isDiZhu = false
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_DiZhuMaoZi"):setVisible(false)
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_NongMinMaoZi"):setVisible(false)
	end
end

-- start --

--------------------------------
-- 设置头像
-- @function setTouXiang

-- end --
function DDZ_GamePlayer:setTouXiang()
	if self.m_isTuoGuan then  --设置托管头像
		local por = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_TouXiang")
		local farme = cc.SpriteFrame:create("Image/DDZ/img_JiQiRenTouXiang.png",cc.rect(0,0,76,76))
    	por:setSpriteFrame(farme)
    	por:setScale(1)
	else   --设置默认头像
		local image = AvatarConfig:getAvatar(self.m_playerInfo.player.sex, self.m_playerInfo.player.gold, 0)
    	local rect = cc.rect(0, 0, 178, 176)
    	local frame = cc.SpriteFrame:create(image, rect)
    	local por = cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_TouXiang")
    	por:setSpriteFrame(frame)
    	por:setScaleX(76/178)
    	por:setScaleY(76/176)

    	-- if self.m_playerInfo.player.imageid and self.m_playerInfo.player.imageid ~="" then
        
     --    	weixinImage[self.seat] = self.m_playerInfo.player.imageid
    	-- else
     --    	weixinImage[self.seat] = nil
    	-- end
    	--设置微信头像
    	util.setHeadImage(por:getParent(), self.m_playerInfo.player.imageid, por, image, self.seat)
	end
end

-- start --

--------------------------------
-- 获取玩家本地椅子号
-- @function getPlayerSeat
-- @return number 本地椅子号

-- end --
function DDZ_GamePlayer:getPlayerSeat()
	return self.m_playerInfo.seat
end

-- start --

--------------------------------
-- 退出房间
-- @function OutRoot

-- end --
function DDZ_GamePlayer:OutRoot()
	--隐藏牌数
	if self.m_playerInfo.seat ~= 1 then  
		cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_ta_PaiShu" .. self.m_playerInfo.seat):setVisible(false)  
	end

	self:clearPlayerCards() 	 --清理牌
	self:clearLastCards()

 	--隐藏玩家信息 等待下一个玩家进入 重新设置
 	local ImageNode = cc.uiloader:seekNodeByNameFast(self.m_UINode, "TouXiang_BG")
 	util.setImageNodeHide(ImageNode, self.seat)		--清理微信头像
	self.m_UINode:setVisible(false)

end

-- start --

--------------------------------
-- 设置玩家是否已经准备  显示隐藏已准备文字图片
-- @function setPlayerReadyState
-- @param number   1 准备 0 没准备

-- end --
function DDZ_GamePlayer:setPlayerReadyState(ready)
	-- print("setPlayerReadyState",ready)
	self.m_playerInfo.player.ready = ready
	if ready == 1 then  -- 已经准备
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBeiWenZi"):setVisible(true)
		if self.m_playerInfo.seat == 1 then  --如果准备的人是自己  隐藏准备按钮
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):setVisible(false)
		end
	else 				--还没有准备
		print("setPlayerReadyState(ready)")
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBeiWenZi"):setVisible(false)
	end
end
function DDZ_GamePlayer:setPlayerReadyStateEX(flag)
	
	if flag then  -- 已经准备
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBeiWenZi"):setVisible(true)
		if self.m_playerInfo.seat == 1 then  --如果准备的人是自己  隐藏准备按钮
			cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_btn_ZhunBei"):setVisible(false)
		end
	else 				--还没有准备
		print("setPlayerReadyStateEX(ready)")
		cc.uiloader:seekNodeByNameFast(self.m_UINode, "k_img_YiZhunBeiWenZi"):setVisible(false)
	end
end
-- start --

--------------------------------
-- 在选中的牌中只能提取 牌型
-- @function ZhiNengTiQu
-- @param table ZhiNengCards 选中的牌

-- end --
function DDZ_GamePlayer:ZhiNengTiQu(ZhiNengCards)
	for k,v in ipairs(self.m_Cards) do
		if v:isCardLuTou() then
			return false
		end
	end

	local TiQuCard = {}
	for k,v in ipairs(ZhiNengCards) do
		table.insert(TiQuCard,{num = v:getCardNum(),color = v:getCardColor()})
	end

	--提取
	local cards = DDZ_findSequence(PinningCardInfo,TiQuCard)

	
	if cards == nil or #cards == 0 then
		cards = {}
		local ret = cleaeBomp(TiQuCard)
		self.m_sceneSelf:SortCards(1,ret)
		for i,v in ipairs(ret) do
			if v.num == ret[#ret].num then
				table.insert(cards,v)
			end
		end
		
	else
		if DDZ_GetCardType(cards) == "errorcardtype" then
			cards = {}
			local ret = cleaeBomp(TiQuCard)
			self.m_sceneSelf:SortCards(1,ret)
			for i,v in ipairs(ret) do
				if v.num == ret[#ret].num then
					table.insert(cards,v)
				end
			end
		end
	end

	-- dump(cards,"智能提取的牌")
	self:XZPlayerCardLuTuo(cards,ZhiNengCards)
    for k,v in ipairs(ZhiNengCards) do
    	v:setColor(DDZ_Const.CARD_RELEASE_COLOR)

    	for kk,vv in ipairs(cards) do
    		if v:getCardNum() == vv.num and v:getCardColor() == vv.color and v.index == vv.index then
		

    			if not self.sortCardBtnFlag then
	        		v:setCardLuTou()
	        	else
	        		v:setCardLuTou(1)
	        	end
    			-- print("牌露头")
    			break
    		end
    	end
    end
    -- self:XZPlayerCardLuTuo(cards,ZhiNengCards)

  	--添加选择的牌
  	self:addLuTouCards()

	return true
end

--***************************************************  托管相关方法  **************************************************************************

-- start --

--------------------------------
-- 是否开启托管
-- @function isTuoGuanEnabled
-- @return bool    托管状态

-- end --
function DDZ_GamePlayer:isTuoGuanEnabled()
	return self.m_isTuoGuan
end

-- start --

--------------------------------
-- 设置托管状态
-- @function setTuoGuanState
-- #param bool isTuoGuan   托管状态

-- end --

function DDZ_GamePlayer:setTuoGuanState(isTuoGuan)
	self.m_isTuoGuan = isTuoGuan
	if self.m_playerInfo.seat == 1 then    --如果托管的是自己
		if self.m_isTuoGuan then 	--开启托管
			self.m_sceneSelf.root:setTouchEnabled(false) --关闭选牌触摸

			for k,v in ipairs(self.m_Cards) do
				if not self.sortCardBtnFlag then
	        		v:setCardSuoTou()
	        	else
	        		v:setCardSuoTou(1)
	        	end
				v:setColor(DDZ_Const.CARD_SELECT_COLOR)
			end
	
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuanQuXiao"):setVisible(true)  --显示取消托管按钮
			self:setTouXiang()  --设置为托管头像

		else 						--取消托管
			for k,v in ipairs(self.m_Cards) do
				v:setColor(DDZ_Const.CARD_RELEASE_COLOR)
			end

			self:setTouXiang()  --设置为默认头像
			cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_btn_TuoGuanQuXiao"):setVisible(false)  --隐藏取消托管按钮
			self.m_sceneSelf.root:setTouchEnabled(true)	--开启选牌触摸
		end
	else    --如果托管的是别人 只需要设置一下托管头像
		self:setTouXiang()  --设置头像
	end
end
--***************************************************  动作相关方法  **************************************************************************

-- start --

--------------------------------
-- 播放顺子动画
-- @function playShunZiAction
-- @param number cardNum  出牌的数量
-- @param number scale    打出去牌的缩放值

-- end --
function DDZ_GamePlayer:playShunZiAction(cardNum,scale)
	print("播放顺子动画")

	local node_root = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi")
	local node = display.newNode()
	node:setPosition(node_root:getPositionX(),node_root:getPositionY())
	node:addTo(self.m_sceneSelf.root,1000)

	local pos = cc.p(node:getPosition())
	print("原始位置 = " .. pos.x)

	if self.m_playerInfo.seat ~= 1 then
		local offset = (((cardNum - 1) * DDZ_Const.CARD_WIDTH_DISTANCE + DDZ_Const.CARD_WIDTH) / 2 - DDZ_Const.CARD_WIDTH/2) * scale 

		if self.m_playerInfo.seat == 2 then
			print("播放顺子动画的偏移量 = -" .. offset)
			node:setPosition(cc.p(pos.x - offset,pos.y))
		elseif self.m_playerInfo.seat == 3 then
			print("播放顺子动画的偏移量 = +" .. offset)
			node:setPosition(cc.p(pos.x + offset,pos.y))
		end

		print("修改之后的位置 = " .. node:getPositionX())
	end

	--爆炸
	local function BaoZhaAction()
		local BaoZha = display.newSprite("Image/DDZ/texiao/img_GuangQuan01.png")
		BaoZha:addTo(node,2000)

		local animation = cc.Animation:create()
		for i=2,5 do
			local sprite = display.newSprite("Image/DDZ/texiao/img_GuangQuan0" .. i .. ".png")
			animation:addSpriteFrame(sprite:getSpriteFrame())
		end
		animation:setDelayPerUnit(0.1)
		local action = cc.Animate:create(animation)
		BaoZha:runAction(cc.Sequence:create(action,cc.CallFunc:create(function () 
			node:setPosition(pos)
			node:removeFromParent() 
			end)))
	end

	--文字
	local function WenZiAction()
		local Guang = display.newSprite("Image/DDZ/texiao/img_ShunZiDi.png")
--		Guang:pos(Guang:getPositionX()-250-Guang:getContentSize().width/2,Guang:getPositionY())
		Guang:pos(Guang:getPositionX()-220,Guang:getPositionY())
		Guang:setAnchorPoint(cc.p(0,0.5))
		Guang:setScaleX(0.1)
		Guang:addTo(node,1000)

		local WenZi = display.newSprite("Image/DDZ/texiao/tx_ShunZi.png")
		WenZi:pos(WenZi:getPositionX()-150,WenZi:getPositionY())
		WenZi:addTo(node,1010)

		Guang:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1),cc.RemoveSelf:create(true),cc.CallFunc:create(BaoZhaAction)))
		WenZi:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveTo:create(0.18,cc.p(0,0)))))
	end

	--低杠
	local DiGang = display.newSprite("Image/DDZ/texiao/img_Di.png")
	DiGang:pos(DiGang:getContentSize().width/2 * -1,DiGang:getPositionY())
	DiGang:setAnchorPoint(cc.p(0,0.5))
	DiGang:setScaleX(0.1)
	DiGang:addTo(node,999)
	local sequence = cc.Sequence:create(cc.ScaleTo:create(0.1,1),cc.RemoveSelf:create(true),cc.CallFunc:create(WenZiAction))
	DiGang:runAction(sequence)
end

-- start --

--------------------------------
-- 播放飞机动画
-- @function playShunZiAction
-- @param number cardNum  出牌的数量
-- @param number scale    打出去牌的缩放值

-- end --
function DDZ_GamePlayer:playFeiJiAction(cardNum,scale)
	local node_root = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi")
	local node = display.newNode()
	node:setPosition(node_root:getPositionX(),node_root:getPositionY())
	node:addTo(self.m_sceneSelf.root,1000)

	local pos = cc.p(node:getPosition())
	
	if self.m_playerInfo.seat ~= 1 then
		local offset = (((cardNum - 1) * DDZ_Const.CARD_WIDTH_DISTANCE + DDZ_Const.CARD_WIDTH) / 2 - DDZ_Const.CARD_WIDTH/2) * scale 
	
		if self.m_playerInfo.seat == 2 then
			node:setPosition(cc.p(pos.x - offset,pos.y))
		elseif self.m_playerInfo.seat == 3 then
			node:setPosition(cc.p(pos.x + offset,pos.y))
		end
	end


	--飞机 从屏幕 右侧 飞向 左侧
	local FeiJi =  display.newSprite("Image/DDZ/texiao/FeiJi/img_PlaneActionNew_1.png")
	FeiJi:setPosition(cc.p(display.width + FeiJi:getContentSize().width/2 + 2,display.cy))
	local animation = cc.Animation:create()
	for i=1,2 do
		local sprite = display.newSprite("Image/DDZ/texiao/FeiJi/img_PlaneActionNew_" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.05)
	local action = cc.Animate:create(animation)
	local forAction = cc.Repeat:create(action,30)
	local moveScequenceAction = cc.Sequence:create(cc.MoveTo:create(1.2,cc.p(0 - FeiJi:getContentSize().width/2 - 2, display.cy)),
		cc.CallFunc:create(function () FeiJi:removeFromParent() end))

	FeiJi:addTo(self.m_sceneSelf.root)
	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_AIRCRAFT)
	FeiJi:runAction(cc.Spawn:create(forAction,moveScequenceAction))

	--爆炸
	local function BaoZhaAction()
		local BaoZha = display.newSprite("Image/DDZ/texiao/img_GuangQuan01.png")
		BaoZha:addTo(node)

		local animation = cc.Animation:create()
		for i=2,5 do
			local sprite = display.newSprite("Image/DDZ/texiao/img_GuangQuan0" .. i .. ".png")
			animation:addSpriteFrame(sprite:getSpriteFrame())
		end
		animation:setDelayPerUnit(0.1)
		local action = cc.Animate:create(animation)
		BaoZha:runAction(cc.Sequence:create(action,cc.CallFunc:create(function () 
			node:setPosition(pos)
			node:removeFromParent() 
		end
			)))
	end

	--文字
	local function WenZiAction()
		local Guang = display.newSprite("Image/DDZ/texiao/img_ShunZiDi.png")
--		Guang:pos(Guang:getPositionX()-250-Guang:getContentSize().width/2,Guang:getPositionY())
		Guang:pos(Guang:getPositionX()-220,Guang:getPositionY())
		Guang:setAnchorPoint(cc.p(0,0.5))
		Guang:setScaleX(0.1)
		Guang:addTo(node)

		local WenZi = display.newSprite("Image/DDZ/texiao/img_FeiJi.png")
		WenZi:pos(WenZi:getPositionX()-150,WenZi:getPositionY())
		WenZi:addTo(node,10)

		Guang:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15,1),cc.RemoveSelf:create(true),cc.CallFunc:create(BaoZhaAction)))
		WenZi:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveTo:create(0.18,cc.p(0,0)))))
	end

	--低杠
	local DiGang = display.newSprite("Image/DDZ/texiao/img_Di.png")
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
-- @param number cardNum  出牌的数量
-- @param number scale    打出去牌的缩放值

-- end --
function DDZ_GamePlayer:playLianDuiAction(cardNum,scale)
	local node = cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_player" .. self.m_playerInfo.seat .. "_ChuPaiWeiZhi")
	-- local node = display.newNode()
	-- node:setPosition(node_root:getPositionX(),node_root:getPositionY())
	-- node:addTo(self.m_sceneSelf.root,1000)

	local pos = cc.p(node:getPosition())
	
	if self.m_playerInfo.seat ~= 1 then
		local offset = (((cardNum - 1) * DDZ_Const.CARD_WIDTH_DISTANCE + DDZ_Const.CARD_WIDTH) / 2 - DDZ_Const.CARD_WIDTH/2) * scale 
	
		if self.m_playerInfo.seat == 2 then
			node:setPosition(cc.p(pos.x - offset,pos.y))
		elseif self.m_playerInfo.seat == 3 then
			node:setPosition(cc.p(pos.x + offset,pos.y))
		end
	end

	--连
	local Lian = display.newSprite("Image/DDZ/texiao/tx_Lian.png")
	Lian:pos(-150,0)
	--对
	local Dui = display.newSprite("Image/DDZ/texiao/tx_Dui.png")
	Dui:pos(150,0)

	Lian:addTo(node,10000)
	Dui:addTo(node,10000)

	local lian_action_1 = cc.EaseBackInOut:create(cc.MoveBy:create(0.2,cc.p(108,0)))
	local lian_move_1 = cc.MoveBy:create(0.5,cc.p(-50,0))
	local lian_move_2 = cc.Sequence:create(cc.RotateTo:create(0.1,-20),cc.RotateTo:create(0.1,20))
	local lian_action_2 = cc.Spawn:create(lian_move_1,cc.Repeat:create(lian_move_2,3))

	local dui_action_1 = cc.EaseBackInOut:create(cc.MoveBy:create(0.2,cc.p(-108,0)))
	local dui_move_1 = cc.MoveBy:create(0.5,cc.p(50,0))
	local dui_move_2 = cc.Sequence:create(cc.RotateTo:create(0.1,20),cc.RotateTo:create(0.1,-20))
	local dui_action_2 = cc.Spawn:create(dui_move_1,cc.Repeat:create(dui_move_2,3))

	Lian:runAction(cc.Sequence:create(lian_action_1,lian_action_2,cc.CallFunc:create(function() node:setPosition(pos) end),cc.RemoveSelf:create(true)))
	Dui:runAction(cc.Sequence:create(dui_action_1,dui_action_2,cc.RemoveSelf:create(true)))

	local BaoZha = display.newSprite("Image/DDZ/texiao/img_GuangQuan01.png")
	BaoZha:addTo(node,10001)

	local animation = cc.Animation:create()
	for i=2,5 do
		local sprite = display.newSprite("Image/DDZ/texiao/img_GuangQuan0" .. i .. ".png")
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
function DDZ_GamePlayer:playZhaDanAction()
	--炸弹
	local ZhaDan = display.newSprite("Image/DDZ/texiao/img_ZhaDan.png")
	ZhaDan:pos(display.cx,display.height+ZhaDan:getContentSize().height/2)
	ZhaDan:addTo(self.m_sceneSelf.root,100)

	--爆炸动画
	local function BaoZhaAction()
		ZhaDan:stopAllActions()
		ZhaDan:removeFromParent()

		local BaoZha = display.newSprite("Image/DDZ/texiao/img_BaoZha_01.png")
		BaoZha:setAnchorPoint(cc.p(0.5,0))
		BaoZha:pos(display.cx, display.cy*0.7)
		BaoZha:addTo(self.m_sceneSelf.root,10)

		ZhaDan = display.newSprite("Image/DDZ/texiao/tx_ZhaDan.png")
		ZhaDan:pos(display.cx, display.cy*0.85)
		ZhaDan:setScaleX(0.1)
		ZhaDan:addTo(self.m_sceneSelf.root,10)
		ZhaDan:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.6,1)),cc.ScaleTo:create(0.05,0.01,1),cc.RemoveSelf:create(true)))
	
		local animation = cc.Animation:create()
		for i=2,9 do
			local sprite = display.newSprite("Image/DDZ/texiao/img_BaoZha_0" .. i .. ".png")
			animation:addSpriteFrame(sprite:getSpriteFrame())
		end
		animation:setDelayPerUnit(0.1)
		local action = cc.Animate:create(animation)
		DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BOOM)
		BaoZha:runAction(cc.Sequence:create(action,cc.RemoveSelf:create(true)))
	end

	local ZhaDan_Action_1 = cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(display.cx,display.cy*0.7)),cc.CallFunc:create(BaoZhaAction))
	local ZhaDan_Action_2 = cc.Repeat:create(cc.RotateBy:create(0.2,100),5)
	
	ZhaDan:runAction(cc.Spawn:create(ZhaDan_Action_1,ZhaDan_Action_2))
end

-- start --


--------------------------------
-- 播放火箭特效
-- @function playHuoJianAction

-- end --
function DDZ_GamePlayer:playHuoJianAction()
	local node = display.newNode()
	node:setPosition(cc.p(display.cx,display.cy))

	--火箭
	local HuoJian = display.newSprite("Image/DDZ/texiao/HuoJian/img_GameAction_DouDiZu_RocketGuided.png")
	HuoJian:setLocalZOrder(2)
	HuoJian:addTo(node)

	--火花
	local HuoHua = display.newSprite("Image/DDZ/texiao/HuoJian/img_GameAction_DouDiZu_Rocket_Fire1.png")
	HuoHua:setPosition(cc.p(0,HuoJian:getContentSize().height * 0.53 * -1))
	HuoHua:addTo(node)

	local animation = cc.Animation:create()
	for i=1,2 do
		local sprite = display.newSprite("Image/DDZ/texiao/HuoJian/img_GameAction_DouDiZu_Rocket_Fire" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.1)
	local action = cc.Animate:create(animation)
	HuoHua:runAction(cc.Repeat:create(action,30))

	--烟雾
	local YanWu = display.newSprite("Image/DDZ/texiao/HuoJian/img_GameAction_DouDiZu_Rocket_Fog1.png")
	YanWu:setPosition(cc.p(0,HuoJian:getContentSize().height * 0.64 * -1))
	YanWu:addTo(node)

	local animation = cc.Animation:create()
	for i=1,2 do
		local sprite = display.newSprite("Image/DDZ/texiao/HuoJian/img_GameAction_DouDiZu_Rocket_Fog" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.15)
	local action = cc.Animate:create(animation)
	YanWu:runAction(cc.Sequence:create(action,cc.CallFunc:create(function() YanWu:removeFromParent() end)))

	local function HuoJianActionEnd()
		node:removeFromParent()

		--炸弹掉下来
		local ZhaDan = display.newSprite("Image/DDZ/texiao/img_ZhaDan.png")
		ZhaDan:pos(display.cx,display.height+ZhaDan:getContentSize().height/2)
		ZhaDan:addTo(self.m_sceneSelf.root,100)
	
		--爆炸动画
		local function BaoZhaAction()
			ZhaDan:stopAllActions()
			ZhaDan:removeFromParent()
	
			local BaoZha = display.newSprite("Image/DDZ/texiao/img_BaoZha_01.png")
			BaoZha:setAnchorPoint(cc.p(0.5,0))
			BaoZha:pos(display.cx, display.cy*0.7)
			BaoZha:addTo(self.m_sceneSelf.root,10)
	
			ZhaDan = display.newSprite("Image/DDZ/texiao/img_WangZha.png")
			ZhaDan:pos(display.cx, display.cy*0.85)
			ZhaDan:setScaleX(0.1)
			ZhaDan:addTo(self.m_sceneSelf.root,10)
			ZhaDan:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.ScaleTo:create(0.6,1)),cc.ScaleTo:create(0.05,0.01,1),cc.RemoveSelf:create(true)))
		
			local animation = cc.Animation:create()
			for i=2,9 do
				local sprite = display.newSprite("Image/DDZ/texiao/img_BaoZha_0" .. i .. ".png")
				animation:addSpriteFrame(sprite:getSpriteFrame())
			end
			animation:setDelayPerUnit(0.1)
			local action = cc.Animate:create(animation)
			BaoZha:runAction(cc.Sequence:create(action,cc.RemoveSelf:create(true)))
		end
	
		local ZhaDan_Action_1 = cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(display.cx,display.cy*0.7)),cc.CallFunc:create(BaoZhaAction))
		local ZhaDan_Action_2 = cc.Repeat:create(cc.RotateBy:create(0.2,100),5)
		
		ZhaDan:runAction(cc.Spawn:create(ZhaDan_Action_1,ZhaDan_Action_2))
	end

	local moveScequenceAction = cc.Sequence:create(cc.DelayTime:create(0.1),cc.EaseSineIn:create(cc.MoveTo:create(0.6,cc.p(display.cx,display.height + HuoJian:getContentSize().height / 2 + HuoHua:getContentSize().height * 0.7))),
		cc.CallFunc:create(HuoJianActionEnd))

	node:addTo(self.m_sceneSelf.root)

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_ROCKET)
	node:runAction(moveScequenceAction)
end

-- start --

--------------------------------
-- 播放春天特效
-- @function playChunTianAction

-- end --
function DDZ_GamePlayer:playChunTianAction()
	--春天
	local QuanGuan = display.newSprite("Image/DDZ/texiao/ChunTian/lord_anim_spring_1.png")
	QuanGuan:setPosition(cc.p(display.cx,display.cy))
	QuanGuan:setScale(0.01)

	local SuoFang = nil
	local DongHua = nil
	local YinShen = nil
	local sequence = nil

	SuoFang = cc.ScaleTo:create(0.2,1)
	local animation = cc.Animation:create()
	for i=2,17 do
		local sprite = display.newSprite("Image/DDZ/texiao/ChunTian/lord_anim_spring_" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.06)
	DongHua = cc.Animate:create(animation)
	YinShen = cc.FadeOut:create(0.3)
	sequence = cc.Sequence:create(SuoFang,DongHua,YinShen,cc.RemoveSelf:create(true))
	self.m_sceneSelf.root:add(QuanGuan,2001)

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_SPRING)
	QuanGuan:runAction(sequence)
end

-- start --

--------------------------------
-- 播放反春特效
-- @function playFanChunAction

-- end --
function DDZ_GamePlayer:playFanChunAction()
	--反春
	local QuanGuan = display.newSprite("Image/DDZ/texiao/FanChun/anti_anim_spring_1.png")
	QuanGuan:setPosition(cc.p(display.cx,display.cy))

	local DongHua = nil
	local YinShen = nil
	local sequence = nil

	local animation = cc.Animation:create()
	for i=2,12 do
		local sprite = display.newSprite("Image/DDZ/texiao/FanChun/anti_anim_spring_" .. i .. ".png")
		animation:addSpriteFrame(sprite:getSpriteFrame())
	end
	animation:setDelayPerUnit(0.06)
	DongHua = cc.Animate:create(animation)
	YinShen = cc.FadeOut:create(0.3)
	sequence = cc.Sequence:create(DongHua,YinShen,cc.RemoveSelf:create(true))
	self.m_sceneSelf.root:add(QuanGuan,2001)

	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_SPRING)
	QuanGuan:runAction(sequence)
end

-- start --

--------------------------------
-- 播放结算分数
-- @function playScoreAction
-- @param number score  结算分数
-- @param function finishCallBack 动画结束回调方法

-- end --
function DDZ_GamePlayer:playScoreAction(score,finishCallBack)
	local FenShu = nil

	if score > 0 then
		FenShu = display.newBMFontLabel({
			text = "+" .. score,
			font = "Image/DDZ/font/1.fnt"
		})
	else
		FenShu = display.newBMFontLabel({
			text = tostring(score),
			font = "Image/DDZ/font/2.fnt"
		})
	end

	if self.m_playerInfo.seat == 2 then
		FenShu:setAnchorPoint(cc.p(1,0.5))
	else
		FenShu:setAnchorPoint(cc.p(0,0.5))
	end

	FenShu:setPosition(cc.p(cc.uiloader:seekNodeByNameFast(self.m_sceneSelf.root, "k_nd_JieSuanfenWeiZhi" .. self.m_playerInfo.seat):getPosition()))
	FenShu:addTo(self.m_sceneSelf.root)

	local moveAction = cc.EaseSineOut:create(cc.MoveBy:create(2, cc.p(0,60)))
	local fadeAction = cc.FadeOut:create(2)
	local sequenceAction = nil
	if finishCallBack then
		sequenceAction = cc.Sequence:create(cc.Spawn:create(moveAction,fadeAction),cc.RemoveSelf:create(true),cc.CallFunc:create(finishCallBack))
	else
		sequenceAction = cc.Sequence:create(cc.Spawn:create(moveAction,fadeAction),cc.RemoveSelf:create(true))
	end
	FenShu:runAction(sequenceAction)
end

--***************************************************  操作玩家触摸牌的相关方法  **************************************************************************

-- start --

--------------------------------
-- 是否有牌被选中
-- @function began
-- @param table event
-- @return bool

-- end --
function DDZ_GamePlayer:began(event)
	local selectCards_tab = {}
    for k,v in ipairs(self.m_Cards) do
        if cc.rectContainsPoint(v.m_touchRect,cc.p(event.x,event.y)) then
        	table.insert(selectCards_tab,v)
            -- table.insert(selectCards,v)
            -- v:setColor(DDZ_Const.CARD_SELECT_COLOR)
            -- return true
        end
    end
    local index_max = 0 
    local index = 0
    for i,v in ipairs(selectCards_tab) do
    	if v:getLocalZOrder() > index_max  then
    		index_max = v:getLocalZOrder()
    		index = i
    	end
    end
    if selectCards_tab[index] then
    	table.insert(selectCards,selectCards_tab[index])
    	selectCards_tab[index]:setColor(DDZ_Const.CARD_SELECT_COLOR)
    	return true
    end

    self:setPlayerCardAllSuoTou()
    selectCards = {}
    self:addLuTouCards()

    return false
end

-- start --

--------------------------------
-- 移动手指选牌
-- @function moved
-- @param table event

-- end --
function DDZ_GamePlayer:moved(event)
	-- print("DDZ_GamePlayer:moved")
	--如果当前选择的牌是最后一张 就直接返回
	if #selectCards ~= 0 then
        local back = selectCards[#selectCards]
        if cc.rectContainsPoint(back.m_touchRect,cc.p(event.x,event.y)) then
            return
        end
    end

    --找到当前选择的牌
    local card = nil
    for k,v in ipairs(self.m_Cards) do
        if cc.rectContainsPoint(v.m_touchRect,cc.p(event.x,event.y)) then
        	card = v
        	break
        end
    end
    --如果没有选中任何牌就直接返回
    if not card then
    	return
    end

    --判断当前选择的牌是否需要存储
    local isInsert = true
    for k,v in ipairs(selectCards) do
        if v == card then
           	isInsert = false
            break
        end
    end
    --如果需要存储
    if isInsert then
        table.insert(selectCards,card)
        card:setColor(DDZ_Const.CARD_SELECT_COLOR)
    end
    --纵向排序时
    if not self.sortCardBtnFlag then
    	-- print("纵向排序时")
	    --获取 第一张选择的牌 与 最后一张选择的牌的 x 位置
	    local x1 = selectCards[1].m_touchRect.x
	    local x2 = card.m_touchRect.x
	    if x1 > x2 then
	        x1,x2 = x2,x1
	    end

	    --存储 第一张选择的牌 与 最后一张选择的牌  x 之内的牌
	    for k,v in ipairs(self.m_Cards) do
	        if v.m_touchRect.x > x1 and v.m_touchRect.x < x2 then
	            isInsert = true
	            for kk,vv in ipairs(selectCards) do
	                if v == vv then
	                    isInsert = false 
	                    break
	                end
	            end
	            if isInsert then
	                table.insert(selectCards,v)
	                v:setColor(DDZ_Const.CARD_SELECT_COLOR)
	            end
	        end
	    end
	    
    	--释放 第一张选择的牌 与 最后一张选择的牌  x 之外的牌
	    local index = 1
	    while index <= #selectCards do
	        if selectCards[index].m_touchRect.x < x1 or selectCards[index].m_touchRect.x > x2 then
	            selectCards[index]:setColor(DDZ_Const.CARD_RELEASE_COLOR)
	            table.remove(selectCards,index)
	        else
	            index = index + 1
	        end
	    end
    end
    
end

-- start --

--------------------------------
-- 手指弹起
-- @function ended
-- @param table event

-- end --
function DDZ_GamePlayer:ended(event)
	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_HIT_CARD)

	--智能提取牌型
    if self:ZhiNengTiQu(selectCards) then
         selectCards = {}
        return 
    end
    
    	for k,v in ipairs(selectCards) do
    	
    		if not self.sortCardBtnFlag then
    			v:setColor(DDZ_Const.CARD_RELEASE_COLOR)
    		end
	        
	        if v:isCardLuTou() then
	        	if not self.sortCardBtnFlag then
	        		v:setCardSuoTou()
	        	else
	        		v:setCardSuoTou(1)
	        	end
	            
	        else
	        	if not self.sortCardBtnFlag then
	        		v:setCardLuTou()
	        	else
	        		v:setCardLuTou(1)
	        	end
	            
	        end
        
    	end
    
    


    selectCards = {}

    --添加选择的牌
   	self:addLuTouCards()
end

--************************************************************************************************************************************************

return DDZ_GamePlayer