local DDZ_MJPRoom = class("DDZ_MJPRoom",function()
    return display.newNode()
end)

local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local Share = require("app.User.Share")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local message = require("app.net.Message")
local sound_common = require("app.Common.sound_common")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local PlatConfig = require("app.config.PlatformConfig")
local DDZ_Audio = require("app.Games.DDZ.DDZ_Audio")

local room_session
local table_session
local players = {}
--local roomEnd = nil

function DDZ_MJPRoom:ctor()

end

function DDZ_MJPRoom:hideButton()
    print("DDZ_MJPRoom:hideButton---")
    
    if self:getChildByName("startGame") then
        self:getChildByName("startGame"):hide()
    end

    if self:getChildByName("weixinInvite") then
        self:getChildByName("weixinInvite"):hide()
    end
    
end

function DDZ_MJPRoom:showSeat(params)
    print("DDZ_MJPRoom:showSeat")
    -- dump(params)
    -- if params.seat_cnt then
    --     seat_cnt = params.seat_cnt
    -- end

    --基本信息
    local info = display.newSprite("ShYMJ/PrivateRoom/img_info.png")
        :pos(2,display.height)
        :addTo(self)
        :setAnchorPoint(0,1)

    --房间号文字
    cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 20, 
        text = "房号："
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(3,77)

    --房间号密码
    cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 22, 
        text = tostring(params.table_code), 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(54,77)

     --分数文字
    cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 20, 
        text = "局数：", 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(3,46)

    --分数
    cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 22, 
        text = tostring(params.gameround) .. "局", 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(54,46)

    local netBg = display.newSprite("Image/PrivateRoom/img_NetBg.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(info)
        :setPosition(74,15.5)

    local netG = display.newSprite("Image/PrivateRoom/img_NetG.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(info)
        :setPosition(74,15.5)
        :hide()

    local netY = display.newSprite("Image/PrivateRoom/img_NetY.png")
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(info)
        :setPosition(74,15.5)
        :hide()

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
    :setPosition(68,10)

    local setDelayTime = function()

            delayTime = app.constant.delayTime
           -- print("delayHandler--- = ",delayTime)
           if delayTime == nil then
              delayTime = 50
           end
            local strTime = tostring(delayTime) .. "ms"
            netTime:setString(strTime)

            if delayTime<100 then
                netG:show()
                netY:hide()
                netTime:setTextColor(cc.c3b(125,220,51))
                netG:setTextureRect(cc.rect(0,0,37,26))
            elseif delayTime<200 then
                netG:show()
                netY:hide()
                netTime:setTextColor(cc.c3b(125,220,51))
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
        self.delayHandler = scheduler.scheduleGlobal(
        function()
            setDelayTime()
        end, 1)
    end

    --解散按钮
    local callback = self.callback


    print("paytypesy = ",params.pay_type)

    if self:getChildByName("weixinInvite")==nil  then
         --微信邀请好友
        local weixinInvite = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/btn_weixin_friend.png", pressed = "ShYMJ/PrivateRoom/btn_weixin_friend.png" })
        :onButtonClicked(function()
            DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
            Share.requestWChatFriend(params.table_code, params.seat_cnt, params.gameround, params.gameid, params.pay_type, params.customization)

        end)
        :pos(display.cx-188,270)
        :addTo(self)
        :setName("weixinInvite")
        util.BtnScaleFun(weixinInvite)
    end
   

    --开始游戏
    if self:getChildByName("startGame")==nil then
        local startGame = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/btn_start_game.png", pressed = "ShYMJ/PrivateRoom/btn_start_game.png" })
        :onButtonClicked(function()
            print("发送准备请求")
            DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_BEHAVIOR)
            self.callback:setisReady(true)
            message.sendMessage("game.ReadyReq", {
                session = room_session
            })

        end)
        :pos(display.cx+188,270)
        :addTo(self)
        :setName("startGame")
        util.BtnScaleFun(startGame)
    end

     --审核专用
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    if platConfig ~= nil and platConfig.isAppStore ~= nil then
        if platConfig.isAppStore == true then
            weixinInvite:hide()
            startGame:setPosition(display.cx,270)
        end
    end
end

function DDZ_MJPRoom:tableSession( tableSession )
   table_session = tableSession 
end

function DDZ_MJPRoom:getSession()
   return table_session
end
function DDZ_MJPRoom:roomSession( roomSession )
   room_session = roomSession 
end

function DDZ_MJPRoom:setPlayer(seat, name, score, sex, viptype,creator, imageid)
    if players[seat] then return end

    name = util.checkNickName(name)
    local score_str = tostring(score)
    --set head
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    local rect = cc.rect(0, 0, 178, 176)
    local frame_head = cc.SpriteFrame:create(image, rect)

    -- local image_framebg = AvatarConfig:getAvatarBG(sex, score, viptype,1)
    -- local rectbg = cc.rect(0, 0, 105, 105)
    -- local frame_headbg = cc.SpriteFrame:create(image_framebg, rectbg)

    local player_bg = nil
    local head_bg = nil
    local head = nil
    local name_label = nil
    local score_label = nil
    local ready = nil

     --背景
    player_bg = display.newSprite("Image/PrivateRoom/img_height_touxiangBG.png")
        :addTo(self)

    --头像背景
    -- head_bg = display.newSprite(frame_headbg)
    --     :addTo(self)

    -- --头像
    head = display.newSprite(frame_head)
        :scale(0.6)
        :addTo(self)

    --  --昵称
    name_label = cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 18, 
        text = name, 
    })
    :setAnchorPoint(cc.p(0.5,0.5))
    :addTo(self)

    if viptype > 0 then
       name_label:setColor(cc.c3b(255, 0, 0))
    end

    --分数
    score_label = cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 18, 
        text = score_str,
    })
    :setAnchorPoint(cc.p(0.5,0.5))
    :addTo(self)


   
    local basePos_x
    local basePos_y
    local pos_head_y_offset = 30
    local pos_name_y_offset = -35
    local pos_score_y_offset = -63
    local pos_ready_y_offset = -8
    if seat == 4 then
        basePos_x = 80
        basePos_y = display.cy
    elseif seat == 2 then
        basePos_x = display.width - 80
        basePos_y = display.cy
    elseif seat == 3 then
        basePos_x = 280
        basePos_y = display.height - 100
    elseif seat == 1 then
        basePos_x = 80
        basePos_y = 100
    end

    player_bg:pos(basePos_x,basePos_y)
    --head_bg:pos(basePos_x,basePos_y+pos_head_y_offset)
    head:pos(basePos_x,basePos_y+pos_head_y_offset)

    --设置微信头像
    util.setHeadImage(self, imageid, head, image, seat)


    name_label:pos(basePos_x,basePos_y+pos_name_y_offset)
    score_label:pos(basePos_x,basePos_y+pos_score_y_offset)

    players[seat] = {player_bg=player_bg,head=head,name_label=name_label,score_label=score_label}


end

function DDZ_MJPRoom:clearPlayer(seat)
    local player = players[seat]
    if player then
        for _,ui_node in pairs(player) do
            ui_node:removeFromParent()
        end
    end

    util.setImageNodeHide(self, seat)
    players[seat] = nil
end

function DDZ_MJPRoom:showRoomEndState(flag)
    -- if roomEnd then
    --     roomEnd:setVisible(flag)
    -- end
end

function DDZ_MJPRoom:ready(seat)

end

function DDZ_MJPRoom:init(callback)
    self.callback = callback
    return self
end

function DDZ_MJPRoom:clear()
    room_session = nil
    players = {}
    --roomEnd = nil
    if self.delayHandler then
        scheduler.unscheduleGlobal(self.delayHandler)
        self.delayHandler = nil
    end
end

return DDZ_MJPRoom