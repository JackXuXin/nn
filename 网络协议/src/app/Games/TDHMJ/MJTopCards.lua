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
    -- local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card_up.png")
    -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 38, 63))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_up.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_Hua.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 23, 35))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_Hua.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX_Hua.png")
    -- for i = 1, 3 do
    --     for j = 1, 4 do
    --         if i == 1 and j < 4 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 4*16+4+j))
    --         elseif i == 2 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+j))
    --         elseif i == 3 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+4+j))
    --         end
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_top.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_top.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(36*(j-1), 44.6*(i-1), 36, 44.6))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_UpZY.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(30*(j-1), 24*(i-1), 30, 24))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_UpZY%d.png", i*16+j))
    --     end
    -- end
    
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_cpg_back.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 52))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_cpg_back.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_Up_cpg.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 50))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_Up_cpg.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai_cpg.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(32*(j-1), 39.6*(i-1), 32, 39.6))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_cpg%d.png", i*16+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun_cai.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/MJ_jiantou.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 47, 57))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/MJ_jiantou.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/NJ_outCard_shadow3.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/NJ_outCard_shadow3.png")

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
    :pos(display.left+500+count*22, display.top-120)
    :addTo(huaLevel)

    local flower=display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
    :pos(12, 23)
    :setRotation(180)
    :addTo(sprite)
    
    table.insert(flowerArray, count+1, {val=card, sprite=sprite,flower=flower})
    return self
end

function MJTopCards:sortFlower()
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

function MJTopCards:arrangeFlower()
    local count = #flowerArray
    for i = 1, count do
        local card = flowerArray[i].val
        local sprite = flowerArray[i].sprite
        local flower = flowerArray[i].flower
        sprite:pos(display.left+500+i*22, display.top-120)
        flower:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card)))
    end
end

function MJTopCards:complementCards(cards, del)
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

function MJTopCards:addOut(card, max)
    local num = 11
    if max == 2 then
        num = 22
    end
    -- local val = self.callBack:getDragonCard()
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
        dis = 43*(dis % 2) + 12*math.floor(dis/2)
        local sprite = display.newSprite("#ShYMJ/img_spe_paichiSX_top.png")
        :pos(display.cx + 36*num/2-24 - (count%num)*35, display.top - 212 + dis)
        if count % (2*num) > num-1 then
            sprite:addTo(outSeconde)
        else
            sprite:addTo(outLevel)
        end
        local flower=display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", card))
        :pos(18, 35)
        :setRotation(180)
        :addTo(sprite)

        --出牌后的，选择相同的牌的显示效果
        local shadow = display.newSprite("#ShYMJ/NJResult/NJ_outCard_shadow3.png")
        :pos(18, 56/2)
        :hide()
        :addTo(sprite) 

        -- local icon = "#ShYMJ/img_up_card_hun.png"
        -- local majiang = self.callBack:getMajiang()
        -- if majiang == "shzhmj" then
        -- local icon = "#ShYMJ/img_up_card_hun_cai.png"
        -- end
        -- local dragon=display.newSprite(icon)
        -- :pos(25+8, 40-16)
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
function MJTopCards:ShowShadow(card)
    for i=1,#outArray do
        if outArray[i].val==card then
            --todo
            outArray[i].shadow:show()
        end
    end
end
--隐藏相同牌效果
function MJTopCards:HideShadow()
    for i=1,#outArray do
        outArray[i].shadow:hide()
    end
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
        sp:pos(display.right- 340 - (i-1)*3*40, display.top-65)
    end
end

function MJTopCards:addCombin(combin, card, direct)
    local count = #combinArray
    local sprite = display.newSprite()
    :pos(display.right- 340 - count*3*40, display.top-65)
    :addTo(handLevel)
    -- if combin == "left" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
    --     :pos(-2, 0)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+1))
    --     :pos(19, 36)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(36, 10)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
    --     :pos(21, 23)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
    --     :pos(-38,0)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+2))
    --     :pos(19, 36)
    --     :setRotation(180)
    --     :addTo(temp)
    -- elseif combin == "center" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
    --     :pos(-2, 0)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-1))
    --     :pos(19, 36)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(36,10)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
    --     :pos(21, 23)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
    --     :pos(-38,0)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+1))
    --     :pos(19, 36)
    --     :setRotation(180)
    --     :addTo(temp)
    -- elseif combin == "right" then
    --     local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
    --     :pos(-2, 0)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-2))
    --     :pos(19, 36)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_cpgZY.png")
    --     :pos(36,10)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
    --     :pos(21, 23)
    --     :setRotation(180)
    --     :addTo(temp)
    --     temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
    --     :pos(-38,0)
    --     :addTo(sprite)
    --     display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-1))
    --     :pos(19, 36)
    --     :setRotation(180)
    --     :addTo(temp)
    if combin == "peng" then
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)

        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :addTo(sprite)
        if direct == "right" then
            FromCard:setRotation(90)
        elseif direct == "left" then
            FromCard:setRotation(-90)
        else
            FromCard:setRotation(180)
        end
    elseif combin == "chi" then
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
    elseif combin == "ming_gang" then
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(2,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(0,12)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :pos(0,12)
            :addTo(sprite)
        if direct == "right" then
            FromCard:setRotation(90)
        elseif direct == "left" then
            FromCard:setRotation(-90)
        else
            FromCard:setRotation(180)
        end
    elseif combin == "bu_gang" then
        
        local temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(-32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
            :pos(0,12)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17, 30)
            :setRotation(180)
            :addTo(temp)
        --箭头（默认指向上）
        local FromCard = display.newSprite("#ShYMJ/MJ_jiantou.png")
            :setScale(0.8)
            :pos(0,12)
            :addTo(sprite)
        if direct == "right" then
            FromCard:setRotation(90)
        elseif direct == "left" then
            FromCard:setRotation(-90)
        else
            FromCard:setRotation(180)
        end
        
    elseif combin == "an_gang" then
        local temp =  display.newSprite("#ShYMJ/img_spe_paichiSX_cpg_back.png")
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_paichiSX_cpg_back.png")
        :pos(-32,0)
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_paichiSX_cpg_back.png")
        :pos(32,0)
        :addTo(sprite)
        temp =  display.newSprite("#ShYMJ/img_spe_Up_cpg.png")
        :pos(0,13)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
        :pos(17, 30)
        :setRotation(180)
        :addTo(temp)
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
                sprite:pos(display.cx - 18*(count+1) + pos*36, display.top-60)
            elseif mode == "right" then
                sprite:pos(display.cx - 18*13 + 5 + pos*36, display.top-60)
            elseif mode == "link" then
                sprite:pos(display.cx - 18*15 + 5 + pos*36, display.top-60)
            elseif mode == "single" then
                if pos == 1 then
                    sprite:pos(display.cx - 18*15 - 5 + pos*36, display.top-60)
                else
                    sprite:pos(display.cx - 18*15 + 5 + pos*36, display.top-60)
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

function MJTopCards:removeCard(flower)
    local count = 3 * #combinArray + #cardsArray

    if count > 13 or flower=="flower" then
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

function MJTopCards:drawCard(card,flower)
    for i=1,#card do
        self:addCard(card[i])
        self:arrangeCards("single")
        if flower then
            self:arrangeCards("link")
        end
    end
    
end



function MJTopCards:combinCard(combin, card, direct)
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