local YCMJScene = class("YCMJScene", function()
    return display.newScene("YCMJScene")
end)

local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")
local sound = require("app.Games.YCMJ.MJSound")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")
local Share = require("app.User.Share")

local util = require("app.Common.util")

local MatchMessage = require("app.net.MatchMessage")

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
local privateRoom
local privateRoomRecord

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

local matchid = nil
local tempSingnCount = 0
local isMatchInit = false
local isMatchStatus = false

local table_code

local liaotianSprite =nil

function YCMJScene:ctor()
    print("YCMJScene:ctor")
    sound.init()

    backGround = require("app.Games.YCMJ.MJBackground").new()
    :addTo(self)
    :init(self) 
    
    cardWalls = require("app.Games.YCMJ.MJWalls").new()
    :addTo(self)
    :init(self) 
    
    topCards = require("app.Games.YCMJ.MJTopCards").new()
    :addTo(self)
    :init(self) 
    
    leftCards = require("app.Games.YCMJ.MJLeftCards").new()
    :addTo(self)
    :init(self) 
    
    rightCards = require("app.Games.YCMJ.MJRightCards").new()
    :addTo(self)
    :init(self) 
    
    bottomCards = require("app.Games.YCMJ.MJBottomCards").new()
    :addTo(self)
    :init(self)
    
    playersInfo = require("app.Games.YCMJ.MJPlayers").new()
    :addTo(self)
    :init(self)

    outCards = require("app.Games.YCMJ.MJOutCard").new()
    :addTo(self)
    :init(self) 

    directTimer = require("app.Games.YCMJ.MJTimer").new()
    :addTo(self)
    :init(self)
    
    huResult = require("app.Games.YCMJ.MJResult").new()
    :addTo(self)
    :init(self)

    matchNode = require("app.Games.YCMJ.MJMatch").new()
    :addTo(self)

    privateRoom = require("app.Games.YCMJ.MJPRoom").new()
    :addTo(self)
    :init(self)

    privateRoomRecord = require("app.Games.YCMJ.MJPRoomRecord").new()
    :addTo(self)
    :init(self)
    :setLocalZOrder(100)
    :setVisible(false)

    settingPanel = require("app.Games.YCMJ.MJSetting").new()
    :addTo(self)
    :init(self)

    msgWorker.init("YCMJ", handler(self, self.dispatchMessage))

    
   liaotianSprite = display.newSprite()
    :addTo(self)
    if util.UserInfo.watching == false then
         -- 设置语音聊天按钮
         util.SetVoiceBtn(self,liaotianSprite)

    end

   Share.SetGameShareBtn(true, self, display.left+69, display.cy-130)

   -- matchNode:showState(16,2,100,"奖品类型","gold2")

    --matchNode:updateRank(22,333)
end

function YCMJScene:onEnter()
end

function YCMJScene:onExit()
    print("YCMJScene:onExit---")
    self:clearScene()
end

function YCMJScene:onStart()
    if not watchingGame then
        message.dispatchGame("room.ReadyReq", {})
    end
end

function YCMJScene:onLeave()
    if matchid then
        print("ts:" .. matchSession)
        MatchMessage.LeaveMatchReq(matchSession)
    elseif table_code then
        message.dispatchPrivateRoom("room.LeaveGame", {})
    else
    -- if table_code then
    --     message.dispatchPrivateRoom("room.LeaveGame", {})
    -- else
        message.dispatchGame("room.LeaveGame", {})
    end
end

function YCMJScene:onSound(open)
    
end

function YCMJScene:onRestart()
    self:restart()
    if not watchingGame then
        if tableSession == 0 or seatIndex == 0 then
            errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
                self:onLeave()
            end):addTo(self)
            return 
        end
        message.sendMessage("YCMJ.Ready", {session=tableSession})
        isRestart = true
    end
end

function YCMJScene:onOutCard(card)
    message.sendMessage("YCMJ.OutCard", {session=tableSession, seat=0, card=card})
end

function YCMJScene:onCombinCard(combin, card)
    message.sendMessage("YCMJ.CombinCard", {session=tableSession, seat=0, combin={combin=combin, card=card, out=0}})
end

function YCMJScene:onHuCard()
    message.sendMessage("YCMJ.HuCard", {session=tableSession})
end

function YCMJScene:onIgnoreCard()
    message.sendMessage("YCMJ.IgnoreCard", {session=tableSession})
end

function YCMJScene:getDragonCard()
    return dragonCard
end

function YCMJScene:getMajiang()
    return majiang
end
--要牌器
function YCMJScene:AddCardYW(Addcard)
    -- local tab={}

    message.sendMessage("YCMJ.RequestCard", {session=tableSession, seat=0, cards=Addcard})
end
function YCMJScene:onOutedCard(card, seat)
    local direct = self:getDirectCards(seat)
    if direct ~= nil then
        direct:addOut(card, max_player)
    end
end

function YCMJScene:onCanelManager(card, seat)
    message.sendMessage("YCMJ.Managed", {session=tableSession, seat=0, state=0})
end

function YCMJScene:onSelectInfo(select)
    message.sendMessage("YCMJ.SelectInfo", {session=tableSession, seat=0, select=select})
end

function YCMJScene:dispatchMessage(name, msg)
    print("dispatchMessage:" .. name)
    if name == "room.InitMatch" then
        if msg.matchid ~= nil then
            --matchNode:updateRank(22,333)
            matchid = msg.matchid
            matchSession = msg.session
            max_player = msg.max_player
            print("InitMatch max_player:" .. max_player)
            isMatchInit = true
            if isMatchStatus then
                print("InitMatch1111")
                matchNode:showLeftTime(matchid,tempSingnCount)
            end
        end
    elseif name == "room.SignupCountNtf" then
        if msg.session == matchSession then
            matchNode:updateSingup(msg.count)
            tempSingnCount = msg.count
        end
    elseif name == "room.MatchStatustNtf" then

        print("msg.status:" .. msg.status)
        if msg.status == 1 then
            isMatchStatus = true
        end

        if msg.session == matchSession then
            if msg.status == 1 then
                print("matchid:" .. matchid)
                if isMatchInit then
                    print("MatchStatustNtf1111")
                    matchNode:showLeftTime(matchid,tempSingnCount)
                end
            elseif msg.status == 2 then
                matchNode:removeLeftTime()
                matchNode:showMatchStart()
            elseif msg.status == 4 then
                matchNode:removeLeftTime()
                matchNode:showCancel()
            elseif msg.status == 8 then
            elseif msg.status == 16 then
            end
        end
    elseif name == "room.MatchInfoNtf" then
        print("matchSession:" .. matchSession)
        dump(msg)
        if matchSession == msg.session then
            matchNode:showState(msg.status,msg.rank,msg.gold,msg.rewardtitle,msg.rewardtype)
        end
    elseif name == "room.LeaveMatchRep" then

    elseif name == "room.MatchRankNtf" then
        print("MatchRankNtf s:" .. msg.session .. ",matchSession:" .. matchSession)
        if msg.session == matchSession then
            matchNode:updateRank(msg.rank,msg.total)
        end
    elseif name == "room.InitPrivateRoom" then
        tableSession = msg.table_session
        table_code = msg.table_code
        max_player = msg.max_player
        privateRoom:tableSession(msg.table_session)
        if result ~= 2 then
            privateRoom:showSeat({seat_cnt = msg.max_player,table_code = msg.table_code,tableid = msg.tableid,gameround = msg.gameround,
                pian_cnt = msg.pian_cnt})
        end
    elseif name == "room.PrivateRoomEnter" then
        local viptype = 0
        if msg.player.viptype ~= nil then 
            viptype = msg.player.viptype
        end
        privateRoom:setPlayer(msg.seat, msg.player.name, msg.player.gold, msg.player.sex, viptype, msg.player.creator, msg.player.imageid)
    elseif name == "room.PrivateRoomSitup" then
        if msg.seat ~= seatIndex then
            if privateRoom then
                privateRoom:clearPlayer(msg.seat)
            end
        end
    elseif name == "room.PrivateRoomTableStart" then
        seatIndex = msg.seat
        for i = 1,#msg.player do
            dump("玩家信息",msg.player[i])
            local viptype = 0
            if msg.player[i].viptype ~= nil then 
                viptype = msg.player[i].viptype
            end
            playersInfo:setPlayer(self:getDirect(msg.player[i].seat), msg.player[i].name, msg.player[i].gold, msg.player[i].sex, viptype, msg.player[i].imageid)
        end
        if privateRoom then
            privateRoom:showRoomEndState(true)
            privateRoom:clear()
            privateRoom:removeFromParent()
            privateRoom = nil
        end
    elseif name == "room.PrivateRoomReadyRep" then
        if privateRoom then
            privateRoom:ready(msg.seat)
        end
    elseif name == "room.PrivateRoomGameScore" then
        for i=1,#msg.playerInfo do
            playersInfo:updateScore(self:getDirect(msg.playerInfo[i].seat), msg.playerInfo[i].score)
        end
    elseif name == "room.InitGameScenes" then
        seatIndex = msg.seat
        tableSession = msg.session
        if matchid == nil then

            max_player = msg.max_player

        elseif table_code == nil then

            max_player = msg.max_player
        end
        --保存玩家座位
        huResult:setMaxPlayer(max_player,seatIndex)
        
        print("tableSession:",tableSession)

        print("seatIndex:" .. seatIndex .. ",max_player:" .. max_player)
        watchingGame = msg.watching
        bottomCards:watching(watchingGame)
        if not watchingGame then
            print("YCMJ.Ready")
            message.sendMessage("YCMJ.Ready", {session=tableSession})
        end
        majiang = msg.gamekey
        print("gamekey:" .. majiang)
        baseScore = 0
        managerGame = false
        backGround:setMajiang(majiang)

        if matchid ~= nil then
            matchNode:removeLeftTime()
        end

    elseif name == "room.EnterGame" then
--modify wby whb 161031
        print("room.EnterGame准备1")
        local viptype = 0
        if msg.player.viptype ~= nil then 
            viptype = msg.player.viptype
        end
        print("room.EnterGame-msg.player.imageid,", msg.player.imageid)
        playersInfo:setPlayer(self:getDirect(msg.seat), msg.player.name, msg.player.gold, msg.player.sex, viptype, msg.player.imageid)
--modify end
        playersInfo:setState(self:getDirect(msg.seat), msg.player.ready>0)
    elseif name == "room.LeaveGame" then
        print("room.LeaveGame-----")
        playersInfo:clearPlayer(self:getDirect(msg.seat))
        playersInfo:setState(self:getDirect(msg.seat), false)
        if msg.seat == seatIndex then
            seatIndex = 0
            tableSession = 0
        end
    elseif name == "room.Ready" then
        print("room.Ready准备2")
        playersInfo:setState(self:getDirect(msg.seat), true)
    elseif msg.session == tableSession then
        if name == "YCMJ.Ready" then
            print("YCMJ.Ready--111")
            if isRestart then
                self:onStart()
            else

                if not matchid then

                    playersInfo:allowReady()

                elseif not table_code then

                    playersInfo:allowReady()

                end
            end
        elseif name == "YCMJ.MajiangInfo" then
            self:restart()
            majiang = msg.majiang
            if msg.banker then
                playersInfo:setBanker(self:getDirect(msg.banker))
                huResult:setBanker(msg.banker)
            end
        elseif name == "YCMJ.StartGame" then
            self:restart()
            if matchid ~= nil then
                 matchNode:removeAll()
            end
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            playersInfo:clearState()
        elseif name == "YCMJ.BankerSeat" then
            cardWalls:showWalls(true, msg.points[1], msg.points[2], self:getDirect(msg.banker))
            playersInfo:setBanker(self:getDirect(msg.banker),msg.lian)
            huResult:setBanker(msg.banker,msg.lian)
            --modify by whb
            huResult:setOpenCard(msg.mark)
            --modify end
            -- if majiang == "shzhmj" then
            --     huResult:setPoints(0, 0)
            -- else
                huResult:setPoints(msg.points[1], msg.points[2])
            -- end
            dragonCard = msg.dragon
            msgWorker.sleep(0.75)
            sound.rotateDice()
        elseif name == "YCMJ.DistributeCard" then

            print("YCMJ.DistributeCard----0000")
            playersInfo:addCardYouWant(0)
            scheduler.performWithDelay(function()

                    print("YCMJ.DistributeCard----111")
                    cardWalls:showWalls(false)
                    huResult:showInfo()
                end, 1.0)
            local direct = self:getDirectCards(msg.seat)
            --print("direct:" .. direct)
            if direct ~= nil then
                print("YCMJ.DistributeCard----222",direct)
                dump(msg.card)
                direct:distributeCards(msg.card)
            end
            huResult:setCardNumber(msg.number)
            if msg.finish > 0 then
                print("YCMJ.DistributeCard----333")
                scheduler.performWithDelay(function()
                    bottomCards:arrangeAnime(true)
                    print("YCMJ.DistributeCard----444")
                end, 0.25)
                msgWorker.sleep(0.5)
            end
        elseif name == "YCMJ.AllowRequestCard" then
            print("允许要牌")
            directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            -- directTimer:setPosition(0,0)
            if seatIndex == msg.seat then
                --todo
                playersInfo:addCardYouWant(1)
            end
        elseif name == "YCMJ.OutCard" then
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
        elseif name == "YCMJ.OutedCard" then
            outCards:outedCard(msg.card, msg.seat)
        elseif name == "YCMJ.AllowOut" then
            print("YCMJ.AllowOut--111")
            playersInfo:addCardYouWant(0) ---隐藏请求发牌
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            print("YCMJ.AllowOut--222")
            if msg.time > 0 then
                print("YCMJ.AllowOut--333")
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                print("YCMJ.AllowOut--444")
                bottomCards:allowOut(true, msg.card, 0)
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 0 if managerGame then manager = 1 end
            print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        elseif name == "YCMJ.AllowOutEx" then
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
        elseif name == "YCMJ.AllowFlower" then
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowFlower(true, msg.card)
            end
        elseif name == "YCMJ.DrawCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:drawCard(msg.card)
            end
            huResult:setCardNumber(msg.number)
            sound.drawCard(msg.card)
        elseif name == "YCMJ.ComplementCard" then
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
        elseif name == "YCMJ.AllowCombin" then
            bottomCards:arrangeAnime(false)
            print("AllowCombin msg.allowOut:" .. tostring(msg.allowOut))
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
                        bottomCards:allowOut(true, {}, 0)
                    end
                end
            end
        elseif name == "YCMJ.AllowCombinEx" then
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
        elseif name == "YCMJ.CombinCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:combinCard(msg.combin.combin, msg.combin.card, self:getDirect(msg.combin.out))
            end
            directTimer:clearTime()
            outCards:combinCard(msg.combin.combin, self:getDirect(msg.seat))
            sound.combinCard(msg.combin.combin, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "YCMJ.EndGame" then
            print("游戏结束")
            -- dump(msg, "result")
            playersInfo:clearManager()
            playersInfo:hideAllButton()
            directTimer:clearTime()
            liaotianSprite:hide()
            local heads = {}
            local weixinImage = {}
            for i = 1,max_player do
                heads[i] = playersInfo:getHead(self:getDirect(i))
                weixinImage[i] = playersInfo:getWeixinHead(self:getDirect(i))
            end
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
                    huResult:setResult(msg, watchingGame,heads,table_code,weixinImage)
                    sound.gameResult(result)
                    --print("gameResult3:" .. type(matchid))
                    if matchid then
                        huResult:hideButton()
                    end
                end, 1.0)
            else
                huResult:setResult(msg, watchingGame,heads,table_code,weixinImage)
                sound.gameResult(0)
                --print("gameResult:" .. type(matchid))
                if matchid then
                    huResult:hideButton()
                end
            end
            settingPanel:allowShare(true)
        elseif name == "YCMJ.GameInfo" then
            dragonCard = msg.dragon
            playersInfo:setBanker(self:getDirect(msg.banker),msg.lian)
            huResult:setBanker(msg.banker,msg.lian)
             --modify by whb
            huResult:setOpenCard(msg.mark)
            --modify end
            --huResult:setDragon(msg.dragon)
            huResult:setPoints(msg.points[1], msg.points[2])
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            huResult:showInfo()
        elseif name == "YCMJ.PlayerInfo" then
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
        elseif name == "YCMJ.Managed" then
            if not watchingGame then
                playersInfo:setManager(msg.state == 0, self:getDirect(msg.seat))
                if msg.seat == seatIndex then
                    managerGame = (msg.state == 0)
                end
            end
        elseif name == "YCMJ.AllowSelect" then
            playersInfo:clearState()
            cardWalls:showWalls(false)
            directTimer:setTimer(msg.time, "")
            if matchid ~= nil then
                matchNode:removeAll()
            end
            if msg.select > 0 then
                playersInfo:allowMopao()
            end
        elseif name == "YCMJ.SelectInfo" then
            if msg.select > 0 then
                playersInfo:setMopao(self:getDirect(msg.seat))
            end
            if msg.seat == seatIndex then
                playersInfo:hideAllButton()
            end
        elseif name == "YCMJ.Termination" then
            if privateRoomRecord then
                privateRoomRecord:performWithDelay(function() 
                    local weixinImage = {}
                    for i = 1,max_player do
                        weixinImage[i] = playersInfo:getWeixinHead(self:getDirect(i))
                    end 
                    privateRoomRecord:showPrivateRoomRecord(true,msg,weixinImage)
                    end, 5)
            end
        end
    end
end

function YCMJScene:getDirect(seat)
    print("getDirect max_player:" .. max_player ..",seatIndex:" .. seatIndex .."seat:" .. seat)
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

function YCMJScene:getDirectCards(seat)
    print("getDirectCards max_player:" .. max_player ..",seatIndex:" .. seatIndex .."seat:" .. seat)
    local pos = ((seat-1) - (seatIndex-1) + max_player) % max_player + 1
    print("pos:" .. pos)
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

function YCMJScene:restart()
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
    liaotianSprite:show()

end

function YCMJScene:clearScene()
    print("YCMJScene:clearScene()")
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
    if privateRoom then
    privateRoom:clear()
    end
    privateRoomRecord:clear()

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
    privateRoom = nil
    privateRoomRecord = nil
    max_player = nil

    table_code = nil

    matchSession = 0
    matchid = nil
    tempSingnCount = 0
    isMatchInit = false
    isMatchStatus = false

    msgWorker.clear()
    scheduler.clear()
end

return YCMJScene