local LocalScheduler = require("app.Common.LocalScheduler")

return {
	scheduler = LocalScheduler.new(),

	watching = false,
	game_status = false,

	-- table info as UpdateGameInfo
	max_chip = nil,
	base_chip = nil,
	op_time_cd = nil,
	tax_rate = nil,
	room_gold = 10000,

	raise_options = nil, -- the options when add/raise chip
	last_chip = 0,

	-- local seatId as key
	players = {},
}
