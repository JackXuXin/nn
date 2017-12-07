local GPScene = class("GPScene", function()
    return display.newScene("GPScene")
end)

local scheduler = require("framework.scheduler")

local message = require("app.net.Message")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")
local msgMgr = require("app.room.msgMgr")
local uiSettings = require("app.Games.GP.uiSettings")

local GamePlayer = require("app.Games.GP.GamePlayer")
local Card = require("app.Games.GP.Card")

local SettlementLayer = require("app.Games.GP.SettlementLayer")

local define = require("app.Games.GP.Define")

local GP_Audio = require("app.Games.GP.GP_Audio")

local util = require("app.Common.util")

local Share = require("app.User.Share")

local gamePlayers = {}  --桌子上的玩家  下标是对应当前玩家的椅子顺序

local max_player = nil   -- 最大游戏人数

local abandonedCards = {}  -- 桌子上废弃的牌
local waitCards = {}       -- 等待发送的牌

local isSendCard = false  --是否正在发牌

local selectCard = {}  --手指选择的牌

local ClearCard = {}  --结算的时候 暂时存放需要清理的牌

local isPalyerChuPai = false  --发牌之后是否有玩家出过牌  用于恢复场景的时候 判断 不出 是不是需要显示

function GPScene:ctor()
    self.tableSession = 0   --数据校验
    self.seatIndex = 0      --自己的椅子号
    self.HitCards = {}      --最后一名玩家打出在桌子上的牌
    self.DaoJiShiTime = 0

    self.root = cc.uiloader:load("Scene/GPScene.json"):addTo(self)

    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player2"):setVisible(false)
    cc.uiloader:seekNodeByNameFast(self.root, "k_img_DengDaiZhunBei"):setVisible(false)

    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_ChuPaiWeiZhi1"):setLocalZOrder(20)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_ChuPaiWeiZhi2"):setLocalZOrder(20)

    -- settings UI
    uiSettings:init(self)

    --创建废弃的牌
    self:createAbandonedCard()

    self.root:setTouchEnabled(false)
    self.root:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self.root:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            local isCardSuoTou = true

            for k,v in ipairs(gamePlayers[1].m_Cards) do
                local rect = v.m_touchRect
                local isContain = cc.rectContainsPoint(rect,cc.p(event.x,event.y))
                if isContain then
                    table.insert(selectCard,v)
                    v:setColor(define.cardSelectColor)
                    print("撞在一起了" .. #selectCard)
                    return true
                end

                rect = cc.rect(v:getPositionX() - v:getContentSize().width/2,v:getPositionY() - v:getContentSize().height/2,
                    v:getContentSize().width,v:getContentSize().height)
                isContain = cc.rectContainsPoint(rect,cc.p(event.x,event.y))
                if isContain then
                    isCardSuoTou = false
                end
            end

            if isCardSuoTou then
                print("点击了一下空白处")
                for k,v in ipairs(gamePlayers[1].m_Cards) do
                    if v:isCardLuTou() then
                        v:selectCardSuoTou()
                    end
                end
                gamePlayers[1]:addSelectCard()
            end


            return false            
        elseif event.name == "moved" then
            if not self.root:isTouchEnabled() then
                selectCard = {}
                return 
            end

            if #selectCard ~= 0 then
                local back = selectCard[#selectCard]
                local rect = back.m_touchRect
                local isContain = cc.rectContainsPoint(rect,cc.p(event.x,event.y))
                if isContain then
                    return
                end
            end

            for k,v in ipairs(gamePlayers[1].m_Cards) do
                local rect = v.m_touchRect
                local isContain = cc.rectContainsPoint(rect,cc.p(event.x,event.y))
                if isContain then

                    local isInsert = true
                    for kk,vv in ipairs(selectCard) do
                        if v == vv then
                            isInsert = false
                            break
                        end
                    end
                    if isInsert then
                        table.insert(selectCard,v)
                        v:setColor(define.cardSelectColor)
                    end

                    local x1 = selectCard[1].m_touchRect.x
                    local x2 = v.m_touchRect.x
                    if x1 > x2 then
                        x1,x2 = x2,x1
                    end

                    for kk,vv in ipairs(gamePlayers[1].m_Cards) do
                        if vv.m_touchRect.x > x1 and vv.m_touchRect.x < x2 then
                            isInsert = true

                            for kkk,vvv in ipairs(selectCard) do
                                if vvv == vv then
                                    isInsert = false 
                                    break
                                end
                            end
                            if isInsert then
                                table.insert(selectCard,vv)
                                vv:setColor(define.cardSelectColor)
                            end

                        end
                    end

                    local index = 1
                    while index <= #selectCard do
                        if selectCard[index].m_touchRect.x < x1 or selectCard[index].m_touchRect.x > x2 then
                            selectCard[index]:setColor(define.cardReleaseColor)
                            table.remove(selectCard,index)
                        else
                            index = index + 1
                        end
                    end

                    print("撞在一起了" .. #selectCard)
                    break
                end
            end
        else
            if not self.root:isTouchEnabled() then
                selectCard = {}
                return 
            end

            if gamePlayers[1]:ZhiNengTiQu(selectCard) then
                 selectCard = {}
                return 
            end

            print("点击弹起在一起了" .. #selectCard)
            for k,v in ipairs(selectCard) do
                v:setColor(define.cardReleaseColor)
                if v:isCardLuTou() then
                    v:selectCardSuoTou()
                else
                    v:selectCardLuTou()
                end
            end

            selectCard = {}

            --添加选择的牌
            gamePlayers[1]:addSelectCard()
        end
    end)

    --预加载音效
    GP_Audio.preloadAllSound()

    msgWorker.init("GP", handler(self, self.dispatchMessage))


    if util.UserInfo.watching == false then

         -- 设置语音聊天按钮
         util.SetVoiceBtn(self,self.root)

    end

    
end

function GPScene:onEnter()
end

function GPScene:onExit()
    GP_Audio.stopDaoJiShiSound()

    --清理废牌
    for k,v in ipairs(abandonedCards) do
        v:removeFromParent()
    end
    abandonedCards = {}

    --清理手牌
    for k,v in ipairs(gamePlayers) do
        for kk,vv in ipairs(v.m_Cards) do
            vv:removeFromParent()
        end
        v = {}
    end

    --清理桌子上的牌
    for k,v in ipairs(self.HitCards) do
        v:removeFromParent()
    end
    self.HitCards = {}

    selectCard = {}  --手指选择的牌

    GamePlayer.clearData()
end

function GPScene:dispatchMessage(name, msg)
    if msg then
        dump(msg, name)
    else
        print("GPScene:dispatchMessage:name = " .. name)
    end

    if name == "room.InitGameScenes" then
        self.seatIndex = msg.seat
        self.tableSession = msg.session
        max_player = msg.max_player

        if msg.watching then
            if self.root then
                cc.uiloader:seekNodeByNameFast(self.root, "k_btn_ZhunBei"):setVisible(false)
            end
        end
    elseif name == "room.EnterGame" then
        msg.seat = self:convertSeatToPlayer(msg.seat)
        local gamePlayer = GamePlayer:create(msg,self)
        gamePlayers[msg.seat] = gamePlayer
    elseif name == "room.LeaveGame" then
        local seat = self:convertSeatToPlayer(msg.seat)
        gamePlayers[seat]:OutRoot()      --退出房间
        gamePlayers[seat] = nil
        if msg.seat == self.seatIndex then
            self.seatIndex = 0
            self.tableSession = 0
        end
    elseif name == "room.Ready" then
        msg.seat = self:convertSeatToPlayer(msg.seat)
        gamePlayers[msg.seat]:setPlayerReadyState(1)    --显示已准备

        if not self:isPlayerAllReady() then  --是否桌子上的玩家已经全部准备
            if msg.seat == 1 then --自己的准备回复
               cc.uiloader:seekNodeByNameFast(self.root, "k_img_DengDaiZhunBei"):setVisible(true)   --显示等待其他玩家
            end
        else
            cc.uiloader:seekNodeByNameFast(self.root, "k_img_DengDaiZhunBei"):setVisible(false)   --隐藏等待其他玩家
            for k,v in ipairs(gamePlayers) do
                v:setPlayerReadyState(0)
            end
        end
    elseif self.tableSession == msg.session then
        if name == "GP.Deal" then    --  发牌
            isPalyerChuPai = false
            --禁用点击事件
            self.root:setTouchEnabled(false)
            --倒计时时间
            self.DaoJiShiTime = msg.openCardTime
            --显示废弃牌
            self:showAbandonedCard()
            --显示抵住
            cc.uiloader:seekNodeByNameFast(self.root, "k_tx_DiZhu"):setString(tostring(msg.baseScore))
            --发牌
            self:createPalyerCard(msg.cardofdeal,msg.handoutplayer)

            GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_DISPATCH)
        elseif name == "GP.TuoGuan" then   --开启托管
            msg.seatid = self:convertSeatToPlayer(msg.seatid)

            if not gamePlayers[msg.seatid]:isTuoGuanEnabled() then   --如果没有开启托管 就开启托管
                print("玩家 " .. msg.seatid .. " 开启了托管")
                gamePlayers[msg.seatid]:setTuoGuanState(true)
            end

        elseif name == "GP.CancelTuoGuanRep" then   --取消托管
            msg.seatid = self:convertSeatToPlayer(msg.seatid)

            print("取消托管剩下的倒计时时间 = " .. msg.timeRelease)

            if gamePlayers[msg.seatid]:isTuoGuanEnabled() then   --如果开启了托管 就取消托管
                gamePlayers[msg.seatid]:setTuoGuanState(false)
            end

            if msg.seatid == 1 then
                if gamePlayers[1]:isShowChuPai() then
                    gamePlayers[1]:hideChuPai()
                    gamePlayers[1]:showChuPai(msg.timeRelease)
                end
            else
                if gamePlayers[2]:isShowDengDaiChuPai() then
                    gamePlayers[2]:hideDengDaiChuPai()
                    gamePlayers[2]:showDengDaiChuPai(msg.timeRelease)
                end
            end

        elseif name == "GP.HandoutRep" then  -- 出牌
            print("收到出牌请求")
            if not isPalyerChuPai then
                isPalyerChuPai = true
            end

            msg.seatid = self:convertSeatToPlayer(msg.seatid)

            if msg.seatid == 1 then
                gamePlayers[2]:setBuChuTextShowState(false)
            else
                gamePlayers[1]:setBuChuTextShowState(false)
            end
 
            gamePlayers[msg.seatid]:ChuPai(msg.handoutcard,msg.cardNum)

            if #gamePlayers[msg.seatid].m_Cards ~= 0 then
                if msg.handoutPlayer == self.seatIndex then
                    gamePlayers[1]:showChuPai(nil,msg.handoutcard)
                    gamePlayers[2]:hideDengDaiChuPai()
                else
                    gamePlayers[1]:hideChuPai()
                    gamePlayers[2]:showDengDaiChuPai()
                end
            end
        elseif name == "GP.Result" then  --结算
            print("收到结算请求")

            GamePlayer.clearData()

            gamePlayers[1]:Result()
            gamePlayers[2]:Result()

            if msg.result == 1 then  --如果我是赢家
                msg.YingJiaName = gamePlayers[1].m_playerInfo.player.name
                msg.ShuJiaName = gamePlayers[2].m_playerInfo.player.name
            else
                msg.YingJiaName = gamePlayers[2].m_playerInfo.player.name
                msg.ShuJiaName = gamePlayers[1].m_playerInfo.player.name
            end

            local settlementLayer = SettlementLayer:create(self,msg)
            self.root:add(settlementLayer,2000)

            if msg.records[2].cardleastnum == "17"  then  --全关
                gamePlayers[1]:playQuanGuanAction()
                GP_Audio.playSoundWithPath(GP_Audio.preloadResPath.GP_SOUND_ALLOFF)
            end

            --显示废弃的牌值
            self:SortCards(1,msg.cardleast)
            for k,v in ipairs(msg.cardleast) do
                if abandonedCards[k] ~= nil then
                    abandonedCards[k]:setNum(v.num)
                    abandonedCards[k]:setCardColor(v.color)
                end
            end
            self:showAbandonedCard(true)

            --如果我是赢家就显示输家手里的牌
            self:SortCards(2,msg.handCard)
            if msg.result == 1 then
                ClearCard = gamePlayers[2].m_Cards
                for k,v in ipairs(msg.handCard) do
                    if ClearCard[k] ~= nil then
                        ClearCard[k]:setNum(v.num)
                        ClearCard[k]:setCardColor(v.color)
                        ClearCard[k]:showFront()
                        ClearCard[k]:setLocalZOrder(ClearCard[k]:getPositionX())
                    end
                end
            else
                ClearCard = gamePlayers[1].m_Cards
            end

            gamePlayers[1].m_Cards = {}
            gamePlayers[2].m_Cards = {}
            selectCard = {}  --手指选择的牌

        elseif name == "GP.ReloadSence" then   --恢复场景
            print("开始恢复场景")

            self.DaoJiShiTime = msg.openCardTime

            --隐藏准备按钮
            cc.uiloader:seekNodeByNameFast(gamePlayers[1].m_UINode, "k_btn_ZhunBei"):setVisible(false)

            --恢复自己的牌
                --创建牌
                for k,v in ipairs(msg.handCard) do
                    local card = Card.new()
                    local frame = cc.SpriteFrame:create("Image/GP/img_Pai.png",cc.rect(0,4*define.cardHeight,define.cardWidth,define.cardHeight))
                    card:setSpriteFrame(frame)
                    card:center()
                    card:setVisible(false)
                    card:setNum(v.num)
                    card:setCardColor(v.color)
                    card:addTo(self.root)
                    --赋值给自己
                    gamePlayers[1].m_Cards[#gamePlayers[1].m_Cards+1] = card
                end

                --排序显示
                gamePlayers[1]:sortCardPoint()
                for k,v in ipairs(gamePlayers[1].m_Cards) do
                    v:setVisible(true)
                end

            --恢复对家的牌
                --创建牌
                for i=1,msg.opponentCardNum do
                    local card = Card.new()
                    local frame = cc.SpriteFrame:create("Image/GP/img_Pai.png",cc.rect(0,4*define.cardHeight,define.cardWidth,define.cardHeight))
                    card:setSpriteFrame(frame)
                    card:center()
                    card:setVisible(false)
                    card:setCardColor(0)            
                    card:setNum(0)
                    card:addTo(self.root)
                    --赋值给对家
                    gamePlayers[2].m_Cards[#gamePlayers[2].m_Cards+1] = card
                end

                --排序显示
                gamePlayers[2]:sortCardPoint()
                for k,v in ipairs(gamePlayers[2].m_Cards) do
                    v:setVisible(true)
                end

            --如果对家正在托管 恢复对家的状态
            if msg.state == 2 then
                print("对面的玩家正在托管")
                gamePlayers[2]:setTuoGuanState(true)
            end

            --恢复桌子上的牌
                msg.curPlayer = self:convertSeatToPlayer(msg.curPlayer)
                if #msg.curCard ~= 0 then
                    --获取位置
                    local X = 0
                    local Y = 0
                    if msg.curPlayer == 1 then
                        X = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_ChuPaiWeiZhi2"):getPositionX()
                        Y = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_ChuPaiWeiZhi2"):getPositionY()
                    else
                        X = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_ChuPaiWeiZhi1"):getPositionX()
                        Y = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_ChuPaiWeiZhi1"):getPositionY()
                    end
                
                    local scaleCoefficient = 0.7
                    local width = (#msg.curCard * define.cardWidthDistance + define.cardWidth - define.cardWidthDistance) * scaleCoefficient
                    X = (X - width / 2) + (define.cardWidth*scaleCoefficient) / 2
                
                    --从大到小排序
                    self:SortCards(1,msg.curCard)
                
                    --创建牌
                    local bg = cc.uiloader:seekNodeByNameFast(self.root, "k_img_BeiJing")
                    for k,v in ipairs(msg.curCard) do
                        local card = Card.new()
                        card:setNum(v.num)
                        card:setCardColor(v.color)
                        card:showFront()
                
                        card:setPosition(cc.p(X,Y))
                        X = X + define.cardWidthDistance * scaleCoefficient
                        card:setScale(0.7)
                        card:setLocalZOrder(k)
                        card:addTo(bg)
                        table.insert(self.HitCards,card)
                    end
                else
                    if isPalyerChuPai then  -- 有人已经出过牌之后  才需要判断要不要显示不出
                        if msg.curPlayer == 1 then
                            gamePlayers[2]:setBuChuTextShowState(true)
                        else
                            gamePlayers[1]:setBuChuTextShowState(true)
                        end
                    end
                end

            --恢复出牌 or 恢复倒计时
                print("恢复场景的倒计时是 = " .. msg.time)
                if msg.curPlayer == 1 then
                    gamePlayers[1]:showChuPai(msg.time,msg.curCard)
                else
                    gamePlayers[2]:showDengDaiChuPai(msg.time)
                end

            --恢复废弃的牌
                self:showAbandonedCard()
            --恢复抵住
                cc.uiloader:seekNodeByNameFast(self.root, "k_tx_DiZhu"):setString(tostring(msg.baseScore))

            --恢复触摸状态
            self.root:setTouchEnabled(true)
        end
    end
end

-- start --

--------------------------------
-- --创建发出去的牌
-- @function createPalyerCard
-- @param table cardofdeal       服务器发给玩家的牌
-- @param number handoutplayer   先出牌的一方的椅子ID

-- end --
function GPScene:createPalyerCard(cardofdeal,handoutplayer)
    if #waitCards ~= 0 then
        for k,v in waitCards do
            v:removeFromParent()
            v = nil
        end
    end
    waitCards = {}

    for i=1,34 do       --创建34张需要发给玩家的牌
        waitCards[i] = Card.new()
        local frame = cc.SpriteFrame:create("Image/GP/img_Pai.png",cc.rect(0,4*define.cardHeight,define.cardWidth,define.cardHeight))
        waitCards[i]:setSpriteFrame(frame)
        waitCards[i]:center()
        waitCards[i]:setVisible(false)
        waitCards[i]:addTo(self.root)
    end

    local hand = nil
    local function onSendCard(dt)  --发牌定时器
        if isSendCard then   --如果正在播放发牌动画直接返回
            return
        end

        isSendCard = true   --开始发牌
    
        local playerIndex = (#waitCards % 2) + 1   --轮流发牌的 椅子号
        local card = table.remove(waitCards,1)     --要发送的牌
        if playerIndex == 1 then                   --给自己发牌
            local cardValue = table.remove(cardofdeal,1)
            card:setCardColor(cardValue.color)     --设置牌的花色
            card:setNum(cardValue.num)             --设置牌的点数
        else                          --给对手的牌  牌的 花色与牌值 先设置为默认的0
            card:setCardColor(0)
            card:setNum(0)
        end
    
        local function cardSendFinishedCallback()     --发牌动画播放结束 回调继续发下一张牌
            if #waitCards == 0 then        --牌已经全部发送

                self:stopAction(hand)    --结束发牌定时器
                audio.stopAllSounds()    --停止发牌音效
    
                --显示出牌
                if handoutplayer == self.seatIndex then --自己出牌
                    gamePlayers[1]:showChuPai(self.DaoJiShiTime+4,nil)
                else                           --另一个人在出牌
                    gamePlayers[2]:showDengDaiChuPai(self.DaoJiShiTime+4)
                end

                self.root:setTouchEnabled(true)    -- 开启触摸选牌
            end

            isSendCard = false         --结束发牌
        end

        gamePlayers[playerIndex]:sendCard(card,cardSendFinishedCallback)    --给 playerIndex 对应的玩家 发一张牌
    end

    hand = self:schedule(onSendCard,0.03)    --启动发牌定时器
end

-- start --

--------------------------------
-- 创建11张废弃的牌
-- @function resetAbandonedCard

-- end --
function GPScene:createAbandonedCard()

    print("abandonedCards = " .. #abandonedCards)
    for k,v in ipairs(abandonedCards) do
        v:removeFromParent()
    end
    abandonedCards = {}


    local FeiPaiNode = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_FeiPaiWeiZhi")

    for i=1,9 do
        abandonedCards[i] = Card.new()
        local frame = cc.SpriteFrame:create("Image/GP/img_Pai.png",cc.rect(0,4*define.cardHeight,define.cardWidth,define.cardHeight))
        abandonedCards[i]:setSpriteFrame(frame)
        abandonedCards[i]:setScale(0.63)
        abandonedCards[i]:setAnchorPoint(cc.p(0.5,1))
        abandonedCards[i]:setPosition(cc.p(0,i * define.cardHeightDistance * -1))
        FeiPaiNode:addChild(abandonedCards[i])

        if i == 9 then
            display.newSprite("Image/GP/tx_FeiPaiWenZi.png")
                :setName("tx_FeiPaiWenZi")
                :pos(0,(abandonedCards[i]:getContentSize().height/2+((i-2)*define.cardHeightDistance))*-1)
                :addTo(FeiPaiNode)
        end
    end

    self:hideAbandonedCard()  --创建之后先隐藏 等开始游戏之后在显示
end

-- start --

--------------------------------
-- 重置废弃的牌  为重新开局准备
-- @function resetAbandonedCard

-- end --
function GPScene:resetAbandonedCard()
    local FeiPaiNode = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_FeiPaiWeiZhi")

    for k,v in ipairs(abandonedCards) do
        v:showLast()

        --调整位置
        v:setPosition(cc.p(0,k * define.cardHeightDistance * -1))
    end

    --显示 废牌11张
    if FeiPaiNode:getChildByName("tx_FeiPaiWenZi") then
        FeiPaiNode:getChildByName("tx_FeiPaiWenZi"):setVisible(true)
    end
end

-- start --

--------------------------------
-- 显示废弃的牌
-- @function showAbandonedCard
-- @param bool showRange        如果为 true 显示正面 调整位置 结算的时候会传 true

-- end --
function GPScene:showAbandonedCard(showRange)
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_FeiPaiWeiZhi"):setVisible(true)

    if showRange then
        --隐藏 废牌9张
        local FeiPaiNode = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_FeiPaiWeiZhi")
        if FeiPaiNode:getChildByName("tx_FeiPaiWenZi") then
            FeiPaiNode:getChildByName("tx_FeiPaiWenZi"):setVisible(false)
        end

        for k,v in ipairs(abandonedCards) do
            --显示正面
            v:showFront()

            --调整位置
            if k < 4 then
                v:setPositionY((v:getScaleContentSize().height/2) * 0.9 - v:getScaleContentSize().height)
    
                local x = ((3 * define.cardWidthDistance * 0.7) + v:getScaleContentSize().width)/2 + v:getScaleContentSize().width/2
                    - v:getScaleContentSize().width * 1.8
                x = x + (k-1) * define.cardWidthDistance * 0.7
                v:setPositionX(x+13)
            elseif k < 7 then
                v:setPositionY(0 - v:getScaleContentSize().height)
    
                local x = ((3 * define.cardWidthDistance * 0.7) + v:getScaleContentSize().width)/2 + v:getScaleContentSize().width/2
                    - v:getScaleContentSize().width * 1.8
                x = x + (k-4) * define.cardWidthDistance * 0.7
                v:setPositionX(x+13)
            else
                v:setPositionY((v:getScaleContentSize().height/2) * 0.9 * -1 - v:getScaleContentSize().height)
    
                local x = ((5 * define.cardWidthDistance * 0.7) + v:getScaleContentSize().width)/2 + v:getScaleContentSize().width/2
                    - v:getScaleContentSize().width * 1.8
                x = x + (k-8) * define.cardWidthDistance * 0.7
                v:setPositionX(x+13)
            end
        end
    end
end

-- start --

--------------------------------
-- 隐藏废弃的牌 游戏结束重新准备的时候调用
-- @function hideAbandonedCard

-- end --
function GPScene:hideAbandonedCard()
    cc.uiloader:seekNodeByNameFast(self.root, "k_nd_FeiPaiWeiZhi"):setVisible(false)
end

-- start --

--------------------------------
-- 是否桌子上的玩家已经全部准备
-- @function isPlayerAllReady
-- @return bool#bool        是否桌子上的玩家已经全部准备

-- end --
function GPScene:isPlayerAllReady()
    if #gamePlayers < max_player then   --桌子人数还没达到游戏开始人数 直接返回
        return false
    end

    for k,v in ipairs(gamePlayers) do
        if v.m_playerInfo.player.ready == 0 then    --如果有玩家还没准备返回 false
            return false
        end
    end

    return true   -- 全部准备返回 true
end


-- start --

--------------------------------
-- 转换 椅子号 对应玩家的位置  msg.seat = 1 = 自己
-- @function convertSeatToPlayer
-- @param number seat           玩家在服务器的 椅子号
-- @return number#number        转换之后面向本地玩家的 椅子号

-- end --
function GPScene:convertSeatToPlayer(seat)
    local difference = self.seatIndex - 1
    if seat - difference <= 0 then
        seat = seat + max_player - difference
    else 
        seat  = seat - difference
    end

    return seat
end

-- start --

--------------------------------
-- 排序一组牌  or  排序一组实际的手牌
-- @function SortCards
-- @param number order    1 等于从大到小   2 等于从小到大
-- @param table cards     需要排序的牌

-- end --
function GPScene:SortCards(order,cards)
    for k,v in ipairs(cards) do
        if v.num <= 2 then
            v.num = v.num + 13
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
        if v.num >= 14 then
            v.num = v.num - 13
        end
    end
end

function GPScene:SortCardsEx(order,cards)
    for k,v in ipairs(cards) do
        if v.m_num <= 2 then
            v.m_num = v.m_num + 13
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
        if v.m_num >= 14 then
            v.m_num = v.m_num - 13
        end
    end
end

-- start --

--------------------------------
-- 重新开始
-- @function againStart

-- end --
function GPScene:againStart()
    print("----------------------")
    print(type(self.seatIndex))
    print(type(self.tableSession))
    if self.seatIndex == 0 and self.tableSession == 0 then
        message.dispatchGame("room.LeaveGame")
        return 
    end

    --删除需要清理手牌
    if ClearCard ~= nil then
        for k,v in ipairs(ClearCard) do
            v:removeFromParent()
        end
    end
    ClearCard = {}
    selectCard = {}  --手指选择的牌

    --删除桌子上的牌
    for k,v in ipairs(self.HitCards) do
        v:removeFromParent()
    end
    self.HitCards = {}

    --隐藏和重制废弃的牌
    self:hideAbandonedCard()
    self:resetAbandonedCard()

    --隐藏不出文字
    gamePlayers[1]:setBuChuTextShowState(false)
    if gamePlayers[2] then
        gamePlayers[2]:setBuChuTextShowState(false)
    end

    gamePlayers[1]:clickReady()
end

-- start --

--------------------------------
-- 退出房间
-- @function quitRoot

-- end --
function GPScene:quitRoot()
    uiSettings:clickExit()
end

-- -- start --

-- --------------------------------
-- -- 判断牌型
-- -- @function PanDuanPaiXing
-- -- @param number cards      判断牌型的牌
-- -- @return number#number    返回牌型    

-- -- end --
-- function GPScene:PanDuanPaiXing()

-- end


-- -- start --

-- --------------------------------
-- -- 是否单牌
-- -- @function isDanZhang
-- -- @param number cards      判断牌型的牌
-- -- @return bool#bool        是不是单张

-- -- end --
-- function GPScene:isDanZhang(cards)
--     return #cards == 1
-- end

-- -- start --

-- --------------------------------
-- -- 是否对子
-- -- @function isDuiZi
-- -- @param number cards      判断牌型的牌
-- -- @return bool#bool        是不是对子

-- -- end --
-- function GPScene:isDuiZi(cards)
--     return #cards == 2 and cards[1]:getNum() == cards[2]:getNum()
-- end

-- -- start --

-- --------------------------------
-- -- 是否三张
-- -- @function isSanZhang
-- -- @param number cards      判断牌型的牌
-- -- @return bool#bool        是不是三张

-- -- end --
-- function GPScene:isSanZhang(cards)
--     return #cards == 3 and cards[1]:getNum() == cards[2]:getNum() and cards[1]:getNum() == cards[3]:getNum()
-- end

-- -- start --

-- --------------------------------
-- -- 是否俘虏
-- -- @function convertSeatToPlayer
-- -- @param number cards      判断牌型的牌
-- -- @return bool#bool        是不是俘虏

-- -- end --
-- function GPScene:isFuLu(cards)
--     if #cards == 5 then
--         if (cards[1]:getNum() == cards[2]:getNum() and cards[1]:getNum() == cards[3]:getNum() and cards[4]:getNum() == cards[5]:getNum()) 
--             or (cards[3]:getNum() == cards[4]:getNum() and cards[5]:getNum() == cards[3]:getNum() and cards[1]:getNum() == cards[2]:getNum()) then
--             return true
--         end
--     end

--     return false
-- end

-- -- start --

-- --------------------------------
-- -- 是否连对
-- -- @function convertSeatToPlayer
-- -- @param number cards      判断牌型的牌
-- -- @return bool#bool        是不是连对

-- -- end --
-- function GPScene:isLianDui(cards)
--     if (#cards % 2) == 0 then
--         for i=2,#cards,2 do
--             if cards[i] then
--                 --todo
--             end
--         end
--     end

--     return true
-- end

return GPScene