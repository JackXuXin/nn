local MJOutCard = class("MJOutCard",function()
    return display.newSprite()
end)

local showCard = nil
local valueCard
-- local dragonCard
local showCombin = nil
local combinContent = nil

local outCard = 0
local outSeat = 0

local leftNotify = {}
local rightNotify = {}
local topNotify = {}
local bottomNotify = {}
local showNotify = nil

local ScoreTop =nil
local ScoreLeft =nil
local ScoreRight =nil
local ScoreBottom =nil

function MJOutCard:ctor()
    -- local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card.png")
    -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 74, 126))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card.png")
   
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_sendcardframe.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 116, 156))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_sendcardframe.png")
    
    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai.png")
    -- for i = 1, 5 do
    --     for j = 1, 9 do
    --         local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(72*(j-1), 89*(i-1), 72, 89))
    --         cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_%d.png", i*16+j))
    --     end
    -- end

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_0.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 158))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_0.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_1.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_1.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_2.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_2.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_3.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_3.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_4.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_4.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_5.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 110, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_5.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_9.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 190, 148))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_9.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_10.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 277, 182))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_10.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_circle.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 126, 124))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_circle.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/text_gangqian.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 68, 28))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/text_gangqian.png")

    showNotify = display.newSprite()
    :hide()
    :addTo(self)

    leftNotify.sprite = display.newSprite()
    :hide()
    :addTo(showNotify)
    leftNotify.icon = display.newSprite("#ShYMJ/text_gangqian.png")
    :addTo(leftNotify.sprite)
    leftNotify.text = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :addTo(leftNotify.sprite)
    leftNotify.text:setAnchorPoint(0.5, 0.5)

    rightNotify.sprite  = display.newSprite()
    :hide()
    :addTo(showNotify)
    rightNotify.icon = display.newSprite("#ShYMJ/text_gangqian.png")
    :addTo(rightNotify.sprite)
    rightNotify.text = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :addTo(rightNotify.sprite)
    rightNotify.text:setAnchorPoint(0.5, 0.5)

    topNotify.sprite  = display.newSprite()
    :hide()
    :addTo(showNotify)
    topNotify.icon = display.newSprite("#ShYMJ/text_gangqian.png")
    :addTo(topNotify.sprite)
    topNotify.text = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :addTo(topNotify.sprite)
    topNotify.text:setAnchorPoint(0.5, 0.5)

    bottomNotify.sprite  = display.newSprite()
    :hide()
    :addTo(showNotify)
    bottomNotify.icon = display.newSprite("#ShYMJ/text_gangqian.png")
    :addTo(bottomNotify.sprite)
    bottomNotify.text = cc.ui.UILabel.new({color=cc.c3b(255,255,0), size=24, text="", align=align})
    :addTo(bottomNotify.sprite)
    bottomNotify.text:setAnchorPoint(0.5, 0.5)
end
--加减分的动作
function MJOutCard:combinScore(info)
    -- local sequence = transition.sequence({
    -- cc.MoveBy:create(0.5, cc.p(0, 50)),
    -- cc.FadeIn:create(0.3),
    -- })
    --1.一个动作对象只能由一个节点执行，想要实现多个节点执行一个相同的动作对象，可以使用clone()函数
    --2.亦或则是对该动作对象重新进行赋值，即此时该动作对象为一个新的动作对象（下面用的就是第2种方法）
    print("combinScore1")
    dump(info, "加减分动作")
    for i=1,#info do
        local FadeInAction=cc.FadeIn:create(1.5)
        local moveAction = cc.MoveBy:create(1.5,cc.p(0, 60))
        local FadeOutAction =cc.FadeOut:create(1.5)
        local spawn1 = cc.Spawn:create(FadeInAction,moveAction)
        local spawn2 = cc.Spawn:create(FadeOutAction,moveAction)
        local s = cc.Sequence:create(spawn1,spawn2)
        

        local direct
        if  info[i].seat~=0 then
            direct = self.callBack:getDirect(info[i].seat)
        else
            direct = nil
        end
        
        if direct == "left"  then
            print("combinScoreleft")
            ScoreLeft = cc.ui.UILabel.new({color=cc.c3b(255,233,199), size=30, text="", align=align})
            :pos(50, display.cy - 63)
            :addTo(self)
            ScoreLeft:setString(info[i].score)
            
            transition.execute(ScoreLeft, s, {
                onComplete = function ()
                    if ScoreLeft~=nil then
                        ScoreLeft:hide()
                    end
                end
            })
            
        elseif direct == "right"  then
            print("combinScoreright")
            ScoreRight = cc.ui.UILabel.new({color=cc.c3b(255,233,199), size=30, text="", align=align})
            :pos(display.width - 110, display.cy -63)
            :addTo(self)
            ScoreRight:setString(info[i].score)
            transition.execute(ScoreRight, s, {
                onComplete = function ()
                    if ScoreRight~=nil then
                        ScoreRight:hide()
                    end
                end
            })
        elseif direct == "top"  then
            print("combinScoretop")
            ScoreTop = cc.ui.UILabel.new({color=cc.c3b(255,233,199), size=30, text="", align=align})
            :pos(250, display.height - 100-63)
            :addTo(self)
            ScoreTop:setString(info[i].score)
            transition.execute(ScoreTop, s, {
                onComplete = function ()
                    if ScoreTop~=nil then
                        ScoreTop:hide()
                    end
                end
            })
        elseif direct == "bottom"  then
            print("combinScorebottom")
            ScoreBottom = cc.ui.UILabel.new({color=cc.c3b(255,233,199), size=30, text="", align=align})
            :pos(50, 100-63)
            :addTo(self)
            ScoreBottom:setString(info[i].score)
            transition.execute(ScoreBottom, s, {
                onComplete = function ()
                    if ScoreBottom~=nil then
                        ScoreBottom:hide()
                    end
                end
            })
        end
        
    end
    
end

function MJOutCard:outCard(card, direct)
    print("card:" ..card ..",direct:" ..direct)
    print("outCard:" ..outCard ..",outSeat:" ..outSeat)
    if outCard and outCard > 0 and outSeat and outSeat > 0 then
        self.callBack:onOutedCard(outCard, outSeat)  --将已经出的牌加到桌面上
        outCard = 0
        outSeat = 0
    end

    if showCombin ~= nil then
        showCombin:hide()
    end
    if showCard == nil then
        showCard = display.newSprite("#ShYMJ/img_GameUI_sendcardframe.png")--显示到手牌上的出牌效果
        :addTo(self)
        display.newSprite(string.format("#ShYMJ/img_normal_card.png"))
        :pos(58, 76)
        :addTo(showCard)
        valueCard = display.newSprite()
        :pos(59, 71)
        :addTo(showCard)

        -- local icon = "#ShYMJ/img_tanpai_hun.png"
        -- local majiang = self.callBack:getMajiang()
        -- if majiang == "shzhmj" then
        -- local icon = "#ShYMJ/img_tanpai_hun_cai.png"
        -- end
        -- dragonCard = display.newSprite(icon)
        -- :pos(58, 80)
        -- :addTo(showCard)
    
    end
    if direct == "left" then
        showCard:pos(display.left + 280, display.cy + 34)
    elseif direct == "right" then
        showCard:pos(display.right - 280, display.cy + 34)
    elseif direct == "top" then
        showCard:pos(display.cx, display.top - 200)
    elseif direct == "bottom" then
        showCard:pos(display.cx, display.bottom + 270)
    end
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_cardvalue_shoupai_%d.png", card))
    valueCard:setSpriteFrame(frame)
    -- local val = self.callBack:getDragonCard()
    -- if val == card then
        -- dragonCard:show()
    -- else
        -- dragonCard:hide()
    -- end
    showCard:show()
end

function MJOutCard:outedCard(card, seat)
    print("outedCard::::card:" ..card ..",seat:" ..seat)
    outCard = card
    outSeat = seat
end
--碰杠胡显示动作
function MJOutCard:combinCard(combin, direct)
    if showCard ~= nil then
        showCard:hide()
    end
    if showCombin == nil then
        showCombin = display.newSprite("#ShYMJ/ani_special_circle.png")
        :addTo(self)
        combinContent = display.newSprite()
        :pos(63, 62)
        :addTo(showCombin)
    end
    if direct == "left" then
        showCombin:pos(display.left + 185, display.cy + 34)
    elseif direct == "right" then
        showCombin:pos(display.right - 185, display.cy + 34)
    elseif direct == "top" then
        showCombin:pos(display.cx, display.top - 165)
    elseif direct == "bottom" then
        showCombin:pos(display.cx, display.bottom + 235)
    end
    -- if combin == "left" or combin == "center" or combin == "right" then
    --     local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_0.png")
    --     combinContent:setSpriteFrame(frame)
    if combin == "peng" then  --碰
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_1.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "an_gang" then --暗杠
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_2.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "bu_gang" then --补杠
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_2.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "ming_gang" then --明杠
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_2.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "hua_gang" then --花杠
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_10.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "Ting" then --听牌
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_3.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "fa_kuan1" or combin == "fa_kuan2" then --罚款
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_9.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "hu" then --胡
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_4.png")
        combinContent:setSpriteFrame(frame)
        
    elseif combin == "muo" then --自摸
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_5.png")
        combinContent:setSpriteFrame(frame)
        
    -- elseif combin == "pao" then
    --     local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("ShYMJ/ani_special_8.png")
    --     combinContent:setSpriteFrame(frame)
    end
    combinContent:setScale(2.0)
    local animate1 = cc.ScaleTo:create(0.25, 1.0) --0.25
    local animate2 = cc.ScaleTo:create(0.25, 1.0)
    local animate3 = cc.CallFunc:create(function() 
        showCombin:hide()
    end)
    combinContent:runAction(cc.Sequence:create(animate1, animate2, animate3))
    showCombin:show()
end

function MJOutCard:gangNotify(notify, content)
    if notify then
        leftNotify.sprite:hide()
        rightNotify.sprite:hide()
        topNotify.sprite:hide()
        bottomNotify.sprite:hide()
        local count = #content
        for i = 1, count do
            if content[i].direct == "left" then
                leftNotify.text:setString(content[i].text)
                local width = 70 + leftNotify.text:getBoundingBox().width
                leftNotify.icon:pos(display.left+250+35, display.cy + 34)
                leftNotify.text:pos(display.left+250+35+width/2, display.cy + 34)
                leftNotify.sprite:show()
            elseif content[i].direct == "right" then
                rightNotify.text:setString(content[i].text)
                local width = 70 + rightNotify.text:getBoundingBox().width
                rightNotify.icon:pos(display.right-250-width+35, display.cy + 34)
                rightNotify.text:pos(display.right-250-width+35+width/2, display.cy + 34)
                rightNotify.sprite:show()
            elseif content[i].direct == "top" then
                topNotify.text:setString(content[i].text)
                local width = 70 + topNotify.text:getBoundingBox().width
                topNotify.icon:pos(display.cx-width/2+35, display.top - 180 + 34)
                topNotify.text:pos(display.cx-width/2+35+width/2, display.top - 180 + 34)
                topNotify.sprite:show()
            elseif content[i].direct == "bottom" then
                bottomNotify.text:setString(content[i].text)
                local width = 70 + bottomNotify.text:getBoundingBox().width
                bottomNotify.icon:pos(display.cx-width/2+35, display.bottom + 180 + 34)
                bottomNotify.text:pos(display.cx-width/2+35+width/2, display.bottom + 180 + 34)
                bottomNotify.sprite:show()
            end
        end
        local animate1 = cc.ScaleTo:create(0.4, 1.0)
        local animate2 = cc.CallFunc:create(function() 
            showNotify:hide()
        end)
        showNotify:runAction(cc.Sequence:create(animate1, animate2))
        showNotify:show()
    else
        showNotify:hide()
    end
end

function MJOutCard:clearCard()
    if showCard ~= nil then
        showCard:hide()
    end
    if showCombin ~= nil then
        showCombin:hide()
    end
end

function MJOutCard:clear()
    showCard = nil
    valueCard = nil
    -- dragonCard = nil
    showCombin = nil
    combinContent = nil

    outCard = 0
    outSeat = 0

    leftNotify = {}
    rightNotify = {}
    topNotify = {}
    bottomNotify = {}

    showNotify = nil
    ScoreTop =nil
    ScoreLeft =nil
    ScoreRight =nil
    ScoreBottom =nil
end

function MJOutCard:restart()
    self:clearCard()
    showNotify:hide()

    outCard = 0
    outSeat = 0

    ScoreTop =nil
    ScoreLeft =nil
    ScoreRight =nil
    ScoreBottom =nil
end

function MJOutCard:init(callback)
    self.callBack = callback
    return self
end

return MJOutCard