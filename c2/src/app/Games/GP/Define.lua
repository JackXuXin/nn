local define = {}

define.cardWidth = 129.05       --牌宽
define.cardHeight = 178         --牌高
define.cardWidthDistance = 52   --牌宽的间距
define.cardHeightDistance = 13  --牌高的间距
define.cardLuTouDistance = 12   --牌露头距离
define.cardSelectColor = cc.c3b(130,130,130)   --牌被选中的颜色
define.cardReleaseColor = cc.c3b(255,255,255)   --牌被释放的颜色

--牌型
define.SINGLE_CARD    = 1  --单牌
define.DOUBLE_CARD    = 2  --对子
define.THREE_CARD     = 3  --三不带
define.THREE_TWO_CARD = 4  --三带二 俘虏
define.COMPANY_CARD   = 5  --连对
define.AIRCARFT_CARD  = 6  --三连
define.CONNECT_CARD   = 7  --顺子
define.BOMB_CARD      = 8  --炸弹
define.ERROR_CARD     = 9  --错误的牌型

define.SendCardAciontTime = 3    --发牌动画时间

return define