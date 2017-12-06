local util = require("app.Games.WL.game_util")
local CardTypeDispatch = util.CardType
local CardArray = util.CardArray
local CardFinder = util.CardFinder
local CardArrayCollection = util.CardArrayCollection
local CardGame = util.CardGame

local lg = {}
lg.CardArray = CardArray

local function getNSameNum( cards )
	for i,v in ipairs(cards:getRepeatetable()) do
		if #v ~= 0  then
			return i
		end
	end

	return 1
end

local function isAllKing( cards )
	for i,v in ipairs(cards) do
		if v.num ~= 14 and v.num ~= 15 then
			return false
		end
	end

	return true
end

local function isKing( card )
	return card.color == 5 or card.color == 4
end


local function isBomb( cards )
	if isAllKing(cards) then
		if #cards == 4 and #cards:getRepeatetable()[2] ~= 0 then
			return true
		else
			return false
		end
	else
		local n = getNSameNum(cards)
		return n >= 4 and  n < 7 and n == #cards
	end
end

local function isRewardBomb( cards )
	if isAllKing(cards) then
		return #cards >= 4
	else
		local n = getNSameNum(cards)
		return n >= 7
	end
end

local function initCardType(  )
	local CardType = {}
	CardType["single"] = CardTypeDispatch.getCardTypeFun("single")
	CardType["double"] = CardTypeDispatch.getCardTypeFun("double")
	CardType["trible"] = CardTypeDispatch.getCardTypeFun("trible")
	CardType["bomb"] = isBomb
	CardType["rewardBomb"] = isRewardBomb

	CardTypeDispatch.init(CardType)
	CardTypeDispatch.setLevel({"rewardBomb"}, 2)
	CardTypeDispatch.setLevel({"bomb"}, 1)
end

 initCardType()

function lg.getCardType( cards )
	cards = util.createCardArray(cards)
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

function getBombLen( cards )
	if isAllKing(cards) then
		if #cards:getRepeatetable()[4] ~= 0 then
			return #cards * 2
		elseif #cards:getRepeatetable()[3] ~= 0 then
			return 3*2 + (#cards - 3)
		else
			if #cards >= 4 then
				return 7
			else
				return 0
			end
		end
	else
		return #cards
	end
end

---compare
local CardCompare = util.CardCompare
CardCompare.init(CardTypeDispatch)
CardCompare.setCompareFun("rewardBomb", function ( a,b )
	local aLen,bLen = getBombLen(a),getBombLen(b)

	if aLen > bLen then
		return true
	elseif aLen == bLen then
		local bAllKinga,bAllkingb = isAllKing(a), isAllKing(b)
		if bAllKinga and bAllkingb then
			return false
		elseif bAllkinga then
			return true
		elseif bAllkingb then
			return false
		else
			return a[1] > b[1]
		end
	else
		return false
	end
end)
CardCompare.setCompareFun("bomb", function ( a,b )
	if #a > #b then
		return true
	elseif #a == #b then
		local bAllKinga,bAllkingb = isAllKing(a), isAllKing(b)
		if bAllKinga and bAllkingb then
			return false
		elseif bAllkinga then
			return true
		elseif bAllkingb then
			return false
		else
			return a[1] > b[1]
		end
	else
		return false
	end

end)
function lg.compare( acards, bcards )
	acards = util.createCardArray(acards)
	bcards = util.createCardArray(bcards)
	return CardCompare.compare(acards, bcards)
end

function lg.compare_( acards,bcards )
	if bcards == nil or #bcards == 0 then
		return false
	else
		return lg.compare(bcards, acards)
	end
end

--finder
local function getAllKings( cards )
	local allKing = lg.CardArray:new()
	for i,v in ipairs(cards) do
		if isKing(v) then
			allKing:add(v)
		end
	end
	return allKing
end

local function resultCardsSortFun( cards )
	table.sort(cards, function ( a,b )
		if a.num ~= b.num then
			return a.num > b.num 
		else
			if a.color == b.color then
				return false
			else
				return a.color > b.color
			end
		end
	end)
	return cards
end

local function findBomb( cards )
	local res = CardArrayCollection:new()
	for i=4,CardArray.repeateTableSize do
		local v = cards:getRepeatetable()[i]
		local j = 1
		while j <= #v do
			append(res, v:sub(j, j + i))
			j = j + i
		end
	end

	local allKingBomb = getAllKings(cards)
	if #allKingBomb >= 4 then
		append(res, allKingBomb)
	end

	return res:filteSame(function ( a,b )
		return a[1].num == b[1].num
	end, CardCompare.compare):map(resultCardsSortFun)
end

function findDoubles( cards )
	local doubleArray = cards:getRepeatetable()[2]
	return CardArrayCollection:new(doubleArray:seprateIntoSamePices(2)):map(resultCardsSortFun)
end

function findTribles( cards )
	local tribleArray = cards:getRepeatetable()[3]
	return CardArrayCollection:new(tribleArray:seprateIntoSamePices(3)):map(resultCardsSortFun)
end

function findSingles( cards )
	local singles = cards:getRepeatetable()[1]
	return CardArrayCollection:new(singles:seprateIntoSamePices(1))
end

local dywlFinder = {}
dywlFinder["single"] = findSingles
dywlFinder["double"] = findDoubles
dywlFinder["trible"] = findTribles
dywlFinder["bomb"] = findBomb
dywlFinder["rewardBomb"] = findBomb
CardFinder.init(dywlFinder)

function lg.find( type, cards )
	return CardFinder.find(type, cards)
end

function hasRewardBomb( cards )
	if cards == nil or #cards == 0 then
		return false
	end
	local res = lg.find("bomb", cards):filte(function ( v )
		return getBombLen(v) >= 7
	end)

	return #res ~= 0
end

function lg.needReDeal( playerCards )
	local handcardWithBomb = playerCards:filte(function ( v )
		return hasRewardBomb(v)
	end)
	if #handcardWithBomb == 0 then
		return true
	else
		return false
	end
end

--cardGame
function CardGame:callbackAfterDeal( leastCards )
	self.scoreAtThisRound = 0
	self.firstHandoutPlayerIndex = self.curOperatePlayer
	self.lastHandoutPlayerIndex = modeRingNum(self.playerNum, self.firstHandoutPlayerIndex - 1)
	self.playerRewardFromRewardBomb = {0,0,0,0}
	self.playerScoreFromCard = {0,0,0,0}
	self.rewardWinnerRecorder = {0,0,0,0}
	self.winner = {}

	walk(self.playerHandCards, function ( i,v )
		table.sort(v)
	end)

	if lg.needReDeal(CardArrayCollection:new(self.playerHandCards)) then
		self:deal()
	end

end

function CardGame:settleScore( winnerIndex )
	self.playerScoreFromCard[winnerIndex] = self.playerScoreFromCard[winnerIndex] + self.scoreAtThisRound
	self.scoreAtThisRound = 0
end

function CardGame:settleScoreAtEndGame( winner )
	--赢家获取所有输家手牌中的分
	for i,v in ipairs(self.playerHandCards) do
		if i ~= winner then
			self.playerScoreFromCard[winner] = self.playerScoreFromCard[winner] + getScoreOfCards(v)
		end
	end

	--奖金计算
	local rewardPlayerNum = 0
	for i=1,self.playerNum do
		if self.rewardWinnerRecorder[i] > 0 then
			rewardPlayerNum = rewardPlayerNum + 1
		end
	end

	if rewardPlayerNum == 1 then
		for i=1,self.playerNum do
			self.rewardWinnerRecorder[i] = 2*self.rewardWinnerRecorder[i]
		end
	end

	--得分计算
	local scoreOfGame = map(self.playerScoreFromCard,function ( a )
		return a - 100
	end)
	self.rewardWinnerRecorder = map(self.rewardWinnerRecorder, function ( a )
		return a*30
	end)
	for i,v in ipairs(self.rewardWinnerRecorder) do
		scoreOfGame[i] = scoreOfGame[i] + 3*v
		local j = modeRingNum(4, i + 1)
		while j ~= i do
			scoreOfGame[j] = scoreOfGame[j] - v
			j = modeRingNum(4, j + 1)
		end
	end

	return scoreOfGame
end

function getScoreOfCards( cards )
	local total = 0

	for i,v in ipairs(cards) do
		if v.num == 5 then
			total = total + 5
		elseif v.num == 10 or v.num == 13 then
			total = total + 10
		end
	end

	return total
end

function CardGame:hasPlayer( playerIndex )
	for i,v in ipairs(self.winner) do
		if v == playerIndex then
			return false
		end
	end

	return true
end

function CardGame:isOver(  )
	return #self.winner >= 3
end

function CardGame:nextPlayer(  )
	self.curOperatePlayer = modeRingNum(self.playerNum, self.curOperatePlayer + 1)
	while not self:hasPlayer(self.curOperatePlayer) do
		self.curOperatePlayer = modeRingNum(self.playerNum, self.curOperatePlayer + 1)
	end
end

function CardGame:getLoserScoreInHand(  )
	local loserIndex
	for i=1,self.playerNum do
		if not findInArray(self.winner, i) then
			loserIndex = i
		end
	end

	return getScoreOfCards(self.playerHandCards[loserIndex])
end

function CardGame:settleLoserScoreInHandToWinner(  )
	self.playerScoreFromCard[self:getFirstWinner()] =  
		self.playerScoreFromCard[self:getFirstWinner()] + self:getLoserScoreInHand()
end

function CardGame:CallbackAfterWin(winner)
	append(self.winner, winner)
	self:nextPlayer()

	if self:isOver() then
		self.playerScoreFromCard[winner] = self.playerScoreFromCard[winner] + self.scoreAtThisRound
		self:settleLoserScoreInHandToWinner()
	end
end

function CardGame:getWinnerIndex( winner )
	return findInArray(self.winner, winner)
end

function CardGame:getFirstWinner(  )
	return self.winner[1]
end

-- function CardGame:callbackAfterDeal(  )
-- 	walk(self.playerHandCards[1], function ( i,v )
-- 		table.sort(v, util.Card.compareByNum)
-- 	end)
-- end

CardGame.CANNOTPASS = 7
CardGame.CANNOTBROKEN = 8
CardGame.CANNOTBROKENKING = 9
CardGame.GAMEHASOVER = 10
function CardGame:handout( playerIndex, handoutCards )
	if playerIndex ~= self.curOperatePlayer then
		return CardGame.NOTCURPLAYER
	end

	if self:isOver() then
		return CardGame.GAMEHASOVER
	end

	self.handoutTime[playerIndex] = 0

	if handoutCards == nil or #handoutCards == 0 then
		if #lg.remindForServer(lg.getCurCard(playerIndex), self.playerHandCards[playerIndex]) ~= 0 or self.curCard.handoutPlayer == playerIndex then
			return CardGame.CANNOTPASS
		else
			if self.lastPassPlayer == nil then
				self.lastPassPlayer = self.curOperatePlayer
			end
			self:nextPlayer()
			if self.curOperatePlayer == self.curCard.handoutPlayer or 
				(self.lastPassPlayer ~= nil and self.lastPassPlayer == self.curOperatePlayer) then
				local roundTotalScore = self.scoreAtThisRound
				if self.curOperatePlayer ~= self.curCard.handoutPlayer then
					self:settleScore(self.curCard.handoutPlayer)
					self.roundWinner = self.curCard.handoutPlayer
				else
					self:settleScore(self.curOperatePlayer)
					self.roundWinner = self.curOperatePlayer
				end
				self.curCard.handoutPlayer = self.curOperatePlayer
				self.curCard.handoutCards = {}
				return CardGame.PASS, roundTotalScore
			else
				return CardGame.PASS, false
			end
		end
	end

	handoutCards = util.createCardArray(handoutCards)
	local cardType = self.cardTypeFun(handoutCards)
	if cardtype == "errorcardtype" then
		return CardGame.ERRORCARDTYPE
	end

	--手牌成炸弹不能拆开打
	local numPre = function ( card )
		return card.num == handoutCards[1].num
	end
	if not isAllKing(handoutCards) and self.playerHandCards[playerIndex]:countOf(numPre) > #handoutCards then
		return CardGame.CANNOTBROKEN
	end

	--王成炸弹不能拆开打
	if isAllKing(handoutCards) then
		local kingsNumInHandCards = #getAllKings(self.playerHandCards[playerIndex])
		local kingsNumInHandoutCards = #getAllKings(handoutCards)
		if kingsNumInHandCards >= 4 and  kingsNumInHandCards ~= kingsNumInHandoutCards then
			return CardGame.CANNOTBROKENKING
		end
	end


	if self.curCard.handoutPlayer == nil or self.curCard.handoutPlayer == playerIndex then
		if isRewardBomb(handoutCards) then
			self.rewardWinnerRecorder[playerIndex]
				= self.rewardWinnerRecorder[playerIndex] + getBombLen(handoutCards) - 6
		end
		self.scoreAtThisRound = self.scoreAtThisRound + getScoreOfCards(handoutCards)
		self.lastPassPlayer = nil
		return self:handoutSuccess(playerIndex, handoutCards),false
	end

	if not self.cardCompareFun(handoutCards, self.curCard.handoutCards) then
		return CardGame.NOTBIGERTHANCUR
	end

	self.firstHandoutPlayerIndex = playerIndex
	self.scoreAtThisRound = self.scoreAtThisRound + getScoreOfCards(handoutCards)
	if isRewardBomb(handoutCards) then
			self.rewardWinnerRecorder[playerIndex]
				= self.rewardWinnerRecorder[playerIndex] + getBombLen(handoutCards) - 6
	end
	self.lastPassPlayer = nil
	return self:handoutSuccess(playerIndex, handoutCards),false
end

function CardGame:handoutAuto(  )
	local canHandoutCards = lg.remindForServer(lg.getCurCard(self.curOperatePlayer), self.playerHandCards[self.curOperatePlayer])
	return canHandoutCards[1], self:handout(self.curOperatePlayer, canHandoutCards[1])
end

function lg.getCount( ... )
	-- body
end

function lg.settleGold( playersGold, gameScore )
	--处理金币不足的情况
	for i,v in ipairs(playersGold) do
		if math.abs(v) < math.abs(gameScore[i]) then
			if gameScore[i] > 0 then
				local margin = math.abs(gameScore[i]) - math.abs(v)
				local loserCount = count(gameScore, function ( vg )
					return vg < 0
				end)
				local averageMargin = margin/loserCount
				gameScore = map(gameScore, function ( vg )
					if vg < 0 then
						return vg + averageMargin
					else
						return vg
					end
				end)
				gameScore[i] = v
			elseif gameScore[i] < 0 then
				local margin = math.abs(gameScore[i]) - math.abs(v)
				local winnerCount = count(gameScore, function ( vg )
					return vg > 0
				end)
				local averageMargin = margin/winnerCount
				gameScore = map(gameScore, function ( vg )
					if vg > 0 then
						return vg - averageMargin
					else
						return vg
					end
				end)
				gameScore[i] = -v
			end
		end
	end

	return map(gameScore, function ( v )
		return v - v%1
	end)
end

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
	{num = 14, color = 4}, {num = 15, color = 5}
}
g_cards = CardArray:new(g_cards)
lg.cardGame = util.CardGame:new({
	playerNum = 4,
	cardNumForPerPlayer = 54,
	timeout = 150,
	doubleCardType = {},
	gloableCards = g_cards:copy() + g_cards:copy() + g_cards:copy() + g_cards:copy(),
	cardCompareFun = lg.compare,
	cardTypeFun = lg.getCardType})
lg.Timer = util.Timer


lg.SUCCESS = util.CardGame.SUCCESS
lg.PASS = util.CardGame.PASS
lg.WIN = util.CardGame.WIN
lg.ERRORCARDTYPE = CardGame.ERRORCARDTYPE

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

local function getAllCardTypes( cards )
	local accumulateAdaptor = function ( a,b )
		return b - a
	end

	return map(
		{"bomb", "trible", "double", "single"},
		function ( a )
			local res = lg.find(a, cards)
			cards = accumulate(accumulateAdaptor, cards, res)
			return res
		end)
end

local function contractAll( cardsArray )
	local contractAdaptor = function ( a,b )
		return contract(a, b)
	end

	return accumulate(function ( a, init )
		return contractAdaptor(init,a)
	end,
	util.createCardArray(),
	cardsArray)
end


function lg.remind( curcard, handcard )
	handcard = util.createCardArray(handcard):copy()
	local cardTypes = getAllCardTypes(handcard)
	cardTypes = accumulate(function ( cardsCollection, init )
		contract(init, cardsCollection)
		return init
	end, CardArrayCollection:new(), cardTypes)
	cardTypes = filte(cardTypes, function ( v )
		if curcard == nil or #curcard == 0 then
			return true
		else
			return lg.compare(v, curcard)
		end
	end)
	table.sort(cardTypes, function ( a,b )
		return lg.compare(b,a)
	end)
	local res = contractAll(cardTypes)
	if #getAllKings(handcard) >= 4 then
		local king = nil
		res = filte(res, function ( card )
			if isKing(card) and king ~= nil then
				return false
			elseif isKing(card) then
				king = card
				return true
			else
				return true
			end
		end)
	end

	local resWithoutSame = util.createCardArray()
	local prev = res[1]
	resWithoutSame:add(prev)
	for i,v in ipairs(res) do
		if prev.num ~= v.num then  	
			resWithoutSame:add(v)
		end
		prev = v
	end 

	return resWithoutSame
end


function lg.remindForServer ( curcard, handcards )
	if curcard == nil or #curcard == 0 then
		local res = handcards:findAll(function ( v )
			if isKing(handcards[1]) and #getAllKings(handcards) >= 4 then
				return isKing(v)
			else
				return v.num == handcards[1].num
			end
		end)
		return CardArrayCollection:new():add(res)
	end
	local cardType = lg.getCardType(curcard)
	local res = lg.find(cardType, handcards)
	if cardType ~= "bomb" or cardType ~= "rewardBomb" then
		res = res + lg.find("bomb", handcards)
	end
	return res:filte(function ( cards )
		if curcard == nil or #curcard == 0 then
			return true
		else
			return lg.compare(cards, curcard)
		end
	end):filte(function ( cards )
		if isKing(cards[1]) then
			return #cards == #getAllKings(handcards)
		else
			return true
		end
	end)
end

function lg.sort( handcard, sortdeny )
	return handcard:sort()
end

local function contractAllForCardTypeSort( cardsArray )
	local contractAdaptor = function ( a,b )
		return contract(b, a)
	end

	return accumulate(function ( a, init )
		return accumulate(contractAdaptor, init, a)
	end,
	util.createCardArray(),
	cardsArray)
end

function lg.sortByCardType( handcard )
	map(handcard, function ( a )
		if a.num == nil then
			a.num = a.m_num
		end
		return a
	end)
	local cards = util.createCardArray(handcard):copy()

	local cardTypes = getAllCardTypes(cards)
	map(cardTypes, function ( a )
		return table.sort(a, lg.compare)
	end)
	local result = contractAllForCardTypeSort(cardTypes)

	-- local i = 1
	-- while i <= #result do
	-- 	local j = i
	-- 	while j <= #handcard do
	-- 		if result[i].num == handcard[j].num and result[i].color == handcard[j].color then
	-- 			break
	-- 		end
	-- 		j = j + 1
	-- 	end
	-- 	handcard[i], handcard[j] = handcard[j], handcard[i]
	-- 	i = i + 1
	-- end

	local handcardCpy = util.Array:new(handcard)
	result:walk(function ( i,card )
		local cardInHandIndex = handcardCpy:findF(function ( cardInHand )
			return util.Card.equals(cardInHand, card)
		end)
		handcard[i] = handcardCpy[cardInHandIndex]
		table.remove(handcardCpy, cardInHandIndex)
	end)

	return result
end


return lg
