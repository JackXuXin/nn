local MatchMessage = {}

local Message = import(".Message")
local crypt = require("crypt")
local RoomConfig = require("app.config.RoomConfig")
local util = require("app.Common.util")
require("app.room.manager")
local msgMgr = require("app.room.msgMgr")

local Player = app.userdata.Player
local Account = app.userdata.Account

function MatchMessage.MatchConfigReq()
	print("MatchConfigReq")
	-- body
	MatchMessage.oldMessage = {}
	Message.sendMessage("match.MatchConfigReq", MatchMessage.oldMessage)
end

function MatchMessage.MatchConfigRep(msg)
	print("MatchConfigRep")
	print("config:" .. msg.config)
	util.DEBUG_LOG(msg.config)
	local newConfig = assert(loadstring(msg.config))()
    newConfig = checktable(newConfig)

    dump(newConfig)

    for _,config in ipairs(RoomConfig) do

    	config.matchroom = {}

    	for _, matchConfig in ipairs(newConfig) do

	    	if config.gameid == matchConfig.gameid and matchConfig.matchid then

	    		print("match------",matchConfig.matchid)
		    	
	    		--for _,v in pairs(config.matchid) do
	    			local _, newRoom = util.findRootByLeaf(newConfig, "matchid", matchConfig.matchid, 2)
	    			if newRoom then
			        	--dump(newRoom)

			        	--local curWeek = os.date("%w",os.time())

			        	--print("curWeek:",curWeek)

			        	-- if matchConfig.matchid == 20802 then

			        	-- 	if curWeek == "6" then 

			        	-- 		table.insert(config.matchroom, newRoom)

			        	-- 	end

			        	-- elseif matchConfig.matchid == 20801 then

			        	-- 	if curWeek ~= "6" then 

			        	-- 		table.insert(config.matchroom, newRoom)

			        	-- 	end

			        	-- else 

			        		table.insert(config.matchroom, newRoom)

			        	--end

			        	--table.insert(config.matchroom, newRoom)
			        	print("found match room:" .. tostring(#config.matchroom))
			        end 
	    		--end

	    		local function testSort(a,b)

	    			if a.invisible ~= nil and a.invisible == 1 and b.invisible == nil then

	    			   return false 

	    			elseif b.invisible ~= nil and b.invisible == 1 and a.invisible == nil then
	    
	    			    return true 

	    			else

	    				local aHour = tonumber(a.startHour) or 0
	    				local bHour = tonumber(b.startHour) or 0
	    				local aMinute = tonumber(a.startMinute) or 0
	    				local bMinute = tonumber(b.startMinute) or 0
						return aHour < bHour or (aHour == bHour and aMinute < bMinute)

			        end
			    end
			    table.sort(config.matchroom,testSort)
	    	end
	    end
    end

end

function MatchMessage.MatchListReq(gameId, matchid)
	print("MatchListReq" .. gameId)

	print("matchid", matchid)
	app.constant.matchid = matchid
	-- body
	MatchMessage.oldMessage = {gameid = gameId, matchid = matchid}
	Message.sendMessage("match.MatchListReq", MatchMessage.oldMessage)
end

function MatchMessage.MatchListRep(msg)
	print("MatchListRep:" .. type(msg))
end

function MatchMessage.MatchSignupReq(optype,matchid)
	print("MatchSignupReq: optype:" .. optype .. "matchid:" .. matchid )
	MatchMessage.oldMessage = {optype = optype,matchid = matchid}
	Message.sendMessage("match.MatchSignupReq", MatchMessage.oldMessage)
end

function MatchMessage.MatchSignupRep(msg)
	print("MatchSignupRep")
end

function MatchMessage.MatchRankReq(matchid)
	MatchMessage.oldMessage = {matchid = matchid}
	Message.sendMessage("match.MatchRankReq", MatchMessage.oldMessage)
end

function MatchMessage.MatchRankRep(msg)
	--print("MatchRankRep:" .. msg)
end

function MatchMessage.EnterMatchReq(matchId,online)
	-- body

	local gameKey = nil
	local gameScene = nil

	for _,config in ipairs(RoomConfig) do
    	if not gameKey and config.matchroom then
    		for _,v in pairs(config.matchroom) do
    			if v.matchid == matchId then
    				gameKey = v.gamekey
    				gameScene = config.scene
    				break
    			end
	    	end
    	end
    end

    assert(gameKey, "gameKey is nil")
    assert(gameScene, "gameScene is nil")

    print("gameKey:" .. gameKey .. ",gameScene:" .. gameScene)

	msgMgr:setGameKey(gameKey)
	msgMgr:setGameName(gameScene)
	msgMgr:setOnline(online)

	MatchMessage.oldMessage = {clientid = 0,matchid = matchId}
	Message.sendMessage("match.EnterMatchReq", MatchMessage.oldMessage)
end

function MatchMessage.EnterMatchRep(msg)
	dump(msg, "MatchMessage.EnterMatchRep")
	-- body
	msgMgr:MatchEnterRoomRep(msg)
end

function MatchMessage.SignupCountNtf(msg)
	print("SignupCountNtf:" .. msg.count)
	-- body
	Message.dispatchCurrent("room.SignupCountNtf",msg)
end

function MatchMessage.MatchStatustNtf(msg)
	print("MatchStatustNtf")
	print("state:" .. msg.status)
	msgMgr:MatchStatus(msg)
	Message.dispatchCurrent("room.MatchStatustNtf",msg)
end

function MatchMessage.MatchInfoNtf(msg)
	Message.dispatchCurrent("room.MatchInfoNtf",msg)
end

function MatchMessage.LeaveMatchReq(session)
	print("LeaveMatchReq")

	-- body
	MatchMessage.oldMessage = {session = session}
	Message.sendMessage("match.LeaveMatchReq", MatchMessage.oldMessage)
end

function MatchMessage.LeaveMatchRep(msg)
	print("LeaveMatchRep")
	
	Message.dispatchCurrent("room.LeaveMatchRep",msg)
	Message.unregisterHandle()
	app:enterScene("LobbyScene", nil, "fade", 0.5)
end

function MatchMessage.MatchRankNtf(msg)
	Message.dispatchCurrent("room.MatchRankNtf",msg)
end

function MatchMessage.dispatch(name, msg)
	local module, method = name:match "([^.]*).(.*)"
	print("module:"..module.."method:"..method)
	if MatchMessage[method] then
		MatchMessage[method](msg)
	end

	Message.notifyScene(method, msg, MatchMessage.oldMessage)
end

Message.registerHandle("match", MatchMessage.dispatch)

return MatchMessage