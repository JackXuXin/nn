--
-- Author: peter
-- Date: 2017-02-17 13:10:43
--

local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local PATH = SRDDZ_Const.PATH

local SRDDZ_Card = class("SRDDZ_Card", function()
	return display.newSprite()
end)

--[[
	* 生成一张牌
	* @param number num  牌值
	* @param number color  花色
--]]
function SRDDZ_Card:ctor(num,color)
	self.m_num = num or 0     		--牌值
	self.m_color = color or 0  		--花色
	self.m_isSelect = false 		--是否已经选择
	self.m_touchRect = nil

--	print("创建一张牌值为 = " .. self.m_num .. " 花色为 = " .. self.m_color .. " 的扑克牌")

	if self.m_num == 0 then
		self:showLast()
	else
		self:showFront()
	end
end


--[[
	* 显示牌正面
--]]
function SRDDZ_Card:showFront(num,color)
	self.m_num = num or self.m_num
	self.m_color = color or self.m_color

	-- local frame = nil
	-- if self.m_color == 4 then
	-- 	frame = cc.SpriteFrame:create(PATH.IMGS_CARD,cc.rect((self.m_num-14)*SRDDZ_Const.CARD_WIDTH,self.m_color*SRDDZ_Const.CATD_HEIGHT,SRDDZ_Const.CARD_WIDTH,SRDDZ_Const.CATD_HEIGHT))
	-- else
	-- 	frame = cc.SpriteFrame:create(PATH.IMGS_CARD,cc.rect((self.m_num-1)*SRDDZ_Const.CARD_WIDTH,self.m_color*SRDDZ_Const.CATD_HEIGHT,SRDDZ_Const.CARD_WIDTH,SRDDZ_Const.CATD_HEIGHT))
	-- end

 --   	self:setSpriteFrame(frame)

 	if self.m_color >= 4 then
 		self:setSpriteFrame(SRDDZ_Util.card_frames[self.m_num-13+52])
 	else
 		self:setSpriteFrame(SRDDZ_Util.card_frames[self.m_color*13+self.m_num])
 	end
end

--[[
	* 显示牌背面
--]]
function SRDDZ_Card:showLast()
	-- local frame = cc.SpriteFrame:create(PATH.IMGS_CARD,cc.rect(2*SRDDZ_Const.CARD_WIDTH,4*SRDDZ_Const.CATD_HEIGHT,SRDDZ_Const.CARD_WIDTH,SRDDZ_Const.CATD_HEIGHT))
 --   self:setSpriteFrame(frame)

   self:setSpriteFrame(SRDDZ_Util.card_frames[55])
end

--[[
	* 牌是否被选择
--]]
function SRDDZ_Card:isCardLuTou()
	return self.m_isSelect
end

--[[
	* 设置牌露头
--]]
function SRDDZ_Card:setCardLuTou()
	if not self.m_isSelect then  --如果没有被选择
		self.m_isSelect = true
		self:setPosition(cc.p(self:getPositionX(),self:getPositionY()+SRDDZ_Const.CARD_LUTOU_DISTANCE))
		self.m_touchRect.y = self.m_touchRect.y + SRDDZ_Const.CARD_LUTOU_DISTANCE
	end
end

--[[
	* 设置牌缩头
--]]
function SRDDZ_Card:setCardSuoTou()
	if self.m_isSelect then 	--如果已经被选择
		self.m_isSelect = false
		self:setPosition(cc.p(self:getPositionX(),self:getPositionY()-SRDDZ_Const.CARD_LUTOU_DISTANCE))
		self.m_touchRect.y = self.m_touchRect.y - SRDDZ_Const.CARD_LUTOU_DISTANCE
	end
end

--[[
	* 设置牌状态(缩头，露头)
--]]
function SRDDZ_Card:setCardSelectState()
	if self.m_isSelect then
		self:setCardSuoTou()
	else
		self:setCardLuTou()
	end
end

--[[
	* 获取牌缩放之后的大小
--]]
function SRDDZ_Card:getScaleContentSize()
	local size = self:getContentSize()
	local scale = cc.p(self:getScaleX(),self:getScaleY())
	return cc.size(size.width * scale.x, size.height * scale.y)
end

--------------设置获取 牌值 花色---------------
function SRDDZ_Card:getCardNum()
	return self.m_num
end

function SRDDZ_Card:setCardNum(num)
	self.m_num = num
end

function SRDDZ_Card:getCardColor()
	return self.m_color
end

function SRDDZ_Card:setCardColor(color)
	self.m_color = color
end
--------------------------------------------------------

return SRDDZ_Card