--
-- Author: K
-- Date: 2016-12-27 11:20:21
-- 常量
--

local DDZ_Const = {}

DDZ_Const.CARD_WIDTH = 117        					--牌宽
DDZ_Const.CATD_HEIGHT = 161          					--牌高
DDZ_Const.CARD_WIDTH_DISTANCE = 30   					--牌宽的间距
DDZ_Const.CARD_HEIGHT_DISTANCE = 24  					--牌高的间距
DDZ_Const.CARD_LUTOU_DISTANCE = 12   					--牌露头距离
DDZ_Const.CARD_SELECT_COLOR = cc.c3b(130,130,130)    	--牌被选中的颜色
DDZ_Const.CARD_RELEASE_COLOR = cc.c3b(255,255,255)   	--牌被释放的颜色

DDZ_Const.GAME_MAX_PLAYER = 3  							--游戏最大人数
DDZ_Const.GAME_MAX_HIERARCHY = 10000  					--游戏最大层级

DDZ_Const.REQUEST_INFO_00 = "给服务器发送了 抢地主 请求"
DDZ_Const.REQUEST_INFO_02 = "给服务器发送了 不抢地主 请求"
DDZ_Const.REQUEST_INFO_03 = "给服务器发送了 取消托管 请求"
DDZ_Const.REQUEST_INFO_04 = "给服务器发送了 出牌 请求"
DDZ_Const.REQUEST_INFO_05 = "给服务器发送了 不出牌 请求"

return DDZ_Const