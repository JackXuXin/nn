--
-- Author: peter
-- Date: 2017-02-17 13:51:47
--

local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
local AvatarConfig = require("app.config.AvatarConfig")
local util = require("app.Common.util")

local gameScene = nil

local SRDDZ_uiPlayerInfos = {}

function SRDDZ_uiPlayerInfos:init(scene)
	gameScene = scene

	self.ui_infos = {}  --每个玩家的UI信息

	for i=1,SRDDZ_Const.MAX_PLAYER_NUMBER do
		local user_info_ui = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_player_info_"..i)
		self.ui_infos[i] = {
			ui_body = user_info_ui,
			ui_cards = {},
		}

		self.ui_infos[i].ui_body:setVisible(false)
	end
end

function SRDDZ_uiPlayerInfos:clear()
	self.ui_infos = {}
end

--[[
	* 显示玩家UI信息
	* @param number seatId  显示UI玩家的椅子号
	* @param table playerInfo  显示UI玩家的信息 昵称 金币等等
--]]
function SRDDZ_uiPlayerInfos:showPlayerInfoUI(seatId,playerInfo,viptype)

	cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_tx_user_name"):setString(util.checkNickName(playerInfo.mName))
	cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_tx_user_silver"):setString(SRDDZ_Util.num2str(playerInfo.mGold))
	cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_sp_Trusteeship"):setVisible(playerInfo.mIsTuoGuan)

	if viptype > 0 then
      cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_tx_user_name"):setColor(cc.c3b(255, 0, 0))
    end

	self.ui_infos[seatId].ui_body:setVisible(true)

	-- --头像背景
	-- local image = AvatarConfig:getAvatarBG(playerInfo.sex, playerInfo.mGold, 0, 1)
 --    local rect = cc.rect(0, 0, 105, 105)
 --    local frame = cc.SpriteFrame:create(image, rect)
    local por = cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_sp_touxiang_bg")
    --por:setSpriteFrame(frame)
    por:hide()
    image = AvatarConfig:getAvatar(playerInfo.sex, playerInfo.mGold, playerInfo.viptype)

    --微信头像设置
    local img_userinfobg = cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "img_userinfobg")
    local img_touXiang = cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_sp_touxiang")

	img_touXiang:show()
	--头像
    rect = cc.rect(0, 0, 188, 188)
    frame = cc.SpriteFrame:create(image, rect)
    por = cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_sp_touxiang")
    por:setSpriteFrame(frame)
    por:setScale(0.53)

    --local bgpor = cc.uiloader:seekNodeByNameFast(self.ui_infos[seatId].ui_body, "k_sp_touxiang_bg")

	util.setHeadImage(img_userinfobg, playerInfo.imageid, img_touXiang, image, 1)

end

--[[
	* 获取玩家牌信息
	* @return 玩家牌信息
--]]
function SRDDZ_uiPlayerInfos:getPlayerCardInfos()
	local ui_cards = self.ui_infos[1].ui_cards
	local cards = {}

	for k,v in ipairs(ui_cards) do
		table.insert(cards,{num = v:getCardNum(),color = v:getCardColor()})
	end

	return cards
end


return SRDDZ_uiPlayerInfos