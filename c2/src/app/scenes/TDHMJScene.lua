--推倒胡麻将
local TDHMJScene = class("TDHMJScene", function()
    return display.newScene("TDHMJScene")
end)

local scheduler = require("app.Common.LocalScheduler").new()
local message = require("app.net.Message")
local sound = require("app.Games.TDHMJ.MJSound")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")
local util = require("app.Common.util")

local MatchMessage = require("app.net.MatchMessage")

local backGround      --背景
local cardWalls       --牌堆
local topCards        --顶部牌
local leftCards       --左边牌
local rightCards      --右边牌
local bottomCards     --底部牌
local outCards        --出牌
local playersInfo     --玩家信息
local directTimer     --倒计时
local huResult        --胡牌结果
local settingPanel    --设置面板
local matchNode       --比赛节点
--加载资源
local MJSpriteFrame

local max_player      --最大玩家数量

local msgIndex = 0    --消息下标

local seatIndex = 0      --座位下标

local tableSession = 0   --表格回话
local matchSession = 0   --比赛回话

local dragonCard         --

local watchingGame = false     --
local managerGame = false      --
local isRestart = false        --

local majiang = ""
local baseScore = 0            --基础分

-- local playTab={}
-- local playNum=1
-- playTab.name={}
-- playTab.seat={}

-- local fishTab={}
-- fishTab.seat={}
-- fishTab.num={}

local BankerSeat

local matchid = nil
local tempSingnCount = 0
local isMatchInit = false
local isMatchStatus = false
local liaotianSprite =nil


function TDHMJScene:ctor()
    print("TDHMJScene:ctor:宁夏麻将222222+++++++++++++++++++++")
    sound.init()

    MJSpriteFrame = require("app.Games.TDHMJ.MJSpriteFrame").new()
    :init(self)

    backGround = require("app.Games.TDHMJ.MJBackground").new()
    :addTo(self)
    :init(self) 
    
    cardWalls = require("app.Games.TDHMJ.MJWalls").new()
    :addTo(self)
    :init(self) 
    
    topCards = require("app.Games.TDHMJ.MJTopCards").new()
    :addTo(self)
    :init(self) 
    
    leftCards = require("app.Games.TDHMJ.MJLeftCards").new()
    :addTo(self)
    :init(self) 
    
    rightCards = require("app.Games.TDHMJ.MJRightCards").new()
    :addTo(self)
    :init(self) 
    
    bottomCards = require("app.Games.TDHMJ.MJBottomCards").new()
    :addTo(self)
    :init(self) 
    
    playersInfo = require("app.Games.TDHMJ.MJPlayers").new()
    :addTo(self)
    :init(self)

    directTimer = require("app.Games.TDHMJ.MJTimer").new()
    :addTo(self)
    :init(self) 

    outCards = require("app.Games.TDHMJ.MJOutCard").new()
    :addTo(self)
    :init(self) 

    liaotianSprite = display.newSprite()
    :addTo(self)
    if util.UserInfo.watching == false then

         -- 设置语音聊天按钮
         util.SetVoiceBtn(self,liaotianSprite)
         
    end
    
    huResult = require("app.Games.TDHMJ.MJResult").new()
    :addTo(self)
    :init(self)

    matchNode = require("app.Games.TDHMJ.MJMatch").new()
    :addTo(self)

    settingPanel = require("app.Games.TDHMJ.MJSetting").new()
    :addTo(self)
    :init(self)

    

    msgWorker.init("TDHMJ", handler(self, self.dispatchMessage))

    
end

function TDHMJScene:onEnter()
end

function TDHMJScene:onExit()
    print("清空了对象吗？")
    self:clearScene()
end

function TDHMJScene:onStart()
    if not watchingGame then
        util.SetRequestBtnHide()
        message.dispatchGame("room.ReadyReq", {})
        print("准备开始游戏++++")
    end
end
--下鱼子消息
-- function TDHMJScene:sendFishScore(num)
--     print("发送下鱼子消息++++")
--     message.sendMessage("TDHMJ.Fish", {session=tableSession, amounts=num})

    
-- end


function TDHMJScene:onLeave()
    if matchid then
        print("ts:" .. matchSession)
        MatchMessage.LeaveMatchReq(matchSession)
    else
        message.dispatchGame("room.LeaveGame", {})
        
    end
end

function TDHMJScene:onSound(open)
    sound.setState(open)
end

function TDHMJScene:onRestart()
    print("restart1")
    self:restart()
    if not watchingGame then
        if tableSession == 0 or seatIndex == 0 then
            errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
                self:onLeave()
            end):addTo(self)
            return 
        end
        message.sendMessage("TDHMJ.Ready", {session=tableSession})
        isRestart = true
    end
end
--选中牌时显示其他已出的牌，看看是否有和当前要出的牌一样的
function TDHMJScene:ShowCompareCard(card)
    print("选中牌的值:" ..card)
    bottomCards:ShowShadow(card)
    leftCards:ShowShadow(card)
    rightCards:ShowShadow(card)
    topCards:ShowShadow(card)
end
--清楚比较牌后的显示效果
function TDHMJScene:HideCompareCard()
    bottomCards:HideShadow()
    leftCards:HideShadow()
    rightCards:HideShadow()
    topCards:HideShadow()
end


function TDHMJScene:onOutCard(card)
    print("我要出牌了：" ..card)
    message.sendMessage("TDHMJ.OutCard", {session=tableSession, seat=0, card=card})
    print("已经出了牌了")
end

function TDHMJScene:onCombinCard(combin, card,chi)--
    print("做了碰杠胡操作1")
    if combin=="gang" then
        print("做了碰杠胡操作2")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0,tp="ming_gang", card=card, out=0})
    elseif combin=="chi" then
        print("做了碰杠胡操作3")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0, tp="chi", card=chi, out=0,chi_combins=card})
    elseif combin=="bugang" then
        print("做了碰杠胡操作3")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0, tp="bu_gang", card=card, out=0})
    elseif combin=="angang" then
        print("做了碰杠胡操作4")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0, tp="an_gang", card=card, out=0})
    elseif combin=="peng" then
        print("做了碰杠胡操作5")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0, tp="peng", card=card, out=0})
    elseif combin=="hun" then
        print("做了碰杠胡操作6")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0, tp="hu", card=card, out=0})
    elseif combin=="drop" then
        print("做了碰杠胡操作7")
        message.sendMessage("TDHMJ.CombinCard", {session=tableSession, seat=0, tp="ignore", card=card, out=0})
    end
end

function TDHMJScene:onHuCard()  --胡牌消息
    message.sendMessage("TDHMJ.HuCard", {session=tableSession})
end

function TDHMJScene:onTingCard() --听牌消息
    message.sendMessage("TDHMJ.Ting", {session=tableSession,seat=seatIndex})
end

function TDHMJScene:onIgnoreCard() --放弃消息
    message.sendMessage("TDHMJ.IgnoreCard", {session=tableSession})
end

function TDHMJScene:getDragonCard()

    return dragonCard
end

function TDHMJScene:getMajiang()
    return majiang
end

function TDHMJScene:onOutedCard(card, seat)
    local direct = self:getDirectCards(seat)
    if direct ~= nil then
        direct:addOut(card, max_player)
    end
end

-- function TDHMJScene:onCanelManager1(card, seat)
--     message.sendMessage("TDHMJ.Managed", {session=tableSession, seat=0, state=1})
-- end

function TDHMJScene:onCanelManager(card, seat)
    message.sendMessage("TDHMJ.Managed", {session=tableSession, seat=0, state=0})
end

function TDHMJScene:onSelectInfo(select)
    message.sendMessage("TDHMJ.SelectInfo", {session=tableSession, seat=0, select=select})
end
--要牌器
function TDHMJScene:AddCardYW(Addcard)
    -- local tab={}

    message.sendMessage("TDHMJ.RequestCard", {session=tableSession, seat=0, cards=Addcard})
end

function TDHMJScene:dispatchMessage(name, msg)
    -- print("dispatchMessage:" .. name)
    -- print("下鱼子++++++++")
    -- print("-----------------------")
    -- dump(msg)
    -- print("-----------------------")
    
--     local msgTab={
-- ["huang"]=0,
-- ["player_infos"]={
-- [1]={
-- ["total"]="0",
-- ["hard_flowers"]=0,
-- ["bu_gangs"]={
-- },
-- ["soft_flowers"]=0,
-- ["pengs"]={
-- },
-- ["an_gangs"]={
-- },
-- ["seat"]=1,
-- ["fa_kuan_flowers"]="0",
-- ["bu_gang_flowers"]="0",
-- ["hua_gang_flowers"]="0",
-- ["ming_gang_flowers"]="0",
-- ["card_type"]={
-- },
-- ["an_gang_flowers"]="0",
-- ["hand_cards"]={
-- [1]=17,
-- [2]=17,
-- [3]=19,
-- [4]=19,
-- [5]=21,
-- [6]=38,
-- [7]=41,
-- [8]=51,
-- [9]=52,
-- [10]=54,
-- [11]=55,
-- [12]=57,
-- [13]=66,
-- },
-- ["name"]="5bCP6buE6buE",
-- ["ming_gangs"]={
-- },
-- },
-- [2]={
-- ["total"]="0",
-- ["hard_flowers"]=4,
-- ["bu_gangs"]={
-- },
-- ["soft_flowers"]=0,
-- ["pengs"]={
-- },
-- ["an_gangs"]={
-- },
-- ["seat"]=2,
-- ["fa_kuan_flowers"]="0",
-- ["bu_gang_flowers"]="0",
-- ["hua_gang_flowers"]="0",
-- ["ming_gang_flowers"]="0",
-- ["card_type"]={
-- },
-- ["an_gang_flowers"]="0",
-- ["hand_cards"]={
-- [1]=20,
-- [2]=21,
-- [3]=23,
-- [4]=24,
-- [5]=33,
-- [6]=34,
-- [7]=35,
-- [8]=38,
-- [9]=40,
-- [10]=40,
-- [11]=49,
-- [12]=55,
-- [13]=65,
-- },
-- ["name"]="55So5oi3MDAwODA0OTk=",
-- ["ming_gangs"]={
-- },
-- },
-- [3]={
-- ["fa_kuan_flowers"]="0",
-- ["card_type"]={
-- [1]={
-- ["tp"]=15,
-- ["flowers"]="40",
-- },
-- },
-- ["ming_gang_flowers"]="+10",
-- ["an_gang_flowers"]="0",
-- ["hand_cards"]={
-- [1]=37,
-- [2]=37,
-- [3]=68,
-- [4]=68,
-- },
-- ["ming_gangs"]={
-- [1]=18,
-- },
-- ["bu_gangs"]={
-- },
-- ["seat"]=3,
-- ["an_gangs"]={
-- },
-- ["bu_gang_flowers"]="0",
-- ["total"]="+12800",
-- ["name"]="55So5oi3MDAwODA0OTY=",
-- ["hard_flowers"]=1,
-- ["soft_flowers"]=1,
-- ["lead_to"]={
-- ["card_from"]=4,
-- ["card"]=37,
-- },
-- ["pengs"]={
-- [1]=23,
-- [2]=22,
-- },
-- ["hua_gang_flowers"]="0",
-- },
-- [4]={
-- ["total"]="-12800",
-- ["hard_flowers"]=1,
-- ["bu_gangs"]={
-- },
-- ["soft_flowers"]=0,
-- ["pengs"]={
-- },
-- ["an_gangs"]={
-- },
-- ["seat"]=4,
-- ["fa_kuan_flowers"]="0",
-- ["bu_gang_flowers"]="0",
-- ["hua_gang_flowers"]="0",
-- ["ming_gang_flowers"]="0",
-- ["card_type"]={
-- },
-- ["an_gang_flowers"]="0",
-- ["hand_cards"]={
-- [1]=22,
-- [2]=25,
-- [3]=36,
-- [4]=36,
-- [5]=38,
-- [6]=41,
-- [7]=50,
-- [8]=51,
-- [9]=52,
-- [10]=54,
-- [11]=55,
-- [12]=65,
-- [13]=66,
-- },
-- ["name"]="55So5oi3MDAwODA0OTc=",
-- ["ming_gangs"]={
-- },
-- },
-- },
-- ["bixiahu"]=1,
-- ["banker"]=1,
-- }
-- local heads = {
--         [1] = "Image/Common/Avatar/male_5.png",
--         [2] = "Image/Common/Avatar/male_5.png",
--         [3] = "Image/Common/Avatar/male_5.png",
--         [4] = "Image/Common/Avatar/male_5.png",
--     }
    
    -- huResult:setResult(msgTab, false,heads)
    

    
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
    elseif name == "room.InitGameScenes" then
    --     print("下鱼子！！！！！！！！！！！！！")
    -- playersInfo:SetFishState(true)
    -- playersInfo:DownTimer(10)
        print("room.InitGameScenes+++++")
        

        seatIndex = msg.seat
        tableSession = msg.session
        if matchid == nil then
            max_player = msg.max_player

        end
        --保存玩家座位
        huResult:setMaxPlayer(max_player,seatIndex)
        print("seatIndex:" .. seatIndex .. ",max_player:" .. max_player)
        watchingGame = msg.watching
        bottomCards:watching(watchingGame)

        if not watchingGame then
            --print("TDHMJ.Ready")
            message.sendMessage("TDHMJ.Ready", {session=tableSession})
        end
        majiang = msg.gamekey
        print("gamekey:" .. majiang)
        baseScore = 0
        managerGame = false
        backGround:setMajiang(majiang)--可用于设置不同子游戏的游戏背景（函数并没有具体的实现，是个空函数）

        if matchid ~= nil then
            matchNode:removeLeftTime()
        end

    elseif name == "room.EnterGame" then
        --modify wby whb 161031
        local viptype = 0
        if msg.player.viptype ~= nil then 
            viptype = msg.player.viptype
        end
        -- playTab.name[playNum]=msg.player.name
        -- playTab.seat[playNum]=msg.seat
        -- playNum=playNum+1
        --设置玩家的基本信息
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
        -- self.liaotianSprite:show()
        if name == "TDHMJ.Ready" then
            print("TDHMJ.Ready")
            if isRestart then
                self:onStart()
            else
                if not matchid then
                -------------------------------
                    --下鱼子
                    
                    --------------------------------
                    print("")
                    util.SetRequestBtnShow()
                    playersInfo:allowReady()
                end
            end
        elseif name == "TDHMJ.MajiangInfo" then
            print("TDHMJ.MajiangInfo")
            print("restart2")
            self:restart()
            majiang = msg.majiang
            if msg.banker then
                playersInfo:setBanker(self:getDirect(msg.banker),max_player)
            end
        -- elseif name == "TDHMJ.AllowFish" then
        --     print("TDHMJ.AllowFish")
        --     print("下鱼子")
            
        --     playersInfo:setState("all", false) --隐藏所有人的准备
        --     playersInfo:SetFishState(true) --显示下鱼子
        --     -- playersInfo:DownTimer(msg.time)
        --     directTimer:setTimer(msg.time, "FishTime")
        --     print("AllowFish" ..msg.fish)
        --     if msg.fish==10 then
        --         --todo
        --         playersInfo:SetFishTouch(false)
        --     else
        --         playersInfo:SetFishTouch(true)
        --         -- playersInfo:SetFishNum(self:getDirect(seatIndex), msg.fish)
        --     end
        --     directTimer:setPosition(0,130)

        --     -- directTimer:setPosition(0,50)
        --     print("倒计时时间: " ..msg.time)
        -- elseif name == "TDHMJ.Fish" then
        --     print("TDHMJ.Fish+++++")
        --     print("有人下鱼了" ..msg.amounts)
        --     if msg.seat==seatIndex then
        --         playersInfo:SetFishTouch(true)
        --     end
        --     if msg.amounts~=10 then
        --         --todo
        --         playersInfo:SetFishNum(self:getDirect(msg.seat), msg.amounts)  --显示下鱼子数目
        --         -- table.insert(fishTab.seat,msg.seat)
        --         -- table.insert(fishTab.num,msg.amounts)
        --     end
            
            
            

        elseif name == "TDHMJ.StartGame" then
            print("TDHMJ.StartGame")
            print("restart3")
            self:restart()

            -- dump(msg, "TDHMJ.StartGame+++++++++", 3)
            if matchid ~= nil then --移除比赛显示的节点
                matchNode:removeAll()
            end
            
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            playersInfo:clearState()
            playersInfo:SetBixiahu(msg.bixiahu)--显示比下胡
        elseif name == "TDHMJ.BankerSeat" then   --庄家信息
            print("TDHMJ.BankerSeat")
            -- playersInfo:SetFishState(false)--隐藏下鱼子
            -- playersInfo:StopTimer()  --停止倒计时
            directTimer:clearTime()
            cardWalls:showWalls(true, msg.points[1], msg.points[2], self:getDirect(msg.banker))--掷色子
            playersInfo:setBanker(self:getDirect(msg.banker),max_player)
            BankerSeat=msg.banker
            --modify by whb
            -- huResult:setOpenCard(msg.feng_quan)
            --modify end
            -- if majiang == "shzhmj" then
            --     huResult:setPoints(0, 0)
            -- else
            -- huResult:setPoints(msg.points[1], msg.points[2])
            -- en￼d
            -- dragonCard = msg.feng_quan
            msgWorker.sleep(0.75)
            sound.rotateDice()
        elseif name == "TDHMJ.DistributeCard" then  --发牌接口  第一次收到的牌（另加每次摸牌的走的消息）
            print("TDHMJ.DistributeCard+++++++++" ..msg.finish)
            --要牌器
            -- if msg.finish>3 and msg.seat == seatIndex then
            --     print("请求发牌10")
            --     playersInfo:addCardYouWant(1)
            -- else
            directTimer:clearTime() --关闭要牌器的定时器
            playersInfo:addCardYouWant(0)
            if msg.finish<3 then     --发牌
                print("发牌")
                
                
                cardWalls:showWalls(false)
                local direct = self:getDirectCards(msg.seat)
                if direct ~= nil then
                    direct:distributeCards(msg.cards)
                end
                huResult:setCardNumber(msg.number)
                print("发牌1")
                if msg.finish == 2 then    --停止发牌
                    scheduler.performWithDelay(function()
                    bottomCards:arrangeAnime(true)
                    end, 0.25)
                msgWorker.sleep(0.5)
                print("发牌2")
                end
            elseif  msg.finish >2 then  --摸牌
                print("摸牌消息1")
                playersInfo:hideAllButton()
                print("摸牌消息2")
                local direct = self:getDirectCards(msg.seat)
                 print("摸牌消息3")
                if direct ~= nil then
                     print("摸牌消息4" )
                    direct:drawCard(msg.cards,msg.finish==4)
                     print("摸牌消息5")
                end
                 print("摸牌消息6")
                huResult:setCardNumber(msg.number)
                 print("摸牌消息7")
                sound.drawCard()
                 print("摸牌消息8")
                -- print("发牌3" ..msg.seat "number" ..msg.number "card" ..msg.card "fisnish" ..msg.finish)
            end
        -- end
        elseif name == "TDHMJ.AllowRequestCard" then
            print("允许要牌")
            directTimer:setTimer(msg.time, self:getDirect(msg.seat))
            directTimer:setPosition(0,0)
            if seatIndex == msg.seat then
                --todo
                playersInfo:addCardYouWant(1)
            end
            
        elseif name == "TDHMJ.OutCard" then   --告诉所有玩家出牌  手牌上面的显示效果 同时将上一个玩家出的牌显示到桌面上
            print("TDHMJ.OutCard:" .. msg.card)

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

           
        elseif name == "TDHMJ.OutedCard" then    --用于将玩家的牌保存起来，下一次调用outcard消息时再将其显示出来
            print("TDHMJ.OutedCard:" .. msg.card)
            -- local direct = self:getDirectCards(msg.seat)
            -- if direct ~= nil then
            --     direct:outCard(msg.card)
            -- end
            self:HideCompareCard()
            outCards:outedCard(msg.card, msg.seat)
            
            
        elseif name == "TDHMJ.AllowOut" then     --发过来的是不可以出的牌（告诉玩家可以出的牌）
            print("TDHMJ.AllowOut")
            playersInfo:addCardYouWant(0) ---隐藏请求发牌
            bottomCards:arrangeAnime(false)
            playersInfo:hideAllButton()
            print("AllowOutTime1:" ..msg.time)
            if msg.time > 0 then
                print("AllowOutTime2:" ..msg.time)
                print("AllowOutTime2:" ..self:getDirect(msg.seat))
                directTimer:setTimer(msg.time, self:getDirect(msg.seat))
                directTimer:setPosition(0,0)
            end
            -- print("托管出牌::" ..msg.seat .."managerGame:" ..managerGame)
            if  seatIndex == msg.seat and not watchingGame and not managerGame then
                print("TDHMJ.AllowOut22222托管")
                
                bottomCards:allowOut(true, msg.cards, msg.mode)
                
                
            end
            local watch = 0 if watchingGame then watch = 1 end
            local manager = 1 if managerGame then manager = 0 end
            -- print("AllowOut seatIndex=" .. seatIndex .. " msg.seat:" .. msg.seat .. " watchingGame:" .. watch .. " managerGame:" .. manager)
        -- elseif name == "TDHMJ.AllowOutEx" then
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
        -- elseif name == "TDHMJ.AllowFlower" then  --告诉可以出花牌
        --     if msg.time > 0 then
        --         directTimer:setTimer(msg.time, self:getDirect(msg.seat))
        --     end
        --     if seatIndex == msg.seat and not watchingGame and not managerGame then
        --         bottomCards:allowFlower(true, msg.card)
        --     end
        -- elseif name == "TDHMJ.DrawCard" then  --摸牌消息
        --     playersInfo:hideAllButton()
        --     local direct = self:getDirectCards(msg.seat)
        --     if direct ~= nil then
        --         direct:drawCard(msg.card)
        --     end
        --     huResult:setCardNumber(msg.number)
        --     sound.drawCard(msg.card)
        elseif name == "TDHMJ.ComplementCard" then --移除手牌中的花牌
            print("TDHMJ.ComplementCard")
            dump(msg, "花牌")
            print("TDHMJ.ComplementCard1")
            bottomCards:arrangeAnime(false)
            print("TDHMJ.ComplementCard2")
            local direct = self:getDirectCards(msg.seat)
            print("TDHMJ.ComplementCard3")
            if direct ~= nil then
                print("TDHMJ.ComplementCard4")
                direct:complementCards(msg.cards, msg.number~=0)
                print("TDHMJ.ComplementCard5")
                sound.combinCard("buhua", playersInfo:getSex(self:getDirect(msg.seat)), majiang)
            end
            if msg.number > 0 then
                print("TDHMJ.ComplementCard6")
                huResult:setCardNumber(msg.number)
            end
            -- sound.complementCard(playersInfo:getSex(self:getDirect(msg.seat)), majiang)
            -- if seatIndex == msg.seat then
            --     bottomCards:allowFlower(false)
            -- end
            -- playersInfo:SetFlowerNum(self:getDirect(msg.seat),#msg.card)  --显示花牌数目
        elseif name == "TDHMJ.AllowTing" then   --允许玩家听牌

            playersInfo:addCardYouWant(0) ---隐藏要牌器
            bottomCards:arrangeAnime(false)
            dump(msg)
            if msg.time > 0 then
                if msg.seat > 0 then
                    directTimer:setTimer(msg.time, self:getDirect(msg.seat))
                    directTimer:setPosition(0,0)
                else
                    directTimer:setTimer(msg.time, "")
                    directTimer:setPosition(0,0)
                end
            end
            if not watchingGame then
                if not managerGame then
                    if msg.seat == seatIndex then
                        playersInfo:allowTing()
                    end
                end
            end
        elseif name == "TDHMJ.AllowCombin" then   --允许玩家碰杠胡

            playersInfo:addCardYouWant(0) ---隐藏要牌器
            print("TDHMJ.AllowCombin1")
            bottomCards:arrangeAnime(false)
            print("TDHMJ.AllowCombin2")
           
            dump(msg)

            if msg.time > 0 then
                print("TDHMJ.AllowCombin3")
                if msg.seat > 0 then
                    print("TDHMJ.AllowCombin4")
                    directTimer:setTimer(msg.time, self:getDirect(msg.seat))
                    print("TDHMJ.AllowCombin5")
                    directTimer:setPosition(0,0)
                    print("TDHMJ.AllowCombin6")
                else
                    directTimer:setTimer(msg.time, "")
                    print("TDHMJ.AllowCombin7")
                    directTimer:setPosition(0,0)
                    print("TDHMJ.AllowCombin8")
                end
            end
            
            if not watchingGame then
                print("TDHMJ.AllowCombin9")
                -- local count = #msg.beope
                -- for i = 1, count do
                --     if msg.combin[i].out == seatIndex then
                --         msg.combin[i].out = 0
                --     end
                -- end

                if not managerGame then
                    print("TDHMJ.AllowCombin10")
                    if msg.seat == seatIndex then
                        print("TDHMJ.AllowCombin11")
                        playersInfo:allowCombin(msg)
                        print("TDHMJ.AllowCombin12")
                    end
                    -- if msg.seat == seatIndex then
                    --     bottomCards:allowOut(true, {}, 0)
                    -- end
                end
            end
        -- elseif name == "TDHMJ.AllowCombinEx" then --本人碰杠的操作
        --     bottomCards:arrangeAnime(false)
        --     if msg.time > 0 then
        --         if msg.allowOut > 0 then
        --         directTimer:setTimer(msg.time, self:getDirect(msg.allowOut))
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
        --             if msg.allowOut == seatIndex then
        --                 bottomCards:allowOut(true, msg.card, msg.mode)
        --             end
        --         end
        --     end
        elseif name == "TDHMJ.CombinCard" then  --其他玩家的碰杠胡操作（包含自己） 两个座位标识  msg.seat代表出牌的标识   msg.combin.out代表碰杠胡的标识
            playersInfo:addCardYouWant(0) ---隐藏要牌器
            print("TDHMJ.CombinCard")
            print("碰杠胡操作 " ..msg.tp  .."胡的牌" ..msg.card)
            playersInfo:hideAllButton()
            directTimer:clearTime()
            
            --加减分动作
            outCards:combinScore(msg.score_info)
                
            
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil and msg.tp~="hua_gang" and msg.tp~="fa_kuan1" and msg.tp~="fa_kuan2" then
                print("TDHMJ.CombinCard++++++++")
                if msg.tp~="chi" then
                    --todo
                    direct:combinCard(msg.tp, msg.card, self:getDirect(msg.out),msg.chi_combins)
                else
                    direct:combinCard(msg.tp, msg.card, self:getDirect(msg.out))
                end
                
            end
            
            outCards:combinCard(msg.tp, self:getDirect(msg.seat))
            sound.combinCard(msg.tp, playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "TDHMJ.HuCard" then   --胡牌显示效果
            print("TDHMJ.HuCard")
            -- playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            directTimer:clearTime()
            
            outCards:combinCard("hu", self:getDirect(msg.seat))
            
            sound.combinCard("hu", playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        
        elseif name == "TDHMJ.Ting" then   --听牌显示效果
            print("TDHMJ.Ting")
            -- playersInfo:hideAllButton()
            local direct = self:getDirectCards(msg.seat)
            directTimer:clearTime()
            outCards:combinCard("Ting", self:getDirect(msg.seat))
            sound.combinCard("Ting", playersInfo:getSex(self:getDirect(msg.seat)), majiang)
        elseif name == "TDHMJ.EndGame" then   --游戏结束接口
            print("TDHMJ.EndGame")
            -- self.liaotianSprite:hide()
            playersInfo:clearManager()
            playersInfo:hideAllButton()
            directTimer:clearTime()
            print("游戏结束+++++++=======")
            -- dump(msg,"游戏结束")
            -- huResult:showInfo() ---测试用
            local result = -1
            if  msg.player_infos~=nil then
                
                for i=1,#msg.player_infos do
                    if msg.huang~=1 then    
                        outCards:combinCard("hu", self:getDirect(msg.player_infos[i].seat))
                        sound.combinCard("hu", playersInfo:getSex(self:getDirect(msg.player_infos[i].seat)), majiang)

                        if msg.player_infos[i].seat == seatIndex and msg.player_infos[i].lead_to~=nil and type(msg.player_infos[i].lead_to)=="table" and msg.player_infos[i].lead_to.card~=0 then
                            scheduler.performWithDelay(function()
                                sound.gameResult(1)
                                result = 1
                            end, 1.0)
                        end
                    else
                        scheduler.performWithDelay(function()
                            sound.gameResult(0)
                        end, 1.0)
                        result = 0
                     end
                end
                if  result==-1 then
                    scheduler.performWithDelay(function()
                            sound.gameResult(-1)
                    end, 1.0)
                end
            end
            local heads = {}
            for i = 1,max_player do
                heads[i] = playersInfo:getHead(self:getDirect(i))
            end
        -- local heads = {
        --     [1] = "Image/Common/Avatar/male_5.png",
        --     [2] = "Image/Common/Avatar/male_5.png",
        --     [3] = "Image/Common/Avatar/male_5.png",
        --     [4] = "Image/Common/Avatar/male_5.png",
        -- }
            huResult:setResult(msg, watchingGame,heads)
            -- playTab={}
            -- playNum=1
            -- playTab.name={}
            -- playTab.seat={}
            
            -- sound.combinCard("hun", playersInfo:getSex(self:getDirect(msg.hun)), majiang)

            settingPanel:allowShare(true)
            liaotianSprite:hide()
        elseif name == "TDHMJ.GameInfo" then   -- 游戏信息
            print("TDHMJ.GameInfo")
            dump(msg)
            -- dragonCard = msg.feng_quan
            playersInfo:setBanker(self:getDirect(msg.banker),max_player)
            BankerSeat=msg.banker
             --modify by whb
            -- huResult:setOpenCard(msg.feng_quan)
            --modify end
            -- huResult:setPoints(msg.points[1], msg.points[2])
            huResult:setBaseScore(msg.score)
            huResult:setCardNumber(msg.number)
            playersInfo:SetBixiahu(msg.bixiahu)--显示比下胡
        elseif name == "TDHMJ.PlayerInfo" then  --玩家信息
            print("TDHMJ.PlayerInfo+++")
            print("TDHMJ.PlayerInfo+++" ..msg.seat)
            print("----------------")
            dump(msg)
            print("----------------")
            
            util.SetRequestBtnHide()--隐藏邀请好友按钮
            directTimer:setPosition(0,0)
            local direct = self:getDirectCards(msg.seat)
            if direct ~= nil then
                -- playersInfo:ReSetFlowerNum() --重新设置花牌的数目
                -- for i=1,4 do
                --     playersInfo:SetFlowerNum(self:getDirect(msg.PlayerInfo[i].seat), #msg.PlayerInfo[i].hard_flowers)  --显示花牌数目
                -- end
                
                direct:complementCards(msg.flowers,false)  --显示花牌
                local count = #msg.combins
                
                
                for i = 1, count do
                    print("leixing1 :::" ..msg.combins[i].combin)
                    print("leixing2 :::" ..msg.combins[i].card)
                    print("leixing3 :::" ..msg.combins[i].card_from)
                    print("leixing4 :::" ..self:getDirect(msg.combins[i].card_from))
                    direct:combinCard(msg.combins[i].combin, msg.combins[i].card, self:getDirect(msg.combins[i].card_from))
                end
                
                -- dump(msg.outs, "msg.outs:::")
                count = #msg.outs
                
                for i = 1, count do
                    direct:addOut(msg.outs[i], max_player)
                end
                
                -- dump(msg.cards, "msg.cards:::")
                direct:distributeCards(msg.cards)
            end
        elseif name == "TDHMJ.Managed" then  --托管
            -- print("TDHMJ.PlayerInfo")
            print("托管了+++" ..msg.state)
            print("托管了---" ..msg.seat)
            if not watchingGame then
                playersInfo:setManager(msg.state == 0, self:getDirect(msg.seat))
                if msg.seat == seatIndex then
                    managerGame = (msg.state ~= 0) --1  托管  0不托管
                end
            end
        -- elseif name == "TDHMJ.AllowSelect" then --加炮
        --     playersInfo:clearState()
        --     cardWalls:showWalls(false)
        --     directTimer:setTimer(msg.time, "")
        --     if matchid ~= nil then
        --         matchNode:removeAll()
        --     end
        --     if msg.select > 0 then
        --         playersInfo:allowMopao()
        --     end
        -- elseif name == "TDHMJ.SelectInfo" then
        --     if msg.select > 0 then
        --         playersInfo:setMopao(self:getDirect(msg.seat))
        --     end
        --     if msg.seat == seatIndex then
        --         playersInfo:hideAllButton()
        --     end
        end
    end
end

function TDHMJScene:getDirect(seat)
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

function TDHMJScene:getDirectCards(seat)
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

function TDHMJScene:restart()
    
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
    BankerSeat=nil

end

function TDHMJScene:clearScene()
    print("TDHMJScene:clearScene()")
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
    MJSpriteFrame = nil
    -- huResult = nil
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

    BankerSeat=nil

    -- playTab={}
    -- playNum=1
    -- playTab.name={}
    -- playTab.seat={}

    msgWorker.clear()
    scheduler.clear()
end

return TDHMJScene