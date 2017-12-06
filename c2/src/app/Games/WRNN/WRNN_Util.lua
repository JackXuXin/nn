--
-- Author: peter
-- Date: 2017-04-20 16:49:05
--
local WRNN_Const = require("app.Games.WRNN.WRNN_Const")

local gameScene = nil

local WRNN_Util = {}

WRNN_Util.card_frames = {} -- card 117*161

function WRNN_Util:init(scene)
	gameScene = scene
end

function WRNN_Util.sliceCardFrames(filepath, width, height)
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

    WRNN_Util.card_frames = frames
end

--[[
	* 桌子椅子号转换为本地椅子号
	* @param int seat  桌子椅子号
--]]
function WRNN_Util.convertSeatToPlayer(seat)
	local difference = gameScene.seatIndex - 1
    if seat - difference <= 0 then
        seat = seat + gameScene.WRNN_Const.MAX_PLAYER_NUMBER - difference
    else 
        seat  = seat - difference
    end

    return seat
end


-- function WRNN_Util.localseat(seat)
--     local tepm ={[1]={1,2,3,4,5,6},
--                  [2]={2,3,4,5,6,1},
--                  [3]={3,4,5,6,1,2},
--                  [4]={4,5,6,1,2,3},
--                  [5]={5,6,1,2,3,4},
--                  [6]={6,1,2,3,4,5},
--                 }
      
--     return tepm[gameScene.seatIndex][seat]
-- end
-- function WRNN_Util.goblseat(seat)
--     local tepm ={[1]={1,2,3,4,5,6},
--                  [2]={2,3,4,5,6,1},
--                  [3]={3,4,5,6,1,2},
--                  [4]={4,5,6,1,2,3},
--                  [5]={5,6,1,2,3,4},
--                  [6]={6,1,2,3,4,5},
--                 }
      
--     return tepm[gameScene.seatIndex][seat]
-- end



--[[
    * 旁观坐下场景椅子号转换为桌子椅子号
    * @param int seat  场景椅子号
--]]
function WRNN_Util.convertSeatToTable(seat)
   local difference = gameScene.seatIndex - 1
    seat = seat + difference
    if seat > 6 then
        seat = seat - gameScene.WRNN_Const.MAX_PLAYER_NUMBER
    end

    return seat
end

--[[
    * 获取牌的花色 and 牌值
    * @param number cardInfo  需要转换的数字
    * @param number&number 牌值&花色
--]]
function WRNN_Util.getCardNumAndColor(cardInfo)
    local num = cardInfo%16
    local color = math.floor(cardInfo/16)

    return num,color
end

--[[
    * 从小到大排序 牌
    * @param table cards 手牌
--]]
function WRNN_Util.sortCards(cards)
    if not cards or #cards == 0 then
        return
    end

    table.sort(cards,function(a,b)
            local num1,color1 = WRNN_Util.getCardNumAndColor(a)
            local num2,color2 = WRNN_Util.getCardNumAndColor(b)

            if num1 == num2 then
                return color1 < color2
            else
                return num1 < num2
            end
        end)
end


function WRNN_Util.sortCards2(cards)
    if not cards or #cards == 0 then
        return
    end

    table.sort(cards,function(a,b)
             return a.cardinfo < b.cardinfo    
        end)
end

--[[
    * 转换金币数为4位一个逗号
    * @param number val  需要转换的数字
--]]
function WRNN_Util.num2str(val)
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
    * 获取下注数
    * @param number totalBetGold  当前下注的总数量
--]]
function WRNN_Util.getBetNumber(gold)
    if gold >= 5000000 then
        return 5000000
    elseif gold >= 1000000 then
        return 1000000
    elseif gold >= 500000 then
        return 500000
    elseif gold >= 100000 then
        return 100000
    elseif gold >= 10000 then
        return 10000
    elseif gold >= 1000 then
        return 1000
    end

    return 1000
end

--[[
    * 获取当前最大下注数
    * @param number totalBetGold  当前下注的总数量
    * @return number  最大下注数
--]]
function WRNN_Util.getMaxBetNumber(totalBetGold)
    --本局还可以下注的总金额
    local CanBetGold = 0
    --自己还可以下注的总金额
    local gold = 0
    --当前下注金额
    local betGold = 0
    
    totalBetGold = totalBetGold or 0
    CanBetGold = gameScene.maxBetGold - totalBetGold  --本局还可以下注的总金额

    local str = gameScene.WRNN_uiPlayerInfos.ui_infos[1].k_tx_XiaZhu_Num:getString()
    str = string.gsub(str, ",", "")
    betGold = tonumber(str) or 0   --当前下注金额

    --最大限制 500W
    gold = (gameScene.WRNN_PlayerMgr:getPlayerGold(1) + betGold) / 5
    if gold > 5000000 then
        gold = 5000000
    end
    gold = gold - betGold  --自己还可以下注的总金额

    print("getMaxBetNumber",gold,CanBetGold)

    if gold >= 5000000 and CanBetGold >= 5000000 then
        return 5000000
    elseif gold >= 1000000 and CanBetGold >= 1000000 then
        return 1000000
    elseif gold >= 500000 and CanBetGold >= 500000 then
        return 500000
    elseif gold >= 100000 and CanBetGold >= 100000 then
        return 100000
    elseif gold >= 10000 and CanBetGold >= 10000 then
        return 10000
    elseif gold >= 1000 and CanBetGold >= 1000 then
        return 1000
    end

    return 1000
end

--下注金币动画
function WRNN_Util.showGoldAnimation(parent,num,fromPos,toPos,callback)

         if num <=0 then
             callback()
             return
         end   
        local dis = math.pow(fromPos.x - toPos.x, 2) + math.pow(fromPos.y - toPos.y, 2)
        local move_time = math.sqrt(dis)/500
        if move_time > 0.5 then
            move_time = 0.5
        end
    
        local count = 0
        if num > 10 then
            num = 10
        end
        
         for i=1,num do
             local coin = display.newSprite(WRNN_Const.PATH.BTN_COIN)
             coin:setPosition(fromPos)
             coin:addTo(parent)
             coin:hide()
             
             local delay = cc.DelayTime:create(0.1+i*0.1)
             local move  = cc.MoveTo:create(move_time,toPos)
             local scale = cc.ScaleTo:create(0.1,0)
             local fun1   =  cc.CallFunc:create(function() 
                             coin:show()
                end)
             local fun2   =  cc.CallFunc:create(function() 
                            count = count + 1
                            
                             gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_BET)
                            if count == num then
                               if callback then
                                   callback()     
                               end                             
                            end 
                            coin:removeSelf()  
                    end)
             local action = cc.Sequence:create(delay,fun1,move,scale,fun2)
             transition.execute(coin, action)
         end
    
end

--算 牌 中 上下 浮动 动画
function WRNN_Util.showThinkCardTypeAnimation(parent,items,rate)
    
     
     for i=1,#items do
         local node = items[i]
         node:stopAllActions()

         local delayTime = cc.DelayTime:create(i*rate)
         local scale_b = cc.ScaleTo:create(rate*0.5,1.2)
         local scale_n = cc.ScaleTo:create(rate*0.5,1.0)
         local delayTime2 = cc.DelayTime:create( (#items+1 -i) * rate )

         --local jump = cca.jumpBy(rate*0.5,0,0,30,1)

         local sequence = cc.Sequence:create(delayTime,scale_b,scale_n,delayTime2)
         local action = cc.RepeatForever:create(sequence)

         transition.execute(node, action)
              
     end

end

--牛牛牌型转换成索引

function WRNN_Util.getIndexByStringCardStyle(style)
   local style_map ={["_wu_niu"] = 0,
                     ["_niu_1"] = 1,
                     ["_niu_2"] = 2,
                     ["_niu_3"] = 3,
                     ["_niu_4"] = 4,
                     ["_niu_5"] = 5,
                     ["_niu_6"] = 6,
                     ["_niu_7"] = 7,
                     ["_niu_8"] = 8,
                     ["_niu_9"] = 9,
                     ["_niu_niu"] = 10,
                     ["_4_zha"] = 11,
                     ["_5_hua_niu"] = 12,
                     ["_5_xiao_niu"] = 13,                    
                     ["_zha_dan_niu"] = 14,
                    }

    return style_map[style]
end











WRNN_Util.sliceCardFrames(WRNN_Const.PATH.IMGS_CARD,117,161)

return WRNN_Util