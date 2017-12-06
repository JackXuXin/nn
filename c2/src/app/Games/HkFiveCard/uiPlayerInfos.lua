
local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local comUtil = require("app.Common.util")
local util = require("app.Games.HkFiveCard.util")
local utilCommon = require("app.Common.util")

local AvatarConfig = require("app.config.AvatarConfig")

local scene = nil

local uiPlayerInfos = {}

local NetSprite = require("app.config.NetSprite")

function uiPlayerInfos:init(tableScene)
	scene = tableScene

	self.ui_infos = {}
	for i = 1, consts.MAX_PLAYER_NUM do
		local user_info_ui = cc.uiloader:seekNodeByNameFast(scene.root, "player_info_"..i)
		self.ui_infos[i] = {
			ui_body = user_info_ui,
			img_user_playing = cc.uiloader:seekNodeByName(user_info_ui, "img_userplaying"),
			lb_user_name = cc.uiloader:seekNodeByName(user_info_ui, "user_name"),
			lb_user_silver = cc.uiloader:seekNodeByName(user_info_ui, "user_silver"),
			lb_cur_chip_in = cc.uiloader:seekNodeByName(user_info_ui, "cur_chip_in"),
			lb_total_chip_in = cc.uiloader:seekNodeByName(user_info_ui, "total_chip_in"),
			lb_xiazhu_bg = cc.uiloader:seekNodeByName(user_info_ui, "XiaZhuBG"),
			lb_user_touxiang = cc.uiloader:seekNodeByNameFast(user_info_ui, "touxiang"),
			lb_user_touxiang_bg = cc.uiloader:seekNodeByNameFast(user_info_ui, "touxiang_bg"),
			img_userinfobg = cc.uiloader:seekNodeByNameFast(user_info_ui, "img_userinfobg"),
			ui_cards = {},
			ui_jettons = {},
		}
		self.ui_infos[i].ui_body:setVisible(false)
		self.ui_infos[i].img_user_playing:setVisible(false)
		self.ui_infos[i].lb_user_name:setVisible(true) -- control by ui_body
		self.ui_infos[i].lb_user_silver:setVisible(true) -- control by ui_body
		-- shows on action add 
		self.ui_infos[i].lb_cur_chip_in:setVisible(false)
		self.ui_infos[i].lb_total_chip_in:setVisible(false)
		self.ui_infos[i].lb_xiazhu_bg:setVisible(false)

	end
	
	return self
end

function uiPlayerInfos:clear()

end

function uiPlayerInfos:visible(seatId)
	return self.ui_infos[seatId].ui_body:isVisible()
end

-- for show waiting words on scene
function uiPlayerInfos:visibleCnt()
	local cnt = 0
	for i = 1, consts.MAX_PLAYER_NUM do
		if self.ui_infos[i].ui_body:isVisible() then
			cnt = cnt + 1
		end
	end
	return cnt
end

function uiPlayerInfos:setInfo(seatId, name, silver)

    print("uiPlayerInfos:setInfo")

	local ui_info = self.ui_infos[seatId]
	ui_info.lb_user_name:setString(comUtil.checkNickName(name))
	ui_info.lb_user_silver:setString(util.num2str(silver))
end

function uiPlayerInfos:showSeatInfo(seatId, flag)
	local ui_info = self.ui_infos[seatId]
	ui_info.ui_body:setVisible(flag)

	local player = vars.players[seatId]
	if player then
		ui_info.lb_user_name:setString(comUtil.checkNickName(player.name))
		ui_info.lb_user_silver:setString(util.num2str(player.gold))

		if player.sex ~= 0 then

			--头像背景
			-- local image = AvatarConfig:getAvatarBG(player.sex, player.gold, 0,1)
   --  		local rect = cc.rect(0, 0, 105, 105)
   --  		local frame = cc.SpriteFrame:create(image, rect)
    		local por = ui_info.lb_user_touxiang_bg
    		local img_userinfobg = ui_info.img_userinfobg
    		--por:setSpriteFrame(frame)
    		por:hide()
    		image = AvatarConfig:getAvatar(player.sex, player.gold, player.viptype)
           
			ui_info.lb_user_touxiang:show()
			--头像
    		rect = cc.rect(0, 0, 188, 188)
    		frame = cc.SpriteFrame:create(image, rect)
    		por = ui_info.lb_user_touxiang
    		por:setSpriteFrame(frame)
    		por:setScale(0.53)

	         --设置微信头像
	        utilCommon.setHeadImage(img_userinfobg, player.imageid, ui_info.lb_user_touxiang, image, 1)
	       

		end

		print("viptype:" .. player.viptype)
--modify by whb 161031
    if player.viptype ~= nil and player.viptype > 0 then
       ui_info.lb_user_name:setColor(cc.c3b(255, 0, 0))
    end
--modify end
	end
end

function uiPlayerInfos:updateChip(seatId)
	local ui_info = self.ui_infos[seatId]
	local lb_cur_chip = ui_info.lb_cur_chip_in
	local lb_total_chip = ui_info.lb_total_chip_in
	local lb_silver = ui_info.lb_user_silver
	local lb_xiazhu_bg = ui_info.lb_xiazhu_bg

	local player = vars.players[seatId]
	if player == nil then 
		printf("seat:%d player data is nil.", seatId)
		return 
	end

	lb_cur_chip:setVisible(player.curchip > 0)
--	lb_cur_chip:setString(comUtil.toDotNum(player.curchip))
	lb_cur_chip:setString(util.num2str(player.curchip))
	lb_xiazhu_bg:setVisible(player:total_chip() > 0)
	lb_total_chip:setVisible(player:total_chip() > 0)
--	lb_total_chip:setString(comUtil.toDotNum(player:total_chip()))
	lb_total_chip:setString(util.num2str(player:total_chip()))
	lb_silver:setString(util.num2str(player:left_gold()))
end

return uiPlayerInfos