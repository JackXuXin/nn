local MJPRoom = class("MJPRoom",function()
    return display.newNode()
end)

local util = require("app.Common.util")
local message = require("app.net.Message")
local AvatarConfig = require("app.config.AvatarConfig")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local sound_common = require("app.Common.sound_common")
local Share = require("app.User.Share")

local table_session
local seat_cnt
local players = {}
local ui_buttons = {}
local seatIndex = 0

local clears = {}

local function getSeatPosition(seat)
    local pos_base_x = display.cx + (seat - 1 - (seat_cnt - 1) / 2) * 220
    local pos_base_y = 230
    return pos_base_x,pos_base_y
end

function MJPRoom:ctor()

end

function MJPRoom:showSeat(params)
    print("MJPRoom:showSeat")
    dump(params)
    if params.seat_cnt then
        seat_cnt = params.seat_cnt
        for i = 1,seat_cnt do
            local pos_base_x,pos_base_y = getSeatPosition(i)
            local seatBtn = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/img_head_bg.png", pressed = "ShYMJ/PrivateRoom/img_head_bg.png" })
            :pos(pos_base_x,pos_base_y)
            :addTo(self)
            table.insert(clears,seatBtn)
            -- local sp = display.newSprite(string.format("ShYMJ/PrivateRoom/text_%d.png",i))
            -- :pos(pos_base_x,pos_base_y)
            -- :addTo(self)
            -- table.insert(clears,sp)

            --房主
            -- if params.creator then
            --      --坐下站起 按钮
            --     local sitdownSitup = cc.ui.UIPushButton.new({ normal = "res/ShYMJ/PrivateRoom/btn_sitdown_01.png", pressed = "res/ShYMJ/PrivateRoom/btn_sitdown_02.png" })
            --     :onButtonClicked(function(event)

            --         if not players[i] then
            --             message.sendMessage("PrivateRoom.PrivateRoomSitdownReq", {
            --                 session = table_session, 
            --                 tableid = params.tableid,
            --                 seat = i,
            --             })
            --         else
            --             message.sendMessage("PrivateRoom.PrivateRoomSitupReq", {
            --                 session = table_session, 
            --                 tableid = params.tableid,
            --                 seat = i,
            --             })
            --         end
            --     end)
            --     :pos(pos_base_x,pos_base_y-150)
            --     :setScale(0.9)
            --     :addTo(self)
            --     :hide()
            --     ui_buttons[i] = sitdownSitup
            --     table.insert(clears,sitdownSitup)
            -- end
        end
    end

    --房主
    -- if params.creator then
    --      --解散按钮
    --      local roomEnd = cc.ui.UIPushButton.new({ normal = "res/ShYMJ/PrivateRoom/btn_dissolution_01.png", pressed = "res/ShYMJ/PrivateRoom/btn_dissolution_02.png" })
    --         :onButtonClicked(function()
    --             local layer
    --             layer = MiddlePopBoxLayer.new(app.lang.system, app.lang.room_dissolution, 
    --                 MiddlePopBoxLayer.ConfirmDefault, true, nil, function ()
    --                     layer:removeFromParent()
    --                     message.sendMessage("PrivateRoom.PrivateRoomManualEndReq", {
    --                        session = table_session
    --                     })
    --                     sound_common.confirm()
    --                 end)
    --             :addTo(self)
    --         end)
    --         :pos(1120,665)
    --         :addTo(self)
    --         table.insert(clears,roomEnd)
    -- end

    --基本信息
    local info = display.newSprite("ShYMJ/PrivateRoom/img_info.png")
        :pos(120,display.height - 80)
        :addTo(self)

    --分数
    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 20, 
        text = "分数:" .. tostring(params.pian_cnt), 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(68,80)

    --房间号
    cc.ui.UILabel.new({
        color = cc.c3b(233,167,132), 
        size = 20, 
        text = "房间号："
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(68,52)

    --房间号密码
    cc.ui.UILabel.new({
        color = cc.c3b(255,0,0), 
        size = 23, 
        text = tostring(params.table_code), 
    })
    :addTo(info)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(68,23)

    --邀请
    -- local gameInvite = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/game_friend_0.png", pressed = "ShYMJ/PrivateRoom/game_friend_1.png" })
    -- :onButtonClicked(function()
    --     util:ShowRequestLayer(self)
    -- end)
    -- :pos(display.cx,600)
    -- :addTo(self)
    -- table.insert(clears,gameInvite)

    local weixinInvite = cc.ui.UIPushButton.new({ normal = "ShYMJ/PrivateRoom/btn_weixin_friend.png", pressed = "ShYMJ/PrivateRoom/btn_weixin_friend.png" })
    :onButtonClicked(function()

        Share.requestWChatFriend(params.table_code, params.seat_cnt, params.gameround)

    end)
    :pos(display.cx,520)
    :addTo(self)
    table.insert(clears,gameInvite)
end

function MJPRoom:tableSession( tableSession )
   table_session = tableSession 
end

function MJPRoom:setPlayer(seat, name, score, sex, viptype, creator, imageid)
    print("setPlayer:" .. tostring(seat))
    if players[seat] then return end

    name = util.checkNickName(name)
    local str = string.format("%s", util.num2str_text(score))
    --set head
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    local rect = cc.rect(0, 0, 178, 176)
    local frame_head = cc.SpriteFrame:create(image, rect)

    --头像
    local head = display.newSprite(frame_head)
        :pos(0,0)
        :addTo(self)
    table.insert(clears,head)

    --昵称
    local name_label = cc.ui.UILabel.new({
        color = cc.c3b(255,255,255), 
        size = 18, 
        text = name, 
    })
    :addTo(self)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(0,0)
    table.insert(clears,name_label)

    local x,y = getSeatPosition(seat)
    head:setPosition(cc.p(x,y))
    name_label:setPosition(cc.p(x,y - 100))
    if viptype > 0 then
       name_label:setColor(cc.c3b(255, 0, 0))
    end

    players[seat] = {head = head,name_label = name_label}
    
    --设置微信头像
    util.setHeadImage(self, imageid, head, image, seat)

    -- if creator then
    --     for seatid,ui_button in pairs(ui_buttons) do
    --         if seatid ~= seat then
    --             ui_button:hide()
    --         end
    --     end
    --     if ui_buttons[seat] then
    --         ui_buttons[seat]:setButtonImage("normal", "res/ShYMJ/PrivateRoom/btn_situp_01.png", true)
    --         ui_buttons[seat]:setButtonImage("pressed", "res/ShYMJ/PrivateRoom/btn_situp_02.png", true)
    --     end
    -- else
    --     if ui_buttons[seat] then
    --         ui_buttons[seat]:hide()
    --     end
    -- end
end

function MJPRoom:clearPlayer(seat,creator)
    print("clearPlayer:" .. tostring(seat))
    dump(players)
    local player = players[seat]
    if player then
        dump(player)
        player.head:removeFromParent()
        player.name_label:removeFromParent()
        if players[seat].ready then
            players[seat].ready:removeFromParent()
        end
    end
    if seat == seatIndex and players.btnReady then
        players.btnReady:hide()
    end

    -- if creator then
    --     for seatid,ui_button in pairs(ui_buttons) do
    --         if seatid ~= seat and not players[seatid] then
    --             ui_button:show()
    --         end
    --     end
    --     if ui_buttons[seat] then
    --         ui_buttons[seat]:setButtonImage("normal", "res/ShYMJ/PrivateRoom/btn_sitdown_01.png", true)
    --         ui_buttons[seat]:setButtonImage("pressed", "res/ShYMJ/PrivateRoom/btn_sitdown_02.png", true)
    --     end
    -- else
    --     if ui_buttons[seat] and players[seatid] then
    --         ui_buttons[seat]:show()
    --     end
    -- end
    util.setImageNodeHide(self, seat)
    players[seat] = nil
end

function MJPRoom:allowReady(seat)
    print("allowReady:" .. seat)
    if not players.btnReady then
        local btn = cc.ui.UIPushButton.new({ normal = "ShYMJ/button_kaishi_normal.png", pressed = "ShYMJ/button_kaishi_selected.png" })
        :onButtonClicked(function()
            message.sendMessage("PrivateRoom.PrivateRoomReadyReq", {
                session = table_session
                })
        end)
        :pos(display.cx,60)
        :addTo(self)

        players.btnReady = btn
    else
        players.btnReady:show()
    end
    seatIndex = seat
end

function MJPRoom:ready(seat)
    if not players[seat].ready then
        local x,y = getSeatPosition(seat)
        local ready = display.newSprite("ShYMJ/PrivateRoom/text_ready.png")
          --  :pos(x,y - 130)
            :pos(x,y - 65)
            :addTo(self)
        players[seat].ready = ready
        table.insert(clears,ready)
    end
    if seatIndex == seat and players.btnReady then
        players.btnReady:hide()
    end
end

function MJPRoom:init(callback)
    self.callback = callback
    return self
end

function MJPRoom:clear()
    -- for i = 1,#clears do
    --     clears[i]:removeFromParent()
    -- end

    seat_cnt = nil
    room_session = nil
    players = {}
    ui_buttons = {}
end

return MJPRoom