--
-- Author: peter
-- Date: 2017-03-13 14:12:07
--
local gameScene = nil

local WL_Card = class("WL_Card", function()
	return display.newSprite()
end)

function WL_Card:init(scene)
	gameScene = scene
end

function WL_Card:clear()
end

--[[
	* 生成一张牌
	* @param number num  牌值
	* @param number color  花色
--]]
function WL_Card:ctor(cardInfo)
	local num,color

	if cardInfo then
		num,color = gameScene.WL_Util.getCardNumAndColor(cardInfo)
	else
		num,color = 0,0
	end

	self.num = num   			--牌值
	self.color = color  		--花色
	self.isSelect = false 		--是否已经选择
	self.touchRect = nil

--	print("创建一张牌值为 = " .. self.num .. " 花色为 = " .. self.color .. " 的扑克牌")

	if self.num == 0 then
		self:showLast()
	else
		self:showFront()
	end
end

--[[
	* 显示牌正面
	* @param number num  牌值
	* @param number color  花色
--]]
function WL_Card:showFront(cardInfo)
	if cardInfo then
		self.num,self.color = gameScene.WL_Util.getCardNumAndColor(cardInfo)
	end

 	if self.color >= 4 then
 		self:setSpriteFrame(gameScene.WL_Util.card_frames[self.num-13+52])
 	else
 		self:setSpriteFrame(gameScene.WL_Util.card_frames[self.color*13+self.num])
 	end
end

--[[
	* 显示牌背面
--]]
function WL_Card:showLast()
   self:setSpriteFrame(gameScene.WL_Util.card_frames[55])
end

--[[
	* 牌是否被选择
--]]
function WL_Card:isCardLuTou()
	return self.isSelect
end

--[[
	* 设置牌露头
--]]
function WL_Card:setCardLuTou()
	if not self.isSelect then  --如果没有被选择
		self.isSelect = true
		self:setPosition(cc.p(self:getPositionX(),self:getPositionY()+gameScene.WL_Const.CARD_LUTOU_DISTANCE))
		self.touchRect.y = self.touchRect.y + gameScene.WL_Const.CARD_LUTOU_DISTANCE
	end
end

--[[
	* 设置牌缩头
--]]
function WL_Card:setCardSuoTou()
	if self.isSelect then 	--如果已经被选择
		self.isSelect = false
		self:setPosition(cc.p(self:getPositionX(),self:getPositionY()-gameScene.WL_Const.CARD_LUTOU_DISTANCE))
		self.touchRect.y = self.touchRect.y - gameScene.WL_Const.CARD_LUTOU_DISTANCE
	end
end

--[[
	* 设置牌状态(缩头，露头)
--]]
function WL_Card:setCardSelectState()
	if self.isSelect then
		self:setCardSuoTou()
	else
		self:setCardLuTou()
	end
end

--[[
	* 获取牌缩放之后的大小
--]]
function WL_Card:getScaleContentSize()
	local size = self:getContentSize()
	local scale = cc.p(self:getScaleX(),self:getScaleY())
	return cc.size(size.width * scale.x, size.height * scale.y)
end

--------------获取 牌值 花色---------------
function WL_Card:getCardNum()
	return self.num
end

function WL_Card:getCardColor()
	return self.color
end
--------------------------------------------------------

return WL_Card