--
-- Author: peter
-- Date: 2017-03-10 11:27:57
--

local WL_Const = require("app.Games.WL.WL_Const")

local gameScene = nil

local WL_Util = {}

WL_Util.card_frames = {} -- card 117*161

function WL_Util:init(scene)
	gameScene = scene
end

function WL_Util:clear()

end


function WL_Util.sliceCardFrames(filepath, width, height)
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

    WL_Util.card_frames = frames
end

--[[
	* 桌子椅子号转换为本地椅子号
	* @param	seat  桌子椅子号
--]]
function WL_Util.convertSeatToPlayer(seat)
	local difference = gameScene.seatIndex - 1
    if seat - difference <= 0 then
        seat = seat + WL_Const.MAX_PLAYER_NUMBER - difference
    else 
        seat  = seat - difference
    end

    return seat
end

--[[
    * 转换金币数为4位一个逗号
    * @param number val  需要转换的数字
--]]
function WL_Util.num2str(val)
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
    * 从大到小排序 牌
    * @param table cards 手牌
--]]
function WL_Util.sortCards(cards)
    local sort = {14,15,3,4,5,6,7,8,9,10,11,12,13,16,17}

    for i=1,#cards do
        for k=1,#cards-i do
            if sort[cards[k].num] < sort[cards[k+1].num] then
                cards[k],cards[k+1] = cards[k+1],cards[k]
            end
        end
    end

    for i=1,#cards do
        for k=1,#cards-i do
            if cards[k].num == cards[k+1].num and cards[k].color < cards[k+1].color then
                cards[k],cards[k+1] = cards[k+1],cards[k]
            end
        end
    end

    -- for i=1,#cards-1 do
    --     if cards[i].num == cards[i+1].num and cards[i].color < cards[i+1].color then
    --         cards[i],cards[i+1] = cards[i+1],cards[i]
    --     end
    -- end

    -- table.sort(cards,
    -- function(a,b) 
    --     if sort[a.num] == sort[b.num] then
    --         return a.color > b.color
    --     else
    --         return sort[a.num] > sort[b.num]
    --     end
    -- end)
end

--[[
    * 获取手牌 or 出牌的排序位置
    * @param number cardNum 要排序位置的牌数
    * @param number scale 排序的缩放比例
    * @param cc.p originName 要排序的牌原点节点名字
--]]
function WL_Util.getCardSortPos(cardNum,scale,pos)
    local X = pos.x
    local Y = pos.y

    -- if self.m_playerInfo.seat == 1 then
    if cardNum-1 ~= 0 then
        local width = (((cardNum-1) * gameScene.WL_Const.CARD_WIDTH_DISTANCE) + gameScene.WL_Const.CARD_WIDTH) * scale
        X = X - width / 2 + gameScene.WL_Const.CARD_WIDTH * scale / 2
    end
    -- end

    return cc.p(X,Y)
end

--[[
    * 获取牌的花色 and 牌值
    * @param number cardInfo  需要转换的数字
    * @param number&number 牌值&花色
--]]
function WL_Util.getCardNumAndColor(cardInfo)
    local num = cardInfo%16
    local color = math.floor(cardInfo/16)

    return num,color
end

--[[
    * 把一个字段描述牌信息的表转换为两个字段描述
    * @param table cards  需要转换的牌信息
    * @param table  转换之后的牌信息
--]]
function WL_Util.conversionCardInfoForm(cards)
    if not cards or #cards == 0 then
        return {}
    end

    local conversionCards = {}

    for k,v in ipairs(cards) do
        local cardNum,cardColor = WL_Util.getCardNumAndColor(v)
        table.insert(conversionCards,{num = cardNum,color = cardColor})
    end

    return conversionCards
end

--[[
    * 设置相关方法
--]]
local has_sound = true
function WL_Util.switchSound()
    has_sound = not has_sound
    if has_sound then
        audio.setSoundsVolume(1.0)
    else
        audio.setSoundsVolume(0.0)
    end
end
function WL_Util.hasSound()
    return has_sound
end

WL_Util.sliceCardFrames(WL_Const.PATH.IMGS_CARD,117,161)

return WL_Util