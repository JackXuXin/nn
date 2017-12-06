local DYMJScene = class("DYMJScene", function()
    return display.newScene("DYMJScene")
end)

local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")
local sound = require("app.Games.DYMJ.MJSound")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")

local util = require("app.Common.util")

--local MatchMessage = require("app.net.MatchMessage")

local backGround
local cardWalls
local topCards
local leftCards
local rightCards
local bottomCards
local outCards
local playersInfo
local directTimer
local huResult
local settingPanel
local matchNode

local max_player

local msgIndex = 0

local seatIndex = 0

local tableSession = 0
local matchSession = 0

local dragonCard

local watchingGame = false
local managerGame = false
local isRestart = false

local majiang = ""
local baseScore = 0

-- local matchid = nil
-- local tempSingnCount = 0
-- local isMatchInit = false
-- local isMatchStatus = false

function DYMJScene:ctor()
    print("DYMJScene:ctor")
    sound.init()

    backGround = require("app.Games.DYMJ.MJBackground").new()
    :addTo(self)
    :init(self) 
    
    cardWalls = require("app.Games.DYMJ.MJWalls").new()
    :addTo(self)
    :init(self) 
    
    topCards = require("app.Games.DYMJ.MJTopCards").new()
    :addTo(self)
    :init(self) 
    
    leftCards = require("app.Games.DYMJ.MJLeftCards").new()
    :addTo(self)
    :init(self) 
    
    rightCards = require("app.Games.DYMJ.MJRightCards").new()
    :addTo(self)
    :init(self) 
    
    bottomCards = require("app.Games.DYMJ.MJBottomCards").new()
    :addTo(self)
    :init(self)
    
    playersInfo = require("app.Games.DYMJ.MJPlayers").new()
    :addTo(self)
    :init(self)

    outCards = require("app.Games.DYMJ.MJOutCard").new()
    :addTo(self)
    :init(self) 

    directTimer = require("app.Games.DYMJ.MJTimer").new()
    :addTo(self)
    :init(self)
    
    huResult = require("app.Games.DYMJ.MJResult").new()
    :addTo(self)
    :init(self)

    matchNode = require("app.Games.DYMJ.MJMatch").new()
    :addTo(self)

    settingPanel = require("app.Games.DYMJ.MJSetting").new()
    :addTo(self)
    :init(self)

    msgWorker.init("DYMJ", handler(self, self.dispatchMessage))

    print("ycScene0000000-----")

     if util.UserInfo.watching == false then

        print("ycScene-----")

         -- 设置语音聊天按钮
         -- util.SetVoiceBtn(self,settingPanel)


         print("ycScene2222222----")

    end
end

function DYMJScene:onEnter()
end

function DYMJScene:onExit()
    self:clearScene()
end

function DYMJScene:onStart()
    if not watchingGame then
        message.dispatchGame("room.ReadyReq", {})
    end
end

function DYMJScene:onLeave()
    -- if matchid then
    --     print("ts:" .. matchSession)
    --     MatchMessage.LeaveMatchReq(matchSession)
    -- else
        message.dispatchGame("room.LeaveGame", {})
    -- end
end

function DYMJScene:onSound(open)
    
end

function DYMJScene:onRestart()
    self:restart()
    if not watchingGame then
        if tableSession == 0 or seatIndex == 0 then
            errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
                self:onLeave()
            end):addTo(self)
            return 
        end
        message.sendMessage("DYMJ.Ready", {session=tableSession})
        isRestart = true
    end
end

function DYMJScene:onOutCard(card)
    message.sendMessage("DYMJ.OutCard", {session=tableSession, seat=0, card=card})
end

function DYMJScene:onCombinCard(combin, card)
    message.sendMessage("DYMJ.CombinCard", {session=tableSession, seat=0, combin={combin=combin, card=card, out=0}})
end

function DYMJScene:onHuCard()
    message.sendMessage("DYMJ.HuCard", {session=tableSession})
end

function DYMJScene:onIgnoreCard()
    message.sendMessage("DYMJ.IgnoreCard", {session=tableSession})
end

function DYMJScene:getDragonCard()
    return dragonCard
end

function DYMJScene:getMajiang()
    return majiang
end

function DYMJScene:onOutedCard(card, seat)
    local direct = self:getDirectCards(seat)
    if direct ~= nil then
        direct:addOut(card, max_player)
    end
end

function DYMJScene:onCanelManager(card, seat)
    message.sendMessage("DYMJ.Managed", {session=tableSession, seat=0, state=0})
end

function DYMJScene:onSelectInfo(select)
    message.sendMessage("DYMJ.SelectInfo", {session=tableSession, seat=0, select=select})
end

function DYMJScene:dispatchMessage(name, msg)
    print("dispatchMessage:" .. name)
    dump(msg)
    -- if name == "room.InitMatch" then
    --     if msg.matchid ~= nil then
    --         --matchNode:updateRank(22,333)
    --         matchid = msg.matchid
    --         matchSession = msg.session
    --         max_player = msg.max_player
    --         print("InitMatch max_player:" .. max_player)
    --         isMatchInit = true
    --         if isMatchStatus then
    --             print("InitMatch1111")
    --             matchNode:showLeftTime(matchid,tempSingnCount)
    --         end
    --     end
    -- elseif name == "room.SignupCountNtf" then
    --     if msg.session == matchSession then
    --         matchNode:updateSingup(msg.count)
    --         tempSingnCount = msg.count
    --     end
    -- elseif name == "room.MatchStatustNtf" then

    --     print("msg.status:" .. msg.status)
    --     if msg.status == 1 then
    --         isMatchStatus = true
    --     end

    --     if msg.session == matchSession then
    --         if msg.status == 1 then
    --             print("matchid:" .. matchid)
    --             if isMatchInit then
    --                 print("MatchStatustNtf1111")
    --                 matchNode:showLeftTime(matchid,tempSingnCount)
    --             end
    --         elseif msg.status == 2 then
    --             matchNode:removeLeftTime()
    --             matchNode:showMatchStart()
    --         elseif msg.status == 4 then
    --             matchNode:removeLeftTime()
    --             matchNode:showCancel()
    --         elseif msg.status == 8 then
    --         elseif msg.status == 16 then
    --         end
    --     end
    -- elseif name == "room.MatchInfoNtf" then
    --     print("matchSession:" .. matchSession)
    --     dump(msg)
    --     if matchSession == msg.session then
    --         matchNode:showState(msg.status,msg.rank,msg.gold,msg.rewardtitle,msg.rewardtype)
    --     end
    -- elseif name == "room.LeaveMatchRep" then

    -- elseif name == "room.MatchRankNtf" then
    --     print("MatchRankNtf s:" .. msg.session .. ",matchSession:" .. matchSession)
    --     if msg.session == matchSession then
    --         matchNode:updateRank(msg.rank,msg.total)
    --     end
    -- else
    if name == "room.InitGameScenes" then
        seatIndex = msg.seat
        tableSession = msg.session
        --if matchid == nil then
            max_player = msg.max_player
            huResult:setMaxPlayer(max_player,seatIndex)
        --end
        print("seatIndex:" .. seatIndex .. ",max_player:" .. max_player)
        watchingGame = msg.watching
        bottomCards:watching(watchingGame)
        if not watchingGame then
            print("DYMJ.Ready")
            message.sendMessage("DYMJ.Ready", {session=tableSession})
        end
        majiang = msg.gamekey
        print("gamekey:" .. majiang)
        baseScore = 0
        managerGame = false
        backGround:setMajiang(majiang)

        --test
        -- huResult:setResult()

    elseif name == "room.EnterGame" then
--modify wby whb 161031
        local viptype = 0
        if msg.player.viptype ~= nil then 
            viptype = msg.player.viptype
        end
        playersInfo:setPlayer(self:getDirect(msg.seat), msg.player.name, msg.player.gold, msg.player.sex, viptype)
--modify end
        playersInfo:setState(self:getDirect(msg.seat), msg.player.ready>0)
    elseif name == "room.LeaveGame" then
        playersInfo:clearPlayer(self:getDirect(msg.seat))
        playersInfo:setState(self:getDirect(msg.seat), false)
        if msg.seat == seatIndex then
            seatIndex = 0
            tableSession = 0
        end
    elseif name == "room.Ready" then
        playersInfo:setState(self:getDirect(msg.seat), true)
    elseif msg.session == tableSession then
        if name == "DYMJ.Ready" then
            if isRestart then
                self:onStart()
            else
                --if not matchid then
                    playersInfo:allowReady()
                --end
            end
        elseif name == "DYMJ.MajiangInfo" then
            self:restart()
            majiang = msg.majiang
            if msg.banker then
                playersInfo:setBanker(self:getDirect(msg.banker))
            end
        elseif name == "DYMJ.StartGame" then
            self:restart()
            -- if matchid ~= nil then
            --     matchNode:removeAll()
            -- end
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            playersInfo:clearState()
        elseif name == "DYMJ.BankerSeat" then
            cardWalls:showWalls(true, msg.points[1], msg.points[2], self:getDirect(msg.banker))
            playersInfo:setBanker(self:getDirect(msg.banker))
            --modify by whb
            huResult:setOpenCard(msg.dragon)
            --modify end
            -- if majiang == "shzhmj" then
            --     huResult:setPoints(0, 0)
            -- else
                huResult:setPoints(msg.points[1], msg.points[2])
            -- end
            dragonCard = msg.dragon
            msgWorker.sleep(0.75)
            sound.rotateDice()
        elseif name == "DYMJ.DistributeCard" then
            scheduler.performWithDelay(function()
                    cardWalls:showWalls(false)
                    huResult:showInfo()
                end, 1.0)
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:distributeCards(msg.card)
            end
            huResult:setCardNumber(msg.number)
            if msg.finish > 0 then
                scheduler.performWithDelay(function()
                    bottomCards:arrangeAnime(true)
                end, 0.25)
                msgWorker.sleep(0.5)
            end
        elseif name == "DYMJ.OutCard" then
            playersInfo:hideAllButton()
            outCards:outCard(msg.card, self:getDirect(msg.seat))
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:outCard(msg.card)
            end
            directTimer:clearTime()
            if seatIndex == msg.seat then
                bottomCards:allowOut(false)
            end
            sound.outCard(msg.card, dragonCard, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "DYMJ.OutedCard" then
            outCards:outedCard(msg.card, msg.seat)
        elseif name == "DYMJ.AllowOut" then
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowOut(true, msg.card, 0)
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 0 if managerGame then manager = 1 end
            print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        elseif name == "DYMJ.AllowOutEx" then
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowOut(true, msg.card, msg.mode)
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 0 if managerGame then manager = 1 end
            print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        elseif name == "DYMJ.AllowFlower" then
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowFlower(true, msg.card)
            end
        elseif name == "DYMJ.DrawCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:drawCard(msg.card)
            end
            huResult:setCardNumber(msg.number)
            sound.drawCard(msg.card)
        elseif name == "DYMJ.ComplementCard" then
            bottomCards:arrangeAnime(false)
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:complementCards(msg.card, msg.number==0)
            end
            if msg.number > 0 then
                huResult:setCardNumber(msg.number)
            end
            sound.complementCard(playersInfo:getSex(self:getDirect(msg.seat)), majiang)
            if seatIndex == msg.seat then
                bottomCards:allowFlower(false)
            end
        elseif name == "DYMJ.AllowCombin" then
            bottomCards:arrangeAnime(false)
            print("AllowCombin msg.allowOut:" .. tostring(msg.allowOut))
            dump(msg.combin)
            if msg.time > 0 then
                if msg.allowOut > 0 then
                    directTimer:setTimer(msg.time, self:getDirect(msg.allowOut))
                else
                    directTimer:setTimer(msg.time, "")
                end
            end
            
            if not watchingGame then
                local count = #msg.combin
                for i = 1, count do
                    if msg.combin[i].out == seatIndex then
                        msg.combin[i].out = 0
                    end
                end

                if not managerGame then
                    playersInfo:allowCombin(msg.combin, msg.allowOut == seatIndex)
                    if #msg.combin ~= 0 then
                        directTimer:setTimer(msg.time, "bottom")
                    end
                    if msg.allowOut == seatIndex then
                        bottomCards:allowOut(true, {}, 0)
                    end
                end
            end
        elseif name == "DYMJ.AllowCombinEx" then
            bottomCards:arrangeAnime(false)
            print("AllowCombinEx msg.allowOut:" .. tostring(msg.allowOut))
            print(dump(msg.combin))
            if msg.time > 0 then
                if msg.allowOut > 0 then
                    directTimer:setTimer(msg.time, self:getDirect(msg.allowOut))
                else
                    directTimer:setTimer(msg.time, "")
                end
            end
            
            if not watchingGame then
                local count = #msg.combin
                for i = 1, count do
                    if msg.combin[i].out == seatIndex then
                        msg.combin[i].out = 0
                    end
                end

                if not managerGame then
                    playersInfo:allowCombin(msg.combin, msg.allowOut == seatIndex)
                    if #msg.combin ~= 0 then
                        directTimer:setTimer(msg.time, "bottom")
                    end
                    if msg.allowOut == seatIndex then
                        bottomCards:allowOut(true, msg.card, msg.mode)
                    end
                end
            end
        elseif name == "DYMJ.CombinCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:combinCard(msg.combin.combin, msg.combin.card, self:getDirect(msg.combin.out))
                if msg.combin.discard_card and msg.combin.discard_card > 0 then
                    print("add qi pai:" .. tostring(msg.combin.discard_card))
                    --添加一张弃牌
                    direct:addOut(msg.combin.discard_card,max_player,true)
                end
            end
            directTimer:clearTime()
            outCards:combinCard(msg.combin.combin, self:getDirect(msg.seat))
            sound.combinCard(msg.combin.combin, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "DYMJ.EndGame" then
            playersInfo:clearManager()
            playersInfo:hideAllButton()
            directTimer:clearTime()
            if msg.mode > 0 then
                if msg.mode > 2 then
                    outCards:combinCard("muo", self:getDirect(msg.hun))
                    sound.combinCard("hun", playersInfo:getSex(self:getDirect(msg.hun)), majiang)
                elseif msg.mode > 0 then
                    outCards:combinCard("hun", self:getDirect(msg.hun))
                    sound.combinCard("hun", playersInfo:getSex(self:getDirect(msg.hun)), majiang)
                end
                local result = 0
                if msg.hun == seatIndex then
                    result = 1
                else
                    result = -1
                end
                local heads = {}
                for i = 1,max_player do
                    heads[i] = playersInfo:getHead(self:getDirect(i))
                end
                scheduler.performWithDelay(function()
                    huResult:setResult(msg, watchingGame,heads)
                    sound.gameResult(result)
                    --print("gameResult3:" .. type(matchid))
                    if matchid then
                        huResult:hideButton()
                    end
                end, 1.0)
            else
                local heads = {}
                for i = 1,max_player do
                    heads[i] = playersInfo:getHead(self:getDirect(i))
                end
                huResult:setResult(msg, watchingGame,heads)
                sound.gameResult(0)
                --print("gameResult:" .. type(matchid))
                if matchid then
                    huResult:hideButton()
                end
            end
            settingPanel:allowShare(true)
        elseif name == "DYMJ.GameInfo" then
            dragonCard = msg.dragon
            playersInfo:setBanker(self:getDirect(msg.banker))
             --modify by whb
            huResult:setOpenCard(msg.dragon)
            --modify end
            --huResult:setDragon(msg.dragon)
            huResult:setPoints(msg.points[1], msg.points[2])
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            huResult:showInfo()
        elseif name == "DYMJ.PlayerInfo" then
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:complementCards(msg.flower)
                local count = #msg.combins
                for i = 1, count do
                    direct:combinCard(msg.combins[i].combin, msg.combins[i].card, self:getDirect(msg.combins[i].out))
                    if msg.combins[i].discard_card and msg.combins[i].discard_card > 0 then
                        print("add qi pai:" .. tostring(msg.combins[i].discard_card))
                        --添加一张弃牌
                        direct:addOut(msg.combins[i].discard_card,max_player,true)
                    end
                end
                count = #msg.outs
                for i = 1, count do
                    direct:addOut(msg.outs[i], max_player)
                end
                direct:distributeCards(msg.cards)
            end
        elseif name == "DYMJ.Managed" then
            if not watchingGame then
                playersInfo:setManager(msg.state == 0, self:getDirect(msg.seat))
                if msg.seat == seatIndex then
                    managerGame = (msg.state == 0)
                end
            end
        elseif name == "DYMJ.AllowSelect" then
            playersInfo:clearState()
            cardWalls:showWalls(false)
            directTimer:setTimer(msg.time, "")
            if matchid ~= nil then
                matchNode:removeAll()
            end
            if msg.select > 0 then
                playersInfo:allowMopao()
            end
        elseif name == "DYMJ.SelectInfo" then
            if msg.select > 0 then
                playersInfo:setMopao(self:getDirect(msg.seat))
            end
            if msg.seat == seatIndex then
                playersInfo:hideAllButton()
            end
        end
    end
end

function DYMJScene:getDirect(seat)
    print("getDirectCards max_player:" .. max_player ..",seatIndex:" .. seatIndex .."seat:" .. seat)
    local pos = ((seat-1) - (seatIndex-1) + max_player) % max_player + 1
    if pos == 1 then
        return "bottom"
    elseif pos == 2 then
        if max_player == 4 then
            return "right"
        else
            return "top"
        end
    elseif pos == 3 then
        return "top"
    elseif pos == 4 then
        return "left"
    else
        return ""
    end
end

function DYMJScene:getDirectCards(seat)
    print("getDirectCards max_player:" .. max_player ..",seatIndex:" .. seatIndex .."seat:" .. seat)
    local pos = ((seat-1) - (seatIndex-1) + max_player) % max_player + 1
    if pos == 1 then
        return bottomCards
    elseif pos == 2 then
        if max_player == 4 then
            return rightCards
        else
            return topCards
        end
    elseif pos == 3 then
        return topCards
    elseif pos == 4 then
        return leftCards
    else
        return nil
    end
end

function DYMJScene:restart()
    cardWalls:restart()
    backGround:restart()
    topCards:restart()
    leftCards:restart()
    rightCards:restart()
    bottomCards:restart()
    outCards:restart()
    playersInfo:restart()
    directTimer:restart()
    huResult:restart()
    scheduler.clear()
    --majiang = ""
    baseScore = 0
    watchingGame = false
    managerGame = false
    isRestart = false
    settingPanel:allowShare(false)

end

function DYMJScene:clearScene()
    print("DYMJScene:clearScene()")
    cardWalls:clear()
    topCards:clear()
    leftCards:clear()
    rightCards:clear()
    bottomCards:clear()
    outCards:clear()
    playersInfo:clear()
    directTimer:clear()
    huResult:clear()
    matchNode:clear()

    backGround = nil
    cardWalls = nil
    topCards = nil
    leftCards = nil
    rightCards = nil
    bottomCards = nil
    outCards = nil
    playersInfo = nil
    directTimer = nil
    huResult = nil
    majiang = nil
    baseScore = nil
    watchingGame = nil
    managerGame = nil
    isRestart = nil
    matchNode = nil
    max_player = nil

    matchSession = 0
    matchid = nil
    tempSingnCount = 0
    isMatchInit = false
    isMatchStatus = false

    msgWorker.clear()
    scheduler.clear()
end

return DYMJScene