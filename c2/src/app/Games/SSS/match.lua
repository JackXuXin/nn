local SSSScene = package.loaded["app.scenes.SSSScene"] or {}

local web = require("app.net.web")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomConfig = require("app.config.RoomConfig")
local msgMgr = require("app.room.msgMgr")
local util = require("app.Common.util")

local PlatConfig = require("app.config.PlatformConfig")

local _leftTime = nil
local _startTime = nil
local _matchScore = 0

function SSSScene:showMatch()
    local matchLayer = cc.uiloader:load("Layer/Game/SSS/MatchLayer.json")

    self.match = matchLayer
    self.match.nd_info = cc.uiloader:seekNodeByNameFast(matchLayer, "nd_info")
    self.match.nd_time = cc.uiloader:seekNodeByNameFast(matchLayer, "nd_time"):hide()
    self.match.nd_cancel = cc.uiloader:seekNodeByNameFast(matchLayer, "nd_cancel"):hide()
    self.match.nd_tip = cc.uiloader:seekNodeByNameFast(matchLayer, "nd_tip"):hide()
    self.match.nd_out = cc.uiloader:seekNodeByNameFast(matchLayer, "nd_out"):hide()
    self.match.nd_result = cc.uiloader:seekNodeByNameFast(matchLayer, "nd_result"):hide()

    cc.uiloader:seekNodeByNameFast(matchLayer, "img_cancel_bg"):setLayoutSize(1280, 400)
    cc.uiloader:seekNodeByNameFast(matchLayer, "img_out_bg"):setLayoutSize(1280, 400)
    cc.uiloader:seekNodeByNameFast(matchLayer, "img_result_bg"):setLayoutSize(1280, 400)

    self.match.nd_info.labelRank = cc.uiloader:seekNodeByNameFast(self.match.nd_info, "tx_rank")
    self:setDelayTime(cc.uiloader:seekNodeByNameFast(self.match.nd_info, "img_match_Info"))
    self.match.nd_info.labelMatchScore = cc.uiloader:seekNodeByNameFast(self.match.nd_info, "tx_match_score"):hide()

    self.match.nd_time.lableTime = cc.uiloader:seekNodeByNameFast(self.match.nd_time, "tx_time")
    self.match.nd_time.labelSingup = cc.uiloader:seekNodeByNameFast(self.match.nd_time, "tx_player_num")

    self.match.nd_tip.labelTip = cc.uiloader:seekNodeByNameFast(self.match.nd_tip, "tx_tip")

    self.match.nd_out.labelReward = cc.uiloader:seekNodeByNameFast(self.match.nd_out, "tx_reward")
    self.match.nd_out.labelInfo = cc.uiloader:seekNodeByNameFast(self.match.nd_out, "tx_info")
    self.match.nd_out.labelInfo = cc.uiloader:seekNodeByNameFast(self.match.nd_out, "tx_info")

    self.match.nd_result.labelReward = cc.uiloader:seekNodeByNameFast(self.match.nd_result, "tx_reward")
    self.match.nd_result.labelRank = cc.uiloader:seekNodeByNameFast(self.match.nd_result, "tx_rank")
    self.match.nd_result.labelWechat = cc.uiloader:seekNodeByNameFast(self.match.nd_result, "tx_wechat")

    local function onBackScene()
        msgMgr:resetMatch()
        app:enterScene("LobbyScene", nil, "fade", 0.5)
    end

    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(self.match.nd_cancel, "btn_confirmRed"))
        :onButtonClicked(onBackScene)

    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(self.match.nd_result, "btn_confirmRed"))
        :onButtonClicked(onBackScene)

    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(self.match.nd_out, "btn_confirmRed"))
        :onButtonClicked(onBackScene)

    local nd_drop_bar = cc.uiloader:seekNodeByNameFast(self.scene,"nd_drop_bar")
    cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_dissolution_bar"):hide()
    cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_exit"):hide()
    cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_ruleBtn"):hide()
    cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_exit_match"):show()

    -- local ExitTipLayer = cc.uiloader:seekNodeByNameFast(self.scene, "ExitTipLayer")
    -- cc.uiloader:seekNodeByNameFast(ExitTipLayer, "tx_info"):setString("确定要退出比赛？")

    self.match:addTo(self.scene,1000)
end

function SSSScene:resetMatch()
    if self.match then
        self:hideLeftTime()
        self:setShowMatchTip(false)
    end
end

function SSSScene:showLeftTime(matchid,signCount)
    print("showLeftTime---", matchid)

    self.match.nd_time:show()

    for _,config in ipairs(RoomConfig) do
        if config.matchroom then
            --print("matchid:" .. matchid)
            for _,v in pairs(config.matchroom) do
                if v.matchid == matchid then
                    _startTime = {}
                    _startTime.startHour = v.startHour
                    _startTime.startMinute = v.startMinute
                    break
                end
            end
        end
    end

    web.getServerTime(function (time)
        _leftTime = time
        self:updateLeftTime()
        self.match.nd_time:schedule(function()
            _leftTime = _leftTime + 1
            self:updateLeftTime()
        end, 1.0)

    end)
end

function SSSScene:hideLeftTime()
    print("hideLeftTime---")
    if self.match then
        self.match.nd_time:stopAllActions()
        self.match.nd_time:hide()
    end
end

function SSSScene:updateLeftTime()
    local servertime = os.date("*t", _leftTime)
    local s = os.time({year=servertime.year, month=servertime.month, day=servertime.day,hour = _startTime.startHour,min = _startTime.startMinute,sec = 0})

    local diff = os.difftime(s,_leftTime)
    
    if diff <= 0 then
        self.match.nd_time.lableTime:setString("00:00:00")
    else
        local left = string.format("%02d:%02d:%02d", math.floor(diff/(60*60)), math.floor((diff/60)%60), diff%60)
        self.match.nd_time.lableTime:setString(left)
    end
end

function SSSScene:updateSingup(count)
    self.match.nd_time.labelSingup:setString(tostring(count))
end


function SSSScene:setShowMatchTip(flag, text)
    if text then
        self.match.nd_tip.labelTip:setString(text)
    end

    self.match.nd_tip:setVisible(flag)
end

function SSSScene:setShowCancel(flag)
    self.match.nd_cancel:setVisible(flag)
end

function SSSScene:updateRank(rank, totalRank)
    self.match.nd_info.labelRank:setString(rank .. "/" .. totalRank)
end

function SSSScene:showState(state, rank, gold, reward, rewardType)
    self:resetMatch()
    if state == 1 then
        self:setShowMatchTip(true, "准备分桌，等待其他玩家结束游戏...")
    elseif state == 2 then
        self:setShowMatchTip(true, "准备晋级，等待其他玩家结束游戏...")
    elseif state == 4 then
        self:setShowOut(true, rank, gold, reward)
    elseif state == 8 then
        self:setShowMatchTip(true, "恭喜您，晋级成功！")
    elseif state == 16 then
        self:setShowResult(true, rank, reward, rewardType)
    end
end

function SSSScene:setShowOut(flag, rank, gold, reward)
    if reward == "" then
        cc.uiloader:seekNodeByNameFast(self.match.nd_out, "Text_5"):hide()
    end

    --奖励
    if reward then
        self.match.nd_out.labelReward:setString(reward)
    end

    --排名 积分
    if gold and reward then
        self.match.nd_out.labelInfo:setString("目前排名：".. rank)
    end

    self.match.nd_out:setVisible(flag)
end

function SSSScene:setShowResult(flag, rank, reward, rewardType)
    --排名
    if rank then
        self.match.nd_result.labelRank:setString("第" .. rank .. "名！")
    end

    --奖励
    if reward then
        self.match.nd_result.labelReward:setString(reward)
    end

    self.match.nd_result:setVisible(flag)
end

--设置比赛分数显示状态
function SSSScene:setMatchScoreShowState(flag)
    self.match.nd_info.labelMatchScore:setVisible(flag)
end

--刷新比赛分数
function SSSScene:updateMatchScore(score, flag)
    if flag then
        _matchScore = score
    else
        _matchScore = _matchScore + score
    end
    self.match.nd_info.labelMatchScore:setString("分数：" .. _matchScore .. "分")
end

function SSSScene:clearMatch()
    self:resetMatch()
end

return SSSScene