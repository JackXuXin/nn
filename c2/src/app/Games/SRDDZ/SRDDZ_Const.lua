--
-- Author: peter
-- Date: 2017-02-17 13:12:31
--

local SRDDZ_Const = {}

SRDDZ_Const.MAX_PLAYER_NUMBER = 4  --最大游戏人数

SRDDZ_Const.REQUEST_INFO_00 = "给框架发送 <<准备>> 请求"
SRDDZ_Const.REQUEST_INFO_01 = "给框架发送 <<退出游戏>> 请求"
SRDDZ_Const.REQUEST_INFO_02 = "给服务器发送 <<叫分>> 请求"
SRDDZ_Const.REQUEST_INFO_03 = "给服务器发送 <<不出>> 请求"
SRDDZ_Const.REQUEST_INFO_04 = "给服务器发送 <<出牌>> 请求"
SRDDZ_Const.REQUEST_INFO_05 = "给服务器发送 <<要不起>> 请求"
SRDDZ_Const.REQUEST_INFO_06 = "给服务器发送 <<取消托管>> 请求"

SRDDZ_Const.CARD_WIDTH = 117        					--牌宽
SRDDZ_Const.CATD_HEIGHT = 161          					--牌高
SRDDZ_Const.CARD_WIDTH_DISTANCE = 36   					--牌宽的间距
SRDDZ_Const.CARD_HEIGHT_DISTANCE = 55  					--牌高的间距
SRDDZ_Const.CARD_LUTOU_DISTANCE = 12   					--牌露头距离
SRDDZ_Const.CARD_SELECT_COLOR = cc.c3b(130,130,130)    	--牌被选中的颜色
SRDDZ_Const.CARD_RELEASE_COLOR = cc.c3b(255,255,255)   	--牌被释放的颜色

SRDDZ_Const.CARD_SCALE = 0.47   						--其他玩家的牌缩放系数

SRDDZ_Const.PATH = {
	-- btn image file path
	BTN_SOUND_NORMAL = 'Image/SRDDZ/button/button_sound_normal.png',
	BTN_SOUND_PRESSED = 'Image/SRDDZ/button/button_sound_selected.png',
	BTN_MUTE_NORMAL = 'Image/SRDDZ/button/button_mute_normal.png',
	BTN_MUTE_PRESSED = 'Image/SRDDZ/button/button_mute_selected.png',
	BTN_CCDOWN_NORMAL = 'Image/SRDDZ/button/button_ccdown_norma.png',
	BTN_CCUP_NORMAL = 'Image/SRDDZ/button/button_ccup_norma.png',

	-- tx image file path
	TX_SCORE_0 = 'Image/SRDDZ/gameui/tx_GamePlay_BuYao_Action.png',
	TX_SCORE_1 = 'Image/SRDDZ/gameui/tx_GamePlay_One_Action.png',
	TX_SCORE_2 = 'Image/SRDDZ/gameui/tx_GamePlay_Two_zhcn_Action.png',
	TX_SCORE_3 = 'Image/SRDDZ/gameui/tx_GamePlay_Three_Action.png',
	TX_HOWEVER = 'Image/SRDDZ/gameui/tx_CardNo.png',
	TX_PASS = 'Image/SRDDZ/gameui/tx_GamePlay_Pass_Action.png',

	-- imgs packed file path
	IMGS_CARD = 'Image/SRDDZ/card/img_card.png',
	IMG_RESULT_WIN = 'Image/SRDDZ/gameresult/img_GAME_RESULT_WIN.png',
	IMG_RESULT_LOSE = 'Image/SRDDZ/gameresult/img_GAME_RESULT_LOSE.png',

	-- img file path
	IMG_LANDLORD_IDENTITY = 'Image/SRDDZ/gameui/img_DiZhu.png',
	IMG_LANDLORD_Mark = 'Image/SRDDZ/gameui/img_DiZhuMark.png',

	-- sound 
}

return SRDDZ_Const