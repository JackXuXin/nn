--
-- Author: peter
-- Date: 2017-03-10 18:56:47
--

local scheduler = require("framework.scheduler")

local ui_rankings = {}

-- colors 
local COLOR_YELLOW = cc.c3b(255,255,0)
local COLOR_WHITE = cc.c3b(255,255,255)

local gameScene = nil

local WL_uiResults = {}

function WL_uiResults:init(scene)
	gameScene = scene

	self.k_nd_layer_result = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_layer_result")
	self.k_nd_layer_result:setVisible(false)
	self.k_nd_layer_result:setLocalZOrder(2001)

	self.k_btn_TuiChuFangJian = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_TuiChuFangJian")
	self.k_btn_TuiChuFangJian:onButtonClicked(handler(self,self.clickTuiChu))

	self.k_btn_ZaiLaiYiJu = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_ZaiLaiYiJu")
	self.k_btn_ZaiLaiYiJu:onButtonClicked(handler(self,self.clickJiXu))
end

function WL_uiResults:clear()
	ui_rankings = {}
end


--[[
	* click退出房间
--]]
function WL_uiResults:clickTuiChu()
	gameScene.WL_Message.dispatchGame("room.LeaveGame")

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_QUIT)
end

--[[
	* click再来一局
--]]
function WL_uiResults:clickJiXu()
	if gameScene.seatIndex == 0 and gameScene.session == 0 then
        gameScene.WL_Message.dispatchGame("room.LeaveGame")
        return 
    end

	gameScene.WL_Message.dispatchGame("room.ReadyReq",gameScene.WL_Const.REQUEST_INFO_00)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_CONTINUE)
end

--[[
	* 显示游戏结果
	* *param bool flag 显示状态
	* @param table records 结算的信息数据
--]]
function WL_uiResults:showGameResult(flag,records)
	if not flag then
		for index,ui_ranking in pairs(ui_rankings) do
			ui_ranking:removeFromParent()
		end

		ui_rankings = {}

		self.k_nd_layer_result:setVisible(flag)
		return 
	end

	local k_la_Panel_result = cc.uiloader:seekNodeByName(self.k_nd_layer_result, "k_la_Panel_result")

	for index,recordInfo in ipairs(records) do
		local ui_record = cc.uiloader:seekNodeByNameFast(k_la_Panel_result, "k_player_result_" .. recordInfo.seat)

		--名字
		local ui_name = cc.uiloader:seekNodeByName(ui_record, "k_player_name")
		ui_name:setString(util.checkNickName(recordInfo.name))
		ui_name:setColor(COLOR_WHITE)

		--分数
		local ui_score = cc.uiloader:seekNodeByName(ui_record, "k_player_score")
		ui_score:setString(tostring(recordInfo.score))
		ui_score:setColor(COLOR_WHITE)

		--奖金
		local ui_bonus = cc.uiloader:seekNodeByName(ui_record, "k_player_bonus")
		ui_bonus:setString(tostring(recordInfo.bonus))
		ui_bonus:setColor(COLOR_WHITE)

		--总得分
		local ui_total = cc.uiloader:seekNodeByName(ui_record, "k_player_total_score")
		ui_total:setString(tostring(recordInfo.total))
		ui_total:setColor(COLOR_WHITE)

		--刷新玩家总得分 为了最后一手牌是 分数牌而刷新
		gameScene.WL_uiPlayerInfos:updateFinalScore(recordInfo.seat,recordInfo.total)

		--排名
		local pos = cc.p(ui_name:getPosition())
		local size = ui_name:getContentSize()

		local ui_ranking = display.newSprite(gameScene.WL_Const.PATH['IMG_RANKING_' .. recordInfo.result])
		ui_ranking:setAnchorPoint(cc.p(1,0.5))
		ui_ranking:setPosition(cc.p(pos.x-size.width/2-6,pos.y))
		ui_record:addChild(ui_ranking)
		ui_rankings[recordInfo.seat] = ui_ranking

		--自己的颜色
		if recordInfo.seat == 1 then
			ui_name:setColor(COLOR_YELLOW)
			ui_score:setColor(COLOR_YELLOW)
			ui_bonus:setColor(COLOR_YELLOW)
			ui_total:setColor(COLOR_YELLOW)
		end
	end

	scheduler.performWithDelayGlobal(
		function()
			self.k_nd_layer_result:setVisible(flag)
		end,3)
end

--[[
	* 结算界面显示状态
	* *param bool 显示状态
--]]
function WL_uiResults:isVisible()
	return self.k_nd_layer_result:isVisible()
end

return WL_uiResults