--
-- Author: peter
-- Date: 2016-12-19 13:14:26
--

local GP_Audio = {}

--GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_OUT_CARD)
GP_Audio.preloadResPath = {			--预加载资源的路径
	GP_SOUND_READY = "Sound/GP/ready.mp3",       							--准备音效
	GP_SOUND_BEHAVIOR = "Sound/GP/KeypressStandard.mp3", 					--不出 提示 出牌
	GP_SOUND_BOOM = "Sound/GP/Snd_boom.mp3", 								--炸弹音效
	GP_SOUND_HIT_CARD = "Sound/GP/Snd_HitCard.mp3", 						--牌露头音效
	GP_SOUND_OUT_CARD = "Sound/GP/Snd_OutCard.mp3",							--打牌音效
	GP_SOUND_DISPATCH = "Sound/GP/Special_Dispatch.mp3",					--发牌音效
	GP_SOUND_TIMEOUT = "Sound/GP/timeout.mp3",								--倒计时音效
	GP_SOUND_ALLOFF = "Sound/GP/QuanGuan.mp3",								--全关音效
				
	--男音效		
	GP_SOUND_MALE_SINGLE_1 = "Sound/GP/male/A.mp3",							--男_单牌_A
	GP_SOUND_MALE_SINGLE_2 = "Sound/GP/male/2.mp3",							--男_单牌_2
	GP_SOUND_MALE_SINGLE_3 = "Sound/GP/male/3.mp3",							--男_单牌_3
	GP_SOUND_MALE_SINGLE_4 = "Sound/GP/male/4.mp3",							--男_单牌_4
	GP_SOUND_MALE_SINGLE_5 = "Sound/GP/male/5.mp3",							--男_单牌_5
	GP_SOUND_MALE_SINGLE_6 = "Sound/GP/male/6.mp3",							--男_单牌_6
	GP_SOUND_MALE_SINGLE_7 = "Sound/GP/male/7.mp3",							--男_单牌_7
	GP_SOUND_MALE_SINGLE_8 = "Sound/GP/male/8.mp3",							--男_单牌_8
	GP_SOUND_MALE_SINGLE_9 = "Sound/GP/male/9.mp3",							--男_单牌_9
	GP_SOUND_MALE_SINGLE_10 = "Sound/GP/male/10.mp3",						--男_单牌_10
	GP_SOUND_MALE_SINGLE_11 = "Sound/GP/male/J.mp3",						--男_单牌_11
	GP_SOUND_MALE_SINGLE_12 = "Sound/GP/male/Q.mp3",						--男_单牌_12
	GP_SOUND_MALE_SINGLE_13 = "Sound/GP/male/K.mp3",						--男_单牌_13
				
	GP_SOUND_MALE_DOUBLE_2 = "Sound/GP/male/22.mp3",						--男_对牌_22
	GP_SOUND_MALE_DOUBLE_3 = "Sound/GP/male/33.mp3",						--男_对牌_33
	GP_SOUND_MALE_DOUBLE_4 = "Sound/GP/male/44.mp3",						--男_对牌_44
	GP_SOUND_MALE_DOUBLE_5 = "Sound/GP/male/55.mp3",						--男_对牌_55
	GP_SOUND_MALE_DOUBLE_6 = "Sound/GP/male/66.mp3",						--男_对牌_66
	GP_SOUND_MALE_DOUBLE_7 = "Sound/GP/male/77.mp3",						--男_对牌_77
	GP_SOUND_MALE_DOUBLE_8 = "Sound/GP/male/88.mp3",						--男_对牌_88
	GP_SOUND_MALE_DOUBLE_9 = "Sound/GP/male/99.mp3",						--男_对牌_99
	GP_SOUND_MALE_DOUBLE_10 = "Sound/GP/male/1010.mp3",						--男_对牌_1010
	GP_SOUND_MALE_DOUBLE_11 = "Sound/GP/male/JJ.mp3",						--男_对牌_JJ
	GP_SOUND_MALE_DOUBLE_12 = "Sound/GP/male/QQ.mp3",						--男_对牌_QQ
	GP_SOUND_MALE_DOUBLE_13 = "Sound/GP/male/KK.mp3",						--男_对牌_KK
			
	GP_SOUND_MALE_TRIBLE = "Sound/GP/male/SanZhang.mp3",					--男_三张
	GP_SOUND_MALE_CAPTIVE = "Sound/GP/male/3Dai2.mp3",						--男_3带2
	GP_SOUND_MALE_SEQUENCES = "Sound/GP/male/ShunZi.mp3",					--男_顺子
	GP_SOUND_MALE_DOUBLESEQUENCES = "Sound/GP/male/LianDui.mp3",			--男_连对
	GP_SOUND_MALE_TRIBLESEQUENCES = "Sound/GP/male/SanLian.mp3",			--男_三连
	GP_SOUND_MALE_BOMB = "Sound/GP/male/ZhaDan.mp3",						--男_炸弹
		
	GP_SOUND_MALE_NO = "Sound/GP/male/BuYao.mp3",							--男_不要
	GP_SOUND_MALE_YOU = "Sound/GP/male/DaNi.mp3",							--男_大你
	GP_SOUND_MALE_ONE = "Sound/GP/male/ShengYiZhang.mp3",					--男_剩一张
	GP_SOUND_MALE_TWO = "Sound/GP/male/ShengLiangZhang.mp3",				--男_剩两张

	--女音效
	GP_SOUND_FEMALE_SINGLE_1 = "Sound/GP/female/A.mp3",						--女_单牌_A
	GP_SOUND_FEMALE_SINGLE_2 = "Sound/GP/female/2.mp3",						--女_单牌_2
	GP_SOUND_FEMALE_SINGLE_3 = "Sound/GP/female/3.mp3",						--女_单牌_3
	GP_SOUND_FEMALE_SINGLE_4 = "Sound/GP/female/4.mp3",						--女_单牌_4
	GP_SOUND_FEMALE_SINGLE_5 = "Sound/GP/female/5.mp3",						--女_单牌_5
	GP_SOUND_FEMALE_SINGLE_6 = "Sound/GP/female/6.mp3",						--女_单牌_6
	GP_SOUND_FEMALE_SINGLE_7 = "Sound/GP/female/7.mp3",						--女_单牌_7
	GP_SOUND_FEMALE_SINGLE_8 = "Sound/GP/female/8.mp3",						--女_单牌_8
	GP_SOUND_FEMALE_SINGLE_9 = "Sound/GP/female/9.mp3",						--女_单牌_9
	GP_SOUND_FEMALE_SINGLE_10 = "Sound/GP/female/10.mp3",					--女_单牌_10
	GP_SOUND_FEMALE_SINGLE_11 = "Sound/GP/female/J.mp3",					--女_单牌_11
	GP_SOUND_FEMALE_SINGLE_12 = "Sound/GP/female/Q.mp3",					--女_单牌_12
	GP_SOUND_FEMALE_SINGLE_13 = "Sound/GP/female/K.mp3",					--女_单牌_13
			
	GP_SOUND_FEMALE_DOUBLE_2 = "Sound/GP/female/22.mp3",					--女_对牌_22
	GP_SOUND_FEMALE_DOUBLE_3 = "Sound/GP/female/33.mp3",					--女_对牌_33
	GP_SOUND_FEMALE_DOUBLE_4 = "Sound/GP/female/44.mp3",					--女_对牌_44
	GP_SOUND_FEMALE_DOUBLE_5 = "Sound/GP/female/55.mp3",					--女_对牌_55
	GP_SOUND_FEMALE_DOUBLE_6 = "Sound/GP/female/66.mp3",					--女_对牌_66
	GP_SOUND_FEMALE_DOUBLE_7 = "Sound/GP/female/77.mp3",					--女_对牌_77
	GP_SOUND_FEMALE_DOUBLE_8 = "Sound/GP/female/88.mp3",					--女_对牌_88
	GP_SOUND_FEMALE_DOUBLE_9 = "Sound/GP/female/99.mp3",					--女_对牌_99
	GP_SOUND_FEMALE_DOUBLE_10 = "Sound/GP/female/1010.mp3",					--女_对牌_1010
	GP_SOUND_FEMALE_DOUBLE_11 = "Sound/GP/female/JJ.mp3",					--女_对牌_JJ
	GP_SOUND_FEMALE_DOUBLE_12 = "Sound/GP/female/QQ.mp3",					--女_对牌_QQ
	GP_SOUND_FEMALE_DOUBLE_13 = "Sound/GP/female/KK.mp3",					--女_对牌_KK
		
	GP_SOUND_FEMALE_TRIBLE = "Sound/GP/female/SanZhang.mp3",				--女_三张
	GP_SOUND_FEMALE_CAPTIVE = "Sound/GP/female/3Dai2.mp3",					--女_3带2
	GP_SOUND_FEMALE_SEQUENCES = "Sound/GP/female/ShunZi.mp3",				--女_顺子
	GP_SOUND_FEMALE_DOUBLESEQUENCES = "Sound/GP/female/LianDui.mp3",		--女_连对
	GP_SOUND_FEMALE_TRIBLESEQUENCES = "Sound/GP/female/SanLian.mp3",		--女_三连
	GP_SOUND_FEMALE_BOMB = "Sound/GP/female/ZhaDan.mp3",					--女_炸弹
	
	GP_SOUND_FEMALE_NO = "Sound/GP/female/Guo.mp3",							--女_过
	GP_SOUND_FEMALE_YOU = "Sound/GP/female/Ya.mp3",							--女_压
	GP_SOUND_FEMALE_ONE = "Sound/GP/female/ShengYiZhang.mp3",				--女_剩一张
	GP_SOUND_FEMALE_TWO = "Sound/GP/female/ShengLiangZhang.mp3"				--女_剩两张
}


local audioEnabled = true   --是否开启了音乐播放

local DaoJiShiSoundHand = nil   --倒计时音效句柄

-- start --

--------------------------------
-- 预加载关牌所有音乐资源
-- @function preloadAllSound

-- end --
function GP_Audio.preloadAllSound()
	for k,v in ipairs(GP_Audio.preloadResPath) do
		audio.preloadSound(v)
	end
end


-- start --

--------------------------------
-- 选择 是否开启音乐播放
-- @function switchAudioEnabled

-- end --
function GP_Audio.switchAudioEnabled()
	audioEnabled = not audioEnabled
	if audioEnabled then
		audio.setSoundsVolume(1)
	else
		audio.setSoundsVolume(0)
	end
end

-- start --

--------------------------------
-- 是否开启了音乐播放
-- @function isAudioEnabled
-- @return   audioEnabled 静态变量

-- end --
function GP_Audio.isAudioEnabled()
	return audioEnabled
end

-- start --

--------------------------------
-- 播放音效
-- @function playSoundWithPath
-- @param path     播放资源路径

-- end --

function GP_Audio.playSoundWithPath(path,loob)
	if audioEnabled then
		audio.playSound(path,loob)
	end
end

-- start --

--------------------------------
-- 播放倒计时音效
-- @function playDaoJiShiSound

-- end --
function GP_Audio.playDaoJiShiSound()
	if audioEnabled then
		if not DaoJiShiSoundHand then
			DaoJiShiSoundHand = audio.playSound(GP_Audio.preloadResPath.GP_SOUND_TIMEOUT,true)
		end
	end
end

-- start --

--------------------------------
-- 停止倒计时音效
-- @function playSoundWithPath

-- end --
function GP_Audio.stopDaoJiShiSound()
	if audioEnabled then
		if DaoJiShiSoundHand then
			audio.stopSound(DaoJiShiSoundHand)
			DaoJiShiSoundHand = nil
		end
	end
end

return GP_Audio