--
-- Author: peter
-- Date: 2017-03-10 19:18:57
--

local gameScene = nil

local WL_uiTableInfos = {}

function WL_uiTableInfos:init(scene)
	gameScene = scene

	self.k_tx_DiFen = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_tx_DiFen")
	self.k_tx_DiFen:setString("")

	self.k_img_roundScore_bg = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_img_roundScore_bg")
	self.k_img_roundScore_bg:setVisible(false)

	self.k_ta_roundScore = cc.uiloader:seekNodeByName(self.k_img_roundScore_bg, "k_ta_roundScore")
	self.k_ta_roundScore:setString("0")

	self.k_nd_DengDai = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_DengDai")
	self.k_nd_DengDai:setVisible(false)
end

function WL_uiTableInfos:clear()
end

--[[
	* 设置底分
	* @param number num 底分
--]]
function WL_uiTableInfos:setDiFen(num)
	self.k_tx_DiFen:setString(tostring(num))
end

--[[
	* 是否已经全部准备
	* return boolean 状态
--]]
local function isPlayerAllReady()
	local count = 0
	for k,v in pairs(gameScene.WL_PlayerMgr.playerInfos) do
		count = count + 1
	end

	if count ~= 4 then
		return false
	end

	for k,v in ipairs(gameScene.WL_PlayerMgr.playerInfos) do
		if not v:isReadyState() then
			return false
		end
	end

	return true
end

--[[
	* 显示等待其他玩家准备
	* @param boolean flag  显示状态
--]]
function WL_uiTableInfos:showWaitState(flag)
	if not self.k_nd_DengDai then
		return
	end

	--如果都准备了就返回
	if flag then
		if isPlayerAllReady() then
			return 
		end
	end

	if flag then
		--先隐藏3个点
		for i=1,3 do
			cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. i):setVisible(false)
		end

		--执行点点点动画
		local count = 0
		self.k_nd_DengDai:schedule(
			function()
				count = count + 1
				if count > 3 then
					for i=1,3 do
						cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. i):setVisible(false)
					end
					count = 0
					return
				end

				cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. count):setVisible(true)

			end,0.4)
	else
		self.k_nd_DengDai:stopAllActions()
	end

	self.k_nd_DengDai:setVisible(flag)
end

--[[
	* 显示本轮总分
	* @param boolean flag  显示状态
--]]
function WL_uiTableInfos:showRoundScore(flag)
	self.k_img_roundScore_bg:setVisible(flag)

	if not flag then
		self:updateRoundScore(0)
	end
end

--[[
	* 刷新本轮总分
	* @param number score  本轮总分
--]]
function WL_uiTableInfos:updateRoundScore(score)
	self.k_ta_roundScore:setString(tostring(score))
end

--[[
	* 显示得分动画
	* @param number 本轮胜利玩家椅子号
	* @param number winScore 玩家本轮得分
--]]
function WL_uiTableInfos:showScoreAction(winner,winScore)
	if winScore <= 0 then
		return 
	end

	local ui_winScore = cc.LabelAtlas:_create()
    ui_winScore:initWithString(
            tostring(winScore),
            gameScene.WL_Const.PATH.TX_SCORE,
            21,
            26,
            string.byte('0'))
    ui_winScore:setAnchorPoint(cc.p(0.5,0.5))
    ui_winScore:setPosition(cc.p(self.k_ta_roundScore:getPosition()))
    self.k_img_roundScore_bg:addChild(ui_winScore,2)

    local move = cca.moveBy(2,250,0)
    local distance = 250
    local time = 2

    if winner == 1 then
    	move = cca.moveBy(time,0,-distance)
    elseif winner == 2 then
    	move = cca.moveBy(time,distance,0)
    elseif winner == 3 then
    	move = cca.moveBy(time,0,distance)
    else
    	move = cca.moveBy(time,-distance,0)
    end

    local fade = cca.fadeOut(time)
    local spawn = cca.spawn{move,fade}
    local callfunc = cca.cb(function() ui_winScore:removeFromParent() end)
    local seq = cca.seq{spawn,callfunc}
    ui_winScore:runAction(seq)
end

return WL_uiTableInfos