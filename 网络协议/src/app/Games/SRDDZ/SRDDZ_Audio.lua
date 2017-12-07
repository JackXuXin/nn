--
-- Author: peter
-- Date: 2017-02-17 13:15:27
--

local SRDDZ_Audio = {}

local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")

--gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_FEMALE_NO)
SRDDZ_Audio.preloadResPath = {			--预加载资源的路径
	SRDDZ_SOUND_READY = "Sound/SRDDZ/ready.mp3",       								--准备音效
	SRDDZ_SOUND_BEHAVIOR = "Sound/SRDDZ/KeypressStandard.mp3", 						--点按钮
	SRDDZ_SOUND_BOOM = "Sound/SRDDZ/Snd_boom.mp3", 									--炸弹音效
	SRDDZ_SOUND_HIT_CARD = "Sound/SRDDZ/Snd_HitCard.mp3", 							--选牌音效
	SRDDZ_SOUND_OUT_CARD = "Sound/SRDDZ/Snd_OutCard.mp3",								--打牌音效
	SRDDZ_SOUND_DISPATCH = "Sound/SRDDZ/Special_Dispatch.mp3",						--发牌音效
	SRDDZ_SOUND_TIMEOUT = "Sound/SRDDZ/timeout.mp3",									--倒计时音效
	SRDDZ_SOUND_SPRING = "Sound/SRDDZ/ChunTian.mp3",									--春天音效  X
	SRDDZ_SOUND_AIRCRAFT = "Sound/SRDDZ/FeiJi.mp3",									--飞机音效  X
	SRDDZ_SOUND_ROCKET = "Sound/SRDDZ/HuoJian.mp3",									--火箭音效  X
	SRDDZ_SOUND_FAIL = "Sound/SRDDZ/fail.mp3",										--输音效  
	SRDDZ_SOUND_SUCCESS = "Sound/SRDDZ/Success.mp3",									--赢音效
	SRDDZ_SOUND_QUIT = "Sound/SRDDZ/quit.mp3",										--退出音效
	SRDDZ_SOUND_CONTINUE = "Sound/SRDDZ/Continue.mp3",								--再来一局音效

	--男音效		
	SRDDZ_SOUND_MALE_SINGLE_1 = "Sound/SRDDZ/male/A.mp3",								--男_单牌_A
	SRDDZ_SOUND_MALE_SINGLE_2 = "Sound/SRDDZ/male/2.mp3",								--男_单牌_2
	SRDDZ_SOUND_MALE_SINGLE_3 = "Sound/SRDDZ/male/3.mp3",								--男_单牌_3
	SRDDZ_SOUND_MALE_SINGLE_4 = "Sound/SRDDZ/male/4.mp3",								--男_单牌_4
	SRDDZ_SOUND_MALE_SINGLE_5 = "Sound/SRDDZ/male/5.mp3",								--男_单牌_5
	SRDDZ_SOUND_MALE_SINGLE_6 = "Sound/SRDDZ/male/6.mp3",								--男_单牌_6
	SRDDZ_SOUND_MALE_SINGLE_7 = "Sound/SRDDZ/male/7.mp3",								--男_单牌_7
	SRDDZ_SOUND_MALE_SINGLE_8 = "Sound/SRDDZ/male/8.mp3",								--男_单牌_8
	SRDDZ_SOUND_MALE_SINGLE_9 = "Sound/SRDDZ/male/9.mp3",								--男_单牌_9
	SRDDZ_SOUND_MALE_SINGLE_10 = "Sound/SRDDZ/male/10.mp3",							--男_单牌_10
	SRDDZ_SOUND_MALE_SINGLE_11 = "Sound/SRDDZ/male/J.mp3",							--男_单牌_11
	SRDDZ_SOUND_MALE_SINGLE_12 = "Sound/SRDDZ/male/Q.mp3",							--男_单牌_12
	SRDDZ_SOUND_MALE_SINGLE_13 = "Sound/SRDDZ/male/K.mp3",							--男_单牌_13
	SRDDZ_SOUND_MALE_SINGLE_14 = "Sound/SRDDZ/male/XiaoWang.mp3",						--男_小王
	SRDDZ_SOUND_MALE_SINGLE_15 = "Sound/SRDDZ/male/DaWang.mp3",						--男_大王

	SRDDZ_SOUND_MALE_DOUBLE_1 = "Sound/SRDDZ/male/AA.mp3",							--男_对牌_AA
	SRDDZ_SOUND_MALE_DOUBLE_2 = "Sound/SRDDZ/male/22.mp3",							--男_对牌_22
	SRDDZ_SOUND_MALE_DOUBLE_3 = "Sound/SRDDZ/male/33.mp3",							--男_对牌_33
	SRDDZ_SOUND_MALE_DOUBLE_4 = "Sound/SRDDZ/male/44.mp3",							--男_对牌_44
	SRDDZ_SOUND_MALE_DOUBLE_5 = "Sound/SRDDZ/male/55.mp3",							--男_对牌_55
	SRDDZ_SOUND_MALE_DOUBLE_6 = "Sound/SRDDZ/male/66.mp3",							--男_对牌_66
	SRDDZ_SOUND_MALE_DOUBLE_7 = "Sound/SRDDZ/male/77.mp3",							--男_对牌_77
	SRDDZ_SOUND_MALE_DOUBLE_8 = "Sound/SRDDZ/male/88.mp3",							--男_对牌_88
	SRDDZ_SOUND_MALE_DOUBLE_9 = "Sound/SRDDZ/male/99.mp3",							--男_对牌_99
	SRDDZ_SOUND_MALE_DOUBLE_10 = "Sound/SRDDZ/male/1010.mp3",							--男_对牌_1010
	SRDDZ_SOUND_MALE_DOUBLE_11 = "Sound/SRDDZ/male/JJ.mp3",							--男_对牌_JJ
	SRDDZ_SOUND_MALE_DOUBLE_12 = "Sound/SRDDZ/male/QQ.mp3",							--男_对牌_QQ
	SRDDZ_SOUND_MALE_DOUBLE_13 = "Sound/SRDDZ/male/KK.mp3",							--男_对牌_KK
	SRDDZ_SOUND_MALE_DOUBLE_14 = "Sound/SRDDZ/male/XiaoWang2.mp3",							--男_对牌_小王
	SRDDZ_SOUND_MALE_DOUBLE_15 = "Sound/SRDDZ/male/DaWang2.mp3",							--男_对牌_大王

	SRDDZ_SOUND_MALE_AAA = "Sound/SRDDZ/male/SanZhang.mp3",							--男_三张
	SRDDZ_SOUND_MALE_AAABB = "Sound/SRDDZ/male/3Dai2.mp3",							--男_3带2
	SRDDZ_SOUND_MALE_AAABBB = "Sound/SRDDZ/male/FeiJi.mp3",							--男_飞机
	SRDDZ_SOUND_MALE_ROCKET = "Sound/SRDDZ/male/HuoJian.mp3",							--男_火箭
	SRDDZ_SOUND_MALE_AABBCC = "Sound/SRDDZ/male/LianDui.mp3",							--男_连对
	SRDDZ_SOUND_MALE_BOMB = "Sound/SRDDZ/male/ZhaDan.mp3",							--男_炸弹

	SRDDZ_SOUND_MALE_NO = "Sound/SRDDZ/male/BuYao.mp3",								--男_不要
	SRDDZ_SOUND_MALE_YOU = "Sound/SRDDZ/male/DaNi.mp3",								--男_大你
	SRDDZ_SOUND_MALE_JIAOFEN_0 = "Sound/SRDDZ/female/F0.mp3",							--男_不叫
	SRDDZ_SOUND_MALE_JIAOFEN_1 = "Sound/SRDDZ/female/F1.mp3",							--男_一分
	SRDDZ_SOUND_MALE_JIAOFEN_2 = "Sound/SRDDZ/female/F2.mp3",							--男_二分
	SRDDZ_SOUND_MALE_JIAOFEN_3 = "Sound/SRDDZ/female/F3.mp3",							--男_三分

	--女音效
	SRDDZ_SOUND_FEMALE_SINGLE_1 = "Sound/SRDDZ/female/A.mp3",							--女_单牌_A
	SRDDZ_SOUND_FEMALE_SINGLE_2 = "Sound/SRDDZ/female/2.mp3",							--女_单牌_2
	SRDDZ_SOUND_FEMALE_SINGLE_3 = "Sound/SRDDZ/female/3.mp3",							--女_单牌_3
	SRDDZ_SOUND_FEMALE_SINGLE_4 = "Sound/SRDDZ/female/4.mp3",							--女_单牌_4
	SRDDZ_SOUND_FEMALE_SINGLE_5 = "Sound/SRDDZ/female/5.mp3",							--女_单牌_5
	SRDDZ_SOUND_FEMALE_SINGLE_6 = "Sound/SRDDZ/female/6.mp3",							--女_单牌_6
	SRDDZ_SOUND_FEMALE_SINGLE_7 = "Sound/SRDDZ/female/7.mp3",							--女_单牌_7
	SRDDZ_SOUND_FEMALE_SINGLE_8 = "Sound/SRDDZ/female/8.mp3",							--女_单牌_8
	SRDDZ_SOUND_FEMALE_SINGLE_9 = "Sound/SRDDZ/female/9.mp3",							--女_单牌_9
	SRDDZ_SOUND_FEMALE_SINGLE_10 = "Sound/SRDDZ/female/10.mp3",						--女_单牌_10
	SRDDZ_SOUND_FEMALE_SINGLE_11 = "Sound/SRDDZ/female/J.mp3",						--女_单牌_11
	SRDDZ_SOUND_FEMALE_SINGLE_12 = "Sound/SRDDZ/female/Q.mp3",						--女_单牌_12
	SRDDZ_SOUND_FEMALE_SINGLE_13 = "Sound/SRDDZ/female/K.mp3",						--女_单牌_13
	SRDDZ_SOUND_FEMALE_SINGLE_14 = "Sound/SRDDZ/female/XiaoWang.mp3",					--女_小王
	SRDDZ_SOUND_FEMALE_SINGLE_15 = "Sound/SRDDZ/female/DaWang.mp3",					--女_大王

	SRDDZ_SOUND_FEMALE_DOUBLE_1 = "Sound/SRDDZ/female/AA.mp3",						--女_对牌_AA
	SRDDZ_SOUND_FEMALE_DOUBLE_2 = "Sound/SRDDZ/female/22.mp3",						--女_对牌_22
	SRDDZ_SOUND_FEMALE_DOUBLE_3 = "Sound/SRDDZ/female/33.mp3",						--女_对牌_33
	SRDDZ_SOUND_FEMALE_DOUBLE_4 = "Sound/SRDDZ/female/44.mp3",						--女_对牌_44
	SRDDZ_SOUND_FEMALE_DOUBLE_5 = "Sound/SRDDZ/female/55.mp3",						--女_对牌_55
	SRDDZ_SOUND_FEMALE_DOUBLE_6 = "Sound/SRDDZ/female/66.mp3",						--女_对牌_66
	SRDDZ_SOUND_FEMALE_DOUBLE_7 = "Sound/SRDDZ/female/77.mp3",						--女_对牌_77
	SRDDZ_SOUND_FEMALE_DOUBLE_8 = "Sound/SRDDZ/female/88.mp3",						--女_对牌_88
	SRDDZ_SOUND_FEMALE_DOUBLE_9 = "Sound/SRDDZ/female/99.mp3",						--女_对牌_99
	SRDDZ_SOUND_FEMALE_DOUBLE_10 = "Sound/SRDDZ/female/1010.mp3",						--女_对牌_1010
	SRDDZ_SOUND_FEMALE_DOUBLE_11 = "Sound/SRDDZ/female/JJ.mp3",						--女_对牌_JJ
	SRDDZ_SOUND_FEMALE_DOUBLE_12 = "Sound/SRDDZ/female/QQ.mp3",						--女_对牌_QQ
	SRDDZ_SOUND_FEMALE_DOUBLE_13 = "Sound/SRDDZ/female/KK.mp3",						--女_对牌_KK
	SRDDZ_SOUND_FEMALE_DOUBLE_14 = "Sound/SRDDZ/female/XiaoWang2.mp3",							--女_对牌_小王
	SRDDZ_SOUND_FEMALE_DOUBLE_15 = "Sound/SRDDZ/female/DaWang2.mp3",							--女_对牌_大王

	SRDDZ_SOUND_FEMALE_AAA = "Sound/SRDDZ/female/SanZhang.mp3",						--女_三张
	SRDDZ_SOUND_FEMALE_AAABB = "Sound/SRDDZ/female/3Dai2.mp3",						--女_3带2
	SRDDZ_SOUND_FEMALE_AAABBB = "Sound/SRDDZ/female/FeiJi.mp3",						--女_飞机
	SRDDZ_SOUND_FEMALE_ROCKET = "Sound/SRDDZ/female/HuoJian.mp3",						--女_火箭
	SRDDZ_SOUND_FEMALE_AABBCC = "Sound/SRDDZ/female/LianDui.mp3",						--女_连对
	SRDDZ_SOUND_FEMALE_BOMB = "Sound/SRDDZ/female/ZhaDan.mp3",						--女_炸弹

	SRDDZ_SOUND_FEMALE_NO = "Sound/SRDDZ/female/BuYao.mp3",							--女_不要
	SRDDZ_SOUND_FEMALE_YOU = "Sound/SRDDZ/female/DaNi.mp3",							--女_大你
	SRDDZ_SOUND_FEMALE_JIAOFEN_0 = "Sound/SRDDZ/female/F0.mp3",						--女_不叫
	SRDDZ_SOUND_FEMALE_JIAOFEN_1 = "Sound/SRDDZ/female/F1.mp3",						--女_一分
	SRDDZ_SOUND_FEMALE_JIAOFEN_2 = "Sound/SRDDZ/female/F2.mp3",						--女_二分
	SRDDZ_SOUND_FEMALE_JIAOFEN_3 = "Sound/SRDDZ/female/F3.mp3",						--女_三分
}

function SRDDZ_Audio:init()
	--预加载斗地主所有音乐资源
	for k,v in ipairs(SRDDZ_Audio.preloadResPath) do
		audio.preloadSound(v)
	end
end

function SRDDZ_Audio:clear()
	-- 卸载斗地主所有音乐资源
	for k,v in ipairs(SRDDZ_Audio.preloadResPath) do
		audio.unloadSound(v)
	end
end

local audioEnabled = true   --是否开启了音乐播放

--[[
	* 播放音效
	* @function playSoundWithPath
	* @param path     播放资源路径
--]]
function SRDDZ_Audio.playSoundWithPath(path,loob)
	if SRDDZ_Util.hasSound() then
		audio.playSound(path,loob)
	end
end

-- local DaoJiShiSoundHand = nil   --倒计时音效句柄

-- --[[
-- 	* 播放倒计时音效
-- 	* @function playDaoJiShiSound
-- --]]
-- function SRDDZ_Audio.playDaoJiShiSound()
-- 	if audioEnabled then
-- 		if not DaoJiShiSoundHand then
-- 			DaoJiShiSoundHand = audio.playSound(SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_TIMEOUT,true)
-- 		end
-- 	end
-- end

-- --[[
-- 	* 停止倒计时音效
-- 	* @function playSoundWithPath
-- --]]
-- function SRDDZ_Audio.stopDaoJiShiSound()
-- 	if audioEnabled then
-- 		if DaoJiShiSoundHand then
-- 			audio.stopSound(DaoJiShiSoundHand)
-- 			DaoJiShiSoundHand = nil
-- 		end
-- 	end
-- end


return SRDDZ_Audio