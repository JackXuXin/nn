local SDKInterface = {}

function SDKInterface.shareToFriend()
    SDKInterface.shareWeixin_(false, true)
end

function SDKInterface.shareWeixin_(screenshot, friend)
    function callback(param)

        if device.platform == "android" then
            param = json.decode(param)
        end

        local result = param.result
        local isfriend = param.friend

        print("shareWeixin:ff:",isfriend)
        local scene = display.getRunningScene()
        if result == 0 then

           -- ErrorLayer.new(app.lang.share_success):addTo(scene)
           print("--------分享成功--------")
           if isfriend then 
              print("shareWeixin:isfriend:",isfriend)
              print("--------朋友圈分享成功--------")
          
              -- UserMessage.shareAddGold()
           end
           
        else
           -- ErrorLayer.new(app.lang.share_failed):addTo(scene)
            print("--------微信分享失败--------")
          
        end
        print("shareWeixin:result:",result)
        print("--------微信分享结果--------")
        print(result)

    end

     local SharedTitle = "旺旺慈溪游戏"
     local SharedDescription = "旺旺慈溪游戏［手机版］隆重上线！有五张、冲击麻将，简单又刺激..."
     local SharedUrl = "http://wwcx.wangwang68.com"
     local serverPath
     local sharePerson
     local shareFrined

     -- sharePerson或shareFrined 赋值1是app类型，赋值2是图片类型，sharePath为nil 是链接类型
     sharePath = "Image/dissolveroom_popup.png"
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


function SDKInterface.requestWChatFriend(conf)

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
      local roomTypeStr = "分钟"

      if conf.max_player == 2 then
        playerStr = "二人房间"
      else
        playerStr = "四人房间"
      end


    titleInfo = "温岭六家统，" .. "房间号：" .. conf.table_code
    local paymodeStr = "房主付费，"
    if conf.paymode == 2 then
        paymodeStr = "AA付费，"
    end
    requestInfo = paymodeStr .. conf.round .. "局"

    print(titleInfo..requestInfo)
  
    local type = 0

    SharedUrl = "http://wwcx.wangwang68.com/Invitation.html?appurl=mywwcx://domain/path&".. "type=" .. type .. "&uid=" .. uid .. "&gameID=" .. gameid .. "&roomID=" .. roomid .. "&session=" .. session
                .. "&tableid=" .. tableid .. "&seatid=" .. seatid .. "&password=" .. password

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
            SharedUrl = "https://fir.im/666byios",--SharedUrl,
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
        params.SharedUrl ="https://fir.im/666bya" --SharedUrl
        local str = json.encode(params)

        luaj.callStaticMethod("app/WeixinSDK", "shareEx", { str, callback })
  
    end

end

return SDKInterface
