local scheduler = require("framework.scheduler")
local sound = require("app.Games.TDHMJ.MJSound")

local MJTimer = class("MJTimer",function()
    return display.newSprite()
end)

local progTimer
local fire

function MJTimer:ctor()   
    
end

function MJTimer:setTimer(time, direct)
    local pos_x
    local pos_y
    if direct == nil or direct == "" then
        return
    elseif direct == "left" then
        pos_x = 80
        pos_y = display.cy
    elseif direct == "right" then
        pos_x = display.width - 80
        pos_y = display.cy
    elseif direct == "top" then
        pos_x = 280
        pos_y = display.height - 100
    elseif direct == "bottom"  then
        pos_x = 80
        pos_y = 100
    end
    self:clearTime()
    self:timeStart(time)
    progTimer:setPosition(cc.p(pos_x,pos_y))
end

function MJTimer:timeStart(total_time,left_time)
    print("lefttime:" .. tostring(left_time))
    left_time = left_time or total_time
    local per = left_time / total_time * 100
    progTimer = display.newProgressTimer("ShYMJ/head_top.png",display.PROGRESS_TIMER_RADIAL)
    progTimer:setReverseDirection(true)
    progTimer:setPercentage(per)
    --progTimer:setPosition(cc.p(70,93))
    self:addChild(progTimer,101)

    local label_time = cc.LabelAtlas:_create()
    label_time:initWithString(
        tostring(left_time),
        "ShYMJ/timer_number.png",
        22,
        30,
        string.byte('0'))
    label_time:setAnchorPoint(cc.p(0.5,0.5))
    label_time:setPosition(cc.p(70,108))
    label_time:setString(tostring(left_time))
    progTimer:addChild(label_time)
    label_time.time = left_time

    local pt = cca.progressTo(left_time,0)
    transition.execute(progTimer, pt, {
        delay = 0,
        easing = nil,
        onComplete = function()
            self:clearTime()
        end,
    })

    self.handle_lefttime = scheduler.scheduleGlobal(function()
        label_time.time = label_time.time - 1
        label_time:setString(tostring(label_time.time))
    end,1.0)

    local move_point = {cc.p(70,181),cc.p(135,181),cc.p(135,5),cc.p(5,5),cc.p(5,181),cc.p(70,181)}
    fire = display.newSprite("common/huohua/01.png")
    fire:setPosition(move_point[1])
    progTimer:addChild(fire)

    local seq = cc.Sequence:create(
        cc.MoveTo:create(total_time / 8, move_point[2]),
        cc.MoveTo:create(total_time / 4, move_point[3]),
        cc.MoveTo:create(total_time / 4, move_point[4]),
        cc.MoveTo:create(total_time / 4, move_point[5]),
        cc.MoveTo:create(total_time / 8, move_point[6])
        )

    local animation = cc.Animation:create()
    for i=1,16 do
        local texture = cc.Director:getInstance():getTextureCache():addImage(string.format("common/huohua/%02d.png",i))
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 72, 77))
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(0.06)
    local animate = cc.Animate:create(animation)

    --bug:cc.RepeatForever和cc.Spawn冲突？
    fire:runAction(seq)
    fire:runAction(cc.RepeatForever:create(animate))
end

function MJTimer:clearTime()
    if fire then
        fire:stopAllActions()
    end
    if progTimer then
        progTimer:stopAllActions()
        progTimer:removeFromParent()
        progTimer = nil
        fire = nil
    end
    if self.handle_lefttime then
        scheduler.unscheduleGlobal(self.handle_lefttime)
        self.handle_lefttime = nil
    end
end

function MJTimer:clear()
    self:clearTime()
end

function MJTimer:restart()
    print("MJTimer:restart")
    self:clearTime()
end

function MJTimer:init(callback)
    self.callBack = callback
    return self
end


return MJTimer