--
-- Author: peter
-- Date: 2017-04-20 18:06:12
--

local WRNN_Const = {}

WRNN_Const.MAX_PLAYER_NUMBER = 6  --最大游戏人数

WRNN_Const.REQUEST_INFO_00 = "给框架发送 <<准备>> 请求"
WRNN_Const.REQUEST_INFO_01 = "给框架发送 <<退出游戏>> 请求"
WRNN_Const.REQUEST_INFO_02 = "给服务器发送 <<抢庄>> 请求"
WRNN_Const.REQUEST_INFO_03 = "给服务器发送 <<不抢庄>> 请求"
WRNN_Const.REQUEST_INFO_04 = "给服务器发送 <<下注>> 请求"
WRNN_Const.REQUEST_INFO_05 = "给框架发送 <<旁观坐下>> 请求"

--WRNN_Const.Game_INFO_00 = "下注超限请重新选择下注金额" 
WRNN_Const.Game_INFO_00 = "本局最大下注金额已满" 
WRNN_Const.Game_INFO_01 = "等待其他玩家押注"
WRNN_Const.Game_INFO_02 = "请在投注区域投注"
WRNN_Const.Game_INFO_03 = "下注金额最大限制为500万"
WRNN_Const.Game_INFO_04 = "个人最大下注金额已满"
WRNN_Const.Game_INFO_05 = "本局下注已满，提前开牌"

WRNN_Const.DOUBLE_RULE_1 = "牛牛x3 牛九x2 牛八x2"
WRNN_Const.DOUBLE_RULE_2 = "牛牛x4 牛九x3 牛八x2 牛七x2"


WRNN_Const.PATH = {
	-- btn image file path
	BTN_SOUND_NORMAL = 'Image/WRNN/button/btn_sound_normal.png',
	BTN_SOUND_PRESSED = 'Image/WRNN/button/btn_sound_selected.png',
	BTN_MUTE_NORMAL = 'Image/WRNN/button/btn_mute_normal.png',
	BTN_MUTE_PRESSED = 'Image/WRNN/button/btn_mute_selected.png',
	BTN_CCDOWN_NORMAL = 'Image/WRNN/button/btn_ccdown_norma.png',
	BTN_CCUP_NORMAL = 'Image/WRNN/button/btn_ccup_norma.png',

	BTN_COIN = 'Image/WRNN/gameui/gold.png',

	-- imgs packed file path
	IMGS_CARD = 'Image/WRNN/card/img_card.png',

	-- img image file path
	IMG_WIDTH_COUNTDOWN_BG = 'Image/WRNN/gameui/img_width_countDown_BG.png',
	IMG_HEIGHT_COUNTDOWN_BG = 'Image/WRNN/gameui/img_height_countDown_BG.png',
	IMG_BANKER = 'Image/WRNN/gameui/img_Zhuang.png',
	IMG_WIDTH_BANKER_BG = 'Image/WRNN/gameui/img_zhuang_frame_width.png',
	IMG_HEIGHT_BANKER_BG = 'Image/WRNN/gameui/img_zhuang_frame_width.png',
	IMG_CHIP_1000 = 'Image/WRNN/gameui/img_jetton_1.png',
	IMG_CHIP_10000 = 'Image/WRNN/gameui/img_jetton_2.png',
	IMG_CHIP_100000 = 'Image/WRNN/gameui/img_jetton_3.png',
	IMG_CHIP_500000 = 'Image/WRNN/gameui/img_jetton_4.png',
	IMG_CHIP_1000000 = 'Image/WRNN/gameui/img_jetton_5.png',
	IMG_CHIP_5000000 = 'Image/WRNN/gameui/img_jetton_6.png',
	IMG_CARD_TYPE_BG = 'Image/WRNN/gameui/img_CardType_GB.png',
	IMG_RESULT_WIN = 'Image/WRNN/gameresult/img_GAME_RESULT_WIN.png',
	IMG_RESULT_LOSE = 'Image/WRNN/gameresult/img_GAME_RESULT_LOSE.png',
	IMG_RESULT_FLAT = 'Image/WRNN/gameresult/img_GAME_RESULT_FLAT.png',
	IMG_RESULT_YELLOW_BG = 'Image/WRNN/gameresult/img_results_farme_huang.png',
	IMG_RESULT_BLUE_BG = 'Image/WRNN/gameresult/img_results_farme_lan.png',

	-- tx image file path
	TX_GAME_TIME_NUMBER = 'Image/WRNN/gameui/ta_GameUI_Time_Number.png',
	TX_CARD_TYPE_BG = 'Image/WRNN/gameui/img_CardType_GB.png',
	TX_CARD_TYPE_NO = 'Image/WRNN/gameui/img_CardType_No.png',
	TX_CARD_TYPE_0 = 'Image/WRNN/gameui/img_CardType_0.png',
	TX_CARD_TYPE_1 = 'Image/WRNN/gameui/img_CardType_1.png',
	TX_CARD_TYPE_2 = 'Image/WRNN/gameui/img_CardType_2.png',
	TX_CARD_TYPE_3 = 'Image/WRNN/gameui/img_CardType_3.png',
	TX_CARD_TYPE_4 = 'Image/WRNN/gameui/img_CardType_4.png',
	TX_CARD_TYPE_5 = 'Image/WRNN/gameui/img_CardType_5.png',
	TX_CARD_TYPE_6 = 'Image/WRNN/gameui/img_CardType_6.png',
	TX_CARD_TYPE_7 = 'Image/WRNN/gameui/img_CardType_7.png',
	TX_CARD_TYPE_8 = 'Image/WRNN/gameui/img_CardType_8.png',
	TX_CARD_TYPE_9 = 'Image/WRNN/gameui/img_CardType_9.png',
	TX_CARD_TYPE_10 = 'Image/WRNN/gameui/img_CardType_10.png',
	TX_CARD_TYPE_11 = 'Image/WRNN/gameui/img_CardType_11.png',
	TX_CARD_TYPE_12 = 'Image/WRNN/gameui/img_CardType_12.png',
	TX_CARD_TYPE_13 = 'Image/WRNN/gameui/img_CardType_13.png',
	TX_GAME_UI_BUQING = 'Image/WRNN/gameui/tx_GameUI_BuQiang.png',
	TX_GAME_UI_QIANG = 'Image/WRNN/gameui/tx_GameUI_Qiang.png',

}

return WRNN_Const