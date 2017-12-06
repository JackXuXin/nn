local scheduler = require("framework.scheduler")

local RoomConfig = require("app.config.RoomConfig")
local util = require("app.Common.util")
local message = require("app.net.Message")
local errorLayer = require("app.layers.ErrorLayer")
local crypt = require("crypt")
local userdata = require("app.UserData")
local errors = require("app.Common.errors")

-- require("app.room.utils")
local _Player = app.userdata.Player

local roomScene = nil

local msgMgr = {} -- main manager
local msgQueue = {}

-- message handlers
local gameMsg = {}	-- from server
local userMsg = {}	-- from server
local roomMsg = {}	-- from client table

local handlers = {game=gameMsg, user=userMsg, room=roomMsg}

local table_id = 0
local seat_id = 0
local watching = false

local player_info = {}
local table_states = {}

local TABLE_STATE = {
	WAIT = 0x00,
	GAME = 0x01, -- game started
	LOCK = 0x02, -- table locked by password
}
msgMgr.TABLE_STATE = TABLE_STATE

local gameid = nil
local roomid = nil
local matchid = nil
local gamekey = ""
local table_code = nil

local sit_table = false
local room_session = 0
local table_session = 0
local game_scene = nil
local max_player = nil
local max_seats = nil

local online = false
local MatchStatusMsg = nil

local handler

--私人房 添加
local game_state = nil			--0: 房卡游戏未开始； 1: 房卡游戏已开始
local game_mode = nil			--1: 房主付费; 2: 均摊
local game_round = nil	 		--局数
local game_base = nil  			--低分
local game_count = nil			--初始分数
local game_rule = nil 			--规则位图

---------------------------------match--------------------------------------

function msgMgr:MatchEnterRoomRep(msg)
	print("MatchEnterRoomRep enter room result:" .. msg.result)
	local sCount = 0
	print("mmmm:" .. msg.matchid .. "," .. msg.table)
	if msg.result == 0 then
		room_session = msg.session
		matchid = msg.matchid

		for _,config in ipairs(RoomConfig) do
	    	if config.matchroom then
	    		for _,v in pairs(config.matchroom) do
	    			if v.matchid == matchid then
	    				max_player = v.seats
	    				break
	    			end
		    	end
			end
		end
		
		print("max_player:",max_player)

	    app:enterScene(game_scene, nil, "fade", 0.5)
		message.dispatchCurrent("room.InitMatch",{matchid = matchid,session = msg.session,max_player = max_player,online = online,table = msg.table})
		if MatchStatusMsg then
			message.dispatchCurrent("room.MatchStatustNtf",MatchStatusMsg)
		end

	else
		local scene = display.getRunningScene()
		errorLayer.new(app.lang.enter_room_failed):addTo(scene)
	end
end

function msgMgr:setOnline(_online)
	online = _online
end

function msgMgr:MatchStatus(msg)
	-- body
	if msg.status == 1 then
		MatchStatusMsg = msg
	end
end

function msgMgr:resetMatch()
	-- body
	MatchStatusMsg = nil
	matchid = nil
	online = false
end

---------------------------------match end----------------------------------

-- ------------------------------ UserMessage ------------------------------
function msgMgr:EnterRoomResonpse(msg)
	print("enter room result:" .. msg.result)
	if msg.result == 0 then
		for tableid, t in pairs(player_info) do
			for seatid, p in pairs(t) do
				if p.uid == _Player.uid then
					-- reconnect to the old place
					printf("reconnect to table:%d seat:%d", tableid, seatid)
					message.sendMessage("game.SitdownReq", {
						session = room_session, 
						table = tableid, 
						seat = seatid,
						-- rule = _Player.roomRule, -- reconnect is unnecessary
					})
					return
				end
			end
		end
		print("RoomScene gameid:" .. gameid .. " roomid:" .. roomid)
		--进入房间清理语音资源
		--util.CloseChannel()
		--end

		--app.constant.enterGameUInfo = {}

    	app:enterScene("RoomScene", {gameid, roomid}, "fade", 0.5)
	else
		local scene = display.getRunningScene()
		if msg.result == 6 then
			local roomid = msg.roomid
			local err_str = string.format(app.lang.other_room_playing, RoomConfig:getFullName(roomid))
			errorLayer.new(err_str):addTo(scene)
		else
			errorLayer.new(app.lang.enter_room_failed):addTo(scene)
		end
	end
end

-- ------------------------------ game msg ------------------------------
function gameMsg.RoomSession(msg)
	print("get room session..............................................................:", msg.session)
    room_session = msg.session
end

function gameMsg.SetSession(msg)
	print("get table session.............................................................:", msg.session)
    table_session = msg.session
end

function gameMsg.SitdownRep(msg)
	print("坐下回复")
	print("sit down result:" .. msg.result .. " table session:" .. table_session .. " tableid:" .. msg.table)
    if msg.result == 0 then
		table_session = msg.session
        table_id = msg.table
        seat_id = msg.seat
        watching = (msg.watching == 1)
        g_watching = watching

        if game_scene ~= nil then
        	print("loading game scene:", game_scene)

             print("matchid = ",matchid)
            if matchid == nil then	--如果不是比赛房
            	print("watching:", watching)
	    		--如果不是旁观玩家，初始化频道聊天接口
            	if watching == false then

            		local password = ""

            		local curTableRule = userdata.Room.tableRule
            		if curTableRule ~= nil then

            			password = curTableRule.pwd
            		end

            		local players = msgMgr:get_seat_players(table_id)

            		if gameid ~= nil then
						print(
							"游戏ID = " .. gameid,
							"房间ID = " .. roomid,
							"桌子ID = " .. table_id,
							"椅子ID = " .. seat_id,
							"房间session = " .. room_session,
							"人数 = " .. max_seats
						)

						if table_code then

							local strChannel = CONFIG_APP_CHANNEL .. table_id .. gameid .. table_code
							print("strChannel = ",strChannel)
					        util.UserInfo = { gameid = gameid, roomid = roomid, table_id = table_id, seat_id = seat_id, watching = watching, room_session = room_session, password = table_code, players = #players}
					        util.OpenChannel(strChannel)

						end 

            		end

            	end

            	if game_scene == "ShYMJScene" or game_scene == "DDZScene" then

					app.constant.isReconnectGame = true
					local scene = display.getRunningScene().name 
					if scene ~= game_scene then
						app:enterScene(game_scene, nil, "fade", 0.5)
					end
				else
					print("进入游戏场景app:enterScene",game_scene)
					--进入游戏场景
            		app:enterScene(game_scene, nil, "fade", 0.5)
				end

            else

            	max_seats = nil 

            end

            -- add send room id and game id
	    	if table_code then		--私人房
				message.dispatchPrivateRoom("room.setSeat",{seatid = seat_id})
				message.dispatchCurrent("room.InitPrivateRoom",{seatid = seat_id,room_Session = room_session,table_session = table_session,max_player=max_seats, watching=watching, 
					gameid=gameid, table_code = table_code,tableid = table_id,gameround = game_round,customization = game_rule,pay_type = game_mode,game_state = game_state,
					game_base = game_base,game_count = game_count})
            elseif max_seats ~= nil then
            	local pos = (table_id-1) % (#max_seats) + 1
            	message.dispatchCurrent("room.InitGameScenes", {session=table_session, seat=seat_id, 
            		max_player=max_seats[pos], watching=watching, roomid=roomid, gameid=gameid, gamekey=gamekey,table_id=table_id})
            else
            	--每次进入比赛房间，根据桌子号切换频道
            	if matchid ~= nil and table_id ~= nil then
            		local strChannel = CONFIG_APP_CHANNEL .. matchid .. table_id
					print("strChannel = ",strChannel)
			        --util.UserInfo = { gameid = gameid, roomid = roomid, table_id = table_id, seat_id = seat_id, watching = watching, room_session = table_session, password = "111", players = 4}
			        util.OpenChannel(strChannel)
            	end

            	message.dispatchCurrent("room.InitGameScenes", {session=table_session, seat=seat_id,
            		max_player=max_player, watching=watching, roomid=roomid, gameid=gameid, gamekey=gamekey,table_id=table_id})
            end
        else
        	print("game_scene is nil!")
        	if roomScene then
	            errorLayer.new("坐到桌子成功"):addTo(roomScene)
	        end
        end
    else
		local error_info = errors.str(msg.result)

		if error_info == "no_seat_available" then		--房间人数已满
			error_info = app.lang.enter_room_failed_exceed
		elseif error_info == "lack_gold" then				--钻石不足
			error_info = app.lang.enter_room_failed_gold	
    	else
			error_info = app.lang.enter_room_failed
		end
		local scene = display.getRunningScene()
		--清理密码
		if scene.clearLoginPassword then
			scene:clearLoginPassword()
		end

		--清理私人房数据
		if table_code then
			msgMgr:clearProvateRoomInfo()
		end

		print("请求坐下失败:" .. error_info)
		errorLayer.new(error_info):addTo(scene)
    end
end

function gameMsg.SitupRep(msg)
	--比赛切换座位时，关掉原有的频道
	util.CloseChannel(false)
	app.constant.enterGameUInfo = {}
	print("SitupRep------")
	--dump(msg)
end

function gameMsg.TableStateInfo(msg)

    print("TableStateInfozzzz")
	-- dump(msg) --HACK: do not dump here. will crushed by 'name'
	for i = 1, #msg.player do
		msg.player[i].name = crypt.base64decode(msg.player[i].name)
	end
	if msg.session == room_session then
		for i = 1, #msg.player do
			local p = {
				uid = msg.player[i].uid,
				name = msg.player[i].name, 
				gold = msg.player[i].gold, 
				ready = msg.player[i].ready, 
				sex = msg.player[i].sex,
				viptype = msg.player[i].viptype,
				imageid = msg.player[i].imageid
			}
			print("room_session-TableStateInfo:",msg.player[i].imageid)
	    	msgMgr:add_seat_player(msg.table, msg.player[i].seat, p)
		end
		printf("set table:%d state:%d", msg.table, msg.state)
		msgMgr:set_table_state(msg.table, msg.state)
		if roomScene then
			for i = 1, #msg.player do
			    roomScene:playerSeat(msg.table, msg.player[i].seat, msg.player[i])
			    roomScene:SeatReady(msg.table, msg.player[i].seat, msg.player[i].ready>0)
			end
			roomScene:tableState(msg.table, msg.state)
		end
	elseif msg.session == table_session then
		if msg.table == table_id then
			message.dispatchCurrent("room.TableStateInfo", {state = msg.state, round = msg.round})
			for i = 1, #msg.player do
				local userNum = #app.constant.enterGameUInfo
				local find = false

				if userNum>0 then

					for k,v in pairs(app.constant.enterGameUInfo) do

				        if app.constant.enterGameUInfo[k].uid == msg.player[i].uid then

				        	find = true
				           break

				        end

		            end

		            if not find then

		            	 local msg = { uid = msg.player[i].uid, nickname = msg.player[i].name, gold = msg.player[i].gold, sex = msg.player[i].sex, viptype = msg.player[i].viptype, imageid = msg.player[i].imageid}

	                     table.insert(app.constant.enterGameUInfo, msg)

		            end

				else

					 local msg = { uid = msg.player[i].uid, nickname = msg.player[i].name, gold = msg.player[i].gold, sex = msg.player[i].sex, viptype = msg.player[i].viptype, imageid = msg.player[i].imageid}

	                 table.insert(app.constant.enterGameUInfo, msg)

				end

				print("gameMsg.TableSitdown111111seatid::" .. tostring(msg.player[i].seat) .. ",vip:" .. tostring(msg.player[i].viptype))
				print("TableStateInfo:",msg.player[i].imageid)
		    	message.dispatchCurrent("room.EnterGame", {seat=msg.player[i].seat, player={name=msg.player[i].name, gold=msg.player[i].gold, ready=msg.player[i].ready, 
		    		sex=msg.player[i].sex, viptype=msg.player[i].viptype, imageid = msg.player[i].imageid, uid = msg.player[i].uid}})
			end
		end
	end
	
end

local function TableBeLeave(isleave)

	if gameid == 105 then

	   return
	   
	end

	print("TableBeLeave-----")

	if handler then

		print("destroy handler-----")
	    scheduler.unscheduleGlobal(handler)
		handler = nil
	end

	if isleave then

		print("BeLeave-----")
		app.constant.show_leaveTip = true
		message.dispatchGame("room.LeaveGame", {seat=seat_id})

	end


end

function gameMsg.TableSitdown(msg)
	msg.player.name = crypt.base64decode(msg.player.name)
	if msg.session == room_session then
		print("gameMsg.TableSitdown－room_session")
		local p = {
			uid = msg.player.uid,
			name = msg.player.name, 
			gold = msg.player.gold, 
			ready = 0, 
			sex = msg.player.sex, 
			viptype = msg.player.viptype,
			imageid = msg.player.imageid
		}
		msgMgr:add_seat_player(msg.table, msg.seat, p)
		if roomScene then
		    roomScene:playerSeat(msg.table, msg.seat, msg.player)
		end
	elseif msg.session == table_session then
		if msg.table == table_id then

			print("gameMsg.TableSitdown－table_session")
			local userNum = #app.constant.enterGameUInfo
			local find = false

			if userNum>0 then

				for k,v in pairs(app.constant.enterGameUInfo) do

			        if app.constant.enterGameUInfo[k].uid == msg.player.uid then

			        	find = true
			           break

			        end

	            end

	            if not find then

	            	 local msg = { uid = msg.player.uid, nickname = msg.player.name, gold = msg.player.gold, sex = msg.player.sex, viptype = msg.player.viptype, imageid = msg.player.imageid}

                     table.insert(app.constant.enterGameUInfo, msg)

	            end

			else

				 local msg = { uid = msg.player.uid, nickname = msg.player.name, gold = msg.player.gold, sex = msg.player.sex, viptype = msg.player.viptype, imageid = msg.player.imageid}

                 table.insert(app.constant.enterGameUInfo, msg)

			end

			print("TableSitdown:",msg.player.imageid)
        	message.dispatchCurrent("room.EnterGame", {seat=msg.seat, player={name=msg.player.name, gold=msg.player.gold, ready=0, sex=msg.player.sex, viptype=msg.player.viptype,
        		 imageid = msg.player.imageid, uid = msg.player.uid}})
    	end
	end
end

function gameMsg.TableSitup(msg)
	if msg.session == room_session then
		print("remove_seat_player table:" .. msg.table .. " seat:" .. msg.seat)
		msgMgr:remove_seat_player(msg.table, msg.seat)

	    if roomScene then
	    	print("roomScene update table:" .. msg.table .. " seat:" .. msg.seat)
		    roomScene:playerSeat(msg.table, msg.seat, nil)
		    roomScene:SeatReady(msg.table, msg.seat, false)
		end
	elseif msg.session == table_session then
		if msg.table == table_id then

       		message.dispatchCurrent("room.LeaveGame", {seat=msg.seat})
    	end
	end
end

function gameMsg.SeatReady(msg)
	print("SeatReady--------")
	--dump(msg,"SeatReady = ")

	if msg.session == room_session then

		--print("SeatReady--111--")
		--print("gameMsg.SeatReady table:" .. msg.table .. " seat:" .. msg.seat .. " session:" .. msg.session)
		local player = msgMgr:get_seat_player(msg.table, msg.seat)
	    if player ~= nil then
	        player.ready = 1
	    end

	    if roomScene then
		    roomScene:SeatReady(msg.table, msg.seat, true)
		end
	elseif msg.session == table_session then
		if msg.table == table_id then
        	message.dispatchCurrent("room.Ready", {seat=msg.seat})
    	end
	end
end

function gameMsg.TableStateStart(msg)

	print("TableStateStart")

	if msg.session == room_session then

		-- print("gameMsg.TableStateStart table:" .. msg.table .. " session:" .. msg.session)
	    local players = msgMgr:get_seat_players(msg.table)
	    for i, v in pairs(players) do
	        v.ready = 0
	        if roomScene then
		        roomScene:SeatReady(msg.table, i, false)
		    end
	    end
	    msgMgr:add_table_state(msg.table, TABLE_STATE.GAME)
	    if roomScene then
		    roomScene:tableState(msg.table, table_states[msg.table])
		end
	end
end

function gameMsg.TableStateEnd(msg)
	if msg.session == room_session then
		-- print("gameMsg.TableStateEnd table:" .. msg.table .. " session:" .. msg.session)
		msgMgr:cls_table_state(msg.table, TABLE_STATE.GAME)
		if roomScene then
		    roomScene:tableState(msg.table, table_states[msg.table])
		end
	end
end

function gameMsg.ReadyRep(msg)
	print("ReadyRep")
	--dump(msg, "ReadyRep = ")
	--message.dispatchCurrent("room.ReadyRep", {result=msg.result})
	if msg.result ~= 0 then
		local scene = display.getRunningScene()
		errorLayer.new(app.lang.falied_ready):addTo(scene)
	end
end

function gameMsg.LeaveRoomRep(msg)
	-- print("gameMsg.LeaveRoomRep")
	-- app:enterScene("LobbyScene", nil, "fade", 0.5)
end

-------------------表情消息-----------------------
-- function gameMsg.ChatReq(msg)
-- 	print("派发表情消息")
-- 	dump(msg, "表情")
-- 	local biaoqingSession = msg.session
-- 	message.sendMessage("game.ChatReq", {session=biaoqingSession,info = msg.info,toseat = msg.toseat})

-- end
function gameMsg.ChatRep(msg)
	print("派发表情消息1")
	if msg.result ~= 0 then
		local scene = display.getRunningScene()
		errorLayer.new("消息发送失败"):addTo(scene)
	end

end
function gameMsg.ChatMsg(msg)
	print("派发表情消息2")
	dump(msg, "派发表情消息2")
	message.dispatchCurrent("room.ChatMsg", msg)
end

-------------------表情消息-----------------------
function gameMsg.UpdateSeat(msg)
	message.dispatchCurrent("room.UpdateSeat", {table = msg.table, finish = msg.finish, player = msg.player})
	if msg.finish ~= 0 then
		local scene = display.getRunningScene()
		if scene.name ~= "RoomScene" and scene.name ~= "LobbyScene" and scene.name ~= "LoginScene" then
			local layer = scene:getChildByName("privateScaRoomLayer")
			if layer then
				layer:removeFromParent()
			end

			--私人房已经解散，清理数据
			msgMgr:clearProvateRoomInfo()			

			local dissolution_info = errors.str(msg.finish)
			if dissolution_info == "finish_long_time_no_playing" then			-- 长时间无人操作，房间解散
				print("长时间无人操作，房间解散")
				message.dispatchPrivateRoom("room.TimeDismissGame",{})
			elseif dissolution_info == "finish_host_dismiss" then				-- 游戏没开始，房主解散房间
				print("游戏没开始，房主解散房间")
				message.dispatchPrivateRoom("room.ExitTable", {textInfo = app.lang.room_dissolution_owner})
			elseif dissolution_info == "finish_dismiss" then					-- 游戏已开始，大家投票解散房间
				print("游戏已开始，大家投票解散房间")
			elseif dissolution_info == "finish_timeout" then					-- 创建房间，15分钟未开始游戏，自动解散房间
				print("创建房间，15分钟未开始游戏，自动解散房间")
				message.dispatchPrivateRoom("room.ExitTable", {textInfo = app.lang.room_dissolution_timeout})				 
			end
		end
	end
end
function gameMsg.DismissGameReq(msg)
	message.dispatchPrivateRoom("room.DismissGameReq",{session = msg.session, privateid = msg.privateid, seat = msg.seat, nickname = msg.nickname})
end
function gameMsg.DismissGameRep(msg)
	local dissolution_info = errors.str(msg.result)
	print("解散房间信息:" .. dissolution_info)
	if dissolution_info == "no_right_dismiss" then  						-- 无权发起解散请求
		print("解散房间信息:无权发起解散请求")
		message.dispatchPrivateRoom("room.DismissGameRep",{session = msg.session, privateid = msg.privateid, seat = msg.seat, nickname = msg.nickname, info = dissolution_info})
	elseif dissolution_info == "success_req_dismiss" then					-- 解散请求收到，已转发其他玩家
		print("解散房间信息:解散请求收到，已转发其他玩家")
		message.dispatchPrivateRoom("room.DismissGameRep",{session = msg.session, privateid = msg.privateid, seat = msg.seat, nickname = msg.nickname, info = dissolution_info})		
	elseif dissolution_info == "player_req_dismiss" then					-- 已有玩家发起解散请求
		print("解散房间信息:已有玩家发起解散请求")
		message.dispatchPrivateRoom("room.DismissGameRep",{session = msg.session, privateid = msg.privateid, seat = msg.seat, nickname = msg.nickname, info = dissolution_info})
	elseif dissolution_info == "reject_req_dismiss" or 						-- 某玩家拒绝解散
			dissolution_info == "success_reject_dismiss" then				-- 拒绝解散成功
		message.dispatchPrivateRoom("room.DismissGameRep",{session = msg.session, privateid = msg.privateid, seat = msg.seat, nickname = msg.nickname})
	elseif dissolution_info == "wait_rep_dismiss" then						-- 等待解散结果
		print("解散房间信息:等待解散结果")
	elseif dissolution_info == "no_req_dismiss" then						-- 无人申请解散
		print("解散房间信息:无人申请解散")
	elseif dissolution_info == "repeat_req_dismiss" then					-- 重复解散申请
		print("解散房间信息:重复解散申请")		
	end
end
function gameMsg.ManagedNtf(msg)
	message.dispatchCurrent("room.ManagedNtf", {session = msg.session, seat = msg.seat, state = msg.state})
end
-- ------------------------------ room msg from client table ------------------------------
function roomMsg.LeaveGame()
    message.sendMessage("game.SitupReq", {session=room_session})
    roomMsg.ExitTable()
end

function roomMsg.ExitTable()
	if watching == false then

		print("ExitTable----")
		util.CloseChannel()
		app.constant.enterGameUInfo = {}
	end

	message.unregisterHandle()

	print("ExitTable not return ----")

    print("gameid,roomid,",gameid,roomid)

	app:enterScene("RoomScene", {gameid, roomid}, "fade", 0.5)
end

function roomMsg.ReadyReq()
	print("roomMsg ReadyReq")
    message.sendMessage("game.ReadyReq", {session=room_session})
end


-- ------------------------------ message manager ------------------------------
function msgMgr:setRoomScene(scene)
	roomScene = scene
	if scene then
		print("set room scene succeed.")
	    -- errorLayer.new("进入房间成功"):addTo(roomScene)
	end
end

function msgMgr:dispatch(name, msg)
--	print("msgMgr:dispatch:" .. name)
	local clsName, funcName = name:match "([^.]*).(.*)"
	assert(handlers[clsName], clsName .. " handler not exist!")
	--print("handlers name:" .. clsName)
	if handlers[clsName] then
		assert(handlers[clsName][funcName], clsName.."Mgr have no func: "..funcName)
		handlers[clsName][funcName](msg)
	end
	return true
end

---------------------------------- room table state manage -------------------------------------
function msgMgr:set_table_state(tableid, state)
    table_states[tableid] = state
end

function msgMgr:add_table_state(tableid, state)
	table_states[tableid] = table_states[tableid] or TABLE_STATE.WAIT
	table_states[tableid] = bit.bor(table_states[tableid], state)
end

function msgMgr:cls_table_state(tableid, state)
	table_states[tableid] = table_states[tableid] or TABLE_STATE.WAIT
	table_states[tableid] = bit.band(table_states[tableid], bit.bnot(state))
end

function msgMgr:add_seat_player(table, seat, player)
    if player_info[table] == nil then
    	player_info[table] = {}
    end
    player_info[table][seat] = player
end

function msgMgr:remove_seat_player(table, seat)
    local temp = player_info[table]
    if temp ~= nil then
        temp[seat] = nil
    end
end

function msgMgr:get_seat_players(table)
    local temp = player_info[table]
    if temp ~= nil then
        return temp
    end
    return {}
end

function msgMgr:get_seat_player(table, seat)
    local temp = player_info[table]
    if temp ~= nil then
        return temp[seat]
    end
    return nil
end

function msgMgr:get_table_info()
	return player_info
end

function msgMgr:get_table_state(tid)
	if tid then
		return table_states[tid]
	end
	return table_states
end

---------------------------------room data visit------------------------------------------

function msgMgr:setRoomId(gid, rid)
	gameid = gid
	roomid = rid
	player_info = {}
	table_states = {}
	print("setRoomId gameid:" .. gameid .. " roomid:" .. roomid)
end

function msgMgr:setGameName(name)
	game_scene = name
end

function msgMgr:setPrivateRoomInfo(param)
	room_session = param.session						--通信验证
	table_code = param.info.privateid					--私人房房号
	roomid = param.info.roomid							--房间ID
	gameid = param.info.gameid							--游戏ID
	max_seats = param.info.customization.seats			--椅子数
	game_state = param.info.state 						--0: 房卡游戏未开始； 1: 房卡游戏已开始
	game_mode = param.info.customization.mode			--1: 房主付费; 2: 均摊 
	game_round = param.info.customization.round 		--局数
	game_base = param.info.customization.base 			--低分
	game_count = param.info.customization.count 		--初始分数
	game_rule = param.info.customization.rule 			--规则位图
end

function msgMgr:clearProvateRoomInfo()
	room_session = 0			--通信验证
	table_code = nil			--私人房房号
	roomid = nil				--房间ID
	gameid = nil				--游戏ID
	max_seats = nil				--椅子数
	game_state = nil 			--0: 房卡游戏未开始； 1: 房卡游戏已开始
	game_mode = nil				--1: 房主付费; 2: 均摊 
	game_round = nil			--局数
	game_base = nil 			--低分
	game_count = nil 			--初始分数
	game_rule = nil 			--规则位图
end

--清理私人房密码
function msgMgr:clearPrivateCode()
	table_code = nil
end

function msgMgr:setMaxPlayer(max, seats)
	max_player = max
	print("max_player = ", max_player)
	if seats ~= nil then
		max_seats = {}
		for i = 1, #seats do
			max_seats[i] = #seats[i]
		end
	else
		print("max_player111 = ", max_player)
		max_seats = nil
	end
end

function msgMgr:setGameKey(key)
	gamekey = key
end

function msgMgr:get_room_session()
	return room_session
end

return msgMgr