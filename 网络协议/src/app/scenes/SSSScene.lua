local SSSScene = class("SSSScene", function()
    require("app.Games.SSS.privateRoom")
    require("app.Games.SSS.players")
    require("app.Games.SSS.cards")
    require("app.Games.SSS.match")
    require("app.Games.SSS.SSS_uiRule")
    require("app.Games.SSS.SSS_uiPrompt")
    return display.newScene("SSSScene")
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local message = require("app.net.Message")
local msgWorker = require("app.net.MsgWorker")
local errorLayer = require("app.layers.ErrorLayer")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local ErrorLayer = require("app.layers.ErrorLayer")
local sound = require("app.Games.SSS.sound_sss")
local sound_common = require("app.Common.sound_common")
local logic = require ("app.Games.SSS.lg_13shui")
local util = require("app.Common.util")
local Share = require("app.User.Share")
local MathBit = require("app.Common.MathBit")
local ProgressLayer = require("app.layers.ProgressLayer")
local PRMessage = require("app.net.PRMessage")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local MatchMessage = require("app.net.MatchMessage")
local msgMgr = require("app.room.msgMgr")


local Account = app.userdata.Account

local gameState                         --0: 房卡游戏未开始； 1: 房卡游戏已开始
local seatCount                         -- 椅子数
local seatIndex                         --个人椅子号
local roomSession                       --房间Session
local tableSession                      --桌子Session
local watchingGame                      --是否旁观
local basechip                          --底分
local gameRoomId                        --房间ID
local gameround                         --最大局数

local table_code                        --私人房间号

local is_card_sp = false                --是否报道
local btn_sp_show = false               --是否有特殊牌型
local valid_seats = {}                  --有效的椅子号

local isScene = false                   --是否恢复场景

--比赛
local _matchSession                     --比赛房间Session
local _matchid                          --比赛ID
local _isMatchInit                      --比赛是否初始化
local _tempSingnCount                   --比赛报名人数

--ui
local btnSign                           --报道按钮
local btnConfirm                        --完成按钮
local btnStart                          --开始按钮
local ResultLayer                       --结算
local SeeLayer                          --看牌
local centerBG                          --选牌型


local progressTag = 10000

--表情变量
local emoBgLayer
local lastPosX
local lastPosY
local cureHead
local uidText

--牌型图片
local type_img = {"type_danzhang.png","type_duizi.png", "type_liadui.png",
                  "type_santiao.png","type_shunzi.png","type_tonghua.png",
                  "type_hulu.png","type_zhadan.png","type_tonghuashun.png",
                  "type_wuzha.png"}

--[[ --
    * 隐藏元素
--]]
local function hideNodes(ui_scene)
    cc.uiloader:seekNodeByNameFast(ui_scene,"Button_Start"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"Button_Sign"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"Button_Confirm"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"Text_Record"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"btn_game_continue"):hide()

    cc.uiloader:seekNodeByNameFast(ui_scene,"mapaiImage"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"mapaiText"):hide()

    cc.uiloader:seekNodeByNameFast(ui_scene,"Room_Info"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"Room_Info_2"):hide()

    -- cc.uiloader:seekNodeByNameFast(ui_scene,"nd_drop_content"):hide()

    --隐藏等待其他玩家
    cc.uiloader:seekNodeByNameFast(ui_scene,"Image_Ready_0"):hide()
    cc.uiloader:seekNodeByNameFast(cc.uiloader:seekNodeByNameFast(ui_scene,"User_1"):hide(),"Image_Ready"):hide()
    cc.uiloader:seekNodeByNameFast(cc.uiloader:seekNodeByNameFast(ui_scene,"User_2"):hide(),"Image_Ready"):hide()
    cc.uiloader:seekNodeByNameFast(cc.uiloader:seekNodeByNameFast(ui_scene,"User_3"):hide(),"Image_Ready"):hide()
    cc.uiloader:seekNodeByNameFast(cc.uiloader:seekNodeByNameFast(ui_scene,"User_4"):hide(),"Image_Ready"):hide()
    cc.uiloader:seekNodeByNameFast(cc.uiloader:seekNodeByNameFast(ui_scene,"User_5"):hide(),"Image_Ready"):hide()

    cc.uiloader:seekNodeByNameFast(ui_scene,"nd_drop_bar"):setLocalZOrder(201)

    centerBG:hide()
    centerBG:setLocalZOrder(210)

    ResultLayer:hide()
    ResultLayer:setLocalZOrder(1000)
    SeeLayer:hide()
    SeeLayer:setLocalZOrder(1000)

    cc.uiloader:seekNodeByNameFast(ui_scene,"PrivateRoom"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"PRoomRecord"):hide()
    cc.uiloader:seekNodeByNameFast(ui_scene,"PRoomRecord"):setLocalZOrder(1001)

    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(ResultLayer,"ExitBtn"))
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(ResultLayer,"SureNextBtn"))
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(SeeLayer,"btn_confirm"))
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(SeeLayer,"btn_show_result"))

    cc.uiloader:seekNodeByNameFast(ui_scene, "tx_add_card"):hide()
end

function SSSScene:ctor()
    print("SSSScene:ctor")
    --总输赢
    self.totalRecord = 0
    --苍蝇牌值
    self.game_fly_card = 0
    --牌纹理
    self:setCardsTexture()

    --初始化音效
    sound.init()

    --牌型资源加载---
    local type_img_texture_rect = {
        cc.rect(0, 0, 69, 36),
        cc.rect(0, 0, 71, 35),
        cc.rect(0, 0, 70, 36),
        cc.rect(0, 0, 71, 37),
        cc.rect(0, 0, 72, 36),
        cc.rect(0, 0, 73, 36),
        cc.rect(0, 0, 84, 44),
        cc.rect(0, 0, 84, 44),
        cc.rect(0, 0, 123, 44),
        cc.rect(0, 0, 121, 43),
    }
    --加载牌型资源
    for i=1,#type_img do
        local  res  = string.format("Image/SSS/type_img/%s", type_img[i])
        local texture = cc.Director:getInstance():getTextureCache():addImage(res)
        local frame = cc.SpriteFrame:createWithTexture(texture, type_img_texture_rect[i])
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, type_img[i])
    end
    ---------------------------------------

    --创建场景界面
    self.scene = cc.uiloader:load("Scene/SSSScene.json"):addTo(self)

    --设置语音聊天
    util.SetVoiceBtn(self,self.scene)

    util.IsShowVoiceBtn(false, self.scene)

    --下拉栏---
    local nd_drop_bar = cc.uiloader:seekNodeByNameFast(self.scene,"nd_drop_bar")
    cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_exit_match"):hide()

    local nd_drop_content = cc.uiloader:seekNodeByNameFast(self.scene,"nd_drop_content")
    nd_drop_content.showState = false


    local btn_Arrow
    local sp_drop_bg
    local function drop_move_action( event )
        sound_common.confirm()
        
        nd_drop_content.showState = not nd_drop_content.showState

        if nd_drop_content.showState then
            sp_drop_bg:show()
            nd_drop_content:moveBy(0.2,-270,0)
        else
            sp_drop_bg:hide()
            nd_drop_content:moveBy(0.2,270,0)
        end

        if nd_drop_content.showState then
            btn_Arrow:setButtonImage(cc.ui.UIPushButton.NORMAL,"Image/SSS/PrivateRoom/button_ccup_norma.png",true)
            btn_Arrow:setButtonImage(cc.ui.UIPushButton.PRESSED,"Image/SSS/PrivateRoom/button_ccup_norma.png",true)
        else
            btn_Arrow:setButtonImage(cc.ui.UIPushButton.NORMAL,"Image/SSS/PrivateRoom/button_ccdown_norma.png",true)
            btn_Arrow:setButtonImage(cc.ui.UIPushButton.PRESSED,"Image/SSS/PrivateRoom/button_ccdown_norma.png",true)
        end
    end


    --下拉栏下拉按钮
    btn_Arrow = util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_Arrow"))
        :onButtonClicked(drop_move_action)

    --下拉栏背景
    sp_drop_bg = cc.uiloader:seekNodeByNameFast(nd_drop_bar,"sp_drop_bg"):hide()
    sp_drop_bg:addNodeEventListener(cc.NODE_TOUCH_EVENT,drop_move_action)

    --下拉栏声音按钮
    local btn_sound_bar = util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_sound_bar"))
        :onButtonClicked(
            function (event)
                sound_common.confirm()

                if app.constant.voiceOn then
                    app.constant.voiceOn = false

                    event.target:setButtonImage(cc.ui.UIPushButton.NORMAL,"Image/SSS/PrivateRoom/btn_sound_off.png",true)
                    event.target:setButtonImage(cc.ui.UIPushButton.PRESSED,"Image/SSS/PrivateRoom/btn_sound_off.png",true)
                else
                    event.target:setButtonImage(cc.ui.UIPushButton.NORMAL,"Image/SSS/PrivateRoom/btn_sound_on.png",true)
                    event.target:setButtonImage(cc.ui.UIPushButton.PRESSED,"Image/SSS/PrivateRoom/btn_sound_on.png",true)

                    app.constant.voiceOn = true
                end

                util.GameStateSave("voiceOn",app.constant.voiceOn)
                sound.setState(app.constant.voiceOn)
                sound_common.setVoiceState(app.constant.voiceOn)
            end
        )
    if app.constant.voiceOn then
        btn_sound_bar:setButtonImage(cc.ui.UIPushButton.NORMAL,"Image/SSS/PrivateRoom/btn_sound_on.png",true)
        btn_sound_bar:setButtonImage(cc.ui.UIPushButton.PRESSED,"Image/SSS/PrivateRoom/btn_sound_on.png",true)
    else
        btn_sound_bar:setButtonImage(cc.ui.UIPushButton.NORMAL,"Image/SSS/PrivateRoom/btn_sound_off.png",true)
        btn_sound_bar:setButtonImage(cc.ui.UIPushButton.PRESSED,"Image/SSS/PrivateRoom/btn_sound_off.png",true)
    end
    sound.setState(app.constant.voiceOn)


    local function onExitScene()
        sound_common.confirm()
        self:onRestart()
        self:onLeave()
    end

    --下拉栏退出按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_exit"))
        :onButtonClicked(function ()
            self:showPromptLayer("确定要离开游戏？", onExitScene)
        end)

    --下拉栏退出比赛按钮
    -- util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_exit_match"))
    --     :onButtonClicked(onExitLayer)

    local function onRoomDissolutionCallback()
        message.sendMessage("game.DismissGameReq", {
            session = roomSession,
            privateid = table_code,
            seat = seatIndex,
        })
    end

    --下拉栏解散按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_dissolution_bar"))
        :onButtonClicked(
            function(event)
                self:showPromptLayer("确定要解散房间？", onRoomDissolutionCallback)
            end
        )


    -- 游戏规则按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(nd_drop_bar, "btn_ruleBtn"))
        :onButtonClicked(
            function (event)
                self:showGameRule()
            end
        )

    ----------------------------

    --继续游戏按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(self.scene, "btn_game_continue"))
        :onButtonClicked(function (event)
            sound_common.confirm()
            self:onStart()
        end)
        :setLocalZOrder(200)


    --摆牌界面
    centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")

    --上道
    cc.uiloader:seekNodeByNameFast(centerBG, "Button_1")
        :onButtonClicked(function (event)
            sound.deal()
            self:onCenterBtnClicked(1)
        end)

    --中道
    cc.uiloader:seekNodeByNameFast(centerBG, "Button_2")
        :onButtonClicked(function (event)
            sound.deal()
            self:onCenterBtnClicked(2)
        end)

    --下道
    cc.uiloader:seekNodeByNameFast(centerBG, "Button_3")
        :onButtonClicked(function (event)
            sound.deal()
            self:onCenterBtnClicked(3)
        end)

    --牌的选择状态按钮 上道
    cc.uiloader:seekNodeByNameFast(centerBG, "ok_btn_1")
        :onButtonClicked(function (event)
            self:onCenterBtnClicked(1)
        end)
        :setButtonEnabled(false)

    --牌的选择状态按钮 中道
    cc.uiloader:seekNodeByNameFast(centerBG, "ok_btn_2")
        :onButtonClicked(function (event)
            self:onCenterBtnClicked(2)
        end)
        :setButtonEnabled(false)

    --牌的选择状态按钮 下道
    cc.uiloader:seekNodeByNameFast(centerBG, "ok_btn_3")
        :onButtonClicked(function (event)
            self:onCenterBtnClicked(3)
        end)
        :setButtonEnabled(false)

    if Account.tags.weixin_login_tag ~= "1" then
        local btnStart = cc.uiloader:seekNodeByNameFast(self.scene,"Button_Start")
        btnStart:pos(640,184.25)
    end

    --结算界面
    ResultLayer = cc.uiloader:seekNodeByNameFast(self.scene, "ResultLayer")

    --看牌界面
    SeeLayer = cc.uiloader:seekNodeByNameFast(self.scene, "SeeLayer")

    --继续游戏回调方法
    local function onContinueGameCallback( event )
        sound_common.confirm()

        self:onRestart()
        self:onStart()

        -- ResultLayer:hide()
        -- SeeLayer:hide()
    end

    --结算界面 下一局确定按钮
    cc.uiloader:seekNodeByNameFast(ResultLayer, "SureNextBtn")
        :onButtonClicked(onContinueGameCallback)

    --看牌界面 下一局确定按钮
    cc.uiloader:seekNodeByNameFast(SeeLayer, "btn_confirm")
        :onButtonClicked(onContinueGameCallback)

    --结算界面 显示桌面按钮
    cc.uiloader:seekNodeByNameFast(ResultLayer, "ExitBtn")
        :onButtonClicked(function (event)
            sound_common.confirm()
            ResultLayer:hide()
            SeeLayer:show()
        end)

    --看牌界面 显示结算按钮
    cc.uiloader:seekNodeByNameFast(SeeLayer, "btn_show_result")
        :onButtonClicked(function (event)
            sound_common.confirm()
            ResultLayer:show()
            SeeLayer:hide()
        end)

    --准备按钮
    btnStart = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Start")
        :onButtonClicked(function (event)
            sound_common.confirm()
            self:onStart()
            btnStart:hide()
            util.SetRequestBtnHide()
        end)
        --:show()
    btnStart:setLocalZOrder(200)
    util.BtnScaleFun(btnStart)

    --完成按钮
    btnConfirm = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Confirm")
        :setLocalZOrder(450)
        :onButtonClicked(function (event)
            sound.confirm()
            print("Button_Confirm--")
            local cards = self:getCenterCards()
            if is_card_sp or self:checkCenterCard(cards) then
                print("Button_Confirm1111--")
                message.sendMessage("_13Shui.OpenCardReq", {session=tableSession,seatid = seatIndex,
                    is_special_cardtype = is_card_sp,order_card_cnts = {3,5,5},cardvalues = cards})
                -- ErrorLayer.new("摆牌失败:没有出现倒水!"):addTo(self.scene,500)
            else
                ErrorLayer.new("摆牌失败:出现倒水!"):addTo(self.scene,500)
            end
        end)

    --报道按钮
    btnSign = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Sign")
        :setLocalZOrder(450)
        :onButtonClicked(function (event)
            sound.btn_type_2()
            self:onSignClicked()

            if is_card_sp then
                local cards = self:getCenterCards()
                message.sendMessage("_13Shui.OpenCardReq", {session=tableSession,seatid = seatIndex,
                    is_special_cardtype = is_card_sp,order_card_cnts = {3,5,5},cardvalues = cards})
            end

        end)


    --触摸层
    local touchLayer = display.newLayer()
    self.scene:addChild(touchLayer,211)
    touchLayer:setTouchSwallowEnabled(false)
    touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:_touch(event)
    end)


    --注册监听
    msgWorker.init("_13Shui", handler(self, self.dispatchMessage))
    msgWorker.sleep()

    self.isOk = false
    seatCount = 4

    hideNodes(self.scene)

     --截屏分享
  --  Share.SetGameShareBtn(true, self.scene, 900, 700)
   --添加后台，前台兼听函数
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT",
                             handler(self, self.onEnterBackground))
    self.customListenerBg = customListenerBg
    eventDispatcher:addEventListenerWithFixedPriority(self.customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT",
                             handler(self, self.onEnterForeground))
    self.customListenerFg = customListenerFg
    eventDispatcher:addEventListenerWithFixedPriority(self.customListenerFg, 1)
end

function SSSScene:onEnter()
    print("onEnter")

    btnSign = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Sign")
    btnConfirm = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Confirm")
    btnStart = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Start")

    ResultLayer = cc.uiloader:seekNodeByNameFast(self.scene, "ResultLayer")
    SeeLayer = cc.uiloader:seekNodeByNameFast(self.scene, "SeeLayer")
    centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")

    --表情相关

    local rect = cc.rect(0, 0, 188, 188)
    if emoBgLayer == nil then
        emoBgLayer = display.newSprite("Image/PrivateRoom/img_EmoBg.png")
        :hide()
        :addTo(self)
        :setTouchEnabled(true)
    end

    if cureHead == nil then
        cureHead = display.newSprite()
        :pos(55,206)
        :show()
        :addTo(emoBgLayer)
        :scale(0.42)
    end

    if uidText == nil then
        uidText = cc.ui.UILabel.new({
                color = cc.c3b(245,222,183),
                size = 30,
                text = "ID：",
            })
        :addTo(emoBgLayer)
        :setAnchorPoint(cc.p(0, 0.5))
        :setPosition(55+46,206)
    end

    self.eHeadInfo = {[1] = {}, [2] = {}, [3] = {}, [4] = {}}
    local Image_1 = cc.uiloader:seekNodeByNameFast(self.scene, "Image_1")
    if Image_1 ~= nil then
        Image_1:setTouchEnabled(true)
        Image_1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
            if event.name == "began" then
                if emoBgLayer ~= nil then
                    emoBgLayer:hide()
                end
                return true
            end
        end)
    end

    local function onGitEmo(event)

        print("button.index = ",event.target.index)

        local visible = emoBgLayer:isVisible()
        local ui_node = cc.uiloader:seekNodeByNameFast(self.scene, "User_" .. event.target.index)
        local pos_x_offset = 45
        local pos_y_offset = 22
        local index = event.target.index
        local direct = "left"

        if index == 2  then
            pos_x_offset = -55-365
            pos_y_offset = 0
            direct = "right"
        elseif index == 3 then
            pos_x_offset = -55-365
            pos_y_offset = -45
            direct = "top"
        else
            pos_x_offset = 55
            pos_y_offset = 0
            direct = "left"
        end

        emoBgLayer:setPosition(cc.p(ui_node:getPositionX()+pos_x_offset,ui_node:getPositionY() + pos_y_offset))
        local curPosY = emoBgLayer:getPositionY()
        local curPosX = emoBgLayer:getPositionX()
        if curPosX == lastPosX and curPosY == lastPosY then
            emoBgLayer:setVisible(not visible)
        else
            emoBgLayer:setVisible(true)
        end
        emoBgLayer:setAnchorPoint(cc.p(0,0.5))
        lastPosX = emoBgLayer:getPositionX()
        lastPosY = emoBgLayer:getPositionY()
        util.showEmotionsLayer(self, emoBgLayer, direct)
        if emoBgLayer:isVisible() then
            local imageid = self.eHeadInfo[index].imageid
            local image = self.eHeadInfo[index].image
            local uid = self.eHeadInfo[index].uid

            local frame_head = cc.SpriteFrame:create(image, rect)
            cureHead:setSpriteFrame(frame_head)

            print("imageid = ", imageid)
            print("image = ", image)
            print("uid = ", uid)
            local uidStr = "ID：" .. uid
            uidText:setString(uidStr)

            if index == 2 then
                util.setImageNodeHide(emoBgLayer, 101)
                util.setImageNodeHide(emoBgLayer, 103)
                util.setHeadImage(emoBgLayer, imageid, cureHead, image, 102)
            elseif index == 3 then
                util.setImageNodeHide(emoBgLayer, 101)
                util.setImageNodeHide(emoBgLayer, 102)
                util.setHeadImage(emoBgLayer, imageid, cureHead, image, 103)
            elseif index == 4 then
                util.setImageNodeHide(emoBgLayer, 102)
                util.setImageNodeHide(emoBgLayer, 103)
                util.setHeadImage(emoBgLayer, imageid, cureHead, image, 101)
            end
        end

    end

    --表情按钮
    for i=2,4 do
        local ui_node = cc.uiloader:seekNodeByNameFast(self.scene, "User_" .. i)
        if ui_node then
             local btn_gifEmo = cc.uiloader:seekNodeByNameFast(ui_node, "btn_gifEmo")
                :onButtonClicked(onGitEmo)
                btn_gifEmo.index = i
              util.BtnScaleFun(btn_gifEmo)
        end
    end

    --重置表情变量
    util.reSetEmotion()

    msgWorker.wakeup()
end

function SSSScene:setEmoBtnTouch(isTouch)

    for i=2,4 do
        local ui_node = cc.uiloader:seekNodeByNameFast(self.scene, "User_" .. i)
        if ui_node then
             local btn_gifEmo = cc.uiloader:seekNodeByNameFast(ui_node, "btn_gifEmo")
             btn_gifEmo:setTouchEnabled(isTouch)
        end
    end
end

function SSSScene:onEnterTransitionFinish()
      print("SSSScene:onEnterTransitionFinish---")
      scheduler.performWithDelayGlobal(
      function ()
          --登录好友聊天系统
          if app.constant.isLoginChat == false and loginFchatHandler == nil then
             loginYvSys()
          end
      end, 1.0)
end

function SSSScene:onExitTransitionStart()

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()

    if self.customListenerBg ~= nil then
        eventDispatcher:removeEventListener(self.customListenerBg)
    end

    if self.customListenerFg ~= nil then
        eventDispatcher:removeEventListener(self.customListenerFg)
    end

    self:clearScene()
    self:stopAllActions()
    sound_common.stop_bg()
end

--[[ --
    * 准备游戏
--]]
function SSSScene:onStart()
    if not watchingGame then
        print("发送准备请求")
        message.sendMessage("game.ReadyReq", {
            session = roomSession
        })
    end
end

--[[ --
    * 离开游戏
--]]
function SSSScene:onLeave()
    if table_code then
        message.dispatchPrivateRoom("room.LeaveGame", {})
        msgMgr:clearProvateRoomInfo()
    elseif _matchid then

        --关闭语音频道
        util.CloseChannel()
        app.constant.enterGameUInfo = {}

        MatchMessage.LeaveMatchReq(_matchSession)
        msgMgr:resetMatch()
    else
        message.dispatchGame("room.LeaveGame", {})
    end

end

--[[ --
    * 重新准备状态
--]]
function SSSScene:onRestart()
    self:restart()
    print("SSSScene:onRestart()")

    if tableSession == 0 or seatIndex == 0 then
        errorLayer.new(app.lang.table_gold_lack, nil, nil, function()
            self:onLeave()
        end):addTo(self)
        return
    end
    --message.sendMessage("_13Shui.Ready", {session=tableSession})
end

--[[ --
    * 显示完成按钮
--]]
function SSSScene:showBtnConfirm()
    btnConfirm:show()
end

--[[ --
    * 隐藏完成按钮 And 取消按钮
--]]
function SSSScene:hideBtnConfirm()
    btnConfirm:hide()
end

--[[ --
    * 清理倒计时
--]]
function SSSScene:clearTime()
    if self.handle_lefttime then
        scheduler.unscheduleGlobal(self.handle_lefttime)
        self.handle_lefttime = nil
    end
end

--[[ --
    * 获取本地椅子号
--]]
function SSSScene:getViewSeat(realSeat)
    return (realSeat + seatCount - seatIndex) % seatCount + 1
end

--[[ --
    * 获取桌子椅子号
--]]
function SSSScene:getRealSeat(viewSeat)
    if viewSeat > seatCount then
        return viewSeat
    end

    return (viewSeat + seatIndex - 2) % seatCount + 1
end

--[[ --
    * 获取游戏房间ID
--]]
function SSSScene:getGameRoomId()
    return gameRoomId
end

--[[ --
    * 是否参与游戏
--]]
function SSSScene:isValidSeat(realSeat)
    for i = 1,#valid_seats do
        if valid_seats[realSeat] then
            return true
        end
    end
    return false
end

--[[ --
    * 设置签署
--]]
function SSSScene:setSigned(signed)
    is_card_sp = signed
end

--[[ --
    * 发牌结束
--]]
function SSSScene:onSendCardEnd()
    print("------------SSSScene:onSendCardEnd------------------","发牌结束")
    --显示报道按钮
    -- btn_sp_show = true
    btnSign:setVisible(btn_sp_show)

    --配牌中提示显示
    for i=1,4 do
        local seat = self:getRealSeat(i)
        if self:isValidSeat(seat) then
            self:setGameState(seat,1)
            seat = self:getViewSeat(seat)
            self:setPeipai(seat,true)
        end
    end
end

--[[ --
    * 更新总战绩
--]]
function SSSScene:updateRecordInfo(record,flag)
    if flag then
        self.totalRecord = record or 0
        cc.uiloader:seekNodeByNameFast(self.scene, "Text_Record"):show()
    else
        self.totalRecord = self.totalRecord + record
    end

    cc.uiloader:seekNodeByNameFast(self.scene, "Text_Record"):setString("总战绩：" .. tostring(self.totalRecord).."道")
end
--[[ --
    * 设置房间号
--]]
function SSSScene:setRoomCode()
    local Room_Info = cc.uiloader:seekNodeByNameFast(self.scene,"Room_Info")
    cc.uiloader:seekNodeByNameFast(Room_Info, "tx_id"):setString(tostring(table_code))
end

--[[ --
    * 消息派发
--]]
function SSSScene:dispatchMessage(name, msg)
    print("SSSScene msg name:" .. name)
    if name == "room.InitMatch" then                --比赛房初始化
        _matchSession = msg.session
        _matchid = msg.matchid
        self._matchid = msg.matchid
        seatCount = msg.max_player
        _isMatchInit = true

        self:showMatch()
    elseif name == "room.SignupCountNtf" then       --比赛计数
        print("SSS_刷新参赛人数")
        dump(msg,"SSS_刷新参赛人数")

        if msg.session == _matchSession then
            self:updateSingup(msg.count)
            _tempSingnCount = msg.count
        end
    elseif name == "room.MatchStatustNtf" then      --比赛状态
        print("SSS_刷新比赛状态",_matchid)
        dump(msg,"SSS_刷新比赛状态")

        if msg.session == _matchSession then
            if msg.status == 1 then                 --比赛未开始
                if _isMatchInit then
                    self:showLeftTime(_matchid, _tempSingnCount)
                end
            elseif msg.status == 2 then             --比赛开始
                self:hideLeftTime()
                self:setShowMatchTip(true, "比赛开始！")
                self:setMatchScoreShowState(true)
            elseif msg.status == 4 then             --人数不够，取消比赛
                self:hideLeftTime()
                self:setShowCancel(true)
            elseif msg.status == 8 then             --比赛进行中
                self:setMatchScoreShowState(true)
            elseif msg.status == 16 then            --比赛已结束
            end
        end
    elseif name == "room.MatchInfoNtf" then         --比赛信息
        print("SSS_刷新比赛信息")
        dump(msg,"SSS_刷新比赛信息")

        if msg.session == _matchSession then
            self:showState(msg.status,msg.rank,msg.gold,msg.rewardtitle,msg.rewardtype)
        end
    elseif name == "room.MatchRankNtf" then         --比赛排名
        print("SSS_刷新比赛排名")
        dump(msg,"SSS_刷新比赛排名")

        if msg.session == _matchSession then
            self:updateRank(msg.rank, msg.total)
        end
    elseif name == "room.MatchPromotionNtf" then    --比赛提升
        print("SSS_刷新比赛提升")
        dump(msg,"SSS_刷新比赛提升")
    elseif name == "room.LeaveMatchRep" then        --比赛离开房间
        print("离开比赛房间")
    elseif name == "room.InitGameScenes" then       --初始化大厅房间
        seatIndex = msg.seat
        tableSession = msg.session
        self.tableSession = tableSession
        watchingGame = msg.watching
        -- if not watchingGame then
        --     message.sendMessage("_13Shui.Ready", {session=tableSession})
        -- end
        basechip = 0
        gameRoomId = msg.roomid
    elseif name == "room.EnterGame" then    --玩家进入
        print(msg.seat .."号玩家进入")
        local viptype = 0
        --打开语音按钮
        util.IsShowVoiceBtn(true, self.scene)
        if msg.player.viptype ~= nil then
            viptype = msg.player.viptype
        end
        print("seatCount = ",seatCount)
        print("enter room :" .. tostring(self:getViewSeat(msg.seat)))
        print("seat:" .. msg.seat .. ",viptype:" .. tostring(msg.player.viptype))
        print("viptype2:" .. tostring(viptype))
        self:setPlayer(self:getViewSeat(msg.seat), msg.player.name, msg.player.gold, msg.player.sex,viptype, msg.player.imageid, msg.player.uid)
        self:setState(self:getViewSeat(msg.seat), msg.player.ready>0)

        --记录准备状态
        if msg.player.ready ~= 0 then
            self:setGameState(msg.seat,3)

            if msg.seat == seatIndex then
                cc.uiloader:seekNodeByNameFast(self.scene,"btn_game_continue"):hide()
            end
        end

        --刷新总水数
        if msg.seat == seatIndex then
            if _matchid then
                self:updateMatchScore(msg.player.gold, true)
            else
                self:updateRecordInfo(msg.player.gold,true)
            end
        end
    elseif name == "room.LeaveGame" then    --玩家离开
        print(msg.seat .."号玩家离开")

        if seatIndex and tableSession and gameState == 0 then
            self:clearPlayer(self:getViewSeat(msg.seat))
            self:setState(self:getViewSeat(msg.seat), false)
            if msg.seat == seatIndex then
                seatIndex = 0
                tableSession = 0
            end
        end
    elseif name == "room.Ready" then    --玩家准备
        print(msg.seat,"号玩家准备")
        self:setGameState(msg.seat,3)
        --显示准备
        print("seatCount = ",seatCount)
        self:setState(self:getViewSeat(msg.seat), true)
        --隐藏按钮  --隐藏继续游戏按钮
        if msg.seat == seatIndex then
            cc.uiloader:seekNodeByNameFast(self.scene,"btn_WinXin_YaoQing"):hide()
            cc.uiloader:seekNodeByNameFast(self.scene,"btn_game_start"):hide()
            cc.uiloader:seekNodeByNameFast(self.scene,"btn_game_continue"):hide()
            ResultLayer:hide()
            SeeLayer:hide()
        end
    elseif name == "room.InitPrivateRoom" then  --初始化私人房
        roomSession = msg.room_Session
        tableSession = msg.table_session
        gameState = msg.game_state
        self.tableSession = tableSession
        table_code = msg.table_code
        seatIndex = msg.seatid
        seatCount = msg.max_player    --椅子数
        self.seatCount = seatCount
        gameround = msg.gameround     --最大局数

        self.customization = msg.customization                        --可选项状态

        self.room_is_add_color = true
        if MathBit.andOp(msg.customization,1) == 1 then                                 --不加牌
            self.room_is_add_color = false
            cc.uiloader:seekNodeByNameFast(self.scene, "tx_add_card"):setString("")
        elseif MathBit.andOp(msg.customization,2) == 2 then                             --加一色
            cc.uiloader:seekNodeByNameFast(self.scene, "tx_add_card"):setString("加一色")
        elseif MathBit.andOp(msg.customization,4) == 4 then                             --加1王
            cc.uiloader:seekNodeByNameFast(self.scene, "tx_add_card"):setString("加1王")
        elseif MathBit.andOp(msg.customization,8) == 8 then                             --加2王
            cc.uiloader:seekNodeByNameFast(self.scene, "tx_add_card"):setString("加2王")
        end

        if MathBit.andOp(msg.customization,32) == 32 then         --没有苍蝇
            self.game_fly_card = 0
        elseif MathBit.andOp(msg.customization,64) == 64 then     --黑桃10 苍蝇
            self.game_fly_card = 0x3A
        elseif MathBit.andOp(msg.customization,128) == 128 then     --红桃5  苍蝇
            self.game_fly_card = 0x25
        end

        print("room.InitPrivateRoom---",tableSession,table_code,seatCount)

        if gameState == 0 then          --房卡游戏未开始
            self:showPRSeat({seat_cnt = msg.max_player,table_code = msg.table_code,tableid = msg.tableid,gameround = msg.gameround,
                table_session = msg.table_session, pay_type = msg.pay_type})
        else
            -- cc.uiloader:seekNodeByNameFast(self.scene,"nd_drop_bar"):show()

            --显示苍蝇 总水数
            self:showMaPaiImg()

            --显示 局数 房间号
            cc.uiloader:seekNodeByNameFast(self.scene,"Room_Info"):show()
        end
    elseif name == "room.PrivateStart" then     --私人房间开局
        print("room.PrivateStart---","私人房间开局")

        --私人房开局
        gameState = 1

        --隐藏房间界面
        self:hidePRSeat()

        -- cc.uiloader:seekNodeByNameFast(self.scene,"nd_drop_bar"):show()

        --显示苍蝇 总水数
        self:showMaPaiImg()
        self:updateRecordInfo(0,true)

        --显示房间号
        cc.uiloader:seekNodeByNameFast(self.scene,"Room_Info"):show()
        self:setRoomCode()

        --显示网络信号
        local Room_Info_1 = cc.uiloader:seekNodeByNameFast(self.scene,"Room_Info_1")
        self:setDelayTime(Room_Info_1)
    elseif name == "room.TableStateInfo" then       --私人房间信息
        print("私人房间信息",gameState, msg.state, msg.round)

        --当前局数
        if gameState and gameState ~= 0 then
            self.current_Ju_Shu = msg.round - 1
            self:updateCurrentGameNum()

            --显示房间号
            self:setRoomCode()

            --显示网络信号
            local Room_Info_1 = cc.uiloader:seekNodeByNameFast(self.scene,"Room_Info_1")
            self:setDelayTime(Room_Info_1)
        end

        --房间已经开始游戏 但本局游戏还没开始
        if msg.state == 0 and gameState and gameState ~= 0 then
            cc.uiloader:seekNodeByNameFast(self.scene,"btn_game_continue"):show()
        end

        --清掉加载条
        --self:closeProgressLayer()
    elseif name == "room.UpdateSeat" then  --刷新分
        print("刷新分数")
        for i = 1,#msg.player do
            if msg.player[i].seat == seatIndex then
                self:updateRecordInfo(msg.player[i].gold,true)
            end

            self:updatePRScore(self:getViewSeat(msg.player[i].seat), msg.player[i].gold)
        end
    elseif name == "room.ManagedNtf" then
        print("断线消息：room.ManagedNtf", "椅子号：" .. msg.seat, "状态：" .. msg.state)
        if gameState ~= 0 then
            local seat = self:getViewSeat(msg.seat)
            print("椅子= ".. seat)
            if msg.state == 1 then  --断线
                self:setComplete(seat,false)
                self:setPeipai(seat,false)
                self:setState(seat,false)
                self:setDuanXian(seat,true)
            else        --上线
                self:setDuanXian(seat,false)
                local state = self:getGameState(msg.seat)
                if not state then
                    return
                end

                if state == 1 then
                    self:setPeipai(seat,true)
                elseif state == 2 then
                    self:setComplete(seat,true)
                elseif state == 3 then
                    self:setState(seat,true)
                end
            end
        end
    elseif name == "room.ChatMsg" then
       --print("room.chatMsg-session, table_session", msg.session, roomSession)
       if _matchid ~= nil then
            if _matchSession == msg.session then
                if msg.info.chattype == 1 then
                    self:playEmotion(tonumber(msg.info.content), self:getViewSeat(msg.fromseat), self:getViewSeat(msg.toseat))
                end
            end
       else
            if roomSession == msg.session then
                if msg.info.chattype == 1 then
                    self:playEmotion(tonumber(msg.info.content), self:getViewSeat(msg.fromseat), self:getViewSeat(msg.toseat))
                end
            end
       end

    elseif msg.session == tableSession then
        if name == "_13Shui.Ready" then
            print("显示准备：_13Shui.Ready")

            if not isScene then
                --显示准备按钮
                btnStart:setVisible(true)
                --显示聊天按钮
                util.SetRequestBtnShow()
            end

        elseif name == "_13Shui.Termination" then   --总战绩
            if emoBgLayer ~= nil then
                emoBgLayer:hide()
            end
            self:performWithDelay(function()
                self:showRecord(msg)
            end, 5)
        elseif name == "_13Shui.GameStart" then
            print("游戏开始：_13Shui.GameStart")

            if _matchid then
                self:resetMatch(false)
                self:restart()
            end

            if emoBgLayer ~= nil then
                emoBgLayer:hide()
                self:setEmoBtnTouch(false)
            end

            cc.uiloader:seekNodeByNameFast(self.scene, "User_1"):pos(72, 96.43)

            if table_code then
                self:onRestart()
            end
            ResultLayer:hide()
            SeeLayer:hide()

            sound.game_start()

            --有效的椅子号
            valid_seats = msg.valid_seat_id
            --隐藏状态
            for i = 1,4 do
                self:setState(i, false)
                self:setPeipai(i, false)
            end

            --如果不是比赛房 刷新当前局数
            if not _matchid then
                self:updateCurrentGameNum()
            end

        elseif name == "_13Shui.SendCard" then
            print("发牌回复：_13Shui.SendCard")

            print("------------我的手牌1-------------")
            dump(msg.cardvalues)
            print("-------------------------")

            --隐藏个人信息
            self:setMyInfoShowState(false)

            ResultLayer:hide()
            SeeLayer:hide()

            --是否有特殊牌型
            btn_sp_show = (msg.is_special_cardtype == true)
            print("-----------特殊牌型--------------")
            print(btn_sp_show)
            print("-------------------------")

            --发牌
            self:onSendCard(msg.cardvalues)
            --print("------------我的手牌-------------")
            --dump(msg.cardvalues)
            --print("-------------------------")

        elseif name == "_13Shui.OpenCardRep" then
            print("摆牌回复：_13Shui.OpenCardRep seat = " .. msg.seatid)

            if emoBgLayer ~= nil then
                self:setEmoBtnTouch(true)
            end

            if msg.seatid == seatIndex then
                if msg.result == 0 then
                    btnSign:hide()
                    btnSign:stopAllActions()
                    self:hideBtnConfirm()
                    self:hideTypeBtn()
                    self.isOk = true
                    self:clearTime()

                    self:setGameState(msg.seatid,2)
                    self:setPeipai(self:getViewSeat(msg.seatid),false)
                    self:setComplete(self:getViewSeat(msg.seatid),true)


                    --动画
                    cc.uiloader:seekNodeByNameFast(centerBG,"bg"):hide()
                    transition.execute(centerBG, cc.MoveBy:create(0.2, cc.p(0, -155)), {
                        delay = 0,
                        easing = "backOut",
                        onComplete = function()
                            cc.uiloader:seekNodeByNameFast(centerBG,"ok_btn_1"):setButtonEnabled(false)
                            cc.uiloader:seekNodeByNameFast(centerBG,"ok_btn_2"):setButtonEnabled(false)
                            cc.uiloader:seekNodeByNameFast(centerBG,"ok_btn_3"):setButtonEnabled(false)
                        end,
                    })
                else
                    local str
                    if msg.result == 1 then
                        str = "摆牌失败:已经摊牌!"
                    elseif msg.result == 2 then
                        str = "摆牌失败:不在游戏中!"
                    elseif msg.result == 3 then
                        str = "摆牌失败:出现倒水!"
                    end
                    ErrorLayer.new(str):addTo(self.scene,500)
                end
            else
                if msg.result == 0 then
                    self:setGameState(msg.seatid,2)
                    self:setComplete(self:getViewSeat(msg.seatid),true)
                    self:setPeipai(self:getViewSeat(msg.seatid),false)
                end
            end
        elseif name == "_13Shui.CompareCard" then
            print("比牌：_13Shui.CompareCard")

            centerBG:stopAllActions()
            centerBG:pos(0,0)

            self:compare(msg.userinfos,msg.daqianginfos,msg.quanleidainfos)
        elseif name == "_13Shui.GameOver" then
            print("结算：_13Shui.GameOver")

            self:showResult(msg.scoreinfos, table_code, gameround)
        elseif name == "_13Shui.GameScene_OpenCard" then
            print("恢复配牌场景：_13Shui.GameScene_OpenCard")

            isScene = true
            valid_seats = msg.valid_seat_id
            basechip = msg.base_score
            btn_sp_show = msg.is_specital_card_type
            self:onGameScene(true,msg)
        elseif name == "_13Shui.GameScene_GameOver" then
            print("恢复比牌场景：_13Shui.GameScene_GameOver")

            isScene = true
            valid_seats = msg.valid_seat_id

            basechip = msg.base_score
            self:onGameScene(false,msg)
        end
    end
end

function SSSScene:SendEmotion(id, direct)
    local toSeat = util.getToSeat(direct, seatCount, seatIndex, 1)
    print("发送表情消息-toSeat = ,direct = ",toSeat, direct)
    if _matchSession then
        print("发送比赛表情消息-matchSession =",_matchSession)
        message.sendMessage("game.ChatReq", {session = _matchSession,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
    else
        print("发送开房表情消息-roomsession =",roomSession)
        message.sendMessage("game.ChatReq", {session = roomSession,info = {chattype = 1,content = tostring(id)},toseat = toSeat})
    end
end

function SSSScene:playEmotion(index, fromDirect, toDirect)

    local from_player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",fromDirect))
    local to_player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",toDirect))
    local beginPos = cc.p(from_player_ui:getPositionX(), from_player_ui:getPositionY())
    local endPos = cc.p(to_player_ui:getPositionX(), to_player_ui:getPositionY())

    util.RunEmotionInfo(self, index, beginPos, endPos)
end

--[[ --
    * 这一局结束 重置信息
--]]
function SSSScene:restart()
    print("SSSScene:restart()")
    is_card_sp = false
    btn_sp_show = false
    valid_seats = {}
    self.isOk = false
    isScene = false
    self:restartCards()
    self:clearTime()
end

--[[ --
    * 清理场景
--]]
function SSSScene:clearScene()
    gameState = nil
    gameround = nil

    seatCount = nil
    centerBG = nil
    btnSign = nil

    btnConfirm = nil
    btnStart = nil

    ResultLayer = nil
    SeeLayer = nil

    roomSession = nil
    seatIndex = nil
    tableSession = nil
    watchingGame = nil
    basechip = nil
    gameRoomId = nil

    table_code = nil
    privateRoom = nil

    is_card_sp = nil
    btn_sp_show = nil
    valid_seats = nil
    isScene = nil

    _matchSession = nil
    _matchid = nil
    _isMatchInit = nil
    _tempSingnCount = nil

    if emoBgLayer ~= nil then
        util.setImageNodeHide(emoBgLayer, 101)
        util.setImageNodeHide(emoBgLayer, 102)
        util.setImageNodeHide(emoBgLayer, 103)
    end
    emoBgLayer = nil
    cureHead = nil
    uidText = nil

    if self.delayHandler then
        scheduler.unscheduleGlobal(self.delayHandler)
        self.delayHandler = nil
    end

    self:clearCards()
    self:clearPlayers()
    self:clearTime()
    self:clearMatch()
end

function SSSScene:closeProgressLayer()
    local progressLayer = self:getChildByTag(progressTag)

    if progressLayer then
        print("SSSScene:closeProgressLayer--移除加载")
        ProgressLayer.removeProgressLayer(progressLayer)
    end
end

function SSSScene:exitScene()
    errorLayer.new(app.lang.room_over_leave, nil, nil,
        function()
                print("断线重连时房间不存在2")
                self:onLeave()
        end):addTo(self, 1000)
end

function SSSScene:socket(msg)
    print("SSSScene:socket = ", msg)
    if msg == "SOCKET_TCP_CONNECTED" then
        if _matchid ~= nil then
            MatchMessage.MatchListReq(106, app.constant.matchid)
        else
            PRMessage.EnterPrivateRoomReq(app.constant.privateCode)
        end

        self:closeProgressLayer()
    elseif msg == "SOCKET_TCP_CLOSED" then
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.reconnect_loading):addTo(self, 8888, progressTag)
        end
    elseif msg == "SOCKET_TCP_CONNECT_FAILURE" then
        print("SOCKET_TCP_CONNECT_FAILURE----")
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.serverRestart_loading):addTo(self, 8888, progressTag)
        end
    end

end

function SSSScene:reloadTextureCache()

     --牌型资源加载---
    local type_img_texture_rect = {
        cc.rect(0, 0, 69, 36),
        cc.rect(0, 0, 71, 35),
        cc.rect(0, 0, 70, 36),
        cc.rect(0, 0, 71, 37),
        cc.rect(0, 0, 72, 36),
        cc.rect(0, 0, 73, 36),
        cc.rect(0, 0, 84, 44),
        cc.rect(0, 0, 84, 44),
        cc.rect(0, 0, 123, 44),
        cc.rect(0, 0, 121, 43),
    }
    --加载牌型资源
    for i=1,#type_img do
        local  res  = string.format("Image/SSS/type_img/%s", type_img[i])
        local texture = cc.Director:getInstance():getTextureCache():addImage(res)
        local frame = cc.SpriteFrame:createWithTexture(texture, type_img_texture_rect[i])
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, type_img[i])
    end
    --重新加载牌的缓存资源
    self:reLoadCardsTexture()
    print("reloadTextureCache----")
end

function SSSScene:onEnterBackground()
    print("SSSScene-onEnterBackground---------")
end

function SSSScene:onEnterForeground()
    --重新加载缓存资源
    print("SSSScene-onEnterForeground11---------")
    self:reloadTextureCache()
    if app.constant.lastHearTime + 60 < os.time() then
        print("outTime---")
        local progressLayer = self:getChildByTag(progressTag)
        if progressLayer == nil then
            ProgressLayer.new(app.lang.reconnect_loading):addTo(self, 8888, progressTag)
        end
    end
end

return SSSScene