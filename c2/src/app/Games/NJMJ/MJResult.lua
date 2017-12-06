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

-- local dragonCard
-- local cardValue

-- local pointNumber1
-- local pointNumber2

-- local pointText1
-- local pointText2

-- local startButton
-- local leaveButton

-- local resultScore
-- local resultCards
-- local resultPoints
-- local laziSprite

-- local reusltBlank
-- local iconDragon

local bg_result
local max_player
local my_seat
local score_num

local cardLocation
local zimohucard={card=0,seat=0}

function MJResult:ctor()
    -- local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/zuoshang.png")
    -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 171, 70))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/zuoshang.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 62, 92))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")
   

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/DYResult/img_card_result.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 43, 62))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/DYResult/img_card_result.png")
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    -- for i = 1, 4 do
    --     for j = 1, 9 do
    --         frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(36*(j-1), 44.6*(i-1), 36, 44.6))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
    --     end
    -- end

    


    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/Hu.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/Hu.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_tuzhang1.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 271, 215))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_cardvalue_tuzhang1.png")
    

    leftPanel = display.newSprite("#ShYMJ/zuoshang.png")
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

    --设置龙牌
    -- dragonCard = display.newSprite("#ShYMJ/img_spe_card.png")
    -- :setScale(0.65)
    -- :setAnchorPoint(0.5, 1)
    -- :pos(61, 77)
    -- :hide()
    -- :addTo(leftPanel)
    -- cardValue=display.newSprite(string.format("#ShYMJ/img_cardvalue_cpg%d.png", 16*4+8))
    -- :pos(31, 53)
    -- :addTo(dragonCard)
    -- iconDragon = display.newSprite("#ShYMJ/img_up_card_hun.png")
    -- :setRotation(180)
    -- :pos(18, 75)
    -- :addTo(dragonCard)
    ----

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

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/result_win_bg.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 1278, 610))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/result_win_bg.png")

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

function MJResult:setBaseScore(score)
    baseScore:setString(string.format("%d", score))
    baseScore:show()
    score_num = score
    print("base score_num:" .. tostring(score_num))
    leftPanel:show()
end

function MJResult:setCardNumber(number)
    cardNumber:setString(string.format("%d", number))
    cardNumber:show()
    leftPanel:show()
end

function MJResult:showInfo()
    leftPanel:hide()
end

-- function MJResult:setDragon(dragon)
--     local majiang = self.callBack:getMajiang()
--     local icon = "ShYMJ/img_up_card_hun_cai.png"

--     iconDragon:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(icon))
--     cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", dragon)))
--     dragonCard:show()
--     -- rightPanel:show()
-- end

--modify by whb 161103
-- function MJResult:setOpenCard(dragon)

--     local card = dragon
--     -- if dragon == 16*1+1 then

--     --     card = 16*1+9

--     -- elseif dragon == 16*2+1 then

--     --     card = 16*2+9

--     -- elseif dragon == 16*3+1 then

--     --     card = 16*3+9

--     -- elseif dragon == 16*4+1 then

--     --     card = 16*4+4

--     -- end

--     print("setOpenCard-dragon:" .. dragon)
--     print("setOpenCard:" .. card)

--     iconDragon:hide()
--     cardValue:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_cpg%d.png", card)))
--     dragonCard:show()
--     -- rightPanel:show()
-- end
--modify end

function MJResult:setPoints(point1, point2)
    -- if point1 > 0 and point1 < 7 then
 --        pointText1:hide()
    --  pointNumber1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", 6+point1)))
    --  pointNumber1:show()
 --    else
 --        pointNumber1:hide()
 --        pointText1:show()
    -- end

    -- if point2 > 0 and point2 < 7 then
 --        pointText2:hide()
    --  pointNumber2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", point2)))
    --  pointNumber2:show()
 --    else
 --        pointNumber2:hide()
 --        pointText2:show()
    -- end
 --    rightPanel:show()
end

--
function MJResult:CombinCards(combin,cardInfo,index)
    if combin=="an_gang" then   --暗杠的牌
        --todo
        for i = 1, 3 do
            display.newSprite("#ShYMJ/img_spe_backcard.png")
            :setScale(0.6)
            :pos(cardLocation[index]+(i-1)*37,display.height - 72 - index * 105)
            :addTo(bg_result)
        end
        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        :pos(cardLocation[index]+37, display.height - 72 - index * 105 + 14)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cardInfo))
        :setScale(0.9)
        :pos(22, 37)
        :addTo(sprite)

        cardLocation[index]=cardLocation[index]+3*37+20
    elseif combin=="bu_gang" or combin=="ming_gang" then    --明杠或补杠的牌
        --todo
        for i = 1, 3 do
            local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
            :pos(cardLocation[index]+(i-1)*37,display.height - 72 - index * 105)
            :addTo(bg_result)
            display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cardInfo))
            :setScale(0.9)
            :pos(22, 37)
            :addTo(sprite)
        end
        local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
        :pos(cardLocation[index]+37, display.height - 72 - index * 105 + 14)
        :addTo(bg_result)
        display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cardInfo))
        :setScale(0.9)
        :pos(22, 37)
        :addTo(sprite)

        cardLocation[index]=cardLocation[index]+3*37+20
    elseif combin=="peng" then     --碰的牌
        for i = 1, 3 do
            local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
            :pos(cardLocation[index]+(i-1)*37,display.height - 72 - index * 105)
            :addTo(bg_result)
            display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cardInfo))
            :setScale(0.9)
            :pos(22, 37)
            :addTo(sprite)
        end

        cardLocation[index]=cardLocation[index]+3*37+20
    elseif combin=="hu" then     --胡的牌，点炮或是自摸，自摸则将参数保存，交于手牌处理
        --todo
        -- my_seat=1
        if cardInfo.card_from ==index then
            --保存自摸的牌
            return
        else
            local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
            -- :setScale(0.6)
            :setAnchorPoint(0.5,0.5)
            :pos(cardLocation[index],display.height - 72 - index * 105)
            :addTo(bg_result)

            display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cardInfo.card))
            :setScale(0.9)
            :pos(22, 37)
            :addTo(sprite)
            --添加胡牌小图标
            display.newSprite("ShYMJ/NJResult/Result_hu.png")
            :setScale(0.8)
            -- :setScale(0.6)
            :pos(43-19/2*0.8, 62-19/2*0.8)
            :addTo(sprite)

            cardLocation[index]=cardLocation[index]+37+20
        end
    elseif combin=="cards" then  --手牌，判断是否是自摸
        --todo
        
        for i=1,#cardInfo do
            local sprite = display.newSprite("#ShYMJ/DYResult/img_card_result.png")
            :setAnchorPoint(0.5,0.5)
            :pos(cardLocation[index]+(i-1)*37,display.height - 72 - index * 105)
            :addTo(bg_result)

            display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX%d.png", cardInfo[i]))
            :setScale(0.9)
            :pos(22, 37)
            :addTo(sprite)
            if zimohucard.card==cardInfo[i] and zimohucard.seat==index then
                --todo
                --添加胡牌小图标
                display.newSprite("ShYMJ/NJResult/Result_hu.png")
                :setScale(0.8)
                -- :setScale(0.6)
                :pos(43-19/2*0.8, 62-19/2*0.8)
                :addTo(sprite)
                zimohucard.card=0
            end

        end
        cardLocation[index]=cardLocation[index]+#cardInfo*37+20
    end
end


function MJResult:scoreText(scoreInfo,bixiahu)
    -- dump(scoreInfo)
    local isShow=false
    local str=""
    str=str .."("
    --所有杠
    -- local gang=0
    if tonumber(scoreInfo.an_gang_flowers)~=0 then
        isShow=true
        str=str .."暗杠" ..scoreInfo.an_gang_flowers .." "
    end
    if tonumber(scoreInfo.ming_gang_flowers)~=0 then
        isShow=true
        str=str .."明杠" ..scoreInfo.ming_gang_flowers .." "
    end
    if tonumber(scoreInfo.bu_gang_flowers)~=0 then
        isShow=true
        str=str .."补杠" ..scoreInfo.bu_gang_flowers .." "
    end
    if tonumber(scoreInfo.hua_gang_flowers)~=0 then
        isShow=true
        str=str .."花杠" ..scoreInfo.hua_gang_flowers .." "
    end
    
    --罚款
    if  tonumber(scoreInfo.fa_kuan_flowers)~=0 then
        isShow=true
        str=str .."罚款" ..scoreInfo.fa_kuan_flowers .." "
    end

    --硬花
    if tonumber(scoreInfo.hard_flowers)~=0 then
        isShow=true
        str=str .."硬花" ..scoreInfo.hard_flowers .."x2 "
    end
    --软花
    if tonumber(scoreInfo.soft_flowers)~=0 then
        isShow=true
        str=str .."软花" ..tostring(scoreInfo.soft_flowers) .."x2 "
    end

    --胡牌类型
    if scoreInfo.card_type~=nil and #scoreInfo.card_type>0 then
        isShow=true
        local hupaiTab={[12]="门清",[13]="混一色",[14]="清一色",[15]="对对胡",[16]="全球独钓",[17]="七对",[18]="双七对",[19]="压绝",[20]="无花果",[21]="天胡",[22]="地胡",[23]="小杠开花",[24]="大杠开花",}
        for i=1,#scoreInfo.card_type do
            str=str ..tostring(hupaiTab[scoreInfo.card_type[i].tp]) .."x" ..tostring(scoreInfo.card_type[i].flowers) .." "
        end
        
    end
   
    --跑10
    if scoreInfo.lead_to~=nil and type(scoreInfo.lead_to)=="table" and scoreInfo.lead_to.card~=0 then
        -- isShow=true
        str=str .."跑10" .." "
    end

    str=str ..")"
    --比下胡
    
    if bixiahu==2 then
        str=str .."x2 "
    end
    -- score_num=100      --注释
    if scoreInfo.lead_to~=nil and type(scoreInfo.lead_to)=="table" and scoreInfo.lead_to.card~=0 then
        str=str .."底分" .."x" ..score_num
    end
    if isShow  then
        cc.ui.UILabel.new({
            text = str, 
            size = 18, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(340,display.height - 120 - scoreInfo.seat * 105)
    end
end

function MJResult:hunScore(scores)
    -- local count = #scores
    -- dump(scores)
    -- for i = 1, count do
    --     local name = crypt.base64decode(scores[i].name)
    --     name = util.checkNickName(name)
    --     if scores[i].hu > 0 then
    --         resultScore[1][i].name:setString(name)
    --         if scores[i].banker_cnt > 0 then
    --             resultScore[1][i].flower:setString(scores[i].banker_cnt)
    --             resultScore[1][i].banker:show()
    --             local posy = resultScore[1][i].banker:getPositionY()
    --             resultScore[1][i].banker:setPosition(cc.p(- 40,posy))
    --         else
    --             resultScore[1][i].flower:setString("")
    --             resultScore[1][i].banker:hide()
    --         end
    --         if scores[i].banker_long_cnt > 0 then
    --             resultScore[1][i].bao:setString(scores[i].banker_long_cnt)
    --         else
    --             resultScore[1][i].bao:setString("")
    --         end
    --         resultScore[1][i].longcnt:setString(scores[i].total_dragon_cnt)
    --         resultScore[1][i].score:setString(scores[i].score)
    --         resultScore[1][i].hu:show()
    --     else
    --         resultScore[2][i].name:setString(name)
    --         if scores[i].banker_cnt > 0 then
    --             resultScore[2][i].flower:setString(scores[i].banker_cnt)
    --             resultScore[2][i].banker:show()
    --             local posy = resultScore[1][i].banker:getPositionY()
    --             resultScore[2][i].banker:setPosition(cc.p(0,posy))
    --         else
    --             resultScore[2][i].flower:setString("")
    --             resultScore[2][i].banker:hide()
    --         end
    --         if scores[i].banker_long_cnt > 0 then
    --             resultScore[2][i].bao:setString(scores[i].banker_long_cnt)
    --         else
    --             resultScore[2][i].bao:setString("")
    --         end
    --         resultScore[2][i].longcnt:setString(scores[i].total_dragon_cnt)
    --         resultScore[2][i].score:setString(scores[i].score)
    --         resultScore[2][i].hu:hide()
    --     end
    -- end
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
    -- startButton:hide()
    -- leaveButton:hide()
end

function MJResult:setMaxPlayer(max,seat)
    max_player = max
    my_seat = seat
end

--创建结算面板
function MJResult:createResult(result, watching,heads,table_code,weixinImage)
    --牌的相对位置
    cardLocation={350,350,350,350}
    bg_result = display.newSprite("ShYMJ/DYResult/BG.png")
    :pos(display.cx,display.cy)
    :addTo(self)
    display.newSprite("ShYMJ/DYResult/zhuzi.png")
    :pos(100,display.height - 213)
    :addTo(bg_result)
    --比下胡
    if result.bixiahu==2 then
        --todo
        display.newSprite("ShYMJ/NJResult/bixiahu.png")
        :pos(250,display.height - 100)
        :addTo(bg_result)
    end
    
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
    cc.ui.UILabel.new({
        text = "底分：每花" .. tostring(score_num) .. "两", 
        -- text = "底分：每花" .. score_num .. "两", 
        size = 24, 
        color = cc.c3b(255,255,255)
        })
    :addTo(bg_result)
    :setAnchorPoint(0.5,0.5)
    :setPosition(220,120)

    local startButton = nil
    if not watching then
        startButton = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_again_normal.png", pressed = "ShYMJ/button_again_selected.png" })
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

    if table_code then
        if startButton then
            startButton:hide()
        end

        if leaveButton then
            leaveButton:hide()
        end
    end


    local winner = 0
    --玩家信息
    
   

    local dianpao=0
    local dianpaoNum=0
    local baopai=0
    -- max_player=4      --注释
    for i = 1,max_player do
        --赢家
        if result.player_infos[i].lead_to~=nil and type(result.player_infos[i].lead_to)=="table"  and result.player_infos[i].lead_to.card~=0  then
            display.newSprite("ShYMJ/DYResult/win_bg.png")
            :pos(display.cx,display.height - 80 - result.player_infos[i].seat * 105 - 5)
            :addTo(bg_result)
            winner = result.player_infos[i].seat
        end

        display.newSprite("ShYMJ/DYResult/head_bg.png")
        :pos(250,display.height - 80 - result.player_infos[i].seat * 105)
        :addTo(bg_result)
        --头像
        local headImage=display.newSprite(heads[result.player_infos[i].seat])
            :pos(250,display.height - 80 - result.player_infos[i].seat * 105)
            :addTo(bg_result)
            :scale(0.4)
        --微信头像
        
        if weixinImage and weixinImage[result.player_infos[i].seat] then
            util.setHeadImage(headImage:getParent(), weixinImage[result.player_infos[i].seat], headImage, heads[result.player_infos[i].seat])
        end
        --名字
        for s_t=1,max_player do
            if result.player_infos[s_t].seat==i then
                local name = crypt.base64decode(result.player_infos[s_t].name)
                name = util.checkNickName(name)
                local name = cc.ui.UILabel.new({
                    text = name, 
                    size = 18, 
                    color = cc.c3b(255,255,255)
                })
                :addTo(bg_result)
                :setAnchorPoint(0.5,0.5)
                :setPosition(250,display.height - 80 - i * 105 - 45)
            end
        end
        

       

        --本方
        -- if result.player_infos[i].seat == my_seat then
        if result.player_infos[i].seat == my_seat then
            display.newSprite("ShYMJ/DYResult/benfang.png")
            :pos(250 - 100,display.height - 80 - result.player_infos[i].seat * 105)
            :addTo(bg_result)
        end

        --麻将
        --暗杠
        if result.player_infos[i].an_gangs~=nil and type(result.player_infos[i].an_gangs)=="table" and #result.player_infos[i].an_gangs>0 then
            --todo
            for j=1,#result.player_infos[i].an_gangs do
                local cardInfo=result.player_infos[i].an_gangs[j]
                self:CombinCards("an_gang",cardInfo,result.player_infos[i].seat) --暗杠
            end
            
        end
        --补杠
        if result.player_infos[i].bu_gangs~=nil and type(result.player_infos[i].bu_gangs)=="table" and #result.player_infos[i].bu_gangs>0 then
            --todo
            for j=1,#result.player_infos[i].bu_gangs do
                local cardInfo=result.player_infos[i].bu_gangs[j]
                self:CombinCards("bu_gang",cardInfo,result.player_infos[i].seat) --补杠
            end
        end
        --明杠
        if result.player_infos[i].ming_gangs~=nil and type(result.player_infos[i].ming_gangs)=="table" and #result.player_infos[i].ming_gangs>0 then
            --todo
            for j=1,#result.player_infos[i].ming_gangs do
                local cardInfo=result.player_infos[i].ming_gangs[j]
                self:CombinCards("ming_gang",cardInfo,result.player_infos[i].seat) --明杠
            end
        end
        --碰
        if result.player_infos[i].pengs~=nil and type(result.player_infos[i].pengs)=="table" and #result.player_infos[i].pengs>0 then
            --todo
            for j=1,#result.player_infos[i].pengs do
                local cardInfo=result.player_infos[i].pengs[j]
                self:CombinCards("peng",cardInfo,result.player_infos[i].seat) --碰
            end
        end
        
        --先判断是否为自摸
        if result.player_infos[i].lead_to~=nil and type(result.player_infos[i].lead_to)=="table" and result.player_infos[i].lead_to.card~=0 then
            --todo
            local cardInfo={}
            cardInfo.card_from=result.player_infos[i].lead_to.card_from
            cardInfo.card=result.player_infos[i].lead_to.card
            if cardInfo.card_from ==result.player_infos[i].seat then
                --保存自摸的牌
                zimohucard.card=cardInfo.card
                zimohucard.seat=cardInfo.card_from
            end
        end
        --手牌
        if result.player_infos[i].hand_cards~=nil and type(result.player_infos[i].hand_cards)=="table" and #result.player_infos[i].hand_cards>0 then
            --todo
            
            local cardInfo=result.player_infos[i].hand_cards
            self:CombinCards("cards",cardInfo,result.player_infos[i].seat) --手牌
            
        end
        --胡哪张牌
        if result.player_infos[i].lead_to~=nil and type(result.player_infos[i].lead_to)=="table" and result.player_infos[i].lead_to.card~=0 then
            --todo
            local cardInfo={}
            cardInfo.card_from=result.player_infos[i].lead_to.card_from
            cardInfo.card=result.player_infos[i].lead_to.card
            self:CombinCards("hu",cardInfo,result.player_infos[i].seat) --胡
        end


        --总计得分
        display.newSprite("ShYMJ/DYResult/gold_icon.png")
        :pos(display.width - 300,display.height - 80 - result.player_infos[i].seat * 105)
        :addTo(bg_result)

        local score = cc.ui.UILabel.new({
            text = result.player_infos[i].total, 
            size = 22, 
            color = cc.c3b(255,255,255)
            })
        :addTo(bg_result)
        :setAnchorPoint(0,0.5)
        :setPosition(display.width - 280,display.height - 80 - result.player_infos[i].seat * 105)

        --自摸
        local str
        local kuaizhaoSp
        if result.player_infos[i].lead_to~=nil and type(result.player_infos[i].lead_to)=="table" and result.player_infos[i].lead_to.card~=0 then
            --todo
            local cardInfo={}
            cardInfo.card_from=result.player_infos[i].lead_to.card_from
            cardInfo.card=result.player_infos[i].lead_to.card
            if result.player_infos[i].kuai_zhao ==1 then
                    --todo
                str = "ShYMJ/NJResult/kuaizhao.png"
                kuaizhaoSp=display.newSprite(str)
                :pos(display.width - 115,display.height - 80 - result.player_infos[i].seat * 105)
                :addTo(bg_result)
                if cardInfo.card_from ~=result.player_infos[i].seat then
                    --点炮
                    dianpao=cardInfo.card_from
                    dianpaoNum=dianpaoNum+1
                end
            elseif cardInfo.card_from ==result.player_infos[i].seat then
                str = "ShYMJ/DYResult/zimo.png"     --自摸
                display.newSprite(str)
                :pos(display.width - 115,display.height - 80 - result.player_infos[i].seat * 105)
                :addTo(bg_result)

            else
                
                if result.player_infos[i].shui_bao ~=nil and result.player_infos[i].shui_bao>0 and type(result.player_infos[i].shui_bao)=="number" and result.player_infos[i].shui_bao==result.player_infos[i].seat then
                    --包牌(胡和包牌同时存在)
                    str = "ShYMJ/NJResult/baopai.png"
                    display.newSprite(str)
                    :pos(display.width - 115,display.height - 80 - result.player_infos[i].shui_bao * 105)
                    :addTo(bg_result)
                    baopai=result.player_infos[i].shui_bao
                else
                    str = "ShYMJ/NJResult/hu.png"       --胡
                    display.newSprite(str)
                    :pos(display.width - 115,display.height - 80 - result.player_infos[i].seat * 105)
                    :addTo(bg_result)
                end
                --点炮
                dianpao=cardInfo.card_from
                dianpaoNum=dianpaoNum+1
            end
            

        end
        
        if result.player_infos[i].shui_bao ~=nil and result.player_infos[i].shui_bao>0 and type(result.player_infos[i].shui_bao)=="number" then  --包牌
            if result.player_infos[i].kuai_zhao ==1 then  --快照/包牌  （包牌和快照同时存在）
                if result.player_infos[i].shui_bao==result.player_infos[i].seat then
                    -- kuaizhaoSp:setScale(0.6)
                    -- kuaizhaoSp:pos(display.width - 115*2+115/2,display.height - 80 - result.player_infos[i].seat * 105)

                    -- str = "ShYMJ/NJResult/baopai.png"
                    -- display.newSprite(str)
                    -- :setScale(0.6)
                    -- :pos(display.width - 115/2,display.height - 80 - result.player_infos[i].shui_bao * 105)
                    -- :addTo(bg_result)
                
                elseif dianpao~=0 and dianpao==result.player_infos[i].shui_bao then
                    if dianpaoNum==1 then
                        --点炮（点炮和包牌同时存在）
                        display.newSprite("ShYMJ/NJResult/dianpao.png")
                        :pos(display.width - 115,display.height - 80 - dianpao * 105)
                        :addTo(bg_result)
                        dianpao=0
                    end
                else
                    str = "ShYMJ/NJResult/baopai.png"
                    display.newSprite(str)
                    :pos(display.width - 115,display.height - 80 - result.player_infos[i].shui_bao * 105)
                    :addTo(bg_result)
                end
            else                                        
                
                if dianpao~=0 and dianpao==result.player_infos[i].shui_bao then
                    if dianpaoNum==1 then
                        --点炮（点炮和包牌同时存在）
                        display.newSprite("ShYMJ/NJResult/dianpao.png")
                        :pos(display.width - 115,display.height - 80 - dianpao * 105)
                        :addTo(bg_result)
                        dianpao=0
                    end
                elseif baopai~=result.player_infos[i].shui_bao then
                    --包牌
                    str = "ShYMJ/NJResult/baopai.png"
                    display.newSprite(str)
                    :pos(display.width - 115,display.height - 80 - result.player_infos[i].shui_bao * 105)
                    :addTo(bg_result)
                end
            end
        end
        if dianpao~=0 then
            if dianpaoNum==1 then
                --点炮
                display.newSprite("ShYMJ/NJResult/dianpao.png")
                :pos(display.width - 115,display.height - 80 - dianpao * 105)
                :addTo(bg_result)
                dianpao=0
            end
        end
        --计算得分
        self:scoreText(result.player_infos[i],result.bixiahu)
    end

    
    
    --庄家图标
    display.newSprite("ShYMJ/img_GameUI_zhuang.png")
    :pos(250 - 25,display.height - 80 - result.banker * 105 + 25)
    :addTo(bg_result)
end

function MJResult:setResult(result, watching,heads,table_code,weixinImage)
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

    self:createResult(result, watching, heads,table_code,weixinImage)
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
    -- rightPanel = nil
    -- resultPanel = nil
    -- scorePanel = nil

    baseScore = nil
    score = nil
    cardNumber = nil

    -- dragonCard = nil
    -- iconDragon = nil
    -- cardValue = nil

    -- pointNumber1 = nil
    -- pointNumber2 = nil

    -- pointText1 = nil
    -- pointText2 = nil

    -- startButton = nil
    -- leaveButton = nil

    -- resultScore = nil
    -- resultCards = nil
    -- resultPoints = nil

    -- reusltBlank = nil
    -- laziSprite = nil

    bg_result = nil
    max_player = nil
    my_seat = nil

    cardLocation={}
    zimohucard={}
end

function MJResult:restart()
    baseScore:hide()
    cardNumber:hide()
    -- dragonCard:hide()
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
    zimohucard={card=0,seat=0}

end

function MJResult:init(callback)
    self.callBack = callback
    return self
end

return MJResult