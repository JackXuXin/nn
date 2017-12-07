local MJBackground = class("MJBackground",function()
    return display.newSprite()
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local shymjIcon
local shzhmjIcon
local shxmjIcon

local bottomBg = nil
local light1 = nil
local light2 = nil
local light3 = nil
local light4 = nil

local pointNumber1
local pointNumber2


function MJBackground:ctor()
    shymjIcon = display.newSprite("ShYMJ/ShyRes/game_bg.png")
    :pos(display.cx, display.cy)
    :addTo(self)


    shxmjIcon = display.newSprite("ShYMJ/ShyRes/game_bg2.png")
    :pos(display.cx, display.cy)
    :addTo(self)

    shzhmjIcon = display.newSprite("ShYMJ/ShyRes/game_bg3.png")
    :pos(display.cx, display.cy)
    :addTo(self)

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_BottomBg.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 141, 139))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_BottomBg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_Glight1.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 263, 490))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_Glight1.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_Glight2.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 491, 263))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_Glight2.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_Glight3.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 263, 490))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_Glight3.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_Glight4.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 491, 263))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_Glight4.png")

    bottomBg = display.newSprite("#ShYMJ/img_BottomBg.png")
    :pos(display.cx, display.cy+25)
    :hide()
    :addTo(self)

    --local texture = bottomBg:getTexture()
    --local sizeImg = texture:getContentSize()
    -- light1 = display.newSprite("ShYMJ/img_Glight1.png")
    -- :pos(sizeImg.width/2, sizeImg.height/2)
    -- :setAnchorPoint(0.5,1)
    -- :hide()
    -- :addTo(bottomBg)

    -- light2 = display.newSprite("ShYMJ/img_Glight2.png")
    -- :pos(sizeImg.width/2, sizeImg.height/2)
    -- :setAnchorPoint(0,0.5)
    -- :hide()
    -- :addTo(bottomBg)

    -- light3 = display.newSprite("ShYMJ/img_Glight3.png")
    -- :pos(sizeImg.width/2, sizeImg.height/2)
    -- :setAnchorPoint(0.5,0)
    -- :hide()
    -- :addTo(bottomBg)

    -- light4 = display.newSprite("ShYMJ/img_Glight4.png")
    -- :pos(sizeImg.width/2, sizeImg.height/2)
    -- :setAnchorPoint(1,0.5)
    -- :hide()
    -- :addTo(bottomBg)

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ShyRes/LaoZhuang.png")
    for i = 1, 2 do
        for j = 1, 6 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(28*(j-1), 28*(i-1), 28, 28))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/LaoZhuang%d.png", (i-1)*6+j))
        end
    end

    pointNumber1 = display.newSprite("#ShYMJ/LaoZhuang7.png")
    :pos(display.cx, display.cy+25+15)
    :hide()
    :addTo(self)

    pointNumber2 = display.newSprite("#ShYMJ/LaoZhuang1.png")
    :pos(display.cx, display.cy+25-15)
    :hide()
    :addTo(self)

end

function MJBackground:showInfo()
    pointNumber1:show()
    pointNumber2:show()
end

function MJBackground:setPoints(point1, point2)
    if point1 > 0 and point1 < 7 then
        pointNumber1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", 6+point1)))
    else
        pointNumber1:hide()
    end

    if point2 > 0 and point2 < 7 then
        pointNumber2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/LaoZhuang%d.png", point2)))
    else
        pointNumber2:hide()
    end
    --rightPanel:show()
end

function MJBackground:setBottomBg(seat, maxPlayer)

    print("seat = ,maxPlayer,",seat ,maxPlayer)

    local curAngle = 0

    if maxPlayer == 2 then

        if seat == 2 then

            bottomBg:setRotation(180)
            curAngle = 180

        end

    else

        if seat == 2 then

            bottomBg:setRotation(90)
            curAngle = 90

        elseif seat == 3 then

            bottomBg:setRotation(180)
            curAngle = 180

        elseif seat == 4 then

            bottomBg:setRotation(-90)
            curAngle = -90

        end

    end

    if curAngle ~= 0 then
        light1:setRotation(curAngle)
        light2:setRotation(curAngle)
        light3:setRotation(curAngle)
        light4:setRotation(curAngle)
    end

end

function MJBackground:setShowLight(outSeat, maxPlayer)

    print("outSeat = ,maxPlayer,",outSeat ,maxPlayer)

    if light1 == nil or light2 == nil or light3 == nil or light4 == nil  then
        return
    end

    if outSeat == 0 then
        -- light1:hide()
        -- light2:hide()
        -- light3:hide()
        -- light4:hide()
        return
    end

    light1:hide()
    light2:hide()
    light3:hide()
    light4:hide()

    if maxPlayer == 2 then

        if outSeat == 2 then
            light3:show()
        else
            light1:show()
        end

    else

        if outSeat == 2 then

            light2:show()

        elseif outSeat == 3 then

            light3:show()

        elseif outSeat == 4 then

            light4:show()

        else

            light1:show()

        end

    end
end

function MJBackground:setLight(direct, isConect, seat, outSeat, maxPlayer)

    if bottomBg == nil then
        return
    end

    if bottomBg:isVisible() == false then

        self:setBottomBg(seat, maxPlayer)
       
        if isConect == true then
            bottomBg:show()
            self:setShowLight(outSeat, maxPlayer)
        else
            scheduler.performWithDelayGlobal(
            function()
                bottomBg:show()
                self:setShowLight(outSeat, maxPlayer)
            end, 0.5)
        end
    else
        if outSeat == 5 then
            self:setShowLight(seat, maxPlayer)
        else
            self:setShowLight(outSeat, maxPlayer)
        end
    end

    print("seat = ",seat ,direct, outSeat)

end

function MJBackground:setMajiang(key)

	if key == "shymj" then
        shxmjIcon:hide()
		shymjIcon:show()
        shzhmjIcon:hide()
    elseif key == "shzhmj" then
        shzhmjIcon:show()
        shxmjIcon:hide()
        shymjIcon:hide()
    else
        shxmjIcon:show()
        shymjIcon:hide()
        shzhmjIcon:hide()
	end
	
end

function MJBackground:clear()
    shymjIcon = nil
    shxmjIcon = nil
    shzhmjIcon = nil

    bottomBg = nil
    light1 = nil
    light2 = nil
    light3 = nil
    light4 = nil

    pointNumber1 = nil
    pointNumber2 = nil
end

function MJBackground:restart()
    
    bottomBg:hide()
    light1:hide()
    light2:hide()
    light3:hide()
    light4:hide()
    pointNumber1:hide()
    pointNumber2:hide()

end

function MJBackground:init(callback)

    self.callBack = callback
    light1 = display.newSprite("ShYMJ/img_Glight1.png")
    :pos(display.cx, display.cy+25)
    :setAnchorPoint(0.5,1)
    :hide()
    :addTo(callback,1)

    light2 = display.newSprite("ShYMJ/img_Glight2.png")
    :pos(display.cx, display.cy+25)
    :setAnchorPoint(0,0.5)
    :hide()
    :addTo(callback,1)

    light3 = display.newSprite("ShYMJ/img_Glight3.png")
    :pos(display.cx, display.cy+25)
    :setAnchorPoint(0.5,0)
    :hide()
    :addTo(callback,1)

    light4 = display.newSprite("ShYMJ/img_Glight4.png")
    :pos(display.cx, display.cy+25)
    :setAnchorPoint(1,0.5)
    :hide()
    :addTo(callback,1)

    if shymjIcon ~= nil then
        shymjIcon:setTouchEnabled(true)
        shymjIcon:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                self.callBack:HideAllhua()
                return true
            end
        end)
    end

    return self
end

return MJBackground