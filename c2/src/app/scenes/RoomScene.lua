local RoomScene = class("RoomScene", function ()
	return display.newScene("RoomScene")
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local message = require("app.net.Message")
local errorLayer = require("app.layers.ErrorLayer")
local userdata = require("app.UserData")
local util = require("app.Common.util")

local msgMgr = require("app.room.msgMgr")

local AvatarConfig = require("app.config.AvatarConfig")
local RequireTablePasswordLayer = require("app.layers.RequireTablePasswordLayer")

local ErrorLayer = require("app.layers.ErrorLayer")
local sound_common = require("app.Common.sound_common")

-- require("app.room.utils") --NOTE: for refactor convinence

local TABLE_STATE = msgMgr.TABLE_STATE

local table_idle_pic = nil
local table_busy_pic = nil
local seat_icon_pic = nil
local hand_icon_pic = nil
local lock_icon_pic = nil

local sprintTable = {}

local table_cnt = 0
local seat_cnt = 0
local seats_table = nil 

function RoomScene:init_room_info(config, gameid)
    print("RoomScene:init_room_info")
    seat_cnt = config.seats
    seats_table = config.seatslayout

    g_seats_table = seats_table
    
    --dump(config)
    --dump(config.layout)
    --dump(seats_table)
    print("RoomScene:seat_cnt",seat_cnt)

    msgMgr:setMaxPlayer(config.seats, seats_table)
    if config.gamekey ~= nil then
        msgMgr:setGameKey(config.gamekey)
    else
        msgMgr:setGameKey("")
    end

    -- bairenniuniu no table ui
    if gameid == 105 then
        sprintTable = {}
        for i=1, tonumber(config.tables) do
            table.insert(sprintTable, {})
        end
        table_cnt = config.tables
        return
    end
    dump(config.layout)
    table_idle_pic = tostring(config.layout.table.idle)
    print("table_idle_pic:",table_idle_pic)
    local texture = cc.Director:getInstance():getTextureCache():addImage(table_idle_pic)
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, tonumber(texture:getPixelsWide()), tonumber(texture:getPixelsHigh())))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, table_idle_pic)

    table_busy_pic = config.layout.table.busy
    texture = cc.Director:getInstance():getTextureCache():addImage(table_busy_pic)
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, table_busy_pic)

    lock_icon_pic = config.layout.lock.icon
    texture = cc.Director:getInstance():getTextureCache():addImage(lock_icon_pic)
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, lock_icon_pic)

    seat_icon_pic = {}
    for i = 1, #config.layout.seat do
        seat_icon_pic[config.layout.seat[i].id] = config.layout.seat[i].icon
        texture = cc.Director:getInstance():getTextureCache():addImage(seat_icon_pic[config.layout.seat[i].id])
        frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, seat_icon_pic[config.layout.seat[i].id])
    end

    hand_icon_pic = {}
    for i = 1, #config.layout.hand do
        hand_icon_pic[config.layout.hand[i].id] = config.layout.hand[i].icon
        texture = cc.Director:getInstance():getTextureCache():addImage(hand_icon_pic[config.layout.hand[i].id])
        frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, hand_icon_pic[config.layout.hand[i].id])
    end

    local count = math.floor(display.width / config.layout.width)
     print("RoomScene:count:" .. count)
    if config.tables > 0 and count > 0 then
        table_cnt = config.tables
        local rows = math.floor(config.tables/count)
        if config.tables%count > 0 then 
            rows = rows + 1 
        end

        local emptyNode = cc.Node:create()
        if rows * config.layout.height > display.height-81 then
            emptyNode:setContentSize(display.width, rows * config.layout.height)
        else
            emptyNode:setContentSize(display.width, display.height-81)
        end

        for temp = 1, tonumber(config.tables) do
            local tb = {table=nil, seat={}, avatar = {},name={}, hand={}}
            local index = tonumber(config.tables) - temp + 1
            local posx = ((index - 1) % count)*config.layout.width
            local posy = (rows-math.floor((index-1)/count)-1)*config.layout.height
            local table = display.newSprite("#"..table_idle_pic)
            :pos(posx+tonumber(config.layout.table.posx), posy+tonumber(config.layout.table.posy))
            :addTo(emptyNode)
            tb.table = table

            local lock = display.newSprite("#"..lock_icon_pic)
            :pos(posx+tonumber(config.layout.lock.posx), posy+tonumber(config.layout.lock.posy))
            :hide()
            :addTo(emptyNode)
            tb.lock = lock

            --test by whb

             --lock:pos(posx+tonumber(config.layout.lock.posx-25), posy+tonumber(config.layout.lock.posy-25))

            --test

            local number = #config.layout.seat
            local position = nil
            if seats_table ~= nil then
                local pos = (index - 1) % (#seats_table) + 1
                number = #seats_table[pos]
                position = seats_table[pos]
            end

            for i = 1, number do
                local pos = i
                if position ~= nil then
                    pos = position[i]
                end

                local seat
--modify by whb 161026
                if gameid == 102 then

                    print("number:" .. tostring(number)..",pos:" .. tostring(pos))
                    if number == 2 and pos == 1 then
                        seat = display.newSprite("#"..seat_icon_pic[config.layout.seat[3].id])
                        :addTo(emptyNode,-1)
                        seat:pos(posx+tonumber(config.layout.seat[3].posx), posy+tonumber(config.layout.seat[pos].posy))
                        seat:flipY(true)
                        local posx,posy = seat:getPosition()
                         print("seat_icon_pic:pos:" .. posx .. ":" .. posy)
                    else
                         seat = display.newSprite("#"..seat_icon_pic[config.layout.seat[pos].id])
                        :pos(posx+tonumber(config.layout.seat[pos].posx), posy+tonumber(config.layout.seat[pos].posy))
                        :addTo(emptyNode,-1)
                    end
                else

                    --todo
                    seat = display.newSprite("#"..seat_icon_pic[config.layout.seat[pos].id])
                    :pos(posx+tonumber(config.layout.seat[pos].posx), posy+tonumber(config.layout.seat[pos].posy))
                    :addTo(emptyNode,-1)

                  
                    -- if pos==2 then
                    -- seat:pos(posx+tonumber(config.layout.seat[pos].posx-5), posy+tonumber(config.layout.seat[pos].posy))
                    -- elseif pos==4 then
                    -- seat:pos(posx+tonumber(config.layout.seat[pos].posx+3), posy+tonumber(config.layout.seat[pos].posy))
                    -- end
                end
--modify end

                -- seat = display.newSprite("#"..seat_icon_pic[config.layout.seat[pos].id])
                -- :pos(posx+tonumber(config.layout.seat[pos].posx), posy+tonumber(config.layout.seat[pos].posy))
                -- :addTo(emptyNode,-1)

                seat:setTouchEnabled(true)
                seat:setTouchSwallowEnabled(false)
                seat:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                    if event.name == "began" then
                        seat.x = event.x
                        seat.y = event.y
                        return true
                    elseif event.name == "ended" then
                        if seat:hitTest(cc.p(event.x, event.y), false) and math.abs(seat.x-event.x)<10 and  math.abs(seat.y-event.y)<10 then
                            self:selectSeat(index, i)
                        end
                    end
                end)
--                 if config.layout.seat[pos].apx and config.layout.seat[pos].apy then
--                     seat:setAnchorPoint(cc.p(config.layout.seat[pos].apx,config.layout.seat[pos].apy))
-- --modify by whb 161026
--                     if gameid == 102 then

--                         if number == 2 and pos == 1 then
--                          seat:setAnchorPoint(cc.p(config.layout.seat[3].apx,config.layout.seat[pos].apy))
--                         end
--                     end
-- --modify end
--                 end
                tb.seat[tonumber(i)] = seat

                --添加头像
                local avatar_ = display.newSprite()
                avatar_:setPosition(seat:getPositionX(),seat:getPositionY())
                avatar_:addTo(emptyNode)
                avatar_:hide()

                avatar_:setTouchEnabled(true)
                avatar_:setTouchSwallowEnabled(false)
                avatar_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
                    if event.name == "began" then
                        seat.x = event.x
                        seat.y = event.y
                        return true
                    elseif event.name == "ended" then
                        -- if seat:hitTest(cc.p(event.x, event.y), false) then
                        if math.abs(seat.x-event.x)<10 and  math.abs(seat.y-event.y)<10 then
                            self:selectSeat(index, i)
                        end
                    end
                end)

               local avatar_bg = display.newSprite("Image/Common/Avatar/bg_gray.png")
               avatar_bg:setPosition(59,49)
               avatar_bg:addTo(avatar_,-1)

               local avatar_bg_1 = display.newSprite()
               avatar_bg_1:setPosition(59,49)
               avatar_bg_1:addTo(avatar_,-1)
               avatar_bg_1:setTag(100)

               tb.avatar[tonumber(i)] = avatar_

            end
            for i = 1, number do
                local pos = i
                if position ~= nil then
                    pos = position[i]
                end
                local align = cc.ui.TEXT_ALIGN_CENTER
                if config.layout.name[pos].point == "left" then
                    align = cc.ui.TEXT_ALIGN_LEFT
                elseif config.layout.name[pos].point == "right" then
                    align = cc.ui.TEXT_ALIGN_RIGHT
                end
                local text=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="", align=align})
                :pos(posx+tonumber(config.layout.name[pos].posx), posy+tonumber(config.layout.name[pos].posy))
                :addTo(emptyNode)
                text:setAnchorPoint(0.5, 0.5)
                tb.name[tonumber(i)] = text

                --test by whb

                if gameid == 102 then

                    if number == 2 and pos == 1 then
                       
                        text:pos(posx+tonumber(config.layout.name[3].posx), posy+tonumber(config.layout.name[pos].posy))
                       
                    end
                end


                -- if pos==1 then
                -- text:pos(posx+tonumber(config.layout.name[pos].posx), posy+tonumber(config.layout.name[pos].posy-25))
                -- elseif pos==2 then
                -- text:pos(posx+tonumber(config.layout.name[pos].posx+25), posy+tonumber(config.layout.name[pos].posy))
                -- elseif pos==3 then
                -- text:pos(posx+tonumber(config.layout.name[pos].posx), posy+tonumber(config.layout.name[pos].posy+25))
                -- elseif pos==4 then
                -- text:pos(posx+tonumber(config.layout.name[pos].posx-25), posy+tonumber(config.layout.name[pos].posy))
                -- end
                  
                --end
            end
            for i = 1, number do
                local pos = i
                if position ~= nil then
                    pos = position[i]
                end
                local hand = display.newSprite("#"..hand_icon_pic[config.layout.hand[pos].id])
                :pos(posx+tonumber(config.layout.hand[pos].posx), posy+tonumber(config.layout.hand[pos].posy))
                -- :setScale(1/2)
                :hide()
                :addTo(emptyNode)
                tb.hand[tonumber(i)] = hand

                local text=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=16, text="已准备"})
                :pos(50,10)
                :addTo(hand)
                text:setAnchorPoint(0.5, 0.5)


                 if gameid == 102 then

                    if number == 2 and pos == 1 then
                       
                        hand:pos(posx+tonumber(config.layout.hand[3].posx), posy+tonumber(config.layout.hand[pos].posy))
                       
                    end
                end

                --test by whb

                -- if pos==1 then
                -- hand:pos(posx+tonumber(config.layout.hand[pos].posx), posy+tonumber(config.layout.hand[pos].posy-25))
                -- elseif pos==2 then
                -- hand:pos(posx+tonumber(config.layout.hand[pos].posx+25), posy+tonumber(config.layout.hand[pos].posy))
                -- elseif pos==3 then
                -- hand:pos(posx+tonumber(config.layout.hand[pos].posx), posy+tonumber(config.layout.hand[pos].posy+25))
                -- elseif pos==4 then
                -- hand:pos(posx+tonumber(config.layout.hand[pos].posx-25), posy+tonumber(config.layout.hand[pos].posy))
                -- end

                --end
            end
            sprintTable[index] = tb
            cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=20, text=string.format("%d", index), align=cc.ui.TEXT_ALIGN_CENTER})
            :pos(posx+tonumber(config.layout.width/2), posy-8)
            :addTo(emptyNode)
            :setAnchorPoint(0.5, 0.5)

            if gameid == 102 or gameid == 101 or gameid == 106 or gameid == 108 or gameid == 107 or gameid == 103 or gameid == 104 or gameid == 109 or gameid == 111 or gameid == 116 then
                 local bgSprite = display.newSprite("Image/Common/Table/Cell_BG.png")
                :pos(posx+tonumber(config.layout.table.posx), posy+tonumber(config.layout.table.posy))
                :addTo(emptyNode)


--modify by whb 161026
                --print("RoomScene:temp:" .. temp)
                local lie
                lie = index%3;
                if lie == 0 then
                lie = 3;
                end
                --print("RoomScene:lie:" .. lie)
                local textGold
                if config.goldseq ~= nil then
                 textGold = config.goldseq[lie]
                else
                 textGold = config.gold
                end

                if textGold == 5000 then
                   textGold = "五千"
                elseif textGold == 10000 then
                   textGold = "一万"
                elseif textGold == 50000 then
                   textGold = "五万"
                elseif textGold == 100000 then
                   textGold = "十万"
                elseif textGold == 1000000 then
                   textGold = "一百万"
                elseif textGold == 10000000 then
                   textGold = "一千万"
                end

--modify end
               
                local cell=cc.ui.UILabel.new({color=cc.c3b(255,255,255), size=20, text=textGold .. "起", align=align})
                :pos(posx+tonumber(config.layout.table.posx), posy+tonumber(config.layout.table.posy))
                :addTo(emptyNode)
                cell:setAnchorPoint(0.5, 0.5)

                 -- if gameid == 101 then
                 -- bgSprite:pos(posx+tonumber(config.layout.table.posx), posy+tonumber(config.layout.table.posy)+12)
                 -- cell:pos(posx+tonumber(config.layout.table.posx), posy+tonumber(config.layout.table.posy)+12)
                 -- end

            end
        end

        cc.ui.UIScrollView.new({viewRect = cc.rect(0,0,display.width,display.height-81)})
        :addScrollNode(emptyNode)
        :setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
        :addTo(self.scene)
        -- :setBounceable(false)
        :resetPosition()
    end
end

function RoomScene:selectSeat(table, seat)
    local session = msgMgr:get_room_session()
    print("select table:" .. table .. " seat:" .. seat .. " session:" .. session)
    if session > 0 then
        local state = msgMgr:get_table_state(table) or 0
        if bit.band(state, TABLE_STATE.LOCK) ~= 0 then 
            RequireTablePasswordLayer.new(function(pwd)
                message.sendMessage("game.SitdownReq", {
                    session = session, 
                    table = table, 
                    seat = seat, 
                    sitpwd = pwd,
                    -- rule = userdata.Room.tableRule, -- unnecessary
                })
            end):addTo(self.scene)
        else
            message.sendMessage("game.SitdownReq", {
                session = session, 
                table = table, 
                seat = seat, 
                -- sitpwd = sitpwd, -- unnecessary
                rule = userdata.Room.tableRule,
            })
        end
    end
end

function RoomScene:LeaveRoom()
    local session = msgMgr:get_room_session()
    message.sendMessage("game.LeaveRoomReq", {session=session})
    --为防止重复点击Home按钮，每次点击按钮后一秒钟之内无法再次点击
    self.scene.home:setButtonEnabled(false)
    scheduler.performWithDelayGlobal(function ()
        if self.scene then
            self.scene.home:setButtonEnabled(true)
        end
    end, 2.0)
    app:enterScene("LobbyScene", nil, "fade", 0.5)
end

function RoomScene:ctor(gameid, roomid)
    print("RoomScene:ctor gameid:" .. gameid .. " roomid:" .. roomid)

    self.gameid = gameid
    self.roomid = roomid

	local scene
    if gameid == 105 then
        scene = cc.uiloader:load("Scene/BRNNRoomScene.json"):addTo(self)
    else
        scene = cc.uiloader:load("Scene/RoomScene.json"):addTo(self)
    end
    self.scene = scene

    local quickStart = cc.uiloader:seekNodeByName(scene, "Start")
    if gameid == 105 then 

        quickStart:onButtonClicked(function()
            print("click quick start.")
            self:selectSeat(0, 0)
        end)

    else

        quickStart:hide()
        quickStart:setLocalZOrder(10)
        if quickStart then
            local btn_qiick = cc.ui.UIPushButton.new({ normal = "Image/TableList/btn_quick_start.png", pressed = "Image/TableList/btn_quick_start.png" })
            :onButtonClicked(function()
               self:selectSeat(0, 0)
            end)
            :setPosition(display.width - 57,260)
            self.scene:addChild(btn_qiick, 100)
            -- quickStart:onButtonClicked(function()
            --     print("click quick start.")
                
            -- end)
            --add ani
            quickStart:schedule(function()
                local target = display.newSprite("Image/TableList/btn_quick_start.png")
                target:setPosition(btn_qiick:getPositionX(),btn_qiick:getPositionY())
                target:addTo(btn_qiick:getParent())
        
                local scaleTo = cc.ScaleTo:create(1.0,1.5)
                local fadeTo = cc.FadeTo:create(1.0,0)
                local spawn = cc.Spawn:create(scaleTo,fadeTo)
                local rs = cc.RemoveSelf:create()
                local seq = cc.Sequence:create(spawn,rs)
        
                target:runAction(seq)
            end,5)
        end

    end
   

    local home = cc.uiloader:seekNodeByName(scene, "Home")
    if home then
        self.scene.home = home
        home:onButtonClicked(function()
            self:LeaveRoom()
        end)
    end

    local title = cc.uiloader:seekNodeByName(scene, "Title");
    if title then
        self.scene.title = title
    end

    local rule = nil
    local game_scene_name = nil
    if gameid ~= nil and roomid ~= nil then
    	local config = require("app.config.RoomConfig")
        assert(config, "config is nil")
       -- print("config:test----------")
       -- dump(config)

		for i = 1, #config do
			if config[i].gameid == gameid then

                 print("game_scene_name111------")
                for j = 1, #config[i].room do
                    if config[i].room[j].roomid == roomid then

                        print("game_scene_name222------")
                        game_scene_name = config[i].scene
                        msgMgr:setGameName(config[i].scene)
                        title:setString(config[i].name .. " -- " .. config[i].room[j].name)
                        self:init_room_info(config[i].room[j], gameid)
                        break
                    end
                end

                if config[i].rule then
                    rule = config[i].rule[device.platform]
                end
                break
            end
		end
	end

    local ruleBtn = cc.uiloader:seekNodeByName(scene, "OpenRule")
    if rule and ruleBtn then
        ruleBtn:onButtonClicked(function ()
            local ruleLayer = cc.uiloader:load("Layer/PopBoxLayer.json"):addTo(self)

            -- cc.uiloader:seekNodeByNameFast(ruleLayer, "Title")
            --     :setString(app.lang.rule)

            local title_sprite = cc.uiloader:seekNodeByNameFast(ruleLayer, "Image_Title")
            local s = display.newSprite("Image/TableList/rule_title.png")
            local frame = s:getSpriteFrame()
            title_sprite:setSpriteFrame(frame)

            cc.uiloader:seekNodeByNameFast(ruleLayer, "Close")
                :onButtonClicked(function ()
                    sound_common.cancel()
                    ruleLayer:removeFromParent()
                end)

            local content = cc.uiloader:seekNodeByNameFast(ruleLayer, "Content")
            local webview = ccexp.WebView:create()
            content:addChild(webview)
            webview:setVisible(true)
            webview:setScalesPageToFit(true)
            webview:setContentSize(cc.size(content:getContentSize().width,content:getContentSize().height - 10)) -- 一定要设置大小才能显示
            webview:reload()
            webview:setAnchorPoint(cc.p(0, 0))
            webview:setPosition(0, -10)

            local node = cc.uiloader:seekNodeByNameFast(ruleLayer, "Node")
            node:setScale(0)
            transition.scaleTo(node, {
                scale = 1, 
                time = app.constant.lobby_popbox_trasition_time,
                onComplete = function ()
                    scheduler.performWithDelayGlobal(function ()
                        if device.platform == "android" then
                            local basePath = "assets"
                            --local basePath2 = "/data/data/"
                            local filePath = cc.FileUtils:getInstance():fullPathForFilename(rule)
                            print("filePath:" .. tostring(filePath))
                            local resultPath = rule
                            if string.sub(filePath,1,string.len(basePath)) ~= basePath then
                                resultPath = "file://" .. filePath
                                --print("resultPath:" .. tostring(resultPath))
                            end
                            print("resultPath22:" .. tostring(resultPath))
                            webview:loadFile(resultPath)
                        else
                            webview:loadFile(rule)
                        end
                    end, 0.1) 
                end
            })
        end)
    end

    local settingsBtn = cc.uiloader:seekNodeByName(scene, "Settings")
    if settingsBtn then
        settingsBtn:onButtonClicked(function ()
            local settingsLayer = cc.uiloader:load("Layer/Game/SettingsLayer.json"):addTo(self)
            local node = cc.uiloader:seekNodeByNameFast(settingsLayer, "Node")
            node:setScale(0)
            transition.scaleTo(node, {
                scale = 1, 
                time = app.constant.lobby_popbox_trasition_time,
            })

            -- cc.uiloader:seekNodeByNameFast(settingsLayer, "Title"):setString(app.lang.room_setting)
            local title_sprite = cc.uiloader:seekNodeByNameFast(settingsLayer, "Image_Title")
            local s = display.newSprite("Image/TableList/setting_title.png")
            local frame = s:getSpriteFrame()
            title_sprite:setSpriteFrame(frame)

            cc.uiloader:seekNodeByNameFast(settingsLayer, "Close"):onButtonClicked(function() 
                settingsLayer:removeFromParent() 
                sound_common.cancel()
            end)
            cc.uiloader:seekNodeByNameFast(settingsLayer, "Cancel"):onButtonClicked(function() 
                settingsLayer:removeFromParent() 
                sound_common.cancel()
            end)

            local curTableRule = userdata.Room.tableRule
            local winOption = cc.uiloader:seekNodeByNameFast(settingsLayer, "CheckBox_Win")
            local winInput = cc.uiloader:seekNodeByNameFast(settingsLayer, "Win_Input")
            assert(winOption)
            assert(winInput)
            if curTableRule.minwinrate then
                winOption:setButtonSelected(true)
                winInput:setString(tostring(curTableRule.minwinrate))
            end

            local escapeOption = cc.uiloader:seekNodeByNameFast(settingsLayer, "CheckBox_Escape")
            local escapeInput = cc.uiloader:seekNodeByNameFast(settingsLayer, "Escape_Input")
            assert(escapeOption)
            assert(escapeInput)
            if curTableRule.maxfleerate then
                escapeOption:setButtonSelected(true)
                escapeInput:setString(tostring(curTableRule.maxfleerate))
            end

            local scoreOption = cc.uiloader:seekNodeByNameFast(settingsLayer, "CheckBox_Score")
            local lowScoreInput = cc.uiloader:seekNodeByNameFast(settingsLayer, "LowScore_Input")
            local highScoreInput = cc.uiloader:seekNodeByNameFast(settingsLayer, "HightScore_Input")
            assert(scoreOption)
            assert(lowScoreInput)
            assert(highScoreInput)
            if curTableRule.minscore and curTableRule.maxscore then
                scoreOption:setButtonSelected(true)
                lowScoreInput:setString(tostring(curTableRule.minscore))
                highScoreInput:setString(tostring(curTableRule.maxscore))
            end

            local blackListOption = cc.uiloader:seekNodeByNameFast(settingsLayer, "CheckBox_BlackList")
            assert(blackListOption)
            if curTableRule.noblackman then
                blackListOption:setButtonSelected(true)
            end

            local ipOption = cc.uiloader:seekNodeByNameFast(settingsLayer, "CheckBox_IP")
            assert(ipOption)
            if curTableRule.nosameip then
                ipOption:setButtonSelected(true)
            end

            local pwdOption = cc.uiloader:seekNodeByNameFast(settingsLayer, "CheckBox_Pwd")
            local pwdInput = cc.uiloader:seekNodeByNameFast(settingsLayer, "Pwd_Input")
            assert(pwdOption)
            assert(pwdInput)
            if curTableRule.pwd then 
                pwdOption:setButtonSelected(true)
                pwdInput:setString(tostring(curTableRule.pwd))
            end

            cc.uiloader:seekNodeByNameFast(settingsLayer, "Confirm"):onButtonClicked(function ()
                sound_common.confirm()
                local tableRule = {}
                if winOption:isButtonSelected() then
                    tableRule.minwinrate = tonumber(winInput:getString()) or nil
                end
                if escapeOption:isButtonSelected() then
                    tableRule.maxfleerate = tonumber(escapeInput:getString()) or nil
                end
                if scoreOption:isButtonSelected() then
                    local low = tonumber(lowScoreInput:getString())
                    local hig = tonumber(highScoreInput:getString())
                    if low and hig then
                        tableRule.minscore = low
                        tableRule.maxscore = hig
                    end
                end
                if blackListOption:isButtonSelected() then
                    tableRule.noblackman = true
                end
                if ipOption:isButtonSelected() then
                    tableRule.nosameip = true
                end
                if pwdOption:isButtonSelected() then
                    tableRule.pwd = pwdInput:getString()
                end
                dump(tableRule)
                userdata.Room.tableRule = tableRule
                settingsLayer:removeFromParent()
            end)
        end)
    end

    assert(game_scene_name, "game scene is nil")
    local game_scene = require("app.scenes."..game_scene_name)
    if game_scene.preload then
        game_scene.preload()
    else
        print(game_scene_name.." have no preload() func.")
    end

    
end

function RoomScene:playerSeat(table, seat, player)
    print("RoomScene:playerSeat")
    -- modify by whb 1229
        if table == 0 then

            return

        end
    -- end 
    --print("table:" .. table)
    local sprints = sprintTable[table].seat
    local avatars = sprintTable[table].avatar
    local seatCnt = 0
    if sprints ~= nil then
        seatCnt = #sprints
        sprint = sprints[seat]
        avatar = avatars[seat]
        if sprint ~= nil then
            if player == nil then
                sprint:setScale(1)
                if seats_table ~= nil then
                    local pos = (table - 1) % (#seats_table) + 1

                   -- print("playerSeat:pos111:" .. pos .. ":" .. seat)
                    sprint:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(seat_icon_pic[seats_table[pos][seat]]))
                    sprint:show()
                    avatar:hide()
                  -- print("playerSeat000-------")
                   util.setImageNodeHide(avatar:getParent(), (table-1)*4+seat)

                    --modify by whb 161026
                    if self.gameid == 102 then

                        if seatCnt == 2 and seat == 1 then

                            sprint:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(seat_icon_pic[seats_table[pos][2]]))
                            if sprint:isFlippedY() == false then
                                sprint:flipY(true)
                            end
                        end
                    end
                   --modify end
                else
                    sprint:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(seat_icon_pic[seat]))
                    sprint:show()
                    avatar:hide()
                  -- print("playerSeat1111-------")
                    util.setImageNodeHide(avatar:getParent(), (table-1)*4+seat)
                end
            else
                if player.sex == 0 then
                    player.sex = 1
                end
                --modify by whb 161031
               -- local image = AvatarConfig:getAvatar(player.sex, player.gold, player.viptype)
               local viptype = 0
                if player.viptype ~= nil then
                    viptype = player.viptype
                end
                local image = AvatarConfig:getAvatar(player.sex, player.gold, viptype)
                --modify end
                --print(image)
                local texture = cc.Director:getInstance():getTextureCache():addImage(image)
                local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, image)

                -- local rect = cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh())
                -- local frame = cc.SpriteFrame:create(image, rect)

                if avatar ~= nil and image ~= nil then
                     avatar:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(image))
                     avatar:setScale(0.409)
                    -- avatar:setSpriteFrame(frame)
                end


                --avatar:show()
                -- local image2 = AvatarConfig:getAvatarBG(player.sex, player.gold, viptype,0)
                -- local texture = cc.Director:getInstance():getTextureCache():addImage(image2)
                -- local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
                -- cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, image2)

                local a_bg = avatar:getChildByTag(100)
                a_bg:hide()
                --a_bg:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(image2))

                sprint:hide()
                avatar:show()

                 --微信头像设置
                local img_userinfobg = avatar:getParent()
                print("RoomScene:playerSeat-imageid:",player.imageid)
                 --设置微信头像
                util.setHeadImage(img_userinfobg, player.imageid, avatar, image, (table-1)*4+seat,1000)
            

            end
        end
    end

    sprints = sprintTable[table].name
    if sprints ~= nil then
        sprint = sprints[seat]
        if sprint ~= nil then
            if player == nil then
                sprint:setString("")
            else
                sprint:setString(util.checkNickName(player.name))

--modify by whb 161031

    if player.viptype~=nil and player.viptype > 0 then
       sprint:setColor(cc.c3b(255, 0, 0))
    end
--modify end
            end
        end
    end
end

function RoomScene:SeatReady(table, seat, isReady)
    --dump(sprintTable)
    print("table:" .. tostring(table))
    print("sprintTable:" .. tostring(#sprintTable))
    if table == 0 then

        return

    end
    
    local sprints = sprintTable[table].hand
    if sprints ~= nil then
        sprint = sprints[seat]
        if sprint ~= nil then
            if isReady then
                sprint:show()
            else
                sprint:hide()
            end
        end
    end
end

function RoomScene:lockState(table, state)
    local sprint = sprintTable[table].lock
    if  sprint ~= nil then
        if state then
            sprint:show()
        else
            sprint:hide()
        end
    end
end

function RoomScene:tableState(table, state)
    local sprint = sprintTable[table].table
    if sprint ~= nil then
        state = state or TABLE_STATE.WAIT
        if bit.band(state, TABLE_STATE.GAME) ~= 0 then
            sprint:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(table_busy_pic))
        else
            sprint:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(table_idle_pic))
        end
        self:lockState(table, bit.band(state, TABLE_STATE.LOCK) ~= 0)
    end
end

function RoomScene:onEnter()


end

function RoomScene:RequestFromWChat()

    --print("Room_RequestFromWChat:test",self.info)

    local gameid, roomid, uid, session, tableid, seatid, password

    if device.platform == "android" then
        param = json.decode(self.info)
        xmlPath = param.path
       
    else
        param = self.info
    end

    --dump(self.info)

        gameid = param.gameid
        roomid = param.roomid
        uid = param.uid
        session = param.session
        tableid = param.tableid
        seatid = param.seatid
        password = param.password
       -- print("Room_RequestFromWChat:",param.gameid)

   
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

             --scheduler.unscheduleGlobal(self.RoomRequest)
            -- self.RoomRequest = nil

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

function RoomScene:onEnterTransitionFinish()
    print("onEnterTransitionFinish...")
    self.finished = true
    msgMgr:setRoomScene(self)

    -- if app.constant.show_leaveTip ~= nil and  app.constant.show_leaveTip then

    --     print("11111111111111")

    --     ErrorLayer.new(app.lang.leaveRoom_error, nil, 1.5, errorLayerCallBack, 1):addTo(self)
    --     app.constant.show_leaveTip = false

    -- end

    util.RunHorn(nil,self,self.scene)

    local tableinfo = msgMgr:get_table_info()
    local tablestate = msgMgr:get_table_state()
    for i = 1, table_cnt do
        local players = tableinfo[i]
        local cnt = seat_cnt
        if seats_table ~= nil then
            local pos = (i-1) % (#seats_table) + 1
            cnt = #seats_table[pos]
        end
        if players ~= nil then
            for j = 1, cnt do
                local p = players[j]
                if p ~= nil then
                    self:playerSeat(i, j, p)
                    self:SeatReady(i, j, p.ready>0)
                else
                    self:playerSeat(i, j, nil)
                    self:SeatReady(i, j, false)
                end
            end
        else
            for j = 1, cnt do
                self:playerSeat(i, j, nil)
                self:SeatReady(i, j, false)
            end
        end
        self:tableState(i, tablestate[i])
    end

    self.RoomRequest = scheduler.scheduleGlobal(function()

   if app.constant.isReuqestWchat ~= 2 then

            function callback(param)

          --  print("roomScene-shareWeixin:gameid--")

            self.info = param

            self:RequestFromWChat()

           end

            if device.platform == "ios" then

                 luaoc.callStaticMethod("WeixinSDK", "loginReady", { callback = callback})

            -- elseif device.platform == "android" then

            --     luaj.callStaticMethod("app/WeixinSDK", "loginReady", { callback })

            end

   end

   end, 0.5)

   if app.constant.isReuqestWchat == 1 then

        scheduler.performWithDelayGlobal(function ()

         self:LeaveRoom()

         app.constant.isReuqestWchat = 2
                    
        end, 0.5)

    elseif app.constant.isReuqestWchat == 3  then

       scheduler.performWithDelayGlobal(function ()

         selectEnterGameScene()
                    
        end, 0.5)

   elseif app.constant.isRequesting == 1 then

        scheduler.performWithDelayGlobal(function ()

         self:LeaveRoom()

         app.constant.isRequesting = 2
                    
        end, 0.5)

    elseif app.constant.isRequesting == 3  then

       scheduler.performWithDelayGlobal(function ()

         inGameEnterGameScene()
                    
        end, 0.5)

   end

end

function RoomScene:onExit()

     if self.RoomRequest then

        scheduler.unscheduleGlobal(self.RoomRequest)
        self.RoomRequest = nil

    end
    msgMgr:setRoomScene(nil)
    if self.quickstartHandler then
        scheduler.unscheduleGlobal(self.quickstartHandler)
        self.quickstartHandler = nil
    end
end

function RoomScene:onCleanup()
end

function RoomScene:RunHorn(content)
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
        color = display.COLOR_WHITE, 
        size = 25, 
        text = content,
    }):addTo(self.scene):setAnchorPoint(cc.p(0, 0)):setLocalZOrder(2)

    local lb_width = hornMsgLabel:getCascadeBoundingBox().size.width
    local lb_height = hornMsgLabel:getCascadeBoundingBox().size.height
    hornMsgLabel:setPosition(display.width, self.scene.horn:getPositionY() + 7)

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

-- UserMessage
function RoomScene:NoticeInfo(msg)
    -- dump(msg)
    -- if msg and (msg.gameid == 0 or msg.gameid == self.gameid) then
    --     self:RunHorn(msg.content)
    -- end
end

function RoomScene:Invitation(msg)

    print("RoomScene.Invitation")
    --dump(msg)

    local scene = display.getRunningScene()

     if scene.name ~= "RoomScene" then 

        return

     end

    --dump(msg)

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

       print("r-sure click-------")

       local scene = display.getRunningScene()

       print("r-scene.name", scene.name)

         local curGameID =  app.constant.cur_GameID
         local cur_RoomID = app.constant.cur_RoomID

         if curGameID == msg.gameid and cur_RoomID == msg.roomid then

                 app.constant.isRequesting = 3
                 inGameEnterGameScene()

         else

             local session = msgMgr:get_room_session()
             message.sendMessage("game.LeaveRoomReq", {session=session})
             app:enterScene("LobbyScene", nil, "fade", 0.5)

             app.constant.isRequesting = 2

         end

    end

    app.constant.isRequesting = 1
    util.setRequestLayer(self, sure)
    
end

return RoomScene