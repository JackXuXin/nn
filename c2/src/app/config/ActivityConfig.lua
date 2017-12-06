local config = {
	{
		appID="3550",	--旺旺余姚
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={3,4,5,6},
		activityRes={
			unselected = "Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		configJP = {},
	},
	
	
	{
		appID="3551",	--旺旺慈溪
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		--activityID={3,4,5,6},
		activityID={},
		activityRes={
			unselected = "Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		configJP = {},

	},
	{
		appID="3552",	--旺旺东阳
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={2,},
		activityRes={
			unselected = "Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		configJP = {},

	},
	{

		appID="3553",
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={2,},
		activityRes={
			unselected = "Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		actBtn = "Image/ActiviLayer/",
		configJP = {},

	},
	{

		appID="3554",
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={2,},
		activityRes={
			unselected = "Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		actBtn = "Image/ActiviLayer/",
		configJP = {},

	},
	{

		appID="3556",
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={2,},
		activityRes={
			unselected = "Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		actBtn = "Image/ActiviLayer/",
		configJP = {},

	},
	{

		appID="1801",	--金陵茶苑
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={2,3,4},
		activityRes={
			unselected = "Platform_Src/Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Platform_Src/Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		configJP = {},

	},
	{
		appID="1802",	--皇后山庄
		LuckyID={},
		jiangping = {	--奖品的信息

		},
		activityID={2,3},
		activityRes={
			unselected = "Platform_Src/Image/ActiviLayer/act_%d_name_unselected.png",
			selected = "Platform_Src/Image/ActiviLayer/act_%d_name.png"
		},
		image="Platform_Src/Image/ActiviLayer/act_%s_context.png",
		configJP = {},

	},
	
	getActConfig = function (self, appID)
		for _,v in ipairs(self) do
			if v.appID == appID then

				return v
			end
		end
		return nil
	end,
	getActID = function (self, appID,pos)
		print("getActID1")
		for _,v in ipairs(self) do
			print("getActID2")
			if v.appID == appID then
				print("getActID3")
				for k,s in pairs(v.configJP) do
					print("getActID4")
					if  s.pos==pos then
						print("getActID5")
						return s.id
					end
				end
				
			end
		end
		return nil
	end,
	getActPos = function (self, appID,ActID)
		print("getActID1")
		for _,v in ipairs(self) do
			print("getActID2")
			if v.appID == appID then
				print("getActID3")
				for k,s in pairs(v.configJP) do
					print("getActID4")
					if  s.id==ActID then
						print("getActID5")
						return s.pos
					end
				end
				
			end
		end
		return nil
	end,
	getConfigJP = function (self, appID,actID)
		for _,v in ipairs(self) do
			if v.appID == appID then
				for k,s in pairs(v.configJP) do
					if  s.id==actID then
						return s
					end
				end
				
			end
		end
		return nil
	end,
	-- getRewards = function (self, appID,actID)
	-- 	for _,v in ipairs(self) do
	-- 		if v.appID == appID then
	-- 			for k,s in pairs(v.configJP) do
	-- 				if  s.id==actID then
	-- 					return s.rewards
	-- 				end
	-- 			end
				
	-- 		end
	-- 	end
	-- 	return nil
	-- end,
}

return config