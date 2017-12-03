local HandCard = class("HandCard", function(_, isHandcard)
	return display.newSprite("Image/card/card_hand.png")
end)

function HandCard:ctor(card, isHandcard)
	local size = self:getContentSize()
	self.num = card.num
	self.color = card.color

	local num, color, colorSmall = self:getCardElement(card)
	if self.color == 4 then
		num:addTo(self):pos(26.5, size.height - 70)
		local crown = display.newSprite("Image/card/xiaowang.png")
		crown:addTo(self):pos(75.5, size.height - 111)
	elseif self.color == 5 then
		num:addTo(self):pos(26.5, size.height - 70)
		local crown = display.newSprite("Image/card/dawang.png")
		crown:addTo(self):pos(75.5, size.height - 111)
	else
		color:addTo(self):pos(73.5, size.height - 111.5)
		colorSmall:addTo(self):pos(27, size.height - 61)
		num:addTo(self):pos(26.5, size.height - 29.5)
	end
end

function HandCard:getCardElement( card )
	local num, color, colorSmall
	if card.color == 4 then
		return display.newSprite("Image/card/num_black_14.png")
	elseif card.color == 5 then
		return display.newSprite("Image/card/num_red_14.png")
	elseif card.color % 2 == 0 then
		num = display.newSprite("Image/card/num_black_"..card.num..".png")
	else
		num = display.newSprite("Image/card/num_red_"..card.num..".png")
	end

	color = display.newSprite("Image/card/color_"..card.color..".png")
	colorSmall = display.newSprite("Image/card/color_s_"..card.color..".png")

	return num, color, colorSmall
end

function HandCard:isContain( x,y,isAllWidth )
	local localPoint = self:convertToNodeSpace(cc.p(x,y))
	local selfRect = cc.rect(0,0,isAllWidth and self:getContentSize().width or 45, self:getContentSize().height)
	-- dump(selfRect, "x = "..localPoint.x.." y = "..localPoint.y)
	return cc.rectContainsPoint(selfRect, localPoint)
end

function HandCard:moveCard(  )
	local posx,posy = self:getPosition()
	self.selected = not self.selected
	if self.selected then
		self:setPosition(cc.p(posx, posy + 30))
		-- self.handCardShadow = display.newSprite("Image/card/card_hand_shadow.png")

		-- self.handCardShadow:addTo(self)
		-- self.handCardShadow:setAnchorPoint(0, 0)
		-- self.handCardShadow:pos(0,0)
	else
		self:setPosition(cc.p(posx, posy - 30))
		-- self.handCardShadow:removeSelf()
	end
end

function HandCard:resetSelect(  )
	local posx,posy = self:getPosition()
	if self.selected then
		self:setPosition(cc.p(posx, posy - 30))
		self.selected = false
		-- self.handCardShadow:removeSelf()
	end
end

function HandCard:isSelected(  )
	return self.selected
end

function HandCard:equals( card )
	-- dump(card, "Card")

	if card.color == 4 or card.color == 5 then
		return card.color == self.color 
	else
		return card.num == self.num and card.color == self.color
	end
end

function HandCard:biggerThan( card )
	local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
	return cardcomparetable[self.num] >  cardcomparetable[card.num]
end


------------------------ OutCard -------------------------------

local function isBaida( card )
	if card.color == 4 or card.color == 5 then
		return card.num ~= 14 and card.num ~= 15
	else
		return false
	end
end 

local OutCard = class("OutCard", function(_, isHandcard)
	return display.newSprite("Image/card/card_thrown.png")
end)

function OutCard:ctor(card)
	local size = self:getContentSize()
	self.num = card.num
	self.color = card.color

	local num, color, colorSmall = self:getCardElement(card, isBaida(card))
	num:setScale(0.8)

	if isBaida(card) then
		num:addTo(self):pos(21.5, size.height - 24)
		color:addTo(self):pos(21.5, size.height - 83)
		colorSmall:addTo(self):pos(22, size.height - 49)
	elseif self.color == 4 then
		num:addTo(self):pos(22, 56) --size.height - 55)
		local crown = display.newSprite("Image/card/xiaowang.png")
		crown:setScale(0.6)
		crown:addTo(self):pos(57.5, size.height - 83)
	elseif self.color == 5 then
		num:addTo(self):pos(22, 56) --size.height - 55)
		local crown = display.newSprite("Image/card/dawang.png")
		crown:setScale(0.6)
		crown:addTo(self):pos(57.5, size.height - 83)
	else
		colorSmall:setScale(0.7)
		color:setScale(0.6)
		num:addTo(self):pos(21.5, size.height - 24)
		colorSmall:addTo(self):pos(22, size.height - 49)
		color:addTo(self):pos(56.5, size.height - 84.5)
	end
end

function OutCard:getCardElement( card )
	if isBaida(card) then
		num = display.newSprite("Image/card/num_brown_"..card.num..".png")
		num:setScale(0.8)
		if card.color == 4 then
			color = display.newSprite("Image/card/num_black_14.png")
		elseif card.color == 5 then
			color = display.newSprite("Image/card/num_red_14.png")
		end
		color:setScale(0.4)
		colorSmall = display.newSprite("Image/card/bianstar.png")
		return num, color, colorSmall
	else
		if card.color == 4 then
			return display.newSprite("Image/card/num_black_14.png")
		elseif card.color == 5 then
			return display.newSprite("Image/card/num_red_14.png")
		elseif card.color % 2 == 0 then
			num = display.newSprite("Image/card/num_black_"..card.num..".png")
		else
			num = display.newSprite("Image/card/num_red_"..card.num..".png")
		end
	end

	color = display.newSprite("Image/card/color_"..card.color..".png")
	colorSmall = display.newSprite("Image/card/color_s_"..card.color..".png")
	return num, color, colorSmall
end

local CardFactory = class("CardFactory", function(card, isHandcard)
	if isHandcard then
		return HandCard.new(card)
	else
		return OutCard.new(card)
	end
end)


return CardFactory
