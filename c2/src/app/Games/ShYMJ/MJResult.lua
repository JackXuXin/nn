local MJResult = class("MJResult",function()
    return display.newSprite()
end)

local crypt = require("crypt")
local util = require("app.Common.util")

local leftPanel
local leftPanelex
--local rightPanel
--local resultPanel
--local scorePanel

local baseScore
local cardNumber
local suanFenStr
local liang
local pubStr

local dragonCard
local cardValue

local pointText1
local pointText2

local startButton
local leaveButton

--local resultScore
--local resultCards
--local resultPoints

--local reusltBlank
local iconDragon
--结算牌的位置
local cardLocation
local bg_result
local bg_show_result
local max_player
local my_seat
local score_num
local banker_seat
local islian    --连庄
local hua_num

function MJResult:ctor()
	local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/zuoshang.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 153, 111))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/zuoshang.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/zuoshang_h.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 153, 111))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/zuoshang_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_BaoziBg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 153, 39))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_BaoziBg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/baozi.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 60, 33))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/baozi.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/youshang_er.png")
    -- --modify by whb 161103
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 196, 75))
    -- --modify end
    -- --frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 151, 108))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/youshang_er.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun_cai.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card_h.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 59, 88))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card_h.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 5 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(56*(j-1), 69.2*(i-1), 56, 69.2))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(36*(j-1), 44.6*(i-1), 36, 44.6))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
        end
    end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/LaoZhuang.png")
    -- for i = 1, 2 do
    --     for j = 1, 6 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(28*(j-1), 28*(i-1), 28, 28))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/LaoZhuang%d.png", (i-1)*6+j))
    --     end
    -- end
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/result_fanshu.png")
    for i = 1, 16 do
        frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29*(i-1), 205, 29))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_fanshu%d.png", i))
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/result_shengzhou_fanshu.png")
    for i = 1, 8 do
        frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29*(i-1), 146, 29))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_shengzhou_fanshu%d.png", i))
    end


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/Hu.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/Hu.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/img_cardvalue_tuzhang1.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 271, 215))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_cardvalue_tuzhang1.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/DYResult/img_card_result.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 43, 62))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/DYResult/img_card_result.png")

    leftPanelex = display.newSprite("#ShYMJ/img_BaoziBg.png")
    :pos(2, display.height-96-2-111-2)
    :hide()
    :addTo(self)
    :setAnchorPoint(0,1)

    local baozi = display.newSprite("#ShYMJ/baozi.png")
    :pos(59, 19)
    :addTo(leftPanelex)
    :setAnchorPoint(0.5,0.5)

    leftPanel = display.newSprite("#ShYMJ/zuoshang.png")
    :pos(2, display.height-96-4)
    :hide()
    :addTo(self)
    :setAnchorPoint(0,1)

    baseScore = cc.ui.UILabel.new({color=cc.c3b(125,220,51), size=18, text="100", align=align})
    :pos(57, 30)
    :hide()
    :addTo(leftPanel)
    baseScore:setAnchorPoint(0.5, 0.5)

    suanFenStr = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="1-3-10", align=align})
    :pos(42, 30)
    :hide()
    :addTo(leftPanel)
    suanFenStr:setAnchorPoint(0, 0.5)

    liang = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=17, text="花", align=align})
    :pos(78, 30)
    :hide()
    :addTo(leftPanel)
    liang:setAnchorPoint(0, 0.5)
    pubStr = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=17, text="底花", align=align})
    :pos(3, 30)
    :addTo(leftPanel)
    :hide()
    pubStr:setAnchorPoint(0, 0.5)

    cardNumber = cc.ui.UILabel.new({color=cc.c3b(125,220,51), size=18, text="98", align=align})
    :pos(57, 10)
    :hide()
    :addTo(leftPanel)
    cardNumber:setAnchorPoint(0.5, 0.5)

    --img_spe_paichiSX

    dragonCard = display.newSprite("#ShYMJ/img_spe_card.png")
    :setScale(0.52)
    :setAnchorPoint(0.5, 1)
    :pos(50, 105)
    :hide()
    :addTo(leftPanel)
    cardValue=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", 16*4+8))
    :pos(31, 53)
    :addTo(dragonCard)
    iconDragon = display.newSprite("#ShYMJ/img_up_card_hun.png")
    :setRotation(180)
    :pos(18, 75)
    :addTo(dragonCard)

    pointText1 = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="翻", align=align})
    :pos(display.cx, display.cy+25)
    :hide()
    :addTo(leftPanel)
    pointText1:setAnchorPoint(0.5, 0.5)

    pointText2 = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="牌", align=align})
    :pos(display.cx, display.cy+25)
    :hide()
    :addTo(leftPanel)
    pointText2:setAnchorPoint(0.5, 0.5)

    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultBg.png")
    --frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 1280, 563))
    --cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultBg.png")

    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultSmallBg.png")
    --frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 912, 244))
    --cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultSmallBg.png")

    --texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultSmallBg_shengzhou.png")
    --frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 912, 244))
    --cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultSmallBg_shengzhou.png")

    --resultPanel = display.newSprite("#ShYMJ/ResultBg.png")
    --:pos(display.cx, display.cy)
    --:hide()
    --:addTo(self)

    --scorePanel = display.newSprite("#ShYMJ/ResultSmallBg.png")
    --:pos(640, 220)
    --:addTo(resultPanel)

    -- startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_selected.png" })
    -- :onButtonClicked(function()
    --     self:OnRestartButton()
    --  end)
    -- :pos(640 + 150, 50)
    -- :addTo(resultPanel)

    -- leaveButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit2_normal.png", pressed = "ShYMJ/button_quit2_selected.png" })
    -- :onButtonClicked(function()
    --     self:OnLeaveButton()
    --  end)
    -- :pos(640 - 150, 50)
    -- :addTo(resultPanel)

    -- resultScore = {{}, {}}
    -- for index = 1, 2 do
    --     for row = 1, 4 do
    --         local hu = display.newSprite("#ShYMJ/Hu.png")
    --         :pos(0, 197.5-row*45)
    --         :hide()
    --         :addTo(scorePanel)

           -- local name = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
           --:pos(30, 200-row*42)
           -- :addTo(scorePanel)
           -- name:setAnchorPoint(0, 0.5)

            --local flower = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            --:pos(475, 200-row*42)
            --:addTo(scorePanel)
            --flower:setAnchorPoint(0.5, 0.5)

            --local bao = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            --:pos(558, 200-row*42)
            --:addTo(scorePanel)
            --bao:setAnchorPoint(0.5, 0.5)

            --local score = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            --:pos(810, 200-row*42)
            --:addTo(scorePanel)
            --score:setAnchorPoint(0.5, 0.5)

            --resultScore[index][row] = {name=name, flower=flower, bao=bao, score=score, hu=hu}
        --end
    --end

    -- resultCards = display.newSprite()
    -- :addTo(resultPanel)

    -- resultPoints = display.newSprite()
    -- :addTo(resultPanel)

    -- reusltBlank = display.newSprite("ShYMJ/ResultDrawBg.png")
    -- :pos(display.cx, display.cy - 20)
    -- :hide()
    -- :addTo(resultPanel)

end

function MJResult:setMaxPlayer(max,seat)
    max_player = max
    my_seat = seat
end

function MJResult:setBaseScore(score, majiang, sfType)
	
	baseScore:show()
    score_num = score
    pubStr:show()

    if majiang == "shzhmj" then
        baseScore:hide()
        suanFenStr:show()
        if sfType == 1 then
            suanFenStr:setString("2-5-15")
        else
            suanFenStr:setString("1-3-10")
        end
        liang:hide()
        pubStr:setString("算分")
    else

        local huaIndex = 2
        for i = 2, 5 do
            local hua = util.test_bit(sfType, i)
            if hua == 1 then
                huaIndex = i
                break
            end
        end

        hua_num = huaIndex
        baseScore:setString(string.format("%d", hua_num))

        suanFenStr:hide()
        pubStr:setString("底花")
        liang:show()
    end

    local imgName = "ShYMJ/zuoshang"
    imgName = getUsedSrc(imgName)
    leftPanel:setTexture(imgName)
    --leftPanel:pos(2, display.height-96-2)
    --leftPanel:show()
end
function MJResult:setBanker(banker,lian)
    if lian ~= nil then
         print("连庄的值" ..lian)
    end

    banker_seat =banker
    islian = lian
    --leftPanel:show()
end
function MJResult:setCardNumber(number)
	cardNumber:setString(string.format("%d", number))
	cardNumber:show()
    --leftPanel:show()
end

function MJResult:setSuanFen(type)
    cardNumber:setString(string.format("%d", number))
    cardNumber:show()
    --leftPanel:show()
end

function MJResult:showInfo()

    leftPanel:show()
end

function MJResult:showBaoziInfo()
    if leftPanelex ~= nil then
        leftPanelex:show()
    end
end

function MJResult:setDragon(dragon)
    local icon = "ShYMJ/img_up_card_hun.png"
    local majiang = self.callBack:getMajiang()
    if majiang == "shzhmj" then
        icon = "ShYMJ/img_up_card_hun_cai.png"
    end
    iconDragon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(icon))
	cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", dragon)))
	dragonCard:show()
    local imageName = "ShYMJ/img_spe_card"
    imageName = getUsedSrc(imageName)
    dragonCard:setTexture(imageName)
    -- rightPanel:show()
end

--modify by whb 161103
function MJResult:setOpenCard(dragon)

--     local majiang = self.callBack:getMajiang()


--     local card = dragon-1
--     if dragon == 16*1+1 then

--         card = 16*1+9

--     elseif dragon == 16*2+1 then

--         card = 16*2+9

--     elseif dragon == 16*3+1 then

--         card = 16*3+9

--     elseif dragon == 16*4+1 then

--         card = 16*4+4

--     end

-- -- modify by whb shzmj fan card
--     if majiang == "shzhmj" and dragon == 16*4+5 then

--         card = 16*4+7

--     end

    local card = dragon

    print("setOpenCard-dragon:" .. dragon)
    print("setOpenCard:" .. card)

    iconDragon:hide()
    cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
    local imageName = "ShYMJ/img_spe_card"
    imageName = getUsedSrc(imageName)
    dragonCard:setTexture(imageName)
    dragonCard:show()
    --rightPanel:show()
end
--modify end

-- function MJResult:setPoints(point1, point2)
-- 	if point1 > 0 and point1 < 7 then
--         pointText1:hide()
-- 		pointNumber1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", 6+point1)))
-- 		--pointNumber1:show()
--     else
--         pointNumber1:hide()
--         pointText1:hide()
-- 	end

-- 	if point2 > 0 and point2 < 7 then
--         pointText2:hide()
-- 		pointNumber2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", point2)))
-- 		--pointNumber2:show()
--     else
--         pointNumber2:hide()
--         pointText2:hide()
-- 	end
--     --rightPanel:show()
-- end

function MJResult:hunCards(combin, cards,index,winner,mode)
    -- resultCards:removeAllChildren()

    local dragon = self.callBack:getDragonCard()
   -- local xpos = display.cx - (#combin*190+#cards*60+10)/2 + 30
    local count = #combin
    for i = 1, count do
        if combin[i].combin == "left" then
            print("left" ..index)
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                -- :setScale(0.6)
                :pos(cardLocation[index]+(j-1)*37,display.height - 72 - index * 105)
                :addTo(bg_result)

                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card+j-1))
                -- :setScale(1.3)
                :pos(22, 37)
                :addTo(sprite)
                print("left" ..combin[i].card+j-1)
            end
            cardLocation[index]=cardLocation[index]+3*37+20
        elseif combin[i].combin == "center" then
            print("center" ..index)
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                -- :setScale(0.6)
                :pos(cardLocation[index]+(j-1)*37,display.height - 72 - index * 105)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card+j-2))
                -- :setScale(1.3)
                :pos(22, 37)
                :addTo(sprite)
                print("center" ..combin[i].card+j-2)
            end
            cardLocation[index]=cardLocation[index]+3*37+20
        elseif combin[i].combin == "right" then
            print("right" ..index)
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                -- :setScale(0.6)
                :pos(cardLocation[index]+(j-1)*37,display.height - 72 - index * 105)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card+j-3))
                -- :setScale(1.3)
                :pos(22, 37)
                :addTo(sprite)
                print("right" ..combin[i].card+j-3)
            end
            cardLocation[index]=cardLocation[index]+3*37+20
        elseif combin[i].combin == "peng" then
            print("peng" ..index)
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                -- :setScale(0.6)
                :pos(cardLocation[index]+(j-1)*37,display.height - 72 - index * 105)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                -- :setScale(1.3)
                :pos(22, 37)
                :addTo(sprite)
                print("peng" ..combin[i].card)
            end
            cardLocation[index]=cardLocation[index]+3*37+20
        elseif combin[i].combin == "gang" then
            print("gang" ..index)
            print("gang" ..combin[i].card)
            if combin[i].out > 0 then
                for j = 1, 3 do
                    local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                    -- :setScale(0.6)
                    :pos(cardLocation[index]+(j-1)*37,display.height - 72 - index * 105)
                    :addTo(bg_result)
                    display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                    -- :setScale(1.3)
                    :pos(22, 37)
                    :addTo(sprite)
                end
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                -- :setScale(0.6)
                :pos(cardLocation[index]+37, display.height - 72 - index * 105 + 14)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                -- :setScale(0.9)
                :pos(22, 37)
                :addTo(sprite)
                cardLocation[index]=cardLocation[index]+3*37+20
            else
                local img_spe_backcard = "#ShYMJ/img_spe_backcard"
                img_spe_backcard = getUsedSrc(img_spe_backcard)
                for j = 1, 3 do
                    display.newSprite(img_spe_backcard)
                    :setScale(0.6)
                    :pos(cardLocation[index]+(j-1)*37,display.height - 72 - index * 105)
                    :addTo(bg_result)
                end
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                -- :setScale(0.6)
                :pos(cardLocation[index]+37, display.height - 72 - index * 105 + 14)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                -- :setScale(1.3)
                :pos(22, 37)
                :addTo(sprite)
                cardLocation[index]=cardLocation[index]+3*37+20
            end

        end
        -- xpos = xpos + 60*3 + 10
    end

    count = #cards
    if count > 2 then
        for i = 1, count-2 do
            for j = i+1, count-1 do
                if (cards[i] > cards[j] and cards[i]~=dragon) or (cards[i] < cards[j] and cards[j]==dragon) then
                    local val = cards[i]
                    cards[i] = cards[j]
                    cards[j] = val
                end
            end
        end
    end
    local sum
    if index==winner and mode>0 and mode<2 then
        sum=count-1
    else
        sum=count
    end

    for i = 1, sum do

        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        -- :setScale(0.6)
        :pos(cardLocation[index]+(i-1)*36,display.height - 72 - index * 105)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cards[i]))
        -- :setScale(1.3)
        :pos(22, 37)
        :addTo(sprite)
        print("index-card[i] = ",index, i, cards[i])
        if dragon == cards[i] then
            local icon = "#ShYMJ/img_up_card_hun.png"
            local majiang = self.callBack:getMajiang()
            if majiang == "shzhmj" then
                icon = "#ShYMJ/img_up_card_hun_cai.png"
            end
	    display.newSprite(icon)
            :setRotation(180)
            :pos(19, 47)
            :addTo(sprite)
            sprite:setColor(cc.c3b(235, 206, 134))
            sprite:setCascadeColorEnabled(false)
        end
    end
    cardLocation[index]=cardLocation[index]+sum*37+20
    if index==winner and mode>0 and mode<2 then

        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        -- :setScale(0.6)
        :pos(cardLocation[index],display.height - 72 - index * 105)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cards[count]))
        -- :setScale(1.3)
        :pos(22, 37)
        :addTo(sprite)
        if dragon == cards[count] then
            --local icon = "#ShYMJ/img_up_card_hun.png"
            --local majiang = self.callBack:getMajiang()
            --if majiang == "shzhmj" then
            local icon = "#ShYMJ/img_up_card_hun_cai.png"
            --end
            display.newSprite(icon)
            :setRotation(180)
            :pos(17, 49)
            :addTo(sprite)
            sprite:setColor(cc.c3b(235, 206, 134))
            sprite:setCascadeColorEnabled(false)
        end
    end
end

function MJResult:hunPoints(points, index, majiang)
    --resultPoints:removeAllChildren()
    local count = #points
    print("points = ",count)
    local sumstr = ""
    local sumTable = {}
    for i = 1, count do

        local str = ""


        print("points[i].hun=",points[i].hun, string.len(points[i].hun), majiang)

        if majiang == "shzhmj" then
            if points[i].hun == "fangchong" then
                str = "放冲3番 "
            elseif points[i].hun == "qianggang" then
                str = "抢杠30番 "
            elseif points[i].hun == "baotou" then
                str = "爆头10番 "
            elseif points[i].hun == "gangkai" then
                str = "杠开10番 "
            elseif points[i].hun == "zimo" then
                str = "自摸3番 "
            elseif points[i].hun == "threecaipiao" then
                str = "三财飘X8 "
            elseif points[i].hun == "doublecaipiao" then
                str = "双财飘X4 "
            elseif points[i].hun == "caipiao" then
                str = "财飘X2 "
            end
        else
            if points[i].hun == "wuflowerwudragon" then
                str = "无龙无花50番 "

                table.insert(sumTable, {text=" 无龙无花", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="50", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "wuflower" then
                str = "无花2番 "

                table.insert(sumTable, {text=" 无花", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "fourdragon" then
                str = "四龙2番 "

                table.insert(sumTable, {text=" 四龙", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "gangkai" then
                str = "杠开2番 "

                table.insert(sumTable, {text=" 杠开", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "baozi" then
                str = "豹子2番 "

                table.insert(sumTable, {text=" 豹子", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "menqing" then
                str = "门清2番 "
                table.insert(sumTable, {text=" 门清", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "flydragon" then
                str = "飞龙2番 "
                table.insert(sumTable, {text=" 飞龙", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "fourflower" then
                str = "四花齐2番 "
                table.insert(sumTable, {text=" 四花齐", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "dadiao" then
                str = "大吊2番 "
                table.insert(sumTable, {text=" 大吊", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "pengpenghu" then
                str = "碰碰胡2番 "
                table.insert(sumTable, {text=" 碰碰胡", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "huanyise" then
                str = "混一色2番 "
                table.insert(sumTable, {text=" 混一色", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "baotou" then
                str = "爆头2番 "
                table.insert(sumTable, {text=" 爆头", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "wudragon" then
                str = "无龙2番 "
                table.insert(sumTable, {text=" 无龙", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="2", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "qingyise" then
                str = "清一色4番 "
                table.insert(sumTable, {text=" 清一色", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="4", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "doubleflydragon" then
                str = "双飞龙4番 "
                table.insert(sumTable, {text=" 双飞龙", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="4", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            elseif points[i].hun == "threeflydragon" then
                str = "三飞龙8番 "
                table.insert(sumTable, {text=" 三飞龙", color=cc.c3b(31, 173, 157)})
                table.insert(sumTable, {text="8", color=cc.c3b(221, 150, 68)})
                table.insert(sumTable, {text="番 ", color=cc.c3b(31, 173, 157)})
            end

        end

        sumstr = sumstr .. str .. " "

	end
    if majiang == "shzhmj" then
         if sumstr ~= nil then

            print("str:",sumstr)
            cc.ui.UILabel.new({
            text = sumstr,
            size = 18,
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(340,display.height - 120 - index * 105)
        end
    else
        util.setRichText(bg_result, cc.p(200+334, display.height - 128 - index * 105), sumTable, 400, 40, 20)
    end

end

function MJResult:clearResult()
   --resultPoints:removeAllChildren()
   --resultCards:removeAllChildren()
    -- for i = 1, 2 do
    --     for j = 1, 4 do
    --         resultScore[i][j].name:setString("")
    --         resultScore[i][j].flower:setString("")
    --         resultScore[i][j].bao:setString("")
    --         resultScore[i][j].score:setString("")
    --         resultScore[i][j].hu:hide()
    --     end
    -- end
    --laziSprite:hide()
    if bg_result then
        bg_result:removeFromParent()
        bg_result = nil
    end

    if bg_show_result then
        bg_show_result:removeFromParent()
        bg_show_result = nil
    end
end

function MJResult:hideButton()
    startButton:hide()
    leaveButton:hide()
end

function MJResult:createResult(result, watching, majiang, heads, table_code, weixinImage, customization)

    if majiang == "shzhmj" then
        --scorePanel:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ResultSmallBg_shengzhou.png"))

    end

    --牌的相对位置
    cardLocation={350,350,350,350}
    bg_result = display.newSprite("ShYMJ/DYResult/BG.png")
    :pos(display.cx,display.cy)
    :addTo(self)

    --是否慌庄
    local top_str
    if result.mode <= 0 then
        top_str = "ShYMJ/DYResult/huangzhuang.png"
    else
        top_str = "ShYMJ/result_top.png"
    end
    local showTitle = display.newSprite(top_str)
    :pos(display.cx + 20,display.height - 80)
    :addTo(bg_result)


    --低分
    local lianzhuang=islian

    local text = "底花：" .. tostring(hua_num) .. "花"
    local textTable = {{text="底花：", color=cc.c3b(255, 255, 255)},
    {text=tostring(hua_num), color=cc.c3b(221, 150, 68)}, {text="花", color=cc.c3b(255, 255, 255)}}

    if majiang == "shzhmj" then
        if customization == 0 then
            text = "算分：1-3-10"
        else
            text = "算分：2-5-15"
        end
    end

    if lianzhuang ~= nil and lianzhuang>0 then

        text = "底花：" .. tostring(hua_num) .. "花" ..tostring(lianzhuang) .."连庄 "

        if majiang == "shzhmj" then
            if customization == 0 then
                text = "算分：1-3-10 " .. tostring(lianzhuang) .."连庄 "
            else
                text = "算分：2-5-15 " .. tostring(lianzhuang) .."连庄 "
            end
        end

        textTable = {{text="底花：", color=cc.c3b(255, 255, 255)},
        {text=tostring(hua_num), color=cc.c3b(221, 150, 68)}, {text="花", color=cc.c3b(255, 255, 255)},
        {text=tostring(lianzhuang), color=cc.c3b(221, 150, 68)}, {text="连庄", color=cc.c3b(255, 255, 255)}}

    end

    util.setRichText(bg_result, cc.p(200+220, 130), textTable, 400, 40, 22)
    -- cc.ui.UILabel.new({
    --     --text = "底分：每龙" .. tostring(hua_num) .. "两 " ..tostring(lianzhuang) .."连庄 "  .."底龙" ..tostring(dilong) .."龙",
    --     text = text,
    --     size = 22,
    --     color = cc.c3b(255,255,255)
    --     })
    -- :addTo(bg_result)
    -- :setAnchorPoint(0.5,0.5)
    -- :setPosition(220,130)

    if not watching then
        startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_normal.png" })
        :onButtonClicked(
        function()
            self:OnRestartButton()
         end)
        :pos(display.cx + 150, 80)
        :addTo(bg_result)
    end

    util.BtnScaleFun(startButton)

    leaveButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit2_normal.png", pressed = "ShYMJ/button_quit2_normal.png" })
    :onButtonClicked(function()
        self:OnLeaveButton()
     end)
    :pos(display.cx - 150, 80)
    :addTo(bg_result)

    util.BtnScaleFun(leaveButton)

     --玩家信息
    local hua = cc.ui.UILabel.new({
            text = "花",
            size = 22,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 285,display.height - 120)

    local offLen = 0
    if majiang == "shzhmj" then
        hua:hide()
        offLen = 30
    end


    local bao = cc.ui.UILabel.new({
            text = "承包",
            size = 22,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 215-offLen,display.height - 120)
    local scoreFen = cc.ui.UILabel.new({
            text = "总分数",
            size = 22,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 125-offLen,display.height - 120)


    local winner = 0
    for i = 1,#result.scores do
        --赢家
        if  result.scores[i].hu > 0 then
            display.newSprite("ShYMJ/DYResult/win_bg.png")
            :pos(display.cx,display.height - 80 - i * 105 - 5)
            :addTo(bg_result)
            winner=i

        end

        display.newSprite("ShYMJ/DYResult/head_bg.png")
        :pos(250,display.height - 80 - i * 105)
        :addTo(bg_result)
        --头像
        print("heads[i]",heads[i])
        local headImage=display.newSprite(heads[i])
        :pos(250,display.height - 80 - i * 105)
        :addTo(bg_result)
        :scale(0.4)
        if weixinImage and weixinImage[i] then
            util.setHeadImage(headImage:getParent(), weixinImage[i], headImage, heads[i])
        end
        --名字


        local name = crypt.base64decode(result.scores[i].name)
        name = util.checkNickName(name)
        local name = cc.ui.UILabel.new({
                text = name,
                size = 18,
                color = cc.c3b(255,255,255)
        })
        :addTo(bg_result)
        :setAnchorPoint(0.5,0.5)
        :setPosition(250,display.height - 80 - i * 105 - 45)


        --本方
        print("my_seat-i = my_seat",i,my_seat)
        if i == my_seat then
            print("my_seat---")
            local benfang = display.newSprite("ShYMJ/DYResult/benfang.png")
            :pos(250 - 100, display.height - 80 - i * 105)
            :setAnchorPoint(0.5,0.5)
            :addTo(bg_result)
        end
        --花
        local scoreL = cc.ui.UILabel.new({
            text = tostring(result.scores[i].flower),
            size = 22,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 283,display.height - 80 - i * 105)

        if majiang == "shzhmj" then
            scoreL:hide()
        end

         --承包
        local scoreL = cc.ui.UILabel.new({
            text = tostring(result.scores[i].bao),
            size = 22,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 200-offLen,display.height - 80 - i * 105)

        --总分数
        local scoreF = cc.ui.UILabel.new({
            text = tostring(result.scores[i].score),
            size = 22,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 123-offLen,display.height - 80 - i * 105)

        print("result.scores[i].score = ",result.scores[i].score)
        local find = string.find(result.scores[i].score, "输")
        if find ~= nil then
            scoreF:setTextColor(cc.c3b(27,207,237))
        end
    end

     if result.mode > 0 then
         if result.chao > 0 then

            local laziSprite = display.newSprite("#ShYMJ/img_cardvalue_tuzhang1.png")
            :pos(256, 122)
            :hide()
            :addTo(bg_result)
            if laziSprite then
                laziSprite:show()
            end
         end

     end

    if winner == my_seat then
        if result.mode > 0 then
            showTitle:setTexture("ShYMJ/DYResult/img_Succ.png")
        end

        bg_result:setTexture("ShYMJ/DYResult/img_WinBg.png")
    else
        if result.mode > 0 then
            showTitle:setTexture("ShYMJ/DYResult/img_Fail.png")
        end
        bg_result:setTexture("ShYMJ/DYResult/img_LoseBg.png")
    end

    --麻将
    print("显示牌1")
    for i=1,#result.infos do

        print("显示牌2")
        local combin=result.infos[i].combins
        local cards=result.infos[i].cards

        print("infos[i].cards =,winder = ",i,winder)
        self:hunCards(combin, cards,i,winner,result.mode)

    end

    print("显示胡牌类型")
   -- dump(result.points, "result.points = ")
    --胡牌类型
    self:hunPoints(result.points, result.hun, majiang)

     --庄家图标
    local bankerSprite=display.newSprite("ShYMJ/img_GameUI_zhuang.png")
    :pos(250 + 37.5,display.height - 80 - banker_seat * 105 + 25)
    :addTo(bg_result,1000)

    if islian and islian>1 then
        print("连庄")
        --todo
        bankerSprite:setTexture("ShYMJ/img_GameUI_lian_zhuang.png")
    else
        print("正常庄")
        bankerSprite:setTexture("ShYMJ/img_GameUI_zhuang.png")
    end

    if result.mode <= 0 then

        bankerSprite:hide()

    end

    --添加显示桌面功能---

    --显示结算面板
    --bg_show_result = display.newScale9Sprite("ShYMJ/mask.png")
    bg_show_result = display.newSprite()
        :setTouchEnabled(true)
        :hide()
        :pos(display.cx,display.cy)
        :size(display.width,display.height)
        :addTo(self)

    local curRound = app.constant.gameround
    local maxRount = app.constant.curRoomRound
    print("curRound = ,maxRount = ", curRound, maxRount)

    --显示结算按钮
    local btn_show_result = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_show_result.png", pressed = "ShYMJ/btn_show_result.png" })
        :onButtonClicked(function()
            bg_show_result:hide()
            bg_result:show()
        end)
        :pos(640-160, 170)
        :addTo(bg_show_result)

    util.BtnScaleFun(btn_show_result)

    local btn_continue_0 = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_normal.png" })
        :onButtonClicked(function()

            self.callBack:ReadyNextRound()

        end)
        :pos(640+160, 170)
        :addTo(bg_show_result)

    util.BtnScaleFun(btn_continue_0)

    if curRound == maxRount then
        btn_show_result:setPosition(640, 170)
        btn_continue_0:hide()
    end

    --显示桌面按钮
    local btn_show_desktop = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_show_desktop.png", pressed = "ShYMJ/btn_show_desktop.png" })
        :onButtonClicked(function()
            bg_show_result:show()
            bg_result:hide()
        end)
        :pos(640-160, 65)
        :addTo(bg_result)

    util.BtnScaleFun(btn_show_desktop)

    local btn_continue_0 = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_normal.png" })
        :onButtonClicked(function()

            self.callBack:ReadyNextRound()

        end)
        :pos(640+160, 65)
        :addTo(bg_result)

    util.BtnScaleFun(btn_continue_0)

    if curRound == maxRount then
        btn_show_desktop:setPosition(640, 65)
        btn_continue_0:hide()
    end

     bg_show_result:show()
     bg_result:hide()

    --翻出未出的手牌
    print("setResult--",result.infos)
    self:setShowCard(result.infos, result.scores)
    -----------------------

end

function MJResult:setShowCard(infos, scores)

    local leftSeat = 0
    local rightSeat = 0
    local topSeat = 0
    if max_player == 2 then
        if my_seat == 1 then
            topSeat = 2
        else
            topSeat = 1
        end
    elseif max_player == 4 then
        if my_seat == 1 then
            rightSeat = 2
            topSeat = 3
            leftSeat = 4
        elseif my_seat == 2 then
            rightSeat = 3
            topSeat = 4
            leftSeat = 1
        elseif my_seat == 3 then
            rightSeat = 4
            topSeat = 1
            leftSeat = 2
        else
            rightSeat = 1
            topSeat = 2
            leftSeat = 3
        end
    end

    local basePos_leftHead_x = 62
    local basePos_leftHead_y = display.cy+48
    local basePos_rightHead_x = display.width - 70
    local basePos_rightHead_y = display.cy+78
    local basePos_topHead_x = display.width-260
    local basePos_topHead_y = display.height - 70
    local basePos_bottomHead_x = 62
    local basePos_bottomHead_y = 210

    local pos_y_offset = -46
    local pos_x_offset = 0

    --dump(infos,"setShowCard-infoCards = ")
   local dragon = self.callBack:getDragonCard()
   local function sortCard(cards)
        local count = #cards
        if count > 2 then
            for i = 1, count-2 do
                for j = i+1, count-1 do
                    if (cards[i] > cards[j] and cards[i]~=dragon) or (cards[i] < cards[j] and cards[j]==dragon) then
                        local val = cards[i]
                        cards[i] = cards[j]
                        cards[j] = val
                    end
                end
            end
        end
        return cards
   end

    if topSeat ~= 0 then

        local score = scores[topSeat].score
         --总分数
        local scoreF = cc.ui.UILabel.new({
            text = tostring(score),
            size = 40,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_show_result)
        :setAnchorPoint(0.5,0.5)
        :setPosition(basePos_topHead_x + pos_x_offset-200, basePos_topHead_y + pos_y_offset)

        local find = string.find(score, "输")
        if find ~= nil then
            score = string.gsub(score, "输", "-")
            scoreF:setTextColor(cc.c3b(27,207,237))
            scoreF:setString(score)
        end

        find = string.find(score, "赢")
        if find ~= nil then
            score = string.gsub(score, "赢", "+")
            scoreF:setString(score)
        end

        local cards = infos[topSeat].cards
        cards = sortCard(cards)
        local cardsArray = self.callBack:getTopCards()
        local imgName = "ShYMJ/img_spe_paichiSX_top"
        imgName = getUsedSrc(imgName)
        local scaleX = 0.644
        local scaleY = 0.727
        if cardsArray ~= nil then
            local count = #cardsArray
            for pos = 1, count do
                local sprite = cardsArray[pos].sprite
                local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(imgName)
                sprite:setSpriteFrame(frame)
                sprite:setScale(scaleX, scaleY)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cards[count-pos+1]))
                :pos(29, 53.5)
                :setRotation(180)
                :setScale(1.4)
                :addTo(sprite)
                if dragon == cards[count-pos+1] then
                    local icon = "#ShYMJ/img_up_card_hun.png"
                    local majiang = self.callBack:getMajiang()
                    if majiang == "shzhmj" then
                        icon = "#ShYMJ/img_up_card_hun_cai.png"
                    end
                    display.newSprite(icon)
                    :pos(41, 38)
                    :addTo(sprite)
                    sprite:setColor(cc.c3b(235, 206, 134))
                    sprite:setCascadeColorEnabled(false)
                end
            end
        end
    end
    if leftSeat ~= 0 then

        local score = scores[leftSeat].score
         --总分数
        local scoreF = cc.ui.UILabel.new({
            text = tostring(score),
            size = 40,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_show_result)
        :setAnchorPoint(0.5,0.5)
        :setPosition(basePos_leftHead_x + pos_x_offset+200,basePos_leftHead_y + pos_y_offset)

        local find = string.find(score, "输")
        if find ~= nil then
            score = string.gsub(score, "输", "-")
            scoreF:setTextColor(cc.c3b(27,207,237))
            scoreF:setString(score)
        end

        find = string.find(score, "赢")
        if find ~= nil then
            score = string.gsub(score, "赢", "+")
            scoreF:setString(score)
        end

        local cards = infos[leftSeat].cards
        cards = sortCard(cards)
        local cardsArray = self.callBack:getLeftCards()
        local imgName = "ShYMJ/img_left_paichiZY"
        imgName = getUsedSrc(imgName)
        if cardsArray ~= nil then
            local count = #cardsArray
            for pos = 1, count do
                local sprite = cardsArray[pos].sprite
                local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(imgName)
                sprite:setSpriteFrame(frame)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY%d.png", cards[pos]))
                :pos(26, 28)
                :setRotation(180)
                :addTo(sprite)
                if dragon == cards[pos] then
                    local icon = "#ShYMJ/img_left_card_spe_hun.png"
                    local majiang = self.callBack:getMajiang()
                    if majiang == "shzhmj" then
                        icon = "#ShYMJ/img_left_card_spe_hun_cai.png"
                    end
                    display.newSprite(icon)
                    :pos(26, 21)
                    :addTo(sprite)
                    sprite:setColor(cc.c3b(235, 206, 134))
                    sprite:setCascadeColorEnabled(false)
                end
            end
        end
    end

    if rightSeat ~= 0 then

        local score = scores[rightSeat].score
         --总分数
        local scoreF = cc.ui.UILabel.new({
            text = tostring(score),
            size = 40,
            color = cc.c3b(221,150,68)
            })
        :addTo(bg_show_result)
        :setAnchorPoint(0.5,0.5)
        :setPosition(basePos_rightHead_x + pos_x_offset-200,basePos_rightHead_y + pos_y_offset)

        local find = string.find(score, "输")
        if find ~= nil then
            score = string.gsub(score, "输", "-")
            scoreF:setTextColor(cc.c3b(27,207,237))
            scoreF:setString(score)
        end

        find = string.find(score, "赢")
        if find ~= nil then
            score = string.gsub(score, "赢", "+")
            scoreF:setString(score)
        end

        local cards = infos[rightSeat].cards
        cards = sortCard(cards)
        local cardsArray = self.callBack:getRightCards()
        local imgName = "ShYMJ/img_left_paichiZY"
        imgName = getUsedSrc(imgName)
        if cardsArray ~= nil then
            local count = #cardsArray
            for pos = 1, count do
                local sprite = cardsArray[pos].sprite
                local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(imgName)
                sprite:setSpriteFrame(frame)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiZY%d.png", cards[count-pos+1]))
                :pos(26, 28)
                :addTo(sprite)
                if dragon == cards[count-pos+1] then
                    local icon = "#ShYMJ/img_left_card_spe_hun.png"
                    local majiang = self.callBack:getMajiang()
                    if majiang == "shzhmj" then
                        icon = "#ShYMJ/img_left_card_spe_hun_cai.png"
                    end
                    display.newSprite(icon)
                    :pos(24, 36)
                    :setRotation(180)
                    :addTo(sprite)
                    sprite:setColor(cc.c3b(235, 206, 134))
                    sprite:setCascadeColorEnabled(false)
                end
            end
        end
    end

    local score = scores[my_seat].score
     --总分数
    local scoreF = cc.ui.UILabel.new({
        text = tostring(score),
        size = 40,
        color = cc.c3b(221,150,68)
        })
    :addTo(bg_show_result)
    :setAnchorPoint(0.5,0.5)
    :setPosition(basePos_bottomHead_x + pos_x_offset+200,basePos_bottomHead_y + pos_y_offset)

    local find = string.find(score, "输")
    if find ~= nil then
        score = string.gsub(score, "输", "-")
        scoreF:setTextColor(cc.c3b(27,207,237))
        scoreF:setString(score)
    end

    find = string.find(score, "赢")
    if find ~= nil then
        score = string.gsub(score, "赢", "+")
        scoreF:setString(score)
    end

end

function MJResult:setResult(result, watching, majiang, heads, table_code, weixinImage, customization)
    self:clearResult()

    --dump(heads, "heads = ")
    print("majiang = ",majiang)
    self:createResult(result, watching, majiang, heads, table_code, weixinImage, customization)

    if table_code then
        self:hideButton()
    end
end

function MJResult:OnLeaveButton()
    self.callBack:onLeave()
end

function MJResult:OnRestartButton()
    self.callBack:onRestart()
end

function MJResult:clear()
    leftPanel = nil
    leftPanelex = nil
    -- rightPanel = nil
    -- resultPanel = nil
    -- scorePanel = nil

    baseScore = nil
    cardNumber = nil
    suanFenStr = nil
    liang = nil
    pubStr = nil

    dragonCard = nil
    iconDragon = nil
    cardValue = nil

    -- pointNumber1 = nil
    -- pointNumber2 = nil

    pointText1 = nil
    pointText2 = nil

    startButton = nil
    leaveButton = nil

    -- resultScore = nil
    -- resultCards = nil
    -- resultPoints = nil

    -- reusltBlank = nil
    -- laziSprite = nil

    bg_result = nil
    bg_show_result = nil
    max_player = nil
    my_seat = nil

    cardLocation={}
end

function MJResult:restart()
    baseScore:hide()
    cardNumber:hide()
    suanFenStr:hide()
    dragonCard:hide()
    -- pointNumber1:hide()
    -- pointNumber2:hide()
    pointText1:hide()
    pointText2:hide()
    leftPanel:hide()
    leftPanelex:hide()
    -- rightPanel:hide()
    -- resultPanel:hide()
    -- laziSprite:hide()
    self:clearResult()
    cardLocation={20,20,20,20}
end

function MJResult:init(callback)
    self.callBack = callback
    return self
end

return MJResult