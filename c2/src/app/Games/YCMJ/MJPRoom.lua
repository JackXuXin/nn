local MJPRoom = class("MJPRoom",function()
    return display.newNode()
end)

local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local Share = require("app.User.Share")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local message = require("app.net.Message")
local sound_common = require("app.Common.sound_common")

local table_session
local players = {}
local roomEnd = nil

function MJPRoom:ctor()

end

function MJPRoom:showSeat(params)
    print("MJPRoom:showSeat")
    dump(params)
    if params.seat_cnt then
        seat_cnt = params.seat_cnt
    end

    --基本信息
    local info = display.newSprite("ShYMJ/PrivateRoom/img_info.png")
        :pos(120,display.height - 80)
        :addTo(self)

    --分数文字
    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 20, 
        text = "分数:", 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(22,111)

    --分数
    cc.ui.UILabel.new({
        color = cc.c3b(245,245,34), 
        size = 22, 
        text = tostring(params.pian_cnt), 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(68,82)

    --房间号文字
    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 20, 
        text = "房间号："
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(22,52)

    --房间号密码
    cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 23, 
        text = tostring(params.table_code), 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(68,23)

    --解散按钮
    local callback = self.callback
    roomEnd = cc.ui.UIPushButton.new({ normal = "Image/PrivateRoom/btn_dissolution_01.png", pressed = "Image/PrivateRoom/btn_dissolution_01.png" })
       :onButtonClicked(function()
           local layer
           layer = MiddlePopBoxLayer.new(app.lang.system, app.lang.room_dissolution, 
               MiddlePopBoxLayer.ConfirmDefault, true, nil, function ()
                   layer:removeFromParent()
                   message.sendMessage("PrivateRoom.PrivateRoomManualEndAsk", {
                      session = table_session
                   })
                   sound_common.confirm()
               end)
           :addTo(callback)
       end)
       :pos(1140,665)
       :hide()
       :addTo(self.callback)

    --邀请
    -- local gameInvite = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/game_friend_0.png", pressed = "ShYMJ/PrivateRoom/game_friend_1.png" })
    -- :onButtonClicked(function()
    --     util:ShowRequestLayer(self)
    -- end)
    -- :pos(display.cx,600)
    -- :addTo(self)

    local weixinInvite = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/btn_weixin_friend.png", pressed = "ShYMJ/PrivateRoom/btn_weixin_friend.png" })
    :onButtonClicked(function()

        Share.requestWChatFriend(params.table_code, params.seat_cnt, params.gameround)

    end)
    :pos(display.cx,280)
    :addTo(self)
end

function MJPRoom:tableSession( tableSession )
   table_session = tableSession 
end

function MJPRoom:setPlayer(seat, name, score, sex, viptype,creator, imageid)
    if players[seat] then return end

    name = util.checkNickName(name)
    local score_str = tostring(score)
    --set head
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    local rect = cc.rect(0, 0, 188, 188)
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
   head_bg = display.newSprite()
      :addTo(self)
    head_bg:hide()

    -- --头像
    head = display.newSprite(frame_head)
        :scale(0.568)
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

    --准备
    local ready = display.newSprite("ShYMJ/PrivateRoom/text_ready.png")
        :addTo(self)
        :scale(0.65)


    name_label:pos(basePos_x,basePos_y+pos_name_y_offset)
    score_label:pos(basePos_x,basePos_y+pos_score_y_offset)
    ready:pos(basePos_x,basePos_y+pos_ready_y_offset)

    players[seat] = {player_bg=player_bg,head_bg=head_bg,head=head,name_label=name_label,score_label=score_label,ready=ready}


end

function MJPRoom:clearPlayer(seat)
    local player = players[seat]
    if player then
        for _,ui_node in pairs(player) do
            ui_node:removeFromParent()
        end
    end
    util.setImageNodeHide(self, seat)
    players[seat] = nil
end

function MJPRoom:showRoomEndState(flag)
    if roomEnd then
        roomEnd:setVisible(flag)
    end
end

function MJPRoom:ready(seat)
end

function MJPRoom:init(callback)
    self.callback = callback
    return self
end

function MJPRoom:clear()
    room_session = nil
    players = {}
    roomEnd = nil
end

return MJPRoom