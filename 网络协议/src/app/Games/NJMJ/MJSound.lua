local MJSound = {}

local soundState = true

function MJSound.init()
	soundState = true

	if device.platform == "ios" then
		audio.preloadSound("Sound/NJMJ/dealcard.mp3")
		audio.preloadSound("Sound/NJMJ/downtotable.mp3")

		audio.preloadSound("Sound/NJMJ/countdown.mp3")

		audio.preloadSound("Sound/NJMJ/drawgame.mp3")
		audio.preloadSound("Sound/NJMJ/selectcard.mp3")

		audio.preloadSound("Sound/NJMJ/fangpao.mp3")
		audio.preloadSound("Sound/NJMJ/female/45.mp3")
		audio.preloadSound("Sound/NJMJ/male/45.mp3")

		audio.preloadSound("Sound/NJMJ/Dice.mp3")

		audio.preloadSound("Sound/NJMJ/discardcard.mp3")
		audio.preloadSound("Sound/NJMJ/tishi_cpg.mp3")

		audio.preloadSound("Sound/NJMJ/win.mp3")
		audio.preloadSound("Sound/NJMJ/lose.mp3")
	end
	
	
	for i = 1, 4 do
		for j = 1, 9 do
			if i == 4 and j > 4 then
				break
			end
			audio.preloadSound("Sound/NJMJ/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
			audio.preloadSound("Sound/NJMJ/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
		end
	end
end

function MJSound.setState(sound)
	soundState = sound
end

function MJSound.arrangeCard()
	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/dealcard.mp3", false)
end

function MJSound.selectCard()
	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/selectcard.mp3", false)
end

function MJSound.drawCard()
	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/discardcard.mp3", false)
end

-- function MJSound.complementCard(sex, majiang)
-- 	if not soundState then
-- 		return
-- 	end
-- 	if sex > 1 then
-- 		audio.playSound("Sound/NJMJ/male/buhua.mp3", false)
-- 	else
-- 		audio.playSound("Sound/NJMJ/female/buhua.mp3", false)
-- 	end
-- end

function MJSound.outCard(card, dragon, sex, majiang)

	

	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/downtotable.mp3", false)
	local i = math.floor(card/16)
	local j = card % 16
	print("XS mj sound out card:i:" .. i .. ",j:" .. j)
	if sex > 1 then
		-- if card == dragon then
		-- 	audio.playSound("Sound/NJMJ/male/piao.mp3", false)
		-- else
		print("mj sound haha :" .. "Sound/NJMJ/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
			audio.playSound("Sound/NJMJ/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
		-- end
	else
		-- if card == dragon then
		-- 	audio.playSound("Sound/NJMJ/female/piao.mp3", false)
		-- else
			audio.playSound("Sound/NJMJ/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
		-- end
	end
	
end

function MJSound.combinCard(combin, sex, majiang)
	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/tishi_cpg.mp3", false)
	-- if combin == "left" or combin == "center" or combin == "right" then
	-- 	if sex > 1 then
	-- 		audio.playSound("Sound/NJMJ/male/chi.mp3", false)
	-- 	else
	-- 		audio.playSound("Sound/NJMJ/female/chi.mp3", false)
	-- 	end
	if combin == "peng" then
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/peng.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/peng.mp3", false)
		end
	elseif combin == "an_gang" then
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/gang.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/gang.mp3", false)
		end
	elseif combin == "bu_gang" then
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/gang.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/gang.mp3", false)
		end
	elseif combin == "ming_gang" then
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/gang.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/gang.mp3", false)
		end
	elseif combin == "Ting" then   --听牌
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/Ting.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/Ting.mp3", false)
		end
	elseif combin == "buhua" then   --补花
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/buhua.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/buhua.mp3", false)
		end
	elseif combin == "FaKuan" then --罚款
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/hu.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/hu.mp3", false)
		end
	
	elseif combin == "hu" then
		if sex > 1 then
			audio.playSound("Sound/NJMJ/male/hu.mp3", false)
		else
			audio.playSound("Sound/NJMJ/female/hu.mp3", false)
		end
	end
	
end

function MJSound.gameResult(result)
	if not soundState then
		return
	end
	if result == 0 then
		audio.playSound("Sound/NJMJ/drawgame.mp3", false)
	elseif result > 0 then
		audio.playSound("Sound/NJMJ/win.mp3", false)
	elseif result < 0 then
		audio.playSound("Sound/NJMJ/lose.mp3", false)
	end
end

function MJSound.timeTick()
	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/countdown.mp3", false)
end

function MJSound.rotateDice()
	if not soundState then
		return
	end
	audio.playSound("Sound/NJMJ/Dice.mp3", false)
end

return MJSound