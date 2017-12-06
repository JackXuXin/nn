function isSubCardarray( subset, set )
	if #subset > #set then return false end
	for k,v in pairs(subset) do
		if findCard(v, set) == nil then return false end
	end

	return true
end

function getCardarrayOps(  )
	cardarrayOps = {}
	cardarrayOps.__add = function ( a,b )
		local res = {}
	    for k,v in ipairs(a) do
			res[#res == 0 and 1 or #res + 1] = v
		end
	    for k,v in ipairs(b) do
			res[#res == 0 and 1 or #res + 1] = v
		end
		setmetatable(res, cardarrayOps)
	    return res
	end

	cardarrayOps.__sub = function ( a,b )
		if isSubCardarray(b, a) == false then
			error("argument#2 larger than argument1")
		end
		local res = {}
		setmetatable(res, cardarrayOps)
		for k,v in pairs(a) do
			local ak = findCard(v, b)
			if ak == nil then
				append(res, v)
			end
		end
		return res
	end

	cardarrayOps.__eq = function ( a,b )
		for k,v in pairs(a) do
			if v ~= b[k] then
				return false
			end
		end
		return true
	end

	cardarrayOps.__lt = function ( a,b )
		return cardCompare(b, a)
	end
	return cardarrayOps
end

function newCardarray( a )
	local res = {}
	if a ~= nil then
		res = a
	end
	setmetatable(res, getCardarrayOps())
	return res
end

function findCard( card, cardset, f )
	if f == nil then
		f = function ( a,b )
			return a.num == b.num and a.color == b.color
		end
	end

	for k,v in pairs(cardset) do
		if f(v, card) then return k end
	end

	return nil
end

function cardset_print( cardset )
	if cardset == nil then print("cardset is nil") return end
	local str = ""
	for k,v in pairs(cardset) do
		str = str.."{num = "..v.num.." color = "..v.color.."} "
	end
	print(str)
end

function append(t, v)
	if t == nil then
		t = {}
	end
	t[#t == 0 and 1 or #t + 1] = v
	return t
end

function cardarrayFilter( a, f )
	local res = {}
	for k,v in pairs(a) do
		if f(v) then append(res, v) end
	end
	return res
end

function getRepeatetable( cardset )
	initCardarray(cardset)
	table.sort( cardset )

	cardset = newCardarray(cardset)
	local repeatetable = {}
	local prev = 0
	local repeattime = 1
	local res = {}

	for k,v in pairs(cardset) do
		if v.num == prev then
			repeattime = repeattime + 1
		else
			if repeattime > 1 then
				if repeatetable[repeattime] == nil then
					repeatetable[repeattime] = newCardarray()
				end
				repeatetable[repeattime] = repeatetable[repeattime] + cardarrayFilter(cardset, function ( v1 )
					return v1.num == prev
				end)
			end
			repeattime = 1
			prev = v.num
		end
	end

	if repeattime > 1 then
		if repeatetable[repeattime] == nil then
			repeatetable[repeattime] = newCardarray()
		end
		repeatetable[repeattime] = repeatetable[repeattime] + cardarrayFilter(cardset, function ( v1 )
						return v1.num == prev
					end)
	end

	return repeatetable

end

function nsamesequence( cardset, n )
	local repeatetable = getRepeatetable(cardset)
	local res = {}

	for k,v in pairs(repeatetable) do
		if k >= n then
			for i=1,n do
				append(res, v[i])
			end
		end
	end
	return res
end

function onlyhasn( cardset, n )
	local res = getRepeatetable(cardset)
	if res[n] == nil then return false end
	return #res[n] == #cardset
end

function _nsame( cardset, n )
	local repeatetable = getRepeatetable(cardset)
	local res = {}
	local ops = {}
	ops.__add = function ( a, b )
		local res = {}
	    for k,v in ipairs(a) do
			res[#res == 0 and 1 or #res + 1] = v
		end
	    for k,v in ipairs(b) do
			res[#res == 0 and 1 or #res + 1] = v
		end
	    return res
	end
	setmetatable(res, ops)

	for k,v in pairs(repeatetable) do
		if k >= n then
			setmetatable(v, ops)
			res = v + res
		end
	end
	return res
end

function _nsameonly( cardset, n )
	local repeatetable = getRepeatetable(cardset)
	if nil == repeatetable[n] then return {}
	else return repeatetable[n] end
end

function _hasnsame( cardset, n )
	local repeatetable = getRepeatetable(cardset)
	if repeatetable[n] == nil then
		return false
	else
		return true
	end
end


--ç‰Œåž‹å®šä¹‰
--[[
single å•ç‰Œ
double å¯¹å­
trible ä¸‰å¯¹
captive ä¿˜è™
sequences é¡ºå­
doublesequences åŒè¿žé¡º
triblesequences ä¸‰è¿žé¡º
bomb ç‚¸å¼¹
bombandsingle ç‚¸å¼¹å¸¦ä¸€
--]]
--require(")
cardops = {}
cardops.__eq = function ( a,b )
	return a.num == b.num
end
local cardCompareTable = {12,13,1,2,3,4,5,6,7,8,9,10,11}
cardops.__lt = function ( a,b )
	if a.num < 1 or a.num > 13 then
		error("argument1 error = "..tostring(a.num))
	end
	if b.num < 1 and b.num >13 then
		error("argument2 error = "..tostring(b.num))
	end
	return cardCompareTable[a.num] < cardCompareTable[b.num]
end
cardops.__sub = function ( a,b )
	if a.num < 1 or a.num > 13 then
		error("argument1 error = "..tostring(a.num))
	end
	if b.num < 1 and b.num >13 then
		error("argument2 error = "..tostring(b.num))
	end
	return cardCompareTable[a.num] - cardCompareTable[b.num]
end

function initCardarray( cardset )
	for _,v in pairs(cardset) do
		setmetatable(v, cardops)
	end
end

local function isSingle( cardset )
	local res = #cardset
	return res == 1
end

local function isDouble( cardset )
	local res = #cardset
	if res ~= 2 then return false end
	return cardset[1] == cardset[2]
end

local function istrible( cardset )
	if # cardset  ~= 3 then return false end
	return _hasnsame(cardset, 3)
end

local function iscaptive( cardset )
	if #cardset ~= 5 then return false end
	if false == _hasnsame(cardset, 3) then return false end
	if false == _hasnsame(cardset, 2) then return false end
	return true
end

local function isDoubleSequences( cardset )
	if findCard({num = 2,color = 0}, cardset) ~=nil then return false end
	if onlyhasn(cardset, 2) == false then return false end
	if #cardset < 4 then return false end
	local prev
	for k,v in pairs(cardset) do
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

local function isTribleSequences( cardset )
	if findCard({num = 2,color = 0}, cardset) ~=nil then return false end
	if onlyhasn(cardset, 3) == false then return false end
	if #cardset < 6 then return false end
	local prev
	for k,v in pairs(cardset) do
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

local function isPlane(cardset)
	if #cardset < 10 then return false end
	local triblesequence = _nsameonly(cardset, 3)
	local doublesequence = _nsameonly(cardset, 2)
	if #cardset ~= #triblesequence + #doublesequence then
		return false
	end

	return isTribleSequences(triblesequence) and isDoubleSequences(doublesequence)
end

local function isSequences( cardset )

	for k,v in pairs(cardset) do
		if v.num == 2 then
			return false
		end
	end
	if #cardset < 5 then return false end
	if _hasnsame(cardset, 2) then return false end
	if _hasnsame(cardset, 3) then return false end
	if _hasnsame(cardset, 4) then return false end

	local prev
	for k,v in pairs(cardset) do
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

local function isBomb( cardset )
	if #cardset ~= 4 and #cardset ~= 5 then return false end
	return _hasnsame(cardset, 4)
end

--ç‰Œå€¼åˆ¤æ–­å‡½æ•°å®šä¹‰
local function getCardType( cardset )
	if cardset == nil then return "errorcardtype" end

	initCardarray(cardset)
	if isSingle(cardset) then return "single" end
	if isDouble(cardset) then return "double" end
	if istrible(cardset) then return "trible" end
	if iscaptive(cardset) then return "captive" end
	if isDoubleSequences(cardset) then return "doublesequences" end
	if isTribleSequences(cardset) then return "triblesequences" end
	if isBomb(cardset) then return "bomb" end
	if isSequences(cardset) then return "sequences" end
	if isPlane(cardset) then return "plane" end
	return "errorcardtype"
end

local function singleCompare( a,b )
	return b[1] < a[1]
end

local function doubleCompare( a,b )
	return b[1] < a[1]
end

local function tribleCompare( a,b )
	return b[1] < a[1]
end

local function bombCompare( a,b )
	local a_ = _nsame(a, 4)
	local b_ = _nsame(b, 4)
	return b_[1] < a_[1]
end

local function sequencesCompare( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

local function doublesequencesCompare( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

local function triblesequencesCompare( a,b )
	if #a ~= #b then return false end
	return b[1] < a[1]
end

local function captiveCompare( a,b )
	local a_ = _nsame(a, 3)
	local b_ = _nsame(b, 3)
	return b_[1] < a_[1]
end

local function planeCompare(a, b)
	if #a ~= #b then
		return false
	end

	local a_ = _nsameonly(a, 3)
	local b_ = _nsameonly(b, 3)

	return b_[1] < a_[1]
end

--cardtype_test()
--ç‰Œå€¼æ¯”è¾ƒå‡½æ•°åˆ—è¡¨
local cardCompareFuntionTable = {}
cardCompareFuntionTable.single = singleCompare
cardCompareFuntionTable.double = doubleCompare
cardCompareFuntionTable.trible = tribleCompare
cardCompareFuntionTable.bomb = bombCompare
cardCompareFuntionTable.doublesequences = doublesequencesCompare
cardCompareFuntionTable.triblesequences = triblesequencesCompare
cardCompareFuntionTable.sequences = sequencesCompare
cardCompareFuntionTable.captive = captiveCompare
cardCompareFuntionTable.plane = planeCompare


local function cardCompare( a, b )
	if b == nil or #b == 0 then
		return true
	end
	local cardtypea = getCardType(a)
	local cardtypeb = getCardType(b)

	if cardtypea == "errorcardtype" then return false end
	if cardtypeb == "errorcardtype" then return false end

	if cardtypea ~= cardtypeb then
		if cardtypea == "bomb" and cardtypeb == "bombandsingle" then return false end
		if cardtypeb == "bomb" and cardtypea == "bombandsingle" then return false end
		if cardtypea == "bomb" or cardtypea == "bombandsingle" then return true end
		if cardtypeb == "bomb" or cardtypeb == "bombandsingle" then return false end
		return false
	end
	return cardCompareFuntionTable[cardtypea](a, b)
end


local RemindDispatch = {}
function RemindDispatch.single( curcard, handcard )
	if #handcard == 0 then return{} end
	if #curcard ~=1 then
		--print("error curcard beyond length")
	 	return {}
	end

	local tmp = curcard[1]
	local res = {}
	for k,v in pairs(handcard) do
		if v > tmp then
			tmp = v
			local ressingle = {v}
			append(res, ressingle)
		end
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.double( curcard, handcard )
	if #handcard < 2 then return{} end
	if #curcard ~= 2 then return{} end

	local res = {}
	local resdouble = {}
	local doublecollection = _nsameonly(handcard, 2)

	for k,v in pairs(doublecollection) do
		append(resdouble, v)
		if k % 2 == 0 then
			if cardCompare(resdouble, curcard) then append(res, resdouble) end
			resdouble = {}
		end
	end

	local triblecollection = _nsameonly(handcard, 3)
	local restrible = {}
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			restrible[3] = nil
			if cardCompare(restrible, curcard) then append(res, restrible) end
			restrible = {}
		end
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

local function subset( cardset, s, e )
	local res = {}
	for i,v in ipairs(cardset) do
		if i >= s and i < e then
			append(res, v)
		end
	end

	return res
end

local function getNsameSequence( cardset, n )
	local repeatetable = getRepeatetable(cardset)
	local res = {}
	setmetatable(res, getCardarrayOps())

	for k,v in pairs(repeatetable) do
		if k > n then
			local i = 1
			while i <= #v do
				res = res + subset(v, i, i + n)
				i = i + k
			end
		elseif k == n then
			res = res + v
		end
	end
	return res
end

function RemindDispatch.plane( curcard, handcard )
	local tribles = getNsameSequence(handcard, 3)
	local planeSize = #curcard/5
	if #tribles < planeSize*3 then
		return {}
	end

	local res = {}
	local lengthOfPlaneMain = planeSize*3
	local lengthOfPlaneWing = planeSize*2
	local i = 1
	while i <= #tribles - lengthOfPlaneMain + 1 do
		local planeMain = subset(tribles, i, i + lengthOfPlaneMain)
		if isTribleSequences(planeMain) then
			local doubles = getNsameSequence(handcard - planeMain, 2)
			local k = 1
			while k <= #doubles - lengthOfPlaneWing + 1 do
				local planeWing = subset(doubles, k, k + lengthOfPlaneWing)
				if isDoubleSequences(planeWing) then
					local plane = planeMain + planeWing
					if cardCompare(plane, curcard) then
						append(res, plane)
					else
						break
					end
				end
				k = k + 2
			end
		end

		i = i + 3
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.trible( curcard, handcard )
	local res = {}
	local triblecollection = _nsameonly(handcard, 3)
	local restrible = {}
	for k,v in pairs(triblecollection) do
		append(restrible, v)
		if k % 3 == 0 then
			if cardCompare(restrible, curcard) then append(res, restrible) end
			restrible = {}
		end
	end
	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.bomb( curcard, handcard )
	local res = {}
	local resbomb = {}
	local bombcollection = _nsameonly(handcard, 4)
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		if k % 4 == 0 then
			if cardCompare(resbomb, curcard) then
				append(res, resbomb)
			end
			resbomb = {}
		end
	end
	return res
end

function RemindDispatch.sequences( curcard, handcard )
	local res = {}

	local sequenceslen = #curcard
	local sequencescollection = {}
	local startindex = 1
	local prev = handcard[1]
	local tmp = {}
	append(sequencescollection, handcard[1])
	for k,v in pairs(handcard) do
		if v - prev == 1 then
			append(sequencescollection, v)
			prev = v
			startindex = #sequencescollection - sequenceslen
			if startindex >= 0 then
				tmp = {}
				for i=startindex + 1,#sequencescollection do
					append(tmp, sequencescollection[i])
				end
				if cardCompare(tmp, curcard) then
					append(res, tmp)
				end
			end
		end
		if v - prev > 1 then
			sequencescollection = {}
			prev = v
			append(sequencescollection, v)
		end
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.doublesequences( curcard, handcard )
	local res = {}

	local alldoubleelement = _nsame(handcard, 2)
	if #alldoubleelement == 0 then return{} end
	table.sort(alldoubleelement)

	local repeatetime = 0
	local prev = alldoubleelement[1]
	local i = 1
	while i <= #alldoubleelement do
		local v = alldoubleelement[i]
		if v == prev then repeatetime = repeatetime + 1
		else
			repeatetime = 1
			prev = v
		end
		if repeatetime > 2 then
			table.remove(alldoubleelement, i)
			i = i - 1
			repeatetime = 2
		end
		i = i + 1
	end

	local sequenceslen = #curcard
	local sequencescollection = {}
	local startindex = 1
	prev = alldoubleelement[1]
	repeatetime = 0
	for k,v in pairs(alldoubleelement) do
		if v - prev == 1 or v - prev == 0 then
			repeatetime = repeatetime + 1
			if repeatetime >= sequenceslen and repeatetime % 2 == 0 then
				local tmp = {}
				for i = k - sequenceslen + 1, k do
					append(tmp, alldoubleelement[i])
				end
				if cardCompare(tmp, curcard) then
					append(res, tmp)
				end
			end
		end
		if v - prev > 1 then
			repeatetime = 1
		end
		prev = v
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.triblesequences( curcard, handcard )
	local res = {}

	local alldoubleelement = _nsame(handcard, 3)
	if #alldoubleelement == 0 then return{} end
	table.sort(alldoubleelement)

	local repeatetime = 0
	local prev = alldoubleelement[1]
	local i = 1
	while i <= #alldoubleelement do
		local v = alldoubleelement[i]
		if v == prev then repeatetime = repeatetime + 1
		else
			repeatetime = 1
			prev = v
		end
		if repeatetime > 3 then
			table.remove(alldoubleelement, i)
			i = i - 1
			repeatetime = 3
		end
		i = i + 1
	end

	local sequenceslen = #curcard
	local sequencescollection = {}
	local startindex = 1
	prev = alldoubleelement[1]
	repeatetime = 0
	for k,v in pairs(alldoubleelement) do
		if v - prev == 1 or v - prev == 0 then
			repeatetime = repeatetime + 1
			if repeatetime >= sequenceslen and repeatetime % 3 == 0 then
				local tmp = {}
				for i = k - sequenceslen + 1, k do
					append(tmp, alldoubleelement[i])
				end
				if cardCompare(tmp, curcard) then
					append(res, tmp)
				end
			end
		end
		if v - prev > 1 then
			repeatetime = 1
		end
		prev = v
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.captive( curcard, handcard )
	local res = {}
	local triblecollection = _nsameonly(handcard, 3)
	local doublecollection = _nsame(handcard, 2)
	local doublecollectionOnly = _nsameonly(handcard, 2)
	if #triblecollection == 0 or #doublecollection == 0 then
		return RemindDispatch.bomb(curcard, handcard)
	end

	local restrible = {}
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
			if cardCompare(restrible , curcard) then append(res, restrible) end
			restrible = {}
		end
	end

	setmetatable(res, getCardarrayOps())
	res = res + RemindDispatch.bomb(curcard, handcard)

	return res
end

function RemindDispatch.bombandsingle( curcard, handcard  )
	if #handcard < 5 then return {} end

	local res = {}
	local resbomb = {}
	local bombcollection = _nsameonly(handcard, 4)
	for k,v in pairs(bombcollection) do
		append(resbomb, v)
		local tmp = curcard
		if getCardType(curcard) == "bombandsingle" then
			tmp[#tmp] = nil
		end
		if k % 4 == 0 and cardCompare(resbomb, tmp) then
			for sk,sv in pairs(handcard) do
				if sv ~= bombcollection[1] then
					append(resbomb, sv)
					break
				end
			end
			append(res, resbomb)
			resbomb = {}
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
		gp_sort(tmp, true)

		local res = {}
		for k,v in pairs(tmp) do
			append(res, {v})
		end
		return res
	end

	local cardtype = getCardType(curcard)
	initCardarray(handcard)
	table.sort(curcard)
	table.sort(handcard)
	local res = RemindDispatch[cardtype](curcard, handcard)
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

	if cardType == "bomb" or cardType == "bombandsingle" then
		return true
	end

	if cardType ~= "single" and cardType ~= "double" and cardType ~= "trible" then
		return false
	end

	if #resItem == 1 then
		local tmp = _nsame(handcard, 2)
		return findCard(resItem[1], tmp, function ( a,b )
			return a.num == b.num
		end)
	end

	if #resItem == 2 or #resItem == 3 then
		local tmp = _nsameonly(handcard, #resItem)
		return not findCard(resItem[1], tmp, function ( a,b )
			return a.num == b.num
		end)
	end
	return false
end

local function filterResult( resOriginal, handcard )
	local i = 1
	local iterSize = #resOriginal
	while i <= iterSize do
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

	return resOriginal
end

local function RemindAgent( curcard, handcard, sortdeny )
	if curcard == nil or #curcard == 0 then
		--copy
		local tmp = {}
		for k,v in pairs(handcard) do
			append(tmp, v)
		end
		gp_sort(tmp, true)

		local res = {}
		for k,v in pairs(tmp) do
			append(res, {v})
		end
		return res
	end

	local cardtype = getCardType(curcard)
	initCardarray(handcard)
	table.sort(curcard)
	table.sort(handcard)
	local res = RemindDispatch[cardtype](curcard, handcard)
	if type(res) == "table" and sortdeny == nil then
		table.sort( res,function ( a,b )
			return cardCompare(b,a)
		end )
		for k,v in pairs(res) do
			gp_sort(v, true)
		end
	end
	return res
end


function gp_sort( handcard, o )
	initCardarray(handcard)
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

	if o then
		table.sort( handcard , f)
	else
		table.sort( handcard, reserveF )
	end
	return handcard
end

function gp_findSequence( curcard, handcard )
	if handcard == nil then
		return {}
	end

	if #handcard < 4 then
		return {}
	end

	local handCardType = getCardType(handcard)
	if curcard == nil or #curcard == 0 and handCardType ~= "errorcardtype" then
		return handcard
	end

	local curCardType = getCardType(curcard)
	--local bsequences = (curCardType == "sequences") or (curCardType == "doublesequences") or (curCardType == "triblesequences")
	if curcard ~= nil and #curcard ~= 0 then
		return gp_Remind(curcard, handcard)[1], curCardType
	end

	-- if (curcard ~= nil and #curcard ~= 0) and not bsequences then
	-- 	return {}
	-- end

	--find sequence
	local prev = handcard[1]
	local sequence = {}
	append(sequence, prev)
	for k,v in pairs(handcard) do
		if v.num - prev.num == 1 then
			append(sequence, v)
			prev = v
		end
	end

	if #sequence >= 5 then
		return sequence, "sequences"
	end


	--find triblesequence
	local triblesequence = {}
	local alltribleelement = _nsame(handcard, 3)
	gp_sort(alltribleelement, true)
	local i = 1
	local repeatetime = 0
	while i <= #alltribleelement do
		local v = alltribleelement[i]
		if v == prev then repeatetime = repeatetime + 1
		else
			repeatetime = 1
			prev = v
		end
		if repeatetime > 3 then
			table.remove(alltribleelement, i)
			i = i - 1
			repeatetime = 3
		end
		i = i + 1
	end

	local prev = alltribleelement[1]
	for k,v in pairs(alltribleelement) do
		if v.num - prev.num == 1 or v.num - prev.num == 0 then
			append(triblesequence, v)
			prev = v
		end
	end
	if #triblesequence >= 6 then
		return triblesequence, "triblesequences"
	end

	--find doublesequence
	repeatetime = 0
	local alldoubleelement = _nsame(handcard, 2)
	if #alldoubleelement == 0 then return{} end
	gp_sort(alldoubleelement, true)
	local i = 1
	while i <= #alldoubleelement do
		local v = alldoubleelement[i]
		if v == prev then repeatetime = repeatetime + 1
		else
			repeatetime = 1
			prev = v
		end
		if repeatetime > 2 then
			table.remove(alldoubleelement, i)
			i = i - 1
			repeatetime = 2
		end
		i = i + 1
	end
	local doublesequence = {}
	prev = alldoubleelement[1]
	for k,v in pairs(alldoubleelement) do
		if v.num - prev.num == 1 or v.num - prev.num == 0 then
			append(doublesequence, v)
			prev = v
		end
	end

	if #doublesequence >= 4 then
		return doublesequence, "doublesequences"
	end

	return {}
end

function gp_canAllhandout( handcard )
	return getCardType(handcard) ~= "errorcardtype"
end


local function Remind( curcard, handcard, sortdeny )
	local res = RemindAgent(curcard, handcard, sortdeny)
	if curcard == nil or #curcard == 0 then
		return res
	end
	return filterResult(res, handcard)
end

function gp_Remind( curcard, handcard, sortdeny )
	return Remind(curcard, handcard, sortdeny)
end

function gp_getCardtype( cardset )
	return getCardType(cardset)
end

function gp_cardCompare( a,b )
	return cardCompare(a,b)
end

function getItemForGPLogic( itemName )
	local item = {}
	item["getCardType"] = getCardType
	item["cardCompare"] = cardCompare
	return item[itemName]
end

function getTestItem( itemName  )
	local testItem = {}
	testItem["isDoubleSequences"] = isDoubleSequences
	testItem["isPlane"] = isPlane
	testItem["isBomb"] = isBomb
	testItem["getCardType"] = getCardType
	testItem["planeCompare"] = planeCompare
	testItem["cardCompare"] = cardCompare
	testItem["filterResult"] = filterResult
	testItem["Remind"] = Remind
	return testItem[itemName]
end
