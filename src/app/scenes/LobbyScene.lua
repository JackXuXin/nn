local LobbyScene = class("LobbyScene", function ()
    return display.newScene("LobbyScene")
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local GateNet = require("app.net.GateNet")
local privateRoomController = require ("app.controllers.PrivateRoomController")

local Userinfo = import("..models.Userinfo")

local function checkResponse(event)
    --dump(event)
    if event.name == "progress" then
        return 0
    end

    local request = event.request
    local ok = (event.name == "completed")
    if not ok then
        return -1
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then
        return -1
    end

    return 1
end

function LobbyScene:ctor()
    -- scene
    self.scene = cc.uiloader:load("Scene/LobbyScene.json"):addTo(self)
    require("app.controllers.ResourceController"):loadPlist("Animation", "createRoom")
    require("app.controllers.ResourceController"):loadPlist("Animation", "joinRoom")


    self.list = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(200, 200, 200, 120),
        bgScale9 = true,
        viewRect = cc.rect(50, 162, 550, 340),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :addTo(self)
end

function LobbyScene:onReciveWeixinUserinfo( event )
    local result = checkResponse(event)
    print("result:"..result)
    if result == 0 then
        return
    elseif result == -1 then
        return
    end

    local response = event.request:getResponseString()
    response = json.decode(response)
    local nick, headIcon, sex
    if response.headimgurl then
        headIcon = response.headimgurl
        print("headIcon")
        print(headIcon)
    end

    if response.nickname then
        nick = response.nickname
    end

    if response.sex then
        sex = response.sex
    end

    print("wChat:info-", nick..":"..headIcon .. ":" .. sex)
    local userinfo = Userinfo.new({
            nickname = response.nickname,
            sex = response.sex,
            headimgurl = response.headimgurl
        })
    app:setObject("self", userinfo)

    self:setHead(response.headimgurl)
    self:setNickname(response.nickname)
    app.gateNet:execute("ModifyUserdata", {addr = GateNet:getAddr("db"), nickname = response.nickname, headimgurl = response.headimgurl})
end

function LobbyScene:setHead( headimgurl )
    app:createView("NetSprite",headimgurl,self.weixinHead:getContentSize(),function ( headImg )
      --headImg:addTo(self.weixinHead)
      headImg:setAnchorPoint(0, 0)
      headImg:pos(0,0)
    end):addTo(self.weixinHead,-1)
end

function LobbyScene:setNickname( nickname )
    local nameContainer = cc.uiloader:seekNodeByName(self.scene, "weixin_nametiao")
    local nameContainerSize = nameContainer:getContentSize()
    local name = cc.ui.UILabel.new(
    {
      font="UIFont.fnt",
      color=cc.c3b(255,255,255),
      size=20, 
      text=nickname,
      align=display.CENTER,
      x = nameContainerSize.width/2,
      y = nameContainerSize.height/2
    })
    name:addTo(nameContainer)
end

function LobbyScene:getWeixinUserinfo(  )
  local account = app:getObject("account")
  local url = "https://api.weixin.qq.com/sns/userinfo?access_token="..account.assessToken_.."&openid="..account.openid_
  local request = network.createHTTPRequest(handler(self, self.onReciveWeixinUserinfo), url, "GET")
  print(url)
  request:start()
end 


function LobbyScene:showUserInfo( ok, userInfo )
	dump(userInfo, "showUserinfo")
	app.userInfo = userInfo

  self:setDiamond(userInfo.diamond.."")
  self:setId(userInfo.uid.."")
  privateRoomController:enter()
end

function LobbyScene:setDiamond( text )
  cc.uiloader:seekNodeByName(self.scene, "diamond"):setString(text)
end

function LobbyScene:setId( id )
  cc.uiloader:seekNodeByName(self.scene, "id"):setString(id)
end

function LobbyScene:joinRoom(  )
  privateRoomController:enter("111111")
  -- app:createView("RoomJoinLayer", "Layer/RoomJoinLayer.json"):addTo(self)
end

function LobbyScene:createRoom(  )
  app:createView("RoomCreateLayer", "Layer/RoomCreateLayer.json"):addTo(self)
   -- privateRoomController:create(1,2)
end

function LobbyScene:getButtonPressFun( button, buttonType )
  return function ( event )
    if event.name == "began" then  
          button:setScale(0.9)  
          if buttonType == "create" then
            self:createRoom()
          elseif buttonType == "join" then
            self:joinRoom()
          end
        elseif event.name == "moved" then  
           -- sprite:setPosition(cc.p(x,y))               
        elseif event.name == "ended" then  
            button:setScale(1)    
        end  
          
      return true  
  end
end

function LobbyScene:showTableList( ok, msg )
    if not ok then
      return
    end

    for i,tableInfo in ipairs(msg.tables) do
      self:addTableItem(tableInfo)
    end

    self.list:reload()
end

function LobbyScene:endTable( msg )
  local delItem = self.list:find(function ( item )
    return item.table_code == msg.table_code
  end)
  if delItem then
    self.list:removeItem(delItem, true)
  else
    printError("table %s is nil", msg.table_code)
  end
end

function LobbyScene:addTableItem( tableInfo )
  dump(tableInfo, "addTable")
  local newItem = self.list:newItem()
  local content = app:createView("RoomItemNode", "Node/RoomItemNode.json", tableInfo)
  newItem:addContent(content)
  newItem:setItemSize(260, 91)
  newItem.table_code = tableInfo.table_code
  newItem:performWithDelay(function (  )
    self.list:removeItem(newItem, true)
  end, tableInfo.time)
  self.list:addItem(newItem)
end

function LobbyScene:addTable( tableInfo )
  self:addTableItem(tableInfo)
  self.list:reload()
end

function LobbyScene:onEnter()
   dump({addr = GateNet:getAddr("db")},"getAddr")
   GateNet:call("UserInfo", {addr = GateNet:getAddr("db")}, handler(self, self.showUserInfo))
   GateNet:call("TableList", {}, handler(self, self.showTableList))
  GateNet:registerHandler("EndRoom", handler(self, self.endRoom))

  self.createRoomBtn = cc.uiloader:seekNodeByName(self.scene, "createRoom")
  self.createRoomBtn:playAnimationForever(require("app.controllers.ResourceController"):getAnimation("create", 20))
  self.createRoomBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, self:getButtonPressFun(self.createRoomBtn, "create"))
  self.createRoomBtn:setTouchEnabled(true)

  self.joinRoomBtn = cc.uiloader:seekNodeByName(self.scene, "joinRoom")
  self.joinRoomBtn:playAnimationForever(require("app.controllers.ResourceController"):getAnimation("join", 20, 0.25))
  self.joinRoomBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, self:getButtonPressFun(self.joinRoomBtn, "join"))
  self.joinRoomBtn:setTouchEnabled(true)

  self.weixinHead = cc.uiloader:seekNodeByName(self.scene, "wenxin_head")

  if device.platform ~= "mac" then
    self:getWeixinUserinfo()
  end
end

return LobbyScene
