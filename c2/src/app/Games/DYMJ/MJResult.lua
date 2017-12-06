local MJResult = class("MJResult",function()
    return display.newSprite()
end)

local crypt = require("crypt")
local util = require("app.Common.util")

local leftPanel
local rightPanel
local resultPanel
local scorePanel

local baseScore
local cardNumber

local dragonCard
local cardValue

local pointNumber1
local pointNumber2

local pointText1
local pointText2

local startButton
local leaveButton

local resultScore
local resultCards
local resultPoints
local laziSprite

local reusltBlank
local iconDragon

local bg_result
local max_player
local my_seat
local score_num

function MJResult:ctor()
	local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/DYResult/zuoshang_dy.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 246, 78))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/DYResult/zuoshang_dy.png")

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

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/DYResult/img_card_result.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 43, 62))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/DYResult/img_card_result.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(36*(j-1), 44.6*(i-1), 36, 44.6))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/LaoZhuang.png")
    for i = 1, 2 do
        for j = 1, 6 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(28*(j-1), 28*(i-1), 28, 28))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/LaoZhuang%d.png", (i-1)*6+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_yuci_fanshu.png")
    for i = 1, 21 do
        frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29.857*(i-1), 250, 29.857))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_yuci_fanshu%d.png", i))
    end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_shengzhou_fanshu.png")
    -- for i = 1, 8 do
    --     frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29*(i-1), 146, 29))
    --     cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_shengzhou_fanshu%d.png", i))
    -- end


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/Hu.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/Hu.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_tuzhang1.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 271, 215))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_cardvalue_tuzhang1.png")
    

    leftPanel = display.newSprite("#ShYMJ/DYResult/zuoshang_dy.png")
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

    resultPanel = display.newSprite("#ShYMJ/result_win_bg.png")
    :pos(display.cx, display.cy + 100)
    :hide()
    :addTo(self)

    scorePanel = display.newSprite()
    :pos(250, 30)
    :addTo(resultPanel)

    startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_selected.png" })
    :onButtonClicked(function()
        self:OnRestartButton()
     end)
    :pos(640 + 150, 50)
    :addTo(resultPanel)

    leaveButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit2_normal.png", pressed = "ShYMJ/button_quit2_selected.png" })
    :onButtonClicked(function()
        self:OnLeaveButton()
     end)
    :pos(640 - 150, 50)
    :addTo(resultPanel)

    resultScore = {{}, {}}
    for index = 1, 2 do
        for row = 1, 4 do
            local hu = display.newSprite("#ShYMJ/Hu.png")
            :pos(0, 197.5-row*45)
            :hide()
            :addTo(scorePanel)

            local banker = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
            :pos(0, 197.5-row*45)
            :hide()
            :addTo(scorePanel)

            local name = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            :pos(30, 200-row*45)
            :addTo(scorePanel)
            name:setAnchorPoint(0, 0.5)

            local flower = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            :pos(280, 200-row*45)
            :addTo(scorePanel)
            flower:setAnchorPoint(0.5, 0.5)

            local bao = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            :pos(398, 200-row*45)
            :addTo(scorePanel)
            bao:setAnchorPoint(0.5, 0.5)

            local longcnt = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            :pos(527, 200-row*45)
            :addTo(scorePanel)
            bao:setAnchorPoint(0.5, 0.5)

            local score = cc.ui.UILabel.new({color=cc.c3b(255,255,255*(index-1)), size=30, text="", align=align})
            :pos(690, 200-row*45)
            :addTo(scorePanel)
            score:setAnchorPoint(0.5, 0.5)
         
            resultScore[index][row] = {name=name, flower=flower, bao=bao, longcnt = longcnt, score=score, hu=hu,banker = banker}
        end
    end

    laziSprite = display.newSprite("#ShYMJ/img_cardvalue_tuzhang1.png")
    :pos(256, 122)
    :hide()
    :addTo(scorePanel)

    local result_top = display.newSprite("ShYMJ/result_top.png")
    :pos(400, 480)
    :addTo(scorePanel)
    
    
    resultCards = display.newSprite()
    :addTo(resultPanel)

    resultPoints = display.newSprite()
    :addTo(resultPanel)

    reusltBlank = display.newSprite("ShYMJ/ResultDrawBg.png")
    :pos(display.cx, display.cy - 20)
    :hide()
    :addTo(resultPanel)

end

function MJResult:setBaseScore(score)
	baseScore:setString(string.format("%d", score))
	baseScore:show()
    score_num = score
    print("base score_num:" .. tostring(score_num))
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
    local majiang = self.callBack:getMajiang()
    local icon = "ShYMJ/img_up_card_hun_cai.png"

    iconDragon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(icon))
	cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", dragon)))
	dragonCard:show()
    -- rightPanel:show()
end

--modify by whb 161103
function MJResult:setOpenCard(dragon)

    local card = dragon
    -- if dragon == 16*1+1 then

    --     card = 16*1+9

    -- elseif dragon == 16*2+1 then

    --     card = 16*2+9

    -- elseif dragon == 16*3+1 then

    --     card = 16*3+9

    -- elseif dragon == 16*4+1 then

    --     card = 16*4+4

    -- end

    print("setOpenCard-dragon:" .. dragon)
    print("setOpenCard:" .. card)

    iconDragon:hide()
    cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
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


function MJResult:hunCards(combin, cards,seat)
    -- resultCards:removeAllChildren()

    local dragon = self.callBack:getDragonCard()
    local xpos = display.cx - (#combin*190+#cards*60+10)/2 + 150
    local ypos = display.height - 72 - seat * 105
    local count = #combin
    for i = 1, count do
        if combin[i].combin == "left" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                :pos(xpos+(j-1)*37, ypos)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card+j-1))
                :pos(22, 37)
                :addTo(sprite)
            end
        elseif combin[i].combin == "center" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                :pos(xpos+(j-1)*37, ypos)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card+j-2))
                :pos(22, 37)
                :addTo(sprite)
            end
        elseif combin[i].combin == "right" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                :pos(xpos+(j-1)*37, ypos)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card+j-3))
                :pos(22, 37)
                :addTo(sprite)
            end
        elseif combin[i].combin == "peng" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                :pos(xpos+(j-1)*37, ypos)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                :pos(22, 37)
                :addTo(sprite)
            end
        elseif combin[i].combin == "gang" then
            if combin[i].out > 0 then
                for j = 1, 3 do
                    local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                    :pos(xpos+(j-1)*37, ypos)
                    :addTo(bg_result)
                    display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                    :pos(22, 37)
                    :addTo(sprite)
                end
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                :pos(xpos+37, ypos + 14)
                :addTo(bg_result)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                :pos(22, 37)
                :addTo(sprite)
            else
                for j = 1, 3 do
                    display.newSprite("#ShYMJ/img_spe_backcard.png")
                    :pos(xpos+(j-1)*37, ypos)
                    :addTo(bg_result)
                end
                local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
                :pos(xpos+37, ypos + 14)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", combin[i].card))
                :pos(22, 37)
                :addTo(sprite)
            end
            
        end
        xpos = xpos + 37*3 + 10
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

    for i = 1, count do
        if i==count and i~=1 then
            xpos = xpos + 10
        end
        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        :pos(xpos, ypos)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cards[i]))
        :pos(22,37)
        :addTo(sprite)
        if dragon == cards[i] then
            --local icon = "#ShYMJ/img_up_card_hun.png"
            --local majiang = self.callBack:getMajiang()
            --if majiang == "shzhmj" then
            local icon = "#ShYMJ/img_up_card_hun_cai.png"
            --end
            display.newSprite(icon)
            :setRotation(180)
            :pos(17, 50)
            :addTo(sprite)
        end
        xpos = xpos + 37
    end
end

function MJResult:hunPoints(points,seat)
    dump(points)
    local hu_zh = {
        gangkai = "杠开",
        zimo = "自摸",
        caidiao = "财吊",
        piaocai = "飘财",
        pengpenghu = "碰碰胡",
        sevendouble = "七对",
        qingyise = "清一色",
        buda13 = "十三不搭",
        standbuda13 = "标准十三不搭",
        _7ziquan = "七字全",
        tianhu = "天胡",
        dihu = "地胡",
        luanfeng = "乱风",
        qingfeng = "清风",
        qiangganghu = "抢杠胡",
        start4caishen = "起手四财神",
        _4caishen = "四财神",
    }
    local ypos = display.height - 120 - seat * 105
    local xpos = 400
    for i = 1,#points do
        local hu = cc.ui.UILabel.new({
            text = tostring(hu_zh[points[i].hun]) .. tostring(points[i].point) .. "番", 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(xpos,ypos)

        local width = hu:getContentSize().width
        xpos = xpos + width + 30
    end
end

function MJResult:hunScore(scores)
    local count = #scores
    dump(scores)
    for i = 1, count do
        local name = crypt.base64decode(scores[i].name)
        name = util.checkNickName(name)
        if scores[i].hu > 0 then
            resultScore[1][i].name:setString(name)
            if scores[i].banker_cnt > 0 then
                resultScore[1][i].flower:setString(scores[i].banker_cnt)
                resultScore[1][i].banker:show()
                local posy = resultScore[1][i].banker:getPositionY()
                resultScore[1][i].banker:setPosition(cc.p(- 40,posy))
            else
                resultScore[1][i].flower:setString("")
                resultScore[1][i].banker:hide()
            end
            if scores[i].banker_long_cnt > 0 then
                resultScore[1][i].bao:setString(scores[i].banker_long_cnt)
            else
                resultScore[1][i].bao:setString("")
            end
            resultScore[1][i].longcnt:setString(scores[i].total_dragon_cnt)
            resultScore[1][i].score:setString(scores[i].score)
            resultScore[1][i].hu:show()
        else
            resultScore[2][i].name:setString(name)
            if scores[i].banker_cnt > 0 then
                resultScore[2][i].flower:setString(scores[i].banker_cnt)
                resultScore[2][i].banker:show()
                local posy = resultScore[1][i].banker:getPositionY()
                resultScore[2][i].banker:setPosition(cc.p(0,posy))
            else
                resultScore[2][i].flower:setString("")
                resultScore[2][i].banker:hide()
            end
            if scores[i].banker_long_cnt > 0 then
                resultScore[2][i].bao:setString(scores[i].banker_long_cnt)
            else
                resultScore[2][i].bao:setString("")
            end
            resultScore[2][i].longcnt:setString(scores[i].total_dragon_cnt)
            resultScore[2][i].score:setString(scores[i].score)
            resultScore[2][i].hu:hide()
        end
    end
end

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

function MJResult:setMaxPlayer(max,seat)
    max_player = max
    my_seat = seat
end

--创建结算面板
function MJResult:createResult(result, watching,heads)
    bg_result = display.newSprite("ShYMJ/DYResult/BG.png")
    :pos(display.cx,display.cy)
    :addTo(self)
    display.newSprite("ShYMJ/DYResult/zhuzi.png")
    :pos(100,display.height - 213)
    :addTo(bg_result)

    local top_str
    if result.mode == 0 then
        top_str = "ShYMJ/DYResult/huangzhuang.png"
    else
        top_str = "ShYMJ/result_top.png"
    end
    display.newSprite(top_str)
    :pos(display.cx + 20,display.height - 80)
    :addTo(bg_result)

    --低分
    cc.ui.UILabel.new({
        text = "底分：每番" .. tostring(score_num) .. "两", 
        size = 24, 
        color = cc.c3b(255,255,255)
        })
    :addTo(bg_result)
    :setAnchorPoint(0.5,0.5)
    :setPosition(220,120)

    if not watching then
        local startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_selected.png" })
        :onButtonClicked(function()
            self:OnRestartButton()
         end)
        :pos(display.cx + 150, 80)
        :addTo(bg_result)
    end

    local leaveButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit2_normal.png", pressed = "ShYMJ/button_quit2_selected.png" })
    :onButtonClicked(function()
        self:OnLeaveButton()
     end)
    :pos(display.cx - 150, 80)
    :addTo(bg_result)

    local winner = 0
    --玩家信息
    for i = 1,max_player do
        --赢家
        if result.scores[i].hu > 0 then
            display.newSprite("ShYMJ/DYResult/win_bg.png")
            :pos(display.cx,display.height - 80 - i * 105 - 5)
            :addTo(bg_result)
            winner = i
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

        --庄家
        if result.scores[i].isBanker then
            display.newSprite("ShYMJ/img_GameUI_zhuang.png")
            :pos(250 - 25,display.height - 80 - i * 105 + 25)
            :addTo(bg_result)
        end

        --本方
        if i == my_seat then
            display.newSprite("ShYMJ/DYResult/benfang.png")
            :pos(250 - 100,display.height - 80 - i * 105)
            :addTo(bg_result)
        end

        --麻将
        self:hunCards(result.cardsInfo[i].combins,result.cardsInfo[i].cards,i)

        --总计
        display.newSprite("ShYMJ/DYResult/gold_icon.png")
        :pos(display.width - 300,display.height - 80 - i * 105)
        :addTo(bg_result)

        local score = cc.ui.UILabel.new({
            text = result.scores[i].score, 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 280,display.height - 80 - i * 105)

        --自摸
        local str
        if result.scores[i].bao == 1 then
            str = "ShYMJ/DYResult/zimo.png"
        elseif result.scores[i].bao == 2 then
            str = "ShYMJ/DYResult/chengbao.png"
        end
        if str then
            display.newSprite(str)
            :pos(display.width - 100,display.height - 80 - i * 105)
            :addTo(bg_result)
        end
    end

    --胡型
    if winner > 0 then
        self:hunPoints(result.points,winner)
    end
end

function MJResult:setResult(result, watching,heads)
    self:clearResult()

    --构造一个临时数据
    -- result = {
    --     mode = 1,
    --     hun = 1,
    --     chao = 0,
    --     scores = {
    --         [1] = {
    --             name = "1111111111",
    --             flower = 0,
    --             bao = 1,
    --             score = 30000,
    --             hu = 1,
    --             isBanker = true,
    --             total_dragon_cnt = 3,
    --         },
    --         [2] = {
    --             name = "222222",
    --             flower = 0,
    --             bao = 1,
    --             score = 30000,
    --             hu = 0,
    --             isBanker = true,
    --             total_dragon_cnt = 3,
    --         },
    --         [3] = {
    --             name = "333333333",
    --             flower = 0,
    --             bao = 2,
    --             score = 30000,
    --             hu = 1,
    --             isBanker = true,
    --             total_dragon_cnt = 3,
    --         },
    --         [4] = {
    --             name = "444444444",
    --             flower = 0,
    --             bao = 0,
    --             score = 30000,
    --             hu = 0,
    --             isBanker = true,
    --             total_dragon_cnt = 3,
    --         },
    --     },
    --     points = {
    --         [1] = {
    --             hun = "pengpenghu",
    --             point = 2,
    --         },
    --         [2] = {
    --             hun = "standbuda13",
    --             point = 3,
    --         },
    --         [3] = {
    --             hun = "luanfeng",
    --             point = 2,
    --         },
    --         [4] = {
    --             hun = "sevendouble",
    --             point = 3,
    --         },
    --     },
    --     cardsInfo = {
    --         [1] = {
    --             cards = {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,},
    --             combins = {
    --                 [1] = {
    --                     combin = "left",
    --                     card = 0x26,
    --                     out = 1,
    --                     card_type = 0,
    --                 }
    --             }
    --         },
    --         [2] = {
    --             cards = {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,},
    --             combins = {
    --                 [1] = {
    --                     combin = "left",
    --                     card = 0x26,
    --                     out = 1,
    --                     card_type = 0,
    --                 }
    --             }
    --         },
    --         [3] = {
    --             cards = {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,},
    --             combins = {
    --                 [1] = {
    --                     combin = "left",
    --                     card = 0x26,
    --                     out = 1,
    --                     card_type = 0,
    --                 }
    --             }
    --         },
    --         [4] = {
    --             cards = {0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,},
    --             combins = {
    --                 [1] = {
    --                     combin = "left",
    --                     card = 0x26,
    --                     out = 1,
    --                     card_type = 0,
    --                 }
    --             }
    --         },
    --     }
    -- }

    -- heads = {
    --     [1] = "Image/Common/Avatar/male_5.png",
    --     [2] = "Image/Common/Avatar/male_5.png",
    --     [3] = "Image/Common/Avatar/male_5.png",
    --     [4] = "Image/Common/Avatar/male_5.png",
    -- }

    self:createResult(result, watching, heads)
    -- if majiang == "shzhmj" then
    -- resultPanel:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/result_win_bg.png"))
    -- -- else
    -- --     scorePanel:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ResultSmallBg.png"))
    -- -- end

    -- if result.mode > 0 then
    --     local hun = 0
    --     local count = #result.scores
    --     for i = 1, count do
    --         if result.scores[i].hu > 0 then
    --             hun = i
    --         end
    --     end
    --     count = #result.combins
    --     for i = 1, count do
    --         if result.combins[i].out == hun then
    --             result.combins[i].out = 0
    --         end
    --     end
    --     reusltBlank:hide()
    --     self:hunCards(result.combins, result.cards)
    --     self:hunPoints(result.points, majiang)
    --     self:hunScore(result.scores)
    --     if result.chao > 0 then
    --         laziSprite:show()
    --     end
    -- else
    --     reusltBlank:show()
    -- end

    -- if watching then
    --     leaveButton:pos(640, -80)
    --     startButton:hide()
    -- else
    --     startButton:pos(640 + 150, -80)
    --     leaveButton:pos(640 - 150, -80)
    --     startButton:show()
    -- end

    -- resultPanel:show()
end

function MJResult:OnLeaveButton()
    self.callBack:onLeave()
end

function MJResult:OnRestartButton()
    self.callBack:onRestart()
end

function MJResult:clear()
    leftPanel = nil
    rightPanel = nil
    resultPanel = nil
    scorePanel = nil

    baseScore = nil
    score = nil
    cardNumber = nil

    dragonCard = nil
    iconDragon = nil
    cardValue = nil

    pointNumber1 = nil
    pointNumber2 = nil

    pointText1 = nil
    pointText2 = nil

    startButton = nil
    leaveButton = nil

    resultScore = nil
    resultCards = nil
    resultPoints = nil

    reusltBlank = nil
    laziSprite = nil

    bg_result = nil
    max_player = nil
    my_seat = nil
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
    resultPanel:hide()
    laziSprite:hide()  

    self:clearResult()

end

function MJResult:init(callback)
    self.callBack = callback
    return self
end

return MJResult