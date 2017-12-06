local UserMessage = require("app.net.UserMessage")
local util = require("app.Common.util")
local RoomConfig = require("app.config.RoomConfig")
local sound_common = require("app.Common.sound_common")
local PlatConfig = require("app.config.PlatformConfig")
local Account = app.userdata.Account

local Share = {}

local ErrorLayer = require("app.layers.ErrorLayer")

--local ewmImg = nil
local ProgressLayer = require("app.layers.ProgressLayer")

local isScreen = false

local function shareQQ(screenshot, qzone)
    if device.platform == "ios" then
        luaoc.callStaticMethod("TencentSDK", "share", {
            screenshot = screenshot,
            qzone = qzone,
        })
    elseif device.platform == "android" then
        luaj.callStaticMethod("app/QQSDK", "share", {
            screenshot,
            qzone,
        })
    end
end

function Share.SetGameShareFun(sceneRoot)

    if isScreen == true then
        return
    end

    isScreen = true

    -- ewmImg = cc.ui.UIImage.new("Platform_Src/Image/Lobby/ewm2.png")
    -- local width, height = ewmImg:getLayoutSize()
    -- ewmImg:pos(display.right-width*0.8, display.top-height*0.8)
    --         :addTo(sceneRoot,2000)
    --         :setScale(0.8)
    --         :show()

    Share.createGameShareLayer():addTo(sceneRoot,40000)

end

function Share.SetGameShareBtn(isShow, sceneRoot, posX, posY)

    if Account.tags.recharge_tag ~= "1" then

        return

    end


    local shareBtn = cc.ui.UIPushButton.new({ normal = "Image/Share/end/btn_ShareGame.png", pressed = "Image/Share/end/btn_ShareGame2.png" })
         :onButtonClicked(function()

         Share.SetGameShareFun(sceneRoot)
         -- ewmImg:removeFromParent()
         end)
       :pos(posX, posY)
       :addTo(sceneRoot,101)

    shareBtn:setVisible(isShow)

end

function Share.requestWChatFriend(roomId, playerNum, roomType, gameID, payType, customization)
     function callback(param)

        if device.platform == "android" then
            param = json.decode(param)
        end

        local result = param.result

        print("requestWChatFriend:result:",result)

    end

     local requestInfo = ""
     local titleInfo = ""
     local SharedUrl = ""
     local isAddFriend = true


     if device.platform == "ios" then

            SharedUrl = "https://itunes.apple.com/cn/app/jiang-nan-cha-yuan/id1109346301?mt=8"
      end

      local gameid = "1"
      local roomid = "0"
      local uid = "0"
      local session = "1"
      local tableid = "1"
      local seatid = "1"
      local password = "1"

      local playerStr = ""
      local roomTypeStr = ""

      if playerNum == 2 then

        playerStr = "二人房间，"

      elseif playerNum == 3 then

        playerStr = "三人房间，"

      elseif playerNum == 4 then

        playerStr = "四人房间，"

      else

        playerStr = "五人房间，"

      end

      if roomType == 100 then

        roomTypeStr = "分局。"

      else

        roomTypeStr = "局。"

      end

    if CONFIG_APP_CHANNEL == "3550" then

        local paystr = "AA扣钻，"
        if payType == 1 then
            paystr = "房主支付，"
        end
        local game_name = "冲击麻将私人房，"   
        if gameID == 108 then
           game_name = "冲击麻将私人房，" 
           titleInfo = game_name .. "房间号：" .. roomId
           requestInfo = paystr .. playerStr .. roomType .. roomTypeStr        
        elseif gameID == 116 then
           game_name = "牛牛私人房，" 
           titleInfo = game_name .. "房间号：" .. roomId
           requestInfo = paystr .. playerStr .. roomType .. roomTypeStr        
        elseif gameID == 106 then
            titleInfo = "罗松私人房，" .. "房间号：" .. roomId
            local addStr = "不加牌"
            local syStr = "，不加苍蝇"

            --加一色 加1王 加2王
            if util.test_bit(customization, 1) == 1 then        --不加牌
                -- addStr = "不加牌"
            elseif util.test_bit(customization, 2) == 1 then    --加一色
                addStr = "加一色"
            elseif util.test_bit(customization, 3) == 1 then    --加1王
                addStr = "加1王"
            elseif util.test_bit(customization, 4) == 1 then    --加2王
                addStr = "加2王"
            end

            --黑桃10苍蝇 ，红桃5苍蝇
            if util.test_bit(customization, 6) == 1 then       --不加苍蝇
                -- syStr = "，不加苍蝇"
            elseif util.test_bit(customization, 7) == 1 then   --黑桃10苍蝇
                syStr = "，黑桃10苍蝇"
            elseif util.test_bit(customization, 8) == 1 then   --红桃5苍蝇
                syStr = "，红桃5苍蝇"
            end
            requestInfo = paystr .. playerStr .. roomType .. roomTypeStr .. addStr .. syStr
        end

        



    elseif CONFIG_APP_CHANNEL == "3551" then

        titleInfo = "冲击麻将私人房，" .. "房间号：" .. roomId
        requestInfo = "AA扣钻，" .. playerStr .. roomType .. roomTypeStr

    elseif CONFIG_APP_CHANNEL == "3553" or CONFIG_APP_CHANNEL == "3554" or CONFIG_APP_CHANNEL == "3552" or CONFIG_APP_CHANNEL == "3556" then

        local paystr = "AA扣钻，"

        if payType == 1 then
            paystr = "房主支付，"
        end

        if gameID == 101 then
            titleInfo = "上虞麻将私人房，" .. "房间号：" .. roomId

            local chao = util.test_bit(customization, 1)
            local huaIndex = 2
            for i = 2, 5 do
                local hua = util.test_bit(customization, i)
                if hua == 1 then
                    huaIndex = i
                    break
                end
            end
            local chaoStr = ""
            if chao == 1 then
                chaoStr = "，超一进十"
            end
            --print("customization = ",customization,chao)
            --print("chaoStr = ",chaoStr)
            requestInfo = paystr .. playerStr .. roomType .. roomTypeStr .. huaIndex .. "花，豹子翻倍，承包5倍" .. chaoStr
            print("requestInfo = ",requestInfo)

        elseif gameID == 103 then
            titleInfo = "嵊州麻将私人房，" .. "房间号：" .. roomId
            local suanfenStr = "算分1-3-10，"
            if customization == 2 then
                suanfenStr = "算分2-5-15，"
            end
            requestInfo = paystr .. playerStr .. roomType .. roomTypeStr .. suanfenStr .. "承包5倍"
            print("requestInfo = ",requestInfo)

        elseif gameID == 106 then
            titleInfo = "罗松私人房，" .. "房间号：" .. roomId
            local addStr = "不加牌"
            local syStr = "，不加苍蝇"

            --加一色 加1王 加2王
            if util.test_bit(customization, 1) == 1 then        --不加牌
                -- addStr = "不加牌"
            elseif util.test_bit(customization, 2) == 1 then    --加一色
                addStr = "加一色"
            elseif util.test_bit(customization, 3) == 1 then    --加1王
                addStr = "加1王"
            elseif util.test_bit(customization, 4) == 1 then    --加2王
                addStr = "加2王"
            end

            --黑桃10苍蝇 ，红桃5苍蝇
            if util.test_bit(customization, 6) == 1 then       --不加苍蝇
                -- syStr = "，不加苍蝇"
            elseif util.test_bit(customization, 7) == 1 then   --黑桃10苍蝇
                syStr = "，黑桃10苍蝇"
            elseif util.test_bit(customization, 8) == 1 then   --红桃5苍蝇
                syStr = "，红桃5苍蝇"
            end
            requestInfo = paystr .. playerStr .. roomType .. roomTypeStr .. addStr .. syStr
        elseif gameID == 116 then
           game_name = "牛牛私人房，" 
           titleInfo = game_name .. "房间号：" .. roomId
           requestInfo = paystr .. playerStr .. roomType .. roomTypeStr
        elseif gameID == 110 then
           game_name = "斗地主私人房，" 
           titleInfo = game_name .. "房间号：" .. roomId
           requestInfo = paystr .. playerStr 
           --加一色 加1王 加2王
          if util.test_bit(customization, 1) == 1 then        --不加牌
              requestInfo = requestInfo .."3人1副牌," .. roomType .. roomTypeStr
          elseif util.test_bit(customization, 2) == 1 then    --加一色
              requestInfo = requestInfo .."3人2副牌," .. roomType .. roomTypeStr
          elseif util.test_bit(customization, 3) == 1 then    --加2王
              requestInfo = requestInfo .."4人2副牌," .. roomType .. roomTypeStr
          end
        end
    end

    if CONFIG_APP_CHANNEL == "3550" then

        local type = 0

        SharedUrl = "http://wwyy.wangwang68.com/Invitation.html?appurl=mywwyy://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3551" then

        local type = 0

        SharedUrl = "http://wwcx.wangwang68.com/Invitation.html?appurl=mywwcx://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3552" then

        local type = 0

        SharedUrl = "http://wwzj.wangwang68.com/Invitation.html?appurl=mywwdy://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password
    elseif CONFIG_APP_CHANNEL == "3553" then

        local type = 0

        SharedUrl = "http://wwsx.wangwang68.com/Invitation.html?appurl=mywwsx://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password
    elseif CONFIG_APP_CHANNEL == "3554" then

        local type = 0

        SharedUrl = "https://fir.im/kxmqp/Invitation.html?appurl=mykxmqp://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3556" then

        local type = 0

        SharedUrl = "http://ypls.wangwang68.com/Invitation.html?appurl=myypls://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "1801" then

        local type = 0

        SharedUrl = "http://jinling.gametea.me/Invitation.html?appurl=mywwjl://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password
     end

     if device.platform == "ios" then

         print("requestInfo:",requestInfo)

        luaoc.callStaticMethod("WeixinSDK", "shareEx", {
            isAddFriend = isAddFriend,
            gameid = gameid .. "",
            roomid = roomid .. "",
            uid = uid .. "",
            session = session .. "",
            tableid = tableid .. "",
            seatid = seatid .. "",
            password = password,
            titleInfo = titleInfo,
            requestInfo = requestInfo,
            SharedUrl = SharedUrl,
            callback = callback,
        })
    elseif device.platform == "android" then

        print("shareWeixin:callback:",callback)

        local params = {}

        params.isAddFriend = isAddFriend
        params.gameid = gameid .. ""
        params.roomid = roomid .. ""
        params.uid = uid .. ""
        params.session = session .. ""
        params.tableid = tableid .. ""
        params.seatid = seatid .. ""
        params.password = password
        params.titleInfo = titleInfo
        params.requestInfo = requestInfo
        params.SharedUrl = SharedUrl
        local str = json.encode(params)

        luaj.callStaticMethod("app/WeixinSDK", "shareEx", { str, callback })

    end

end

function requestFriendWeixin(isAdd, uid, nickname)

    function callback(param)

        if device.platform == "android" then
            param = json.decode(param)
        end

        local result = param.result

        print("requestFriendWeixin:result:",result)

    end

     local requestInfo = ""
     local titleInfo = ""
     local SharedUrl = "http://jiangnangame.com/"
     local isAddFriend = isAdd



     if device.platform == "ios" then

            SharedUrl = "https://itunes.apple.com/cn/app/jiang-nan-cha-yuan/id1109346301?mt=8"
      end

      local gameid = "1"
      local roomid = "0"
      local uid = uid
      local session = "1"
      local tableid = "1"
      local seatid = "1"
      local password = "1"

     if isAddFriend == false then

        if util.UserInfo == nil then

             return
        end

        gameid = util.UserInfo.gameid
        roomid = util.UserInfo.roomid
        session = util.UserInfo.room_session
        tableid = util.UserInfo.table_id
        seatid = util.UserInfo.seat_id
        password = util.UserInfo.password

        if password == "" or password == nil then
            password = "1"
        end

        local config = RoomConfig:getGameConfig(gameid)
        local roomName = ""

        for i,room in ipairs(config.room) do

        --if config.room.invisible == nil or config.room.invisible ~= 1 then

            local rID = room.roomid
            local gID = room.gameid

            if rID == roomid and gID == gameid then

                roomName = room.name

                break

            end

      end

        print("roomName:", roomName)

        titleInfo = "[" ..nickname .."]邀请您加入牌局"
        requestInfo = "[".. nickname .."]在" .. "[".. config.name .."]邀请您加入，点击链接直接进入游戏"

        if CONFIG_APP_CHANNEL == "3550" then

             titleInfo = "我在玩[余姚".. config.name .."]，三缺一，快来！"
             requestInfo = "我在[旺旺余姚游戏]邀请您加入牌局，超多本地人一起玩！点击进入"

        elseif CONFIG_APP_CHANNEL == "3551" then

             titleInfo = "我在玩[慈溪".. config.name .."]，三缺一，快来！"
             requestInfo = "我在[旺旺慈溪游戏]邀请您加入牌局，超多本地人一起玩！点击进入"

        elseif CONFIG_APP_CHANNEL == "3553" then

             titleInfo = "我在玩[绍兴".. config.name .."]，三缺一，快来！"
             requestInfo = "我在[旺旺绍兴游戏]邀请您加入牌局，超多本地人一起玩！点击进入"

        end

     else

        titleInfo = "游戏邀请"
        requestInfo = "您的好友邀请您一起玩游戏，好友ID：" .. uid .. "。" .. "游戏中在好友查找内搜索此ID就能加为好友"

     end

   if CONFIG_APP_CHANNEL == "1801" then

        local type = 0

        if device.platform == "ios" then

            type = 0

        else

            type = 1
        end

         SharedUrl = "http://jinling.gametea.me/Invitation.html?appurl=mywwjl://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3550" then

        local type = 0

        if device.platform == "ios" then

            type = 0

        else

            type = 1

        end

         SharedUrl = "http://wwyy.wangwang68.com/Invitation.html?appurl=mywwyy://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3551" then

        local type = 0

        if device.platform == "ios" then

            type = 0

        else

            type = 1

        end

         SharedUrl = "http://wwcx.wangwang68.com/Invitation.html?appurl=mywwcx://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3552" then

        local type = 0

        if device.platform == "ios" then

            type = 0

        else

            type = 1
        end

         SharedUrl = "http://wwzj.wangwang68.com/Invitation.html?appurl=mywwdy://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "3553" then

        local type = 0

        if device.platform == "ios" then

            type = 0

        else

            type = 1
        end

         SharedUrl = "http://wwsx.wangwang68.com/Invitation.html?appurl=mywwsx://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

      elseif CONFIG_APP_CHANNEL == "3554" then

        local type = 0

        if device.platform == "ios" then

            type = 0

        else

            type = 1
        end

         SharedUrl = "https://fir.im/kxmqp/Invitation.html?appurl=mykxmqp://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

    elseif CONFIG_APP_CHANNEL == "1802" then

        local type = 0

        if device.platform == "ios" then

            type = 0

             SharedUrl = "http://jinling.gametea.me/Invitation.html?appurl=myhhsz://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

        else

            type = 1

             SharedUrl = "http://jinling.gametea.me/Invitation.html?appurl=myhhsz://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

        end

     end


    print("isAddFriend:", isAdd)

    if device.platform == "ios" then

         print("requestInfo:",requestInfo)

        luaoc.callStaticMethod("WeixinSDK", "shareEx", {
            isAddFriend = isAddFriend,
            gameid = gameid .. "",
            roomid = roomid .. "",
            uid = uid .. "",
            session = session .. "",
            tableid = tableid .. "",
            seatid = seatid .. "",
            password = password,
            titleInfo = titleInfo,
            requestInfo = requestInfo,
            SharedUrl = SharedUrl,
            callback = callback,
        })
    elseif device.platform == "android" then

        print("shareWeixin:callback:",callback)

        local params = {}

        params.isAddFriend = isAddFriend
        params.gameid = gameid .. ""
        params.roomid = roomid .. ""
        params.uid = uid .. ""
        params.session = session .. ""
        params.tableid = tableid .. ""
        params.seatid = seatid .. ""
        params.password = password
        params.titleInfo = titleInfo
        params.requestInfo = requestInfo
        params.SharedUrl = SharedUrl
        local str = json.encode(params)

        luaj.callStaticMethod("app/WeixinSDK", "shareEx", { str, callback })

    end
end

local function shareWeixin(screenshot, friend)
  
    --UserMessage.shareAddGold()
    function callback(param)

        if device.platform == "android" then
            param = json.decode(param)
        end

        local result = param.result
        local isfriend = param.friend

        print("shareWeixin:ff:",isfriend)
        local scene = display.getRunningScene()
        if result == 0 then

           ErrorLayer.new(app.lang.share_success):addTo(scene,88888)

           if isfriend then
              print("shareWeixin:isfriend:",isfriend)
              UserMessage.shareAddGold()
           end

        else
           ErrorLayer.new(app.lang.share_failed):addTo(scene,88888)
        end
        print("shareWeixin:result:",result)

    end

     local SharedTitle = "旺旺慈溪游戏"
     local SharedDescription = "旺旺慈溪游戏［手机版］隆重上线！有五张、冲击麻将，简单又刺激..."
     local SharedUrl = "http://wwcx.wangwang68.com"
     local serverPath
     local sharePerson
     local shareFrined

     if CONFIG_APP_CHANNEL == "3550" then

         SharedTitle = "旺旺余姚游戏"
         SharedDescription = "旺旺余姚游戏［手机版］隆重上线！有五张、冲击麻将，简单又刺激..."
         SharedUrl = "http://wwyy.wangwang68.com"

        -- if friend then
        --     print("shareWeixin:isfriend:",friend)
        --     UserMessage.shareAddGold()
        -- end

     elseif CONFIG_APP_CHANNEL == "3551" then

         SharedTitle = "旺旺慈溪游戏"
         SharedDescription = "旺旺慈溪游戏［手机版］隆重上线！有五张、冲击麻将，简单又刺激..."
         SharedUrl = "http://wwcx.wangwang68.com"

    elseif CONFIG_APP_CHANNEL == "3552" then

         SharedTitle = "旺旺诸暨游戏"
         SharedDescription = "旺旺诸暨游戏［手机版］隆重上线！有五张、东阳麻将，简单又刺激..."
         SharedUrl = "http://wwzj.wangwang68.com"

    elseif CONFIG_APP_CHANNEL == "3556" then

         SharedTitle = "一品罗松"
         SharedDescription = "一品罗松［手机版］隆重上线！有五张、东阳麻将，简单又刺激..."
         SharedUrl = "http://ypls.wangwang68.com"

    elseif CONFIG_APP_CHANNEL == "3553" then

         SharedTitle = "旺旺绍兴游戏"
         SharedDescription = "旺旺绍兴游戏［手机版］隆重上线！有五张、绍兴麻将，简单又刺激..."
         SharedUrl = "http://wwsx.wangwang68.com"
   elseif CONFIG_APP_CHANNEL == "3554" then

         SharedTitle = "凯旋门棋牌"
         SharedDescription = "凯旋门棋牌［手机版］隆重上线！有罗松、嵊州麻将，简单又刺激..."
         SharedUrl = "https://fir.im/kxmqp"

    elseif CONFIG_APP_CHANNEL == "1801" then

         SharedTitle = "金陵茶苑"
         SharedDescription = "金陵茶苑［手机版］隆重上线！有五张、南京麻将，简单又刺激..."
         SharedUrl = "http://jinling.gametea.me"

     end

     -- sharePerson或shareFrined 赋值1是app类型，赋值2是图片类型，sharePath为nil 是链接类型
     sharePath = "Platform_Src/Image/share.png"
     sharePerson = 2
     shareFrined = 2

    if device.platform == "ios" then

         print("shareWeixin:screenshot:",screenshot)
         print("shareWeixin:friend:",friend)
         print("shareWeixin:callback:",callback)


        luaoc.callStaticMethod("WeixinSDK", "share", {
            screenshot = screenshot,
            friend = friend,
            callback = callback,
            SharedTitle = SharedTitle,
            SharedDescription = SharedDescription,
            SharedUrl = SharedUrl,
            sharePath = sharePath,
            sharePerson = sharePerson,
            shareFrined = shareFrined
        })
    elseif device.platform == "android" then

      print("shareWeixin:callback:",callback)

      local params = {}

        params.screenshot = screenshot
        params.friend = friend
        params.SharedTitle = SharedTitle
        params.SharedDescription = SharedDescription
        params.SharedUrl = SharedUrl
        params.sharePath = "res/" .. sharePath
        params.sharePerson = sharePerson
        params.shareFrined = shareFrined

        local str = json.encode(params)

        luaj.callStaticMethod("app/WeixinSDK", "share", { str, callback })

    end
end

function Share.shareToFriend()
    shareWeixin(false, true)
end

function Share.createLobbyShareLayer()

    if app.constant.isOpening == true then
          return
    end

    sound_common.menu()

	local shareLayer = cc.uiloader:load("Layer/Lobby/ShareLobbyLayer.json")
    local popBoxNode = cc.uiloader:seekNodeByNameFast(shareLayer, "PopBoxNode")
    util.setMenuAniEx(popBoxNode)
    local close = cc.uiloader:seekNodeByNameFast(shareLayer, "Close")
    util.BtnScaleFun(close)
    close:onButtonClicked(function ()
        shareLayer:removeFromParent()
        shareLayer = nil
        sound_common.cancel()
    end)

    local img_title = cc.uiloader:seekNodeByNameFast(shareLayer, "Image_Title")
    local s = display.newSprite("Image/Share/share_title.png")
    local frame = s:getSpriteFrame()
    img_title:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(shareLayer, "Image_1"):setLayoutSize(943, 538)

    local weiixn = cc.uiloader:seekNodeByNameFast(shareLayer, "Weixin"):onButtonClicked(function ()
        shareWeixin(false, false)
    end)
    local friend = cc.uiloader:seekNodeByNameFast(shareLayer, "Friend"):onButtonClicked(function ()
        shareWeixin(false, true)
       -- UserMessage.shareAddGold()
    end)

    util.BtnScaleFun(weiixn)
    util.BtnScaleFun(friend)

    -- local popBoxNode = cc.uiloader:seekNodeByNameFast(shareLayer, "PopBoxNode")
    -- popBoxNode:setScale(0)
    -- transition.scaleTo(popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

--modify by whb 0324
    local Text_4 = cc.uiloader:seekNodeByNameFast(popBoxNode, "Text_4")
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    Text_4:setString(platConfig.shareLayer_Text_4)
    local Text_3 = cc.uiloader:seekNodeByNameFast(popBoxNode, "Text_3")
    Text_3:setString(platConfig.share_Text_3)


--modify end

    return shareLayer
end

function Share.createLobbyAttenLayer()
    local shareLayer = cc.uiloader:load("Layer/Lobby/AttenLobbyLayer.json")

    -- cc.uiloader:seekNodeByNameFast(shareLayer, "Title")
    --     :setString(app.lang.share)
    cc.uiloader:seekNodeByNameFast(shareLayer, "Close")
        :onButtonClicked(function ()
            shareLayer:removeFromParent()
            sound_common.cancel()
        end)

    local popBoxNode = cc.uiloader:seekNodeByNameFast(shareLayer, "PopBoxNode")
    popBoxNode:setScale(0)
    transition.scaleTo(popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

    --modify by whb 0324
    local Text_4 = cc.uiloader:seekNodeByNameFast(popBoxNode, "Text_4")
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    Text_4:setString(platConfig.shareLayer_Text_4)

--modify end

    return shareLayer
end

function Share.createGameShareLayer()
	node = display.newNode()

      --print("createGameShareLayer000-----")

	display.captureScreen(function (succeed, outputFile)
		print(succeed, outputFile)


        -- if ewmImg ~= nil then

        --     ewmImg:removeFromParent()
        --     ewmImg = nil
        -- end

         --print("create000-----")

		local shareLayer = cc.uiloader:load("Layer/Game/ShareGameLayer.json"):addTo(node)

		local screenshotPanel = cc.uiloader:seekNodeByNameFast(shareLayer, "ScreenshotPanel")
		local panelSize = screenshotPanel:getContentSize()

        --print("create111-----")

		local texture = cc.Director:getInstance():getTextureCache():addImage(outputFile)
		display.newScale9Sprite(outputFile, panelSize.width / 2, panelSize.height / 2, panelSize,
			cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
		:addTo(screenshotPanel)

        --print("create2222-----")

		cc.uiloader:seekNodeByNameFast(shareLayer, "Close")
		    :onButtonClicked(function ()
                sound_common.cancel()
		        node:removeFromParent()
                 isScreen = false
		        cc.Director:getInstance():getTextureCache():removeTexture(texture)
		    end)

		cc.uiloader:seekNodeByNameFast(shareLayer, "Weixin"):onButtonClicked(function ()
		    shareWeixin(true, false)
		end)
		cc.uiloader:seekNodeByNameFast(shareLayer, "Friend"):onButtonClicked(function ()
		    shareWeixin(true, true)
		end)

		local popBoxNode = cc.uiloader:seekNodeByNameFast(shareLayer, "PopBox")
		popBoxNode:setScale(0)
		transition.scaleTo(popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

	end, app.constant.screenshot_file)

	return node
end

return Share