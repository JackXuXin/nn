local logic = {}

local cardres = {
	10,11,12,13,
	20,21,22,23,
	30,31,32,33,
	40,41,42,43,
	50,51,52,53,
	60,61,62,63,
	70,71,72,73,
	80,81,82,83,
	90,91,92,93,
	100,101,102,103,
	110,111,112,113,
	120,121,122,123,
	130,131,132,133,
	140,141,
}

local ct_none = 0
local ct_bull_1 = 1
local ct_bull_2 = 2
local ct_bull_3 = 3
local ct_bull_4 = 4
local ct_bull_5 = 5
local ct_bull_6 = 6
local ct_bull_7 = 7
local ct_bull_8 = 8
local ct_bull_9 = 9
local ct_bull_bull = 10
local ct_bomb = 11
local ct_flower5 = 12
local ct_less_ten = 13

local MAX_MULTI = 5


function logicValue(card)
	assert(type(card) ~= 'table')
	return math.floor(card / 10)
end

function getHumanVisible(card)
	local v = logicValue(card)
	local color
	if card % 10 == 0 then
		color = '♦'  
	elseif card % 10 == 1 then
		color = '♣'
	elseif card % 10 == 2 then
		color = '♥'
	elseif card % 10 == 3 then
		color = '♠'
	end
   
	local str = ''
	if v == 1 then
		str = 'A'..color
	elseif v < 10 then
		str = string.format('%s%s', tostring(v), color)
	elseif v == 10 then
		str = 'T'..color
	elseif v == 11 then
		str = 'J'..color
	elseif v == 12 then
		str = 'Q'..color
	elseif v == 13 then
		str = 'K'..color
	elseif v == 14 then
		str = '$'..color
	end

	return str
end

function logic.digitalCards(cards)
	if not cards then return "" end
	local buff = ''
	for i = 1, #cards do
		if i > 1 then
			buff = buff..','
		end
		buff = string.format("%s%s", buff, tostring(cards[i]))
	end
	return buff
end

function logic.visualCards(cards)
	if not cards then return "" end
	local buff = ''
	for i = 1, #cards do
		buff = buff..getHumanVisible(cards[i])..' '
	end
	return buff
end


local function get_card_value( card )
	local value =  math.floor(card / 10)
	if value > 10 then value = 10 end
	return value
end

local function find_niu(cards, testcards, pos, value)
	pos = pos or 1
	value = value or 0
	if #testcards > 3 then 
		return false
	elseif value % 10 == 0 and #testcards == 3 then
		return true
	end

	for i=pos,#cards do
		table.insert(testcards, cards[i])
		if find_niu(cards, testcards, i+1, value+get_card_value(cards[i])) then
			return true
		end
	 	table.remove(testcards, #testcards)
	end
	return false
end

local function sort_niu_cards(cards, result_cards)
	local index
	for i,v in ipairs(result_cards) do
		index = table.indexof(cards, v)
		if i ~= index then
			cards[i] = cards[i] + cards[index]
			cards[index] = cards[i] - cards[index]
			cards[i] = cards[i] - cards[index]
		end
	end
end

local function get_cardtype(cards, manually)
	if cards == nil or #cards < 4 then
		LOG_ERROR("100nn get_cardtype fail!!!!!!")
		return
	end

	local len = #cards
	if manually then
		local max_card = cards[1]
		for i = 2, len do
			if max_card < cards[i] then
				max_card = cards[i]
			end
		end

		--五小牛
		local sum = 0
		for i = 1, len do
			sum = sum + get_card_value(cards[i])
		end
		if sum <= 10 then
			local find = false
			for k, v in pairs(cards) do
				if v > 53 then
					find = true 
					break
				end
			end
			if not find then
				return {ct = ct_less_ten, card = max_card, multi = MAX_MULTI}
			end
		end

		--炸弹
		local num_set = {}
		for i = 1, 5 do 
			local num = math.floor(cards[i]/10)
			local cnt = num_set[num] or 0
			num_set[num] = cnt + 1
		end
		for k, v in pairs(num_set) do
			if v == 4 then
				return {ct = ct_bomb, card = k, multi = MAX_MULTI}
			end
		end

		sum = 0
		for i = 1, 3 do
			sum = sum + get_card_value(cards[i])
		end
		--无牛
		if sum % 10 ~= 0 then
			return {ct = ct_none, card = max_card, multi = 1}
		end

		sum = 0
		for i = 4, len do
			sum = sum + get_card_value(cards[i])
		end
		--牛1 - 牛9
		sum = sum % 10
		if sum ~= 0 then
			local m = 1
			if sum >= 7 then
				m = sum - 5
			end
			return {ct = sum, card = max_card, multi = m}
		end

		--五花牛 四花牛 牛牛
		local cnt = 0
		sum = 0
		for i,v in ipairs(cards) do
			if v >= 110 then
				cnt = cnt + 1
			end
			if v >= 100 and v <= 103 then
				sum = 1
			end 
		end
		if cnt >= 5 then
			return {ct = ct_flower5, card = max_card, multi = MAX_MULTI}
		else
			return {ct = ct_bull_bull, card = max_card, multi = MAX_MULTI}
		end
	else
		local result_cards = {}
		if find_niu(cards, result_cards) then
			sort_niu_cards(cards, result_cards)
		end

		return get_cardtype(cards, true)
	end
end

local function cmp_cardtype(c1, c2)
    if c1.ct ~= c2.ct then
		return c1.ct - c2.ct
    end
    return c1.card - c2.card
end

local function shuffle(sindex)
	local sindex = sindex or 1
	local cnt = #cardres
	for i = sindex, cnt do
		local k = math.random(i, cnt)
		if k ~= i then
			cardres[i], cardres[k] = cardres[k], cardres[i]
		end
	end
end

local function new_cards()
    shuffle()
	local ret = table.arraycopy(cardres, 1, 25)
		
	if DEV_TEST then
		ret = {
			140,141,120,121,110,
			80,81,82,83,90,
			70,61,52,63,90,
			20,41,102,113,30,
			90,91,92,93,110,
		}
	end
	
	return ret
end

-- export functions
logic.get_cardtype = get_cardtype
logic.cmp_cardtype = cmp_cardtype
logic.find_niu = find_niu
logic.new_cards = new_cards
logic.MAX_MULTI = MAX_MULTI

return logic
