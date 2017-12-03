local util = require("app.models.game_util")
local CardArray = util.CardArray
local BDCardArray = util.BDCardArray
local BDCard = util.BDCard
local CardTypeDispatch = util.CardType
local Card = util.Card
local CardArrayCollection = util.CardArrayCollection
local CardFinderComponet = util.CardFinder
local CardCompare = util.CardCompare
local CardGame = util.CardGame

local lg = {}

function Card:isBd(  )
	return self.color == 4 or self.color == 5
end

local function isSequence(cards, internal)
	if cards:findByNum(2) == nil and cards:isSequence( internal, internal * 2) then 
		return true
	else
		cards = util.CardArray:new(cards, function ( a,b )
			return a.num < b.num
		end)

		return cards:isSequence(internal, internal * 2, function ( a,b )
				return a.num - b.num == 1
			end)
	end
end

--cards 必须为 顺子
local function getSequenceStartNum( cards, internal )
	if cards:findByNum(2) == nil and cards:isSequence( internal, internal * 2) then 
		return cards[1].num
	else
		cards = util.CardArray:new(cards, function ( a,b )
			return a.num < b.num
		end)

		return cards[1].num
	end
end

local function isAllKing( cards )
	return isAll(cards, function ( card )
		return card.color == 4 or card.color == 5
	end)
end 

local function isKingBomb( cards )
	if #cards >= 4 then
		return isAllKing(cards)
	else
		return false
	end
end 

local function isDouble(cards)
	return #cards == 2 and cards:isAllSame() and not isAllKing(cards)
end

local function isTrible( cards )
	return #cards == 3 and cards:isAllSame() and not isAllKing(cards)
end

local function isBomb(cards)
	return (#cards >= 4 and cards:isAllSame()) or isKingBomb(cards)
end

local function isTribleSequence( cards )
	if #cards >= 6 then
		return isSequence(cards, 3)
	else
		return false
	end
end

function isDoubleSequence(cards)
	if #cards >= 4 then
		return isSequence(cards, 2)
	else
		return false
	end
end

function isSingleSequence( cards )
	if #cards == 5 then
		return isSequence(cards, 1)
	else
		return false
	end
end


local function isTribleAndDouble( cards )
	if #cards ~= 5 then
		return false
	end

	return CardTypeDispatch.getCardTypeFun("tribleAndDouble")(cards)
end

local function isFly( cards )
	if #cards >= 10 then
		local flyLen = #cards / 5
		local tribleSequences = cards:getFixlenNSameSequence(3, flyLen*3)
		if findInArray(tribleSequences, _, function ( _,tribleSequence )
			local doubleSequence = cards - tribleSequence
			doubleSequence:sort()
			return isDoubleSequence(doubleSequence)
		end) then
      		return true
    	else
    		cards = CardArray:new(cards, function ( a,b )
    			return a.num < b.num
    		end)
      		tribleSequences = cards:getFixlenNSameSequence(3, flyLen*3,function ( v, prev )
      			return v.num - prev.num
      		end)
      		return findInArray(tribleSequences, _, function ( _,tribleSequence )
				local doubleSequence = cards - tribleSequence
				return isDoubleSequence(doubleSequence)
			end)
		end
	else
		return false
	end
end 

local function initCardType(  )
	local CardType = {}
	CardType["single"] = CardTypeDispatch.getCardTypeFun("single")
	CardType["double"] = isDouble
	CardType["trible"] = isTrible
	CardType["tribleAndDouble"] = isTribleAndDouble
	CardType["singleSequence"] = isSingleSequence
	CardType["doubleSequence"] = isDoubleSequence
	CardType["tribleSequence"] = isTribleSequence
	CardType["bomb"] = isBomb
	CardType["fly"] = isFly

	CardTypeDispatch.init(CardType)
	CardTypeDispatch.setLevel({"bomb"}, 1)
end

initCardType()

function lg.getCardType( cards )
	cards = util.CardArray:new(cards)

	local types = CardTypeDispatch.getCardType(cards)
	if #types ~= 0 then
		local typeIndex = 1
		local maxLevelType = types[typeIndex]
		for i,v in ipairs(types) do
			if CardTypeDispatch.getLevelByType(v) > CardTypeDispatch.getLevelByType(maxLevelType) then
				maxLevelType = v
			end
		end
		return maxLevelType
	else
		return nil
	end

end

----compare
local CardCompareDispatch = {}
CardCompare.init(CardTypeDispatch, CardCompareDispatch)

local function getBombSize( cards )
	if isKingBomb(cards) then
		return #cards * 2
	else
		return #cards
	end
end 
lg.getBombSize = getBombSize
function CardCompareDispatch.bomb( a, b )
	local bombSizea = getBombSize(a)
	local bombSizeb = getBombSize(b)
	if bombSizea > bombSizeb then
		return true
	elseif bombSizea == bombSizeb then
		return a[1] > b[1]
	else
		return false
	end
end

function CardCompareDispatch.trible( a, b )
	return a[1] > b[1]
end

local function getTrible( cards )
	local repeatetable = cards:getRepeatetable()
	if #repeatetable[3] ~= 0 then
		return repeatetable[3][1]
	else
		return nil
	end

end

function CardCompareDispatch.tribleAndDouble( a, b )
  local carda = getTrible(a)
  local cardb = getTrible(b)
	return carda > cardb
end

local function getFlyValue( cards )
	local tribleSequence = cards:getRepeatetable()[3]
	return tribleSequence[1]
end 

function CardCompareDispatch.fly( a,b )
	local aValue = getFlyValue(a)
	local bValue = getFlyValue(b)

	return aValue.num > bValue.num
end

function CardCompareDispatch.singleSequence( a, b )
	local numa = getSequenceStartNum(a,1)
	local numb = getSequenceStartNum(b,1)
	return numa > numb
end

function CardCompareDispatch.doubleSequence( a,b )
	local numa = getSequenceStartNum(a,2)
	local numb = getSequenceStartNum(b,2)
	return numa > numb
end

function CardCompareDispatch.tribleSequence( a,b )
	local numa = getSequenceStartNum(a,3)
	local numb = getSequenceStartNum(b,3)
	return numa > numb
end

CardCompareDispatch["single"] = CardCompare.getCompareFun("single")
CardCompareDispatch["double"] = CardCompare.getCompareFun("double")

function lg.compare( acards, bcards )
	acards = CardArray:new(acards)
	bcards = CardArray:new(bcards)
	local result = CardCompare.compare(acards:copy(), bcards:copy())
	return result
end

lg.BDCardArray = BDCardArray

----finder
local CardFinder = {}
CardFinderComponet.init(CardFinder)

local function findAtLeastNSame( cards, n )
	return CardArrayCollection:new(cards:getAtleastNsame(n))
end

local function findNSame( cards, n )
	local bdNum = #cards:findBdIndexs()
	local res = CardArrayCollection:new()
	contract(res, util.BDCardArray:new(cards):getNSames(n))

	if cards:getBDCount() >= n then
		append(res, cards:findBdCards():sub(1, n + 1))
	end
	return res:map(function ( a )
		return util.BDCardArray:new(a)
	end)
end

local function findKingBomb( cards )
	local kingBomb = cards:findAll(BDCard.isBd)
	if #kingBomb >= 4 then
		kingBomb = BDCardArray:new(kingBomb)
		kingBomb:restoreBd()
		return CardArrayCollection:new({kingBomb})
	else
		return CardArrayCollection:new()
	end
end 

function CardFinder.bomb( cards, bombLen )
	local res = util.CardArrayCollection:new()
	bombLen = (bombLen == nil and 4 or bombLen)
	for i=bombLen,15 do
		local iSames = cards:getNSames(i)
		cards:restoreBd()
		if #iSames > 0 then
			res:append(iSames)
		end
	end
	return res:append(findKingBomb(cards)) 
end

function CardFinder.single( cards )
	return CardFinderComponet.getCardFinder("single")(cards):sort(function ( a,b )
		local bTypeCollisiona = not cards:getRepeatetable()[1]:hasSub(a)
		local bTypeCollisionb = not cards:getRepeatetable()[1]:hasSub(b)
		if bTypeCollisiona and bTypeCollisionb then
			return a[1] < b[1]
		elseif bTypeCollisiona then
			return false
		elseif bTypeCollisionb then
			return true
		else
			return a[1] < b[1]
		end
	end)
end

local function findSequence( cards, internal, sequenceLen )
	local res1 = cards:getFixlenNSameSequence(internal, sequenceLen)

	cards = util.BDCardArray:new(cards,function ( a,b )
		return a.num < b.num
	end)
	local res2 = cards:getFixlenNSameSequence(internal, sequenceLen, function ( a,b )
		return a.num - b.num
	end,function(a)
		if a == 13 then
			return a
		else
			a = a + 1
		end
		return a
	end)

	return (res1 + res2):filteSame(function ( a,b )
		return a[1].num == b[1].num
	end, function ( a,b )
		return a[1].num < b[1].num
	end)

end 

function CardFinder.singleSequence( cards, sequenceLen )
	return findSequence(cards, 1, sequenceLen)
end

function CardFinder.tribleSequence( cards, sequenceLen )
	return findSequence(cards, 3, sequenceLen)
end

function CardFinder.doubleSequence( cards, sequenceLen )
	return findSequence(cards, 2, sequenceLen)
end

function CardFinder.fly( cards, sequenceLen )
	local res = CardArrayCollection:new()

	local tribleSequences = CardFinder.tribleSequence(cards, sequenceLen/5*3)
	walk(tribleSequences, function ( _,tribleSequence )
		tribleSequence = BDCardArray:new(tribleSequence)
		local doubleSequenceSource = cards - tribleSequence
		local doubleSequences = CardFinder.doubleSequence(doubleSequenceSource, sequenceLen/5*2)
		if #doubleSequences > 0 then
			append(res, tribleSequence + doubleSequences[1])
		end
	end)

	return res
end

local function findNSame( cards, n )
	return cards:getNSames(n):filte(function ( resultItem )
		if isAllKing(resultItem) then
			return isAll(resultItem, function ( card )
				return card.color == 4
			end) or isAll(resultItem, function ( card )
				return card.color == 5
			end)

		else
			return true
		end
	end)
end 

function CardFinder.trible( cards )
	return cards:getNSames(3)
end

local function findDoubleKing( cards )
	local bigDoubleKing = util.BDCardArray:new()
	local smallDoubleKing = util.BDCardArray:new()
	for i,v in ipairs(cards) do
		if v.color == 5 then
			bigDoubleKing:add(v)
		elseif v.color == 4 then
			smallDoubleKing:add(v)
		end
	end

	local res = CardArrayCollection:new()
	if #bigDoubleKing == 2 then
		bigDoubleKing:restoreBd()
		append(res, bigDoubleKing:copy())
	end
	if #smallDoubleKing == 2 then
		smallDoubleKing:restoreBd()
		append(res, smallDoubleKing:copy())
	end
	return res
end

function CardFinder.double( cards )
	return cards:getNSames(2) +findDoubleKing(cards)
end



local function tribleAndDouble( cards )
	local tmpCpy = util.BDCardArray:new(cards)
	local tribles = tmpCpy:getNSames(3)
	local res = CardArrayCollection:new()
	for i,trible in ipairs(tribles) do
		if trible:getBDCount() < 3 then
			local double = util.BDCardArray:new(tmpCpy - trible):getBestNSame(2)
			if double ~= nil and double:getBDCount() < 2 then
				append(res, trible + double)
			end
		end
	end

	local bombFilter = function ( a )
		a = util.BDCardArray:new(a)
		local isBomb = (#a:getNSames(#a) ~= 0)
    return not isBomb
	end
	local samePre = function ( a,b )
		local tribleA = getTrible(a)
		local tribleB = getTrible(b)
		return tribleA.num == tribleB.num
	end
	return res
		:filte(bombFilter)
		:map(function ( cards )
    cards = BDCardArray:new(cards)
		local cardsWithoutBd = cards:copy():deleteAllDb()
		local repeatetable = cardsWithoutBd:getRepeatetable()
		local bdIndexs = cards:findBdIndexs()
		local singles = cardsWithoutBd:getRepeatetable()[1]
		if #repeatetable[3] ~= 0 then
			return cards
		elseif #repeatetable[2] == 4 then
			cards[bdIndexs[1]].num = repeatetable[2][4].num
		elseif #repeatetable[2] == 2 then
			if repeatetable[2][1] > singles[1] then
				cards[bdIndexs[1]].num = repeatetable[2][2].num
				cards[bdIndexs[2]].num = singles[1].num
			else
				cards[bdIndexs[1]].num = singles[1].num
				cards[bdIndexs[2]].num = singles[1].num
			end
		elseif #repeatetable[2] == 0 then
			cards[bdIndexs[1]].num = singles[2].num
			cards[bdIndexs[2]].num = singles[2].num
			cards[bdIndexs[3]].num = singles[1].num
		end
		cards:sort()
		return cards
	end):filteSame(samePre, function ( a,b )
		a = BDCardArray:new(a)
		b = BDCardArray:new(b)
		local tribleA = getTrible(a)
		local tribleB = getTrible(b)
		if tribleA.num == tribleB.num then
			if #a:findBdIndexs() ~= 0 then
				return false
			elseif #b:findBdIndexs() ~= 0 then
				return true
			else
				return false
			end
		else
			return lg.compare(b,a)
		end
	end):sort(function ( a,b )
		return lg.compare(b,a)
	end)

end

CardFinder.tribleAndDouble = tribleAndDouble
lg.BDCardArray = BDCardArray
lg.CardArray = CardArray

local g_cards = {
	{num = 3, color = 0}, {num = 3, color = 1}, {num = 3, color = 2}, {num = 3, color = 3},
	{num = 4, color = 0}, {num = 4, color = 1}, {num = 4, color = 2}, {num = 4, color = 3},
	{num = 5, color = 0}, {num = 5, color = 1}, {num = 5, color = 2}, {num = 5, color = 3},
	{num = 6, color = 0}, {num = 6, color = 1}, {num = 6, color = 2}, {num = 6, color = 3},
	{num = 7, color = 0}, {num = 7, color = 1}, {num = 7, color = 2}, {num = 7, color = 3},
	{num = 8, color = 0}, {num = 8, color = 1}, {num = 8, color = 2}, {num = 8, color = 3},
	{num = 9, color = 0}, {num = 9, color = 1}, {num = 9, color = 2}, {num = 9, color = 3},
	{num = 10, color = 0}, {num = 10, color = 1}, {num = 10, color = 2}, {num = 10, color = 3},
	{num = 11, color = 0}, {num = 11, color = 1}, {num = 11, color = 2}, {num = 11, color = 3},
	{num = 12, color = 0}, {num = 12, color = 1}, {num = 12, color = 2}, {num = 12, color = 3},
	{num = 13, color = 0}, {num = 13, color = 1}, {num = 13, color = 2}, {num = 13, color = 3},
	{num = 1, color = 0}, {num = 1, color = 1}, {num = 1, color = 2}, {num = 1, color = 3},
	{num = 2, color = 0}, {num = 2, color = 1}, {num = 2, color = 2}, {num = 2, color = 3},
	{num = 14, color = 4}, {num = 15, color = 5},
		{num = 3, color = 0}, {num = 3, color = 1}, {num = 3, color = 2}, {num = 3, color = 3},
	{num = 4, color = 0}, {num = 4, color = 1}, {num = 4, color = 2}, {num = 4, color = 3},
	{num = 5, color = 0}, {num = 5, color = 1}, {num = 5, color = 2}, {num = 5, color = 3},
	{num = 6, color = 0}, {num = 6, color = 1}, {num = 6, color = 2}, {num = 6, color = 3},
	{num = 7, color = 0}, {num = 7, color = 1}, {num = 7, color = 2}, {num = 7, color = 3},
	{num = 8, color = 0}, {num = 8, color = 1}, {num = 8, color = 2}, {num = 8, color = 3},
	{num = 9, color = 0}, {num = 9, color = 1}, {num = 9, color = 2}, {num = 9, color = 3},
	{num = 10, color = 0}, {num = 10, color = 1}, {num = 10, color = 2}, {num = 10, color = 3},
	{num = 11, color = 0}, {num = 11, color = 1}, {num = 11, color = 2}, {num = 11, color = 3},
	{num = 12, color = 0}, {num = 12, color = 1}, {num = 12, color = 2}, {num = 12, color = 3},
	{num = 13, color = 0}, {num = 13, color = 1}, {num = 13, color = 2}, {num = 13, color = 3},
	{num = 1, color = 0}, {num = 1, color = 1}, {num = 1, color = 2}, {num = 1, color = 3},
	{num = 2, color = 0}, {num = 2, color = 1}, {num = 2, color = 2}, {num = 2, color = 3},
	{num = 14, color = 4}, {num = 15, color = 5},
		{num = 3, color = 0}, {num = 3, color = 1}, {num = 3, color = 2}, {num = 3, color = 3},
	{num = 4, color = 0}, {num = 4, color = 1}, {num = 4, color = 2}, {num = 4, color = 3},
	{num = 5, color = 0}, {num = 5, color = 1}, {num = 5, color = 2}, {num = 5, color = 3},
	{num = 6, color = 0}, {num = 6, color = 1}, {num = 6, color = 2}, {num = 6, color = 3},
	{num = 7, color = 0}, {num = 7, color = 1}, {num = 7, color = 2}, {num = 7, color = 3},
	{num = 8, color = 0}, {num = 8, color = 1}, {num = 8, color = 2}, {num = 8, color = 3},
	{num = 9, color = 0}, {num = 9, color = 1}, {num = 9, color = 2}, {num = 9, color = 3},
	{num = 10, color = 0}, {num = 10, color = 1}, {num = 10, color = 2}, {num = 10, color = 3},
	{num = 11, color = 0}, {num = 11, color = 1}, {num = 11, color = 2}, {num = 11, color = 3},
	{num = 12, color = 0}, {num = 12, color = 1}, {num = 12, color = 2}, {num = 12, color = 3},
	{num = 13, color = 0}, {num = 13, color = 1}, {num = 13, color = 2}, {num = 13, color = 3},
	{num = 1, color = 0}, {num = 1, color = 1}, {num = 1, color = 2}, {num = 1, color = 3},
	{num = 2, color = 0}, {num = 2, color = 1}, {num = 2, color = 2}, {num = 2, color = 3},
	{num = 14, color = 4}, {num = 15, color = 5},
	{num = 3, color = 0}, {num = 3, color = 1}, {num = 3, color = 2}, {num = 3, color = 3},
	{num = 4, color = 0}, {num = 4, color = 1}, {num = 4, color = 2}, {num = 4, color = 3},
	{num = 5, color = 0}, {num = 5, color = 1}, {num = 5, color = 2}, {num = 5, color = 3},
	{num = 6, color = 0}, {num = 6, color = 1}, {num = 6, color = 2}, {num = 6, color = 3},
	{num = 7, color = 0}, {num = 7, color = 1}, {num = 7, color = 2}, {num = 7, color = 3},
	{num = 8, color = 0}, {num = 8, color = 1}, {num = 8, color = 2}, {num = 8, color = 3},
	{num = 9, color = 0}, {num = 9, color = 1}, {num = 9, color = 2}, {num = 9, color = 3},
	{num = 10, color = 0}, {num = 10, color = 1}, {num = 10, color = 2}, {num = 10, color = 3},
	{num = 11, color = 0}, {num = 11, color = 1}, {num = 11, color = 2}, {num = 11, color = 3},
	{num = 12, color = 0}, {num = 12, color = 1}, {num = 12, color = 2}, {num = 12, color = 3},
	{num = 13, color = 0}, {num = 13, color = 1}, {num = 13, color = 2}, {num = 13, color = 3},
	{num = 1, color = 0}, {num = 1, color = 1}, {num = 1, color = 2}, {num = 1, color = 3},
	{num = 2, color = 0}, {num = 2, color = 1}, {num = 2, color = 2}, {num = 2, color = 3},
	{num = 14, color = 4}, {num = 15, color = 5}
}

local jtCardGame = {}
setmetatable(jtCardGame, CardGame)
jtCardGame.__index = jtCardGame

function jtCardGame:new(gameMsg, callback)	
	local newObj = CardGame:new(gameMsg, callback)	
	setmetatable(newObj, jtCardGame)
	return newObj
end

function jtCardGame:getSpecialWin(  )
	return filte(self.playerHandCards, function (handcard )
		return self:checkSpecialWin(handcard)
	end)
end

-- function jtCardGame:clear(  )
-- 	self.playerHandCards = {{}, {}, {}, {}, {}, {}}
-- 	self.playerScore = {0,0,0,0,0,0}
-- 	self.playerValidScore = {0,0,0,0,0,0}
-- end

function jtCardGame:deal(  )
	CardGame.deal(self)

	-- self.playerHandCards[1][1] = {num = 14, color = 4}
	-- self.playerHandCards[1][2] = {num = 14, color = 4}
	-- self.playerHandCards[1][3] = {num = 14, color = 4}
	-- self.playerHandCards[1][4] = {num = 14, color = 4}

	local winPlayer = self:getSpecialWin()
	if #winPlayer > 0 then
		local scores = {}
		walk(winPlayer, function ( seat )
			scores[seat] = (6 - #winPlayer)*2
		end)
		for i=1,6 do
			if scores[i] == nil then
				scores[i] = -#winPlayer*2
			end
		end

		self.playerValidScore = {0,0,0,0,0,0}
		self:setWinnerScore(scores)
		self:setLoserScore(scores)
		return scores
	else
		return nil
	end
end

function jtCardGame:beginGame(  )
	CardGame.beginGame(self)
	self.innerPlayer = {true, true, true, true, true, true}
	self.curScore = 0
	self.outterCount = 0
	self.playerScore = {0,0,0,0,0,0}
	self.playerValidScore = {0,0,0,0,0,0}
end

function jtCardGame:getScore( cards )
	local total = 0

	for i,v in ipairs(cards) do
		if v.num == 5 and not v:isBd() then
			total = total + 5
		elseif (v.num == 10 or v.num == 13) and not v:isBd() then
			total = total + 10
		end
	end

	return total
end

function jtCardGame:nextPlayer(  )
	CardGame.nextPlayer(self)
	while not self.innerPlayer[self.curOperatePlayer] do
		CardGame.nextPlayer(self)
	end
end

function jtCardGame:beforeLastHanoutPlayerHasNoPlayer(  )
	if self.lastPassPlayer == nil then
		return false
	end

	local i = modeRingNum(self.playerNum, self.lastPassPlayer + 1) 
	while i ~= self.lastPassPlayer do
		if self.innerPlayer[i] then
			return false
    elseif i == self.curCard.handoutPlayer then
      return true
		else
			i = modeRingNum(self.playerNum, i + 1) 
		end
	end
  
end

function jtCardGame:isSameTeam( player1, player2 )
	return player1%2 == player2%2
end

function jtCardGame:teamAddToValidScore( outPlayer )
	-- luadump(self.playerScore, "playerScore")
	walk(self.playerScore, function ( player, score )
		if self:isSameTeam(outPlayer, player) then
			self.playerValidScore[player] = self.playerValidScore[player] + score
			self.playerScore[player] = 0
		end
	end)	
	-- luadump(self.playerValidScore, "playerValidScore")
end

function jtCardGame:getTeamScore( team )
	return accumulate(function ( score, init )
		return init + score
	end,
	0,
	filte(self.playerValidScore,function ( validScore, player )
		return team == player%2
	end))
end

function jtCardGame:isAllTeamOut( team )
	return not exist(self.innerPlayer, function ( isIn, index )
		return index % 2 == team 
	end)
end

function jtCardGame:isNoneTeamOut( team )
  local team1 = {1,3,5}
  local team2 = {2,4,6}
  local teamGroup = {}
  teamGroup[0] = team2
  teamGroup[1] = team1
  return not exist(teamGroup[team], function (seat)
      return not self.innerPlayer[seat]
  end)
end

function jtCardGame:getScoresByTeamFlag( teamFlag, multi )
	local scores = {}
	for i=1,6 do
		if i % 2 == teamFlag then
			scores[i] = multi 
		else
			scores[i] = -multi
		end
	end

	return scores
end

function jtCardGame:getGameResult( outPlayer )
	local outPlayerTeamScore = self:getTeamScore(outPlayer%2)
	local otherTeamScore = self:getTeamScore((outPlayer + 1)%2)

	-- LOG_DEBUG("outPlayerTeamScore = %d, otherTeamScore = %d", outPlayerTeamScore, otherTeamScore)
	if otherTeamScore >= 200 and outPlayerTeamScore > 0 then
		local winTeam = (outPlayer + 1)%2
		return self:getScoresByTeamFlag(winTeam, 1)
	elseif outPlayerTeamScore >= 200 and otherTeamScore > 0 then
		local winTeam = outPlayer%2
		return self:getScoresByTeamFlag(winTeam, 1)
	elseif outPlayerTeamScore == 400 then
		local winTeam = outPlayer%2
		return self:getScoresByTeamFlag(winTeam, 2)
	elseif self:isAllTeamOut(outPlayer%2) then
		local winTeam = outPlayer%2

		if self:isNoneTeamOut((outPlayer + 1)%2) or otherTeamScore == 0 then
			return self:getScoresByTeamFlag(winTeam, 2)
		else
			return self:getScoresByTeamFlag(winTeam, 1)
		end
	else
		return false
	end
end

function jtCardGame:setWinnerScore( scores )
	self.winnerScore = 0
	walk(scores, function ( seat,score )
		if score > 0 then
			self.winnerScore = self.winnerScore + self.playerValidScore[seat]
		end
	end)
end

function jtCardGame:setLoserScore( scores )
	self.loserScore = 0

	walk(scores, function ( seat,score )
		if score < 0 then
			self.loserScore = self.loserScore + self.playerValidScore[seat]
		end
	end)
end


function jtCardGame:handout( playerIndex, handoutCards )
	local result = CardGame.handout(self, playerIndex, handoutCards)
	if CardGame.SUCCESS == result then
		self.curScore = self:getScore(handoutCards) + self.curScore
		self.lastPassPlayer = nil
	elseif CardGame.WIN == result then
		self.outterCount = self.outterCount + 1
		self.innerPlayer[playerIndex] = nil
		self.lastPassPlayer = nil

		-- luadump(self.innerPlayer, "innerPlayer")

		if self.outterCount == 5 then
			self.playerScore[playerIndex] = self.playerScore[playerIndex] + self:getScore(handoutCards) + self.curScore
			for seat,leastPlayer in pairs(self.innerPlayer) do
				self.playerScore[playerIndex] = self.playerScore[playerIndex] + self:getScore(self.playerHandCards[seat])
			end
			-- luadump(self.playerScore, "playerScore")
			self.playerValidScore[playerIndex] = self.playerValidScore[playerIndex] + self.playerScore[playerIndex]
			self.playerScore[playerIndex] = 0

			local scores = self:getScoresByTeamFlag(playerIndex%2, 1)
			self:setWinnerScore(scores)
			self:setLoserScore(scores)
			return {result = CardGame.WIN, scores = scores}
		else
			self.curScore = self:getScore(handoutCards) + self.curScore
			if self.outterCount == 1 then
				self:teamAddToValidScore(playerIndex)
			else
				self.playerValidScore[playerIndex] = self.playerValidScore[playerIndex] + self.playerScore[playerIndex]
				self.playerScore[playerIndex] = 0
			end

			-- luadump(self.playerValidScore, "self.playerValidScore")

			local scores = self:getGameResult(playerIndex)
			
			if scores then
				self:setWinnerScore(scores)
				self:setLoserScore(scores)
				result = CardGame.WIN
				return {result = CardGame.WIN, scores = scores}
			else
				self:nextPlayer()
				result = CardGame.SUCCESS
			end
		end
	elseif CardGame.PASS == result then
		self.lastPassPlayer = playerIndex
		if self.curCard.handoutPlayer == self.curOperatePlayer or self:beforeLastHanoutPlayerHasNoPlayer() then
			local curScore = self.curScore
			local roundWinner
			if self.curOperatePlayer ~= self.curCard.handoutPlayer then
				self.playerValidScore[self.curCard.handoutPlayer] = self.playerValidScore[self.curCard.handoutPlayer] + self.curScore
				roundWinner = self.curCard.handoutPlayer
				-- luadump(self.playerValidScore, "self.playerValidScore")
			else
				self.playerScore[self.curOperatePlayer] = self.playerScore[self.curOperatePlayer] + self.curScore
				roundWinner = self.curOperatePlayer
			end
			self.curScore = 0
			self.curCard = {}

			-- luadump(self.playerScore, "playerScore")
			return {
				result = CardGame.PASS, curPlayer = self.curOperatePlayer, 
				roundWinner = roundWinner, score = curScore
			}
		end
	end

	return {result = result, score = self.curScore, curPlayer = self.curOperatePlayer}
end

function jtCardGame:getCurcard(  )
	return {seat = self.curCard.handoutPlayer, cards = self.curCard.handoutCards}
end

function CardGame:dividePlayer( cards )
	local sortedCards = CardArray:new(cards)
	local red = {}
	local blue = {}

	if sortedCards:hasNsame(4) or sortedCards:hasNsame(5) or sortedCards:hasNsame(6) then
		return nil
	elseif sortedCards:hasNsame(3) then
		local redCard = sortedCards:getRepeatetable()[3][1]
		walk(cards, function ( i,card )
			if card.num == redCard.num then
				append(red, i)
			else
				append(blue, i)
			end
		end)
	elseif sortedCards:hasNsame(2) then 
		local redCards = sortedCards:getRepeatetable()[2]
		if #redCards == 2 then
			local leastCards = sortedCards - redCards
      leastCards:sort()
			walk(cards, function ( i,card )
				if card.num == redCards[1].num or card.num == leastCards[4].num then
					append(red, i)
				else
					append(blue, i)
				end
			end)
		elseif #redCards == 4 then
			local leastCards = sortedCards - redCards
			walk(cards, function ( i,card )
				if card.num == redCards[1].num or card.num == leastCards[1].num then
					append(red, i)
				else
					append(blue, i)
				end
			end)
		end
	else
		walk(cards, function ( i,card )
			local index = sortedCards:find(card)
			if index > 3 then
				append(red, i)
			else
				append(blue, i)
			end
		end)
	end

	return {red = red, blue = blue}
end

local function moreThan9( cards )
	return findInArray({9,10,11,12,13,14,15,16}, _, function ( _,times )
		return #cards:getRepeatetable()[times] > 0
	end)
end 

local function has4king( cards )
	return cards:getRepeatetable()[4]:findByNum(14) or cards:getRepeatetable()[4]:findByNum(15)
end 

function jtCardGame:checkSpecialWin( cards )
	return moreThan9(cards) or has4king(cards)
end

lg.cardGame = jtCardGame:new({
	playerNum = 6,
	cardNumForPerPlayer = 36,
	timeout = 150,
	gloableCards = g_cards,
	cardCompareFun = lg.compare,
	cardTypeFun = lg.getCardType})
lg.goldSettlement = util.GoldSettlement:new(nil,nil,true)
lg.Timer = util.Timer
lg.CardFinder = CardFinder

lg.SUCCESS = util.CardGame.SUCCESS
lg.PASS = util.CardGame.PASS
lg.WIN = util.CardGame.WIN

lg.WAIT = 0
lg.CALLSCORE = 1
lg.INGAME = 2
lg.TUOGUAN = 3

function lg.getCurCard( seatid )
	if lg.cardGame.curCard.handoutPlayer == seatid then
		return util.createCardArray()
	else
		if lg.cardGame.curCard.handoutCards == nil then
			return util.createCardArray()
		else
			return lg.cardGame.curCard.handoutCards
		end
	end
end

function lg.canAllhandout( handcard )
	return lg.getCardType(handcard) ~= nil
end

function lg.remind( curcard, handcard )
	handcard = util.BDCardArray:new(handcard):copy()
	if curcard == nil or #curcard == 0 then
		return CardFinderComponet.find("single", handcard)
	else
		curcard = util.CardArray:new(curcard):copy()
		local cardType = lg.getCardType(curcard)
		local res = CardFinderComponet.find(cardType, handcard, #curcard):filte(function ( a )
			a = util.CardArray:new(a)
			return CardCompare.compare(a:copy(), curcard:copy())
		end)

		if cardType ~= "bomb" then
			return res:append(CardFinderComponet.find("bomb", handcard))
		else
	      return res
	    end
	end
end

function lg.findSequence( curcard, handcard )
	handcard = util.createCardArray(handcard):copy()
	if curcard == nil or #curcard == 0 then
		if lg.canAllhandout( handcard ) then
			return handcard
		else
			return (CardFinderComponet.find("tribleSequence", handcard)
						+ CardFinderComponet.find("doubleSequence", handcard))[1]
		end
	else
		return lg.remind( curcard, handcard )[1]
	end
end


function lg.sort( handcard )
	handcard = CardArray:new(handcard)
	return handcard:sort()
end

function lg.getCardTypeForClient( cards )
	cards = BDCardArray:new(cards)

	local res = {}
	if cards:hasBd() then
		for typename,finderFun in pairs(CardFinder) do
			cards:restoreBd()
			local outCards = finderFun(cards, #cards)[1]
			if outCards ~= nil and #outCards == #cards then
				table.insert(res, outCards)
			end
		end
	else
		if lg.getCardType(cards) then
			table.insert(res, cards)
		end
	end

	return res
end

function lg.getCardsForDivde(  )
	local dealor = util.Dealor:new(0,g_cards)
	dealor:shuffle()
	return dealor.cards:sub(1, 7)
end

return lg