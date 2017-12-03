local PrivateRoomController = class("PrivateRoomController", function ()
    return {}
end)

function PrivateRoomController:ctor(  )
	print("create PrivateRoomController")
end

function PrivateRoomController:create( game_round, mode )
	app.gateNet:call("Create", 
	{
		gameid = 108,
		seat_cnt = 6,
		game_round = 1,
		time = 5,
		mode = mode,
		uid = app.userInfo.uid
	},
	handler(self, self.onCreateRep))
end

function PrivateRoomController:createDummy( game_round, mode, callback )
	app.gateNet:call("CreateDummy", 
	{
		gameid = 108,
		seat_cnt = 6,
		game_round = 1,
		time = 5,
		mode = mode,
		uid = app.userInfo.uid
	},
	callback)
end

function PrivateRoomController:onCreateRep( ok, createRep )
	dump(createRep, "creaetRep")
	self:enter(createRep.table_code)
end

function PrivateRoomController:enter( tableCode )
	app.gateNet:call("Enter",
	{
		table_code = tableCode,
		uid = app.userInfo.uid
	},
	handler(self, self.onEnterRep))
	app.gateNet:registerHandler("GameStart", handler(self, self.GameStart))
	app.gateNet:registerHandler("Leave", handler(self, self.GameLeave))
	app.gateNet:registerHandler("PlayerJoin", handler(self, self.join))
	app.gateNet:registerHandler("EndRoomReq", handler(self, self.endRoomReq))
	app.gateNet:registerHandler("EndRoomRep", handler(self, self.endRoomRep))
	app.gateNet:registerHandler("CanAgain", handler(self, self.canAgain))
end

function PrivateRoomController:leave(  )
	app.gateNet:execute("Leave", {uid = app.userInfo.uid})
end

function PrivateRoomController:join( msg )
	if self.viewHandler then
		if self.start then
			self.viewHandler:playerRecconect(msg.player.seat)
		else
			self.viewHandler:onJoin(msg.player, msg.player.seat)
		end
	else
		print("viewHandler is nil")
	end
end

function PrivateRoomController:againRoom(  )
	app.gateNet:call("Again", {}, handler(self, self.againRoomRep))
end

function PrivateRoomController:againRoomRep( ok, msg )
	if ok then
		self.viewHandler:againRoomSuccess()
	end
end

function PrivateRoomController:canAgain( msg )
	self.viewHandler:roomFeeHasPayed()
end

function PrivateRoomController:onEnterRep( ok, eneterRep )
	if not ok then
		print("not ok")
		return
	end
	-- dump(eneterRep, "eneterRep")
	self.tableInfo = eneterRep
	if eneterRep.result == "success" or eneterRep.result == "reconnect" then
		app:enterScene(gameSceneConfig[eneterRep.gameid])
	else
		print(eneterRep.result)
	end

	self.start = eneterRep.result == "reconnect"
end

function PrivateRoomController:onPlayerInfo( ok, playerInfo )
	self.playerInfo = playerInfo
	 table.walk(msg.players, function ( playerInfo )
		self.viewHandler:addPlayer(playerInfo, playerInfo.seat)
	end)
end

function PrivateRoomController:GameStart( args )
	-- self.viewHandler:gameStart()
	-- print("game start")
	-- if self.startCount == nil then
	-- 	self.startCount = 1
	-- else
	-- 	self.startCount = self.startCount + 1
	-- end
	-- print("startCount = ", args.uid) 
	-- if self.viewHandler then
	-- 	require("app.controllers.6jtController"):register(self.viewHandler)
	-- else
	-- 	self.start = true
	-- end

	-- if self.viewHandler then
	-- 	self.viewHandler:startGame()
	-- end
	self.start = true
end

function PrivateRoomController:addScore( seat, score )
	self.players[seat].gold = self.players[seat].gold + score
end

function PrivateRoomController:endGame(  )
	self.tableInfo.curround = self.tableInfo.curround + 1
end

function PrivateRoomController:zeroRound(  )
	self.tableInfo.curround = 1
end

function PrivateRoomController:GameLeave( args )
	if self.start then
		self.viewHandler:playerDisconnect(args.seat)
	else
		self.viewHandler:delPlayer(args.seat)
	end
end

function PrivateRoomController:isOver(  )
	print("curround = ", self.tableInfo.curround, "gameround = ", self.tableInfo.gameround)
	return self.tableInfo.curround == self.tableInfo.gameround + 1
end

function PrivateRoomController:isInGame( ok, isInGameRep )
	dump(isInGameRep, "isInGameRep")
	if isInGameRep.table_code then
		self:enter({table_code = table_code, uid = app.userInfo.uid})
	end
end

function PrivateRoomController:getPlayer( seat )
	local index = exist(self.players, function ( player )
		return player.seat == seat 
	end)

	return self.players[index]
end

function PrivateRoomController:register( viewHandler )
	self.viewHandler = viewHandler
end

function PrivateRoomController:queryTablePlayer(  )
	app.gateNet:call("QueryTablePlayer", {addr = self.tableInfo.table_addr, uid = app.userInfo.uid}, handler(self, self.addPlayers))
end

function PrivateRoomController:addPlayers( ok, msg )
	
	self.players = msg.players
	self.start = msg.start

	if msg.start then
		self.viewHandler:onReconnect(msg.players)
	else
		self.viewHandler:onSelfJoinTable(msg.players)
	end
end

function PrivateRoomController:ready(  )
	app.gateNet:execute("Ready", {addr = self.tableInfo.table_addr})
end

function PrivateRoomController:dismissRequest(  )
	local selfSeat = exist(self.players, function ( player )
		return player.uid == app.userInfo.uid
	end)
	app.gateNet:execute("EndRoomReq", {seat = selfSeat, addr = self.tableInfo.table_addr})
	-- self.viewHandler:showDismissRoomRep(selfSeat)
end

function PrivateRoomController:endRoomReq( msg )
	self.viewHandler:showDismissRoomRep(msg.seat)
	app.gateNet:registerHandler("EndRoom", handler(self, self.endRoom))
end

function PrivateRoomController:endRoomRep( msg )
	self.viewHandler:endRoomRep(msg.seat, msg.agree)
end

function PrivateRoomController:endRoomRespond( selfSeat, agree )
	app.gateNet:execute("EndRoomRep", {addr = self.tableInfo.table_addr, agree = agree, seat = selfSeat})
end

function PrivateRoomController:endRoom(  )
	
	self.viewHandler:showRoomResult()
	-- app:enterScene("LobbyScene")
end

local privateRoomController = PrivateRoomController:new()
return PrivateRoomController