local MJWalls = class("MJWalls",function()
    return display.newSprite()
end)

local wallsLevel

local rotateDice1
local rotateDice2

local hor1
local hor2
local ver1
local ver2

local baoBgani

function MJWalls:ctor()
    wallsLevel = display.newSprite()
    :addTo(self)
    :hide()
    
    hor1 = display.newSprite("ShYMJ/img_cardwall_horizontal.png")
    :pos(display.cx+60, display.cy+145+ 34)
    :addTo(wallsLevel)
    
    ver1 = display.newSprite("ShYMJ/img_cardwall_vertical.png")
    :pos(display.cx-160, display.cy+45+ 34)
    :addTo(wallsLevel)
    
    ver2 = display.newSprite("ShYMJ/img_cardwall_vertical.png")
    :pos(display.cx+160, display.cy-45+ 34)
    :addTo(wallsLevel)
    
    hor2 = display.newSprite("ShYMJ/img_cardwall_horizontal.png")
    :pos(display.cx-60, display.cy-145+ 34)
    :addTo(wallsLevel)

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_dice_rotate.png")
    for i = 1, 9 do
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect((i-1)*50, 0, 50, 54))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_dice_rotate%d.png", i))
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_dice_normal.png")
    for i = 1, 6 do
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect((i-1)*65, 0, 65, 68))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_dice_normal%d.png", i))
    end

    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_dice_rotate%d.png", 1))
    rotateDice1 = cc.Sprite:createWithSpriteFrame(frame)
    rotateDice1:pos(display.cx - 20, display.cy + 34 + 15)
    rotateDice1:addTo(wallsLevel)
    rotateDice2 = cc.Sprite:createWithSpriteFrame(frame)
    rotateDice2:pos(display.cx + 20, display.cy + 34 - 15)
    rotateDice2:addTo(wallsLevel)

    baoBgani = display.newSprite("ShYMJ/img_AniBg.png")
    baoBgani:pos(display.cx, display.cy)
    local baozi = display.newSprite("ShYMJ/img_Baozi.png")
    :setAnchorPoint(0.5, 0.5)
    :addTo(baoBgani)
    baozi:pos(baoBgani:getContentSize().width/2, baoBgani:getContentSize().height/2+baozi:getContentSize().height/7)
    baoBgani:hide()

end

function MJWalls:setBganihide()

    if baoBgani ~= nil then
        baoBgani:hide()
    end

end

function MJWalls:showWalls(show, dice1, dice2, direct, majiang)

    if show == true then
        local frames1 = {}
        local frames2 = {}
        for i = 1, 9 do
            frames1[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_dice_rotate%d.png", i))
            frames2[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_dice_rotate%d.png", i))
        end
        frames1[10] = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_dice_normal%d.png", dice1))
        frames2[10] = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_dice_normal%d.png", dice2))

        local animation1 = cc.Animation:createWithSpriteFrames(frames1, 1/15)
        local animate1 = cc.Animate:create(animation1);
        rotateDice1:runAction(cc.Sequence:create(animate1))

        local animation2 = cc.Animation:createWithSpriteFrames(frames2, 1/15)
        local animate2 = cc.Animate:create(animation2);
        rotateDice2:runAction(cc.Sequence:create(animate2))

        local callback = cc.CallFunc:create(
         function()

            if dice1 == dice2 and majiang == "shymj" then

                local callbackex = cc.CallFunc:create(
                    function()
                        if self.callBack ~= nil then
                           self.callBack:showBaozi()
                        end
                    end
                    )

                baoBgani:setOpacity(255)
                baoBgani:show()
                baoBgani:setScale(0)
                baoBgani:pos(display.cx, display.cy)
                local scale1_star = cc.ScaleTo:create(0.4,1.1)
                local scale2_star = cc.ScaleTo:create(0.4,1.0)
                local delay = cc.DelayTime:create(0.8)
                local fadeto = cc.FadeTo:create(0.5,0)
                local scale3 = cc.ScaleTo:create(0.5,0.1)
                local moveto = cc.MoveTo:create(0.5,cc.p(2, display.height-211))
                local spawnAni = cc.Spawn:create(fadeto,scale3,moveto)
                local scale_star = cc.Sequence:create(scale1_star, scale2_star, delay, spawnAni, callbackex)
                baoBgani:runAction(scale_star)
                baoBgani:setCascadeOpacityEnabled(true)

            end

         end)

        local dis = math.random(4)*10
        local divide =  math.random(4) + 1
        if direct == "left" then
            rotateDice1:pos(display.cx - 80, display.cy + 34 + 35)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx-80+30+dis, display.cy + 34 - 115))
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx-80+30+dis+(30+dis)/divide, display.cy+34-115+150/divide)) 
            rotateDice1:runAction(cc.Sequence:create(animate1, animate2))
            rotateDice2:pos(display.cx - 20, display.cy + 34 + 55)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx-20+30+dis, display.cy + 34 - 115)) 
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx-20+30+dis+(30+dis)/divide, display.cy+34-115+170/divide)) 
            rotateDice2:runAction(cc.Sequence:create(animate1, animate2, callback))
        elseif direct == "right" then
            rotateDice1:pos(display.cx + 80, display.cy + 34 - 55)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx+80-30-dis, display.cy + 34 + 115))
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx+80-30-dis-(30+dis)/divide, display.cy+34+115-170/divide)) 
            rotateDice1:runAction(cc.Sequence:create(animate1, animate2))
            rotateDice2:pos(display.cx + 20, display.cy + 34 - 35)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx+20-30-dis, display.cy + 34 + 115)) 
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx+20-30-dis-(30+dis)/divide, display.cy+34+115-150/divide)) 
            rotateDice2:runAction(cc.Sequence:create(animate1, animate2, callback))
        elseif direct == "top" then
            rotateDice1:pos(display.cx + 40, display.cy + 34 + 80)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx-125, display.cy + 34 + 50 - dis))
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx-125+165/divide, display.cy+34+50-dis - (30+dis)/divide)) 
            rotateDice1:runAction(cc.Sequence:create(animate1, animate2))
            rotateDice2:pos(display.cx + 60, display.cy + 34 + 20)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx-125, display.cy + 34 - 10 - dis)) 
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx-125+185/divide, display.cy+34- 10 -dis - (30+dis)/divide)) 
            rotateDice2:runAction(cc.Sequence:create(animate1, animate2, callback))
        else
            rotateDice1:pos(display.cx - 60, display.cy + 34 - 20)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx+125, display.cy + 34 + 10 + dis))
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx+125-185/divide, display.cy+34+10+dis + (30+dis)/divide)) 
            rotateDice1:runAction(cc.Sequence:create(animate1, animate2))
            rotateDice2:pos(display.cx - 40, display.cy + 34 - 80)
            animate1 = cc.MoveTo:create(0.25, cc.p(display.cx+125, display.cy + 34 - 50 + dis)) 
            animate2 = cc.MoveTo:create(0.25, cc.p(display.cx+125-165/divide, display.cy+34- 50 +dis+ (30+dis)/divide)) 
            rotateDice2:runAction(cc.Sequence:create(animate1, animate2, callback))
        end

        local hor = "ShYMJ/img_cardwall_horizontal"
        hor = getUsedSrc(hor)
        hor1:setTexture(hor)
        hor2:setTexture(hor)

        local ver = "ShYMJ/img_cardwall_vertical"
        ver = getUsedSrc(ver)
        ver1:setTexture(ver)
        ver2:setTexture(ver)

        wallsLevel:show()
    else
        wallsLevel:hide()
    end
end

function MJWalls:clear()
    wallsLevel = nil
    rotateDice1 = nil
    rotateDice2 = nil
    baoBgani = nil
    hor1 = nil
    hor2 = nil
    ver1 = nil
    ver2 = nil
end

function MJWalls:restart()
    wallsLevel:hide()
end

function MJWalls:init(callback)
    self.callBack = callback
    if baoBgani ~= nil then
        baoBgani:addTo(self.callBack,99999)
    end
    return self
end

return MJWalls