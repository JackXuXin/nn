local BRNNConfig = {}

BRNNConfig.CardType = {
	[0] = "Image/BRNN/NiuType_bairen/game_niuniu_niu2.png",
	[1] = "Image/BRNN/NiuType_bairen/game_niuniu_niu3.png",
	[2] = "Image/BRNN/NiuType_bairen/game_niuniu_niu4.png",
	[3] = "Image/BRNN/NiuType_bairen/game_niuniu_niu5.png",
	[4] = "Image/BRNN/NiuType_bairen/game_niuniu_niu6.png",
	[5] = "Image/BRNN/NiuType_bairen/game_niuniu_niu7.png",
	[6] = "Image/BRNN/NiuType_bairen/game_niuniu_niu8.png",
	[7] = "Image/BRNN/NiuType_bairen/game_niuniu_niu9.png",
	[8] = "Image/BRNN/NiuType_bairen/game_niuniu_niu10.png",
	[9] = "Image/BRNN/NiuType_bairen/game_niuniu_niu11.png",
	[10] = "Image/BRNN/NiuType_bairen/game_niuniu_niu12.png",
	[11] = "Image/BRNN/NiuType_bairen/game_niuniu_niu13.png",
	[12] = "Image/BRNN/NiuType_bairen/game_niuniu_niu15.png",
	[13] = "Image/BRNN/NiuType_bairen/game_niuniu_niu14.png",
}

BRNNConfig.OpenCardPosition = {
	{ x = 740, y = 645 },
	{ x = 230, y = 230 },
	{ x = 530, y = 230 },
	{ x = 830, y = 230 },
	{ x = 1130, y = 230 },
}

BRNNConfig.DealCardPosition = {
	{ x = 760, y = 645 },
	{ x = 250, y = 230 },
	{ x = 550, y = 230 },
	{ x = 850, y = 230 },
	{ x = 1150, y = 230 },
}

BRNNConfig.BetsConfig = {
	{ gold = 100, image = "#Chip-100.png", sprite = "Counter100" },
	{ gold = 1000, image = "#Chip-1000.png", sprite = "Counter1000" },
	{ gold = 10000, image = "#Chip-10000.png", sprite = "Counter10000" },
	{ gold = 100000, image = "#Chip-100000.png", sprite = "Counter100000" },
	{ gold = 1000000, image = "#Chip-1000000.png", sprite = "Counter1000000" },
	{ gold = 5000000, image = "#Chip-5000000.png", sprite = "Counter5000000" },
}

return BRNNConfig