local LobbyScene = class("LobbyScene", function ()
    --print(package.loaded["app.scenes.LobbyScene"])
    require("app.User.PersonalCenter")
    require("app.User.SafeBox")
    require("app.User.Recharge")
    require("app.User.FreeGold")
    require("app.User.PrivateRoom")
    require("app.User.MatchRoom")
    require("app.User.Lottery")
    require("app.User.GameRecord")
    require("app.User.Cooperation")
    return display.newScene("LobbyScene")
    end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local web = require("app.net.web")

local GateNet = require("app.net.GateNet")
local AvatarConfig = require("app.config.AvatarConfig")
local UserMessage = require("app.net.UserMessage")
local MatchMessage = require("app.net.MatchMessage")
local PRMessage = require("app.net.PRMessage")

local ProgressLayer = require("app.layers.ProgressLayer")
local ErrorLayer = require("app.layers.ErrorLayer")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")

local RoomConfig = require("app.config.RoomConfig")
local PreloadRes = require("app.config.PreloadRes")
local util = require("app.Common.util")
local Share = require("app.User.Share")

local crypt = require("crypt")

local RequestLayer = require("app.layers.RequestLayer")
local message = require("app.net.Message")
local roomMgr = require("app.room.manager")
local msgMgr = require("app.room.msgMgr")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local sound_common = require("app.Common.sound_common")

local PlatConfig = require("app.config.PlatformConfig")
local ActivityConfig = require("app.config.ActivityConfig")--活动信息配置

local NetSprite = require("app.config.NetSprite")
local LoginNet = require("app.net.LoginNet")


local Player = app.userdata.Player
local Account = app.userdata.Account

local progressTag = 10000
local hasSetListener = false

local guideTag = 99999
local guideInfo = require("app.Guide")
local guideLayer = require("app.layers.GuideLayer")

LobbyScene.UPDATE_CHATNUM = "UPDATE_CHATNUM"

local leftTime = nil
local startTime = nil

local curMenu = 1
local isFinding = false

--local curScene
local curFriendID
local lastFriendIndex = 1
local lastCurFriendID = 0

local curActIndex = 1
--local loginFchatHandler

local aniHandlers = {}
local lucky_profile = {} --小红点的表
local aniParent = {}
local lastRand = 1
local curRuleType = 1


function LobbyScene:TurnMenuAni(param, mType)
    if param.left ~= nil then
        local posX = param.left:getPositionX()
        local posY = param.left:getPositionY()
        posX = -posX
        local  action = cc.MoveTo:create(0.6, cc.p(posX, posY))
        action = cc.EaseExponentialInOut:create(action)
        transition.execute(param.left, action, {
          easing = "bounceOut",
          onComplete = function()
          print("move param.left")
          end,
          })
      end

      if param.center ~= nil then
      local posX = param.center:getPositionX()
      local posY = param.center:getPositionY()
      local w = param.center:getContentSize().width
      local x = display.width-math.abs(posX)
      posX = display.width+x-w
      local  action = cc.MoveTo:create(0.6, cc.p(posX, posY))
      action = cc.EaseExponentialInOut:create(action)
      transition.execute(param.center, action, {
        easing = "bounceOut",
        onComplete = function()
          print("move param.center")
        end,
        })
    end

    if param.right ~= nil then
      local posX = param.right:getPositionX()
      local posY = param.right:getPositionY()
      local w = param.right:getViewRect().width
      local x = display.width-math.abs(posX)
      posX = display.width+x-w
      local  action = cc.MoveTo:create(0.6, cc.p(posX, posY))
      action = cc.EaseExponentialInOut:create(action)
      transition.execute(param.right, action, {
        easing = "bounceOut",
        onComplete = function()
        print("move param.right")
        end,
        })
    end

    local curSpeed = 1

    if param.centerItem ~= nil then

      for index,item in ipairs(param.centerItem) do

          local posX = item:getPositionX()
          local posY = item:getPositionY()
          -- item:setTouchEnabled(false)
          local lastPosX = posX
          local w = 100
          print("setlobbyMenu-posX = ",posX)

          if posX > display.width then

             posX = posX-(display.width-w)
          else
             posX = posX+(display.width-w)
          end

          local speed = math.abs(lastPosX-posX)/(display.width-w)
          curSpeed = speed
          local  action = cc.MoveTo:create(speed, cc.p(posX, posY))
          action = cc.EaseExponentialInOut:create(action)
          transition.execute(item, action, {
            delay = 0.1*(index-1),
            easing = "bounceInOut",
            onComplete = function()
                -- item:setTouchEnabled(true)
                print("move param.item",index)
                 if index == #param.centerItem and mType ~= nil and mType==0 then
                    self:setNickandChatLogin()
                end

            end
            })
      end

    end

    if param.rightItem ~= nil then

      for game_index,game in ipairs(param.rightItem) do
        if game then
          local posX = game:getPositionX()
          local posY = game:getPositionY()
          local Home = cc.uiloader:seekNodeByNameFast(self.scene, "Home")
          -- Home:setTouchEnabled(false)
          local w = 120

          local lastPosX = posX

          if posX > display.width then
             posX = posX-(display.width-w)
          else
             posX = posX+(display.width-w)
          end
          --print("game-w",w,posX,posY)
          local speed = math.abs(lastPosX-posX)/(display.width-w)
          curSpeed = speed
          --print("speed22 = ",speed)
          local  action = cc.MoveTo:create(speed, cc.p(posX, posY))
          action = cc.EaseExponentialInOut:create(action)
          transition.execute(game, action, {
            delay = 0.1*(game_index-1),
            easing = "bounceInOut",
            onComplete = function()
                -- local Home = cc.uiloader:seekNodeByNameFast(self.scene, "Home")
                Home:setTouchEnabled(true)
                print("move param.game",gameid)
            end
            })
        end
      end
    end

     if param.top ~= nil then

      local posX = param.top:getPositionX()
      local posY = param.top:getPositionY()
      local lastPosY = posY
     -- local y = display.height-math.abs(posY)
     -- posY = display.height+y-H
      local H = 77

      print("top-posy = ",posY)
      if posY >= display.height+30 then
            posY = posY-H
      else
            posY = posY+H
      end

      --local speed = math.abs(lastPosY-posY)/(H)
      local  action = cc.MoveTo:create(1.5, cc.p(posX, posY))
      action = cc.EaseExponentialInOut:create(action)

      transition.execute(param.top, action, {
            easing = "bounceOut",
            onComplete = function()
            end})
    end

    if param.bottom ~= nil then
      local posX = param.bottom:getPositionX()
      local posY = param.bottom:getPositionY()
      --local H = param.bottom:getContentSize().height
      local lastPosY = posY
      local H = 98
      print("bottom-posy = ",posY)
      if posY < -30 then
            posY = posY+H
      else
            posY = posY-H
      end
      --posY = -posY
      --local speed = math.abs(lastPosY-posY)/(H)
      local  action = cc.MoveTo:create(1.5, cc.p(posX, posY))
      action = cc.EaseExponentialInOut:create(action)
      transition.execute(param.bottom, action, {
        easing = "bounceOut",
        onComplete = function()
              -- local posY = param.bottom:getPositionY()
        end
        })
    end

end

function LobbyScene:ctor()

    curScene =   self
    print("start player")
    sound_common.init()
    sound_common.bg()
    -- get bank info
    UserMessage.BankInfoReq()
    -- query recharge
    self:checkOrder()
    --活动商品缓存添加
    self:addFrame()
    -- init variable
    self.loaded = false
    -- scene
    self.scene = cc.uiloader:load("Platform_Src/LobbyScene.json"):addTo(self)

    self.scene.uid = cc.uiloader:seekNodeByNameFast(self.scene, "userID")
    local money = cc.uiloader:seekNodeByNameFast(self.scene, "AtlasLabel_Money")
    local dam = cc.uiloader:seekNodeByNameFast(self.scene, "AtlasLabel_Dam")
    money:hide()
    dam:hide()

  --   local param1 = { root = money:getParent(), size = money:getSystemFontSize(),
  --   x = money:getPositionX(), y = money:getPositionY(), text = "0",
  --   color1 = cc.c4b(255,255,255,255), color2 = cc.c4b(221,124,64,255), w = 2
  -- }
    local param2 = { root = dam:getParent(), size = dam:getSystemFontSize(),
    x = dam:getPositionX(), y = dam:getPositionY(), text = "0",
    color1 = cc.c4b(255,255,255,255), color2 = cc.c4b(221,124,64,255), w = 2
    }

    self.scene.dam_Lobby = util.SetStroke(param2)
    self.scene.nickname = cc.uiloader:seekNodeByNameFast(self.scene, "Nick")
    self.scene.bg = cc.uiloader:seekNodeByNameFast(self.scene, "Background")
    self.scene.horn = cc.uiloader:seekNodeByNameFast(self.scene, "Paomadeng")
    self.scene.horn_bg = display.newScale9Sprite("Image/Lobby/img_mainmenu_Background.png",
      0,
    self.scene.horn:getPositionY(),
    cc.size(46, 46)):setAnchorPoint(cc.p(0,0))
    self.scene.horn_bg:addTo(self.scene.bg) --NOTE: add to background !
    self.scene.horn_bg:setLocalZOrder(1)
    self.scene.horn_bg:setScale(0.1)

    self.scene.horn:setVisible(false)
    self.scene.horn_bg:setVisible(false)

    self.scene.avatar = cc.uiloader:seekNodeByNameFast(self.scene, "Avatar")
    self.scene.avatar_bg = cc.uiloader:seekNodeByNameFast(self.scene, "AvatarFrame")
   -- self.scene.avatar:onButtonClicked(handler(self, self.showPersonalCenter))
    local btn_Add = cc.uiloader:seekNodeByNameFast(self.scene, "Add")
    btn_Add:setTag(1)
    btn_Add:onButtonClicked(handler(self, self.showRecharge))
    local btn_Add_D = cc.uiloader:seekNodeByNameFast(self.scene, "Add_D")
    btn_Add_D:setTag(2)
    btn_Add_D:onButtonClicked(handler(self, self.showRecharge))
    util.BtnScaleFun(btn_Add)
    util.BtnScaleFun(btn_Add_D)

    -- local myself_btn = cc.uiloader:seekNodeByNameFast(self.scene, "MySelf")
    -- -- :onButtonClicked(handler(self, self.showPersonalCenter))
    -- myself_btn:hide()
    -- util.BtnScaleFun(myself_btn)

    -- cc.uiloader:seekNodeByNameFast(self.scene, "Share")
    -- :onButtonClicked(handler(self, self.showShare))

  local recharge = cc.uiloader:seekNodeByNameFast(self.scene, "Recharge")
   --if Account.tags.recharge_tag == "1" then
   recharge:show()
   recharge:setTag(2)
   recharge:onButtonClicked(handler(self, self.showRecharge))
   --else
    --    recharge:hide()
   --end
--
  util.BtnScaleFun(recharge)

  local btn_ShareFriend = cc.uiloader:seekNodeByNameFast(self.scene, "btn_ShareFriend")

  btn_ShareFriend:onButtonClicked(handler(self, self.showShare))
  util.BtnScaleFun(btn_ShareFriend)

-- local safebox = cc.uiloader:seekNodeByNameFast(self.scene, "SafeBox")
-- if Account.tags.safebox_tag == "1" then
--   safebox:show()
--   safebox:onButtonClicked(handler(self, self.showSafeBox))
-- else
--   safebox:hide()
-- end

-- util.BtnScaleFun(safebox)

  local service = cc.uiloader:seekNodeByNameFast(self.scene, "Service")

  util.BtnScaleFun(service)

  if Account.tags.service_tag == "1" then
      service:show()
      service:onButtonClicked(
   function ()
        if app.constant.isOpening == true then
             return
        end
        sound_common.menu()
        local activeLayer = self:showSubLayer("Layer/Lobby/ServiceLayer.json", "Image/Lobby/service_title.png")

    --modify by whb 0324
    local Text_2 = cc.uiloader:seekNodeByNameFast(activeLayer, "Text_2")
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    Text_2:setString(platConfig.serviceLayer_Text_2)

    local Text_1 = cc.uiloader:seekNodeByNameFast(activeLayer, "Text_1")
    Text_1:setString(platConfig.noticeLayer_Text_1)
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    if platConfig ~= nil and platConfig.isAppStore ~= nil then
        if platConfig.isAppStore == true then
            Text_1:setString("")
        end
    end
    --modify end

    local btn_service = cc.uiloader:seekNodeByNameFast(activeLayer, "Btn_Service")
    btn_service:onButtonClicked(handler(self, self.showChatMenu))

    end)
    util.BtnScaleFun(btn_service)
      --print("Service--begin")
      --service:onButtonClicked(handler(self, self.showChatMenu))
    else
      service:hide()
    end

    -- local btnFreeGold = cc.uiloader:seekNodeByNameFast(self.scene, "FreeGold")

    -- util.BtnScaleFun(btnFreeGold)

    -- local honor = cc.uiloader:seekNodeByNameFast(self.scene, "Honor")
    -- self.scene.honor = honor

    -- local btn_RichRank = cc.uiloader:seekNodeByNameFast(self.scene, "btn_RichRank")
    -- self.scene.richRank = btn_RichRank

  --  local btnFriendRoom = cc.uiloader:seekNodeByNameFast(self.scene, "FriendRoom")

    local btnFriendRoom = nil
    if btnFriendRoom ~= nil then
      self.scene.btnFriendRoom = btnFriendRoom
    end
     --add by whb 0106

    if Account.tags.recharge_tag == "1" then

        app.constant.isOpenYvSys = true

    else

        app.constant.isOpenYvSys = false

    end

    -- if Account.tags.free_gold_tag == "1" then

    --  -- btnFreeGold:show()
    --   btnFreeGold:onButtonClicked(handler(self, self.showFreeGold))

    -- else
    --   btnFreeGold:hide()
    -- end
    -- if Account.tags.honor_tag == "1" then
    --     -- honor:show()
    --     -- honor:onButtonClicked(handler(self, self.showHonor))
    --     -- btn_RichRank:show()
    --     -- btn_RichRank:onButtonClicked(handler(self, self.showRichRank))

    --     if btnFriendRoom ~= nil then

    --     btnFriendRoom:show()
    --     btnFriendRoom:onButtonClicked(handler(self, self.showFriendRoom))
    --   end
    -- else
    --     --honor:hide()
    --    -- btn_RichRank:hide()

    --     if btnFriendRoom ~= nil then
    --     btnFriendRoom:hide()
    --   end
    -- end

    --self.scene.btnFreeGold = btnFreeGold

    local activity = cc.uiloader:seekNodeByNameFast(self.scene, "Activity")
    -- local Img_ChatTip = cc.uiloader:seekNodeByNameFast(activity, "Img_ChatTip_2")
    -- Img_ChatTip:show()
    if Account.tags.activity_tag == "1" then
      activity:show()
      activity:onButtonClicked(function ()
        self:showActivityLayer()
        end)
    else
      activity:hide()
    end

    util.BtnScaleFun(activity)

    --创建房间 加入房间 查看战绩 按钮
    --local private_room_create = cc.uiloader:seekNodeByNameFast(self.scene, "private_room_create")
    --local private_room_login = cc.uiloader:seekNodeByNameFast(self.scene, "private_room_login")
    local private_room_record = cc.uiloader:seekNodeByNameFast(self.scene, "private_room_record")

    --private_room_create:onButtonClicked(function(event) self:setPrivateRoomType("create") end)
    --private_room_login:onButtonClicked(function(event)  self:setPrivateRoomType("login")  end)
    private_room_record:onButtonClicked(
      function(event)
        self:showGameRecordMenu()
        PRMessage.PrivateGameRecordProfileReq()
      end
    )

    util.BtnScaleFun(private_room_record)
--[[
    --比赛按钮
    local btn_match = cc.uiloader:seekNodeByNameFast(self.scene, "btn_match")
    local img_btn_effect = cc.uiloader:seekNodeByNameFast(btn_match, "img_btn_effect"):hide()
    local img_match_guang = cc.uiloader:seekNodeByNameFast(btn_match, "img_match_guang"):hide()
    util.BtnScaleFun(btn_match, 1 ,0.95)
      :onButtonClicked(function()
        -- MatchMessage.MatchListReq(106)
        -- self:showRoomList(106)
        self:showMatchLayer()
        MatchMessage.MatchListReq(106)
	  end)

	--比赛按钮滑动光
	btn_match:schedule(function()
		img_btn_effect:pos(-195.00, 46)
		local seq = cca.seq{cca.show(), cca.moveBy(0.8, 257, 0), cca.hide()}
		img_btn_effect:runAction(seq)
  	end, 5)

	--比赛按钮的边光
	btn_match:schedule(function()
		img_match_guang:scale(1)
		img_match_guang:setOpacity(255)
		local spawn = cca.spawn{cca.scaleBy(1.2,1.07), cca.fadeOut(1.2)}
		local seq = cca.seq{cca.show(), spawn, cca.hide()}
		img_match_guang:runAction(seq)
	end, 8)

	--上下两个移动光点
	local img_embellishment_top = cc.uiloader:seekNodeByNameFast(self.scene, "img_embellishment_top")
	local img_embellishment_bottom = cc.uiloader:seekNodeByNameFast(self.scene, "img_embellishment_bottom")
	img_embellishment_top:schedule(function()
		img_embellishment_top:pos(1400, img_embellishment_top:getPositionY())
    img_embellishment_bottom:pos(-120, img_embellishment_bottom:getPositionY())

    img_embellishment_top:moveBy(3.5, -1500, 0)
    img_embellishment_bottom:moveBy(3.5, 1500, 0)
	end, 8)
--]]
    local btn_RequestCode = cc.uiloader:seekNodeByNameFast(self.scene, "btn_RequestCode")

    if btn_RequestCode ~= nil then

        btn_RequestCode:onButtonClicked(
          function ()
            self:showRequestCode()
          end)

        util.BtnScaleFun(btn_RequestCode)

    end

    -- local btn_GameRule = cc.uiloader:seekNodeByNameFast(self.scene, "btn_GameRule")

    -- if btn_GameRule ~= nil then

    --   btn_GameRule:onButtonClicked(
    --     function ()
    --       self:showRuleLayer()
    --     end)

    --   util.BtnScaleFun(btn_GameRule)

    -- end

--,node, ani_str, node1, ani_light
--[[
local function playHouseBtnAction(param)

  local node = param.node
  local ani_str = param.ani_str
  local node1 = param.node1
  local ani_light = param.ani_light

  local target = display.newSprite(ani_str)

  if ani_str == "Image/Lobby/img_Ml.png" then
    target:setPosition(node:getPositionX()-13,node:getPositionY()+13)
  else
    target:setPosition(node:getPositionX(),node:getPositionY())
  end

  target:addTo(node:getParent(),9)

       -- local blik = cc.Blink:create(2.0, 2)

       -- target:setOpacity(65)
       local fadein = cc.FadeIn:create(0.1)
       local scaleTo = cc.ScaleTo:create(0.7,1.04)
       local fadeout = cc.FadeOut:create(0.8)
       local sTo3 = cc.ScaleTo:create(0.8,1.07)
       local spTo2 = cc.Spawn:create(fadeout,sTo3)
       local spawn = cc.Spawn:create(fadein,scaleTo)

       local removeSelf = cc.RemoveSelf:create(true)
        -- local dt_1 = cc.DelayTime:create(5)

        -- local callback = cc.CallFunc:create(function()

        --    target:setScale(1.0)
        --  end)

        local seq = cc.Sequence:create(spawn, spTo2, removeSelf)
        --local rep_seq = cc.RepeatForever:create(seq)

        target:runAction(seq)

        local ligth = display.newSprite(ani_light)
        ligth:setPosition(node1:getPositionX(),node1:getPositionY())
        ligth:addTo(node1:getParent(),6)
        ligth:setAnchorPoint(0.5,0.5)

        local scaleTo = cc.ScaleTo:create(0.7,1.07)
        local fadeTo = cc.FadeIn:create(0.7)
        local fadeTo2 = cc.FadeTo:create(0.8,0)
        local moveby = cc.MoveBy:create(0.8,cc.p(0,-8))

        local spawn1 = cc.Spawn:create(scaleTo,fadeTo)
        local spawn2 = cc.Spawn:create(fadeTo2,moveby)

        local removeSelf = cc.RemoveSelf:create(true)

         -- local callback2 = cc.CallFunc:create(function()
         --   --ligth:setOpacity(0)
         --   ligth:setScale(1.0)
         --   ligth:setPosition(node1:getPositionX(),node1:getPositionY())
         -- end)

         local seq = cc.Sequence:create(spawn1, spawn2, removeSelf)
        --local rep_seq = cc.RepeatForever:create(seq)

        ligth:runAction(seq)

      end

  local function add_star_ani(parent, num, pos)
    --添加星星

    for i = 1, num do

      local star = display.newSprite("Image/Lobby/star.png")

       -- local rand_x = math.random(60,240)
       -- local rand_y = math.random(160,300)
       local rand_x = pos[i].x
       local rand_y = pos[i].y
        --print("rand_x,rand_y:",rand_x,rand_y)
        local pos_star = cc.p(rand_x,rand_y)
        star:setPosition(pos_star)
        parent:addChild(star,20)

        local rand_scale = 0.01 + math.random(1,7) / 100
        star:setScale(rand_scale)

        local rand_scale2 = 0.5 + math.random(1,5) / 50

        local rand_rotate = 160 + math.random(1,8)*10
        local rand_delay = 1.5 + math.random(1,4)
        local rand_dur = 1.7 + math.random(1,4)/5

        if i == 2 or i == 3 or i == 5 then

          rand_scale2 = 0.7 + math.random(1,5) / 20
          rand_delay = 5 + math.random(1,4)
          elseif i == 4 or i == 6 then

            rand_delay = 8.5 + math.random(1,4)
          end

          local scale1_star = cc.ScaleTo:create(1.0,rand_scale2)
          local scale2_star = cc.ScaleTo:create(1.0,rand_scale)
          local seq_star = cc.Sequence:create(scale1_star,scale2_star)
          local ret_star = cc.RotateBy:create(rand_dur,rand_rotate)

          if i == 4 or i == 6 then

            ret_star = ret_star:reverse()

          end

          local spawn_star = cc.Spawn:create(seq_star,ret_star)

          if i == 2 or i == 3 or i == 5 then

            spawn_star = cc.Spawn:create(seq_star)

          end

          local dt_star = cc.DelayTime:create(rand_delay)
          local seq2_star = cc.Sequence:create(spawn_star,dt_star)
          local rep_star = cc.RepeatForever:create(seq2_star)

          star:runAction(rep_star)
        end

      end

    local function add_star_aniEx(parent, num, pos, index)
        --添加星星

        for i = 1, num do

           local star = display.newSprite("Image/Lobby/star.png")

           -- local rand_x = math.random(60,240)
           -- local rand_y = math.random(160,300)
           local rand_x = pos[i].x
           local rand_y = pos[i].y
            --print("rand_x2,rand_y2:",rand_x,rand_y)
            local pos_star = cc.p(rand_x,rand_y)
            star:setPosition(pos_star)
            parent:addChild(star,20)

            star:setScale(0.5)

        --+ math.random(1,8)*10
            local rand_rotate = 360
            local rand_delay = 3 + math.random(1,4)
            local rand_dur = 3.0

            local scale1_star = cc.ScaleTo:create(0.7,1.1)
            local scale2_star = cc.ScaleTo:create(0.7,0.1)
            local scale_star = cc.Sequence:create(scale1_star, scale2_star)

            local ret_star = cc.RotateBy:create(rand_dur,rand_rotate)

            local fadein = cc.FadeIn:create(rand_dur/2)
            local fadeout = cc.FadeTo:create(rand_dur/2, 150)
            local fade_star = cc.Sequence:create(fadeout, fadein)

            local points = { cc.p(43.44, 211.49), cc.p(63.37, 209.16), cc.p(83.32, 204.86), cc.p(103.66, 205.64), cc.p(123.61, 206.42), cc.p(143.56, 207.20),
            cc.p(163.90, 209.94), cc.p(174.07, 213.45), cc.p(163.90, 209.94), cc.p(143.56, 207.20), cc.p(123.61, 206.42), cc.p(103.66, 205.64), cc.p(88.81, 207.18)}

            if i == num and index == 3 then

            points = { cc.p(144.50, 162), cc.p(135.55, 182.26), cc.p(110.11, 193.57), cc.p(84.20, 182.73), cc.p(76.19, 161.53),
            cc.p(84.67, 138.51), cc.p(109.17, 127.20), cc.p(134.14, 137.80), cc.p(144.50, 162)}

            elseif index == 2 then

              if i == 1 then
               points = { cc.p(66.82, 223.39), cc.p(44.21, 223.39), cc.p(42.32, 192.77), cc.p(42.32, 158.52), cc.p(77.42, 155.75),
               cc.p(110.87, 155.75), cc.p(144.79, 155.75)}
              else
               points = { cc.p(144.79, 155.75), cc.p(180.59, 155.75), cc.p(182.53, 190.61), cc.p(182.53, 222.65), cc.p(143.43, 222.65),
               cc.p(106.68,  222.65), cc.p(66.82, 222.65)}
              end

            end

            local orbit = cc.CardinalSplineTo:create(rand_dur, points, 0)
            spawn_star = cc.Spawn:create(ret_star,orbit,fade_star)

            local callback = cc.CallFunc:create(
            function()

              star:setScale(0.5)
              star:setOpacity(255)

            end)

            local dt_star = cc.DelayTime:create(rand_delay)
            local seq2_star = cc.Sequence:create(spawn_star,scale_star, dt_star,callback)
            local rep_star = cc.RepeatForever:create(seq2_star)

            star:runAction(rep_star)
      end

   end

 local function playGameBtnAction(parent,ani_str)
       local sp = display.newSprite(ani_str)
        --local gameSize = game:getContentSize()
        local gameSize = cc.size(324,225)
        local gPos_x = gameSize.width / 2 - 15
        local gPos_y = -50

        --随机坐标
        local rand_x = math.random(1,gameSize.width - 30)
        local rand_y = math.random(1,40)
        sp:setPosition(gPos_x - rand_x ,gPos_y - rand_y)
        sp:addTo(parent,-1)
        sp:setScale(0.1)

        --随机淡入淡出时间
        local rand_in = math.random(1,2) / 10
        local rand_in_fade = math.random(100,255)
        local rand_out = math.random(1,20) / 10
        --随机停留时间
        local rand_delay = 0.5 + math.random(1,10) / 10
        --随机放大倍数
        local rand_scale = 0.1 + math.random(1,7) / 10
        --随机移动位置
        local rand_posy = sp:getPositionY() + math.random(1,150)

        local fto = cc.FadeTo:create(rand_in,rand_in_fade)
        local sTo = cc.ScaleTo:create(rand_in,rand_scale)
        local spTo = cc.Spawn:create(fto,sTo)
        local dt = cc.DelayTime:create(rand_delay)
        local fout = cc.FadeOut:create(rand_out)
        local s = cc.Sequence:create(dt,fout)
        local moveTo = cc.MoveTo:create(rand_delay + rand_out,cc.p(sp:getPositionX(), rand_posy))
        local spawn = cc.Spawn:create(s,moveTo)
        local removeSelf = cc.RemoveSelf:create()
        local seq = cc.Sequence:create(spTo,spawn,removeSelf)

        sp:runAction(seq)
  end

  local function playGameBtnActionEx(parent,ani_str)
       local sp = display.newSprite(ani_str)
        --local gameSize = game:getContentSize()
        local gameSize = cc.size(300,310)
        local gPos_x = gameSize.width / 2
        local gPos_y = -50

        --随机坐标
        local rand_x = math.random(10,gameSize.width-20)
        local rand_y = math.random(1,40)
        sp:setPosition(gPos_x - rand_x ,gPos_y - rand_y)
        sp:addTo(parent,9)
        sp:setScale(0.1)

        --随机淡入淡出时间
        local rand_in = math.random(1,2) / 10
        local rand_in_fade = math.random(100,255)
        local rand_out = math.random(1,20) / 10
        --随机停留时间
        local rand_delay = 0.5 + math.random(1,10) / 10
        --随机放大倍数
        local rand_scale = 0.1 + math.random(1,7) / 10
        --随机移动位置
        local rand_posy = sp:getPositionY() + math.random(30,150)

        local fto = cc.FadeTo:create(rand_in,rand_in_fade)
        local sTo = cc.ScaleTo:create(rand_in,rand_scale)
        local spTo = cc.Spawn:create(fto,sTo)
        local dt = cc.DelayTime:create(rand_delay)
        local fout = cc.FadeOut:create(rand_out)
        local s = cc.Sequence:create(dt,fout)
        local moveTo = cc.MoveTo:create(rand_delay + rand_out,cc.p(sp:getPositionX(), rand_posy))
        local spawn = cc.Spawn:create(s,moveTo)
        local removeSelf = cc.RemoveSelf:create()
        local seq = cc.Sequence:create(spTo,spawn,removeSelf)

        sp:runAction(seq)
  end

--
local panel_Bg1 = cc.uiloader:seekNodeByNameFast(self.scene, "Panel_Bg1")

self.scene.panel_Bg1 = panel_Bg1

local button_House1 = cc.uiloader:seekNodeByNameFast(self.scene, "Button_House1")
local button_House2= cc.uiloader:seekNodeByNameFast(self.scene, "Button_House2")

-- 交换两个游戏图标位置
if CONFIG_APP_CHANNEL == "3553" then

  local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
  local gameLeft = cc.uiloader:seekNodeByNameFast(self.scene, platConfig.game[1].Node_Name)
  local gameRight = cc.uiloader:seekNodeByNameFast(self.scene, platConfig.game[2].Node_Name)
  local leftName = cc.uiloader:seekNodeByNameFast(gameLeft, "Name")
  local RightName = cc.uiloader:seekNodeByNameFast(gameRight, "Name")
  local leftPosX,leftPosY = gameLeft:getPosition()
  local rightPosX,rightPosY = gameRight:getPosition()

  gameLeft:setPosition(cc.p(rightPosX, rightPosY))
  gameRight:setPosition(cc.p(leftPosX, leftPosY))
  leftName:setString("2")
  RightName:setString("1")

end

local gameListView = cc.uiloader:seekNodeByNameFast(self.scene, "GameListView")

self.scene.gameListView = gameListView

local w = gameListView:getViewRect().width

local x = gameListView:getPositionX()

gameListView:setPosition(display.width+(display.width-x-w),0)
--]]
local Image_BottomBar = cc.uiloader:seekNodeByNameFast(self.scene, "Image_BottomBar")
local TopBar = cc.uiloader:seekNodeByNameFast(self.scene, "TopBar")

local Home = cc.uiloader:seekNodeByNameFast(self.scene, "Home")
Home:hide()
self.scene.home = Home

local UserInfoBar = cc.uiloader:seekNodeByNameFast(self.scene, "UserInfoBar")
self.scene.userInfoBar = UserInfoBar
UserInfoBar:setPositionX(0)

self.scene.TopBar = TopBar
self.scene.Image_BottomBar = Image_BottomBar

    


   local  BtnCreateRoom = cc.uiloader:seekNodeByNameFast(self.scene, "BtnCreateRoom")
   local  BtnJoinRoom = cc.uiloader:seekNodeByNameFast(self.scene, "BtnJoinRoom")
   local  BtnClubRoom = cc.uiloader:seekNodeByNameFast(self.scene, "BtnClubRoom")
    
    BtnCreateRoom:onButtonClicked(function()  
          if app.constant.isOpening == true then
              return
          end
          app.constant.isOpening = true

        self.curRoomType = "create"  --login
        self:setPrivateRoomType(self.curRoomType,116)

    end)   
    
    BtnJoinRoom:onButtonClicked(function()  
          if app.constant.isOpening == true then
              return
          end
          app.constant.isOpening = true

          self.curRoomType = "login"  --
          self:setPrivateRoomType(self.curRoomType,116)

    end)   


    BtnClubRoom:onButtonClicked(function()  


    end)   

    util.BtnScaleFun(BtnCreateRoom,2)
    util.BtnScaleFun(BtnJoinRoom,2)
    util.BtnScaleFun(BtnClubRoom,2)


    --add by whb 0914
    self:addGuideLayer(guideInfo.guideMenu[1])
    self:getTxtLayer()

    app.constant.isShowChat = false
    app.constant.isLoginGame = true
    app.constant.newChatNum = 0
    app.constant.cur_GameID = 0
    app.constant.cur_RoomID = 0

    app.constant.show_leaveTip = false
    app.constant.isOpening = false
    app.constant.isReconnectGame = false
    app.constant.curRoomRound = 0

--add by whb 0324

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    -- local Logo = cc.uiloader:seekNodeByNameFast(self.scene, "Logo")
    -- local logoSprite = display.newSprite(platConfig.logo_small)
    -- local logoframe = logoSprite:getSpriteFrame()
    -- Logo:setSpriteFrame(logoframe)

    -- local Image_Girl = cc.uiloader:seekNodeByNameFast(self.scene, "Image_Girl")
    -- --print("Image_Girl.res:",platConfig.Image_Girl.res)
    -- Image_Girl:setTexture(platConfig.Image_Girl.res)
    -- Image_Girl:setPositionX(platConfig.Image_Girl.posX)
    -- Image_Girl:setPositionY(platConfig.Image_Girl.posY)

    local btn_Certification = cc.uiloader:seekNodeByNameFast(self.scene, "btn_Certification")
    btn_Certification:onButtonClicked(handler(self,self.showCertificateLayer))
    util.BtnScaleFun(btn_Certification)

    --合作按钮
    local btn_Cooperation = cc.uiloader:seekNodeByNameFast(self.scene, "btn_Cooperation")
    btn_Cooperation:onButtonClicked(handler(self,self.showCooperation))
    util.BtnScaleFun(btn_Cooperation)

    --setting
    local btn_setting = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Setting")
    btn_setting:show()
    btn_setting:onButtonClicked(handler(self,self.showSetting))
    util.BtnScaleFun(btn_setting)

    local btn_Lottery = cc.uiloader:seekNodeByNameFast(self.scene, "btn_Lottery")
    if Account.tags.activity_tag == "1" then
        btn_Lottery:show()
        btn_Lottery:onButtonClicked(handler(self,self.showLotteryLayer))
    else
        btn_Lottery:hide()
    end
    util.BtnScaleFun(btn_Lottery)

    --审核版本，大厅界面配置
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    if platConfig ~= nil and platConfig.isAppStore ~= nil then
        if Account.tags.recharge_tag == "1" then
            --platConfig.isAppStore = false
            platConfig.isAppStore = false
        else
            platConfig.isAppStore = true
        end
        if platConfig.isAppStore then

            -- for i = 5, 7 do
            --   local Image_line = cc.uiloader:seekNodeByNameFast(self.scene, "Image_line_" .. i)
            --   if Image_line ~= nil then
            --     Image_line:hide()
            --   end
            -- end
            btn_Certification:hide()
            btn_ShareFriend:hide()
            btn_Lottery:hide()
            activity:hide()
            btn_RequestCode:hide()
            btn_match:hide()
            btn_setting:setPosition(btn_RequestCode:getPosition())
            service:setPosition(private_room_record:getPosition())
            --btn_GameRule:setPosition(private_room_record:getPosition())
            private_room_record:setPosition(btn_Lottery:getPosition())

        end

    end

    --notice
    -- local btn_notice = cc.uiloader:seekNodeByNameFast(self.scene, "Button_Notice")
    -- if Account.tags.activity_tag == "1" then
    --   btn_notice:show()
    --   btn_notice:onButtonClicked(handler(self,self.showNoticeBox))
    -- else
    --   btn_notice:hide()
    -- end

    -- util.BtnScaleFun(btn_notice)

  end


  function LobbyScene:init()
    if not self.loaded and Player.uid and Player.uid == Account.uid then
      self:moneyChanged()
      self:nicknameChanged()
      self.loaded = true

    end

  end

  function LobbyScene:onEnter()

    --断线重连后，进入大厅清理语音资源
    util.CloseChannel()
    --end

    print("LobbyScene:onEnte")
    --MatchMessage.MatchConfigReq()
    UserMessage.UserInfoRequest(app.userdata.Account.uid)
    UserMessage.RoomListReq()

    UserMessage.LuckyListReq()--抽奖活动的基本信息

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    if platConfig ~= nil and platConfig.isAppStore ~= nil then
        if platConfig.isAppStore == false then
             scheduler.performWithDelayGlobal(
              function ()
                util.matchSchedule()
              end, 1.0)
        end
    end

    self.handler = nil
    self.handler = scheduler.scheduleGlobal(function()
      self:init()
      if self.loaded and self.handler then
        scheduler.unscheduleGlobal(self.handler)
        self.handler = nil
      end
      end, 0.1, false)

    return handle
  end

--检查是否显示活动页面
function LobbyScene:checkShowActivity()

  
  -- local today = os.date("*t",os.time())
  -- local today_str = string.format("%d%02d%02d",today.year,today.month,today.day)
  -- print("today_str:" .. today_str)
  -- if GameData.lastLoginDate == nil or GameData.lastLoginDate ~= today_str then
  --   -- if true then
  --       --todo
  --       if CONFIG_APP_CHANNEL == "3552" then
  --         self:showActivityLayer()
  --       else
  --         self:showLotteryLayer()
  --       end

  --       -- self:showLotteryLayer()
  --       util.GameStateSave("lastLoginDate",today_str)
  --     end
  --   end
  --   function LobbyScene:showActivityBtn(startIndex,endIndex,listID,group,isLucky)
  --   local index=1
  --   if endIndex<=0 then
  --       --todo
  --       return
  --     end
  --     for i = startIndex,endIndex do
  --     print("startIndex" ..startIndex)
  --     print("endIndex" ..endIndex)
  --     local activityConfig = ActivityConfig:getActConfig(CONFIG_APP_CHANNEL)
  --     local unselected = string.format(activityConfig.activityRes.unselected,listID[index])
  --     local selected = string.format(activityConfig.activityRes.selected,listID[index])

  --     local checkbox = cc.ui.UICheckBoxButton.new({
  --       off = unselected,
  --       off_pressed = selected,
  --       off_disabled = unselected,
  --       on = {selected, selected},
  --       on_pressed = {unselected, selected},
  --       on_disabled = {unselected, unselected},
  --       })
  --     checkbox:addTo(self.scene.activeLayer)
  --     checkbox:setPosition(340, 500 - (i - 1) * 80)
  --     checkbox.index = listID[index]
  --     checkbox.Lucky = isLucky

  --     group:addButtons({
  --       [checkbox] = handler(self, self.showActivity)
  --       })
  --     index=index+1
  --     if i == 1 and curActIndex == 1 then
  --       checkbox:setButtonSelected(true)
  --       elseif i == 2 and curActIndex == 2 then
  --         checkbox:setButtonSelected(true)
  --       end



  --       for j=1,#lucky_profile do
  --         if lucky_profile[j]==i then
  --           print("显示小红点")
  --           local hongdianSp = display.newSprite("Image/Common/Avatar/info.png")
  --           :setScale(0.8)
  --           :setPosition(85,20)
  --           :setTag(1056)
  --           :addTo(checkbox)
  --         end
  --       end
  --     end
  --   end
  --   function LobbyScene:LuckyProfileRep(msg)
  --     print("LuckyProfileRep++=")
  --     local activity = cc.uiloader:seekNodeByNameFast(self.scene, "btn_Lottery")
  --     local Img_ChatTip = cc.uiloader:seekNodeByNameFast(activity, "Img_LotteryTip")
  --     Img_ChatTip:show()
  --     if Account.tags.activity_tag == "1" then
  --       local isShow=false
  --       lucky_profile = {}

  --       if #msg.lucky_profile>0  then
  --           --todo
  --           for i=1,#msg.lucky_profile do
  --            if msg.lucky_profile[i].status==1 then
  --                   --todo
  --                   isShow=true

  --                   local ActPos = ActivityConfig:getActPos(CONFIG_APP_CHANNEL,msg.lucky_profile[i].id)
  --                   table.insert(lucky_profile,#lucky_profile+1,ActPos)
  --                 end


  --               end
  --               if isShow then
  --                 Img_ChatTip:show()
  --               else
  --                 Img_ChatTip:hide()
  --               end

  --             end


  --           else
  --             Img_ChatTip:hide()
  --           end
  --           dump(lucky_profile, "小红点的表")
  --         end
  -- function LobbyScene:showActivityLayer()
  --           if app.constant.isOpening == true then
  --               return
  --           end
  --           sound_common.menu()

  --           local activeLayer = cc.uiloader:load("Layer/Lobby/ActivityLayer.json"):addTo(self.scene)
  --           self.scene.activeLayer = activeLayer

  --           activeLayer.popBoxNode = cc.uiloader:seekNodeByNameFast(activeLayer, "Image_bg")
  --           util.setMenuAniEx(activeLayer.popBoxNode)
  --           -- activeLayer.popBoxNode:setScale(0)
  --           -- transition.scaleTo(activeLayer.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

  --           local close = cc.uiloader:seekNodeByNameFast(activeLayer, "Button_Close"):onButtonClicked(function ()
  --             self.scene.activeLayer:removeFromParent()
  --             self.scene.activeLayer = nil
  --             sound_common:cancel()
  --             end)
  --           util.BtnScaleFun(close)

  --           close:setLocalZOrder(10)

  --           local Image_Act = cc.uiloader:seekNodeByNameFast(activeLayer, "Image_Act")
  --           --Image_Act:hide()

  --   --test url
  --         local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
  --         local urlStr = platConfig.activityImg
  --         local image = "Platform_Src/Image/active.png"

  --         util.setActivityImage(Image_Act:getParent(), urlStr, Image_Act, image, 1, nil, "activity1")


  end

  function LobbyScene:showLotteryLayer()
    sound_common.menu()
    -- local activeLayer = self:showSubLayer("Layer/Lobby/LotteryLayer.json", "Image/Lobby/Lottery/img_LotteryTitle.png")
    -- self.scene.activeLayer = activeLayer
    local activityConfig = ActivityConfig:getActConfig(CONFIG_APP_CHANNEL)

    local LuckyList = activityConfig.LuckyID

    self:showLottery(1)

  end

  function LobbyScene:RequestFromWChat()

   -- print("Lobby_RequestFromWChat:test",self.info)

   local gameid, roomid, uid, session, tableid, seatid, password

   if device.platform == "android" then
    param = json.decode(self.info)
    xmlPath = param.path

  else
    param = self.info
  end

    gameid = param.gameid
    roomid = param.roomid
    uid = param.uid
    session = param.session
    tableid = param.tableid
    seatid = param.seatid
    password = param.password
       -- print("Lobby_RequestFromWChat:",param.gameid)

       if gameid == 0 or gameid == "0" or uid == 0 or uid =="0" then

        return

      end


      local roomNid = tonumber(roomid)
      if roomNid == 0 then

        -- saveLoginfo("RequestFromWChatce------" .. uid)

        app.constant.isInvite = true

        app.constant.nChatUid = tonumber(uid)

        if  app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)

            return

          end

          print("RequestFromWChat:uid", uid)

          SetInvitation()

        else

          app.constant.isReuqestWchat = 1

          print("RequestFromWChat:", gameid, roomid, uid, session, tableid, seatid, password)

          app.constant.requestWchatInfo.session = tonumber(session)
          app.constant.requestWchatInfo.tableid = tonumber(tableid)
          app.constant.requestWchatInfo.password = password
          app.constant.requestWchatInfo.roomid = tonumber(roomid)
          app.constant.requestWchatInfo.gameid = tonumber(gameid)

          if app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)
            app.constant.isReuqestWchat = 2
            return

          end

          local scene = display.getRunningScene()

          print("RequestFromWChat:", scene.name)

          if scene.name == "LoginScene" then

            local account,password = "",""

            if self.class.accountHistory[1] then

              account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password
            end

            --saveLoginfo("account:,password:"..account.."p"..password)

            local astr = string.len(account)
            local pstr = string.len(password)

            if astr>0 and pstr>0 then

              scene:login({
                channel = app.constant.channel_game,
                account = account,
                password = password,
                })

            else

                --saveLoginfo("account:,password2222:")

                scene:loginWeixin()

              end


              elseif scene.name ~= "LobbyScene" and  scene.name ~= "RoomScene" then

                local curGameID =  app.constant.cur_GameID
                local cur_RoomID = app.constant.cur_RoomID

                if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                  app.constant.isReuqestWchat = 0

                  return

                end


                message.dispatchGame("room.LeaveGame", {})

            -- local session = msgMgr:get_room_session()
            -- message.sendMessage("game.LeaveRoomReq", {session=session})
            -- app:enterScene("LobbyScene", nil, "fade", 0.5)

            elseif scene.name == "RoomScene" then

              local curGameID =  app.constant.cur_GameID
              local cur_RoomID = app.constant.cur_RoomID

              if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                app.constant.isReuqestWchat = 3
                selectEnterGameScene()

              else

                local session = msgMgr:get_room_session()
                message.sendMessage("game.LeaveRoomReq", {session=session})
                app:enterScene("LobbyScene", nil, "fade", 0.5)

                app.constant.isReuqestWchat = 2

              end

              elseif scene.name == "LobbyScene" then

                app.constant.isReuqestWchat = 2

                setEnterScene()

         end

      end

    end

function LobbyScene:setNickandChatLogin()

  print("setNickandChatLogin--------")

  --微信头像和昵称修改消息
  local nickname = nil
  local sex = app.constant.wChatInfo.sex
  local imgId = app.constant.wChatInfo.icon
  local refresh_token = util.read_wx_refresh_token()

  if app.constant.isRelogin then

    if app.constant.isWchatLogin then
        if app.constant.isReChangeNick then
            nickname = crypt.base64encode(app.constant.wChatInfo.nick)
            print("weichat---modify---")
            self.isModifying = false
            UserMessage.ModifyUserInfoReq(sex, nickname, imgId)
            app.constant.isReChangeNick = false
        end
    else
        print("account---modify---")
        self.isModifying = false
        if Player.nickname ~= "" then

            --nickname = crypt.base64encode("text11")
            nickname = crypt.base64encode(Player.nickname)
            UserMessage.ModifyUserInfoReq(Player.sex, nickname, "")
        end
    end
    app.constant.isRelogin = false
  end

  --登录好友聊天系统
  if  app.constant.isLoginChat == false and loginFchatHandler == nil then
     print("begin---LoginChat------")
     loginYvSys()
  end

end

function LobbyScene:onEnterTransitionFinish()
      if self.handler then
          scheduler.unscheduleGlobal(self.handler)
          self.handler = nil
          self:init()

      end

      if self.scene.panel_Bg1 ~= nil and self.scene.TopBar ~= nil and self.scene.Image_BottomBar ~= nil then

          -- local game1 = cc.uiloader:seekNodeByNameFast(self.scene, string.format("Game_%d",1))
          -- local game2 = cc.uiloader:seekNodeByNameFast(self.scene, string.format("Game_%d",2))
          -- local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
          -- local game1 = cc.uiloader:seekNodeByNameFast(self.scene, platConfig.game[1].Node_Name)
          -- local game2 = cc.uiloader:seekNodeByNameFast(self.scene, platConfig.game[2].Node_Name)
          -- local Button_House1 = cc.uiloader:seekNodeByNameFast(self.scene, "Button_House1")
          -- local Button_House2 = cc.uiloader:seekNodeByNameFast(self.scene, "Button_House2")
          -- local param = {center = self.scene.panel_Bg1, centerItem = {Button_House2,Button_House1}, top = self.scene.TopBar, bottom = self.scene.Image_BottomBar, rightItem = {game1,game2}}
          -- self:TurnMenuAni(param,0)

      end

      -- scheduler.performWithDelayGlobal(function ()
       -- 判断是否第一天
      if Account.tags.activity_tag == "1" then

          self:checkShowActivity()

      end
      -- end, 1.5)

      -- MatchMessage.MatchConfigReq()
      -- MatchMessage.MatchListReq(106)

      if Account.tags.free_gold_tag == "1" then
      --申请福利消息
          UserMessage.FreeGoldQueryReq()
      end

      --util.RunHorn(nil,self,self.scene)
      local aniHandler = scheduler.performWithDelayGlobal(
      function ()
          util.RunHorn(nil,self,self.scene)
      end, 2.0)
      table.insert(aniHandlers,aniHandler)

      if Account.tags.activity_tag == "1" then
          UserMessage.LuckyProfileReq() --判断活动是否有小红点
      end
      print("LobbyScene:onEnterTransitionFinish---")



      self.LobbyRequest = scheduler.scheduleGlobal(
      function()

          if app.constant.isReuqestWchat ~= 2 then

              function callback(param)

                 self.info = param

                 self:RequestFromWChat()

              end

              if device.platform == "ios" then

                 luaoc.callStaticMethod("WeixinSDK", "loginReady", { callback = callback})

              end

          end
      end, 0.5)
   end

function LobbyScene:onExit()
    print("LobbyScene:onExit")

    --重置红点变量
    image_FRed_A = nil
    image_FRed_F = nil
    --重置变量
    curScene = nil
    panel_Apply = nil
    panel_Friend = nil
    listView_Friend = nil


    if self.codeScheduler ~= nil then
        scheduler.unscheduleGlobal(self.codeScheduler)
        self.codeScheduler = nil
    end

    if self.LobbyRequest then

        scheduler.unscheduleGlobal(self.LobbyRequest)
        self.LobbyRequest = nil

    end

    if self.leftTimeHandler then
        scheduler.unscheduleGlobal(self.leftTimeHandler)
        self.leftTimeHandler = nil
    end

    if loginFchatHandler then

        scheduler.unscheduleGlobal(loginFchatHandler)
        loginFchatHandler = nil

    end

    if self.setChatImage then

        scheduler.unscheduleGlobal(self.setChatImage)
        self.setChatImage = nil

    end

    for k,v in pairs(aniHandlers) do
        if v ~= nil then
            scheduler.unscheduleGlobal(v)
        end
    end
    aniHandlers = {}
    aniParent = {}

    -- if self.yanhuaHandler then

    --     scheduler.unscheduleGlobal(self.yanhuaHandler)
    --     self.yanhuaHandler = nil

    -- end

    if EmotionList ~= nil then

        EmotionList:removeFromParent()
        EmotionList = nil

    end
    sound_common.stop_bg()

    --比赛的界面
    self.matchListLayer = nil
    self.MatchCompetitionLayer = nil
    self.matchRankListLayer = nil
end

function LobbyScene:onCleanup()
    print("LobbyScene:onCleanup")
    util.removeImages(PreloadRes.LobbyRes)
end

function LobbyScene:showSetting()
   if app.constant.isOpening == true then
             return
   end
    sound_common.menu()
    local settingLayer = self:showSubLayer("Layer/Lobby/SettingLayer.json", "Image/Lobby/setting_title.png","setting")

    --这里没有保存声音开关到本地，每次打开app声音默认都是开着的
    local btn_music = cc.uiloader:seekNodeByNameFast(settingLayer, "Button_Music")
    local btn_voice = cc.uiloader:seekNodeByNameFast(settingLayer, "Button_Voice")
    local Image_Music = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_Music")
    local Image_Voice = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_Voice")
    local btn_changeAccount = cc.uiloader:seekNodeByNameFast(settingLayer, "Button_ChangeAccount")
    local Image_6 = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_6")
    local Image_7 = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_7")
    local Image_Vbg = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_Vbg")
    local Image_Mbg = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_Mbg")

    local Image_Pbg = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_Pbg")
    local btn_Pvoice = cc.uiloader:seekNodeByNameFast(settingLayer, "Button_PVoice")
    local Image_Voice_0 = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_Voice_0")
    local Image_8 = cc.uiloader:seekNodeByNameFast(settingLayer, "Image_8")

    cc.uiloader:seekNodeByNameFast(settingLayer, "Image_1"):setLayoutSize(805, 495)

     app.constant.femaleOn = Player.sex

    local function updateState()
          if app.constant.musicOn then
            --btn_music:setPosition(154,65)

            Image_6:setPosition(36.00,138.81)
            Image_Music:setPosition(130.41,138.81)
            Image_Music:setTexture("Image/Lobby/img_Off_1.png")

            Image_Mbg:setTexture("Image/Lobby/img_yellow.png")

          else

            Image_6:setPosition(166.74,138.81)
            Image_Music:setPosition(73.31,138.81)
            Image_Music:setTexture("Image/Lobby/img_On_0.png")

            Image_Mbg:setTexture("Image/Lobby/img_blue.png")
          end

          if app.constant.voiceOn then

            Image_7:setPosition(36.00,38.75)
            Image_Voice:setPosition(130.41,38.75)
            Image_Voice:setTexture("Image/Lobby/img_Off_1.png")

            Image_Vbg:setTexture("Image/Lobby/img_yellow.png")

          else

            Image_7:setPosition(166.74,38.75)
            Image_Voice:setPosition(73.31,38.75)
            Image_Voice:setTexture("Image/Lobby/img_On_0.png")

            Image_Vbg:setTexture("Image/Lobby/img_blue.png")

          end
      end

      local function updatePeopleVoice()

            if app.constant.femaleOn == 1 then

              Image_8:setPosition(36.00,-58.77)
              Image_Voice_0:setPosition(128.65,-58.77)
              Image_Voice_0:setTexture("Image/Lobby/img_MaleVoice.png")

              Image_Pbg:setTexture("Image/Lobby/img_blue.png")

            else

              Image_8:setPosition(166.74,-58.77)
              Image_Voice_0:setPosition(76.31,-58.77)
              Image_Voice_0:setTexture("Image/Lobby/img_FemaleVoice.png")

              Image_Pbg:setTexture("Image/Lobby/img_blue.png")

             end
      end

      btn_music:onButtonClicked(
        function (event)
            app.constant.musicOn = not app.constant.musicOn
            updateState()
            util.GameStateSave("musicOn",app.constant.musicOn)
            sound_common.setMusicState(app.constant.musicOn)
            if not app.constant.musicOn then
              sound_common.stop_bg()
            else
              sound_common.bg()
            end
        end)
      btn_voice:onButtonClicked(
        function (event)
            app.constant.voiceOn = not app.constant.voiceOn
            updateState()
            util.GameStateSave("voiceOn",app.constant.voiceOn)
            sound_common.setVoiceState(app.constant.voiceOn)
            sound_common.setVoiceState(app.constant.voiceOn)
        end)
      updateState()

      btn_Pvoice:onButtonClicked(
        function (event)
            if app.constant.femaleOn == 1 then
                app.constant.femaleOn = 2
            else
                app.constant.femaleOn = 1
            end
            updatePeopleVoice()

        end)
      updatePeopleVoice()

      btn_changeAccount:onButtonClicked(
      function (event)
          local changeAccountLayer = cc.uiloader:load("Layer/Lobby/ChangeAccount.json"):addTo(self.scene)
          local cancel = cc.uiloader:seekNodeByNameFast(changeAccountLayer, "Button_Cancel")
          :onButtonClicked(
          function ()
              sound_common.cancel()
              changeAccountLayer:removeFromParent()
          end)

          local confirm = cc.uiloader:seekNodeByNameFast(changeAccountLayer, "Button_Confirm")
          :onButtonClicked(
          function ()
              sound_common.confirm()
              --exit chatmenu
              self:LogOutChat()

              --退出云娃系统
              self:LogOutYvSys()

              app.constant.isLoginGame = false

              app.constant.autoLogin = false

              app.constant.isturn = true

              app.constant.isWchatLogin = false

              --抹掉refresh_token
              util.write_wx_refresh_token()

              app:enterScene("LoginScene", nil, "fade", 0.5)
              GateNet.disconnect()
          end)

          util.BtnScaleFun(cancel, 0.69)

          util.BtnScaleFun(confirm, 0.69)
      end)

      util.BtnScaleFun(btn_changeAccount)

      end

    function LobbyScene:showNoticeBox()
        print("showNoticeBox")
        sound_common.menu()
        local noticeLayer = self:showSubLayer("Layer/Lobby/NoticeLayer.json", "Image/Lobby/notice_title.png")

        --modify by whb 0324
        local Text_1 = cc.uiloader:seekNodeByNameFast(noticeLayer, "Text_1")
        local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
        Text_1:setString(platConfig.noticeLayer_Text_1)
        --modify end

        local scrollView = cc.uiloader:seekNodeByNameFast(noticeLayer, "ScrollView")
        local scrollNode = scrollView:getScrollNode()
        scrollNode:removeAllChildren()

        local localNoticeValue = app.userdata.Player.noticeInfosEx

        local noticeNum = 0
        --记录最后一条信息label y坐标
        local last_y = 340
        dump(localNoticeValue)
        for i = #localNoticeValue,1,-1 do
          noticeNum = noticeNum + 1
          local content,line_num = util.stringFormat(tostring(#localNoticeValue - i + 1) .. "、" .. localNoticeValue[i].content,87)
          local label_notice = cc.ui.UILabel.new({
            text = tostring(content),
            size = 24,
            color = cc.c3b(171, 96, 58),
            align = cc.ui.TEXT_ALIGN_LEFT
            })
          label_notice:addTo(scrollNode)
          label_notice:setAnchorPoint(0,0)
          last_y = last_y - label_notice:getContentSize().height - 10
          label_notice:setPosition(cc.p(10,last_y))

        --最多显示5条公告
        if noticeNum >= 5 then break end
      end
    end

    function LobbyScene:setBurthenMark()
      for _,config in ipairs(RoomConfig) do
        local gameid = config.gameid
        local players = 0
        local maxPlayers = 0
        for _,room in ipairs(config.room) do
          players = players + (room.players or 0)
          maxPlayers = maxPlayers + (room.maxRoomPlayer or room.tables * room.seats * 2)
        end

        print("setBurthenMark:players,maxPlayers",players,maxPlayers)

        local name = PreloadRes.LobbyResName.BurthenMark
        local burthenFrame
        if players <= maxPlayers / 5 then
          burthenFrame = util.getSpriteFrameFromCache(name, PreloadRes.LobbyRes[name], 1)
          elseif players <= maxPlayers  / 2 then
            burthenFrame = util.getSpriteFrameFromCache(name, PreloadRes.LobbyRes[name], 2)
          else
            burthenFrame = util.getSpriteFrameFromCache(name, PreloadRes.LobbyRes[name], 3)
          end

          local game = cc.uiloader:seekNodeByNameFast(self.scene, config.icon);
          if game then
            local burthenPanel = cc.uiloader:seekNodeByNameFast(game, "BurthenPanel");
            if burthenPanel and burthenFrame then
              local node = display.newSprite(burthenFrame):addTo(burthenPanel)
              :setPosition(0, 0)
              node:setAnchorPoint(cc.p(0, 0))
            end
          end
        end
      end

      function LobbyScene:setPopularityMark()
        for _,config in ipairs(RoomConfig) do
          local game = cc.uiloader:seekNodeByNameFast(self.scene, config.icon);
          if game then
            local name = PreloadRes.LobbyResName.PopularityMark
            popularityFram = util.getSpriteFrameFromCache(name, PreloadRes.LobbyRes[name], config.popular)
            local PopularityPanel = cc.uiloader:seekNodeByNameFast(game, "PopularityPanel");
            if PopularityPanel then
              local node = display.newSprite(popularityFram):addTo(PopularityPanel)
              :setPosition(0, 0)
              node:setAnchorPoint(cc.p(0, 0))
            end
          end
        end
      end

  function LobbyScene:changeAvatar()
    --modify by whb 161028
    local image = AvatarConfig:getAvatar(Player.sex, Player.gold, Player.viptype)
    if self.scene.avatar.images_[cc.ui.UIPushButton.NORMAL] == image then
      return
    end

   local size = self.scene.avatar.scale9Size_

   if app.constant.isWchatLogin then

    if app.constant.wChatInfo.icon then

      local url = app.constant.wChatInfo.icon
            --print("changeAvatar-oldImage:",image)
            local subUrl = string.sub(url,1,-2)
            local url = subUrl .. 132
            print("newUrl:",url)
            local UserInfoBar = cc.uiloader:seekNodeByNameFast(self.scene, "UserInfoBar")
            local icontest = NetSprite.new(url,image, self.scene.avatar_bg):addTo(UserInfoBar,30000)

            local sizeImg = icontest:getContentSize()

            --print("sizeImg11--:", sizeImg.width, sizeImg.height)
            icontest:setPosition(self.scene.avatar_bg:getPosition())
            icontest:setScale(70/sizeImg.width,70/sizeImg.height)

            self.scene.avatar:setOpacity(0)
            self.scene.avatar_bg:hide()

      else

            self.scene.avatar_bg:hide()

            self.scene.avatar:setButtonImage(cc.ui.UIPushButton.NORMAL, image)
            self.scene.avatar:setButtonImage(cc.ui.UIPushButton.PRESSED, image)
            self.scene.avatar:setButtonImage(cc.ui.UIPushButton.DISABLED, image)
            self.scene.avatar:setButtonSize(size[1], size[2])
      end
    else

        self.scene.avatar_bg:hide()
        self.scene.avatar:setButtonImage(cc.ui.UIPushButton.NORMAL, image)
        self.scene.avatar:setButtonImage(cc.ui.UIPushButton.PRESSED, image)
        self.scene.avatar:setButtonImage(cc.ui.UIPushButton.DISABLED, image)
        self.scene.avatar:setButtonSize(size[1], size[2])

    end

  end

    function LobbyScene:moneyChanged()

      print("moneyChanged---")
      self:updateGoldAndDiamond()
      self:changeAvatar()
    end

    function LobbyScene:sexChanged()
      self:changeAvatar()
    end

    function LobbyScene:nicknameChanged()
        local nname = util.checkNickName(Player.nickname)
        print("LobbyScene:nicknameChanged,",Player.nickname)
        self.scene.nickname:setString(nname)

        if self.scene.uid ~= nil then

          self.scene.uid:setString(Player.uid)

        end
        --modify by whb 161028
        if app.constant.isWchatLogin == false then

          if Player.viptype > 0 then
            self.scene.nickname:setColor(cc.c3b(255, 0, 0))
          else
            self.scene.nickname:setColor(cc.c3b(43, 255, 194))
          end

        end

        --modify end
    end

function LobbyScene:showActivity(checkbox)

    if self.scene.activeLayer and self.scene.activeLayer:getChildByTag(1001) then
      self.scene.activeLayer:removeChildByTag(1001)
    end

    local index = checkbox.index
    local activityConfig = ActivityConfig:getActConfig(CONFIG_APP_CHANNEL)
    -- local act_num = platConfig.act[2]
    if checkbox.Lucky then
      if index then
        self:showLottery(index)
      else
        self:showLottery(1)
      end
    else
        --todo
        local act_img = string.format(activityConfig.image,index)
        print("act_img:", act_img)
        local act_sprite = display.newSprite(act_img)
        :setTag(1001)
        :pos(756,310)
        :addTo(self.scene.activeLayer)
    end

  end

  function LobbyScene:showShare()
    Share.createLobbyShareLayer():addTo(self,10)
  end

  function LobbyScene:showSubLayer(layerRes, title, layername)
    local subLayer = cc.uiloader:load(layerRes):addTo(self.scene)

    local popBoxNode = cc.uiloader:seekNodeByNameFast(subLayer, "PopBoxNode")
    -- popBoxNode:setScale(0)
    -- transition.scaleTo(popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

    util.setMenuAniEx(popBoxNode)

    local title_sprite = cc.uiloader:seekNodeByNameFast(subLayer, "Image_Title")
    local s = display.newSprite(title)
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

    local close = cc.uiloader:seekNodeByNameFast(subLayer, "Close")
    :onButtonClicked(function ()
      sound_common.cancel()
      subLayer:removeFromParent()
      subLayer = nil
      sound_common.cancel()
            --add by whb 0914
            self:addGuideLayer(guideInfo.guideMenu[1])
            curActIndex = 1
            if layername == "richLayer" then
                self.scene.richLayer = nil
            elseif layername == "setting" then
                if app.constant.femaleOn ~= Player.sex then
                    local sex = app.constant.femaleOn
                    print("setting-sex = ",sex)
                    UserMessage.ModifyUserInfoReq(sex)
                end
            end
      end)

    util.BtnScaleFun(close)

    return subLayer
  end

  function LobbyScene:showPromote()
    local promoteLayer = self:showSubLayer("Layer/Lobby/PromoteLayer.json", app.lang.promote)
    --test
    local isBinded = false
    if isBinded then
      cc.uiloader:seekNodeByNameFast(promoteLayer, "Image_Text_2")
      :show()
      cc.uiloader:seekNodeByNameFast(promoteLayer, "Button_Share")
      :show()
      :onButtonClicked(function ()
            --share
            promoteLayer:removeFromParent()
            self:showShare()
            end)
      cc.uiloader:seekNodeByNameFast(promoteLayer, "Button_Exchange")
      :show()
      :onButtonClicked(function ()
            --exchange
            promoteLayer:removeFromParent()
            self:showHonor()
            end)
      local textHonor = cc.uiloader:seekNodeByNameFast(promoteLayer, "Text_1")
      textHonor:show()
      textHonor:setString(tostring(checkint(Player.honor)))
    else
      cc.uiloader:seekNodeByNameFast(promoteLayer, "Image_Text_1")
      :show()
      local inputPanel = cc.uiloader:seekNodeByNameFast(promoteLayer, "Panel_Input_1")
      local input = util.createInput(inputPanel)
      inputPanel:show()
      input:setString(app.lang.honor_input)
      input:setTextColor(cc.c4b(255,255,255,255))
      input:addEventListener(function(editbox, eventType)
        print("type:"..eventType)
        if eventType == 0 then
          editbox:setString("")
          elseif eventType == 1 then
                --editbox:setString(app.lang.honor_input)
              end
              end)
      cc.uiloader:seekNodeByNameFast(promoteLayer, "Button_Confirm")
      :show()
      :onButtonClicked(function ()
            --confirm
            local honorNum = input:getString()
            print("honor:"..honorNum)
            end)
    end
  end

  function LobbyScene:RankingListRep(msg)
    print("LobbyScene:RankingListRep")

    self:closeProgressLayer()

    if self.scene.richLayer  ~= nil then

      local ranklist = cc.uiloader:seekNodeByNameFast(self.scene.richLayer, "ListView_RIchRank")

      ranklist:removeAllItems()

      for _,v in pairs(msg.ranking_list) do

            --print("ranking_list:uid = " .. v.uid,"v.rank = " .. v.rank,"v.nickname = " .. v.nickname,"v.gold = " .. v.gold, "v.imageid = " .. v.imageid, "v.sex = " .. v.sex, "v.viptype = " .. v.viptype)

            local listItemLayout = ranklist:newItem()

            local oneItem = cc.uiloader:load("Node/RichRank_Item.json")

            local text_Nick = cc.uiloader:seekNodeByNameFast( oneItem, "Text_Nick")
            text_Nick:setString(util.checkNickName(v.nickname))

            local id_Value = cc.uiloader:seekNodeByNameFast( oneItem, "Text_Money")
            id_Value:setString(v.gold)


            local icon = AvatarConfig:getAvatar(v.sex, v.gold, v.viptype)

            local sprite_Head = cc.uiloader:seekNodeByNameFast( oneItem, "Sprite_Head")
            rect = cc.rect(0, 0, 188, 188)
            frame = cc.SpriteFrame:create(icon, rect)
            sprite_Head:setSpriteFrame(frame)

            local Sprite_sbg = cc.uiloader:seekNodeByNameFast( oneItem, "Sprite_sbg")
                -- rect2 = cc.rect(0, 0, 105, 105)
                -- -- local iconBg = AvatarConfig:getBgByRolesUrl(icon)
                --  local iconBg = AvatarConfig:getAvatarBG(v.sex, v.gold, v.viptype,0)
                --  frame2 = cc.SpriteFrame:create(iconBg, rect2)
                --  Sprite_sbg:setSpriteFrame(frame2)
                Sprite_sbg:hide()

                util.setHeadImage(sprite_Head:getParent(), v.imageid, sprite_Head, icon, 2)

                if v.imageid ~= nil and v.imageid ~= "" then

                 Sprite_sbg:hide()
                    -- Sprite_sbg:setTexture("Image/Common/Avatar/img_iconK.png")

                  end

                  local Atlas_RichRank = cc.uiloader:seekNodeByNameFast( oneItem, "Atlas_RichRank")
                  Atlas_RichRank:setString(v.rank .. "")

                  local Image_rankImg = cc.uiloader:seekNodeByNameFast( oneItem, "Image_rankImg")
                  local Image_RankBg = cc.uiloader:seekNodeByNameFast( oneItem, "Image_RankBg")

                  if v.rank > 3 then

                    Image_rankImg:hide()
                    Image_RankBg:show()

                  else

                    Image_rankImg:show()
                    Image_RankBg:hide()

                    Image_rankImg:setTexture("Image/Lobby/richrank/img_RN" .. v.rank .. ".png")

                  end


                  print("oneitem-:", oneItem)

                  listItemLayout:addContent(oneItem)

                  listItemLayout:setAnchorPoint(0,0.5)

                  listItemLayout:setItemSize(832, 121)

                  ranklist:addItem(listItemLayout)

                end

                ranklist:reload()

              end

            end


            function LobbyScene:showRichRank()


              local richLayer = self:showSubLayer("Layer/Lobby/RichRankLayer.json", "Image/Lobby/richrank/img_RichText.png", "richLayer")

              self.scene.richLayer = richLayer

              local ranklist = cc.uiloader:seekNodeByNameFast(richLayer, "ListView_RIchRank")

              if ranklist ~= nil then

               ProgressLayer.new(app.lang.default_loading):addTo(self, nil, progressTag)

               UserMessage.RankingListReq()

             end


           end


  function LobbyScene:showHonor()
    --dump(Player)
    local honorLayer = self:showSubLayer("Layer/Lobby/HonorLayer.json", "Image/HonorLayer/honor_title.png")

    print("player:honor:", Player.honor)
    self.scene.honorValue = cc.uiloader:seekNodeByNameFast(honorLayer, "HonorValue")
    :setString(tostring(util.num2str_text(checkint(Player.honor))))

    self.scene.honorLayer = honorLayer
    self.scene.btnBind = cc.uiloader:seekNodeByNameFast(honorLayer, "Button_Bind")
    self.scene.btnBind:onButtonClicked(function ()
      self:showBind()
      end)

    self.scene.text_bindId = cc.uiloader:seekNodeByNameFast(honorLayer, "Bind_Value")

    self:updateBindInfo()

     --add by whb 0918
     print("showHonor:------")
     self:closeGuideLayer("guide_Honor")

     local scrollView = cc.uiloader:seekNodeByNameFast(honorLayer, "ScrollView")
     local scrollNode = scrollView:getScrollNode()
     scrollNode:removeAllChildren()

     local function createItem(index)
      local bg = display.newSprite(PreloadRes.HonorResName.HonorBg)
      bg:addTo(scrollNode)
      bg:setPosition(cc.p(120 + math.mod(index,4) * 200,260 - math.floor(index / 4) * 250))

      local img_name_y = 0
      local text_name
      local text_name_color
      local text_honor
      local text_value
      local text_value_color
      local btn_normal
      local btn_pressed
      local btn_disabled
      if index == 0 then
        text_name = PreloadRes.HonorResName.exchange_name
        img_name_y = 15
        text_name_color = cc.c3b(255,8,1)
        text_honor = "兑奖比例"
        text_value = "1荣誉值=1旺豆"
        text_value_color = cc.c3b(255,8,1)

        btn_normal = "Image/HonorLayer/exchange_0.png"
        btn_pressed = "Image/HonorLayer/exchange_1.png"
        btn_disabled = "Image/HonorLayer/exchange_2.png"
      else
        text_name = PreloadRes.HonorRes[index].name
        text_name_color = cc.c3b(171,96,58)
        text_honor = "荣誉值"
        text_value = tostring(PreloadRes.HonorRes[index].value)
        text_value_color = cc.c3b(255,255,255)

        btn_normal = "Image/HonorLayer/exchange_yellow_0.png"
        btn_pressed = "Image/HonorLayer/exchange_yellow_1.png"
        btn_disabled = "Image/HonorLayer/exchange_2.png"
      end

      local img_Name = display.newSprite("Image/HonorLayer/item/" .. index .. ".png")
      img_Name:addTo(bg)
      img_Name:setPosition(96,140 + img_name_y)

      local label_Name = cc.ui.UILabel.new({text = text_name, size = 22, color = text_name_color})
      label_Name:addTo(bg)
      label_Name:setAnchorPoint(0.5,0.5)
      label_Name:setPosition(96,200)

      if index ~= 0 then
        display.newSprite("Image/HonorLayer/item_num_bg.png")
        :addTo(bg)
        :setPosition(96,75)
      end

      local label_honor = cc.ui.UILabel.new({text = text_honor, size = 12, color = cc.c3b(171,96,58)})
      label_honor:addTo(bg)
      label_honor:setAnchorPoint(0.5,0.5)
      label_honor:setPosition(96,95)

      local label_Value = cc.ui.UILabel.new({text = text_value, size = 16, color = text_value_color})
      label_Value:addTo(bg)
      label_Value:setAnchorPoint(0.5,0.5)
      label_Value:setPosition(96,75)

      local btn_exchange = cc.ui.UIPushButton.new({
        normal = btn_normal,
        pressed = btn_pressed,
        disabled = btn_disabled,
        }, {
        scale9 = true
        })
      :onButtonClicked(
      function ()
          if index == 0 then
            self:showExchangeMenu()
          else

          if CONFIG_APP_CHANNEL == "3551" then

            ErrorLayer.new("请联系客服，微信公众号wwcixi", nil, nil, nil):addTo(self)

            elseif CONFIG_APP_CHANNEL == "3550" then

              ErrorLayer.new("请联系客服，微信公众号wwyuyao", nil, nil, nil):addTo(self)

            end
          end
      end)
      :addTo(bg)
      :setPosition(96,40)

    end

    createItem(0)

    for i = 1, #PreloadRes.HonorRes do
      createItem(i)
    end

  end

  function LobbyScene:updateBindInfo()
    -- body
    print("supid:"..Player.supid)
    if Player.supid == -2 then
      self.scene.text_bindId:setString(app.lang.bind_topest)
      self.scene.btnBind:setVisible(false)
      elseif Player.supid ~= -1 then
        self.scene.text_bindId:setString(tostring(Player.supid))
        self.scene.btnBind:setVisible(false)
      end
    end

   function LobbyScene:showBind()

    --add by whb 0919
    self:closeGuideLayer("guide_Bind")
    --add end
    self.scene.bindLayer = cc.uiloader:load("Layer/Lobby/BindLayer.json"):addTo(self.scene)

    local popBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "PopBoxNode")
    popBoxNode:setScale(0)
    transition.scaleTo(popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

    -- cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Title")
    --     :setString(app.lang.bind)

    local title = cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/HonorLayer/bind_title.png",cc.rect(0,0,210,45))
    title:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Close")
    :onButtonClicked(function ()
      sound_common.cancel()
      self.scene.bindLayer:removeFromParent()
      self.scene.bindLayer = nil
      end)

    --self.scene.bindLayer = self:showSubLayer("Layer/Lobby/BindLayer.json", app.lang.bind)

    local inputPanel = cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Panel_Input_1")
    print("1:"..type(inputPanel))
    local input = util.createInput(inputPanel)
    print("2:"..type(input))
    --input:setString(app.lang.honor_input)
    --input:setPlaceholderFontColor(cc.c3b(255,255,255))
    input:addEventListener(function(editbox, eventType)
      print("type:"..eventType)
        -- if eventType == 0 then
        --     editbox:setString("")
        -- elseif eventType == 1 then
        --     editbox:setString(app.lang.honor_input)
        -- end
        end)
    self.scene.bindLayer.text_nickname = cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Text_NameValue")
    cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Button_GetName")
    :onButtonClicked(function ()
        --self:disableSafeBoxInputTouch()
        --confirm
        local userid = input:getString()
        print("userid:"..userid)

        local id = math.floor(checknumber(input:getString()))
        if id == 0 then
          ErrorLayer.new(app.lang.give_gold_nickname_nil, nil, nil, nil):addTo(self)
          elseif id == Player.uid then
            ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
          else
            ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
            :addTo(self,nil,progressTag)
            UserMessage.UserInfoRequest(id)
          end
          end)

    cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Button_Confirm")
    :onButtonClicked(function ()
        --confirm
        local userid = input:getString()
        print("userid:"..userid)
        --send request

        if self.scene.bindLayer.text_nickname:getString() == "" then
          ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, nil):addTo(self)
          return
        end

        local id = math.floor(checknumber(input:getString()))
        if id == 0 then
          ErrorLayer.new(app.lang.give_gold_nickname_nil, nil, nil, nil):addTo(self)
          elseif id == Player.uid then
            ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
          else
            ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
            :addTo(self,nil,progressTag)
            self.bindId = id
            UserMessage.BindUserReq(id)
          end
          end)

    cc.uiloader:seekNodeByNameFast(self.scene.bindLayer, "Button_Cancel")
    :onButtonClicked(function ()

      self.scene.bindLayer:removeFromParent()
      self.scene.bindLayer = nil

      end)
  end

--get nickname resp
function LobbyScene:onBindGetNameResp(msg)
    -- body
    if CONFIG_APP_CHANNEL ~= "3550" and CONFIG_APP_CHANNEL ~= "3551" then
      local layer = self.scene.bindLayer
      if layer and layer.text_nickname then
        self:closeProgressLayer()
        if msg.uid ~= 0 then
          print("111nName:" .. msg.nickname)
          local otherName = crypt.base64decode(msg.nickname)
          print("otherName:" .. otherName)
          layer.text_nickname:setString(util.checkNickName(otherName))
        else
          layer.text_nickname:setString(app.lang.nickname_notfound)
        end
      end
    else
      local layer = self.scene.rechargeLayer
      if layer and layer.text_nickname then
        local progressLayer = self:getChildByTag(3462)
        if progressLayer then
          print("移除加载")
          ProgressLayer.removeProgressLayer(progressLayer)
        end
        if msg.uid ~= 0 then
          print("111nName:" .. msg.nickname)
          local otherName = crypt.base64decode(msg.nickname)
          print("otherName:" .. otherName)
          layer.text_nickname:setString(util.checkNickName(otherName))
        else
          layer.text_nickname:setString(app.lang.nickname_notfound)
        end
      end
    end

  end

--bind honor resp
function LobbyScene:BindUserRepEx(msg)
  if CONFIG_APP_CHANNEL ~= "3550" and CONFIG_APP_CHANNEL ~= "3551" then
          local layer = self.scene.bindLayer
          if layer then
              self:closeProgressLayer()
              print("result:"..msg.result)
              -- 0成功; 1重复绑定; 其他：id无法绑定
              if msg.result == 0 then     --success
              self.scene.bindLayer:removeFromParent()
              self.scene.bindLayer = nil

              Player.supid = self.bindId
              self:updateBindInfo()
              elseif msg.result == 1 then
              ErrorLayer.new(app.lang.bind_error_1, nil, nil, nil):addTo(self)
              elseif msg.result == 2 then
              ErrorLayer.new(app.lang.bind_error_2, nil, nil, nil):addTo(self)
              elseif msg.result == 3 then
              ErrorLayer.new(app.lang.bind_error_3, nil, nil, nil):addTo(self)
              elseif msg.result == 4 then
              ErrorLayer.new(app.lang.bind_error_4, nil, nil, nil):addTo(self)
              elseif msg.result == 5 then
              ErrorLayer.new(app.lang.bind_error_5, nil, nil, nil):addTo(self)
              else
              ErrorLayer.new(app.lang.bind_error, nil, nil, nil):addTo(self)
              end
          end
  else
              local layer = self.scene.rechargeLayer
              if layer then
                 local progressLayer = self:getChildByTag(3463)
                 if progressLayer then
                    print("移除加载")
                    ProgressLayer.removeProgressLayer(progressLayer)
                 end
                    print("result:"..msg.result)
              -- 0成功; 1重复绑定; 其他：id无法绑定
                  if msg.result == 0 then     --success
                    layer.goodsList:removeFromParent()
                    layer.goodsList = nil

                    Player.supid = self.bindId
                    self:BindingSucceed()

                    elseif msg.result == 1 then
                    ErrorLayer.new(app.lang.bind_error_1, nil, nil, nil):addTo(self)
                    elseif msg.result == 2 then
                    ErrorLayer.new(app.lang.bind_error_2, nil, nil, nil):addTo(self)
                    elseif msg.result == 3 then
                    ErrorLayer.new(app.lang.bind_error_3, nil, nil, nil):addTo(self)
                    elseif msg.result == 4 then
                    ErrorLayer.new(app.lang.bind_error_4, nil, nil, nil):addTo(self)
                    elseif msg.result == 5 then
                    ErrorLayer.new(app.lang.bind_error_5, nil, nil, nil):addTo(self)
                    else
                    ErrorLayer.new(app.lang.bind_error, nil, nil, nil):addTo(self)
                  end
              end
    end
  end

  function LobbyScene:closeProgressLayer()

    local progressLayer = self:getChildByTag(progressTag)
    if progressLayer then
      print("移除加载")
      ProgressLayer.removeProgressLayer(progressLayer)
    end
  end





-- ---------------------------------------------下面是比赛相关的方法----------------------------------------

-- --[[ --
-- 	* 显示比赛房间List界面
-- 	@param int		gameId			游戏ID
-- --]]
-- function LobbyScene:showMatchRoomList(gameId)
-- 	--比赛房间列表界面
-- 	local matchListLayer = cc.uiloader:load("Layer/Lobby/MatchListLayer.json"):addTo(self.scene)

-- 	--滚动scrillView 列表
-- 	local list = cc.uiloader:seekNodeByNameFast(matchListLayer, "List")
-- 	self.scene.scrollNode = list:getScrollNode()
-- 	self.scene.scrollNode:removeAllChildren()

-- 	--房间配置
-- 	local config = RoomConfig:getGameConfig(gameId)
-- 	assert(config)

-- 	--标题
-- 	local title = config.name .. "比赛房" or ""
-- 	cc.uiloader:seekNodeByNameFast(matchListLayer, "Title")
-- 	:setString(title)

-- 	--关闭按钮
-- 	cc.uiloader:seekNodeByNameFast(matchListLayer, "Close")
-- 	:onButtonClicked(function ()
-- 		sound_common.cancel()
-- 		matchListLayer:removeFromParent()
-- 		matchListLayer = nil

-- 		--关闭某某定时器
-- 		if self.leftTimeHandler then
-- 			scheduler.unscheduleGlobal(self.leftTimeHandler)
-- 					self.leftTimeHandler = nil
-- 		end
-- 	end)

-- end

-- --[[ --
-- 	* 显示比赛列表
-- 	@param table		msg			比赛列表数据
-- 	@param table		oldMsg		发送请求的数据
-- --]]
-- function LobbyScene:MatchListRep(msg,oldMsg)
--     print("LobbyScene:MatchListRep")

--     local config = RoomConfig:getGameConfig(oldMsg.gameid)
--     assert(config)
--     dump(config)

-- 	--断线重连
--     if config.matchroom then
-- 		for i = 1,#config.matchroom do
-- 			for k,v in pairs(msg.matches) do
-- 				if v.matchid == config.matchroom[i].matchid then
-- 					if v.online then
-- 						MatchMessage.EnterMatchReq(v.matchid,true)
-- 						return
-- 					end
-- 				end
-- 			end
-- 		end
--     end

-- 	--显示比赛房间List界面
--     self:showMatchRoomList(oldMsg.gameid)

--     --名字太长，换行显示
--     local function matchNameFormat(name)
--       	return util.stringFormat(name,32)
--     end

--     --奖品太长，换行显示
--     local function prizeFormat(name)
--       	return util.stringFormat(name,39)
--     end

-- 	if config.matchroom then
-- 		self.scene.matchItem = {}

-- 		--星期
-- 		local week = os.date("%w",os.time())
-- 		print("week:",week)

-- 		--循环比赛房间
-- 		for i = 1,#config.matchroom do
-- 			local mroom = config.matchroom[i]					--比赛配置
-- 			local invisible = mroom.invisible					--nil
-- 			local matchid = msg.matchid							--比赛ID	0
-- 			local itemMatchid = config.matchroom[i].matchid
-- 			print("matchid:",matchid)
-- 			print("itemMatchid:",itemMatchid)

-- 			--添加比赛通知
-- 			-- if invisible == nil or invisible ~= 1 then
-- 			--      self:addMatchNotication(mroom)
-- 			-- end

-- 			if itemMatchid ~= 20602 or (itemMatchid == 20602 or week == 6) then
-- 				if matchid ~= nil and matchid>0 and mroom.matchid == matchid then
-- 					--Item
-- 					local item = cc.uiloader:load("Node/MatchItem.json")
-- 						:addTo(self.scene.scrollNode)
-- 					item:setPosition(cc.p(20,300 - 120))
-- 					item.matchId = mroom.matchid
-- 					self.scene.matchItem[i] = item

-- 					--比赛时间
-- 					local hour = string.format("%02d",mroom.startHour)
-- 					local minute = string.format("%02d",mroom.startMinute)
-- 					local strtime = hour .. ":" .. minute
-- 					cc.uiloader:seekNodeByNameFast(item, "Text_StartTime")
-- 						:setString(strtime)

-- 					--比赛图标
-- 					local frameName = mroom.icon
-- 					dump(mroom)
-- 					print("111frameName:"..frameName)
-- 					local icon = cc.uiloader:seekNodeByNameFast(item, "Image_Icon")
-- 					icon:setSpriteFrame(cc.SpriteFrame:create("Image/Match/" .. frameName, cc.rect(0,0,113, 113)))

-- 					--比赛房名字
-- 					local name = mroom.name
-- 					local len = string.len(name)
-- 					print("name len:" .. len)
-- 					name = matchNameFormat(name)
-- 					cc.uiloader:seekNodeByNameFast(item, "Text_MatchTitle")
-- 						:setString(name)

-- 					--参加金额
-- 					local fee = mroom.fee
-- 					if not fee  then
-- 						fee = "免费"
-- 					else
-- 						fee = mroom.fee.display
-- 					end
-- 					if mroom.matchid == 20801 then
-- 						fee = fee
-- 					elseif mroom.matchid == 20802 then
-- 						fee = fee
-- 					end
-- 					cc.uiloader:seekNodeByNameFast(item, "Text_ConstValue")
-- 					:setString(fee)

-- 					--比赛奖品
-- 					local rewards = mroom.rewards
-- 					for i = 1,3 do
-- 						local rstart = rewards[i].startRank
-- 						local rend = rewards[i].endRank

-- 						local rank
-- 						if rstart == rend then
-- 							rank = "第"..rstart .. "名:"
-- 						else
-- 							rank = "第"..rstart .. "~" .. rend .. "名:"
-- 						end

-- 						local str = rank .. rewards[i].name
-- 						str = prizeFormat(str)
-- 						cc.uiloader:seekNodeByNameFast(item, string.format("Text_Prize_%d",i))
-- 							:setString(str)
-- 					end

-- 					print("2222matchid:", matchid)

-- 					--比赛状态按钮显示
-- 					local state = 1
-- 					for k,v in pairs(msg.matches) do
-- 						if v.matchid == config.matchroom[i].matchid then

-- 							state = v.status				--比赛状态
-- 							item.state = state				--比赛状态
-- 							local isSignup = v.signup		--是否报名过比赛

-- 							--进入比赛按钮
-- 							cc.uiloader:seekNodeByNameFast(item, "Button_Enter")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("enter")
-- 									MatchMessage.EnterMatchReq(v.matchid,false)
-- 								end)

-- 							--退出比赛按钮
-- 							cc.uiloader:seekNodeByNameFast(item, "Button_Exit")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("exit")
-- 									MatchMessage.MatchSignupReq(2,v.matchid)
-- 								end)

-- 							--报名比赛按钮
-- 							cc.uiloader:seekNodeByNameFast(item, "Button_Signup")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("signup")
-- 									MatchMessage.MatchSignupReq(1,v.matchid)
-- 								end)

-- 							--比赛进行中按钮
-- 							cc.uiloader:seekNodeByNameFast(item, "Button_Playing")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("playing")
-- 								end)

-- 							--报名按钮
-- 							cc.uiloader:seekNodeByNameFast(item, "Button_Rank")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("end")
-- 									self:showMatchRankList(v.matchid)
-- 								end)

-- 							--已取消按钮
-- 							cc.uiloader:seekNodeByNameFast(item, "Button_Cancel")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("end")
-- 									--self:showMatchRankList(matchId)
-- 								end)

-- 							--刷新按钮状态
-- 							self:updateMatchState(v.matchid, state, isSignup)
-- 						end
-- 					end

-- 					--比赛倒计时
-- 					item.labelLeftTime = cc.uiloader:seekNodeByNameFast(item, "Text_LeftTime")
-- 					local startTime = {}
-- 					startTime.startHour = mroom.startHour
-- 					startTime.startMinute = mroom.startMinute
-- 					item.startTime = startTime		--比赛开始时间
-- 				elseif matchid == nil or matchid == 0 then
-- 					if invisible == nil or invisible ~= 1 then
-- 						print("444444:", matchid)

-- 						--Item
-- 						local item = cc.uiloader:load("Node/MatchItem.json")
-- 							:addTo(self.scene.scrollNode)
-- 						item:setPosition(cc.p(20,300 - 120 - (i - 1) * 160))
-- 						item.matchId = mroom.matchid
-- 						self.scene.matchItem[i] = item

-- 						--比赛图标
-- 						local frameName = mroom.icon
-- 						dump(mroom)
-- 						print("frameName:"..frameName)
-- 						local icon = cc.uiloader:seekNodeByNameFast(item, "Image_Icon")
-- 						icon:setSpriteFrame(cc.SpriteFrame:create("Image/Match/" .. frameName, cc.rect(0,0,113, 113)))

-- 						--比赛时间
-- 						local hour = string.format("%02d",mroom.startHour)
-- 						local minute = string.format("%02d",mroom.startMinute)
-- 						local strtime = hour .. ":" .. minute
-- 						cc.uiloader:seekNodeByNameFast(item, "Text_StartTime")
-- 						:setString(strtime)

-- 						--比赛房名字
-- 						local name = mroom.name
-- 						name = matchNameFormat(name)
-- 						cc.uiloader:seekNodeByNameFast(item, "Text_MatchTitle")
-- 						:setString(name)

-- 						--参与金额
-- 						local fee = mroom.fee
-- 						print("fee::::",fee)
-- 						if fee then
-- 							cc.uiloader:seekNodeByNameFast(item, "Text_ConstValue")
-- 								:setString(fee.val .. "钻石")
-- 						end

-- 						--比赛奖品
-- 						local rewards = mroom.rewards
-- 						for i = 1,3 do
-- 							local rstart = rewards[i].startRank
-- 							local rend = rewards[i].endRank

-- 							local rank
-- 							if rstart == rend then
-- 								rank = "第"..rstart .. "名:"
-- 							else
-- 								rank = "第"..rstart .. "~" .. rend .. "名:"
-- 							end

-- 							local str = rank .. rewards[i].name
-- 							str = prizeFormat(str)
-- 							cc.uiloader:seekNodeByNameFast(item, string.format("Text_Prize_%d",i))
-- 								:setString(str)
-- 						end

-- 						--比赛状态
-- 						local state = 1
-- 						for k,v in pairs(msg.matches) do
-- 							if v.matchid == config.matchroom[i].matchid then
-- 								state = v.status				--比赛状态
-- 								item.state = state				--比赛状态
-- 								local isSignup = v.signup		--是否报名过

-- 								--进入比赛按钮
-- 								cc.uiloader:seekNodeByNameFast(item, "Button_Enter")
-- 									:hide()
-- 									:onButtonClicked(function ()
-- 										print("enter")
-- 										MatchMessage.EnterMatchReq(v.matchid,false)
-- 									end)

-- 								--退出比赛按钮
-- 								cc.uiloader:seekNodeByNameFast(item, "Button_Exit")
-- 									:hide()
-- 									:onButtonClicked(function ()
-- 										print("exit")
-- 										MatchMessage.MatchSignupReq(2,v.matchid)
-- 									end)

-- 								--报名比赛按钮
-- 								cc.uiloader:seekNodeByNameFast(item, "Button_Signup")
-- 									:hide()
-- 									:onButtonClicked(function ()
-- 											print("signup")
-- 											MatchMessage.MatchSignupReq(1,v.matchid)
-- 											--self:showMatchRankList(20100)
-- 										end)

-- 								--比赛进行中按钮
-- 								cc.uiloader:seekNodeByNameFast(item, "Button_Playing")
-- 								:onButtonClicked(function ()
-- 									print("playing")
-- 									end)
-- 								:hide()

-- 								--比赛排名按钮
-- 								cc.uiloader:seekNodeByNameFast(item, "Button_Rank")
-- 								:hide()
-- 								:onButtonClicked(function ()
-- 									print("end")
-- 									self:showMatchRankList(v.matchid)
-- 								end)

-- 								--已取消按钮
-- 								cc.uiloader:seekNodeByNameFast(item, "Button_Cancel")
-- 									:hide()
-- 									:onButtonClicked(function ()
-- 										print("end")
-- 										--self:showMatchRankList(matchId)
-- 									end)

-- 								--刷新按钮状态
-- 								self:updateMatchState(v.matchid,state,isSignup)
-- 							end
-- 						end

-- 						--倒计时
-- 						item.labelLeftTime = cc.uiloader:seekNodeByNameFast(item, "Text_LeftTime")
-- 						local startTime = {}
-- 						startTime.startHour = mroom.startHour
-- 						startTime.startMinute = mroom.startMinute
-- 						item.startTime = startTime

-- 					end
-- 				end
-- 			end
-- 		end

-- 		--获取服务器时间开始倒计时刷新比赛时间
-- 		web.getServerTime(function (time)
-- 			leftTime = time
-- 			self:updateLeftTime()
-- 			self.leftTimeHandler = scheduler.scheduleGlobal(function()
-- 				leftTime = leftTime + 1
-- 				self:updateLeftTime()
-- 			end, 1.0)
-- 		end)
--     end
-- end

-- --[[ --
-- 	* 刷新比赛倒计时时间
-- --]]
-- function LobbyScene:updateLeftTime()
--     local servertime = os.date("*t", leftTime)

--    	for i = 1,#self.scene.matchItem do
--     	local item = self.scene.matchItem[i]
--     	if item ~= nil then
--           	--print("updateMatchTime11111--")
--           	local s = os.time({year=servertime.year, month=servertime.month, day=servertime.day,hour = item.startTime.startHour,min = item.startTime.startMinute,sec = 0})
--           	local diff = os.difftime(s,leftTime)
--             --print("diff:" .. diff)
-- 			item.labelLeftTime:setVisible(true)

--             if item.state ~= 4 and item.state ~= 16 then
--                 --print("updateMatchTime2222--")
--                 if diff <= 0 then
--                     item.labelLeftTime:setString("00:00:00")
--                	else
--                     local left = string.format("%02d:%02d:%02d", math.floor(diff/(60*60)), math.floor((diff/60)%60), diff%60)
--                     item.labelLeftTime:setString(left)
--                 end
--             else
-- 				item.labelLeftTime:setString("00:00:00")
-- 				local btn_signup = cc.uiloader:seekNodeByNameFast(item, "Button_Signup")
-- 					:show()
-- 				btn_signup:setButtonEnabled(false)
--             end
--         end
--     end
-- end

-- --[[ --
-- 	* 刷新比赛按钮状态
-- 	@param int		matchId			比赛ID
-- 	@param int		state			比赛状态
-- 	@param bool		signup			是否报名过
-- --]]
-- function LobbyScene:updateMatchState(matchId,state,signup)
-- 	print("matchId:" .. matchId ..",state:" .. tostring(state))
-- 	local item
-- 	for k,v in pairs(self.scene.matchItem) do
-- 		if v.matchId == matchId then
-- 			item = v
-- 			break
-- 		end
-- 	end

--     -- cc.uiloader:seekNodeByNameFast(item, "Text_ConstValue")
--     --    :setString(fee)

--     if state == 1 then
-- 		if signup then
-- 			cc.uiloader:seekNodeByNameFast(item, "Button_Enter")
-- 				:show()
-- 			cc.uiloader:seekNodeByNameFast(item, "Button_Exit")
-- 				:show()
-- 			cc.uiloader:seekNodeByNameFast(item, "Button_Signup")
-- 				:hide()
-- 		else
-- 			cc.uiloader:seekNodeByNameFast(item, "Button_Enter")
-- 				:hide()
-- 			cc.uiloader:seekNodeByNameFast(item, "Button_Exit")
-- 				:hide()
-- 			cc.uiloader:seekNodeByNameFast(item, "Button_Signup")
-- 				:show()
-- 		end
--     elseif state == 2 or state == 8 then
--         cc.uiloader:seekNodeByNameFast(item, "Button_Playing")
--         	:show()
--     elseif state == 16 then
-- 		cc.uiloader:seekNodeByNameFast(item, "Button_Ended")
-- 			:show()
-- 		cc.uiloader:seekNodeByNameFast(item, "Button_Rank")
-- 			:show()
-- 		cc.uiloader:seekNodeByNameFast(item, "Button_Signup")
-- 			:hide()
--     elseif state == 4 then
-- 		cc.uiloader:seekNodeByNameFast(item, "Button_Cancel")
-- 			:show()
--     end
-- end

-- --[[ --
-- 	* 报名比赛
-- 	@param table		msg			报名数据
-- 	@param table		oldMsg		发送请求的数据
-- --]]
-- function LobbyScene:MatchSignupRep(msg,oldMsg)
--     print("MatchSignupRep:" .. msg.result)
-- 	--dump(msg)

--     if msg.result == 0 then
--         if oldMsg.optype == 1 then  --报名成功
--           	self:updateMatchState(oldMsg.matchid,1,true)
--         elseif oldMsg.optype == 2 then  --取消成功
--           	self:updateMatchState(oldMsg.matchid,1,false)
--         end
--     else
--         local string = "报名失败！"
--         if msg.result == 4 then
--           	string = "报名失败，已经报名过"
--         elseif msg.result == 6 then
--             string = "报名失败，名额已满"
--         elseif msg.result == 7 then
--             string = "报名失败，同ip报名限制"
--         elseif msg.result == 8 then
--             string = "报名失败，报名费用不足"
--         end
--         ErrorLayer.new(string):addTo(self.scene)
-- 	end
-- end

-- --[[ --
-- 	* 显示比赛排名
-- 	@param int		matchid			比赛ID
-- --]]
-- function LobbyScene:showMatchRankList(matchid)
--     print("match--rank111-----")
--     --比赛排名界面
--     local matchRankListLayer = cc.uiloader:load("Layer/Lobby/MatchRankLayer.json"):addTo(self.scene)

-- 	--比赛列表
--     local list = cc.uiloader:seekNodeByNameFast(matchRankListLayer, "List")
--     self.scene.rankscrollNode = list:getScrollNode()
--     self.scene.rankscrollNode:removeAllChildren()

-- 	--标题
--     cc.uiloader:seekNodeByNameFast(matchRankListLayer, "Title")
-- 		--:setString(title)

-- 	--关闭按钮
-- 	cc.uiloader:seekNodeByNameFast(matchRankListLayer, "Close")
-- 		:onButtonClicked(function ()
-- 			sound_common.cancel()
-- 			matchRankListLayer:removeFromParent()
-- 			matchRankListLayer = nil
-- 		end)

-- 	--发送比赛排名数据请求
--     MatchMessage.MatchRankReq(matchid)
-- end

-- --[[ --
-- 	* 比赛排名
-- 	@param table		msg			排名数据
-- 	@param table		oldMsg		发送请求的数据
-- --]]
-- function LobbyScene:MatchRankRep(msg,oldMsg)
--     -- msg = {}
--     -- msg.result = 0
--     -- msg.players = {{nickname = "1111",rank = 1,prize = "aaaaaaa"},{nickname = "22222222222",rank = 2,prize = "bbbbbbb"},
--     -- {nickname = "333333",rank = 3,prize = "ccccccc"},{nickname = "444444",rank = 4,prize = "ddddddd"},{nickname = "55555",rank = 5,prize = "eeeeeeee"}}
--     -- print("MatchRankRep:" .. msg.result)
--     -- dump(msg)

--     if msg.result == 0 then         --成功
-- 		for i = 1,#msg.players do
-- 			--Item底图
-- 			local itemBg = display.newSprite("Image/Match/rank_bg_2.png")
-- 			itemBg:setPosition(498,340 - i * 100)
-- 			itemBg:setContentSize(993,85)
-- 			self.scene.rankscrollNode:addChild(itemBg)

-- 			--排名玩家数据
-- 			local player
-- 			for k,v in pairs(msg.players) do
-- 				if v.rank == i then
-- 					player = v
-- 					break
-- 				end
-- 			end

-- 			--显示第几名
--             if player.rank <= 3 then	--前三名
-- 				local rankNode = display.newSprite(string.format("Image/Match/r_%d.png",player.rank))
-- 				rankNode:setPosition(180,40)
-- 				rankNode:setAnchorPoint(cc.p(0.5,0.5))
-- 				itemBg:addChild(rankNode)
--             else
-- 				cc.ui.UILabel.new({
-- 					color = cc.c3b(131, 52, 28),
-- 					size = 23,
-- 					text = tostring(player.rank),
-- 					})
-- 				:addTo(itemBg)
-- 				:setAnchorPoint(cc.p(0.5, 0.5))
-- 				:setPosition(180,40)
-- 			end

-- 			--排名颜色
--             local labelColor
--             if player.rank == 1 then
--               	labelColor = cc.c3b(255,108,0)
--             elseif player.rank == 2 then
--                 labelColor = cc.c3b(141,27,39)
--             elseif player.rank == 3 then
--                 labelColor = cc.c3b(3,175,76)
--             else
--             	labelColor = cc.c3b(131, 52, 28)
-- 			end

--             --玩家名字
--             cc.ui.UILabel.new({color = labelColor, size = 23, text = tostring(crypt.base64decode(util.checkNickName(player.nickname)))})
-- 				:addTo(itemBg)
-- 				:setAnchorPoint(cc.p(0.5, 0.5))
-- 				:setPosition(497,40)

--             --奖品
--             cc.ui.UILabel.new({color = labelColor, size = 23, text = tostring(player.reward)})
-- 				:addTo(itemBg)
-- 				:setAnchorPoint(cc.p(0.5, 0.5))
-- 				:setPosition(814,40)
--         end
--     end
-- end

-- --[[ --
-- 	* 检查某个游戏房间配置数据   目前没啥用了
-- 	@param int		gameid			游戏ID
-- --]]
-- function LobbyScene:checkRoomList(gameId)
--     local config = RoomConfig:getGameConfig(gameId)
--     if config == nil then
--     	return false
--     end

-- 	if #config.room == 0 then
-- 		return false
-- 	end

--     return true
-- end

-- --[[ --
-- 	* 显示房间列表
--     @param int 			gameId 				游戏ID
-- --]]
-- function LobbyScene:showRoomList(gameId)
--     local roomListLayer = cc.uiloader:load("Layer/Lobby/RoomListLayer.json"):addTo(self.scene)
--     self.scene.roomListLayer = roomListLayer
--     self.scene.roomListLayer.gameId = gameId

-- 	local popBoxNode = cc.uiloader:seekNodeByNameFast(roomListLayer, "PopBoxNode")
-- 	popBoxNode:setScale(0)

-- 	transition.scaleTo(popBoxNode, {
-- 		scale = 1,
-- 		time = app.constant.lobby_popbox_trasition_time,
-- 		onComplete = function ()
-- 			local config = RoomConfig:getGameConfig(gameId)
-- 			assert(config)

-- 			--标题
-- 			cc.uiloader:seekNodeByNameFast(roomListLayer, "Title")
-- 			:setString(config.name)
-- 			--关闭按钮
-- 			cc.uiloader:seekNodeByNameFast(roomListLayer, "Close")
-- 			:onButtonClicked(function ()
-- 				sound_common.cancel()
-- 				roomListLayer:removeFromParent()
-- 				self.scene.roomListLayer = nil
-- 			end)

-- 			--加载房间配置  目前只有比赛房
-- 			self:loadRoomConfig()

-- 			-- if #config.room == 0 then
-- 			--   MatchMessage.MatchConfigReq()
-- 			--   UserMessage.RoomListReq()
-- 			-- else
-- 			--   self:loadRoomConfig()
-- 			-- end
-- 		end,
-- 	})
-- end


-- --[[ --
-- 	* 加载房间配置
-- --]]
-- function LobbyScene:loadRoomConfig()
-- 	if not self.scene.roomListLayer then
-- 		return
-- 	end

-- 	local roomListLayer = self.scene.roomListLayer
-- 	local gameId = roomListLayer.gameId

-- 	local list = cc.uiloader:seekNodeByNameFast(roomListLayer, "List")
-- 	local scrollNode = list:getScrollNode()
-- 	scrollNode:removeAllChildren()

-- 	local config = RoomConfig:getGameConfig(gameId)
-- 	assert(config)
-- 	dump(config)

-- 	--房间配置 空表
--     for i,room in ipairs(config.room) do
-- 		--if config.room.invisible == nil or config.room.invisible ~= 1 then

--         local players = room.players or 0
--         local maxPlayers = room.maxRoomPlayer or room.tables * room.seats * 2
--         local gold = room.gold or 0
--         local name = room.name or ""
--         local fixedbase = room.fixedbase

--         self:loadRoomItem(i,list,name,players,maxPlayers,gold,nil,fixedbase,function()
-- 			UserMessage.EnterRoomRequest(gameId, room.roomid)

-- 			app.constant.cur_GameID = gameId
-- 			app.constant.cur_RoomID = room.roomid
-- 		end)

--         --end
--     end

-- 	--比赛配置
--     local hasFriendRoom = false
-- 	if config.matchroom and #config.matchroom > 0 then

--         local players = 0
--         local maxPlayers = 1
--         local gold = 0
--         local name = config.name .. "比赛房" or ""

--         local times = {}
-- 		for k,mroom in pairs(config.matchroom) do
-- 			if mroom.invisible == nil or mroom.invisible ~= 1 then
-- 				local hour = string.format("%02d",mroom.startHour)
-- 				local minute = string.format("%02d",mroom.startMinute)
-- 				local str = ""
-- 				if #times == 0 then
-- 					str = "比赛时间："
-- 				end
-- 				str = str .. hour .. ":" .. minute
-- 				print("bisai:",str)
-- 				table.insert(times,str)
-- 			elseif mroom.invisible == 1 then
-- 				hasFriendRoom = true
-- 			end
-- 		end

-- 		--加载一条Item
-- 		self:loadRoomItem(#config.room + 1,list,name,players,maxPlayers,0,times,fixedbase,function()
-- 			--请求比赛List
-- 			MatchMessage.MatchListReq(gameId)
-- 		end)
-- 	end

-- 	--如果有好友密码房，加创建入口  --隐藏的比赛房
-- 	if hasFriendRoom == true then
-- 		local name = config.name .. "线下比赛房" or ""
-- 		local players = 0
-- 		local maxPlayers = 1
-- 		local gold = 0
-- 		local times = {}
-- 		table.insert(times,"比赛")

-- 		self:loadRoomItem(#config.room + 2,list,name,players,maxPlayers,0,times,fixedbase,function()
-- 			-- if self.scene.roomListLayer ~= nil then
-- 			--  self.scene.roomListLayer:removeFromParent()
-- 			-- 	self.scene.roomListLayer = nil
-- 			-- end

-- 			self:showFriendRoom()
-- 		end, false)
-- 	end
-- end

-- --[[ --
-- 	* 加载一条Item
--     @param int 			i 				房间数
-- 	@param ScrollView 	list 			列表节点
-- 	@param string 		name			房间名称
-- 	@param int 			players			玩家人数
-- 	@param int 			maxPlayers		最大玩家人数
-- 	@param int			gold			金币限制
-- 	@param table		times			比赛开始时间s
-- 	@param int			fixedbase		低分
-- 	@param function		callback		Item加载完成回调
-- 	@param bool 		isShow			false 没啥用
-- --]]
-- function LobbyScene:loadRoomItem(i, list, name, players, maxPlayers, gold, times, fixedbase, callback, isShow)
--   	local height = list:getCascadeBoundingBox().height
-- 	local width = list:getCascadeBoundingBox().width
-- 	--Label 颜色
-- 	local fontColor = cc.c3b(162, 67, 14)
-- 	if times ~=nil and #times > 0 then
-- 		fontColor = cc.c3b(204, 2, 18)
-- 	end

-- 	--scrollView 滚动节点
-- 	local scrollNode = list:getScrollNode()
-- 	local node = display.newNode():addTo(scrollNode)
-- 	node:setPosition(0, height - i * 151 - (i - 1) * 40)

-- 	--Item 标签 ---

-- 	--空闲 普通 火爆 标签
--   	local stateRes
--   	if players <= maxPlayers / 5 then
--     	stateRes = "Image/Match/state_0.png"
--     elseif players <= maxPlayers  / 2 then
--       	stateRes = "Image/Match/state_1.png"
--     else
--       	stateRes = "Image/Match/state_2.png"
--     end

-- 	--比赛房标签
--     if times ~= nil and #times > 0 then
--       	stateRes = "Image/Match/state_m.png"
--     end

-- 	--添加标签
--     if stateRes then
--       	display.newSprite(stateRes):addTo(node)
--       		:setPosition(70, 75)
-- 	end

-- 	---------------------------------

-- 	--Item底图
--     display.newSprite("Image/Match/item_bg.png"):addTo(node)
--     	:setPosition(width / 2 - 50, 75)

-- 	--进入按钮图  比赛为红色图  普通房间为绿色图
--     local nImag, pImag, dImag
--     if times ~= nil and #times > 0 then
-- 		nImag = "Image/Match/enterm.png"
-- 		pImag = "Image/Match/enter_downm.png"
-- 		dImag = "Image/Match/enter_downm.png"
--     else
-- 		nImag = "Image/Match/enter.png"
-- 		pImag = "Image/Match/enter_down.png"
-- 		dImag = "Image/Match/enter_down.png"
--     end

--     --进入按钮
--     local button = cc.ui.UIPushButton.new({normal = nImag, pressed = nImag, disabled = dImag,}, {scale9 = true})
-- 		:onButtonClicked(function ()
-- 			callback()
-- 		end)
-- 		:addTo(node)
-- 		:setPosition(width - 120, 75)

--     --比赛房名字
--     cc.ui.UILabel.new({color = fontColor, size = 30, text = name,})
-- 		:addTo(node)
-- 		:setAnchorPoint(cc.p(0, 0))
-- 		:setPosition(70 + 70, 80)

--     --房间固定底注
--     local pos_x = 0
--     if fixedbase ~=nil and fixedbase > 0 then
-- 		pos_x = pos_x + 70 + 70
-- 		cc.ui.UILabel.new({color = fontColor, size = 20, text = "固定底分 : " .. fixedbase})
-- 			:addTo(node)
-- 			:setAnchorPoint(cc.p(0, 1))
-- 			:setPosition(pos_x, 75 / 2 + 15)
-- 		pos_x = pos_x + 30
-- 	end

-- 	--进入房间最小金额
--     if gold > 0 then
-- 		pos_x = pos_x + 70 + 70
-- 		cc.ui.UILabel.new({color = fontColor, size = 20, text = "最小金额 : " .. gold})
-- 			:addTo(node)
-- 			:setAnchorPoint(cc.p(0, 1))
-- 			:setPosition(pos_x, 75 / 2 + 15)
--     end

--     --比赛时间
--    	-- print("times----------:")
--    	-- dump(times)
-- 	if times and isShow == nil then
-- 		for k,time in pairs(times) do
-- 			local temp = 100
-- 			pos_x = pos_x + 140 + temp * (k - 1)

-- 			cc.ui.UILabel.new({color = fontColor, size = 20, text = time})
-- 				:addTo(node)
-- 				:setAnchorPoint(cc.p(0, 1))
-- 				:setPosition(pos_x, 75 / 2 + 15)
-- 		end
-- 	end
-- end

-- -----------------------------------------------------------------------------------------------





      function LobbyScene:RunHorn(content)
        if type(content) ~= "string" then
          logger.error("horn content is:%s", tostring(content))
          return
        end

        if self.scene.hornMsgLabel then
          self.scene.hornMsgLabel:removeFromParent()
          self.scene.hornMsgLabel = nil
        end

        self.scene.horn:setVisible(true)
        self.scene.horn_bg:setVisible(true)
        local hornMsgLabel = cc.ui.UILabel.new({
          color = display.COLOR_BLACK,
          size = 25,
          text = content,
    }):addTo(self.scene.bg) --NOTE: add to background

        local lb_width = hornMsgLabel:getCascadeBoundingBox().size.width
        local lb_height = hornMsgLabel:getCascadeBoundingBox().size.height
        hornMsgLabel:setPosition(display.width, self.scene.horn:getPositionY())

        local delay = (1 + lb_width/display.width) * 8
        local action = cc.Sequence:create(
          cc.MoveTo:create(delay, cc.p(-lb_width, hornMsgLabel:getPositionY())),
          cc.CallFunc:create(function()
            self.scene.horn:setVisible(false)
            self.scene.horn_bg:setVisible(false)
            end)
          )
        transition.execute(hornMsgLabel, action)
        self.scene.hornMsgLabel = hornMsgLabel
      end

      function LobbyScene:UserInfoResonpse(msg, oldmsg)
        print("LobbyScene:UserInfoResonpse")
        if msg.uid == Player.uid then

          self:moneyChanged()
          self:nicknameChanged()
          self.loaded = true
          self:SafeBoxUserInfoUpdate()

          elseif isFinding then

           self:onFindFriendResp(msg)
         else

          self:SafeBoxOtherUserInfoResonpse(msg, oldmsg)
          self:onBindGetNameResp(msg)
        end
      end

  function LobbyScene:RoomListRep(msg)

        print("----LobbyScene.RoomListRep--config")

        --self:loadRoomConfig()
    --self:setBurthenMark()

  end

  function LobbyScene:NoticeInfo(msg)
  --  if msg and msg.gameid == 0 then
    --   app.userdata.notice_content = msg.content
    --   self:RunHorn(msg.content)
   -- end
 end

--add by whb 0914
function LobbyScene:addGuideLayer(curMenu)

  if Account.tags then

    return
  end


  if Account.tags.honor_tag ~= "1" then

    return

  end

  local account = Account.account

    -- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_FreeGold",0)
    -- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_Honor",0)
    -- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_Sign",0)
    -- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_Bind",0)

    guideInfo.guide_FreeGold = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_FreeGold")
    guideInfo.guide_Honor = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_Honor")
    guideInfo.guide_Sign = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_Sign")
    guideInfo.guide_Bind = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_Bind")

    print("addGuideLayer-Enter:freeGold,honor,sign,bind,",guideInfo.guide_FreeGold,guideInfo.guide_Honor,guideInfo.guide_Sign,guideInfo.guide_Bind)
    if guideInfo.guide_FreeGold ~= 0 and guideInfo.guide_Honor ~= 0 and guideInfo.guide_Sign ~= 0 and guideInfo.guide_Bind ~= 0 then
      self:removeGuideLayer()
      return
    end

    local guideLayerInSelf = self:getChildByTag(guideTag)
    print("addGuideLayer-guideLayerInSelf:",guideLayerInSelf)
    if guideLayerInSelf == nil then

      print("guide_InitLayer :"..guideInfo.guide_CurMenu)
      guideLayer.new(app.lang.future_game):addTo(self,nil,guideTag)

    end

    guideInfo.guide_CurMenu = curMenu

    self:showGuideLayer();

    print("guide_CurMenu :"..guideInfo.guide_CurMenu)
    if curMenu == guideInfo.guideMenu[1] then

      if guideInfo.guide_FreeGold == 0 or guideInfo.guide_Honor == 0 then

        self.scene.TopBar = cc.uiloader:seekNodeByNameFast(self.scene, "TopBar")
        local  x, y = self.scene.btnFreeGold:getPosition()
        local pos = self.scene:convertToWorldSpace(cc.p(x, y));
        guideLayer:SetItemPos("freeGold", pos.x, pos.y, handler(self, self.showFreeGold))
        x, y = self.scene.honor:getPosition()
        guideLayer:SetItemPos("honor", x, y, handler(self, self.showHonor))
      else
        self:removeGuideLayer()
      end

      elseif curMenu == guideInfo.guideMenu[2] then

        if guideInfo.guide_Sign == 0 then

          local scroll_View = cc.uiloader:seekNodeByNameFast(self.scene.freeLayer, "ScrollView")
          local btn_sign = cc.uiloader:seekNodeByNameFast(self.scene.freeLayer, "Button_Sign")
           -- local PopBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.freeLayer, "PopBoxNode")
           local  x, y = btn_sign:getPosition()
           -- local  m, n = scroll_View:getScrollNode():getPosition()
           local pos = scroll_View:getScrollNode():convertToWorldSpace(cc.p(x, y));
           -- local x, y = x+m+3, y+n
           print("guide_Sign--x,y",x,y)
           print("guide_Sign-convertTo--x,y",pos.x, pos.y)
           guideLayer:SetItemPos("sign", pos.x, pos.y, handler(self, self.showSign))

         else
          self:removeGuideLayer()
        end
      else
        if guideInfo.guide_Bind == 0 then

          local PopBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.honorLayer, "PopBoxNode")
          local  x, y = self.scene.btnBind:getPosition()
          local pos = PopBoxNode:convertToWorldSpace(cc.p(x, y));
          print("guide_Bind--x,y",x,y)
          print("guide_Bind-convertTo--x,y",pos.x+x, pos.y+y)
          guideLayer:SetItemPos("bind", pos.x, pos.y, handler(self, self.showBind))

        else
          self:removeGuideLayer()
        end
      end
       --todo

     end

     function LobbyScene:closeGuideLayer(guide_Name)
      local guideLayer = self:getChildByTag(guideTag)
      if guideLayer then

        local account = Account.account
        print("closeGuideLayer:--account,guide_Name",account,guide_Name)
        cc.UserDefault:getInstance():setIntegerForKey(account .. guide_Name,1)
        guideInfo[guide_Name] = 1
        guideLayer:HideLayer()

      end
    end

    function LobbyScene:showGuideLayer()
      local guideLayer = self:getChildByTag(guideTag)
      if guideLayer then
        guideLayer:ShowLayer()
      end
    end

    function LobbyScene:removeGuideLayer()
      local guideLayer = self:getChildByTag(guideTag)
      if guideLayer then
       guideLayer:stop()
     end
   end

   function LobbyScene:showJumpAction()
    local honor = self.scene.honor
    if Account.tags.honor_tag == "1" then
      if honor:isVisible() then
        local x, y = honor:getPosition()
        local upAction = transition.create(cc.MoveTo:create(0.2, cc.p(x, y + 30)), {
          easing = "sineOut",
          })
        local downAction = transition.create(cc.MoveTo:create(0.2, cc.p(x, y)), {
          easing = "sineIn",
          })

        if guideInfo.guide_Honor ~= 0 then
          honor:runAction(cc.RepeatForever:create(transition.sequence({
            cc.DelayTime:create(1),
            upAction,
            downAction,
            cc.DelayTime:create(2),
            })))
        end

      end
    else
      honor:hide()
    end
  end

  function LobbyScene:showChatMenu()

    self:SetUserInfo()

    if hasSetListener == false then

      self:SetUnreadListener(true)

    end

    self:SetUIChat()

    self:ResetChatNum()

    if imgInfo ~= nil then

      imgInfo:hide()
    end

    print("server:enter")
    function callback(param)
      if device.platform == "android" then
        param = json.decode(param)
      end
      local result = param.result
      print("LobbyScene:showChatMenu:result-",result)

    end

    local params = {}

    print("server:device.platform" .. device.platform)
    if device.platform == "ios" then
      params.callback = callback
      params.bgPath = "Image/Lobby/Image_Title_bar.png"
       -- params.backPath = "Image/Common/Avatar/reback1.png"

       print("LobbyScene:showChatMenu:begin---")

       luaoc.callStaticMethod("AppController", "OpenChatMenu", params)

       elseif device.platform == "android" then

        print("server:222222")

        luaj.callStaticMethod("app/QiYuSDK", "OpenChatMenu", { callback })

      end
    end

    function LobbyScene:LogOutChat()

    --if CONFIG_APP_CHANNEL == "3501" then return end

    function callback(param)

      if device.platform == "android" then
        param = json.decode(param)
      else
        self:ResetChatNum()
      end

      local result = param.result
      print("LobbyScene:LogOutChat-result:",result)

    end

    local params = {}

    if device.platform == "ios" then
      params.callback = callback

      luaoc.callStaticMethod("AppController", "LogOutChat", params)

      elseif device.platform == "android" then

        --luaj.callStaticMethod("app/QiYuSDK", "SetUnreadListener", { false, callback })
        luaj.callStaticMethod("app/QiYuSDK", "LogOutChat", { callback })

      end

    end

    function LobbyScene:SetUIChat()

      function callback(param)

       if device.platform == "android" then
        param = json.decode(param)
      end

      local result = param.result
      print("LobbyScene:SetUIChat-result:",result)

    end

    local params = {}

    if device.platform == "ios" then
      params.callback = callback
      params.bgPath = "Image/Common/Avatar/session_bg.png"
--modify by whb 161028
local image = AvatarConfig:getAvatar(Player.sex, Player.gold, Player.viptype)
--modify end
params.customerPath = image

local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
params.serverPath = platConfig.serviceIcon

luaoc.callStaticMethod("AppController", "SetUIChat", params)

elseif device.platform == "android" then

  params.bgPath = "Image/Common/Avatar/session_bg.png"
--modify by whb 161028
local image = AvatarConfig:getAvatar(Player.sex, Player.gold, Player.viptype)
--modify end
params.customerPath = image
local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
params.serverPath = platConfig.serviceIcon
local str = json.encode(params)

luaj.callStaticMethod("app/QiYuSDK", "SetUIChat", { str, callback })

end

end

function LobbyScene:SetUnreadListener(bsetListener)

  function callback(param)

    if device.platform == "android" then
      param = json.decode(param)
    end

    local result = param.result
    print("LobbyScene:SetUnreadListener-result:",result)

  end

  hasSetListener = bsetListenr

  if device.platform == "ios" then

--   luaoc.callStaticMethod("AppController", "SetUIChat", params)

elseif device.platform == "android" then

 luaj.callStaticMethod("app/QiYuSDK", "SetUnreadListener", { bsetListener, callback })

end

end

function LobbyScene:SetUserInfo()

  function callback(param)

    if device.platform == "android" then
      param = json.decode(param)
    end

    local result = param.result
    print("LobbyScene:SetUserInfo-result:",result)

  end

  local params = {}

  if device.platform == "ios" then

    print("SetUser---:",Player.uid)

    params.callback = callback
    params.uid = Player.uid
    params.nickname = util.checkNickName(Player.nickname)
    params.sex = Player.sex
    params.time = os.date("%Y-%m-%d %H:%M:%S")

    luaoc.callStaticMethod("AppController", "SetUserInfo", params)

    elseif device.platform == "android" then

      params.uid = Player.uid
      params.nickname = util.checkNickName(Player.nickname)
      params.sex = Player.sex
      params.time = os.date("%Y-%m-%d %H:%M:%S")

      print("SetUser-android:",Player.uid)
      local str = json.encode(params)
        --params.uid, params.nickname, params.sex, params.time,
        print("SetUser-json:",str)
        luaj.callStaticMethod("app/QiYuSDK", "UpdateUserInfo", {str, callback })

      end

    end

    function LobbyScene:ResetChatNum()

      function callback(param)

        local result = param.result
        print("LobbyScene:ResetChatNum-result:",result)

      end

      local params = {}

      if device.platform == "ios" then
        params.callback = callback

        luaoc.callStaticMethod("AppController", "ResetChatNum", params)

        elseif device.platform == "android" then

       -- luaj.callStaticMethod("app/WeixinSDK", "recharge", { str, callback })

     end

   end

   function G_SetChatNum(chatNum)

    if device.platform == "android" then
      param = json.decode(chatNum)
      chatNum = param.result
      print("G_SetChatNum:",param.result)
    end

    if imgInfo == nil or textLayer == nil then
      return
    end

    if chatNum == 0 then
      imgInfo:hide()
    else
      imgInfo:show()
    end

    textLayer:setString(chatNum)
    print("G_SetChatNum:",chatNum)

  end

function table_copy_table(ori_tab)
    if (type(ori_tab) ~= "table") then
      return nil
    end
    local new_tab = {}
    for i,v in pairs(ori_tab) do
      local vtyp = type(v)
      if (vtyp == "table") then
        new_tab[i] = table_copy_table(v)
        elseif (vtyp == "thread") then
          new_tab[i] = v
          elseif (vtyp == "userdata") then
            new_tab[i] = v
          else
            new_tab[i] = v
          end
        end
        return new_tab
end

function LobbyScene:onFindFriendResp(msg)

isFinding = false

if self.scene.friendChatLayer == nil then
return
end

if msg.uid ~= 0 then
  print("onFindFriendResp:" .. msg.nickname)
  print("uid:" .. msg.uid)
  local otherName = crypt.base64decode(msg.nickname)
  print("onFindFriendResp-otherName:" .. otherName)

  self:SearchFriend(otherName)

  self:enableSearchInputTouch()

else
  self:closeProgressLayer()
  ErrorLayer.new(app.lang.nickname_notfound, nil, nil, handler(self, self.enableSearchInputTouch)):addTo(self)
end

end


function LobbyScene:OpenSesameRep(msg, oldmsg)

  print("LobbyScene:OpenSesameRep, msg.result:", msg.result)

  self:closeProgressLayer()

  if msg.result == 0 then

    self:closeFriendRoom()

    local config = RoomConfig:getGameConfig(msg.gameid)

    for k,mroom in pairs(config.matchroom) do

      local matchid = mroom.matchid

      if msg.roomid == matchid then

        MatchMessage.MatchListReq(mroom.gameid, matchid)

        break
      end

    end

        --ErrorLayer.new(app.lang.exchange_success):addTo(self)
      else
        ErrorLayer.new(app.lang.enterFriend_error, nil, nil, nil):addTo(self)
      end


    end

    function ExitYvSys()

      if app.constant.isOpenYvSys == false then

        return

      end

      if device.platform ~= "ios" and  device.platform ~= "android" then
        return
      end
     -- DestroyPanel_Apply()

      app.constant.isLoginChat = false

      if EmotionList ~= nil then
        EmotionList:removeFromParent()
        EmotionList = nil
      end


      local test = yvcc.YVPlatform:getSingletonPtr()
      local playerManner = yvcc.YVPlatform:getPlayerManager()

      print("playerManner---:",playerManner)

      playerManner:cpLogout()

      local istance = yvcc.HclcData:sharedHD():getListen()

      print("istance---:",istance)
      if istance then
       istance:releaseAllNode()
     end

   end


  function LobbyScene:LogOutYvSys()

    ExitYvSys()

  end

  function loginYvCallback(result, isext)

      if result == 0 then

        app.constant.isLoginChat = true

        print("loginYvSys loginOk----")
        --清除语音资源
        local scene = display.getRunningScene().name
        if scene == "LoginScene" or scene == "LobbyScene" then
            util.CloseChannel()
        end

        if loginFchatHandler then

           scheduler.unscheduleGlobal(loginFchatHandler)
           loginFchatHandler = nil

         end
      else

            print("loginYvError---reLogin----")
      end

  end

function loginYvSys()

    if app.constant.isOpenYvSys == false or Player.uid == 0 or Player.uid == nil then
      return
    end

    -- print("loginYvSys--------")

    if device.platform ~= "ios"  and device.platform ~= "android" then
      return
    end

    print("loginYvSys0:",loginFchatHandler)

    --登录好友系统定时器，若两分钟未登录成功会重新登录
    if loginFchatHandler == nil then

     loginFchatHandler = scheduler.scheduleGlobal(
      function()

        loginYvSys()

        print("loginYvSys reLogin----")

      end, 15)

    end

    local test = yvcc.YVPlatform:getSingletonPtr()
    local playerManner = yvcc.YVPlatform:getPlayerManager()
    local uidstr = Player.uid .. ""
    local nickstr = util.checkNickName(Player.nickname)
    local intsex = Player.sex

    local imageStr = AvatarConfig:getAvatar(Player.sex, Player.gold, Player.viptype)
    -- if Player.imageid ~= nil and Player.imageid ~= "" then
    --   imageStr = Player.imageid
    -- end
    print("userInfo:",uidstr,nickstr,intsex,imageStr)
    playerManner:cpLogin(uidstr,nickstr,"","",intsex,imageStr);
    print("lua bind: ",test)

   --getEmotionData()

end

function SetInvitation()

--   if app.constant.isShowChat == false then

--     if curScene ~= nil then

--       scheduler.performWithDelayGlobal(function ()
--         curScene:showFriendChat()
--         end, 1)

--     end

--   else

--    print("setInvitation000-------")

--    if curScene ~= nil then

--     print("setInvitation-------")

--     if curScene.scene.addFriend.editBoxes[1] ~= nil then

--     print("setInvitation2222-------")

--     curScene.scene.addFriend.editBoxes[1]:setString(app.constant.nChatUid)

--   end

-- end

-- end

-- app.constant.isInvite = false
end

function RequestFromWChat(gameid, roomid, uid, session, tableid, seatid, password)


 local roomNid = tonumber(roomid)
 if roomNid == 0 then

       -- saveLoginfo("RequestFromWChatce------" .. uid)

       app.constant.isInvite = true

       app.constant.nChatUid = tonumber(uid)

       if  app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)

            return

          end

          print("RequestFromWChat:uid", uid)

          SetInvitation()

        else

         app.constant.isReuqestWchat = 1

         print("RequestFromWChat:", gameid, roomid, uid, session, tableid, seatid, password)

         app.constant.requestWchatInfo.session = tonumber(session)
         app.constant.requestWchatInfo.tableid = tonumber(tableid)
         app.constant.requestWchatInfo.password = password
         app.constant.requestWchatInfo.roomid = tonumber(roomid)
         app.constant.requestWchatInfo.gameid = tonumber(gameid)

         if app.constant.isLoginGame == false then

            -- saveLoginfo("RequestFromWChat2222------" .. uid)
            app.constant.isReuqestWchat = 2
            return

          end

          local scene = display.getRunningScene()

          print("RequestFromWChat:", scene.name)

          if scene.name == "LoginScene" then

           local account,password = "",""

           if self.class.accountHistory[1] then

            account,password = self.class.accountHistory[1].account, self.class.accountHistory[1].password
          end

            --saveLoginfo("account:,password:"..account.."p"..password)

            local astr = string.len(account)
            local pstr = string.len(password)

            if astr>0 and pstr>0 then

              scene:login({
                channel = app.constant.channel_game,
                account = account,
                password = password,
                })

            else

                --saveLoginfo("account:,password2222:")

                scene:loginWeixin()

              end


              elseif scene.name ~= "LobbyScene" and  scene.name ~= "RoomScene" then

               local curGameID =  app.constant.cur_GameID
               local cur_RoomID = app.constant.cur_RoomID

               if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                app.constant.isReuqestWchat = 0

                return

              end


              message.dispatchGame("room.LeaveGame", {})

             -- local session = msgMgr:get_room_session()
             -- message.sendMessage("game.LeaveRoomReq", {session=session})
             -- app:enterScene("LobbyScene", nil, "fade", 0.5)

             elseif scene.name == "RoomScene" then

               local curGameID =  app.constant.cur_GameID
               local cur_RoomID = app.constant.cur_RoomID

               if curGameID == tonumber(gameid) and cur_RoomID == tonumber(roomid) then

                 app.constant.isReuqestWchat = 3
                 selectEnterGameScene()

               else

                 local session = msgMgr:get_room_session()
                 message.sendMessage("game.LeaveRoomReq", {session=session})
                 app:enterScene("LobbyScene", nil, "fade", 0.5)

                 app.constant.isReuqestWchat = 2

               end

               elseif scene.name == "LobbyScene" then

                 app.constant.isReuqestWchat = 2

                 setEnterScene()

               end
         -- if g_watching == false then

         --     util.CloseChannel()

         -- end

       end

     end


     function setEnterScene()

      print("setEnterScene--------")

      if app.constant.isReuqestWchat ~= 2 then
        return
      end

      roomid = app.constant.requestWchatInfo.roomid
      gameid = app.constant.requestWchatInfo.gameid

      app.constant.cur_GameID = gameid
      app.constant.cur_RoomID = roomid

      UserMessage.EnterRoomRequest(tonumber(gameid), tonumber(roomid))

      app.constant.isReuqestWchat = 3

    end

    function selectEnterGameScene()

      if app.constant.isReuqestWchat ~= 3 then
        return
      end

      local session = app.constant.requestWchatInfo.session
      local tableid = app.constant.requestWchatInfo.tableid
      local password = app.constant.requestWchatInfo.password

      print("Siting in  desk-----")

      if password == "1" then

        message.sendMessage("game.SitdownReq", {
          session = tonumber(session),
          table = tonumber(tableid),
          seat = 0,
            --rule = userdata.Room.tableRule,
            })

      else

        message.sendMessage("game.SitdownReq", {
          session = tonumber(session),
          table = tonumber(tableid),
          seat = 0,
          sitpwd = password,
            --rule = userdata.Room.tableRule,
            })

      end

      app.constant.isReuqestWchat = 0
    end

    function inGameEnterScene()

      print("inGameEnterScene--------")

      if app.constant.isRequesting ~= 2 then
        return
      end

      roomid = app.constant.requestInfo.roomid
      gameid = app.constant.requestInfo.gameid

      app.constant.cur_GameID = gameid
      app.constant.cur_RoomID = roomid

      UserMessage.EnterRoomRequest(tonumber(gameid), tonumber(roomid))

      app.constant.isRequesting = 3

    end

    function inGameEnterGameScene()

      if app.constant.isRequesting ~= 3 then
        return
      end

      local session = app.constant.requestInfo.session
      local tableid = app.constant.requestInfo.tableid
      local password = app.constant.requestInfo.password

      print("Siting in  desk--inGame--")

      if password == "1" then

        message.sendMessage("game.SitdownReq", {
          session = tonumber(session),
          table = tonumber(tableid),
          seat = 0,
            --rule = userdata.Room.tableRule,
            })

      else

        message.sendMessage("game.SitdownReq", {
          session = tonumber(session),
          table = tonumber(tableid),
          seat = 0,
          sitpwd = password,
            --rule = userdata.Room.tableRule,
            })

      end

      app.constant.isRequesting = 0
    end

    function LobbyScene:Invitation(msg)

      print("LobbyScene.Invitation")

      local scene = display.getRunningScene()

      if scene.name ~= "LobbyScene" then

        return

      end

   -- dump(msg)

   if app.constant.isRequesting>0 then

    print("being in the Invitation!")
    return
  end

  app.constant.requestInfo.uid = msg.uid
  app.constant.requestInfo.nickname = msg.nickname
  app.constant.requestInfo.gameid = msg.gameid
  app.constant.requestInfo.roomid = msg.roomid
  app.constant.requestInfo.tableid = msg.tableid
  app.constant.requestInfo.seatid = msg.seatid
  app.constant.requestInfo.password = msg.password
  app.constant.requestInfo.session = msg.session

    --dump(app.constant)

    local sure = function (event)

    print("sure click-------")

    local scene = display.getRunningScene()

    print("scene.name", scene.name)

    app.constant.isRequesting = 2

    inGameEnterScene()

  end

  app.constant.isRequesting = 1
  util.setRequestLayer(self, sure)

end

function onReuestInvitation()

  UserMessage.InviteFriendsReq()

end

function saveLoginfo(info)

  local file = io.open(device.writablePath .. "loginfo", "a+")
  if not file then
    return
  end

  print("openLoginfo---")

  local strTime = os.date("%H:%M:%S", os.time())

  file:write("[" .. strTime .. "]---" .. info)
  file:write("\n")

  file:close()
end
--add end
function LobbyScene:addMatchNotication(Nid, body, matchInfo, noticeType, openWeek, weekDay, hour, minute, isrepeat, hour2, minute2)

  function callback(param)

   if device.platform == "android" then
    param = json.decode(param)
  end

  local result = param.result
  print("LobbyScene:addMatchNotication-result:",result)

end

print("body:",body)
print("matchInfo.startHour:",matchInfo.startHour)
print("matchInfo.startMinute:",matchInfo.startMinute)
print("openWeek:",openWeek)
print("weekDay:",weekDay)


local params = {}

local requestIdentifier = Nid
local subtitle = matchInfo.name
local body = body
local noticeType = noticeType
local openWeek = openWeek
local weekday = weekDay
local hour = hour
local minute = minute
local isrepeat = isrepeat

local hour2 = hour2
local minute2 = minute2

if device.platform == "ios" then
  params.callback = callback
  params.requestIdentifier = requestIdentifier
  params.subtitle = subtitle
  params.body = body
  params.noticeType = noticeType
  params.openWeek = openWeek
  params.weekday = weekday
  params.hour = hour
  params.minute = minute
  params.isrepeat = isrepeat


  local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
  params.serverPath = platConfig.serviceIcon

  luaoc.callStaticMethod("AppController", "createLocalizedUserNotification", params)

  elseif device.platform == "android" then

    print("android:--addMatchNotication---")

    params.requestIdentifier = requestIdentifier
    params.subtitle = subtitle
    params.body = body
    params.weekday = weekday
    params.hour = hour
    params.minute = minute
    params.hour2 = hour2
    params.minute2 = minute2
    params.isrepeat = isrepeat

    local str = json.encode(params)

    luaj.callStaticMethod("app/MyPushService", "setLocalNotification", { str, callback })

  end

end


function LobbyScene:deleteCloseMatch(matchid)


   function callback(param)

     if device.platform == "android" then
      param = json.decode(param)
    end

    local result = param.result
    print("LobbyScene:isHasMatch-result:",result)

  end

  if matchid == 20801 then

   for i = 1, 5 do

     local params = {}

     local nId = matchid .. i

     params.requestIdentifier = nId
     params.callback = callback

     luaoc.callStaticMethod("AppController", "deleteNotification", params)

   end

   for i = 11, 15 do

     local params = {}

     local nId = matchid .. i

     params.requestIdentifier = nId
     params.callback = callback

     luaoc.callStaticMethod("AppController", "deleteNotification", params)

   end

   local params2 = {}

   local nId = matchid .. 7

   params2.requestIdentifier = nId
   params2.callback = callback

   luaoc.callStaticMethod("AppController", "deleteNotification", params2)

   nId = matchid .. 17

   params2.requestIdentifier = nId
   params2.callback = callback

   luaoc.callStaticMethod("AppController", "deleteNotification", params2)


   elseif matchid == 20802 then

     local params = {}

     local nId = matchid .. 6

     params.requestIdentifier = nId
     params.callback = callback

     luaoc.callStaticMethod("AppController", "deleteNotification", params)

     nId = matchid .. 16

     params.requestIdentifier = nId
     params.callback = callback

     luaoc.callStaticMethod("AppController", "deleteNotification", params)

   end

end

  function LobbyScene:BindUserRep(msg)

    local progressLayer = self:getChildByTag(3462)
    if progressLayer then
        print("移除加载")
        ProgressLayer.removeProgressLayer(progressLayer)
    end

    print("msg.qq = ",msg.qq)
    print("msg.weixin = ",msg.weixin)
     -- 0成功; 1重复绑定; 其他：id无法绑定
    if msg.result == 0 then     --success

          ErrorLayer.new(app.lang.bind_Success, nil, nil, nil):addTo(self)

          Player.supid = self.bindId
          Player.qq = msg.qq
          Player.weixin = msg.weixin
          self:updateRequestCode()

      elseif msg.result == 1 then
          ErrorLayer.new(app.lang.bind_error_1, nil, nil, nil):addTo(self)
      elseif msg.result == 2 then
          ErrorLayer.new(app.lang.bind_error_2, nil, nil, nil):addTo(self)
      elseif msg.result == 3 then
          ErrorLayer.new(app.lang.bind_error_3, nil, nil, nil):addTo(self)
      elseif msg.result == 4 then
          ErrorLayer.new(app.lang.bind_error_4, nil, nil, nil):addTo(self)
      elseif msg.result == 5 then
          ErrorLayer.new(app.lang.bind_error_5, nil, nil, nil):addTo(self)
      else
          ErrorLayer.new(app.lang.bind_error, nil, nil, nil):addTo(self)
      end

  end

  function LobbyScene:updateRequestCode()

      if self.scene.bindRequest == nil then
          return
      end

      local Panel_bond1 = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Panel_bond1")
      --if CONFIG_APP_CHANNEL == "3552" then
        Panel_bond1:setTexture("Image/Pay/img_BindLayerBg_wwzj.png")
      --end
      local Panel_bond2 = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Panel_bond2")
      local Panel_bondModify = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Panel_bondModify")
      local img_SuccessTip = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "img_SuccessTip")

      if Panel_bond1 ~= nil then
          Panel_bond1:hide()
      end
      if Panel_bond2 ~= nil then
          Panel_bond2:hide()
      end
      if Panel_bondModify ~= nil then
          Panel_bondModify:hide()
      end
      if img_SuccessTip ~= nil then
          img_SuccessTip:show()
      end
      -- if Player.supid ~= -1 then

      --   Panel_bond1:hide()
      --   Panel_bond2:show()
      --   local Text_RequestCode = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Text_RequestCode")
      --   local Text_WChat = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Text_WChat")
      --   local Text_QQChat = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Text_QQChat")
      --   Text_RequestCode:setString(tostring(Player.supid))
      --   Text_WChat:setString(tostring(Player.weixin))
      --   Text_QQChat:setString(tostring(Player.qq))

      -- end

  end

  function LobbyScene:BindMobileRep(msg)
      print("LobbyScene.BindMobileRep result:"..msg.result)

      local progressLayer = self:getChildByTag(progressTag)
      if progressLayer then
          print("BindMobileRep-移除加载")
          ProgressLayer.removeProgressLayer(progressLayer)
      end

      if msg.result == 0 then

          MiddlePopBoxLayer.new(app.lang.sure_bingPhone, app.lang.sure_bingPhone, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
          if self.scene.cerLayer ~= nil then
              self.scene.cerLayer:removeFromParent()
              self.scene.cerLayer = nil
              sound_common:cancel()
          end
      elseif msg.result == 1 then
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone1, app.lang.failed_bingPhone1, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 2 then
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone2, app.lang.failed_bingPhone2, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 3 then
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone3, app.lang.failed_bingPhone3, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 4 then
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone4, app.lang.failed_bingPhone4, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 5 then
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone5, app.lang.failed_bingPhone5, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 6 then
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone6, app.lang.failed_bingPhone6, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      else
          MiddlePopBoxLayer.new(app.lang.failed_bingPhone, app.lang.failed_bingPhone, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      end

  end

  function LobbyScene:IdentityVerificationRep(msg)
      print("LobbyScene.IdentityVerificationRep result:"..msg.result)

      local progressLayer = self:getChildByTag(progressTag)
      if progressLayer then
          print("IdentityVerificationRep-移除加载")
          ProgressLayer.removeProgressLayer(progressLayer)
      end

      if msg.result == 0 then

          if self.scene.cerLayer ~= nil then

              self.scene.cerLayer:removeFromParent()
              self.scene.cerLayer = nil
              sound_common:cancel()

          end
        --验证成功提示
          Player.isverified = true
          MiddlePopBoxLayer.new(app.lang.sure_certification, app.lang.sure_certification, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)

      elseif msg.result == 1 then
          MiddlePopBoxLayer.new(app.lang.failed_certification1, app.lang.failed_certification2, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 2 then
          MiddlePopBoxLayer.new(app.lang.failed_certification2, app.lang.failed_certification2, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 3 then
          MiddlePopBoxLayer.new(app.lang.failed_certification3, app.lang.failed_certification3, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      elseif msg.result == 4 then
          MiddlePopBoxLayer.new(app.lang.failed_certification4, app.lang.failed_certification4, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      else
          MiddlePopBoxLayer.new(app.lang.failed_certification, app.lang.failed_certification, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
      end

  end


--实名认证界面
  function LobbyScene:showCertificateLayer()
      if app.constant.isOpening == true then
          return
      end
      --print("login_file = ",file)

      sound_common.menu()
      self.scene.cerLayer = cc.uiloader:load("Layer/Lobby/CertificationLayer.json"):addTo(self.scene)
      local popBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "PopBoxNode")
      util.setMenuAniEx(popBoxNode)

      local title = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Image_Title")
      local s = display.newSprite("Image/Lobby/certification/img_RenzhenTitle.png")
      local frame = s:getSpriteFrame()
      title:setSpriteFrame(frame)

      cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Image_1"):setLayoutSize(940.00, 535.00)


      -- local Text_1_0 = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Text_1_0")
      -- Text_1_0:hide()
      -- print("text_width = ",Text_1_0:getWidth())
      local textTable = {{text="（实名认证后，赠送", color=cc.c3b(61, 97, 139)},
                {text="8颗钻石", color=cc.c3b(219, 96, 95)},
                {text="）", color=cc.c3b(61, 97, 139)}}

      -- util.setRichText(Text_1_0:getParent(), cc.p(Text_1_0:getPositionX(), Text_1_0:getPositionY()), textTable, Text_1_0:getWidth(), 40, Text_1_0:getSystemFontSize())

      local Panel_Certificate = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Panel_Certificate")
      local NameInputPanel = cc.uiloader:seekNodeByNameFast(Panel_Certificate, "NameInputPanel")
      local nameInput = util.createInput(NameInputPanel, { color = cc.c4b(255,255,255, 255), placeHolder = "请输入姓名", mode = cc.EDITBOX_INPUT_MODE_ANY, maxLength = 6 })
      local NumInputPanel = cc.uiloader:seekNodeByNameFast(Panel_Certificate, "NumInputPanel")
      local numInput = util.createInput(NumInputPanel, { color = cc.c4b(255,255,255, 255), placeHolder = "请输入身份证号", mode = cc.EDITBOX_INPUT_MODE_ANY })
      local Panel_chooseCertificate = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Panel_chooseCertificate")
      local Panel_bingNum = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Panel_bingNum")

      -- local Text_choose = cc.uiloader:seekNodeByNameFast(Panel_chooseCertificate, "Text_choose")
      -- Text_choose:hide()
      -- util.setRichText(Text_choose:getParent(), cc.p(Text_choose:getPositionX(), Text_choose:getPositionY()), textTable, Text_choose:getWidth(), 40, Text_choose:getSystemFontSize())

      local close = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Close")
      :onButtonClicked(
            function ()

              local isChoose = Panel_chooseCertificate:isVisible()

              if isChoose == true then
                  self.scene.cerLayer:removeFromParent()
                  self.scene.cerLayer = nil
                  sound_common:cancel()
              else
                  Panel_bingNum:hide()
                  Panel_Certificate:hide()
                  Panel_chooseCertificate:show()
              end
            end)
      util.BtnScaleFun(close)

      Panel_bingNum:hide()
      Panel_Certificate:hide()
      Panel_chooseCertificate:show()

      local btn_bindPhone = cc.uiloader:seekNodeByNameFast(Panel_chooseCertificate, "btn_bindPhone")
      local btn_certificate = cc.uiloader:seekNodeByNameFast(Panel_chooseCertificate, "btn_certificate")
      util.BtnScaleFun(btn_bindPhone)
      util.BtnScaleFun(btn_certificate)
      btn_bindPhone:onButtonClicked(
            function()
              Panel_chooseCertificate:hide()
              Panel_Certificate:hide()
              Panel_bingNum:show()

            end
            )
      btn_certificate:onButtonClicked(
            function()
              if Player.isverified then
                  MiddlePopBoxLayer.new(app.lang.ok_certificate, app.lang.ok_certificate, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
              else
                  Panel_chooseCertificate:hide()
                  Panel_Certificate:show()
                  Panel_bingNum:hide()
              end
            end
            )

      local path = cc.FileUtils:getInstance():fullPathForFilename("Rule/badword")
      local file = cc.FileUtils:getInstance():getStringFromFile(path)
      local t = {}
      for a in string.gmatch(file, "(.-)\n") do
           table.insert(t, a)
      end
      local xs = {}
      path = cc.FileUtils:getInstance():fullPathForFilename("Rule/surname")
      file = cc.FileUtils:getInstance():getStringFromFile(path)
      for a in string.gmatch(file, "(.-)|") do
           table.insert(xs, a)
      end

      local Button_SureCertificate = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Button_SureCertificate")
      Button_SureCertificate:onButtonClicked(
            function()

                local nameInput = nameInput:getString()
                local num = util.isZhongWen(nameInput)
                if num>1 then
                    for i = 1, #t do
                      if t[i] == nameInput then
                         num = 0
                         print("t[i]:"..t[i])
                         break
                      end
                    end

                    local isXs = util.isBaiJiaXing(nameInput, xs)
                    if isXs == false then
                      num = 0
                    end
                end

                print("nameInput:"..nameInput,num)
                local numInput = numInput:getString()
                local isCard = util.verifyIDCard(numInput)
                print("numInput:"..numInput,isCard)

                -- local oldid = math.floor(checknumber(oldInput))
                -- local newid = math.floor(checknumber(newInput))
                if nameInput == "" or nameInput == nil then
                    ErrorLayer.new(app.lang.error_certificate3, nil, nil, nil):addTo(self)
                elseif num == 0 or num<2 then
                    ErrorLayer.new(app.lang.error_certificate1, nil, nil, nil):addTo(self)
                elseif numInput == "" or numInput == nil then
                    ErrorLayer.new(app.lang.error_certificate4, nil, nil, nil):addTo(self)
                elseif isCard == 1 then
                    ErrorLayer.new(app.lang.error_certificate5, nil, nil, nil):addTo(self)
                elseif isCard == 2 or isCard == 3 or isCard == 4 or isCard == 4 then
                    ErrorLayer.new(app.lang.error_certificate2, nil, nil, nil):addTo(self)
                else
                    ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                        :addTo(self,nil,progressTag)
                    UserMessage.IdentityVerificationReq(nameInput, numInput)
                end

            end)
      util.BtnScaleFun(Button_SureCertificate)

      local phoneInputPanel = cc.uiloader:seekNodeByNameFast(Panel_bingNum, "phoneInputPanel")
      local phoneInput = util.createInput(phoneInputPanel, { color = cc.c4b(255,255,255, 255), placeHolder = "请输入手机号", mode = cc.EDITBOX_INPUT_MODE_NUMERIC })

      local cerInputPanel = cc.uiloader:seekNodeByNameFast(Panel_bingNum, "cerInputPanel")
      local cerCodeInput = util.createInput(cerInputPanel, { color = cc.c4b(255,255,255, 255), placeHolder = "请输入验证码", mode = cc.EDITBOX_INPUT_MODE_NUMERIC })

      local btn_getCode = cc.uiloader:seekNodeByNameFast(Panel_bingNum, "btn_getCode")
      self.scene.btnGetCode = btn_getCode
      local Text_Count = cc.uiloader:seekNodeByNameFast(Panel_bingNum, "Text_Count")

      if app.constant.countTime > 0 and self.codeScheduler ~= nil then

         local strTime =  "重新获取(" .. app.constant.countTime .. "秒)"
         Text_Count:setString(strTime)
         self:BeginInCount()
      end

       btn_getCode:onButtonClicked(
            function()

                local iphone = phoneInput:getString()

                if #iphone ~= 11 or string.find(iphone, "[%D]") then
                    print("iphone:" .. tostring(iphone))
                    ErrorLayer.new(app.lang.iphone_error, nil, nil, nil):addTo(self)
                    return
                end

                phoneInput:setTouchEnabled(false)
                self:BeginInCount()
                self:getCode( {mobile = iphone,},
                app.lang.sending_loading, app.lang.getCode_error,
                function ()
                    phoneInput:setTouchEnabled(true)
                end)

            end
        )

        local Button_SurebingNum = cc.uiloader:seekNodeByNameFast(Panel_bingNum, "Button_SurebingNum")
       Button_SurebingNum:onButtonClicked(
            function()

                local iphone = phoneInput:getString()
                local code = cerCodeInput:getString()
                if #iphone ~= 11 or string.find(iphone, "[%D]") then
                  print("iphone:" .. tostring(iphone))
                  ErrorLayer.new(app.lang.iphone_error, nil, nil, nil):addTo(self)
                  return
                elseif (not code or #code == 0) then
                  print("code:" .. tostring(iphone))
                  ErrorLayer.new(app.lang.code_nil, nil, nil, nil):addTo(self)
                return
                end

                ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                :addTo(self,nil,progressTag)
                UserMessage.BindMobileReq(iphone, code)
            end
        )
        util.BtnScaleFun(btn_getCode)
        util.BtnScaleFun(Button_SurebingNum)

  end

  function LobbyScene:getCode(params, loading, failure, errorLayerCallBack)

      local progressLayer = ProgressLayer.new(loading, nil, function ()
                  ErrorLayer.new(app.lang.network_disabled, nil, nil, errorLayerCallBack):addTo(self)
              end)
          :addTo(self)

      function getCodeCallback(ok, msg)
          if not ok then
              print("failed:", failure .. (msg or ""))

              if msg ~= nil then
                  ErrorLayer.new( msg, nil, nil, errorLayerCallBack):addTo(self)
              else
                  ErrorLayer.new(failure .. (msg or ""), nil, nil, errorLayerCallBack):addTo(self)
              end

              ProgressLayer.removeProgressLayer(progressLayer)
              progressLayer = nil
          else

              ErrorLayer.new(app.lang.sendCode_ok, nil, nil, errorLayerCallBack, 1):addTo(self)

              ProgressLayer.removeProgressLayer(progressLayer)
                      progressLayer = nil
          end
      end

      LoginNet.getCode(getCodeCallback, params)
  end

  function LobbyScene:updateCount()

    app.constant.countTime = app.constant.countTime - 1

    if self.scene.cerLayer == nil then
        return
    end

    local btn_getCode = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "btn_getCode")
    local Text_Count = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Text_Count")

    local strTime =  "重新获取(" .. app.constant.countTime .. "秒)"
    Text_Count:setString(strTime)

    if app.constant.countTime <= 0 then

        scheduler.unscheduleGlobal(self.codeScheduler)
        self.codeScheduler = nil
        app.constant.countTime = 60
        -- if self.registerLayer.btn_ReSend ~= nil then
        --     self.registerLayer.btn_ReSend:show()
        -- end
        if btn_getCode ~= nil then
            btn_getCode:show()
        end

        Text_Count:setString("重新获取(60秒)")
        Text_Count:hide()

    end
    --print("11111----")
end

function LobbyScene:BeginInCount()

    if self.scene.cerLayer == nil then
        return
    end

    local btn_getCode = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "btn_getCode")
    local Text_Count = cc.uiloader:seekNodeByNameFast(self.scene.cerLayer, "Text_Count")

    if btn_getCode ~= nil then
        btn_getCode:hide()
    end

    if self.codeScheduler ~= nil then
            scheduler.unscheduleGlobal(self.codeScheduler)
            self.codeScheduler = nil
    end

    if Text_Count ~= nil then
        Text_Count:show()
    end

    self.codeScheduler = scheduler.scheduleGlobal(handler(self, self.updateCount), 1.0)

end

--邀请码界面
  function LobbyScene:showRequestCode()

      if app.constant.isOpening == true then
          return
      end

      sound_common.menu()
      self.scene.bindRequest = cc.uiloader:load("Layer/Lobby/BindLayer11.json"):addTo(self.scene)
      local popBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "PopBoxNode")
      util.setMenuAniEx(popBoxNode)

      local title = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Image_Title")
      local s = display.newSprite("Image/Pay/img_BindTitle.png")
      local frame = s:getSpriteFrame()
      title:setSpriteFrame(frame)

      local close = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Close")
      :onButtonClicked(
            function ()

              self.scene.bindRequest:removeFromParent()
              self.scene.bindRequest = nil
              sound_common:cancel()

            end)
      util.BtnScaleFun(close)

      local Panel_bond1 = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Panel_bond1")
      --if CONFIG_APP_CHANNEL == "3552" then
        Panel_bond1:setTexture("Image/Pay/img_BindLayerBg_wwzj.png")
      --end
      local Panel_bond2 = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Panel_bond2")
      local Panel_bondModify = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Panel_bondModify")
      Panel_bond1:hide()
      Panel_bond2:hide()
      if Panel_bondModify ~= nil then
          Panel_bondModify:hide()
      end
      -- local Button_ModifyRcode = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Button_ModifyRcode")
      -- if Button_ModifyRcode ~= nil then
      --     Button_ModifyRcode:hide()
      -- end

        local img_SuccessTip = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "img_SuccessTip")
        if img_SuccessTip ~= nil then
            img_SuccessTip:hide()
        end
        local Button_ModifyRcode = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Button_ModifyRcode")
        Button_ModifyRcode:onButtonClicked(
            function()
                if Panel_bondModify ~= nil then
                    Panel_bondModify:show()
                    Panel_bond2:hide()
                end
                if title ~= nil then
                   title:setTexture("Image/Pay/img_ModifyBind.png")
                end
            end)
        util.BtnScaleFun(Button_ModifyRcode)
       -- Button_ModifyRcode:hide()

        local OldInputPanel = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "OldInputPanel")
        local oldInput = util.createInput(OldInputPanel, { color = cc.c4b(255,255,255, 255), 
          mode = cc.EDITBOX_INPUT_MODE_NUMERIC, placeHolder = "请输入解绑码", })

        local NewInputPanel = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "NewInputPanel")
        local newInput = util.createInput(NewInputPanel, { color = cc.c4b(255,255,255, 255), 
          mode = cc.EDITBOX_INPUT_MODE_NUMERIC, placeHolder = "请输入新的邀请码" })

        local Button_SureModify = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Button_SureModify")
        Button_SureModify:onButtonClicked(
            function()

                local oldInput = oldInput:getString()
                print("oldInput:"..oldInput)
                local newInput = newInput:getString()
                print("newInput:"..newInput)

                local oldid = math.floor(checknumber(oldInput))
                local newid = math.floor(checknumber(newInput))
                if oldid == 0 or newid == 0 then
                    ErrorLayer.new(app.lang.bind_error_null, nil, nil, nil):addTo(self)
                elseif #oldInput ~= 6 then
                    ErrorLayer.new(app.lang.bind_error_unBind, nil, nil, nil):addTo(self)
                elseif newid == Player.uid then
                    ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
                else
                    ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                        :addTo(self,nil,3462)
                    self.bindId = newid
                    UserMessage.BindUserReq(newid, oldid)
                end

            end)
        util.BtnScaleFun(Button_SureModify)


      print("Player.supid = ",Player.supid)

      if Player.supid ~= -1 then

        Panel_bond2:show()
        local Text_RequestCode = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Text_RequestCode")
        local Text_WChat = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Text_WChat")
        local Text_QQChat = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Text_QQChat")
        Text_RequestCode:setString(tostring(Player.supid))
        Text_WChat:setString(tostring(Player.weixin))
        Text_QQChat:setString(tostring(Player.qq))



        return

      else

        Panel_bond1:show()
        local RequestInputPanel = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "RequestInputPanel")
        local RequestInput = util.createInput(RequestInputPanel, { color = cc.c4b(255,255,255, 255), mode = cc.EDITBOX_INPUT_MODE_NUMERIC })
        local Button_Bind = cc.uiloader:seekNodeByNameFast(self.scene.bindRequest, "Button_Bind")
        Button_Bind:onButtonClicked(
            function()

                local bondid = RequestInput:getString()
                print("bondid:"..bondid)

                local id = math.floor(checknumber(bondid))
                if id == 0 then
                    ErrorLayer.new(app.lang.bind_error_null, nil, nil, nil):addTo(self)
                elseif id == Player.uid then
                    ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
                else
                    ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                        :addTo(self,nil,3462)
                    self.bindId = id
                    UserMessage.BindUserReq(id)
                end

            end)
        util.BtnScaleFun(Button_Bind)

      end

  end

  function LobbyScene:showRuleContent(checkbox)

      if self.scene.RuleLayer == nil then
          return
      end
      local ruleLayer = self.scene.RuleLayer
      local CardList = cc.uiloader:seekNodeByNameFast(ruleLayer, "CardList")
      local RuleList = cc.uiloader:seekNodeByNameFast(ruleLayer, "RuleList")
      local img_PlayContent = cc.uiloader:seekNodeByNameFast(ruleLayer, "img_PlayContent")

      CardList:hide()
      img_PlayContent:hide()
      RuleList:hide()

      local curtype = checkbox.index

      if curtype == 1 then

        RuleList:show()

      elseif curtype == 2 then

        CardList:show()

      else

        img_PlayContent:show()

      end

  end

  function LobbyScene:showRuleMenu(checkbox)

      if self.scene.RuleLayer == nil then
          return
      end

      local ruleLayer = self.scene.RuleLayer
      curRuleType = checkbox.gameid
      --print("curRuleType = ",curRuleType)
      local popBoxNode = cc.uiloader:seekNodeByNameFast(ruleLayer, "PopBoxNode")
      local CardList = cc.uiloader:seekNodeByNameFast(ruleLayer, "CardList")
      local RuleList = cc.uiloader:seekNodeByNameFast(ruleLayer, "RuleList")
      local img_PlayContent = cc.uiloader:seekNodeByNameFast(ruleLayer, "img_PlayContent")
      local img_RuleContent = cc.uiloader:seekNodeByNameFast(ruleLayer, "img_RuleContent")

      RuleList:show()

      if curRuleType == 101 or curRuleType == 103 then
          local getPosY = RuleList:getPositionY()
          --print("getPosY = ",getPosY)
          getPosY = getPosY+32
          RuleList:setPositionY(getPosY)
          CardList:hide()
          img_PlayContent:hide()
          img_RuleContent:setTexture("Image/Lobby/ruleImg/img_ShyContent.png")
          if curRuleType == 103 then
              img_RuleContent:setTexture("Image/Lobby/ruleImg/img_ShzContent.png")
          end

          for i = 1,3 do
              local child = popBoxNode:getChildByTag(1000+i)
              if child ~= nil then
                child:removeFromParent()
                child = nil
              end
          end
          ruleLayer.Rulegroup = nil

      else
          if ruleLayer.Rulegroup == nil then
             RuleList:setPositionY(-15)
             ruleLayer.Rulegroup = RadioButtonGroup.new()
             img_RuleContent:setTexture("Image/Lobby/ruleImg/img_KyContent.png")
              for i = 1,3 do
                  local unselected = string.format("Image/Lobby/ruleImg/img_DescS%dN.png",i)
                  local selected = string.format("Image/Lobby/ruleImg/img_DescS%d.png",i)
                  local checkbox = cc.ui.UICheckBoxButton.new({
                      off = unselected,
                      off_pressed = selected,
                      off_disabled = unselected,
                      on = {selected, selected},
                      on_pressed = {unselected, selected},
                      on_disabled = {unselected, unselected},
                  })
                  --print("checkbox11 = ",checkbox)
                  checkbox:addTo(popBoxNode, nil ,1000+i)
                  checkbox:setPosition(-98.34+(i - 1) * 213,215.29)
                  checkbox.index = i

                  ruleLayer.Rulegroup:addButtons({
                      [checkbox] = handler(self, self.showRuleContent)
                  })

                  if i == 1 then
                      checkbox:setButtonSelected(true)
                  end
              end
          end

      end

  end

--游戏规则界面
  function LobbyScene:showRuleLayer()

     if app.constant.isOpening == true then
          return
      end

      sound_common.menu()
      local ruleLayer = cc.uiloader:load("Layer/Lobby/RuleLayer.json"):addTo(self.scene)
      self.scene.RuleLayer = ruleLayer
      local popBoxNode = cc.uiloader:seekNodeByNameFast(self.scene.RuleLayer, "PopBoxNode")
      util.setMenuAni(popBoxNode)

      local title = cc.uiloader:seekNodeByNameFast(self.scene.RuleLayer, "Image_Title")
      local s = display.newSprite("Image/Lobby/ruleImg/img_RuleTitle.png")
      local frame = s:getSpriteFrame()
      title:setSpriteFrame(frame)

      local GameList = cc.uiloader:seekNodeByNameFast(ruleLayer, "GameList")
      local x = GameList:getCascadeBoundingBox().width / 2 + 114
      local height = GameList:getCascadeBoundingBox().height

      local close = cc.uiloader:seekNodeByNameFast(self.scene.RuleLayer, "Close")
      :onButtonClicked(
            function ()

              self.scene.RuleLayer:removeFromParent()
              self.scene.RuleLayer = nil
              sound_common:cancel()

            end)
      util.BtnScaleFun(close)

      ruleLayer.group = RadioButtonGroup.new()
      local cnt_goods = 0
      local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
      for game_index,v in ipairs(platConfig.game) do

          if platConfig.isAppStore == true and game_index == 2 then
              break
          end

          local selected, unselected
          if v.gameid == 101 then
                unselected = "Image/Lobby/ruleImg/img_Shy_SeleN.png"
                selected = "Image/Lobby/ruleImg/img_Shy_Sele.png"
          elseif v.gameid == 106 then
                unselected = "Image/Lobby/ruleImg/img_Sss_SeleN.png"
                selected = "Image/Lobby/ruleImg/img_Sss_Sele.png"
          elseif v.gameid == 103 then
                unselected = "Image/Lobby/ruleImg/img_Shz_SeleN.png"
                selected = "Image/Lobby/ruleImg/img_Shz_Sele.png"
          end

          if selected and unselected then
              cnt_goods = cnt_goods + 1
              local checkbox = cc.ui.UICheckBoxButton.new({
                  off = unselected,
                  off_pressed = selected,
                  off_disabled = unselected,
                  on = {selected, selected},
                  on_pressed = {unselected, selected},
                  on_disabled = {unselected, unselected},
              })
              checkbox:addTo(GameList:getScrollNode())
              checkbox:setPosition(x, height + 510-40 - (cnt_goods - 1) * 80)
              checkbox.gameid = v.gameid

              ruleLayer.group:addButtons({
                  [checkbox] = handler(self, self.showRuleMenu)
              })

            if cnt_goods == 1 then
                 checkbox:setButtonSelected(true)
            end

          end

      end

  end


return LobbyScene
