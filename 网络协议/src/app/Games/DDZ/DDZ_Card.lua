--
-- Author: K
-- Date: 2016-12-27 10:23:16
-- 扑克牌类 DDZ_Card
--

local DDZ_Card = class("DDZ_Card", function()
	return display.newSprite()
end)

local DDZ_Const = require("app.Games.DDZ.DDZ_Const")

-- start --

--------------------------------
-- 创建一张牌
-- @function create
-- @return  一张牌

-- end --
function DDZ_Card:create(num,color)
	num = num or 0
	color = color or 0

	-- print("创建一张牌值为 = " .. self.m_num .. " 花色为 = " .. self.m_color .. " 的扑克牌")

	local bRet = DDZ_Card.new()
	bRet:init(num,color)
	
	return bRet
end

-- start --

--------------------------------
-- 构造函数
-- @function ctor

-- end --
function DDZ_Card:ctor()
	self.m_num = nil     		--牌值
	self.m_color = nil   		--花色
	self.m_isSelect = false 	--是否已经选择
	self.m_touchRect = nil
	self.dizhu_node = nil 
end

-- start --

--------------------------------
-- 对象初始化
-- @function init

-- end --
function DDZ_Card:init(num,color)
	self.m_num = num
	self.m_color = color
	if self.m_num == 0 then
		self:showLast()
	else
		self:showFront()
	end
end

--显示正面
function DDZ_Card:showFront()
	local frame = nil
	if self.m_color == 4 then
		frame = cc.SpriteFrame:create("Image/DDZ/img_Pai.png",cc.rect((self.m_num-14)*DDZ_Const.CARD_WIDTH,self.m_color*DDZ_Const.CATD_HEIGHT,DDZ_Const.CARD_WIDTH,DDZ_Const.CATD_HEIGHT))
	else
		frame = cc.SpriteFrame:create("Image/DDZ/img_Pai.png",cc.rect((self.m_num-1)*DDZ_Const.CARD_WIDTH,self.m_color*DDZ_Const.CATD_HEIGHT,DDZ_Const.CARD_WIDTH,DDZ_Const.CATD_HEIGHT))
	end

   	self:setSpriteFrame(frame)
   	self:SetDiZu()
end

--显示背面
function DDZ_Card:showLast()
	local frame = cc.SpriteFrame:create("Image/DDZ/img_Pai.png",cc.rect(2*DDZ_Const.CARD_WIDTH,4*DDZ_Const.CATD_HEIGHT,DDZ_Const.CARD_WIDTH,DDZ_Const.CATD_HEIGHT))
   self:setSpriteFrame(frame)
end

--显示地主图标
function DDZ_Card:SetDiZu()
	self.dizhu_node = display.newSprite("Image/DDZ/duzhu.png")
	:hide()
	:pos(82.5,129.5)
	:addTo(self)
	
end
-- 是否显示地主图标
function DDZ_Card:ShowDiZu(flag)
	if flag then
		if self.dizhu_node then
			self.dizhu_node:show()
		end
	else
		if self.dizhu_node then
			self.dizhu_node:hide()
		end
	end
	
end
--------------------------------
-- 牌是否露头
-- @function isCardLuTou

-- end --
function DDZ_Card:isCardLuTou()
	return self.m_isSelect
end

-- start --

--------------------------------
-- 牌被选择露头
-- @function selectCardLuTou

-- end --
function DDZ_Card:setCardLuTou(sortCardBtnFlag)
	if not self.m_isSelect then  --如果没有被选择
		self.m_isSelect = true
		if sortCardBtnFlag ~= 1 then
			self:setPosition(cc.p(self:getPositionX(),self:getPositionY()+DDZ_Const.CARD_LUTOU_DISTANCE))
			if self.m_touchRect then
				self.m_touchRect.y = self.m_touchRect.y + DDZ_Const.CARD_LUTOU_DISTANCE
			end
		else
			if self.m_touchRect then
				self.m_touchRect.y = self.m_touchRect.y
			end
			self:setColor(DDZ_Const.CARD_SELECT_COLOR)
		end
		
		
	end
end

-- start --

--------------------------------
-- 牌失去选择缩头
-- @function selectCardSuoTou

-- end --
function DDZ_Card:setCardSuoTou(sortCardBtnFlag)
	if self.m_isSelect then 	--如果已经被选择
		self.m_isSelect = false
		if sortCardBtnFlag ~= 1 then
			self:setPosition(cc.p(self:getPositionX(),self:getPositionY()-DDZ_Const.CARD_LUTOU_DISTANCE))
			if self.m_touchRect then
				self.m_touchRect.y = self.m_touchRect.y - DDZ_Const.CARD_LUTOU_DISTANCE
			end
			
		else
			if self.m_touchRect then
				self.m_touchRect.y = self.m_touchRect.y
			end
		end
		
		self:setColor(DDZ_Const.CARD_RELEASE_COLOR)
		
	end
end

-- start --

--------------------------------
-- 设置牌选择状态
-- @function setCardSelectState

-- end --
function DDZ_Card:setCardSelectState(sortCardBtnFlag)
	if not self.m_isSelect then
		self:setCardSuoTou(sortCardBtnFlag)
	else
		self:setCardLuTou(sortCardBtnFlag)
	end
end

-- start --

--------------------------------
-- 获取缩放之后的大小
-- @function getScaleContentSize

-- end --
function DDZ_Card:getScaleContentSize()
	local size = self:getContentSize()
	local scale = cc.p(self:getScaleX(),self:getScaleY())
	return cc.size(size.width * scale.x, size.height * scale.y)
end

--------------设置获取 牌值 花色 是否已经选择---------------
function DDZ_Card:getCardNum()
	return self.m_num
end

function DDZ_Card:setCardNum(num)
	self.m_num = num
end

function DDZ_Card:getCardColor()
	return self.m_color
end

function DDZ_Card:setCardColor(color)
	self.m_color = color
end
--------------------------------------------------------

return DDZ_Card