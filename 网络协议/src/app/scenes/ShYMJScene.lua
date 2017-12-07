local ShYMJScene = class("ShYMJScene", function()
    return display.newScene("ShYMJScene")
end)

local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")
local sound = require("app.Games.ShYMJ.MJSound")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")
local Share = require("app.User.Share")
local sound_common = require("app.Common.sound_common")
local ProgressLayer = require("app.layers.ProgressLayer")
local schedulerSys = require(cc.PACKAGE_NAME .. ".scheduler")

local util = require("app.Common.util")

local MatchMessage = require("app.net.MatchMessage")
local PRMessage = require("app.net.PRMessage")

local progressTag = 10000

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

local roomSession = 0
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

local table_code        --私人房间号
local gameState         --0: 房卡游戏未开始； 1: 房卡游戏已开始

local liaotianSprite =nil
function ShYMJScene:ctor()
    print("ShYMJScene:ctor")
    sound.init()

    backGround = require("app.Games.ShYMJ.MJBackground").new()
    :addTo(self)
    :init(self)

    cardWalls = require("app.Games.ShYMJ.MJWalls").new()
    :addTo(self)
    :init(self)

    topCards = require("app.Games.ShYMJ.MJTopCards").new()
    :addTo(self)
    :init(self)

    leftCards = require("app.Games.ShYMJ.MJLeftCards").new()
    :addTo(self)
    :init(self)

    rightCards = require("app.Games.ShYMJ.MJRightCards").new()
    :addTo(self)
    :init(self)

    bottomCards = require("app.Games.ShYMJ.MJBottomCards").new()
    :addTo(self)
    :init(self)

    playersInfo = require("app.Games.ShYMJ.MJPlayers").new()
    :addTo(self,2)
    :init(self)

    outCards = require("app.Games.ShYMJ.MJOutCard").new()
    :addTo(self)
    :init(self)

    directTimer = require("app.Games.ShYMJ.MJTimer").new()
    :addTo(self,3)
    :init(self)

    huResult = require("app.Games.ShYMJ.MJResult").new()
    :addTo(self,55)
    :init(self)

    matchNode = require("app.Games.ShYMJ.MJMatch").new()
    :addTo(self)

    privateRoom = require("app.Games.ShYMJ.MJPRoom").new()
    :addTo(self)
    :init(self)

    privateRoomRecord = require("app.Games.ShYMJ.MJPRoomRecord").new()
    :addTo(self)
    :init(self)
    :setLocalZOrder(102)
    :setVisible(false)

    settingPanel = require("app.Games.ShYMJ.MJSetting").new()
    :addTo(self,101)
    :init(self)

    msgWorker.init("ShYMJ", handler(self, self.dispatchMessage))

    liaotianSprite = display.newSprite()
    :addTo(self,50)
    if util.UserInfo.watching == false then
         -- 设置语音聊天按钮
         util.SetVoiceBtn(self,liaotianSprite)
    end
    --重置表情变量
    util.reSetEmotion()

   --Share.SetGameShareBtn(true, self, display.left+69, display.cy-130)

end

function ShYMJScene:onEnter()
end

function ShYMJScene:onEnterTransitionFinish()

      print("ShYMJScene:onEnterTransitionFinish---")
      schedulerSys.performWithDelayGlobal(
      function ()
          --登录好友聊天系统
          if app.constant.isLoginChat == false and loginFchatHandler == nil then
             loginYvSys()
          end
      end, 1.0)
end

function ShYMJScene:onExit()
    self:clearScene()
    sound_common.stop_bg()
end

function ShYMJScene:onStart()
    if not watchingGame then
        message.dispatchGame("room.ReadyReq", {})
    end
end

function ShYMJScene:onLeave()
    if matchid then
        print("ts:" .. matchSession)
        MatchMessage.LeaveMatchReq(matchSession)
    elseif table_code then
        message.dispatchPrivateRoom("room.LeaveGame", {})
    else
        message.dispatchGame("room.LeaveGame", {})
    end
end

function ShYMJScene:onSound(open)
    --sound.setState(open)
end

function ShYMJScene:onRestart()
    self:restart()
    if not watchingGame then
        if tableSession == 0 or seatIndex == 0 then
            errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
                self:onLeave()
            end):addTo(self)
            return
        end
        message.sendMessage("ShYMJ.Ready", {session=tableSession})
        isRestart = true
    end
end

function ShYMJScene:ReadyNextRound()

     if not watchingGame then
        --message.dispatchGame("room.ReadyReq", {})
        self.isReady = true
        message.sendMessage("game.ReadyReq", {
            session = roomSession
        })
    end

end

function ShYMJScene:onOutCard(card)
    message.sendMessage("ShYMJ.OutCard", {session=tableSession, seat=0, card=card})
end

function ShYMJScene:onCombinCard(combin, card)
    message.sendMessage("ShYMJ.CombinCard", {session=tableSession, seat=0, combin={combin=combin, card=card, out=0}})
end

function ShYMJScene:onHuCard()
    message.sendMessage("ShYMJ.HuCard", {session=tableSession})
end

function ShYMJScene:onIgnoreCard()
    message.sendMessage("ShYMJ.IgnoreCard", {session=tableSession})
end

function ShYMJScene:getDragonCard()
    return dragonCard
end

function ShYMJScene:setDragonCard(dragon)
    local majiang = self:getMajiang()

    local card = dragon+1
    if dragon == 16*1+9 then

        card = 16*1+1

    elseif dragon == 16*2+9 then

        card = 16*2+1

    elseif dragon == 16*3+9 then

        card = 16*3+1

    elseif dragon >= 16*4+4 then

        card = 16*4+1

    end

    if majiang == "shzhmj" and dragon == 16*4+7 then

        card = 16*4+5

    end

    return card
end

function ShYMJScene:getMajiang()
    return majiang
end


function ShYMJScene:onOutedCard(card, seat)
    local direct = self:getDirectCards(seat)
    if direct ~= nil then
        direct:addOut(card, max_player)
    end
end

function ShYMJScene:onCanelManager(card, seat)
    message.sendMessage("ShYMJ.Managed", {session=tableSession, seat=0, state=0})
end

function ShYMJScene:onSelectInfo(select)
    message.sendMessage("ShYMJ.SelectInfo", {session=tableSession, seat=0, select=select})
end
--开局显示左上角信息
local function show_start_game_info(self)
    print("显示左上角信息")
    if self.gameround ~= nil and self.delayHandler == nil then
        --基本信息
        local offset = 6
        local info = display.newSprite("ShYMJ/PrivateRoom/img_info.png")
        playersInfo.info = info
        :pos(85-6,display.height - 60+10)
        :addTo(self)
        --分数文字
        cc.ui.UILabel.new({
        color = cc.c3b(255,255,255),
        size = 20,
        text = "局数:",
        })
        :addTo(info)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(8-5,82-offset)
        --分数
        cc.ui.UILabel.new({
        color = cc.c3b(255,255,255),
        size = 22,
        text = self.gameround .. "/" .. app.constant.curRoomRound .. "局"
        })
        :addTo(info,1,99)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(59-5,82-offset)
        --房间号文字
        cc.ui.UILabel.new({
        color = cc.c3b(255,255,255),
        size = 20,
        text = "房号："
        })
        :addTo(info)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(8-5,52-offset)
        --房间号密码
        cc.ui.UILabel.new({
        color = cc.c3b(255,255,255),
        size = 23,
        text = tostring(table_code),
        })
        :addTo(info)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(59-5,52-offset)
        --延迟时间
        local delayTime = app.constant.delayTime
        --delayTime = offset90
        local netTime = cc.ui.UILabel.new({
            color = cc.c3b(255,0,0),
            size = 19,
            text = delayTime .. "ms"
        })
        :addTo(info)
        :setAnchorPoint(cc.p(1, 0.5))
        :setPosition(78-5,16-offset)
         local netBg = display.newSprite("Image/PrivateRoom/img_NetBg.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(info)
        :setPosition(83-5,22-offset)
        local netG = display.newSprite("Image/PrivateRoom/img_NetG.png")
            :setAnchorPoint(cc.p(0, 0.5))
            :addTo(info)
            :setPosition(83-5,22-offset)
            :hide()
        local netY = display.newSprite("Image/PrivateRoom/img_NetY.png")
            :setAnchorPoint(cc.p(0, 0.5))
            :addTo(info)
            :setPosition(83-5,22-offset)
            :hide()
        local setDelayTime =
        function()
            delayTime = app.constant.delayTime
            netTime:setString(delayTime .. "ms")
            if delayTime<100 then
                netG:show()
                netY:hide()
                netTime:setTextColor(cc.c3b(0,255,0))
                netG:setTextureRect(cc.rect(0,0,37,26))
            elseif delayTime<200 then
                netG:show()
                netY:hide()
                netTime:setTextColor(cc.c3b(0,255,0))
                netG:setTextureRect(cc.rect(0,0,30,26))
            elseif delayTime<1000 then
                netG:hide()
                netY:show()
                netTime:setTextColor(cc.c3b(217,135,79))
                netY:setTextureRect(cc.rect(0,0,18,26))
            else
                netG:hide()
                netY:show()
                netTime:setTextColor(cc.c3b(206,46,51))
                netY:setTextureRect(cc.rect(0,0,8,26))
            end
        end
        setDelayTime()
        if self.delayHandler == nil then
            self.delayHandler = schedulerSys.scheduleGlobal(
            function()
                setDelayTime()
            end, 1)
        end
    end
end

function ShYMJScene:dispatchMessage(name, msg)
    --print("dispatchMessage:" .. name)
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
                matchNode:hideLeftTime()
                matchNode:showMatchStart("比赛开始！")
            elseif msg.status == 4 then
                matchNode:hideLeftTime()
                matchNode:showMatchStart("")
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
    elseif name == "room.InitPrivateRoom" then      --初始化私人房
        print("初始化私人房")
        roomSession = msg.room_Session
        tableSession = msg.table_session
        table_code = msg.table_code
        max_player = msg.max_player
        seatIndex = msg.seatid
        gameState = msg.game_state
        if privateRoom ~= nil then
            privateRoom:tableSession(msg.table_session)
            privateRoom:roomSession(msg.room_Session)
        end

        huResult:setMaxPlayer(max_player,seatIndex)

        local gID = msg.gameid
        majiang = "shymj"
        if gID == 101 then
            majiang = "shymj"
        elseif gID == 103 then
            majiang = "shzhmj"
        end
        print("InitPrivateRoom = ",majiang)

        backGround:setMajiang(majiang)


        if self.gameround == nil then
            self.gameround = 0
        end

        self.table_session = msg.table_session
        self.room_Session = msg.room_Session
        self.table_code = msg.table_code
        self.seat_Index = msg.seatid
        self.max_player = msg.max_player
        self.customization = msg.customization

        if gameState == 0 then          --房卡游戏未开始
            if result ~= 2 then
                privateRoom:showSeat({seat_cnt = msg.max_player,table_code = msg.table_code,tableid = msg.tableid,gameround = msg.gameround,
                    pian_cnt = msg.pian_cnt, pay_type = msg.pay_type, customization = msg.customization, gameid = msg.gameid})
            end
        else
            show_start_game_info(self)
        end
    elseif name == "room.PrivateStart" then         --私人房间开局
        print("私人房间开局")
        --私人房开局
        gameState = 1
        if privateRoom then

            privateRoom:showRoomEndState(true)
            privateRoom:clear()
            privateRoom:removeFromParent()
            privateRoom = nil

        end
        --显示左上角信息
        show_start_game_info(self)
    elseif name == "room.TableStateInfo" then       --私人房间信息
        print("私人房间信息",msg.state)
        --清掉加载条
        self:closeProgressLayer()

        if gameState ~= 0 then
            if privateRoom then
                privateRoom:showRoomEndState(true)
                privateRoom:clear()
                privateRoom:removeFromParent()
                privateRoom = nil
            end
            self.gameround = msg.round
            playersInfo:setGameRound(self.gameround)
        end
        --本局游戏还没开始
        if msg.state == 0 and gameState ~= 0  then
            --恢复场景 游戏还没有开局 显示继续游戏按钮
            local game_continue = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_continue_0.png", pressed = "ShYMJ/btn_continue_0.png" })
            :onButtonClicked(function()
                print("发送准备请求")
                self.isReady = true
                message.sendMessage("game.ReadyReq", {
                    session = roomSession
                })
            end)
            :pos(display.cx,270)
            :addTo(self)
            :setName("game_continue")
            util.BtnScaleFun(game_continue)
        end

    elseif name == "room.UpdateSeat" then
        print("刷新分数")

        for i = 1,#msg.player do
            playersInfo:updateScore(self:getDirect(msg.player[i].seat), msg.player[i].gold)

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
            message.sendMessage("ShYMJ.Ready", {session=tableSession})
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
        local viptype = 0
        if msg.player.viptype ~= nil then
            viptype = msg.player.viptype
        end
        print("symj-room.EnterGame-----")
      --  dump(msg.player, "msg.pleryer = ")
        playersInfo:setPlayer(self:getDirect(msg.seat), msg.player.name, msg.player.gold, msg.player.sex, viptype, msg.player.imageid, msg.player.uid)
--modify end
        playersInfo:setState(self:getDirect(msg.seat), msg.player.ready>0)
        if seatIndex == msg.seat and msg.player.ready>0 then
            --删除继续游戏按钮
            local game_continue = self:getChildByName("game_continue")
            if game_continue then
                game_continue:removeSelf()
            end
        end
    elseif name == "room.LeaveGame" then
        print(msg.seat .."号玩家离开")
        if gameState == 0 then
        playersInfo:clearPlayer(self:getDirect(msg.seat))
        playersInfo:setState(self:getDirect(msg.seat), false)
        if msg.seat == seatIndex then
            seatIndex = 0
            tableSession = 0
            end
        end
    elseif name == "room.Ready" then
        print(msg.seat.."号玩家准备游戏")
        playersInfo:setState(self:getDirect(msg.seat), true)
        if seatIndex == msg.seat then
            --隐藏 邀请好友 开始游戏 按钮
            if privateRoom then
                privateRoom:hideButton()
            end
            --删除继续游戏按钮
            local game_continue = self:getChildByName("game_continue")
            if game_continue then
                game_continue:removeSelf()
            end
             --删除 结算界面
            huResult:clearResult()
        end
    elseif name == "room.ManagedNtf" then
        print("断线消息：room.ManagedNtf", "椅子号：" .. msg.seat, "状态：" .. msg.state)
        if gameState ~= 0 then
            -- msg.state  1 = 断线
            if not watchingGame then
                playersInfo:setManager(msg.state == 1, self:getDirect(msg.seat))
                if msg.seat == seatIndex then
                    managerGame = (msg.state == 0)
                end
            end
        end

    elseif name == "room.ChatMsg" then
       print("room.chatMsg-session, table_session", msg.session, roomSession)
       if roomSession == msg.session then
            if msg.info.chattype == 1 then
                 playersInfo:playEmotion(tonumber(msg.info.content), self:getDirect(msg.fromseat), self:getDirect(msg.toseat))
            end
       end
    elseif msg.session == tableSession then
        if name == "ShYMJ.Ready" then
            if isRestart then
                self:onStart()
            else

                if not matchid then

                    playersInfo:allowReady()

                elseif not table_code then

                    playersInfo:allowReady()

                end
            end
        elseif name == "ShYMJ.MajiangInfo" then
            self:restart()
            majiang = msg.majiang
            if majiang == "shzhmj" then
                playersInfo:setBanker(self:getDirect(msg.banker))
                --huResult:setBanker(msg.banker)
            end
        elseif name == "ShYMJ.StartGame" then
            print("游戏开始")
            if majiang == "shzhmj" then
                directTimer:clearTime()
                playersInfo:hideAllButton()
                baseScore = msg.score
            else
                self:restart()
                --显示花
                playersInfo:showHua(max_player)
            end
            if matchid ~= nil then
                matchNode:removeAll()
            end

            self.isReady = false
            self.gameround = self.gameround + 1
            playersInfo:setGameRound(self.gameround)

            print("scrore:",msg.score)
            huResult:setBaseScore(msg.score, majiang, self.customization)
            huResult:setCardNumber(msg.number)
            playersInfo:clearState()

        elseif name == "ShYMJ.BankerSeat" then
            cardWalls:showWalls(true, msg.points[1], msg.points[2], self:getDirect(msg.banker), majiang)
           -- playersInfo:setBanker(self:getDirect(msg.banker))
            print("msg.banker",msg.banker)
            playersInfo:setBanker(self:getDirect(msg.banker),msg.lian)
            huResult:setBanker(msg.banker,msg.lian)
             --huResult:setBanker(msg.banker)
            --modify by whb
	        huResult:setOpenCard(msg.dragon)
            --modify end
            --huResult:setDragon(msg.dragon)
            if majiang == "shzhmj" then
                --huResult:setPoints(0, 0)
                backGround:setPoints(0, 0)
            else
                print("ShYMJ.BankerSeat----")
                --huResult:setPoints(msg.points[1], msg.points[2])
                backGround:setPoints(msg.points[1], msg.points[2])
            end
            dragonCard = self:setDragonCard(msg.dragon)
            msgWorker.sleep(0.75)
            sound.rotateDice()
        elseif name == "ShYMJ.DistributeCard" then
             scheduler.performWithDelay(function()

                    print("YCMJ.DistributeCard----111")
                    cardWalls:showWalls(false)
                    huResult:showInfo()
                    backGround:showInfo()
                end, 1.0)
             scheduler.performWithDelay(function()
                    cardWalls:setBganihide()
                end, 2.5)
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
        elseif name == "ShYMJ.OutCard" then
            print("OutCard--msg.seat,",msg.seat)
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
        elseif name == "ShYMJ.OutedCard" then
            print("OutedCard--msg.seat,",msg.seat)
            outCards:outedCard(msg.card, msg.seat)
        elseif name == "ShYMJ.AllowOut" then
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            self:setBgLight(self:getDirect(msg.seat), msg.time, msg.seat)
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowOut(true, msg.card, 0)
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 0 if managerGame then manager = 1 end
            print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        elseif name == "ShYMJ.AllowOutEx" then
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            self:setBgLight(self:getDirect(msg.seat), msg.time, msg.seat)
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowOut(true, msg.card, msg.mode)
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 0 if managerGame then manager = 1 end
            print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        elseif name == "ShYMJ.AllowFlower" then
            if msg.time > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            end
            self:setBgLight(self:getDirect(msg.seat), msg.time, msg.seat)
            if seatIndex == msg.seat and not watchingGame and not managerGame then
                bottomCards:allowFlower(true, msg.card)
            end
        elseif name == "ShYMJ.DrawCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:drawCard(msg.card)
            end
            huResult:setCardNumber(msg.number)
            sound.drawCard(msg.card)
        elseif name == "ShYMJ.ComplementCard" then
            bottomCards:arrangeAnime(false)
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:complementCards(msg.card, msg.number==0)
                playersInfo:getHuaCards(msg.card, self:getDirect(msg.seat))
            end
            if msg.number > 0 then
                huResult:setCardNumber(msg.number)
            end
            print("ComplementCard-msg.seat = ", msg.seat)
            sound.complementCard(playersInfo:getSex(self:getDirect(msg.seat)), majiang)
            if seatIndex == msg.seat then
                bottomCards:allowFlower(false)
            end
        elseif name == "ShYMJ.AllowCombin" then
            bottomCards:arrangeAnime(false)
            if msg.time > 0 then
                if msg.allowOut > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.allowOut))
                else
                    directTimer:setTimer(msg.time, "")
                end
            end

            print("AllowCombin--allowOut = ",msg.allowOut)

            self:setBgLight(self:getDirect(msg.allowOut), msg.time, msg.allowOut)

            if not watchingGame then
                local count = #msg.combin
                for i = 1, count do
                    if msg.combin[i].out == seatIndex then
                        msg.combin[i].out = 0
                    end
                end

                if not managerGame then
                    playersInfo:allowCombin(msg.combin, msg.allowOut == seatIndex)
                    if #msg.combin ~= 0 then -- modify
                        directTimer:setTimer(msg.time, "bottom")
                        self:setBgLight("bottom", msg.time, 5)
                    end
                    if msg.allowOut == seatIndex then
                        bottomCards:allowOut(true, {}, 0)
                    end
                end
            end
        elseif name == "ShYMJ.AllowCombinEx" then
            bottomCards:arrangeAnime(false)
            if msg.time > 0 then
                if msg.allowOut > 0 then
                directTimer:setTimer(msg.time, self:getDirect(msg.allowOut))
                else
                    directTimer:setTimer(msg.time, "")
                end
            end

            print("AllowCombinEx--allowOut = ",msg.allowOut)

            self:setBgLight(self:getDirect(msg.allowOut), msg.time, msg.allowOut)

            if not watchingGame then
                local count = #msg.combin
                for i = 1, count do
                    if msg.combin[i].out == seatIndex then
                        msg.combin[i].out = 0
                    end
                end

                if not managerGame then
                    playersInfo:allowCombin(msg.combin, msg.allowOut == seatIndex)
                   if #msg.combin ~= 0 then  -- modify
                       directTimer:setTimer(msg.time, "bottom")
                       self:setBgLight("bottom", msg.time, 5)
                   end
                    if msg.allowOut == seatIndex then
                        bottomCards:allowOut(true, msg.card, msg.mode)
                    end
                end
            end
        elseif name == "ShYMJ.CombinCard" then
            playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                direct:combinCard(msg.combin.combin, msg.combin.card, self:getDirect(msg.combin.out))
            end
            directTimer:clearTime()
            outCards:combinCard(msg.combin.combin, self:getDirect(msg.seat))
            if majiang == "shzhmj" then
                if msg.combin.combin == "gang" then
                    local content = {}
                    for i = 1, max_player do
                        if i == msg.seat then
                            if msg.combin.out == i then
                                content[#content+1] = {direct=self:getDirect(i), text="+" .. 5 * baseScore * (max_player-1)}
                            else
                                content[#content+1] = {direct=self:getDirect(i), text="+" .. 5 * baseScore}
                            end
                        elseif msg.combin.out == msg.seat or msg.combin.out == i then
                            content[#content+1] = {direct=self:getDirect(i), text="-" .. 5 * baseScore}
                        end
                    end
                    outCards:gangNotify(true, content)
                end
            end
            sound.combinCard(msg.combin.combin, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "ShYMJ.EndGame" then
            playersInfo:clearManager()
            playersInfo:hideAllButton()
            directTimer:clearTime()
            liaotianSprite:hide()
            self.heads = {}
            self.weixinImage = {}
            for i = 1,max_player do

                self.heads[i] = playersInfo:getHead(self:getDirect(i))
                --dump(heads[i],"endGame:head[i] = ")
                self.weixinImage[i] = playersInfo:getWeixinHead(self:getDirect(i))
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
                    huResult:setResult(msg, watchingGame, majiang, self.heads, table_code, self.weixinImage, self.customization)
                    sound.gameResult(result)
                    --print("gameResult3:" .. type(matchid))
                    if matchid then
                        huResult:hideButton()
                    end
                end, 1.0)
            else
                huResult:setResult(msg, watchingGame, majiang, self.heads, table_code, self.weixinImage, self.customization)
                sound.gameResult(0)
                --print("gameResult:" .. type(matchid))
                if matchid then
                    huResult:hideButton()
                end
            end
            settingPanel:allowShare(true)
        elseif name == "ShYMJ.GameInfo" then
            dragonCard = self:setDragonCard(msg.dragon)
            playersInfo:setBanker(self:getDirect(msg.banker),msg.lian)
            huResult:setBanker(msg.banker,msg.lian)

            cardWalls:setBganihide()

            playersInfo:showHua(max_player)

           -- playersInfo:setBanker(self:getDirect(msg.banker))
           -- huResult:setBanker(msg.banker)
             --modify by whb
            huResult:setOpenCard(msg.dragon)
            --modify end
            print("scrore:",msg.score)
            --huResult:setPoints(msg.points[1], msg.points[2])
            backGround:setPoints(msg.points[1], msg.points[2])
            huResult:setBaseScore(msg.score, majiang, self.customization)
            huResult:setCardNumber(msg.number)
	        huResult:showInfo()
            backGround:showInfo()
        elseif name == "ShYMJ.PlayerInfo" then
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                --断线重连后清除原来数据
                direct:restart()

                outCards:restart()
                directTimer:restart()

                direct:complementCards(msg.flower)
                playersInfo:getHuaCards(msg.flower, self:getDirect(msg.seat))
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
        elseif name == "ShYMJ.Managed" then
            -- if not watchingGame then
            --      print("ShYMJ.Managed = ",msg.state,msg.seat)
            --     playersInfo:setManager(msg.state == 0, self:getDirect(msg.seat))
            --     if msg.seat == seatIndex then
            --         managerGame = (msg.state == 0)
            --     end
            -- end
        elseif name == "ShYMJ.AllowSelect" then
            playersInfo:clearState()
            cardWalls:showWalls(false)
            directTimer:setTimer(msg.time, "")
            if matchid ~= nil then
                matchNode:removeAll()
            end
            if msg.select > 0 then
                playersInfo:allowMopao()
            end
        elseif name == "ShYMJ.SelectInfo" then
            print("ShYMJ.SelectInfo--")
            --清理已准备标示
            for i=1,max_player do
                local ready = self:getChildByName("ready" .. i)
                if ready then
                    ready:removeSelf()
                end
            end
            if msg.select > 0 then
                playersInfo:setMopao(self:getDirect(msg.seat))
            end
            if msg.seat == seatIndex then
                playersInfo:hideAllButton()
            end
        elseif name == "ShYMJ.Termination" then
            if privateRoomRecord then
                privateRoomRecord:performWithDelay(function()
                    local weixinImage = {}
                    for i = 1,max_player do
                        weixinImage[i] = playersInfo:getWeixinHead(self:getDirect(i))
                    end
                    print("termination--majiang = ",majiang)
                    privateRoomRecord:showPrivateRoomRecord(true,msg,weixinImage,majiang)
                    end, 5)
            end
        end
    end
end

function ShYMJScene:getViewSeat(realSeat)
    return (realSeat + max_player - seatIndex) % max_player + 1
end

function ShYMJScene:getDirect(seat)
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

function ShYMJScene:getDirectCards(seat)
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

function ShYMJScene:getTopCards()
    if topCards ~= nil then
        return topCards:getCardsArray()
    end
end

function ShYMJScene:getLeftCards()
    if leftCards ~= nil then
        return leftCards:getCardsArray()
    end
end

function ShYMJScene:getRightCards()
    if rightCards ~= nil then
        return rightCards:getCardsArray()
    end
end

function ShYMJScene:showBaozi()
    if huResult ~= nil then
        huResult:showBaoziInfo()
    end
end

function ShYMJScene:restart()
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

function ShYMJScene:clearScene()
    if self.delayHandler then
        schedulerSys.unscheduleGlobal(self.delayHandler)
        self.delayHandler = nil
    end

    if settingPanel ~= nil then
        settingPanel:setOnShow()
    end
    print("ShYMJScene:clearScene()")
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
    gameState = nil

    matchSession = 0
    matchid = nil
    tempSingnCount = 0
    isMatchInit = false
    isMatchStatus = false

    msgWorker.clear()
    scheduler.clear()
end

function ShYMJScene:SendEmotion(id, direct)
    local toSeat = util.getToSeat(direct, max_player, seatIndex)
    print("发送表情消息-toSeat = ,direct = ",toSeat, direct)
    print("发送表情消息-roomsession =",roomSession)
    message.sendMessage("game.ChatReq", {session = roomSession,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
end

function ShYMJScene:HideAllhua()
    if playersInfo ~= nil then
        playersInfo:HideAllHuaBg()
    end
    if settingPanel ~= nil then
        local isOn = settingPanel:IsOnShow()
        if isOn == false then
            settingPanel:onShowButton(false)
        end
    end

end

function ShYMJScene:setBgLight(direct, time, outSeat)

    local isTrue = false
    if tonumber(time) <= 18 then
        isTrue = true
    end
    if backGround ~= nil then
        backGround:setLight(direct, isTrue, seatIndex, outSeat, max_player)
    end

end

function ShYMJScene:getMaxPlayers()

    if max_player ~= nil then
        return max_player
    end
    return nil
end

function ShYMJScene:exitScene()
    errorLayer.new(app.lang.room_over_leave, nil, nil, 
        function()
                print("断线重连时房间不存在2")
                self:onLeave()
        end):addTo(self, 1000)
end

function ShYMJScene:closeProgressLayer()

    local progressLayer = self:getChildByTag(progressTag)
    if progressLayer then
      print("ShYMJScene:closeProgressLayer--移除加载")
      ProgressLayer.removeProgressLayer(progressLayer)
    end
  end

function ShYMJScene:socket(msg)

    print("ShYMJScene:socket = ", msg)
    if msg == "SOCKET_TCP_CONNECTED" then

        PRMessage.EnterPrivateRoomReq(app.constant.privateCode)
        if gameState == 0 then

                if self.isReady then
                    self.isReady = true
                    message.sendMessage("game.ReadyReq", {
                        session = roomSession
                    })
                end
        end

        self:closeProgressLayer()
    elseif msg == "SOCKET_TCP_CLOSED" then
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.reconnect_loading):addTo(self, 8888, progressTag)
        end
    elseif msg == "SOCKET_TCP_CONNECT_FAILURE" then
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.serverRestart_loading):addTo(self, 8888, progressTag)
        end
        print("SOCKET_TCP_CONNECT_FAILURE----")
    end

end

return ShYMJScene