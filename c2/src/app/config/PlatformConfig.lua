local PlatConfig = {
	{

	    --../wwyy/
		appID = "3550" ,
		name = "旺旺余姚",
		public_id = "wwyuyao",

		game = {[1] = { Node_Name = "Game_sss",gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 7, IconPosY = 42,  IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png"  ,
			 dt_time = 1.5, starPosX = 77,starPosY = -60, length = 100},
				[2] = { Node_Name = "Game_nn",gameid = 116,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/nn_1.png", IconPosX = 0, IconPosY = 42, IconRes = "Platform_Src/Image/Lobby/GameIcons/nn_bg.png" ,
		     dt_time = 1.5 , starPosX = 113,starPosY = -61, length = 160},
				},
        gameIconBg = "Platform_Src/Image/Lobby/GameIcons/hua_%s.png",
        gameani = { [1] = "Platform_Src/Image/Lobby/GameIcons/img_Point2.png",[2] = "Platform_Src/Image/Lobby/GameIcons/img_LightPic.png" },

        actBtn = "Image/ActiviLayer/",

        wChat_Appid = "wx62af3cecbb4ebe04",

        share_Text_3 = "一次抽奖",

        activityImg = "http://wwimg.gametea.me/yuyao/activity.jpg",

	},

	{
		appID = "3551",
		name = "旺旺慈溪",
		public_id = "wwcixi",

		act = { [1] = "Platform_Src/Image/ActiviLayer/act_%s_context.png" ,[2] = 4},

		--1, 25

		game = { [1] = { gameid = 108 ,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/cxmj_2.png", IconPosX = 10, IconPosY = 20, IconRes = "Image/Lobby/GameIcons/cxmj_1.png" ,
	  			 dt_time = 1.2 , starPosX = 111,starPosY = -38},
				 [2] = { gameid = 111,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/ddz_2.png", IconPosX = 0, IconPosY = 20, IconRes = "Image/Lobby/GameIcons/ddz_1.png"  ,
				 dt_time = 2.8, starPosX = 133,starPosY = -36},
				 -- [3] = { gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 0, IconPosY = 20, IconRes = "Image/Lobby/GameIcons/sss_1.png" ,
				 -- dt_time = 0.95, starPosX = 95,starPosY = -26},
				 [3] = { gameid = 105,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/brnn.png", IconPosX = 3, IconPosY = 27, IconRes = "Platform_Src/Image/Lobby/GameIcons/wz_3.png" ,
				 dt_time = 1.1, starPosX = 101,starPosY = -26},
				 [4] = { gameid = 102,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/wz_2.png", IconPosX = 10, IconPosY = 20,  IconRes = "Image/Lobby/GameIcons/wz_1.png"  ,
				 dt_time = 2.5, starPosX = 72,starPosY = -26},

			   },


		Image_Girl = { res = "Image/Lobby/girl.png", posX = 225.39, posY = 356.14, },
		agentAniShow = false,

        gameIconBg = "Platform_Src/Image/Lobby/GameIcons/hua_%s.png",

        actBtn = "Image/ActiviLayer/",

        wChat_Appid = "wx3078da8981e17344",

        share_Text_3 = "一次抽奖",

        activityImg = "http://wwimg.gametea.me/cixi/activity.jpg",

        --loadingImg = { [1] = "http://wwimg.gametea.me/cixi/loading_1.jpg", [2] = "http://wwimg.gametea.me/cixi/loading_2.jpg", [3] = "http://wwimg.gametea.me/cixi/loading_3.jpg"}
	},

	{
		appID = "3552",
		name = "旺旺诸暨",
		public_id = "",
		act = { [1] = "Platform_Src/Image/ActiviLayer/act_%s_context.png" ,[2] = 1},
		game = {
				[1] = { Node_Name = "Game_sss",gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 7, IconPosY = 42,  IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png"  ,
					dt_time = 1.5, starPosX = 152,starPosY = -63, length = 160, Image_off="Image/Lobby/PrivateRoom/cb_sss_normal.png", Image_on = "Image/Lobby/PrivateRoom/cb_sss_select.png"},
				[2] = { Node_Name = "Game_nn",gameid = 116,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 0, IconPosY = 42, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
					dt_time = 1.5 , starPosX = 113,starPosY = -61, length = 130, Image_off="Image/Lobby/PrivateRoom/cb_nn_normal.png", Image_on = "Image/Lobby/PrivateRoom/cb_nn_select.png"},
				
			   },

		gameIconBg = "Platform_Src/Image/Lobby/GameIcons/hua_%s.png",
        gameani = { [1] = "Platform_Src/Image/Lobby/GameIcons/img_Point2.png",[2] = "Platform_Src/Image/Lobby/GameIcons/img_LightPic.png" },

		actBtn = "Image/ActiviLayer/",
		wChat_Appid = "wxa628140e38220162",
		share_Text_3 = "一次抽奖",
		activityImg = "http://wwimg.gametea.me/zhuji/activity.jpg",
		isAppStore = false,
		publick_btn = false

	},

	{
		appID = "3553",
		name = "旺旺上虞",
		public_id = "wwshangyu",

		-- game = {[1] = { Node_Name = "Game_sss",gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 7, IconPosY = 42,  IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png"  ,
		-- 	 dt_time = 1.5, starPosX = 77,starPosY = -60, length = 100},
		-- 		[2] = { Node_Name = "Game_symj",gameid = 101,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/mj_1.png", IconPosX = 7, IconPosY = 10, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
		--      dt_time = 1.5 , starPosX = 150,starPosY = -61, length = 160},

		-- 		 },
		game = {
				[1] = { Node_Name = "Game_sss",gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 7, IconPosY = 42,  IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png"  ,
					dt_time = 1.5, starPosX = 152,starPosY = -63, length = 160, Image_off="Image/Lobby/PrivateRoom/cb_sss_normal.png", Image_on = "Image/Lobby/PrivateRoom/cb_sss_select.png"},
				[2] = { Node_Name = "Game_symj",gameid = 101,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/mj_1.png", IconPosX = 7, IconPosY = 10, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
				    dt_time = 1.5 , starPosX = 77,starPosY = -60, length = 100, Image_off="Image/Lobby/PrivateRoom/cb_symj_normal.png", Image_on = "Image/Lobby/PrivateRoom/cb_symj_select.png"},
				[3] = { Node_Name = "Game_nn",gameid = 116,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 0, IconPosY = 42, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
					dt_time = 1.5 , starPosX = 113,starPosY = -61, length = 130, Image_off="Image/Lobby/PrivateRoom/cb_nn_normal.png", Image_on = "Image/Lobby/PrivateRoom/cb_nn_select.png"},
				[4] = { Node_Name = "Game_ddz",gameid = 110,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 0, IconPosY = 42, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
					dt_time = 1.5 , starPosX = 113,starPosY = -61, length = 130, Image_off="Image/Lobby/PrivateRoom/cb_ddz_normal.png", Image_on = "Image/Lobby/PrivateRoom/cb_ddz_select.png"},
			   },
        gameIconBg = "Platform_Src/Image/Lobby/GameIcons/hua_%s.png",
        gameani = { [1] = "Platform_Src/Image/Lobby/GameIcons/img_Point2.png",[2] = "Platform_Src/Image/Lobby/GameIcons/img_LightPic.png" },

        actBtn = "Image/ActiviLayer/",

        wChat_Appid = "wx482f1a5eff7a740e",

        share_Text_3 = "一次抽奖",

        activityImg = "http://wwimg.gametea.me/shaoxing/activity.jpg",

       -- loadingImg = { [1] = "http://wwimg.gametea.me/shaoxing/loading_1.jpg", [2] = "http://wwimg.gametea.me/shaoxing/loading_2.jpg", [3] = "http://wwimg.gametea.me/shaoxing/loading_3.jpg"},
		isAppStore = false,
	},

	{
		appID = "3554",
		name = "凯旋门",
		public_id = "",

		act = { [1] = "Platform_Src/Image/ActiviLayer/act_%s_context.png" ,[2] = 4},

	  	game = {[1] = { Node_Name = "Game_sss",gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 7, IconPosY = 42,  IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png"  ,
			 dt_time = 1.6, starPosX = 77,starPosY = -60, length = 100},
				[2] = { Node_Name = "Game_symj",gameid = 101,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/mj_1.png", IconPosX = 7, IconPosY = 10, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
		     dt_time = 1.6 , starPosX = 150,starPosY = -61, length = 160},

				 },

        gameIconBg = "Platform_Src/Image/Lobby/GameIcons/hua_%s.png",
        gameani = { [1] = "Platform_Src/Image/Lobby/GameIcons/img_Point2.png",[2] = "Platform_Src/Image/Lobby/GameIcons/img_LightPic.png" },

        actBtn = "Image/ActiviLayer/",

        wChat_Appid = "wx142362b02f2ca2a3",

        share_Text_3 = "一次抽奖",

        activityImg = "http://wwimg.gametea.me/kaixuanmen/activity.jpg",

        publick_btn = false

        --loadingImg = { [1] = "http://wwimg.gametea.me/cixi/loading_1.jpg", [2] = "http://wwimg.gametea.me/cixi/loading_2.jpg", [3] = "http://wwimg.gametea.me/cixi/loading_3.jpg"}

	},
	{
		appID = "3556",
		name = "一品罗松",
		public_id = "",

		game = {[1] = { Node_Name = "Game_sss",gameid = 106,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/sss_2.png", IconPosX = 7, IconPosY = 42,  IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png"  ,
			 dt_time = 1.6, starPosX = 77,starPosY = -60, length = 100},
				[2] = { Node_Name = "Game_symj",gameid = 101,Image_Icon = "Platform_Src/Image/Lobby/GameIcons/mj_1.png", IconPosX = 7, IconPosY = 10, IconRes = "Platform_Src/Image/Lobby/GameIcons/sss_bg.png" ,
		     dt_time = 1.6 , starPosX = 150,starPosY = -61, length = 160},

				 },

		gameIconBg = "Platform_Src/Image/Lobby/GameIcons/hua_%s.png",
        gameani = { [1] = "Platform_Src/Image/Lobby/GameIcons/img_Point2.png",[2] = "Platform_Src/Image/Lobby/GameIcons/img_LightPic.png" },

		actBtn = "Image/ActiviLayer/",
		wChat_Appid = "wx1e2d5cb9a081a652",
		share_Text_3 = "一次抽奖",
		activityImg = "http://wwimg.gametea.me/shaoxing/activity.jpg",
		isAppStore = false,
		publick_btn = false

	},

	getPlatConfig = function (self, appID)
		for _,v in ipairs(self) do
			if v.appID == appID then

				--add config
				v.Image_logo = "Platform_Src/Image/Logon/logo.png"
				v.serviceIcon = "Platform_Src/Image/Common/Avatar/serviceIcon.png"
				v.logo_small = "Platform_Src/Image/Lobby/logo_small.png"
				v.word_1 = "Platform_Src/Image/Lobby/GameIcons/%s_word_1.png"
				v.word = "Platform_Src/Image/Lobby/GameIcons/%s_word.png"
				v.share = "Platform_Src/Image/Lobby/share.png"

				v.freeGoldLayer_Text_9 = "关注" .. tostring(v.name) .."唯一公众号 ".. tostring(v.public_id) .."了解活动详情，所有活动最终解释权归" .. tostring(v.name) .."所有"
			    v.noticeLayer_Text_1 = "唯一微信公众号：" .. tostring(v.public_id)
				v.serviceLayer_Text_2 = "欢迎您给" .. tostring(v.name) .."提出任何意见和建议，我们将非常重视，谢谢您！"
				v.shareLayer_Text_4 = "更多活动请关注公众号" .. tostring(v.public_id)
				v.shareRespName = "领取兑换码到微信公众号".. tostring(v.public_id) .. "\n活动专区参加现金红包活动"

				return v
			end
		end
		return nil
	end,

}

return PlatConfig