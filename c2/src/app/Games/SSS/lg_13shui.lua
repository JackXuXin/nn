
local logic = {}



local DEBUG_TEST			= nil
local IN_SHX = true


--------------------------------------------------------
------------------------变量定义------------------------
--------------------------------------------------------

--52张 16进制,花色为前面的值，牌值为后面的
local totalcard_set = {
  {
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,   --方块1，，，方块K
    0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,   --梅花1，，，梅花K
    0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,   --红心1，，，红心K
    0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,   --黑桃1，，，黑桃K
  },
  {
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,   --方块1，，，方块K
    0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,   --梅花1，，，梅花K
    0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,   --红心1，，，红心K
    0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,   --黑桃1，，，黑桃K
    0x01,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,        --方块1，方块3，，方块K
  },
  {
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,   --方块1，，，方块K
    0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,   --梅花1，，，梅花K
    0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,   --红心1，，，红心K
    0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,   --黑桃1，，，黑桃K
    0x4F,
  },
  {
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,   --方块1，，，方块K
    0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,   --梅花1，，，梅花K
    0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,   --红心1，，，红心K
    0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,   --黑桃1，，，黑桃K
    0x4F,0x4F,
  },
  {
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,   --方块1，，，方块K
    0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,   --梅花1，，，梅花K
    0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,   --红心1，，，红心K
    0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,   --黑桃1，，，黑桃K
    0x4F,0x4F,0x4F,0x4F,
  },

}
--[[
local totalcard =
{
	0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,		--方块1，，，方块K
	0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,		--梅花1，，，梅花K
	0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,		--红心1，，，红心K
	0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,		--黑桃1，，，黑桃K
}
--64张牌，增加方块3-方块A
local totalcardex = 
{
  0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,   --方块1，，，方块K
  0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,   --梅花1，，，梅花K
  0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,   --红心1，，，红心K
  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,   --黑桃1，，，黑桃K
  0x01,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,        --方块1，方块3，，方块K
}
--]]
CARD_TYPE =
{
    --普通牌型[10个]
    CARD_TYPE_NULL                            = 0,     --无效牌型

    CARD_TYPE_SAN_PAI                         = 1,     --散牌
    CARD_TYPE_DUI_ZI                          = 2,     --对子
    CARD_TYPE_2_DUI                           = 3,     --两对

    CARD_TYPE_3_TIAO                          = 4,     --三条
    CARD_TYPE_SHUN_ZI                         = 5,     --顺子
    CARD_TYPE_TONG_HUA                        = 6,     --同花

    CARD_TYPE_HU_LU                           = 7,     --葫芦
    CARD_TYPE_4_TIAO                          = 8,     --四条
    CARD_TYPE_TONG_HUA_SHUN                   = 9,     --同花顺
    CARD_TYPE_BOMB                            = 10,    --炸弹

    --13张,整手牌牌型[14个]
    CARD_TYPE_SPECIAL_QING_LONG	            = 0x20,  --青龙：同花且A到K
    CARD_TYPE_SPECIAL_QUAN_HONG	            = 0x22,  --全红：13张红色（方块、红桃）的牌
    CARD_TYPE_SPECIAL_QUAN_HEI	            = 0x24,  --全黑：13张黑色（梅花、黑桃）的牌

    CARD_TYPE_SPECIAL_QUAN_HONG_1_DIAN_HEI	= 0x26,  --全红一点黑：即是13张有12张是红的1张是黑的
    CARD_TYPE_SPECIAL_QUAN_HEI_1_DIAN_HONG	= 0x28,  --全黑一点红：即是13张有12张是黑的1张是红的
    CARD_TYPE_SPECIAL_1_TIAO_LONG	        = 0x2A,  --一条龙：A到K

    CARD_TYPE_SPECIAL_5_DUI_1_KE	        = 0x2C,  --5对一刻：5组对子，一个三条
    CARD_TYPE_SPECIAL_QUAN_XIAO	            = 0x2E,  --全小：2到10
    CARD_TYPE_SPECIAL_QUAN_DA               = 0x30,  --全大：6到K

    CARD_TYPE_SPECIAL_6_DUI_BAN             = 0x32,  --6对半：6组对子，一张单牌
    CARD_TYPE_SPECIAL_BAN_XIAO	            = 0x34,  --半小：A到10
    CARD_TYPE_SPECIAL_BAN_DA                = 0x36,  --半大：6到A

    CARD_TYPE_SPECIAL_3_HUA                 = 0x38,  --三花：3道都是同花
    CARD_TYPE_SPECIAL_3_SHUN                = 0x3A,  --三顺：3道都是顺子
}


--
local TOTAL_CARD_CNT		    = 52

PLAYER_CARD_CNT		            = 13


--花色范围
local MIN_CARD_COLOR      	    = 0x00
local MAX_CARD_COLOR      	    = 0x04

--牌值范围
local MIN_CARD_VALUE     	    = 0x01
local MAX_CARD_VALUE       	    = 0x0F
local MAX_CARD_LOGIC_VALUE      = 0x0F


--记录A作为逻辑值0x0E个数,可能在4个A中有1个作为逻辑0x0E做顺子使用
logic.logic_a_cnt = 0

--牌型
local my_card_type          = {}
local my_special_card_type  = {}
--比较牌
local my_compare_card       = {}
--提取牌
local my_extract_card   =    {}


--------------------------------------------------------
------------------------函数定义------------------------
--------------------------------------------------------


--花色
function logic.get_card_color(card)
    local color = math.floor(card/16)
    if(color>MAX_CARD_COLOR or color<MIN_CARD_COLOR) then assert(false) end
    return color ~= 4 and color or -1
end

--牌值
function logic.get_card_value(card)
    local value = card%16
    if(value>MAX_CARD_VALUE or value<MIN_CARD_VALUE) then assert(false) end
    return value
end

--牌逻辑值(0x01 --> 0x0E),其他还是以前的值
function logic.get_card_logic_value(card)
    local value = card%16
    if(value == 0x01) then return 0x0E end

    --print("value : " .. value)
    if(value>MAX_CARD_VALUE or value<MIN_CARD_VALUE) then assert(false) end
    return value
end

local JOKER_CARD = 0x4F
local function is_joker_card(card)
  return card == JOKER_CARD
end

local function extract_jokers(cards)
  local ret_cards = {}
  local joker_num = 0
  for _, card in pairs(cards) do
    if not is_joker_card(card) then
      table.insert(ret_cards, card)
    else
      joker_num = joker_num + 1
    end
  end
  
  return ret_cards, joker_num
end

function logic.check_3_dao_card_type(after_cards)

    local ok = false
    local card_type = {}

    if(type(after_cards) ~= "table") then return ok,card_type end
    if(#after_cards ~= PLAYER_CARD_CNT) then return ok,card_type end

    local cards = {}
    for i=1,3 do
        cards[i] = {}
    end

    cards[1] = logic.copy_table_part(after_cards, 1, 3)
    cards[2] = logic.copy_table_part(after_cards, 4, 5)
    cards[3] = logic.copy_table_part(after_cards, 9, 5)

    for i=1,3 do
        --logic.debug_print_table(cards[i], true)
        card_type[i] = logic.get_card_type(cards[i])
    end

    if(logic.compare_cards(cards[1], cards[2]) > 0) then return false,card_type end

	--logic.debug_print_table(cards[1], true)
	--logic.debug_print_table(cards[2], true)
	--logic.debug_print_table(cards[3], true)

    if(logic.compare_cards(cards[2], cards[3]) > 0) then return false,card_type end

    return true,card_type
end

--特殊牌型排序
function logic.sort_special_card(total_card_)

    local tmp_total_card_ = logic.copy_table(total_card_)
    local out_card_ = {}
    local out_card_type = nil

    if(type(tmp_total_card_) ~= "table") then assert(false); return out_card_,out_card_type end
    if(#tmp_total_card_ ~= PLAYER_CARD_CNT) then assert(false); return out_card_,out_card_type end
    if(logic.is_special_card_type(tmp_total_card_) == false) then return out_card_,out_card_type end

    local card_type = logic.get_card_type(tmp_total_card_)
    if(logic.is_special_card_type(tmp_total_card_) == false) then
        return out_card_,out_card_type
    end

    --牌型
    out_card_type = card_type
    print(string.format("\r\nlogic.sort_special_card(),牌型:0x%02X", card_type))

    if(card_type == CARD_TYPE.CARD_TYPE_SPECIAL_3_HUA) then
        
        --print(string.format("\r\nlogic.sort_special_card(),牌型:3花"))

        local cards = {}

        for dao_index=3,1,-1 do

            local index = 1+#cards
            cards[index] = {}

            if(dao_index == 1) then
                cards[index] = logic.copy_table(tmp_total_card_)
            else
                cards[index] = my_extract_card.card_type_tong_hua(tmp_total_card_,dao_index)

                local new_tmp_total_card_ = logic.delete_cards(tmp_total_card_, cards[index])
                tmp_total_card_ = logic.copy_table(new_tmp_total_card_)
            end

            --print(string.format("\r\nlogic.sort_special_card(),提取成功,道数:%d,牌张数:%d",dao_index,#cards[index]))
            --logic.debug_print_table(cards[index], true)

            --print(string.format("\r\nlogic.sort_special_card(),道数:%d,牌张数:%d,剩余的牌",dao_index,#tmp_total_card_))
            --logic.debug_print_table(tmp_total_card_, true)
        end

        for index=3,1,-1 do

            for k,v in ipairs(cards[index]) do
                out_card_[1+#out_card_] = cards[index][k]
            end
        end

        --print(string.format("\r\nlogic.sort_special_card()牌张数:%d,输出的牌:",#out_card_))
        --logic.debug_print_table(out_card_, true)

    elseif(card_type == CARD_TYPE.CARD_TYPE_SPECIAL_3_SHUN) then
        
        print(string.format("\r\nlogic.sort_special_card(),牌型:3顺"))

        local is_ok,order_card_  = my_special_card_type.is_special_card_type_3_shun(tmp_total_card_)
        --print(string.format("\r\nlogic.sort_special_card(),返回:is_ok:%s,#order_card_:%s,", tostring(is_ok),#order_card_))
        --logic.debug_print_table(order_card_, true)

        if(logic.is_equal_table(order_card_, tmp_total_card_) == false) then
            assert(false);
        end

        for k,v in ipairs(order_card_) do
            out_card_[1+#out_card_] = v
        end

        --print(string.format("\r\nlogic.sort_special_card(),牌张数:%d,输出的牌:",#out_card_))
        --logic.debug_print_table(out_card_, true)

    else
        out_card_ = logic.copy_table(tmp_total_card_)
        table.sort(out_card_, sort_table_logic_value_asc)
    end

    assert(#out_card_ == PLAYER_CARD_CNT)
    return out_card_,out_card_type
end

--牌型排序
function logic.sort_card_type(total_card_)

    local tmp_total_card_ =  logic.copy_table(total_card_)

    local out_total_card_ = {}

    if(type(tmp_total_card_) ~= "table") then return tmp_total_card_ end
    if(#tmp_total_card_~=3 and #tmp_total_card_~=5) then return tmp_total_card_ end

    local card_type = logic.get_card_type(tmp_total_card_)
    local card_type_txt = logic.get_card_type_txt(card_type)

    print(string.format("\r\nlogic.sor_card_type(),牌型:%s,",card_type_txt))

    --按逻辑值大小排序
    if(card_type==CARD_TYPE.CARD_TYPE_SAN_PAI or card_type==CARD_TYPE.CARD_TYPE_TONG_HUA) then

        out_total_card_ = logic.copy_table(tmp_total_card_)
        table.sort(out_total_card_, sort_table_logic_value_desc)
        return out_total_card_

    --对子
    elseif(card_type == CARD_TYPE.CARD_TYPE_DUI_ZI) then

        --单牌排序
        local single_card_ = {}

        for k,v in ipairs(tmp_total_card_) do

            local value = logic.get_card_value(v)
            if(logic.find_value_cnt(tmp_total_card_, value) == 1) then
                single_card_[#single_card_+1] = v
            end

        end

        table.sort(single_card_, sort_table_logic_value_desc)

        --对子
        local dui_zi_card_ = {}

        dui_zi_card_ = logic.delete_cards(tmp_total_card_, single_card_)
        table.sort(dui_zi_card_, sort_table_logic_value_desc)

        --组合在一起
        for i=1,#dui_zi_card_ do
            out_total_card_[#out_total_card_+1] = dui_zi_card_[i]
        end

        for i=1,#single_card_ do
            out_total_card_[#out_total_card_+1] = single_card_[i]
        end

        return out_total_card_

    --两对
    elseif(card_type == CARD_TYPE.CARD_TYPE_2_DUI) then

        --单牌排序
        local single_card_ = {}

        for k,v in ipairs(tmp_total_card_) do

            local value = logic.get_card_value(v)
            if(logic.find_value_cnt(tmp_total_card_, value) == 1) then
                single_card_[#single_card_+1] = v
            end

        end

        table.sort(single_card_, sort_table_logic_value_desc)

        --对牌排序
        local dui_card_ = {}

        dui_card_ = logic.delete_cards(tmp_total_card_, single_card_)
        table.sort(dui_card_, sort_table_logic_value_desc)

        --组合在一起
        for i=1,#dui_card_ do
            out_total_card_[#out_total_card_+1] = dui_card_[i]
        end

        for i=1,#single_card_ do
            out_total_card_[#out_total_card_+1] = single_card_[i]
        end

        return out_total_card_

    --3条
    elseif(card_type == CARD_TYPE.CARD_TYPE_3_TIAO) then

        --单牌排序
        local single_card_ = {}

        for k,v in ipairs(tmp_total_card_) do

            local value = logic.get_card_value(v)
            if(logic.find_value_cnt(tmp_total_card_, value) == 1) then
                single_card_[#single_card_+1] = v
            end

        end

        table.sort(single_card_, sort_table_logic_value_desc)

        --三条排序
        local _3_tiao_card_ = {}

        _3_tiao_card_ = logic.delete_cards(tmp_total_card_, single_card_)
        table.sort(_3_tiao_card_, sort_table_logic_value_desc)

        --组合在一起
        for i=1,#_3_tiao_card_ do
            out_total_card_[#out_total_card_+1] = _3_tiao_card_[i]
        end

        for i=1,#single_card_ do
            out_total_card_[#out_total_card_+1] = single_card_[i]
        end

        return out_total_card_

    --顺子,同花顺
    elseif(card_type == CARD_TYPE.CARD_TYPE_SHUN_ZI or card_type==CARD_TYPE.CARD_TYPE_TONG_HUA_SHUN) then

        --A作为1，2，3 下顺的时候特殊排序
        --[[
        local is_shun = logic.is_shun_zi(tmp_total_card_)
        if(is_shun == true) then
            out_total_card_ = logic.copy_table(tmp_total_card_) 
            table.sort(out_total_card_, sort_table_value_desc)

            return out_total_card_
        end

        local is_shun_logic_value = logic.is_shun_zi_logic_value(tmp_total_card_)
        if(is_shun_logic_value == true) then
        
            out_total_card_ = logic.copy_table(tmp_total_card_) 
            table.sort(out_total_card_, sort_table_logic_value_desc)

            return out_total_card_        
        end

        assert(false)
        --]]
        local tmp_cards, joker_num = extract_jokers(tmp_total_card_)
        local has_a, has_5432 = false, false
        for _, card in ipairs(tmp_cards) do
          local logic_value = logic.get_card_value(card)
          if logic_value == 1 then
            has_a = true
          elseif logic_value >= 2 and logic_value <= 5 then
            has_5432 = true
          end
        end
        if has_a and has_5432 then
          table.sort(tmp_cards, sort_table_value_desc)
        else
          table.sort(tmp_cards, sort_table_logic_value_desc)
        end
        for i = 1, joker_num do
          table.insert(out_total_card_, JOKER_CARD)
        end
        for i = 1, #tmp_cards do
          table.insert(out_total_card_, tmp_cards[i])
        end
        
        return out_total_card_

    --葫芦
    elseif(card_type == CARD_TYPE.CARD_TYPE_HU_LU) then

        --对牌排序
        local dui_card_ = {}

        for k,v in ipairs(tmp_total_card_) do

            local value = logic.get_card_value(v)
            if(logic.find_value_cnt(tmp_total_card_, value) == 2) then
                dui_card_[#dui_card_+1] = v
            end

        end

        table.sort(dui_card_, sort_table_logic_value_desc)

        --3条排序
        local _3_tiao_card_ = {}

        _3_tiao_card_ = logic.delete_cards(tmp_total_card_, dui_card_)
        table.sort(_3_tiao_card_, sort_table_logic_value_desc)

        --组合在一起
        for i=1,#_3_tiao_card_ do
            out_total_card_[#out_total_card_+1] = _3_tiao_card_[i]
        end

        for i=1,#dui_card_ do
            out_total_card_[#out_total_card_+1] = dui_card_[i]
        end

        return out_total_card_

    --4条
    elseif(card_type == CARD_TYPE.CARD_TYPE_4_TIAO) then

        --单牌排序
        local single_card_ = {}

        for k,v in ipairs(tmp_total_card_) do

            local value = logic.get_card_value(v)
            if(logic.find_value_cnt(tmp_total_card_, value) == 1) then
                single_card_[#single_card_+1] = v
            end

        end

        table.sort(single_card_, sort_table_logic_value_desc)

        --4条排序
        local _4_tiao_card_ = {}

        _4_tiao_card_ = logic.delete_cards(tmp_total_card_, single_card_)
        table.sort(_4_tiao_card_, sort_table_logic_value_desc)

        --组合在一起
        for i=1,#_4_tiao_card_ do
            out_total_card_[#out_total_card_+1] = _4_tiao_card_[i]
        end

        for i=1,#single_card_ do
            out_total_card_[#out_total_card_+1] = single_card_[i]
        end

        return out_total_card_
    elseif(card_type == CARD_TYPE.CARD_TYPE_BOMB) then
        out_total_card_ = logic.copy_table(tmp_total_card_) 
        table.sort(out_total_card_, sort_table_logic_value_desc)

        return out_total_card_
    else
        assert(false)
    end

    return out_total_card_
end

function logic.sort_card_type_shun_zi_asc(total_card_)
    if(type(total_card_) ~= "table") then return  nil end

    local tmp_total_card_ =  logic.copy_table(total_card_)

    --print(string.format("\r\nlogic.sort_card_type_shun_zi_asc(),#tmp_total_card_:%d,", #tmp_total_card_))
    --logic.debug_print_table(tmp_total_card_, true)
    local out_total_card_ = {}

    local is_shun = logic.is_shun_zi(tmp_total_card_)
    if(is_shun == true) then

        --print(string.format("\r\nlogic.sort_card_type_shun_zi_asc(),普通值成顺"))

        out_total_card_ = logic.copy_table(tmp_total_card_) 
        table.sort(out_total_card_, sort_table_value_asc)

        return out_total_card_
    end

    local is_shun_logic_value = logic.is_shun_zi_logic_value(tmp_total_card_)
    if(is_shun_logic_value == true) then
    
        --print(string.format("\r\nlogic.sort_card_type_shun_zi_asc(),逻辑值成顺"))

        out_total_card_ = logic.copy_table(tmp_total_card_) 
        table.sort(out_total_card_, sort_table_logic_value_asc)

        return out_total_card_        
    end

    assert(false)
    return tmp_total_card_

end

function logic.sort_card_type_shun_zi_desc(total_card_)
    if(type(total_card_) ~= "table") then return  nil end

    local tmp_total_card_ =  logic.copy_table(total_card_)

    local out_total_card_ = {}

    local is_shun = logic.is_shun_zi(tmp_total_card_)
    if(is_shun == true) then

        --print(string.format("\r\nlogic.sort_card_type_shun_zi_desc(),普通值成顺"))

        out_total_card_ = logic.copy_table(tmp_total_card_) 
        table.sort(out_total_card_, sort_table_value_desc)

        return out_total_card_
    end

    local is_shun_logic_value = logic.is_shun_zi_logic_value(tmp_total_card_)
    if(is_shun_logic_value == true) then
    
        --print(string.format("\r\nlogic.sort_card_type_shun_zi_desc(),逻辑值成顺"))

        out_total_card_ = logic.copy_table(tmp_total_card_) 
        table.sort(out_total_card_, sort_table_logic_value_desc)

        return out_total_card_        
    end

    assert(false)
    return tmp_total_card_

end

--摊牌(不考虑特殊牌型)
function logic.open_card_client(cards)
    if(type(cards) ~= "table") then return  nil end
    if(#cards ~= PLAYER_CARD_CNT) then return  nil end

    --特殊牌型在客户端摊牌中不考虑

    local out_cards = {}
    local out_card_types = {}

    local fun_list_1_ =
    {
        my_extract_card.card_type_bomb,
        my_extract_card.card_type_tong_hua_shun,
        my_extract_card.card_type_4_tiao,
        my_extract_card.card_type_hu_lu,
        my_extract_card.card_type_tong_hua,
        my_extract_card.card_type_shun_zi,
        my_extract_card.card_type_3_tiao,
        my_extract_card.card_type_2_dui,    
        my_extract_card.card_type_dui_zi,
        my_extract_card.card_type_san_pai,
    }

    local fun_cnt = #fun_list_1_

    local card_type_ =
    {
        "同花顺",
        "4条",
        "葫芦",
        "同花",
        "顺子",
        "3条",
        "2对",
        "对子",
        "散牌",
    }


    --提取下道
    for fun_index=1,fun_cnt do

        local total_card_ = logic.copy_table(cards)

        --print(string.format("\r\nlogic.open_card_client(),全部的牌张数:%d,全部的牌：",#total_card_))
        --logic.debug_print_table(total_card_, true)
 
        local extract_card_3_ = fun_list_1_[fun_index](total_card_, 3)
        if(#extract_card_3_ == 5) then
           
            --print(string.format("\r\nlogic.open_card_client(),提取3道成功,fun_index:%d,牌型:%s,提取的牌:",fun_index,card_type_[fun_index]))
            --logic.debug_print_table(extract_card_3_, true)

            local card_type_3 = logic.get_card_type(extract_card_3_)
            local total_card_order_2_ = logic.delete_cards(total_card_, extract_card_3_)
            
            --提取中道
            for fun_index_ex=1, fun_cnt do
        
                local total_card_order_2_copy_ = logic.copy_table(total_card_order_2_)

                --print(string.format("\r\nlogic.open_card_client(),提取2道成功之前,3道牌型为:%s,fun_index_ex:%d,当前牌型:%s,提取的牌:",card_type_[fun_index],fun_index_ex,card_type_[fun_index_ex]))
                --logic.debug_print_table(total_card_order_2_copy_, true)

                local extract_card_2_ = fun_list_1_[fun_index_ex](total_card_order_2_copy_, 2)
                if(#extract_card_2_ == 5) then
           
                    --print(string.format("\r\nlogic.open_card_client(),提取2道成功,fun_index:%d,牌型:%s,提取的牌:",fun_index_ex,card_type_[fun_index_ex]))
                    --logic.debug_print_table(extract_card_2_, true)

                    local card_type_2 = logic.get_card_type(extract_card_2_)

                    --提取上道
                    local extract_card_1_ = logic.delete_cards(total_card_order_2_copy_, extract_card_2_)
                    local card_type_1 = logic.get_card_type(extract_card_1_)
                
                    if((#extract_card_3_+#extract_card_2_+#extract_card_1_) == PLAYER_CARD_CNT) then

                        --print(string.format("\r\nlogic.open_card_client(),提取 成功后"))
                        --logic.debug_print_table(tmp_card_, true)
 
                        local table_index = 1+#out_cards
                        out_cards[table_index] = {}
                        out_card_types[table_index] = {}

                        --排序，方便后面的排除重复的组合
                        table.sort(extract_card_3_, sort_table_logic_value_desc)
                        for k,v in pairs(extract_card_3_) do 
                            out_cards[table_index][#out_cards[table_index]+1] = v
                        end
                        out_card_types[table_index][#out_card_types[table_index]+1] = card_type_3

                        table.sort(extract_card_2_, sort_table_logic_value_desc)
                        for k,v in pairs(extract_card_2_) do 
                            out_cards[table_index][#out_cards[table_index]+1] = v
                        end
                        out_card_types[table_index][#out_card_types[table_index]+1] = card_type_2

                        table.sort(extract_card_1_, sort_table_logic_value_desc)
                        for k,v in pairs(extract_card_1_) do 
                            out_cards[table_index][#out_cards[table_index]+1] = v
                        end
                        out_card_types[table_index][#out_card_types[table_index]+1] = card_type_1

                    end
                end
               
            end
        end

    end

    print(string.format("\r\nlogic.open_card_client(),#out_cards:%d,",#out_cards))
    for i=1,#out_cards do
        print(string.format("\r\nlogic.open_card_client(),i:%d,",i))
        logic.debug_print_table(out_cards[i], true)
        logic.debug_print_table(out_card_types[i], false)
    end

    --反向
    for k,v in pairs(out_cards) do
        out_cards[k] = logic.reverse_table(out_cards[k])
    end

    --去掉重复的
    local tmp_out_cards_cnt = #out_cards
    for i=1,tmp_out_cards_cnt do
        
        if(out_cards[i] ~= nil) then

            --print(string.format("\r\nlogic.open_card_client(),去重复,i:%d,tmp_out_cards_cnt:%d,",i, tmp_out_cards_cnt))

            for j=i+1,tmp_out_cards_cnt do
            
                --print(string.format("\r\nlogic.open_card_client(),去重复,j:%d,tmp_out_cards_cnt:%d,",j, tmp_out_cards_cnt))

                if(out_cards[j] ~= nil) then

                    if(i ~= j) then

                        --print(string.format("\r\nlogic.open_card_client(),i:%d,j:%d,去重复,牌值:",i,j))
                        --logic.debug_print_table(out_cards[i], true)
                        --logic.debug_print_table(out_cards[j], true)

                        if(logic.is_equal_table_no_sort(out_cards[i], out_cards[j]) == true) then   
                        
                            print(string.format("\r\nlogic.open_card_client(),i:%d,j:%d,重复，舍弃",i,j))
                                         
                            out_cards[j] = nil
                            out_card_types[j] = nil
                        end
                    end
                end
            end
        end
    end
    --]]

    --校验
    for k,v in pairs(out_cards) do
        local ok = logic.check_3_dao_card_type(out_cards[k])
        if(ok == false) then

            print(string.format("\r\nlogic.open_card_client(),k:%d,校验不合格，舍弃",k))
            out_cards[k] = nil
            out_card_types[k] = nil
        end
    end

    print(string.format("\r\nlogic.open_card_client(),检验之后，#out_cards:%d,",#out_cards))
    --for i=1,#out_cards do
    for k,v in pairs(out_cards) do
        print(string.format("\r\nlogic.open_card_client(),i:%d,",k))
        logic.debug_print_table(out_cards[k], true)
        logic.debug_print_table(out_card_types[k], false)
    end

    --如果三道都是相同的牌型,取头道最大的第一个牌型
    for k,v in pairs(out_card_types) do
        for k1,v1 in pairs(out_card_types) do

            if(k~=k1 and out_card_types[k]~=nil and out_card_types[k1]~=nil) then
                
                if(out_card_types[k][1]==out_card_types[k1][1] and out_card_types[k][2]==out_card_types[k1][2] and out_card_types[k][3]==out_card_types[k1][3]) then
                    
                    print(string.format("\r\nlogic.open_card_client(),k:%d,k1:%d,3道牌型都相同，舍弃",k,k1))
                    out_cards[k1] = nil
                    out_card_types[k1] = nil
                end

            end

        end
    end


    --[[
    --特殊牌型处理,头道对子,中道两对
    logic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(out_cards)
    
    --特殊牌型处理,头道对子,中道对子，尾道两对
    logic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(out_cards)
    --]]

    local final_out_cards = {}
    for k,v in pairs(out_cards) do
        local index = 1+#final_out_cards

        final_out_cards[index] = {}
        final_out_cards[index] = logic.copy_table(out_cards[k])
    end

    print(string.format("\r\nlogic.open_card_client(),#final_out_cards:%d,",#final_out_cards))
    for i=1,#final_out_cards do
        --print(string.format("\r\nlogic.open_card_client(),i:%d,",i))
        --logic.debug_print_table(final_out_cards[i], true)
    end

    --return  final_out_cards

    --得到三道权重最大的四种组合
    local final_final_out_cards = {}
    local weight_cnt_ = {}

    --计算权重
    for j=1,#final_out_cards do
        weight_cnt_[j] = logic.cal_3_dao_total_weight_all(final_out_cards[j])
        print(string.format("\r\nlogic.open_card_client(),weight_cnt_[%d]:%d,",j, weight_cnt_[j]))
    end
    local final_out_cards_cnt = #final_out_cards

    --需要输出的牌组合个数
    local max_out_card_cnt = math.min(4, #final_out_cards)
    print(string.format("\r\nlogic.open_card_client(),max_out_card_cnt:%d,",max_out_card_cnt))
  
    for i=1,max_out_card_cnt do

        local max_weight_cnt = 0
        local max_weight_cnt_index = 0

        for j=1,#final_out_cards do
            if(weight_cnt_[j] ~= nil) then

                if(j == 1) then max_weight_cnt=weight_cnt_[j];max_weight_cnt_index=j
                else 
                    if(max_weight_cnt < weight_cnt_[j]) then  max_weight_cnt=weight_cnt_[j];max_weight_cnt_index=j end
                end
            end
        end

        --print(string.format("\r\nlogic.open_card_client(),max_weight_cnt_index:%d,",max_weight_cnt_index))

        --找到最大权重
        if(max_weight_cnt_index>=1 and max_weight_cnt_index<=final_out_cards_cnt) then
            
            weight_cnt_[max_weight_cnt_index] = nil

            --print(string.format("\r\nlogic.open_card_client(),max_weight_cnt_index:%d,",max_weight_cnt_index))

            local table_index = 1+#final_final_out_cards
            final_final_out_cards[table_index] = {}
            final_final_out_cards[table_index] = logic.copy_table(final_out_cards[max_weight_cnt_index])

        end

    end

    return  final_final_out_cards
end

--特殊牌型处理,头道对子,中道两对
function logic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(out_cards)

    --特别的几种组合的优化
    for k,v in pairs(out_cards) do
        --三道牌型
        local dao_cards = {}
        local dao_card_type_ = {}

        for dao_index=1,3 do
            local start_index_  = {1,4,9}
            local card_cnt_     = {3,5,5}

            dao_cards[dao_index] = {}
            dao_cards[dao_index] = logic.copy_table_part(out_cards[k], start_index_[dao_index], card_cnt_[dao_index])

            dao_card_type_[dao_index] = logic.get_card_type(dao_cards[dao_index])
        end

        local card_type_txt_ = {}
        for k1,v1 in ipairs(dao_card_type_) do
            card_type_txt_[#card_type_txt_+1] = logic.get_card_type_txt(dao_card_type_[k1])
        end

        local weight_cnt= logic.cal_3_dao_total_weight_all(out_cards[k])
        --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,权重:%d,3道牌牌型,:%s,%s,%s,牌值:",k,weight_cnt, card_type_txt_[1],card_type_txt_[2],card_type_txt_[3]))                
        --logic.debug_print_table(out_cards[k], true)

        local dao_cards_after_delete_dui_zi = {}

        --中道两对,头道对子
        if(dao_card_type_[2]==CARD_TYPE.CARD_TYPE_2_DUI and dao_card_type_[1]==CARD_TYPE.CARD_TYPE_DUI_ZI) then
            
            --提取所有对子出来
            local _dui_zi_card_total_ = {}

            for dao_index=3,1,-1 do
                
                --对子
                local _dui_zi_card_dao_index_ = {}

                for k1,v1 in ipairs(dao_cards[dao_index]) do

                    if(logic.find_value_cnt(dao_cards[dao_index], logic.get_card_value(v1)) == 2) then
                        _dui_zi_card_dao_index_[#_dui_zi_card_dao_index_ +1] = v1
                    end

                end

                --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),删除前,dao_cards[%d],牌值:",dao_index))                
                --logic.debug_print_table(dao_cards[dao_index], true)

                dao_cards_after_delete_dui_zi[dao_index] = {}
                dao_cards_after_delete_dui_zi[dao_index] = logic.delete_cards(dao_cards[dao_index],_dui_zi_card_dao_index_)

                --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),删除后,dao_cards_after_delete_dui_zi[%d],牌值:",dao_index))                
                --logic.debug_print_table(dao_cards_after_delete_dui_zi[dao_index], true)

                for k1,v1 in ipairs(_dui_zi_card_dao_index_) do
                    _dui_zi_card_total_[#_dui_zi_card_total_+1] = v1
                end

            end

            --至少3对
            print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,#_dui_zi_card_total_:%d,",k,#_dui_zi_card_total_))
            assert(#_dui_zi_card_total_ >= 6)

            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,",k))
            --logic.debug_print_table(out_cards[k], true)

            --对子排序
            table.sort(_dui_zi_card_total_, sort_table_logic_value_desc)
            
            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),对子个数:%d,所有对子排序后,牌值:",#_dui_zi_card_total_))                
            --logic.debug_print_table(_dui_zi_card_total_, true)

            --最大的对子放在头道
            local new_dao_cards = {}
            for dao_index=1,3 do
                new_dao_cards[dao_index] = {}
            end
                        
            for dao_index=1,3 do
                new_dao_cards[dao_index] = {}
                
                if(dao_index == 1) then 
                
                    --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),dao_index:%d,",dao_index))                
 
                    new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[1]
                    new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[2]

                    for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                    end

                    --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),dao_index:%d,new_dao_cards[%d]:",dao_index, dao_index))                
                    --logic.debug_print_table(new_dao_cards[dao_index], true)

                end

                --尾道是葫芦
                if(dao_card_type_[3] == CARD_TYPE.CARD_TYPE_HU_LU) then

                    assert(#_dui_zi_card_total_ == 8)

                    if(dao_index == 2) then

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[3]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[4]

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[5]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[6]

                        for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                            new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                        end
                    end

                    if(dao_index == 3) then

                        for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                            new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                        end

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[7]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[8]

                    end

                --尾道是两对
                elseif(dao_card_type_[3] == CARD_TYPE.CARD_TYPE_2_DUI) then

                    assert(#_dui_zi_card_total_ == 10)

                    if(dao_index == 2) then

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[5]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[6]

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[7]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[8]

                        for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                            new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                        end
                    end

                    if(dao_index == 3) then

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[3]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[4]

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[9]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[10]

                        for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                            new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                        end

                    end

                --其他
                else
                    assert(#_dui_zi_card_total_ == 6)

                    if(dao_index == 2) then
                  
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[3]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[4]

                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[5]
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[6]

                        for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                            new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                        end
                    end

                    if(dao_index == 3) then
                        new_dao_cards[dao_index] = logic.copy_table(dao_cards_after_delete_dui_zi[dao_index])
                    end

                end                
                     
            end

            --组合起来
            out_cards[k] = {}
            for dao_index=1,3 do
                for k1,v1 in ipairs(new_dao_cards[dao_index]) do
                    out_cards[k][#out_cards[k] +1] = v1
                end
            end

            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,对子重排之后:",k))                
            --logic.debug_print_table(out_cards[k], true)

        end

    end

    --再次去掉重复的
    tmp_out_cards_cnt = #out_cards
    for i=1,tmp_out_cards_cnt do
        
        if(out_cards[i] ~= nil) then

            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),去重复,i:%d,tmp_out_cards_cnt:%d,",i, tmp_out_cards_cnt))

            for j=i+1,tmp_out_cards_cnt do
            
                --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),去重复,j:%d,tmp_out_cards_cnt:%d,",j, tmp_out_cards_cnt))

                if(out_cards[j] ~= nil) then

                    if(i ~= j) then

                        --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),i:%d,j:%d,去重复,牌值:",i,j))
                        --logic.debug_print_table(out_cards[i], true)
                        --logic.debug_print_table(out_cards[j], true)

                        if(logic.is_equal_table_no_sort(out_cards[i], out_cards[j]) == true) then   
                        
                            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),i:%d,j:%d,重复，舍弃",i,j))
                                         
                            out_cards[j] = nil
                        end
                    end
                end
            end
        end
    end
    --]]

    --再次校验
    for k,v in pairs(out_cards) do
        local ok = logic.check_3_dao_card_type(out_cards[k])
        if(ok == false) then

            print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,再次校验不合格，舍弃",k))
            out_cards[k] = nil
        end
    end

end

--特殊牌型处理,头道对子,中道对子，尾道两对
function logic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(out_cards)

    --特别的几种组合的优化
    for k,v in pairs(out_cards) do
        --三道牌型
        local dao_cards = {}
        local dao_card_type_ = {}

        for dao_index=1,3 do
            local start_index_  = {1,4,9}
            local card_cnt_     = {3,5,5}

            dao_cards[dao_index] = {}
            dao_cards[dao_index] = logic.copy_table_part(out_cards[k], start_index_[dao_index], card_cnt_[dao_index])

            dao_card_type_[dao_index] = logic.get_card_type(dao_cards[dao_index])
        end

        local card_type_txt_ = {}
        for k1,v1 in ipairs(dao_card_type_) do
            card_type_txt_[#card_type_txt_+1] = logic.get_card_type_txt(dao_card_type_[k1])
        end

        local weight_cnt= logic.cal_3_dao_total_weight_all(out_cards[k])
        --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,权重:%d,3道牌牌型,:%s,%s,%s,牌值:",k,weight_cnt, card_type_txt_[1],card_type_txt_[2],card_type_txt_[3]))                
        --logic.debug_print_table(out_cards[k], true)

        local dao_cards_after_delete_dui_zi = {}

        --中道两对,头道对子
        if(dao_card_type_[3]==CARD_TYPE.CARD_TYPE_2_DUI and dao_card_type_[2]==CARD_TYPE.CARD_TYPE_DUI_ZI and dao_card_type_[1]==CARD_TYPE.CARD_TYPE_DUI_ZI) then
            
            --提取所有对子出来
            local _dui_zi_card_total_ = {}

            for dao_index=3,1,-1 do
                
                --对子
                local _dui_zi_card_dao_index_ = {}

                for k1,v1 in ipairs(dao_cards[dao_index]) do

                    if(logic.find_value_cnt(dao_cards[dao_index], logic.get_card_value(v1)) == 2) then
                        _dui_zi_card_dao_index_[#_dui_zi_card_dao_index_ +1] = v1
                    end

                end

                --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),删除前,dao_cards[%d],牌值:",dao_index))                
                --logic.debug_print_table(dao_cards[dao_index], true)

                dao_cards_after_delete_dui_zi[dao_index] = {}
                dao_cards_after_delete_dui_zi[dao_index] = logic.delete_cards(dao_cards[dao_index],_dui_zi_card_dao_index_)

                --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),删除后,dao_cards_after_delete_dui_zi[%d],牌值:",dao_index))                
                --logic.debug_print_table(dao_cards_after_delete_dui_zi[dao_index], true)

                for k1,v1 in ipairs(_dui_zi_card_dao_index_) do
                    _dui_zi_card_total_[#_dui_zi_card_total_+1] = v1
                end

            end

            --至少4对
            print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),k:%d,#_dui_zi_card_total_:%d,",k,#_dui_zi_card_total_))
            assert(#_dui_zi_card_total_ >= 8)

            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_2_dui(),k:%d,",k))
            --logic.debug_print_table(out_cards[k], true)

            --对子排序
            table.sort(_dui_zi_card_total_, sort_table_logic_value_desc)
            
            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),对子个数:%d,所有对子排序后,牌值:",#_dui_zi_card_total_))                
            --logic.debug_print_table(_dui_zi_card_total_, true)

            --最大的对子放在头道
            local new_dao_cards = {}
            for dao_index=1,3 do
                new_dao_cards[dao_index] = {}
            end
                        
            for dao_index=1,3 do
                new_dao_cards[dao_index] = {}
                
                if(dao_index == 1) then 
                
                    --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),dao_index:%d,",dao_index))                
 
                    new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[3]
                    new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[4]

                    for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                        new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                    end

                    --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),dao_index:%d,new_dao_cards[%d]:",dao_index, dao_index))                
                    --logic.debug_print_table(new_dao_cards[dao_index], true)

                end

                 if(dao_index == 2) then

                     new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[1]
                     new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[2]

                     for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                         new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                     end
                 end

                 if(dao_index == 3) then

                     for kk,vv in ipairs(dao_cards_after_delete_dui_zi[dao_index]) do
                         new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = vv
                     end

                     new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[5]
                     new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[6]

                     new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[7]
                     new_dao_cards[dao_index][#new_dao_cards[dao_index] + 1] = _dui_zi_card_total_[8]
                 end

            end

            --组合起来
            out_cards[k] = {}
            for dao_index=1,3 do
                for k1,v1 in ipairs(new_dao_cards[dao_index]) do
                    out_cards[k][#out_cards[k] +1] = v1
                end
            end

            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),k:%d,对子重排之后:",k))                
            --logic.debug_print_table(out_cards[k], true)

        end

    end

    --再次去掉重复的
    tmp_out_cards_cnt = #out_cards
    for i=1,tmp_out_cards_cnt do
        
        if(out_cards[i] ~= nil) then

            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),去重复,i:%d,tmp_out_cards_cnt:%d,",i, tmp_out_cards_cnt))

            for j=i+1,tmp_out_cards_cnt do
            
                --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),去重复,j:%d,tmp_out_cards_cnt:%d,",j, tmp_out_cards_cnt))

                if(out_cards[j] ~= nil) then

                    if(i ~= j) then

                        --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),i:%d,j:%d,去重复,牌值:",i,j))
                        --logic.debug_print_table(out_cards[i], true)
                        --logic.debug_print_table(out_cards[j], true)

                        if(logic.is_equal_table_no_sort(out_cards[i], out_cards[j]) == true) then   
                        
                            --print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),i:%d,j:%d,重复，舍弃",i,j))
                                         
                            out_cards[j] = nil
                        end
                    end
                end
            end
        end
    end
    --]]

    --再次校验
    for k,v in pairs(out_cards) do
        local ok = logic.check_3_dao_card_type(out_cards[k])
        if(ok == false) then

            print(string.format("\r\nlogic.open_card_client_adjust_1dao_dui_zi_2dao_dui_zi_3dao_2_dui(),k:%d,再次校验不合格，舍弃",k))
            out_cards[k] = nil
        end
    end

end

--摊牌,特殊牌型
function logic.open_card_server(cards)
    if(type(cards) ~= "table") then return  nil end
    if(#cards ~= PLAYER_CARD_CNT) then return  nil end

    local out_cards = {}
    local tmp_cards = logic.copy_table(cards)

    --特殊牌型判断，特殊牌型是13张牌整手牌分配
    if(logic.is_special_card_type(cards)) then
        print(string.format("\r\nlogic.open_card_server(),特殊牌型,"))
        out_cards = logic.copy_table(tmp_cards)
        return out_cards
    end

    --普通牌型
    local final_out_cards = logic.open_card_client(cards)

    print(string.format("\r\nlogic.open_card_server(),#final_out_cards:%d,", #final_out_cards))
    if(#final_out_cards >= 1) then
        return final_out_cards[1]
    end

    assert(false)
    return {}
end

--提取牌型
--

--提取牌型:所有对子
function logic.extract_dui_zi(cards, max_jokers)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 2) then return out_card_,out_card_cnt_ end

    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    table.sort(tmp_cards, sort_table_logic_value_asc)

    local same_cnt_limit = 2
    max_jokers = max_jokers or 0
    for k = same_cnt_limit, same_cnt_limit - max_jokers, -1 do
      if joker_num < same_cnt_limit - k then break end
      local i=1
      while i<#tmp_cards do
        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)

        if(same_value_cnt >= k) then
            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = (k >= 2) and tmp_cards[i+1] or JOKER_CARD
            out_card_cnt_[#out_card_cnt_ + 1] = 2
            i = i+same_value_cnt
        else
            i = i+1
        end
      end
      if k == same_cnt_limit and #out_card_ > 0 then
        break
      end
    end

    return out_card_,out_card_cnt_
end

local function extract_san_pai(cards, cnt, ignore)
  local ret_cards = {}
  if #cards < cnt then return ret_cards end
  local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
  table.sort(tmp_cards, sort_table_logic_value_asc)
  if #tmp_cards < cnt then return ret_cards end
  for i = 1, #tmp_cards do
    local value = logic.get_card_value(tmp_cards[i])
    local same_value_cnt = logic.find_value_cnt(tmp_cards, value)
    if same_value_cnt == 1 then
      local tmp_card = tmp_cards[i]
      for j = 1, #ignore do
        if value == logic.get_card_value(ignore[j]) then
          tmp_card = nil
          break
        end
      end
      if tmp_card then
        table.insert(ret_cards, tmp_card)
        if #ret_cards == cnt then
          break
        end
      end
    end
  end
  
  if #ret_cards ~= cnt then
    return {}
  end
  
  return ret_cards
end

function logic.extract_dui_zi_ex(cards)
  --返回牌型
  local out_card_ = {}
  local out_card_cnt_ = {}

  local out_dui_zi_cards, out_dui_zi_cnt = logic.extract_dui_zi(cards, 1)
  if #out_dui_zi_cards < 2 then return out_dui_zi_cards, out_dui_zi_cnt end
  
  for i = #out_dui_zi_cnt, 1, -1 do
    local tmp_cards = logic.copy_table_remove_nil(cards)
    tmp_cards = logic.delete_cards(tmp_cards, {out_dui_zi_cards[i * 2 - 1], out_dui_zi_cards[i * 2]})
    local san_pais = extract_san_pai(tmp_cards, 3, {out_dui_zi_cards[i * 2 - 1]})
    if #san_pais == 3 then
      table.insert(out_card_, out_dui_zi_cards[i * 2 - 1])
      table.insert(out_card_, out_dui_zi_cards[i * 2])
      table.insert(out_card_, san_pais[1])
      table.insert(out_card_, san_pais[2])
      table.insert(out_card_, san_pais[3])
      table.insert(out_card_cnt_, 5)
    end
  end
  
  return out_card_,out_card_cnt_
end

--提取牌型:所有三条
function logic.extract_3_tiao(cards, max_jokers)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 3) then return out_card_,out_card_cnt_ end
 
    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    table.sort(tmp_cards, sort_table_logic_value_desc)
    
    local same_cnt_limit = 3
    local use_joker = true
    max_jokers = max_jokers or 0
    for k = same_cnt_limit, same_cnt_limit - max_jokers, -1 do
      if joker_num < same_cnt_limit - k then break end
      local i=1
      while i < #tmp_cards do
        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)
        if(same_value_cnt >= k) then
            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = (k >= 2) and tmp_cards[i+1] or JOKER_CARD
            out_card_[#out_card_+1] = (k >= 3) and tmp_cards[i+2] or JOKER_CARD
            out_card_cnt_[#out_card_cnt_+1] = 3
            i = i+same_value_cnt
        else
            i = i+1
        end 
      end
      
      if k == same_cnt_limit and #out_card_ > 0 then
        use_joker = false
        break
      end
    end
    if use_joker and joker_num >= same_cnt_limit then
      out_card_[#out_card_+1] = JOKER_CARD
      out_card_[#out_card_+1] = JOKER_CARD
      out_card_[#out_card_+1] = JOKER_CARD
      out_card_cnt_[#out_card_cnt_ + 1] = 3
    end
    
    --3条排序
    -- table.sort(out_card_, sort_table_logic_value_desc)

    return out_card_,out_card_cnt_
end

function logic.extract_3_tiao_ex(cards)
  --返回牌型
  local out_card_ = {}
  local out_card_cnt_ = {}
  
  local out_dui_zi_cards, out_dui_zi_cnt = logic.extract_3_tiao(cards, 1)
  if #out_dui_zi_cards < 3 then return out_dui_zi_cards, out_dui_zi_cnt end
  
  for i = 1, #out_dui_zi_cnt do
    local tmp_cards = logic.copy_table_remove_nil(cards)
    tmp_cards = logic.delete_cards(tmp_cards, {out_dui_zi_cards[i * 3 - 2], out_dui_zi_cards[i * 3 - 1], out_dui_zi_cards[i * 3]})
    local san_pais = extract_san_pai(tmp_cards, 2, {out_dui_zi_cards[i * 3 - 2]})
    if #san_pais == 2 then
      table.insert(out_card_, out_dui_zi_cards[i * 3 - 2])
      table.insert(out_card_, out_dui_zi_cards[i * 3 - 1])
      table.insert(out_card_, out_dui_zi_cards[i * 3])
      table.insert(out_card_, san_pais[1])
      table.insert(out_card_, san_pais[2])
      table.insert(out_card_cnt_, 5)
    end
  end
  
  return out_card_,out_card_cnt_
end

local function gen_shun_zi_table(cards)
  table.sort(cards, sort_table_logic_value_asc)
  local shun_zi_table = {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  local prev = 0
  for i = 1, #cards do 
    local card_value = logic.get_card_value(cards[i])
    if card_value ~= prev then
      shun_zi_table[card_value] = cards[i]
      prev = card_value
      if card_value == 1 then
        shun_zi_table[14] = cards[i]
      end
    end
  end
  
  return shun_zi_table
end

function logic.extract_shun_zi(cards)
    local out_card_ = {}
    local out_card_cnt_ = {}

    --返回牌型
    if(#cards < 5) then return out_card_,out_card_cnt_ end
    
    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    local shun_zi_table = gen_shun_zi_table(tmp_cards)
    local prev_cards
    for k = 0, joker_num do
      for _, i in ipairs({10, 1, 9, 8, 7, 6, 5, 4, 3, 2}) do
        local tmp_out_cards = {}
        local num = 0
        for j = i, i + 5 - 1 do
          if shun_zi_table[j] and shun_zi_table[j] ~= 0 then
            table.insert(tmp_out_cards, shun_zi_table[j])
            num = num + 1
          end
        end
        if num + k == 5 then
          for j = 1, 5 - num do
            table.insert(tmp_out_cards, JOKER_CARD)
          end
          if #out_card_ == 0 or not logic.is_equal_table(prev_cards, tmp_out_cards) then
            for _, card in ipairs(tmp_out_cards) do
              table.insert(out_card_, card)
            end
            table.insert(out_card_cnt_, 5)
            prev_cards = logic.copy_table_remove_nil(tmp_out_cards)
          end
        end
      end
      
      if k == 0 and #out_card_ > 0 then
        break
      end
    end
    
    return out_card_,out_card_cnt_
end

local function get_combin_seq(n, m)
  local ret_seq = {}
  
  local fill_first_m1 = function(t, n, m)
    for i = 1, n do
      if i <= m then
        t[i] = 1
      else
        t[i] = 0
      end
    end
  end 
  local seq = {}
  local pos = n + 1
  local num = m
  repeat
    fill_first_m1(seq, pos - 1, num)
    table.insert(ret_seq, logic.copy_table_remove_nil(seq))
    num = 0
    pos = nil
    for i = 1, #seq - 1 do
      if seq[i] == 1 and seq[i + 1] == 0 then
        pos = i
        seq[i], seq[i + 1] = 0, 1
        break
      end
      if seq[i] == 1 then
        num = num + 1
      end
    end
  until not pos
  
  return ret_seq
end

function logic.extract_2_dui(cards)
  --返回牌型
  local out_card_ = {}
  local out_card_cnt_ = {}
  
  local out_dui_zi_cards, out_dui_zi_cnt = logic.extract_dui_zi(cards, 0)
  if #out_dui_zi_cnt >= 2 then
    local combin_seq = get_combin_seq(#out_dui_zi_cnt, 2)
    for _, seq in pairs(combin_seq) do
      for i = 1, #seq do
        if seq[i] > 0 then
          table.insert(out_card_, out_dui_zi_cards[(i - 1) * 2 + 1])
          table.insert(out_card_, out_dui_zi_cards[i * 2])
        end
      end
      table.insert(out_card_cnt_, 4)
    end
    
    return out_card_,out_card_cnt_
  elseif #out_dui_zi_cnt >= 1 then
    local tmp_cards = logic.copy_table_remove_nil(cards)
    tmp_cards = logic.delete_cards(tmp_cards, out_dui_zi_cards)
    local tmp_out_dui_zi_cards, tmp_out_dui_zi_cnt = logic.extract_dui_zi(tmp_cards, 1)
    if #tmp_out_dui_zi_cnt > 0 then
      for i = 1, #tmp_out_dui_zi_cnt do
        table.insert(out_card_, out_dui_zi_cards[1])
        table.insert(out_card_, out_dui_zi_cards[2])
        table.insert(out_card_, tmp_out_dui_zi_cards[(i - 1) * 2 + 1])
        table.insert(out_card_, tmp_out_dui_zi_cards[i * 2])
        table.insert(out_card_cnt_, 4)
      end
    end
  end
  
  return out_card_, out_card_cnt_
end

function logic.extract_2_dui_ex(cards)
  --返回牌型
  local out_card_ = {}
  local out_card_cnt_ = {}
  
  local out_dui_zi_cards, out_dui_zi_cnt = logic.extract_2_dui(cards)
  if #out_dui_zi_cards < 4 then return out_dui_zi_cards, out_dui_zi_cnt end

  for i = 1, #out_dui_zi_cnt do
    local tmp_cards = logic.copy_table_remove_nil(cards)
    tmp_cards = logic.delete_cards(tmp_cards, {out_dui_zi_cards[i * 4 - 3], out_dui_zi_cards[i * 4 - 2], out_dui_zi_cards[i * 4 - 1], out_dui_zi_cards[i * 4]})
    local san_pais = extract_san_pai(tmp_cards, 1, {out_dui_zi_cards[i * 4 - 3], out_dui_zi_cards[i * 4 - 1]})
    if #san_pais == 1 then
      table.insert(out_card_, out_dui_zi_cards[i * 4 - 3])
      table.insert(out_card_, out_dui_zi_cards[i * 4 - 2])
      table.insert(out_card_, out_dui_zi_cards[i * 4 - 1])
      table.insert(out_card_, out_dui_zi_cards[i * 4])
      table.insert(out_card_, san_pais[1])
      table.insert(out_card_cnt_, 5)
    end
  end
  
  return out_card_,out_card_cnt_
end

function logic.extract_tong_hua(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 5) then return out_card_,out_card_cnt_ end
    
    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    table.sort(tmp_cards, sort_table_logic_value_asc)
    
    local color_table = {{}, {}, {}, {}}
    for _, card in ipairs(tmp_cards) do
      local color = logic.get_card_color(card)
      table.insert(color_table[color + 1], card)
    end
    
    for k = 0, joker_num do
      for c = 1, 4 do
        if #color_table[c] + k >= 5 then
          local combin_seq = get_combin_seq(#color_table[c], 5 - k)
          for _, seq in pairs(combin_seq) do
            for i = 1, #seq do
              if seq[i] > 0 then
                table.insert(out_card_, color_table[c][i])
              end
            end
            for i = 1, k do
              table.insert(out_card_, JOKER_CARD)
            end
            table.insert(out_card_cnt_, 5)
          end
        end
      end
      
      if k == 0 and #out_card_ > 0 then
        break
      end
    end
    
    return out_card_,out_card_cnt_
end
--提取牌型:所有葫芦
function logic.extract_hu_lu(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 5) then return out_card_,out_card_cnt_ end

    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))

    --提取3条
    local out_3_tiao_card_ = logic.extract_3_tiao(tmp_cards, 0)
    local _3_tiao_cnt = #out_3_tiao_card_/3
    if _3_tiao_cnt > 0 then
      local tmp_cards2 = logic.copy_table_remove_nil(tmp_cards)
      local new_total_cards = logic.delete_cards(tmp_cards2, out_3_tiao_card_)
      --提取对子
      local out_dui_zi_card_ = logic.extract_dui_zi(new_total_cards, 0)
      local dui_zi_cnt = #out_dui_zi_card_/2
  
      --从3条里分对子出来
      if(dui_zi_cnt<=0 and _3_tiao_cnt>=2) then
          --最小的三条
          local min_pos = 1
          local min_card_logic_value = logic.get_card_logic_value(out_3_tiao_card_[1])
          for i = 4, #out_3_tiao_card_ - 2, 3 do
            local tmp_card_logic_value = logic.get_card_logic_value(out_3_tiao_card_[i])
            if tmp_card_logic_value < min_card_logic_value then
              min_pos = i
            end
          end
          local tmp_3_tiao_ = {}
          for i = min_pos, min_pos + 2 do
              tmp_3_tiao_[#tmp_3_tiao_+1] = out_3_tiao_card_[i]
          end
  
          out_3_tiao_card_ = logic.delete_cards(out_3_tiao_card_, tmp_3_tiao_)
          out_dui_zi_card_ = {tmp_3_tiao_[1], tmp_3_tiao_[2]}
      end
  
      _3_tiao_cnt = #out_3_tiao_card_/3
      dui_zi_cnt = #out_dui_zi_card_/2
  
      local _3_tiao_arrays = {}
      for i=1,_3_tiao_cnt do
          _3_tiao_arrays[i] = {}
          _3_tiao_arrays[i] = logic.copy_table_part(out_3_tiao_card_, 1+(i-1)*3, 3)
      end
  
      local dui_zi_arrays = {}
      for i=1,dui_zi_cnt do
          dui_zi_arrays[i] = {}
          dui_zi_arrays[i] = logic.copy_table_part(out_dui_zi_card_, 1+(i-1)*2, 2)
      end
  
      for i=1,_3_tiao_cnt do
          for j=1,dui_zi_cnt do
              
              for k,v in ipairs(_3_tiao_arrays[i]) do
                  out_card_[#out_card_+1] = v
              end
  
              for k,v in ipairs(dui_zi_arrays[j]) do
                  out_card_[#out_card_+1] = v
              end
  
              out_card_cnt_[#out_card_cnt_ + 1] = 5
          end
      end
    end
    
    if #out_card_ > 0 or joker_num == 0 then
      return out_card_,out_card_cnt_
    end
    
    local out_dui_zi_card_ = logic.extract_dui_zi(tmp_cards, 0)
    local _2_tiao_cnt = #out_dui_zi_card_/2
    if _2_tiao_cnt >= 2 then
      local combin_seq = get_combin_seq(_2_tiao_cnt, 2)
      for _, seq in ipairs(combin_seq) do
        for i = 1, #seq do
          if seq[i] > 0 then
            table.insert(out_card_, out_dui_zi_card_[(i - 1) * 2 + 1])
            table.insert(out_card_, out_dui_zi_card_[i * 2])
          end
        end
        table.insert(out_card_, JOKER_CARD)
        table.insert(out_card_cnt_, 5)
      end
    end
    
    return out_card_,out_card_cnt_
end

function logic.extract_4_tiao(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 5) then return out_card_,out_card_cnt_ end

    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    table.sort(tmp_cards, sort_table_logic_value_desc)

    local same_cnt_limit = 4
    local max_jokers = 3
    for k = same_cnt_limit, same_cnt_limit - max_jokers, -1 do
      if joker_num < same_cnt_limit - k then break end
      local i=1
      while i < #tmp_cards do
        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)
        if(same_value_cnt >= k) then
            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = (k >= 2) and tmp_cards[i+1] or JOKER_CARD
            out_card_[#out_card_+1] = (k >= 3) and tmp_cards[i+2] or JOKER_CARD
            out_card_[#out_card_+1] = (k >= 4) and tmp_cards[i+3] or JOKER_CARD
            out_card_cnt_[#out_card_cnt_+1] = 4
            i = i+same_value_cnt
        else
            i = i+1
        end
      end
      
      if k == same_cnt_limit and #out_card_ > 0 then
        break
      end
    end

    return out_card_,out_card_cnt_
end

function logic.extract_4_tiao_ex(cards)
  --返回牌型
  local out_card_ = {}
  local out_card_cnt_ = {}
  
  local out_dui_zi_cards, out_dui_zi_cnt = logic.extract_4_tiao(cards)
  if #out_dui_zi_cards < 4 then return out_dui_zi_cards, out_dui_zi_cnt end
  
  for i = 1, #out_dui_zi_cnt do
    local tmp_cards = logic.copy_table_remove_nil(cards)
    tmp_cards = logic.delete_cards(tmp_cards, {out_dui_zi_cards[i * 4 - 3], out_dui_zi_cards[i * 4 - 2], out_dui_zi_cards[i * 4 - 1], out_dui_zi_cards[i * 4]})
    local san_pais = extract_san_pai(tmp_cards, 1, {out_dui_zi_cards[i * 4 - 3]})
    if #san_pais == 1 then
      table.insert(out_card_, out_dui_zi_cards[i * 4 - 3])
      table.insert(out_card_, out_dui_zi_cards[i * 4 - 2])
      table.insert(out_card_, out_dui_zi_cards[i * 4 - 1])
      table.insert(out_card_, out_dui_zi_cards[i * 4])
      table.insert(out_card_, san_pais[1])
      
      table.insert(out_card_cnt_, 5)
    end
  end
  
  return out_card_,out_card_cnt_
end

--提取牌型:所有同花顺
function logic.extract_tong_hua_shun(cards)
    local out_card_ = {}
    local out_card_cnt_ = {}

    --返回牌型
    if(#cards < 5) then return out_card_,out_card_cnt_ end

    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    
    local color_table = {{}, {}, {}, {}}
    for _, card in ipairs(tmp_cards) do
      local color = logic.get_card_color(card)
      table.insert(color_table[color + 1], card)
    end

    for i=1,4 do  
      for j = 1, joker_num do table.insert(color_table[i], JOKER_CARD) end  
      if(#color_table[i] >= 5) then
        local shun_zi_card_,shun_zi_cards_cnt_= logic.extract_shun_zi(color_table[i])
        if(#shun_zi_cards_cnt_ >= 1) then
          for k,v in ipairs(shun_zi_card_) do
            out_card_[#out_card_+1] = shun_zi_card_[k]
          end
          for k,v in ipairs(shun_zi_cards_cnt_) do
            out_card_cnt_[#out_card_cnt_+1] = shun_zi_cards_cnt_[k]
          end
        end
      end
    end

    return out_card_,out_card_cnt_
end

function logic.extract_bomb(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 5) then return out_card_,out_card_cnt_ end

    --排序
    local tmp_cards, joker_num = extract_jokers(logic.copy_table_remove_nil(cards))
    table.sort(tmp_cards, sort_table_logic_value_asc)

    local same_cnt_limit = 5
    for k = same_cnt_limit, 1, -1 do
      if joker_num < same_cnt_limit - k then break end
      local i=1
      while i < #tmp_cards do
        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)
        if(same_value_cnt >= k) then
            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = (k >= 2) and tmp_cards[i+1] or JOKER_CARD
            out_card_[#out_card_+1] = (k >= 3) and tmp_cards[i+2] or JOKER_CARD
            out_card_[#out_card_+1] = (k >= 4) and tmp_cards[i+3] or JOKER_CARD
            out_card_[#out_card_+1] = (k >= 5) and tmp_cards[i+4] or JOKER_CARD
            out_card_cnt_[#out_card_cnt_+1] = 5
            i = i+same_value_cnt
        else
            i = i+1
        end
      end
      
      if k == same_cnt_limit and #out_card_ > 0 then
        break
      end
    end

    return out_card_,out_card_cnt_
end

--[[
--提取牌型:所有对子
function logic.extract_dui_zi(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 2) then return out_card_,out_card_cnt_ end

    --排序
    local tmp_cards = logic.copy_table_remove_nil(cards)
    table.sort(tmp_cards, sort_table_logic_value_asc)

    --logic.debug_print_table(tmp_cards)
    --return nil

    local i=1
    while i<#tmp_cards do
        --print("i: " .. i .. ",#tmp_cards:" .. #tmp_cards)

        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)

        --print("same_value_cnt is " .. same_value_cnt)

        if(same_value_cnt >= 2) then

            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = tmp_cards[i+1]

            out_card_cnt_[#out_card_cnt_ + 1] = 2
            i = i+same_value_cnt

            --print("i,2 dui zi " .. i)
        else
            i = i+1
        end

    end

    return out_card_,out_card_cnt_
end

--提取牌型:所有三条
function logic.extract_3_tiao(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 3) then return out_card_,out_card_cnt_ end

    --print("\r\n logic.extract_3_tiao(),牌值:")
    --logic.debug_print_table(cards, true)
 
    --排序
    local tmp_cards = logic.copy_table_remove_nil(cards)

    --print("\r\n logic.extract_3_tiao(),copy后牌值:")
    --logic.debug_print_table(tmp_cards, true)

    table.sort(tmp_cards, sort_table_logic_value_asc)

    --logic.debug_print_table(tmp_cards)
    --return nil

    local i=1
    while i<#tmp_cards do
        --print("i: " .. i .. ",#tmp_cards:" .. #tmp_cards)

        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)

        --print("same_value_cnt is " .. same_value_cnt)

        if(same_value_cnt >= 3) then

            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = tmp_cards[i+1]
            out_card_[#out_card_+1] = tmp_cards[i+2]

            out_card_cnt_[#out_card_cnt_+1] = 3

            i = i+same_value_cnt

            --print("i,2 dui zi " .. i)
        else
            i = i+1
        end

    end

    --3条排序
    table.sort(out_card_, sort_table_logic_value_desc)

    return out_card_,out_card_cnt_
end

--提取牌型:所有顺子
function logic.extract_shun_zi(cards)

    local out_card_ = {}
    local out_card_cnt_ = {}

    --返回牌型
    if(#cards < 5) then return out_card_,out_card_cnt_ end

    logic.logic_a_cnt = 0

    --得到A的个数
    local ACnt = logic.find_value_cnt(cards, 0x01)

    --A做0x01,或者0x0E
    for k=0,ACnt do

        local tmp_cards = logic.copy_table(cards)

        logic.logic_a_cnt = k
        --print(string.format("logic.extract_shun_zi(),A is 0x0E cnt :%d", k))

        local out_shun_zi_card_ = {}
        local out_shun_zi_card_cnt_ = {}

        local cnt = logic.extract_shun_zi_ex(tmp_cards, out_shun_zi_card_, out_shun_zi_card_cnt_)

        --print(string.format("logic.extract_shun_zi(),get shun zi:%d"), #out_shun_zi_cards)
        --print("main funciton , out_shun_zi_cards: " .. cnt)
        --print("main funciton , out_shun_zi_cards: " .. #out_shun_zi_cards)
        --logic.debug_print_table(out_shun_zi_cards, true)

        if(#out_shun_zi_card_ > #out_card_) then
            out_card_ = out_shun_zi_card_
            out_card_cnt_ = out_shun_zi_card_cnt_
        end

        --print(string.format("\r\nlogic.extract_shun_zi(),"))
        --logic.debug_print_table(out_cards, true)
        --logic.debug_print_table(out_shun_zi_cards_cnt, false)

    end

    logic.logic_a_cnt = 0

    return out_card_,out_card_cnt_
end

function logic.extract_shun_zi_ex(total_card_, out_shun_zi_card_, out_shun_zi_card_cnt_)

    if(type(out_shun_zi_card_) ~= "table") then return 0 end
    if(type(out_shun_zi_card_cnt_) ~= "table") then return 0 end
    if(type(total_card_) ~= "table") then return #out_shun_zi_card_ end
    if(#total_card_ <= 0) then return #out_shun_zi_card_ end

    --print(string.format("\r\nlogic.extract_shun_zi_ex(),全部的牌个数:%d,全部的牌:",#total_card_))
    --logic.debug_print_table(total_card_, true)

    --print(string.format("\r\nlogic.extract_shun_zi_ex(),out_shun_zi_card_个数:%d,out_shun_zi_card_:",#out_shun_zi_card_))
    --logic.debug_print_table(out_shun_zi_card_, true)

    --print(string.format("\r\nlogic.extract_shun_zi_ex(),out_shun_zi_card_cnt_个数:%d,out_shun_zi_card_cnt_:",#out_shun_zi_card_cnt_))
    --logic.debug_print_table(out_shun_zi_card_cnt_, false)

    local tmp_total_card_ = logic.copy_table_remove_nil(total_card_)

    --值表
    local value_table = logic.value_table_14(tmp_total_card_)
    if(value_table == nil) then assert(false); return #out_shun_zi_card_ end

    --print(string.format("\r\nlogic.extract_shun_zi_ex(),value_table个数:%d,value_table:",#value_table))
    --logic.debug_print_table(value_table)

    --顺子表
    local shun_zi_table_ = logic.from_values_2_shun_zi_table(value_table)
    if(shun_zi_table_ == nil) then assert(false); return #out_shun_zi_card_ end

    --print(string.format("\r\nlogic.extract_shun_zi_ex(),shun_zi_table_个数:%d,shun_zi_table_:",#shun_zi_table_)) 
    --logic.debug_print_table(shun_zi_table_,false)

    --没有顺子,返回
    local shun_zi_cnt = 0
    for i=1,#shun_zi_table_ do
        if(shun_zi_table_[i] >= 5)  then
            shun_zi_cnt = shun_zi_cnt+1
        end
    end
    if(shun_zi_cnt <= 0) then return #out_shun_zi_card_ end

    local new_card_ = tmp_total_card_
    for i=1,#shun_zi_table_ do
        if(shun_zi_table_[i] >= 5)  then

            new_card_ = logic.delete_table_item(tmp_total_card_, shun_zi_table_[i], i)

            --print(string.format("\r\nlogic.extract_shun_zi_ex(),1,tmp_total_card_个数:%d,tmp_total_card_:",#tmp_total_card_))
            --logic.debug_print_table(tmp_total_card_, true)

            --print(string.format("\r\nlogic.extract_shun_zi_ex(),2,new_card_个数:%d,new_card_:",#new_card_))
            --logic.debug_print_table(new_card_, true)

            --得到一个顺子
            local finial_shun_zi_card_ = logic.delete_cards(total_card_, new_card_)
            --升序排序
            finial_shun_zi_card_ = logic.sort_card_type_shun_zi_asc(finial_shun_zi_card_)

            --print(string.format("\r\nlogic.extract_shun_zi_ex(),得到一个顺子,顺子中牌个数:%d,finial_shun_zi_card_:",#finial_shun_zi_card_))
            --logic.debug_print_table(finial_shun_zi_card_, true)

            for k,v in ipairs(finial_shun_zi_card_) do
                out_shun_zi_card_[1+#out_shun_zi_card_] = v
            end

            out_shun_zi_card_cnt_[1+#out_shun_zi_card_cnt_] = shun_zi_table_[i]

            break ;

        end
    end

    --继续查找顺子
    return logic.extract_shun_zi_ex(new_card_, out_shun_zi_card_, out_shun_zi_card_cnt_)

end

--提取牌型:所有同花
function logic.extract_tong_hua(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 5) then return out_card_,out_card_cnt_ end

    local color_cnt = logic.color_cnt(cards)

    for k,v in ipairs(color_cnt) do
        if(v >= 5) then

            for k1,v1 in ipairs(cards) do

                if(logic.get_card_color(v1) == (k-1)) then
                     out_card_[#out_card_+1] = v1
                end
                
            end
            out_card_cnt_[#out_card_cnt_ + 1] = v
        end
    end

    local out_cnt = #out_card_cnt_
    if(out_cnt == 1) then
        return out_card_,out_card_cnt_ 
    end

    --[[
    --分牌比较大小
    local tmp_out_cards = {}
    local start_index = 1
    for i=1,out_cnt do
        tmp_out_cards[i] = {}

        tmp_out_cards[i] = logic.copy_table_part(out_card_,start_index,out_card_cnt_[i])
        start_index = start_index + out_card_cnt_[i]
    end

    local finual_out_card_ = {}

    for i=1,out_cnt do
        local max_index = 0
        for j=1,out_cnt do
            --if(tmp_out_cards)

            if(max_index == 0) then 
                max_index = j
            else
                if(my_compare_card.compare_card_type_tong_hua(tmp_out_cards[max_index], tmp_out_cards[j]) == true) then
                    max_index = j
                end
            end

        end           
    end
    --]]
--[[
    return out_card_,out_card_cnt_
end

--提取牌型:所有葫芦
function logic.extract_hu_lu(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 5) then return out_card_,out_card_cnt_ end

    local tmp_card_ = logic.copy_table_remove_nil(cards)

    --提取3条
    local out_3_tiao_card_ = logic.extract_3_tiao(tmp_card_)
    if(#out_3_tiao_card_ < 3) then return out_card_,out_card_cnt_ end
    local _3_tiao_cnt = #out_3_tiao_card_/3

    local new_total_cards = logic.delete_cards(tmp_card_, out_3_tiao_card_)
    --提取对子
    local out_dui_zi_card_ = logic.extract_dui_zi(new_total_cards)
    local dui_zi_cnt = #out_dui_zi_card_/2

    --print(string.format("\r\nlogic.extract_hu_lu(),_3_tiao_cnt:%d,", _3_tiao_cnt))
    --logic.debug_print_table(out_3_tiao_card_, true)

    --从3条里分对子出来
    if(dui_zi_cnt<=0 and _3_tiao_cnt>=2) then
        
        local tmp_out_3_tiao_card_ = logic.copy_table(out_3_tiao_card_)
        table.sort(tmp_out_3_tiao_card_, sort_table_logic_value_asc)

        --最小的三条
        local tmp_3_tiao_ = {}
        for i=1,3 do
            tmp_3_tiao_[#tmp_3_tiao_+1] = tmp_out_3_tiao_card_[i]
        end

        --print(string.format("\r\nlogic.extract_hu_lu(),"))
        --logic.debug_print_table(tmp_out_3_tiao_card_, true)
        --logic.debug_print_table(tmp_3_tiao_, true)

        out_3_tiao_card_ = logic.delete_cards(tmp_out_3_tiao_card_, tmp_3_tiao_)

        out_dui_zi_card_ = {}

        out_dui_zi_card_[#out_dui_zi_card_ + 1] = tmp_3_tiao_[1]
        out_dui_zi_card_[#out_dui_zi_card_ + 1] = tmp_3_tiao_[2]
    end

    _3_tiao_cnt = #out_3_tiao_card_/3
    dui_zi_cnt = #out_dui_zi_card_/2
    
    --print(string.format("\r\nlogic.extract_hu_lu(),_3_tiao_cnt:%d,dui_zi_cnt:%d,",_3_tiao_cnt,dui_zi_cnt))

    --3条排序
    table.sort(out_3_tiao_card_, sort_table_logic_value_desc)

    local _3_tiao_arrays = {}
    for i=1,_3_tiao_cnt do
        _3_tiao_arrays[i] = {}
        _3_tiao_arrays[i] = logic.copy_table_part(out_3_tiao_card_, 1+(i-1)*3, 3)
    end

    local dui_zi_arrays = {}
    for i=1,dui_zi_cnt do
        dui_zi_arrays[i] = {}
        dui_zi_arrays[i] = logic.copy_table_part(out_dui_zi_card_, 1+(i-1)*2, 2)
    end

    for i=1,_3_tiao_cnt do
        for j=1,dui_zi_cnt do
            
            for k,v in ipairs(_3_tiao_arrays[i]) do
                out_card_[#out_card_+1] = v
            end

            for k,v in ipairs(dui_zi_arrays[j]) do
                out_card_[#out_card_+1] = v
            end

            out_card_cnt_[#out_card_cnt_ + 1] = 5
        end
    end
 
    return out_card_,out_card_cnt_
end

--提取牌型:所有四条
function logic.extract_4_tiao(cards)
    --返回牌型
    local out_card_ = {}
    local out_card_cnt_ = {}

    if(#cards < 4) then return out_card_,out_card_cnt_ end

    --排序
    local tmp_cards = logic.copy_table_remove_nil(cards)
    table.sort(tmp_cards, sort_table_logic_value_asc)

    local i=1
    while i<#tmp_cards do

        local value = logic.get_card_value(tmp_cards[i])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)

        if(same_value_cnt >= 4) then

            out_card_[#out_card_+1] = tmp_cards[i]
            out_card_[#out_card_+1] = tmp_cards[i+1]
            out_card_[#out_card_+1] = tmp_cards[i+2]
            out_card_[#out_card_+1] = tmp_cards[i+3]

            out_card_cnt_[#out_card_cnt_+1] = 4

            i = i+same_value_cnt

        else
            i = i+1
        end

    end

    --4条排序
    table.sort(out_card_, sort_table_logic_value_desc)

    return out_card_,out_card_cnt_
end

--提取牌型:所有同花顺
function logic.extract_tong_hua_shun(cards)

    local out_card_ = {}
    local out_card_cnt_ = {}

    --返回牌型
    if(#cards < 5) then return out_card_,out_card_cnt_ end

    --分成4个颜色牌
    local color_cards = {}
    for i=1,4 do
        color_cards[i] = {}
    end

    for i=1,#cards do
        local clr = logic.get_card_color(cards[i])
        -- print(string.format("\r\nlogic.extract_tong_hua_shun(),i:%d,clr:%d, ",i,clr+1))
        color_cards[clr+1][ 1+#color_cards[clr+1] ] = cards[i] 
    end

    for i=1,4 do        
        --print(string.format("\r\nlogic.extract_tong_hua_shun(),i:%d,#color_cards[i]:%d,牌: ",i,#color_cards[i]))
        --logic.debug_print_table(color_cards[i], true) 
    end

    for i=1,4 do        
        if(#color_cards[i] >= 5) then

            local shun_zi_card_,shun_zi_cards_cnt_= logic.extract_shun_zi(color_cards[i])

            if(#shun_zi_cards_cnt_ >= 1) then

                for k,v in ipairs(shun_zi_card_) do
                    out_card_[#out_card_+1] = shun_zi_card_[k]
                end

                for k,v in ipairs(shun_zi_cards_cnt_) do
                    out_card_cnt_[#out_card_cnt_+1] = shun_zi_cards_cnt_[k]
                end

            end

        end
    end

    return out_card_,out_card_cnt_
end
--]]

-------------------------------------------------
--{{my_extract_card
--


--提取散牌:
function my_extract_card.open_card(cards, dao_index)

    print("my_extract_card.open_card()")

    if(dao_index<1 or dao_index>3) then assert(false);return false,{} end

    if(dao_index == 1) then

        local fun_order_index_ =
        {
            my_extract_card.card_type_3_tiao,
            my_extract_card.card_type_dui_zi,
            my_extract_card.card_type_san_pai,
        };

        for k,v in pairs(fun_order_index_) do

            local new_card_ = fun_order_index_[k](cards, dao_index)
            if(#new_card_ > 0) then  return true,new_card_ end

        end

        return false,{}
    else

        local fun_order_index_ =
        {
            my_extract_card.card_type_bomb,
            my_extract_card.card_type_tong_hua_shun,
            my_extract_card.card_type_4_tiao,
            my_extract_card.card_type_hu_lu,
            my_extract_card.card_type_tong_hua,
            my_extract_card.card_type_shun_zi,
            my_extract_card.card_type_2_dui,

            my_extract_card.card_type_3_tiao,
            my_extract_card.card_type_dui_zi,
            my_extract_card.card_type_san_pai,
        };

        for k,v in pairs(fun_order_index_) do

            local new_card_ = fun_order_index_[k](cards, dao_index)
            if(#new_card_ > 0) then  return true,new_card_ end

        end

        return false,{}
    end

end


--提取散牌:
function my_extract_card.card_type_san_pai(cards, dao_index)

    --返回牌型
    local out_cards = {}

    local tmp_cards = logic.copy_table_remove_nil(cards)

    --排序
    table.sort(tmp_cards, sort_table_logic_value_asc)

    if(dao_index == 1) then
        if(#tmp_cards < 3) then return out_cards end

        local tmp_out_cards = {}

        for i=1,2 do
            tmp_out_cards[i] = tmp_cards[i]
        end
        tmp_out_cards[1+#tmp_out_cards] = tmp_cards[#tmp_cards]

        if(#tmp_out_cards ~= 3) then return out_cards end

        out_cards = logic.copy_table(tmp_out_cards)
        return out_cards

    else
        if(#tmp_cards < 5) then return out_cards end

        local tmp_out_cards = {}

        for i=1,4 do
            tmp_out_cards[i] = tmp_cards[i]
        end
        tmp_out_cards[1+#tmp_out_cards] = tmp_cards[#tmp_cards]

        if(#tmp_out_cards ~= 5) then return out_cards end

        out_cards = logic.copy_table(tmp_out_cards)
        return out_cards
    end

end

--提取对子:最大的对子,最小的散牌
function my_extract_card.card_type_dui_zi(cards, dao_index)

    --返回牌型
    local out_cards = {}

    local out_dui_zi_cards = {}
    local out_1_cards = {}

    local total_card_ = logic.copy_table_remove_nil(cards)

    if(dao_index == 1) then
        if(#total_card_ < 3) then return out_cards end

        --对子
        local tmp_out_dui_zi_cards = logic.extract_dui_zi(total_card_)
        if(#tmp_out_dui_zi_cards < 2) then return out_cards end

        --找到最大的对子
        table.sort(tmp_out_dui_zi_cards, sort_table_logic_value_desc)
        for i=1,2 do
            out_dui_zi_cards[1+#out_dui_zi_cards] = tmp_out_dui_zi_cards[i]
        end

        --删除掉最大对子之后
        local new_cards = logic.delete_cards(total_card_, out_dui_zi_cards)

        for k,v in ipairs(new_cards) do

            local value = logic.get_card_value(new_cards[k])
            local same_value_cnt = logic.find_value_cnt(new_cards, value)

            if(same_value_cnt == 1) then
                out_1_cards[1 + #out_1_cards] = new_cards[k]

                if(#out_1_cards == 1) then
                    break
                end
            end
        end

        if(#out_1_cards < 1) then

            for k,v in ipairs(new_cards) do

                local value = logic.get_card_value(new_cards[k])
                local same_value_cnt = logic.find_value_cnt(new_cards, value)

                if(same_value_cnt >= 2) then
                    out_1_cards[1 + #out_1_cards] = new_cards[k]

                    if(#out_1_cards == 1) then
                        break
                    end
                end
            end

        end

        --合起来
        if(#out_dui_zi_cards ~= 2) then return out_cards end
        if(#out_1_cards ~= 1) then return out_cards end

        for k,v in ipairs(out_dui_zi_cards) do
            out_cards[#out_cards+1] = v
        end
        for k,v in ipairs(out_1_cards) do
            out_cards[#out_cards+1] = v
        end

        return out_cards
    end

    if(#total_card_ < 5) then return out_cards end

    --对子
    local tmp_out_dui_zi_cards = logic.extract_dui_zi(total_card_)
    if(#tmp_out_dui_zi_cards < 2) then return out_cards end

    --找到最大的对子
    table.sort(tmp_out_dui_zi_cards, sort_table_logic_value_desc)
    for i=1,2 do
        out_dui_zi_cards[1+#out_dui_zi_cards] = tmp_out_dui_zi_cards[i]
    end

    --删除掉最大对子之后
    local new_cards = logic.delete_cards(total_card_, out_dui_zi_cards)

    --print(string.format("\r\nmy_extract_card.dui_zi(),全部的牌:%d,", #cards))
    --logic.debug_print_table(cards, true)

    --print(string.format("\r\nmy_extract_card.dui_zi(),对子:%d,", #out_dui_zi_cards))
    --logic.debug_print_table(out_dui_zi_cards, true)

    --print(string.format("\r\nmy_extract_card.dui_zi(),剩下的牌:%d,", #new_cards))
    --logic.debug_print_table(new_cards, true)

    --找到最小的散牌
    table.sort(new_cards, sort_table_logic_value_asc)

    for k,v in ipairs(new_cards) do

        local value = logic.get_card_value(new_cards[k])
        local same_value_cnt = logic.find_value_cnt(new_cards, value)

        if(same_value_cnt == 1) then
            out_1_cards[1 + #out_1_cards] = new_cards[k]

            if(#out_1_cards == 3) then
                break
            end
        end
    end

    if(#out_1_cards < 3) then

        for k,v in ipairs(new_cards) do

            local value = logic.get_card_value(new_cards[k])
            local same_value_cnt = logic.find_value_cnt(new_cards, value)

            if(same_value_cnt >= 2) then
                out_1_cards[1 + #out_1_cards] = new_cards[k]

                if(#out_1_cards == 3) then
                    break
                end
            end
        end

    end

    --合起来
    if(#out_dui_zi_cards ~= 2) then return out_cards end
    if(#out_1_cards ~= 3) then return out_cards end

    for k,v in ipairs(out_dui_zi_cards) do
        out_cards[#out_cards+1] = v
    end
    for k,v in ipairs(out_1_cards) do
        out_cards[#out_cards+1] = v
    end

    return out_cards
end


--提取2对:最大的对子,最小的对子,最小的散牌
function my_extract_card.card_type_2_dui(cards, dao_index)

    --返回牌型
    local out_cards = {}

    local out_dui_zi_cards = {}
    local out_1_cards = {}

    local total_card_ = logic.copy_table_remove_nil(cards)

    if(#total_card_ < 5) then return out_cards end
    if(dao_index == 1) then return out_cards end

    --对子
    local tmp_out_dui_zi_cards = logic.extract_dui_zi(total_card_)
    if(#tmp_out_dui_zi_cards < 4) then return out_cards end

    --找到最大的对子,最小的对子
    table.sort(tmp_out_dui_zi_cards, sort_table_logic_value_asc)
    for i=1,2 do
        out_dui_zi_cards[1+#out_dui_zi_cards] = tmp_out_dui_zi_cards[i]
    end

    table.sort(tmp_out_dui_zi_cards, sort_table_logic_value_desc)
    for i=1,2 do
        out_dui_zi_cards[1+#out_dui_zi_cards] = tmp_out_dui_zi_cards[i]
    end

    --删除掉最大对子，最小的对子之后
    local new_cards = logic.delete_cards(total_card_, out_dui_zi_cards)

    --print(string.format("\r\n全部的牌:%d,", #cards))
    --logic.debug_print_table(cards, true)

    --print(string.format("\r\n两对:%d,", #out_dui_zi_cards))
    --logic.debug_print_table(out_dui_zi_cards, true)

    --print(string.format("\r\n剩下的牌:%d,", #new_cards))
    --logic.debug_print_table(new_cards, true)

    --找到最小的散牌
    table.sort(new_cards, sort_table_logic_value_asc)

    for k,v in ipairs(new_cards) do

        local value = logic.get_card_value(new_cards[k])
        local same_value_cnt = logic.find_value_cnt(new_cards, value)

        if(same_value_cnt == 1) then
            out_1_cards[1 + #out_1_cards] = new_cards[k]

            if(#out_1_cards == 1) then
                break
            end
        end
    end

    if(#out_1_cards < 1) then

        for k,v in ipairs(new_cards) do

            local value = logic.get_card_value(new_cards[k])
            local same_value_cnt = logic.find_value_cnt(new_cards, value)

            if(same_value_cnt >= 2) then
                out_1_cards[1 + #out_1_cards] = new_cards[k]

                if(#out_1_cards == 1) then
                    break
                end
            end
        end

    end

    --合起来
    if(#out_dui_zi_cards ~= 4) then return out_cards end
    if(#out_1_cards ~= 1) then return out_cards end

    for k,v in ipairs(out_dui_zi_cards) do
        out_cards[#out_cards+1] = v
    end
    for k,v in ipairs(out_1_cards) do
        out_cards[#out_cards+1] = v
    end

    return out_cards
end


--提取3条:最大的三条,最小的散牌
function my_extract_card.card_type_3_tiao(cards, dao_index)

    --返回牌型
    local out_cards = {}

    local out_3_tiao_cards = {}
    local out_1_cards = {}

    local total_card_ = logic.copy_table_remove_nil(cards)

    if(#total_card_ < 5) then return out_cards end

    --一道
    if(dao_index == 1) then

        --3条牌
        local tmp_out_3_tiao_cards = logic.extract_3_tiao(total_card_)
        if(#tmp_out_3_tiao_cards < 3) then return out_cards end

        --找到最大的三条
        table.sort(tmp_out_3_tiao_cards, sort_table_logic_value_desc)

        for i=1,3 do
            out_3_tiao_cards[1+#out_3_tiao_cards] = tmp_out_3_tiao_cards[i]
        end

        for k,v in ipairs(out_3_tiao_cards) do
            out_cards[#out_cards+1] = v
        end

        return out_cards
    end

    --3条牌
    local tmp_out_3_tiao_cards = logic.extract_3_tiao(total_card_)
    if(#tmp_out_3_tiao_cards < 3) then return out_cards end

    --print(string.format("\r\n三条:%d,", #tmp_out_3_tiao_cards))
    --logic.debug_print_table(tmp_out_3_tiao_cards, true)


    --找到最大的三条
    table.sort(tmp_out_3_tiao_cards, sort_table_logic_value_desc)

    for i=1,3 do
        out_3_tiao_cards[1+#out_3_tiao_cards] = tmp_out_3_tiao_cards[i]
    end

    --print(string.format("\r\n三条:%d,", #out_3_tiao_cards))
    --logic.debug_print_table(out_3_tiao_cards, true)

    --删除掉最大的三条之后
    local new_cards = logic.delete_cards(total_card_, out_3_tiao_cards)

    --[[
    print(string.format("\r\n全部的牌:%d,", #cards))
    logic.debug_print_table(cards, true)

    print(string.format("\r\n三条:%d,", #out_3_tiao_cards))
    logic.debug_print_table(out_3_tiao_cards, true)

    print(string.format("\r\n剩下的牌:%d,", #new_cards))
    logic.debug_print_table(new_cards, true)
    --]]

    --找到最小的散牌
    table.sort(new_cards, sort_table_logic_value_asc)

    for k,v in ipairs(new_cards) do

        local value = logic.get_card_value(new_cards[k])
        local same_value_cnt = logic.find_value_cnt(new_cards, value)

        if(same_value_cnt == 1) then
            out_1_cards[1 + #out_1_cards] = new_cards[k]

            if(#out_1_cards == 2) then
                break
            end
        end
    end

    if(#out_1_cards < 2) then

        for k,v in ipairs(new_cards) do

            local value = logic.get_card_value(new_cards[k])
            local same_value_cnt = logic.find_value_cnt(new_cards, value)

            if(same_value_cnt >= 2) then
                out_1_cards[1 + #out_1_cards] = new_cards[k]

                if(#out_1_cards == 2) then
                    break
                end
            end
        end

    end

    --合起来
    if(#out_3_tiao_cards ~= 3) then return out_cards end
    if(#out_1_cards ~= 2) then return out_cards end

    for k,v in ipairs(out_3_tiao_cards) do
        out_cards[#out_cards+1] = v
    end
    for k,v in ipairs(out_1_cards) do
        out_cards[#out_cards+1] = v
    end

    return out_cards
end

--提取顺子:最大的顺子
function my_extract_card.card_type_shun_zi(cards, dao_index)

    --返回牌型
    local out_cards = {}

    if(dao_index == 1) then 
        --[[
        if(#cards ~= 3) then assert(false);return out_cards end
         
        local shun_zi_cards,shun_zi_cards_cnt = logic.extract_shun_zi(cards)

        print(shun_zi_cards)
        print(shun_zi_cards_cnt)

        if(#shun_zi_cards_cnt ~= 1) then  return out_cards end
        if(#shun_zi_cards ~= 3) then  return out_cards end
        
        out_cards = logic.copy_table(shun_zi_cards)
        --]]
        return out_cards
    end

    if(#cards < 5) then return out_cards end

    local shun_zi_cards,shun_zi_cards_cnt = logic.extract_shun_zi(cards)
    if(#shun_zi_cards_cnt <= 0) then  return out_cards end

    print(string.format("\r\nmy_extract_card.shun_zi(),顺子:%d,全部的牌:%d,", #shun_zi_cards_cnt, #shun_zi_cards))
    logic.debug_print_table(shun_zi_cards, true)

    local shun_zi_cnt = #shun_zi_cards_cnt

    print(string.format("\r\nmy_extract_card.shun_zi(),顺子个数shun_zi_cnt:%d,", shun_zi_cnt))

    --只有一条顺子
    if(shun_zi_cnt == 1) then

        my_extract_card.card_type_shun_zi_helper(cards,shun_zi_cards)
        assert(#shun_zi_cards>=5)

        out_cards = logic.copy_table_part(shun_zi_cards, #shun_zi_cards-4, 5)
    else

        local tmp_shun_zi_cards_ = {}
        for i=1,shun_zi_cnt do
            tmp_shun_zi_cards_[i] = {}
        end

        local start_index = 1
        for i=1,shun_zi_cnt do
            tmp_shun_zi_cards_[i] = logic.copy_table_part(shun_zi_cards, start_index, shun_zi_cards_cnt[i])
            start_index = start_index+shun_zi_cards_cnt[i]
        end

        --如果有多的顺子[头尾的牌]，可以和其他牌组成对子，则放到下道去组合对子
        for i=1,shun_zi_cnt do
            my_extract_card.card_type_shun_zi_helper(cards,tmp_shun_zi_cards_[i])
            assert(#tmp_shun_zi_cards_[i]>=5)
        end

        for i=1,shun_zi_cnt do
            print(string.format("\r\nmy_extract_card.shun_zi(),顺子:%d,顺子个数:%d,全部的牌:,", i,#tmp_shun_zi_cards_[i]))
            logic.debug_print_table(tmp_shun_zi_cards_[i], true)
        end

        --选择大的一个顺子
        local max_index = 0
        local max_card = 0

        for i=1,shun_zi_cnt do

            local tmp_max_card = tmp_shun_zi_cards_[i][#tmp_shun_zi_cards_[i]]

            if(max_card == 0) then
                max_index = i
                max_card = tmp_max_card
            else
                if(my_compare_card.compare_1_card(max_card, tmp_max_card) == true) then
                    max_index = i
                    max_card = tmp_max_card
                end
            end

            --logic.debug_print_table(_5_cnt_tong_hua_cards_[i], true)
        end

        if(max_index~=0 and max_index>=1 and max_index<=shun_zi_cnt) then
            --out_cards = tmp_shun_zi_cards_[max_index]
            out_cards = logic.copy_table_part(tmp_shun_zi_cards_[max_index], #tmp_shun_zi_cards_[max_index]-4, 5)
        end

    end

   return out_cards
end

--如果顺子个数多余5个，则可以后道组成对子，3条的，不放在顺子里
function my_extract_card.card_type_shun_zi_helper(total_card_,shun_zi_card_)

    if(type(total_card_) ~= "table") then assert(false);return false end
    if(type(shun_zi_card_) ~= "table") then assert(false);return false end
    
    if(#shun_zi_card_ <= 5) then return false end

    --排序，降序
    logic.sort_card_type_shun_zi_desc(shun_zi_card_)

    --需要查找是否有对子
    --如果顺子中有多出的牌张数，则搜索，如果有对子的牌，放到下道去
    if(#shun_zi_card_ > 5) then
     
        --可能被删除的牌
        local maybe_delete_card_ = {}

        local index = #shun_zi_card_
        for i=1,#shun_zi_card_-5 do
            maybe_delete_card_[#maybe_delete_card_+1] = shun_zi_card_[index]
            index = index-1
        end

        local is_delete = false

        local copy_maybe_delete_card_ = logic.copy_table(maybe_delete_card_)
        local need_delete_card_cnt = #maybe_delete_card_
        while(need_delete_card_cnt > 0) do

            --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),#maybe_delete_card_:%d,可能删除的牌:,", #maybe_delete_card_))
            --logic.debug_print_table(maybe_delete_card_, true)

            for k,v in pairs(maybe_delete_card_) do

                local value = logic.get_card_value(v)
                --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),value:0x%02x,",value))

                if(logic.find_value_cnt(total_card_, value) >= 2) then
                
                    --要删除的牌
                    local delete_card_ = {}

                    for i=1,#copy_maybe_delete_card_ do

                        delete_card_[#delete_card_+1] = copy_maybe_delete_card_[i]

                        if(logic.get_card_value(copy_maybe_delete_card_[i]) == value) then                        
                            break 
                        end

                    end

                    --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),要删除牌个数#delete_card_:%d,", #delete_card_))
                    --logic.debug_print_table(delete_card_, true)

                    --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),顺子牌个数#shun_zi_card_:%d", #shun_zi_card_))
                    --logic.debug_print_table(shun_zi_card_, true)

                    shun_zi_card_ = logic.delete_cards(shun_zi_card_, delete_card_)

                    --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),删除后,顺子牌个数#shun_zi_card_:%d", #shun_zi_card_))
                    --logic.debug_print_table(shun_zi_card_, true)

                    copy_maybe_delete_card_ = logic.delete_cards(copy_maybe_delete_card_, delete_card_)

                    --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),删除后,需要删除的牌个数#copy_maybe_delete_card_:%d", #copy_maybe_delete_card_))
                    --logic.debug_print_table(copy_maybe_delete_card_, true)

                    is_delete = true
                    
                end

                local delete_card_ = {}
                delete_card_[#delete_card_+1] = v
                maybe_delete_card_ = logic.delete_cards(maybe_delete_card_, delete_card_)
                need_delete_card_cnt = #maybe_delete_card_

                break 
                     
            end

        end

        --如果没有查找到删除的大对子
        --则从顺子的最小端开始再次查找
        if(is_delete == false) then

            --可能被删除的牌
            local maybe_delete_card_ = {}

            local index = 1
            for i=1,#shun_zi_card_-5 do
                maybe_delete_card_[#maybe_delete_card_+1] = shun_zi_card_[index]
                index = index+1
            end
             
            local copy_maybe_delete_card_ = logic.copy_table(maybe_delete_card_)
            local need_delete_card_cnt = #maybe_delete_card_
            while(need_delete_card_cnt > 0) do

                --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),#maybe_delete_card_:%d,可能删除的牌:,", #maybe_delete_card_))
                --logic.debug_print_table(maybe_delete_card_, true)

                for k,v in pairs(maybe_delete_card_) do

                    local value = logic.get_card_value(v)
                    --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),value:0x%02x,",value))

                    if(logic.find_value_cnt(total_card_, value) >= 2) then
                    
                        --要删除的牌
                        local delete_card_ = {}

                        for i=1,#copy_maybe_delete_card_ do

                            delete_card_[#delete_card_+1] = copy_maybe_delete_card_[i]

                            if(logic.get_card_value(copy_maybe_delete_card_[i]) == value) then                        
                                break 
                            end

                        end

                        --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),要删除牌个数#delete_card_:%d,", #delete_card_))
                        --logic.debug_print_table(delete_card_, true)

                        --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),顺子牌个数#shun_zi_card_:%d", #shun_zi_card_))
                        --logic.debug_print_table(shun_zi_card_, true)

                        shun_zi_card_ = logic.delete_cards(shun_zi_card_, delete_card_)

                        --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),删除后,顺子牌个数#shun_zi_card_:%d", #shun_zi_card_))
                        --logic.debug_print_table(shun_zi_card_, true)

                        copy_maybe_delete_card_ = logic.delete_cards(copy_maybe_delete_card_, delete_card_)

                        --print(string.format("\r\nmy_extract_card.card_type_shun_zi_helper(),删除后,需要删除的牌个数#copy_maybe_delete_card_:%d", #copy_maybe_delete_card_))
                        --logic.debug_print_table(copy_maybe_delete_card_, true)

                        is_delete = true
                        
                    end

                    local delete_card_ = {}
                    delete_card_[#delete_card_+1] = v
                    maybe_delete_card_ = logic.delete_cards(maybe_delete_card_, delete_card_)
                    need_delete_card_cnt = #maybe_delete_card_

                    break 
                         
                end

            end

        end

    end

    --排序，升序
    logic.sort_card_type_shun_zi_asc(shun_zi_card_)

    return true
end

--提取同花:最大的同花散牌,最小的同花散牌
function my_extract_card.card_type_tong_hua(cards, dao_index) 
    --print(string.format("\r\nmy_extract_card.card_type_tong_hua(),#cards:%d,dao_index:%d,", #cards, dao_index))
    --logic.debug_print_table(cards, true)

    --返回牌型
    local out_cards = {}

    if(#cards < 5) then return out_cards end
    if(dao_index == 1) then return out_cards end

    --同花
    local tmp_out_tong_hua_cards_cnt,tmp_out_tong_hua_cards = my_extract_card.card_type_tong_hua_ex(cards)
    if(#tmp_out_tong_hua_cards < 1) then return out_cards end

    local tong_hua_cnt = #tmp_out_tong_hua_cards_cnt
    --print(string.format("\r\nmy_extract_card.card_type_tong_hua(),同花个数:%d,", tong_hua_cnt))
    --logic.debug_print_table(tmp_out_tong_hua_cards, true)

    local tong_hua_cards_ = {}
    for i=1,tong_hua_cnt do
        tong_hua_cards_[i] = {}
    end

    local start_index =1
    for i=1,tong_hua_cnt do
        tong_hua_cards_[i] = logic.copy_table_part(tmp_out_tong_hua_cards,start_index,tmp_out_tong_hua_cards_cnt[i])
        start_index = start_index + tmp_out_tong_hua_cards_cnt[i]
    end

    for i=1,tong_hua_cnt do
        --print(string.format("\r\nmy_extract_card.card_type_tong_hua(),全部的牌:%d,", #tong_hua_cards_[i]))
        --logic.debug_print_table(tong_hua_cards_[i], true)
    end
    --]]

    --排序,从大到小
    for i=1,tong_hua_cnt do
        table.sort(tong_hua_cards_[i], sort_table_logic_value_desc)

        --print(string.format("\r\nmy_extract_card.card_type_tong_hua(),同花的牌:%d,", #tong_hua_cards_[i]))
        --logic.debug_print_table(tong_hua_cards_[i], true)
    end

    --5张
    local _5_cnt_tong_hua_cards_ = {}
    for i=1,tong_hua_cnt do
        _5_cnt_tong_hua_cards_[i] = {}
    end

    for i=1,tong_hua_cnt do
        
        --需要查找是否有对子
        --如果同花有多出的牌张数，则搜索，如果有对子的牌，放到下道去
        if(#tong_hua_cards_[i] > 5) then
            
            local card_cnt = #tong_hua_cards_[i]
            while(card_cnt > 5) do
                
                local is_find = false

                for k,v in pairs(tong_hua_cards_[i]) do
                    local value = logic.get_card_value(v)
                    if(logic.find_value_cnt(cards, value) >= 2) then
                        
                        local delete_card_ = {}
                        delete_card_[#delete_card_+1] = v

                        --print(string.format("\r\nmy_extract_card.card_type_tong_hua(),i:%d,同花牌个数:%d,删除:0x%02x,", i,card_cnt,v))

                        tong_hua_cards_[i] = logic.delete_cards(tong_hua_cards_[i], delete_card_)
                        card_cnt = #tong_hua_cards_[i]
                        is_find = true
                        break 
                    end
                end

                if(is_find == false) then break end
            end

        end

        --排序,从小到大
        table.sort(tong_hua_cards_[i], sort_table_logic_value_asc)
        
        _5_cnt_tong_hua_cards_[i] = logic.copy_table_part(tong_hua_cards_[i], 1, 4)
        --最大的
        _5_cnt_tong_hua_cards_[i][1+#_5_cnt_tong_hua_cards_[i]] = tong_hua_cards_[i][#tong_hua_cards_[i]]
    end

    --排序
    --for i=1,tong_hua_cnt do
    --   table.sort(tong_hua_cards_[i], sort_table_logic_value_asc)
    --end

    for i=1,tong_hua_cnt do
        --print(string.format("\r\n5张 全部的牌:%d,", #_5_cnt_tong_hua_cards_[i]))
        --logic.debug_print_table(_5_cnt_tong_hua_cards_[i], true)
    end

    if(tong_hua_cnt == 1) then
        out_cards = _5_cnt_tong_hua_cards_[1]
    else

        local max_index = 0
        local max_card = 0

        for i=1,tong_hua_cnt do

            local tmp_max_card = logic.get_max_logic_card(_5_cnt_tong_hua_cards_[i])

            if(max_card == 0) then
                max_index = i
                max_card = tmp_max_card
            else
                if(my_compare_card.compare_1_card(max_card, tmp_max_card) == true) then
                    max_index = i
                    max_card = tmp_max_card
                end
            end

            --logic.debug_print_table(_5_cnt_tong_hua_cards_[i], true)
        end

        if(max_index~=0 and max_index>=1 and max_index<=tong_hua_cnt) then
            out_cards = _5_cnt_tong_hua_cards_[max_index]
        end

    end

    return out_cards
end

--提取牌型:所有同花
function my_extract_card.card_type_tong_hua_ex(cards)
    --返回牌型
    local out_cards = {}
    local out_cards_cnt = {}

    if(#cards < 5) then return out_cards end

    local color_cnt = logic.color_cnt(cards)

    --print(string.format("\r\nmy_extract_card.card_type_tong_hua_ex(),#cards:%d,", #cards))
    --logic.debug_print_table(color_cnt, false)

    for k,v in ipairs(color_cnt) do
        if(v >= 5) then

            for k1,v1 in ipairs(cards) do

                if(logic.get_card_color(v1) == (k-1)) then
                     out_cards[#out_cards+1] = v1
                end
            end

            out_cards_cnt[1+#out_cards_cnt] = v
        end
    end

    --print(string.format("\r\nmy_extract_card.card_type_tong_hua_ex(),#out_cards_cnt:%d,", #out_cards_cnt)) 
    --logic.debug_print_table(out_cards, true)
    --logic.debug_print_table(out_cards_cnt, false)

    return out_cards_cnt,out_cards
end

--提取葫芦:最大的三条,最小的对子
function my_extract_card.card_type_hu_lu(cards, dao_index)

    --返回牌型
    local out_cards = {}

    if(#cards < 5) then return out_cards end
    if(dao_index == 1) then return out_cards end

    local tmp_cards = logic.copy_table_remove_nil(cards)

    --3条牌
    local tmp_out_3_tiao_cards = logic.extract_3_tiao(tmp_cards)
    if(#tmp_out_3_tiao_cards < 3) then return out_cards end

    local out_3_tiao_cards = {}
    local out_dui_zi_cards = {}

    --找到最大的三条
    table.sort(tmp_out_3_tiao_cards, sort_table_logic_value_desc)

    for i=1,3 do
        out_3_tiao_cards[1+#out_3_tiao_cards] = tmp_out_3_tiao_cards[i]
    end

    --删除掉最大的三条之后
    local new_cards = logic.delete_cards(tmp_cards, out_3_tiao_cards)

    --print(string.format("\r\n全部的牌:%d,", #cards))
    --logic.debug_print_table(cards, true)

    --print(string.format("\r\n三条:%d,", #out_3_tiao_cards))
    --logic.debug_print_table(out_3_tiao_cards, true)

    --print(string.format("\r\n剩下的牌:%d,", #new_cards))
    --logic.debug_print_table(new_cards, true)

    --找到最小的对子
    local tmp_out_dui_zi_cards = logic.extract_dui_zi(new_cards)
    if(#tmp_out_dui_zi_cards < 2) then return out_cards end

    table.sort(tmp_out_dui_zi_cards, sort_table_logic_value_asc)

    for i=1,2 do
        out_dui_zi_cards[1+#out_dui_zi_cards] = tmp_out_dui_zi_cards[i]
    end

    --合起来
    if(#out_3_tiao_cards ~= 3) then return out_cards end
    if(#out_dui_zi_cards ~= 2) then return out_cards end

    for k,v in ipairs(out_3_tiao_cards) do
        out_cards[#out_cards+1] = v
    end
    for k,v in ipairs(out_dui_zi_cards) do
        out_cards[#out_cards+1] = v
    end

    return out_cards
end

--提取4条:最大的四条,最小的单牌
function my_extract_card.card_type_4_tiao(cards, dao_index)
    --返回牌型
    local out_cards = {}

    if(#cards < 4) then return out_cards end
    if(dao_index == 1) then return out_cards end

    local out_4_tiao_cards = {}
    local out_1_cards = {}

    --排序
    local tmp_cards = logic.copy_table(cards)
    table.sort(tmp_cards, sort_table_logic_value_desc)

    --logic.debug_print_table(tmp_cards)
    --return nil

    for k,v in ipairs(tmp_cards) do

        local value = logic.get_card_value(tmp_cards[k])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)

        if(same_value_cnt >= 4) then

            out_4_tiao_cards[#out_4_tiao_cards+1] = tmp_cards[k]
            out_4_tiao_cards[#out_4_tiao_cards+1] = tmp_cards[k+1]
            out_4_tiao_cards[#out_4_tiao_cards+1] = tmp_cards[k+2]
            out_4_tiao_cards[#out_4_tiao_cards+1] = tmp_cards[k+3]

            break
        end

    end

    --找到最小的单牌
    local new_cards = logic.delete_cards(tmp_cards,out_4_tiao_cards)
    table.sort(new_cards, sort_table_logic_value_asc)

    --print(string.format("\r\n全部的牌:%d,", #tmp_cards))
    --logic.debug_print_table(tmp_cards, true)

    --print(string.format("\r\n四条:%d,", #out_4_tiao_cards))
    --logic.debug_print_table(out_4_tiao_cards, true)

    --print(string.format("\r\n剩下的牌:%d,", #new_cards))
    --logic.debug_print_table(new_cards, true)

    for k,v in ipairs(new_cards) do

        local value = logic.get_card_value(new_cards[k])
        local same_value_cnt = logic.find_value_cnt(new_cards, value)

        --print(string.format("\r\n,i:%d,value:%d,same_value_cnt:%d,", i,value,same_value_cnt))

        if(same_value_cnt == 1) then
            out_1_cards[1 + #out_1_cards] = new_cards[k]
            break
        end

    end

    --如果单牌没有找到
    if(#out_1_cards < 1) then

        for k,v in ipairs(new_cards) do

            local value = logic.get_card_value(new_cards[k])
            local same_value_cnt = logic.find_value_cnt(new_cards, value)

            --print(string.format("\r\n,i:%d,value:%d,same_value_cnt:%d,", i,value,same_value_cnt))

            if(same_value_cnt >= 2) then
                out_1_cards[1 + #out_1_cards] = new_cards[k]
                break
            end

        end
    end

    --合起来
    if(#out_4_tiao_cards ~= 4) then return out_cards end
    if(#out_1_cards ~= 1) then return out_cards end

    for k,v in ipairs(out_4_tiao_cards) do
        out_cards[#out_cards+1] = v
    end
    for k,v in ipairs(out_1_cards) do
        out_cards[#out_cards+1] = v
    end

    return out_cards
end

--提取同花顺:最大的同花顺
function my_extract_card.card_type_tong_hua_shun(cards, dao_index)

    --返回牌型
    local out_cards = {}

    if(#cards < 5) then return out_cards end
    if(dao_index == 1) then return out_cards end

    local shun_zi_cards = logic.extract_tong_hua_shun(cards)
    if(#shun_zi_cards <= 0) then  return out_cards end

    --print(string.format("\r\nmy_extract_card.card_type_tong_hua_shun(),同花顺:%d,全部的牌:,", #shun_zi_cards))
    --logic.debug_print_table(shun_zi_cards, true)

    --分开
    local tong_hua_shun_cards_ = {}
    for i=1,2 do
        tong_hua_shun_cards_[i] = {}
    end

    local clr = 0x00
    local index =1
    for k,v in ipairs(shun_zi_cards) do

        local tmp_clr = logic.get_card_color(v)

        if(k == 1) then clr = tmp_clr;tong_hua_shun_cards_[index][1+#tong_hua_shun_cards_[index]] = v

        else
            if(tmp_clr == clr) then
                tong_hua_shun_cards_[index][1+#tong_hua_shun_cards_[index]] = v
            else
                clr = tmp_clr
                index = index + 1
                tong_hua_shun_cards_[index][1+#tong_hua_shun_cards_[index]] = v
            end
        end
    end

    local shun_zi_cnt = 0
    for i=1,2 do
        --print(string.format("\r\n my_extract_card.card_type_tong_hua_shun(),同花顺:%d,全部的牌:,", i,#tong_hua_shun_cards_[i]))
        if(#tong_hua_shun_cards_[i] > 0) then
            --logic.debug_print_table(tong_hua_shun_cards_[i], true)
            shun_zi_cnt = shun_zi_cnt+1
        end
    end

    --只有一条顺子
    if(shun_zi_cnt == 1) then
        out_cards = logic.copy_table_part(tong_hua_shun_cards_[1], #tong_hua_shun_cards_[1]-4, 5)
    else

        local tmp_shun_zi_cards_ = {}
        for i=1,shun_zi_cnt do
            tmp_shun_zi_cards_[i] = {}
        end

        for i=1,shun_zi_cnt do
            tmp_shun_zi_cards_[i] = logic.copy_table_part(tong_hua_shun_cards_[i], 1, 5)
        end

        for i=1,shun_zi_cnt do
            --print(string.format("\r\nmy_extract_card.card_type_tong_hua_shun(),顺子:%d,顺子个数:%d,全部的牌:,", i,#tmp_shun_zi_cards_[i]))
            --logic.debug_print_table(tmp_shun_zi_cards_[i], true)
        end

        --选择大的一个顺子
        local max_index = 0
        local max_card = 0

        for i=1,shun_zi_cnt do

            local tmp_max_card = tmp_shun_zi_cards_[i][#tmp_shun_zi_cards_[i]]

            if(max_card == 0) then
                max_index = i
                max_card = tmp_max_card
            else
                if(my_compare_card.compare_1_card(max_card, tmp_max_card) == true) then
                    max_index = i
                    max_card = tmp_max_card
                end
            end

            --logic.debug_print_table(_5_cnt_tong_hua_cards_[i], true)
        end

        if(max_index~=0 and max_index>=1 and max_index<=shun_zi_cnt) then
            out_cards = tmp_shun_zi_cards_[max_index]
        end

    end

   return out_cards

end

--提取炸弹：最大的炸弹
function my_extract_card.card_type_bomb(cards, dao_index)
    --返回牌型
    local out_cards = {}

    if(#cards < 5) then return out_cards end
    if(dao_index == 1) then return out_cards end

    --排序
    local tmp_cards = logic.copy_table(cards)
    table.sort(tmp_cards, sort_table_logic_value_desc)

    for k,v in ipairs(tmp_cards) do

        local value = logic.get_card_value(tmp_cards[k])
        local same_value_cnt = logic.find_value_cnt(tmp_cards, value)

        if(same_value_cnt >= 5) then

            out_cards[#out_cards+1] = tmp_cards[k]
            out_cards[#out_cards+1] = tmp_cards[k+1]
            out_cards[#out_cards+1] = tmp_cards[k+2]
            out_cards[#out_cards+1] = tmp_cards[k+3]
            out_cards[#out_cards+1] = tmp_cards[k+4]

            break
        end

    end
    
    return out_cards
end

--
--my_extract_card}}
-------------------------------------------------



--普通牌型[9种]
--

--普通牌型:对子
function my_card_type.is_card_type_dui_zi(cards)
  if(#cards < 2) then return  false end

  local tmp_cards, poker_num = extract_jokers(cards)
  if poker_num > 1 then return false end
  local values = logic.value_cnt(tmp_cards)

  local _2 = 0
  for i=1,#values,1 do
    if(values[i] == 2) then _2=_2+1 end
  end

	return (poker_num == 0 and _2 == 1) or (poker_num == 1 and _2 == 0)
end

--普通牌型:两对
function my_card_type.is_card_type_2_dui(cards)
  if(#cards < 4) then return  false end

  local tmp_cards, poker_num = extract_jokers(cards)
  if poker_num > 1 then return false end
  local values = logic.value_cnt(tmp_cards)

  local _2 = 0
  for i=1,#values,1 do
    if(values[i] == 2) then _2=_2+1 end
  end

	return (poker_num == 0 and _2 == 2) or (poker_num == 1 and _2 == 1)
end

--普通牌型:三条
function my_card_type.is_card_type_3_tiao(cards)
  if(#cards < 3) then return  false end

  local tmp_cards, poker_num = extract_jokers(cards)
  if poker_num > 3 then return false end
  local values = logic.value_cnt(tmp_cards)

  local _1 = 0
  local _2 = 0
  local _3 = 0
  for i=1,#values,1 do
    if(values[i] == 2) then _2=_2+1
    elseif(values[i] == 3) then _3=_3+1
    elseif(values[i] == 1) then _1=_1+1
    end
  end

	return (poker_num == 0 and _3 == 1) or (poker_num == 1 and _2 == 1) or (poker_num == 2 and _2 + _3 == 0) or (poker_num == 3 and _1 + _2 + _3 == 0)
end

--普通牌型:顺子
function my_card_type.is_card_type_shun_zi(cards)
  if(#cards < 3) then return  false end

  local tmp_cards, poker_num = extract_jokers(cards)
  local shun_zi_table = gen_shun_zi_table(tmp_cards)
  local n = #cards
  local m = n - poker_num
  for i = 1, 14 - n + 1 do
    local num = 0
    for j = i, i + n - 1 do
      if shun_zi_table[j] > 0 then num = num + 1 end
    end
    if num == m then return true end
  end
  
  return false
end

--普通牌型:同花
function my_card_type.is_card_type_tong_hua(cards)
  if(#cards < 3) then return  false end
  
  local tmp_cards, poker_num = extract_jokers(cards)

  local colors = logic.color_cnt(tmp_cards)
  for i,v in ipairs(colors) do
      if(v + poker_num == #cards) then return true end
  end

  return false
end

--普通牌型:葫芦
function my_card_type.is_card_type_hu_lu(cards)
  if(#cards ~= 5) then return false end

  local tmp_cards, poker_num = extract_jokers(cards)
  if poker_num > 1 then return false end
  
  local values = logic.value_cnt(tmp_cards)

  local _1 = 0
  local _2 = 0
  local _3 = 0
  for i=1,#values,1 do
    if(values[i] == 2) then _2=_2+1
    elseif(values[i] == 3) then _3=_3+1
    elseif(values[i] == 1) then _1=_1+1
    end
  end

  return (poker_num == 0 and _2 == 1 and _3 == 1) or (poker_num == 1 and (_2 == 2 or (_3 == 1 and _1 == 1)))
end

--普通牌型:四条
function my_card_type.is_card_type_4_tiao(cards)
  if(#cards < 4) then return  false end

  local tmp_cards, poker_num = extract_jokers(cards)
  local values = logic.value_cnt(tmp_cards)

  local _4 = 0
  for i=1,#values,1 do
      if(values[i] + poker_num == 4) then _4=_4+1 end
  end

  if(_4 >= 1) then return true end

	return false
end

--普通牌型:同花顺
function my_card_type.is_card_type_tong_hua_shun(cards)
  return  my_card_type.is_card_type_tong_hua(cards) and my_card_type.is_card_type_shun_zi(cards)
end

--普通牌型:炸弹
function my_card_type.is_card_type_bomb(cards)
  if(#cards < 5) then return  false end

  local tmp_cards, poker_num = extract_jokers(cards)
  local values = logic.value_cnt(tmp_cards)

  local _5 = 0
  for i=1,#values,1 do
      if(values[i] + poker_num == 5) then _5=_5+1 end
  end

  if(_5 == 1) then return true end

  return false
end

--特殊牌型[14种]
--

--特殊牌型:青龙：同花且A到K
function my_special_card_type.is_special_card_type_qing_long(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

	local is = my_special_card_type.is_special_card_type_1_tiao_long(cards)
	if(is ~= true) then return false end

    local colors = logic.color_cnt(cards)
	--debug_print_table(colors)

	for i,v in ipairs(colors) do
		--print(string.format("logic.is_special_card_type_qing_long(),i:%d,v:%d",i,v))
		if(v == PLAYER_CARD_CNT) then return true end
	end

	return false
end

--特殊牌型:全红：13张红色（方块、红桃）的牌
function my_special_card_type.is_special_card_type_quan_hong(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local colors = logic.color_cnt(cards)
	--debug_print_table(colors)

    if((colors[1]+colors[3]) == PLAYER_CARD_CNT) then return true end

    return false
end

--特殊牌型:全黑：13张黑色（梅花、黑桃）的牌
function my_special_card_type.is_special_card_type_quan_hei(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local colors = logic.color_cnt(cards)
	--debug_print_table(colors)

    if((colors[2]+colors[4]) == PLAYER_CARD_CNT) then return true end


    return false
end

--特殊牌型:全红一点黑：即是13张有12张是红的1张是黑的
function my_special_card_type.is_special_card_type_quan_hong_1_dian_hei(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local colors = logic.color_cnt(cards)
	--debug_print_table(colors)

    if((colors[1]+colors[3]) == (PLAYER_CARD_CNT-1)) then return true end

    return false
end

--特殊牌型:全黑一点红：即是13张有12张是黑的1张是红的
function my_special_card_type.is_special_card_type_quan_hei_1_dian_hong(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local colors = logic.color_cnt(cards)
	--debug_print_table(colors)

	if((colors[2]+colors[4]) == (PLAYER_CARD_CNT-1)) then return true end

    return false
end

--特殊牌型:一条龙：A到K
function my_special_card_type.is_special_card_type_1_tiao_long(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

	--debug_print_table(values)

    --排序
    table.sort(values)

	--debug_print_table(values)

    for i=1,(#values-1),1 do
        if((values[i+1]-values[i]) ~= 1) then return false end
    end

    return true
end

--特殊牌型:5对一刻：5组对子，一个三条
function my_special_card_type.is_special_card_type_5_dui_1_ke(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = logic.value_cnt(cards)
	--debug_print_table(values)

    local _2 = 0
    local _3 = 0

    for i=1,#values,1 do
        if(values[i] == 3) then _3=_3+1
        elseif(values[i] == 2) then _2=_2+1
        elseif(values[i] == 4) then _2=_2+2
        end
    end

    if(_3 ~= 1) then return false end
    if(_2 ~= 5) then return false end

    return true
end

--特殊牌型:全小：2到10
function my_special_card_type.is_special_card_type_quan_xiao(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

    --debug_print_table(values)

    for i,v in ipairs(values) do
        if(v<2 or v>10) then return false end
    end

    return true
end

--特殊牌型:全大：6到K
function my_special_card_type.is_special_card_type_quan_da(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

    --debug_print_table(values)

    for i,v in ipairs(values) do
        if(v<6 or v>0x0D) then return false end
    end

    return true
end

--特殊牌型:6对半：6组对子，一张单牌
function my_special_card_type.is_special_card_type_6_dui_ban(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = logic.value_cnt(cards)
	--debug_print_table(values)

    local _2 = 0

    for i=1,#values,1 do
        if(values[i]%2 == 0) then _2=_2+math.ceil(values[i]/2) end
    end

    if(_2 ~= 6) then return false end

    return true
end

--特殊牌型:半小：A到10
function my_special_card_type.is_special_card_type_ban_xiao(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

    --debug_print_table(values)

    for i,v in ipairs(values) do
        if(v<1 or v>0x0A) then return false end
    end

    return true
end

--特殊牌型:半大：6到A
function my_special_card_type.is_special_card_type_ban_da(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_logic_value(v)
    end

    --debug_print_table(values)

    for i,v in ipairs(values) do
        if(v<0x06 or v>0x0E) then return false end
    end

    return true
end

--特殊牌型:三花：3道都是同花
function my_special_card_type.is_special_card_type_3_hua(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    --是否同花(如果是同花，牌型算做全红或全黑)
    local is_tong_hua = my_card_type.is_card_type_tong_hua(cards)
    if(is_tong_hua == true) then return false end

    local colors = logic.color_cnt(cards)
	--debug_print_table(colors)

    local cnt = 0
    for i,v in ipairs(colors) do
        if(v >= 5) then colors[i] = colors[i]-5;cnt=cnt+5; end
    end
	--debug_print_table(colors)

    for i,v in ipairs(colors) do
        if(v >= 3) then colors[i] = colors[i]-3;cnt=cnt+3; end
    end
	--debug_print_table(colors)

    return (cnt==PLAYER_CARD_CNT)
end


--特殊牌型:三顺：3道都是顺子
function my_special_card_type.is_special_card_type_3_shun(cards)
    if(#cards ~= PLAYER_CARD_CNT) then return  false end

    --得到A的个数
    local ACnt = logic.find_value_cnt(cards, 0x01)

    for i,v in ipairs(cards) do

        local tmp_cards = logic.copy_table(cards)

        --A做0x01,或者0x0E
        for k=0,ACnt do

            logic.logic_a_cnt = k
            print("A做 0x0E 的个数 :" .. k)

            --值表
            local value_table = logic.value_table_14(tmp_cards)
            if(value_table == nil) then assert(false); return false end
	        --debug_print_table(value_table)

            --顺子表
            local shun_zi_table = logic.from_values_2_shun_zi_table(value_table)
            if(shun_zi_table == nil) then assert(false); return false end
	        --debug_print_table(shun_zi_table)

            for j=i,#shun_zi_table do
                if(shun_zi_table[j]>=3)  then

                    local out_card_table_ = {}

                    print("is_special_card_type_3_shun()," ..i,j .. ">=3")
                    local is = my_special_card_type.is_special_card_type_3_shun_ex(tmp_cards,j,nil, out_card_table_)

                    --如果是三顺,返回A作为逻辑0x0E的个数
                    if(is == true) then return true,out_card_table_ end
                end
            end

        end
    end

    logic.logic_a_cnt = 0

    return false
end

--特殊牌型:三顺：3道都是顺子
function my_special_card_type.is_special_card_type_3_shun_ex(cards, _1_dao_start_index,orderindex,out_card_table_)
    --if(#cards ~= PLAYER_CARD_CNT) then return  false end

    orderindex = orderindex or 1
    --print("is_special_card_type_3_shun_ex(),orderindex:" .. orderindex)

    local tmp_cards = logic.copy_table(cards)

    local value_table = logic.value_table_14(tmp_cards)
    if(value_table == nil) then assert(false); return false end
	--debug_print_table(value_table)

    --顺子表
    local shun_zi_table = logic.from_values_2_shun_zi_table(value_table)
    if(shun_zi_table == nil) then assert(false); return false end

    --print("\r\nlogic.is_special_card_type_3_shun_ex(),is_special_card_type_3_shun_ex(),shun_zi_table:")
	--logic.debug_print_table(shun_zi_table)

    for i,v in ipairs(shun_zi_table) do

        if(_1_dao_start_index == i) then

            --1道
            if((orderindex==1) and (v>=3))  then
                --print("is_special_card_type_3_shun_ex(),一道，删牌:1")

                --保存总牌
                local tmp_tmp_cards = logic.copy_table(tmp_cards)

                local new_cards = logic.delete_table_item(tmp_cards, 3, i)

                local shun_zi_card_ = logic.delete_cards(tmp_tmp_cards, new_cards)
                
                --保存顺子牌 
                for k,v in ipairs(shun_zi_card_) do
                    out_card_table_[1+#out_card_table_] = v
                end

                --print("is_special_card_type_3_shun_ex(),一道，删牌:2")
                orderindex = orderindex+1
                --print("is_special_card_type_3_shun_ex(),一道，删牌:3")
                return my_special_card_type.is_special_card_type_3_shun_ex(new_cards, nil, orderindex,out_card_table_)
            end
        end

        if(_1_dao_start_index == nil) then

            --2道，3道
            if((orderindex>=2) and (v>=5)) then

                --保存总牌
                local tmp_tmp_cards = logic.copy_table(tmp_cards)

                local new_cards = logic.delete_table_item(tmp_cards, 5, i)

                local shun_zi_card_ = logic.delete_cards(tmp_tmp_cards, new_cards)
                
                --保存顺子牌 
                for k,v in ipairs(shun_zi_card_) do
                    out_card_table_[1+#out_card_table_] = v
                end

                orderindex = orderindex+1
                if(orderindex == 4) then return true end

                return my_special_card_type.is_special_card_type_3_shun_ex(new_cards, nil, orderindex,out_card_table_)
            end
        end

    end

    return false
end

--是否特殊牌型
function logic.is_special_card_type(cards)
    local tmp_cards, joker_num = extract_jokers(cards)
    if joker_num > 0 then return false end
    local funs =
    {
        -- my_special_card_type.is_special_card_type_qing_long,
        my_special_card_type.is_special_card_type_quan_hong,
        my_special_card_type.is_special_card_type_quan_hei,
        my_special_card_type.is_special_card_type_quan_hong_1_dian_hei,
        my_special_card_type.is_special_card_type_quan_hei_1_dian_hong,

        my_special_card_type.is_special_card_type_1_tiao_long,
        my_special_card_type.is_special_card_type_5_dui_1_ke,
        my_special_card_type.is_special_card_type_quan_xiao,
        my_special_card_type.is_special_card_type_quan_da,
        my_special_card_type.is_special_card_type_6_dui_ban,

        my_special_card_type.is_special_card_type_ban_xiao,
        my_special_card_type.is_special_card_type_ban_da,
        my_special_card_type.is_special_card_type_3_hua,
        my_special_card_type.is_special_card_type_3_shun,
    }

    for k,v in pairs(funs) do
        if(v(cards) == true) then return true end
    end

    return false
end

--得到牌型(同时满足两种牌型的时候,返回大牌型)
function logic.get_card_type(cards)

    local card_type = CARD_TYPE.CARD_TYPE_NULL
    if(type(cards) ~= "table") then assert(false);return card_type end

    local card_cnt = #cards
    --print(string.format("\r\nlogic.get_card_type(),card_cnt:%d,",card_cnt))
    if(card_cnt < 3) then assert(false);return card_type end

    --全副牌
    if(card_cnt == PLAYER_CARD_CNT) then        
        local tmp_cards, joker_num = extract_jokers(cards)
        if joker_num > 0 then return CARD_TYPE.CARD_TYPE_SAN_PAI end
        --if(my_special_card_type.is_special_card_type_qing_long(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QING_LONG
        if(my_special_card_type.is_special_card_type_quan_hong(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HONG
        elseif(my_special_card_type.is_special_card_type_quan_hei(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HEI
        elseif(my_special_card_type.is_special_card_type_quan_hong_1_dian_hei(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HONG_1_DIAN_HEI
        elseif(my_special_card_type.is_special_card_type_quan_hei_1_dian_hong(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HEI_1_DIAN_HONG

        elseif(my_special_card_type.is_special_card_type_1_tiao_long(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_1_TIAO_LONG
        elseif(my_special_card_type.is_special_card_type_5_dui_1_ke(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_5_DUI_1_KE
        elseif(my_special_card_type.is_special_card_type_quan_xiao(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_XIAO
        elseif(my_special_card_type.is_special_card_type_quan_da(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_DA
        elseif(my_special_card_type.is_special_card_type_6_dui_ban(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_6_DUI_BAN

        elseif(my_special_card_type.is_special_card_type_ban_xiao(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_BAN_XIAO
        elseif(my_special_card_type.is_special_card_type_ban_da(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_BAN_DA
        elseif(my_special_card_type.is_special_card_type_3_hua(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_3_HUA
        elseif(my_special_card_type.is_special_card_type_3_shun(cards)) then return CARD_TYPE.CARD_TYPE_SPECIAL_3_SHUN

        else return CARD_TYPE.CARD_TYPE_SAN_PAI end
    end

    --5张
    if(card_cnt == 5 or card_cnt == 4) then
        if(my_card_type.is_card_type_bomb(cards)) then return CARD_TYPE.CARD_TYPE_BOMB
        elseif(my_card_type.is_card_type_tong_hua_shun(cards)) then return CARD_TYPE.CARD_TYPE_TONG_HUA_SHUN
        elseif(my_card_type.is_card_type_4_tiao(cards)) then return CARD_TYPE.CARD_TYPE_4_TIAO
        elseif(my_card_type.is_card_type_hu_lu(cards)) then return CARD_TYPE.CARD_TYPE_HU_LU
        elseif(my_card_type.is_card_type_tong_hua(cards)) then return CARD_TYPE.CARD_TYPE_TONG_HUA
        elseif(my_card_type.is_card_type_shun_zi(cards)) then return CARD_TYPE.CARD_TYPE_SHUN_ZI
        elseif(my_card_type.is_card_type_3_tiao(cards)) then return CARD_TYPE.CARD_TYPE_3_TIAO
        elseif(my_card_type.is_card_type_2_dui(cards)) then return CARD_TYPE.CARD_TYPE_2_DUI
        elseif(my_card_type.is_card_type_dui_zi(cards)) then return CARD_TYPE.CARD_TYPE_DUI_ZI

        else return CARD_TYPE.CARD_TYPE_SAN_PAI end
    end

    --3张
    if(card_cnt == 3 or card_cnt == 2) then

        if(my_card_type.is_card_type_dui_zi(cards)) then return CARD_TYPE.CARD_TYPE_DUI_ZI
        elseif(my_card_type.is_card_type_3_tiao(cards)) then return CARD_TYPE.CARD_TYPE_3_TIAO

        else return CARD_TYPE.CARD_TYPE_SAN_PAI end
    end

    return card_type
end


--删除表中的元素
function logic.delete_table_item(total_table,cnt,value)

    if(type(total_table) ~= "table") then assert(false);return nil end
    if(#total_table < cnt) then assert(false);return nil end

    --print(string.format("\r\nlogic.delete_table_item(),删除个数:%d,删除起始牌值:%d,总牌个数:%d,总牌:",cnt, value, #total_table))
    --logic.debug_print_table(total_table, true)

    local delete_cnt = 0
    for i=1,cnt,1 do

        local value_delete = value+i-1
        --print(string.format("\r\nlogic.delete_table_item(),value_delete:%d,",value_delete))

        for k,v in pairs(total_table) do
            if(v ~= nil) then
                local get_value = logic.get_card_value(v)
                --print(get_value)

                --删除逻辑A
                if(logic.logic_a_cnt>0) then
                    if(value_delete==0x0E and get_value==0x01) then logic.logic_a_cnt=logic.logic_a_cnt-1;delete_cnt=delete_cnt+1;total_table[k] = nil break end
                end

                if(get_value == value_delete) then delete_cnt=delete_cnt+1;total_table[k] = nil break end
            end
        end
    end

    if(cnt ~= delete_cnt) then
        --print(string.format("\r\nlogic.delete_table_item(),需要删除的个数:%d,已经删除的个数:%d,logic.logic_a_cnt:%d,",cnt,delete_cnt,logic.logic_a_cnt))
        assert(false);
    end

    local new_table = {}
    for i,v in pairs(total_table) do
        if(v ~= nil) then new_table[1+#new_table] = v end
    end

    --print(string.format("\r\nlogic.delete_table_item(),删除后,个数:%d,新牌:",#new_table))
    --logic.debug_print_table(new_table, true)

    return new_table
end

--删除表中的元素
function logic.delete_card(total_cards,delete_card)
    local new_table = {}

    if(type(total_cards) ~= "table") then assert(false);return new_table end

    for k,v in ipairs(total_cards) do
        if(v ~= delete_card) then
            new_table[#new_table + 1] = v
        end
    end
    return new_table
end

--删除表中的元素
function logic.delete_cards(total_cards,delete_cards)
    local new_table = {}

    if(type(total_cards) ~= "table") then assert(false);return new_table end
    if(type(delete_cards) ~= "table") then assert(false);return new_table end


    for k,v in ipairs(delete_cards) do
        for k1,v1 in pairs(total_cards) do
            if(v == v1) then
                total_cards[k1] = nil
                break
            end
        end
    end

    for k1,v1 in pairs(total_cards) do
        new_table[#new_table + 1] = v1
    end

    return new_table
end


--比较
--

--比较散牌
function my_compare_card.compare_card_type_san_pai(cards_source, cards_dest)
    local tmp_cards_source_ = logic.copy_table(cards_source)
    local tmp_cards_dest_ = logic.copy_table(cards_dest)
  
    --排序
    table.sort(tmp_cards_source_, sort_table_logic_value_desc)
    table.sort(tmp_cards_dest_, sort_table_logic_value_desc)
  
    for i=1,#tmp_cards_source_ do
      if tmp_cards_dest_[i] then
        local logic_value_source = logic.get_card_logic_value(tmp_cards_source_[i])
        local logic_value_dest = logic.get_card_logic_value(tmp_cards_dest_[i])
    
        if(logic_value_source ~= logic_value_dest) then return logic_value_dest>logic_value_source and -1 or 1 end 
      end
    end
    if #tmp_cards_source_ ~= #tmp_cards_dest_ then
      if #tmp_cards_source_ > #tmp_cards_dest_ then
        return 1
      else
        return -1
      end
    end

    for i=1,#tmp_cards_source_ do
      local tmp_ret = my_compare_card.compare_1_card(tmp_cards_source_[i], tmp_cards_dest_[i])
      if tmp_ret ~= 0 then return tmp_ret end
    end  
    
    return 0
end

local function mask_jokers_dui_zi(cards, joker_num)
  local mask_cards = {}
  for _, card in ipairs(cards) do
    table.insert(mask_cards, card)
  end
  table.sort(mask_cards, sort_table_logic_value_desc)
  local card_value = logic.get_card_value(mask_cards[1])
  for i = 1, joker_num do 
    table.insert(mask_cards, 4 * 16 + card_value)
  end
  
  return mask_cards
end

--比较对子
function my_compare_card.compare_card_type_dui_zi(cards_source, cards_dest)

    local card_type_source = logic.get_card_type(cards_source)
    if(card_type_source ~= CARD_TYPE.CARD_TYPE_DUI_ZI) then assert(false); return -1 end

    local card_type_dest = logic.get_card_type(cards_dest)
    if(card_type_dest ~= CARD_TYPE.CARD_TYPE_DUI_ZI) then assert(false); return 1 end

    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    if poker_num_source > 0 then tmp_cards_source = mask_jokers_dui_zi(tmp_cards_source, poker_num_source) end
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    if poker_num_dest > 0 then tmp_cards_dest = mask_jokers_dui_zi(tmp_cards_dest, poker_num_dest) end

    local max_card_source = 0
    local max_card_dest = 0

    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 2) then max_card_source=v;break end
    end

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 2) then max_card_dest=v;break end
    end

    --print(string.format("\r\nmy_compare_card.compare_card_type_dui_zi(),max_card_source:0x%02x,max_card_dest:0x%02x,", max_card_source,max_card_dest))

    --对子值不相等
    if(logic.get_card_logic_value(max_card_source) ~= logic.get_card_logic_value(max_card_dest)) then
        return logic.get_card_logic_value(max_card_dest)>logic.get_card_logic_value(max_card_source) and -1 or 1
    end

    --比较散牌
    local single_card_source_ = {}
    local single_card_dest_ = {}

    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) ~= 2) then 
            single_card_source_[#single_card_source_+1] = v
        end
    end

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) ~= 2) then 
            single_card_dest_[#single_card_dest_+1] = v
        end
    end

	--降序排列
	table.sort(single_card_source_, sort_table_logic_value_desc)
	table.sort(single_card_dest_, sort_table_logic_value_desc)

    --print(string.format("\r\nmy_compare_card.compare_card_type_dui_zi(),单牌降序排序之后:"))
    --logic.debug_print_table(single_card_source_, true)
    --logic.debug_print_table(single_card_dest_, true)

    for i=1,#single_card_source_ do
        if(logic.get_card_logic_value(single_card_source_[i]) ~= logic.get_card_logic_value(single_card_dest_[i])) then
            return logic.get_card_logic_value(single_card_dest_[i])>logic.get_card_logic_value(single_card_source_[i]) and -1 or 1
        end
    end

    --如果散牌也一样大，比较最大的散牌的花色
    return my_compare_card.compare_1_card(single_card_source_[1], single_card_dest_[1])
end

local function mask_jokers_2_dui(cards, poker_num)
  local ret_cards = logic.copy_table_remove_nil(cards)
  table.sort(ret_cards, sort_table_logic_value_desc)
  local card_value
  for i = 1, #ret_cards do
    if logic.find_value_cnt(ret_cards, logic.get_card_value(ret_cards[i])) == 1 then
      card_value = logic.get_card_value(ret_cards[i])
      break
    end
  end
  
  if card_value then table.insert(ret_cards, 4 * 16 + card_value) end
  return ret_cards
end

--比较两对
function my_compare_card.compare_card_type_2_dui(cards_source, cards_dest)
    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    if poker_num_source > 0 then tmp_cards_source = mask_jokers_2_dui(tmp_cards_source, poker_num_source) end
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    if poker_num_dest > 0 then tmp_cards_dest = mask_jokers_2_dui(tmp_cards_dest, poker_num_dest) end
    
    local max_card_source = {}
    local max_card_dest = {}

    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 2) then

            local same_cnt = 0
            for k1,v1 in ipairs(max_card_source) do
                if(logic.get_card_value(v) == logic.get_card_value(v1)) then same_cnt=same_cnt+1 break end
            end

            if(same_cnt <= 0) then max_card_source[1+#max_card_source]=v end
        end
    end
    --debug_print_table(max_card_source)

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 2) then

            local same_cnt = 0
            for k1,v1 in ipairs(max_card_dest) do
                if(logic.get_card_value(v) == logic.get_card_value(v1)) then same_cnt=same_cnt+1 break end
            end

            if(same_cnt <= 0) then max_card_dest[1+#max_card_dest]=v end
        end
    end
    --debug_print_table(max_card_dest)

    if(#max_card_source ~= 2) then assert(false);return -1 end
    if(#max_card_dest ~= 2) then assert(false);return 1 end

	--降序排列
	table.sort(max_card_source, sort_table_logic_value_desc)
	table.sort(max_card_dest, sort_table_logic_value_desc)

	for i=1,#max_card_source, 1 do

		if(logic.get_card_logic_value(max_card_dest[i]) > logic.get_card_logic_value(max_card_source[i])) then return -1 end
		if(logic.get_card_logic_value(max_card_dest[i]) < logic.get_card_logic_value(max_card_source[i])) then return 1 end

	end

	--依然相等，则比较最后一张散牌
	local san_card_source = 0
    for k,v in ipairs(cards_source) do
        if(logic.find_value_cnt(cards_source, logic.get_card_value(v)) == 1) then

			san_card_source = v
			break ;

        end
    end

	local san_card_dest = 0
    for k,v in ipairs(cards_dest) do
        if(logic.find_value_cnt(cards_dest, logic.get_card_value(v)) == 1) then

			san_card_dest = v
			break ;

        end
    end

    return my_compare_card.compare_1_card(san_card_source, san_card_dest)
end

local function mask_jokers_3_tiao(cards, joker_num)
  local ret_cards = logic.copy_table_remove_nil(cards)
  if joker_num == 1 then
    local card_value
    for _, card in ipairs(ret_cards) do
      if logic.find_value_cnt(ret_cards, logic.get_card_value(card)) == 2 then
        card_value = logic.get_card_value(card)
        break
      end
    end
    if card_value then table.insert(ret_cards, 4 * 16 + card_value) end
  elseif joker_num == 2 then
    table.sort(ret_cards, sort_table_logic_value_desc)
    local card_value = logic.get_card_value(ret_cards[1])
    table.insert(ret_cards, 4 * 16 + card_value)
    table.insert(ret_cards, 4 * 16 + card_value)
  elseif joker_num == 3 then
    table.insert(ret_cards, 0x41)
    table.insert(ret_cards, 0x41)
    table.insert(ret_cards, 0x41)
  end
  
  return ret_cards
end

--比较三条
function my_compare_card.compare_card_type_3_tiao(cards_source, cards_dest)
    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    if poker_num_source > 0 then tmp_cards_source = mask_jokers_3_tiao(tmp_cards_source, poker_num_source) end
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    if poker_num_dest > 0 then tmp_cards_dest = mask_jokers_3_tiao(tmp_cards_dest, poker_num_dest) end

    local max_card_source = 0
    local max_card_dest = 0

    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 3) then max_card_source=v end
    end

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 3) then max_card_dest=v end
    end

    local result = my_compare_card.compare_1_card(max_card_source, max_card_dest)
    if result ~= 0 then return result end
    
    local san_pai_source = {}
    local san_pai_dest = {}
    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 1) then table.insert(san_pai_source, v) end
    end

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 1) then table.insert(san_pai_dest, v) end
    end
    
    return my_compare_card.compare_card_type_san_pai(san_pai_source, san_pai_dest)
end

local function mask_jokers_shun_zi(cards, joker_num, clr)
  local ret_cards = logic.copy_table_remove_nil(cards)
  local shun_zi_table = gen_shun_zi_table(ret_cards)
  for i = 1, #shun_zi_table - 5 + 1 do
    if shun_zi_table[i] > 0 then
      if not IN_SHX and shun_zi_table[1] == 0 and joker_num >= i - 1 then
        for j = 1, i - 1 do
          table.insert(ret_cards, clr * 16 + j)
        end
        local n = i - 1
        for j = i + 1, 5 do
          if shun_zi_table[j] == 0 then
            table.insert(ret_cards, clr * 16 + j)
            n = n + 1
          end
        end
        if n == joker_num then
          break
        else
          ret_cards = logic.copy_table_remove_nil(cards)
        end
      end
      for j = i + 1, i + 4 do
        if shun_zi_table[j] == 0 then
          card_value = j
          if j == 14 then card_value = 1 end
          table.insert(ret_cards, clr * 16 + card_value)
        end
      end
      break
    end
  end
  
  if #ret_cards ~= 5 then
    local n = 0
    for i = 10, #shun_zi_table do
      if shun_zi_table[i] == 0 then
        local card_value = i
        if i == 14 then card_value = 1 end
        table.insert(ret_cards, clr * 16 + card_value)
        n = n + 1
      end
    end
    assert(n == joker_num, "mask_jokers_shun_zi assert fail")
  end
  
  return ret_cards
end

local function adjust_shun_zi(cards)
  if logic.get_card_value(cards[1]) == 1 and logic.get_card_value(cards[2]) == 5 then
    local card = cards[1]
    table.remove(cards, 1)
    table.insert(cards, card)
  end
end

local function compare_card_type_shun_zi_ex(cards_source, cards_dest, useclr)
  local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
  if poker_num_source > 0 then tmp_cards_source = mask_jokers_shun_zi(tmp_cards_source, poker_num_source, useclr and logic.get_card_color(tmp_cards_source[1]) or 4) end
  local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
  if poker_num_dest > 0 then tmp_cards_dest = mask_jokers_shun_zi(tmp_cards_dest, poker_num_dest, useclr and logic.get_card_color(tmp_cards_dest[1]) or 4) end
  
  table.sort(tmp_cards_source, sort_table_logic_value_desc)
  table.sort(tmp_cards_dest, sort_table_logic_value_desc)
  if IN_SHX then
    adjust_shun_zi(tmp_cards_source)
    adjust_shun_zi(tmp_cards_dest)
  end
  for i = 1, 2 do
    local logic_value_source = logic.get_card_logic_value(tmp_cards_source[i])
    local logic_value_dest = logic.get_card_logic_value(tmp_cards_dest[i])
    if logic_value_source ~= logic_value_dest then
      return logic_value_source > logic_value_dest and 1 or -1
    end
  end
  
  for i = 1, 5 do
    local ret = my_compare_card.compare_1_card(tmp_cards_source[i], tmp_cards_dest[i])
    if ret ~= 0 then
      return ret
    end
  end
  return 0
end

--比较顺子
function my_compare_card.compare_card_type_shun_zi(cards_source, cards_dest)
    return compare_card_type_shun_zi_ex(cards_source, cards_dest, false)
    --[[
   --找到最大牌
    local is_shun_zi_source,max_card_source = logic.is_shun_zi(cards_source)
    if(is_shun_zi_source == false) then

        --print(string.format("is_shun_zi_source:%s,",tostring(is_shun_zi_source)))
        local is_shun_zi_source2,max_card_source2 = logic.is_shun_zi_logic_value(cards_source)

        is_shun_zi_source = is_shun_zi_source2
        max_card_source = max_card_source2

        --print(string.format("is_shun_zi_source:%s,max_card_source:%d,",tostring(is_shun_zi_source), max_card_source))

    end
    if(is_shun_zi_source == false) then assert(false) return true end

    local is_shun_zi_dest,max_card_dest = logic.is_shun_zi(cards_dest)
    if(is_shun_zi_dest == false) then
        local is_shun_zi_dest2,max_card_dest2 = logic.is_shun_zi_logic_value(cards_dest)
        is_shun_zi_dest = is_shun_zi_dest2
        max_card_dest = max_card_dest2
    end
    if(is_shun_zi_dest == false) then assert(false) return false end

    --print(string.format("max_card_source:%d,max_card_dest:%d,",max_card_source, max_card_dest))

    return my_compare_card.compare_1_card(max_card_source, max_card_dest)
    --]]
end

local function mask_jokers_tong_hua(cards, joker_num)
  local ret_cards = logic.copy_table_remove_nil(cards)
  local color = logic.get_card_color(ret_cards[1])
  for i = 1, joker_num do
    table.insert(ret_cards, color * 16 + 1)
  end
  
  return ret_cards
end

--比较同花
function my_compare_card.compare_card_type_tong_hua(cards_source, cards_dest)
    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    -- if poker_num_source ~= poker_num_dest then return poker_num_source > poker_num_dest and 1 or -1 end
    tmp_cards_source = mask_jokers_tong_hua(tmp_cards_source, poker_num_source)
    tmp_cards_dest = mask_jokers_tong_hua(tmp_cards_dest, poker_num_dest)
    return my_compare_card.compare_card_type_san_pai(tmp_cards_source, tmp_cards_dest)
    --[[
    local tmp_cards_source = logic.copy_table(cards_source)
    local tmp_cards_dest = logic.copy_table(cards_dest)

    --排序
    table.sort(tmp_cards_source, sort_table_logic_value_desc)
    table.sort(tmp_cards_dest, sort_table_logic_value_desc)

    for i=1,#tmp_cards_source do
    
        local logic_value_source = logic.get_card_logic_value(tmp_cards_source[i])
        local logic_value_dest = logic.get_card_logic_value(tmp_cards_dest[i])

        if(logic_value_source ~= logic_value_dest) then return logic_value_dest>logic_value_source end 
    end
    
    --如果仍没有比较出来,比较第一张的花色 
    local max_card_source =logic.get_max_logic_card(cards_source)
    local max_card_dest =logic.get_max_logic_card(cards_dest)

    return my_compare_card.compare_1_card(max_card_source, max_card_dest)
    --]]
end

local function mask_jokers_hu_lu(cards, joker_num)
  local ret_cards = logic.copy_table_remove_nil(cards)
  table.sort(ret_cards, sort_table_logic_value_desc)
  local card_value = logic.get_card_value(ret_cards[1])
  local same_cnt = logic.find_value_cnt(ret_cards, card_value)
  if same_cnt == 1 or same_cnt == 2 then
    table.insert(ret_cards, 4 * 16 + card_value)
  else
    table.insert(ret_cards, 4 * 16 + logic.get_card_value(ret_cards[4]))
  end
  
  return ret_cards
end

--比较葫芦
function my_compare_card.compare_card_type_hu_lu(cards_source, cards_dest)
    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    if poker_num_source > 0 then tmp_cards_source = mask_jokers_hu_lu(tmp_cards_source, poker_num_source) end
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    if poker_num_dest > 0 then tmp_cards_dest = mask_jokers_hu_lu(tmp_cards_dest, poker_num_dest) end

    table.sort(tmp_cards_source, sort_table_logic_value_desc)
    local max_card_3_source, max_card_2_source
    for k,v in ipairs(tmp_cards_source) do
      if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 3) then max_card_3_source=v; break end
    end
    if max_card_3_source then
      max_card_2_source = tmp_cards_source[4]
    else
      max_card_3_source, max_card_2_source = tmp_cards_source[1], tmp_cards_source[3]
    end
    
    local max_card_3_dest, max_card_2_dest
    for k,v in ipairs(tmp_cards_dest) do
      if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 3) then max_card_3_dest=v; break end
    end
    if max_card_3_dest then
      max_card_2_dest = tmp_cards_dest[4]
    else
      max_card_3_dest, max_card_2_dest = tmp_cards_dest[1], tmp_cards_dest[3]
    end
    
    if logic.get_card_logic_value(max_card_3_source) ~= logic.get_card_logic_value(max_card_3_dest) then
      return logic.get_card_logic_value(max_card_3_dest) > logic.get_card_logic_value(max_card_3_source) and -1 or 1
    end
    if logic.get_card_logic_value(max_card_2_source) ~= logic.get_card_logic_value(max_card_2_dest) then
      return logic.get_card_logic_value(max_card_2_dest) > logic.get_card_logic_value(max_card_2_source) and -1 or 1
    end
    
    return my_compare_card.compare_1_card(max_card_3_source, max_card_3_dest)
end

local function mask_jokers_4_tiao(cards, joker_num)
  local ret_cards = logic.copy_table_remove_nil(cards)
  table.sort(ret_cards, sort_table_logic_value_desc)
  local card_value_
  if #ret_cards > 2 then
    local card_value = logic.get_card_value(ret_cards[1])
    if logic.find_value_cnt(ret_cards, card_value) > 1 then
      card_value_ = card_value
    else
      card_value_ = logic.get_card_value(ret_cards[2])
    end
  else
    card_value_ = logic.get_card_value(ret_cards[1])
  end
  
  if card_value_ then
    for i = 1, joker_num do
      table.insert(ret_cards, 4 * 16 + card_value_)
    end
  end
  
  return ret_cards
end

--比较四条
function my_compare_card.compare_card_type_4_tiao(cards_source, cards_dest)
    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    if poker_num_source > 0 then tmp_cards_source = mask_jokers_4_tiao(tmp_cards_source, poker_num_source) end
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    if poker_num_dest > 0 then tmp_cards_dest = mask_jokers_4_tiao(tmp_cards_dest, poker_num_dest) end

    local max_card_source = 0
    local max_card_dest = 0

    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 4) then max_card_source=v;break end
    end

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 4) then max_card_dest=v;break end
    end

    if logic.get_card_logic_value(max_card_source) ~= logic.get_card_logic_value(max_card_dest) then
      return logic.get_card_logic_value(max_card_source) > logic.get_card_logic_value(max_card_dest) and 1 or -1
    end
    
    local card_1_source, card_1_dest
    for k,v in ipairs(tmp_cards_source) do
        if(logic.find_value_cnt(tmp_cards_source, logic.get_card_value(v)) == 1) then card_1_source=v;break end
    end

    for k,v in ipairs(tmp_cards_dest) do
        if(logic.find_value_cnt(tmp_cards_dest, logic.get_card_value(v)) == 1) then card_1_dest=v;break end
    end
    
    if logic.get_card_logic_value(card_1_source) ~= logic.get_card_logic_value(card_1_dest) then
      return logic.get_card_logic_value(card_1_source) > logic.get_card_logic_value(card_1_dest) and 1 or -1
    end
    
    return my_compare_card.compare_1_card(max_card_source, max_card_dest)
end

--比较同花顺
function my_compare_card.compare_card_type_tong_hua_shun(cards_source, cards_dest)
    return compare_card_type_shun_zi_ex(cards_source, cards_dest, true)
end

-- 比较炸弹
function my_compare_card.compare_card_type_bomb(cards_source, cards_dest)
    local tmp_cards_source, poker_num_source = extract_jokers(cards_source)
    local tmp_cards_dest, poker_num_dest = extract_jokers(cards_dest)
    
    table.sort(tmp_cards_source, sort_table_logic_value_desc)
    table.sort(tmp_cards_dest, sort_table_logic_value_desc)

    return my_compare_card.compare_1_card(tmp_cards_source[1], tmp_cards_dest[1])
end

--比较单张牌
function my_compare_card.compare_1_card(card_source, card_dest)
    if(type(card_source) ~= "number") then assert(false);return -1 end
    if(type(card_dest) ~= "number") then assert(false);return 1 end

	--print(string.format("\r\nmy_compare_card.compare_1_card(),%d,%d,", card_source, card_dest))
    if(card_source == 0) then assert(false);return -1 end
    if(card_dest == 0) then assert(false);return 1 end

    local value_source = logic.get_card_logic_value(card_source)
    local value_dest = logic.get_card_logic_value(card_dest)

    --值相同，比较花色
    if(value_source == value_dest) then
        if logic.get_card_color(card_dest) == logic.get_card_color(card_source) then return 0
        else return logic.get_card_color(card_dest)>logic.get_card_color(card_source) and -1 or 1 end
    end

    --值不同，值大返回true
    return (value_dest>value_source) and -1 or 1
end

--比较牌型
function logic.compare_cards(cards_source, cards_dest)
    if(type(cards_source) ~= "table") then assert(false);return -1 end
    if(type(cards_dest) ~= "table") then assert(false);return 1 end

    if(#cards_source > 5) then assert(false);return -1 end
    if(#cards_dest > 5) then assert(false);return 1 end

    local card_type_source = logic.get_card_type(cards_source)
    local card_type_dest = logic.get_card_type(cards_dest)

    --print(string.format("\r\nlogic.compare_cards(),card_type_source:%d,card_type_dest:%d,", card_type_source,card_type_dest))
    if(card_type_source ~= card_type_dest) then return card_type_dest>card_type_source and -1 or 1 end

    if(card_type_source == CARD_TYPE.CARD_TYPE_DUI_ZI) then return my_compare_card.compare_card_type_dui_zi(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_2_DUI) then return my_compare_card.compare_card_type_2_dui(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_3_TIAO) then return my_compare_card.compare_card_type_3_tiao(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_SHUN_ZI) then return my_compare_card.compare_card_type_shun_zi(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_TONG_HUA) then return my_compare_card.compare_card_type_tong_hua(cards_source, cards_dest)

    elseif(card_type_source == CARD_TYPE.CARD_TYPE_HU_LU) then return my_compare_card.compare_card_type_hu_lu(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_4_TIAO) then return my_compare_card.compare_card_type_4_tiao(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_TONG_HUA_SHUN) then return my_compare_card.compare_card_type_tong_hua_shun(cards_source, cards_dest)
    elseif(card_type_source == CARD_TYPE.CARD_TYPE_BOMB) then return my_compare_card.compare_card_type_bomb(cards_source, cards_dest)

    else return my_compare_card.compare_card_type_san_pai(cards_source, cards_dest) end

end


--计算玩家三道牌总水数
function logic.cal_3_dao_total_shui_cnt_all(total_card_)
    --print(string.format("\r\nlogic.cal_3_dao_total_shui_cnt_all(),#total_card_：%d", #total_card_))
    if(#total_card_ ~= PLAYER_CARD_CNT) then assert(false); return 0 end
    
    local cards = {}
    for i=1,3 do
        cards[i] = {}
    end

    for dao_index=1,3 do
        local start_index_  = {1,4,9}
        local card_cnt_     = {3,5,5}
        cards[dao_index] = logic.copy_table_part(total_card_, start_index_[dao_index], card_cnt_[dao_index])
    end

    return logic.cal_3_dao_total_shui_cnt(cards[1],cards[2],cards[3])
end

function logic.cal_3_dao_total_shui_cnt(cards1,cards2,cards3)

    if(type(cards1) ~= "table") then assert(false); return 1 end
    if(type(cards2) ~= "table") then assert(false); return 1 end
    if(type(cards3) ~= "table") then assert(false); return 1 end

    local card_type1 = logic.get_card_type(cards1);
    local card_type2 = logic.get_card_type(cards2);
    local card_type3 = logic.get_card_type(cards3);

    local shui_cnt1 = logic.get_shui_cnt(1, card_type1)
    local shui_cnt2 = logic.get_shui_cnt(2, card_type2)
    local shui_cnt3 = logic.get_shui_cnt(3, card_type3)

    --print(string.format("card_type1:%d,card_type2:%d,card_type3:%d,shui_cnt1:%d,shui_cnt2:%d,shui_cnt3:%d, \r\n",card_type1,card_type2,card_type3,shui_cnt1,shui_cnt2,shui_cnt3))

    return shui_cnt1+shui_cnt2+shui_cnt3
end

--[[
--返回水数
--orderindex,1为头道,2为中道,3为下道

--同花顺5水(在中道为10水)
--四条4水(在中道为8水)
--葫芦1水(在中道为2水)
--三条头道为3水
--其他1水

--特殊牌型
--青龙                            52水
--全红，全黑                      26水
--全红一点黑，全黑一点红，一条龙  13水
--5对1刻                          9水
--全小，全大，6对半               6水
--半小，半大，三花，三顺          3水
--]]
function logic.get_shui_cnt(orderindex, cardtype)

    --普通牌型
    if (cardtype == CARD_TYPE.CARD_TYPE_BOMB) then
        if(orderindex == 2) then return (IN_SHX and 16 or 20)
        else return (IN_SHX and 8 or 10) end
        
    elseif(cardtype == CARD_TYPE.CARD_TYPE_TONG_HUA_SHUN) then
        if(orderindex == 2) then return 10
        else return 5 end

    elseif(cardtype == CARD_TYPE.CARD_TYPE_4_TIAO) then
        if(orderindex == 2) then return 8
        else return 4 end

    elseif(cardtype == CARD_TYPE.CARD_TYPE_HU_LU) then
        if(orderindex == 2) then return 2
        else return 1 end

    elseif(cardtype == CARD_TYPE.CARD_TYPE_3_TIAO) then
        if(orderindex == 1) then return 3
        else return 1 end

    --特殊牌型
    -- elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QING_LONG) then
    --    return 52

    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HONG) then
        return 26
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HEI) then
        return 26

    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HONG_1_DIAN_HEI) then
        return 13
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HEI_1_DIAN_HONG) then
        return 13
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_1_TIAO_LONG) then
        return 13

    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_5_DUI_1_KE) then
        return 9

    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_XIAO) then
        return 6
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_DA) then
        return 6
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_6_DUI_BAN) then
        return 6

    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_BAN_XIAO) then
        return 3
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_BAN_DA) then
        return 3
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_3_HUA) then
        return 3
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SPECIAL_3_SHUN) then
        return 3

    --其他
    else return 1 end

    return 1
end

--计算玩家三道牌总权重
function logic.cal_3_dao_total_weight_all(total_card_)
    --print(string.format("\r\nlogic.cal_3_dao_total_weight_all(),#total_card_：%d", #total_card_))
    if(#total_card_ ~= PLAYER_CARD_CNT) then assert(false); return 0 end
    
    local cards = {}
    for i=1,3 do
        cards[i] = {}
    end

    for dao_index=1,3 do
        local start_index_  = {1,4,9}
        local card_cnt_     = {3,5,5}
        cards[dao_index] = logic.copy_table_part(total_card_, start_index_[dao_index], card_cnt_[dao_index])
    end

    return logic.cal_3_dao_total_weight(cards[1],cards[2],cards[3])
end

function logic.cal_3_dao_total_weight(cards1,cards2,cards3)

    if(type(cards1) ~= "table") then assert(false); return 1 end
    if(type(cards2) ~= "table") then assert(false); return 1 end
    if(type(cards3) ~= "table") then assert(false); return 1 end

    local card_type1 = logic.get_card_type(cards1);
    local card_type2 = logic.get_card_type(cards2);
    local card_type3 = logic.get_card_type(cards3);

    local weight_cnt1 = logic.cal_weight(1, card_type1)
    local weight_cnt2 = logic.cal_weight(2, card_type2)
    local weight_cnt3 = logic.cal_weight(3, card_type3)

    return weight_cnt1+weight_cnt2+weight_cnt3
end

--计算权重
function logic.cal_weight(orderindex, cardtype)

    --散牌
    if(cardtype == CARD_TYPE.CARD_TYPE_SAN_PAI) then
        return 0

    --对子
    elseif(cardtype == CARD_TYPE.CARD_TYPE_DUI_ZI) then
        if(orderindex==1) then return 2
        elseif(orderindex==2) then return 1
        else return 0  end

    --2对
    elseif(cardtype == CARD_TYPE.CARD_TYPE_2_DUI) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 1
        else return 0 end

    --3条
    elseif(cardtype == CARD_TYPE.CARD_TYPE_3_TIAO) then
        if(orderindex==1) then return 2
        elseif(orderindex==2) then return 2
        else return 1 end

    --顺子
    elseif(cardtype == CARD_TYPE.CARD_TYPE_SHUN_ZI) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 2
        else return 1 end

    --同花
    elseif(cardtype == CARD_TYPE.CARD_TYPE_TONG_HUA) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 3
        else return 2 end
    
    --葫芦
    elseif(cardtype == CARD_TYPE.CARD_TYPE_HU_LU) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 3
        else return 3 end

    --4条
    elseif(cardtype == CARD_TYPE.CARD_TYPE_4_TIAO) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 3
        else return 3 end

    --同花顺
    elseif(cardtype == CARD_TYPE.CARD_TYPE_TONG_HUA_SHUN) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 3
        else return 4 end
    
    elseif(cardtype == CARD_TYPE.CARD_TYPE_BOMB) then
        if(orderindex==1) then return 0
        elseif(orderindex==2) then return 3
        else return 4 end

    else 
        assert(false)
        return 0
    end

end

--计算4个花色的牌张数
function logic.color_cnt(cards)
    --if(#cards ~= PLAYER_CARD_CNT) then return  false end
    if(type(cards) ~= "table") then return  false end

    local colors = {}
    for i,v in ipairs(cards) do
        colors[i] = logic.get_card_color(v)
    end

    --if(#colors ~= PLAYER_CARD_CNT) then return  false end

    local clr = {0,0,0,0}

    for i,v in ipairs(colors) do
        if(colors[i] == 0) then clr[1] = clr[1]+1
        elseif(colors[i] == 1) then clr[2] = clr[2]+1
        elseif(colors[i] == 2) then clr[3] = clr[3]+1
        elseif(colors[i] == 3) then clr[4] = clr[4]+1
        else assert(false)
		end
    end

    return clr
end

--计算值个数
function logic.value_cnt(cards)
    if(#cards < 1) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

    --13个
    local vl = {0,0,0,0,0, 0,0,0,0,0, 0,0,0,}

    for i,v in ipairs(values) do
        vl[v] = vl[v]+1
    end

    return vl
end

--计算值个数
function logic.value_table_14(cards)
    if(#cards < 1) then return nil end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

    --14个
    --local vl = {0x01,0x02,0x03,0x04,0x05, 0x06,0x07,0x08,0x09,0x0A, 0x0B,0x0C,0x0D,0x0E}
    local v2 = {0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,}

    local logic_a_cnt = 0

    for i,v in ipairs(values) do

        if(v==0x01 and logic_a_cnt<logic.logic_a_cnt) then logic_a_cnt=logic_a_cnt+1;v2[#v2]=0x0E
        else v2[v] = v end
    end

    return v2
end

--是否顺子
function logic.is_shun_zi(cards)
    if(#cards < 3) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_value(v)
    end

	--debug_print_table(values)

    --排序
    table.sort(values)

	--debug_print_table(values)

    for i=1,(#values-1),1 do
        if((values[i+1]-values[i]) ~= 1) then return false end
    end

    local maxvalue = values[#values]
    local maxcard = 0
    for i,v in ipairs(cards) do
        if(logic.get_card_value(v) == maxvalue) then maxcard = v break end
    end

    return true,maxcard
end

--是否顺子
function logic.is_shun_zi_logic_value(cards)
    if(#cards < 3) then return  false end

    local values = {}
    for i,v in ipairs(cards) do
        values[i] = logic.get_card_logic_value(v)
    end

	--debug_print_table(values)

    --排序
    table.sort(values)

	--logic.debug_print_table(values,false)

    for i=1,(#values-1),1 do
        if((values[i+1]-values[i]) ~= 1) then return false end
    end

    local maxvalue = values[#values]
    --print(string.format("maxvalue:%d,", maxvalue))

    local maxcard = 0
    for i,v in ipairs(cards) do
        if(logic.get_card_logic_value(v) == maxvalue) then maxcard = v break end
    end

    return true,maxcard
end

--是否顺子(值)
function logic.is_shun_zi_value(values)
    if(#values < 3) then return  false end

    --排序
    table.sort(values)
	--debug_print_table(values)

    for i=1,(#values-1),1 do
        if((values[i+1]-values[i]) ~= 1) then return false end
    end

    local maxvalue = values[#values]
    return true,maxvalue
end

--从值得到顺子表，每个值对应后续的顺子的牌张数
--比如      23456 89
--得到的表  54321 21
function logic.from_values_2_shun_zi_table(values)
    if(type(values) ~= "table") then return nil end
    if(#values ~= 14) then assert(false);return nil end

    --14个元素,多出来一个是因为A可以做0x0E
    local tab = {}
    for i=1,#values,1 do
        tab[i] = 0
    end

    for i=1,#values,1 do
        if(values[i]>0) then

            for j=i,#values,1 do
                if((values[j]-values[i])==(j-i)) then tab[i] = tab[i]+1
                else break end
            end
        end
    end

    --debug_print_table(tab)

    return tab
end

--随机洗牌
function logic.shuffle(index, tab)
	index = index or 1
	local cnt = #tab
	for i=index, cnt do
		local k = math.random(i, cnt)
		if k ~= i then
			tab[i], tab[k] = tab[k], tab[i]
		end
	end
end

--产生新的牌
function logic.rand_cards(card_set)
--[[
    --测试使用
    local test_total_card_ =
    {
        --全垒打
 	    --0x01,0x02,0x24,0x23,0x05,0x06,0x07,0x26,0x09,0x0A,0x2B,0x0C,0x0D,		--方块1，，，方块K
	    --0x11,0x32,0x34,0x13,0x15,0x16,0x17,0x37,0x39,0x1A,0x1B,0x1C,0x1D,		--梅花1，，，梅花K
	    --0x21,0x22,0x24,0x23,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,		--红心1，，，红心K
	    --0x31,0x32,0x34,0x33,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,		--黑桃1，，，黑桃K

        --3花
        0x21,0x03,0x24,0x23,0x25,0x28,0x27,0x38,0x29,0x2A,0x25,0x2C,0x3D,		--红心1，，，红心K
	    0x31,0x32,0x34,0x33,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,		--黑桃1，，，黑桃K

	    0x01,0x0A,0x03,0x13,0x15,0x19,0x17,0x1B,0x21,0x23,0x25,0x27,0x2D,		--方块1，，，方块K
	    
	    0x11,0x22,0x03,0x13,0x14,0x25,0x16,0x07,0x39,0x3A,0x3B,0x3C,0x2D,		--梅花1，

        --6对半
	    0x01,0x11,0x03,0x13,0x05,0x15,0x07,0x17,0x09,0x19,0x0A,0x3A,0x0D,		--方块1，，，方块K
	    0x21,0x22,0x24,0x23,0x25,0x26,0x27,0x18,0x29,0x2A,0x2B,0x2C,0x2D,		--梅花1，，，梅花K
	    0x21,0x22,0x24,0x23,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,		--红心1，，，红心K
	    0x22,0x32,0x04,0x34,0x35,0x36,0x37,0x0A,0x39,0x3A,0x3B,0x3C,0x3D,		--黑桃1，，，黑桃K

        --全红,全黑
	    0x01,0x22,0x24,0x02,0x05,0x06,0x27,0x08,0x07,0x0A,0x0B,0x0C,0x0D,		--方块1，，，方块K
	    0x11,0x32,0x14,0x13,0x15,0x16,0x17,0x18,0x39,0x1A,0x1B,0x1C,0x31,		--梅花1，，，梅花K
	    0x21,0x22,0x24,0x23,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,		--红心1，，，红心K
	    0x31,0x32,0x34,0x33,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,		--黑桃1，，，黑桃K


        --青龙
	    0x01,0x02,0x04,0x03,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,		--方块1，，，方块K
	    0x11,0x12,0x14,0x13,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,		--梅花1，，，梅花K
	    0x21,0x22,0x24,0x23,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,		--红心1，，，红心K
	    0x31,0x32,0x34,0x33,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,		--黑桃1，，，黑桃K

    }

    return test_total_card_
--]]


    math.randomseed(os.time())

    local newCards = logic.copy_table(totalcard_set[card_set])
    logic.shuffle(1, newCards)

    --一家特殊牌型测试
    --for i=1,13 do
    --    newCards[i] = i
    --end

    --[[对子,对子,两对,牌型
    local test_card_ = 
    {
	    0x02,0x12,0x07,0x17,0x09,
	    0x03,0x0D,0x1D,0x15,0x06,
	    0x2A,0x1C,0x2C,
    }
    --]]

    --[[6对半,牌型
    local test_card_ = 
    {
	    0x02,0x12,0x22,0x32,0x09,
	    0x03,0x13,0x18,0x38,0x39,
	    0x2A,0x1C,0x2C,
    }
    --]]

    --[[5对1刻,牌型
    local test_card_ = 
    {
	    0x02,0x12,0x22,0x32,0x09,
	    0x03,0x13,0x18,0x38,0x39,
	    0x29,0x1C,0x2C,
    }
    --]]

    --[[
    for i=1,13 do
        newCards[i] = test_card_[i]
    end
   
   --[[ 
    newCards[1] = 0x12
    newCards[2] = 0x13
    newCards[3] = 0x14
    newCards[4] = 0x16
    newCards[5] = 0x17
    newCards[6] = 0x1B
    newCards[7] = 0x1D

    newCards[8] = 0x24
    newCards[9] = 0x25
    newCards[10] = 0x28

    newCards[11] = 0x3A
    newCards[12] = 0x3C
    newCards[13] = 0x31


    --]]

	return newCards


end

--复制table
function logic.copy_table(st)
    local table = {}

	for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            table[k] = v
        else
            table[k] = logic.copy_table(v)
        end
    end

    return table
end

--复制table,去掉nil
function logic.copy_table_remove_nil(table)
    local new_table = {}

	for k, v in pairs(table) do
        new_table[1+#new_table] = table[k]
    end

    return new_table
end

--复制table
function logic.copy_table_part(total_cards, start_index, cnt)

    local new_cards = {}

    if(type(total_cards) ~= "table") then assert(false); return new_cards end
    if(start_index<1) then assert(false); return new_cards end
    if(cnt<1) then assert(false); return new_cards end

    for i=start_index,start_index+cnt-1,1 do
        new_cards[1+#new_cards] = total_cards[i]
    end

    return new_cards
end

--反向table
function logic.reverse_table(table)
    local new_table = {}
    if(type(table) ~= "table") then assert(false); return new_table end

    new_table = logic.copy_table(table)

    local size = #new_table
        
    for i=1,size/2 do
        new_table[i],new_table[size-i+1] = new_table[size-i+1],new_table[i]
    end
 
    return new_table
end

--查找牌值个数
function logic.find_value_cnt(cards, value)

   local cnt = 0
   for k,v in ipairs(cards) do
        if(value == logic.get_card_value(v)) then cnt = cnt+1 end
   end

   return cnt
end

function logic.find_card_cnt(cards, card)

   local cnt = 0
   for k,v in ipairs(cards) do
        if(card == v) then cnt = cnt+1 end
   end

   return cnt
end

--是否相等
function logic.is_equal_table(source_cards, dest_cards)

    if(#source_cards ~= #dest_cards) then return false end

    local  source_cards_tmp = logic.copy_table(source_cards)
    local  dest_cards_tmp = logic.copy_table(dest_cards)

    --排序
    table.sort(source_cards_tmp)
    table.sort(dest_cards_tmp)

    for i=1,#source_cards do
        if(source_cards_tmp[i] ~= dest_cards_tmp[i]) then return false end
    end

    return true
end

--是否相等
function logic.is_equal_table_no_sort(source_cards, dest_cards)
    if(type(source_cards) ~= "table") then assert(false); return false end
    if(type(dest_cards) ~= "table") then assert(false); return false end

    if(#source_cards ~= #dest_cards) then return false end

    for i=1,#source_cards do
        if(source_cards[i] ~= dest_cards[i]) then return false end
    end

    return true
end

--按逻辑值排序,从小到大

--升序
function sort_table_value_asc(card1, card2)

    if(logic.get_card_value(card2) > logic.get_card_value(card1)) then return true
    elseif(logic.get_card_value(card2) == logic.get_card_value(card1)) then
        return logic.get_card_color(card2) > logic.get_card_color(card1)
    else return false end
end

--降序
function sort_table_value_desc(card1, card2)

    if(logic.get_card_value(card2) < logic.get_card_value(card1)) then return true
    elseif(logic.get_card_value(card2) == logic.get_card_value(card1)) then
        return logic.get_card_color(card2) < logic.get_card_color(card1)
    else return false end
end

--升序
function sort_table_logic_value_asc(card1, card2)

    if(logic.get_card_logic_value(card2) > logic.get_card_logic_value(card1)) then return true
    elseif(logic.get_card_logic_value(card2) == logic.get_card_logic_value(card1)) then
        return logic.get_card_color(card2) > logic.get_card_color(card1)
    else return false end
end

--降序
function sort_table_logic_value_desc(card1, card2)

    if(logic.get_card_logic_value(card2) < logic.get_card_logic_value(card1)) then return true
    elseif(logic.get_card_logic_value(card2) == logic.get_card_logic_value(card1)) then
        return logic.get_card_color(card2) < logic.get_card_color(card1)
    else return false end
end


--找到最大的逻辑牌
function logic.get_max_logic_card(cards)
    if(type(cards) ~= "table") then assert(false);return 0x00 end

    local max_card = 0x02

    for k,v in ipairs(cards) do
        if(logic.get_card_logic_value(max_card) < logic.get_card_logic_value(v)) then max_card = v end
    end

    return max_card
end

--牌型转换为文字描述
function logic.get_3_card_type_txt(total_card_)

    local card_type_txt_ = {}

    if(type(total_card_) ~= "table") then return card_type_txt_ end
    if(#total_card_ ~= PLAYER_CARD_CNT) then return card_type_txt_ end

    local cards = {}
    for i=1,3 do
        cards[i] = {}
    end

    for dao_index=1,3 do
        local start_index_  = {1,4,9}
        local card_cnt_     = {3,5,5}
        cards[dao_index] = logic.copy_table_part(total_card_, start_index_[dao_index], card_cnt_[dao_index])
    end

    local card_type_ = {}
    for dao_index=1,3 do
        card_type_[dao_index] = logic.get_card_type(cards[dao_index])
        card_type_txt_[dao_index] = logic.get_card_type_txt(card_type_[dao_index])
    end

    return card_type_txt_
end

--牌型转换为文字描述
function logic.get_card_type_txt(cardtype)

    local ct_ = 
    {
        --普通牌型[9个]
        CARD_TYPE.CARD_TYPE_NULL                            ,     --无效牌型

        CARD_TYPE.CARD_TYPE_SAN_PAI                         ,     --散牌
        CARD_TYPE.CARD_TYPE_DUI_ZI                          ,     --对子
        CARD_TYPE.CARD_TYPE_2_DUI                           ,     --两对

        CARD_TYPE.CARD_TYPE_3_TIAO                          ,     --三条
        CARD_TYPE.CARD_TYPE_SHUN_ZI                         ,     --顺子
        CARD_TYPE.CARD_TYPE_TONG_HUA                        ,     --同花

        CARD_TYPE.CARD_TYPE_HU_LU                           ,     --葫芦
        CARD_TYPE.CARD_TYPE_4_TIAO                          ,     --四条
        CARD_TYPE.CARD_TYPE_TONG_HUA_SHUN                   ,     --同花顺
        CARD_TYPE.CARD_TYPE_BOMB                            ,     --炸弹

        --13张,整手牌牌型[14个]
        CARD_TYPE.CARD_TYPE_SPECIAL_QING_LONG	            ,  --青龙：同花且A到K
        CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HONG	            ,  --全红：13张红色（方块、红桃）的牌
        CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HEI	            ,  --全黑：13张黑色（梅花、黑桃）的牌

        CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HONG_1_DIAN_HEI	,  --全红一点黑：即是13张有12张是红的1张是黑的
        CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_HEI_1_DIAN_HONG	,  --全黑一点红：即是13张有12张是黑的1张是红的
        CARD_TYPE.CARD_TYPE_SPECIAL_1_TIAO_LONG	            ,  --一条龙：A到K

        CARD_TYPE.CARD_TYPE_SPECIAL_5_DUI_1_KE	            ,  --5对一刻：5组对子，一个三条
        CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_XIAO	            ,  --全小：2到10
        CARD_TYPE.CARD_TYPE_SPECIAL_QUAN_DA                 ,  --全大：6到K

        CARD_TYPE.CARD_TYPE_SPECIAL_6_DUI_BAN               ,  --6对半：6组对子，一张单牌
        CARD_TYPE.CARD_TYPE_SPECIAL_BAN_XIAO	            ,  --半小：A到10
        CARD_TYPE.CARD_TYPE_SPECIAL_BAN_DA                  ,  --半大：6到A

        CARD_TYPE.CARD_TYPE_SPECIAL_3_HUA                   ,  --三花：3道都是同花
        CARD_TYPE.CARD_TYPE_SPECIAL_3_SHUN                  ,  --三顺：3道都是顺子
    }

    local card_type_txt_ =
    {
        "无效牌型",

        "散牌",
        "对子",
        "两对",
        
        "三条",
        "顺子",
        "同花",

        "葫芦",
        "4条",
        "同花顺",
        "炸弹",

        "青龙：同花且A到K",
        "全红：13张红色（方块、红桃）的牌",
        "全黑：13张黑色（梅花、黑桃）的牌",

        "全红一点黑：即是13张有12张是红的1张是黑的",
        "全黑一点红：即是13张有12张是黑的1张是红的",
        "一条龙：A到K",

        "5对一刻：5组对子，一个三条",
        "全小：2到10",
        "全大：6到K",

        "6对半：6组对子，一张单牌",
        "半小：A到10",
        "半大：6到A",

        "三花：3道都是同花",
        "三顺：3道都是顺子",
    }

    assert(#ct_ == #card_type_txt_)

    for k,v in pairs(ct_) do
        if(v == cardtype) then
            return card_type_txt_[k]
        end
    end

    assert(false)
    return "无效牌型"
end

--打印输出
function logic.debug_print_table(tb, is_hex)

	if(DEBUG_TEST) then return end

	if(type(tb) ~="table") then return end

	print("\n")
	for i,v in pairs(tb) do
        if(is_hex == true) then print(string.format("%d,0x%02x",i,v))
        else print(string.format("%d,%d",i,v)) end
	end
	print("\n")
end

--[[
--打印输出
function debug_print_tables(tb)

	if(DEBUG_TEST) then return end

	if(type(tb) ~="table") then return end

	print("\n")
	for i,v in ipairs(tb) do
	    for j,v1 in ipairs(tb[i]) do
		    print(i,j,v1)
        end
	end
	print("\n")
end
--]]


function logic.get_multi_by_fly(cards1, cards2, fly_card)
  if not fly_card then
    return 1
  end
  
  for _, card in ipairs(cards1) do
    if card == fly_card then
      return 2
    end
  end
  for _, card in ipairs(cards2) do
    if card == fly_card then
      return 2
    end
  end
  
  return 1
end


return logic,my_card_type,my_special_card_type,my_compare_card,my_extract_card



--------------------------------------------------------
------------------------the  end------------------------
--------------------------------------------------------
