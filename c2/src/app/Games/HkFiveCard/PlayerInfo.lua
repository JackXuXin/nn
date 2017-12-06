local PlayerInfo = {}


-- index of card type (also for frames)
local CT_GIVE_UP 		= -1	-- 弃牌
local CT_ERROR   		= 0		-- 错误(无牌型)
local CT_HIGH_CARD		= 1		-- 散牌
local CT_ONE_PAIR		= 2		-- 对子
local CT_TWO_PAIRS 		= 3		-- 两对
local CT_THREE_OF_A_KING = 4	-- 三张
local CT_STRAIGHT 		= 5		-- 顺子
local CT_FLUSH			= 6		-- 同花
local CT_FULL_HOUSE 		= 7		-- 葫芦
local CT_FOUR_OF_A_KING 	= 8		-- 铁支
local CT_STRAIGHT_FLUSH 	= 9		-- 同花顺


function PlayerInfo:new(name, gold, viptype, sex, imageid)
	local player = {}

	function player:reset()
		self.ingame = false
		self.ready = false
		self.giveup = false
		self.showhand = false
		self.cards = {}
		self.private_card = nil
		card_type = app.lang.card_types[CT_ERROR]
		self.score = 0
		self.prechip = 0
		self.curchip = 0
		self.sex = 0
	end

	function player:total_chip()
		return self.prechip + self.curchip
	end

	function player:left_gold()
		return self.gold - self:total_chip()
	end

	function player:setScore(val, taxRate)
		self.score = val
		printf("val")
		if taxRate and val > 0 then
			val = val - math.floor(val*taxRate)
		end
		self.gold = self.gold + val
	end

	-- do not calculate in client, synchronize from server
	function player:setGold(val)
		self.gold = val
	end

	function player:raiseTo(val)
		self.curchip = val
	end

	function player:newRound() -- after sent card
		self.prechip = self.prechip + self.curchip
		self.curchip = 0
	end

	player:reset()
	player.name = name
	player.gold = gold
	player.sex = sex

--modify by whb 161031
	player.viptype = viptype
--modigy end

--modify by whb 170616
	player.imageid = imageid
--modigy end
	
	return player
end

return PlayerInfo

