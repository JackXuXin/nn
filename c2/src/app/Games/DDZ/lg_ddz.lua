local Card = {}
local CardType_Num = 1  --1代表1副牌的时候，2代表2副牌的时候
local maxPlayer = 3
--索引查询
Card.__index = Card
--相等
Card.__eq = function ( a,b )
	return a.num == b.num and a.color == b.color
end
--小于
Card.__lt = function ( a,b )
	local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
	return cardcomparetable[a.num] < cardcomparetable[b.num]
end
--减法
Card.__sub = function ( a,b )
	local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
	return cardcomparetable[a.num] - cardcomparetable[b.num]
end

function Card:new( num, color )
	if num > 15 or num < 1 then return nil end
	if color > 4 or color < 0 then return nil end

	local o = {}
	o.num = num
	o.color = color
	setmetatable(o, Card)

	return o
end

function append( t, v )
	if t == nil then
		t = {}
	end
	t[#t == 0 and 1 or #t + 1] = v
	return t
end

--拷贝table
function copy_table(ori_tab)
    if type(ori_tab) ~= "table" then
        return
    end
    local new_tab = {}
    for k,v in pairs(ori_tab) do
        local vtype = type(v)
        if vtype == "table" then
            new_tab[k] = copy_table(v)
        else
            new_tab[k] = v
        end
    end
    return new_tab
end

local CardArray = {}
CardArray.__index = CardArray

CardArray.__add = function ( a,b )
	local res = CardArray:new()
    for k,v in ipairs(a) do
		res[#res == 0 and 1 or #res + 1] = v
	end
    for k,v in ipairs(b) do
		res[#res == 0 and 1 or #res + 1] = v
	end
	table.sort( res, function ( a,b )
		local cardcomparetable = {12,13,1,2,3,4,5,6,7,8,9,10,11,14,15}
		return cardcomparetable[a.num] < cardcomparetable[b.num]
	end )
    return res
end

CardArray.__sub = function ( a,b )
	if a:hasSub(b) == false then error("argument#2 larger than argument1") end
	local res = CardArray:new()
	for k,v in ipairs(a) do
		if b:find(v) == nil then
			res:add(v)
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

function CardArray:new( cardarray )
	local o = {}
	setmetatable(o, CardArray)
	-- dump(cardarray, "CardArray:new:")
	if type(cardarray) == "table" then
		for k,v in ipairs(cardarray) do
			append(o, Card:new(v.num, v.color))
		end
		table.sort( o )
	end

	return o
end

function cardarrayFilter( a, f )
	local res = {}
	for k,v in pairs(a) do
		if f(v) then append(res, v) end
	end
	return res
end

--判断相同牌的函数
function CardArray:getRepeatetable(  )
	if self.repeatTable ~= nil then
		return self.repeatTable
	end

	local prev = 0
	local repeattime = 1
	if CardType_Num == 1 then
		self.repeateTable = {CardArray:new(),CardArray:new(),CardArray:new(),CardArray:new()}
	else
		self.repeateTable = {CardArray:new(),CardArray:new(),CardArray:new(),CardArray:new(),CardArray:new(),CardArray:new(),CardArray:new(),CardArray:new()}
	end
	

	for k,v in ipairs(self) do
		if v.num == prev then
			if CardType_Num == 1 then
				if repeattime <4 then
					repeattime = repeattime + 1
				end
			elseif CardType_Num == 2 then
				if repeattime <8 then
					repeattime = repeattime + 1
				end
			end
			
		else
			if repeattime > 1 then
				self.repeateTable[repeattime] = self.repeateTable[repeattime] + cardarrayFilter(self, function ( v1 )
					return v1.num == prev
				end)
			end
			repeattime = 1
			prev = v.num
		end
	end

	if repeattime > 1 then
		self.repeateTable[repeattime] = self.repeateTable[repeattime] + cardarrayFilter(self, function ( v1 )
						return v1.num == prev
					end)
	end

	return self.repeateTable
end

function CardArray:hasNsame( n )
	return #self:getRepeatetable()[n] ~= 0
end

function CardArray:getAtleastNsameSequences( n )
	local res = CardArray:new()
	if CardType_Num ==1 then
		for i = n,4 do
			if #self:getRepeatetable()[i] ~= 0 then
				res = res + self.repeateTable[i]
			end
		end
	elseif CardType_Num ==2 then
		for i = n,8 do
			if #self:getRepeatetable()[i] ~= 0 then
				res = res + self.repeateTable[i]
			end
		end
	end

	return res
end

function CardArray:onlyHasn( n )
	local repeatetable = self:getRepeatetable()
	if #repeatetable[n] == 0 then return false end
	return #repeatetable[n] == #self
end

function CardArray:find( card, f )
	card = Card:new(card.num, card.color)
	local findF = f ~= nil and f or function ( a,b )
		return a== b
	end
	for k,v in ipairs(self) do
		if findF(v,card) then return k end
	end

	return nil
end

function CardArray:sort( f )
	table.sort( self, f )
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
	for k,v in ipairs(sub) do
		if self:find(v) == nil then return false end
	end

	return true
end

function CardArray:sub( s,e )
	local tmp = CardArray:new()
	for i,v in ipairs(self) do
		if i >= s and i < e then
			tmp:add(v)
		end
	end

	return tmp
end

function CardArray:add( card )
	append(self, card)
--	table.sort(self)	--暂时先这么处理，比较简单
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

function CardArray:findNsame( n, f )
	if self == nil or #self == 0 then
		return CardArray:new() --空集
	end

	local res = CardArray:new()
	local repeatetime = 0
	local prev = self[1]
	for k,v in pairs(self) do
		if f(v,prev) then
			repeatetime = repeatetime + 1
		else
			if repeatetime == n then
				res:add(prev)
			end
			repeatetime = 1
			prev = v
		end
	end

	if repeatetime ~= 1 and n ~= 1 and repeatetime == n then
		res:add(self[#self])
	end

	local resTmpSize = #res
	local i = 1
	while i <= resTmpSize do
		for k,v in pairs(self) do
			if f(v,res[1]) then
				append(res, v)
			end
		end
		table.remove(res,1)
		i = i + 1
	end

	return res
end

function CardArray:findNsameByNum( n )
	local f = function ( a,b )
		return a.num == b.num
	end

	return self:findNsame(n, f)
end

function CardArray:hasNsameByNum( n )
	-- body
end

function CardArray:findNsamebyColor( n )
	local f = function ( a,b )
		return a.color == b.color
	end

	return self:findNsame(n, f)
end

function CardArray:clearRepeatetable(  )
	self.repeateTable = nil
end


local CardTypeFinderDispatch = {}

local function isSingle( cardset )
	return #cardset == 1
end

local function isDouble( cardset )
	return #cardset == 2 and cardset[1].num == cardset[2].num
end

--双王(一副牌)
local function isRocket( cardset )
	
	if #cardset == 2 then
		return (cardset[1].num == 14 and cardset[2].num == 15) or (cardset[1].num == 15 and cardset[2].num == 14)
	end
	
end

--双小王（两副牌）
local function isRocket_1( cardset )
	
	if #cardset == 2 then
		return cardset[1].num == 14 and cardset[2].num == 14
	end
	
end

--双大王（两副牌）
local function isRocket_2( cardset )
	
	if #cardset == 2 then
		return cardset[1].num == 15 and cardset[2].num == 15
	end
	
end
--4王（两副牌）
local function isRocket_3( cardset )
	
	if #cardset == 4 then
		for k,v in pairs(cardset) do
			if v.num <14 then
				return false
			elseif k == 4 then
				return true
			end
		end
		
	else
		return false
	end
	
end

local function isTrible( cardset )
	return #cardset == 3 and cardset:hasNsame(3)
end

local function isTribleanddouble( cardset )
	if #cardset ~= 5 then return false end
	if false == cardset:hasNsame(3) then return false end
	if false == cardset:hasNsame(2) then return false end
	return true
end

local function isTribleandsingle( cardset )
	if #cardset ~= 4 then return false end
	if false == cardset:hasNsame(3) then return false end
	return true
end
--连对 （3个对子起步）
local function isDoubleSequence( cardset )
	for k,v in pairs(cardset) do
		if v.num == 2 or v.num == 14 or v.num == 15 then
			return false
		end
	end
	if cardset:onlyHasn(2) == false then return false end
	if #cardset < 6 then return false end
	local prev
	for k,v in ipairs(cardset) do
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
--3连3张（飞机）
local function isTribleSequence( cardset )
	for k,v in pairs(cardset) do
		if v.num == 2 or v.num == 14 or v.num == 15 then
			return false
		end
	end
	if cardset:onlyHasn(3) == false then return false end
	-- if CardType_Num == 1 then
	-- 	--1副牌
	-- 	if #cardset < 6 then return false end
	-- elseif CardType_Num == 2 then
	-- 	--2副牌
	-- 	if #cardset < 9 then return false end
	-- end
	if maxPlayer == 3 and CardType_Num == 2 then
		
		if #cardset < 9 then return false end
	else
		if #cardset < 6 then return false end
	end
	local prev
	for k,v in ipairs(cardset) do
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

local function getTribleSequenceFromPlane( cardset, planeSize )
	local triblesequences = CardTypeFinderDispatch.triblesequence(cardset, planeSize * 3)
	return triblesequences[#triblesequences]
end

local function isPlaneInDouble( cardset )
	if #cardset < 10 or #cardset % 5 ~= 0 then return false end
	local tribleSequences = CardTypeFinderDispatch.triblesequence(cardset)
	if #tribleSequences == 0 then
		return false
	end
	local plane = tribleSequences[1]
	local doubleWings = CardTypeFinderDispatch.double(cardset - plane)
	local planeSize = #plane/3
	local wingSize = #doubleWings
	return planeSize == wingSize
end

local function isPlaneInSingle( cardset )
	if #cardset < 8 or #cardset % 4 ~= 0 then return false end
	local tribleSequencesForPlane = CardTypeFinderDispatch.triblesequence(cardset, #cardset/4*3)
	if #tribleSequencesForPlane == 0 then
		return false
	end
	local plane = tribleSequencesForPlane[1]
	local planeSize = #plane/3
	local wing = cardset - plane
	local wingSize = #wing
	return planeSize == wingSize
end
--是否顺子
local function isSequence( cardset )

	for k,v in pairs(cardset) do
		if v.num == 2 or v.num == 14 or v.num == 15 then
			return false
		end
	end

	if #cardset < 5 then return false end
	if cardset:hasNsame(2) then return false end
	if cardset:hasNsame(3) then return false end
	if cardset:hasNsame(4) then return false end
	if  CardType_Num == 2 then
		if cardset:hasNsame(5) then return false end
		if cardset:hasNsame(6) then return false end
		if cardset:hasNsame(7) then return false end
		if cardset:hasNsame(8) then return false end
	end

	local prev
	for k,v in ipairs(cardset) do
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

--是否是飞机
local function isWingOfPlane( wing, plane )
	local sizeOfPlane = #plane/3
	local sizeOfWing = sizeOfPlane
	local winInSingle = wing
	if #winInSingle == sizeOfWing then return true end

	local winInDouble = CardTypeFinderDispatch.double(wing)
	if #winInDouble * 2 ~= #wing then
		return false
	else
		return true
	end
end

local function isPlane( cards )
	local triblesequences = CardTypeFinderDispatch.triblesequence(cards)
	if #triblesequences == 0 then return false end
	for i,v in ipairs(triblesequences) do
		local plane = v
		local wing = cards - plane
		if isWingOfPlane(wing, plane) then return true end
	end
	return false
end
--4张相同的牌
local function isBomb( cardset )
	if #cardset ~= 4 then return false end
	return cardset:onlyHasn(4)
end
--4张相同的牌带2个单张
local function isBombandtwosingle( cardset )
	if #cardset ~= 6 then return false end

	return cardset:hasNsame(4)
end
--4张相同的牌带2对
local function isBombandtwodouble( cardset )
	if #cardset ~= 8 then return false end
	local bomb = CardTypeFinderDispatch.bomb(cardset)
	if #bomb == 0 then
		return false
	end
	local double = CardTypeFinderDispatch.double(cardset - bomb[1])
	if #double ~= 2 then
		return false
	end

	return true
end
--2副扑克 5炸
local function isBomb_5( cardset )
	if #cardset ~= 5  then
		return false
	end
	return cardset:onlyHasn(5)
end

--2副扑克 6炸
local function isBomb_6( cardset )
	if #cardset ~= 6  then
		return false
	end
	return cardset:onlyHasn(6)
end

--2副扑克 7炸
local function isBomb_7( cardset )
	if #cardset ~= 7  then
		return false
	end
	return cardset:onlyHasn(7)
end

--2副扑克 8炸
local function isBomb_8( cardset )
	if #cardset ~= 8  then
		return false
	end
	return cardset:onlyHasn(8)
end

local CardTypeDispatch = {}
--基础牌型（通用）
CardTypeDispatch["single"] = isSingle     						--单张 
CardTypeDispatch["double"] = isDouble     						--对子
CardTypeDispatch["trible"] = isTrible   						--3张
CardTypeDispatch["sequence"] = isSequence         				--顺子
CardTypeDispatch["bomb"] = isBomb 								--炸弹（4张）
CardTypeDispatch["doublesequence"] = isDoubleSequence 			--连对
CardTypeDispatch["triblesequence"] = isTribleSequence   		--3连3张（飞机）什么都不带 （2副牌的飞机3连以上，且什么都不能带）

--1副牌
CardTypeDispatch["rocket"] = isRocket                           --王炸 （2张王）
CardTypeDispatch["tribleandsingle"] = isTribleandsingle 		--3带1
CardTypeDispatch["tribleanddouble"] = isTribleanddouble 		--3带2
CardTypeDispatch["planeInSingle"] = isPlaneInSingle 	        --3连3张（飞机）带1张
CardTypeDispatch["planeInDouble"] = isPlaneInDouble             --3连3张（飞机）带1对
CardTypeDispatch["bombandtwosingle"] = isBombandtwosingle       --4带2张单张
CardTypeDispatch["bombandtwodouble"] = isBombandtwodouble    	--4带2对

--2副牌
-- CardTypeDispatch["rocket_1"] = isRocket_1						--双小王
-- CardTypeDispatch["rocket_2"] = isRocket_2						--双大王
CardTypeDispatch["rocket_3"] = isRocket_3						--4王
CardTypeDispatch["bomb_5"]   = isBomb_5							--5炸
CardTypeDispatch["bomb_6"]   = isBomb_6							--6炸
CardTypeDispatch["bomb_7"]   = isBomb_7							--7炸
CardTypeDispatch["bomb_8"]   = isBomb_8							--8炸



local bit = require "bit"

--私人房间规则
function setCardType(customization)
	-- if bit.band(customization, 16) > 0 then
	-- 	CardTypeDispatch["tribleandsingle"] = isTribleandsingle
	-- 	CardTypeDispatch["tribleanddouble"] = nil
		
 --        -- rule_text = rule_text .. "可三带一、"
 --    elseif bit.band(customization, 8) > 0 then
 --    	CardTypeDispatch["tribleandsingle"] = nil
 --    	CardTypeDispatch["tribleanddouble"] = isTribleanddouble
    	
    	
 --        -- rule_text = rule_text .. "可3带一对、"
 --    elseif bit.band(customization, 4) > 0 then
 --    	CardTypeDispatch["tribleandsingle"] = isTribleandsingle
	-- 	CardTypeDispatch["tribleanddouble"] = isTribleanddouble
    	
 --        -- rule_text = rule_text .. "可三带一也可3带一对、"
 --    end
 	if bit.band(customization, 1) > 0 then
        -- maxPlayer = 3
        CardType_Num = 1
        maxPlayer = 3
                  
    elseif bit.band(customization, 2) > 0 then
        -- maxPlayer = 3
        CardType_Num = 2
        maxPlayer = 3
                    
    elseif bit.band(customization, 4) > 0 then
        -- maxPlayer = 4
        CardType_Num = 2
        maxPlayer = 4
                    
    end
    
    if CardType_Num == 1 then        --1副牌
  --   	CardTypeDispatch["rocket_1"] = nil				--双小王
		-- CardTypeDispatch["rocket_2"] = nil				--双大王
		CardTypeDispatch["rocket_3"] = nil				--4王
		CardTypeDispatch["bomb_5"]   = nil				--5炸
		CardTypeDispatch["bomb_6"]   = nil				--6炸
		CardTypeDispatch["bomb_7"]   = nil				--7炸
		CardTypeDispatch["bomb_8"]   = nil				--8炸

		CardTypeDispatch["rocket"] = isRocket                           --王炸 （2张王）
		CardTypeDispatch["tribleandsingle"] = isTribleandsingle 		--3带1
		CardTypeDispatch["tribleanddouble"] = isTribleanddouble 		--3带2
		CardTypeDispatch["planeInSingle"] = isPlaneInSingle 	        --3连3张（飞机）带1张
		CardTypeDispatch["planeInDouble"] = isPlaneInDouble             --3连3张（飞机）带1对
		CardTypeDispatch["bombandtwosingle"] = isBombandtwosingle       --4带2张单张
		CardTypeDispatch["bombandtwodouble"] = isBombandtwodouble    	--4带2对
    	
    elseif CardType_Num == 2 then    --2副牌
    	CardTypeDispatch["rocket"] = nil                --王炸 （2张王）
		CardTypeDispatch["tribleandsingle"] = nil 		--3带1
		CardTypeDispatch["tribleanddouble"] = nil 		--3带2
		CardTypeDispatch["planeInSingle"] = nil 	    --3连3张（飞机）带1张
		CardTypeDispatch["planeInDouble"] = nil         --3连3张（飞机）带1对
		CardTypeDispatch["bombandtwosingle"] = nil      --4带2张单张
		CardTypeDispatch["bombandtwodouble"] = nil    	--4带2对

		CardTypeDispatch["rocket_3"] = isRocket_3						--4王
		CardTypeDispatch["bomb_5"]   = isBomb_5							--5炸
		CardTypeDispatch["bomb_6"]   = isBomb_6							--6炸
		CardTypeDispatch["bomb_7"]   = isBomb_7							--7炸
		CardTypeDispatch["bomb_8"]   = isBomb_8							--8炸

    end
end

function getCardtypeForCompare( cardset )
	if cardset == nil then return {} end

	local resType = {}
	for cardTypeName,judgeFuction in pairs(CardTypeDispatch) do
		if judgeFuction(cardset) then
			append(resType, cardTypeName)
		end
	end
	
	-- dump(resType, "返回当前的牌型")
	return resType
end

local function getCardType( cardset )
	local types = getCardtypeForCompare(cardset)
	if #types == 0 then
		return "errorcardtype"
	end
	return types[1]
end

local CardCompareDispatch = {}

function CardCompareDispatch.single( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.double( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.trible( a,b )
	local a_ = a:getRepeatetable()[3]
	local b_ = b:getRepeatetable()[3]
	return b_[1] < a_[1]
end

function CardCompareDispatch.bomb( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.bomb_5( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.bomb_6( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.bomb_7( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.bomb_8( a,b )
	return b[1] < a[1]
end

function CardCompareDispatch.bombandtwodouble( a,b )
	local a_ = a:getRepeatetable()[4]
	local b_ = b:getRepeatetable()[4]
	local compareTagA = a_[#a_ == 8 and 5 or 1]
	local compareTagB = b_[#b_ == 8 and 5 or 1]
	return compareTagB < compareTagA
end

function CardCompareDispatch.bombandtwosingle( a,b )
	return CardCompareDispatch.bombandtwodouble(a,b)
end

function CardCompareDispatch.sequence( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

function CardCompareDispatch.doublesequence( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

function CardCompareDispatch.triblesequence( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

function CardCompareDispatch.planeInSingle( a,b )
	local tribleSequencesA = getTribleSequenceFromPlane(a, #a/4)
	local tribleSequencesB = getTribleSequenceFromPlane(b, #b/4)
	return CardCompareDispatch.triblesequence(tribleSequencesA, tribleSequencesB)
end

function CardCompareDispatch.tribleanddouble(a, b)
	return CardCompareDispatch.trible(a, b)
end

function CardCompareDispatch.tribleandsingle( a,b )
	return CardCompareDispatch.trible(a, b)
end

function CardCompareDispatch.planeInDouble( a,b )
	local tribleSequencesA = getTribleSequenceFromPlane(a, #a/5)
	local tribleSequencesB = getTribleSequenceFromPlane(b, #b/5)
	return CardCompareDispatch.triblesequence(tribleSequencesA, tribleSequencesB)
end

--获取当前牌的等级，数字大的大
local function DDZCardLevel( cardType )
	local level
	if CardType_Num == 1 then
		level = {bomb = 2, rocket = 3}
	elseif CardType_Num == 2 then
		level = {bomb = 2, bomb_5 = 3,bomb_6 = 4,bomb_7 = 5,bomb_8 = 6,rocket_3 = 7}
	end

	return level[cardType] == nil and 1 or level[cardType]
end

local function getBombOrRocktFormTypes( types )
	for i,v in ipairs(types) do
		if CardType_Num == 1 then
			if v == "bomb" or v == "rocket" then
				return {v}
			end
		elseif CardType_Num == 2 then
			if v == "bomb" or "bomb_5" or "bomb_6" or "bomb_7" or "bomb_8" or v == "rocket_3"  then
				return {v}
			end
		end
		
	end

	return types
end

local function getTypeForCompare( typesa, typesb )
	if #typesa == 1 and #typesb == 1 then
		return typesa[1],typesb[1]
	end

	typesa = getBombOrRocktFormTypes(typesa)
	typesb = getBombOrRocktFormTypes(typesb)

	--find insections
	for ai,av in ipairs(typesa) do
		for bi,bv in ipairs(typesb) do
			if av == bv then
				return av, bv
			end
		end
	end

	return nil
end
--比较函数
local function DDZCompare( a,b )
	if b == nil or #b == 0 then
		return true
	end
	local typesa = getCardtypeForCompare(a)
	local typesb = getCardtypeForCompare(b)
	local cardtypea, cardtypeb = getTypeForCompare(typesa, typesb)
	if cardtypea == nil then
		return false
	end

	if cardtypea == "errorcardtype" then return false end
	if cardtypeb == "errorcardtype" then return false end

	if cardtypea ~= cardtypeb then
		local levela = DDZCardLevel(cardtypea)
		local levelb = DDZCardLevel(cardtypeb)
		return levela > levelb
	end
	return CardCompareDispatch[cardtypea](a, b)
end

local function DDZCompareWaper( a,b )
	return DDZCompare(b,a)
end

local DDZCardArray = {}
setmetatable(DDZCardArray, CardArray)
DDZCardArray.__index = DDZCardArray
DDZCardArray.__lt = DDZCompareWaper
DDZCardArray.__sub = CardArray.__sub
DDZCardArray.__add = CardArray.__add
DDZCardArray.__eq = function ( a,b )
	if #a ~= #b then return false end
	for i=1,#a do
		if a[i].num ~= b[i].num then
			return false
		end
	end

	return true
end
function DDZCardArray:new( o )
	local newObj = CardArray:new(o)
	setmetatable(newObj, DDZCardArray)
	return newObj
end

function DDZCardArray:getCardType(  )
	return getCardType(self)
end

local Player = {}
Player.__index = Player

Player.UNREADY = 0
Player.READY = 1
Player.INGAME = 2
Player.TUOGUAN = 3

function Player:new( v )
	local obj = {}
	setmetatable(obj, Player)
	obj.state = Player.UNREADY
	obj.handcard = {}
	obj.handoutTime = 0
	obj.multiple = 1
	obj.hasHandout = false
	return obj
end

function Player:setHasHandout( hasHandout )
	self.hasHandout = hasHandout
end

function Player:getHasHandout(  )
	return self.hasHandout
end

function Player:getState(  )
	return self.state
end

function Player:setState( state )
	self.state = state
end

function Player:getMultiple(  )
	return self.multiple
end

function Player:toBelandlord( ... )
	self.multiple = self.multiple * 2
end

function Player:reset(  )
	self.handoutTime = 0
	self.multiple = 1
	self.state = Player.UNREADY
	self.hasHandout = false
end

function Player:resetHandoutTime(  )
	self.handoutTime = 0
end

function Player:handout( cardset )
	if not self.handcard:hasSub(cardset) then
		return false
	end
	self.multiple = isBombOrRocket(cardset) and (self.multiple * 2) or self.multiple
	self.handcard = self.handcard - cardset
	if #self.handcard == 0 then return 0 end
	return true
end

function Player:setHandoutCard( cards )
	self.handoutCard = cards
end

function Player:getHandoutCard(  )
	if self.handoutCard == nil then
		return {}
	end
	return self.handoutCard
end

function Player:increaseHandoutTime(  )
	self.handoutTime = self.handoutTime + 1
	return self.handoutTime
end

function Player:getHandoutTime(  )
	return self.handoutTime
end


local DDZGame = {}
local DDZAllcomboJudment = {}
DDZGame.__index = DDZGame

--游戏状态
DDZGame.WAITFORPLAYER = 0
DDZGame.INGAME = 1
DDZGame.CALLSCORE = 2

local g_card = {
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
	{num = 14, color = 4}, {num = 15, color = 4}
}


function DDZGame:new( openCardTime )
	local obj = {}
	setmetatable(obj, DDZGame)
	obj.state = DDZGame.WAITFORPLAYER
	obj.players = {}
	obj.players[1] = Player:new()
	obj.players[2] = Player:new()
	obj.players[3] = Player:new()

	self.callMarker = obj.players
	self.multiple = 1/2
	return obj
end

function DDZGame:joined( seatid )
	self.players[seatid].seatid = seatid
end

function DDZGame:cancelTuoGuan(seatid)
	self:getPlayer(seatid).state = Player.INGAME
end

function DDZGame:deal(  )
	--disorder card
	math.randomseed(os.time())

	for i,v in ipairs(g_card) do
		v = Card:new(v.num, v.color)
	end

	--洗牌
	local cardsize = #g_card
	for i=1,51 do
		index = math.random(cardsize)
	 	g_card[1], g_card[index] = g_card[index], g_card[1]
	end

	--发牌
	self.cardleast = CardArray:new()
	self.players[1].handcard = CardArray:new()
	self.players[2].handcard = CardArray:new()
	self.players[3].handcard = CardArray:new()
	for i,v in ipairs(g_card) do
		if i > 51 then
			self.cardleast:add(v)
		else
			if i % 3 == 0 then self.players[1].handcard:add(v) end
			if i % 3 == 1 then self.players[2].handcard:add(v) end
			if i % 3 == 2 then self.players[3].handcard:add(v) end
		end
	end

	self.curOperatePlayer = math.random(3)
	self.callMarker = {
		self:getPlayer(self.curOperatePlayer),
		self:getPlayer(getSeatidByNum(self.curOperatePlayer + 1)),
		self:getPlayer(getSeatidByNum(self.curOperatePlayer + 2))
	}
	self.multiple = 1/2
	self.curCard = {}

	self.landlordHandoutOnce = nil

	self:changePlayerState(Player.INGAME)
	self.state = DDZGame.CALLSCORE
	return self.curOperatePlayer,self.cardleast
end

function DDZGame:changePlayerState( state )
	self.players[1].state = state
	self.players[2].state = state
	self.players[3].state = state
end

function DDZGame:getState(  )
	return self.state
end

function DDZGame:setState( state )
	self.state = state
end

function DDZGame:getPlayer( seatid )
	return self.players[seatid]
end

function getPlayerIndexByNum( num )
	if num % 3 == 0 then
		return 3
	else
		return num%3
	end
end

function DDZGame:getNextOperatePlayer( )
	self.curOperatePlayer = getPlayerIndexByNum(self.curOperatePlayer + 1)
	return self.curOperatePlayer
end


-- called true: 叫地主 false 不叫
--return value:
DDZGame.ONCALLING = 0		--继续叫分
DDZGame.GAMEBEGINING = 1	--游戏开始
DDZGame.GONEXTGAME = 2		--流局（所有玩家都没有叫地主，重新发牌，直接进入下一局）
DDZGame.ERROR = 3			--错误

function DDZGame:setLandlord( callMarkerIndex )
	self.landlord = self.callMarker[callMarkerIndex].seatid
	self:clearCallMaker()
	self.state = DDZGame.INGAME
	self.curOperatePlayer = self.landlord
	self:getPlayer(self.landlord):toBelandlord()

	self.DDZAllcomboJudment = DDZAllcomboJudment:new({
		self.players[1].handcard,
		self.players[2].handcard,
		self.players[3].handcard},
		self.landlord)
end

function DDZGame:setPlayerGold( gold )
	self.playerGold = gold
	self.baseSocre = nil
end

function DDZGame:getMinigold(  )
	local minigold = self.playerGold[1]
	for i,v in ipairs(self.playerGold) do
		if v < minigold then
			minigold = v
		end
	end

	return minigold
end

function DDZGame:calculateBaseScore(  )
	local minigold = self:getMinigold()
	local baseScore = minigold/50
	baseScore = baseScore - baseScore % 100
	return baseScore
end

function DDZGame:getBaseScore(  )
	if self.baseSocre == nil then
		self.baseSocre = self:calculateBaseScore()
	end
	return self.baseSocre
end

function DDZGame:getWinner(  )
	for i,v in ipairs(self.players) do
		if #v.handcard == 0 then
			return i
		end
	end
end

function DDZGame:isLandlordWin(  )
	local winner = self:getWinner()
	return winner == self.landlord
end

function DDZGame:getGameResult(  )
	local result = {}
	local WIN = 1
	local LOSE = -1

	local landlordWin = self:isLandlordWin()
	if landlordWin then
		result[1] = self.landlord == 1 and WIN or LOSE
		result[2] = self.landlord == 2 and WIN or LOSE
		result[3] = self.landlord == 3 and WIN or LOSE
	else
		result[1] = self.landlord == 1 and LOSE or WIN
		result[2] = self.landlord == 2 and LOSE or WIN
		result[3] = self.landlord == 3 and LOSE or WIN
	end

	result[self.landlord] = result[self.landlord]*2

	return result
end

function DDZGame:filteScore( updateGold )
	for i,v in ipairs(updateGold) do
		if v + self.playerGold[i] < 0 then
			if self.landlord == i then
				updateGold[i] = -self.playerGold[i]
				updateGold[getPlayerIndexByNum(i + 1)] = self.playerGold[i]/2
				updateGold[getPlayerIndexByNum(i + 2)] = self.playerGold[i]/2
				return updateGold
			else
				updateGold[self.landlord] = updateGold[self.landlord] + (v + self.playerGold[i])
				updateGold[i] = -self.playerGold[i]
			end
		elseif v > self.playerGold[i] then
			if self.landlord == i then
				updateGold[i] = self.playerGold[i]
				updateGold[getPlayerIndexByNum(i + 1)] = -self.playerGold[i]/2
				updateGold[getPlayerIndexByNum(i + 2)] = -self.playerGold[i]/2
				return updateGold
			else
				updateGold[i] = self.playerGold[i]
				updateGold[self.landlord] = updateGold[self.landlord] - (v - self.playerGold[i])
			end
		end
	end

	return updateGold
end

function DDZGame:getScore()
	local score = self:getBaseScore() * self:getMultiple()
	local gameResult = self:getGameResult()
	return self:filteScore({score*gameResult[1], score*gameResult[2], score*gameResult[3]})
end

function DDZGame:callScore( seatid, called )
	if seatid ~= self.curOperatePlayer then
		return DDZGame.ERROR
	end

	if seatid == self.callMarker[3].seatid then
		self.secondRound = true
	end

	self:getPlayer(seatid):resetHandoutTime()
	self.curOperatePlayer = self:getNextOperatePlayer()
	if called then
		self:getPlayer(seatid).calledLandlord = true
		self.multiple = self.multiple * 2
	end

	--第一个玩家第二次叫地主
	if self.callMarker[1].seatid == seatid and self.secondRound then
		if called then
			self:setLandlord(1)
		else
			self:setLandlord(self.callMarker[3].calledLandlord and 3 or 2)
		end
		return DDZGame.GAMEBEGINING
	elseif self.callMarker[1].seatid == seatid and self.callMarker[1].calledLandlord and not called then
		if self.callMarker[3].calledLandlord then
			self:setLandlord(3)
			return DDZGame.GAMEBEGINING
		else
			self:setLandlord(2)
			return DDZGame.GAMEBEGINING
		end
	end

	--第一个玩家没有叫地主，最后一个叫地主玩家
	if self.callMarker[1].calledLandlord == nil and seatid == self.callMarker[3].seatid then
		if called and (not self.callMarker[2].calledLandlord) then
			self:setLandlord(3)
			return DDZGame.GAMEBEGINING
		elseif called and self.callMarker[2].calledLandlord then
			self.curOperatePlayer = self.callMarker[2].seatid
			return DDZGame.ONCALLING
		elseif self.callMarker[2].calledLandlord then
			self:setLandlord(2)
			return DDZGame.GAMEBEGINING
		else
			self:clearCallMaker()
			return DDZGame.GONEXTGAME
		end
	end

	--第二个玩家第二次叫地主
	if self.callMarker[1].calledLandlord == nil and self.secondRound then
		if called then
			self:setLandlord(2)
		else
			self:setLandlord(3)
		end
		return DDZGame.GAMEBEGINING
	end

	--第一个玩家叫地主，其他两个玩家没叫
	if self.callMarker[1].calledLandlord and seatid == self.callMarker[3].seatid then
		if self.callMarker[2].calledLandlord == nil and self.callMarker[3].calledLandlord == nil then
			self:setLandlord(1)
			return DDZGame.GAMEBEGINING
		end
	end

	return DDZGame.ONCALLING
end

function DDZGame:clearCallMaker(  )
	self:getPlayer(1).calledLandlord = nil
	self:getPlayer(2).calledLandlord = nil
	self:getPlayer(3).calledLandlord = nil
	self.fistPlayerHasCalled = false
	self.secondRound = false
end

function DDZGame:getMultiple(  )
	return self.multiple == 0.5 and 0 or self.multiple
end

function DDZGame:getLeastcard(  )
	return self.cardleast
end

function getSeatidByNum( num )
	if num % 3 == 0 then
		return 3
	else
		return num % 3
	end
end

function getLastCalledPlayer( firsstCalledPlayer )
	return getSeatidByNum(firstCalledPlayer + 2)
end

function isBombOrRocket( cardset )
	return getCardType(cardset) == "bomb" or getCardType(cardset) == "rocket"
end

DDZAllcomboJudment.__index = DDZAllcomboJudment

DDZAllcomboJudment.FARMALLCOMBO = 1
DDZAllcomboJudment.LANDLORDALLCOMBO = 2

function DDZAllcomboJudment:new( playersHandcard, landlord )
	local o = {}
	self.playersHandcard = playersHandcard
	self.landlord = landlord

	setmetatable(o,DDZAllcomboJudment)
	return o
end

function DDZAllcomboJudment:handout( seatid )
	if not self.landlordHandoutOnce and #self.playersHandcard[self.landlord] == 20 then
		self.landlordHandoutOnce = true
	end
	if self.landlordHandoutOnce and #self.playersHandcard[self.landlord] ~= 20 then
		self.landlordHandoutOnce = false
	end
end

function DDZGame:isAllcombo( winPlayer )
	if self.landlord == winPlayer then
		self.allComboType = DDZAllcomboJudment.LANDLORDALLCOMBO
		return #self.players[getPlayerIndexByNum(winPlayer + 1)].handcard == 17 and
			#self.players[getPlayerIndexByNum(winPlayer + 2)].handcard == 17
	else
		if self.landlordHandoutOnce then
			self.allComboType = DDZAllcomboJudment.FARMALLCOMBO
		end
		return self.landlordHandoutOnce
	end
end

function DDZGame:getAllcomboType(  )
	return self.allComboType
end


DDZGame.SUCCESS = 0 			--出牌成功
DDZGame.PASS = 1				--过牌
DDZGame.WIN = 2					--赢
DDZGame.NOTCURPLAYER = 3		--非当前玩家出牌
DDZGame.ERRORCARDTYPE = 4		--错误牌型
DDZGame.NONEHANDCARD = 5		--手牌中没有对应的牌
DDZGame.NOTBIGERTHANCUR = 6		--出的牌不能大过桌面的牌
function DDZGame:handout( seatid, cardset )
	if seatid ~= self.curOperatePlayer then
		return DDZGame.NOTCURPLAYER, "seatid = "..tostring(seatid).." cur = "..tostring(self.curOperatePlayer)
	end

	self:getPlayer(seatid):setHasHandout(true)
	self:getPlayer(self.curOperatePlayer):resetHandoutTime()
	if cardset == nil then
		self:getPlayer(seatid):setHandoutCard({})
		self.curOperatePlayer = self:getNextOperatePlayer()
		return DDZGame.PASS
	end

	cardset = DDZCardArray:new(cardset)
	local cardType = getCardType(cardset)
	if cardtype == "errorcardtype" then
		return DDZGame.ERRORCARDTYPE
	end

	if not self.landlordHandoutOnce and seatid == self.landlord then
		self.landlordHandoutOnce = true
	end
	if self.landlordHandoutOnce and seatid == self.landlord and #self.players[self.landlord].handcard ~= 20  then
		self.landlordHandoutOnce = false
	end

	if self.curCard.handoutPlayer == nil or self.curCard.handoutPlayer == seatid then
		local handoutResult = self:getPlayer(seatid):handout(cardset)
		if handoutResult == false then return DDZGame.NONEHANDCARD end

		self.DDZAllcomboJudment.playersHandcard[seatid] = self:getPlayer(seatid).handcard
		self.curCard.handoutPlayer = seatid
		self.curCard.cardset = cardset
		self.curOperatePlayer = self:getNextOperatePlayer()
		self.multiple = isBombOrRocket(cardset) and (self.multiple * 2) or self.multiple
		if handoutResult == 0 then
			if self:isAllcombo(seatid) then
				self.multiple = self.multiple * 2
			end
			self:clear()
			return DDZGame.WIN
		end
		if handoutResult == true then
			self:getPlayer(seatid):setHandoutCard(cardset)
			return DDZGame.SUCCESS
		end
	end

	if not(cardset > self.curCard.cardset) then
		return DDZGame.NOTBIGERTHANCUR
	end

	local handoutResult = self:getPlayer(seatid):handout(cardset)
	if handoutResult == false then return DDZGame.NONEHANDCARD end
	self.DDZAllcomboJudment.playersHandcard[seatid] = self:getPlayer(seatid).handcard
	self.curOperatePlayer = self:getNextOperatePlayer()
	self.curCard.handoutPlayer = seatid
	self.curCard.cardset = cardset
	self.multiple = isBombOrRocket(cardset) and (self.multiple * 2) or self.multiple
	if handoutResult == 0 then
		if self:isAllcombo(seatid) then
			self.multiple = self.multiple * 2
		end
		self:clear()
		return DDZGame.WIN
	end
	if handoutResult == true then
		self:getPlayer(seatid):setHandoutCard(cardset)
		return DDZGame.SUCCESS
	end
end

function DDZGame:getCurcard(  )
	if self.curCard == nil then
		return {}
	end
	if self.curCard.cardset ~= nil then
		self.curCard.cardset:clearRepeatetable()
	end
	if self.curCard.handoutPlayer == self.curOperatePlayer then
		return {}
	end
	return self.curCard.cardset
end

function DDZGame:sendLeastCartToLandlord(  )
	self.players[self.landlord].handcard = self.players[self.landlord].handcard + self.cardleast
	self.DDZAllcomboJudment.playersHandcard[self.landlord] = self.players[self.landlord].handcard
end

function DDZGame:handoutAuto(  )
	if self.curCard == nil then
		return
	end
	if self.curCard.handoutPlayer == nil or self.curCard.handoutPlayer == self.curOperatePlayer then
		local autoHandoutCard =  self:getHandoutPlayer().handcard[1]
		return self:handout(self.curOperatePlayer, {autoHandoutCard}), {autoHandoutCard}
	else
		return self:handout(self.curOperatePlayer) -- PASS
	end
end

function DDZGame:clear(  )
	self.curCard = nil
	self.baseSocre = nil
	self.players[1]:reset()
	self.players[2]:reset()
	self.players[3]:reset()
	self.state = DDZGame.WAITFORPLAYER
	self:clearCallMaker()
end

function DDZGame:ready( seatid )
	if seatid == nil then return end
	self.players[seatid].state = Player.READY
	for i,v in ipairs(self.players) do
		if self.players[i].state == Player.UNREADY then
			return false
		end
	end

	return true
end

function DDZGame:leave( seatid )
	if self.state == INGAME then
		self.players[seatid].state = Player.TUOGUAN
	else
		self.players[seatid].state = Player.UNREADY
	end
end

function DDZGame:reconnect( seatid )
	--self.players[seatid] = Player:new()
end

function DDZGame:getHandoutPlayer(  )
	return self.players[self.curOperatePlayer]
end


function getClass( ... )
	return Card, CardArray, DDZCardArray,DDZGame,DDZAllcomboJudment
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

function CardArrayCollection:new( v )
	local obj = {}
	setmetatable(obj, CardArrayCollection)
	return obj
end

function CardTypeFinderDispatch.single( handcard )
	if #handcard == 0 then return{} end

	local res = CardArrayCollection:new()
	local prev = handcard[1]
	append(res, DDZCardArray:new({prev}))
	for k,v in pairs(handcard) do
		if prev.num ~= v.num then
			local ressingle = DDZCardArray:new({v})
			append(res, ressingle)
			prev = v
		end
	end

	return res
end

function CardTypeFinderDispatch.double(  handcard )
	if #handcard < 2 then return{} end

	local res = CardArrayCollection:new()
	local resdouble = DDZCardArray:new()
	local doublecollection = handcard:getRepeatetable()[2]
	if doublecollection == nil then
		doublecollection = {}
	end

	for k,v in ipairs(doublecollection) do
		append(resdouble, v)
		if k % 2 == 0 then
			append(res, resdouble)
			resdouble = DDZCardArray:new()
		end
	end

	local triblecollection = handcard:getRepeatetable()[3]
	if triblecollection == nil then
		return res
	end

	local restrible = DDZCardArray:new()
	for k,v in ipairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			restrible[3] = nil
			append(res, restrible)
			restrible = DDZCardArray:new()
		end
	end

	local forblecollection = handcard:getRepeatetable()[4]
	if forblecollection == nil then
		return res
	end

	local forble = DDZCardArray:new()
	for i,v in ipairs(forblecollection) do
		append(forble, v)
		if i % 4 == 0 then
			append(res, forble:sub(1,3))
			append(res, forble:sub(3, 5))
			forble = DDZCardArray:new()
		end
	end

	return res
end

function CardTypeFinderDispatch.trible( handcard )
	local res = CardArrayCollection:new()
	local triblecollection = handcard:getRepeatetable()[3]
	if triblecollection == nil then
		triblecollection = {}
	end
	local restrible = DDZCardArray:new()
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			append(res, restrible)
			restrible = DDZCardArray:new()
		end
	end

	return res
end
--4炸
function CardTypeFinderDispatch.bomb( handcard )
	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
	local bombcollection = handcard:getRepeatetable()[4]
	if CardType_Num ==1  then
		if bombcollection == nil then
			return res
			-- return res + CardTypeFinderDispatch.rocket(curcard, handcard)
		end
	end
	
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 4 == 0 then
			append(res, resbomb)
			resbomb = DDZCardArray:new()
		end
	end
	return res
end
--5炸
function CardTypeFinderDispatch.bomb_5( handcard )
	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
	local bombcollection = handcard:getRepeatetable()[5]
	if bombcollection == nil then
		-- return res + CardTypeFinderDispatch.rocket_3(curcard, handcard)
		return res
	end
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 5 == 0 then
			append(res, resbomb)
			resbomb = DDZCardArray:new()
		end
	end
	return res
end
--6炸
function CardTypeFinderDispatch.bomb_6( handcard )
	print("bomb_6")
	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
	local bombcollection = handcard:getRepeatetable()[6]
	print("bombcollection",bombcollection)
	if bombcollection == nil then
		return res
		-- return res + CardTypeFinderDispatch.rocket_3(curcard, handcard)
	end
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 6 == 0 then
			append(res, resbomb)
			resbomb = DDZCardArray:new()
		end
	end
	return res
end
--7炸
function CardTypeFinderDispatch.bomb_7( handcard )
	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
	local bombcollection = handcard:getRepeatetable()[7]
	if bombcollection == nil then
		return res
		-- return res + CardTypeFinderDispatch.rocket_3(curcard, handcard)
	end
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 7 == 0 then
			append(res, resbomb)
			resbomb = DDZCardArray:new()
		end
	end
	return res
end
--8炸
function CardTypeFinderDispatch.bomb_8( handcard )
	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
	local bombcollection = handcard:getRepeatetable()[8]
	if bombcollection == nil then
		return res
		-- return res + CardTypeFinderDispatch.rocket_3(curcard, handcard)
	end
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 8 == 0 then
			append(res, resbomb)
			resbomb = DDZCardArray:new()
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

function CardTypeFinderDispatch.sequence( handcard, cardsLen )
	local res = CardArrayCollection:new()

	local sequence = DDZCardArray:new()
	local prev = handcard[1]
	append(sequence, handcard[1])
	local A = Card:new(1,1)
	for k,v in ipairs(handcard) do
		if v > A then
			break
		elseif v - prev == 1 then
			append(sequence, v)
			prev = v
		elseif v - prev > 1 then
			if #sequence >= 5 then
				append(res, sequence)
			end
			sequence = DDZCardArray:new()
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

function CardTypeFinderDispatch.doublesequence( handcard, cardsLen )
	local res = CardArrayCollection:new()

	local alldoubleelement = handcard:getAtleastNsameSequences(2)
	if alldoubleelement == nil or #alldoubleelement == 0 then return{} end
	table.sort(alldoubleelement)

	local repeatetime = 1
	local prev = alldoubleelement[1]
	local doublesequence = DDZCardArray:new()
	doublesequence:add(prev)
	local i = 2
	while i <= #alldoubleelement do
		local v = alldoubleelement[i]
		if v.num == prev.num then
			repeatetime = repeatetime + 1
			if repeatetime <= 2 then
				doublesequence:add(v)
			end
		else
			if v - prev > 1 then
				if #doublesequence >= 6 then  append(res, doublesequence) end
				doublesequence = DDZCardArray:new()
			end
			repeatetime = 1
			prev = v
			doublesequence:add(v)
		end
		i = i + 1
	end

	if #doublesequence >= 6 then
		append(res, doublesequence)
	end

	if cardsLen == nil then
		return res
	end

	local resAfterFilter = CardArrayCollection:new()
	prev = alldoubleelement[1]
	for k,v in pairs(res) do
		resAfterFilter = resAfterFilter + sequenceFilteByLen(v, cardsLen, 2)
	end

	return resAfterFilter
end

function CardTypeFinderDispatch.planeInSingle( handcard, cardsLen )
	local planeSize = cardsLen/4
	local wingSize = planeSize
	local tribleSequenceInPlaneSize = planeSize * 3
	local triblesequences = CardTypeFinderDispatch.triblesequence(handcard, tribleSequenceInPlaneSize)
	local res = CardArrayCollection:new()
	for i,triblesequence in ipairs(triblesequences) do
		local planeInSingle = DDZCardArray:new()
		local wingInSingle = handcard - triblesequence
		if #wingInSingle >= wingSize then
			planeInSingle = triblesequence + wingInSingle:sub(1,1 + wingSize)
			append(res, planeInSingle)
		end
	end
	return res

end

function CardTypeFinderDispatch.planeInDouble( handcard, cardsLen )
	local triblesequences = CardTypeFinderDispatch.triblesequence(handcard, cardsLen/5*3)
	local res = CardArrayCollection:new()
	for i,triblesequence in ipairs(triblesequences) do
		local planeInDouble = DDZCardArray:new()
		local double = CardTypeFinderDispatch.double(handcard - triblesequence)
		if #double >= 2 then
			planeInDouble = triblesequence + double[1] + double[2]
			append(res, planeInDouble)
		end
	end
	return res
end

function CardTypeFinderDispatch.triblesequence( handcard, cardsLen )
	local res = CardArrayCollection:new()

	local alldoubleelement = handcard:getAtleastNsameSequences(3)
	if alldoubleelement == nil or #alldoubleelement == 0 then return{} end
	table.sort(alldoubleelement)

	local repeatetime = 1
	local prev = alldoubleelement[1]
	local doublesequence = DDZCardArray:new()
	local i = 1
	while i <= #alldoubleelement do
		local v = alldoubleelement[i]
		if v.num == prev.num then
			if repeatetime <= 3 then
				doublesequence:add(v)
			end
			repeatetime = repeatetime + 1
			i = i + 1
		else
			if v.num - prev.num > 1 then
				if #doublesequence >= 6 then  append(res, doublesequence) end
				doublesequence = DDZCardArray:new()
			end
			repeatetime = 1
			prev = v
		end
	end

	if #doublesequence >= 6 then
		append(res, doublesequence)
	end

	if cardsLen == nil then
		return res
	end

	local resAfterFilter = CardArrayCollection:new()
	prev = alldoubleelement[1]
	for k,v in pairs(res) do
		resAfterFilter = resAfterFilter + sequenceFilteByLen(v, cardsLen, 3)
	end

	return resAfterFilter
end

function CardTypeFinderDispatch.tribleandsingle( handcard )
	local res = CardArrayCollection:new()
	local triblecollection = handcard:getRepeatetable()[3]
	if triblecollection == nil or #triblecollection == 0 then
		return{}
	end

	local restrible = DDZCardArray:new()
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			for dk,dv in pairs(handcard) do
				if dv.num ~= v.num then
 					append(restrible, dv)
 					break
				end
			end
			append(res, restrible)
			restrible = DDZCardArray:new()
		end
	end

	return res
end

function CardTypeFinderDispatch.tribleanddouble( handcard )
	local res = CardArrayCollection:new()
	local triblecollection = handcard:getRepeatetable()[3]
	local doublecollection = handcard:getAtleastNsameSequences(2)
	local doublecollectionOnly = handcard:getRepeatetable()[2]
	if #triblecollection == 0 or #doublecollection == 0 then
		return res
	end

	local restrible = DDZCardArray:new()
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			local times = 0
			local doublecollectionSrc = doublecollectionOnly
			if #doublecollectionOnly == 0 then
				doublecollectionSrc = doublecollection
			end
			for dk,dv in pairs(doublecollectionSrc) do
				if dv.num ~= v.num then
					times = times + 1
 					append(restrible, dv)
				end
				if times == 2 then
					times = 0
					break
				end
			end
			append(res, restrible)
			restrible = DDZCardArray:new()
		end
	end

	return res
end

function CardTypeFinderDispatch.bombandtwodouble( handcard )
	if #handcard < 8 then return {} end

	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
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
			resbomb = DDZCardArray:new()
		end
	end

	return res
end

local ROCKET = {{num = 14, color = 4},{num = 15, color = 4}}
local ROCKET_3 = {{num = 14, color = 4},{num = 14, color = 4},{num = 15, color = 4},{num = 15, color = 4}}
--双王（一副牌）
function CardTypeFinderDispatch.rocket( handcard )
	if getCardType(curcard) == "rocket" then
		return {}
	end
	local res = CardArrayCollection:new()
	if (handcard:find(Card:new(14,4)) and handcard:find(Card:new(15,4))) then
		append(res, DDZCardArray:new(ROCKET))
	end

	return  res
end
--4个王（两副牌）
function CardTypeFinderDispatch.rocket_3( handcard )
	if getCardType(curcard) == "rocket_3" then
		return {}
	end
	local res = CardArrayCollection:new()
	local card_rocket_Num = 0
	for k,v in pairs(handcard) do
		if v.num == 14 or v.num == 15 then
			card_rocket_Num = card_rocket_Num + 1
		end
	end

	if card_rocket_Num == 4 then
		append(res, DDZCardArray:new(ROCKET_3))
	end

	return  res
end

function CardTypeFinderDispatch.bombandtwosingle( handcard  )
	if #handcard < 6 then return {} end

	local res = CardArrayCollection:new()
	local resbomb = DDZCardArray:new()
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
			resbomb = DDZCardArray:new()
		end
	end

	return res
end

function remindForServer( curcard, handcard, sortdeny )
		if curcard == nil or #curcard == 0 then
		--copy
		local tmp = {}
		for k,v in pairs(handcard) do
			append(tmp, v)
		end
		sort(tmp, true)

		local res = {}
		for k,v in pairs(tmp) do
			append(res, {v})
		end
		return res
	end

	local cardtype = getCardType(curcard)
	--initCardarray(handcard)
	table.sort(curcard)
	table.sort(handcard)
	local res = CardTypeFinderDispatch[cardtype](curcard, handcard)
	if type(res) == "table" and sortdeny == nil then
		table.sort( res,function ( a,b )
			return cardCompare(b,a)
		end )
		for k,v in pairs(res) do
			sort(v, true)
		end
	end
	return res
end

local function filterItem( resItem, handcard )
	local cardType = getCardType(resItem)
	handcard = DDZCardArray:new(handcard)

	if cardType == "bomb" or cardType == "bombandsingle" then
		return true
	end

	if cardType ~= "single" and cardType ~= "double" and cardType ~= "trible" then
		return false
	end

	if #resItem == 1 then
		local tmp = handcard:getAtleastNsameSequences(2)
		return tmp:find(resItem[1])
	end

	if #resItem == 2 or #resItem == 3 then
		local tmp = handcard:getRepeatetable()[#resItem]
		return not tmp:find(resItem[1])
	end
	return false
end

local function filterResult( resOriginal, handcard )
	local i = 1
	local iterSize = #resOriginal
	while i <= iterSize do
		resOriginal[i] = DDZCardArray:new(resOriginal[i])
		if filterItem(resOriginal[i], handcard) then
			local tmp = resOriginal[i]
			local k = i
			while k < #resOriginal do
				resOriginal[k] = resOriginal[k + 1]
				k = k + 1
			end
			resOriginal[k] = tmp
			iterSize = iterSize - 1
		else
			i = i + 1
		end
	end

	for i,v in ipairs(resOriginal) do
		resOriginal[i]:clearRepeatetable()
	end

	return resOriginal
end

local function filteCollection( collection, filter )
	local i = 1
	while collection[i] ~= nil do
		if filter(collection[i]) then
			collection[i], collection[#collection] = collection[#collection],collection[i]
			collection[#collection] = nil
		else
			i = i + 1
		end
	end
end


local function sort( handcard, o )
	local f = function ( a,b )
		if a < b then
			return true
		elseif a.num == b.num then
			return a.color < b.color
		else
			return false
		end
	end

	local reserveF = function ( a,b )
		if a < b then
			return false
		elseif a.num == b.num then
			return a.color > b.color
		else
			return true
		end
	end

	handcard = DDZCardArray:new(handcard)
	if o then
		table.sort( handcard , f)
	else
		table.sort( handcard, reserveF )
	end
	return handcard
end

local function RemindAgent( curcard, handcard, sortdeny )
	print("RemindAgent1")
	if curcard == nil or #curcard == 0 then
		--copy
		local tmp = {}
		for k,v in pairs(handcard) do
			append(tmp, v)
		end
		tmp = sort(tmp, true)

		local res = {}
		for k,v in pairs(tmp) do
			append(res, {v})
		end
		print("RemindAgent2")
		return res
	end

	local cardtype = getCardType(curcard)
	if CardType_Num == 1 then
		if cardtype == "errorcardtype" or cardtype == "rocket" then
			return {}
		end
	elseif CardType_Num == 2 then
		if cardtype == "errorcardtype" or cardtype == "rocket_3" then
			return {}
		end
	end
	print("RemindAgent3")
	table.sort(curcard)
	table.sort(handcard)
	local res = CardTypeFinderDispatch[cardtype](handcard, #curcard)
	local prev = nil
	filteCollection(res, function ( v )
		return not (DDZCardArray:new(v) > curcard)
	end)
	filteCollection(res, function ( v )
		if not (prev == v) then
			prev = v
			return false
		else
			return true
		end
	end)
	print("RemindAgent4")
	if CardType_Num == 1  then
		if cardtype ~= "bomb" then
			res = res + CardTypeFinderDispatch.bomb(handcard)
		end
		res = res + CardTypeFinderDispatch.rocket(handcard)
	elseif CardType_Num == 2 then
		print("RemindAgent5",cardtype)
		local cardType_tab = {
		"bomb_8",
		"bomb_7",
		"bomb_6",
		"bomb_5",
		"bomb",
		}
		for k,v in pairs(cardType_tab) do
			if cardtype ~= v then
				if k==1 then
					res = res + CardTypeFinderDispatch.bomb_8(handcard)
				elseif k==2 then
					res = res + CardTypeFinderDispatch.bomb_7(handcard)
				elseif k==3 then
					res = res + CardTypeFinderDispatch.bomb_6(handcard)
				elseif k==4 then
					res = res + CardTypeFinderDispatch.bomb_5(handcard)
				elseif k==5 then
					res = res + CardTypeFinderDispatch.bomb(handcard)
				end
			else
				break
			end
			

		end
		
		print("RemindAgent6",cardtype)
		res = res + CardTypeFinderDispatch.rocket_3(handcard)
	end
	if type(res) == "table" and sortdeny == nil then
		table.sort( res,function ( a,b )
			return DDZCompare(b,a)
		end )
		for k,v in pairs(res) do
			sort(v, true)
		end
	end
	return res
end

local function Remind( curcard, handcard, sortdeny )
	handcard = DDZCardArray:new(handcard)
	if (curcard == nil or #curcard == 0) and DDZ_canAllhandout(handcard) then
		return {handcard}
	end


	handcard = DDZCardArray:new(handcard)
	curcard = DDZCardArray:new(curcard)
	print("Remind1")
	local res = RemindAgent(curcard, handcard, sortdeny)
	if curcard == nil or #curcard == 0 then
		return res
	end
	return filterResult(res, handcard)
end


local function findSequence( curcard, handcard )
	if handcard == nil then
		return {}
	end

	if #handcard < 4 then
		return {}
	end

	handcard = DDZCardArray:new(handcard)
	curcard = DDZCardArray:new(curcard)
	local handCardType = getCardType(handcard)
	if curcard == nil or #curcard == 0 and handCardType ~= "errorcardtype" then
		handcard:clearRepeatetable()
		return handcard
	end

	local curCardType = getCardType(curcard)
	--local bsequences = (curCardType == "sequences") or (curCardType == "doublesequences") or (curCardType == "triblesequences")
	if curcard ~= nil and #curcard ~= 0 then
		if DDZCompare(handcard, curcard) then
			handcard:clearRepeatetable()
			return handcard ,curCardType
		end
		return Remind(curcard, handcard)[1], curCardType
	end

	-- if (curcard ~= nil and #curcard ~= 0) and not bsequences then
	-- 	return {}
	-- end

	--find sequence
	local res = CardTypeFinderDispatch.sequence(handcard)
	if #res > 0 then return res[1] end


	--find triblesequence
	res = CardTypeFinderDispatch.triblesequence(handcard)
	if #res > 0 then return res[1] end

	--find doublesequence
	res = CardTypeFinderDispatch.doublesequence(handcard)
	if #res > 0 then return res[1] end

	return {}
end

function DDZ_canAllhandout( handcard )
	return getCardType(handcard) ~= "errorcardtype"
end

function getLgDDZClass(  )
	return Player, CardArray,Card
end

function DDZ_GetCardType( cardset )
	return getCardType(DDZCardArray:new(cardset))
end

function DDZ_cardCompare( a,b )
	a = DDZCardArray:new(a)
	b = DDZCardArray:new(b)
	return b < a
end
--传入需要管的牌和当前的手牌
--输出当前可以管的牌
--提示按钮的回调
function DDZ_remind( curcard, handcard )
	return Remind(curcard, handcard)
end
--智能提取
function DDZ_findSequence( curcard, handcard )
	return findSequence(curcard, handcard)
end

function DDZ_sort( handcard, sortdeny )
	return sort(handcard, sortdeny)
end


function getTestItem( itemName  )
	local testItem = {}
	testItem["isDoubleSequences"] = isDoubleSequences
	testItem["isPlane"] = isPlane
	testItem["isBomb"] = isBomb
	testItem["Remind"] = Remind
	testItem["getCardType"] = getCardType
	testItem["planeCompare"] = planeCompare
	testItem["cardCompare"] = cardCompare
	testItem["filterResult"] = filterResult
	return testItem[itemName]
end

return DDZGame


