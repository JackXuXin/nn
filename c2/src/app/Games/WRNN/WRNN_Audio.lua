--
-- Author: peter
-- Date: 2017-05-08 11:33:09
--

local WRNN_Audio = {}

--gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.SRDDZ_SOUND_FEMALE_NO)
WRNN_Audio.preloadResPath = {			--预加载资源的路径
	WRNN_SOUND_BET = "Sound/WRNN/WRNN_bet.mp3",       								--下注筹码落地
	WRNN_SOUND_GOLD_RESULTS = "Sound/WRNN/WRNN_goldResults.mp3", 					--结算收筹码
	WRNN_SOUND_LOSE = "Sound/WRNN/WRNN_lose.mp3", 									--结算输
	WRNN_SOUND_WIN = "Sound/WRNN/WRNN_win.mp3", 									--结算赢
	WRNN_SOUND_SEND_CARD = "Sound/WRNN/WRNN_sendCard.mp3",							--发牌
	WRNN_SOUND_SEND_CARD_END = "Sound/WRNN/WRNN_sendCardEnd.mp3",					--发牌落地
	WRNN_SOUND_TOUCH = "Sound/WRNN/WRNN_touch.mp3",									--点击按钮
	WRNN_SOUND_DINGDING = "Sound/WRNN/WRNN_dingding.mp3",							--下注提醒
	WRNN_SOUND_countdown = "Sound/WRNN/WRNN_countdown.mp3",							--倒计时提醒
	

	

	

	--男音效		
	WRNN_SOUND_MALE_NIU_0 = "Sound/WRNN/male/WRNN_niu0.mp3",						--男_无牛
	WRNN_SOUND_MALE_NIU_1 = "Sound/WRNN/male/WRNN_niu1.mp3",						--男_牛1
	WRNN_SOUND_MALE_NIU_2 = "Sound/WRNN/male/WRNN_niu2.mp3",						--男_牛2
	WRNN_SOUND_MALE_NIU_3 = "Sound/WRNN/male/WRNN_niu3.mp3",						--男_牛3
	WRNN_SOUND_MALE_NIU_4 = "Sound/WRNN/male/WRNN_niu4.mp3",						--男_牛4
	WRNN_SOUND_MALE_NIU_5 = "Sound/WRNN/male/WRNN_niu5.mp3",						--男_牛5
	WRNN_SOUND_MALE_NIU_6 = "Sound/WRNN/male/WRNN_niu6.mp3",						--男_牛6
	WRNN_SOUND_MALE_NIU_7 = "Sound/WRNN/male/WRNN_niu7.mp3",						--男_牛7
	WRNN_SOUND_MALE_NIU_8 = "Sound/WRNN/male/WRNN_niu8.mp3",						--男_牛8
	WRNN_SOUND_MALE_NIU_9 = "Sound/WRNN/male/WRNN_niu9.mp3",						--男_牛9
	WRNN_SOUND_MALE_NIU_10 = "Sound/WRNN/male/WRNN_niu10.mp3",						--男_牛10
	WRNN_SOUND_MALE_NIU_11 = "Sound/WRNN/male/WRNN_niu11.mp3",						--男_牛11
	WRNN_SOUND_MALE_NIU_12 = "Sound/WRNN/male/WRNN_niu12.mp3",						--男_牛12
	WRNN_SOUND_MALE_NIU_13 = "Sound/WRNN/male/WRNN_niu13.mp3",						--男_牛13
	WRNN_SOUND_MALE_NIU_14 = "Sound/WRNN/male/WRNN_niu10.mp3",						--男_炸弹牛

	--女音效
	WRNN_SOUND_FEMALE_NIU_0 = "Sound/WRNN/female/WRNN_niu0.mp3",					--女_无牛
	WRNN_SOUND_FEMALE_NIU_1 = "Sound/WRNN/female/WRNN_niu1.mp3",					--女_牛1
	WRNN_SOUND_FEMALE_NIU_2 = "Sound/WRNN/female/WRNN_niu2.mp3",					--女_牛2
	WRNN_SOUND_FEMALE_NIU_3 = "Sound/WRNN/female/WRNN_niu3.mp3",					--女_牛3
	WRNN_SOUND_FEMALE_NIU_4 = "Sound/WRNN/female/WRNN_niu4.mp3",					--女_牛4
	WRNN_SOUND_FEMALE_NIU_5 = "Sound/WRNN/female/WRNN_niu5.mp3",					--女_牛5
	WRNN_SOUND_FEMALE_NIU_6 = "Sound/WRNN/female/WRNN_niu6.mp3",					--女_牛6
	WRNN_SOUND_FEMALE_NIU_7 = "Sound/WRNN/female/WRNN_niu7.mp3",					--女_牛7
	WRNN_SOUND_FEMALE_NIU_8 = "Sound/WRNN/female/WRNN_niu8.mp3",					--女_牛8
	WRNN_SOUND_FEMALE_NIU_9 = "Sound/WRNN/female/WRNN_niu9.mp3",					--女_牛9
	WRNN_SOUND_FEMALE_NIU_10 = "Sound/WRNN/female/WRNN_niu10.mp3",					--女_牛10
	WRNN_SOUND_FEMALE_NIU_11 = "Sound/WRNN/female/WRNN_niu11.mp3",					--女_牛11
	WRNN_SOUND_FEMALE_NIU_12 = "Sound/WRNN/female/WRNN_niu12.mp3",					--女_牛12
	WRNN_SOUND_FEMALE_NIU_13 = "Sound/WRNN/female/WRNN_niu13.mp3",					--女_牛13
	WRNN_SOUND_MALE_NIU_14 = "Sound/WRNN/male/WRNN_niu10.mp3",						--女_炸弹牛
}

function WRNN_Audio:init()
	--预加载所有音乐资源
	for k,v in ipairs(WRNN_Audio.preloadResPath) do
		audio.preloadSound(v)
	end
end

function WRNN_Audio:clear()
	-- 卸载所有音乐资源
	for k,v in ipairs(WRNN_Audio.preloadResPath) do
		audio.unloadSound(v)
	end
end

--[[
	* 播放音效
	* @function playSoundWithPath
	* @param path     播放资源路径
--]]
function WRNN_Audio.playSoundWithPath(path,loob)
	if app.constant.voiceOn then
		audio.playSound(path,loob)
	end
end

return WRNN_Audio