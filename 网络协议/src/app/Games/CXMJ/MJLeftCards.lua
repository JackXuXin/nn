local MJLeftCards = class("MJLeftCards",function()
    return display.newSprite()
end)

local cardsArray = {}

local flowerArray = {}

local outArray = {}

local combinArray = {}

local combinLevel
local cardLevel

function MJLeftCards:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 26, 58))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiZY_Hua.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 31, 27))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiZY_Hua.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiZY_Hua.png")
    for i = 1, 3 do
        for j = 1, 4 do
            if i == 1 and j < 4 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 4*16+4+j))
            elseif i == 2 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 5*16+j))
            elseif i == 3 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 5*16+4+j))
            end
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_paichiZY.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_paichiZY.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiZY.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(37*(j-1), 30*(i-1), 37, 30))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY_daopai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 50))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY_daopai.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalueZY_DaoPaicpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(30*(j-1), 37.2*(i-1), 30, 37.2))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiZY_cpg_back.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiZY_cpg_back.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalueZY_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(37*(j-1), 30*(i-1), 37, 30))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalueZY_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card_spe_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card_spe_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card_spe_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card_spe_hun_cai.png")

    combinLevel = display.newSprite()
    :addTo(self)
    cardLevel = display.newSprite()
    :addTo(self)
end

function MJLeftCards:addFlower(card)
    local count = #flowerArray
    local sprite = display.newSprite("#ShYMJ/img_spe_paichiZY_Hua.png")
    :pos(display.left+125, display.bottom+300+count*22)
    :addTo(cardLevel)

    local flower = display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY_Hua%d.png", card))
    :pos(15,18)
    :setRotation(180)
    :addTo(sprite)
    
    table.insert(flowerArray, count+1, {val=card, sprite=sprite, flower=flower})
    return self
end

function MJLeftCards:arrangeFlower()
    local count = #flowerArray
    for i = 1, count do
        local card = flowerArray[count-i+1].val
        local sprite = flowerArray[i].sprite
        local flower = flowerArray[i].flower
        sprite:pos(display.left+125, display.bottom+300+(count-i)*22)
        flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", card)))
    end
end

function MJLeftCards:addOut(card)
    local val = self.callBack:getDragonCard()
    local count = #outArray
    -- if count > 21 then
    --     local flower = outArray[count].flower
    --     flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY%d.png", card)))
    --     local dragon = outArray[count].dragon
    --     if card == val then
    --         dragon:show()
    --     else
    --         dragon:hide()
    --     end
    -- else
        local sprite = display.newSprite("#ShYMJ/img_left_paichiZY.png")
        :pos(display.left + 305 - 47 * (math.floor(count/11) % 2), display.cy +11*26/2 - (count%11)*26+14*math.floor(count/22))
        :addTo(cardLevel)
     
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY%d.png", card))
        :pos(23, 30)
        :setRotation(180)
        :addTo(sprite)

        local icon = "#ShYMJ/img_left_card_spe_hun_cai.png"
        -- local majiang = self.callBack:getMajiang()
        -- if majiang == "shzhmj" then
        -- local icon = "#ShYMJ/img_left_card_spe_hun_cai.png"
        -- end
        local dragon=display.newSprite(icon)
        :pos(24, 24)
        :addTo(sprite)
        -- :setRotation(180)
        if card == val then
            dragon:show()
        else
            dragon:hide()
        end
        table.insert(outArray, count+1, {val=card, sprite=sprite, flower=flower, dragon=dragon})
    -- end
    
    return self
end

function MJLeftCards:removeCombin(combin, card)
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
        sp:pos(display.left + 180, display.top- 120- (i-1)*93)
    end
end

function MJLeftCards:addCombin(combin, card, direct)
    local count = #combinArray
    local sprite = display.newSprite()
    :pos(display.left + 180, display.top- 120 - count*96)
    :addTo(combinLevel)
    if combin == "left" then
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
        :pos(-5, 25)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
        :pos(16, 32)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0, -6)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+1))
        :pos(21, 25)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0, -30)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+2))
        :pos(21, 25)
        :addTo(temp)
    elseif combin == "center" then
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
        :pos(-5, 25)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
        :pos(16, 32)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0, -6)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-1))
        :pos(21, 25)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0,-30)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+1))
        :pos(21, 25)
        :addTo(temp)
    elseif combin == "right" then
        local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
        :pos(-5,25)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
        :pos(16, 32)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0, -6)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-2))
        :pos(21, 25)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(0,-30)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-1))
        :pos(21, 25)
        :addTo(temp)
    elseif combin == "peng" then
        if direct == "top" then
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
            :pos(-5, 25)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
            :pos(16, 32)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0 , -6)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, -30)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        elseif direct == "bottom" then
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 30)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 6)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
            :pos(-5, -25)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
            :setRotation(180)
            :pos(16, 32)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,-24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        end
    elseif combin == "ming_gang" then
        if direct == "top" then
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
            :pos(-5, 25)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
            :pos(16, 32)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0 , -6)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, -30)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,5)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        elseif direct == "bottom" then
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 30)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 6)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
            :pos(-5, -25)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
            :setRotation(180)
            :pos(16, 32)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,17)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,-24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,11)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        end
    elseif combin == "bu_gang" then
        if direct == "top" then
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
            :pos(-5, 25)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
            :pos(16, 32)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0 , -6)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, -30)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,5)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        elseif direct == "bottom" then
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 30)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0, 6)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
            :pos(-5, -25)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
            :setRotation(180)
            :pos(16, 32)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,17)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(0,-24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-1,11)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card))
            :pos(21, 25)
            :addTo(temp)
        end
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
            :pos(21, 25)
            :addTo(temp)
        
    end
    table.insert(combinArray, count+1, {combin=combin, val=card, sprite=sprite})
    return self
end

function MJLeftCards:addCard()
    local sprite = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_left_card.png"))
    :addTo(cardLevel)
    table.insert(cardsArray, #cardsArray+1, {val=card, sprite=sprite})
end

function MJLeftCards:arrangeCards(mode)
    local count = #cardsArray
    if count > 0 then
        for pos = 1, count do
            local sprite = cardsArray[pos].sprite
            if mode == "center" then
                sprite:pos(display.left + 180 , display.cy + 60 +  27*count/2 -pos*27)
            elseif mode == "right" then
                sprite:pos(display.left + 180 , display.cy + 60 - 27*6 + (count-pos)*27+5)
            elseif mode == "link" then
                sprite:pos(display.left + 180 , display.cy + 60 - 27*7 + (count-pos)*27+5)
            elseif mode == "single" then
                if pos == count then
                    sprite:pos(display.left + 180 , display.cy + 60 - 27*6 - 27-5)
                else
                    sprite:pos(display.left + 180 , display.cy + 60 - 27*7 + (count-pos)*27+5)
                end
            end 
        end
    end
end

function MJLeftCards:distributeCards(cards)
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

function MJLeftCards:removeCard()
    local count = 3 * #combinArray + #cardsArray

    if count > 13 then
        local out = table.remove(cardsArray, 1)
        if out ~= nil then
            out.sprite:removeFromParent()
        end
    end
end

function MJLeftCards:outCard(card)
    self:removeCard()
    self:arrangeCards("right")
    -- self:addOut(card)
end

function MJLeftCards:drawCard(card)
    self:addCard(card)
    self:arrangeCards("single")
end

function MJLeftCards:complementCards(cards, del)
    local count = #cards
    for i = 1, count do
        if cards[i] > 16*4+4 then
            self:addFlower(cards[i])
            if del then
                self:removeCard()
            end
        end
    end
    self:arrangeFlower()
    self:arrangeCards("single")
end

function MJLeftCards:combinCard(combin, card, direct)
    self:addCombin(combin, card, direct)
    if combin == "left" then
        self:removeCard()
        self:removeCard()
    elseif combin == "center" then
        self:removeCard()
        self:removeCard()
    elseif combin == "right" then
        self:removeCard()
        self:removeCard()
    elseif combin == "peng" then
        self:removeCard()
        self:removeCard()
    elseif combin == "ming_gang" then
        -- self:removeCombin("peng", card)
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
        -- self:removeCard(card)
    elseif combin == "bu_gang" then
        self:removeCombin("peng", card)
        self:removeCard(card)
        -- self:removeCard(card)
        -- self:removeCard(card)
        -- self:removeCard(card)
    elseif combin == "an_gang" then
        -- self:removeCombin("peng", card)
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
    end
    self:arrangeCards("link")
end

function MJLeftCards:clear()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
    combinLevel = nil
    cardLevel = nil
end
function MJLeftCards:restart()
    combinLevel:removeAllChildren()
    cardLevel:removeAllChildren()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
end

function MJLeftCards:init(callback)
    self.callBack = callback
    return self
end

return MJLeftCards