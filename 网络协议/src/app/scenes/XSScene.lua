local XSMJScene = class("XSMJScene", function()
    return display.newScene("XSMJScene")
end)

local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")
local sound = require("app.Games.XSMJ.MJSound")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")

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

function XSMJScene:ctor()
    print("XSMJScene:ctor")
    sound.init()

    backGround = require("app.Games.XSMJ.MJBackground").new()
    :addTo(self)
    :init(self) 
    
    cardWalls = require("app.Games.XSMJ.MJWalls").new()
    :addTo(self)
    :init(self) 
    
    topCards = require("app.Games.XSMJ.MJTopCards").new()
    :addTo(self)
    :init(self) 
    
    leftCards = require("app.Games.XSMJ.MJLeftCards").new()
    :addTo(self)
    :init(self) 
    
    rightCards = require("app.Games.XSMJ.MJRightCards").new()
    :addTo(self)
    :init(self) 
    
    bottomCards = require("app.Games.XSMJ.MJBottomCards").new()
    :addTo(self)
    :init(self) 

    outCards = require("app.Games.XSMJ.MJOutCard").new()
    :addTo(self)
    :init(self) 
    
    directTimer = require("app.Games.XSMJ.MJTimer").new()
    :addTo(self)
    :init(self) 
    
    playersInfo = require("app.Games.XSMJ.MJPlayers").new()
    :addTo(self)
    :init(self)
    
    huResult = require("app.Games.XSMJ.MJResult").new()
    :addTo(self)
    :init(self)

    matchNode = require("app.Games.XSMJ.MJMatch").new()
    :addTo(self)

    settingPanel = require("app.Games.XSMJ.MJSetting").new()
    :addTo(self)
    :init(self)

    msgWorker.init("XSMJ", handler(self, self.dispatchMessage))
end

function XSMJScene:onEnter()
end

function XSMJScene:onExit()
    self:clearScene()
end

function XSMJScene:onStart()
    if not watchingGame then
        message.dispatchGame("room.ReadyReq", {})
    end
end

function XSMJScene:onLeave()
    -- if matchid then
    --     print("ts:" .. matchSession)
    --     MatchMessage.LeaveMatchReq(matchSession)
    -- else
        message.dispatchGame("room.LeaveGame", {})
    -- end
end

function XSMJScene:onSound(open)
    sound.setState(open)
end

function XSMJScene:onRestart()
    self:restart()
    if not watchingGame then
        if tableSession == 0 or seatIndex == 0 then
            errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
                self:onLeave()
            end):addTo(self)
            return 
        end
        message.sendMessage("XSMJ.Ready", {session=tableSession})
        isRestart = true
    end
end

function XSMJScene:onOutCard(card)
    message.sendMessage("XSMJ.OutCard", {session=tableSession, seat=0, card=card})
end

function XSMJScene:onCombinCard(combin, card)
    message.sendMessage("XSMJ.CombinCard", {session=tableSession, seat=0, combin={combin=combin, card=card, out=0}})
end

function XSMJScene:onHuCard()
    message.sendMessage("XSMJ.HuCard", {session=tableSession})
end

function XSMJScene:onIgnoreCard()
    message.sendMessage("XSMJ.IgnoreCard", {session=tableSession})
end

function XSMJScene:getDragonCard()
    return dragonCard
end

function XSMJScene:getMajiang()
    return majiang
end

function XSMJScene:onOutedCard(card, seat)
    local direct = self:getDirectCards(seat)
    if direct ~= nil then
        direct:addOut(card, max_player)
    end
end

function XSMJScene:onCanelManager(card, seat)
    message.sendMessage("XSMJ.Managed", {session=tableSession, seat=0, state=0})
end

function XSMJScene:onSelectInfo(select)
    message.sendMessage("XSMJ.SelectInfo", {session=tableSession, seat=0, select=select})
end

function XSMJScene:dispatchMessage(name, msg)
    print("dispatchMessage:" .. name)
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
        --end
        print("seatIndex:" .. seatIndex .. ",max_player:" .. max_player)
        watchingGame = msg.watching
        bottomCards:watching(watchingGame)
        if not watchingGame then
            print("XSMJ.Ready")
            message.sendMessage("XSMJ.Ready", {session=tableSession})
        end
        majiang = msg.gamekey
        print("gamekey:" .. majiang)
        baseScore = 0
        managerGame = false
        backGround:setMajiang(majiang)

        -- if matchid ~= nil then
        --     matchNode:removeLeftTime()
        -- end

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
        if name == "XSMJ.Ready" then
            if isRestart then
                self:onStart()
            else
                --if not matchid then
                    playersInfo:allowReady()
                --end
            end
        elseif name == "XSMJ.MajiangInfo" then
            self:restart()
            majiang = msg.majiang
            if msg.banker then
                playersInfo:setBanker(self:getDirect(msg.banker),max_player)
            end
        elseif name == "XSMJ.StartGame" then
            self:restart()
            -- if matchid ~= nil then
            --     matchNode:removeAll()
            -- end
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            playersInfo:clearState()
        elseif name == "XSMJ.BankerSeat" then
            cardWalls:showWalls(true, msg.points[1], msg.points[2], self:getDirect(msg.banker))
            playersInfo:setBanker(self:getDirect(msg.banker),max_player)
            --modify by whb
            huResult:setOpenCard(msg.feng_quan)
            --modify end
            -- if majiang == "shzhmj" then
            --     huResult:setPoints(0, 0)
            -- else
                huResult:setPoints(msg.points[1], msg.points[2])
            -- end
            dragonCard = msg.feng_quan
            msgWorker.sleep(0.75)
            sound.rotateDice()
        elseif name == "XSMJ.DistributeCard" then
            cardWalls:showWalls(false)
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
        elseif name == "XSMJ.OutCard" then
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
        elseif name == "XSMJ.OutedCard" then
            outCards:outedCard(msg.card, msg.seat)
        elseif name == "XSMJ.AllowOut" then
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
        elseif name == "XSMJ.AllowOutEx" then
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
        elseif name == "XSMJ.AllowFlower" then
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowFlower(true, msg.card)
            end
        elseif name == "XSMJ.DrawCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:drawCard(msg.card)
            end
            huResult:setCardNumber(msg.number)
            sound.drawCard(msg.card)
        elseif name == "XSMJ.ComplementCard" then
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
        elseif name == "XSMJ.AllowCombin" then
            bottomCards:arrangeAnime(false)
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
                    if msg.allowOut == seatIndex then
                        bottomCards:allowOut(true, {}, 0)
                    end
                end
            end
        elseif name == "XSMJ.AllowCombinEx" then
            bottomCards:arrangeAnime(false)
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
                    if msg.allowOut == seatIndex then
                        bottomCards:allowOut(true, msg.card, msg.mode)
                    end
                end
            end
        elseif name == "XSMJ.CombinCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:combinCard(msg.combin.combin, msg.combin.card, self:getDirect(msg.combin.out))
            end
            directTimer:clearTime()
            outCards:combinCard(msg.combin.combin, self:getDirect(msg.seat))
            sound.combinCard(msg.combin.combin, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "XSMJ.EndGame" then
            playersInfo:clearManager()
            playersInfo:hideAllButton()
            directTimer:clearTime()
            --print("game end mode " .. tostring(msg.mode))
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
                scheduler.performWithDelay(function()
                    huResult:setResult(msg, watchingGame, majiang)
                    sound.gameResult(result)
                    --print("gameResult3:" .. type(matchid))
                    if matchid then
                        huResult:hideButton()
                    end
                end, 1.0)
            else
                huResult:setResult(msg, watchingGame, majiang)
                sound.gameResult(0)
                --print("gameResult:" .. type(matchid))
                if matchid then
                    huResult:hideButton()
                end
            end
            settingPanel:allowShare(true)
        elseif name == "XSMJ.GameInfo" then
            dragonCard = msg.feng_quan
            playersInfo:setBanker(self:getDirect(msg.banker),max_player)
             --modify by whb
            huResult:setOpenCard(msg.feng_quan)
            --modify end
            huResult:setPoints(msg.points[1], msg.points[2])
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
        elseif name == "XSMJ.PlayerInfo" then
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:complementCards(msg.flower)
                local count = #msg.combins
                for i = 1, count do
                    direct:combinCard(msg.combins[i].combin, msg.combins[i].card, self:getDirect(msg.combins[i].out))
                end
                count = #msg.outs
                for i = 1, count do
                    direct:addOut(msg.outs[i], max_player)
                end
                direct:distributeCards(msg.cards)
            end
        elseif name == "XSMJ.Managed" then
            if not watchingGame then
                playersInfo:setManager(msg.state == 0, self:getDirect(msg.seat))
                if msg.seat == seatIndex then
                    managerGame = (msg.state == 0)
                end
            end
        elseif name == "XSMJ.AllowSelect" then
            playersInfo:clearState()
            cardWalls:showWalls(false)
            directTimer:setTimer(msg.time, "")
            if matchid ~= nil then
                matchNode:removeAll()
            end
            if msg.select > 0 then
                playersInfo:allowMopao()
            end
        elseif name == "XSMJ.SelectInfo" then
            if msg.select > 0 then
                playersInfo:setMopao(self:getDirect(msg.seat))
            end
            if msg.seat == seatIndex then
                playersInfo:hideAllButton()
            end
        end
    end
end

function XSMJScene:getDirect(seat)
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

function XSMJScene:getDirectCards(seat)
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

function XSMJScene:restart()
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

function XSMJScene:clearScene()
    print("XSMJScene:clearScene()")
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

return XSMJScene