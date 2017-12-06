--活动抽奖界面
local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}
local UserMessage = require("app.net.UserMessage")
local util = require("app.Common.util")
local ErrorLayer = require("app.layers.ErrorLayer")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local PlatConfig = require("app.config.PlatformConfig")
local ActivityConfig = require("app.config.ActivityConfig")--活动信息配置
local ProgressLayer = require("app.layers.ProgressLayer")
local sound_common = require("app.Common.sound_common")
local Player = app.userdata.Player
local ActID --活动的id


local light_index = 1 --发光的位置
local bushu = 0 --总共步数
local quanshu = math.random(2,4)    --随机圈数
local time = 10 --抽奖定时器时间间隔
local index = 10 --抽到的奖品
local isTouch = true  --抽奖按钮是否可以点击
local list_width=0   --获奖人信息的总长度
local RootNode  --获奖人信息节点
local xinxi_Node --活动介绍节点
local lotteryLayer  --抽奖层
local LotterySch  --转圈定时器
-- local choujiang_ID
local jiangping = {}
-- local wanjiaSch
local jiangping_test=0  --抽到的奖品
local choujiangBtnstatus --判断是否可以抽奖
local info_required = true --是否显示填写抽奖地址
local NewSelf
local turnArrow = nil


local ALLROATE = 360--360度
local num = 12
local duration  = 2.65 --转动持续时间
local rotateNum = 5 --转动圈数
local lastAngle = 0
local offAngle = 15
local aniHandler = nil
--转盘角度数据
local zhuanpanData =
{
    {start = (num-12)*ALLROATE/num + 1-offAngle, ended = (num-11)*ALLROATE/num-offAngle},
    {start = (num-11)*ALLROATE/num + 1-offAngle, ended = (num-10)*ALLROATE/num-offAngle},
    {start = (num-10)*ALLROATE/num + 1-offAngle, ended = (num-9)*ALLROATE/num-offAngle},
    {start = (num-9)*ALLROATE/num + 1-offAngle, ended = (num-8)*ALLROATE/num-offAngle},
    {start = (num-8)*ALLROATE/num + 1-offAngle, ended = (num-7)*ALLROATE/num-offAngle},
    {start = (num-7)*ALLROATE/num + 1-offAngle, ended = (num-6)*ALLROATE/num-offAngle},
    {start = (num-6)*ALLROATE/num + 1-offAngle, ended = (num-5)*ALLROATE/num-offAngle},
    {start = (num-5)*ALLROATE/num + 1-offAngle, ended = (num-4)*ALLROATE/num-offAngle},
    {start = (num-4)*ALLROATE/num + 1-offAngle, ended = (num-3)*ALLROATE/num-offAngle},
    {start = (num-3)*ALLROATE/num + 1-offAngle, ended = (num-2)*ALLROATE/num-offAngle},
    {start = (num-2)*ALLROATE/num + 1-offAngle, ended = (num-1)*ALLROATE/num-offAngle},
    {start = (num-1)*ALLROATE/num + 1-offAngle, ended = (num-0)*ALLROATE/num-offAngle},
}

local function  isIndexByAngle(curAngel)

    local index = nil

    for k,v in pairs(zhuanpanData) do
         if curAngel >= v.start and curAngel <= v.ended then
            return k 
         end
    end

    return  index

end

local function rotateSprite(time, rotateAngle_, curIndex)

    local img_TurnArrow_1 = cc.uiloader:seekNodeByNameFast(lotteryLayer, "img_TurnArrow_1")
    local action = cc.RotateBy:create(time, rotateAngle_)
   --local easeAction = cc.EaseCubicActionInOut:create(action)
    local easeAction = cc.EaseSineInOut:create(action)
    --CCEaseExponentialOut
    --sprite:runAction(easeAction)
    --local blink = cc.Blink:create(2, 4)

    local action = cc.Sequence:create(easeAction)

    --local moveLight = display.newSprite("Image/Lobby/Lottery/img_MoveLight.png")
    --moveLight:setAnchorPoint(0.5, 0)
    -- --moveLight:setPosition(23, -5)

   -- moveLight:setPosition(img_TurnArrow_1:getPosition())
    --local popBoxNode = cc.uiloader:seekNodeByNameFast(lotteryLayer, "zhuanPan")
    --       moveLight:addTo(popBoxNode, img_TurnArrow_1:getLocalZOrder())
   
    --moveLight:addTo(popBoxNode)

    local img_Light = cc.uiloader:seekNodeByNameFast(lotteryLayer, "img_Light")
    img_Light:hide()
   
    if  aniHandler == nil then

        aniHandler = scheduler.scheduleUpdateGlobal(
        function()

            local rotate = img_TurnArrow_1:getRotation()
            local rot2 =  math.floor(rotate%360)

            local light_index = isIndexByAngle(rot2)
            if light_index ~= nil then

                local jiangpingStr = string.format("jiangping_%d",light_index)
                local jiangping = cc.uiloader:seekNodeByNameFast(lotteryLayer, jiangpingStr)
                local light = cc.uiloader:seekNodeByNameFast(jiangping, "light")
                if light then
                    light:show()
                    
                end

                local fadeOut = cc.FadeOut:create(0.2)
                local action2 = cc.Sequence:create(fadeOut)
                  transition.execute(light, action2,
                 {
                    onComplete = function ()
                        light:hide()
                        light:setOpacity(255)
                        --print("判断是否填写地址的界面")
                    end
                })

            end
           
                --print("img_TurnArrow_1:getRotate = ",rotate)

        end)
    end
    

    transition.execute(img_TurnArrow_1, action,
         {
            onComplete = function ()

                print("curINdex = ", curIndex)

                if aniHandler ~= nil then
                    scheduler.unscheduleGlobal(aniHandler)
                    aniHandler = nil
                end

                for i=1,12 do
                    local jiangpingStr = string.format("jiangping_%d",i)
                    local jiangping = cc.uiloader:seekNodeByNameFast(lotteryLayer, jiangpingStr)
                    local light = cc.uiloader:seekNodeByNameFast(jiangping, "light")

                   local callback = cc.CallFunc:create(function() 
                      light:hide()
                      light:setOpacity(255)
                    end)
                    local delay = cc.DelayTime:create(0.04*(i-1))
                    local blink = cc.Blink:create(0.1, 1)
                    local fadeout = cc.FadeOut:create(0.5)
                    local seaction = cc.Sequence:create(delay,blink,fadeout,callback)
                    
                    light:show()
                    light:setOpacity(255)
                    light:runAction(seaction)
                end

                local animation = cc.Animation:create()
                for i=1,2 do
                    local sprite = display.newSprite("Image/Lobby/Lottery/img_Light" .. i .. ".png")
                    --sprite:setRotation(img_TurnArrow_1:getRotation())
                    sprite:setPosition(img_Light:getPosition())
                    animation:addSpriteFrame(sprite:getSpriteFrame())
                end
                animation:setDelayPerUnit(0.1)
                animation:setLoops(-1)
                local animate = cc.Animate:create(animation)
                img_Light:show()
                img_Light:setRotation((curIndex-1)*(ALLROATE/num))
                local fadeout = cc.FadeOut:create(1)
                -- local action = cc.Sequence:create(animate, fadeout)
                img_Light:runAction(animate)
                local img_Circle = cc.uiloader:seekNodeByNameFast(lotteryLayer, "img_Circle")
                local scale1_star = cc.ScaleTo:create(0.3,1.6)
                local scale2_star = cc.ScaleTo:create(0.3,3.5)
                local scale_star = cc.Sequence:create(scale1_star, scale2_star)
                img_Circle:show()
                local callback = cc.CallFunc:create(
                    function() 
                        img_Light:stopAllActions()
                        img_Light:hide()
                        img_Circle:hide()
                        img_Circle:setOpacity(255)
                        img_Circle:setScale(1.0)

                        UserMessage.LuckyInfoReq(ActID,true)
                        Restart()
                        print("判断是否填写地址的界面")
                        print(info_required)
                        if info_required then
                            print("打开填写地址的界面")
                            NewSelf:lianxiLayer()
                        end

                    end)
                    local spawn = cc.Spawn:create(scale_star,fadeout)
                    local action = cc.Sequence:create(spawn, callback)
                    img_Circle:runAction(action)
            end
        })

end

local function kaishipaoEx()
    local targetIdx = index   --服务器传来的值。
    print("targetIdx = ",targetIdx)
    scheduler.performWithDelayGlobal(
        function(dt)
                local targetData = zhuanpanData[targetIdx]
                local rotateAngle = math.random(targetData.start, targetData.ended)+360 * rotateNum
                print("随机角度是：", rotateAngle)
                --第二次需要重置坐标点
                if lastAngle ~= 0 then
                    rotateSprite(duration, rotateAngle + lastAngle, targetIdx)
                else
                    rotateSprite(duration, rotateAngle, targetIdx)
                end
                lastAngle = 360 - rotateAngle + 360 * rotateNum
        end, 0.1)
end

function LobbyScene:addFrame()
    NewSelf = self
    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_1.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 91, 87))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_1.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_2.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 90, 92))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_2.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_3.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 108, 86))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_3.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_4.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 112, 84))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_4.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_5.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 121, 84))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_5.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_6.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 127, 99))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_6.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_7.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 93, 93))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_7.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_8.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 71, 69))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_8.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_9.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 130, 84))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_9.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/jiangping_10.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 137, 85))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/jiangping_10.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_01.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 519, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_01.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_02.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 545, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_02.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_03.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 551, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_03.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_04.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 583, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_04.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_05.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 352, 75))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_05.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_06.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 352, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_06.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/test_06.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 393, 76))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/test_06.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/BG.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 616, 501))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/BG.png")

    -- texture = cc.Director:getInstance():getTextureCache():addImage("Image/Lobby/Lottery/BG_jlcy.png")
    -- frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 616, 501))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Image/Lobby/Lottery/BG_jlcy.png")
end
--抽奖界面的信息
-- function UserMessage:LuckyListRep(msg)
--     if #msg.lucky_list>0 then
--         --todo
--         for i=1,#msg.lucky_list do
--             if choujiang_ID==msg.lucky_list[i].id then
--                 --todo
--                 local len=#jiangping
--                 table.insert(jiangping,len+1,msg.lucky_list[i].config)
--             end
--         end
--     end
    
    
-- end
function LobbyScene.ShareGameRep(msg)
    print("LobbyScene.ShareGameRep---")
    if lotteryLayer then
        ActID=ActivityConfig:getActID(CONFIG_APP_CHANNEL,1)
        UserMessage.LuckyInfoReq(ActID,true)
    end
end
function LobbyScene:showLottery(id)

    if app.constant.isOpening == true then    
          return
    end
    -- choujiang_ID=id
	lotteryLayer = cc.uiloader:load("Layer/Lobby/Lottery_2.json"):addTo(self)
	lotteryLayer:setTag(1001)
    lotteryLayer:ignoreAnchorPointForPosition(false)
    lotteryLayer:setAnchorPoint(0.5, 0.5)
	lotteryLayer:setPosition(display.width/2,display.height/2)

    lastAngle = 0

    local popBoxNode = cc.uiloader:seekNodeByNameFast(lotteryLayer, "zhuanPan")
    util.setMenuAniEx(popBoxNode)

    local img_Light = cc.uiloader:seekNodeByNameFast(lotteryLayer, "img_Light")
    img_Light:hide()

    local Button_Lshare = cc.uiloader:seekNodeByNameFast(lotteryLayer, "Button_Lshare")
    Button_Lshare:onButtonClicked(handler(self, self.showShare))
    util.BtnScaleFun(Button_Lshare)

    local close = cc.uiloader:seekNodeByNameFast(lotteryLayer, "Close")
    util.BtnScaleFun(close)
    close:onButtonClicked(
        function ()

             if aniHandler ~= nil then
                 scheduler.unscheduleGlobal(aniHandler)
                 aniHandler = nil
             end

             lotteryLayer:removeFromParent()
             lotteryLayer = nil

            --  local scale2_star = cc.ScaleTo:create(0.2,0.1)
            --  transition.execute(popBoxNode, scale2_star,  
            --     {
            --          easing = "sineOut",
            --          onComplete = function()
            --          lotteryLayer:removeFromParent()
            --          lotteryLayer = nil
            --         -- print("lotter = ",lotteryLayer)
                  
            --  end})
            
        end)

    local wanjia_Layout = cc.uiloader:seekNodeByNameFast(lotteryLayer, "wanjia_Layout")
    RootNode = display.newNode()
    :addTo(wanjia_Layout)
    :setPosition(580,0)

    print("showLottery1231")
    print("id:::" ..id)
    ActID=ActivityConfig:getActID(CONFIG_APP_CHANNEL,id)

    UserMessage.LuckyInfoReq(ActID,true)
    print("1231::" ..ActID)
    setAllFrame()
    -- self.scene.lotteryLayer=lotteryLayer
	--抽奖按钮
    local choujiang_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "choujiang_Btn")
    choujiang_Btn:setTouchEnabled(isTouch)
    choujiang_Btn:onButtonPressed(function ()
            choujiang_Btn:scale(0.85)
        end)
    choujiang_Btn:onButtonRelease(function ()
            choujiang_Btn:scale(1.0)
        end)
    choujiang_Btn:onButtonClicked(function ()
            if choujiangBtnstatus then
                --todo
                --请求抽奖信息
                UserMessage.LuckyDrawReq(ActID)
                light_index=1
                
                isTouch=false
                choujiang_Btn:setTouchEnabled(isTouch)
                sound_common.turnPan()
            else
                --kaishipaoEx()
                ErrorLayer.new("未达到抽奖条件！"):addTo(self, 12000)
            end
            
        end)
    --明日再战按钮
    -- local mingrizaizhan_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "mingrizaizhan_Btn")
    -- mingrizaizhan_Btn:onButtonPressed(function ()
    --         mingrizaizhan_Btn:scale(0.85)
    --     end)
    -- mingrizaizhan_Btn:onButtonRelease(function ()
    --         mingrizaizhan_Btn:scale(1.0)
    --     end)
    -- mingrizaizhan_Btn:onButtonClicked(function ()
    --         ErrorLayer.new("您的抽奖次数已用完！"):addTo(self.scene)
    --     end)
    --中奖纪录按钮
    local julu_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "julu_Btn")
    julu_Btn:onButtonPressed(function ()
            julu_Btn:scale(0.85)
        end)
    julu_Btn:onButtonRelease(function ()
            julu_Btn:scale(1.0)
        end)
    julu_Btn:onButtonClicked(function ()
            lotteryLayer:hide()
            UserMessage.LuckyRecordReq(ActID)

            ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
            :addTo(self,nil,2189)

            -- self:jilu_layer()
        end)
    --问号按钮
    local wenhao_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "wenhao_Btn")
    wenhao_Btn:onButtonPressed(function ()
            wenhao_Btn:scale(0.85)
            showxinxi_list()
            
        end)
    wenhao_Btn:onButtonRelease(function ()
            hidexinxi_list()
            wenhao_Btn:scale(1.0)
        end)
    wenhao_Btn:onButtonClicked(function ()
            -- showxinxi_list()
        end)

    --联系人地址按钮回调
    local lianxi_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "lianxi_Btn")
    lianxi_Btn:onButtonPressed(function ()
            lianxi_Btn:scale(0.85)
            
            
        end)
    lianxi_Btn:onButtonRelease(function ()
            
            lianxi_Btn:scale(1.0)
        end)
    lianxi_Btn:onButtonClicked(function ()
            if lotteryLayer ~= nil then
                lotteryLayer:hide()
            end
            self:lianxiLayer()
        end)

    -- for i=1,10 do
    -- 	--商品
    -- 	local jiangpingStr = string.format("jiangping_%d",i)
    -- 	local jiangping = cc.uiloader:seekNodeByNameFast(lotteryLayer, jiangpingStr);
    -- end
    
    -- --测试数据
    -- local ceshi1={{name="张珊1",JP="充电宝1"},{name="张珊2",JP="充电宝2"},{name="张珊3",JP="充电宝3"},{name="张珊4",JP="充电宝4"},}
    -- wanjia_list(ceshi1)
    gundong()

    --测试数据
    -- local ceshi2="活动说明：\n\n1.每天累计玩20局麻将即可参与抽奖。\n2.每人每天只可抽奖1次。\n3.抽奖次数不累计，每天0点清零。\n4.实物类奖励将在7个工作日内发放。"
    
    


end
--点击抽奖按钮的消息
function LobbyScene:LuckyDrawRep(msg)
    -- index = 4
    print("LuckyDrawRep++")
    if msg.result==0 then --  抽奖成功
        --todo
        index = msg.draw.pos
        --抽奖抽到的奖品
        jiangping_test = index

        kaishipaoEx()
        print("抽奖抽到的奖品" ..index)

        UserMessage.LuckyProfileReq() --判断活动是否有小红点

        info_required = msg.draw.info_required
        print("info_required的值2：")
        print(info_required)
        shiShowdizhi()
    else
        hideAllLight()
        Restart()
        ErrorLayer.new("未达成抽奖条件！"):addTo(self.scene)
    end
end
function shiShowdizhi()
    local lianxi_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "lianxi_Btn")
    if info_required then
        --todo
        lianxi_Btn:show()
    else
        lianxi_Btn:hide()
    end
    
end

--转盘效果
-- function kaishipao()
--     hideAllLight()

--     local jiangpingStr = string.format("jiangping_%d",light_index)
--     local jiangping = cc.uiloader:seekNodeByNameFast(lotteryLayer, jiangpingStr);
--     local light = cc.uiloader:seekNodeByNameFast(jiangping, "light");
--     if light then
--         light:show()
--     end
    
--     if light_index<10 then
--         light_index=light_index+1
--     else
--         light_index=1
--     end

--     bushu=bushu+1
--     if bushu==quanshu*10+index then
--         --todo
--         scheduler.unscheduleGlobal(LotterySch)
        

        
--         local blink = cc.Blink:create(2, 4)
        

--         transition.execute(light, blink, {
--                 onComplete = function ()
--                     if light~=nil then
--                         light:stopAllActions()
--                         UserMessage.LuckyInfoReq(ActID,true)

--                         Restart()
--                         print("判断是否填写地址的界面")
--                         print(info_required)
--                         if info_required then
--                             --todo
--                             print("打开填写地址的界面")
--                             NewSelf:lianxiLayer()
--                         end
--                     end
--                 end
--             })

        
--     else
--         scheduler.unscheduleGlobal(LotterySch)

--         if bushu%10==0 then
            
--             time=time+30
--         elseif bushu%4==0 then
            
--             time=time+40
--         end
        
--         LotterySch = scheduler.scheduleGlobal(kaishipao, time/1000.0)
        
--     end
    
-- end
--隐藏所有的发光图片
function hideAllLight()
    for i=1,12 do
        --商品
        local jiangpingStr = string.format("jiangping_%d",i)
        local jiangping = cc.uiloader:seekNodeByNameFast(lotteryLayer, jiangpingStr);
        local light = cc.uiloader:seekNodeByNameFast(jiangping, "light")
        if light then

            light:hide()
            light:stopAllActions()
        end
        
    end
end


--重置所有图片
--通过事先加载的活动配置文件来重置所有图片
function setAllFrame()
    --设置活动的时间
    local Time_test = cc.uiloader:seekNodeByNameFast(lotteryLayer, "Time_test");
    --获取单个的抽奖信息
    print("id:::" ..ActID)
    local ConfigJP = ActivityConfig:getConfigJP(CONFIG_APP_CHANNEL,ActID)
    dump(ConfigJP,"ceshi123::")
    local timeStr=""
    timeStr=timeStr .."活动时间:"
    timeStr=timeStr ..ConfigJP.startTime.month .."月" ..ConfigJP.startTime.day .."日 至 "
    -- timeStr=timeStr ..ConfigJP.startTime.hour ..":" ..ConfigJP.startTime.min .."至"
    -- timeStr=timeStr ..ConfigJP.endTime.year .."年"
    timeStr=timeStr ..ConfigJP.endTime.month .."月" ..ConfigJP.endTime.day .."日"
    -- timeStr=timeStr ..ConfigJP.endTime.hour ..":" ..ConfigJP.endTime.min
   -- Time_test:setString(timeStr)


    local Lottery_BG = cc.uiloader:seekNodeByNameFast(lotteryLayer, "Lottery_BG");

    --Lottery_BG:setTexture(string.format("Platform_Src/Image/ActiviLayer/%s", ConfigJP.backgroud))
    -- Lottery_BG:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("Image/Lobby/Lottery/%s", ConfigJP.backgroud)))
    dump(ConfigJP.rewards, "ConfigJP.rewards = ")
    print("ConfigJP.rewards = ",#ConfigJP.rewards)
    
    for i=1,#ConfigJP.rewards do
        --商品
        local jiangpingStr = string.format("jiangping_%d",i)
        local jiangping = cc.uiloader:seekNodeByNameFast(lotteryLayer, jiangpingStr);
        local jiangLi = cc.uiloader:seekNodeByNameFast(jiangping, "jiangping")
        if jiangLi then
            jiangLi:setTexture(string.format("Image/Lobby/Lottery/%s", ConfigJP.rewards[i].icon))
            -- jiangLi:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("Image/Lobby/Lottery/jiangping_%d.png", ConfigJP.rewards[i].icon)))
        end
        local text = cc.uiloader:seekNodeByNameFast(jiangping, "jieshao")
        text:setString(ConfigJP.rewards[i].name)
        
    end

    print("setAllFrame")
    --设置活动的信息
    xinxi_list()
end





--一局之后重置所有数据
function Restart()
    light_index = 1
    -- bushu = 0
    -- quanshu = math.random(2,4)
    -- time = 10
    index = 1
    local choujiang_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "choujiang_Btn")
    isTouch=true
    choujiang_Btn:setTouchEnabled(isTouch)
end



-------------------------------------------
--玩家获奖信息列表
function wanjia_list(wanjia_list)
    print("wanjia_list")
    dump(wanjia_list,"wanjia_list::")
    list_width=0
    if RootNode then
        --todo
        RootNode:removeFromParent()
        RootNode = nil
    end
    
    local wanjia_Layout = cc.uiloader:seekNodeByNameFast(lotteryLayer, "wanjia_Layout");
    RootNode = display.newNode()
                    :addTo(wanjia_Layout)
                    :setPosition(580,0)
    if wanjia_list and  #wanjia_list>0 then
        for i=1,#wanjia_list do
            print("恭喜玩家")
            local text_01 = cc.ui.UILabel.new({
            text = "恭喜玩家", 
            size = 24, 
            color = cc.c3b(222,172,254)
            })
            :addTo(RootNode)
            :setAnchorPoint(0,0.5)
            :setPosition(list_width,20)
            local size=text_01:getContentSize()
            list_width=list_width+size.width

            local strname="\""
            strname=strname .. util.checkNickName(wanjia_list[i].nickname) .."\""
            local text_02 = cc.ui.UILabel.new({
            text = strname, 
            size = 24, 
            color = cc.c3b(255,247,72)
            })
            :addTo(RootNode)
            :setAnchorPoint(0,0.5)
            :setPosition(list_width+2,20)
            local size=text_02:getContentSize()
            list_width=2+list_width+size.width

            local text_03 = cc.ui.UILabel.new({
            text = ",获得", 
            size = 24, 
            color = cc.c3b(222,172,254)
            })
            :addTo(RootNode)
            :setAnchorPoint(0,0.5)
            :setPosition(list_width+2,20)
            local size=text_03:getContentSize()
            list_width=2+list_width+size.width
            print("输出的奖品：：" ..wanjia_list[i].reward)
            local strJP="\""
            strJP=strJP ..wanjia_list[i].reward .."\""
            local text_04 = cc.ui.UILabel.new({
            text = strJP, 
            size = 24, 
            color = cc.c3b(255,247,72)
            })
            :addTo(RootNode)
            :setAnchorPoint(0,0.5)
            :setPosition(list_width+2,20)
            local size=text_04:getContentSize()
            list_width=2+list_width+size.width+20

            
        end
        
    end
    gundong()
end
--获奖信息滚动控制
function gundong()
   
    
    local action =cc.Sequence:create(
    cc.MoveBy:create(0.1, cc.p(-10,0)),
    cc.CallFunc:create(
            function ()
                if RootNode then
                    --todo
                    local x=RootNode:getPositionX()
                    -- print("总的长度：" ..list_width)
                    if x>580 or x<0-list_width then
                        -- print("当前的x值：" ..x)
                        RootNode:setPosition(580,0)
                    
                    end
                end
            end
        )
    )
    if RootNode then
        --todo
        RootNode:stopAllActions()
        RootNode:runAction(cc.RepeatForever:create(action))
    end
    

    

end
--获奖信息接收函数
-- function wanjia_dispatch(msg)
--     -- wanjiaSch = scheduler.scheduleGlobal(gundong, 0.1)

-- end


-----------------------------------------------------

--点击问号的回调函数
function xinxi_list()
    --获取单个的抽奖信息
    local ConfigJP = ActivityConfig:getConfigJP(CONFIG_APP_CHANNEL,ActID)
    dump(ConfigJP, "xinxi_list::")
    xinxi_Node = display.newNode()
    :hide()
    :addTo(lotteryLayer)
    :setPosition(1085,510)
    local purpose = cc.rect(10, 10, 845-10*2, 501 - 10*2) 
    local horn_bg = display.newScale9Sprite("Image/Lobby/Lottery/xinxi_BG.png", 0, 0, cc.size(845, 501),purpose)
        :setPosition(-10,-10)
        :setAnchorPoint(cc.p(1,1))
        :addTo(xinxi_Node)
    local text_str=""
    for i=1,#ConfigJP.tips do
        text_str=text_str ..ConfigJP.tips[i] .."\n"
    end
    local xinxi_text = cc.ui.UILabel.new({
            text = text_str, 
            size = 15, 
            color = cc.c3b(255,255,255)
            })
            :addTo(xinxi_Node)
            :setAnchorPoint(1,1)
            :setPosition(-50,-64)
    local size=xinxi_text:getContentSize()
    horn_bg:setContentSize(size.width+80,size.height+55)
    -- horn_bg:setScale(size.width/845,size.height/501)
    -- horn_bg:setPreferredSize(size.width,size.height)
    -- xinxi_text:setPosition(0-size.width,0-size.height)
            
end
function showxinxi_list()
    if xinxi_Node then
        --todo
        xinxi_Node:setVisible(true)
    end
end
function hidexinxi_list()
    if xinxi_Node then
        --todo
        xinxi_Node:setVisible(false)
    end
end
-- --活动说明的数据接收函数
-- function xinxi_dispatch()

-- end
--抽奖按钮的相关消息
function LobbyScene:LuckyInfoRep(msg)
    -- print("LuckyInfoRep111")
    -- dump(msg.lucky_list,"hh:::")
    
    info_required = msg.info_required
    print("info_required的值1：")
    print(info_required)
    shiShowdizhi()
    for _,v in pairs(msg.lucky_list) do
        -- dump(v, "qwewq:")

        if v.id==ActID then
            --点击抽奖
            local choujiang_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "choujiang_Btn");
            --明日再来
            --local mingrizaizhan_Btn = cc.uiloader:seekNodeByNameFast(lotteryLayer, "mingrizaizhan_Btn");
            if v.status==1 then
                choujiangBtnstatus=true
                choujiang_Btn:show()
                -- isTouch=true
                choujiang_Btn:setTouchEnabled(true)
                --mingrizaizhan_Btn:hide()
            elseif v.status==2 then
                choujiangBtnstatus=false
                choujiang_Btn:show()
                -- isTouch=false
                choujiang_Btn:setTouchEnabled(true)
                --mingrizaizhan_Btn:hide()
            elseif v.status==4 then
                choujiang_Btn:setTouchEnabled(false)
                --choujiang_Btn:hide()
                --mingrizaizhan_Btn:show()
            end

            --当前玩的局数
            -- local text_02 = cc.uiloader:seekNodeByNameFast(lotteryLayer, "text_02");
            -- local str = ""
            -- str = str ..v.game_cnt .."/" ..v.total_cnt
            -- text_02:setString(str)
            -- text_02:setString("54646546465")

            --抽奖的次数
            local text_04 = cc.uiloader:seekNodeByNameFast(lotteryLayer, "text_04");
            text_04:setString(tostring(v.available_draws))

            print("当前抽奖次数" ..v.available_draws)
            --玩家获奖信息
            -- dump(v.reward_notices, "v.reward_notices::")
            wanjia_list(v.reward_notices)
        end
    end
end

function LobbyScene:LuckyRecordRep(msg)
    local progressLayer = self:getChildByTag(2189)
    if progressLayer then
        ProgressLayer.removeProgressLayer(progressLayer)
    end
    self:jilu_layer(msg.records)
    -- dump(msg.records,"LuckyRecordRep::")
end

--联系方式界面
function LobbyScene:lianxiLayer()
    -- Recipients = self:showSubLayer("Layer/Lobby/Recipients.json", "Image/Lobby/activity_title.png")
    -- Recipients:setTag(1002)
    local Recipients = cc.uiloader:load("Layer/Lobby/Recipients.json"):addTo(self.scene)
    Recipients:setTag(6480)
    -- local popBoxNode = cc.uiloader:seekNodeByNameFast(Recipients, "PopBoxNode")
    -- popBoxNode:setScale(0)
    -- transition.scaleTo(popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})
    
    -- cc.uiloader:seekNodeByNameFast(subLayer, "Title")
    --     :setString(title)

    local title_sprite = cc.uiloader:seekNodeByNameFast(Recipients, "Image_Title")
    local s = display.newSprite("Image/Lobby/Lottery/img_Choujiang.png")
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

    local reback = cc.uiloader:seekNodeByNameFast(Recipients, "close_Btn")
        :onButtonClicked(function ()
            
            Recipients:removeFromParent()
            Recipients = nil
            if lotteryLayer ~= nil then
                lotteryLayer:show()
            end
           -- self.scene.activeLayer:show()

        end)
    util.BtnScaleFun(reback)

    -- local test_tishi = cc.uiloader:seekNodeByNameFast(Recipients, "test_tishi")
    -- local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("Image/Lobby/Lottery/test_%02d.png", jiangping_test))
    -- print("大奖：：" ..jiangping_test)
    -- if frame then
    --     test_tishi:setSpriteFrame(frame)
    -- else
    --     test_tishi:hide()
    -- end

  --  local accountInputPanel = cc.uiloader:seekNodeByNameFast(Recipients, "AccountInputPanel")
--local input = util.createInput(accountInputPanel, { color = cc.c4b(255,0,0, 255),placeHolder = "请输入您的姓名（必填）" })
   local text_layout_01 = cc.uiloader:seekNodeByNameFast(Recipients, "text_layout_01")
    local xinming = util.createInput(text_layout_01, {
                        color = cc.c4b(127,127,125, 255),
                        maxLength = 20,
                        fontSize = 20,
                        size = cc.size(400,30),
                        placeHolder = "请输入您的姓名（必填）"
                    })
    --xinming:setTextColor(cc.c4b(255,0,0, 255))
    -- xinming:setTouchEnabled(true)

    local text_layout_02 = cc.uiloader:seekNodeByNameFast(Recipients, "text_layout_02")
    local shouji = util.createInput(text_layout_02, {
                        color = cc.c4b(127,127,125, 255),
                        maxLength = 20,
                        fontSize = 20,
                        size = cc.size(400,30),
                        mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
                        placeHolder = "请输入您的手机号码（必填）",
                    })
    -- shouji:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    -- shouji:setTouchEnabled(true)

    local text_layout_03 = cc.uiloader:seekNodeByNameFast(Recipients, "text_layout_03")
    local weixin = util.createInput(text_layout_03, {
                        color = cc.c4b(127,127,125, 255),
                        maxLength = 20,
                        fontSize = 20,
                        size = cc.size(400,30),
                        placeHolder = "请输入您的微信号（必填）",
                    })
    -- weixin:setTouchEnabled(true)

    local text_layout_04 = cc.uiloader:seekNodeByNameFast(Recipients, "text_layout_04")

    local dizhi = util.createInput(text_layout_04, {
                        color = cc.c4b(127,127,125, 255),
                        maxLength = 150,
                        fontSize = 18,
                        size = cc.size(420,90),
                        maxLen = 55,
                        -- x = -100,
                        -- y = 120,
                        placeHolder = "请输入地址，方便实物奖励的寄出（可选）",
                    })

    --在线客服
    local Service = cc.uiloader:seekNodeByNameFast(Recipients, "Service");
    Service:onButtonPressed(function ()
            Service:scale(0.85)
        end)
    Service:onButtonRelease(function ()
            Service:scale(1.0)
        end)
    Service:onButtonClicked(function ()
            -- if lotteryLayer then
            --     --todo
            --     lotteryLayer:removeFromParent()
            -- end
            -- uiloader:seekNodeByName()
             if app.constant.isOpening == true then    
                return
             end
            local activeLayer = self:showSubLayer("Layer/Lobby/ServiceLayer.json", "Image/Lobby/service_title.png")


            local Text_2 = cc.uiloader:seekNodeByNameFast(activeLayer, "Text_2")
            local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
            Text_2:setString(platConfig.serviceLayer_Text_2)

            local Text_1 = cc.uiloader:seekNodeByNameFast(activeLayer, "Text_1")
            Text_1:setString(platConfig.noticeLayer_Text_1)


            local btn_service = cc.uiloader:seekNodeByNameFast(activeLayer, "Btn_Service")
            btn_service:onButtonClicked(handler(self, self.showChatMenu))
        end)

    --提交按钮
    local TiJiao_Btn = cc.uiloader:seekNodeByNameFast(Recipients, "TiJiao_Btn");
    TiJiao_Btn:onButtonPressed(function ()
            TiJiao_Btn:scale(0.85)
        end)
    TiJiao_Btn:onButtonRelease(function ()
            TiJiao_Btn:scale(1.0)
        end)
    TiJiao_Btn:onButtonClicked(function ()
            if xinming:getString()~="" and shouji:getString()~="" and #shouji:getString()==11 and weixin:getString()~="" then
                --todo
                local info={}
                info.uid = Player.uid
                info.name = xinming:getString()
                info.mobile = shouji:getString()
                info.weixin = weixin:getString()
                info.address = dizhi:getString()
                UserMessage.AddInfoReq(info)

            else
                if xinming:getString()=="" then
                    --todo
                    ErrorLayer.new("请填写好您的姓名！"):addTo(self.scene)
                elseif shouji:getString()=="" or #shouji:getString()~=11 then
                    ErrorLayer.new("请填写好您的手机号码！"):addTo(self.scene)
                elseif weixin:getString()=="" then
                    ErrorLayer.new("请填写好您的微信号！"):addTo(self.scene)
                end
            end
            
        end)
end
--发送地址信息后收到的信息
function LobbyScene:AddInfoRep(msg)
    if msg.result == 0 then
        ErrorLayer.new("填写地址成功！"):addTo(self.scene)
        if self.scene:getChildByTag(6480) then
            self.scene:removeChildByTag(6480)
            --self.scene.activeLayer:show()
            info_required = true
            shiShowdizhi()
        end
    elseif msg.result == 1 then
        --todo
        ErrorLayer.new("您曾填写过地址！"):addTo(self.scene)
    elseif msg.result == 2 then
        --todo
        ErrorLayer.new("缺少重要信息未填！"):addTo(self.scene)
    end
end

function LobbyScene:jilu_layer(records)


    local jilu_layer = cc.uiloader:load("Layer/Lobby/RecordLayer.json"):addTo(self.scene)
   -- jilu_layer:setPosition(342,60)

    local title_sprite = cc.uiloader:seekNodeByNameFast(jilu_layer, "Image_Title")
    local s = display.newSprite("Image/Lobby/Lottery/img_Choujiang.png")
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)
    --返回按钮
    local close_Btn = cc.uiloader:seekNodeByNameFast(jilu_layer, "close_Btn");
    close_Btn:onButtonPressed(function ()
            close_Btn:scale(0.85)
        end)
    close_Btn:onButtonRelease(function ()
            close_Btn:scale(1.0)
        end)
    close_Btn:onButtonClicked(function ()
            jilu_layer:removeFromParent()
            lotteryLayer:show()
        end)

    --奖品列表list
    -- local ListView = cc.uiloader:seekNodeByNameFast(jilu_layer, "ListView");
    -- ListView:setPosition(-280,-170)

    local menu = cc.ui.UIListView.new {
        --viewRect = cc.rect(20, 430, 940, 350),
        viewRect = cc.rect(171, 145, 940, 380),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :onScroll(function(event)
                if "moved" == event.name then
                    
                elseif "ended" == event.name then
                    
                end
            end)
   -- :setPosition(100,-250)
    
    :addTo(jilu_layer)
    

    for i=#records,1,-1 do
        
        -- :addTo(listItem)

        local item = menu:newItem()
        item:setItemSize(941, 35)
        menu:addItem(item)

        --子项的背景
        local itemBG = display.newSprite("Image/Lobby/Lottery/item_BG.png")
        item:addContent(itemBG)

        local item_time1 =  cc.ui.UILabel.new({
            text = records[i].time, 
            size = 20, 
            color = cc.c3b(0,0,0)
            })
        :setAnchorPoint(0,0.5)
        :setPosition(50+200,15)
        :addTo(itemBG)

        local item_time3 =  cc.ui.UILabel.new({
            text = "获得", 
            size = 20, 
            color = cc.c3b(0,0,0)
            })
        :setAnchorPoint(0,0.5)
        :setPosition(300+200,15)
        :addTo(itemBG)

        local item_time4 =  cc.ui.UILabel.new({
            text = records[i].reward, 
            size = 20, 
            color = cc.c3b(0,0,0)
            })
        :setAnchorPoint(0,0.5)
        :setPosition(350+200,15)
        :addTo(itemBG)

        -- ListView:addItem(listItem)
    end
    menu:reload()

    --在线客服
    local Service = cc.uiloader:seekNodeByNameFast(jilu_layer, "Service");
    Service:onButtonPressed(function ()
            Service:scale(0.85)
        end)
    Service:onButtonRelease(function ()
            Service:scale(1.0)
        end)
    Service:onButtonClicked(function ()

            if app.constant.isOpening == true then    
                return
            end

            local activeLayer = self:showSubLayer("Layer/Lobby/ServiceLayer.json", "Image/Lobby/service_title.png")
            local Text_2 = cc.uiloader:seekNodeByNameFast(activeLayer, "Text_2")
            local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
            Text_2:setString(platConfig.serviceLayer_Text_2)

            local Text_1 = cc.uiloader:seekNodeByNameFast(activeLayer, "Text_1")
            Text_1:setString(platConfig.noticeLayer_Text_1)

            local btn_service = cc.uiloader:seekNodeByNameFast(activeLayer, "Btn_Service")
            btn_service:onButtonClicked(handler(self, self.showChatMenu))
            
        end)
end

return LobbyScene
