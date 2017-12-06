--
-- Author: peter
-- Date: 2017-03-21 14:36:00
--

local WL_Audio = {}

WL_Audio.preloadResPath = {
	WL_SOUND_READY = "Sound/WL/ready.mp3",       								--准备音效
	WL_SOUND_BEHAVIOR = "Sound/WL/KeypressStandard.mp3", 						--点按钮
	WL_SOUND_BOOM = "Sound/WL/Snd_boom.mp3", 									--炸弹音效
	WL_SOUND_HIT_CARD = "Sound/WL/Snd_HitCard.mp3", 							--选牌音效
	WL_SOUND_OUT_CARD = "Sound/WL/Snd_OutCard.mp3",								--打牌音效
	WL_SOUND_DISPATCH = "Sound/WL/Special_Dispatch.mp3",						--发牌音效
	WL_SOUND_QUIT = "Sound/WL/quit.mp3",										--退出音效
	WL_SOUND_CONTINUE = "Sound/WL/Continue.mp3",								--再来一局音效
	
	--男音效		
	WL_SOUND_MALE_SINGLE_1 = "Sound/WL/male/A.mp3",								--男_单牌_A
	WL_SOUND_MALE_SINGLE_2 = "Sound/WL/male/2.mp3",								--男_单牌_2
	WL_SOUND_MALE_SINGLE_3 = "Sound/WL/male/3.mp3",								--男_单牌_3
	WL_SOUND_MALE_SINGLE_4 = "Sound/WL/male/4.mp3",								--男_单牌_4
	WL_SOUND_MALE_SINGLE_5 = "Sound/WL/male/5.mp3",								--男_单牌_5
	WL_SOUND_MALE_SINGLE_6 = "Sound/WL/male/6.mp3",								--男_单牌_6
	WL_SOUND_MALE_SINGLE_7 = "Sound/WL/male/7.mp3",								--男_单牌_7
	WL_SOUND_MALE_SINGLE_8 = "Sound/WL/male/8.mp3",								--男_单牌_8
	WL_SOUND_MALE_SINGLE_9 = "Sound/WL/male/9.mp3",								--男_单牌_9
	WL_SOUND_MALE_SINGLE_10 = "Sound/WL/male/10.mp3",							--男_单牌_10
	WL_SOUND_MALE_SINGLE_11 = "Sound/WL/male/J.mp3",							--男_单牌_11
	WL_SOUND_MALE_SINGLE_12 = "Sound/WL/male/Q.mp3",							--男_单牌_12
	WL_SOUND_MALE_SINGLE_13 = "Sound/WL/male/K.mp3",							--男_单牌_13
	WL_SOUND_MALE_SINGLE_14 = "Sound/WL/male/XiaoWang.mp3",						--男_小王
	WL_SOUND_MALE_SINGLE_15 = "Sound/WL/male/DaWang.mp3",						--男_大王

	WL_SOUND_MALE_DOUBLE_1 = "Sound/WL/male/AA.mp3",							--男_对牌_AA
	WL_SOUND_MALE_DOUBLE_2 = "Sound/WL/male/22.mp3",							--男_对牌_22
	WL_SOUND_MALE_DOUBLE_3 = "Sound/WL/male/33.mp3",							--男_对牌_33
	WL_SOUND_MALE_DOUBLE_4 = "Sound/WL/male/44.mp3",							--男_对牌_44
	WL_SOUND_MALE_DOUBLE_5 = "Sound/WL/male/55.mp3",							--男_对牌_55
	WL_SOUND_MALE_DOUBLE_6 = "Sound/WL/male/66.mp3",							--男_对牌_66
	WL_SOUND_MALE_DOUBLE_7 = "Sound/WL/male/77.mp3",							--男_对牌_77
	WL_SOUND_MALE_DOUBLE_8 = "Sound/WL/male/88.mp3",							--男_对牌_88
	WL_SOUND_MALE_DOUBLE_9 = "Sound/WL/male/99.mp3",							--男_对牌_99
	WL_SOUND_MALE_DOUBLE_10 = "Sound/WL/male/1010.mp3",							--男_对牌_1010
	WL_SOUND_MALE_DOUBLE_11 = "Sound/WL/male/JJ.mp3",							--男_对牌_JJ
	WL_SOUND_MALE_DOUBLE_12 = "Sound/WL/male/QQ.mp3",							--男_对牌_QQ
	WL_SOUND_MALE_DOUBLE_13 = "Sound/WL/male/KK.mp3",							--男_对牌_KK
	WL_SOUND_MALE_DOUBLE_14 = "Sound/WL/male/XiaoWang2.mp3",					--男_对牌_小王
	WL_SOUND_MALE_DOUBLE_15 = "Sound/WL/male/DaWang2.mp3",						--男_对牌_大王

	WL_SOUND_MALE_AAA = "Sound/WL/male/SanZhang.mp3",							--男_三张
	WL_SOUND_MALE_BOMB = "Sound/WL/male/ZhaDan.mp3",							--男_炸弹

	WL_SOUND_MALE_NO = "Sound/WL/male/BuYao.mp3",								--男_不要
	WL_SOUND_MALE_YOU = "Sound/WL/male/DaNi.mp3",								--男_大你

	--女音效
	WL_SOUND_FEMALE_SINGLE_1 = "Sound/WL/female/A.mp3",							--女_单牌_A
	WL_SOUND_FEMALE_SINGLE_2 = "Sound/WL/female/2.mp3",							--女_单牌_2
	WL_SOUND_FEMALE_SINGLE_3 = "Sound/WL/female/3.mp3",							--女_单牌_3
	WL_SOUND_FEMALE_SINGLE_4 = "Sound/WL/female/4.mp3",							--女_单牌_4
	WL_SOUND_FEMALE_SINGLE_5 = "Sound/WL/female/5.mp3",							--女_单牌_5
	WL_SOUND_FEMALE_SINGLE_6 = "Sound/WL/female/6.mp3",							--女_单牌_6
	WL_SOUND_FEMALE_SINGLE_7 = "Sound/WL/female/7.mp3",							--女_单牌_7
	WL_SOUND_FEMALE_SINGLE_8 = "Sound/WL/female/8.mp3",							--女_单牌_8
	WL_SOUND_FEMALE_SINGLE_9 = "Sound/WL/female/9.mp3",							--女_单牌_9
	WL_SOUND_FEMALE_SINGLE_10 = "Sound/WL/female/10.mp3",						--女_单牌_10
	WL_SOUND_FEMALE_SINGLE_11 = "Sound/WL/female/J.mp3",						--女_单牌_11
	WL_SOUND_FEMALE_SINGLE_12 = "Sound/WL/female/Q.mp3",						--女_单牌_12
	WL_SOUND_FEMALE_SINGLE_13 = "Sound/WL/female/K.mp3",						--女_单牌_13
	WL_SOUND_FEMALE_SINGLE_14 = "Sound/WL/female/XiaoWang.mp3",					--女_小王
	WL_SOUND_FEMALE_SINGLE_15 = "Sound/WL/female/DaWang.mp3",					--女_大王

	WL_SOUND_FEMALE_DOUBLE_1 = "Sound/WL/female/AA.mp3",						--女_对牌_AA
	WL_SOUND_FEMALE_DOUBLE_2 = "Sound/WL/female/22.mp3",						--女_对牌_22
	WL_SOUND_FEMALE_DOUBLE_3 = "Sound/WL/female/33.mp3",						--女_对牌_33
	WL_SOUND_FEMALE_DOUBLE_4 = "Sound/WL/female/44.mp3",						--女_对牌_44
	WL_SOUND_FEMALE_DOUBLE_5 = "Sound/WL/female/55.mp3",						--女_对牌_55
	WL_SOUND_FEMALE_DOUBLE_6 = "Sound/WL/female/66.mp3",						--女_对牌_66
	WL_SOUND_FEMALE_DOUBLE_7 = "Sound/WL/female/77.mp3",						--女_对牌_77
	WL_SOUND_FEMALE_DOUBLE_8 = "Sound/WL/female/88.mp3",						--女_对牌_88
	WL_SOUND_FEMALE_DOUBLE_9 = "Sound/WL/female/99.mp3",						--女_对牌_99
	WL_SOUND_FEMALE_DOUBLE_10 = "Sound/WL/female/1010.mp3",						--女_对牌_1010
	WL_SOUND_FEMALE_DOUBLE_11 = "Sound/WL/female/JJ.mp3",						--女_对牌_JJ
	WL_SOUND_FEMALE_DOUBLE_12 = "Sound/WL/female/QQ.mp3",						--女_对牌_QQ
	WL_SOUND_FEMALE_DOUBLE_13 = "Sound/WL/female/KK.mp3",						--女_对牌_KK
	WL_SOUND_FEMALE_DOUBLE_14 = "Sound/WL/female/XiaoWang2.mp3",				--女_对牌_小王
	WL_SOUND_FEMALE_DOUBLE_15 = "Sound/WL/female/DaWang2.mp3",					--女_对牌_大王

	WL_SOUND_FEMALE_AAA = "Sound/WL/female/SanZhang.mp3",						--女_三张
	WL_SOUND_FEMALE_BOMB = "Sound/WL/female/ZhaDan.mp3",						--女_炸弹

	WL_SOUND_FEMALE_NO = "Sound/WL/female/BuYao.mp3",							--女_不要
	WL_SOUND_FEMALE_YOU = "Sound/WL/female/DaNi.mp3",							--女_大你
}

function WL_Audio:init()
	--预加载斗地主所有音乐资源
	for k,v in ipairs(WL_Audio.preloadResPath) do
		audio.preloadSound(v)
	end
end

function WL_Audio:clear()

	-- 卸载斗地主所有音乐资源
	for k,v in ipairs(WL_Audio.preloadResPath) do
		audio.unloadSound(v)
	end
end

local audioEnabled = true   --是否开启了音乐播放

--[[
	* 播放音效
	* @function playSoundWithPath
	* @param path     播放资源路径
--]]
function WL_Audio.playSoundWithPath(path,loob)
	if audioEnabled then
		audio.playSound(path,loob)
	end
end

return WL_Audio