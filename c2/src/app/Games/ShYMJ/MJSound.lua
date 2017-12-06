local MJSound = {}

local soundState = true

function MJSound.init()
	soundState = true

	if device.platform == "ios" then
		audio.preloadSound("ShYSound/dealcard.mp3")
		audio.preloadSound("ShYSound/downtotable.mp3")

		audio.preloadSound("ShYSound/female/43_0.mp3")
		audio.preloadSound("ShYSound/male/43_0.mp3")

		audio.preloadSound("ShYSound/countdown.mp3")

		audio.preloadSound("ShYSound/female/35_0.mp3")
		audio.preloadSound("ShYSound/male/35_0.mp3")
		audio.preloadSound("ShYSound/female/36_0.mp3")
		audio.preloadSound("ShYSound/male/36_0.mp3")
		audio.preloadSound("ShYSound/female/37_0.mp3")
		audio.preloadSound("ShYSound/male/37_0.mp3")

		audio.preloadSound("ShYSound/drawgame.mp3")
		audio.preloadSound("ShYSound/selectcard.mp3")

		audio.preloadSound("ShYSound/fangpao.mp3")
		audio.preloadSound("ShYSound/female/45_0.mp3")
		audio.preloadSound("ShYSound/male/45_0.mp3")

		audio.preloadSound("ShYSound/Dice.mp3")

		audio.preloadSound("ShYSound/female/44_0.mp3")
		audio.preloadSound("ShYSound/male/44_0.mp3")

		audio.preloadSound("ShYSound/discardcard.mp3")
		audio.preloadSound("ShYSound/tishi_cpg.mp3")

		audio.preloadSound("ShYSound/win.mp3")
		audio.preloadSound("ShYSound/lose.mp3")

		audio.preloadSound("Sound/total_result.mp3")
	end
	
	
	for i = 1, 4 do
	 	for j = 1, 9 do
	 		if i == 4 and j > 4 then
	 			break
	 		end
	 		audio.preloadSound("ShYSound/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
	 		audio.preloadSound("ShYSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
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
	audio.playSound("ShYSound/dealcard.mp3", false)
end

function MJSound.selectCard()
	if not soundState then
		return
	end
	audio.playSound("ShYSound/selectcard.mp3", false)
end

function MJSound.drawCard()
	if not soundState then
		return
	end
	audio.playSound("ShYSound/discardcard.mp3", false)
end

function MJSound.complementCard(sex, majiang)
	if not soundState then
		return
	end

	if majiang == "shzhmj" then

	elseif majiang == "shymj" then
		if sex > 1 then
			audio.playSound("ShYSound/male/43_0.mp3", false)
		else
			audio.playSound("ShYSound/female/43_0.mp3", false)
		end
	else
		if sex > 1 then
			audio.playSound("ShXSound/male/43_0.mp3", false)
		else
			audio.playSound("ShXSound/female/43_0.mp3", false)
		end
	end
end

function MJSound.outCard(card, dragon, sex, majiang)
	-- print("MJSound.outCard:" .. majiang)
	if not soundState then
		return
	end
	audio.playSound("ShYSound/downtotable.mp3", false)
	local i = math.floor(card/16)
	local j = card % 16

	if majiang == "shzhmj" then
		if sex > 1 then
			if card == dragon then
				audio.playSound("ShZhSound/male/piao.mp3", false)
			else
				audio.playSound("ShZhSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
			end
		else
			if card == dragon then
				audio.playSound("ShZhSound/female/piao.mp3", false)
			else
				audio.playSound("ShZhSound/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
			end
		end
	elseif majiang == "shymj" then
		if sex > 1 then
			if card == dragon then
				audio.playSound("ShYSound/male/44_0.mp3", false)
			else
				audio.playSound("ShYSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
			end
		else
			if card == dragon then
				audio.playSound("ShYSound/female/44_0.mp3", false)
			else
				audio.playSound("ShYSound/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
			end
		end
	else
		if sex > 1 then
			if card == dragon then
				audio.playSound("ShYSound/male/44_0.mp3", false)
			else
				audio.playSound("ShXSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
			end
		else
			if card == dragon then
				audio.playSound("ShYSound/female/44_0.mp3", false)
			else
				audio.playSound("ShXSound/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
			end
		end
	end
	
end

function MJSound.combinCard(combin, sex, majiang)
	if not soundState then
		return
	end
	audio.playSound("ShYSound/tishi_cpg.mp3", false)
	if majiang == "shzhmj" then
		if combin == "left" or combin == "center" or combin == "right" then
			if sex > 1 then
				audio.playSound("ShZhSound/male/chi.mp3", false)
			else
				audio.playSound("ShZhSound/female/chi.mp3", false)
			end
		elseif combin == "peng" then
			if sex > 1 then
				audio.playSound("ShZhSound/male/peng.mp3", false)
			else
				audio.playSound("ShZhSound/female/peng.mp3", false)
			end
		elseif combin == "gang" then
			if sex > 1 then
				audio.playSound("ShZhSound/male/gang.mp3", false)
			else
				audio.playSound("ShZhSound/female/gang.mp3", false)
			end
		elseif combin == "hun" then
			if sex > 1 then
				audio.playSound("ShZhSound/male/hun.mp3", false)
			else
				audio.playSound("ShZhSound/female/hun.mp3", false)
			end
		end
	elseif majiang == "shymj" then
		if combin == "left" or combin == "center" or combin == "right" then
			if sex > 1 then
				audio.playSound("ShYSound/male/35_0.mp3", false)
			else
				audio.playSound("ShYSound/female/35_0.mp3", false)
			end
		elseif combin == "peng" then
			if sex > 1 then
				audio.playSound("ShYSound/male/36_0.mp3", false)
			else
				audio.playSound("ShYSound/female/36_0.mp3", false)
			end
		elseif combin == "gang" then
			if sex > 1 then
				audio.playSound("ShYSound/male/37_0.mp3", false)
			else
				audio.playSound("ShYSound/female/37_0.mp3", false)
			end
		elseif combin == "hun" then
			if sex > 1 then
				audio.playSound("ShYSound/male/45_0.mp3", false)
			else
				audio.playSound("ShYSound/female/45_0.mp3", false)
			end
		end
	else
		if combin == "left" or combin == "center" or combin == "right" then
			if sex > 1 then
				audio.playSound("ShXSound/male/35_0.mp3", false)
			else
				audio.playSound("ShXSound/female/35_0.mp3", false)
			end
		elseif combin == "peng" then
			if sex > 1 then
				audio.playSound("ShXSound/male/36_0.mp3", false)
			else
				audio.playSound("ShXSound/female/36_0.mp3", false)
			end
		elseif combin == "gang" then
			if sex > 1 then
				audio.playSound("ShXSound/male/37_0.mp3", false)
			else
				audio.playSound("ShXSound/female/37_0.mp3", false)
			end
		elseif combin == "hun" then
			if sex > 1 then
				audio.playSound("ShYSound/male/45_0.mp3", false)
			else
				audio.playSound("ShYSound/female/45_0.mp3", false)
			end
		end
	end
	
end

function MJSound.gameResult(result)
	if not soundState then
		return
	end
	if result == 0 then
		audio.playSound("ShYSound/drawgame.mp3", false)
	elseif result > 0 then
		audio.playSound("ShYSound/win.mp3", false)
	elseif result < 0 then
		audio.playSound("ShYSound/lose.mp3", false)
	end
end

function MJSound.timeTick()
	if not soundState then
		return
	end
	audio.playSound("ShYSound/countdown.mp3", false)
end

function MJSound.rotateDice()
	if not soundState then
		return
	end
	audio.playSound("ShYSound/Dice.mp3", false)
end

return MJSound