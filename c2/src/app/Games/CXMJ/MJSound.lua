local MJSound = {}

local soundState = true

function MJSound.init()
	soundState = true

	if device.platform == "ios" then
		audio.preloadSound("CXMJSound/dealcard.mp3")
		audio.preloadSound("CXMJSound/downtotable.mp3")

		--audio.preloadSound("CXMJSound/female/43_0.mp3")
		--audio.preloadSound("CXMJSound/male/43_0.mp3")

		audio.preloadSound("CXMJSound/countdown.mp3")

		-- audio.preloadSound("CXMJSound/female/35_0.mp3")
		-- audio.preloadSound("CXMJSound/male/35_0.mp3")
		-- audio.preloadSound("ShYSound/female/36_0.mp3")
		-- audio.preloadSound("ShYSound/male/36_0.mp3")
		-- audio.preloadSound("ShYSound/female/37_0.mp3")
		-- audio.preloadSound("ShYSound/male/37_0.mp3")

		audio.preloadSound("CXMJSound/drawgame.mp3")
		audio.preloadSound("CXMJSound/selectcard.mp3")

		audio.preloadSound("CXMJSound/fangpao.mp3")
		audio.preloadSound("CXMJSound/female/45.mp3")
		audio.preloadSound("CXMJSound/male/45.mp3")

		audio.preloadSound("CXMJSound/Dice.mp3")

		-- audio.preloadSound("CXMJSound/female/44_0.mp3")
		-- audio.preloadSound("CXMJSound/male/44_0.mp3")

		audio.preloadSound("CXMJSound/discardcard.mp3")
		audio.preloadSound("CXMJSound/tishi_cpg.mp3")

		audio.preloadSound("CXMJSound/win.mp3")
		audio.preloadSound("CXMJSound/lose.mp3")
	end
	
	
	for i = 1, 4 do
		for j = 1, 9 do
			if i == 4 and j > 4 then
				break
			end
			audio.preloadSound("CXMJSound/female/" .. ((i-1)*10+(j-1)) .. ".mp3")
			audio.preloadSound("CXMJSound/male/" .. ((i-1)*10+(j-1)) .. ".mp3")
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
	audio.playSound("CXMJSound/dealcard.mp3", false)
end

function MJSound.selectCard()
	if not soundState then
		return
	end
	audio.playSound("CXMJSound/selectcard.mp3", false)
end

function MJSound.drawCard()
	if not soundState then
		return
	end
	audio.playSound("CXMJSound/discardcard.mp3", false)
end

function MJSound.complementCard(sex, majiang)
	if not soundState then
		return
	end

	-- if majiang == "shzhmj" then

	-- elseif majiang == "shymj" then
	-- 	if sex > 1 then
	-- 		audio.playSound("ShYSound/male/43_0.mp3", false)
	-- 	else
	-- 		audio.playSound("ShYSound/female/43_0.mp3", false)
	-- 	end
	-- else
	-- 	if sex > 1 then
	-- 		audio.playSound("ShXSound/male/43_0.mp3", false)
	-- 	else
	-- 		audio.playSound("ShXSound/female/43_0.mp3", false)
	-- 	end
	-- end
end

function MJSound.outCard(card, dragon, sex, majiang)
	-- print("MJSound.outCard:" .. majiang)
	if not soundState then
		return
	end
	audio.playSound("CXMJSound/downtotable.mp3", false)
	local i = math.floor(card/16)
	local j = card % 16
	print("sound out card:i:" .. i .. ",j:" .. j)
	if sex > 1 then
		if card == dragon then
			audio.playSound("CXMJSound/male/piao.mp3", false)
		else
			audio.playSound("CXMJSound/male/" .. ((i-1)*10+(j-1)) .. ".mp3", false)
		end
	else
		if card == dragon then
			audio.playSound("CXMJSound/female/piao.mp3", false)
		else
			audio.playSound("CXMJSound/female/" .. ((i-1)*10+(j-1)) .. ".mp3", false)
		end
	end
	
end

function MJSound.combinCard(combin, sex, majiang)
	if not soundState then
		return
	end
	audio.playSound("CXMJSound/tishi_cpg.mp3", false)
	if combin == "left" or combin == "center" or combin == "right" then
		if sex > 1 then
			audio.playSound("CXMJSound/male/29.mp3", false)
		else
			audio.playSound("CXMJSound/female/29.mp3", false)
		end
	elseif combin == "peng" then
		if sex > 1 then
			audio.playSound("CXMJSound/male/9.mp3", false)
		else
			audio.playSound("CXMJSound/female/9.mp3", false)
		end
	elseif combin == "ming_gang" or combin == "bu_gang" or combin == "an_gang" then
		if sex > 1 then
			audio.playSound("CXMJSound/male/19.mp3", false)
		else
			audio.playSound("CXMJSound/female/19.mp3", false)
		end
	elseif combin == "hun" then
		if sex > 1 then
			audio.playSound("CXMJSound/male/45.mp3", false)
		else
			audio.playSound("CXMJSound/female/45.mp3", false)
		end
	end
	
end

function MJSound.gameResult(result)
	if not soundState then
		return
	end
	if result == 0 then
		audio.playSound("CXMJSound/drawgame.mp3", false)
	elseif result > 0 then
		audio.playSound("CXMJSound/win.mp3", false)
	elseif result < 0 then
		audio.playSound("CXMJSound/lose.mp3", false)
	end
end

function MJSound.timeTick()
	if not soundState then
		return
	end
	audio.playSound("CXMJSound/countdown.mp3", false)
end

function MJSound.rotateDice()
	if not soundState then
		return
	end
	audio.playSound("CXMJSound/Dice.mp3", false)
end

return MJSound