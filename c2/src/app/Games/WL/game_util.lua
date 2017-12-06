
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
			if filter(v, i) then append(res, v) end
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
		error("empty array")
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

function Array:contract( array )
	contract(self, array)
	return self
end

function Array:map( f )
	local mapDes = map(self, f)
	setmetatable(mapDes, Array)
	return mapDes
end

function Array:filter( f )
	local filteDes = filter(self, f)
	setmetatable(mapDes, Array)
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
	if card == nil then
		return nil
	else
		return Card:new(card.num, card.color)
	end
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
	res = util.createCardArray(res)
	table.sort( res, a.sortFun )
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
		self.sortFun = sortFun
	end

	return o
end

CardArray.repeateTableSize = 16
function CardArray:createRepeatetable(  )
	local prev = 0
	local repeattime = 1
	self.repeateTable = newArray(CardArray.repeateTableSize)
	self.repeateTable = map(self.repeateTable, util.createCardArray)

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

function CardArray:getAtleastNsameSequences( n )
	local res = util.createCardArray()
	for i = n,4 do
		if #self:getRepeatetable()[i] ~= 0 then
			res = res + self.repeateTable[i]
		end
	end

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

function CardArray:getNSameSequence( n, f )
	local res = CardArrayCollection:new()

	local nSameElement = self:getAtleastNsameSequences(n)
	if nSameElement == nil or #nSameElement == 0 then return res end
	table.sort(nSameElement, self.sortFun)

	local repeatetime = 1
	local prev = nSameElement[1]
	local nSameSequence = util.createCardArray()
	nSameSequence:add(prev)
	local i = 2
	while i <= #nSameElement do
		local v = nSameElement[i]
		if v.num == prev.num then
			repeatetime = repeatetime + 1
			if repeatetime <= n then
				nSameSequence:add(v)
			end
		else
			if f and f(v, prev) or (v - prev > 1) then
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

function CardArray:onlyHasn( n )
	local repeatetable = self:getRepeatetable()
	if #repeatetable[n] == 0 then return false end
	return #repeatetable[n] == #self
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
	local tmp = util.createCardArray()
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

function CardArray:isSequences( internal, f )
	local fun = f ~= nil and f or function ( a,b )
		return a - b == 1
	end

	local i = 1
	while i + internal <= #self do
		if not fun(self[i + internal], self[i]) then
			return false
		else
			i = i + internal
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

function CardArray:hasNsameByNum( n )
	-- body
end

function CardArray:findNsamebyColor( n )
	local f = function ( a,b )
		return a.color == b.color
	end

	return self:findNsameF(n, f)
end

function CardArray:clearRepeatetable(  )
	self.repeateTable = nil
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
	local res = handcard:getNSameSequence(2)

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
	local res = handcard:getNSameSequence(3)

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
	local doublecollection = handcard:getAtleastNsameSequences(2)
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
	if cards:onlyHasn(2) == false then return false end
	if #cards < 6 then return false end
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

function CardType.tribleSequence( cards )
	if cards:find({num = 2,color = 0}) ~=nil then return false end
	if cards:onlyHasn(3) == false then return false end
	if #cards < 6 then return false end
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
	return cards:onlyHasn(4)
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
	for i,v in ipairs(self.cards) do
		v = Card:new(v.num, v.color)
	end

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
	return findInArray(self.doubleCardType, cardType, self.cardEqualFun)
end

function CardGame:nextPlayer(  )
	self.curOperatePlayer = modeRingNum(self.playerNum, self.curOperatePlayer + 1)
end

function CardGame:CallbackAfterWin( winner )

end

function CardGame:handoutSuccess( playerIndex, handoutCards )
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
util.CardArray = CardArray
util.CardArrayCollection = CardArrayCollection
util.CardFinder = CardTypeFinderWapper
util.CardType = CardTypeJudgment
util.CardCompare = CardCompare
util.Dealor = Dealor
util.CardGame = CardGame
util.ScoreCaller = ScoreCaller
util.GoldSettlement = GoldSettlement
util.Timer = Timer
util.createCardArray = function ( o )
	return CardArray:new(o)
end


return util


