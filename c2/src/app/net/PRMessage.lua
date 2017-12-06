local PRMessage = {}

local Message = import(".Message")
local crypt = require("crypt")
local PrivateRoomConfig = require("app.config.PrivateRoomConfig")
local util = require("app.Common.util")
local errorLayer = require("app.layers.ErrorLayer")
local ProgressLayer = require("app.layers.ProgressLayer")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local sound_common = require("app.Common.sound_common")
local roomMgr = require("app.room.manager")
local msgMgr = require("app.room.msgMgr")
local errors = require("app.Common.errors")
local PlatConfig = require("app.config.PlatformConfig")

local _room_session = nil		--通信验证
local _privateid = nil			--私人房房号
local _roomid = nil				--房间ID
local _gameid = nil 			--游戏ID
local _clientid = nil			--客户端ID
local _seats = nil				--椅子数
local _seat = nil				--椅子号
local _state = nil 				--0: 游戏未开始； 1: 游戏已开始
local _mode = nil				--1: 房主付费; 2: 均摊
local _round = nil 				--局数
local _base = nil 				--低分
local _count = nil 				--初始分数
local _rule = nil 				--规则位图

local _progressLayer = nil		--提示信息

local gameMsg = {}	-- from server
local roomMsg = {}	-- from client table

local handlers = {private=gameMsg,room=roomMsg}

--[[ --
    * 获取配置请求
--]]
function PRMessage.PrivateRoomConfigReq()
	print("获取配置请求")
	PRMessage.oldMessage = {}

	Message.sendMessage("private.PrivateConfigReq", PRMessage.oldMessage)
end

--[[ --
    * 获取配置回复
--]]
function gameMsg.PrivateConfigRep(msg)
	print("获取配置回复","配置信息 = " .. msg.config)

	local newConfig = assert(loadstring(msg.config))()
    local newConfig = checktable(newConfig)
	dump(newConfig,"newConfig")
    for k,v in pairs(newConfig) do
    	PrivateRoomConfig[k] = v
    end
end

--[[ --
    * 创建房间请求
--]]
function PRMessage.PrivateRoomCreateReq(roomid,mode,round,seats,base,count,rule,hostplay)
	print("创建房间请求")
	if _progressLayer == nil then
		_progressLayer = ProgressLayer.new(app.lang.create_private_room, app.constant.network_loading):addTo(display.getRunningScene(),100)
	end

	hostplay = hostplay or false

	PRMessage.oldMessage = {
		roomid = roomid,			--房间ID
		customization = {
			mode = mode;			-- 1: 房主付费; 2: 均摊
			round = round;			-- 局数
			seats = seats;			-- 游戏人数
			base = base;			-- 底分
			count = count;			-- 初始分数
			rule = rule;			-- 规则位图
			hostplay = hostplay;	-- 是否可以代开房
		}
	}
	dump(PRMessage.oldMessage,"开房请求")
	Message.sendMessage("private.CreatePrivateReq", PRMessage.oldMessage)
end

--[[ --
    * 创建房间回复
--]]
function gameMsg.CreatePrivateRep(msg)
	print("创建房间回复","privateid = " .. msg.privateid,"result = " .. msg.result)

	if msg.result == 0 then
		PRMessage.EnterPrivateRoomReq(msg.privateid)
	else
		if _progressLayer then
			_progressLayer:removeSelf()
			_progressLayer = nil
		end
		local error_info = errors.str(msg.result)

		if error_info == "lack_gold" then  								--钻石不足
			error_info = app.lang.roomid_create_failed_gold
		else 															--失败
			error_info = app.lang.roomid_create_failed
		end

		print("创建房间失败:" .. error_info)
		local scene = display.getRunningScene()
		errorLayer.new(error_info):addTo(scene)
	end
end

--[[ --
    * 进入房间请求
--]]
function PRMessage.EnterPrivateRoomReq(privateid, load)

	if load == 1 and _progressLayer == nil then
		_progressLayer = ProgressLayer.new(app.lang.enter_private_room, app.constant.network_loading):addTo(display.getRunningScene(),100)
	end

	print("进入房间请求")
	_privateid = privateid or 0

	app.constant.privateCode = privateid or 0
	PRMessage.oldMessage = {clientid = 0 ,privateid = _privateid}
	Message.sendMessage("private.EnterPrivateReq", PRMessage.oldMessage)
end

--[[ --
    * 进入房间回复
--]]
function gameMsg.EnterPrivateRep(msg)
	print("进入房间回复","result = " .. msg.result)

	if _progressLayer then
		_progressLayer:removeSelf()
		_progressLayer = nil
	end

	if msg.result == 0 then   						--进入房间成功 请求坐下

		_room_session = msg.session					--通信验证
		_privateid = msg.info.privateid				--私人房房号
		_roomid = msg.info.roomid					--房间ID
		_gameid = msg.info.gameid					--游戏ID
		_clientid = msg.clientid					--客户端ID
		_seats = msg.info.customization.seats		--椅子数
		_state = msg.info.state 					--0: 房卡游戏未开始； 1: 房卡游戏已开始
		_mode = msg.info.customization.mode			--1: 房主付费; 2: 均摊
		_round = msg.info.customization.round 		--局数
		_base = msg.info.customization.base 		--低分
		_count = msg.info.customization.count 		--初始分数
		_rule = msg.info.customization.rule 		--规则位图

		app.constant.curRoomRound = _round

		--准备工作
		roomMgr:prepare(_gameid, _roomid)
		--设置房间信息
		msgMgr:setPrivateRoomInfo(msg)

		--设置游戏场景Name
		local config = require("app.config.RoomConfig")
		for i = 1, #config do
			if config[i].gameid == _gameid then
				msgMgr:setGameName(config[i].scene)
			end
		end

	else 						   	--进入房间失败
		local error_info = errors.str(msg.result)

		--当前游戏场景
		local scene = display.getRunningScene()

		if error_info == "enter_failed" then  				--无明确原因
			error_info = app.lang.enter_room_failed
		elseif error_info == "wrong_privateid" then			--密码输入错误没有对应的房间
			error_info = app.lang.enter_room_failed_password
		elseif error_info == "no_stay_room" then			--玩家没有在任何房间，无需重连
			--显示创建房间界面
			if scene.showPrivateRoom then
				scene:showPrivateRoom()
			end

			--房间解散之后重连 返回大厅
			if scene.name ~= "LobbyScene" and scene.name ~= "LoginScene" then
				roomMsg.ExitTable({textInfo = app.lang.room_dissolution_return})
			end

			return
		else
			error_info = app.lang.enter_room_failed
		end

		--清理密码
		if scene.clearLoginPassword then
			scene:clearLoginPassword()
		end

		if scene.exitScene then
			scene:exitScene()
			return
		end

		print("进入房间失败:" .. error_info)
		errorLayer.new(error_info):addTo(scene)
	end
end

--桌子开始
function gameMsg.PrivateStart(msg)
	print("桌子开始")
	Message.dispatchCurrent("room.PrivateStart", {})
end

--离开桌子
function gameMsg.PrivateRoomLeaveRep(msg)
	print("离开桌子")
	if msg.tableid == tableid then
    	Message.dispatchCurrent("room.PrivateRoomSitup", {seat = msg.seat})
	end
end

--[[ --
    * 战绩信息请求
--]]
function PRMessage.PrivateGameRecordProfileReq(tableindex)
	tableindex = tableindex or 0

	print("战绩信息请求")

	local scene = display.getRunningScene()
	if scene.name == "LobbyScene" then
		_progressLayer = ProgressLayer.new(app.lang.load_data, app.constant.network_loading):addTo(scene,100)
	end

	Message.sendMessage("private.PrivateGameRecordProfileReq",{
		tableindex = tableindex
	})
end

--[[ --
    * 战绩信息回复
--]]
function gameMsg.PrivateGameRecordProfileRep(msg)
	print("战绩信息回复")

	local scene = display.getRunningScene()
	if scene.name == "LobbyScene" then
		scene:createProfileGameRecord(msg.profileinfos,_progressLayer)
		_progressLayer = nil
	end
end

--[[ --
    * 详细战绩信息请求
--]]
function PRMessage.PrivateGameRecordDetailReq(gameid,tableindex)
	print("详细战绩信息请求", "gameid = " .. gameid, "tableindex = " .. tableindex)

	local scene = display.getRunningScene()
	if scene.name == "LobbyScene" then
		_progressLayer = ProgressLayer.new(app.lang.load_data, app.constant.network_loading):addTo(scene,100)
	end

	Message.sendMessage("private.PrivateGameRecordDetailReq",{
		gameid = gameid,
		tableindex = tableindex
	})
end

--[[ --
    * 详细战绩信息回复
--]]
function gameMsg.PrivateGameRecordDetailRep(msg)
	print("详细战绩信息回复", "msg.gameid = " .. msg.gameid, "msg.tableindex = " .. msg.tableindex)

	local scene = display.getRunningScene()
	if scene.name == "LobbyScene" then
		scene:createSpecificGameRecord(msg.tableindex, msg.gameid, msg.rounds, _progressLayer)
		_progressLayer = nil
	end
end


------------------------------------本地消息-----------------------------------
--解散房间
function roomMsg.DismissGameReq(msg)
	print("解散房间请求")
	local scene = display.getRunningScene()
	if scene.name ~= "RoomScene" and scene.name ~= "LobbyScene" and scene.name ~= "LoginScene" then
		--创建界面

		local layer = nil
		if scene.name == "ShYMJScene" then
			layer = cc.uiloader:load("Layer/Lobby/privateScaRoomLayer_0.json")
		else
			layer = cc.uiloader:load("Layer/Lobby/privateScaRoomLayer.json")
		end

		layer:addTo(scene,108)
		layer:setName("privateScaRoomLayer")

		--文字内容
		local name = crypt.base64decode(msg.nickname)
		name = util.checkNickName(name)
		cc.uiloader:seekNodeByNameFast(layer, "Content"):setString("玩家[" .. name .. "]发起解散房间！")

		--弹出界面动画
		local node = cc.uiloader:seekNodeByNameFast(layer, "Node")
		node:setScale(0)
        transition.scaleTo(node, {
            scale = 1,
            easing = "backOut",
            time = app.constant.lobby_popbox_trasition_time,
        })

		--发送解散房间意见
		local function sendDissolutionOpinionCallback(Opinion)
			sound_common.menu()
			Message.sendMessage("game.DismissGameRep", {
					session = _room_session,
					privateid = _privateid,
					seat = _seat,
					result = Opinion   -- 0: 同意, 1:拒绝
				})
			layer:removeFromParent()
		end

		--同意解散房间按钮
		cc.uiloader:seekNodeByNameFast(layer, "btn_agree")
			:onButtonClicked(function()  sendDissolutionOpinionCallback(0)  end)

		--拒绝解散房间按钮
		cc.uiloader:seekNodeByNameFast(layer, "btn_refuse")
			:onButtonClicked(function()  sendDissolutionOpinionCallback(1)  end)
	end
end

--解散房间失败回复(有玩家拒绝)
function roomMsg.DismissGameRep(msg)
	print("roomMsg.DismissGameRep---")
	local scene = display.getRunningScene()
	if scene.name ~= "RoomScene" and scene.name ~= "LobbyScene" and scene.name ~= "LoginScene" then
		local layer = scene:getChildByName("privateScaRoomLayer")
		if layer then
			layer:removeFromParent()
		end

		if msg.info == "player_req_dismiss" then				--已有玩家发起解散请求
			errorLayer.new(app.lang.room_dissolution_text):addTo(scene,10)
		elseif msg.info == "no_right_dismiss" then				--无权发起解散请求
			errorLayer.new(app.lang.room_right_dissolution):addTo(scene,10)
		elseif msg.info == "success_req_dismiss" then
			errorLayer.new(app.lang.success_req_dissolution):addTo(scene,10)
		else	--某某玩家拒绝解散房间
			local sprite9 = display.newScale9Sprite("Image/Public/Tips_Body_Round.png")
				:pos(scene:getContentSize().width/2,scene:getContentSize().height/2+35)
				:addTo(scene,1111)

			local name = crypt.base64decode(msg.nickname)
			name = util.checkNickName(name)

			local text = display.newTTFLabel({text="玩家【" .. name .. "】拒绝解散房间",size=28})
				:pos(sprite9:getContentSize().width/2,sprite9:getContentSize().height/2)
				:addTo(sprite9)

			local size = cc.size(text:getContentSize().width + 30,text:getContentSize().height+20)
			sprite9:size(size)
			text:pos(sprite9:getContentSize().width/2,sprite9:getContentSize().height/2)
			sprite9:runAction(cca.seq({cca.delay(1.2),cca.fadeOut(0.8),cca.removeSelf()}))
		end
	end
end

--长时间无人操作，房间解散
function roomMsg.TimeDismissGame(msg)
	print("长时间无人操作，房间解散")

	local scene = display.getRunningScene()
	if scene.name ~= "RoomScene" and scene.name ~= "LobbyScene" and scene.name ~= "LoginScene" then
		local layer = scene:getChildByName("privateScaRoomLayer")
		if layer then
			layer:removeFromParent()
		end

		-- ProgressLayer.new(app.lang.room_dissolution_time, 4.5):addTo(scene, 10)

		local sprite9 = display.newScale9Sprite("Image/Public/Tips_Body_Round.png")
			:pos(scene:getContentSize().width/2,scene:getContentSize().height/2+35)
			:addTo(scene,10)

		local text = display.newTTFLabel({text="长时间无人操作，房间已解散，等待总战绩数据!",size=28})
			:pos(sprite9:getContentSize().width/2,sprite9:getContentSize().height/2)
			:addTo(sprite9)

		local size = cc.size(text:getContentSize().width + 30,text:getContentSize().height+20)
		sprite9:size(size)
		text:pos(sprite9:getContentSize().width/2,sprite9:getContentSize().height/2)
		sprite9:runAction(cca.seq({cca.delay(3),cca.fadeOut(1.5),cca.removeSelf()}))
	end
end

function roomMsg.LeaveGame()
	print("发送离开房间请求")
    Message.sendMessage("game.LeaveRoomReq", {session = _room_session})
    roomMsg.ExitTable()
end

function roomMsg.ExitTable(msg)
	if watching == false then
		util.CloseChannel()
		app.constant.enterGameUInfo = {}
	end

    local sceneClass = require("app.scenes.LobbyScene")
    local scene = sceneClass.new()
	display.replaceScene(scene, "fade", 0.5, nil)

	if msg and msg.textInfo then
		errorLayer.new(msg.textInfo,nil,1.5,nil,1):addTo(scene,10)
	end
end

function roomMsg.setSeat(msg)
	_seat = msg.seatid
end

function PRMessage.dispatch(name, msg)
	local clsName, funcName = name:match "([^.]*).(.*)"
	-- assert(handlers[clsName], clsName .. " handler not exist!")
	if handlers[clsName] then
		-- assert(handlers[clsName][funcName], clsName.." Mgr have no func: "..funcName)
		if handlers[clsName][funcName] then
			handlers[clsName][funcName](msg)
		end
	end
	return true
end

Message.registerHandle("private", PRMessage.dispatch)


return PRMessage