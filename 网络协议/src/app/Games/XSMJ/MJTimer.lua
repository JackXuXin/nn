local scheduler = require("framework.scheduler")
local sound = require("app.Games.XSMJ.MJSound")

local MJTimer = class("MJTimer",function()
    return display.newSprite()
end)

local background
local directSprite
local highSprite
local lowSprite

local handleScheduler = nil

local numberVal = 0

local sandglass

function MJTimer:ctor()   
    background = display.newSprite("ShYMJ/img_element_gamecenterbg.png")
    :pos(display.cx, display.cy + 34)
    :addTo(self)
    :hide()
    
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_dir_0.png")
    local rect = cc.rect(0, 0, 79, 109)
    local frame0 = cc.SpriteFrame:createWithTexture(texture, rect)
    rect = cc.rect(80, 0, 79, 109)
    local frame1 = cc.SpriteFrame:createWithTexture(texture, rect)
    rect = cc.rect(160, 0, 79, 109)
    local frame2 = cc.SpriteFrame:createWithTexture(texture, rect)
    rect = cc.rect(240, 0, 79, 109)
    local frame3 = cc.SpriteFrame:createWithTexture(texture, rect)

    directSprite = cc.Sprite:createWithSpriteFrame(frame0)
    -- directSprite:hide()
    directSprite:addTo(background)

    local animation = cc.Animation:createWithSpriteFrames({frame1,frame2,frame3}, 0.15)
    local animate = cc.Animate:create(animation);
    directSprite:runAction(cc.RepeatForever:create(animate))
    
    for i=0, 9 do
        local texture = cc.Director:getInstance():getTextureCache():addImage(string.format("ShYMJ/img_gameelemt_symj%d.png", i))
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 25, 33))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_gameelemt_symj%d.png", i))
    end
    
    highSprite = display.newSprite()
    highSprite:pos(38-10, 38)
    highSprite:addTo(background)

    lowSprite = display.newSprite()
    lowSprite:pos(38+10, 38)
    lowSprite:addTo(background)


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_card_shalou.png")
    local frames = {}
    for i = 1, 12 do
        frames[i] = cc.SpriteFrame:createWithTexture(texture, cc.rect((i-1)*68, 0, 68, 68))
    end
    sandglass = cc.Sprite:createWithSpriteFrame(frames[1])
    sandglass:pos(display.cx, display.cy + 34)
    sandglass:addTo(self)
    sandglass:hide()

    animation = cc.Animation:createWithSpriteFrames(frames, 2/12)
    animate = cc.Animate:create(animation);
    sandglass:runAction(cc.RepeatForever:create(animate))
end

function MJTimer:setTimer(time, direct)
    sandglass:hide()   
    if direct == "left" then
        directSprite:setRotation(90)
        directSprite:setPosition(-48, 42)
        directSprite:show()
        self:startTick(time)
        background:show()
    elseif direct == "right" then
        directSprite:setRotation(270)
        directSprite:setPosition(122, 38)
        directSprite:show()
        self:startTick(time)
        background:show()
    elseif direct == "top" then
        directSprite:setRotation(180)
        directSprite:setPosition(40, 124)
        directSprite:show()
        self:startTick(time)
        background:show()
    elseif direct == "bottom" then
        directSprite:setRotation(0)
        directSprite:setPosition(36, -42)
        directSprite:show()
        self:startTick(time)
        background:show()
    else
        directSprite:hide()
        self:startTick(time)
        background:show()
    end
end

function MJTimer:setSandglass()
    self:startTick(nil)
    background:hide()
    sandglass:show()
end

function MJTimer:clearTime()
    self:startTick(nil)
    background:hide()
    sandglass:hide()
end

function MJTimer:onTick()
    numberVal = numberVal - 1  
    highSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_gameelemt_symj%d.png", math.floor(numberVal/10))))
    lowSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_gameelemt_symj%d.png", numberVal%10)))
    if numberVal < 6 then
        sound.timeTick()
    end
    if numberVal == 0 then
        scheduler.unscheduleGlobal(handleScheduler)
        handleScheduler = nil
    end
end
        
function MJTimer:startTick(val)    
    if handleScheduler ~= nil then
        scheduler.unscheduleGlobal(handleScheduler)
        handleScheduler = nil
    end
   
    numberVal = val
    
    if numberVal == nil then
        highSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_gameelemt_symj%d.png", 0)))
        lowSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_gameelemt_symj%d.png", 0)))
    elseif numberVal >= 0 then
        highSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_gameelemt_symj%d.png", math.floor(numberVal/10))))
        lowSprite:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("ShYMJ/img_gameelemt_symj%d.png", numberVal%10)))
        if numberVal > 0 then
            handleScheduler = scheduler.scheduleGlobal(function()
                self:onTick() 
            end, 1.0)
        end
    end
end

function MJTimer:clear()
    if handleScheduler ~= nil then
        scheduler.unscheduleGlobal(handleScheduler)
        handleScheduler = nil
    end

    background = nil
    directSprite = nil
    highSprite = nil
    lowSprite = nil
    sandglass = nil
end

function MJTimer:restart()
    self:clearTime()
end

function MJTimer:init(callback)
    self.callBack = callback
    return self
end

return MJTimer