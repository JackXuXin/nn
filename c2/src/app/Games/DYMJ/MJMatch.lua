local MJMatch = class("MJMatch",function()
    return display.newNode()
end)

local web = require("app.net.web")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomConfig = require("app.config.RoomConfig")
local msgMgr = require("app.room.msgMgr")

local PlatConfig = require("app.config.PlatformConfig")

local nodeLeftTime = nil
local nodeTip = nil

local nodeOut = nil
local nodeResult = nil

local rankLabel = nil

local nodeCancel = nil

local leftTime = nil
local startTime = nil

local tempCount = 0

function MJMatch:ctor()
    print("MJMatch:ctor")

    rankLabel = cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 26, 
        text = ""
    })
    :addTo(self)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(10,678.5)
end

function MJMatch:init(callback)
    self.callback = callback
end

function MJMatch:removeAll()
    if nodeLeftTime then
        nodeLeftTime:removeFromParent()
        nodeLeftTime = nil
    end
    if self.handler then
        scheduler.unscheduleGlobal(self.handler)
        self.handler = nil
    end

    if nodeTip then
        nodeTip:removeFromParent()
        nodeTip = nil
    end
    if nodeOut then
        nodeOut:removeFromParent()
        nodeOut = nil
    end
    if nodeResult then
        nodeResult:removeFromParent()
        nodeResult = nil
    end
    if rankNode then
        rankNode:removeFromParent()
        rankNode = nil
    end
    if nodeCancel then
        nodeCancel:removeFromParent()
        nodeCancel = nil
    end
end

function MJMatch:showCancel()
    nodeCancel = display.newScale9Sprite("Image/Match/textbg_2.png", 3, 3, cc.size(1280, 400))
    nodeCancel:setPosition(640,360)
    self:addChild(nodeCancel)

    cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 30, 
        text = "参赛人数不足，比赛取消！", 
    })
    :addTo(nodeCancel)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(640,300)

    cc.ui.UIPushButton.new({ normal = "Image/Public/Button_ConfirmRed_0.png", pressed = "Image/Public/Button_ConfirmRed_1.png" })
    :onButtonClicked(function()
        print("ok")
        app:enterScene("LobbyScene", nil, "fade", 0.5)

     end)
    :pos(640,150)
    :addTo(nodeCancel)
end

function MJMatch:showState(state,rank,gold,reward,rewardType)
    self:removeAll()
    print("showState11-------")
    if state == 1 then
        self:showTip("准备分桌，等待其他玩家结束游戏...")
    elseif state == 2 then
        self:showTip("准备晋级，等待其他玩家结束游戏...")
    elseif state == 4 then
        self:showOut(rank,gold,reward)
    elseif state == 8 then
        self:showTip("恭喜您，晋级成功！")
    elseif state == 16 then
        self:showResult(rank,reward,rewardType)
    end
end

function MJMatch:updateRank(rank,totalRank)
    -- body
    rankLabel:setString("比赛排名：" .. rank .. "/" .. totalRank)
    
end

function MJMatch:showResult(rank,reward,rewardType)
    nodeResult = display.newScale9Sprite("Image/Match/textbg_2.png", 3, 3, cc.size(1280, 400))
    nodeResult:setPosition(640,360)
    self:addChild(nodeResult)

    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 38, 
        text = "您在本场比赛中获得", 
    })
    :addTo(nodeResult)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(420,350)

    cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 38, 
        text = "第" .. rank .. "名！", 
    })
    :addTo(nodeResult)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(765,350)

    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 25, 
        text = "恭喜获得以下奖励：", 
    })
    :addTo(nodeResult)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(420,310)

    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 25, 
        text = tostring(reward)
    })
    :addTo(nodeResult)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(420,260)

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)

    local wchatService = "请联系客服微信：" .. platConfig.public_id .. "领取奖品"

    if rewardType ~= "gold" then
        cc.ui.UILabel.new({
            color = cc.c3b(233,167,132), 
            size = 25, 
            text = wchatService, 
        })
        :addTo(nodeResult)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(720,260)
    end

    cc.ui.UIPushButton.new({ normal = "Image/Public/Button_ConfirmRed_0.png", pressed = "Image/Public/Button_ConfirmRed_1.png" })
    :onButtonClicked(function()
        print("ok")
        app:enterScene("LobbyScene", nil, "fade", 0.5)
    end)
    :pos(640,150)
    :addTo(nodeResult)
end

function MJMatch:showOut(rank,gold,reward)
    nodeOut = display.newScale9Sprite("Image/Match/textbg_2.png", 3, 3, cc.size(1280, 400))
    nodeOut:setPosition(640,360)
    self:addChild(nodeOut)

    cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 30, 
        text = "很遗憾，您的排名未能进入下一轮，请再接再厉！", 
    })
    :addTo(nodeOut)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(640,300)

    if reward then
        cc.ui.UILabel.new({
            color = cc.c3b(233,167,132), 
            size = 25, 
            text = "获得以下奖励：", 
        })
        :addTo(nodeOut)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(420,260)

        cc.ui.UILabel.new({
            color = cc.c3b(233,167,132), 
            size = 25, 
            text = tostring(reward)
        })
        :addTo(nodeOut)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(420,210)
    end

    cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 24, 
        text = "目前排名：".. rank .. ",积分：" .. gold, 
    })
    :addTo(nodeOut)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(640,60)

    cc.ui.UIPushButton.new({ normal = "Image/Public/Button_ConfirmRed_0.png", pressed = "Image/Public/Button_ConfirmRed_1.png" })
    :onButtonClicked(function()
        print("ok")
        app:enterScene("LobbyScene", nil, "fade", 0.5)

     end)
    :pos(640,150)
    :addTo(nodeOut)
end

function MJMatch:showMatchStart()
    self:showTip("比赛开始！")
end

function MJMatch:removeMatchStart()
    self:removeTip()
end

function MJMatch:showNext()
    self:showTip("恭喜你进入下一轮！")
end

function MJMatch:removeNext()
    self:removeTip()
end

function MJMatch:showRank()
    self:showTip("本轮比赛结束，系统进行排名中...")
end

function MJMatch:removeRank()
    self:removeTip()
end

function MJMatch:showWait()
    self:showTip("请稍等，系统配桌中...")
end

function MJMatch:removeWait()
    self:removeTip()
end

function MJMatch:showTip(str)
    -- body
    self:removeAll()

    nodeTip = display.newSprite("Image/Match/textbg_1.png")
    nodeTip:setPosition(640,360)
    self:addChild(nodeTip)

    cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 30, 
        text = str, 
    })
    :addTo(nodeTip)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(640,50)
end

function MJMatch:removeTip()
    if nodeTip then
        nodeTip:removeFromParent()
        nodeTip = nil
    end
end

function MJMatch:showLeftTime(matchid,signCount)
    print("showLeftTime")
    self:removeAll()
    for _,config in ipairs(RoomConfig) do
        if not startTime and config.matchroom then
            --print("matchid:" .. matchid)
            --dump(config.matchroom)
            for _,v in pairs(config.matchroom) do
                if v.matchid == matchid then
                    startTime = {}
                    startTime.startHour = v.startHour
                    startTime.startMinute = v.startMinute
                    break
                end
            end
        end
    end

    -- startTime = {}
    -- startTime.startHour = 11
    -- startTime.startMinute = 33

    print("startHour:" .. startTime.startHour .. ",startMinute:" .. startTime.startMinute)

    nodeLeftTime = display.newSprite("Image/Match/textbg_1.png")
    nodeLeftTime:setPosition(640,360)
    self:addChild(nodeLeftTime)

    tempCount = signCount
    web.getServerTime(function (time)
        leftTime = time

        nodeLeftTime.labelTime = cc.ui.UILabel.new({
            color = cc.c3b(255,6,0), 
            size = 30, 
            text = "", 
        })
        :addTo(nodeLeftTime)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(570,50)

        cc.ui.UILabel.new({
            color = cc.c3b(255,255,255), 
            size = 30, 
            text = "比赛将在", 
        })
        :addTo(nodeLeftTime)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(443,50)

        cc.ui.UILabel.new({
            color = cc.c3b(255,255,255), 
            size = 30, 
            text = "后开始，当前报名人数：", 
        })
        :addTo(nodeLeftTime)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(795,50)
        print("jjjj")
        nodeLeftTime.labelSingup = cc.ui.UILabel.new({
            color = cc.c3b(255,6,0), 
            size = 30, 
            text = tostring(tempCount), 
        })
        :addTo(nodeLeftTime)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(965,50)

        self:updateLeftTime()
        print("hhhjjjdddd")
        self.handler = scheduler.scheduleGlobal(function()
            --print("leftTime:" .. tostring(leftTime))
            leftTime = leftTime + 1
            self:updateLeftTime()
        end, 1.0)

    end)
end

function MJMatch:updateLeftTime()

    local servertime = os.date("*t", leftTime)
    local s = os.time({year=servertime.year, month=servertime.month, day=servertime.day,hour = startTime.startHour,min = startTime.startMinute,sec = 0})

    local diff = os.difftime(s,leftTime)
    --print("diff:" .. diff)
    if diff == 0 then
        if self.handler then
            scheduler.unscheduleGlobal(self.handler)
            self.handler = nil
        end
        nodeLeftTime.labelTime:setString("00:00:00")
    else
        local left = string.format("%02d:%02d:%02d", math.floor(diff/(60*60)), math.floor((diff/60)%60), diff%60)
        nodeLeftTime.labelTime:setString(left)
    end
end

function MJMatch:updateSingup(count)
    print("count:" .. count)
    print("1:" .. type(nodeLeftTime))
    tempCount = count
    if nodeLeftTime and nodeLeftTime.labelSingup then
        print("count22:" .. count)
        nodeLeftTime.labelSingup:setString(tostring(count))
    end
end

function MJMatch:removeLeftTime()
    if nodeLeftTime then
        if self.handler then
            scheduler.unscheduleGlobal(self.handler)
            self.handler = nil
        end

        nodeLeftTime:removeFromParent()
        nodeLeftTime = nil
    end
end

function MJMatch:clear()
    print("MJMatch:clear1111")
    if self.handler then
        print("MJMatch:clear")
        scheduler.unscheduleGlobal(self.handler)
        self.handler = nil
    end
    self:removeAll()

    leftTime = nil
    startTime = nil

    tempCount = 0

    msgMgr:resetMatch()
end

return MJMatch