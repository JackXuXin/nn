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
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 39, 59))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_up.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card_up_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 39, 59))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_up_h.png")

    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_Hua.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_Hua.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card_h.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_Hua_h.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX_Hua.png")
    -- for i = 1, 3 do
    --     for j = 1, 4 do
    --         if i == 1 and j < 4 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 39*(i-1), 31, 39))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 4*16+4+j))
    --         elseif i == 2 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 39*(i-1), 31, 39))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+j))
    --         elseif i == 3 then
    --             frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 39*(i-1), 31, 39))
    --             cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+4+j))
    --         end
    --     end
    -- end

    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_top.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_top.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_top_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(36*(j-1), 44.6*(i-1), 36, 44.6))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
        end
    end

    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_paichiZY.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 51, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY.png")
    --yellow
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_paichiZY_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 51, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_UpZY.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(30*(j-1), 24*(i-1), 30, 24))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_UpZY%d.png", i*16+j))
        end
    end
    
    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_cpg_back.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_cpg_back.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_cpg_back_h.png")
   -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_Up_cpg.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_Up_cpg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_Up_cpg_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(32*(j-1), 39.6*(i-1), 32, 39.6))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
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
    local scaleX = 0.644
    local scaleY = 0.727
    local num = 7
    local bPosX = 0
    local num2 = 9
    if max == 2 then
        bPosX = 38
        num2 = 16
        num = 6
    end

    local offX = 18
    local offY = 31

    local dis = math.floor(count/num)
    local imgName = "#ShYMJ/img_spe_paichiSX_Hua"
    imgName = getUsedSrc(imgName)
    local sprite = display.newSprite(imgName)
    :setScale(scaleX, scaleY)
   -- :pos(display.left+500+count*22, display.top-135)
    :pos(display.cx + 37*num2/2+37*num- (count%num)*37.5-bPosX, display.top - 284+58+58*2 - dis*48)
    :addTo(huaLevel)

    display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
    :pos(12+offX, 23+offY)
    :setRotation(180)
    :addTo(sprite)
    :setScale(1.2)
    
    table.insert(flowerArray, count+1, {val=card, sprite=sprite})
    return self
end

function MJTopCards:addOut(card, max)
    local num = 9
    if max == 2 then
        --num = 22
        num = 16
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
    local scaleX = 0.644
    local scaleY = 0.727
    local offX = 11
    local offY = 18.5
    local bPosX = 0--38*3
    if max == 4 then
        bPosX = 0
    end
        local dis = math.floor(count/num)
        --dis = 43*(dis % 2) + 12*math.floor(dis/2)
        local imgName = "#ShYMJ/img_spe_paichiSX_top"
        imgName = getUsedSrc(imgName)
        local sprite = display.newSprite(imgName)
        :setScale(scaleX, scaleY)
        --:setFlipY(true)
        :pos(display.cx + 37*num/2-24+4 - (count%num)*37-bPosX, display.top - 272+63-10 + dis*48)
        -- if count % (2*num) > num-1 then
        --     sprite:addTo(outSeconde)
        -- else
        sprite:addTo(outLevel, 3-dis)
        --end
        local flower=display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", card))
        :pos(18+offX, 35+offY)
        :setRotation(180)
        :setScale(1.4)
        :addTo(sprite)
        local icon = "#ShYMJ/img_up_card_hun.png"
        local majiang = self.callBack:getMajiang()
        if majiang == "shzhmj" then
            icon = "#ShYMJ/img_up_card_hun_cai.png"
        end
        local dragon=display.newSprite(icon)
        :pos(21+20, 40-12+10)
        :addTo(sprite)
        if card == val then
            sprite:setColor(cc.c3b(235, 206, 134))
            sprite:setCascadeColorEnabled(false)
            dragon:show()
        else
            dragon:hide()
        end
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
        sp:pos(display.right- 390 - (i-1)*3*40, display.top-65+18)
    end
end

function MJTopCards:addCombin(combin, card, direct)
    local count = #combinArray
    local sprite = display.newSprite()
    :pos(display.right- 390 - count*3*40, display.top-62+18)
   -- :pos(display.right- 340 - count*3*40, display.top-62+18)
    :addTo(handLevel)
    local backScaleX = 0.525
    local backScaleY = 0.568

    print("MJTopCards:addCombin------",combin,direct)

    local zyScaleX = 0.823
    local zyScaleY = 0.906
    local offX = 13
    local offY = 23
    local scale = 1.2
    local img_spe_cpgZY = "#ShYMJ/img_spe_cpgZY"
    img_spe_cpgZY = getUsedSrc(img_spe_cpgZY)
    local img_spe_Up_cpg = "#ShYMJ/img_spe_Up_cpg"
    img_spe_Up_cpg = getUsedSrc(img_spe_Up_cpg)
    if combin == "left" then
        local temp =  display.newSprite(img_spe_Up_cpg)
        :setScale(backScaleX, backScaleY)
        :pos(-2, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+1))
        :pos(17+offX, 30+offY)
        :setRotation(180)
        :addTo(temp)
        :setScale(scale)
        temp =  display.newSprite(img_spe_cpgZY)
        :pos(35, 5)
        :setScale(zyScaleX, zyScaleY)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
        :pos(21+4, 27)
        :setRotation(180)
        :addTo(temp)
        --:setScale(scale)
        temp =  display.newSprite(img_spe_Up_cpg)
        :setScale(backScaleX, backScaleY)
        :pos(-34,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+2))
        :pos(17+offX, 30+offY)
        :setRotation(180)
        :addTo(temp)
        :setScale(scale)
    elseif combin == "center" then
        local temp =  display.newSprite(img_spe_Up_cpg)
        :setScale(backScaleX, backScaleY)
        :pos(-2, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-1))
        :pos(17+offX, 30+offY)
        :setRotation(180)
        :addTo(temp)
        :setScale(scale)
        temp =  display.newSprite(img_spe_cpgZY)
        :pos(36-1,5)
        :setScale(zyScaleX, zyScaleY)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
        :pos(21+4, 27)
        :setRotation(180)
        :addTo(temp)
        --:setScale(scale)
        temp =  display.newSprite(img_spe_Up_cpg)
        :setScale(backScaleX, backScaleY)
        :pos(-34,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card+1))
        :pos(17+offX, 30+offY)
        :setRotation(180)
        :addTo(temp)
        :setScale(scale)
    elseif combin == "right" then
        local temp =  display.newSprite(img_spe_Up_cpg)
        :setScale(backScaleX, backScaleY)
        :pos(-2, 0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-2))
        :pos(17+offX, 30+offY)
        :setRotation(180)
        :addTo(temp)
        :setScale(scale)
        temp =  display.newSprite(img_spe_cpgZY)
        :pos(35,5)
        :setScale(zyScaleX, zyScaleY)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
        :pos(21+4, 27)
        :setRotation(180)
        :addTo(temp)
        --:setScale(scale)
        temp =  display.newSprite(img_spe_Up_cpg)
        :setScale(backScaleX, backScaleY)
        :pos(-34,0)
        :addTo(sprite)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card-1))
        :pos(17+offX, 30+offY)
        :setRotation(180)
        :addTo(temp)
        :setScale(scale)
    elseif combin == "peng" then
        if direct == "left" then
            local temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_cpgZY)
            :pos(-35, 5)
            :setScale(zyScaleX, zyScaleY)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21+4, 27)
            -- :setRotation(180)
            :addTo(temp)
            --:setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(34,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        elseif direct == "right" then
            local temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_cpgZY)
            :pos(35, 5)
            :setScale(zyScaleX, zyScaleY)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21+4, 27)
            :setRotation(180)
            :addTo(temp)
            --:setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-30,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        else
            local temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        end
    elseif combin == "gang" then
        if direct == "left" then
            local temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_cpgZY)
            :pos(-35, 3)
            :setScale(zyScaleX, zyScaleY)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21+4, 27)
            -- :setRotation(180)
            :addTo(temp)
            --:setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(34,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(2,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        elseif direct == "right" then
            local temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-2, 0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_cpgZY)
            :pos(35, 3)
            :setScale(zyScaleX, zyScaleY)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_UpZY%d.png", card))
            :pos(21+4, 27)
            :setRotation(180)
            :addTo(temp)
            --:setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-34,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-2,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        elseif direct == "bottom" then
            local temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(-32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(32,0)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(0,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        else
            local img_spe_backcard = "#ShYMJ/img_spe_paichiSX_cpg_back"
            img_spe_backcard = getUsedSrc(img_spe_backcard)
            local temp =  display.newSprite(img_spe_backcard)
            :addTo(sprite)
            :setScale(backScaleX, backScaleY)
            temp =  display.newSprite(img_spe_backcard)
            :setScale(backScaleX, backScaleY)
            :pos(-32,0)
            :addTo(sprite)
            temp =  display.newSprite(img_spe_backcard)
            :setScale(backScaleX, backScaleY)
            :pos(32,0)
            :addTo(sprite)
            temp =  display.newSprite(img_spe_Up_cpg)
            :setScale(backScaleX, backScaleY)
            :pos(0,13)
            :addTo(sprite)
            display.newSprite(string.format("#ShYMJ/img_cardvalue_shoupai_cpg%d.png", card))
            :pos(17+offX, 30+offY)
            :setRotation(180)
            :addTo(temp)
            :setScale(scale)
        end
        
    end
    table.insert(combinArray, count+1, {combin=combin, val=card, sprite=sprite})
    return self
end

function MJTopCards:addCard()
    local imgName = "ShYMJ/img_normal_card_up"
    imgName = getUsedSrc(imgName)
    local sprite = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(imgName))
    :addTo(handLevel)
    table.insert(cardsArray, #cardsArray+1, {val=card, sprite=sprite})
end

function MJTopCards:getCardsArray()
    return cardsArray
end

function MJTopCards:arrangeCards(mode)
    local count = #cardsArray
    if count > 0 then
        for pos = 1, count do
            local sprite = cardsArray[pos].sprite
            if mode == "center" then
                sprite:pos(display.cx - 18*(count+1) + pos*36+10, display.top-60+18)
            elseif mode == "right" then
                sprite:pos(display.cx - 18*13 + 5 + pos*36+10, display.top-60+18)
            elseif mode == "link" then
                sprite:pos(display.cx - 18*15 + 5 + pos*36+10, display.top-60+18)
            elseif mode == "single" then
                if pos == 1 then
                    sprite:pos(display.cx - 18*15 - 5 + pos*36+10, display. top-60+18)
                else
                    sprite:pos(display.cx - 18*15 + 5 + pos*36+10, display.top-60+18)
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
            --self:addFlower(cards[i])
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