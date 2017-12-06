--
-- Author: peter
-- Date: 2017-03-10 17:08:04
--

local AvatarConfig = require("app.config.AvatarConfig")
local util = require("app.Common.util")

local gameScene = nil

local WL_uiPlayerInfos = {}

function WL_uiPlayerInfos:init(scene)
	gameScene = scene

	self.ui_infos = {} --每个玩家的UI信息

	for i=1,gameScene.WL_Const.MAX_PLAYER_NUMBER do
		local user_info_ui = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_player_info_" .. i)
		self.ui_infos[i] = {
			ui_body = user_info_ui,
			k_tx_user_name = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_tx_user_name"),
			k_tx_user_silver = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_tx_user_silver"),
			k_tx_score = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_tx_score"),
			k_sp_Trusteeship = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_Trusteeship"),
			k_img_title_bg = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_img_title_bg"),
			k_ta_player_score = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_ta_player_score"),
			k_sp_ready = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_ready"),
			k_img_score_bg = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_img_score_bg"),
		}

		self.ui_infos[i].ui_body:setVisible(false)
	end

end

function WL_uiPlayerInfos:clear()
end

--[[
	* 显示玩家UI信息
	* @param table playerInfo  显示UI玩家的信息 昵称 金币等等
--]]
function WL_uiPlayerInfos:showPlayerInfoUI(playerInfo)
	print("椅子号 = " .. playerInfo.seat .. "  "  ..playerInfo.name)

	--名字
	self.ui_infos[playerInfo.seat].k_tx_user_name:setString(util.checkNickName(playerInfo.name))
	--金币
	self.ui_infos[playerInfo.seat].k_tx_user_silver:setString(gameScene.WL_Util.num2str(playerInfo.gold))
	--托管
	self.ui_infos[playerInfo.seat].k_sp_Trusteeship:setVisible(playerInfo.isTuoGuan)
	--准备
	self.ui_infos[playerInfo.seat].k_sp_ready:setVisible(playerInfo:isReadyState())
	--奖金背景
	self.ui_infos[playerInfo.seat].k_img_title_bg:setVisible(false)
	self.ui_infos[playerInfo.seat].k_img_title_bg:setLocalZOrder(10)
	--总得分背景
	self.ui_infos[playerInfo.seat].k_img_score_bg:setVisible(false)

 --    --头像背景
	-- local image = AvatarConfig:getAvatarBG(playerInfo.sex, playerInfo.mGold, 0, 1)
 --    local rect = cc.rect(0, 0, 105, 105)
 --    local frame = cc.SpriteFrame:create(image, rect)
    local por = cc.uiloader:seekNodeByNameFast(self.ui_infos[playerInfo.seat].ui_body, "k_sp_touxiang_bg")
    --por:setSpriteFrame(frame)
    por:setScale(0.95)
    por:hide()

    --微信头像设置
    local img_userinfobg = cc.uiloader:seekNodeByNameFast(self.ui_infos[playerInfo.seat].ui_body, "img_userinfobg")
    local img_touXiang = cc.uiloader:seekNodeByNameFast(self.ui_infos[playerInfo.seat].ui_body, "k_sp_touxiang")

	img_touXiang:show()
	--头像
	image = AvatarConfig:getAvatar(playerInfo.sex, playerInfo.mGold, playerInfo.viptype)
    rect = cc.rect(0, 0, 188, 188)
    frame = cc.SpriteFrame:create(image, rect)
    por = cc.uiloader:seekNodeByNameFast(self.ui_infos[playerInfo.seat].ui_body, "k_sp_touxiang")
    por:setSpriteFrame(frame)
    por:setScale(0.53)

	--local bgpor = cc.uiloader:seekNodeByNameFast(self.ui_infos[playerInfo.seat].ui_body, "k_sp_touxiang_bg")
	util.setHeadImage(img_userinfobg, playerInfo.imageid, img_touXiang, image, 1)

    self.ui_infos[playerInfo.seat].ui_body:setVisible(true)
end

--[[
	* 显示所有玩家奖金背景 and 总得分背景
	* @param boolean flag 显示状态
--]]
function WL_uiPlayerInfos:showAllPlayerTitle(flag)
	for _,ui_info in ipairs(self.ui_infos) do
		ui_info.k_img_title_bg:setVisible(flag)
		ui_info.k_img_score_bg:setVisible(flag)
		if flag then
			ui_info.k_ta_player_score:setString("0")
			ui_info.k_tx_score:setString("0")
		end
	end


	--本局得分的显示
end

--[[
	* 刷新奖金数
	* @param number seatId  玩家椅子号
	* @param number bonus 奖金数
--]]
function WL_uiPlayerInfos:updateBonus(seatId,bonus)
	if bonus <= 0 then
		return 
	end

	self.ui_infos[seatId].k_ta_player_score:setString(tostring(bonus))
end

--[[
	* 刷新总分
	* @param number seatId  玩家椅子号
	* @param number finalScore 奖金数
	* @param number finalScore 奖金数
--]]
function WL_uiPlayerInfos:updateFinalScore(seatId,finalScore)
	if finalScore <= 0 then
		return
	end

	self.ui_infos[seatId].k_tx_score:setString(tostring(finalScore))
end

--[[
	* 显示托管标示
	* @param number seatId  玩家椅子号
	* @param boolean flag 显示状态
--]]
function WL_uiPlayerInfos:showQuXiaoTuoGuanUI(seatId,flag)
	self.ui_infos[seatId].k_sp_Trusteeship:setVisible(flag)
end

return WL_uiPlayerInfos