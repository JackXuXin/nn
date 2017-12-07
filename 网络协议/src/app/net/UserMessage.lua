local UserMessage = {}

local Message = import(".Message")
local crypt = require("crypt")
local RoomConfig = require("app.config.RoomConfig")
local util = require("app.Common.util")
local roomMgr = require("app.room.manager")
local ErrorLayer = require("app.layers.ErrorLayer")
local message = require("app.net.Message")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local ActivityConfig = require("app.config.ActivityConfig")--活动信息配置

local PlatConfig = require("app.config.PlatformConfig")  --游戏配置表

local Player = app.userdata.Player
local Account = app.userdata.Account

function UserMessage.UserInfoRequest(uid)
	print("UserMessage.UserInfoRequest:"..uid)
	UserMessage.oldMessage = {uid = uid}
	Message.sendMessage("user.UserInfoRequest", UserMessage.oldMessage)
end

function UserMessage.UserInfoResonpse(msg)
	print("UserMessage.UserInfoResonpse")
	-- dump(msg,"userinfo = ")
	if Account.uid == msg.uid then
		for k,v in pairs(msg) do
			if k == "nickname" then
				app.userdata.Player[k] = crypt.base64decode(v)
			else
				app.userdata.Player[k] = v
			end
		end
	end

	--dump(Player)
end

function UserMessage.InviteFriendsReq()

    if util.UserInfo ~= nil and selectRequestList ~= nil then


    	local gameid = util.UserInfo.gameid
    	local roomid = util.UserInfo.roomid
    	local tableid = util.UserInfo.table_id
    	local seatid = util.UserInfo.seat_id
    	local session = util.UserInfo.room_session
    	local password = util.UserInfo.password

    	print("UserMessage.InviteFriendsReq1")

    	UserMessage.oldMessage = {nickname = util.checkNickName(Player.nickname), gameid = gameid, roomid = roomid, tableid = tableid, seatid = seatid, session = session, password = password, friends = { }}

    	for k,v in pairs(selectRequestList) do

	         local id = selectRequestList[k].uid

	         print("id:",id)

	         UserMessage.oldMessage.friends[k] = id

	     end

    	--dump(UserMessage.oldMessage)


    end

	Message.sendMessage("user.InviteFriendsReq", UserMessage.oldMessage)
end

function UserMessage.InviteFriendsRep(msg)

	print("UserMessage.InviteFriendsRep")

	 print("util.curScene", util.curScene)

    --print("util.InviteFriendsRep")

    if msg.result == 0 then

         if util.curScene then

            ErrorLayer.new(app.lang.invitation_ok, nil, nil, nil, 1):addTo(util.curScene)

         end

    else

        if util.curScene then

            ErrorLayer.new(app.lang.invitation_error, nil, nil, nil):addTo(util.curScene)

         end

    end

end

function UserMessage.Invitation(msg)

	print("UserMessage.Invitation")

end

function UserMessage.BackupFriendshipReq(type, uid)

	print("UserMessage.BackupFriendshipReq")

	UserMessage.oldMessage = {optype = type, friend = uid}
	Message.sendMessage("user.BackupFriendshipReq", UserMessage.oldMessage)

end

function UserMessage.BackupFriendshipRep(msg)

	print("UserMessage.BackupFriendshipRep:", msg.result)

end

function UserMessage.shareAddGold()
	UserMessage.oldMessage = {uid = Account.uid}
	Message.sendMessage("user.ShareGameReq", UserMessage.oldMessage)
end

function UserMessage.ShareGameRep(msg)
	print("UserMessage.ShareGameRep111")
end

function UserMessage.RankingListReq()
	UserMessage.oldMessage = {}
	print("UserMessage.RankingListReq--")
	Message.sendMessage("user.RankingListReq", UserMessage.oldMessage)
end

function UserMessage.FreeGoldQueryReq()
	UserMessage.oldMessage = {uid = Account.uid}
	Message.sendMessage("user.SigninInfoReq", UserMessage.oldMessage)
end

function UserMessage.SignReq()
	UserMessage.oldMessage = {uid = Account.uid}
	Message.sendMessage("user.SigninReq", UserMessage.oldMessage)
end

function UserMessage.GrantReq()
	UserMessage.oldMessage = {uid = Account.uid}
	Message.sendMessage("user.GetGrantReq", UserMessage.oldMessage)
end

function UserMessage.BindUserReq(uid, code)
	UserMessage.oldMessage = {supid = uid, code = code}
	Message.sendMessage("user.BindUserReq", UserMessage.oldMessage)
end

function UserMessage.BindUserRep(msg)
	print("UserMessage.BindUserRep result:"..msg.result)
end

function UserMessage.BindMobileReq(mobile, code)
	UserMessage.oldMessage = {mobile = mobile, code = code}
	Message.sendMessage("user.BindMobileReq", UserMessage.oldMessage)
end

function UserMessage.BindMobileRep(msg)
	print("UserMessage.BindMobileRep result:"..msg.result)
end

function UserMessage.IdentityVerificationReq(name, code)
	UserMessage.oldMessage = {name = name, code = code}
	Message.sendMessage("user.IdentityVerificationReq", UserMessage.oldMessage)
end

function UserMessage.IdentityVerificationRep(msg)
	print("UserMessage.IdentityVerificationRep result:"..msg.result)
end

function UserMessage.ModifyUserInfoReq(sex, nickname, imageid)
	UserMessage.oldMessage = {sex = sex, nickname = nickname, imageid = imageid}
	-- dump(UserMessage.oldMessage,"modify = ")
	Message.sendMessage("user.ModifyUserInfoReq", UserMessage.oldMessage)
end

function UserMessage.BankInfoReq()
	UserMessage.oldMessage = {optype = 0}
	Message.sendMessage("user.BankOperateReq", UserMessage.oldMessage)
end

function UserMessage.BankSaveGold(gold)
	UserMessage.oldMessage = {optype = 1, gold = gold, pwd = Player.secondpwd}
	Message.sendMessage("user.BankOperateReq", UserMessage.oldMessage)
end

function UserMessage.BankPickGold(gold)
	UserMessage.oldMessage = {optype = 2, gold = gold, pwd = Player.secondpwd}
	Message.sendMessage("user.BankOperateReq", UserMessage.oldMessage)
end

function UserMessage.BankOperateRep(msg)
	--dump(msg)
	if msg.result == 0 then
		Player.gold = msg.gold
		Player.bankgold = msg.bankgold
	end
end

function UserMessage.ModifyPwdReq(pwdtype, oldpwd, newpwd)
	--modify by whb 160921
	print("UserMessage.ModifyPwdReq pwdtype, oldpwd, newpwd:",pwdtype, oldpwd, newpwd)
	UserMessage.oldMessage = {pwdtype = pwdtype, oldpwd = oldpwd, newpwd = newpwd}
	Message.sendMessage("user.SetPwdReq", UserMessage.oldMessage)
	--modify end
end

function UserMessage.ExchangeHonorReq(honor)
	print("UserMessage.ExchangeHonorReq---------")
	UserMessage.oldMessage = {honor = honor}
	Message.sendMessage("user.ExchangeReq", UserMessage.oldMessage)
end

function UserMessage.GiveGoldReq(uid, gold, pwd)
	UserMessage.oldMessage = {uid = uid, gold = gold, pwd = Player.secondpwd}
	Message.sendMessage("user.GiveGoldReq", UserMessage.oldMessage)
end

function UserMessage.GiveDiamondReq(uid, diamond, pwd)
	print("GiveDiamondReq-----")
	UserMessage.oldMessage = {uid = uid, diamond = diamond, pwd = Player.secondpwd}
	Message.sendMessage("user.GiveDiamondReq", UserMessage.oldMessage)
end

function UserMessage.AddGoldReq(gold)
	UserMessage.oldMessage = {gold = gold}
	Message.sendMessage("user.AddGoldReq", UserMessage.oldMessage)
end

function UserMessage.GiveGoldRes(msg)
	if msg.result == 0 then
		for k,v in pairs(msg) do
			if k == "bankgold" then
				print("UserMessage.GiveGoldRes", Player.bankgold, v)
				Player.bankgold = v
				break
			end
		end
	end
end

function UserMessage.GiveDiamondRep(msg)

	print("UserMessage.GiveDiamondRep----")
	if msg.result == 0 then
		for k,v in pairs(msg) do
			if k == "handdiamond" then
				print("UserMessage.GiveDiamondRep111---", Player.diamond, v)
				Player.diamond = v
				break
			end
		end
	end
end


--请求活动
function UserMessage.LuckyListReq()

	print("UserMessage.LuckyListReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.LuckyListReq", UserMessage.oldMessage)
end
--活动反馈基本的信息
function UserMessage.LuckyListRep(msg)

	print("UserMessage.LuckyListRep---------")
	local newConfig = assert(loadstring(msg.config))()
    newConfig = checktable(newConfig)
    -- dump(newConfig)
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
	local activityConfig = ActivityConfig:getActConfig(CONFIG_APP_CHANNEL)

	activityConfig.configJP = {}
	activityConfig.LuckyID = {}
	--赋值整个活动的配置信息
	for i , v in pairs(newConfig) do
		for game_index,conf in pairs(platConfig.game) do
			print("conf.gameid=",conf.gameid, v.gameid)
			if conf.gameid == v.gameid then
				activityConfig.configJP[v.pos]= v
      			table.insert(activityConfig.LuckyID,#activityConfig.LuckyID+1,v.title)
			end
		end

 	end
 	--dump(activityConfig.configJP, "activityConfig.configJP:::")
 	--对活动的位置进行排序
 	if #activityConfig.LuckyID>1 then
 		--todo
 		table.sort(activityConfig.LuckyID) --从小到大排序
 	end

end

--请求抽奖按钮的相关信息
function UserMessage.LuckyInfoReq(id,verbose)

	print("UserMessage.LuckyInfoReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.LuckyInfoReq", {id=id,verbose=verbose})
	-- Message.sendMessage("user.LuckyInfoReq", UserMessage.oldMessage)
end

--请求抽奖记录的相关信息
function UserMessage.LuckyRecordReq(id)

	print("UserMessage.LuckyRecordReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.LuckyRecordReq", {id=id})
	-- Message.sendMessage("user.LuckyInfoReq", UserMessage.oldMessage)
end

--点击抽奖按钮时的请求
function UserMessage.LuckyDrawReq(id)

	print("UserMessage.LuckyDrawReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.LuckyDrawReq", {id=id})
	-- Message.sendMessage("user.LuckyInfoReq", UserMessage.oldMessage)
end

--发送玩家地址
function UserMessage.AddInfoReq(info)

	print("UserMessage.LuckyDrawReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.AddInfoReq", info)
	-- Message.sendMessage("user.LuckyInfoReq", UserMessage.oldMessage)
end

--提示玩家多少局
function UserMessage.LuckyDrawReminder(msg)

	print("UserMessage.LuckyDrawReminder---------")

	ErrorLayer.new(msg.content):addTo(util.curScene)

end
function UserMessage.LuckyProfileReq()
	print("UserMessage.LuckyProfileReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.LuckyProfileReq", UserMessage.oldMessage)
end

function UserMessage.RoomListReq()

	print("UserMessage.RoomListReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.RoomListReq", UserMessage.oldMessage)
end

function UserMessage.CheckReconnectReq()

	print("UserMessage.CheckReconnectReq---------")
	UserMessage.oldMessage = {}
	Message.sendMessage("user.CheckReconnectReq", UserMessage.oldMessage)
end


function UserMessage.RoomListRep(msg)

-- 	local newConfig = {}
-- 	newConfig[1] = {
--   gameid = 102,
--   roomid = 10200,
--   name = "冒险岛",
--   gold = 1000,
--   tables = 60,
--   seats = 5,
--   seatslayout = {{1,2,3,4,5},{1,3},{1,2,3,4,5}},
--   goldseq = {10000,10000,1000000},
--   maxRoomPlayer = 240, -- 房间最大人数，用于客户端展现UI
--   layout = {
--     width = 426,
--     height = 360,
--     table = {idle = "Image/Common/Table/Image_Table_Unplay.png", busy = "Image/Common/Table/Image_Table_Playing.png", posx = 160+52, posy = 180},
--     lock = {icon = "Image/Common/Table/Image_Table_Lock.png", posx=160+80, posy=180-30},
--     seat = {
--       {id=1, posx=290+22, posy=63+20,icon="Image/Common/Table/chair_1.png"},
--       {id=2, posx=360+2, posy=240,icon="Image/Common/Table/chair_2.png"},
--       {id=3, posx=160+52, posy=285,icon="Image/Common/Table/chair_3.png"},
--       {id=4, posx=-40+102, posy=240,icon="Image/Common/Table/chair_4.png"},
--       {id=5, posx=30+82, posy=63+20,icon="Image/Common/Table/chair_5.png"}
--     },
--     name = {
--       {id=1, point="center", posx=290+22, posy=63+80},
--       {id=2, point="center", posx=360+2, posy=300},
--       {id=3, point="center", posx=160+52, posy=345},
--       {id=4, point="center", posx=-40+102, posy=300},
--       {id=5, point="center", posx=30+82, posy=63+80},
--     },
--     hand = {
--       {id=1, icon="Image/Common/Table/Image_Ready.png", posx=290+22-30, posy=63+20-60},
--       {id=2, icon="Image/Common/Table/Image_Ready.png", posx=360+2-30, posy=260-80},
--       {id=3, icon="Image/Common/Table/Image_Ready.png", posx=160+52-30, posy=285-60},
--       {id=4, icon="Image/Common/Table/Image_Ready.png", posx=-40+102-30, posy=260-80},
--       {id=5, icon="Image/Common/Table/Image_Ready.png", posx=30+82-30, posy=63+20-60},
--     }
--   }
-- }

	local newConfig = assert(loadstring(msg.config))()
    newConfig = checktable(newConfig)
    --dump(newConfig)
    print("----UserMessage.RoomListRep--config:" .. #newConfig)
    playerNumbers = msg.players
    for _,config in ipairs(RoomConfig) do
        local gameId = config.gameid
        config.room = {}

        -- local _, newRoom = util.findRootByLeaf(newConfig, "gameid", gameId, 2)

        for i = 1,#newConfig do
        	newRoom = newConfig[i]
        	if newRoom.gameid == gameId then
        		print("newRoom id:" .. newRoom.roomid .. ",key:" .. i)
        		table.insert(config.room, newRoom)
        	end
        end

        -- print("gameid:" gameId)
        -- print("-newRoom",type(newRoom))

        for _,room in ipairs(config.room) do
            local _, roomPlayers = util.findRootByLeaf(playerNumbers, "roomid", room.roomid, 2)
            room.players = roomPlayers and roomPlayers.count or 0

            print("room.players-config:" .. room.players)
        end
    end


 --add by whb 170120

 if app.constant.isReuqestWchat == 2 then

 	scheduler.performWithDelayGlobal(function ()

	 setEnterScene()

	end, 0.5)

 elseif app.constant.isRequesting == 2 then

 	scheduler.performWithDelayGlobal(function ()

	 inGameEnterScene()

	end, 0.5)

 elseif app.constant.isInvite then

 	scheduler.performWithDelayGlobal(function ()

	  SetInvitation()

	end, 0.5)

 end

end

function UserMessage.EnterRoomRequest(gameId, roomId)
	print("enter room request:", gameId, roomId)

    roomMgr:prepare(gameId, roomId)

    --TODO: remove below latter!!!!!!
    Message.sendMessage("user.QuickJoinRequest", {roomid=roomId, clientid=0})

    --TODO: release below latter
    -- Message.sendMessage("user.EnterRoomRequest", {roomid=roomId, clientid=0})
end

function UserMessage.OpenSesameReq(clientid, pwd)
	print("OpenSesameReq:", pwd, clientid)

   -- roomMgr:prepare(gameId, roomId)

    Message.sendMessage("user.OpenSesameReq", {pwd=pwd, clientid=clientid})
end

function UserMessage.OpenSesameRep(msg)

	print("OpenSesameRep:", msg.clientid, msg.gameid, msg.roomid)

	if msg.result == 0 then

		local config = RoomConfig:getGameConfig(msg.gameid)

	    local isMatch = false

	    if config.matchroom ~= nil then

			for k,mroom in pairs(config.matchroom) do

	            local matchid = mroom.matchid

	            if msg.roomid == matchid then

	                isMatch = true

	                break
	            end

	        end
        end

        if isMatch == false then

        	roomMgr:prepare(msg.gameid, msg.roomid)
		    roomMgr:EnterRoomResonpse(msg)

        end

	end

end

function UserMessage.EnterRoomResonpse(msg)
	roomMgr:EnterRoomResonpse(msg)
end

--TODO: remove below latter!!!!
function UserMessage.QuickJoinResonpse(msg)
	roomMgr:EnterRoomResonpse(msg)
end

function UserMessage.RechargeReq(orderId)
	UserMessage.oldMessage = {orderid = orderId or 0}
	Message.sendMessage("user.RechargeReq", UserMessage.oldMessage)
end

function UserMessage.NoticeInfo(msg)
	--dump(msg)
	app.userdata.notice_content = msg.content
end

function UserMessage.PublishNotice(msg)
	dump("公告信息",msg)

	local runningScene = display.getRunningScene()
	if runningScene and runningScene.name then
		for _,v in pairs(msg.notice_list) do
			print("Notice:id = " .. v.id,"v.app_channel = " .. v.app_channel,"v.gameid = " .. v.gameid,"v.content = " .. v.content,"v.note_type = " .. v.note_type)
			if v.app_channel == "0" or v.app_channel == CONFIG_APP_CHANNEL then
				--0全部，1滚屏，2公告
				if v.note_type == 0 or v.note_type == 1 then
					--防止重复
					local has = false
					for _,v1 in pairs(app.userdata.Player.noticeInfos) do
						if v1.id == v.id then
							has = true
						end
					end
					if not has then
						util.RunHorn(v,runningScene,runningScene.scene or runningScene.root)
					end
				end

				--0全部，1滚屏，2公告
				if v.note_type == 0 or v.note_type == 2 then
					table.insert(app.userdata.Player.noticeInfosEx,v)
				end
			end
		end
	end
end

function UserMessage.UnpublishNotice(msg)
	dump(msg,"UserMessage.UnpublishNotice")
	util.removeNotice(msg.id_list)
end

function UserMessage.dispatch(name, msg)
	local module, method = name:match "([^.]*).(.*)"
	print("module:"..module.."-method:"..method)
	if UserMessage[method] then
		UserMessage[method](msg)
	end

	Message.notifyScene(method, msg, UserMessage.oldMessage)
end

Message.registerHandle("user", UserMessage.dispatch)

return UserMessage