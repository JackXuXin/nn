local MJSound = {}

local soundState = true

function MJSound.init()
	soundState = true

	if device.platform == "ios" then
		audio.preloadSound("YCMJSound/dealcard.mp3")
		audio.preloadSound("YCMJSound/downtotable.mp3")

		--audio.preloadSound("YCMJSound/female/43_0.mp3")
		--audio.preloadSound("YCMJSound/male/43_0.mp3")

		audio.preloadSound("YCMJSound/countdown.mp3")

		-- audio.preloadSound("YCMJSound/female/35_0.mp3")
		-- audio.preloadSound("YCMJSound/male/35_0.mp3")
		-- audio.preloadSound("ShYSound/female/36_0.mp3")
		-- audio.preloadSound("ShYSound/male/36_0.mp3")
		-- audio.preloadSound("ShYSound/female/37_0.mp3")
		-- audio.preloadSound("ShYSound/male/37_0.mp3")

		audio.preloadSound("YCMJSound/drawgame.mp3")
		audio.preloadSound("YCMJSound/selectcard.mp3")

		audio.preloadSound("YCMJSound/fangpao.mp3")
		audio.preloadSound("YCMJSound/female/45.mp3")
		audio.preloadSound("YCMJSound/male/45.mp3")

		audio.preloadSound("YCMJSound/Dice.mp3")

		-- audio.preloadSound("YCMJSound/female/44_0.mp3")
		-- audio.preloadSound("YCMJSound/male/44_0.mp3")

		audio.preloadSound("YCMJSound/discardcard.mp3")
		audio.preloadSound("YCMJSound/tishi_cpg.mp3")

		audio.preloadSound("YCMJSound/win.mp3")
		audio.preloadSound("YCMJSound/lose.mp3")
	end
	
	
	for i = 1, 4 do
		for j = 1, 9 do
			if i == 4 and j > 4 then
				break
			end
			audio.preloadSound("YCMJSound/female/" .. ((i-1)*10+(j-1)) .. ".mp3")
			audio.preloadSound("YCMJSound/male/" .. ((i-1)*10+(j-1)) .. ".mp3")
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
	audio.playSound("YCMJSound/dealcard.mp3", false)
end

function MJSound.selectCard()
	if not soundState then
		return
	end
	audio.playSound("YCMJSound/selectcard.mp3", false)
end

function MJSound.drawCard()
	if not soundState then
		return
	end
	audio.playSound("YCMJSound/discardcard.mp3", false)
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
	audio.playSound("YCMJSound/downtotable.mp3", false)
	local i = math.floor(card/16)
	local j = card % 16
	print("sound out card:i:" .. i .. ",j:" .. j)
	if sex > 1 then
		if card == dragon then
			audio.playSound("YCMJSound/male/piao.mp3", false)
		else
			audio.playSound("YCMJSound/male/" .. ((i-1)*10+(j-1)) .. ".mp3", false)
		end
	else
		if card == dragon then
			audio.playSound("YCMJSound/female/piao.mp3", false)
		else
			audio.playSound("YCMJSound/female/" .. ((i-1)*10+(j-1)) .. ".mp3", false)
		end
	end
	
end

function MJSound.combinCard(combin, sex, majiang)
	if not soundState then
		return
	end
	audio.playSound("YCMJSound/tishi_cpg.mp3", false)
	if combin == "left" or combin == "center" or combin == "right" then
		if sex > 1 then
			audio.playSound("YCMJSound/male/29.mp3", false)
		else
			audio.playSound("YCMJSound/female/29.mp3", false)
		end
	elseif combin == "peng" then
		if sex > 1 then
			audio.playSound("YCMJSound/male/9.mp3", false)
		else
			audio.playSound("YCMJSound/female/9.mp3", false)
		end
	elseif combin == "gang" then
		if sex > 1 then
			audio.playSound("YCMJSound/male/19.mp3", false)
		else
			audio.playSound("YCMJSound/female/19.mp3", false)
		end
	elseif combin == "hun" then
		if sex > 1 then
			audio.playSound("YCMJSound/male/45.mp3", false)
		else
			audio.playSound("YCMJSound/female/45.mp3", false)
		end
	end
	
end

function MJSound.gameResult(result)
	if not soundState then
		return
	end
	if result == 0 then
		audio.playSound("YCMJSound/drawgame.mp3", false)
	elseif result > 0 then
		audio.playSound("YCMJSound/win.mp3", false)
	elseif result < 0 then
		audio.playSound("YCMJSound/lose.mp3", false)
	end
end

function MJSound.timeTick()
	if not soundState then
		return
	end
	audio.playSound("YCMJSound/countdown.mp3", false)
end

function MJSound.rotateDice()
	if not soundState then
		return
	end
	audio.playSound("YCMJSound/Dice.mp3", false)
end

return MJSound