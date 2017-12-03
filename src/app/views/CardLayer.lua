
local HandcardLayer = class("HandcardLayer", function(card)
    return display.newSprite()
end)

local Card = require("app.views.Card")

function table.exist(t, fn)
    for k, v in pairs(t) do
        if fn(v, k) then return k end
    end
    return nil
end

function HandcardLayer:ctor(cards, isHandcard)
	dump(cards, "cards")
	self.isHandcard = isHandcard
	-- self:sortCards(cards)
	self.cards = {}
	self.cardsCount = (#cards == 0 and 36 or #cards)
	print("self.cardsCount = ", self.cardsCount)
	table.walk(cards, handler(self, self.toCardView))
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.selected))
	self.hasMoved = {}
end

function HandcardLayer:sort(  )
	table.sort(self.cards, function ( a,b )
		if a.num ~= b.num then
			local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
			return cardcomparetable[a.num] < cardcomparetable[b.num]
		else
			return a.color < b.color 
		end
	end)

	table.walk(self.cards, function ( card, index )
		card:pos(self:getCardLocation(index))
		card:zorder(self:getZByIndex(index))
	end)
end

function HandcardLayer:addCard( card )
	-- dump(card,"card in addcard")
	self:toCardView(card, #self.cards + 1)
end

function HandcardLayer:addCardForDeal( card )
	local cardView = app:createView("Card", card, true)
	if #self.cards <= 18 then
		cardView:addTo(self, -#self.cards):pos(0,0)
	else
		cardView:addTo(self, -#self.cards):pos(0,76)
	end

	table.insert(self.cards, 1, cardView)
	for i=2,#self.cards do
		local x,y = self:getCardLocation(i)
		self.cards[i]:pos(x,y)
	end
end

function HandcardLayer:getZByIndex( index )
	return -index
end

function HandcardLayer:toCardView( card, index )
	local cardView = app:createView("Card", card, true)

	local z = self:getZByIndex(index)

	cardView:addTo(self, z):pos(self:getCardLocation(index))
	table.insert(self.cards, cardView)
end

function HandcardLayer:getCurDealcardPos(  )
	return self:getCardLocation(#self.cards + 1)
end

function HandcardLayer:getCardLocation( index )
	local x,y
	local internalLen = self.isHandcard and 45 or 31
	if index > 18 then
		-- print(#self.cards)
		x = 45 * (self.cardsCount - index)
		y = 76
	else
		x = 45 * (18 - index)
		y = 0
	end

	return x,y
end

function HandcardLayer:getCardIndexByLocation( x, y )
	return table.exist(self.cards, function ( card, index )
		return card:isContain(x, y, index == 1 or index == 19)
	end)
end

function HandcardLayer:moveCardByLocation( x,y )
	local selectedIndex = self:getCardIndexByLocation(x, y)
	self.cards[selectedIndex]:moveCard()
end

function HandcardLayer:selected( event )
	local selectedIndex = self:getCardIndexByLocation(event.x, event.y)
	-- self.cards[1]:isContain(event.x, event.y)
	if not selectedIndex then
		print("selectedIndex is nil")
		if self.newSelect then
			self:getParent():onSelectCardFinish(self:getSelectedCards())
			self.newSelect = false
			print("out but select cards")
		end

		return true
	end

	if event.name == "began" then
		self.hasMoved = {}
		self.hasMoved[selectedIndex] = true
		self.cards[selectedIndex]:moveCard()
		print("new select in begin")
		self.newSelect = true
	elseif event.name == "moved" then
		if not self.hasMoved[selectedIndex] then
			self.hasMoved[selectedIndex] = true
			self.cards[selectedIndex]:moveCard()
			self.newSelect = true
			print("new select")
		end
	elseif event.name == "ended" then
		self.hasMoved = {}
		self:getParent():onSelectCardFinish(self:getSelectedCards())
		print("ended in")
	end

	return true
end

function HandcardLayer:selectCards( selectedCards )
	local selectedCardsCopy = {}
	table.walk(selectedCards, function ( card, key )
		selectedCardsCopy[key] = card
	end)

	dump(selectedCardsCopy, "copy")

	for i,handCard in ipairs(self.cards) do
		local selectIndex
		for index,selectedCard in ipairs(selectedCardsCopy) do
			if handCard:equals(selectedCard) then
				selectIndex = index
				break
			end
		end
		if selectIndex then
			table.remove(selectedCardsCopy, selectIndex)
			handCard:moveCard()
			if #selectedCardsCopy == 0 then
				break
			end
		end
	end
end

function HandcardLayer:resetSelect(  )
	table.walk(self.cards, function ( card )
		card:resetSelect()
	end)
end

function HandcardLayer:getSelectedCards(  )
	local res = {}
	table.walk(self.cards, function ( card )
		if card:isSelected() then
			table.insert(res, card)
		end
	end)

	return res
end

function HandcardLayer:getCardLocationByValue( card )
	local pos = self:getCardIndexByValue(card)
	return self:getCardLocation(pos)
end

function HandcardLayer:getCardIndexByValue( card ) 
	for i,v in ipairs(self.cards) do
		if v:biggerThan(card) then
			return i
		end
	end

	return #self.cards
end

function HandcardLayer:insertCard( card )
	local pos = self:getCardIndexByValue(card)
	print("pos = ", pos)
	local z = self:getZByIndex(pos)
	local cardForInsert = app:createView("Card", card, true):addTo(self, z)
	table.insert(self.cards, pos, cardForInsert)
	for i=pos,#self.cards do
		local x, y = self:getCardLocation(i)
		self.cards[i]:pos(x,y)
		z = self:getZByIndex(i)
		self.cards[i]:setLocalZOrder(z)
	end
end

function HandcardLayer:getWidth(  )
	if self.cards[1] == nil then
		return 0
	else
		local cardSize = self.cards[1]:getContentSize()
		return ( (#self.cards > 18 and 18 or #self.cards) - 1)*45 + cardSize.width
	end
end

function HandcardLayer:deleteCards( cardsDelete )
	local i = 1
	while self.cards[i] do
		local index = exist(cardsDelete, function ( card )
			return self.cards[i]:equals(card)
		end)
		if index then
			self.cards[i]:removeSelf()
			table.remove(self.cards, i)
			table.remove(cardsDelete, index)
		else
			i = i + 1
		end
	end

	return self:convert()
end

function HandcardLayer:convert(  )
	local cards = {}
	table.walk(self.cards, function ( card )
		table.insert(cards, {num = card.num, color = card.color})
		card:removeSelf()
	end)
	table.sort(cards, function ( a, b )
		if a.num ~= b.num then
			local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
			return cardcomparetable[a.num] < cardcomparetable[b.num]
		else
			return a.color < b.color 
		end
	end)

	return cards
end

function HandcardLayer:getLeastCards(  )
	local i = 1
	while self.cards[i] do
		if self.cards[i]:isSelected() then
			self.cards[i]:removeSelf()
			table.remove(self.cards, i)
		else
			i = i + 1
		end
	end

	return self:convert()
end

-----------------------------  OutcardLayer ----------------------------------------------
local OutcardLayer = class("OutcardLayer", function(card)
    return display.newSprite()
end)


function OutcardLayer:ctor(cards)
	self:sortCards(cards)
	self.cards = {}
	table.walk(cards, handler(self, self.toCardView))
end

function OutcardLayer:reverse( cards, start, ended )
	while start < ended do
		cards[start], cards[ended] = cards[ended], cards[start]
		start = start + 1
		ended = ended - 1
	end
end

function OutcardLayer:toCardView( card, index )
	local cardView = app:createView("Card", card, false)

    local z
    if self.isHandcard then
        z = index < 19 and 1 or 0
    end

	cardView:addTo(self, z):pos(self:getCardLocation(index))
	table.insert(self.cards, cardView)
end

function OutcardLayer:sortCards( cards )
	if #cards > 18 then
		self:reverse(cards, 1, 18)
		self:reverse(cards, 19, #cards)
	else
		self:reverse(cards, 1, #cards)
	end
end

function OutcardLayer:getCardLocation( index )
	local x,y
	if index > 18 then
		x = 31 * (index - 19)
		y = 76
	else
		x = 31 * (index - 1)
		y = 0
	end

	return x,y
end

function OutcardLayer:getWidth(  )
	local cardSize = self.cards[1]:getContentSize()
	return (#self.cards - 1)*31 + cardSize.width
end




local CardLayerFactory = class("CardLayerFactory", function ( cards, isHandcard )
	if isHandcard then
		return HandcardLayer.new(cards)
	else
		return OutcardLayer.new(cards)
	end
end)

return CardLayerFactory
