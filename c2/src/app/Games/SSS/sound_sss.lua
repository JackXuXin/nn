local sound_sss = {}

local soundState = true

function sound_sss.init()
	soundState = true

	if device.platform == "ios" then
		audio.preloadSound("Sound/SSS/dianpai.mp3")
		audio.preloadSound("Sound/SSS/fapai.mp3")
		audio.preloadSound("Sound/SSS/gamestart.mp3")
		audio.preloadSound("Sound/SSS/huase.mp3")
		audio.preloadSound("Sound/SSS/jiqiang.mp3")
		audio.preloadSound("Sound/SSS/quanleida.mp3")
		audio.preloadSound("Sound/SSS/queding.mp3")
		audio.preloadSound("Sound/SSS/quxiao.mp3")
		audio.preloadSound("Sound/SSS/shui.mp3")
		audio.preloadSound("Sound/SSS/typebtn.mp3")
		audio.preloadSound("Sound/SSS/daqiang_man.mp3")
		audio.preloadSound("Sound/SSS/daqiang_woman.mp3")
		audio.preloadSound("Sound/SSS/deal.mp3")
	end
end

function sound_sss.setState(sound)
	soundState = sound
end

function sound_sss.touch_card()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/dianpai.mp3", false)
end

function sound_sss.send_card()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/fapai.mp3", false)
end

function sound_sss.game_start()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/gamestart.mp3", false)
end

function sound_sss.btn_huase()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/huase.mp3", false)
end

function sound_sss.da_qiang()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/jiqiang.mp3", false)
end

function sound_sss.quan_lei_da()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/quanleida.mp3", false)
end

function sound_sss.confirm()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/queding.mp3", false)
end

function sound_sss.cancel()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/queding.mp3", false)
end

local shuiHandle = nil
function sound_sss.compare()
	if not soundState then
		return
	end

	if shuiHandle then
		audio.stopSound(shuiHandle)
		shuiHandle = nil
	end

	shuiHandle = audio.playSound("Sound/SSS/shui.mp3", false)
end

function sound_sss.btn_type()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/typebtn.mp3", false)
end

function sound_sss.btn_type_2()
	if not soundState then
		return
	end
	audio.playSound("Sound/SSS/typebtn_2.mp3", false)
end

function sound_sss.daqiang(sex)
	if not soundState then
		return
	end
	if sex == 1 then
		audio.playSound("Sound/SSS/daqiang_woman.mp3", false)
	else
		audio.playSound("Sound/SSS/daqiang_man.mp3", false)
	end
end

function sound_sss.deal()
	if not soundState then
		return
	end
	
	audio.playSound("Sound/SSS/deal.mp3", false)
end

return sound_sss