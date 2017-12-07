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
    -- local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card.png")
    -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 26, 58))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card.png")

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


    combinLevel = display.newSprite()
    :addTo(self)
    cardLevel = display.newSprite()
    :addTo(self)
end

function MJLeftCards:addFlower(card)
    local count = #flowerArray
    local sprite = display.newSprite("#ShYMJ/img_spe_paichiZY_Hua.png")
    :pos(display.left+225, display.bottom+300+count*21)
    :addTo(cardLevel)

    local flower = display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY_Hua%d.png", card))
    :pos(15,18)
    :setRotation(180)
    :addTo(sprite)
    
    table.insert(flowerArray, count+1, {val=card, sprite=sprite, flower=flower})
    return self
end
function MJLeftCards:sortFlower()
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
--
function MJLeftCards:arrangeFlower()
    local count = #flowerArray
    for i = 1, count do
        local card = flowerArray[count-i+1].val
        local sprite = flowerArray[i].sprite
        local flower = flowerArray[i].flower
        sprite:pos(display.left+225, display.bottom+300+(count-i)*21)
        flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", card)))
    end
end

function MJLeftCards:complementCards(cards, del)
    local count = #cards
    for i = 1, count do
        if cards[i] > 16*4+4 then
            self:addFlower(cards[i])
            if del then
                print("MJLeftCards:complementCards+++")
                self:removeCard("flower")
            end
        end
    end
    self:sortFlower()
    self:arrangeFlower()
    self:arrangeCards("single")
end

function MJLeftCards:addOut(card)
    -- local val = self.callBack:getDragonCard()
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
        :pos(display.left + 310 - 47 * (math.floor(count/11) % 2), display.cy + 10 +11*26/2 - (count%11)*26+14*math.floor(count/22))
        :addTo(cardLevel)
     
        local flower = display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY%d.png", card))
        :pos(23, 30)
        :setRotation(180)
        :addTo(sprite)

        --出牌后的，选择相同的牌的显示效果
        local shadow = display.newSprite("#ShYMJ/NJResult/NJ_outCard_shadow2.png")
        :pos(24, 23.5)
        -- :setRotation(90)
        :hide()
        :addTo(sprite) 

        -- local icon = "#ShYMJ/img_left_card_spe_hun.png"
        -- local majiang = self.callBack:getMajiang()
        -- if majiang == "shzhmj" then
        -- local icon = "#ShYMJ/img_left_card_spe_hun_cai.png"
        -- end
        -- local dragon=display.newSprite(icon)
        -- :pos(24, 24)
        -- :addTo(sprite)
        -- if card == val then
            -- dragon:show()
        -- else
            -- dragon:hide()
        -- end
        table.insert(outArray, count+1, {val=card, sprite=sprite, flower=flower,shadow=shadow})
    -- end
    
    return self
end

--显示相同牌效果
function MJLeftCards:ShowShadow(card)
    for i=1,#outArray do
        if outArray[i].val==card then
            --todo
            outArray[i].shadow:show()
        end
    end
end
--隐藏相同牌效果
function MJLeftCards:HideShadow()
    for i=1,#outArray do
        outArray[i].shadow:hide()
    end
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
    -- if combin == "left" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
    --     :pos(-5, 25)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
    --     :pos(18, 32)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, -6)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+1))
    --     :pos(21, 25)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, -30)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+2))
    --     :pos(21, 25)
    --     :addTo(temp)
    -- elseif combin == "center" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
    --     :pos(-5, 25)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
    --     :pos(18, 32)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, -6)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-1))
    --     :pos(21, 25)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0,-30)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card+1))
    --     :pos(21, 25)
    --     :addTo(temp)
    -- elseif combin == "right" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_cpgZY_daopai.png")
    --     :pos(-5,25)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", card))
    --     :pos(18, 32)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0, -6)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-2))
    --     :pos(21, 25)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(0,-30)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalueZY_cpg%d.png", card-1))
    --     :pos(21, 25)
    --     :addTo(temp)
    if combin == "peng" then
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
        
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "top" then
            FromCard:setRotation(0)
        elseif direct == "right" then
            FromCard:setRotation(90)
        else
            FromCard:setRotation(180)
        end
    elseif combin == "chi" then
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
    elseif combin == "bu_gang" then
        
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
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "top" then
            FromCard:setRotation(0)
        elseif direct == "right" then
            FromCard:setRotation(90)
        else
            FromCard:setRotation(180)
        end
        
    elseif combin == "ming_gang" then
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
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "top" then
            FromCard:setRotation(0)
        elseif direct == "right" then
            FromCard:setRotation(90)
        else
            FromCard:setRotation(180)
        end
    end
    table.insert(combinArray, count+1, {combin=combin, val=card, sprite=sprite})
    print("MJLeftCards:addCombin最后")
    return self
end

function MJLeftCards:addCard()
    local sprite = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_left_card.png"))
    :addTo(cardLevel)
    table.insert(cardsArray, #cardsArray+1, {val=card, sprite=sprite})
end

function MJLeftCards:arrangeCards(mode)
    local count = #cardsArray
    print("左边手牌的个数" ..#cardsArray)
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

function MJLeftCards:removeCard(flower)
    local count = 3 * #combinArray + #cardsArray 
    print("MJLeftCards:removeCard")
    if count > 13 or flower=="flower" then
        print("MJLeftCards:removeCard222")
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

function MJLeftCards:drawCard(card,flower)
    for i=1,#card do
        self:addCard(card[i])
        self:arrangeCards("single")
        if flower then
            self:arrangeCards("link")
        end
    end
    
end



function MJLeftCards:combinCard(combin, card, direct)
    self:addCombin(combin, card, direct)
    print("MJLeftCards:combinCard11" ..combin)
    if combin == "peng" then
        print("MJLeftCards:combinCard22")
        self:removeCard(card)
        self:removeCard(card)
    elseif combin == "chi" then
        print("MJLeftCards:combinCard22")
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