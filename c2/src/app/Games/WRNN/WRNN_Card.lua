--
-- Author: peter
-- Date: 2017-04-24 09:55:32
--

local gameScene = nil

local WRNN_Card = class("WRNN_Card",function()
		return display.newSprite()
	end)

function WRNN_Card:init(scene)
	gameScene = scene
end

function WRNN_Card:clear()
end


--[[
	* 生成一张牌
	* @param number cardInfo  牌值 花色
--]]
function WRNN_Card:ctor(cardInfo)
	local num,color

	if cardInfo then
		num,color = gameScene.WRNN_Util.getCardNumAndColor(cardInfo)
	else
		num,color = 0,0
	end

	self.num = num   			--牌值
	self.color = color  		--花色


	if self.num == 0 then
		self:showLast()
	else
		self:showFront()
	end
end

--[[
	* 显示牌正面
	* @param number cardInfo  牌值 花色
--]]
function WRNN_Card:showFront(cardInfo)
	if cardInfo then
		self.num,self.color = gameScene.WRNN_Util.getCardNumAndColor(cardInfo)
	end

 	if self.color >= 4 then
 		self:setSpriteFrame(gameScene.WRNN_Util.card_frames[self.num-13+52])
 	else
 		self:setSpriteFrame(gameScene.WRNN_Util.card_frames[self.color*13+self.num])
 	end
end

--[[
	* 显示牌背面
--]]
function WRNN_Card:showLast()
   self:setSpriteFrame(gameScene.WRNN_Util.card_frames[55])
end

function WRNN_Card:setValue(cardInfo)
	local num,color
    if cardInfo then
		num,color = gameScene.WRNN_Util.getCardNumAndColor(cardInfo)
	else
		num,color = 0,0
	end

	self.num = num   			--牌值
	self.color = color  		--花色
end


return WRNN_Card