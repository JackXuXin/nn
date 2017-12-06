local BRNNScene = package.loaded["app.scenes.BRNNScene"] or {}

local message = require("app.net.Message")
local util = require("app.Common.util")
local ErrorLayer = require("app.layers.ErrorLayer")

local roomMsg = {}
local brnnMsg = {}
local handlers = { room=roomMsg, NN100=brnnMsg }

local Player = app.userdata.Player

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function BRNNScene:dispatch(name, msg)
	local clsName, funcName = name:match "([^.]*).(.*)"
	assert(handlers[clsName], clsName .. " handler not exist!")

	if clsName == "NN100" then
		--print("recv", name)
	end
	if handlers[clsName] then
		assert(handlers[clsName][funcName], clsName.."Mgr have no func: "..funcName)
		handlers[clsName][funcName](self, msg)
	end
end

-- send msg
function BRNNScene:sendLeaveGame()
	message.dispatchGame("room.LeaveGame")
end

function BRNNScene:HistoryReq()
	print("BRNNScene:HistoryReq")
	message.sendMessage("NN100.HistoryReq", { session = self.params.session })
end

function BRNNScene:RankListReq()
	print("BRNNScene:RankListReq")
	message.sendMessage("NN100.RankListReq", { session = self.params.session })
end

function BRNNScene:AskBet(index)
	print("BRNNScene:AskBet", index, self.params.isBanker, self.params.status, self.gameInfo.selectedBet)
	if not self.params.isBanker and self.params.status == 1 and self.gameInfo.selectedBet > 0 then
		message.sendMessage("NN100.AskBet", { 
			session = self.params.session, 
			opidx = index, 
			opval = self.gameInfo.selectedBet,
		})
	end
end

function BRNNScene:BankerListReq()
	print("BRNNScene:BankerListReq")
	message.sendMessage("NN100.BankerListReq", { session = self.params.session })
end

function BRNNScene:BankerReq(optype)
	print("BRNNScene:BankerReq", optype)
	message.sendMessage("NN100.BankerReq", { session = self.params.session, optype = optype })
end

-- receive brnn msg
function brnnMsg.UpdateBankerInfo(self, msg)
	self.params.banker = msg
	self:updateBankerInfo()

	local isBanker = false

	if msg.uid == Player.uid then
		isBanker = true
	end
	if isBanker ~= self.params.isBanker then
		self.params.isBanker = isBanker
		self:changeRoleLayer()
	end
end

function brnnMsg.HistoryRep(self, msg)
	self.params.history = msg.records
	self.params.historyGameId = self.params.gameId
	self:updateHistoryLayer()
end

function brnnMsg.RankListRep(self, msg)
	self.params.rank = msg.players

	table.sort(self.params.rank, function(a, b)
		return checkint(a.gold) > checkint(b.gold)
	end)

	self:updateRankLayer()
end

function brnnMsg.BankerListRep(self, msg)
	self.params.bankerList = msg.bankers
	self.params.minGold = msg.mingold
	self:updateBankerList()
end

function brnnMsg.BankerRep(self, msg)
	if msg.result == 0 then
		if self.bankerListLayer then 
			self:BankerListReq()
		end
	else 
		local error_str = util.error(msg.result)
		if error_str and #error_str > 0 then
			self:bankerReqError(error_str)
		end
    end
end

function brnnMsg.UpdateBetInfo(self, msg)
	-- dump(msg)
	print("brnnMsg.UpdateBetInfo", msg.betcount)
	self.gameInfo.chips = msg.betcount
	self.gameInfo.leftChips = msg.leftbet
	if msg.opuid == Player.uid then
		self.gameInfo.playerChips[msg.opidx] = self.gameInfo.playerChips[msg.opidx] + msg.opval
		self.gameInfo.playerSumChip = self.gameInfo.playerSumChip + msg.opval
	end

	self:updateBets(msg.opidx, msg.opval)
end

function brnnMsg.GameStatusNtf(self, msg)
	print("brnnMsg.GameStatusNtf", msg.status)
	dump(msg.yourbets)
	self.params.status = msg.status
	if msg.status == 1 then
		self.params.gameId = self.params.gameId + 1
		self.gameInfo:clear()
	end
	print("self.gameInfo.timeout:".. self.gameInfo.timeout)
	self.gameInfo.timeout = msg.timeout
	self.gameInfo.leftChips = msg.leftbet
	self.gameInfo.chips = msg.betcount
	self.gameInfo.playerChips = msg.yourbets
	self.gameInfo.cards = msg.cardids
	self.gameInfo.cardtypes = msg.types

	if msg.status == 1 then
		self:beginChipIn()
	elseif msg.status == 2 then
		self:beginOpenCard(false)
	end
end

function brnnMsg.ShowCard(self, msg)

   print("brnnMsg.GameEnd, msg.early", msg.early)
   local time = 0
	if msg.early then

      ErrorLayer.new(app.lang.brnn_earlyopen):addTo(self)
      time = 2.0
      
	end

	--local function schedulerFunction(dt)
     
     self.params.status = 2
	 self.gameInfo.timeout = msg.timeout

	 self.gameInfo.cards = msg.cardids
	 self.gameInfo.cardtypes = msg.types

	 self:beginOpenCard(true)

	--scheduler.unscheduleGlobal(self.handler)

    --end

    --self.handler = scheduler.scheduleGlobal(schedulerFunction, time)

end

function brnnMsg.GameEnd(self, msg)
	print("brnnMsg.GameEnd", "player gold:"..msg.yourgold, "banker gold:"..msg.bankergold, "banker score:"..msg.bankerscore)
	self.gameInfo.cards = msg.cardids
	self.gameInfo.cardtypes = msg.types
	self.gameInfo.result = msg

	dump(msg)
	
	if self.gameInfo.result.winners then
		table.sort(self.gameInfo.result.winners, function(a, b)
			return checkint(a.gain) > checkint(b.gain)
		end)
	end

	self.params.gold = msg.yourgold
	if self.params.banker then
		self.params.banker.gold = msg.bankergold
		self.params.banker.score = msg.bankerscore
	end

	self:checkShowResult()
end

-- receive room msg
function roomMsg.InitGameScenes(self, msg)
	self.params.session = msg.session
	self.params.roomId = msg.roomid
	self.params.seat = msg.seat
	self.params.entered = false
end

function roomMsg.EnterGame(self, msg)

	print("Brnn-roomMsg.EnterGame")
	dump(msg)
	if not self.params.entered and msg.seat == self.params.seat then
		self.params.entered = true
		self.params.gold = msg.player.gold
		self:updatePlayerInfo()
	end
end

function roomMsg.LeaveGame(self, msg)
	if self.params.seat == msg.seat then
		message.dispatchGame("room.ExitTable")
	end
end

function roomMsg.ReadyRep(self, msg) 

end

function roomMsg.Ready(self, msg)

end

return BRNNScene