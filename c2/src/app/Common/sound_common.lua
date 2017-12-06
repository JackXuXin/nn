local sound_common = {}

local voiceState = app.constant.voiceOn
local musicState = app.constant.musicOn

print("voiceState:" .. tostring(voiceState))
print("musicState:" .. tostring(musicState))

function sound_common.init()

	if device.platform == "ios" then
		-- audio.preloadMusic("Sound/Lobby/bg.mp3")
		audio.preloadSound("Sound/Lobby/cancel.mp3")
		audio.preloadSound("Sound/Lobby/confirm.mp3")
		audio.preloadSound("Sound/Lobby/menu.mp3")
		audio.preloadSound("Sound/Lobby/pose1.mp3")
		audio.preloadSound("Sound/total_result.mp3")

		audio.preloadSound("Sound/emoSound/dianji_1.mp3")
		audio.preloadSound("Sound/emoSound/dianji.mp3")
		audio.preloadSound("Sound/emoSound/egg.mp3")
		audio.preloadSound("Sound/emoSound/futou.mp3")
		audio.preloadSound("Sound/emoSound/ganbei.mp3")
		audio.preloadSound("Sound/emoSound/glass.mp3")
		audio.preloadSound("Sound/emoSound/jiqiang.mp3")
		audio.preloadSound("Sound/emoSound/money.mp3")
		audio.preloadSound("Sound/emoSound/poshui.mp3")
		audio.preloadSound("Sound/emoSound/hua.mp3")
		audio.preloadSound("Sound/emoSound/tuoxie.mp3")
	end
end

function sound_common.setVoiceState(sound)
	voiceState = sound
end

function sound_common.setMusicState(sound)
	musicState = sound
end

--背景音乐
function sound_common.bg()
	if not musicState then
		return
	end
	audio.playMusic("Sound/Lobby/bg.mp3", true)
end

--总战绩背景音乐
function sound_common.total_result_bg()
	if not musicState then
		return
	end

	audio.playMusic("Sound/total_result.mp3", true)
end

function sound_common.stop_bg()
	audio.stopMusic(false)
end

function sound_common.menu()
	if not voiceState then
		return
	end
	audio.playSound("Sound/Lobby/menu.mp3", false)
end

function sound_common.cancel()
	if not voiceState then
		return
	end
	app.constant.isOpening = false
	audio.playSound("Sound/Lobby/cancel.mp3", false)
end

function sound_common.confirm()
	if not voiceState then
		return
	end
	audio.playSound("Sound/Lobby/confirm.mp3", false)
end

function sound_common.turnPan()
	if not voiceState then
		return
	end
	print("turnpan-------")
	audio.playSound("Sound/Lobby/pose1.mp3", false)
end

function sound_common.emoSound(strSound)
	
	if strSound == nil or strSound == "" then
		return
	end

	if not voiceState then
		return
	end
	audio.playSound("Sound/emoSound/" .. strSound .. ".mp3", false)
end

return sound_common