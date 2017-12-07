--
-- Author: peter
-- Date: 2017-02-17 13:14:50
--

local comUtil = require("app.Common.util")
local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local PATH = SRDDZ_Const.PATH
local sound_common = require("app.Common.sound_common")


local SRDDZ_Util = {}

-- SRDDZ_Util.action_bg_frames = {}
-- SRDDZ_Util.action_font_frames = {}
-- SRDDZ_Util.card_type_frames = {}
-- SRDDZ_Util.time_num_frames = {}
-- SRDDZ_Util.jetton_frames = {}
SRDDZ_Util.card_frames = {} -- card 117*161

function SRDDZ_Util:init()
    self.session = 0   --数据校验
    self.seatIndex = 0  --自己的椅子号
    self.openCardTime = 0   --最大出牌时间
    self.isChuPai = false  --正在出牌
end

function SRDDZ_Util:clear()

end

function SRDDZ_Util.sliceCardFrames(filepath, width, height)
    local frames = {}
    local texture = cc.Director:getInstance():getTextureCache():addImage(filepath)
    local rect = nil
    for row = 1, 5 do
        for col = 1, 13 do
            rect = cc.rect(width*(col-1), height*(row-1), width, height)
            frames[#frames+1] = cc.SpriteFrame:createWithTexture(texture, rect)
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frames[#frames], filepath..#frames)
        end
    end

    SRDDZ_Util.card_frames = frames
end

--[[
	* 桌子椅子号转换为本地椅子号
	* @param	seat  桌子椅子号
--]]
function SRDDZ_Util.convertSeatToPlayer(seat)
	local difference = SRDDZ_Util.seatIndex - 1
    if seat - difference <= 0 then
        seat = seat + SRDDZ_Const.MAX_PLAYER_NUMBER - difference
    else 
        seat  = seat - difference
    end

    return seat
end

--[[
	* 转换金币数为4位一个逗号
	* @param number val  需要转换的数字
--]]
function SRDDZ_Util.num2str(val)
	if not val or type(val) == "string" then
		val = checkint(val)
	end

	if math.abs(val) < 10000 then
		return tostring(val)
	end

	local symbol = ""
    if val < 0 then
        symbol = "-"
        val = -val
    end

    local ret = nil 
    while val >= 10000 do
        local k = string.format("%04d", val%10000)
        if not ret then
            ret = k
        else
            ret = k .. "," .. ret
        end
        val = math.floor(val/10000)
    end
    return string.format("%s%d", symbol, val)..","..ret
end

--[[
    * 获取牌的花色 and 牌值
    * @param number card  需要转换的数字
    * @param number&number 牌值&花色
--]]
function SRDDZ_Util.getCardNumAndColor(card)
    local num = card%16
    local color = math.floor(card/16)

    return num,color
end

--[[
    * 把一个字段描述牌信息的表转换为两个字段描述
    * @param table cards  需要转换的牌信息
    * @param table  转换之后的牌信息
--]]
function SRDDZ_Util.conversionCardInfoForm(cards)
    local conversionCards = {}

    for k,v in ipairs(cards) do
        local cardNum,cardColor = SRDDZ_Util.getCardNumAndColor(v)
        table.insert(conversionCards,{num = cardNum,color = cardColor})
    end

    return conversionCards
end

--[[
    * 排序一组牌信息  or  排序一组实际的手牌
    * @param number order    1 等于从大到小   2 等于从小到大
    * @param table cards 手牌
    * @param string numField 牌值字段名字
    * @param string colorField 花色字段名字
--]]
function SRDDZ_Util.SortCards(order,cards,numField,colorField)
    for k,v in ipairs(cards) do
        if v[colorField] >= 4 then
            if v[numField] <= 15 then
                v[numField] = v[numField] + 2
            end
        else
            if v[numField] <= 2 then
                v[numField] = v[numField] + 13
            end
        end
    end

    if order == 1 then
        table.sort(cards,
        function(a,b) 
            if a[numField] == b[numField]  then
                return a[colorField] > b[colorField]
            else
                return a[numField] > b[numField] 
            end
        end)
    elseif order == 2 then
       table.sort(cards,
        function(a,b) 
            if a[numField] == b[numField]  then
                return a[colorField] < b[colorField]
            else
                return a[numField] < b[numField] 
            end
        end)
    end

    for k,v in ipairs(cards) do
        if v[colorField] >= 4 then
            if v[numField] >= 16 then
                v[numField] = v[numField] - 2
            end
        else
            if v[numField] >= 14 then
                v[numField] = v[numField] - 13
            end
        end
    end
end

--[[
    * 获取手牌 or 出牌的排序位置
    * @param number cardNum 要排序位置的牌数
    * @param number scale 排序的缩放比例
    * @param cc.p originName 要排序的牌原点节点名字
--]]
function SRDDZ_Util.getCardSortPos(cardNum,scale,pos)
    local X = pos.x
    local Y = pos.y

    -- if self.m_playerInfo.seat == 1 then
    if cardNum-1 ~= 0 then
        local width = (((cardNum-1) * SRDDZ_Const.CARD_WIDTH_DISTANCE) + SRDDZ_Const.CARD_WIDTH) * scale
        X = X - width / 2 + SRDDZ_Const.CARD_WIDTH * scale / 2
    end
    -- end

    return cc.p(X,Y)
end

--[[
    * 设置相关方法
--]]
local has_sound = nil
function SRDDZ_Util.switchSound()
    has_sound = not has_sound

    app.constant.voiceOn = has_sound
    comUtil.GameStateSave("voiceOn",app.constant.voiceOn)
    sound_common.setVoiceState(app.constant.voiceOn)

    if has_sound then
        audio.setSoundsVolume(1.0)
    else
        audio.setSoundsVolume(0.0)
    end
end
function SRDDZ_Util.hasSound()
    return has_sound
end

function SRDDZ_Util.init_autio()
    has_sound = app.constant.voiceOn
end

function SRDDZ_Util.clear()
    has_sound = nil
end

SRDDZ_Util.sliceCardFrames(PATH.IMGS_CARD,117,161)

return SRDDZ_Util