local MJBottomCards = class("MJBottomCards",function()
    return display.newSprite()
end)

local sound = require("app.Games.XSMJ.MJSound")

local cardsArray = {}

local flowerArray = {}

local outArray = {}

local combinArray = {}

local handLevel
local huaLevel
local outLevel
local arrangeLevel

local watchingGame
local animeArrange = false

function MJBottomCards:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 89, 135))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai.png")
    for i = 1, 5 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(79*(j-1), 100*(i-1), 79, 100))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_%d.png", i*16+j))
        end
    end
    
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
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 85, 70))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_daocpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(85*(j-1), 66*(i-1), 85, 66))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_daocpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(51*(j-1), 64*(i-1), 51, 64))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tanpai_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 87, 135))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tanpai_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tanpai_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 87, 135))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tanpai_hun_cai.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun_cai.png")


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_pangguan_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 86, 134))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_pangguan_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card_shadow.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 86, 134))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_shadow.png")

    outLevel = display.newSprite()
    :addTo(self)
    huaLevel = display.newSprite()
    :addTo(self)
    handLevel = display.newSprite()
    :addTo(self)
    arrangeLevel = display.newSprite()
    :addTo(self)
end

function MJBottomCards:addFlower(card)
    local count = #flowerArray
    local sprite = display.newSprite("#ShYMJ/img_spe_paichiSX_Hua.png")
    :pos(display.right-400-count*22, display.bottom+200)
    :addTo(huaLevel)
    display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
    :pos(12, 23)
    :addTo(sprite)
    table.insert(flowerArray, count+1, {val=card, sprite=sprite})
    return self
end

function MJBottomCards:addOut(card, max)
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
        dis = 65*(dis % 2) - 12*math.floor(dis/2)
        local sprite = display.newSprite("#ShYMJ/img_spe_paichiSX.png")
        :pos(display.cx-49*num/2+24+ (count%num)*49, display.bottom + 325 - dis)
        :addTo(outLevel)
        local flower=display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", card))
        :pos(25, 40)
        :addTo(sprite)

        local icon = "#ShYMJ/img_up_card_hun.png"
        local majiang = self.callBack:getMajiang()
        if majiang == "shzhmj" then
            icon = "#ShYMJ/img_up_card_hun_cai.png"
        end
        local dragon=display.newSprite(icon)
        :pos(25-8, 40+19)
        :setRotation(180)
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

function MJBottomCards:removeCombin(combin, card)
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
        sp:pos(display.left+40+3*36 + (i-1)*3*72, display.bottom+85)
    end
end

function MJBottomCards:addCombin(combin, card, direct)
    local count = #combinArray
    local sprite = display.newSprite()
    :pos(display.left+40+3*36 + count*3*72, display.bottom+85)
    :addTo(handLevel)
    if combin == "left" then
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :addTo(sprite)
        :pos(10, 0)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card+1))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
        :pos(-60,-12)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42, 44)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(70,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card+2))
        :pos(30, 50)
        :addTo(temp)
    elseif combin == "center" then
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(10, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card-1))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
        :pos(-60,-12)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42, 44)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(70,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card+1))
        :pos(30, 50)
        :addTo(temp)
    elseif combin == "right" then
        local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(10, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card-2))
        :pos(30, 50)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
        :pos(-60,-12)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
        :pos(42, 44)
        :addTo(temp)
        temp =  display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(70,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card-1))
        :pos(30, 50)
        :addTo(temp)
    elseif combin == "peng" then
        if direct == "left" then
            local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(10, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
            :pos(-60,-12)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
            :pos(42, 44)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(70,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        elseif direct == "right" then
            local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-10, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
            :pos(60,-12)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
            :setRotation(180)
            :pos(42, 44)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-70,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-60,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(60,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        end
    elseif combin == "gang" then
        if direct == "left" then
            local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(10, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
            :pos(-60,-12)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
            :pos(42, 44)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(70,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(10,15)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        elseif direct == "right" then
            local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-10, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_mydaopai_cpg.png")
            :pos(60,-12)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_daocpg%d.png", card))
            :setRotation(180)
            :pos(42, 44)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-70,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-10,15)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        elseif direct == "top" then
            local temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(-60,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(60,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(0,15)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        else
            local temp =  display.newSprite("#ShYMJ/img_spe_backcard.png")
            :addTo(sprite)
            temp =  display.newSprite("#ShYMJ/img_spe_backcard.png")
            :pos(-60,0)
            :addTo(sprite)
            temp =  display.newSprite("#ShYMJ/img_spe_backcard.png")
            :pos(60,0)
            :addTo(sprite)
            temp =  display.newSprite("#ShYMJ/img_spe_card.png")
            :pos(0,24)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", card))
            :pos(30, 50)
            :addTo(temp)
        end
    end
    table.insert(combinArray, count+1, {combin=combin, val=card, sprite=sprite})
    return self
end

function MJBottomCards:getClickCard(sprite)
    local count = #cardsArray
    for i = 1, count do
        if sprite == cardsArray[i].sprite then
            return cardsArray[i]
        end
    end
    return nil
end

function MJBottomCards:clearSelectCard()
    local count = #cardsArray
    for i = 1, count do
        if cardsArray[i].select > 0 then
            cardsArray[i].select = 0
            local x, y = cardsArray[i].sprite:getPosition()
            cardsArray[i].sprite:pos(x, display.bottom+100)
        end
    end
end

function MJBottomCards:onBeganCard(x, y)
    local count = #cardsArray
    for i = 1, count do
        if cardsArray[i].touch then
            if cardsArray[i].sprite:hitTest(cc.p(x, y), false) then
                if cardsArray[i].select > 0 then
                    cardsArray[i].select = cardsArray[i].select + 1
                    return 
                end

                self:clearSelectCard()
                cardsArray[i].select = 1
                local px, py = cardsArray[i].sprite:getPosition()
                cardsArray[i].sprite:pos(px, display.bottom+100 + 30)
                sound.selectCard()
                return
            end
        end
    end
end

function MJBottomCards:onSelectCard(x, y)
    local count = #cardsArray
    for i = 1, count do
        if cardsArray[i].touch then
            if cardsArray[i].sprite:hitTest(cc.p(x, y), false) then
                if cardsArray[i].select > 0 then
                    return 
                end

                self:clearSelectCard()
                cardsArray[i].select = 1
                local px, py = cardsArray[i].sprite:getPosition()
                cardsArray[i].sprite:pos(px, display.bottom+100 + 30)
                sound.selectCard()
                return
            end
        end
    end
end

function MJBottomCards:onClickCard(x, y)
    local count = #cardsArray
    for i = 1, count do
        if cardsArray[i].touch then
            if cardsArray[i].sprite:hitTest(cc.p(x, y), false) then
                if cardsArray[i].select > 1 then
                    cardsArray[i].select = 0
                    self:allowOut(false)
                    self.callBack:onOutCard(cardsArray[i].val)
                end
                return
            end
        end
    end

    for i = 1, count do
        if cardsArray[i].touch and cardsArray[i].select > 0 and y > display.bottom+200 then
            cardsArray[i].select = 0
            self:allowOut(false)
            self.callBack:onOutCard(cardsArray[i].val)
            return
        end
    end
end

function MJBottomCards:addCard(card)
    local sprite = display.newSprite("#ShYMJ/img_normal_card.png")
    :addTo(handLevel)
    
    if card > 0 then
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_%d.png", card))
        :pos(45, 58)
        :addTo(sprite)
    else
         display.newSprite("#ShYMJ/img_spe_pangguan_card.png")
        :pos(45, 75)
        :addTo(sprite)
    end

    local val = self.callBack:getDragonCard()
    
    -- local icon = "#ShYMJ/img_tanpai_hun.png"
    -- local majiang = self.callBack:getMajiang()
    -- if majiang == "shzhmj" then
    local icon = "#ShYMJ/img_tanpai_hun_cai.png"
    -- end
    local dragon = display.newSprite(icon)
    :pos(42, 47)
    :addTo(sprite)
    --if card ~= val then
        dragon:hide()
    --end
    
    local shadow = display.newSprite("#ShYMJ/img_normal_card_shadow.png")
    :pos(44, 67)
    :hide()
    :addTo(sprite)        

    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            self:onBeganCard(event.x, event.y)
            return true
        elseif event.name == "moved" then
            self:onSelectCard(event.x, event.y)
        elseif event.name == "ended" then
            self:onClickCard(event.x, event.y)
        end
    end)
    table.insert(cardsArray, #cardsArray+1, {val=card, sprite=sprite, select=0, shadow=shadow, touch=false})
    return self
end

function MJBottomCards:removeCard(card)
    if watchingGame then
        local count = 3 * #combinArray + #cardsArray
        if count > 13 then
            local out = table.remove(cardsArray, 1)
            if out ~= nil then
                out.sprite:removeFromParent()
            end
        end
    else
        local count = #cardsArray
        for i = 1, count do
            if card == cardsArray[i].val then
                local sp = table.remove(cardsArray, i)
                sp.sprite:removeFromParent()
                return
            end
        end
    end
end

function MJBottomCards:removeFlower()
    local count = #cardsArray
    for i = 1, count do
        if cardsArray[i].val > 16*5 then
            local sp = table.remove(cardsArray, i)
            sp.sprite:removeFromParent()
            return sp.val
        end
    end
    return 0
end

function MJBottomCards:sortCards(ignore)
    local dragon = self.callBack:getDragonCard()
    local count = #cardsArray
    if ignore then
        if count < 3 then
            return 
        end
        count = count - 1
    else
        if count < 2 then
            return 
        end
    end
    
    for i = 1, count-1 do
        for j = i + 1, count do
            if cardsArray[i].val > cardsArray[j].val then
                -- if cardsArray[i].val ~= dragon then
                    local temp = cardsArray[i]
                    cardsArray[i] = cardsArray[j]
                    cardsArray[j] = temp
                -- end
            -- elseif cardsArray[i].val < cardsArray[j].val then
            --     if cardsArray[j].val == dragon then
            --         local temp = cardsArray[i]
            --         cardsArray[i] = cardsArray[j]
            --         cardsArray[j] = temp
            --     end
            end
        end
    end
end

function MJBottomCards:arrangeCards(mode)
    local count = #cardsArray
    if count > 0 then
        for pos = 1, count do
            local sprite = cardsArray[pos].sprite
            if mode == "center" then
                sprite:pos(display.cx - 44*(count+1) + pos*88, display.bottom+100)
            elseif mode == "right" then
                sprite:pos(display.right-115-44-(count-pos)*88, display.bottom+100)
            elseif mode == "link" then
                sprite:pos(display.right-115+44-(count-pos)*88, display.bottom+100)
            elseif mode == "single" then
                if pos == count then
                    sprite:pos(display.right-115+54, display.bottom+100)
                else
                    sprite:pos(display.right-115+44-(count-pos)*88, display.bottom+100)
                end
            end 
        end
    end
end

function MJBottomCards:distributeCards(cards)
    for i=1, #cards do
        self:addCard(cards[i])
    end
    local count = #cardsArray + 3*#combinArray
    if count > 13 then
        self:sortCards()
        self:arrangeCards("link")
        sound.arrangeCard()
    elseif count == 13 then
        self:sortCards()
        self:arrangeCards("right")
        sound.arrangeCard()
    else
        self:arrangeCards("center")
    end
    return self
end

function MJBottomCards:arrangeAnime(anime)
    if anime then
        animeArrange = true
        local count = #cardsArray
        for i = 1, count do
            local sprite = display.newSprite("#ShYMJ/img_spe_backcard.png")
            :pos(display.cx - 31*(count+1) + i*62, display.bottom+80)
            :addTo(arrangeLevel)
        end
        handLevel:hide()
    elseif animeArrange then
        animeArrange = false
        arrangeLevel:removeAllChildren()
        handLevel:show()
    end
end

function MJBottomCards:outCard(card)
    self:removeCard(card)
    self:sortCards()
    self:arrangeCards("right")
    -- self:addOut(card)
end

function MJBottomCards:drawCard(card)
    self:addCard(card)
    self:arrangeCards("single")
end

function MJBottomCards:complementCards(cards, del)
    local count = #cards
    for i = 1, count do
        if cards[i] < 16*5 then
            self:addCard(cards[i])
        else
            self:addFlower(cards[i])
            if del and watchingGame then
                self:removeCard()
            end
        end
    end
    
    while true do
        local card = self:removeFlower()
        if card == 0 then
            break
        end
    end
 
    self:sortCards(true)
    self:arrangeCards("single")
end

function MJBottomCards:combinCard(combin, card, direct)
    self:addCombin(combin, card, direct)
    if combin == "left" then
        self:removeCard(card+1)
        self:removeCard(card+2)
    elseif combin == "center" then
        self:removeCard(card-1)
        self:removeCard(card+1)
    elseif combin == "right" then
        self:removeCard(card-2)
        self:removeCard(card-1)
    elseif combin == "peng" then
        self:removeCard(card)
        self:removeCard(card)
    elseif combin == "gang" then
        self:removeCombin("peng", card)
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
        self:removeCard(card)
    end
    self:arrangeCards("link")
end

function MJBottomCards:allowOut(allow, card, mode)
    if not watchingGame then
        local count = #cardsArray
        for i = 1, count do
            if allow then
                local ignore = false
                if mode == 1 then
                    ignore = true
                end
                for j = 1, #card do
                    if cardsArray[i].val == card[j] then
                        if mode == 1 then
                            ignore = false
                        else
                            ignore = true
                        end
                        break
                    end
                end
                if ignore then
                    cardsArray[i].touch = false
                    cardsArray[i].shadow:show()
                    cardsArray[i].sprite:setTouchEnabled(false)
                else
                    cardsArray[i].touch = true
                    cardsArray[i].shadow:hide()
                    cardsArray[i].sprite:setTouchEnabled(true)
                end
            else
                cardsArray[i].touch = false
                cardsArray[i].sprite:setTouchEnabled(false)
                cardsArray[i].shadow:hide()
            end
        end
    end
end

function MJBottomCards:allowFlower(allow, card)
    if not watchingGame then
        local count = #cardsArray
        for i = 1, count do
            if allow then
                if cardsArray[i].val == card then
                    cardsArray[i].touch = true
                    cardsArray[i].sprite:setTouchEnabled(true)
                    cardsArray[i].shadow:hide()
                else
                    cardsArray[i].touch = false
                    cardsArray[i].sprite:setTouchEnabled(false)
                    cardsArray[i].shadow:show()
                end
            else
                cardsArray[i].touch = false
                cardsArray[i].sprite:setTouchEnabled(false)
                cardsArray[i].shadow:hide()
            end
        end
    end
end

function MJBottomCards:watching(watch)
    watchingGame = watch
end

function MJBottomCards:clear()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
    handLevel = nil
    huaLevel = nil
    outLevel = nil
    arrangeLevel = nil
end
function MJBottomCards:restart()
    handLevel:removeAllChildren()
    huaLevel:removeAllChildren()
    outLevel:removeAllChildren()
    arrangeLevel:removeAllChildren()
    cardsArray = {}
    flowerArray = {}
    outArray = {}
    combinArray = {}
end

function MJBottomCards:init(callback)
    self.callBack = callback
    return self
end

return MJBottomCards