local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local RoomConfig = require("app.config.RoomConfig")
local MatchMessage = require("app.net.MatchMessage")
local web = require("app.net.web")
local util = require("app.Common.util")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local ProgressLayer = require("app.layers.ProgressLayer")
local ErrorLayer = require("app.layers.ErrorLayer")
local sound_common = require("app.Common.sound_common")
local AvatarConfig = require("app.config.AvatarConfig")
local PlatConfig = require("app.config.PlatformConfig")

local _leftTime
local _matchListInfo

local function _setSignWithMatchid(matchid,isSign)
	print("_setSignWithMatchid---", matchid, isSign)
	for i=1,#_matchListInfo do
		if _matchListInfo[i].matchid == matchid then
			_matchListInfo[i].signup = isSign
			break
		end
	end
end

local function _isSignWithMatchid(matchid)
	print("_isSignWithMatchid---", matchid)
	for i=1,#_matchListInfo do
		if _matchListInfo[i].matchid == matchid then
			return _matchListInfo[i].signup
		end
	end
end

local function _sceneTopAndBottomMoveAction(self, isShow, nd_all)
	local TopBar = cc.uiloader:seekNodeByNameFast(self.scene, "TopBar")
	local Image_BottomBar = cc.uiloader:seekNodeByNameFast(self.scene, "Image_BottomBar")

	local Panel_Bg1 = cc.uiloader:seekNodeByNameFast(self.scene, "Panel_Bg1")
	local Button_House1 = cc.uiloader:seekNodeByNameFast(Panel_Bg1, "Button_House1")
	local Button_House2 = cc.uiloader:seekNodeByNameFast(Panel_Bg1, "Button_House2")

	local actionTime = 0.2
	if isShow then
		TopBar:moveTo(actionTime, TopBar:getPositionX(), 720)
		Image_BottomBar:moveTo(actionTime, Image_BottomBar:getPositionX(), 0)
		Button_House1:fadeIn(actionTime)
		Button_House2:fadeIn(actionTime)
	else
		TopBar:moveTo(actionTime, TopBar:getPositionX(), 800)
		Image_BottomBar:moveTo(actionTime, Image_BottomBar:getPositionX(), -95)
		Button_House1:fadeOut(actionTime)
		Button_House2:fadeOut(actionTime)

		nd_all:performWithDelay(function ()
			nd_all:show()
		end, actionTime)
	end
end

--[[ --
	* 显示比赛房间图层
--]]
function LobbyScene:showMatchLayer()
    --比赛房间列表图层
	local matchListLayer = cc.uiloader:load("Layer/Lobby/match/MatchListLayer.json"):addTo(self.scene)
	self.matchListLayer = matchListLayer

	local nd_all = cc.uiloader:seekNodeByNameFast(matchListLayer, "nd_all"):hide()
	_sceneTopAndBottomMoveAction(self, false, nd_all)

	--title按钮
	local ck_sss_title = cc.uiloader:seekNodeByNameFast(matchListLayer, "ck_sss_title")
	local ck_symj_title = cc.uiloader:seekNodeByNameFast(matchListLayer, "ck_symj_title")

	local img_sss_titile = cc.uiloader:seekNodeByNameFast(ck_sss_title, "img_sss_titile")
	local img_symj_titile = cc.uiloader:seekNodeByNameFast(ck_symj_title, "img_symj_titile")
	local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
	for k,v in ipairs(platConfig.game) do
		if v.gameid == 106 then    --sss
			img_sss_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_match_titile_1.png", cc.rect(0,0,176,34)))
		-- elseif v.gameid == 116 then  --nn
		-- 	img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_wrnn_title_1.png", cc.rect(0,0,210,34)))
		elseif v.gameid == 101 then  --symj
			img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_symj_title_1.png", cc.rect(0,0,247,33)))
		end
	end

	local list_sss_match = cc.uiloader:seekNodeByNameFast(matchListLayer, "list_sss_match")
	local list_symj_match = cc.uiloader:seekNodeByNameFast(matchListLayer, "list_symj_match")

	--暂无比赛 文字
	local tx_match_prompt = cc.uiloader:seekNodeByNameFast(matchListLayer, "tx_match_prompt")

	local function onMatchListSelect(button)
		print("onMatchListSelect---")
		if button == ck_sss_title then
			local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
			for k,v in ipairs(platConfig.game) do
				if v.gameid == 106 then    --sss
					img_sss_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_match_titile_2.png", cc.rect(0,0,176,34)))
				-- elseif v.gameid == 116 then  --nn
				-- 	img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_wrnn_title_1.png", cc.rect(0,0,210,34)))
				elseif v.gameid == 101 then  --symj
					img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_symj_title_1.png", cc.rect(0,0,247,33)))
				end
			end
			-- img_sss_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_match_titile_2.png", cc.rect(0,0,176,34)))
			-- img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_symj_title_1.png", cc.rect(0,0,246,33)))

			list_sss_match:show()
			list_symj_match:hide()

			tx_match_prompt:hide()
		end

		if button == ck_symj_title then
			local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
			for k,v in ipairs(platConfig.game) do
				if v.gameid == 106 then    --sss
					img_sss_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_match_titile_1.png", cc.rect(0,0,176,34)))
				-- elseif v.gameid == 116 then  --nn
				-- 	tx_match_prompt:setString("牛魔王比赛房暂未开放！")
				-- 	img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_wrnn_title_2.png", cc.rect(0,0,210,34)))
				elseif v.gameid == 101 then  --symj
					img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_symj_title_2.png", cc.rect(0,0,247,33)))
				end
			end
			-- img_sss_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_match_titile_1.png", cc.rect(0,0,176,34)))
			-- img_symj_titile:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_symj_title_2.png", cc.rect(0,0,246,33)))

			list_sss_match:hide()
			list_symj_match:show()

			tx_match_prompt:show()
		end
	end

	local group_1 = RadioButtonGroup.new({
		[ck_sss_title] = onMatchListSelect,
		[ck_symj_title] = onMatchListSelect,
	})

	--默认十三水比赛
	ck_sss_title:setButtonSelected(true)

	--关闭按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(matchListLayer, "btn_close"))
		:onButtonClicked(function ()
			_sceneTopAndBottomMoveAction(self, true)
			matchListLayer:removeSelf()
			_matchListInfo = nil
			_leftTime = nil
			self.matchListLayer = nil
		end)
end

--[[ --
    * 显示比赛房间List界面
	@param table		msg			List数据
	@param table		oldMsg		发送请求的数据	
--]]
function LobbyScene:MatchListRep(msg,oldMsg)
    print("MatchListRep---")

    local config = RoomConfig:getGameConfig(oldMsg.gameid)

	--断线重连
    if config.matchroom then
		for i = 1,#config.matchroom do
			for k,v in pairs(msg.matches) do
				if v.matchid == config.matchroom[i].matchid then
					if v.online then
						MatchMessage.EnterMatchReq(v.matchid,true)
						return
					end
				end
			end
		end
	end

	if not self.matchListLayer then
		return
	end
	
	local function createList(time)
		_matchListInfo = msg.matches
		
		--星期
		local week = os.date("%w",time)
		print("week:",week)
		-- 如果不是周六 删除周赛的信息
		if tonumber(week) ~= 6 then
			for i=1,#_matchListInfo do
				if _matchListInfo[i].matchid == 20602 then
					table.remove(_matchListInfo, i)
					break
				end
			end
	
			for i=1,#config.matchroom do
				if config.matchroom[i].matchid == 20602 then
					table.remove(config.matchroom, i)
					break
				end
			end
		else
			-- 如果是周六 删除非周赛的信息
			local count = 1
			local let = #_matchListInfo
			for i=1,let do
				if _matchListInfo[count] then
					if _matchListInfo[count].matchid ~= 20602 then
						table.remove(_matchListInfo, count)
					else
						count = count + 1
					end
				end
			end

			count = 1
			let = #config.matchroom
			for i=1,let do
				if config.matchroom[count] then
					if config.matchroom[count].matchid ~= 20602 then
						table.remove(config.matchroom, count)
					else
						count = count + 1
					end
				end
			end
		end
	
		local list_sss_match = cc.uiloader:seekNodeByNameFast(self.matchListLayer, "list_sss_match")
		
		--名字太长，换行显示
		local function matchNameFormat(name)
			return util.stringFormat(name,32)
		end
		
		self.scene.matchItem = {}
		for i=1,#config.matchroom do
			local ui_content = cc.uiloader:load("Node/Match_Item_Template.json")
			local mroom = config.matchroom[i]					--比赛配置
			ui_content.matchId = mroom.matchid
			self.scene.matchItem[i] = ui_content
			
			--比赛图标
			local frameName = mroom.icon
			local icon = cc.uiloader:seekNodeByNameFast(ui_content, "img_icon")
			-- icon:setSpriteFrame(cc.SpriteFrame:create("Image/Match/" .. frameName, cc.rect(0,0,111, 111)))
			if mroom.matchid == 20602 then  --周赛
				icon:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_cai_dian.png", cc.rect(0,0,122, 87)))
			else							--日赛
				icon:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_jin_chao.png", cc.rect(0,0,130, 66)))
			end
	
			--时间
			local hour = string.format("%02d",mroom.startHour)
			local minute = string.format("%02d",mroom.startMinute)
			local strtime = hour .. ":" .. minute
			cc.uiloader:seekNodeByNameFast(ui_content, "tx_match_start_time")
				:setString(strtime)
	
			--比赛房名字
			local name = mroom.name
			local len = string.len(name)
			name = matchNameFormat(name)
			cc.uiloader:seekNodeByNameFast(ui_content, "tx_match_room_name")
				:setString(name)
	
			--开赛时间(天)  根据matchId 判断
			if mroom.matchid == 20602 then  --周赛
				cc.uiloader:seekNodeByNameFast(ui_content, "tx_match_time")
					:setString("每周六开赛")
			else							--日赛
				cc.uiloader:seekNodeByNameFast(ui_content, "tx_match_time")
					:setString("周日至周五")
			end
	
			--开赛条件
			cc.uiloader:seekNodeByNameFast(ui_content, "tx_match_claim")
				:setString("满" .. mroom.minMatchPlayer .. "人开赛")
	
			--比赛倒计时
			ui_content.labelLeftTime = cc.uiloader:seekNodeByNameFast(ui_content, "ta_left_time")
			local startTime = {}
			startTime.startHour = mroom.startHour
			startTime.startMinute = mroom.startMinute
			ui_content.startTime = startTime		--比赛开始时间
	
			--比赛状态
			local state = 1
			for k,v in pairs(msg.matches) do
				if v.matchid == mroom.matchid then
					state = v.status				--比赛状态
					ui_content.state = state		--比赛状态
					local isSignup = v.signup		--是否报名过
					local count = v.count			--报名人数
	
					print("count:",count)
					print("state:",state)
					--报名人数
					if count then
						cc.uiloader:seekNodeByNameFast(ui_content, "tx_sign_num")
							:setString(tostring(count))
					end
	
					local function onSignCallBack()
						self:showCompetitionLayer(count, state, startTime, mroom)
						-- MatchMessage.MatchSignupReq(1,v.matchid)
					end
	
					--报名比赛按钮
					local btn_sign_up = cc.uiloader:seekNodeByNameFast(ui_content, "btn_sign_up")
						:hide()
						:onButtonClicked(onSignCallBack)
	
					--参赛金额
					local fee = mroom.fee
					if fee then
						cc.uiloader:seekNodeByNameFast(btn_sign_up, "tx_const_value")
							-- :setString(fee.val .. "钻石")
							:setString("(免费)")
					end
					
					--已报名按钮
					cc.uiloader:seekNodeByNameFast(ui_content, "btn_sign_finish")
						:hide()
						:onButtonClicked(onSignCallBack)
								
					--比赛进行中按钮
					cc.uiloader:seekNodeByNameFast(ui_content, "btn_playing")
					:onButtonClicked(function ()
						print("playing")
						end)
					:hide()
							
					--比赛排名按钮
					cc.uiloader:seekNodeByNameFast(ui_content, "btn_rank")
					:hide()
					:onButtonClicked(function ()
						self:showMatchRankList(v.matchid)
					end)
	
					--已取消按钮
					cc.uiloader:seekNodeByNameFast(ui_content, "btn_cancel")
						:hide()
						:onButtonClicked(function ()
							print("end")
						end)
	
					--刷新按钮状态
					self:updateMatchState(v.matchid,state,isSignup)
				end				
			end
	
			local item = list_sss_match:newItem()
			item:addContent(ui_content)
			item:setItemSize(1080,133)
			list_sss_match:addItem(item)
		end
		
		list_sss_match:reload()

		return list_sss_match
	end
	

	--获取服务器时间开始倒计时刷新比赛时间
	web.getServerTime(function (time)
		_leftTime = time

		local list_sss_match = createList(time)

		self:updateLeftTime()
		list_sss_match:schedule(function()
			_leftTime = _leftTime + 1
			self:updateLeftTime()
		end, 1.0)
	end)
end

--[[ --
	* 刷新比赛倒计时时间
--]]
function LobbyScene:updateLeftTime()
    local servertime = os.date("*t", _leftTime)

   	for i = 1,#self.scene.matchItem do
    	local item = self.scene.matchItem[i]
    	if item ~= nil then
          	--print("updateMatchTime11111--")
          	local s = os.time({year=servertime.year, month=servertime.month, day=servertime.day,hour = item.startTime.startHour,min = item.startTime.startMinute,sec = 0})
          	local diff = os.difftime(s,_leftTime)
            --print("diff:" .. diff)
			item.labelLeftTime:setVisible(true)
			
            if item.state ~= 4 and item.state ~= 16 then
                --print("updateMatchTime2222--")
                if diff <= 0 then
                    item.labelLeftTime:setString("00:00:00")
               	else
                    local left = string.format("%02d:%02d:%02d", math.floor(diff/(60*60)), math.floor((diff/60)%60), diff%60)
                    item.labelLeftTime:setString(left)
                end
            else
				item.labelLeftTime:setString("00:00:00")
				local btn_signup = cc.uiloader:seekNodeByNameFast(item, "btn_sign_up")
					:show()
				btn_signup:setButtonEnabled(false)
            end
        end
    end
end

--[[ --
	* 刷新比赛按钮状态
	@param int		matchId			比赛ID
	@param int		state			比赛状态
	@param bool		signup			是否报名过
--]]
function LobbyScene:updateMatchState(matchId,state,signup)
	print("matchId:" .. matchId ..",state:" .. tostring(state))
	local item
	for k,v in pairs(self.scene.matchItem) do
		if v.matchId == matchId then
			item = v
			break
		end
	end

	--1未开始 2比赛开始 4人数不够，比赛取消 8比赛进行中 16比赛结束
	local btn_sign_up = cc.uiloader:seekNodeByNameFast(item, "btn_sign_up")					--报名
	local btn_sign_finish = cc.uiloader:seekNodeByNameFast(item, "btn_sign_finish")			--已报名
	local btn_playing = cc.uiloader:seekNodeByNameFast(item, "btn_playing")					--进行中
	local btn_rank = cc.uiloader:seekNodeByNameFast(item, "btn_rank")						--排名
	local btn_cancel = cc.uiloader:seekNodeByNameFast(item, "btn_cancel")					--已取消
	local btn_ended = cc.uiloader:seekNodeByNameFast(item, "btn_ended"):hide()				--已结束

    if state == 1 then
		if signup then
			btn_sign_finish:show()
			btn_sign_up:hide()
		else
			btn_sign_up:show()
			btn_sign_finish:hide()
		end
    elseif state == 2 or state == 8 then
        btn_playing:show()
    elseif state == 16 then
		btn_ended:show()
		btn_rank:show()
		btn_sign_up:hide()
    elseif state == 4 then
		btn_cancel:show()
	end
	
	if self.MatchCompetitionLayer then
		local btn_sign = cc.uiloader:seekNodeByNameFast(self.MatchCompetitionLayer, "btn_sign")
		local btn_enter = cc.uiloader:seekNodeByNameFast(self.MatchCompetitionLayer, "btn_enter")
		local btn_exit = cc.uiloader:seekNodeByNameFast(self.MatchCompetitionLayer, "btn_exit")

		if state == 1 then
			if signup then
				btn_enter:show()
				btn_exit:show()
				btn_sign:hide()
			else
				btn_enter:hide()
				btn_exit:hide()
				btn_sign:show()
			end
		end
	end
end


--[[ --
	* 显示参赛界面
	@param int    	count		报名人数
	@param int		state		比赛状态
	@param table	startTime	比赛开始时间
	@param table	mroom		比赛房配置信息
--]]
function LobbyScene:showCompetitionLayer(count, state, startTime, mroom)
	--奖品太长，换行显示
	local function prizeFormat(name)
		return util.stringFormat(name,39)
	end

	local MatchCompetitionLayer = cc.uiloader:load("Layer/Lobby/match/MatchCompetitionLayer.json"):addTo(self.scene)
	local nd_all = cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "nd_all")
	util.setMenuAniEx(nd_all)

	local nd_info = cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "nd_info")
	local nd_rule = cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "nd_rule"):hide()
	MatchCompetitionLayer.state = state
	MatchCompetitionLayer.startTime = startTime

	self.MatchCompetitionLayer = MatchCompetitionLayer

	--按钮状态
	local signup = _isSignWithMatchid(mroom.matchid)
	if signup then
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_sign"):hide()
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_enter"):show()
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_exit"):show()
	else
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_sign"):show()
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_enter"):hide()
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_exit"):hide()
	end

	--标题
	if mroom.matchid == 20602 then  --周赛
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "Image_Title")
			:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_zhou_sai.png", cc.rect(0, 0, 143, 38)))

		cc.uiloader:seekNodeByNameFast(nd_info, "img_prize_1")
			:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_cai_dian_2.png", cc.rect(0, 0, 130, 108)))

		cc.uiloader:seekNodeByNameFast(nd_info, "img_prize_2")
			:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_50_hua_fen.png", cc.rect(0, 0, 86, 86)))

		cc.uiloader:seekNodeByNameFast(nd_info, "img_prize_3")
			:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_50_hua_fen.png", cc.rect(0, 0, 86, 86)))
	else							--日赛
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "Image_Title")
			:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_sss_ri_sai.png", cc.rect(0, 0, 143, 38)))
	end

	--倒计时
	MatchCompetitionLayer.labelLeftTime = cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "ta_left_time")
	self.scene.matchItem[#self.scene.matchItem+1] = MatchCompetitionLayer
	self:updateLeftTime()

	--开赛条件
	cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "tx_match_claim")
		:setString("满" .. mroom.minMatchPlayer .. "人开赛")

	--报名人数 and 报名人数上限
	if count then
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "tx_sign_num")
			:setString(tostring(count))
	end

	cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "tx_max_sign")
		:setString(mroom.maxMatchPlayer .. "上限")

	--参赛金额
	local fee = mroom.fee
	if fee then
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "tx_const_value")
			-- :setString(fee.val .. "钻石")
			:setString("免费")
	end

	--比赛奖品
	local rewards = mroom.rewards
	for i = 1,3 do
		local rstart = rewards[i].startRank
		local rend = rewards[i].endRank

		local rank
		if rstart == rend then
			rank = "第"..rstart .. "名:"
		else
			rank = "第"..rstart .. "~" .. rend .. "名:"
		end

		local str = rank .. rewards[i].name
		-- str = prizeFormat(str)
		cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, string.format("tx_prize_info_%d",i))
			:setString(str)
	end

	--单局最高分奖品
	cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "tx_prize_info_4")
		:setString("单局最高分奖品：" .. mroom.topReward.name)

	--关闭按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_close"))
		:onButtonClicked(function ()
			if nd_rule:isVisible() then
				nd_rule:hide()
				nd_info:show()
				return
			end

			self.scene.matchItem[#self.scene.matchItem] = nil
			MatchCompetitionLayer:removeSelf()
			self.MatchCompetitionLayer = nil
		end)

	--详细规则按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_rule"))
		:onButtonClicked(function ()
			nd_rule:show()
			nd_info:hide()
		end)

	--马上报名按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_sign"))
		:onButtonClicked(function ()
			MatchMessage.MatchSignupReq(1,mroom.matchid)
		end)

	--进入按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_enter"))
		:onButtonClicked(function ()
			MatchMessage.EnterMatchReq(mroom.matchid,false)
		end)

	--退赛按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(MatchCompetitionLayer, "btn_exit"))
		:onButtonClicked(function ()
			MatchMessage.MatchSignupReq(2,mroom.matchid)
		end)
end

--[[ --
	* 报名比赛
	@param table		msg			报名数据
	@param table		oldMsg		发送请求的数据
--]]
function LobbyScene:MatchSignupRep(msg,oldMsg)
    print("MatchSignupRep:" .. msg.result)
	--dump(msg)
	
    if msg.result == 0 then
        if oldMsg.optype == 1 then 		 	--报名成功
			self:updateMatchState(oldMsg.matchid,1,true)
			_setSignWithMatchid(oldMsg.matchid, true)
        elseif oldMsg.optype == 2 then  	--取消成功
			self:updateMatchState(oldMsg.matchid,1,false)
			_setSignWithMatchid(oldMsg.matchid, false)
        end
    else
        local string = "报名失败！"
        if msg.result == 4 then
          	string = "报名失败，已经报名过"
        elseif msg.result == 6 then
            string = "报名失败，名额已满"
        elseif msg.result == 7 then
            string = "报名失败，同ip报名限制"
        elseif msg.result == 8 then
            string = "报名失败，报名费用不足"
        end
        ErrorLayer.new(string):addTo(self.scene)
	end
end

--[[ --
	* 显示比赛排名
	@param int		matchid			比赛ID
--]]
function LobbyScene:showMatchRankList(matchid)
	print("showMatchRankList---")
    --比赛排名界面
	local matchRankListLayer = cc.uiloader:load("Layer/Lobby/match/MatchRankLayer.json"):addTo(self.scene)
	self.matchRankListLayer = matchRankListLayer
	local nd_all = cc.uiloader:seekNodeByNameFast(matchRankListLayer, "nd_all")
	util.setMenuAniEx(nd_all)

	--关闭按钮
	cc.uiloader:seekNodeByNameFast(matchRankListLayer, "img_bg")
		:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			if event.name == "began" then
				sound_common.cancel()
				matchRankListLayer:removeFromParent()
				self.matchRankListLayer = nil
			end
		end)

	--发送比赛排名数据请求
	MatchMessage.MatchRankReq(matchid)
end

--[[ --
	* 比赛排名
	@param table		msg			排名数据
	@param table		oldMsg		发送请求的数据
--]]
function LobbyScene:MatchRankRep(msg,oldMsg)
	local list_rank = cc.uiloader:seekNodeByNameFast(self.matchRankListLayer, "list_rank")

	-- msg = {}
	-- msg.result = 0
	-- msg.topscorers = {}
	-- msg.players = {
	-- 	{
	-- 		nickname = "a",
	-- 		rank = 1,
	-- 		reward = "sdag"
	-- 	}
	-- }

	local function createContentItem(player, isJu)
		local ui_content = cc.uiloader:load("Node/Match_Item_Rank_Template.json")
		
		if isJu then
			--底图
			cc.uiloader:seekNodeByNameFast(ui_content, "img_rank_bg")
			:setSpriteFrame(cc.SpriteFrame:create("Image/Match/img_ju_item_bg.png", cc.rect(0,0,920,107)))

			--最高分
			local tx_rank = cc.uiloader:seekNodeByNameFast(ui_content, "tx_rank")
			display.newSprite("Image/Match/img_ju_icon.png", tx_rank:getPositionX(), 0)
				:addTo(ui_content)
			tx_rank:hide()
			tx_rank:setString("单局最高分")
		else
			--排名
			local tx_rank = cc.uiloader:seekNodeByNameFast(ui_content, "tx_rank")
			if player.rank <= 3 then
				display.newSprite("Image/Match/r_" .. player.rank .. ".png", tx_rank:getPositionX(), 0)
					:addTo(ui_content)
				tx_rank:hide()
			else
				tx_rank:setString(tostring(player.rank))
			end
		end

		--头像
		local image = AvatarConfig:getAvatar(player.sex, 0, 0)
		local rect = cc.rect(0, 0, 188, 188)
		local frame = cc.SpriteFrame:create(image, rect)

		--微信头像设置
		local img_head = cc.uiloader:seekNodeByNameFast(ui_content, "img_head")
		--参数 父节点 微信头像url 显示头像节点  默认头像路径
		util.setHeadImage(ui_content, player.imageid, img_head, image)

		--名字
		cc.uiloader:seekNodeByNameFast(ui_content, "tx_name")
			:setString(tostring(crypt.base64decode(util.checkNickName(player.nickname))))

		--奖品
		cc.uiloader:seekNodeByNameFast(ui_content, "tx_prize")
			:setString(player.reward)

		local item = list_rank:newItem()
		item:addContent(ui_content)
		item:setItemSize(921,110)
		list_rank:addItem(item)
	end

	if msg.result == 0 then         --成功
		for i = 1,#msg.topscorers do
			local player = msg.topscorers[i]
			createContentItem(player, true)
		end

		for i = 1,#msg.players do
			--排名玩家数据
			local player
			for k,v in pairs(msg.players) do
				if v.rank == i then
					player = v
					break
				end
			end
			createContentItem(player)
		end
		
		list_rank:reload()
    end
end

return LobbyScene