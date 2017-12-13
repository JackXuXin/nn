--
-- Author: peter
-- Date: 2017-04-20 13:21:12
--
local msgWorker = require("app.net.MsgWorker")          --注册监听
local utilCom = require("app.Common.util")
local Share = require("app.User.Share")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local AvatarConfig = require("app.config.AvatarConfig")
local ProgressLayer = require("app.layers.ProgressLayer")
local PRMessage = require("app.net.PRMessage")
local Message = require("app.net.Message")

local progressTag = 10000




local Modular = {
    {name = "WRNN_MsgMgr",path = "app.Games.WRNN.WRNN_MsgMgr"},
    {name = "WRNN_Const",path = "app.Games.WRNN.WRNN_Const"},
    {name = "WRNN_Util",path = "app.Games.WRNN.WRNN_Util"},
    {name = "WRNN_PlayerMgr",path = "app.Games.WRNN.WRNN_PlayerMgr"},
    {name = "WRNN_PlayerInfo",path = "app.Games.WRNN.WRNN_PlayerInfo"},
    {name = "WRNN_uiPlayerInfos",path = "app.Games.WRNN.WRNN_uiPlayerInfos"},
    {name = "WRNN_uiOperates",path = "app.Games.WRNN.WRNN_uiOperates"},
    {name = "WRNN_uiSettings",path = "app.Games.WRNN.WRNN_uiSettings"},
    {name = "WRNN_Message",path = "app.Games.WRNN.WRNN_Message"},
    {name = "WRNN_CardMgr",path = "app.Games.WRNN.WRNN_CardMgr"},
    {name = "WRNN_Card",path = "app.Games.WRNN.WRNN_Card"},
    {name = "WRNN_uiRule",path = "app.Games.WRNN.WRNN_uiRule"},
    {name = "WRNN_uiTableInfos",path = "app.Games.WRNN.WRNN_uiTableInfos"},
    {name = "WRNN_uiResults",path = "app.Games.WRNN.WRNN_uiResults"},
    {name = "WRNN_Audio",path = "app.Games.WRNN.WRNN_Audio"},
    {name = "WRNN_ActionMgr",path = "app.Games.WRNN.WRNN_ActionMgr"},
}


local WRNNScene = class("WRNNScene",function()
        return display.newScene("WRNNScene")
    end)




function WRNNScene:ctor()
    print("构造 五人牛牛 场景")
    self.root = cc.uiloader:load("Scene/WRNNScene.json"):addTo(self)
    self.seatIndex = 0
    self.tableId = 0
    self.session = 0
    self.bankerSeat = 0
    self.status = 0   --游戏状态  0 参与 1 未参与
    self.watching = false    --是否旁观
    self.maxBetGold = 0 --本局最大下注数
    self.currentMaxBetGold = 0 --本局当前最大下注数
    self.roominfo ={} --房间信息
    self.OpenCardState = false --亮牌状态
    self.game_state = 0
    self.SendCardTimes =0
    
    self.ReConnectState = false --断线重连状态
    self.ReadyState = false    -- 准备状态

       --表情变量
    self.emoBgLayer =nil
    self.lastPosX   =nil
    self.lastPosY   =nil
    self.cureHead   =nil
    self.uidText    =nil

   



    utilCom.SetVoiceBtn(self,self.root)
    for k,v in ipairs(Modular) do
        self[v.name] = require(v.path)
        if self[v.name]["init"] then
             self[v.name]:init(self)
        end
    end
   -- --截屏分享
  --   Share.SetGameShareBtn(true, self, display.right-69, display.bottom+140)


    self:setWifiState()
    self:init_emos()
    msgWorker.init("WRNN", handler(self.WRNN_MsgMgr, self.WRNN_MsgMgr.dispatchMessage))




    
  -- self:test()


end

function WRNNScene:onEnter()
    print("进入 五人牛牛 场景")


end

--[[
    * 停止节点与所有子节点动作
    * @param cc.Node node 目标节点
--]]
local function stopNodeWithChildAction(target)
    --关闭所有动作定时器
    if target:getNumberOfRunningActions() > 0 then
        target:stopAllActions()
    end

    nodes = target:getChildren()
    if nodes and #nodes ~= 0 then
        for _,node in pairs(nodes) do
            stopNodeWithChildAction(node)
        end
    else
        return
    end
end

 function WRNNScene:onExit()
      self:clearScene()
 end

function WRNNScene:onEnterBackground()
    print("-------------WRNNScene: 退到后台 ----------------")
    Message.sendMessage("game.LeaveRoomReq", {session = self.room_session})
end

function WRNNScene:onEnterForeground()
    print("-------------WRNNScene: 后台进来 ----------------")
    PRMessage.EnterPrivateRoomReq(self.roominfo.table_code)
       
end


function WRNNScene:onEnterTransitionFinish()
 

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create(app.APP_ENTER_BACKGROUND_EVENT,
                                handler(self, self.onEnterBackground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create(app.APP_ENTER_FOREGROUND_EVENT,
                                handler(self, self.onEnterForeground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

end



--[[
    * 清理
    * @param boolean isStopAction 是否停止所有动作
--]]
function WRNNScene:clearScene(isStopAction)
    print("离开 五人牛牛 场景")

    if isStopAction then
       stopNodeWithChildAction(self.root)
    end

    for k,v in ipairs(Modular) do
        if  self[v.name]["clear"] then
            self[v.name]:clear()
        end
    end

    -- if self.delayHandler then
    --     scheduler.unscheduleGlobal(self.delayHandler)
    --     self.delayHandler = nil
    -- end
    if  self.emoBgLayer ~= nil  then
         self.emoBgLayer:removeFromParent()
         self.emoBgLayer=nil
         self.cureHead = nil
         self.uidText= nil
    end


end



--[设置信号状态]
function WRNNScene:setWifiState()


    local node = display.newNode()
    node:addTo(self.root)
    node:setPosition(1000,650)

    local netBg = display.newSprite("Image/PrivateRoom/img_NetBg.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(node)
        :setPosition(88,21.5)

    local netG = display.newSprite("Image/PrivateRoom/img_NetG.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(node)
        :setPosition(88,21.5)
        :hide()

    local netY = display.newSprite("Image/PrivateRoom/img_NetY.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(node)
        :setPosition(88,21.5)
        :hide()

    --延迟时间
    local delayTime = app.constant.delayTime 
    --delayTime = 1090
    local netTime = cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 19, 
        text = delayTime .. "ms"
    })
    :addTo(node)
    :setAnchorPoint(cc.p(1, 0.5))
    :setPosition(82,16)

    local setDelayTime = function()             

             if netTime ~= nil then
                             delayTime = app.constant.delayTime
                       -- print("delayHandler--- = ",delayTime)
                        local strTime = delayTime .. "ms"
                        netTime:setString(strTime)

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

           
    end

    setDelayTime()

   -- if self.delayHandler == nil then
      node:stopAllActions()
      node:schedule( 
        function()
            setDelayTime()
        end, 1)
    --end
end



--创建互动表情
function WRNNScene:init_emos()
         --表情相关

    local rect = cc.rect(0, 0, 188, 188)

    if  self.emoBgLayer == nil then
         self.emoBgLayer = display.newSprite("Image/PrivateRoom/img_EmoBg.png")
        :hide()
        :addTo(self.root,2020)
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
    local Image_1 = cc.uiloader:seekNodeByNameFast(self.root, "img_background")
    if Image_1 ~= nil then
        Image_1:setTouchEnabled(true)
        Image_1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                if  self.emoBgLayer ~= nil then
                     self.emoBgLayer:hide()
                end
                return true
            end
        end)
    end

    local function onGitEmo(event)

        print("button.index = ",event.target.index)

        local visible =  self.emoBgLayer:isVisible()
        print(visible)
        local ui_node = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player_info_" .. event.target.index)
        local pos_x_offset = 45
        local pos_y_offset = 22
        local index = event.target.index
        local direct = "left"

        if index == 2  then
            pos_x_offset = -255
            pos_y_offset = 0
            direct = "right"
        elseif index == 3   then
            pos_x_offset = -55
            pos_y_offset = -45
            direct = "right"
        elseif index == 4 or index == 5 then
            pos_x_offset = 55
            pos_y_offset = 0
            direct = "top"
        else
            pos_x_offset = 55
            pos_y_offset = 0
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


        local info = self.WRNN_PlayerMgr.playerInfos[index]
        
        local seat = self.WRNN_Util.convertSeatToTable(info.seat)
        -- print("info.seat  "..info.seat)
        -- print("set "..seat)
        utilCom.showEmotionsLayer(self,  self.emoBgLayer,seat)
        if  self.emoBgLayer:isVisible() then
            
           
           -- dump(info,"--player---info--")
           --  --头像
           local  image = AvatarConfig:getAvatar(info.sex, info.gold, info.viptype)
           local  rect = cc.rect(0, 0, 188, 188)
           local  frame = cc.SpriteFrame:create(image, rect)
           if frame then
                 if self.cureHead then
                     self.cureHead:setSpriteFrame(frame)
                     self.cureHead:setScale(0.3734)
                 end                
                     utilCom.setImageNodeHide( self.emoBgLayer, 101)              
                     utilCom.setHeadImage( self.emoBgLayer, info.imageid,  self.cureHead, image, 101)           
                     self.uidText:setString(utilCom.checkNickName(info.name,15))
           else
               print("错误  错误  错误")
           end
           
    
        end

    end

    --表情按钮
    for i=1,6 do
        local ui_node = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player_info_" .. i)
        if ui_node then
             local btn_gifEmo = cc.uiloader:seekNodeByNameFast(ui_node, "btn_gifEmo")
                :onButtonClicked(onGitEmo)
                btn_gifEmo.index = i
                utilCom.BtnScaleFun(btn_gifEmo)
        end
    end

end

function WRNNScene:SendEmotion(id, toSeat)
   -- local toSeat = utilCom.getToSeat(direct, self.roominfo.max_player, self.seatIndex, 1)
    -- print("发送表情消息-toSeat = ,direct = ",toSeat, toSeat)
    -- print("发送表情消息-roomsession =")
     
    self.WRNN_Message.sendMessage("game.ChatReq", {session = self.room_session,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
end

function WRNNScene:playEmotion(index, fromDirect, toDirect)

    local beginPos =  self.WRNN_uiPlayerInfos:getHeadIconPos(fromDirect)  
    local endPos =  self.WRNN_uiPlayerInfos:getHeadIconPos(toDirect)

    utilCom.RunEmotionInfo(self.root, index, beginPos, endPos)
end

function WRNNScene:setEmoBtnTouch(isTouch)

    for i=1,6 do
        local ui_node = cc.uiloader:seekNodeByNameFast(self.root, "k_nd_player_info_" .. i)
        if ui_node then
             local btn_gifEmo = cc.uiloader:seekNodeByNameFast(ui_node, "btn_gifEmo")
             btn_gifEmo:setTouchEnabled(isTouch)
        end
    end
end


function WRNNScene:closeProgressLayer()

    local progressLayer = self:getChildByTag(progressTag)
    if progressLayer then
      print("ShYMJScene:closeProgressLayer--移除加载")
      ProgressLayer.removeProgressLayer(progressLayer)
    end
end
function WRNNScene:socket(msg)
    print("WRNNScene:socket = ", msg)
    if msg == "SOCKET_TCP_CONNECTED" then
        PRMessage.EnterPrivateRoomReq(nil)
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

-- --搓牌测试
-- local CardGrid = require("app.Common.CardGrid")
-- local M_PI = 3.1415
-- local m_pBgSprite
-- local m_sGridSize
-- local m_pForeSprite
-- local m_pForeSpriteVertical 
-- local m_pBgSpriteVertical

-- local mHOffsetX
-- local mHOffsetY
-- local mVOffsetX
-- local mVOffsetY
-- local mFlipDemoOffset 
-- local isIncrease
-- local mTouchBegin
-- local mCardShowType  = 1
-- local Horizontal = 1
-- local Horizontal = 2


-- local function vertex( position,pTarget)  
--     --local g = pTarget:getGrid_c()  
--     return pTarget:vertex(position)  
-- end  

-- local function originalVertex(position,pTarget)  
  
--     --local g = pTarget:getGrid_c()  
--     return pTarget:getOriginalVertex(position)  
-- end  
-- local function setVertex(position, vertex,pTarget)  
  
--     --local g  = pTarget:getGrid_c()  
--     pTarget:setVertex(position, vertex) 
-- end  
-- function WRNNScene:calculateHorizontalVertexPoints(offsetX,flag)    
--     local  R = 50       
--     if flag then 
      
--         local  theta = M_PI / 6.0    --弧度
--         local  agle  = 180/M_PI * theta
--         local   b = (m_pBgSprite:getContentSize().width - offsetX * 1.4) * math.sin(agle)   --sinf(theta);  
          
--         for  i = 1, m_sGridSize.width do  
          
--             for  j = 1 ,m_sGridSize.height do
              
--                 -- Get original vertex  
--                 local p = originalVertex(cc.p(i ,j),m_pForeSprite) 
                  
--                 local  x = (p.y + b) / math.tan(agle) 
                  
--                 local pivotX = x + (p.x - x) * math.cos(agle) * math.cos(agle) 
--                 local pivotY = pivotX * math.tan(agle) - b  
                  
--                 local l = (p.x - pivotX) / math.sin(agle)  
--                 local alpha = l / R 
--                 local alpha_a = 180/M_PI * alpha 
--                 if l >= 0  then
                   
--                         if alpha > M_PI then 
--                             p.x = mHOffsetX + pivotX - R * (alpha - M_PI) * math.sin(agle)  
--                             p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle)  
--                             p.z = 2 * R / 9  
                          
--                         elseif alpha <= M_PI  then                      
--                             p.x = mHOffsetX + pivotX + R * math.sin(alpha_a) * math.sin(agle)  
--                             p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * math.cos(agle)  
--                             p.z = (R - R * math.cos(agle)) / 9  
--                         end     
--                 else 
--                     p.x =  p.x + mHOffsetX  
--                     p.y =  p.y + mHOffsetY  
--                 end  
                  
--                 -- Set new coords  
--                 setVertex(cc.p(i, j), p,m_pForeSprite)  
                  
                  
--             end  
--         end  
          
--         for  i = 1, m_sGridSize.width do  
          
--             for  j = 1,m_sGridSize.height do
              
--                 -- Get original vertex  
--                 local   p = originalVertex(cc.p(i ,j),m_pBgSprite)
--                 local  x = (p.y + b) / math.tan(agle)  
                  
--                 local pivotX = x + (p.x - x) * math.cos(agle) * math.cos(agle)  
--                 local  pivotY = pivotX * math.tan(agle) - b  
                  
--                 local l = (p.x - pivotX) / math.sin(agle)  
--                 local alpha = l / R 
--                 local alpha_a = 180/M_PI * alpha 
--                 if (l >= 0) then
--                     if (alpha > M_PI) then
--                         p.x = mHOffsetX + pivotX - R * (alpha - M_PI) * math.sin(agle)  
--                         p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle) 
--                         p.z = 2 * R / 9 
 
--                     elseif (alpha <= M_PI)  then
                     
--                         p.x = mHOffsetX + pivotX + R * math.sin(alpha_a) * sinf(agle)  
--                         p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * cosf(agle)  
--                         p.z = (R - R * math.cos(alpha_a)) / 9  
--                     end 
                  
--                 else  
                  
--                     p.x = p.x + mHOffsetX  
--                     p.y = p.y + mHOffsetY  
--                 end  
                  
--                 setVertex(cc.p(i, j), p,m_pBgSprite) 
                                   
                  
--             end  
--         end  
          
      
--     else  
      
--         local  theta = M_PI / 6.0 
--         local  agle  = 180/M_PI * theta
--         local  b = math.abs(offsetX * 0.8) 
--         for i = 1 , m_sGridSize.width  do
          
--             for  j = 1, m_sGridSize.height do
              
--                 -- Get original vertex  
--                 local p = originalVertex(cc.p(i ,j),m_pForeSprite)  
                  
--                 local x = (p.y - b) / - math.tan(agle)  
                  
--                 local pivotX = p.x + (x - p.x) * math.sin(agle) * math.sin(agle)  
--                 local pivotY = pivotX * -math.tan(agle) + b  
                  
--                 local l = (pivotX - p.x) / math.sin(agle)  
--                 local alpha = l / R
--                 local alpha_a = 180/M_PI * alpha  


--                 if (l >= 0) then
--                     if (alpha > M_PI) then
--                         p.x = mHOffsetX + pivotX + R * (alpha - M_PI) * math.sin(agle)  
--                         p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle) 
--                         p.z = 2 * R / 9 
                     
--                     elseif (alpha <= M_PI)   then
                      
--                         p.x = mHOffsetX + pivotX - R * math.sin(alpha_a) * math.sin(agle)  
--                         p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * math.cos(agle)  
--                         p.z = (R - R * math.cos(alpha_a)) / 9  
--                     end 
                
--                 else  
                
--                     p.x = p.x+mHOffsetX  
--                     p.y = p.y+mHOffsetY 
--                 end 
                  
--                 -- Set new coords  
--                 setVertex(cc.p(i, j), p,m_pForeSprite)  
                  
                  
--             end  
--         end  
          
--         for i = 1 ,m_sGridSize.width do  
          
--             for  j = 1, m_sGridSize.height do
              
--                 -- Get original vertex  
--                 local p = originalVertex(ccp(i ,j),m_pBgSprite)  
                  
--                 local x = (p.y - b) / -math.tan(agle)  
                  
--                 local pivotX = p.x + (x - p.x) * math.sin(agle) * math.sin(agle) 
--                 local pivotY = pivotX * -math.tan(agle) + b  
                  
--                 local l = (pivotX - p.x) / math.sin(agle)  
--                 local alpha = l / R 
--                 local alpha_a = 180/M_PI * alpha  
--                 if (l >= 0)  then  
--                     if (alpha > M_PI) then
--                         p.x = mHOffsetX + pivotX + R * (alpha - M_PI) * math.sin(agle) 
--                         p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle)  
--                         p.z = 2 * R / 9 
                     
--                     elseif (alpha <= M_PI) then 
                      
--                         p.x = mHOffsetX + pivotX - R * math.sin(alpha_a) * math.sin(agle) 
--                         p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * math.cos(agle)  
--                         p.z = (R - R * math.cos(alpha_a)) / 9  
--                     end  
                  
--                 else  
                  
--                     p.x = p.x+mHOffsetX  
--                     p.y = p.y+mHOffsetY  
--                 end  
  
                  
--                 setVertex(cc.p(i, j), p,m_pBgSprite)  
--             end 
--         end  
--     end  
      
    
-- end   
-- function WRNNScene:calculateVerticalVertexPoints( offsetY)  
  
--     local R2 = 50  
--     local pivotY = offsetY + mVOffsetY  
      
      
--     for  i = 1, m_sGridSize.width do
      
--         for j = 1,m_sGridSize.height do
          
--             -- Get original vertex  
--             local p = originalVertex(cc.p(i ,j),m_pForeSpriteVertical)  
--             local l = pivotY - p.y  
--             local alpha = l / R2
--             local alpha_a = 180/M_PI * alpha 

--             if (l >= 0) then 
--                 if (alpha > M_PI) then
--                     p.z = 2 * R2 / 9  
--                     p.y = mVOffsetY + pivotY + R2 * (alpha - M_PI) 
--                     p.x = p.x + mVOffsetX;  
               
--                 elseif (alpha <= M_PI) then
                 
--                     p.z = (R2 - R2 * math.cos(alpha_a))/9  
--                     p.y = mVOffsetY + pivotY - R2 * math.sin(alpha_a)                       
--                     p.x = p.x +mVOffsetX  
--                 end  
             
--             else  
             
--                 p.x = p.x + mVOffsetX  
--                 p.y = p.y + mVOffsetY  
--             end  
              
              
--             -- Set new coords  
--             setVertex(cc.p(i, j), p,m_pForeSpriteVertical);  
              
              
--         end  
--     end  
      
--     for i = 1, m_sGridSize.width do
      
--         for j = 1, m_sGridSize.height do
          
--             -- Get original vertex  
--             local p = originalVertex(cc.p(i ,j),m_pBgSpriteVertical) 
--             local l = pivotY - p.y 
--             local alpha = l / R2
--             local alpha_a = 180/M_PI * alpha 

--             if (l >= 0)  then
--                 if (alpha > M_PI) then 
--                     p.z = 2 * R2 / 9  
--                     p.y = mVOffsetY + pivotY + R2 * (alpha - M_PI)  
--                     p.x = p.x + mVOffsetX  
                  
--                 elseif (alpha <= M_PI)  then
                  
--                     p.z = (R2 - R2 * math.cos(alpha_a))/9  
--                     p.y = mVOffsetY + pivotY - R2 * math.sin(alpha_a)  
                      
--                     p.x = p.x + mVOffsetX  
--                 end  
              
--             else  
              
--                 p.x = p.x +mVOffsetX  
--                 p.y = p.y +mVOffsetY  
--             end           
--             -- // Set new coords  
--             setVertex(cc.p(i, j), p,m_pBgSpriteVertical)  
              
              
              
--         end  
--     end  
-- end  


--[[
function WRNNScene:test() 

    m_pBgSprite = CardGrid.new("res/Image/test/puke_bg.png")
    m_pForeSprite = CardGrid.new("res/Image/test/puke_4.png")
    m_pForeSprite:pos(640,360)
    m_pBgSprite:pos(640,360)
    m_pForeSprite:addTo(self.root,10000)
    m_pBgSprite:addTo(self.root,10000)
    


    m_pBgSpriteVertical = CardGrid.new("res/Image/test/puke_bg.png")
    m_pForeSpriteVertical = CardGrid.new("res/Image/test/puke_4.png")
    m_pForeSpriteVertical:pos(640,360)
    m_pBgSpriteVertical:pos(640,360)
    m_pForeSpriteVertical:addTo(self.root,10000)
    m_pBgSpriteVertical:addTo(self.root,10000)

    m_sGridSize = cc.size(50,50)

    local size = cc.size(80,160)--m_pBgSprite:getContentSize()
   -- dump(size,"getContentSize")
    self:startWithTarget(m_pForeSprite,true,size)
    self:startWithTarget(m_pBgSprite,false,size)

    self:startWithTarget(m_pForeSpriteVertical,true,size)
    self:startWithTarget(m_pBgSpriteVertical,false,size)

    mFlipDemoOffset =0

     self.root:schedule(function()  

         -- self:onFlipDemoUpdate()
        end,1)

        -- 允许 node 接受触摸事件
        m_pForeSprite:setTouchEnabled(true)
        -- 注册触摸事件
        m_pForeSprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
            function(event)
                if event.name == "began" then
                                    local  point = cc.p(event.x,event.y) 
                                    local  winSize = cc.size(1280,720)                                     
                                    local borderXH = winSize.width/2 + m_pBgSprite:getContentSize().width/2  
                                    local borderYH = winSize.height/2 - m_pBgSprite:getContentSize().height/2  
                                    local borderXHMin = winSize.width/2 - m_pBgSprite:getContentSize().width/2  
                                      
                                    local borderXVMax = winSize.width/2 + m_pBgSprite:getContentSize().height/2 
                                    local borderXVMin = winSize.width/2 - m_pBgSprite:getContentSize().height/2 
                                    local borderYV = mVOffsetY  
                                      
                                    if mCardShowType == Horizontal or mCardShowType == Horizontal2 then
                                      
                                        if point.x > borderXH - 150 and point.x < borderXH and point.y > borderYH and point.y < borderYH + 150 then  
                                          
                                           -- //触摸牌的右下角  
                                            mTouchBegin = cc.p(event.x,event.y) --pTouch->getLocation();  
                                            --unschedule(schedule_selector(PageTurn2::onFlipDemoUpdate));  
                                          
                                        elseif (point.x > borderXHMin and point.x < borderXHMin + 150 and point.y > borderYH and point.y < borderYH + 150) then
                                        --{//触摸牌的左下角  
                                            mTouchBegin = cc.p(event.x,event.y)  --pTouch->getLocation();  
                                           -- unschedule(schedule_selector(PageTurn2::onFlipDemoUpdate));  
                                              
                                        else  
                                         
                                            mTouchBegin = cc.p(0, 0)  
                                        end
                                      
                                    else  
                                      
                                        if (point.x > borderXVMin and point.x < borderXVMax and point.y > borderYV and point.y < borderYV + 150)  then
                                          
                                            --//垂直情况下触摸牌的下边缘  
                                            mTouchBegin = cc.p(event.x,event.y) --pTouch->getLocation();                                       
                                        else  
                                          
                                            mTouchBegin = cc.p(0, 0)  
                                        end  
                                    end 

                    return true
                end

                if event.name == "moved" then
                    

                end
                if event.name == "cancelled" then
                    

                end
                if event.name == "ended" then
                    

                end



                -- event.name 是触摸事件的状态：began, moved, ended, cancelled
                -- event.x, event.y 是触摸点当前位置
                -- event.prevX, event.prevY 是触摸点之前的位置
               -- print("sprite: %s x,y: %0.2f, %0.2f",event.name, event.x, event.y)

                -- 在 began 状态时，如果要让 Node 继续接收该触摸事件的状态变化
                -- 则必须返回 true
          
        end)



end

function WRNNScene:startWithTarget(pTarget, bReverse, size)  
    local newgrid = cc.Grid3D:create(size)        --this->getGrid(bReverse,size);  
    -- local  targetGrid = pTarget:getGrid() 

    -- if targetGrid and  targetGrid:getReuseGrid() > 0 then       
    --     if targetGrid:isActive() and targetGrid:getGridSize().width == m_sGridSize.width  
    --         and targetGrid:getGridSize().height == m_sGridSize.height  then  --/*&& dynamic_cast<CCGridBase*>(targetGrid) != NULL*/         
    --         targetGrid:reuse()      
    --     else           
    --         print("targetGrid  error")
    --     end     
    -- else      
    --     if targetGrid and targetGrid:isActive() then
          
    --         targetGrid:setActive(false)  
    --     end  


        --newgrid:getVertex(cc.p(100,100)) 


        pTarget:setGrid_c(newgrid)  
        pTarget:getGrid_c():setActive(true) 
        print("设置网格 ")
        print(newgrid)
    -- end  
end

function WRNNScene:onFlipDemoUpdate()  
  
    if (mFlipDemoOffset > 100) then  
        isIncrease = false  
    elseif(mFlipDemoOffset <= 0)  then
      
        isIncrease = true  
    end 

    if isIncrease then 
      
        mFlipDemoOffset = mFlipDemoOffset + 2  
      
    else  
      
        mFlipDemoOffset = mFlipDemoOffset - 2  
    end  
      
    if (mCardShowType == Horizontal or mCardShowType == Horizontal2) then
         
        if not m_pBgSprite:isVisible() then  
            m_pBgSprite:setVisible(true)  
            m_pBgSpriteMirror:setVisible(false)  
        end  
        if not m_pForeSprite:isVisible() then 
            m_pForeSprite:setVisible(true) 
            m_pForeSpriteMirror:setVisible(false) 
        end  
      
    else  
      
        if not m_pBgSpriteVertical:isVisible() then
           
            m_pBgSpriteVertical:setVisible(true)  
            m_pBgSpriteMirrorVertical:setVisible(false)  
        end  
        if not m_pForeSpriteVertical:isVisible() then  
            m_pForeSpriteVertical:setVisible(true)  
            m_pForeSpriteMirrorVertical:setVisible(false)  
        end  
    end  
      
    local r = M_PI / 4
    local agle = 180/M_PI * r
    self:calculateHorizontalVertexPoints(mFlipDemoOffset / math.cos(agle),true)  
end  


--]]




return WRNNScene