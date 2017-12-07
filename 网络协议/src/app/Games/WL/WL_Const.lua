--
-- Author: peter
-- Date: 2017-03-10 11:32:11
--

local WL_Const = {}

WL_Const.MAX_PLAYER_NUMBER = 4  --最大游戏人数

WL_Const.REQUEST_INFO_00 = "给框架发送 <<准备>> 请求"
WL_Const.REQUEST_INFO_01 = "给框架发送 <<退出游戏>> 请求"
WL_Const.REQUEST_INFO_02 = "给服务器发送 <<叫分>> 请求"
WL_Const.REQUEST_INFO_03 = "给服务器发送 <<不出>> 请求"
WL_Const.REQUEST_INFO_04 = "给服务器发送 <<出牌>> 请求"
WL_Const.REQUEST_INFO_05 = "给服务器发送 <<要不起>> 请求"
WL_Const.REQUEST_INFO_06 = "给服务器发送 <<取消托管>> 请求"

WL_Const.CARD_WIDTH = 117        						--牌宽
WL_Const.CATD_HEIGHT = 161          					--牌高
WL_Const.CARD_WIDTH_DISTANCE = 37   					--牌宽的间距
WL_Const.CARD_HEIGHT_DISTANCE = 55  					--牌高的间距
WL_Const.CARD_LUTOU_DISTANCE = 12   					--牌露头距离
WL_Const.CARD_SELECT_COLOR = cc.c3b(130,130,130)    	--牌被选中的颜色
WL_Const.CARD_RELEASE_COLOR = cc.c3b(255,255,255)   	--牌被释放的颜色

WL_Const.CARD_SCALE = 0.47   							--其他玩家的牌缩放系数

WL_Const.PATH = {
	-- btn image file path
	BTN_SOUND_NORMAL = 'Image/WL/button/button_sound_normal.png',
	BTN_SOUND_PRESSED = 'Image/WL/button/button_sound_selected.png',
	BTN_MUTE_NORMAL = 'Image/WL/button/button_mute_normal.png',
	BTN_MUTE_PRESSED = 'Image/WL/button/button_mute_selected.png',
	BTN_CCDOWN_NORMAL = 'Image/WL/button/button_ccdown_norma.png',
	BTN_CCUP_NORMAL = 'Image/WL/button/button_ccup_norma.png',

	-- imgs packed file path
	IMGS_CARD = 'Image/WL/card/img_card.png',

	-- img image file path
	IMG_TOUR_NUM_1 = 'Image/WL/gameui/img_YouNum_1.png',
	IMG_TOUR_NUM_2 = 'Image/WL/gameui/img_YouNum_2.png',
	IMG_TOUR_NUM_3 = 'Image/WL/gameui/img_YouNum_3.png',
	IMG_RANKING_1 = 'Image/WL/gameui/img_PaiMIng_1.png',
	IMG_RANKING_2 = 'Image/WL/gameui/img_PaiMIng_2.png',
	IMG_RANKING_3 = 'Image/WL/gameui/img_PaiMIng_3.png',
	IMG_RANKING_4 = 'Image/WL/gameui/img_PaiMIng_4.png',

	-- tx image file path
	TX_PASS = 'Image/WL/gameui/tx_YaoBuQi.png',
	TX_SCORE = 'Image/WL/gameui/tx_num_01.png',
	TX_CARD_NUM = 'Image/WL/gameui/tx_num_03.png',

}

return WL_Const