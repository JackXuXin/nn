local MJTopCards = class("MJTopCards",function()
    return display.newSprite()
end)

local cardsArray = {}

local flowerArray = {}

local outArray = {}

local combinArray = {}

local handLevel
local huaLevel
local outLevel
local outSeconde

function MJTopCards:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card_up.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_up.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_Hua.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 23, 35))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_Hua.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX_Hua.png")
    for i = 1, 3 do
        for j = 1, 4 do
            if i == 1 and j < 4 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 4*16+4+j))
            elseif i == 2 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+j))
            elseif i == 3 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+4+j))
            end
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 50, 74))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(42*(j-1), 52*(i-1), 42, 52))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 34))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_UpZY.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(43*(j-1), 28*(i-1), 43, 28))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_UpZY%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_cpg_back.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 39, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_cpg_back.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_Up_cpg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 38, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_Up_cpg.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun_cai.png")

    handLevel = display.newSprite()
    :addTo(self)
    huaLevel = display.newSprite()
    :addTo(self)
    outSeconde = display.newSprite()
    :addTo(self)
    outLevel = display.newSprite()
    :addTo(self)
end

function MJTopCards:addFlower(card)
    local count = #flowerArray
    local sprite = display.newSprite("#ShYMJ/img_spe_paichiSX_Hua.png")
    :pos(display.left+500+count*22, display.top-135)
    :addTo(huaLevel)

    display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
    :pos(12, 23)
    :setRotation(180)
    :addTo(sprite)
    
    table.insert(flowerArray, count+1, {val=card, sprite=sprite})
    return self
end

function MJTopCards:addOut(card, max)
    local num = 11
    if max == 2 then
        num = 22
    end
    local val = self.callBack:getDragonCard()
    local count = #outArray
    -- if count > 2*num-1 then
    --     local flower = outArray[count].flower
    --     flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiSX%d.png", card)))
    --     local dragon = outArray[count].dragon
    --     if card == val then
    --         dragon:show()
    --     else
    --         dragon:hide()
    --     end
    -- else
        local dis = math.floor(count/num)
        dis = 65*(dis % 2) + 12*math.floor(dis/2)
        local sprite = display.newSprite("#ShYMJ/img_spe_paichiSX.png")
        :pos(display.cx + 49*num/2-24 - (count%num)*49, display.top - 252 + dis)
        if count % (2*num) > num-1 then
            sprite:addTo(outSeconde)
        else
            sprite:addTo(outLevel)
        end
        local flower=display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", card))
        :pos(25, 40)
        :setRotation(180)
        :addTo(sprite)
        -- local icon = "#ShYMJ/img_up_card_hun.png"
        -- local majiang = self.callBack:getMajiang()
        -- if majiang == "shzhmj" then
        local icon = "#ShYMJ/img_up_card_hun_cai.png"
        -- end
        local dragon=display.newSprite(icon)
        :pos(25+8, 40-16)
        :addTo(sprite)
        -- if card == val then
            -- dragon:show()
        -- else
            dragon:hide()
        -- end
        table.insert(outArray, count+1, {val=card, sprite=sprite, flower=flower, dragon=dragon})
    -- end
    
    return self
end

function MJTopCards:removeCombin(combin, card)
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
        sp:pos(display.right- 360 - (i-1)*3*38, display.top-85)
    end
end

function MJTopCards:addCombin(combin, card, direct)
    local count = #combinArray
    local sprite = display.newSprite()
    :pos(display.right- 340 - count*3*40, display.top-85)
    :addTo(handLevel)
    if combin == "left" then
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(-2, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+1))
        :pos(19, 36)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(36, 10)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
        :pos(21, 23)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(-38,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+2))
        :pos(19, 36)
        :setRotation(180)
        :addTo(temp)
    elseif combin == "center" then
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(-2, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-1))
        :pos(19, 36)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(36,10)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
        :pos(21, 23)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(-38,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+1))
        :pos(19, 36)
        :setRotation(180)
        :addTo(temp)
    elseif combin == "right" then
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(-2, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-2))
        :pos(19, 36)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
        :pos(36,10)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
        :pos(21, 23)
        :setRotation(180)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(-38,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-1))
        :pos(19, 36)
        :setRotation(180)
        :addTo(temp)
    elseif combin == "peng" then
        if direct == "left" then
            local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-36, 10)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21, 23)
            -- :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(38,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        elseif direct == "right" then
            local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(36, 10)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21, 23)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-38,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-36,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(36,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        end
    elseif combin == "gang" then
        if direct == "left" then
            local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(-36, 10)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21, 23)
            -- :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(38,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(2,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        elseif direct == "right" then
            local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
            :pos(36, 10)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21, 23)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-38,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-2,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        elseif direct == "bottom" then
            local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-36,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(36,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(0,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_paichiSX_cpg_back.png")
            :addTo(sprite)
            temp =  display.newSprite("#ShYMJ/img_spe_paichiSX_cpg_back.png")
            :pos(-36,0)
            :addTo(sprite)
            temp =  display.newSprite("#ShYMJ/img_spe_paichiSX_cpg_back.png")
            :pos(36,0)
            :addTo(sprite)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(0,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(19, 36)
            :setRotation(180)
            :addTo(temp)
        end
        
    end
    table.insert(combinArray, count+1, {combin=combin, val=card, sprite=sprite})
    return self
end

function MJTopCards:addCard()
    local sprite = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/img_normal_card_up.png"))
    :addTo(handLevel)
    table.insert(cardsArray, #cardsArray+1, {val=card, sprite=sprite})
end

function MJTopCards:arrangeCards(mode)
    local count = #cardsArray
    if count > 0 then
        for pos = 1, count do
            local sprite = cardsArray[pos].sprite
            if mode == "center" then
                sprite:pos(display.cx - 18*(count+1) + pos*36, display.top-80)
            elseif mode == "right" then
                sprite:pos(display.cx - 18*13 + 5 + pos*36, display.top-80)
            elseif mode == "link" then
                sprite:pos(display.cx - 18*15 + 5 + pos*36, display.top-80)
            elseif mode == "single" then
                if pos == 1 then
                    sprite:pos(display.cx - 18*15 - 5 + pos*36, display.top-80)
                else
                    sprite:pos(display.cx - 18*15 + 5 + pos*36, display.top-80)
                end
            end 
        end
    end
end

function MJTopCards:distributeCards(cards)
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

function MJTopCards:removeCard()
    local count = 3 * #combinArray + #cardsArray

    if count > 13 then
        local out = table.remove(cardsArray, 1)
        if out ~= nil then
            out.sprite:removeFromParent()
        end
    end
end

function MJTopCards:outCard(card)
    self:removeCard()
    self:arrangeCards("right")
    -- self:addOut(card)
end

function MJTopCards:drawCard(card)
    self:addCard(card)
    self:arrangeCards("single")
end

function MJTopCards:complementCards(cards, del)
    local count = #cards
    for i = 1, count do
        if cards[i] > 16*4+4 then
            self:addFlower(cards[i])
            if del then
                self:removeCard()
            end
        end
    end
    
    self:arrangeCards("single")
end

function MJTopCards:combinCard(combin, card, direct)
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
    elseif combin == "gang" then
        self:removeCombin("peng", card)
        self:removeCard()
        self:removeCard()
        self:removeCard()
        self:removeCard()
    end
    self:arrangeCards("link")
end

function MJTopCards:clear()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
    handLevel = nil
    huaLevel = nil
    outLevel = nil
    outSeconde = nil
end

function MJTopCards:restart()
    handLevel:removeAllChildren()
    huaLevel:removeAllChildren()
    outLevel:removeAllChildren()
    outSeconde:removeAllChildren()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
end

function MJTopCards:init(callback)
    self.callBack = callback
    return self
end

return MJTopCards