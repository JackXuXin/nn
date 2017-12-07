local SSSScene = package.loaded["app.scenes.SSSScene"] or {}

--local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local util = require("app.Common.util")
local NetSprite = require("app.config.NetSprite")

local playerSex = {}
local playerScore = {}
local playerVip = {}
local playerState = {}

--[[ --
    * 显示Player
--]]
function SSSScene:setPlayer(direct, name, score, sex, viptype, imageid, uid)
    --显示Player节点
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",direct))
    player_ui:setLocalZOrder(100)
    player_ui:show()

    --隐藏配牌 完成 文字图片
    cc.uiloader:seekNodeByNameFast(player_ui, "Image_Peipai"):hide()
    cc.uiloader:seekNodeByNameFast(player_ui, "Image_Complete"):hide()
    cc.uiloader:seekNodeByNameFast(player_ui, "Image_DuanXian"):hide()
    
    --调整 1 号为玩家位置
    if direct == 1 then
        player_ui:setPosition(cc.p(72,96.43))
    end

    --头像
    local image = AvatarConfig:getAvatar(sex, score, viptype)
    local rect = cc.rect(0, 0, 178, 176)
    local frame = cc.SpriteFrame:create(image, rect)

    --清理微信头像
    local img_userinfobg = cc.uiloader:seekNodeByNameFast(player_ui, "Image_PorBG")
    if img_userinfobg:getChildByName("WXHEAD") then
        img_userinfobg:getChildByName("WXHEAD"):removeSelf()
    end

    --微信头像设置
    local img_userinfobg = cc.uiloader:seekNodeByNameFast(player_ui, "Image_PorBG")
    local img_touXiang = cc.uiloader:seekNodeByNameFast(player_ui, "Image_Por")
    img_touXiang:setSpriteFrame(frame)
    img_touXiang:scale(0.54)

    if imageid and imageid ~="" then
        self.eHeadInfo[direct].imageid = imageid
    else
        self.eHeadInfo[direct].imageid = nil
    end
    self.eHeadInfo[direct].uid = uid
    self.eHeadInfo[direct].image = image

    util.setHeadImage(img_userinfobg, imageid, img_touXiang, image)

    --昵称
    local nickname = cc.uiloader:seekNodeByNameFast(player_ui, "Text_nickname")
    local len = string.len(name)
    local size = 20
    if len > 12 then
        size = 18
    end
    -- local max_len = 12
    -- if len > max_len then
    --     name = string.sub(name,1,max_len - 3) .. "..."
    -- end
    nickname:setSystemFontSize(size)
    nickname:setString(util.checkNickName(tostring(name)))
    if viptype > 0 then
      nickname:setColor(cc.c3b(255, 0, 0))
   end

    --金币数
    local gold = cc.uiloader:seekNodeByNameFast(player_ui, "Text_gold")
    gold:setString(util.num2str_thousand(score))

    --玩家数据
    playerSex[direct] = sex
    playerScore[direct] = score
    playerVip[direct] = viptype
    playerState[direct] = nil
end

--[[ --
    * 隐藏Player
--]]
function SSSScene:clearPlayer(direct)
    print("-------SSSScene:clearPlayer-------")
    --隐藏Player节点
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",direct))
    player_ui:hide()

    --头像重置
    local image = "Image/SSS/por.png"
    local rect = cc.rect(0, 0, 100, 100)
    local frame = cc.SpriteFrame:create(image, rect)
    local por = cc.uiloader:seekNodeByNameFast(player_ui, "Image_Por")
    por:setSpriteFrame(frame)
    por:setScale(1.05)
    --清理微信头像
    local img_userinfobg = cc.uiloader:seekNodeByNameFast(player_ui, "Image_PorBG")
    if img_userinfobg:getChildByName("WXHEAD") then
        img_userinfobg:getChildByName("WXHEAD"):removeSelf()
    end

    --昵称重置
    local nickname = cc.uiloader:seekNodeByNameFast(player_ui, "Text_nickname")
    nickname:setString("")

    --金币重置
    local gold = cc.uiloader:seekNodeByNameFast(player_ui, "Text_gold")
    gold:setString("")
end

--[[ --
    * 设置完成显示状态
--]]
function SSSScene:setComplete(direct, comp)
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",direct))
    local com = cc.uiloader:seekNodeByNameFast(player_ui, "Image_Complete")
    com:setVisible(comp)
end

--[[ --
    * 设置准备显示状态
--]]
function SSSScene:setState(direct, comp)
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",direct))
    cc.uiloader:seekNodeByNameFast(player_ui, "Image_Ready")
    :setVisible(comp)
end

--[[ --
    * 设置配牌显示状态
--]]
function SSSScene:setPeipai(direct, comp)
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",direct))
    cc.uiloader:seekNodeByNameFast(player_ui, "Image_Peipai")
    :setVisible(comp)

    if comp then
       
    end
end

--[[ --
    * 设置断线显示状态
--]]
function SSSScene:setDuanXian(direct, comp)
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",direct))
    cc.uiloader:seekNodeByNameFast(player_ui, "Image_DuanXian")
    :setVisible(comp)
end
   
--[[ --
    * 获取性别
--]]
function SSSScene:getSex(seatId)
    return playerSex[seatId]
end

--[[ --
    * 获取分数
--]]
function SSSScene:getScore(seatId)
    return playerScore[seatId]
end

--[[ --
    * 获取VIP
--]]
function SSSScene:getVip(seatId)
    return playerVip[seatId]
end

--[[ --
    * 设置玩家游戏状态 nil = 没有状态 1 = 配牌中 2 = 配牌完成  3 = 已准备
--]]
function SSSScene:setGameState(seatId,state)
    playerState[seatId] = state
end

--[[ --
    * 获取玩家游戏状态
--]]
function SSSScene:getGameState(seatId)
    return playerState[seatId]
end

--[[ --
    * 清理游戏状态
--]]
function SSSScene:clearGameState()
    playerState = {}
end

--[[ --
    * 设置自己的信息显示状态
    @param  bool  flag  显示状态
--]]
function SSSScene:setMyInfoShowState(flag,point)
    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, "User_1")
    player_ui:setVisible(flag)

    if flag and point then
        player_ui:pos(point.x,point.y)
    end
end

--[[ --
    * 清理Playe信息
--]]
function SSSScene:clearPlayers()
    playerSex = {}
    playerScore = {}
    playerVip = {}
    playerState = {}
end

return SSSScene