
local util = {}

function append( t, v )
	if t == nil then
		t = {}
	end
	t[#t == 0 and 1 or #t + 1] = v
	return t
end


function seprateIntoSamePices( cards, picesLen )
	local i = 1
	local res = {}
	while i <= #cards do
		append(res, cards:sub(i, i + picesLen))
		i = i + picesLen
	end
	return res
end

function abs( num )
	if num < 0 then
		return -num
	else
		return num
	end
end

function newArray( arraySize )
	local array = {}
	for i=1,arraySize do
		array[i] = {}
	end

	return array
end

function newArrayWithValue( arraySize, initVal )
	local array = {}
	for i=1,arraySize do
		array[i] = initVal
	end

	return array
end

function findLastFun( array, compareFun, startIndex, endIndex )
	if compareFun(array[startIndex]) == 0 then
		return startIndex
	elseif compareFun(array[endIndex]) == 0 then
		return endIndex
	else
		return nil
	end
end

function findInsertIndexFun( array, compareFun, startIndex, endIndex )
	if compareFun(array[startIndex]) <= 0 then
		return startIndex
	elseif compareFun(array[endIndex]) >= 0 then
		return endIndex + 1
	else
		return endIndex
	end
end

function binaryFind_( array, compareFun, startIndex, endIndex, lastFun )
	if endIndex - startIndex <= 1 then
		return lastFun(array, compareFun, startIndex, endIndex)
	else
		local midIndex = math.floor((startIndex + endIndex)/2)
		local midVar = array[midIndex]
		if compareFun(midVar) > 0 then
			return binaryFind_(array, compareFun, midIndex, endIndex, lastFun)
		elseif compareFun(midVar) < 0 then
			return binaryFind_(array, compareFun, startIndex, midIndex, lastFun)
		elseif compareFun(midVar) == 0 then
			return midIndex
		end
	end
end

function binaryFind( array, compareFun )
  if array == nil or #array == 0 then
    return nil
  else
    return binaryFind_(array, compareFun, 1, #array, findLastFun)
  end
end

function binaryFindInsertIndex( array, compareFun )
  if array == nil or #array == 0 then
    return 1
  else
    return binaryFind_(array, compareFun, 1, #array, findInsertIndexFun)
  end
end

function findInArray( array, item, f )
	if f == nil then
		f = function ( a,b )
			return a == b
		end
	end

	for i,v in ipairs(array) do
		if f(item,v) then
			return i
		end
	end

	return nil
end

function findByF( array, f )
	for i,v in ipairs(array) do
		if f(v,i) then
			return i
		end
	end

	return nil
end

function findAll( array, f )
	local res = {}
	for i,v in ipairs(array) do
		if f(v,i) then
			append(res, v)
		end
	end

	return res
end

function findAllIndexs( array, f )
	local res = {}
	for i,v in ipairs(array) do
		if f(v,i) then
			append(res, i)
		end
	end

	return res
end

function isAll( array, pre )
	for i,v in ipairs(array) do
		if not pre(v) then
			return false
		end
	end

	return true
end


function modeRingNum( mode, num )
	if num > mode then
		return 1
	elseif num < 1 then
		return mode
	else
		return num
	end
end

function distanceOfRingNum( mode, num1, num2 )
	if num2 >= num1 then
		return num2 - num1
	else
		return num2 + mode - num1
	end
end

function excuteFunctionMaybeNil( f, ... )
	if f ~= nil then
		return f(...)
	end
end

function copyArray( array, itemGenerator )
	local res = {}
	if array then
		for i,v in ipairs(array) do
			append(res, itemGenerator and itemGenerator(v) or v)
		end
	end
	return res
end

function filte( array, filter )
	local res = {}
	if array then
		for k,v in ipairs(array) do
			if filter(v, k) then append(res, v) end
		end
	end
	return res
end

function equalsFun( a,b )
	return a == b
end

function filteSame( array, sameFun, comFun )
	local prev = nil
	if sameFun == nil then
		sameFun = equalsFun
	end
	table.sort( array, comFun )
	return filte(array, function ( v )
		if prev == nil then
			prev = v
			return true
		elseif not sameFun(prev, v) then
			prev = v
			return true
		else
			return false
		end
	end)
end

function map( array, mapper )
	local res = {}
	for i,v in ipairs(array) do
		res[i] = mapper(v, i)
	end

	return res
end

function mapOneToMany( array, oneToManyMapper )
	local res = {}
	for i,v in ipairs(array) do
		local mapResult = oneToManyMapper(v)
		for k,kv in ipairs(mapResult) do
			append(res, kv)
		end
	end

	return res
end

function accumulate( pro, init, array )
	if array == nil then
		return init
	end

	for i,v in ipairs(array) do
		init = pro(v, init)
	end

	return init
end


function contract( array1, array2 )
    for k,v in ipairs(array2) do
		array1[#array1 == 0 and 1 or #array1 + 1] = v
	end
	return array1
end


function count( array, f )
	local count = 0
	for i,v in ipairs(array) do
		if f(v) then
			count = count + 1
		end
	end

	return count
end

function walk( array,f )
	for i,v in ipairs(array) do
		f(i, v)
	end
end

function max( array, comFun )
	if array == nil or #array == 0 then
		return nil
	end

	if comFun == nil then
		comFun = function ( a,b )
			return a > b
		end
	end

	local max = array[1]
	for i,v in ipairs(array) do
		if comFun(v, max) then
			max = v
		end
	end

	return max
end

function exist( array, pre )
	for i,v in pairs(array) do
		if pre(v,i) then
			return i
		end
	end

	return nil
end

function deepcopy(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = deepcopy(v)
        end
    end
    return tab
end

local Array = {}
Array.__index = Array

function Array:new( array )
	local o = deepcopy(array)
	setmetatable(o, Array)
	return o
end

function Array.fromNumber( number )
	local array = Array:new()
	for i=1,number do
		append(array, i)
	end

	return array
end

function Array:contract( array )
	contract(self, array)
	return self
end

function Array:append( array )
	return self:contract(array)
end

function Array:map( f )
	local mapDes = map(self, f)
	setmetatable(mapDes, Array)
	return mapDes
end

function Array:filte( f )
	local filteDes = filte(self, f)
	setmetatable(filteDes, Array)
	return filteDes
end

function Array:filteSame( sameFun, sortFun  )
	local noneSame = filteSame(self, sameFun, sortFun)
	setmetatable(noneSame, Array)
	return noneSame
end

function Array:accumulate( init, f )
	return accumulate(f, init, self)
end

function Array:find( item )
	return self:findF(function ( v )
		return v == item
	end)
end

Array.findAll = Array.filter

function Array:findF( f )
	for i,v in ipairs(self) do
		if f(v, i) then
			return i
		end
	end

	return nil
end

function Array:count( item )
	return self:countF(function ( v )
		return item == v
	end)
end

function Array:countF( f )
	local cnt = 0
	for i,v in ipairs(self) do
		if f(v,i) then
			cnt = cnt + 1
		end
	end

	return cnt
end

function Array:sort( f )
	table.sort(self, f)
	return self
end

function Array:finAllF( f )
	local res = findAll(self, f)
	setmetatable(res, Array)
	return res
end

function Array:findAll( item )
	return findAll(self, function ( v )
		return item == v
	end)
end

function Array:walk( f )
	walk(self, f)
end

function Array:walkIf( ifFun, excuteFun )
	for i,v in ipairs(self) do
		if ifFun(i,v) then
			excuteFun(i,v)
		end
	end
end

function Array:walkIfDif( isDifFun, difCallback )
	local prev = nil
	for i,v in ipairs(self) do
		if prev == nil or isDifFun(prev, v) then
			difCallback(v,i)
			prev = v
		end
	end
end

local Card = {}
Card.__index = Card

Card.__lt = function ( a,b )
	local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
	return cardcomparetable[a.num] < cardcomparetable[b.num]
end
Card.__sub = function ( a,b )
	local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
	return cardcomparetable[a.num] - cardcomparetable[b.num]
end

function Card:new( num, color )
	local o = {}
	o.num = num
	o.color = color
	setmetatable(o, Card)

	return o
end

function Card:copy( card )

	return Card:new(self.num, self.color)

end

function Card:toInt32(  )
	return self.color * 16 + self.num
end

function Card.fromInt32( int32 )
	return Card:new( int32%16, int32/16 - int32/16%1)
end

function Card:equals( card )
	if card == nil then
		return false
	end
	return self.num == card.num and self.color == card.color
end

function Card:getCardEqualsPre( )
	return function ( card )
		return self:equals(card)
	end
end

function Card:toStr(  )
	return string.format("{num = %d, color = %d}", self.num, self.color)
end

function Card.compareByNum( carda, cardb )
	return carda.num < cardb.num
end

function Card.getSubFum( num )
	return function ( a,b )
		return a.num - b.num == num
	end
end

local CardArray = {}
setmetatable(CardArray, Array)
CardArray.__index = CardArray

CardArray.__add = function ( a,b )
	local res = contract(a:copy(),b)
	res = util.createCardArray(res, a.sortFun)
--	table.sort( res, a.sortFun )
    return res
end

CardArray.__sub = function ( a,b )
	if a:hasSub(b) == false then error("argument#2 larger than argument1") end
	local res = util.createCardArray()
	local sortFun = function ( a,b )
		if a.num == b.num then
			return a.color < b.color
		else
			return a.num < b.num
		end
	end
	local aCopy = a:copy()
	local bCopy = b:copy()
	table.sort(aCopy, sortFun)
	table.sort(bCopy, sortFun)
	local ia = 1
	local ib = 1
	while ia <= #aCopy do
		if aCopy[ia]:equals(bCopy[ib]) then
			ia = ia + 1
			ib = ib + 1
		else
			append(res, aCopy[ia])
			ia = ia + 1
		end
	end
	return res
end

CardArray.__eq = function ( a,b )
	for k,v in ipairs(a) do
		if v ~= b[k] then
			return false
		end
	end
	return true
end

function CardArray:new( cardarray, sortFun )
	local o = {}
	setmetatable(o, CardArray)

	if type(cardarray) == "table" then
		for k,v in ipairs(cardarray) do
			append(o, Card:new(v.num, v.color))
		end
		table.sort( o, sortFun )
	end
	o.sortFun = sortFun

	return o
end

CardArray.repeateTableSize = 16
function CardArray:createRepeatetable(  )
	local prev = 0
	local repeattime = 1
	self.repeateTable = newArray(CardArray.repeateTableSize)
	for i,v in ipairs(self.repeateTable) do
		self.repeateTable[i] = util.createCardArray()
	end
	--self.repeateTable = map(self.repeateTable, util.createCardArray)
	local repeateStart = 1
	for k,v in ipairs(self) do
		if v.num == prev then
			repeattime = repeattime + 1
		else
			self.repeateTable[repeattime] = self.repeateTable[repeattime] + self:sub(repeateStart, k)
			repeattime = 1
			prev = v.num
			repeateStart = k
		end
	end

	if repeateStart <= #self then
		self.repeateTable[repeattime] = self.repeateTable[repeattime] + self:sub(repeateStart, #self + 1)
	end

	return self.repeateTable
end

function CardArray:resetRepeatetable(  )
	return self:createRepeatetable()
end

function CardArray:getRepeatetable(  )
	if self.repeateTable ~= nil then
		return self.repeateTable
	end
	return self:createRepeatetable()
end

function CardArray:seprateIntoSamePices( picesLen )
	local res = seprateIntoSamePices(self, picesLen)
	return map(res, function ( v )
		return util.createCardArray(v)
	end)
end

function CardArray:hasNsame( n )
	return #self:getRepeatetable()[n] ~= 0
end

function CardArray:getAtleastNsame( n )
	local res = util.createCardArray()
	for i = n,CardArray.repeateTableSize do
		if #self:getRepeatetable()[i] ~= 0 then
			res = res + self.repeateTable[i]
		end
	end

	res.sortFun = self.sortFun
	return res
end

function CardArray:toStr(  )
	local str = ""
	local rowSize = 6
	for i,v in ipairs(self) do
		str = str..","..v:toStr()
		if i % rowSize == 0 then
			str = str.."\n"
		end
	end
	str = str.."\n"

	return str
end

function CardArray:toInt32Array(  )
	return map(self, function ( card )
		return card:toInt32()
	end)
end

function CardArray.fromInt32Array( int3Array )
	if int3Array == nil then
		return util.createCardArray()
	else
		return util.createCardArray( map(int3Array, function ( int32 )
				return Card.fromInt32(int32)
			end))
	end
end

function CardArray:getAllKings( )
	local allKing = CardArray:new()
	for i,v in ipairs(self) do
		if v.num == 14 or v.num == 15 then
			allKing:add(v)
		end
	end
	return allKing
end

function CardArray:deleteAll( card )
	local i = 1
	while i <= #self do
		if self[i]:equals(card) then
			table.remove(self, i)
		else
			i = i + 1
		end
	end
end

function CardArray:addManyCard( num, card )
	for i=1,num do
		append(self, card:copy())
	end
end

function CardArray:addManyCardAt( num, card, index )
	for i=1,num do
		table.insert(self, index, card:copy())
	end
end

local CardArrayCollection = {}
CardArrayCollection.__index = CardArrayCollection
CardArrayCollection.__add = function ( a,b )
	local res = CardArrayCollection:new()
	for i,v in ipairs(a) do
		append(res,v)
	end
	for i,v in ipairs(b) do
		append(res,v)
	end

	return res
end

function CardArrayCollection:toStr()
	local str = ""
	for i,v in ipairs(self) do
		str = str..v:toStr()
		str = str.."\n"
	end
	return str
end

function CardArrayCollection:new( v )
	local obj = copyArray(v)
	setmetatable(obj, CardArrayCollection)
	return obj
end

function CardArrayCollection:add( cards )
	if cards == nil or #cards == 0 then
		return self
	else
		append(self, cards)
		return self
	end
end

function CardArrayCollection:append( collection )
	for i,v in ipairs(collection) do
		append(self, v)
	end
	return self
end

function CardArrayCollection:filte( filter )
	return CardArrayCollection:new(filte(self, filter))
end

function CardArrayCollection:filteSame( sameFun, comFun )
	return CardArrayCollection:new(filteSame(self, sameFun, comFun))
end

function CardArrayCollection:sort( sortFun )
	table.sort( self, sortFun )
	return self
end
function CardArrayCollection:map( mapper )
	return CardArrayCollection:new(map(self, mapper))
end

function CardArrayCollection:mapOneToMany( oneToManyMapper )
	return CardArrayCollection:new(mapOneToMany(self, oneToManyMapper))
end

CardArray.CardArrayCollection = CardArrayCollection

function CardArray:getAllSequences( n, f )
	local res = CardArrayCollection:new()
	local nSameElement = self:getAtleastNsame(n)
	if nSameElement == nil or #nSameElement == 0 then return res end
	table.sort(nSameElement, self.sortFun)

	local repeatetime = 1
	local prev = nSameElement[1]
	local nSameSequence = util.createCardArray()
	nSameSequence:add(prev)
	local i = 2
	while i <= #nSameElement do
		local v = nSameElement[i]
		if f and f(v, prev) == 0 or v.num == prev.num then
			repeatetime = repeatetime + 1
			if repeatetime <= n then
				nSameSequence:add(v)
			end
		else
			if f and f(v, prev) > 1 or (v - prev > 1) then
				append(res, nSameSequence)
				nSameSequence = util.createCardArray()
			end
			repeatetime = 1
			prev = v
			nSameSequence:add(v)
		end
		i = i + 1
	end

	if #nSameSequence >= n then
		append(res, nSameSequence)
	end

	return res
end

function CardArray:getAtleastLenNSameSequence( n, leastLen,f )
	return self:getAllSequences(n, f)
		:filte(function ( cards )
			return #cards >= leastLen
		end)
end

function CardArray:getFixLens( fixlen )
	local i = 1
	local fixLenCollection = CardArrayCollection:new()

	while i+fixlen <= #self + 1 do
		append(fixLenCollection, self:sub(i, i+fixlen))
		i = i + 1
	end
	return fixLenCollection
end

function CardArray:getFixlenNSameSequence( n,fixlen,f )
	return accumulate(function ( resItem,fixLenCollection )
		local i = 1
		while i+fixlen <= #resItem + 1 do
			append(fixLenCollection, resItem:sub(i, i+fixlen))
			i = i + n
		end
		return fixLenCollection
	end,
	CardArrayCollection:new(),
	self:getAtleastLenNSameSequence(n, fixlen, f))
end

function CardArray:getNSames( n )
	local res = CardArrayCollection:new()
	for i=n,CardArray.repeateTableSize do
		accumulate(function ( nSameCards, nSameRes )
			local i = 1
			while i <= #nSameCards do
				local nSameItem = nSameCards:sub(i, i + n)
				if #nSameItem == n then
					append(nSameRes, nSameItem)
				else
					break
				end
				i = i + n
			end
			return nSameRes
		end,
		res,
		self:getRepeatetable()[i]:seprateIntoSamePices(i))
	end

	return res
end

function CardArray:getExactNSame( n )
	return self:getRepeatetable()[n]:seprateIntoSamePices(n)
end

function CardArray:createNumPre( num )
	local numPre = function ( card, num )
		return card.num == num
	end
	return numPre
end

function CardArray:find( card, f )
	if card ~= nil and type(card) == "table" then
		card = Card:new(card.num, card.color)
	end
	local findF = f ~= nil and f or function ( a,b )
		return a:equals(b)
	end
	for k,v in ipairs(self) do
		if findF(v,card) then return k end
	end

	return nil
end

function CardArray:findByNum( num )
	return self:find(nil, function ( v )
		return v.num == num
	end)
end

function CardArray:findAllIndexs( card, f )
	card = Card:new(card.num, card.color)
	local findF = f ~= nil and f or function ( a,b )
		return a:equals(b)
	end
	local res = {}
	for k,v in ipairs(self) do
		if findF(v,card) then
			append(res, k)
		end
	end

	return res
end

function CardArray:sort(  )
	table.sort( self, self.sortFun )
	return self
end

function CardArray:clear(  )
	for k,v in pairs(self) do
		self[k] = nil
	end
end

function CardArray:isempty( )
	return #self == 0
end

function CardArray:hasSub( sub )
	if #sub > #self then return false end
	local selfCopy = self:copy()
	for k,v in ipairs(sub) do
		local index = selfCopy:find(v)
		if index == nil then
			return false
		else
			table.remove(selfCopy, index)
		end
	end

	return true
end

function CardArray:sub( s,e )
	local tmp = util.createCardArray(_,self.sortFun)
	for i,v in ipairs(self) do
		if i >= s and i < e then
			tmp:add(v)
		end
	end

	return tmp
end

function CardArray:add( card )
	append(self, card)
	return self
--	table.sort(self)	--暂时先这么处理，比较简单
end

function CardArray:append( cards )
	for i,v in ipairs(cards) do
		self:add(v)
	end

	return self
end

--删除牌
function CardArray:delete( card )
	local index = self:find(card)
	if index == nil then return false
	else
		table.remove(self, index)
		return true
	end
end

function CardArray:copy(  )
	return util.createCardArray(copyArray(self, function ( a )
		return a:copy()
	end))
end

function CardArray:countOf( predicator )
	local count = 0
	for i,v in ipairs(self) do
		if predicator(v) then count = count + 1 end
	end
	return count
end

function CardArray:findAll( predicator )
	local res = util.createCardArray()
	for i,v in ipairs(self) do
		if predicator(v) then append(res, v) end
	end

	return res
end

function CardArray:findAllByNum( cardNum )
	return self:findAll(function ( card )
		return card.num == cardNum
	end)
end

function CardArray:findNSameF( n, f )
	local res = findAll(self, f)
	setmetatable(res, CardArray)
	return res
end


function CardArray:findNsameByNum( n )
	local f = function ( a,b )
		return a.num == b.num
	end

	return self:findNSameF(n, f)
end

function CardArray:isAllSame( leastLen, sameFun )
	if leastLen ~= nil and #self < leastLen then
		return false
	end

	local firstCard = self[1]
	return not findInArray(self, _, function ( _,card )
		return firstCard.num ~= card.num
	end)
end

function CardArray:isSequence( internalLen, leastLen, f )
	if #self < leastLen or (#self:getRepeatetable()[internalLen] ~= #self) then
		return false
	end

	local fun = f ~= nil and f or function ( a,b )
		return a - b == 1
	end

	local i = 1
	while i + internalLen <= #self do
		if not fun(self[i + internalLen], self[i]) then
			return false
		else
			i = i + internalLen
		end
	end

	return true
end

function CardArray:isAllEquals( f )
	local fun = nil
	if f == nil then
		fun = function ( a,b )
			return a == b
		end
	else
		fun = f
	end

	local a = self[1]
	for i,v in ipairs(self) do
		if not fun(a, v) then
			return false
		end
	end

	return true
end

function CardArray:clearRepeatetable(  )
	self.repeateTable = nil
end

local BDCard = {}
setmetatable(BDCard, Card)
BDCard.__index = BDCard
BDCard.__sub = Card.__sub
BDCard.__lt = Card.__lt

function BDCard:new( num, color )
	local newObj = Card:new( num, color)
	setmetatable(newObj, BDCard)
	return newObj
end

function BDCard:equals(card)
	if self:isBd() and card:isBd() then
		return true
	elseif self:isBd() or card:isBd() then
		return false
	else
		return Card.equals(self, card)
	end
end

function BDCard:isBd(  )
	return self.color == 4 or self.color == 5
end

function BDCard:copy()
  return BDCard:new(self.num, self.color)
end

function BDCard.fromInt32( int32 )
  local newCard = Card.fromInt32(int32)
  setmetatable(newCard, BDCard)
  return newCard
end

local BDCardArray = {}
setmetatable(BDCardArray, CardArray)
BDCardArray.__index = BDCardArray
BDCardArray.__add = function (a,b)
  local res = CardArray.__add(a,b)
  setmetatable(res, BDCardArray)
  return res
end
BDCardArray.__sub = function ( a,b )
	if a:hasSub(b) == false then error("argument#2 larger than argument1") end
	local res = util.createCardArray()
	local sortFun = function ( a,b )
		if a.num == b.num then
			return a.color < b.color
		else
			return a.num < b.num
		end
	end
	local aCopy = a:copy()
	local bCopy = b:copy()
  aCopy:restoreBd()
  bCopy:restoreBd()
	table.sort(aCopy, sortFun)
	table.sort(bCopy, sortFun)
	local ia = 1
	local ib = 1
	while ia <= #aCopy and ib <= #bCopy do
		if aCopy[ia]:equals(bCopy[ib]) then
			ia = ia + 1
			ib = ib + 1
		else
			append(res, aCopy[ia])
			ia = ia + 1
		end
	end
	return contract(res,aCopy:sub(ia, #aCopy + 1))
end

BDCardArray.maxFlag = 13
function BDCardArray:new( cardarray, sortFun )
	local newObj = {}
	if type(cardarray) == "table" then
		for k,v in ipairs(cardarray) do
			append(newObj, BDCard:new(v.num, v.color))
		end
		table.sort( newObj, sortFun )
	end
	newObj.sortFun = sortFun
	setmetatable(newObj, BDCardArray)
	return newObj
end

function BDCardArray.fromInt32Array( int32array )
	local newArray = CardArray.fromInt32Array(int32array)
	setmetatable(newArray, BDCardArray)
	return newArray
end

function BDCardArray:isBd( card )
	if card == nil then
		return false
	else
		return card:isBd()
	end
end

function BDCardArray:find( card, f )
	if card ~= nil and type(card) == "table" then
		card = BDCard:new(card.num, card.color)
	end
	local findF = f ~= nil and f or function ( a,b )
		return a:equals(b)
	end
	for k,v in ipairs(self) do
		if findF(v,card) then return k end
	end

	return nil
end

function BDCardArray:findBdIndexs( )
	local dump = {num = 0, color = 0}
	return self:findAllIndexs(dump, function ( a, _ )
		return self:isBd(a)
	end)
end

function BDCardArray:restoreBd()
	return self:map(function ( card )
		if self:isBd(card) then
			if card.color == 4 then
				card.num = 14
			end
			if card.color == 5 then
				card.num = 15
			end
		end
		return card
	end
	)
end

function BDCardArray:findBdCards()
	local bdIndexs = self:findBdIndexs()
	local bdCards = BDCardArray:new()
	for i,v in ipairs(bdIndexs) do
		bdCards:add(self[v])
	end
	return bdCards
end

function BDCardArray:hasBd(  )
	return exist(self, BDCard.isBd)
end

function BDCardArray:getBDCount(  )
	return #self:filte(function ( card )
		return self:isBd(card)
	end)
end


function BDCardArray:changeNbdToCard( n, bdIndexs, card )
	if n > #bdIndexs then
		return false
	else
		local bdIndexHasChanges = {}
		while n >= 1 do
			self[bdIndexs[n]].num = card.num
			append(bdIndexHasChanges, bdIndexs[n])
			table.remove(bdIndexs, n)
			n = n - 1
		end
		return true, bdIndexHasChanges
	end
end

function BDCardArray:copy(  )
	return BDCardArray:new(self, self.sortFun)
end

function BDCardArray:changeNbdToNum( n, bdIndexs, num )
	if n > #bdIndexs then
		return false
	else
		local bdIndexHasChanges = {}
		while n >= 1 do
			self[bdIndexs[n]].num = num
			append(bdIndexHasChanges, bdIndexs[n])
			table.remove(bdIndexs, n)
			n = n - 1
		end
		return true, bdIndexHasChanges
	end
end

function BDCardArray:filteSameCard(  )
	local startFlags = Array:new()

	self:walkIfDif(function ( prev,v )
		return prev.num ~= v.num
	end, function ( v,_ )
		if not self:isBd(v) then
			append(startFlags, v)
		end
	end)

	return startFlags
end

function BDCardArray:getSequencesStartIndexs(  )
	local startIndexs = {}

	self:walkIfDif(function ( prev,v )
		return prev.num ~= v.num and not self:isBd(v)
	end, function ( v,i )
		startIndexs[v.num] = i
	end)

	return startIndexs
end

function BDCardArray:clearOtherFeatrue(  )
	self.sortFun = nil
end

function BDCardArray:getCardCountMap(  )
	return Array.fromNumber(BDCardArray.maxFlag):map(function ( i, cardNum )
		return self:countOf(function ( card )
			return card.num == cardNum and not self:isBd(card)
		end)
	end)
end

function BDCardArray:getNeedBDCount(n, bdCountMap, cardNum)
	return n - bdCountMap[cardNum] < 0 and 0 or n - bdCountMap[cardNum]
end

function BDCardArray:getEndFlagsFromStart(n, sequenceStartFlags,  bdCountMap,increaseFun)
	local bdCount = self:getBDCount()
	local sequenceEndFlags = sequenceStartFlags:map(function  ( startFlag )
		local endFlag = nil
		local flag = startFlag.num
		local i = self:getNeedBDCount(n, bdCountMap, flag)
		while i <= bdCount  do
			endFlag = flag
			local tmpFlag = increaseFun(flag)
			if tmpFlag == flag then
				break
			end
			flag = tmpFlag
			i = i + self:getNeedBDCount(n, bdCountMap, flag)
		end

		if endFlag then
			return util.Card:new(endFlag,0)
		else
			return 0
		end
	end)

	return sequenceEndFlags
end

function BDCardArray:filteEndFlags( f, sequenceEndFlags )
	local prevEndFlag = nil
	for i,v in ipairs(sequenceEndFlags) do
   		if v == 0 or (prevEndFlag ~= nil and f(prevEndFlag,v) >= 0) then
			sequenceEndFlags[i] = nil
		end
		if v ~= 0 then
			prevEndFlag = v
		end
	end

	return sequenceEndFlags
end

function BDCardArray:getEndFlags( n, sequenceStartFlags, bdCountMap, f, increaseFun )
	local sequenceEndFlags = self:getEndFlagsFromStart(n, sequenceStartFlags,  bdCountMap,increaseFun)
	return self:filteEndFlags(f, sequenceEndFlags)
end

function BDCardArray:constructNSequence( n,leastLen,f,increaseFun )
	local res = CardArrayCollection:new()

	local sequenceStartFlags = self:filteSameCard()
	local bdCountMap = self:getCardCountMap()
	local sequenceEndFlags = self:getEndFlags(n, sequenceStartFlags, bdCountMap,f,increaseFun)
	for i,startFlag in ipairs(sequenceStartFlags) do
		if sequenceEndFlags[i] then
			append(res, self:getSequencesFromFlag(n, startFlag, sequenceEndFlags[i],f,increaseFun, bdCountMap))
		end
	end

	return res
end

function BDCardArray:getBDChanges( n, startFlag, endFlag, f, increaseFun, bdCountMap)
	local flag = startFlag:copy()
	local bdIndexs = self:findBdIndexs()
	local hasChangedBdIndexs = {}
	while f(endFlag, flag) >= 0 do
		local bChanged,changBds = self:changeNbdToCard(n - bdCountMap[flag.num], bdIndexs, flag)
		hasChangedBdIndexs = contract(hasChangedBdIndexs, changBds)
		local tmp = increaseFun(flag.num)
		if tmp == flag.num then
			break
		else
			flag.num = tmp
		end
	end
	local hasChangedBds = map(hasChangedBdIndexs, function(bdIndex)
		return self[bdIndex]
	end)

	return hasChangedBds
end

function BDCardArray:getFundationSequence( startFlag, endFlag,f, sequenceStartIndex )
	local i = sequenceStartIndex[startFlag.num]
	local card = self[i]
	local sequence = BDCardArray:new()
	while card ~= nil and f(endFlag, card) >= 0 do
		if not self:isBd(card) then
			append(sequence, card)
		end
		i = i + 1
		card = self[i]
	end

	return sequence
end

function BDCardArray:getLessThanNSequence( n,sequence, f )
	local prevCard = nil
	local count = 0
	local lessThanNSequences = sequence:filte(function ( curCard )
		if prevCard == nil or f(curCard,prevCard) == 0 then
			count = count + 1
		else
			count = 1
		end
		prevCard = curCard

		return count <= n
	end)

	return lessThanNSequences
end

function BDCardArray:getSequencesFromFlag( n, startFlag, endFlag,f,increaseFun, bdCountMap)
	local hasChangedBds = self:getBDChanges(n, startFlag, endFlag,f,increaseFun,  bdCountMap)
	local sequence = self:getFundationSequence(startFlag, endFlag,f, self:getSequencesStartIndexs() )
	local lessThanNSequences = self:getLessThanNSequence(n, sequence, f)
	return BDCardArray:new(contract(lessThanNSequences, hasChangedBds), self.sortFun)
end

function BDCardArray:getAtleastLenNSameSequence( n, leastLen,f, increaseFun )
	return self:getAllSequences(n, f, increaseFun)
		:filte(function ( cards )
			return #cards >= leastLen
		end)
end

function BDCardArray:getFixlenNSameSequence( n,fixlen,f,increaseFun )
	return accumulate(function ( resItem,fixLenCollection )
		local i = 1
		while i+fixlen <= #resItem + 1 do
			append(fixLenCollection, resItem:sub(i, i+fixlen))
			i = i + n
		end
		return fixLenCollection
	end,
	CardArrayCollection:new(),
	self:getAtleastLenNSameSequence(n, fixlen, f, increaseFun))
end

function BDCardArray:getAllSequences(n, f, increaseFun)
	if f == nil then
		f = function ( a,b )
			return a - b
		end
	end

	if increaseFun == nil then
		increaseFun = function ( num )
			if num == 1 or num == 2 then
				return num
			else
				return modeRingNum(BDCardArray.maxFlag, num + 1)
			end
		end
	end

	return self:constructNSequence(n,n,f,increaseFun)
end

function BDCardArray:getFirstNoBd(  )
	local firstNoBdIndex = findInArray(self, _, function ( _,card )
		return not self:isBd(card)
	end)

	return self[firstNoBdIndex]
end

function BDCardArray:isAllSameExceptBD( comFun )
	if comFun == nil then
		comFun = function ( carda, cardb )
			if self:isBd(carda) or self:isBd(cardb) then
				return true
			else
				return carda.num == cardb.num
			end
		end
	end
	local card = self:getFirstNoBd()
	if card == nil then
		return true
	end
	for i,v in ipairs(self) do
		if not comFun(v, card) then
			return false 
		end
	end

	return true
end

function BDCardArray:isAtleastNSame( n, comFun )
	if #self < n then
		return false
	end

	return self:isAllSameExceptBD(comFun)
end

function BDCardArray:isNSame( n, comFun )
	if #self ~= n then
		return false
	end

	return self:isAllSameExceptBD(comFun)
end

function BDCardArray:getBestNSame( n, comFun )
	local allNSames = self:getNSames(n)
	if comFun == nil then
		comFun = function ( nsamea, nsameb )
			return nsamea:getBDCount() < nsameb:getBDCount()
		end
	end
	return max(allNSames, comFun)
end

function BDCardArray:getCanBeNsameCardNum( cardCountMap, n )
	local bdCount = self:getBDCount()
	local canBeNsameCardNum = Array:new()
	cardCountMap:walkIf(function ( _,cardCount )
		return n - cardCount <= bdCount and cardCount ~= 0
	end, function ( cardNum,_ )
		append(canBeNsameCardNum, cardNum)
	end)

	return canBeNsameCardNum
end

function BDCardArray:getAtleastNsame( n )
	local cardCountMap = self:getCardCountMap()
	local canBeNsameCardNum = self:getCanBeNsameCardNum(cardCountMap, n)
	return canBeNsameCardNum:map(function ( cardNum )
			local fundation = self:findAllByNum(cardNum)
			local _, hasChangedBdIndexs = self:changeNbdToNum(n - cardCountMap[cardNum], self:findBdIndexs(), cardNum)
			local hasChangedBds = map(hasChangedBdIndexs, function(bdIndex)
				return self[bdIndex]
			end)
			local res = contract(
				hasChangedBds,
				fundation
				)
			return BDCardArray:new(res)
		end)
end

function BDCardArray:getNSames( n )
	local cardCountMap = self:getCardCountMap()
	local canBeNsameCardNum = self:getCanBeNsameCardNum(cardCountMap, n)
	return canBeNsameCardNum:map(function ( cardNum )
			local fundation = self:findAllByNum(cardNum)
			fundation = BDCardArray:new(fundation):sub(1, n + 1)
			local _, hasChangedBdIndexs = self:changeNbdToNum(n - cardCountMap[cardNum], self:findBdIndexs(), cardNum)
			local hasChangedBds = map(hasChangedBdIndexs, function(bdIndex)
				return self[bdIndex]
			end)
			local res = contract(
				hasChangedBds,
				fundation
				)
			return BDCardArray:new(res)
		end)
end

function BDCardArray:deleteAllDb()
	local i = 1
	while i <= #self do
		if self:isBd(self[i]) then
			table.remove(self, i)
		else
			i = i + 1
		end
	end
	return self
end

function BDCardArray:isSequence(internalLen, f, increaseFun)
  if #self == 0 then
    return false
  end
  
	if f == nil then
		f = function ( a,b )
			return a - b
		end
	end

	if increaseFun == nil then
		increaseFun = function ( num )
			if num == 1 or num == 2 then
				return num
			else
				return modeRingNum(BDCardArray.maxFlag, num + 1)
			end
		end
	end

	local bdCount = self:getBDCount()
	self:deleteAllDb()
	local cardCountMap = self:getCardCountMap()
	local sequenceItems = self:filteSameCard()
	local sequenceStartCard = sequenceItems[1]
	local sequenceEndCard = sequenceItems[#sequenceItems]:copy()
	local flag = sequenceStartCard:copy()
	while f(flag, sequenceEndCard) ~= 1 do
		local needBdNum = internalLen - cardCountMap[flag.num]
		local bLongerThanInternalLen = (needBdNum < 0)
		if bLongerThanInternalLen then
			return false
		end

		bdCount = bdCount - needBdNum
		if bdCount < 0 then
			return false
		end

		local tmp = increaseFun(flag.num)
		if tmp == flag.num then
			return bdCount%internalLen == 0
		else
			flag.num = tmp
		end
	end

	return bdCount%internalLen == 0
end


function CardArray:findNSames( n )
	local colorTable = getColorTable(self)
	local res = CardArrayCollection:new()
	for i,v in ipairs(colorTable) do
		if #v:getRepeatetable()[n] ~= 0 then
			contract(res, v:getRepeatetable()[n]:seprateIntoSamePices(n))
		end
	end

	return res
end

function getColorTable( cards )
	local cardscpy = cards:copy()

	--按颜色分类
	cardscpy = filte(cardscpy, function ( v )
		return not v:isBd()
	end)
	local colorTable = newArray(5)
	colorTable = map(colorTable, util.createCardArray)
	walk(cardscpy, function ( i,v )
		colorTable[v.color]:add(util.BDCard:new(v.num, v.color))
	end)

	return colorTable
end


local SingleColorHuChecker = {}
SingleColorHuChecker.__index = SingleColorHuChecker
function SingleColorHuChecker:new( cards,bdCount,max_3, max_2 )
	local o = {}
	o.cards = cards:copy()
	o.bdCount = bdCount
	o._3 = max_3
	o._2 = max_2
	
	o.tribleCount = 0
	o.doubleCount = 0
	o.sequenceCount = 0
	setmetatable(o, SingleColorHuChecker)
	return o
end

function SingleColorHuChecker:canBuildDouble( card )
	self.bdCount = self.bdCount - 1
	return self.bdCount >= 0
end

function SingleColorHuChecker:addLackCardFromHand( num1, num2 )
	return findByF(self.cards:getRepeatetable(), function ( cards, repeatetime )
		if repeatetime == 1 then
			return false
		else
			return findByF(cards, function ( card )
		        if num2 == nil and not (card.num == num1) then
		          return false
		        elseif num2 ~= nil and not (card.num == num1 or card.num == num2) then
					return false
				else
					cards:deleteAll(card)
					insertCardsInOrder(
						self.cards:getRepeatetable()[repeatetime - 1], 
						generateCards(repeatetime-1, card))
					return true
				end
			end)
		end
	end)
end

function generateCards( num, card )
	local cards = util.createCardArray()
	for i=1,num do
		append(cards, card:copy())
	end

	return cards
end

function vacateSpace( array, vacateSize, startIndex )
	local i = #array
	while i >= startIndex do
    local tmp = array[i]
    local tmpIndex = i + vacateSize
		array[tmpIndex] = tmp
		i = i - 1
	end
end

function copyInto( cards, copiedCards, startIndex )
	local i = 1
	while i <= #copiedCards do
		cards[startIndex] = copiedCards[i]
		startIndex = startIndex + 1
		i = i + 1
	end
end

function insertCardsInOrder( cards, insertedCards )
	local insertIndex = binaryFindInsertIndex(cards, function ( card )
		return insertedCards[1].num - card.num
	end)
	vacateSpace(cards, #insertedCards, insertIndex)
	copyInto(cards, insertedCards, insertIndex)
	return cards
end

function SingleColorHuChecker:checkAdjecent1( prev, cur )
	local addLackCardFromHandResult = self:addLackCardFromHand(prev.num - 1, cur.num + 1)
	if addLackCardFromHandResult then
		return true
	end

	self.bdCount = self.bdCount - 1
	return self.bdCount >= 0
end

function SingleColorHuChecker:checkAdjecent2(prev, cur)
	local addLackCardFromHandResult = self:addLackCardFromHand(prev.num + 1)
	if addLackCardFromHandResult then
		return true
	end

	self.bdCount = self.bdCount - 1
	return self.bdCount >= 0
end

function deleteHead(num, cards)
	local i = 1
  	local repeatetableSize = #cards
	while i + num <= repeatetableSize do
		cards[i] = cards[i + num]
		i = i + 1
	end
  
	i = num
	while i >= 1 do

	cards[repeatetableSize - i + 1] = nil

	i = i - 1
	end
end

function SingleColorHuChecker:deleteHead( num, repeatetableIndex )
	local repeatetable = self.cards:getRepeatetable()[repeatetableIndex]
	deleteHead(num, repeatetable)
end

function SingleColorHuChecker:getLonlySingleAjecentCardIndexs( lonlySingleCard )
	local adjecentCardIndexs = {}

	self.cards:walkIf(function ( i,card )
		return card.num - lonlySingleCard.num >= -2 and card.num - lonlySingleCard.num <= 2
	end, function ( index,card )
		adjecentCardIndexs[card.num - lonlySingleCard.num] = index
	end)

	return adjecentCardIndexs
end

function SingleColorHuChecker:getBestAjecentInternal( adjecentCardIndexs )
	local adjecentInternals = {}

	local i = -2
	while i <= 2 do
		if adjecentCardIndexs[i] ~= nil then
			if adjecentInternals.headIndex == nil then
				adjecentInternals.headIndex = 1
				adjecentInternals.num = 1
				adjecentInternals.appendIndex = 1
				adjecentInternals[adjecentInternals.appendIndex] = i
			else
				if i - adjecentInternals.headIndex <= 2 then
					adjecentInternals.appendIndex = adjecentInternals.appendIndex + 1
					adjecentInternals[adjecentInternals.appendIndex] = i
					adjecentInternals.num = adjecentInternals.num + 1
					if adjecentInternals.num == 3 then
						break
					end
				else
					if i - adjecentInternals[adjecentInternals.appendIndex] <= 2 then
						adjecentInternals[adjecentInternals.headIndex] = nil
						adjecentInternals.headIndex = adjecentInternals.headIndex + 1
						adjecentInternals.appendIndex = adjecentInternals.appendIndex + 1
						adjecentInternals[adjecentInternals.appendIndex] = i
					else
						break
					end
				end
			end
		end

		i = i + 1
	end

	local headIndex = adjecentInternals.headIndex
	local num = 0
	while num < adjecentInternals.num do
		adjecentInternals[headIndex + num] = adjecentCardIndexs[ adjecentInternals[headIndex + num] ]
		num = num + 1
	end

	return adjecentInternals
end

function SingleColorHuChecker:checkByAdjecentInternals ( adjecentInternals )
	local first = adjecentInternals[ adjecentInternals.headIndex ]
	local last = adjecentInternals[ adjecentInternals.appendIndex ]

	if adjecentInternals.num == 1 then
		if not self:canBuildDouble(self.cards[first]) then
			return false
		end
		table.remove(self.cards, first) 
		self.cards.repeateTable = nil 
		self:increaseDouble()
		return true
	elseif adjecentInternals.num == 2 then 
		table.remove(self.cards, first)
		table.remove(self.cards, last - 1)
		self.bdCount = self.bdCount - 1
		self.cards.repeateTable = nil
		self:increaseSequence()
		return self.bdCount >= 0
	else
		local second = adjecentInternals[ adjecentInternals.appendIndex - 1 ]
		table.remove(self.cards, first)
		table.remove(self.cards, second - 1)
		table.remove(self.cards, last - 2)
		self.cards.repeateTable = nil
		self:increaseSequence()
		return true
	end 
end

function SingleColorHuChecker:checkLonlySingle( lonlySingleCard )
	local adjecentCardIndexs = self:getLonlySingleAjecentCardIndexs(lonlySingleCard)
	local adjecentInternals = self:getBestAjecentInternal(adjecentCardIndexs)
	return self:checkByAdjecentInternals(adjecentInternals)
end

SingleColorHuChecker.ZIPAI = 4
function SingleColorHuChecker:checkSingle(  )
	local singles = self.cards:getRepeatetable()[1]
	local prev = singles[1]
	local cur = singles[2]

	if prev == nil then
		return true, 0

	elseif prev.color == SingleColorHuChecker.ZIPAI then

		return self:canBuildDouble(prev), 1
	elseif cur == nil then
		return self:checkLonlySingle(prev), 0
	elseif 	cur.num - prev.num == 1 then
		if singles[3] ~= nil and singles[3].num - cur.num == 1 then
			return true,3
		else
			return self:checkAdjecent1(prev, cur),2
		end
	elseif cur.num - prev.num == 2 then
		if singles[3] ~= nil and singles[3].num - cur.num == 1 then
			return self:checkLonlySingle(prev),0
		else
			return self:checkAdjecent2(prev, cur),2
		end
	elseif cur.num - prev.num >= 3 then
		return self:checkLonlySingle(prev),0
	end
end

function SingleColorHuChecker:checkDouble(  )
	if self._2 ~= 0 then
		self:increaseDouble()
		return true
	else
		self:increaseTrible()
		self.bdCount = self.bdCount - 1
		return self.bdCount >= 0
	end
end

function SingleColorHuChecker:contractCardsFromRepeatetable(  )
	local res = util.createCardArray()
	contract(res, self.cards:getRepeatetable()[1])
	contract(res, self.cards:getRepeatetable()[2])
	contract(res, self.cards:getRepeatetable()[3])
	res:sort()
	self.cards = res
end

function SingleColorHuChecker:increaseTrible(  )
	self.tribleCount = self.tribleCount + 1
	self._3 = self._3 - 1
end

function SingleColorHuChecker:increaseSequence(  )
	self.sequenceCount = self.sequenceCount + 1
	self._3 = self._3 - 1
end

function SingleColorHuChecker:increaseDouble(  )
	self.doubleCount = self.doubleCount + 1
	self._2 = self._2 - 1
end

function SingleColorHuChecker:check(  )
	if #self.cards:getRepeatetable()[4] ~= 0 then
    	insertCardsInOrder(
			self.cards:getRepeatetable()[1], 
			generateCards(1, self.cards:getRepeatetable()[4][1]))
		self:deleteHead(4, 4)
		self:increaseTrible()
		if self._3 < 0 then
			return false
		else
			if #self.cards:getRepeatetable()[4] == 0 then
				self:contractCardsFromRepeatetable()
			end
			return self:check()
		end
	elseif #self.cards:getRepeatetable()[1] ~= 0 then
		local ok, deleteNum = self:checkSingle()
		self:deleteHead(deleteNum, 1)
		if not ok then
			return false
		else
			if deleteNum == 1 then
				self:increaseDouble()
			elseif deleteNum == 2 or deleteNum == 3 then
				self:increaseSequence()
			end

			if self._2 < 0 or self._3 < 0 then
				return false
			else
        self:contractCardsFromRepeatetable()
				return self:check()
			end
		end
	elseif #self.cards:getRepeatetable()[3] ~= 0 then
		self:deleteHead(3, 3)
		self:increaseTrible()
		if self._3 < 0 then
			return false
		else
			return self:check()
		end
	elseif #self.cards:getRepeatetable()[2] ~= 0 then
		local ok = self:checkDouble()
		self:deleteHead(2, 2)
		if not ok then
			return false
		else
			if self._2 < 0 or self._3 < 0 then
				return false
			else
				return self:check()
			end
		end
	else
		return true
	end
end

local HuTypes = {}
HuTypes.__index = HuTypes


local CombinToCards = {}
function CombinToCards.peng( card )
	card = util.Card.fromInt32(card)
	return {card, card, card}
end

function CombinToCards.gang( card )
	card = util.Card.fromInt32(card)
	return {card, card, card, card}
end

function CombinToCards.left( card )
	card = util.Card.fromInt32(card)
	return {
    card, 
    {color=card.color, num = card.num + 1}, 
    {color=card.color, num = card.num + 2}}
end


function CombinToCards.center( card )
	card = util.Card.fromInt32(card)
	return 
  {
    {color=card.color, num = card.num - 1},
    card, 
    {color=card.color, num = card.num + 1}
    }
end


function CombinToCards.right( card )
	card = util.Card.fromInt32(card)
	return 
    {
    {color=card.color, num = card.num - 2},
    {color=card.color, num = card.num - 1},
    card
    }
end

function getCardsFromCombinInfo( combinInfo )
	local cards = util.createCardArray()

	walk(combinInfo, function (i, combinItem )
		contract( cards, CombinToCards[combinItem.combin](combinItem.card) )
	end)

	return cards
end

function HuTypes:new( cards, combinInfo )
	local o = {}
	o.cards = cards
	
	o.combinCount = #combinInfo
	o.combinInfo = combinInfo
	o.outCards = getCardsFromCombinInfo(combinInfo)

	o.max_3 = 4 - o.combinCount
	o.max_2 = 1
  
	o.bdCount = o.cards:getBDCount()
	o.cards = o.cards:copy():deleteAllDb()
	
	setmetatable(o, HuTypes)
	return o
end


local PengPengHuChecker = {}
PengPengHuChecker.__index = PengPengHuChecker
function PengPengHuChecker:new( cards, combinCount, bdCount )
	local o = {}
	o.cards = cards

	o.max_3 = 4 - combinCount
	o.max_2 = 1
  
	o.bdCount = bdCount
	o.cards = o.cards:copy():deleteAllDb()
	
	setmetatable(o, PengPengHuChecker)
	return o
end

function PengPengHuChecker:check(  )
	return not findByF(getColorTable(self.cards), function ( singleColorCards )
		return not self:isAllTribleOrDouble(singleColorCards:getRepeatetable())
	end)
end

function PengPengHuChecker:isNotLegal(  )
	return self.max_3 < 0 or self.max_2 < 0 or self.bdCount < 0
end

function PengPengHuChecker:isAllTribleOrDouble( repeatetable )
	if #repeatetable[1] ~= 0 and self.max_2 > 0 then
		deleteHead(1, repeatetable[1])
		self.max_2 = self.max_2 - 1
		self.bdCount = self.bdCount - 1
		if self:isNotLegal() then
			return false
		else
			return self:isAllTribleOrDouble(repeatetable)
		end
	elseif #repeatetable[1] ~= 0 then
		local singleCount = #repeatetable[1]
		self.max_3 = self.max_3 - singleCount
		self.bdCount = self.bdCount - 2*singleCount
		repeatetable[1] = {}
		if self:isNotLegal() then
			return false
		else
			return self:isAllTribleOrDouble(repeatetable)
		end
	elseif #repeatetable[2] ~= 0 and self.max_2 > 0 then
		deleteHead(2, repeatetable[2])
		self.max_2 = self.max_2 - 1
		if self:isNotLegal() then
			return false
		else
			return self:isAllTribleOrDouble(repeatetable)
		end
	elseif #repeatetable[2] ~= 0 then
		local doubleCount = #repeatetable[2]/2
		self.max_3 = self.max_3 - doubleCount
		self.bdCount = self.bdCount - doubleCount
    repeatetable[2] = {}
		if self:isNotLegal() then
			return false
		else
			return self:isAllTribleOrDouble(repeatetable)
		end
	elseif #repeatetable[3] ~= 0 then
		self.max_3 = self.max_3 - #repeatetable[3]/3
		repeatetable[3] = {}
		if self:isNotLegal() then
			return false
		else
			return self:isAllTribleOrDouble(repeatetable)
		end
	elseif #repeatetable[4] ~= 0 then
		local forbleCount = #repeatetable[4]/4
		self.max_3 = self.max_3 - forbleCount
		self.max_2 = self.max_2 - forbleCount
		self.bdCount = self.bdCount - forbleCount
		repeatetable[4] = {}

		if self:isNotLegal() then
			return false
		else
			return self:isAllTribleOrDouble(repeatetable)
		end
  else
    return true
	end
end

function HuTypes:isPengpengHu(  )
	local hasChi = findByF(self.combinInfo, function ( combinItem )
		return combinItem.combin ~= "peng" and combinItem.combin ~= "gang"
	end)
	if hasChi then
		return false
	else
		return PengPengHuChecker:new(self.cards, self.combinCount, self.bdCount):check()
	end
end

function HuTypes:checkHu(  )
	local colorTable = getColorTable(self.cards)
	local max_3, max_2 = self.max_3, self.max_2

	self.tribleCount = 0
	self.sequenceCount = 0
	self.doubleCount = 0

  local bdCount = self.bdCount
	local bNoHu = findByF(colorTable, function ( cards )
		local singleColorHuChecker = SingleColorHuChecker:new(cards, bdCount, max_3, max_2)
		if not singleColorHuChecker:check() then
			return true
		else
			bdCount = singleColorHuChecker.bdCount
			max_3 = singleColorHuChecker._3
			max_2 = singleColorHuChecker._2

			self.tribleCount = self.tribleCount + singleColorHuChecker.tribleCount
			self.sequenceCount = self.sequenceCount + singleColorHuChecker.sequenceCount
			self.doubleCount = self.doubleCount + singleColorHuChecker.doubleCount
			return false
		end
	end)

	return not bNoHu
end

function HuTypes:isAllFeng(  )
	if self.isAllFeng_ == nil then
		local tmp = self.cards + util.createCardArray(self.outCards)
		local colorTable = getColorTable(tmp)
		self.isAllFeng_ = #colorTable[4] + self.cards:getBDCount() == #tmp
	end

	return self.isAllFeng_
end

function HuTypes:isAllSameColor(  )
  
  if #self.cards == 0 then
    self.isAllSameColor_ = true
  end
  
	if self.isAllSameColor_ == nil then
		self.cards:sort()
		local card = self.cards[1]

		local qingyisePre = function ( c )
			return c.color == card.color or c:isBd()
		end
		local outCardsTmp = util.createCardArray(self.outCards)
		self.isAllSameColor_ = (#self.cards + #outCardsTmp) == (self.cards:countOf(qingyisePre) + outCardsTmp:countOf(qingyisePre))
	end

	return self.isAllSameColor_
end

function canBeAllDouble( singleColorCards, bdCountRef )
  local needBdCount = #singleColorCards:getRepeatetable()[1] + #singleColorCards:getRepeatetable()[3]/3
	bdCountRef.bdCount = bdCountRef.bdCount - needBdCount
	return bdCountRef.bdCount >= 0
end

function HuTypes:is7Doubles(  )
	if self.combinCount ~= 0 then
		self.is7Doubles_ = false
		return false
	end

	local bdCountRef = {}
	bdCountRef.bdCount = self.bdCount
	self.cards = self.cards:copy():deleteAllDb()
	local colorTable = getColorTable(self.cards)

	local isNotAllDouble = findByF(colorTable, function ( singleColorCards )
		return not canBeAllDouble(singleColorCards, bdCountRef)
	end)
	self.is7Doubles_ = not isNotAllDouble

	return self.is7Doubles_
end

function HuTypes:getFengCount(  )
	if self.fengCount_ == nil then
		self.fengCount_ = (self.cards + self.outCards):countOf(function ( card )
			return card.color == 4
		end)
	end

	return self.fengCount_ + self.bdCount
end

function HuTypes:is7ziQuan(  )
	local sevenZi = util.createCardArray(
		{
			{num = 1,color = 4},{num = 2,color = 4},{num = 3,color = 4},
			{num = 4,color = 4},{num = 5,color = 4},{num = 6,color = 4}
		})
	return self.cards:hasSub(sevenZi) and self.bdCount ~= 0
end

function isStandBukaoSequence( cards )
	 return CardArray.isSequence(cards, 1, 2, function ( a,b )
		return a.num - b.num == 3
	end)
end

function HuTypes:isStandBukao(  )
	if self.combinCount ~= 0 then
		self.isStrandBukao_ = false 
		self.isBukao_ = false
	end

	if self.isStrandBukao_ == nil then
		local colorTable = getColorTable(self.cards + util.createCardArray(self.outCards))
		local isZipaiBukao = (#colorTable[4] == #colorTable[4]:filteSame(util.Card.equals))

		colorTable[4] = nil
		local isStandBukaos = map(colorTable, function ( colorCards )
			return isStandBukaoSequence(colorCards)
		end)
		append(isStandBukaos, isZipaiBukao)

		local isAllStandBukao = accumulate(function ( cur,init )
			return init and cur
		end, true, isStandBukaos)

	    self.isStandBukao_ = isAllStandBukao
	    self.isBuKao_ = isAllStandBukao
	end

	return self.isStandBukao_
end

function isBuKao( cards )
  return CardArray.isSequence(cards, 1, 2, function ( a,b )
		return a.num - b.num >= 3
	end)
end

function HuTypes:isBukao(  )
	if self.combinCount ~= 0 then
		self.isBukao_ = false
		self.isStrandBukao_ = false
	end

	if self.isBukao_ == nil then
		local colorTable = getColorTable(self.cards + util.createCardArray(self.outCards))
		local isZipaiBukao = (#colorTable[4] <= #colorTable[4]:filteSame(util.Card.equals) + #self.cards:findBdIndexs())
		colorTable[4] = nil
		local isBukaos = map(colorTable, function ( colorCards )
			if #colorCards == 0 then
				return true
			else
				return isBuKao(colorCards)
			end
		end)
		append(isBukaos, isZipaiBukao)
		local isAllBukao = accumulate(function ( cur,init )
			return init and cur
		end, true, isBukaos)

		self.isBukao_ = isAllBukao
	end

	return self.isBukao_
end

function HuTypes:getHuTypes(  )
	local huTypes = {}
	if self:checkHu() then
		if self:isAllFeng() then
			append(huTypes, "qingfeng")
			return huTypes
		end

		if self:isPengpengHu() then
			append(huTypes, "pengpenghu")
		end

		if self:isAllSameColor() then
			append(huTypes, "qingyise")
		end

		append(huTypes, "zimo")
	elseif self:isAllFeng() then
		append(huTypes, "luanfeng")
	elseif self:is7Doubles() then
		append(huTypes, "sevendouble")
	elseif self:is7ziQuan() and self:isBukao() then
		append(huTypes, "_7ziquan")
		if self:isStandBukao() then
			append(huTypes, "stand13")
		end
	elseif self:getFengCount() >= 5 then
		if self:isStandBukao() then
			append(huTypes, "stand13")
		elseif self:isBukao() then
			append(huTypes, "buda13")
		end
	end

	return huTypes
end

local CardTypeFinder = {}

function CardTypeFinder.single( handcard )
	if #handcard == 0 then return CardArrayCollection:new() end

	local res = CardArrayCollection:new()
	local prev = handcard[1]
	append(res, util.createCardArray({prev}))
	for k,v in ipairs(handcard) do
		if prev.num ~= v.num then
			local ressingle = util.createCardArray({v})
			append(res, ressingle)
			prev = v
		end
	end
	--contract(res, handcard:getNSames(1):map(util.createCardArray))
	return res
end

function CardTypeFinder.double(  handcard )
	if #handcard < 2 then return CardArrayCollection:new() end

	local res = CardArrayCollection:new()
	local resdouble = util.createCardArray()
	local doublecollection = handcard:getRepeatetable()[2]
	if doublecollection == nil then
		doublecollection = {}
	end

	for k,v in ipairs(doublecollection) do
		append(resdouble, v)
		if k % 2 == 0 then
			append(res, resdouble)
			resdouble = util.createCardArray()
		end
	end

	local triblecollection = handcard:getRepeatetable()[3]
	if triblecollection == nil then
		return res
	end

	local restrible = util.createCardArray()
	for k,v in ipairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			restrible[3] = nil
			append(res, restrible)
			restrible = util.createCardArray()
		end
	end

	local forblecollection = handcard:getRepeatetable()[4]
	if forblecollection == nil then
		return res
	end

	local forble = util.createCardArray()
	for i,v in ipairs(forblecollection) do
		append(forble, v)
		if i % 4 == 0 then
			append(res, forble:sub(1,3))
			append(res, forble:sub(3, 5))
			forble = util.createCardArray()
		end
	end

	return res
end

function CardTypeFinder.trible( handcard )
	local res = CardArrayCollection:new()
	local triblecollection = handcard:getRepeatetable()[3]
	if triblecollection == nil then
		triblecollection = {}
	end
	local restrible = util.createCardArray()
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			append(res, restrible)
			restrible = util.createCardArray()
		end
	end

	local forblecollection = handcard:getRepeatetable()[4]
	if forblecollection == nil then
		return res
	end
	accumulate(function ( forble, init )
		append(init, forble:sub(1,4))
		return init
	end, res, forblecollection:seprateIntoSamePices(4))

	return res
end

function CardTypeFinder.bomb( handcard )
	local res = CardArrayCollection:new()
	local resbomb = util.createCardArray()
	local bombcollection = handcard:getRepeatetable()[4]
	if bombcollection == nil then
		return res + CardTypeFinder.rocket(curcard, handcard)
	end
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 4 == 0 then
			append(res, resbomb)
			resbomb = util.createCardArray()
		end
	end
	return res
end

local function sequenceFilteByLen( sequence, len, interval )
	local res = CardArrayCollection:new()
	if #sequence < len then
		return res
	elseif #sequence == len then
		append(res, sequence)
		return res
	else
		local i = 1
		while i <= #sequence do
			append(res, sequence:sub(i,i + len))
			if i + len > #sequence then
				break
			end
			i = i + (interval == nil and 1 or interval)
		end
	end

	return res
end

function CardTypeFinder.sequence( handcard, cardsLen )
	local res = CardArrayCollection:new()

	local sequence = util.createCardArray()
	local prev = handcard[1]
	append(sequence, handcard[1])
	local A = Card:new(1,1)
	for k,v in ipairs(handcard) do
		if v.num == 2 then
			break
		elseif v - prev == 1 then
			append(sequence, v)
			prev = v
		elseif v - prev > 1 then
			if #sequence >= 5 then
				append(res, sequence)
			end
			sequence = util.createCardArray()
			prev = v
			append(sequence, v)
		end
	end

	if #sequence >= 5 then
		append(res, sequence)
	end

	if cardsLen == nil then
		return res
	end

	local resAfterFilter = CardArrayCollection:new()
	for i,v in ipairs(res) do
		resAfterFilter = resAfterFilter + sequenceFilteByLen(v, cardsLen)
	end

	return resAfterFilter
end

function CardTypeFinder.captive( handcard, cardsLen )
	local alltribleelement = handcard:getRepeatetable()[3]
	local alldoubleelement = handcard:getRepeatetable()[2]
	local triblePices = seprateIntoSamePices(alltribleelement, 3)
	local doublePices = seprateIntoSamePices(alldoubleelement, 2)
	local res = CardArrayCollection:new()
	for i,v in ipairs(triblePices) do
		append(res, v + doublePices[1])
	end
	return res
end

function CardTypeFinder.doubleSequence( handcard, cardsLen )
	local res = handcard:getAllSequences(2)

	return res:filte(function ( cardArray )
		if cardsLen ~= nil then
			return #cardArray >= cardsLen
		else
			return #cardArray >= 4
		end
	end)
end

function CardTypeFinder.planeInSingle( handcard, cardsLen )
	local planeSize = cardsLen/4
	local wingSize = planeSize
	local tribleSequenceInPlaneSize = planeSize * 3
	local triblesequences = CardTypeFinder.triblesequence(handcard, tribleSequenceInPlaneSize)
	local res = CardArrayCollection:new()
	for i,triblesequence in ipairs(triblesequences) do
		local planeInSingle = util.createCardArray()
		local wingInSingle = handcard - triblesequence
		if #wingInSingle >= wingSize then
			planeInSingle = triblesequence + wingInSingle:sub(1,1 + wingSize)
			append(res, planeInSingle)
		end
	end
	return res

end

function CardTypeFinder.planeInDouble( handcard, cardsLen )
	local triblesequences = CardTypeFinder.triblesequence(handcard, cardsLen/5*3)
	local res = CardArrayCollection:new()
	for i,triblesequence in ipairs(triblesequences) do
		local planeInDouble = util.createCardArray()
		local double = CardTypeFinder.double(handcard - triblesequence)
		if #double >= 2 then
			planeInDouble = triblesequence + double[1] + double[2]
			append(res, planeInDouble)
		end
	end
	return res
end

function CardTypeFinder.tribleSequence( handcard, cardsLen )
	local res = handcard:getAllSequences(3)

	return res:filte(function ( cardArray )
		if cardsLen ~= nil then
			return #cardArray >= cardsLen
		else
			return #cardArray >= 6
		end
	end)
end

function CardTypeFinder.tribleAndSingle( handcard )
	local res = CardArrayCollection:new()
	local triblecollection = handcard:getRepeatetable()[3]
	if triblecollection == nil or #triblecollection == 0 then
		return{}
	end

	local restrible = util.createCardArray()
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			for dk,dv in pairs(handcard) do
				if dv ~= v then
 					append(restrible, dv)
 					break
				end
			end
			append(res, restrible)
			restrible = util.createCardArray()
		end
	end

	return res
end

function CardTypeFinder.tribleAndDouble( handcard )
	local res = CardArrayCollection:new()
	local triblecollection = handcard:getRepeatetable()[3]
	local doublecollection = handcard:getAtleastNsame(2)
	local doublecollectionOnly = handcard:getRepeatetable()[2]
	if #triblecollection == 0 or #doublecollection == 0 then
		return res
	end

	local restrible = util.createCardArray()
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			local times = 0
			local doublecollectionSrc = doublecollectionOnly
			if #doublecollectionOnly == 0 then
				doublecollectionSrc = doublecollection
			end
			for dk,dv in pairs(doublecollectionSrc) do
				if dv ~= v then
					times = times + 1
 					append(restrible, dv)
				end
				if times == 2 then
					times = 0
					break
				end
			end
			append(res, restrible)
			restrible = util.createCardArray()
		end
	end

	return res
end

function CardTypeFinder.bombAndTwoDouble( handcard )
	if #handcard < 8 then return {} end

	local res = CardArrayCollection:new()
	local resbomb = util.createCardArray()
	local bombcollection = handcard:getRepeatetable()[4]
	local doublecollection = handcard:getRepeatetable()[2]
	local triblecollection = handcard:getRepeatetable()[3]
	local i = 1
	while #triblecollection ~= 0 and i <= #triblecollection do
		doublecollection = doublecollection + triblecollection:sub(i, i + 2)
		i = i + 3
	end

	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 4 == 0 then
			resbomb = resbomb + doublecollection:sub(1,5)
			append(res, resbomb)
			resbomb = util.createCardArray()
		end
	end

	return res
end

local ROCKET = {{num = 14, color = 4},{num = 15, color = 4}}
function CardTypeFinder.rocket( handcard )
	local res = CardArrayCollection:new()
	if (handcard:find(Card:new(14,4)) and handcard:find(Card:new(15,4))) then
		append(res, util.createCardArray(ROCKET))
	end

	return  res
end

function CardTypeFinder.bombAndTwoSingle( handcard  )
	if #handcard < 6 then return {} end

	local res = CardArrayCollection:new()
	local resbomb = util.createCardArray()
	local bombcollection = handcard:getRepeatetable()[4]
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 4 == 0 then
			local time = 0
			for sk,sv in pairs(handcard) do
				if sv ~= bombcollection[1] then
					append(resbomb, sv)
					time = time + 1
					if time == 2 then
						break
					end
				end
			end
			append(res, resbomb)
			resbomb = util.createCardArray()
		end
	end

	return res
end


local CardTypeFinderWapper = {}
local cardTypeFinderDispatch = CardTypeFinder
function CardTypeFinderWapper.init( c )
	if c == nil then
		cardTypeFinderDispatch = CardTypeFinder
	else
		cardTypeFinderDispatch = c
	end
end

function CardTypeFinderWapper.setCardFinder( type, f )
	cardTypeFinderDispatch[type] = f
end

function CardTypeFinderWapper.getCardFinder( type )
	return CardTypeFinder[type]
end

function CardTypeFinderWapper.find( type, cards, len )
	--print(type)
	return cardTypeFinderDispatch[type](cards, len)
end

function CardTypeFinderWapper.seperateSequence(sequence, targetLen, itemLen )
	local i = 1
	local res = CardArrayCollection:new()
	while i + targetLen <= #sequence + 1 do
		res:add(sequence:sub(i, i + targetLen))
		i = i + itemLen
	end

	return res
end

local CardTypeFinderDispatch = CardTypeFinderWapper

local CardType = {}
function CardType.single( cards )
	return #cards == 1
end

function CardType.double( cards )
	if #cards ~= 2 then
		return false
	else
		return #cards == 2 and cards[1].num == cards[2].num
	end
end

function CardType.rocket( cards )
	if #cards == 2 then
		return cards[1].num == 14 and cards[2].num == 15
	end
end

function CardType.trible( cards )
	return #cards == 3 and cards:hasNsame(3)
end

function CardType.tribleAndDouble( cards )
	if #cards ~= 5 then return false end
	if false == cards:hasNsame(3) then return false end
	if false == cards:hasNsame(2) then return false end
	return true
end

function CardType.tribleAndSingle( cards )
	if #cards ~= 4 then return false end
	if false == cards:hasNsame(3) then return false end
	return true
end

function CardType.doubleSequence( cards )
	if cards:find({num = 2,color = 0}, function (a,b) return a.num == b.num end ) ~=nil then return false end
	if #cards < 6 then return false end

	return cards:isSequence(2)
end

function CardType.tribleSequence( cards )
	if cards:find({num = 2,color = 0}) ~=nil then return false end
	if #cards < 6 then return false end
	return cards:isSequence(3)
end

function getTribleSequenceFromPlane( cards, planeSize )
	local triblesequences = CardTypeFinderDispatch.triblesequence(cards, planeSize * 3)
	return triblesequences[#triblesequences]
end

function CardType.planeInDouble( cards )
	if #cards < 10 or #cards % 5 ~= 0 then return false end
	local tribleSequences = CardTypeFinderDispatch.triblesequence(cards)
	if #tribleSequences == 0 then
		return false
	end
	local plane = tribleSequences[1]
	local doubleWings = CardTypeFinderDispatch.double(cards - plane)
	local planeSize = #plane/3
	local wingSize = #doubleWings
	return planeSize == wingSize
end

function CardType.planeInSingle( cards )
	if #cards < 8 or #cards % 4 ~= 0 then return false end
	local tribleSequencesForPlane = CardTypeFinderDispatch.find("tribleSequence", cards, #cards/4*3)
	if #tribleSequencesForPlane == 0 then
		return false
	end
	local plane = tribleSequencesForPlane[1]
	local planeSize = #plane/3
	local wing = cards - plane
	local wingSize = #wing
	return planeSize == wingSize
end

function CardType.sequence( cards )
	for k,v in pairs(cards) do
		if v.num == 2 or v.num == 14 or v.num == 15 then
			return false
		end
	end
	if #cards < 5 then return false end
	if cards:hasNsame(2) then return false end
	if cards:hasNsame(3) then return false end
	if cards:hasNsame(4) then return false end

	local prev
	for k,v in ipairs(cards) do
		if k == 1 then
			prev = v
		else
			local t = v - prev
			prev = v
			if t > 1 then return false end
		end
	end
	return true
end

function isWingOfPlane( wing, plane )
	if #wing == 0 then
		return false
	else
		local sizeOfPlane = #plane/3
		local sizeOfWing = sizeOfPlane
		local winInSingle = wing
		if #winInSingle == sizeOfWing then return true end

		local winInDouble = CardTypeFinderDispatch.find("double", wing)
		if #winInDouble * 2 ~= #wing then
			return false
		else
			return true
		end
	end
end

function CardType.plane( cards )
	local triblesequences = CardTypeFinderDispatch.find("tribleSequence", cards)
	if #triblesequences == 0 then return false end
	for i,v in ipairs(triblesequences) do
		local plane = v
		local wing = cards - plane
		if isWingOfPlane(wing, plane) then return true end
	end
	return false
end

function CardType.bomb( cards )
	if #cards ~= 4 then return false end
	return cards:isAllSame(4)
end

function CardType.captive( cards )
	if #cards ~= 5 then return false end
	return #cards:getRepeatetable()[3] ~= 0 and #cards:getRepeatetable()[2] ~= 0
end

function CardType.bombAndTwoSingle( cards )
	if #cards ~= 6 then return false end

	return cards:hasNsame(4)
end

function CardType.bombAndTwoDouble( cards )
	if #cards ~= 8 then return false end
	local bomb = CardTypeFinderDispatch.find("bomb", cards)
	if #bomb == 0 then
		return false
	end
	local double = CardTypeFinderDispatch.find("double", (cards - bomb[1]))
	if #double ~= 2 then
		return false
	end

	return true
end

function CardType.rocket( cards )
	if #cards == 2 then
		return cards[1].num == 14 and cards[2].num == 15
	end
end

local cardTypeDispatch = {}
local typeLevel = {}
local MAXLEVELSIZE = 20
local CardTypeJudgment = {}
function CardTypeJudgment.init( c )
	if c == nil then
		cardTypeDispatch = CardType
	else
		cardTypeDispatch = c
	end
	typeLevel = newArray(MAXLEVELSIZE, {})
end

function CardTypeJudgment.setLevel( types, level )
	typeLevel[level] = types
end

function CardTypeJudgment.getLevelByType( type )
	for level,types in ipairs(typeLevel) do
		if findInArray(types, type) then
			return level
		end
	end

	return 0
end

function CardTypeJudgment.getCardTypeFun( typeName )
	return CardType[typeName]
end

function CardTypeJudgment.setCardTypeFun( typeName, f )
	CardType[typeName] = f
end

function CardTypeJudgment.getCardType( cards )
	if cards == nil then return {} end

	local resType = {}
	for cardTypeName,judgeFuction in pairs(cardTypeDispatch) do
		if  judgeFuction(cards) then
			append(resType, cardTypeName)
		end
	end
	return resType
end


local CardCompare = {}

function CardCompare.single( a,b )
	return b[1] < a[1]
end

function CardCompare.double( a,b )
	return b[1] < a[1]
end

function CardCompare.trible( a,b )
	local a_ = a:getRepeatetable()[3]
	local b_ = b:getRepeatetable()[3]
	return b_[1] < a_[1]
end

function CardCompare.bomb( a,b )
	return b[1] < a[1]
end

function CardCompare.bombAndTwoDouble( a,b )
	local a_ = a:getRepeatetable()[4]
	local b_ = b:getRepeatetable()[4]
	local compareTagA = a_[#a_ == 8 and 5 or 1]
	local compareTagB = b_[#b_ == 8 and 5 or 1]
	return compareTagB < compareTagA
end

function CardCompare.bombAndTwoSingle( a,b )
	return CardCompare.bombandtwodouble(a,b)
end

function CardCompare.sequence( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

function CardCompare.doubleSequence( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

function CardCompare.tribleSequence( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

function CardCompare.planeInSingle( a,b )
	local tribleSequencesA = getTribleSequenceFromPlane(a, #a/4)
	local tribleSequencesB = getTribleSequenceFromPlane(b, #b/4)
	return CardCompare.triblesequence(tribleSequencesA, tribleSequencesB)
end

function CardCompare.tribleAndDouble(a, b)
	return CardCompare.trible(a, b)
end

function CardCompare.tribleAndSingle( a,b )
	return CardCompare.trible(a, b)
end

function CardCompare.planeInDouble( a,b )
	local tribleSequencesA = getTribleSequenceFromPlane(a, #a/5)
	local tribleSequencesB = getTribleSequenceFromPlane(b, #b/5)
	return CardCompare.triblesequence(tribleSequencesA, tribleSequencesB)
end

function CardCompare.captive( a,b )
	local a_ = a:getRepeatetable()[3]
	local b_ = b:getRepeatetable()[3]
	return b_[1] < a_[1]
end

local cardCompareDispatch = nil
local cardTypeJudgment = {}
function CardCompare.init( cardType, compareDispatch )
	cardCompareDispatch = compareDispatch
	cardTypeJudgment = cardType
end

function CardCompare.setCompareFun( typeName, fun )
	CardCompare[typeName] = fun
end

function CardCompare.getCompareFun( typeName )
	return CardCompare[typeName]
end

local function filterTypeForCompare( typesa, typesb )
	if #typesa == 1 and #typesb == 1 then
		return typesa[1],typesb[1]
	end

	local maxLevelInA = max(typesa, function ( typea,typeb )
		return cardTypeJudgment.getLevelByType(typea) > cardTypeJudgment.getLevelByType(typeb)
	end)
	local maxLevelInB = max(typesb, function ( typea,typeb )
		return cardTypeJudgment.getLevelByType(typea) > cardTypeJudgment.getLevelByType(typeb)
	end)

	if cardTypeJudgment.getLevelByType(maxLevelInA) ~= cardTypeJudgment.getLevelByType(maxLevelInB) then
		return maxLevelInA, maxLevelInB
	end
	--find insections
	for typeaName,typea in ipairs(typesa) do
		for typebName,typeb in ipairs(typesb) do
			if typea == typeb then
				return typea, typeb
			end
		end
	end
end

function CardCompare.compare( a,b )
	if b == nil or #b == 0 then
		return true
	end
	local typesa = cardTypeJudgment.getCardType(a)
	local typesb = cardTypeJudgment.getCardType(b)

	if #typesa == 0 or #typesb == 0 then
		return false
	else
		local typea, typeb = filterTypeForCompare(typesa, typesb)

		if typea ~= typeb then
			local levela = cardTypeJudgment.getLevelByType(typea)
			local levelb = cardTypeJudgment.getLevelByType(typeb)
			return levela > levelb
		else
			if cardCompareDispatch == nil then
				return CardCompare[typea](a,b)
			else
				return cardCompareDispatch[typea](a, b)
			end
		end
	end
end

local Dealor = {}
Dealor.__index = Dealor

function Dealor:new( playerNum, gloableCards, cardsNumForPerPlayer )
	local o = {}
	setmetatable(o, Dealor)
	o.playerNum = playerNum
	o.cards = util.createCardArray(gloableCards)
	o.cardNumForPerPlayer = cardsNumForPerPlayer
	math.randomseed(os.time())
	return o
end

function Dealor:shuffle(  )
	-- for i,v in ipairs(self.cards) do
	-- 	v = Card:new(v.num, v.color)
	-- end

	local cardsize = #self.cards
	for i=1,cardsize*2 do
		local index1 = math.random(cardsize)
		local index2 = math.random(cardsize)
	 	self.cards[index1], self.cards[index2] = self.cards[index2], self.cards[index1]
	end
end

function Dealor:deal(  )
	self:shuffle()

	local res = {}
	local i = 1
	local startIndex = 1
	local endIndex = self.cardNumForPerPlayer + 1
	while i <= self.playerNum do
		append(res, self.cards:sub(startIndex, endIndex))
		startIndex = endIndex
		endIndex = (i + 1)*self.cardNumForPerPlayer + 1
		i = i + 1
	end
	append(res, self.cards:sub(startIndex, #self.cards + 1))
	return res
end

function Dealor:getFirstOperatePlayer(  )
	return math.random(self.playerNum)
end

local CardGame = {}
CardGame.__index = CardGame

function CardGame:new(gameMsg, callback)
	local o = {}
	o.playerNum = gameMsg.playerNum
	o.cardNumForPerPlayer = gameMsg.cardNumForPerPlayer
	o.timeout = gameMsg.timeout
	o.doubleCardType = gameMsg.doubleCardType
	o.multiple = 1
	o.gloableCards = gameMsg.gloableCards
	o.cardCompareFun = gameMsg.cardCompareFun
	o.cardTypeFun = gameMsg.cardTypeFun

	if callback ~= nil then
		o.timeoutCallback = callback.timeoutCallback
		o.afterDeal = callback.afterDeal
	end
	setmetatable(o, CardGame)
	return o
end

function CardGame:deal( )
	local dealor = Dealor:new(self.playerNum, self.gloableCards,self.cardNumForPerPlayer)

	--发牌
	local cardsAfterDeal = dealor:deal()
	self.playerHandCards = cardsAfterDeal

	self.curOperatePlayer = dealor:getFirstOperatePlayer()
	self.leastCards = cardsAfterDeal[self.playerNum + 1]

	self:callbackAfterDeal(cardsAfterDeal[self.playerNum + 1])
	self.playerHandCards[self.playerNum + 1] = nil
end

function CardGame:callbackAfterDeal( leastCard )

end

function CardGame:callbackAfterHandout( playerIndex, handoutCards )

end

function CardGame:beginGame(  )
	self.handoutTime = newArray(self.playerNum)
	self.curCard = {}
	self.handoutFlags = newArray(self.playerNum)
end

function CardGame:increaseHandoutTime(playerIndex)
	self.handoutTime[playerIndex] = self.handoutTime[playerIndex] + 1
	if o.timeout <= self.handoutTime[playerIndex] then
		excuteFunctionMaybeNil(self.timeoutCallback, playerIndex)
		return true
	end

	return false
end

function CardGame:isAllcombo( winner )
	for playerIndex,hasHandout in ipairs(self.handoutFlags) do
		if playerIndex ~= winner and hasHandout then
			return false
		end
	end

	return true
end

function CardGame:isDouble( cards )
	local cardType = self.cardTypeFun(cards)
	if self.doubleCardType then
		return findInArray(self.doubleCardType, cardType, self.cardEqualFun)
	else
		return false
	end
end

function CardGame:nextPlayer(  )
	self.curOperatePlayer = modeRingNum(self.playerNum, self.curOperatePlayer + 1)
end

function CardGame:CallbackAfterWin( winner )

end

function CardGame:handoutSuccess( playerIndex, handoutCards )
	setmetatable( self.playerHandCards[playerIndex] , BDCardArray )
	setmetatable( handoutCards , BDCardArray )
	local handoutResult = self.playerHandCards[playerIndex]:hasSub(handoutCards)
	if handoutResult == false then return CardGame.NONEHANDCARD end
	self.playerHandCards[playerIndex] = self.playerHandCards[playerIndex] - handoutCards

	self.curCard.handoutPlayer = playerIndex
	self.curCard.handoutCards = handoutCards
	self.multiple = self:isDouble(handoutCards) and (self.multiple * 2) or self.multiple
	self.handoutFlags[playerIndex] = true
	self:callbackAfterHandout(playerIndex, handoutCards)
	if 0 == #self.playerHandCards[playerIndex] then
		self:clear()
		if self:isAllcombo(playerIndex) then
			self.multiple = self.multiple * 2
		end
		self:CallbackAfterWin(self.curOperatePlayer)
		return CardGame.WIN
	end
	self:nextPlayer()
	if handoutResult == true then
		return CardGame.SUCCESS
	end
end

CardGame.SUCCESS = 0 			--出牌成功
CardGame.PASS = 1				--过牌
CardGame.WIN = 2				--赢
CardGame.NOTCURPLAYER = 3		--非当前玩家出牌
CardGame.ERRORCARDTYPE = 4		--错误牌型
CardGame.NONEHANDCARD = 5		--手牌中没有对应的牌
CardGame.NOTBIGERTHANCUR = 6	--出的牌不能大过桌面的牌
function CardGame:handout( playerIndex, handoutCards )
	if playerIndex ~= self.curOperatePlayer then
		return CardGame.NOTCURPLAYER
	end

	self.handoutTime[playerIndex] = 0

	if (handoutCards == nil or #handoutCards == 0 ) and self.curCard.handoutPlayer ~= nil then
		self:nextPlayer()
		return CardGame.PASS
	elseif (handoutCards == nil or #handoutCards == 0 ) and self.curCard.handoutPlayer == nil then
		return CardGame.NOTCURPLAYER
	end

	handoutCards = util.createCardArray(handoutCards)
	local cardType = self.cardTypeFun(handoutCards)
	if cardtype == "errorcardtype" then
		return CardGame.ERRORCARDTYPE
	end


	if self.curCard.handoutPlayer == nil or self.curCard.handoutPlayer == playerIndex then
		return self:handoutSuccess(playerIndex, handoutCards)
	end

	if not self.cardCompareFun(handoutCards, self.curCard.handoutCards) then
		return CardGame.NOTBIGERTHANCUR
	end

	return self:handoutSuccess(playerIndex, handoutCards)
end

function CardGame:handoutAuto()
	if self.curCard == nil then
		return
	end
	if self.curCard.handoutPlayer == nil or self.curCard.handoutPlayer == self.curOperatePlayer then
		local autoHandoutCard =  self.playerHandCards[self.curOperatePlayer][1]
		return self:handout(self.curOperatePlayer, {autoHandoutCard}), util.createCardArray({autoHandoutCard})
	else
		return self:handout(self.curOperatePlayer) -- PASS
	end
end

function CardGame:clear()
	self.handoutTime = {}
end

local Timer = {}
Timer.__index = Timer

function Timer:new( timeout )
	local o = {}
	o.timeout = timeout
	o.time = 0
	setmetatable(o, Timer)
	return o
end

function Timer:increaseTime(  )
	self.time = self.time + 1
	if self.timeout <= self.time then
		excuteFunctionMaybeNil(self.timeoutCallback)
		return true
	end

	return false
end

function Timer:getReleaseTime(  )
	return self.timeout - self.time < 0 and 0 or self.timeout - self.time
end

function Timer:resetTime(  )
	self.time = 0
end


local ScoreCaller = {}
ScoreCaller.__index = ScoreCaller

ScoreCaller.ONCALLING = 0		--继续叫分
ScoreCaller.GAMEBEGINING = 1	--游戏开始
ScoreCaller.GONEXTGAME = 2		--流局（所有玩家都没有叫地主，重新发牌，直接进入下一局）
ScoreCaller.ERROR = 3			--错误

function ScoreCaller:new( firstCallPlayer, playerNum, multiple )
	local o = {}
	o.firstCallPlayer = firstCallPlayer
	o.playerNum = playerNum
	o.multiple = multiple
	o.curCallPlayer = o.firstCallPlayer
	o.secondRound = false
	o.callMarker = {}
	o.isContest = false
	for i=1,o.playerNum do
		append(o.callMarker,false)
	end
	setmetatable(o, ScoreCaller)
	return o
end

function ScoreCaller:getNextPlayerIndex( curPlayerId )
	local nextPlayerId = curPlayerId + 1
	if nextPlayerId > self.playerNum then
		nextPlayerId = 1
	end

	return nextPlayerId
end

function ScoreCaller:nextPlayer(  )
	self.curCallPlayer = self:getNextPlayerIndex(self.curCallPlayer)
end

function ScoreCaller:getLastCallPlayer(  )
	local lastCallPlayer = self.firstCallPlayer - 1
	if lastCallPlayer == 0 then
		lastCallPlayer = self.playerNum
	end
	return lastCallPlayer
end

function ScoreCaller:getPreviousPlayer( curPlayer )
	local previousPlayer = curPlayer - 1
	if previousPlayer == 0 then
		previousPlayer = self.playerNum
	end
	return previousPlayer
end

function ScoreCaller:callScoreForFirstRound( playerId, called )
	if playerId == self:getLastCallPlayer() then
		self.curCallPlayer = nil
		local playerIndex = self.firstCallPlayer
		local calledNum = 0
		repeat
			if self.callMarker[playerIndex] then
				calledNum = calledNum + 1
				if not self.curCallPlayer then
					self.curCallPlayer = playerIndex
				end
			end
			playerIndex = self:getNextPlayerIndex(playerIndex)
		until playerIndex == self.firstCallPlayer
		if calledNum > 1 then
			self.secondRound = true
			return ScoreCaller.ONCALLING
		else
			if called then
				self.landlord = playerId
				return ScoreCaller.GAMEBEGINING
			else
				self.landlord = self.curCallPlayer
				return self.landlord and ScoreCaller.GAMEBEGINING or ScoreCaller.GONEXTGAME
			end
		end
	else
		return ScoreCaller.ONCALLING
	end
end

function ScoreCaller:findFirstCalledFromLast( calledPlayerId, called )
	local playerIndex = self:getLastCallPlayer()
	repeat
		if self.callMarker[playerIndex] then
			self.landlord = playerIndex
			return ScoreCaller.GAMEBEGINING
		end
		playerIndex = self:getPreviousPlayer(playerIndex)
	until playerIndex == self:getLastCallPlayer()
end

function ScoreCaller:rushLandlord( playerId, called )
	if playerId ~= self.curCallPlayer then
		return ScoreCaller.ERROR
	end
	self:nextPlayer()

	if called then
		self.multiple = self.multiple * 2
	end

	if called and self.callMarker[playerId] then
		self.landlord = playerId
		return ScoreCaller.GAMEBEGINING
	end

	if not self.callMarker[playerId] then
		self.callMarker[playerId] = called
	end
	if self.secondRound then
		return self:findFirstCalledFromLast(playerId, called)
	else
		return self:callScoreForFirstRound(playerId, called)
	end
end

function ScoreCaller:getPreviousScore(  )
	local maxScore = 0
	for i=1,self.playerNum do
		if maxScore > self.callMarker[i] then
			maxScore = self.callMarker[i]
		end
	end
	return maxScore
end

ScoreCaller.MAXSCORE = 3
function ScoreCaller:callScore( playerId, score )
	if playerId ~= self.curCallPlayer then
		return ScoreCaller.ERROR
	end

	if score == 0 then
		if playerId ~= self:getLastCallPlayer() then
			self:nextPlayer()
			return ScoreCaller.ONCALLING
		end
	end

	if score <= self.multiple and score ~= 0 then
		return ScoreCaller.ERROR
	end

	if score ~= 0 then
		self.multiple = score
		self.maxScoreCaller = playerId
	end
	if playerId ~= self:getLastCallPlayer() and score ~= ScoreCaller.MAXSCORE then
		self:nextPlayer()
		return ScoreCaller.ONCALLING
	end

	if score == ScoreCaller.MAXSCORE then
		self.landlord = playerId
		return ScoreCaller.GAMEBEGINING
	elseif playerId == self:getLastCallPlayer() then
		if self.multiple == 0 then
			return ScoreCaller.GONEXTGAME
		else
			self.landlord = self.maxScoreCaller
			return ScoreCaller.GAMEBEGINING
		end
	end
end

function ScoreCaller:hasAnyoneCalled(  )

end

local GoldSettlement = {}
GoldSettlement.__index = GoldSettlement

function GoldSettlement:new( playerGolds, landlord, isFixBasescore )
	local o = {}
	o.playerGolds = playerGolds
	o.landlord = landlord
	o.isFixBasescore = isFixBasescore
	setmetatable(o, GoldSettlement)
	return o
end

function GoldSettlement:getMinigold(  )
	local minigold = self.playerGolds[1]
	for i,v in ipairs(self.playerGolds) do
		if v < minigold then
			minigold = v
		end
	end

	return minigold
end

function GoldSettlement:calculateBaseScore(  )
	local minigold = self:getMinigold()
	local baseScore = minigold/50
	baseScore = baseScore - baseScore % 100
	return baseScore
end

function GoldSettlement:getBaseScore(  )
	if self.baseScore == nil and not self.isFixBasescore then
		self.baseScore = self:calculateBaseScore()
	end
	return self.baseScore
end

function GoldSettlement:isLandlordWin( winner )
	return self.landlord == winner
end

function GoldSettlement:getGameResult( winner )
	local result = {}
	local WIN = 1
	local LOSE = -1

	local landlordWin = self:isLandlordWin(winner)
	if landlordWin then
		for i=1,#self.playerGolds do
			if self.landlord == i then
				result[i] = WIN
			else
				result[i] = LOSE
			end
		end
	else
		for i=1,#self.playerGolds do
			if self.landlord == i then
				result[i] = LOSE
			else
				result[i] = WIN
			end
		end
	end

	result[self.landlord] = result[self.landlord]*(#self.playerGolds - 1)

	return result
end

function GoldSettlement:getIndexByNum( num )
	local playerGoldsCount = #self.playerGolds
	if num % playerGoldsCount == 0 then
		return playerGoldsCount
	else
		return num%playerGoldsCount
	end
end

function GoldSettlement:equalDiviseLandlord( updateGolds, result )
	for i,_ in ipairs(updateGolds) do
		if i == self.landlord then
			updateGolds[i] = self.playerGolds[i] * result
		else
			updateGolds[i] = self.playerGolds[self.landlord]/(#self.playerGolds - 1) * (-result)
		end
	end

	return updateGolds
end

function GoldSettlement:filteScore( updateGolds )
	for i,updateGold in ipairs(updateGolds) do
		if updateGold + self.playerGolds[i] < 0 then
			if self.landlord == i then
				return self:equalDiviseLandlord(updateGolds, -1)
			else
				updateGolds[self.landlord] = updateGolds[self.landlord] - (abs(updateGold) - abs(self.playerGolds[i]))
				updateGolds[i] = -self.playerGolds[i]
			end
		elseif updateGold > self.playerGolds[i] then
			if self.landlord == i then
				return self:equalDiviseLandlord(updateGolds, 1)
			else
				updateGolds[i] = self.playerGolds[i]
				updateGolds[self.landlord] = updateGolds[self.landlord] + (abs(updateGold) - abs(self.playerGolds[i]))
			end
		end
	end

	return updateGolds
end

function GoldSettlement:getUpdateGolds(winner, multiple)
	local score = self:getBaseScore() * multiple
	local gameResults = self:getGameResult(winner)
	for i,_ in ipairs(gameResults) do
		gameResults[i] = gameResults[i] * score
	end
	return self:filteScore(gameResults)
end

function util.printRepeateTable( cards )
	table.walk(cards, function ( i,v )
		print(i, v:toStr())
	end)
end

util.Array = Array
util.Card = Card
util.BDCard = BDCard
util.CardArray = CardArray
util.BDCardArray = BDCardArray
util.CardArrayCollection = CardArrayCollection
util.CardFinder = CardTypeFinderWapper
util.CardType = CardTypeJudgment
util.CardCompare = CardCompare
util.Dealor = Dealor
util.CardGame = CardGame
util.ScoreCaller = ScoreCaller
util.GoldSettlement = GoldSettlement
util.Timer = Timer
util.HuTypes = HuTypes
util.createCardArray = function ( o,sortFun )
	return CardArray:new(o,sortFun)
end


return util


