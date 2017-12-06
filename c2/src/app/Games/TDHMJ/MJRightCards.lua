local MJRightCards = class("MJRightCards",function()
    return display.newSprite()
end)

local cardsArray = {}

local flowerArray = {}

local outArray = {}

local combinArray = {}

local combinLevel = {}
local handLevel
local cardLevel

function MJRightCards:ctor()
    -- local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_right_card.png")
    -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 26, 58))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_right_card.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiZY_Hua.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 31, 27))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiZY_Hua.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiZY_Hua.png")
    -- for i = 1, 3 do
    --     for j = 1, 4 do
    --         if i == 1 and j < 4 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 4*16+4+j))
    --         elseif i == 2 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 5*16+j))
    --         elseif i == 3 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 5*16+4+j))
    --         end
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_paichiZY.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_paichiZY.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiZY.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(37*(j-1), 30*(i-1), 37, 30))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY%d.png", i*16+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY_daopai.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 50))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY_daopai.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalueZY_DaoPaicpg.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(30*(j-1), 37.2*(i-1), 30, 37.2))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", i*16+j))
    --     end
    -- end
    
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiZY_cpg_back.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiZY_cpg_back.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalueZY_cpg.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(37*(j-1), 30*(i-1), 37, 30))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalueZY_cpg%d.png", i*16+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card_spe_hun.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card_spe_hun.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card_spe_hun_cai.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card_spe_hun_cai.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/MJ_jiantou.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 47, 57))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/MJ_jiantou.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/NJ_outCard_shadow2.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 48, 46))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/NJ_outCard_shadow2.png")

    cardLevel = display.newSprite()
    :addTo(self)

    handLevel = display.newSprite()
    :addTo(self)

    for i = 1, 5 do
        combinLevel[5-i+1] = display.newSprite()
        :addTo(self)
    end
    
end

function MJRightCards:addFlower(card)
    local count = #flowerArray
    local sprite = display.newSprite("#ShYMJ/img_spe_paichiZY_Hua.png")
    :pos(display.right-220, display.top-220-count*21)
    :addTo(cardLevel)

    local flower=display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY_Hua%d.png", card))
    :pos(15,18)
    -- :setRotation(180)
    :addTo(sprite)
    
    table.insert(flowerArray, count+1, {val=card, sprite=sprite,flower=flower})
    return self
end

function MJRightCards:sortFlower()
    local count=#flowerArray
    for i = 1, count-1 do
        for j = i + 1, count do
            if flowerArray[i].val > flowerArray[j].val then
                
                local temp = flowerArray[i].val
                flowerArray[i].val = flowerArray[j].val
                flowerArray[j].val = temp
            end
        end
    end
end

function MJRightCards:arrangeFlower()
    local count = #flowerArray
    for i = 1, count do
        local card = flowerArray[i].val
        local sprite = flowerArray[i].sprite
        local flower = flowerArray[i].flower
        sprite:pos(display.right-220, display.top-220-i*21)
        flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", card)))
    end
end

function MJRightCards:complementCards(cards, del)
    local count = #cards
    for i = 1, count do
        if cards[i] > 16*4+4 then
            self:addFlower(cards[i])
            if del then
                self:removeCard("flower")
            end
        end
    end
    self:sortFlower()
    self:arrangeFlower()
    self:arrangeCards("single")
end

function MJRightCards:addOut(card)
    -- local val = self.callBack:getDragonCard()
    local count = #outArray
    -- if count > 21 then
    --     local flower = outArray[12].flower
    --     flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY%d.png", card)))
    --     local dragon = outArray[count].dragon
    --     if card == val then
    --         dragon:show()
    --     else
    --         dragon:hide()
    --     end
    -- else
        local sprite = display.newSprite("#ShYMJ/img_left_paichiZY.png")
        :pos(display.right - 305-47 + 47 * (math.floor(count/11) % 2), display.cy + 10 -11*26/2 + (count%11)*26-14*math.floor(count/22))
        :addTo(cardLevel)
     
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY%d.png", card))
        :pos(23, 30)
        -- :setRotation(180)
        :addTo(sprite)

        --出牌后的，选择相同的牌的显示效果
        local shadow = display.newSprite("#ShYMJ/NJResult/NJ_outCard_shadow2.png")
        :pos(24, 23.5)
        -- :setRotation(180)
        :hide()
        :addTo(sprite) 
        -- local icon = "#ShYMJ/img_left_card_spe_hun.png"
        -- local majiang = self.callBack:getMajiang()
        -- if majiang == "shzhmj" then
        -- local icon = "#ShYMJ/img_left_card_spe_hun_cai.png"
        -- end
        -- local dragon=display.newSprite(icon)
        -- :pos(31-8, 35+1)
        -- :setRotation(180)
        -- :addTo(sprite)
        -- if card == val then
            -- dragon:show()
        -- else
            -- dragon:hide()
        -- end
        table.insert(outArray, count+1, {val=card, sprite=sprite, flower=flower,shadow=shadow})
        -- dump(outArray, "右边已出的牌")
        --排序了
        self:arrangeOut()
    -- end
    return self
end

--显示相同牌效果
function MJRightCards:ShowShadow(card)
    for i=1,#outArray do
        if outArray[i].val==card then
            --todo
            -- print("效果的牌card:" ..card)
            -- print("第几张牌:" ..i)
            -- print("总共多少张牌" ..#outArray)
            -- local count = #outArray
            if i<=11 then
                --todo
                -- print("weizhi1" ..#outArray-i+1)
                if #outArray<=11 then
                    --todo
                    outArray[#outArray-i+1].shadow:show()
                else
                    outArray[11-i+1].shadow:show()
                end
                
            else
                -- print("weizhi2" ..#outArray-i)
                outArray[#outArray-i+11+1].shadow:show()
            end
            
        end
    end
end
--隐藏相同牌效果
function MJRightCards:HideShadow()
    for i=1,#outArray do
        outArray[i].shadow:hide()
    end
end

function MJRightCards:arrangeOut()
    local count = #outArray
    if count  > 0 then
        -- local val = self.callBack:getDragonCard()
        local number = math.floor((count-1)/11) * 11 + 1
        for i = number, count do
            local card = outArray[count-i+number].val
            local sprite = outArray[i].sprite
            local flower = outArray[i].flower
            sprite:pos(display.right - 305+47*(math.floor((count-1)/11)%2), display.cy + 10 -11*26/2 + (count-i+1)*26+12*math.floor((count-1)/22))
            flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY%d.png", card)))
            -- local dragon = outArray[i].dragon
            -- if card == val then
                -- dragon:show()
            -- else
                -- dragon:hide()
            -- end
        end
    end
    

    -- if count < 12 then
    --     for i = 1, count do
    --         local card = outArray[count-i+1].val
    --         local sprite = outArray[i].sprite
    --         local flower = outArray[i].flower
    --         sprite:pos(display.right - 245, display.cy + 10 -11*38/2 + (count-i+1)*38)
    --         flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY%d.png", card)))
    --         local dragon = outArray[i].dragon
    --         if card == val then
    --             dragon:show()
    --         else
    --             dragon:hide()
    --         end
    --     end
    -- elseif count < 23 then
    --     for i = 12, count do
    --         local card = outArray[count-i+12].val
    --         local sprite = outArray[i].sprite
    --         local flower = outArray[i].flower
    --         sprite:pos(display.right - 245+62, display.cy + 10 -11*38/2 + ((count-i+1))*38)
    --         flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY%d.png", card)))
    --         local dragon = outArray[i].dragon
    --         if card == val then
    --             dragon:show()
    --         else
    --             dragon:hide()
    --         end
    --     end
    -- end
end

function MJRightCards:removeCombin(combin, card)
    local count = #combinArray
    for i = 1, count do
        if card == combinArray[i].val and combin == combinArray[i].combin then
            local sp = table.remove(combinArray, i)
            sp.sprite:removeFromParent()
            break
        end
    end
    count = #combinArray
    for i = 1, count do
        local sp = combinArray[i].sprite
        sp:pos(display.right - 180, display.bottom + 220 + (i-1)*91)
    end
end

function MJRightCards:addCombin(combin, card, direct)
    local count = #combinArray
    if count > 4 then
        return
    end
    local sprite = display.newSprite()
    :pos(display.right - 180, display.bottom + 220 + count*96)
    :addTo(combinLevel[count+1])
    -- if combin == "left" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, 30)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+2))
    --     :pos(21, 25)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, 6)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+1))
    --     :pos(21, 25)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
    --     :pos(5, -25)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
    --     :pos(18, 32)
    --     :setRotation(180)
    --     :addTo(temp)
    -- elseif combin == "center" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0,30)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+1))
    --     :pos(21, 25)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, 6)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-1))
    --     :pos(21, 25)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
    --     :pos(5, -25)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
    --     :pos(18, 32)
    --     :setRotation(180)
    --     :addTo(temp)
    -- elseif combin == "right" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0,30)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-1))
    --     :pos(21, 25)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, 6)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-2))
    --     :pos(21, 25)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
    --     :pos(5,-25)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
    --     :pos(18, 32)
    --     :setRotation(180)
    --     :addTo(temp)
    if combin == "peng" then
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,-24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "top" then
            FromCard:setRotation(0)
        elseif direct == "left" then
            FromCard:setRotation(-90)
        else
            FromCard:setRotation(180)
        end
    else combin == "chi" then
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,-24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)    
    elseif combin == "an_gang" then
        
        local temp =  display.newSprite("#ShYMJ/img_spe_paichiZY_cpg_back.png")
        :pos(0,24)
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_paichiZY_cpg_back.png")
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_paichiZY_cpg_back.png")
        :pos(0,-24)
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(-1,11)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
        :pos(21, 27)
        :setRotation(180)
        :addTo(temp)
    elseif combin == "bu_gang" then
        
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0,24)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
        :pos(21, 27)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
        :pos(21, 27)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0,-24)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
        :pos(21, 27)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(-1,11)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
        :pos(21, 27)
        :setRotation(180)
        :addTo(temp)
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "top" then
            FromCard:setRotation(0)
        elseif direct == "left" then
            FromCard:setRotation(-90)
        else
            FromCard:setRotation(180)
        end
        
    elseif combin == "ming_gang" then
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,-24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,11)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 27)
            :setRotation(180)
            :addTo(temp)
        
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "top" then
            FromCard:setRotation(0)
        elseif direct == "left" then
            FromCard:setRotation(-90)
        else
            FromCard:setRotation(180)
        end
    end
    table.insert(combinArray, count+1, {combin=combin, val=card, sprite=sprite})
    return self
end

function MJRightCards:addCard()
    local sprite = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_right_card.png"))
    :addTo(handLevel)
    table.insert(cardsArray, #cardsArray+1, {val=card, sprite=sprite})
end

function MJRightCards:arrangeCards(mode)
    local count = #cardsArray
    if count > 0 then
        for pos = 1, count do
            local sprite = cardsArray[pos].sprite
            if mode == "center" then
                sprite:pos(display.right - 180 , display.cy + 80 +  27*count/2 -pos*27)
            elseif mode == "right" then
                sprite:pos(display.right - 180 , display.cy + 80 + 27*5 -(pos-1)*27-5)
            elseif mode == "link" then
                sprite:pos(display.right - 180 , display.cy + 80 + 27*6 -(pos-1)*27-5)
            elseif mode == "single" then
                if pos == 1 then
                    sprite:pos(display.right - 180 , display.cy + 80 + 27*6-(pos-1)*27+5)
                else
                    sprite:pos(display.right - 180 , display.cy + 80 + 27*6-(pos-1)*27-5)
                end
            end 
        end
    end
end

function MJRightCards:distributeCards(cards)
    for i=1, #cards do
        self:addCard()
    end
    local count = #cardsArray + 3*#combinArray
    if count > 13 then
        self:arrangeCards("link")
    elseif count == 13 then
        self:arrangeCards("right")
    else
        self:arrangeCards("center")
    end
    return self
end

function MJRightCards:removeCard(flower)
    local count = 3 * #combinArray + #cardsArray

    if count > 13 or flower=="flower" then
        local out = table.remove(cardsArray, 1)
        if out ~= nil then
            out.sprite:removeFromParent()
        end
    end
end

function MJRightCards:outCard(card)
    self:removeCard()
    self:arrangeCards("right")
    -- self:addOut(card)
end

function MJRightCards:drawCard(card,flower)
    for i=1,#card do
        self:addCard(card[i])
        self:arrangeCards("single")
        if flower then
            self:arrangeCards("link")
        end
    end
    
end



function MJRightCards:combinCard(combin, card, direct)
    self:addCombin(combin, card, direct)
    if combin == "peng" then
        self:removeCard(card)
        self:removeCard(card)
    elseif combin == "chi" then
        self:removeCard(card)
        self:removeCard(card)
    elseif combin == "an_gang" then
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
    elseif combin == "bu_gang" then
        self:removeCombin("peng", card)
        self:removeCard(card)
        -- self:removeCard(card)
        -- self:removeCard(card)
        -- self:removeCard(card)
    elseif combin == "ming_gang" then
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
        -- self:removeCard(card)
    end
    self:arrangeCards("link")
end

function MJRightCards:clear()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
    combinLevel = {}
    handLevel = nil
    cardLevel = nil 
end

function MJRightCards:restart()
    cardLevel:removeAllChildren()
    handLevel:removeAllChildren()
    for i = 1, #combinLevel do
        combinLevel[i]:removeAllChildren()
    end
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
end

function MJRightCards:init(callback)
    self.callBack = callback
    return self
end

return MJRightCards