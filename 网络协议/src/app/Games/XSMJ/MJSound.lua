local MJSound = {}

local soundState = true

function MJSound.init()
	soundState = true

	if device.platform == "ios" then
		audio.preloadSound("YCMJSound/dealcard.mp3")
		audio.preloadSound("YCMJSound/downtotable.mp3")

		audio.preloadSound("YCMJSound/countdown.mp3")

		audio.preloadSound("YCMJSound/drawgame.mp3")
		audio.preloadSound("YCMJSound/selectcard.mp3")

		audio.preloadSound("YCMJSound/fangpao.mp3")
		audio.preloadSound("YCMJSound/female/45.mp3")
		audio.preloadSound("YCMJSound/male/45.mp3")

		audio.preloadSound("YCMJSound/Dice.mp3")

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
			audio.preloadSound("XSMJSound/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
			audio.preloadSound("XSMJSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
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
	if sex > 1 then
		audio.playSound("XSMJSound/male/buhua.mp3", false)
	else
		audio.playSound("XSMJSound/female/buhua.mp3", false)
	end
end

function MJSound.outCard(card, dragon, sex, majiang)
	print(" XS mj MJSound.outCard:" .. majiang)
	if not soundState then
		return
	end
	audio.playSound("YCMJSound/downtotable.mp3", false)
	local i = math.floor(card/16)
	local j = card % 16
	print("XS mj sound out card:i:" .. i .. ",j:" .. j)
	if sex > 1 then
		-- if card == dragon then
		-- 	audio.playSound("YCMJSound/male/piao.mp3", false)
		-- else
		print("mj sound haha :" .. "XSMJSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3")
			audio.playSound("XSMJSound/male/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
		-- end
	else
		-- if card == dragon then
		-- 	audio.playSound("YCMJSound/female/piao.mp3", false)
		-- else
			audio.playSound("XSMJSound/female/" .. ((i-1)*10+(j-1)) .. "_0.mp3", false)
		-- end
	end
	
end

function MJSound.combinCard(combin, sex, majiang)
	if not soundState then
		return
	end
	audio.playSound("XSMJSound/tishi_cpg.mp3", false)
	if combin == "left" or combin == "center" or combin == "right" then
		if sex > 1 then
			audio.playSound("XSMJSound/male/chi.mp3", false)
		else
			audio.playSound("XSMJSound/female/chi.mp3", false)
		end
	elseif combin == "peng" then
		if sex > 1 then
			audio.playSound("XSMJSound/male/peng.mp3", false)
		else
			audio.playSound("XSMJSound/female/peng.mp3", false)
		end
	elseif combin == "gang" then
		if sex > 1 then
			audio.playSound("XSMJSound/male/gang.mp3", false)
		else
			audio.playSound("XSMJSound/female/gang.mp3", false)
		end
	elseif combin == "hun" then
		if sex > 1 then
			audio.playSound("XSMJSound/male/hu.mp3", false)
		else
			audio.playSound("XSMJSound/female/hu.mp3", false)
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