local util = require("app.Games.SRDDZ.game_util")
local CardArray = util.CardArray
local BDCardArray = util.BDCardArray
local CardTypeDispatch = util.CardType
local Card = util.Card
local CardArrayCollection = util.CardArrayCollection
local CardFinderComponet = util.CardFinder
local CardCompare = util.CardCompare

local lg = {}
lg.CardArray = CardArray
local CardFinder = {}
util.createCardArray = function ( o )
	return util.BDCardArray:new(o)
end

local function isBdByColor( card )
	if card == nil then
		return false
	else
		return card.color == 4 or card.color == 5
	end
end
util.BDCardArray.__lt = function ( a,b )
	return CardCompare.compare(b:copy(), a:copy())
end

local function deleteAllDb( cards )
	local i = 1
	while i <= #cards do
		if isBdByColor(cards[i]) then
			table.remove(cards, i)
		else
			i = i + 1
		end
	end
	return cards
end

local function findNSequence( cards, n, leastLen, cardTypeName )
	local cardsCpy = util.BDCardArray:new(cards)
	local res = CardArrayCollection:new()
	contract(res, cardsCpy:getAllSequences(n))
	res = res:map(util.createCardArray)
	if cards:find(nil, function ( a, _ )
		return (a.num == 1 and not isBdByColor(a)) or (a.num == 2 and not isBdByColor(a))
	end) then
		cardsCpy = util.BDCardArray:new(cards, function ( a,b )
			return a.num < b.num
		end)
		local anotherSortSequence = cardsCpy:getAllSequences(n,
			function ( a,b )
				return a.num - b.num
			end,
			function ( num )
				if num == 13 then
					return num
				else
					num = num + 1
				end
				return num
			end)

		contract(res, anotherSortSequence:map(function ( v )
			return BDCardArray:new(v, function ( a,b )
				return a.num < b.num
			end)
		end))
	end

	return res:filte(function ( v )
		return #v >= leastLen
	end)
	:filte(function ( v )
		return isSequence(v,n)
	end)
	:map(function ( v )
		v.maxFlag = nil
		return v
	end)
end

--type
local function isTribleSequence( cards )
	if #cards >= 9 then
		return isSequence(cards, 3)
	else
		return false
	end
end

function isSequence(cards, internal)
	local cpyCards = util.BDCardArray:new(cards:copy())
	if cpyCards:isSequence(internal) and not cpyCards:findByNum(2) then
		return true
	end

	cpyCards = util.BDCardArray:new(cards:copy(),function ( a,b )
		return a.num < b.num
	end)
	return cpyCards:isSequence(internal,function ( a,b )
		return a.num - b.num
	end,function(a)
		if a == 13 then
			return a
		else
			a = a + 1
		end
		return a
	end)
end

function isDoubleSequence(cards)
	if #cards >= 6 then
		return isSequence(cards, 2)
	else
		return false
	end
end

local function isAllSameExeptKing( cards )
	local prev = nil
	for i,v in ipairs(cards) do
		if prev ~= nil and prev.num ~= v.num and not isBdByColor(v)	then
			return false
		else
			if not isBdByColor(v) then
				prev = v
			end
		end
	end

	return true
end

local function isTrible( cards )
	return cards:isNSame(3)
end

local function isDouble(cards)
	return cards:isNSame(2)
end

local function isBomb(cards)
	return cards:isAtleastNSame(4)
end

local function isKingBomb( cards )
	if #cards ~= 4 then
		return false
	else
		return cards:isAllEquals(function ( a,b )
			return (a.color == 4 or a.color == 5) and (b.color == 4 or b.color == 5)
		end)
	end
end


local function isTribleAndDouble( cards )
	if #cards ~= 5 then
		return false
	end

	if CardTypeDispatch.getCardTypeFun("tribleAndDouble")(cards) then
		return true
	end

	-- rest conditions contain bd
	local bdCards = cards:findBdCards()
	local cardsWithoutBd = deleteAllDb(cards:copy())
	local repeatetable = cardsWithoutBd:getRepeatetable()
	local singles = cardsWithoutBd:getRepeatetable()[1]
	if #repeatetable[2] == 4 then
		return #bdCards == 1
	elseif #repeatetable[2] == 2 and #singles == 1 then
		return #bdCards == 2
	elseif #repeatetable[2] == 0 and #singles == 2 then
		return #bdCards == 3
	elseif #repeatetable[3] == 3 then
		return #bdCards + #singles == 2
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
	CardType["doubleSequence"] = isDoubleSequence
	CardType["tribleSequence"] = isTribleSequence
	CardType["bomb"] = isBomb
	CardType["kingBomb"] = isKingBomb

	CardTypeDispatch.init(CardType)
	CardTypeDispatch.setLevel({"bomb"}, 1)
	CardTypeDispatch.setLevel({"kingBomb"}, 2)
end

initCardType()

function lg.getCardType( cards )
	cards = util.BDCardArray:new(cards)

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
function CardCompareDispatch.bomb( a, b )
	if #a > #b then
		return true
	elseif #a == #b then
		return a[1] > b[1]
	else
		return false
	end
end

function CardCompareDispatch.trible( a, b )
	return a[1] > b[1]
end

local function getTrible( cards )
	local cardsWithoutBd = deleteAllDb(cards:copy())
	local repeatetable = cardsWithoutBd:getRepeatetable()
	if #repeatetable[3] ~= 0 then
		return repeatetable[3][1]
	else
		return cardsWithoutBd[#cardsWithoutBd]
	end

end

function CardCompareDispatch.tribleAndDouble( a, b )
	return getTrible(a) > getTrible(b)
end

CardCompareDispatch["doubleSequence"] = CardCompare.getCompareFun("doubleSequence")
CardCompareDispatch["tribleSequence"] = CardCompare.getCompareFun("tribleSequence")
CardCompareDispatch["single"] = CardCompare.getCompareFun("single")
CardCompareDispatch["double"] = CardCompare.getCompareFun("double")

function lg.compare( acards, bcards )
	acards = util.createCardArray(acards)
	bcards = util.createCardArray(bcards)
	return CardCompare.compare(acards:copy(), bcards:copy())
end

----finder
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

function CardFinder.bomb( cards )
	return findAtLeastNSame(cards, 4)
end

function CardFinder.single( cards )
	return CardFinderComponet.getCardFinder("single")(cards):sort(function ( a,b )
		local bTypeCollisiona = not cards:getRepeatetable()[1]:hasSub(a)
		local bTypeCollisionb = not cards:getRepeatetable()[1]:hasSub(b)
		if bTypeCollisiona and bTypeCollisionb then
			return a < b
		elseif bTypeCollisiona then
			return false
		elseif bTypeCollisionb then
			return true
		else
			return a < b
		end
	end)
end

function CardFinder.tribleSequence( cards, sequenceLen )
	return findNSequence(cards, 3, 9):filteSame(function ( a,b )
		return a[1].num == b[1].num
	end, function ( a,b )
		if #a ~= #b then
			return #a < #b
		else
			return a[1].num < b[1].num
		end
	end):mapOneToMany(function ( a )
		if sequenceLen == nil then
			return {a}
		else
			return CardFinderComponet.seperateSequence(a, sequenceLen, 3)
		end
	end)
end

function CardFinder.doubleSequence( cards, sequenceLen )
	return findNSequence(cards, 2, 6):filteSame(function ( a,b )
		return a[1].num == b[1].num
	end,function ( a,b )
		if a[1].num ~= b[1].num then
			return a[1].num < b[1].num
		else
			return #a > #b
		end
	end):mapOneToMany(function ( a )
		if sequenceLen == nil then
			return {a}
		else
			return CardFinderComponet.seperateSequence(a, sequenceLen, 2)
		end
	end)
end

function CardFinder.compareFunForSort( a,b,cards,n )
	local bTypeCollisiona = not cards:getRepeatetable()[n]:hasSub(a)
	local bTypeCollisionb = not cards:getRepeatetable()[n]:hasSub(b)
	if bTypeCollisiona and bTypeCollisionb then
		return a < b
	elseif bTypeCollisiona then
		return false
	elseif bTypeCollisionb then
		return true
	else
		return a < b
	end
end

function CardFinder.trible( cards )
	return findNSame(cards, 3)
	:map(function(trible)
		if trible:getBDCount() == 3 then
			trible = trible:map(function (card)
				card.num = 2
				return card
			end)
			return BDCardArray:new(trible)
		else
			return trible
		end
	end)
	:filteSame(function ( a,b )
		return a[1].num == b[1].num and a[2].num == b[2].num and a[3].num == b[3].num
	end)
	:sort(function ( a,b )
		return CardFinder.compareFunForSort(a,b,cards,3)
	end)
end

local function findDoubleKing( cards )
	local bigDoubleKing = util.createCardArray()
	local smallDoubleKing = util.createCardArray()
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
	return findNSame(cards, 2):filteSame(function ( a,b )
		return a[1].num == b[1].num and a[2].num == b[2].num
	end):sort(function ( a,b )
		return CardFinder.compareFunForSort(a,b, cards, 2)
	end) + findDoubleKing(cards)
end

function CardFinder.kingBomb( cards )
	local kingBomb = cards:getAllKings()
	if #kingBomb == 4 then
		return CardArrayCollection:new():add(kingBomb)
	else
		return CardArrayCollection:new()
	end
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
		return #findNSame(a, #a) == 0
	end
	local samePre = function ( a,b )
		local tribleA = getTrible(a)
		local tribleB = getTrible(b)
		return tribleA.num == tribleB.num
	end
	return res
		:filte(bombFilter)
		:map(function ( cards )
		local cardsWithoutBd = deleteAllDb(cards:copy())
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
			return a < b
		end
	end):sort()

end

CardFinder.tribleAndDouble = tribleAndDouble
lg.BDCardArray = BDCardArray

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
	{num = 14, color = 4}, {num = 15, color = 5}
}

lg.cardGame = util.CardGame:new({
	playerNum = 4,
	cardNumForPerPlayer = 25,
	timeout = 150,
	doubleCardType = {"bomb", "kingBomb"},
	gloableCards = g_cards,
	cardCompareFun = CardCompare.compare,
	cardTypeFun = lg.getCardType})
lg.goldSettlement = util.GoldSettlement:new(nil,nil,true)
lg.Timer = util.Timer
lg.ScoreCaller = util.ScoreCaller
lg.CardFinder = CardFinder

lg.SUCCESS = util.CardGame.SUCCESS
lg.PASS = util.CardGame.PASS
lg.WIN = util.CardGame.WIN

lg.ONCALLING = util.ScoreCaller.ONCALLING
lg.GAMEBEGINING = util.ScoreCaller.GAMEBEGINING
lg.GONEXTGAME = util.ScoreCaller.GONEXTGAME
lg.ERROR = util.ScoreCaller.ERROR

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
		curcard = util.BDCardArray:new(curcard):copy()
		local cardType = lg.getCardType(curcard)
		local res = CardFinderComponet.find(cardType, handcard, #curcard):filte(function ( a )
			return CardCompare.compare(a:copy(), curcard:copy())
		end)

		if cardType == "bomb" then
			return res:append(CardFinderComponet.find("kingBomb", handcard))
		elseif cardType == "kingBomb" then
			return CardArrayCollection:new()
		else
			return res:append(CardFinderComponet.find("bomb", handcard))
					:append(CardFinderComponet.find("kingBomb", handcard))
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

function lg.sort( handcard, sortdeny )
	return handcard:sort()
end

function lg.sortByCardType( handcard )
	map(handcard, function ( a )
		if a.num == nil then
			a.num = a.m_num
			a.color = a.m_color
		end
		return a
	end)
	local cards = util.BDCardArray:new(handcard):copy()

	local accumulateAdaptor = function ( a,b )
		return b - a
	end

	local cardTypes = map(
		{"kingBomb", "bomb", "trible", "double", "single"},
		function ( a )
			if a == "kingBomb" then
				return CardFinderComponet.find(a, cards)
			end
			local res = CardFinderComponet.find(a, cards)
			:filte(function ( v )
				local vCopy = v:copy()
				deleteAllDb(vCopy)
				if lg.getCardType(vCopy) == a then
					return true
				else
					return false
				end
			end)
			:map(deleteAllDb)
			cards = accumulate(accumulateAdaptor, cards, res)
			return res
		end)

	map(cardTypes, function ( a )
		return table.sort(a, lg.compare)
	end)

	local contractAdaptor = function ( a,b )
		return contract(b, a)
	end

	local result = accumulate(function ( a, init )
		return accumulate(contractAdaptor, init, a)
	end,
	util.BDCardArray:new(),
	cardTypes)

	result:restoreBd()

	local i = 1
	while i <= #result do
		local j = i
		while j <= #handcard do
			if result[i].num == handcard[j].num and result[i].color == handcard[j].color then
				break
			end
			j = j + 1
		end
		handcard[i], handcard[j] = handcard[j], handcard[i]
		i = i + 1
	end

	return result
end

return lg
