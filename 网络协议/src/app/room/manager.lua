local message = require("app.net.Message")

local msgMgr = require("app.room.msgMgr")

local manager = {}

local function loadGameScene(gameid, roomid)
	print("loadGameScene name")
    if gameid == nil or roomid == nil then
    	print("gameid or roomid is nil.")
    	return 
    end
	local config = require("app.config.RoomConfig")
    --assert(config, "config is nil")
	for i = 1, #config do
		if config[i].gameid == gameid then
            for j = 1, #config[i].room do
                if config[i].room[j].roomid == roomid then
                	print("set game scene:", config[i].scene)
                    msgMgr:setGameName(config[i].scene)
                    msgMgr:setMaxPlayer(config[i].room[j].seats, config[i].room[j].seatslayout)
                    if config[i].room[j].gamekey ~= nil then
                        msgMgr:setGameKey(config[i].room[j].gamekey)
                    else
                        msgMgr:setGameKey("")
                    end
                    return
                end
            end
        end
	end
end

function manager:init()
    print("registerHandle:game")
	message.registerHandle("game", handler(msgMgr, msgMgr.dispatch))
end

function manager:prepare(gameId, roomId)
    msgMgr:setRoomId(gameId, roomId)
    loadGameScene(gameId, roomId)
end

function manager:EnterRoomResonpse(msg)
    msgMgr:EnterRoomResonpse(msg)
end

manager:init() -- init self here

return manager