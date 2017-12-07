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

--当前显示的胡的玩家的下标
local huInfoIndex = 0
--总台数
local allHuCnt
--庄家
local banker

function MJResult:ctor()
	local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/zuoshang_xs.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 196, 70))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/zuoshang_xs.png")

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
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/xs_fengquan.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 73, 73))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/xs_fengquan.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(51*(j-1), 64*(i-1), 51, 64))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/LaoZhuang.png")
    for i = 1, 2 do
        for j = 1, 6 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(28*(j-1), 28*(i-1), 28, 28))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/LaoZhuang%d.png", (i-1)*6+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_xs_fanshu.png")
    for i = 1, 25 do
        frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 29.24*(i-1), 218, 29.24))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/result_xs_fanshu%d.png", i))
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
    

    leftPanel = display.newSprite("#ShYMJ/zuoshang_xs.png")
    :pos(display.left+100, display.top-37)
    :hide()
    :addTo(self)

    baseScore = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="100", align=align})
    :pos(95, 50)
    :hide()
    :addTo(leftPanel)
    baseScore:setAnchorPoint(0.5, 0.5)


    cardNumber = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="98", align=align})
    :pos(95, 23)
    :hide()
    :addTo(leftPanel)
    cardNumber:setAnchorPoint(0.5, 0.5)

    rightPanel = display.newSprite()
    --modify by whb 161103

    :pos(display.left + 240, display.top + 1)
    --modify end
    --:pos(display.left + 260, display.top-40)
    :hide()
    :addTo(self)

    display.newSprite("#ShYMJ/xs_fengquan.png")
    :setAnchorPoint(0.5, 1)
    --:setScale(0.8)
    :addTo(rightPanel)

    dragonCard = display.newSprite("#ShYMJ/img_spe_card.png")
    :setScale(0.59)
    :setAnchorPoint(0.5, 1)
    :pos(15, -10)
    :hide()
    :addTo(rightPanel)
    cardValue=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", 16*4+8))
    :pos(31, 53)
    :addTo(dragonCard)
    iconDragon = display.newSprite("#ShYMJ/img_up_card_hun.png")
    :setRotation(180)
    :pos(18, 75)
    :addTo(dragonCard)

    pointNumber1 = display.newSprite("#ShYMJ/LaoZhuang7.png")
    :pos(65, 14-35)
    :hide()
    :addTo(rightPanel)

    pointText1 = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="翻", align=align})
    :pos(65, 14-35)
    :hide()
    :addTo(rightPanel)
    pointText1:setAnchorPoint(0.5, 0.5)


    pointNumber2 = display.newSprite("#ShYMJ/LaoZhuang1.png")
    :pos(65, -20-35)
    :hide()
    :addTo(rightPanel)
    pointText2 = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=18, text="牌", align=align})
    :pos(65, -20-35)
    :hide()
    :addTo(rightPanel)
    pointText2:setAnchorPoint(0.5, 0.5)


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultBg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 1280, 563))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultBg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultSmallBg_xs.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 912, 244))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultSmallBg_xs.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ResultSmallBg_shengzhou.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 912, 244))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ResultSmallBg_shengzhou.png")

    resultPanel = display.newSprite("#ShYMJ/ResultBg.png")
    :pos(display.cx, display.cy)
    :hide()
    :addTo(self)

    scorePanel = display.newSprite("#ShYMJ/ResultSmallBg_xs.png")
    :pos(640, 220)
    :addTo(resultPanel)

    startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_selected.png" })
    :onButtonClicked(function()
        self:OnRestartButton()
     end)
    :pos(640 - 150, 50)
    :addTo(resultPanel)

    leaveButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_quit2_normal.png", pressed = "ShYMJ/button_quit2_selected.png" })
    :onButtonClicked(function()
        self:OnLeaveButton()
     end)
    :pos(640 + 150, 50)
    :addTo(resultPanel)

    resultScore = {}
    for row = 1, 4 do
        local hu = display.newSprite("#ShYMJ/Hu.png")
        :pos(0, 197.5-row*42)
        :hide()
        :addTo(scorePanel)

        local banker = display.newSprite("#ShYMJ/img_GameUI_zhuang.png")
        :pos(0, 197.5-row*42)
        :hide()
        :addTo(scorePanel)

        local name = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(30, 200-row*42)
        :addTo(scorePanel)
        name:setAnchorPoint(0, 0.5)

        local flower = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(365, 200-row*42)
        :addTo(scorePanel)
        flower:setAnchorPoint(0.5, 0.5)

        local bao = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(328, 200-row*42)
        :addTo(scorePanel)
        bao:setAnchorPoint(0.5, 0.5)

        local longcnt = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(620, 200-row*42)
        :addTo(scorePanel)
        bao:setAnchorPoint(0.5, 0.5)

        local addition = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(460, 200-row*42)
        :addTo(scorePanel)
        addition:setAnchorPoint(0.5, 0.5)

        local all_hu = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(640, 200-row*42)
        :addTo(scorePanel)
        all_hu:setAnchorPoint(0.5, 0.5)

        local score = cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=30, text="", align=align})
        :pos(810, 200-row*42)
        :addTo(scorePanel)
        score:setAnchorPoint(0.5, 0.5)

        local detail = cc.ui.UIPushButton.new({ normal = "ShYMJ/detail_1.png", pressed = "ShYMJ/detail_2.png" })
        :onButtonClicked(function()

            for i = 1,#resultScore do
                local d = resultScore[i].detail
                if row == d.index then
                    print("detail huInfo:" .. tostring(d.huInfo))
                    if d.huInfo then
                        dump(d.huInfo)
                        huInfoIndex = row
                        self:updateHuInfo(d.huInfo)
                        self:updateWinScoreColor()
                    end
                end
            end

         end)
        :pos(930, 200-row*42)
        :hide()
        :addTo(scorePanel)

        detail.index = row
    
        resultScore[row] = {name=name,bao=bao,score=score, hu=hu,banker = banker,detail = detail,all_hu = all_hu,addition = addition}
    end

    allHuCnt = cc.ui.UILabel.new({color=cc.c3b(255,0,0), size=30, text="", align=align})
    :pos(750, 260)
    :addTo(scorePanel)
    allHuCnt:setAnchorPoint(0.5, 0.5)

    laziSprite = display.newSprite("#ShYMJ/img_cardvalue_tuzhang1.png")
    :pos(256, 122)
    :hide()
    :addTo(scorePanel)
    
    
    resultCards = display.newSprite()
    :addTo(resultPanel)

    resultPoints = display.newSprite()
    :addTo(resultPanel)

    reusltBlank = display.newSprite("ShYMJ/ResultDrawBg.png")
    :pos(display.cx, display.cy + 80)
    :hide()
    :addTo(resultPanel)

end

function MJResult:setBaseScore(score)
	baseScore:setString(string.format("%d", score))
	baseScore:show()
    leftPanel:show()
end

function MJResult:setCardNumber(number)
	cardNumber:setString(string.format("%d", number))
	cardNumber:show()
    leftPanel:show()
end

function MJResult:setDragon(dragon)
    -- local icon = "ShYMJ/img_up_card_hun.png"
    local majiang = self.callBack:getMajiang()
    -- if majiang == "shzhmj" then
    local icon = "ShYMJ/img_up_card_hun_cai.png"
    -- end
    --iconDragon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(icon))
	cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", dragon)))
	--dragonCard:show()
    rightPanel:show()
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
    rightPanel:show()
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
    rightPanel:show()
end

function MJResult:hunCards(combin, cards)
    resultCards:removeAllChildren()

    local dragon = self.callBack:getDragonCard()
    local xpos = display.cx - (#combin*190+#cards*60+10)/2 + 30
    local count = #combin
    for i = 1, count do
        if combin[i].combin == "left" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                :pos(xpos+(j-1)*60, display.cy + 135)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card+j-1))
                :pos(31, 53)
                :addTo(sprite)
            end
        elseif combin[i].combin == "center" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                :pos(xpos+(j-1)*60, display.cy + 135)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card+j-2))
                :pos(31, 53)
                :addTo(sprite)
            end
        elseif combin[i].combin == "right" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                :pos(xpos+(j-1)*60, display.cy + 135)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card+j-3))
                :pos(31, 53)
                :addTo(sprite)
            end
        elseif combin[i].combin == "peng" then
            for j = 1, 3 do
                local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                :pos(xpos+(j-1)*60, display.cy + 135)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card))
                :pos(31, 53)
                :addTo(sprite)
            end
        elseif combin[i].combin == "gang" then
            if combin[i].out > 0 then
                for j = 1, 3 do
                    local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                    :pos(xpos+(j-1)*60, display.cy + 135)
                    :addTo(resultCards)
                    display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card))
                    :pos(31, 53)
                    :addTo(sprite)
                end
                local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                :pos(xpos+60, display.cy + 152)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card))
                :pos(31, 53)
                :addTo(sprite)
            else
                for j = 1, 3 do
                    display.newSprite("#ShYMJ/img_spe_backcard.png")
                    :pos(xpos+(j-1)*60, display.cy + 135)
                    :addTo(resultCards)
                end
                local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
                :pos(xpos+60, display.cy + 160)
                :addTo(resultCards)
                display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", combin[i].card))
                :pos(31, 53)
                :addTo(sprite)
            end
            
        end
        xpos = xpos + 60*3 + 10
    end

    count = #cards
    if count > 2 then
        for i = 1, count-2 do
            for j = i+1, count-1 do
                -- if (cards[i] > cards[j] and cards[i]~=dragon) or (cards[i] < cards[j] and cards[j]==dragon) then
                if cards[i] > cards[j] then
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
        local sprite = display.newSprite("#ShYMJ/img_spe_card.png")
        :pos(xpos, display.cy + 135)
        :addTo(resultCards)
        display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", cards[i]))
        :pos(31, 53)
        :addTo(sprite)
        -- if dragon == cards[i] then
        --     --local icon = "#ShYMJ/img_up_card_hun.png"
        --     --local majiang = self.callBack:getMajiang()
        --     --if majiang == "shzhmj" then
        --     local icon = "#ShYMJ/img_up_card_hun_cai.png"
        --     --end
        --     display.newSprite(icon)
        --     :setRotation(180)
        --     :pos(18, 75)
        --     :addTo(sprite)
        -- end
        xpos = xpos + 60
    end
end

function MJResult:hunPoints(points)
    resultPoints:removeAllChildren()
    local count = #points
    for i = 1, count do
        local str = nil
        if points[i].hun == "8_hua" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 1)
        elseif points[i].hun == "peng_peng_hu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 2)
        elseif points[i].hun == "dan_diao" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 3)
        elseif points[i].hun == "hun_1_se" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 4)
        elseif points[i].hun == "qing_1_se" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 5)
        elseif points[i].hun == "men_qing" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 6)
        elseif points[i].hun == "ping_hu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 7)
        elseif points[i].hun == "bian" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 8)
        elseif points[i].hun == "qian" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 9)
        elseif points[i].hun == "dan_diao_" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 10)
        elseif points[i].hun == "dui_dao" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 11)
        elseif points[i].hun == "tian_hu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 12)
        elseif points[i].hun == "di_hu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 13)
        elseif points[i].hun == "gang_shang_kai_hua" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 14)
        elseif points[i].hun == "hai_di_lao_yue" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 15)
        elseif points[i].hun == "la_gang_hu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 16)
        elseif points[i].hun == "zi_mo" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 17)
        elseif points[i].hun == "ye_hua" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 18)
            --count
            local labelCnt = cc.LabelAtlas:_create()
            labelCnt:initWithString(
                tostring(points[i].point),
                "ShYMJ/caishen_cnt.png",
                18,
                22,
                string.byte('0'))
            labelCnt:setAnchorPoint(cc.p(0.5,0.5))
            local x = display.cx-308+((i-1)%4)*225 + 65
            local y = display.cy + 60 - 30*math.floor((i-1)/4)
            labelCnt:setPosition(cc.p(x,y))
            labelCnt:setString(tostring(points[i].point))
            resultPoints:addChild(labelCnt)
        elseif points[i].hun == "zheng_hua" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 19)
            --count
            local labelCnt = cc.LabelAtlas:_create()
            labelCnt:initWithString(
                tostring(points[i].point),
                "ShYMJ/caishen_cnt.png",
                18,
                22,
                string.byte('0'))
            labelCnt:setAnchorPoint(cc.p(0.5,0.5))
            local x = display.cx-308+((i-1)%4)*225 + 65
            local y = display.cy + 60 - 30*math.floor((i-1)/4)
            labelCnt:setPosition(cc.p(x,y))
            labelCnt:setString(tostring(points[i].point))
            resultPoints:addChild(labelCnt)
        elseif points[i].hun == "zheng_feng_peng_chu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 20)
        elseif points[i].hun == "wei_feng_peng_chu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 21)
        elseif points[i].hun == "quan_feng_peng_chu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 22)
        elseif points[i].hun == "zhong_fa_bai_peng_chu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 23)
            --count
            local labelCnt = cc.LabelAtlas:_create()
            labelCnt:initWithString(
                tostring(points[i].point),
                "ShYMJ/caishen_cnt.png",
                18,
                22,
                string.byte('0'))
            labelCnt:setAnchorPoint(cc.p(0.5,0.5))
            local x = display.cx-308+((i-1)%4)*225 + 65
            local y = display.cy + 60 - 30*math.floor((i-1)/4)
            labelCnt:setPosition(cc.p(x,y))
            labelCnt:setString(tostring(points[i].point))
            resultPoints:addChild(labelCnt)
        elseif points[i].hun == "4_hua" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 24)
        elseif points[i].hun == "da_hu" then
            str = string.format("#ShYMJ/result_xs_fanshu%d.png", 25)
        end
        
        if str ~= nil then
            print("frame string:" .. str)
            local x = display.cx-308+((i-1)%4)*225
            local y = display.cy + 60 - 30*math.floor((i-1)/4) 
            display.newSprite(str)
            :pos(x, y)
            :addTo(resultPoints)
        end
    end
end

function MJResult:updateWinScoreColor()
    local win_color = cc.c3b(255, 255, 0)
    local lose_color = cc.c3b(255, 255, 255)
    for i = 1, #resultScore do
        --赢的玩家
        if huInfoIndex == i then
            -- if banker == i then
            --     local posy = resultScore[i].hu:getPositionY()
            --     resultScore[i].hu:setPosition(cc.p(- 40,posy))
            -- end
            -- resultScore[i].hu:show()

            resultScore[i].bao:setColor(win_color)
            resultScore[i].score:setColor(win_color)
            resultScore[i].name:setColor(win_color)
            resultScore[i].all_hu:setColor(win_color)
            resultScore[i].addition:setColor(win_color)
            resultScore[i].detail:hide()
        else
            --输的玩家
            -- if banker == i then
            --     local posy = resultScore[i].hu:getPositionY()
            --     resultScore[i].hu:setPosition(cc.p(- 40,posy))
            -- end
            -- resultScore[i].hu:hide()

            resultScore[i].bao:setColor(lose_color)
            resultScore[i].score:setColor(lose_color)
            resultScore[i].name:setColor(lose_color)
            resultScore[i].all_hu:setColor(lose_color)
            resultScore[i].addition:setColor(lose_color)

            if resultScore[i].detail.huInfo then
                resultScore[i].detail:show()
            end
        end
    end
end

function MJResult:hunScore(scores)
    local count = #scores
    dump(scores)
    for i = 1, count do
        local name = crypt.base64decode(scores[i].name)
        name = util.checkNickName(name)
        --赢的玩家
        if scores[i].hu > 0 then
            resultScore[i].name:setString(name)
            if scores[i].banker_cnt > 0 then
                banker = i
                resultScore[i].banker:show()
                local posy = resultScore[i].hu:getPositionY()
                resultScore[i].hu:setPosition(cc.p(- 40,posy))
            else
                resultScore[i].banker:hide()
            end
            resultScore[i].score:setString(scores[i].score)
            resultScore[i].all_hu:setString(scores[i].total_tai_cnt)
            resultScore[i].hu:show()

            --hu info
            if scores[i].huInfo then
                resultScore[i].detail.huInfo = scores[i].huInfo
                if huInfoIndex == 0 then
                    huInfoIndex = i
                    self:updateHuInfo(scores[i].huInfo)
                else
                    resultScore[i].detail:show()
                end
            end
        else
            --输的玩家
            resultScore[i].name:setString(name)
            if scores[i].banker_cnt > 0 then
                banker = i
                resultScore[i].banker:show()
                local posy = resultScore[i].hu:getPositionY()
                resultScore[i].hu:setPosition(cc.p(0,posy))
            else
                resultScore[i].banker:hide()
            end
            resultScore[i].score:setString(scores[i].score)
            resultScore[i].all_hu:setString(scores[i].total_tai_cnt)
            resultScore[i].hu:hide()
        end
    end
    self:updateWinScoreColor()
end

function MJResult:clearResult()
    resultPoints:removeAllChildren()
    resultCards:removeAllChildren()
    for j = 1, 4 do
        resultScore[j].name:setString("")
        resultScore[j].bao:setString("")
        resultScore[j].score:setString("")
        resultScore[j].all_hu:setString("")
        resultScore[j].addition:setString("")
        resultScore[j].hu:hide()
        resultScore[j].banker:hide()
        resultScore[j].detail:hide()
        resultScore[j].detail.huInfo = nil
    end
    allHuCnt:setString("")
    laziSprite:hide()
end

function MJResult:hideButton()
    startButton:hide()
    leaveButton:hide()
end

function MJResult:updateHuInfo(huInfo)
   
    for i = 1,#huInfo.cheng_bao do
        if huInfo.cheng_bao[i] > 0 then
            local bao_str = {[1] = "三包",[2] = "互包"}
            resultScore[i].bao:setString(tostring(bao_str[huInfo.cheng_bao[i]]))
        else
            resultScore[i].bao:setString("")
        end
    end

    for i = 1,#huInfo.hu_addition do
        resultScore[i].addition:setString(huInfo.hu_addition[i])
    end

    allHuCnt:setString("牌型总台数：" .. tostring(huInfo.hu_xing_cnt) .. " 台")
    self:hunCards(huInfo.combins, huInfo.cards)
    self:hunPoints(huInfo.points)
end

function MJResult:setResult(result, watching, majiang)
    dump(result)
    self:clearResult()

    -- if majiang == "shzhmj" then
    scorePanel:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ResultSmallBg_xs.png"))
    -- else
    --     scorePanel:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ResultSmallBg.png"))
    -- end

    if result.mode > 0 then
        
        reusltBlank:hide()
        --self:hunCards(result.combins, result.cards)
        --self:hunPoints(result.points, majiang)
        self:hunScore(result.scores)
        if result.chao > 0 then
            laziSprite:show()
        end
    else
        reusltBlank:show()
    end

    if watching then
        leaveButton:pos(640, 50)
        startButton:hide()
    else
        startButton:pos(640 - 150, 50)
        leaveButton:pos(640 + 150, 50)
        startButton:show()
    end

    resultPanel:show()
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

    huInfoIndex = nil
    allHuCnt = nil
    banker = nil
end

function MJResult:restart()
    baseScore:hide()
    cardNumber:hide()
    dragonCard:hide()
    pointNumber1:hide()
    pointNumber2:hide()
    pointText1:hide()
    pointText2:hide()
    leftPanel:hide()
    rightPanel:hide()
    resultPanel:hide()
    laziSprite:hide()  

    huInfoIndex = 0  
    banker = 1
end

function MJResult:init(callback)
    self.callBack = callback
    return self
end

return MJResult