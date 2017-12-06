--
-- Author: K
-- Date: 2016-12-27 11:19:30
-- 音乐
--


local DDZ_Audio = {}

--DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BOOM)
DDZ_Audio.preloadResPath = {			--预加载资源的路径
	DDZ_SOUND_READY = "Sound/DDZ/ready.mp3",       								--准备音效
	DDZ_SOUND_BEHAVIOR = "Sound/DDZ/KeypressStandard.mp3", 						--点按钮
	DDZ_SOUND_BOOM = "Sound/DDZ/Snd_boom.mp3", 									--炸弹音效
	DDZ_SOUND_HIT_CARD = "Sound/DDZ/Snd_HitCard.mp3", 							--选牌音效
	DDZ_SOUND_OUT_CARD = "Sound/DDZ/Snd_OutCard.mp3",							--打牌音效
	DDZ_SOUND_DISPATCH = "Sound/DDZ/Special_Dispatch.mp3",						--发牌音效
	DDZ_SOUND_TIMEOUT = "Sound/DDZ/timeout.mp3",								--倒计时音效
	DDZ_SOUND_SPRING = "Sound/DDZ/ChunTian.mp3",								--春天音效
	DDZ_SOUND_AIRCRAFT = "Sound/DDZ/FeiJi.mp3",									--飞机音效
	DDZ_SOUND_ROCKET = "Sound/DDZ/HuoJian.mp3",									--火箭音效
	DDZ_SOUND_FAIL = "Sound/DDZ/fail.mp3",										--输音效
	DDZ_SOUND_SUCCESS = "Sound/DDZ/Success.mp3",								--赢音效
	DDZ_SOUND_QUIT = "Sound/DDZ/quit.mp3",										--退出音效
	DDZ_SOUND_CONTINUE = "Sound/DDZ/Continue.mp3",								--再来一局音效

	--男音效		
	DDZ_SOUND_MALE_SINGLE_1 = "Sound/DDZ/male/A.mp3",							--男_单牌_A
	DDZ_SOUND_MALE_SINGLE_2 = "Sound/DDZ/male/2.mp3",							--男_单牌_2
	DDZ_SOUND_MALE_SINGLE_3 = "Sound/DDZ/male/3.mp3",							--男_单牌_3
	DDZ_SOUND_MALE_SINGLE_4 = "Sound/DDZ/male/4.mp3",							--男_单牌_4
	DDZ_SOUND_MALE_SINGLE_5 = "Sound/DDZ/male/5.mp3",							--男_单牌_5
	DDZ_SOUND_MALE_SINGLE_6 = "Sound/DDZ/male/6.mp3",							--男_单牌_6
	DDZ_SOUND_MALE_SINGLE_7 = "Sound/DDZ/male/7.mp3",							--男_单牌_7
	DDZ_SOUND_MALE_SINGLE_8 = "Sound/DDZ/male/8.mp3",							--男_单牌_8
	DDZ_SOUND_MALE_SINGLE_9 = "Sound/DDZ/male/9.mp3",							--男_单牌_9
	DDZ_SOUND_MALE_SINGLE_10 = "Sound/DDZ/male/10.mp3",							--男_单牌_10
	DDZ_SOUND_MALE_SINGLE_11 = "Sound/DDZ/male/J.mp3",							--男_单牌_11
	DDZ_SOUND_MALE_SINGLE_12 = "Sound/DDZ/male/Q.mp3",							--男_单牌_12
	DDZ_SOUND_MALE_SINGLE_13 = "Sound/DDZ/male/K.mp3",							--男_单牌_13
	DDZ_SOUND_MALE_SINGLE_14 = "Sound/DDZ/male/XiaoWang.mp3",					--男_小王
	DDZ_SOUND_MALE_SINGLE_15 = "Sound/DDZ/male/DaWang.mp3",						--男_大王
	
	DDZ_SOUND_MALE_DOUBLE_1 = "Sound/DDZ/male/AA.mp3",							--男_对牌_AA
	DDZ_SOUND_MALE_DOUBLE_2 = "Sound/DDZ/male/22.mp3",							--男_对牌_22
	DDZ_SOUND_MALE_DOUBLE_3 = "Sound/DDZ/male/33.mp3",							--男_对牌_33
	DDZ_SOUND_MALE_DOUBLE_4 = "Sound/DDZ/male/44.mp3",							--男_对牌_44
	DDZ_SOUND_MALE_DOUBLE_5 = "Sound/DDZ/male/55.mp3",							--男_对牌_55
	DDZ_SOUND_MALE_DOUBLE_6 = "Sound/DDZ/male/66.mp3",							--男_对牌_66
	DDZ_SOUND_MALE_DOUBLE_7 = "Sound/DDZ/male/77.mp3",							--男_对牌_77
	DDZ_SOUND_MALE_DOUBLE_8 = "Sound/DDZ/male/88.mp3",							--男_对牌_88
	DDZ_SOUND_MALE_DOUBLE_9 = "Sound/DDZ/male/99.mp3",							--男_对牌_99
	DDZ_SOUND_MALE_DOUBLE_10 = "Sound/DDZ/male/1010.mp3",						--男_对牌_1010
	DDZ_SOUND_MALE_DOUBLE_11 = "Sound/DDZ/male/JJ.mp3",							--男_对牌_JJ
	DDZ_SOUND_MALE_DOUBLE_12 = "Sound/DDZ/male/QQ.mp3",							--男_对牌_QQ
	DDZ_SOUND_MALE_DOUBLE_13 = "Sound/DDZ/male/KK.mp3",							--男_对牌_KK
	DDZ_SOUND_MALE_DOUBLE_14 = "Sound/DDZ/male/DaNi.mp3",							--男_对牌_小王
	DDZ_SOUND_MALE_DOUBLE_15 = "Sound/DDZ/male/DaNi.mp3",							--男_对牌_大王

	DDZ_SOUND_MALE_AAA = "Sound/DDZ/male/SanZhang.mp3",							--男_三张
	DDZ_SOUND_MALE_AAAB = "Sound/DDZ/male/3Dai1.mp3",							--男_3带1
	DDZ_SOUND_MALE_AAABB = "Sound/DDZ/male/3Dai2.mp3",							--男_3带2
	DDZ_SOUND_MALE_AAAABB = "Sound/DDZ/male/4Dai2.mp3",							--男_4带2
	DDZ_SOUND_MALE_AAABBB = "Sound/DDZ/male/FeiJi.mp3",							--男_飞机
	DDZ_SOUND_MALE_ROCKET = "Sound/DDZ/male/HuoJian.mp3",						--男_火箭
	DDZ_SOUND_MALE_AABBCC = "Sound/DDZ/male/LianDui.mp3",						--男_连对
	DDZ_SOUND_MALE_SEQUENCES = "Sound/DDZ/male/ShunZi.mp3",						--男_顺子
	DDZ_SOUND_MALE_BOMB = "Sound/DDZ/male/ZhaDan.mp3",							--男_炸弹
	
	DDZ_SOUND_MALE_NO = "Sound/DDZ/male/BuYao.mp3",								--男_不要
	DDZ_SOUND_MALE_YOU = "Sound/DDZ/male/DaNi.mp3",								--男_大你
	DDZ_SOUND_MALE_QIANG = "Sound/DDZ/male/Qiang.mp3",							--男_抢地主
	DDZ_SOUND_MALE_BUQIANG = "Sound/DDZ/male/BuQiang.mp3",						--男_不抢
	DDZ_SOUND_MALE_JIAO = "Sound/DDZ/male/Jiao.mp3",							--男_叫地主
	DDZ_SOUND_MALE_BUJIAO = "Sound/DDZ/male/BuJiao.mp3",						--男_不叫

	--女音效
	DDZ_SOUND_FEMALE_SINGLE_1 = "Sound/DDZ/female/A.mp3",						--女_单牌_A
	DDZ_SOUND_FEMALE_SINGLE_2 = "Sound/DDZ/female/2.mp3",						--女_单牌_2
	DDZ_SOUND_FEMALE_SINGLE_3 = "Sound/DDZ/female/3.mp3",						--女_单牌_3
	DDZ_SOUND_FEMALE_SINGLE_4 = "Sound/DDZ/female/4.mp3",						--女_单牌_4
	DDZ_SOUND_FEMALE_SINGLE_5 = "Sound/DDZ/female/5.mp3",						--女_单牌_5
	DDZ_SOUND_FEMALE_SINGLE_6 = "Sound/DDZ/female/6.mp3",						--女_单牌_6
	DDZ_SOUND_FEMALE_SINGLE_7 = "Sound/DDZ/female/7.mp3",						--女_单牌_7
	DDZ_SOUND_FEMALE_SINGLE_8 = "Sound/DDZ/female/8.mp3",						--女_单牌_8
	DDZ_SOUND_FEMALE_SINGLE_9 = "Sound/DDZ/female/9.mp3",						--女_单牌_9
	DDZ_SOUND_FEMALE_SINGLE_10 = "Sound/DDZ/female/10.mp3",						--女_单牌_10
	DDZ_SOUND_FEMALE_SINGLE_11 = "Sound/DDZ/female/J.mp3",						--女_单牌_11
	DDZ_SOUND_FEMALE_SINGLE_12 = "Sound/DDZ/female/Q.mp3",						--女_单牌_12
	DDZ_SOUND_FEMALE_SINGLE_13 = "Sound/DDZ/female/K.mp3",						--女_单牌_13
	DDZ_SOUND_FEMALE_SINGLE_14 = "Sound/DDZ/female/XiaoWang.mp3",				--女_小王
	DDZ_SOUND_FEMALE_SINGLE_15 = "Sound/DDZ/female/DaWang.mp3",					--女_大王

	DDZ_SOUND_FEMALE_DOUBLE_1 = "Sound/DDZ/female/AA.mp3",						--女_对牌_AA
	DDZ_SOUND_FEMALE_DOUBLE_2 = "Sound/DDZ/female/22.mp3",						--女_对牌_22
	DDZ_SOUND_FEMALE_DOUBLE_3 = "Sound/DDZ/female/33.mp3",						--女_对牌_33
	DDZ_SOUND_FEMALE_DOUBLE_4 = "Sound/DDZ/female/44.mp3",						--女_对牌_44
	DDZ_SOUND_FEMALE_DOUBLE_5 = "Sound/DDZ/female/55.mp3",						--女_对牌_55
	DDZ_SOUND_FEMALE_DOUBLE_6 = "Sound/DDZ/female/66.mp3",						--女_对牌_66
	DDZ_SOUND_FEMALE_DOUBLE_7 = "Sound/DDZ/female/77.mp3",						--女_对牌_77
	DDZ_SOUND_FEMALE_DOUBLE_8 = "Sound/DDZ/female/88.mp3",						--女_对牌_88
	DDZ_SOUND_FEMALE_DOUBLE_9 = "Sound/DDZ/female/99.mp3",						--女_对牌_99
	DDZ_SOUND_FEMALE_DOUBLE_10 = "Sound/DDZ/female/1010.mp3",					--女_对牌_1010
	DDZ_SOUND_FEMALE_DOUBLE_11 = "Sound/DDZ/female/JJ.mp3",						--女_对牌_JJ
	DDZ_SOUND_FEMALE_DOUBLE_12 = "Sound/DDZ/female/QQ.mp3",						--女_对牌_QQ
	DDZ_SOUND_FEMALE_DOUBLE_13 = "Sound/DDZ/female/KK.mp3",						--女_对牌_KK
	DDZ_SOUND_FEMALE_DOUBLE_14 = "Sound/DDZ/female/DaNi.mp3",						--女_对牌_小王
	DDZ_SOUND_FEMALE_DOUBLE_15 = "Sound/DDZ/female/DaNi.mp3",						--女_对牌_大王

	DDZ_SOUND_FEMALE_AAA = "Sound/DDZ/female/SanZhang.mp3",						--女_三张
	DDZ_SOUND_FEMALE_AAAB = "Sound/DDZ/female/3Dai1.mp3",						--女_3带1
	DDZ_SOUND_FEMALE_AAABB = "Sound/DDZ/female/3Dai2.mp3",						--女_3带2
	DDZ_SOUND_FEMALE_AAAABB = "Sound/DDZ/female/4Dai2.mp3",						--女_4带2
	DDZ_SOUND_FEMALE_AAABBB = "Sound/DDZ/female/FeiJi.mp3",						--女_飞机
	DDZ_SOUND_FEMALE_ROCKET = "Sound/DDZ/female/HuoJian.mp3",					--女_火箭
	DDZ_SOUND_FEMALE_AABBCC = "Sound/DDZ/female/LianDui.mp3",					--女_连对
	DDZ_SOUND_FEMALE_SEQUENCES = "Sound/DDZ/female/ShunZi.mp3",					--女_顺子
	DDZ_SOUND_FEMALE_BOMB = "Sound/DDZ/female/ZhaDan.mp3",						--女_炸弹

	DDZ_SOUND_FEMALE_NO = "Sound/DDZ/female/BuYao.mp3",							--女_不要
	DDZ_SOUND_FEMALE_YOU = "Sound/DDZ/female/DaNi.mp3",							--女_大你
	DDZ_SOUND_FEMALE_QIANG = "Sound/DDZ/female/Qiang.mp3",						--女_抢地主
	DDZ_SOUND_FEMALE_BUQIANG = "Sound/DDZ/female/BuQiang.mp3",					--女_不抢
	DDZ_SOUND_FEMALE_JIAO = "Sound/DDZ/female/Jiao.mp3",						--女_叫地主
	DDZ_SOUND_FEMALE_BUJIAO = "Sound/DDZ/female/BuJiao.mp3",					--女_不叫
}

local audioEnabled = true   --是否开启了音乐播放

-- start --

--------------------------------
-- 预加载斗地主所有音乐资源
-- @function preloadAllSound

-- end --
function DDZ_Audio.preloadAllSound()
	for k,v in ipairs(DDZ_Audio.preloadResPath) do
		audio.preloadSound(v)
	end
end

function DDZ_Audio.setState(_audioEnabled)
	audioEnabled = _audioEnabled
end
-- start --

--------------------------------
-- 卸载斗地主所有音乐资源
-- @function preloadAllSound

-- end --
function DDZ_Audio.unloadAllSound()
	for k,v in ipairs(DDZ_Audio.preloadResPath) do
		audio.unloadSound(v)
	end
end

-- start --

--------------------------------
-- 播放音效
-- @function playSoundWithPath
-- @param path     播放资源路径

-- end --

function DDZ_Audio.playSoundWithPath(path,loob)
	if audioEnabled then
		print("path::::",path)
		audio.playSound(path,loob)
	end
end

local DaoJiShiSoundHand = nil   --倒计时音效句柄

-- start --

--------------------------------
-- 播放倒计时音效
-- @function playDaoJiShiSound

-- end --
function DDZ_Audio.playDaoJiShiSound()
	if audioEnabled then
		if not DaoJiShiSoundHand then
			print("播放倒计时音效")
			DaoJiShiSoundHand = audio.playSound(DDZ_Audio.preloadResPath.DDZ_SOUND_TIMEOUT,true)
		end
	end
end

-- start --

--------------------------------
-- 停止倒计时音效
-- @function playSoundWithPath

-- end --
function DDZ_Audio.stopDaoJiShiSound()
	if audioEnabled then
		if DaoJiShiSoundHand then
			audio.stopSound(DaoJiShiSoundHand)
			DaoJiShiSoundHand = nil
		end
	end
end


return DDZ_Audio