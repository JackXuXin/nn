local MJResult = class("MJResult",function()
    return display.newSprite()
end)

local crypt = require("crypt")
local util = require("app.Common.util")

local leftPanel
-- local rightPanel
-- local resultPanel
-- local scorePanel

local baseScore
local cardNumber

local dragonCard
local cardValue

-- local pointNumber1
-- local pointNumber2

-- local pointText1
-- local pointText2

local startButton
local leaveButton

-- local resultScore
-- local resultCards
-- local resultPoints
-- local laziSprite

-- local reusltBlank
local iconDragon
--结算牌的位置
local cardLocation
local bg_result
local max_player
local my_seat
local score_num
local banker_seat
local islian    --连庄

function MJResult:ctor()
	local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/zuoshang_yuci.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 246, 78))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/zuoshang_yuci.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/youshang_er.png")
    --modify by whb 161103
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 196, 75))
    --modify end
    --frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 151, 108))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/youshang_er.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 37, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun_cai.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 4 do
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

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/LaoZhuang.png")
    -- for i = 1, 2 do
    --     for j = 1, 6 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(28*(j-1), 28*(i-1), 28, 28))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/LaoZhuang%d.png", (i-1)*6+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_yuci_fanshu.png")
    -- for i = 1, 21 do
    --     frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29.857*(i-1), 250, 29.857))
    --     cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_yuci_fanshu%d.png", i))
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_shengzhou_fanshu.png")
    -- for i = 1, 8 do
    --     frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29*(i-1), 146, 29))
    --     cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_shengzhou_fanshu%d.png", i))
    -- end


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/Hu.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/Hu.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_tuzhang1.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 271, 215))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_cardvalue_tuzhang1.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/DYResult/img_card_result.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 43, 62))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/DYResult/img_card_result.png")
    

    leftPanel = display.newSprite("#ShYMJ/zuoshang_yuci.png")
    :pos(display.cx - 150, display.cy + 35)
    :hide()
    :addTo(self)

    baseScore = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="100", align=align})
    :pos(195, 52)
    :hide()
    :addTo(leftPanel)
    baseScore:setAnchorPoint(0.5, 0.5)


    cardNumber = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="98", align=align})
    :pos(195, 30)
    :hide()
    :addTo(leftPanel)
    cardNumber:setAnchorPoint(0.5, 0.5)

    --img_spe_paichiSX
    dragonCard = display.newSprite("#ShYMJ/img_spe_card.png")
    :setScale(0.65)
    :setAnchorPoint(0.5, 1)
    :pos(61, 77)
    :hide()
    :addTo(leftPanel)
    cardValue=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", 16*4+8))
    :pos(31, 53)
    :addTo(dragonCard)
    iconDragon = display.newSprite("#ShYMJ/img_up_card_hun.png")
    :setRotation(180)
    :pos(18, 75)
    :addTo(dragonCard)

    -- rightPanel = display.newSprite()
    -- --modify by whb 161103

    -- :pos(display.left + 276, display.top + 1)
    -- --modify end
    -- --:pos(display.left + 260, display.top-40)
    -- :hide()
    -- :addTo(self)

    -- display.newSprite("#ShYMJ/youshang_er.png")
    -- :setAnchorPoint(0.5, 1)
    -- --:setScale(0.8)
    -- :addTo(rightPanel)

    -- dragonCard = display.newSprite("#ShYMJ/img_spe_card.png")
    -- :setScale(0.59)
    -- :setAnchorPoint(0.5, 1)
    -- :pos(-34, -4)
    -- :hide()
    -- :addTo(rightPanel)
    -- cardValue=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", 16*4+8))
    -- :pos(31, 53)
    -- :addTo(dragonCard)
    -- iconDragon = display.newSprite("#ShYMJ/img_up_card_hun.png")
    -- :setRotation(180)
    -- :pos(18, 75)
    -- :addTo(dragonCard)

    -- pointNumber1 = display.newSprite("#ShYMJ/LaoZhuang7.png")
    -- :pos(65, 14-35)
    -- :hide()
    -- :addTo(rightPanel)

    -- pointText1 = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="翻", align=align})
    -- :pos(65, 14-35)
    -- :hide()
    -- :addTo(rightPanel)
    -- pointText1:setAnchorPoint(0.5, 0.5)


    -- pointNumber2 = display.newSprite("#ShYMJ/LaoZhuang1.png")
    -- :pos(65, -20-35)
    -- :hide()
    -- :addTo(rightPanel)
    -- pointText2 = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="牌", align=align})
    -- :pos(65, -20-35)
    -- :hide()
    -- :addTo(rightPanel)
    -- pointText2:setAnchorPoint(0.5, 0.5)


    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_lose_bg.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 1278, 610))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/result_lose_bg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_win_bg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 1278, 610))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/result_win_bg.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultSmallBg_yuci.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 912, 244))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultSmallBg_yuci.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultSmallBg_shengzhou.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 912, 244))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultSmallBg_shengzhou.png")

    -- resultPanel = display.newSprite("#ShYMJ/result_win_bg.png")
    -- :pos(display.cx, display.cy + 100)
    -- :hide()
    -- :addTo(self)

    -- scorePanel = display.newSprite()
    -- :pos(250, 30)
    -- :addTo(resultPanel)

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

    --         local banker = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
    --         :pos(0, 197.5-row*45)
    --         :hide()
    --         :addTo(scorePanel)

    --         local name = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
    --         :pos(30, 200-row*45)
    --         :addTo(scorePanel)
    --         name:setAnchorPoint(0, 0.5)

    --         local flower = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
    --         :pos(280, 200-row*45)
    --         :addTo(scorePanel)
    --         flower:setAnchorPoint(0.5, 0.5)

    --         local bao = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
    --         :pos(398, 200-row*45)
    --         :addTo(scorePanel)
    --         bao:setAnchorPoint(0.5, 0.5)

    --         local longcnt = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
    --         :pos(527, 200-row*45)
    --         :addTo(scorePanel)
    --         bao:setAnchorPoint(0.5, 0.5)

    --         local score = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
    --         :pos(690, 200-row*45)
    --         :addTo(scorePanel)
    --         score:setAnchorPoint(0.5, 0.5)
         
    --         resultScore[index][row] = {name=name, flower=flower, bao=bao, longcnt = longcnt, score=score, hu=hu,banker = banker}
    --     end
    -- end

    -- laziSprite = display.newSprite("#ShYMJ/img_cardvalue_tuzhang1.png")
    -- :pos(256, 122)
    -- :hide()
    -- :addTo(scorePanel)

    -- local result_top = display.newSprite("ShYMJ/result_top.png")
    -- :pos(400, 480)
    -- :addTo(scorePanel)
    
    
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

function MJResult:setBaseScore(score)
	baseScore:setString(string.format("%d", score))
	baseScore:show()
    score_num = score
    
    --leftPanel:show()
end
function MJResult:setBanker(banker,lian)
    
    banker_seat =banker
    islian = lian
    --leftPanel:show()
end
function MJResult:setCardNumber(number)
	cardNumber:setString(string.format("%d", number))
	cardNumber:show()
    --leftPanel:show()
end

function MJResult:showInfo()
    leftPanel:show()
end

function MJResult:setDragon(dragon)
    -- local icon = "ShYMJ/img_up_card_hun.png"
    local majiang = self.callBack:getMajiang()
    -- if majiang == "shzhmj" then
    local icon = "ShYMJ/img_up_card_hun_cai.png"
    -- end
    iconDragon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(icon))
	cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", dragon)))
	dragonCard:show()
    -- rightPanel:show()
end

--modify by whb 161103
function MJResult:setOpenCard(mark)

    -- local card = dragon-1
    -- if dragon == 16*1+1 then

    --     card = 16*1+9

    -- elseif dragon == 16*2+1 then

    --     card = 16*2+9

    -- elseif dragon == 16*3+1 then

    --     card = 16*3+9

    -- elseif dragon == 16*4+1 then

    --     card = 16*4+7

    -- end

    print("setOpenCard-mark:" .. mark)
    

    iconDragon:hide()
    cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", mark)))
    dragonCard:show()
    -- rightPanel:show()
end
--modify end

function MJResult:setPoints(point1, point2)
	-- if point1 > 0 and point1 < 7 then
 --        pointText1:hide()
	-- 	pointNumber1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", 6+point1)))
	-- 	pointNumber1:show()
 --    else
 --        pointNumber1:hide()
 --        pointText1:show()
	-- end

	-- if point2 > 0 and point2 < 7 then
 --        pointText2:hide()
	-- 	pointNumber2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", point2)))
	-- 	pointNumber2:show()
 --    else
 --        pointNumber2:hide()
 --        pointText2:show()
	-- end
 --    rightPanel:show()
end
--传的5个参数 碰杠、手牌、座位号、是否没胡或胡或自摸 0 1 2
function MJResult:hunCards(combin, cards,index,mode,hu_card)
    -- resultCards:removeAllChildren()

    local dragon = self.callBack:getDragonCard()
    -- local xpos = display.cx - (#combin*190+#cards*60+10)/2 + 30
    -- local ypos = display.height - 72 - index * 105 + 14
    local count = #combin
    for i = 1, count do
        if combin[i].mode == "left" then
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
        elseif combin[i].mode == "center" then
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
        elseif combin[i].mode == "right" then
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
        elseif combin[i].mode == "peng" then
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
        elseif combin[i].mode == "ming_gang" then
            print("ming_gang" ..index)
            print("ming_gang" ..combin[i].card)
            
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
        elseif combin[i].mode == "bu_gang" then
            print("gang" ..index)
            print("gang" ..combin[i].card)
            
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
        elseif combin[i].mode == "an_gang" then
            for j = 1, 3 do
                display.newSprite("#ShYMJ/img_spe_backcard.png")
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
        -- xpos = xpos + 60*3 + 10
    end

    count = #cards
    if count > 2 then
        for i = 1, count-1 do
            for j = i+1, count do
                if (cards[i] > cards[j] and cards[i]~=dragon) or (cards[i] < cards[j] and cards[j]==dragon) then
                    local val = cards[i]
                    cards[i] = cards[j]
                    cards[j] = val
                end
            end
        end
    end
    local sum = count
    -- local hu_index = 0
    --是否胡
    -- if mode>0 then
    --     sum=count-1
    -- else
    --     sum=count
    -- end
    for i = 1, sum do
        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        -- :setScale(0.6)
        :pos(cardLocation[index]+(i-1)*36,display.height - 72 - index * 105)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cards[i]))
        -- :setScale(1.3)
        :pos(22, 37)
        :addTo(sprite)
        if dragon == cards[i] then
            --local icon = "#ShYMJ/img_up_card_hun.png"
            --local majiang = self.callBack:getMajiang()
            --if majiang == "shzhmj" then
            local icon = "#ShYMJ/img_up_card_hun_cai.png"
            --end
            display.newSprite(icon)
            :setRotation(180)
            :pos(17, 49)
            :addTo(sprite)
        end
        
    end
    cardLocation[index]=cardLocation[index]+sum*37+20
    --判断是否胡
    if hu_card > 0 and mode ==1 then
        
        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        -- :setScale(0.6)
        :pos(cardLocation[index],display.height - 72 - index * 105)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", hu_card))
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
        end
    end
end

function MJResult:hunPoints(points,index)
    -- resultPoints:removeAllChildren()
    local count = #points
    local str = ""
    for i = 1, count do
        if points[i].style == "CI_XI_TYPE.CX_13_YAO" then
            str = str .." 十三幺 "
        elseif points[i].style == "CI_XI_TYPE.CX_4_LONG_QI" then
            str = str .." 四龙齐 "
        elseif points[i].style == "CI_XI_TYPE.CX_10_LIAN_FENG" then
            str = str .." 连打十风 "
        elseif points[i].style == "CI_XI_TYPE.CX_QUAN_FENG" then
            str = str .." 全风向 "
        elseif points[i].style == "CI_XI_TYPE.CX_YOU_LONG_7_DUI" then
            str = str .." 有龙七小对 "
        elseif points[i].style == "CI_XI_TYPE.CX_WU_LONG_7_DUI" then
            str = str .." 无龙七小对 "
        elseif points[i].style == "CI_XI_TYPE.CX_DUI_DUI_HU" then
            str = str .." 对对胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_HUN_YI_SE" then
            str = str .." 混一色 "
        elseif points[i].style == "CI_XI_TYPE.CX_YOU_LONG_QING_YI_SE" then
            str = str .." 有龙清一色 "
        elseif points[i].style == "CI_XI_TYPE.CX_WU_LONG_QING_YI_SE" then
            str = str .." 无龙清一色 "
        elseif points[i].style == "CI_XI_TYPE.CX_7_FENG_13_YAO" then
            str = str .." 七风齐十三幺 "
        elseif points[i].style == "CI_XI_TYPE.CX_DU_DIAO" then
            str = str .." 独钓 "
        elseif points[i].style == "CI_XI_TYPE.CX_TIAN_HU" then
            str = str .." 天胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_DI_HU" then
            str = str .." 地胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_GANG_KAI" then
            str = str .." 杠上开花 "
        elseif points[i].style == "CI_XI_TYPE.CX_PAO_LONG" then
            str = str .." 抛花 "
        elseif points[i].style == "CI_XI_TYPE.CX_ZI_MO" then
            str = str .." 自摸 "
        elseif points[i].style == "CI_XI_TYPE.CX_JIE_PAO" then
            str = str .." 打胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_BAI_DA" then
            str = str .." 百搭 "
        elseif points[i].style == "CI_XI_TYPE.CX_HU_PAI" then
            str = str .." 胡牌 "
        elseif points[i].style == "CI_XI_TYPE.CX_WU_LONG" then
            str = str .." 无龙 "
        elseif points[i].style == "CI_XI_TYPE.CX_BAO_3_JIA_SESSION_1" then
            str = str .." 单吊抛花打胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_BAO_3_JIA_SESSION_2" then
            str = str .." 杠牌后打胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_BAO_3_JIA_SESSION_3" then
            str = str .." 抢杠胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_BAO_3_JIA_SESSION_4" then
            str = str .." 同圈单吊牌打胡 "
        elseif points[i].style == "CI_XI_TYPE.CX_BAO_3_JIA_SESSION_5" then
            str = str .." 关风向 "
        end
        if points[i].fans~=0 then
            str = str ..tostring(points[i].fans) .."龙 "
        end
        
    end
        if str ~= nil then
            cc.ui.UILabel.new({
            text = str, 
            size = 18, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(340,display.height - 120 - index * 105)
        end
end

-- function MJResult:hunScore(scores)
--     local count = #scores
--     dump(scores)
--     for i = 1, count do
--         local name = crypt.base64decode(scores[i].name)
--         name = util.checkNickName(name)
--         if scores[i].hu > 0 then
--             resultScore[1][i].name:setString(name)
--             if scores[i].banker_cnt > 0 then
--                 resultScore[1][i].flower:setString(scores[i].banker_cnt)
--                 resultScore[1][i].banker:show()
--                 local posy = resultScore[1][i].banker:getPositionY()
--                 resultScore[1][i].banker:setPosition(cc.p(- 40,posy))
--             else
--                 resultScore[1][i].flower:setString("")
--                 resultScore[1][i].banker:hide()
--             end
--             if scores[i].banker_long_cnt > 0 then
--                 resultScore[1][i].bao:setString(scores[i].banker_long_cnt)
--             else
--                 resultScore[1][i].bao:setString("")
--             end
--             resultScore[1][i].longcnt:setString(scores[i].total_dragon_cnt)
--             resultScore[1][i].score:setString(scores[i].score)
--             resultScore[1][i].hu:show()
--         else
--             resultScore[2][i].name:setString(name)
--             if scores[i].banker_cnt > 0 then
--                 resultScore[2][i].flower:setString(scores[i].banker_cnt)
--                 resultScore[2][i].banker:show()
--                 local posy = resultScore[1][i].banker:getPositionY()
--                 resultScore[2][i].banker:setPosition(cc.p(0,posy))
--             else
--                 resultScore[2][i].flower:setString("")
--                 resultScore[2][i].banker:hide()
--             end
--             if scores[i].banker_long_cnt > 0 then
--                 resultScore[2][i].bao:setString(scores[i].banker_long_cnt)
--             else
--                 resultScore[2][i].bao:setString("")
--             end
--             resultScore[2][i].longcnt:setString(scores[i].total_dragon_cnt)
--             resultScore[2][i].score:setString(scores[i].score)
--             resultScore[2][i].hu:hide()
--         end
--     end
-- end

function MJResult:clearResult()
    -- resultPoints:removeAllChildren()
    -- resultCards:removeAllChildren()
    -- for i = 1, 2 do
    --     for j = 1, 4 do
    --         resultScore[i][j].name:setString("")
    --         resultScore[i][j].flower:setString("")
    --         resultScore[i][j].bao:setString("")
    --         resultScore[i][j].score:setString("")
    --         resultScore[i][j].longcnt:setString("")
    --         resultScore[i][j].hu:hide()
    --         resultScore[i][j].banker:hide()
    --     end
    -- end
    -- laziSprite:hide()
    if bg_result then
        bg_result:removeFromParent()
        bg_result = nil
    end
end

function MJResult:hideButton()
    startButton:hide()
    leaveButton:hide()
end

--创建结算面板
function MJResult:createResult(result, watching,heads)
    --牌的相对位置
    cardLocation={350,350,350,350}
    bg_result = display.newSprite("ShYMJ/DYResult/BG.png")
    :pos(display.cx,display.cy)
    :addTo(self)
    -- display.newSprite("ShYMJ/DYResult/zhuzi.png")
    -- :pos(100,display.height - 213)
    -- :addTo(bg_result)

    
    --是否慌庄
    local top_str
    if result.huang == 1 then
        top_str = "ShYMJ/DYResult/huangzhuang.png"
    else
        top_str = "ShYMJ/result_top.png"
    end
    display.newSprite(top_str)
    :pos(display.cx + 20,display.height - 80)
    :addTo(bg_result)

    --低分
    -- score_num=100
    local lianzhuang=0
    local dilong=0
    for i=1,#result.infos do
        if result.infos[i].banker_cnt>0 then
            lianzhuang=result.infos[i].banker_cnt
        end
        if result.infos[i].banker_long_cnt>0 then
            dilong=result.infos[i].banker_long_cnt
        end
    end
    cc.ui.UILabel.new({
        text = "底分：每龙" .. tostring(score_num) .. "两 " ..tostring(lianzhuang) .."连庄 "  .."底龙" ..tostring(dilong) .."龙", 
        -- text = "底分：每花" .. score_num .. "两", 
        size = 22, 
        color = cc.c3b(255,255,255)
        })
    :addTo(bg_result)
    :setAnchorPoint(0.5,0.5)
    :setPosition(220,130)

    if not watching then
        startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_selected.png" })
        :onButtonClicked(function()
            self:OnRestartButton()
         end)
        :pos(display.cx + 150, 80)
        :addTo(bg_result)
    end

    leaveButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit2_normal.png", pressed = "ShYMJ/button_quit2_selected.png" })
    :onButtonClicked(function()
        self:OnLeaveButton()
     end)
    :pos(display.cx - 150, 80)
    :addTo(bg_result)

    
    --玩家信息
    
   

    local scoreLong = cc.ui.UILabel.new({
            text = "总龙数", 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 295,display.height - 120)
    local scoreFen = cc.ui.UILabel.new({
            text = "总分数", 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 180,display.height - 120)

    
    local winner
    for i = 1,#result.infos do
        --赢家
        if  result.infos[i].card > 0 then
            display.newSprite("ShYMJ/DYResult/win_bg.png")
            :pos(display.cx,display.height - 80 - i * 105 - 5)
            :addTo(bg_result)
            winner=i
            
        end

        display.newSprite("ShYMJ/DYResult/head_bg.png")
        :pos(250,display.height - 80 - i * 105)
        :addTo(bg_result)
        --头像
        display.newSprite(heads[i])
        :pos(250,display.height - 80 - i * 105)
        :addTo(bg_result)
        :scale(0.4)
        --名字
        
            
        local name = crypt.base64decode(result.infos[i].name)
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
        if i == my_seat then
            display.newSprite("ShYMJ/DYResult/benfang.png")
            :pos(250 - 100,display.height - 80 - i * 105)
            :addTo(bg_result)
        end
        --总龙数
        local scoreL = cc.ui.UILabel.new({
            text = tostring(result.infos[i].total_dragon_cnt), 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 280,display.height - 80 - i * 105)

        --总分数
        local scoreF = cc.ui.UILabel.new({
            text = tostring(result.infos[i].score), 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 180,display.height - 80 - i * 105)

        --麻将
        print("显示牌2")
        local combin = result.infos[i].combins
        local cards = result.infos[i].cards
        local mode = 0  --没胡
        if result.infos[i].card then
            if result.infos[i].from == result.infos[i].seat then
                --todo
                mode = 2    --自摸
            else
                mode = 1    --胡
            end
        end
        --胡的那张牌
        local hu_card = result.infos[i].card
        --传的5个参数 碰杠、手牌、座位号、是否没胡或胡或自摸 0 1 2 、胡的那张牌
        self:hunCards(combin, cards,i,mode,hu_card)


         print("显示胡牌类型")
        --胡牌类型
        self:hunPoints(result.infos[i].types,i)
    end
    --麻将
    -- print("显示牌1")
    -- for i=1,#result.every_combins do
        
    --     print("显示牌2")
    --     local combin=result.every_combins[i].combins
    --     local cards=result.every_handcards[i].cards

    --     self:hunCards(combin, cards,i,winner,result.mode)
        
    -- end
    -- print("显示胡牌类型")
    --胡牌类型
    -- self:hunPoints(result.points,result.hun)
    --庄家图标
    local bankerSprite=display.newSprite("ShYMJ/img_GameUI_zhuang.png")
    :pos(250 + 37.5,display.height - 80 - banker_seat * 105 + 25)
    :addTo(bg_result)

    if islian and islian>1 then
        print("连庄")
        --todo
        bankerSprite:setTexture("ShYMJ/img_GameUI_lian_zhuang.png")
    else
        print("正常庄")
        bankerSprite:setTexture("ShYMJ/img_GameUI_zhuang.png")
    end

end
function MJResult:setResult(result, watching,heads,table_code)
    self:clearResult()

    self:createResult(result, watching, heads)

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
    -- rightPanel = nil
    -- resultPanel = nil
    -- scorePanel = nil

    baseScore = nil
    cardNumber = nil

    dragonCard = nil
    iconDragon = nil
    cardValue = nil

    -- pointNumber1 = nil
    -- pointNumber2 = nil

    -- pointText1 = nil
    -- pointText2 = nil

    startButton = nil
    leaveButton = nil

    -- resultScore = nil
    -- resultCards = nil
    -- resultPoints = nil

    -- reusltBlank = nil
    -- laziSprite = nil

    bg_result = nil
    max_player = nil
    my_seat = nil

    cardLocation={}
end

function MJResult:restart()
    baseScore:hide()
    cardNumber:hide()
    dragonCard:hide()
    -- pointNumber1:hide()
    -- pointNumber2:hide()
    -- pointText1:hide()
    -- pointText2:hide()
    leftPanel:hide()
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