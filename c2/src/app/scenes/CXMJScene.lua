local CXMJScene = class("CXMJScene", function()
    return display.newScene("CXMJScene")
end)

local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")
local sound = require("app.Games.CXMJ.MJSound")
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

function CXMJScene:ctor()
    print("CXMJScene:ctor")
    sound.init()

    backGround = require("app.Games.CXMJ.MJBackground").new()
    :addTo(self)
    :init(self) 
    
    cardWalls = require("app.Games.CXMJ.MJWalls").new()
    :addTo(self)
    :init(self) 
    
    topCards = require("app.Games.CXMJ.MJTopCards").new()
    :addTo(self)
    :init(self) 
    
    leftCards = require("app.Games.CXMJ.MJLeftCards").new()
    :addTo(self)
    :init(self) 
    
    rightCards = require("app.Games.CXMJ.MJRightCards").new()
    :addTo(self)
    :init(self) 
    
    bottomCards = require("app.Games.CXMJ.MJBottomCards").new()
    :addTo(self)
    :init(self)
    
    playersInfo = require("app.Games.CXMJ.MJPlayers").new()
    :addTo(self)
    :init(self)

    outCards = require("app.Games.CXMJ.MJOutCard").new()
    :addTo(self)
    :init(self) 

    directTimer = require("app.Games.CXMJ.MJTimer").new()
    :addTo(self)
    :init(self)
    
    huResult = require("app.Games.CXMJ.MJResult").new()
    :addTo(self)
    :init(self)

    matchNode = require("app.Games.CXMJ.MJMatch").new()
    :addTo(self)

    privateRoom = require("app.Games.CXMJ.MJPRoom").new()
    :addTo(self)
    :init(self)

    privateRoomRecord = require("app.Games.CXMJ.MJPRoomRecord").new()
    :addTo(self)
    :init(self)
    :setLocalZOrder(100)
    :setVisible(false)

    settingPanel = require("app.Games.CXMJ.MJSetting").new()
    :addTo(self)
    :init(self)

    msgWorker.init("CXMJ", handler(self, self.dispatchMessage))

    
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

function CXMJScene:onEnter()
end

function CXMJScene:onExit()
    print("CXMJScene:onExit---")
    self:clearScene()
end

function CXMJScene:onStart()
    if not watchingGame then
        message.dispatchGame("room.ReadyReq", {})
    end
end

function CXMJScene:onLeave()
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

function CXMJScene:onSound(open)
    
end

function CXMJScene:onRestart()
    self:restart()
    if not watchingGame then
        if tableSession == 0 or seatIndex == 0 then
            errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
                self:onLeave()
            end):addTo(self)
            return 
        end
        message.sendMessage("CXMJ.Ready", {session=tableSession})
        isRestart = true
    end
end

function CXMJScene:onOutCard(card)
    message.sendMessage("CXMJ.Operate", {session=tableSession, seat=0,mode="out", card=card,from=0})
end

function CXMJScene:onCombinCard(combin, card)
    print("onCombinCard：combin:" ..combin .."card" ..card)
    message.sendMessage("CXMJ.Operate", {session=tableSession, seat=0, mode=combin, card=card, from=0})
end

function CXMJScene:onHuCard()
    message.sendMessage("CXMJ.Operate", {session=tableSession, seat=0, mode="hu", card=0, from=0})
    -- message.sendMessage("CXMJ.HuCard", {session=tableSession})
end

function CXMJScene:onIgnoreCard()
    message.sendMessage("CXMJ.Operate", {session=tableSession, seat=0, mode="ignore", card=0, from=0})
    -- message.sendMessage("CXMJ.IgnoreCard", {session=tableSession})
end

function CXMJScene:getDragonCard()
    return dragonCard
end

function CXMJScene:getMajiang()
    return majiang
end
--要牌器
function CXMJScene:AddCardYW(Addcard)
    -- local tab={}

    message.sendMessage("CXMJ.RequestCard", {session=tableSession, seat=0, cards=Addcard})
end
function CXMJScene:onOutedCard(card, seat)
    local direct = self:getDirectCards(seat)
    if direct ~= nil then
        direct:addOut(card, max_player)
    end
end

function CXMJScene:onCanelManager(card, seat)
    message.sendMessage("CXMJ.Managed", {session=tableSession, seat=0, state=0})
end

function CXMJScene:onSelectInfo(select)
    message.sendMessage("CXMJ.SelectInfo", {session=tableSession, seat=0, select=select})
end

function CXMJScene:dispatchMessage(name, msg)
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
        if msg.player.ready == 1 then
            privateRoom:ready(msg.seat)
        end
    elseif name == "room.PrivateRoomSitup" then
        print("room.PrivateRoomSitup:" .. tostring(msg.seat))
        if msg.seat == seatIndex then
             message.dispatchPrivateRoom("room.ExitTable", {})
        else
            if privateRoom then
        privateRoom:clearPlayer(msg.seat)
            end
        end
    elseif name == "room.PrivateRoomSitupRep" then
        if privateRoom then
            --只有房主会站起
            privateRoom:clearPlayer(msg.seat,true)
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
            privateRoom:clear()
            privateRoom:removeFromParent()
            privateRoom = nil
        end
    elseif name == "room.PrivateRoomallowReady" then
        privateRoom:allowReady(msg.seat)
        seatIndex = msg.seat
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
            print("CXMJ.Ready")
            message.sendMessage("CXMJ.Ready", {session=tableSession})
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
        print("msg.player.ready:" ..msg.player.ready)
        local viptype = 0
        if msg.player.viptype ~= nil then 
            viptype = msg.player.viptype
        end
        playersInfo:setPlayer(self:getDirect(msg.seat), msg.player.name, msg.player.gold, msg.player.sex, viptype, msg.player.imageid)
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
        print("room.Ready准备2")
        playersInfo:setState(self:getDirect(msg.seat), true)
    elseif msg.session == tableSession then
        print("慈溪麻将开始")
        if name == "CXMJ.Ready" then
            print("CXMJ.Ready--111")
            if isRestart then
                self:onStart()
            else

                if not matchid then

                    playersInfo:allowReady()

                elseif not table_code then

                    playersInfo:allowReady()

                end
            end
        elseif name == "CXMJ.MajiangInfo" then
            self:restart()
            majiang = msg.majiang
            if msg.banker then
                playersInfo:setBanker(self:getDirect(msg.banker))
                huResult:setBanker(msg.banker)
            end
        elseif name == "CXMJ.StartGame" then
            print("CXMJ.StartGame走了吗")
            self:restart()
            if matchid ~= nil then
                 matchNode:removeAll()
            end
            print("score:" ..msg.score)
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            playersInfo:clearState()
        elseif name == "CXMJ.BankerSeat" then
            cardWalls:showWalls(true, msg.points[1], msg.points[2], self:getDirect(msg.banker))
            playersInfo:setBanker(self:getDirect(msg.banker),msg.lian)
            huResult:setBanker(msg.banker,msg.lian)
            --modify by whb
            dump(msg,"CXMJ.BankerSeat:msg")
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
        elseif name == "CXMJ.DistributeCard" then

            print("CXMJ.DistributeCard----0000")
            playersInfo:addCardYouWant(0)
            scheduler.performWithDelay(function()

                    print("CXMJ.DistributeCard----111")
                    cardWalls:showWalls(false)
                    huResult:showInfo()
                end, 1.0)
            local direct = self:getDirectCards(msg.seat)
            --print("direct:" .. direct)
            if direct ~= nil then
                print("CXMJ.DistributeCard----222",direct)
                dump(msg.cards)
                direct:distributeCards(msg.cards)
            end
            --设置剩余牌数
            huResult:setCardNumber(msg.number)

            -- if msg.finish > 0 then
                print("CXMJ.DistributeCard----333")
                scheduler.performWithDelay(function()
                    bottomCards:arrangeAnime(true)
                    print("CXMJ.DistributeCard----444")
                end, 0.25)
                msgWorker.sleep(0.5)
            -- end

            -- bottomCards:arrangeAnime(false)
        elseif name == "CXMJ.AllowRequestCard" then
            print("允许要牌")
            directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            -- directTimer:setPosition(0,0)
            print("玩家的座位号" ..seatIndex)
            dump(msg)
            if seatIndex == msg.seat then
                --todo
                playersInfo:addCardYouWant(1)
            end
        -- elseif name == "CXMJ.OutCard" then
        --     playersInfo:hideAllButton()
        --     outCards:outCard(msg.card, self:getDirect(msg.seat))
        --     local direct = self:getDirectCards(msg.seat)
        --     if direct ~= nil then
        --         direct:outCard(msg.card)
        --     end
        --     directTimer:clearTime()
        --     if seatIndex == msg.seat then
        --         bottomCards:allowOut(false)
        --     end
        --     sound.outCard(msg.card, dragonCard, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "CXMJ.OutedCard" then
            outCards:outedCard(msg.card, msg.seat)
        elseif name == "CXMJ.AllowOut" then
            print("CXMJ.AllowOut--111")
            playersInfo:addCardYouWant(0) ---隐藏请求发牌
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            print("CXMJ.AllowOut--222")
            if msg.time > 0 then
                print("CXMJ.AllowOut--333")
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                print("CXMJ.AllowOut--444")
                -- bottomCards:allowOut(true, msg.card, 0)
                bottomCards:allowOut(true, msg.card, msg.mode)
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 0 if managerGame then manager = 1 end
            print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        -- elseif name == "CXMJ.AllowOutEx" then
        --     bottomCards:arrangeAnime(false)
        --     playersInfo:hideAllButton()
        --     if msg.time > 0 then
        --         directTimer:setTimer(msg.time, self:getDirect(msg.seat))
        --     end
        --     if seatIndex == msg.seat and not watchingGame and not managerGame then
        --         bottomCards:allowOut(true, msg.card, msg.mode)
        --     end
        --     local watch = 0 if watchingGame then watch = 1 end
        --     local manager = 0 if managerGame then manager = 1 end
        --     print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        elseif name == "CXMJ.AllowFlower" then
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowFlower(true, msg.card)
            end

        elseif name == "CXMJ.DrawCard" then
            print("CXMJ.DrawCard")
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:drawCard(msg.card)
            end
            huResult:setCardNumber(msg.number)
            sound.drawCard(msg.card)
        elseif name == "CXMJ.ComplementCard" then
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
        elseif name == "CXMJ.AllowOperate" then
            print("CXMJ.AllowOperate")
            bottomCards:arrangeAnime(false)

            playersInfo:addCardYouWant(0) ---隐藏请求发牌
            
            -- print("AllowCombin msg.allowOut:" .. tostring(msg.allowOut))
            dump(msg)
            if msg.time > 0 then
                if msg.seat > 0 then
                    directTimer:setTimer(msg.time, self:getDirect(msg.seat))
                else
                    directTimer:setTimer(msg.time, "")
                end
            end
            
            if not watchingGame then
                

                if not managerGame  and msg.seat == seatIndex then
                    for _, t in ipairs(msg.operates) do
                        if t.mode =="out" then
                            --todo
                            bottomCards:allowOut(true, msg.cards, msg.mode)
                        end
                    end
                    playersInfo:allowCombin(msg.operates)
                    
                end
            end
        -- elseif name == "CXMJ.AllowCombinEx" then
        --     bottomCards:arrangeAnime(false)
        --     print("AllowCombinEx msg.allowOut:" .. tostring(msg.allowOut))
        --     print(dump(msg.combin))
        --     if msg.time > 0 then
        --         if msg.allowOut > 0 then
        --             directTimer:setTimer(msg.time, self:getDirect(msg.allowOut))
        --         else
        --             directTimer:setTimer(msg.time, "")
        --         end
        --     end
            
        --     if not watchingGame then
        --         local count = #msg.combin
        --         for i = 1, count do
        --             if msg.combin[i].out == seatIndex then
        --                 msg.combin[i].out = 0
        --             end
        --         end

        --         if not managerGame then
        --             playersInfo:allowCombin(msg.combin, msg.allowOut == seatIndex)
        --             if #msg.combin ~= 0 then
        --                 directTimer:setTimer(msg.time, "bottom")
        --             end
        --             if msg.allowOut == seatIndex then
        --                 bottomCards:allowOut(true, msg.card, msg.mode)
        --             end
        --         end
        --     end
        elseif name == "CXMJ.Operate" then
            print("收到广播数据")
            dump(msg)
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            local ISout = false
            --是否有出牌消息
            
            if msg.mode =="out" then
                ISout = true
                outCards:outCard(msg.card, self:getDirect(msg.seat))
            end
            


            if direct ~= nil then
                if ISout then
                    direct:outCard(msg.card)
                else
                    direct:combinCard(msg.mode, msg.card, self:getDirect(msg.from))
                end
            end
            directTimer:clearTime()
            if ISout then
                if seatIndex == msg.seat then
                    bottomCards:allowOut(false)
                end
                sound.outCard(msg.card, dragonCard, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
            else
                outCards:combinCard(msg.mode, self:getDirect(msg.seat))
                sound.combinCard(msg.mode, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
            end
            
        elseif name == "CXMJ.EndGame" then
            print("游戏结束")
            -- dump(msg, "result")
            playersInfo:clearManager()
            playersInfo:hideAllButton()
            directTimer:clearTime()
            liaotianSprite:hide()
            local heads = {}
            for i = 1,max_player do
                heads[i] = playersInfo:getHead(self:getDirect(i))
            end
            --判断是否慌庄
            if msg.huang ~= 1 then
                --遍历所有数据
                local hu_seat=0
                for i=1,#msg.infos do
                    --判断是否胡
                    if msg.infos[i].card >0 then
                        hu_seat=i
                        --判断是否自摸
                        if msg.infos[i].from == msg.infos[i].seat then
                            --todo
                            outCards:combinCard("muo", self:getDirect(msg.infos[i].seat))
                            sound.combinCard("hun", playersInfo:getSex(self:getDirect(msg.infos[i].seat)), majiang)
                        else
                            outCards:combinCard("hun", self:getDirect(msg.infos[i].seat))
                            sound.combinCard("hun", playersInfo:getSex(self:getDirect(msg.infos[i].seat)), majiang)
                        end
                       
                    end
                end
                local result = 0
                        if hu_seat == seatIndex then
                            result = 1
                        else
                            result = -1
                        end
                        scheduler.performWithDelay(function()
                            huResult:setResult(msg, watchingGame,heads,table_code)
                            sound.gameResult(result)
                
                            if matchid then
                                huResult:hideButton()
                            end
                        end, 1.0)

            else
                huResult:setResult(msg, watchingGame,heads,table_code)
                sound.gameResult(0)
                --print("gameResult:" .. type(matchid))
                if matchid then
                    huResult:hideButton()
                end
            end
            settingPanel:allowShare(true)
        elseif name == "CXMJ.GameInfo" then
            print("CXMJ.GameInfo" ..msg.score)
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

            

        elseif name == "CXMJ.PlayerInfo" then
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                -- direct:complementCards(msg.flower)
                local count = #msg.combins
                for i = 1, count do
                    direct:combinCard(msg.combins[i].mode, msg.combins[i].card, self:getDirect(msg.combins[i].from))
                end
                count = #msg.outs
                for i = 1, count do
                    direct:addOut(msg.outs[i], max_player)
                end
                direct:distributeCards(msg.cards)
            end
        elseif name == "CXMJ.Managed" then
            if not watchingGame then
                playersInfo:setManager(msg.state == 1, self:getDirect(msg.seat))
                if msg.seat == seatIndex then
                    managerGame = (msg.state == 1)
                end
            end
        elseif name == "CXMJ.AllowSelect" then
            playersInfo:clearState()
            cardWalls:showWalls(false)
            directTimer:setTimer(msg.time, "")
            if matchid ~= nil then
                matchNode:removeAll()
            end
            if msg.select > 0 then
                playersInfo:allowMopao()
            end
        elseif name == "CXMJ.SelectInfo" then
            if msg.select > 0 then
                playersInfo:setMopao(self:getDirect(msg.seat))
            end
            if msg.seat == seatIndex then
                playersInfo:hideAllButton()
            end
        elseif name == "CXMJ.Termination" then
            if privateRoomRecord then
                privateRoomRecord:performWithDelay(function() 
                    privateRoomRecord:showPrivateRoomRecord(true,msg)
                    end, 5)
            end
        end
    end
end

function CXMJScene:getDirect(seat)
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

function CXMJScene:getDirectCards(seat)
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

function CXMJScene:restart()
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

function CXMJScene:clearScene()
    print("CXMJScene:clearScene()")
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

return CXMJScene