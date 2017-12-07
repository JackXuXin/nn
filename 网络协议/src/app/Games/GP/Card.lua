--
-- Author: K
-- Date: 2016-11-29 17:43:50
-- 扑克牌类
--

local Card = class("Card", function()
	return display.newSprite()
end)

local define = require("app.Games.GP.Define")

function Card:ctor()
	self.m_num = nil     		--牌值
	self.m_color = nil   		--花色
	self.m_isSelect = false 	--是否已经选择
	self.m_touchRect = nil
end

--显示正面
function Card:showFront()
	local frame = cc.SpriteFrame:create("Image/GP/img_Pai.png",cc.rect((self.m_num-1)*define.cardWidth,self.m_color*define.cardHeight,define.cardWidth,define.cardHeight))
    self:setSpriteFrame(frame)
end

--显示背面
function Card:showLast()
	local frame = cc.SpriteFrame:create("Image/GP/img_Pai.png",cc.rect(0,4*define.cardHeight,define.cardWidth,define.cardHeight))
    self:setSpriteFrame(frame)
end

--是否露头
function Card:isCardLuTou()
	return self.m_isSelect
end

--如果选择了牌就露头
function Card:selectCardLuTou()
	self.m_isSelect = true

	self:setPosition(cc.p(self:getPositionX(),self:getPositionY()+define.cardLuTouDistance))

	self.m_touchRect.y = self.m_touchRect.y + define.cardLuTouDistance
end

--如果选择的牌就缩头
function Card:selectCardSuoTou()
	self.m_isSelect = false

	self:setPosition(cc.p(self:getPositionX(),self:getPositionY()-define.cardLuTouDistance))
	
	self.m_touchRect.y = self.m_touchRect.y - define.cardLuTouDistance
end

--获取缩放之后的大小
function Card:getScaleContentSize()
	local size = self:getContentSize()
	local scale = cc.p(self:getScaleX(),self:getScaleY())
	return cc.size(size.width * scale.x, size.height * scale.y)
end

--------------设置获取 牌值 花色 是否已经选择---------------
function Card:getNum()
	return self.m_num
end

function Card:setNum(num)
	self.m_num = num
end

function Card:getCardColor()
	return self.m_color
end

function Card:setCardColor(color)
	self.m_color = color
end

function Card:getSelect()
	return self.m_isSelect
end

function Card:setSelect(isSelect)
	self.m_isSelect = isSelect
end
--------------------------------------------------------


return Card