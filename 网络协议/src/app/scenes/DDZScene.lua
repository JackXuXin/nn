--
-- Author: K
-- Date: 2016-12-27 10:16:19
--

local DDZScene = class("DDZScene",function()
		return display.newScene("DDZScene")
	end)

local scheduler = require("framework.scheduler")        --定时器
local msgWorker = require("app.net.MsgWorker")	        --注册监听
local DDZ_GamePlayer = require("app.Games.DDZ.DDZ_GamePlayer")	--游戏玩家类
local DDZ_Card = require("app.Games.DDZ.DDZ_Card")				--扑克牌类
local DDZ_Const = require("app.Games.DDZ.DDZ_Const")
local DDZ_Message = require("app.Games.DDZ.DDZ_Message")
local DDZ_SettlementLayer = require("app.Games.DDZ.DDZ_SettlementLayer")
local DDZ_Audio = require("app.Games.DDZ.DDZ_Audio")
local util = require("app.Common.util")

local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local MatchMessage = require("app.net.MatchMessage")
local Message = require("app.net.Message")
local PRMessage = require("app.net.PRMessage")
local AvatarConfig = require("app.config.AvatarConfig")

local matchNode
local matchid = nil
local tempSingnCount = 0
local isMatchInit = false
local isMatchStatus = false
local matchSession = 0   --比赛回话


local gamePlayers = {}  --桌子上的玩家  下标是对应当前玩家的椅子顺序

local DiZhuPai = {}  --抢地主得到的牌
-- local self.maxPlayer = 3  --最大玩家数目
-- local self.maxCards = 54  --所有的牌  54  108
-- local self.dipaiNum = 3   --底牌     3  6  8
-- local cardScale = 1

local LastPlayer = {} --需要管的牌 、和玩家座位号

local JiaoFenScore = 0
LastPlayer.seat = 0
LastPlayer.cards ={}
---------------------------------------
local errorLayer = require("app.layers.ErrorLayer")
--设置
local DDZ_Setting

--私人房间变量
local privateRoom
local privateRoomRecord
local gameState         --0: 房卡游戏未开始； 1: 房卡游戏已开始
local isReady = false
-- local RoundFlog = false

--取对应位数的值
local bit = require "bit"
-- bit.band(value, 16) > 0

--断线重连
local ProgressLayer = require("app.layers.ProgressLayer")
local schedulerSys = require(cc.PACKAGE_NAME .. ".scheduler")
local progressTag = 10000
local endgame_flog = false
local Share = require("app.User.Share")
local shareSprite = nil


--比赛
local match_start = false

--微信头像
local weixinImage = {}

function DDZScene:ctor()
    
	self.tableSession = 0   --数据校验
    self.seatIndex = 0      --自己的椅子号
    self.openCardTime = 0      --最大出牌时间
    self.baseScore = 0      --开局的底分
    self.multiple = 0      --当前的倍数
    -- self.isStartGame = false  --记录是否开始游戏

    gamePlayers = {}
    DiZhuPai = {}

	self.root = cc.uiloader:load("Scene/DDZScene.json"):addTo(self)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player1"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player2"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player3"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player4"):setVisible(false)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player1"):setLocalZOrder(100)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player2"):setLocalZOrder(100)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player3"):setLocalZOrder(100)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player4"):setLocalZOrder(100)
	cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu2"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu3"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu4"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu2"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu3"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu4"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player1_ChuPaiWeiZhi"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player2_ChuPaiWeiZhi"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)
	cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player3_ChuPaiWeiZhi"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player4_ChuPaiWeiZhi"):setLocalZOrder(DDZ_Const.GAME_MAX_HIERARCHY)

	

	--监听退出按钮
	-- cc.uiloader:seekNodeByNameFast(self.root, "k_btn_TuiChu"):onButtonClicked(function ()
 --            MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
 --            MiddlePopBoxLayer.ConfirmTable, true, nil, function ()
 --            -- send leave table msg to server then quit table
 --                if matchid then
 --                    print("ts:" .. matchSession)
 --                    MatchMessage.LeaveMatchReq(matchSession)
 --                elseif self.table_code then
 --                    print("离开游戏请求1")
 --                    DDZ_Message.dispatchPrivateRoom("room.LeaveGame", {})
 --                else
 --                    DDZ_Message.dispatchGame("room.LeaveGame")
 --                end
 --            end)
 --            :addTo(self,3100)
            
	-- 	end)

	--监听点击事件
	self.root:setTouchEnabled(false)
	self.root:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	self.root:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.touchEventCallback))

	msgWorker.init("DDZ", handler(self, self.dispatchMessage))

    
    matchNode= require("app.Games.DDZ.DDZ_Match").new()
    :addTo(self,3000)

    self.ruleNode = display.newNode()
    :addTo(self.root)

    self.settlementLayer = DDZ_SettlementLayer:create()
    :hide()
    :addTo(self.root)

    privateRoom = require("app.Games.DDZ.DDZ_MJPRoom").new()
    :addTo(self.root)
    :init(self)

    self.continueNode = display.newNode()
    :addTo(self.root)

    DDZ_Setting = require("app.Games.DDZ.DDZ_Setting").new()
    :addTo(self.root)
    :init(self)

    self.liaotianSprite = display.newSprite()
    :addTo(self.root)

    if util.UserInfo.watching == false then
         -- 设置语音聊天按钮
         util.SetVoiceBtn(self,self.liaotianSprite)
         
    end

    -- shareSprite =display.newSprite()
    -- :addTo(self.root)
    -- Share.SetGameShareBtn(true, shareSprite, display.left+69, display.cy-70)

    privateRoomRecord = require("app.Games.DDZ.DDZ_MJPRoomRecord").new()
    :addTo(self.root)
    :init(self)
    :setLocalZOrder(100)
    :setVisible(false)

    
end
-------------------断线重连的调用----------------------------
function DDZScene:socket(msg)

    -- print("LYMJScene:socket = ", msg)
    if msg == "SOCKET_TCP_CONNECTED" then
        
        PRMessage.EnterPrivateRoomReq(nil)
        self:closeProgressLayer()
    elseif msg == "SOCKET_TCP_CLOSED" then
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.reconnect_loading):addTo(self, 8888, progressTag)
        end
    elseif msg == "SOCKET_TCP_CONNECT_FAILURE" then
        -- print("SOCKET_TCP_CONNECT_FAILURE----")
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.serverRestart_loading):addTo(self, 8888, progressTag)
        end
    end

end


function DDZScene:closeProgressLayer()

    local progressLayer = self:getChildByTag(progressTag)
    if progressLayer then
      -- print("SSSScene:closeProgressLayer--移除加载")
      ProgressLayer.removeProgressLayer(progressLayer)
    end
end
-----------------------------------------------------------
function DDZScene:onEnter()
    DDZ_Audio.preloadAllSound()
end

function DDZScene:onEnterTransitionFinish()

      -- print("DDZScene:onEnterTransitionFinish---")
      schedulerSys.performWithDelayGlobal(
      function ()
          --登录好友聊天系统
          if app.constant.isLoginChat == false and loginFchatHandler == nil then
             loginYvSys()
          end
      end, 1.0)
end

function DDZScene:exitScene()
    print("断线重连时房间不存在1")
    errorLayer.new(app.lang.room_over_leave, nil, nil, function()
        print("断线重连时房间不存在2")
                self:onLeave()
            end):addTo(self,100000)
end

function DDZScene:onExit()
    print("DDZScene:onExit")
    audio.stopAllSounds()
    DDZ_Audio.unloadAllSound()
    self:clearAllGameData()

    matchNode:clear()
    matchNode = nil
    matchSession = 0
    matchid = nil
    tempSingnCount = 0
    isMatchInit = false
    isMatchStatus = false


    DDZ_SettlementLayer:clear()

    LastPlayer = {}
    LastPlayer.seat = 0
    LastPlayer.cards ={}

    if DDZ_Setting then
        DDZ_Setting:clear()
    end
    if privateRoom then
        privateRoom:clear()
    end
    if privateRoomRecord then
       privateRoomRecord:clear()
    end
    DDZ_Setting = nil
    privateRoom = nil
    privateRoomRecord = nil

    if self.delayHandler then
        schedulerSys.unscheduleGlobal(self.delayHandler)
        self.delayHandler = nil
    end

    shareSprite = nil
    JiaoFenScore = 0
    

    -- RoundFlog = false
    isReady = false
    DiZhuPai = {}  --抢地主得到的牌
    
    match_start = false
    
end
--开局显示左上角信息
local function show_start_game_info(self)
    -- print("显示左上角信息")
    if self.gameround ~= nil and self.delayHandler == nil then
        --基本信息
        local offset = 6
        local info = display.newSprite("ShYMJ/PrivateRoom/img_info.png")
        self.info = info
        :pos(85-6,display.height - 60+10)
        :addTo(self.root)
        --分数文字
        cc.ui.UILabel.new({
        color = cc.c3b(126,152,121), 
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
        color = cc.c3b(126,152,121), 
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
        text = tostring(self.table_code), 
        })
        :addTo(info)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(59-5,52-offset)
        --延迟时间
        local delayTime = app.constant.delayTime
        --delayTime = 1090
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
--设置游戏当前局数
function DDZScene:setGameRound(gameround)
    if self.info == nil then
        return
    end
    local roundText = self.info:getChildByTag(99)
    if roundText ~= nil then
        roundText:setString(tostring(gameround) .. "/" .. app.constant.curRoomRound .. "局")
    end
end
function DDZScene:onLeave()
    if matchid then
        print("ts:" .. matchSession)
        if match_start then
            Message.unregisterHandle()
            app:enterScene("LobbyScene", nil, "fade", 0.5)
        else
            MatchMessage.LeaveMatchReq(matchSession)
        end
    elseif self.table_code then
        print("离开游戏请求1")
        DDZ_Message.dispatchPrivateRoom("room.LeaveGame", {})
    else
        DDZ_Message.dispatchGame("room.LeaveGame")
    end
end
function DDZScene:getGameState()
    return gameState or -1
end

function DDZScene:setisReady(flog)
    isReady = flog
end

function DDZScene:ReadyNextRound()

     if not watchingGame then
        print("LYMJScene:ReadyNextRound()",self.roomSession)
        print("isReady",isReady)
        isReady = true
        --message.dispatchGame("room.ReadyReq", {})
        DDZ_Message.sendMessage("game.ReadyReq", {
            session = self.roomSession
        })
    end

end
function DDZScene:setMatchRule()
    -- self.maxPlayer = 3
    self.maxCards = 54
    self.dipaiNum = 3
    self.cardScale = 1
    self.rule_type = 1

    cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_1"):setVisible(true)
    cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2"):setVisible(false)
    self.img_ShangLan_Node = cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_1")
    self.DiZhuPaiPos = cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_nd_DiZhuPai")
    self.pai_width = DDZ_Const.CARD_WIDTH

     --创建三张牌
        
    local pos = cc.p(self.DiZhuPaiPos:getPosition())
    if #DiZhuPai>0 then
        for k,v in pairs(DiZhuPai) do
            v:removeFromParent()
            v = nil
        end
    end
    DiZhuPai = {}
    -- print("self.dipaiNum",self.dipaiNum)
    for i=1,self.dipaiNum do
        local card = DDZ_Card:create()
        card:setScale(0.35)
        card:setPosition(cc.p(((i-2) * self.pai_width*0.35) + (i-2) * 5,0))
        card:setVisible(false)
        self.DiZhuPaiPos:add(card)
        table.insert(DiZhuPai,card)
    end

    setCardType(1)
    self:init_emos()

end
function DDZScene:dispatchMessage(name,msg)
    print("name = " .. name)
    -- dump(msg,"斗地主消息：")
   
	if msg then
        dump(msg, name)
    else
        print("msg 为 nil 的通信消息 = " .. name)
    end
    --初始化比赛
    if name == "room.InitMatch" then
        if msg.matchid ~= nil then
            --matchNode:updateRank(22,333)
            matchid = msg.matchid
            matchSession = msg.session
            self.maxPlayer = msg.max_player
            
            isMatchInit = true
            if isMatchStatus then
                
                matchNode:showLeftTime(matchid,tempSingnCount)
            end
            matchNode:SetRank()
            self:setMatchRule()
            DDZ_Setting:showMatchBtn(true)
            if privateRoom then
                privateRoom:hideButton()
            end
        end
    elseif name == "room.SignupCountNtf" then
        print("比赛2")
        if msg.session == matchSession then
            matchNode:updateSingup(msg.count)
            tempSingnCount = msg.count
        end
    elseif name == "room.MatchStatustNtf" then
        print("比赛3")
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
                match_start = true
            elseif msg.status == 4 then
                matchNode:removeLeftTime()
                matchNode:showCancel()
            elseif msg.status == 8 then
            elseif msg.status == 16 then
            end
        end
    elseif name == "room.MatchInfoNtf" then
        print("比赛4")
        print("room.MatchInfoNtf++matchSession:" .. matchSession)
        -- dump(msg)
        if matchSession == msg.session then
            matchNode:showState(msg.status,msg.rank,msg.gold,msg.rewardtitle,msg.rewardtype)
        end
    elseif name == "room.LeaveMatchRep" then
        print("比赛5")
    elseif name == "room.MatchRankNtf" then
        print("比赛6")
        print("MatchRankNtf s:" .. msg.session .. ",matchSession:" .. matchSession)
        if msg.session == matchSession then
            matchNode:updateRank(msg.rank,msg.total)
        end
    
    ---------------------------------私人房处理消息----------------------------------------------
    elseif name == "room.InitPrivateRoom" then  --私人房初始化
        
        print("私人房间开局")
        DDZ_Setting:showMatchBtn(false)
        -- dump(msg,"room.InitPrivateRoom:")

        if bit.band(msg.customization, 1) > 0 then
            self.maxPlayer = 3
            self.maxCards = 54
            self.dipaiNum = 3
            self.cardScale = 1
            self.rule_type = 1
                   
        elseif bit.band(msg.customization, 2) > 0 then
            self.maxPlayer = 3
            self.maxCards = 108
            self.dipaiNum = 6
            self.cardScale = 0.89
            self.rule_type = 2
            
        elseif bit.band(msg.customization, 4) > 0 then
            self.maxPlayer = 4
            self.maxCards = 108
            self.dipaiNum = 8
            self.cardScale = 0.89
            self.rule_type = 3
                    
        end
        self.pai_width = 0
        self.DiZhuPaiPos = nil
        if self.maxPlayer > 3 then
            print("4人")
            cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_1"):setVisible(false)
            cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2"):setVisible(true)
            local pos_x = cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2"):getPositionX()
            cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2"):setPositionX(pos_x+300)
            self.img_ShangLan_Node = cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2")
            self.DiZhuPaiPos = cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_nd_DiZhuPai")
            self.pai_width = 20
        else
            if self.maxCards ==54 then
                cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_1"):setVisible(true)
                cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2"):setVisible(false)
                self.img_ShangLan_Node = cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_1")
                self.DiZhuPaiPos = cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_nd_DiZhuPai")
                self.pai_width = DDZ_Const.CARD_WIDTH
            else
                cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_1"):setVisible(false)
                cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2"):setVisible(true)
                self.img_ShangLan_Node = cc.uiloader:seekNodeByNameFast(self.root, "img_ShangLan_2")
                self.DiZhuPaiPos = cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_nd_DiZhuPai")
                self.pai_width = 30
            end
        end
        --创建三张牌
        
        local pos = cc.p(self.DiZhuPaiPos:getPosition())
        if #DiZhuPai>0 then
            for k,v in pairs(DiZhuPai) do
                v:removeFromParent()
                v = nil
            end
        end
        DiZhuPai = {}
        -- print("self.dipaiNum",self.dipaiNum)
        for i=1,self.dipaiNum do
            local card = DDZ_Card:create()
            card:setScale(0.35)
            card:setPosition(cc.p(((i-2) * self.pai_width*0.35) + (i-2) * 5,0))
            card:setVisible(false)
            self.DiZhuPaiPos:add(card)
            table.insert(DiZhuPai,card)
        end

        setCardType(msg.customization)
        
        if self.gameround == nil then
            self.gameround = 0
        end

        
        self.tableSession = msg.table_session
        self.roomSession = msg.room_Session
        self.seatIndex = msg.seatid
        self.table_code = msg.table_code
        self.customization = msg.customization
        gameState = msg.game_state

        -- print("self.roomSession::::",self.roomSession)
        if privateRoom then
            privateRoom:tableSession(msg.table_session)
            privateRoom:roomSession(msg.room_Session)
        end

        if gameState == 0 then          --房卡游戏未开始
            if result ~= 2 then
                privateRoom:showSeat({seat_cnt = msg.max_player,table_code = msg.table_code,tableid = msg.tableid,gameround = msg.gameround,
                    pian_cnt = msg.pian_cnt, pay_type = msg.pay_type, customization = msg.customization, gameid = msg.gameid})
            end
        else
            show_start_game_info(self)
        end
        self:init_emos()
    elseif name == "room.PrivateStart" then         --私人房间开局
        

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
        -- print("私人房间信息",msg.state)
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
            self:setGameRound(self.gameround)
        end

        --本局游戏还没开始
        -- print("gameState",gameState)
        if not matchid then
            if msg.state == 0 and gameState ~= 0 then
            --恢复场景 游戏还没有开局 显示继续游戏按钮
                if self.continueNode:getChildByName("game_continue") ==nil then
                    local game_continue = cc.ui.UIPushButton.new({ normal = "ShYMJ/btn_continue_0.png", pressed = "ShYMJ/btn_continue_0.png" })
                    :onButtonClicked(function()
                        DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
                        -- print("isReady",isReady)
                        isReady = true
                        -- print("发送准备请求")
                        DDZ_Message.sendMessage("game.ReadyReq", {
                            session = self.roomSession
                        })
                    end)
                    :pos(display.cx,270)
                    :addTo(self.continueNode)
                    :setName("game_continue")
                    util.BtnScaleFun(game_continue)
                end
                
            end
        end

    elseif name == "room.UpdateSeat" then
        -- print("刷新分数")

        for i = 1,#msg.player do
            local seat = self:convertSeatToPlayer(msg.player[i].seat)
            if gamePlayers[seat] then
                gamePlayers[seat]:setGold(msg.player[i].gold)
            end
        end
    elseif name == "room.ChatMsg" then
       -- print("room.chatMsg-session, table_session", msg.session, self.roomSession)
       if matchid ~= nil then
            if matchSession == msg.session then
                local fromseat=self:convertSeatToPlayer(msg.fromseat)
                local toseat=self:convertSeatToPlayer(msg.toseat)

                if msg.info.chattype == 1 then
                    self:playEmotion(tonumber(msg.info.content), fromseat, toseat)
                end
            end
       else
            if self.roomSession == msg.session then
                local fromseat=self:convertSeatToPlayer(msg.fromseat)
                local toseat=self:convertSeatToPlayer(msg.toseat)

                if msg.info.chattype == 1 then
                    self:playEmotion(tonumber(msg.info.content), fromseat, toseat)
                end
            end
       end

       
            
    -------------------------------------------------------------------------------------------------
    elseif name == "room.InitGameScenes" then
        self.seatIndex = msg.seat
        self.tableSession = msg.session
    elseif name == "room.EnterGame" then
        dump(msg, "room.EnterGame")
        --保存微信头像
        weixinImage[msg.seat] = msg.player.imageid
        local seatIndex = msg.seat
        msg.seat = self:convertSeatToPlayer(msg.seat)
        local gamePlayer = DDZ_GamePlayer:create(msg,self,seatIndex)
        if gamePlayers[msg.seat] then
            gamePlayer.m_Cards = gamePlayers[msg.seat].m_Cards
        end
        gamePlayers[msg.seat] = gamePlayer

        --所有玩家的状态
        -- msg.seat = self:convertSeatToPlayer(msg.seat)
        -- print("zuowei",msg.seat)
        -- print("msg.player.ready",msg.player.ready)
        if msg.seat==1 and msg.player.ready>0 then
            isReady = true
            --隐藏 邀请好友 开始游戏 按钮
            if privateRoom then
                privateRoom:hideButton()
            end
            --删除继续游戏按钮
            local game_continue = self.continueNode:getChildByName("game_continue")
            if game_continue then
                game_continue:removeSelf()
            end
        end
        gamePlayers[msg.seat]:setPlayerReadyState(msg.player.ready)    --显示已准备
        print("msg.seatsetPlayerReadyState",msg.seat)

    elseif name == "room.LeaveGame" then
        -- print("离开游戏请求2")
        local seat = self:convertSeatToPlayer(msg.seat)
        -- print(seat .. "号椅子退出房间")
        if msg.seat == self.seatIndex then
            self:ClearAllPlayer()
        else
            gamePlayers[seat]:OutRoot()      --退出房间
            gamePlayers[seat] = nil
        end

        

        -- print("离开房间1")
        if self:getGameState() == 0 and msg.seat == self.seatIndex then
            -- print("离开房间")
            errorLayer.new(app.lang.room_owner_leave, nil, nil, function()
                self:onLeave()
            end):addTo(self)

        end

        
    elseif name == "room.Ready" then
        print("斗地主准备消息")
        
        if self.seatIndex == msg.seat then
            --隐藏 邀请好友 开始游戏 按钮
            if privateRoom then
                privateRoom:hideButton()
            end
            isReady = true
            --删除继续游戏按钮
            local game_continue = self.continueNode:getChildByName("game_continue")
            if game_continue then
                game_continue:removeSelf()
            end
        end
        print("msg.seat1",msg.seat)
        msg.seat = self:convertSeatToPlayer(msg.seat)
        gamePlayers[msg.seat]:setPlayerReadyState(1)    --显示已准备
        print("msg.seat2",msg.seat)
        print("self:isPlayerAllReady()",self:isPlayerAllReady())
        if self:isPlayerAllReady() then  --是否桌子上的玩家已经全部准备
            for k,v in ipairs(gamePlayers) do
                v:setPlayerReadyState(0)
                print("隐藏准备")
            end
        end
    elseif name == "room.ManagedNtf" then
        print("room.ManagedNtf")
        
         if gameState ~= 0 then
            -- msg.state  1 = 断线
            if not watchingGame then
                local seat = self:convertSeatToPlayer(msg.seat)
                gamePlayers[seat]:setManager(msg.state == 1)
            end
        end

    elseif self.tableSession == msg.session then
    	if name == "DDZ.Deal" then    --游戏开始 发牌
            -- self.isStartGame = true
            self:hideAllZhuiBei()
            if endgame_flog then
                self.settlementLayer:hide()
            end
    		-- print("收到发牌消息")
            self:againStart()
            
            -- if RoundFlog == false then
            --     self.gameround = self.gameround+1
            --     RoundFlog = true
            -- end
            self.gameround = msg.ju
            -- print("self.gameround",self.gameround)

            self:setGameRound(self.gameround)
            if matchid ~= nil then
                match_start = true
                matchNode:removeAll()
                self:hideAllZhuiBei()
                cc.uiloader:seekNodeByNameFast(gamePlayers[1].m_UINode, "k_btn_ZhunBei"):setVisible(false)      
            end
    		-- self.openCardTime = msg.openCardTime	 --最大出牌时间
            self.baseScore = msg.score           --开局的低分
            self.multiple = 1
            self:updateBeiShu(self.multiple)

            self.root:setTouchEnabled(false)        --关闭触摸 发牌结束在开启


    		cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_DiFen"):setString(tostring(msg.score))  --低分

    		self:clearAllPlayerCards()  --清理手牌 为玩家都不抢地主的情况准备

            DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_DISPATCH)    --发牌音效

            -- dump(msg.cards,"手牌：")

    		self:FaPai(self:changeCard(msg.cards))  --发牌
            if cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_BeiShu") then
                cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_BeiShu"):setString("00")  --设置默认倍数
            end
    		
        -- elseif name == "DDZ.Restart" then     --重新开始消息
        --     self:againStart()

        elseif name == "DDZ.Call" then     --叫地主返回消息
            -- self.isStartGame = true
            self:hideAllZhuiBei()
            msg.seat = self:convertSeatToPlayer(msg.seat)

            --刷新倍数
            self:updateBeiShu(self.multiple)    --先不管倍数问题
            --隐藏抢地主
            if msg.seat == 1 then
                gamePlayers[msg.seat]:hideQiangDiZhu()
            else
                gamePlayers[msg.seat]:hideDengDaiQiangDiZhu()
            end
            --隐藏所有叫分情况
            for i=1,self.maxPlayer do
                local Player_seat = self:convertSeatToPlayer(i)
                gamePlayers[Player_seat]:hideQiangDiZhuState()
            end
            if msg.score>JiaoFenScore then
                JiaoFenScore = msg.score
            end
            self.baseScore = JiaoFenScore
            cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_DiFen"):setString(tostring(JiaoFenScore))  --低分
            --显示对应叫分状态
            gamePlayers[msg.seat]:showQiangDiZhuState(msg.score)
    	elseif name == "DDZ.AllowOperate" then     --叫地主消息
    		-- print("收到抢地主回复")
            -- self.isStartGame = true
            self:hideAllZhuiBei()
    		--继续抢地主
    		-- print("AllowOperate1")
            msg.seat = self:convertSeatToPlayer(msg.seat)
            for i=1,#msg.operates do
                if msg.operates[i] == "jiao" then   --叫地主
                    -- print("AllowOperate2")
                    if msg.seat == 1 then
                        -- print("AllowOperate3")
                        gamePlayers[msg.seat]:showQiangDiZhu(msg.time,JiaoFenScore)
                    else
                        -- print("AllowOperate4")
                        gamePlayers[msg.seat]:showDengDaiQiangDiZhu(msg.time)
                    end

                elseif msg.operates[i] == "out" then
                    --隐藏所有叫分情况
                    for i=1,self.maxPlayer do
                        local Player_seat = self:convertSeatToPlayer(i)
                        gamePlayers[Player_seat]:hideQiangDiZhuState()
                    end
                    --隐藏上一次出牌的玩家
                    for i=1,self.maxPlayer do
                        if i == 1 then
                            gamePlayers[i]:hideChuPai()
                        else
                            gamePlayers[i]:hideDengDaiChuPai()
                        end
                    end
                    
                    --清理上一次出的牌
                    gamePlayers[msg.seat]:clearLastCards()


                    --显示当前出牌玩家的状态
                    if msg.seat == 1 then
                        --判断上一个出牌的玩家是不是自己
                        if LastPlayer.seat~= msg.seat then
                            gamePlayers[msg.seat]:showChuPai(msg.time,self:changeCard(LastPlayer.cards))
                        else
                            LastPlayer.cards = {}
                            gamePlayers[msg.seat]:showChuPai(msg.time,self:changeCard(LastPlayer.cards))
                        end
                        
                    else
                        gamePlayers[msg.seat]:showDengDaiChuPai(msg.time)
                    end
                    
                elseif msg.operates[i] == "pass" then
                    
                end
            end
        elseif name == "DDZ.Floor" then   --底牌.同时也是确定地主
            -- print("收到游戏地主消息")
            self:hideAllZhuiBei()
            -- self.isStartGame = true
            msg.seat = self:convertSeatToPlayer(msg.seat)
            --隐藏所有玩家的抢地主状态
            self:hideAllPlayerQiangDiZhuState()
            self:SortCards(1,self:changeCard(msg.cards))
            local dizhu_card = self:changeCard(msg.cards)
            if self.maxCards == 54 then
                --亮地主牌
               
                for k,v in ipairs(DiZhuPai) do
                    --翻牌动画
                    v:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.01,0.35),cc.CallFunc:create(function ()
                        v:setCardNum(dizhu_card[k].num)
                        v:setCardColor(dizhu_card[k].color)
                        v:showFront()
                        v:runAction(cc.ScaleTo:create(0.2,0.35))
                    end)))
                end
            end
            

            --显示庄家身份
            self:showPlayerIdentity(msg.seat)

            --给地主发三张牌
            for k,v in ipairs(dizhu_card) do
                local card = DDZ_Card:create()
                card:setCardNum(v.num)
                card:setCardColor(v.color)
                card:setVisible(false)
                card:setScale(self.cardScale)
                cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing"):add(card)
                
               
                gamePlayers[msg.seat]:FaPai(card)
            end
            gamePlayers[msg.seat]:setPlayerCardLuTuo(dizhu_card)
        elseif name == "DDZ.Out" then   --出牌消息广播
            -- print("收到了出牌请求的回复")
            -- self.isStartGame = true
            --隐藏所有不出的显示
            self:hideAllZhuiBei()
            gamePlayers[1]:hideGameXingWei()
            for i=1,self.maxPlayer do
                gamePlayers[i]:hideAllchupaiState()
                gamePlayers[i]:hideDaojishi()
            end

            self:updateBeiShu(msg.bei)    --倍数
            
            --记录上家出的牌
            LastPlayer.seat = self:convertSeatToPlayer(msg.seat)
            LastPlayer.cards = msg.cards

            msg.seat = self:convertSeatToPlayer(msg.seat)
            -- msg.handoutPlayer = self:convertSeatToPlayer(msg.handoutPlayer)

            -- --出牌
            gamePlayers[msg.seat]:ChuPai(self:changeCard(msg.cards),self:changeCard(msg.cards),msg.remain2)
            
            
            --设置牌的剩余数目
            if msg.remain ~= 0 then
                if msg.seat ~= 1 then
                    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu" .. msg.seat):setString(tostring(msg.remain)) --更新其他玩家手牌数
                end
            else
                if msg.seat ~= 1 then
                    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu" .. msg.seat):setVisible(false)  --隐藏手牌数
                end
            end
            
           
        elseif name == "DDZ.Pass" then   --不要消息广播
            -- self.isStartGame = true
            --隐藏所有不出的显示
            self:hideAllZhuiBei()
            for i=1,self.maxPlayer do
                gamePlayers[i]:hideAllchupaiState()
            end
            msg.seat = self:convertSeatToPlayer(msg.seat)
            local cards = {}
            -- --出牌
            gamePlayers[msg.seat]:ChuPai(cards,self:changeCard(LastPlayer.cards))
        
    	

        elseif name == "DDZ.Manage" then   --开启托管
            print("收到开启托管请求")

            msg.seat = self:convertSeatToPlayer(msg.seat)

            if msg.state ==1 then
                -- print("玩家 " .. msg.seat .. " 开启了托管")
                gamePlayers[msg.seat]:setTuoGuanState(true)
            else
                -- print("玩家 " .. msg.seat .. " 取消了托管")
                gamePlayers[msg.seat]:setTuoGuanState(false)
            end


        elseif name == "DDZ.EndGame" then  --结算
            -- print("收到结算请求")
            -- -- self.isStartGame = false
            -- dump(msg,"收到结算请求")
            -- self.gameround = self.gameround+1

            if self.maxCards ~= 54 then
                --亮地主牌
                self:SortCards(1,self:changeCard(msg.cards))
                local dizhu_card = self:changeCard(msg.cards)
                for k,v in ipairs(DiZhuPai) do
                    --翻牌动画
                    v:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.01,0.35),cc.CallFunc:create(function ()
                        v:setCardNum(dizhu_card[k].num)
                        v:setCardColor(dizhu_card[k].color)
                        v:showFront()
                        v:runAction(cc.ScaleTo:create(0.2,0.35))
                    end)))
                end
            end

            endgame_flog = true
            -- RoundFlog = false
            --显示其他玩家剩余手牌
            for i=1,#msg.player do
                
                local seat_id =msg.player[i].seat
                local seat = self:convertSeatToPlayer(msg.player[i].seat)
                -- print("显示玩家的座位号：",seat)
                -- print("msg.player[i].seat" ..msg.player[i].seat)
                -- dump(msg.player[seat_id].cards, "结算牌：")
                -- dump(msg.player[seat_id], "结算牌：")

                if seat ~= 1 and #msg.player[seat_id].cards ~= 0 then
                    self:SortCards(1, self:changeCard(msg.player[seat_id].cards))
                    gamePlayers[seat]:showPlayerCards(self:changeCard(msg.player[seat_id].cards))
                end
            end

            --显示结算
            local function showJieSuan()
                -- self.settlementLayer = DDZ_SettlementLayer:create(self,msg)
                self.settlementLayer:init(self,msg)
                self.settlementLayer:show()
                if matchid then
                    --todo
                    self.settlementLayer:hideButton()
                end
                
            end

            --排序数据
            -- for k,v in ipairs(msg.player) do
            --     v.seat = self:convertSeatToPlayer(v.seat)
            --     -- v.name = gamePlayers[v.seat]:getPlayerName()
            -- end

            table.sort(msg.player,function(a,b)
                    return a.seat < b.seat
                end)

            for k,v in ipairs(msg.player) do
                local seat = self:convertSeatToPlayer(v.seat)
                if seat == 1 then
                    if tonumber(v.score)  > 0 then  --播放赢音效
                        DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_SUCCESS)
                    else
                        DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_FAIL)
                    end

                    gamePlayers[seat]:playScoreAction(tonumber(v.score),showJieSuan)
                else
                    gamePlayers[seat]:playScoreAction(tonumber(v.score))
                end
            end


            --播放春天 or 反春
            if msg.chun == 1 then  -- 春天
                gamePlayers[1]:playChunTianAction()
            elseif msg.chun == 2 then  -- 反春
                gamePlayers[1]:playFanChunAction()
            end

        elseif name == "DDZ.GameInfo" then  --游戏场景恢复
            -- print("收到游戏场景恢复请求")
            -- self.isStartGame = true
            self:againStart()
            if matchid ~= nil then
                match_start = true
                matchNode:removeAll()    
            end

            if endgame_flog then
                self.settlementLayer:hide()
            end
            -- self.openCardTime = msg.openCardTime
            self.multiple = 0
            self.baseScore = msg.di
            self.root:setTouchEnabled(true)
            
            self.gameround = msg.ju
            self:setGameRound(self.gameround)
            -- util.SetRequestBtnHide()
            --util.requestBtn:hide()
            --隐藏开始游戏按钮
            cc.uiloader:seekNodeByNameFast(gamePlayers[1].m_UINode, "k_btn_ZhunBei"):setVisible(false)

            if msg.cards[1]~=0 then
                -- print("确定了地主")
                if  self.maxCards == 54 then
                    local cards = self:changeCard(msg.cards)
                    self:SortCards(1,cards)
                    for k,v in ipairs(DiZhuPai) do
                        v:setCardNum(cards[k].num)
                        v:setCardColor(cards[k].color)
                        v:showFront()
                    end
                    self:setDiZhuPaiShowState(true)
                else
                    local pos = cc.p(self.DiZhuPaiPos:getPosition())
                    DiZhuPai = {}
                    for i=1,self.dipaiNum do
                        local card = DDZ_Card:create()
                        card:setScale(0.35)
                        card:setPosition(cc.p( ((i-2) * self.pai_width*0.35) + (i-2) * 5,0))
                        card:setVisible(false)
                        self.DiZhuPaiPos:add(card)
                        table.insert(DiZhuPai,card)
                    end
                    self:setDiZhuPaiShowState(true)
                end
            else
                -- print("还没确定地主")
                -- local DiZhuPaiPos = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_DiZhuPai")
                local pos = cc.p(self.DiZhuPaiPos:getPosition())
                DiZhuPai = {}
                for i=1,self.dipaiNum do
                    local card = DDZ_Card:create()
                    card:setScale(0.35)
                    card:setPosition(cc.p( ((i-2) * self.pai_width*0.35) + (i-2) * 5,0))
                    card:setVisible(false)
                    self.DiZhuPaiPos:add(card)
                    table.insert(DiZhuPai,card)
                end
                self:setDiZhuPaiShowState(true)
            end
            

            --恢复 低分 倍数
            cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_DiFen"):setString(tostring(self.baseScore))
            self:updateBeiShu(msg.bei)

            -- msg.curPlayer = self:convertSeatToPlayer(msg.curPlayer)

            local dizhu = self:convertSeatToPlayer(msg.dizhu)
            -- dump(msg.player, "玩家信息")

            --恢复牌 手里的牌
            for k,v in ipairs(msg.player) do
                -- local index = k
                -- print("当前player下标",k)
                -- print("当前服务端座位号",v.seat)
                v.seat = self:convertSeatToPlayer(v.seat)
                -- print("当前客户端座位号",v.seat)

                if v.seat == 1 then
                    -- dump(v.cards,"玩家的手牌：" .."v.seat1")
                    for kk,vv in ipairs(self:changeCard(v.cards)) do
                        local card = DDZ_Card:create()
                        card:setCardNum(vv.num)
                        card:setCardColor(vv.color)
                        card:setScale(self.cardScale)
                        card:setVisible(false)
                        cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing"):add(card)
                        gamePlayers[v.seat]:FaPai(card)    --给对应的玩家 发一张牌
                    end
                else
                    -- dump(v.cards,"玩家的手牌：" .."v.seat2")
                    for i=1,#v.cards do
                        local card = DDZ_Card:create()
                        card:setScale(self.cardScale)
                        card:setVisible(false)
                        cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing"):add(card)
                        gamePlayers[v.seat]:FaPai(card)    --给对应的玩家 发一张牌
                    end
                end

                if msg.dizhu == 0  then --玩家是地主
                    gamePlayers[v.seat]:setPlayerIdentity(false,false)
                elseif v.seat == dizhu then
                    gamePlayers[v.seat]:setPlayerIdentity(true,true)
                else
                    gamePlayers[v.seat]:setPlayerIdentity(true,false)
                end

                
            end

            cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu2"):setVisible(true)
            cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu3"):setVisible(true)
            if self.maxPlayer >3 then
                cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu4"):setVisible(true)
            end

           

        elseif name == "DDZ.Termination" then
            if self.ruleNode then
                self.ruleNode:hide()
            end
            if shareSprite then
                shareSprite:hide()
            end
            local index_time = 0.01
            if endgame_flog then
                index_time = 5
            end
            if privateRoomRecord then
                privateRoomRecord:performWithDelay(function() 
                    
                    privateRoomRecord:showPrivateRoomRecord(true,msg,weixinImage,majiang)
                    end, index_time)
            end
    	end
    end
end

--将card转换成表结构
function DDZScene:changeCard(card)
    if card ==nil or #card == 0 then
        return {}
    end
    local card_tab ={}
    for i=1,#card do
        -- print("aaaa牌值",card[i]%16)
        -- print("aaaa牌色",math.floor(card[i]/16))
        table.insert(card_tab,#card_tab+1, {num = card[i]%16, color = math.floor(card[i]/16)})
    end
    self:SortCards(1,card_tab)
    return card_tab
end

function DDZScene:hideAllZhuiBei()
    for i,v in ipairs(gamePlayers) do
        v:setPlayerReadyStateEX(false)
    end
end


-- start --

--------------------------------
-- 清理所有游戏中得数据  为下一次开局做准备
-- @function clearAllGameData

-- end --
function DDZScene:clearAllGameData()
    --清理桌子上的牌
    --清理手牌
    self:clearAllPlayerCards()
    --清理玩家数据
    -- if gamePlayers[1] then
    --     gamePlayers[1]:clearGameData()
    -- end
    
    --隐藏手牌数
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu2"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu3"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu2"):setString("0")
    cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu3"):setString("0")
    if self.maxPlayer >3 then
        cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu4"):setVisible(false)
        cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu4"):setString("0")
    end
    --隐藏地主牌
    self:setDiZhuPaiShowState(false)
    --重置低分
    cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_DiFen"):setString("")
    --重置倍数
    if cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_BeiShu") then
        
         cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_BeiShu"):setString("")
    end
   

    
end

-- start --

--------------------------------
-- 清理所有玩家手牌
-- @function clearAllPlayerCards

-- end --
function DDZScene:clearAllPlayerCards()
	for k,v in pairs(gamePlayers) do
		v:clearPlayerCards()
        v:clearLastCards()
        v:setPlayerIdentity(false)
        v:hideQiangDiZhuState()
	end
end


-- start --

--------------------------------
-- 隐藏所有玩家的抢地主状态
-- @function hideAllPlayerQiangDiZhuState

-- end --
function DDZScene:hideAllPlayerQiangDiZhuState()
	for k,v in ipairs(gamePlayers) do
		v:hideQiangDiZhuState()
	end
end

-- start --

--------------------------------
-- 发牌
-- @function FaPai
-- @table cardOfDeal   发给自己的牌
-- @number callPlayer	第一个叫地主的玩家椅子号

-- end --
function DDZScene:FaPai(cardOfDeal,callPlayer)
	--开启一个定时器发牌
	-- local hand = nil
	local Index = 0
    local isSendCard = false  --是否正在发牌

	-- print("#cardOfDeal = " .. #cardOfDeal)

    self.FaPaiTable = {}

    if self.hand then
        scheduler.unscheduleGlobal(self.hand)
    end

    for i=1,self.maxCards - self.dipaiNum do
        local card = DDZ_Card:create()
        card:setScale(self.cardScale)
        card:setVisible(false)
        cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing"):add(card)
        table.insert(self.FaPaiTable,card)
    end

	local function onSendCard(dt)  --发牌定时器

        if isSendCard then
            return 
        end

        isSendCard = true

        local playerIndex = (Index % self.maxPlayer) + 1   --轮流发牌的 椅子号
        -- local card = DDZ_Card:create()
        -- card:setVisible(false)
        -- cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing"):add(card)

        local card = self.FaPaiTable[Index+1]
        if card ~= nil then
            if playerIndex == 1 then
                card:setCardNum(cardOfDeal[1].num)
                card:setCardColor(cardOfDeal[1].color)
                table.remove(cardOfDeal,1)
            else
                card:setCardNum(0)
                card:setCardColor(0)
            end
        end
        
    
        local function cardSendFinishedCallback(dt)     --发牌动画播放结束 回调继续发下一张牌
            Index = Index + 1
            --发牌结束
            if Index >= self.maxCards - self.dipaiNum then
                scheduler.unscheduleGlobal(self.hand)
                self.root:setTouchEnabled(true)
                -- callPlayer = self:convertSeatToPlayer(callPlayer)
                -- print("发牌结束了，开始叫地主",callPlayer)
                -- if callPlayer == 1 then
                --     gamePlayers[callPlayer]:showQiangDiZhu(self.openCardTime - 3)
                -- else
                --     gamePlayers[callPlayer]:showDengDaiQiangDiZhu(self.openCardTime - 3)
                -- end

                DDZ_Message.sendMessage("DDZ.DealOver", {
                    session = self.tableSession,
                })

                audio.stopAllSounds()  --停止发牌音效
            end

            isSendCard = false
        end

        gamePlayers[playerIndex]:FaPai(card,cardSendFinishedCallback)
    end

	self.hand = scheduler.scheduleGlobal(onSendCard, 0.01)

	--显示其他玩家牌数
	cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu2"):setVisible(true)
	cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu3"):setVisible(true)
    if self.maxPlayer>3 then
        cc.uiloader:seekNodeByNameFast(self.root, "k_ta_PaiShu4"):setVisible(true)
    end

	--最后三张牌
	self:setDiZhuPaiShowState(true)
end

-- start --

--------------------------------
-- 刷新倍数
-- @function updateBeiShu
-- @param number BeiShu  翻倍数

-- end --
function DDZScene:updateBeiShu(multiple)
    if multiple and multiple >= self.multiple then
        self.multiple = multiple
        local BeiShu = nil
        if multiple < 10 then
            BeiShu = "0" .. tostring(multiple)
        else
            BeiShu = tostring(multiple)
        end
        if cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_BeiShu") then
            cc.uiloader:seekNodeByNameFast(self.img_ShangLan_Node, "k_ta_BeiShu"):setString(BeiShu)
        end
        
    end
end

-- start --

--------------------------------
-- 显示身份
-- @function FaPai
-- @param number 本地转换之后的地主椅子号

-- end --
function DDZScene:showPlayerIdentity(landlord)
	for k,v in ipairs(gamePlayers) do
		if v:getPlayerSeat() == landlord then
			v:setPlayerIdentity(true,true)
		else
			v:setPlayerIdentity(true,false)
		end
	end
end

-- start --

--------------------------------
-- 是否桌子上的玩家已经全部准备
-- @function isPlayerAllReady
-- @return bool        是否桌子上的玩家已经全部准备

-- end --
function DDZScene:isPlayerAllReady()
    -- if #gamePlayers < DDZ_Const.GAME_MAX_PLAYER then   --桌子人数还没达到游戏开始人数 直接返回
    print("#gamePlayers",#gamePlayers)
    print("self.maxPlayer",self.maxPlayer)
    if #gamePlayers < self.maxPlayer then
    
        return false
    end
    local index = 0
    for k,v in ipairs(gamePlayers) do
        print("v.m_playerInfo.player.ready",v.m_playerInfo.player.ready)
        index = index + 1
        if v.m_playerInfo.player.ready == 0 then    --如果有玩家还没准备返回 false
            return false
        end
    end
    if index~= self.maxPlayer then
        return false
    end

    return true   -- 全部准备返回 true
end

-- start --

--------------------------------
-- 设置地主牌显示状态
-- @function setDiZhuPaiShowState

-- end --
function DDZScene:setDiZhuPaiShowState(state)
	for k,v in ipairs(DiZhuPai) do
		v:setVisible(state)
        if not state then
            v:showLast()
        end
	end
end

-- start --

--------------------------------
-- 转换 椅子号 对应玩家的位置  msg.seat = 1 = 自己
-- @function convertSeatToPlayer
-- @param number seat           玩家在服务器的 椅子号
-- @return number 		        转换之后面向本地玩家的 椅子号

-- end --
function DDZScene:convertSeatToPlayer(seat)
    -- print("web1:",seat)
    local difference = self.seatIndex - 1
    if seat - difference <= 0 then
        seat = seat + self.maxPlayer - difference
    else 
        seat  = seat - difference
    end
    -- print("web2:",seat)
    --当玩家人数为4时，交换3和4的位置
    if self.maxPlayer == 4 then
        if seat == 3 then
            seat = 4
        elseif seat == 4 then
            seat = 3
        end
    end
    return seat
end

-- -- 退出场景时清除对象
-- function DDZScene:ClearScene()--
--     if self.delayHandler then
--         schedulerSys.unscheduleGlobal(self.delayHandler)
--         self.delayHandler = nil
--     end
-- end
--------------------------------
-- 重新开始
-- @function againStart

-- end --
function DDZScene:againStart()--
    print("----------------------")
    -- print(type(self.seatIndex))
    -- print(type(self.tableSession))
    
    if self.seatIndex == 0 and self.tableSession == 0 then
        if self.table_code then
            DDZ_Message.dispatchPrivateRoom("room.LeaveGame",{})
        end
        
        return 
    end

    self:clearAllGameData()
    -- util.SetRequestBtnShow()
    -- util.requestBtn:show()--显示邀请好友按钮
    -- print("隐藏邀请好友按钮")
    -- gamePlayers[1]:clickZhunBei()

    LastPlayer = {}
    LastPlayer.seat = 0
    LastPlayer.cards ={}
    endgame_flog = false

    JiaoFenScore = 0
end

-- start --

--------------------------------
-- 排序一组牌  or  排序一组实际的手牌
-- @function SortCards
-- @param number order    1 等于从大到小   2 等于从小到大
-- @param table cards     需要排序的牌信息

-- end --
function DDZScene:SortCards(order,cards)
    for k,v in ipairs(cards) do
    	if v.color == 4 then
            if v.num <= 15 then
                v.num = v.num + 2
            end
    	else
    		if v.num <= 2 then
        	    v.num = v.num + 13
        	end
    	end
    end

    if order == 1 then
        table.sort(cards,
        function(a,b) 
            if a.num == b.num  then
                return a.color > b.color
            else
                return a.num > b.num 
            end
        end)
    elseif order == 2 then
       table.sort(cards,
        function(a,b) 
            if a.num == b.num  then
                return a.color < b.color
            else
                return a.num < b.num 
            end
        end)
    end

    for k,v in ipairs(cards) do
    	if v.color == 4 then
            if v.num >= 16 then
                v.num = v.num - 2
            end
    	else
    		if v.num >= 14 then
        	    v.num = v.num - 13
        	end
    	end
    end
end

function DDZScene:SortCardsEx(order,cards)
    for k,v in ipairs(cards) do
    	if v.m_color == 4 then
    		if v.m_num <= 15 then
                v.m_num = v.m_num + 2
            end
    	else
    		if v.m_num <= 2 then
        	    v.m_num = v.m_num + 13
        	end
    	end
    end

    if order == 1 then
       table.sort(cards,
        function(a,b) 
            if a.m_num == b.m_num  then
                return a.m_color > b.m_color
            else
                return a.m_num > b.m_num 
            end
        end)
    elseif order == 2 then
       table.sort(cards,
        function(a,b) 
            if a.m_num == b.m_num  then
                return a.m_color < b.m_color
            else
                return a.m_num < b.m_num 
            end
        end)
    end

    for k,v in ipairs(cards) do
    	if v.m_color == 4 then
			if v.m_num >= 16 then
                v.m_num = v.m_num - 2
            end
    	else
    		if v.m_num >= 14 then
        	    v.m_num = v.m_num - 13
        	end
    	end
        -- print("v.m_num:::",v.m_num)
    end
    
end
--清除所有玩家
function DDZScene:ClearAllPlayer()
    for i=1,self.maxPlayer do
        if gamePlayer and gamePlayer[i] then
            gamePlayer[i]:OutRoot()
            gamePlayer[i] = nil
        end
        
    end
end
--***************************************************  表情函数  **************************************************************************
-- --表情函数
-- function DDZScene:SendEmotion(id, direct)
--     local toSeat = util.getToSeat(direct, max_player, seatIndex)
--     print("发送表情消息-toSeat = ,direct = ",toSeat, direct)
--     print("发送表情消息-roomsession =",self.roomSession)
--     message.sendMessage("game.ChatReq", {session = self.roomSession,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
-- end

--创建互动表情
function DDZScene:init_emos()
         --表情相关

    local rect = cc.rect(0, 0, 188, 188)

    if  self.emoBgLayer == nil then
         self.emoBgLayer = display.newSprite("Image/PrivateRoom/img_EmoBg.png")
        :hide()
        :addTo(self.root,2000)
        :setTouchEnabled(true)
    end

    if  self.cureHead == nil then
         self.cureHead = display.newSprite()
        :pos(55,206)
        :show()
        :addTo( self.emoBgLayer)
        :scale(0.42)
    end

    if  self.uidText == nil then
         self.uidText = cc.ui.UILabel.new({
                color = cc.c3b(245,222,183),
                size = 30,
                text = "ID：",
            })
        :addTo( self.emoBgLayer)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(55+46,206)
    end

   -- self.eHeadInfo = {[1] = {}, [2] = {}, [3] = {}, [4] = {},[5]={},[6]={}}
    -- local Image_1 = cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing")
    -- if Image_1 ~= nil then
    --     Image_1:setTouchEnabled(true)
    --     Image_1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    --         if event.name == "began" then
    --             if  self.emoBgLayer ~= nil then
    --                  self.emoBgLayer:hide()
    --             end
    --             return true
    --         end
    --     end)
    -- end

    local function onGitEmo(event)

        -- print("button.index = ",event.target.index)
        local index = event.target.index
        -- if self.maxPlayer == 4 then
        --     if event.target.index == 3 then
        --         index = 4
        --     elseif event.target.index == 4 then
        --         index = 3
        --     end
        -- end
        -- print("button.index = ",index)
        local visible =  self.emoBgLayer:isVisible()
        -- print(visible)
        local ui_node = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player" .. index)
        local pos_x_offset = 45
        local pos_y_offset = 22
        
        local direct = "left"

        if index == 2  then
            pos_x_offset = -480
            pos_y_offset = -50
            direct = "right"
        elseif index == 3   then
           
            pos_x_offset = 70
            pos_y_offset = -50
            direct = "left"
            
        elseif index == 4 then
            pos_x_offset = 160
            pos_y_offset = -85
            direct = "left"
        end

        self.emoBgLayer:setPosition(cc.p(ui_node:getPositionX()+pos_x_offset,ui_node:getPositionY() + pos_y_offset))
        local curPosY =  self.emoBgLayer:getPositionY()
        local curPosX =  self.emoBgLayer:getPositionX()

        if curPosX ==  self.lastPosX and curPosY ==  self.lastPosY then
             self.emoBgLayer:setVisible(not visible)
        else
             self.emoBgLayer:setVisible(true)
        end
         self.emoBgLayer:setAnchorPoint(cc.p(0,0.5))
        self.lastPosX =  self.emoBgLayer:getPositionX()
        self.lastPosY =  self.emoBgLayer:getPositionY()
        
        --dump(self.WRNN_PlayerMgr.playerInfos,"---------")


        local info = gamePlayers[index]
        
        -- local seat = self:convertSeatToPlayer(info.seat)
        -- print("info.seat  "..info.seat)
        -- print("set "..seat)
        util.showEmotionsLayer(self,self.emoBgLayer,info.seatIndex)
        if  self.emoBgLayer:isVisible() then
            
           
           -- dump(info,"--player---info--")
           --  --头像
           local  image = AvatarConfig:getAvatar(info.m_playerInfo.player.sex, info.m_playerInfo.player.gold,0)
           local  rect = cc.rect(0, 0, 188, 188)
           local  frame = cc.SpriteFrame:create(image, rect)
           if frame then
                 if self.cureHead then
                     self.cureHead:setSpriteFrame(frame)
                     self.cureHead:setScale(0.3734)
                 end                
                     util.setImageNodeHide( self.emoBgLayer, 101)              
                     util.setHeadImage( self.emoBgLayer, info.m_playerInfo.player.imageid,  self.cureHead, image, 101)           
                     self.uidText:setString(util.checkNickName(info.m_playerInfo.player.name,15))
           else
               print("错误  错误  错误")
           end
           
    
        end

    end

    --表情按钮
    for i=2,self.maxPlayer do
        local ui_node = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player" .. i)
        if ui_node then
            -- print("i::::",i)
            local btn_gifEmo = cc.uiloader:seekNodeByNameFast(ui_node, "btn_gifEmo")
            :onButtonClicked(onGitEmo)
            btn_gifEmo.index = i
            util.BtnScaleFun(btn_gifEmo)
        end
    end

end


function DDZScene:SendEmotion(id, toSeat)
    -- local toSeat = util.getToSeat(direct, self.maxPlayer, self.seatIndex)
    -- print("发送表情消息-toSeat = ,direct = ",toSeat, direct)
    -- print("发送表情消息-roomsession =",self.roomSession)
    if matchid then
        DDZ_Message.sendMessage("game.ChatReq", {session = matchSession,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
    else
        DDZ_Message.sendMessage("game.ChatReq", {session = self.roomSession,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
    end
   
end

function DDZScene:playEmotion(index, fromDirect, toDirect)
    -- print("index::",index)
    -- print("fromDirect::",fromDirect)
    -- print("toDirect::",toDirect)
    local beginPos =  gamePlayers[fromDirect]:getHeadIconPos(fromDirect)  
    local endPos =  gamePlayers[toDirect]:getHeadIconPos(toDirect)
    -- print("beginPos",beginPos.x,beginPos.y)
    -- print("endPos",endPos.x,endPos.y)

    util.RunEmotionInfo(self.root, index, beginPos, endPos)
end

function DDZScene:setEmoBtnTouch(isTouch)

    for i=1,self.maxPlayer do
        local ui_node = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player" .. i)
        if ui_node then
             local btn_gifEmo = cc.uiloader:seekNodeByNameFast(ui_node, "btn_gifEmo")
             btn_gifEmo:setTouchEnabled(isTouch)
        end
    end
end




--***************************************************  表情函数  **************************************************************************
function DDZScene:touchEventCallback(event)
	if event.name == "began" then
        if  self.emoBgLayer ~= nil then
            self.emoBgLayer:hide()
        end
		return gamePlayers[1]:began(event)
	elseif event.name == "moved" then
		if not self.root:isTouchEnabled() then
            return
        end

        gamePlayers[1]:moved(event)
	else
		if not self.root:isTouchEnabled() then

            return 
        end
        
        gamePlayers[1]:ended(event)
	end
end

return DDZScene