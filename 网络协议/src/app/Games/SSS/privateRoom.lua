local SSSScene = package.loaded["app.scenes.SSSScene"] or {}

local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local Share = require("app.User.Share")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local message = require("app.net.Message")
local sound_common = require("app.Common.sound_common")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local table_session
local roomEnd = nil
local players = {}

function SSSScene:setDelayTime(rootNode)
     if self.delayHandler then
        scheduler.unscheduleGlobal(self.delayHandler)
        self.delayHandler = nil
    end
    if self.delayHandler == nil then
        --延迟时间
        local netTime = nil
        local netBg = nil
        local netG = nil
        local netY = nil
        local delayTime = app.constant.delayTime
      
       if rootNode:getChildByTag(30000) == nil then
            netTime = cc.ui.UILabel.new({
            color = cc.c3b(255,0,0), 
            size = 19, 
            text = delayTime .. "ms"
        })
        :addTo(rootNode,nil,30000)
        :setAnchorPoint(cc.p(1, 0.5))
        :setPosition(78,16)
       end

       if rootNode:getChildByTag(30001) == nil then
            netBg = display.newSprite("Image/PrivateRoom/img_NetBg.png")
            :setAnchorPoint(cc.p(0, 0.5))
            :addTo(rootNode,nil,30001)
            :setPosition(83,22)
       end

       if rootNode:getChildByTag(30002) == nil then
            netG = display.newSprite("Image/PrivateRoom/img_NetG.png")
            :setAnchorPoint(cc.p(0, 0.5))
            :addTo(rootNode,nil,30002)
            :setPosition(83,22)
            :hide()
       end

       if rootNode:getChildByTag(30003) == nil then
            netY = display.newSprite("Image/PrivateRoom/img_NetY.png")
            :setAnchorPoint(cc.p(0, 0.5))
            :addTo(rootNode,nil,30003)
            :setPosition(83,22)
            :hide()
       end

        local setTime = function()

            delayTime = app.constant.delayTime
            netTime:setString(delayTime .. "ms")

            if delayTime<100 then
                netG:show()
                netY:hide()
                netTime:setTextColor(cc.c3b(0,255,0))
                netG:setTextureRect(cc.rect(0,0,37,26))
            elseif delayTime<200 then
                netG:show()
                netY:hide()
                netTime:setTextColor(cc.c3b(0,255,0))
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

        setTime()

        if self.delayHandler == nil then
            self.delayHandler = scheduler.scheduleGlobal(
            function()
                setTime()
            end, 1)
        end
   end
end

function SSSScene:showPRSeat(params)
    print("SSSScene:showSeat")

    local roomNode = cc.uiloader:seekNodeByNameFast(self.scene,"PrivateRoom"):show()
    
    --左上角信息---

    --局数
    cc.uiloader:seekNodeByNameFast(roomNode,"tx_ju_shu"):setString(tostring(params.gameround) .. "局")

    --房间号密码
    cc.uiloader:seekNodeByNameFast(roomNode,"tx_id"):setString(tostring(params.table_code))


    local info_bg = cc.uiloader:seekNodeByNameFast(roomNode,"info_bg")
    self:setDelayTime(info_bg)
    
    -----------------------------------
    --微信邀请
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(roomNode,"btn_WinXin_YaoQing"))
        :onButtonClicked(function()
            Share.requestWChatFriend(params.table_code, params.seat_cnt, params.gameround, 106, params.pay_type, self.customization)
        end)
    

    --开始游戏
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(roomNode,"btn_game_start"))
        :onButtonClicked(function()
            self:onStart()
        end)

    --如果是5人桌 调整椅子位置
    if self.seatCount == 5 then
        local points = {
            {x=72,y=96.43},
            {x=1208.58,y=303.26},
            {x=1208.58,y=524.56},
            {x=72,y=525.98},
            {x=72,y=306.09}
        }

        for k,v in pairs(points) do
            cc.uiloader:seekNodeByNameFast(self.scene, "User_" .. k):pos(v.x,v.y)
        end

        local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, "User_1")
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_Ready"):pos(-5,-47.53)
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_Complete"):pos(-5,-47.53)
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_Peipai"):pos(-5,-47.53)
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_DuanXian"):pos(-5,-47.53)
        cc.uiloader:seekNodeByNameFast(player_ui, "Text_nickname"):pos(110.65,-2.93)
        cc.uiloader:seekNodeByNameFast(player_ui, "Text_gold"):pos(105.56,-49.81)
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_Por"):pos(-4.00,-22.65)
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_Por"):scale(0.9)
        cc.uiloader:seekNodeByNameFast(player_ui, "Image_PorBG_transverse"):hide()
    else
        cc.uiloader:seekNodeByNameFast(self.scene, "Image_PorBG_vertical"):hide()
    end

    players = {}
end

--刷新当前局数
function SSSScene:updateCurrentGameNum()
    local Room_Info = cc.uiloader:seekNodeByNameFast(self.scene,"Room_Info")
    self.current_Ju_Shu = (self.current_Ju_Shu or 0) + 1
    cc.uiloader:seekNodeByNameFast(Room_Info, "tx_ju_shu"):setString(self.current_Ju_Shu .. "/" .. app.constant.curRoomRound .. "局")
end

function SSSScene:hidePRSeat()
    local roomNode = cc.uiloader:seekNodeByNameFast(self.scene,"PrivateRoom"):hide()

    --分数
    --cc.uiloader:seekNodeByNameFast(roomNode,"tx_fen"):setString("")

    --房间号密码
    cc.uiloader:seekNodeByNameFast(roomNode,"tx_id"):setString("")

    --微信邀请
    cc.uiloader:seekNodeByNameFast(roomNode,"btn_WinXin_YaoQing"):removeAllEventListeners()
end

function SSSScene:setPRPlayer(seat, name, score, sex, viptype, imageid)
    print("SSSScene:setPRPlayer---",score)

    if players[seat] then
        return
    end

    players[seat] = true

    self:setPlayer(seat,name,score,sex,viptype,imageid)
end

function SSSScene:clearPRPlayer(seat)
    print("SSSScene:clearPRPlayer---",score)
    players[seat] = false

    self:clearPlayer(seat)
end

--显示解散房间
function SSSScene:showRoomEndState(flag)
    if roomEnd then
        roomEnd:setVisible(flag)
    end
    players = {}
end

--显示已准备
function SSSScene:PRReady(seat)
    local ui_user = cc.uiloader:seekNodeByNameFast(self.scene,"User_" .. seat)

    --显示准备
    cc.uiloader:seekNodeByNameFast(ui_user,"Image_Ready"):show()
end

--刷新分
function SSSScene:updatePRScore(seat,score)
    print("SSSScene:updatePRScore---")

    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",seat))
    local gold = cc.uiloader:seekNodeByNameFast(player_ui, "Text_gold")
    gold:setString(score)
end

--显示战绩
function SSSScene:showRecord(recordInfo)
    print("SSSScene:showRecord---")

    if app.constant.voiceOn then
        sound_common.total_result_bg()
    end

    local roomNode = cc.uiloader:seekNodeByNameFast(self.scene,"PRoomRecord"):show()

    --房间号
    cc.uiloader:seekNodeByNameFast(roomNode,"code"):setString("房间号：" .. recordInfo.tablecode)

    --局数
    cc.uiloader:seekNodeByNameFast(roomNode,"num"):setString(recordInfo.gameround .. "局")

    --玩家战绩信息---
    local ui_user
    local ui_user_pos
    local info

    --4人位置不变
    local user_num = #recordInfo.infos
    if user_num == 2 then
        ui_user_pos = {
            {x = 393.24,y = 368.50},
            {x = 884.66,y = 368.50},
        }
    elseif user_num == 3 then
        ui_user_pos = {
            {x = 265.15,y = 368.50},
            {x = 640.00,y = 368.50},
            {x = 1008.06,y = 368.50},
        }
    end

    for i=1,4 do
        ui_user = cc.uiloader:seekNodeByNameFast(roomNode,"User_Record_" .. i)
        info = recordInfo.infos[i]
        if info then  --显示信息
            --头像
            local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",self:getViewSeat(info.seat)))
            local por = cc.uiloader:seekNodeByNameFast(player_ui, "Image_Por")
            local head_icon_img = cc.uiloader:seekNodeByNameFast(ui_user, "head_icon_img")
            local WXHEAD = por:getParent():getChildByName("WXHEAD")
            if WXHEAD then
                head_icon_img:setSpriteFrame(WXHEAD:getSpriteFrame():clone())
                head_icon_img:setScale(1.27)
            else
                head_icon_img:setSpriteFrame(por:getSpriteFrame():clone())
                head_icon_img:setScale(0.95)
            end
            
            --名称
            cc.uiloader:seekNodeByNameFast(ui_user,"tx_name"):setString(util.checkNickName(crypt.base64decode(info.name)))
            
            --分数
            cc.uiloader:seekNodeByNameFast(ui_user,"tx_fen"):setString("分数：" .. info.score)

            --胜负平局
            if info.wincnt == nil then
                cc.uiloader:seekNodeByNameFast(ui_user,"wincnt"):setString("胜局：" .. 0 .. "局")
            else
                cc.uiloader:seekNodeByNameFast(ui_user,"wincnt"):setString("胜局：" .. info.wincnt .. "局")
            end

            if info.drawcnt == nil then
                cc.uiloader:seekNodeByNameFast(ui_user,"drawcnt"):setString("平局：" .. 0 .. "局")
            else
                cc.uiloader:seekNodeByNameFast(ui_user,"drawcnt"):setString("平局：" .. info.drawcnt .. "局")
            end

            if info.losecnt == nil then
                cc.uiloader:seekNodeByNameFast(ui_user,"losecnt"):setString("败数：" .. 0 .. "局")
            else
                cc.uiloader:seekNodeByNameFast(ui_user,"losecnt"):setString("败数：" .. info.losecnt .. "局")
            end


            --更位置
            if ui_user_pos then
                ui_user:pos(ui_user_pos[i].x,ui_user_pos[i].y)
            end
        else
            ui_user:hide()
        end
    end
    ---------------------------

    --退出房间
    cc.uiloader:seekNodeByNameFast(roomNode,"btn_tuichu")
        :onButtonClicked(function()
            message.dispatchPrivateRoom("room.ExitTable", {})
        end)

    --分享战绩
    cc.uiloader:seekNodeByNameFast(roomNode,"btn_fenxiang")
        :onButtonClicked(function()
            Share.createGameShareLayer():addTo(self)
        end)
end

return SSSScene