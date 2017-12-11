local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local sound_common = require("app.Common.sound_common")
local crypt = require("crypt")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local ErrorLayer = require("app.layers.ErrorLayer")

local PRMessage = require("app.net.PRMessage")
local UserMessage = require("app.net.UserMessage")
local PRConfig = require("app.config.PrivateRoomConfig")

local AvatarConfig = require("app.config.AvatarConfig")
local util = require("app.Common.util")
local PlatConfig = require("app.config.PlatformConfig")
local ProgressLayer = require("app.layers.ProgressLayer")
local code = require("app.Common.code")
local MatchMessage = require("app.net.MatchMessage")
local page_type = nil

local ROOM_CONTENT_POS = {x=115,y=0}

--[[ --
    * 设置显示界面类型
--]]
function LobbyScene:setPrivateRoomType(page, gameID)
	page_type = page
    PRMessage.EnterPrivateRoomReq(nil)
	--UserMessage.CheckReconnectReq()

	app.constant.isOpening = false
end



--[[ --
    * 显示界面
--]]
function LobbyScene:showPrivateRoom(page)
	

	page = page or page_type
	if page == "create" or page == "" or not page then
		self:showCreateMenu()
	else
		self:showLoginRoom()
	end
end

--[[ --
    * 执行标题动作
--]]
local function _play_title_action(nd_title)
	--小鸟动作
	local ui_bird = cc.uiloader:seekNodeByNameFast(nd_title, "img_bird")
	nd_title:schedule(function()
		ui_bird:runAction(cca.blink(0.4,4))
	end, 5)

	--箭头动作
	local color = false
	nd_title:schedule(function()
		color = not color

		for i=1,4 do
			if color then
				if i == 1 or i == 3 then
					cc.uiloader:seekNodeByNameFast(nd_title, "img_guang_" .. i)
						:setSpriteFrame(cc.SpriteFrame:create("Image/Lobby/PrivateRoom/img_arrow_lan.png",cc.rect(0,0,27,42)))
				else
					cc.uiloader:seekNodeByNameFast(nd_title, "img_guang_" .. i)
						:setSpriteFrame(cc.SpriteFrame:create("Image/Lobby/PrivateRoom/img_arrow_hui.png",cc.rect(0,0,27,42)))					
				end
			else
				if i == 2 or i == 4 then
					cc.uiloader:seekNodeByNameFast(nd_title, "img_guang_" .. i)
						:setSpriteFrame(cc.SpriteFrame:create("Image/Lobby/PrivateRoom/img_arrow_fen.png",cc.rect(0,0,27,42)))
				else
					cc.uiloader:seekNodeByNameFast(nd_title, "img_guang_" .. i)
						:setSpriteFrame(cc.SpriteFrame:create("Image/Lobby/PrivateRoom/img_arrow_hui.png",cc.rect(0,0,27,42)))					
				end
			end
		end
	end, 0.2)

	--灯泡动作
	local count = 1
	nd_title:schedule(function()
		for i=0,4 do
			local img_deng = cc.uiloader:seekNodeByNameFast(nd_title, "img_deng_" .. i)
			if i == count%5 or i == (count+2)%5 then
				img_deng:show()
			else
				img_deng:hide()
			end
		end

		count = count + 1
	end, 0.5)
end

--[[ --
    * 隐藏所有开房界面
--]]
local function _hide_all_content(self)
	if self.createRoomLayer.symj_content then self.createRoomLayer.symj_content:hide() end
	if self.createRoomLayer.sss_content then self.createRoomLayer.sss_content:hide() end
	if self.createRoomLayer.nn_content then self.createRoomLayer.nn_content:hide() end
	if self.createRoomLayer.ddz_content then self.createRoomLayer.ddz_content:hide() end
end

--[[ --
    * 创建SYMJ开房界面
--]]
local function _create_symj_content(self, param)
	local roomInfo = GameData.symjRoomInfo or {}
	-- dump(roomInfo,"symjRoomInfo")

	--显示已经创建过的界面	
	if self.createRoomLayer.symj_content then
		self.createRoomLayer.symj_content:show()
		return
	end

	--创建symj开房界面
	local ui_SYMJ = cc.uiloader:load("Node/createRoom/symj_content.json")
		:pos(ROOM_CONTENT_POS.x, ROOM_CONTENT_POS.y)
		:addTo(self.createRoomLayer.nd_all)
	self.createRoomLayer.symj_content = ui_SYMJ

	--滑块
	local scroll_view = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "scroll_view")
	scroll_view.sbV = display.newScale9Sprite("Image/Lobby/PrivateRoom/content/img_tiao.png", 0,0,cc.size(9,420)):addTo(scroll_view):hide()
	scroll_view.offsetV = true

	local roomid = param.roomid 					--房间ID
	local seats = 2 								--玩家人数
	local round = 16  								--游戏局数
	local mode = 1 									--支付类型 1 = 房主支付 2 = AA支付
	local hua_type = 2								--底花
	local is_chao = 1								--是否超一进十
	local base = param.customization.base[1]  		--低分
	local count = param.customization.count[1]	 	--初始分数
	local rule = 0 									--规则位图

	--刷新开房价格
	local function showGoldNum(mode, seats)
		for k,v in pairs(param.cost) do
			local cval = v.cval
			if mode == 1 then
				cval = cval * seats
			end


			cc.uiloader:seekNodeByNameFast(ui_SYMJ, "ta_DNumber" .. k):setString("X" .. tostring(cval) .. " ）")
		end
	end

	--选择椅子数---
	local CheckBox_SeatCnt_4 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_SeatCnt_4")
	local CheckBox_SeatCnt_2 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_SeatCnt_2")

	local function seatSelected(button)
		seats = button.seats

		showGoldNum(mode, seats)
	end

	local group_1 = RadioButtonGroup.new({
		[CheckBox_SeatCnt_4] = seatSelected,
		[CheckBox_SeatCnt_2] = seatSelected,
	})
	CheckBox_SeatCnt_4.seats = 4
	CheckBox_SeatCnt_2.seats = 2

	local node_1 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "node_1")
	CheckBox_SeatCnt_4.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_2")
	CheckBox_SeatCnt_2.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_1")

	--默认4人
	if roomInfo.seats == 2 then
		CheckBox_SeatCnt_2:setButtonSelected(true)
	elseif roomInfo.seats == 4 then
		CheckBox_SeatCnt_4:setButtonSelected(true)
	else
		CheckBox_SeatCnt_4:setButtonSelected(true)
	end

	----------------------------------------


	--选择局数---
	local CheckBox_RoomType_1 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_RoomType_1")
	local CheckBox_RoomType_2 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_RoomType_2")
	local CheckBox_RoomType_3 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_RoomType_3")

	local function roomSelected(button)
		round = button.round
	end

	local group_2 = RadioButtonGroup.new({
		[CheckBox_RoomType_1] = roomSelected,
		[CheckBox_RoomType_2] = roomSelected,
		[CheckBox_RoomType_3] = roomSelected,
	})

	CheckBox_RoomType_1.round = 8
	CheckBox_RoomType_2.round = 16
	CheckBox_RoomType_3.round = 24

	local node_2 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "node_2")
	CheckBox_RoomType_1.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_1")
	CheckBox_RoomType_2.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_2")
	CheckBox_RoomType_3.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_3")

	--默认选择8局
	if roomInfo.round == 8 then
		CheckBox_RoomType_1:setButtonSelected(true)
	elseif roomInfo.round == 16 then
		CheckBox_RoomType_2:setButtonSelected(true)
	elseif roomInfo.round == 24 then
		CheckBox_RoomType_3:setButtonSelected(true)
	else
		CheckBox_RoomType_1:setButtonSelected(true)
	end

	----------------------------------------

	--支付方式选择---
	local CheckBox_Room_Pay_Type_1 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_Room_Pay_Type_1")
	local CheckBox_Room_Pay_Type_2 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_Room_Pay_Type_2")

	local function room_pay_type_selected(button)
		mode = button.mode

		showGoldNum(mode, seats)
	end

	local group_3 = RadioButtonGroup.new({
		[CheckBox_Room_Pay_Type_1] = room_pay_type_selected,
		[CheckBox_Room_Pay_Type_2] = room_pay_type_selected,
	})

	CheckBox_Room_Pay_Type_1.mode = 1
	CheckBox_Room_Pay_Type_2.mode = 2

	local node_3 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "node_3")
	CheckBox_Room_Pay_Type_1.text = cc.uiloader:seekNodeByNameFast(node_3, "tx_zi_2")
	CheckBox_Room_Pay_Type_2.text = cc.uiloader:seekNodeByNameFast(node_3, "tx_zi_1")

	--默认房主支付
	if roomInfo.mode == 1 then
		CheckBox_Room_Pay_Type_1:setButtonSelected(true)
	elseif roomInfo.mode == 2 then
		CheckBox_Room_Pay_Type_2:setButtonSelected(true)
	else
		CheckBox_Room_Pay_Type_1:setButtonSelected(true)
	end

	----------------------------------------

	--底花选择---
	local Button_right = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "Button_right")
	local Button_left = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "Button_left")
	local Image_seleHua = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "Image_seleHua")

	local function hua_type_selected(hua)
		hua_type = hua_type + hua

		if hua_type > 5 then
			hua_type = 2
		end

		if hua_type < 2 then
			hua_type = 5
		end

		Image_seleHua:setTexture("Image/PrivateRoom/img_H" .. hua_type .. ".png" )
	end

	Button_right:onButtonClicked(function()  hua_type_selected(1)  end)
	Button_left:onButtonClicked(function()  hua_type_selected(-1)  end)

	--默认2花
	if roomInfo.hua_type and roomInfo.hua_type >= 2 and roomInfo.hua_type <= 5 then
		hua_type = roomInfo.hua_type
		Image_seleHua:setTexture("Image/PrivateRoom/img_H" .. hua_type .. ".png" )
	end

	----------------------------------------


	--承包 
	cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_baozi"):setButtonEnabled(false)

	--豹子
	cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_chengbao"):setButtonEnabled(false)

	--超一进十---
	local CheckBox_chaoyjs = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "CheckBox_chaoyjs")

	local Button_Wen = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "Button_Wen")
	local img_WenTip = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "img_WenTip")
	local isShow = false
	img_WenTip:hide()

	Button_Wen:onButtonPressed(
		function()
			if app.constant.isOpening == true then
				return
			end
			img_WenTip:show()
			util.setMenuAni(img_WenTip)
		end
	)
	Button_Wen:onButtonRelease(
		function()
			img_WenTip:hide()
		end
	)

	--超一进十回调
	local function room_chao_type_selected(event)
		if event.target:isButtonSelected() then
			is_chao = 1

			CheckBox_chaoyjs.text:setColor(cc.c3b(255,216,0))			
		else
			is_chao = 0

			CheckBox_chaoyjs.text:setColor(cc.c3b(255,255,255))
		end
	end

	local node_6 = cc.uiloader:seekNodeByNameFast(ui_SYMJ, "node_6")
	CheckBox_chaoyjs.text = cc.uiloader:seekNodeByNameFast(node_6, "tx_zi_2")

	CheckBox_chaoyjs:onButtonStateChanged(room_chao_type_selected)

	--默认超一进十
	if roomInfo.is_chao == 0 then
		is_chao = 0
		CheckBox_chaoyjs:setButtonSelected(false)
	elseif roomInfo.is_chao == 1 then
		CheckBox_chaoyjs:setButtonSelected(true)
	else
		CheckBox_chaoyjs:setButtonSelected(true)
	end

	----------------------------------------


	--创建按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(ui_SYMJ, "btn_create_room"))
		:onButtonClicked(function()
			local strHua = ""
			for i = 4, 1, -1 do
				local str = "0"
				if i == (hua_type-1) then
					str = "1"
				end

				strHua = strHua .. str
			end

			local customStr = strHua .. is_chao
			rule = tonumber(customStr, 2)
			print(
				"房间ID = " .. roomid,
				"支付方式 = " .. mode,
				"房间局数 = " .. round,
				"房间人数 = " .. seats,
				"房间低分 = " .. base,
				"房间初始分数 = " .. count,
				"房间花类型" .. hua_type,
				"是否加一进十 = " .. is_chao,
				"位图规则 = " .. rule
			)
			PRMessage.PrivateRoomCreateReq(roomid, mode, round, seats, base, count, rule)

			--记录开房信息
			local roomInfo = {
				seats = seats,				--人数
				round = round,				--局数
				mode = mode,				--支付方式
				hua_type = hua_type,		--花类型
				is_chao = is_chao,			--是否加一进十
			}
			util.GameStateSave('symjRoomInfo',roomInfo)
		end)
end

--[[ --
    * 创建SSS开房界面
--]]
local function _create_sss_content(self, param)
	local roomInfo = GameData.sssRoomInfo or {}
	-- dump(roomInfo,"sssRoomInfo")

	--显示已经创建过的界面
	if self.createRoomLayer.sss_content then
		self.createRoomLayer.sss_content:show()
		return
	end

	--创建sss开房界面
	local ui_SSS = cc.uiloader:load("Node/createRoom/sss_content.json")
	:pos(ROOM_CONTENT_POS.x, ROOM_CONTENT_POS.y)
	:addTo(self.createRoomLayer.nd_all)
	self.createRoomLayer.sss_content = ui_SSS

	--滑块
	-- local scroll_view = cc.uiloader:seekNodeByNameFast(ui_SSS, "scroll_view")
	-- scroll_view.sbV = display.newScale9Sprite("Image/Lobby/PrivateRoom/content/bar.png", 0,0,cc.size(12,38)):addTo(scroll_view):hide()
	-- scroll_view.offsetV = true

	local roomid = param.roomid 						--房间ID
	local mode = 1 									--支付类型 1 = 房主支付 2 = AA支付
	local round = 0  								--游戏局数
	local seats = 0 								--玩家人数
	local base = param.customization.base[1]  		--低分
	local count = param.customization.count[1]	 	--初始分数	
	local rule = 0 		

	local create_room_is_add_color_king = 1  		--是否加一色  1 = 不加  2 = 加一色  4 = 加一王 8 = 加两王
	local create_room_is_add_fly = 32  				--是否加苍蝇  32 = 不加  64 = 黑桃10  128 = 红桃5

	-- --刷新开房价格
	local function showGoldNum(mode, seats)
		for k,v in pairs(param.cost) do
			local cval = v.cval
			if mode == 1 then
				cval = cval * seats
			end

			cc.uiloader:seekNodeByNameFast(ui_SSS, "tx_diamonds_" .. k):setString("X" .. tostring(cval) .. " ）")
		end
	end

	-- --选择椅子数---
	local CheckBox_Room_Player_Num_1 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Player_Num_1")
	local CheckBox_Room_Player_Num_2 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Player_Num_2")
	local CheckBox_Room_Player_Num_3 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Player_Num_3")
	local CheckBox_Room_Player_Num_4 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Player_Num_4")

	--房间游戏人数选择
	local function room_player_num_selected(button)
		seats = button.seats

		showGoldNum(mode, seats)
	end

	local group_1 = RadioButtonGroup.new({
		[CheckBox_Room_Player_Num_1] = room_player_num_selected,
		[CheckBox_Room_Player_Num_2] = room_player_num_selected,
		[CheckBox_Room_Player_Num_3] = room_player_num_selected,
		[CheckBox_Room_Player_Num_4] = room_player_num_selected,
	})

	CheckBox_Room_Player_Num_1.seats = 2
	CheckBox_Room_Player_Num_2.seats = 3
	CheckBox_Room_Player_Num_3.seats = 4
	CheckBox_Room_Player_Num_4.seats = 5

	local node_1 = cc.uiloader:seekNodeByNameFast(ui_SSS, "node_1")
	CheckBox_Room_Player_Num_1.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_1")
	CheckBox_Room_Player_Num_2.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_2")
	CheckBox_Room_Player_Num_3.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_3")

	--默认4人
	if roomInfo.seats == 2 then
		CheckBox_Room_Player_Num_1:setButtonSelected(true)
	elseif roomInfo.seats == 3 then
		CheckBox_Room_Player_Num_2:setButtonSelected(true)
	elseif roomInfo.seats == 4 then
		CheckBox_Room_Player_Num_3:setButtonSelected(true)
	elseif roomInfo.seats == 5 then
		CheckBox_Room_Player_Num_4:setButtonSelected(true)
	else
		CheckBox_Room_Player_Num_3:setButtonSelected(true)
	end

	----------------------------------------------


	--选择局数---
	local CheckBox_Room_Game_Num_1 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Game_Num_1")
	local CheckBox_Room_Game_Num_2 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Game_Num_2")
	local CheckBox_Room_Game_Num_3 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Game_Num_3")

	--房间局数选择
	local function room_game_num_selected(button)
		round = button.round
	end

	local group_2 = RadioButtonGroup.new({
		[CheckBox_Room_Game_Num_1] = room_game_num_selected,
		[CheckBox_Room_Game_Num_2] = room_game_num_selected,
		[CheckBox_Room_Game_Num_3] = room_game_num_selected,
	})

	CheckBox_Room_Game_Num_1.round = 8
	CheckBox_Room_Game_Num_2.round = 16
	CheckBox_Room_Game_Num_3.round = 24

	local node_2 = cc.uiloader:seekNodeByNameFast(ui_SSS, "node_2")
	CheckBox_Room_Game_Num_1.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_1")
	CheckBox_Room_Game_Num_2.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_2")
	CheckBox_Room_Game_Num_3.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_3")


	--默认16局
	if roomInfo.round == 8 then
		CheckBox_Room_Game_Num_1:setButtonSelected(true)
	elseif roomInfo.round == 16 then
		CheckBox_Room_Game_Num_2:setButtonSelected(true)
	elseif roomInfo.round == 24 then
		CheckBox_Room_Game_Num_3:setButtonSelected(true)
	else
		CheckBox_Room_Game_Num_2:setButtonSelected(true)
	end

	----------------------------------------------


	--支付方式---
	local CheckBox_Room_Pay_Type_1 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Pay_Type_1")
	local CheckBox_Room_Pay_Type_2 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Pay_Type_2")

	--支付方式选择
	local function room_pay_type_selected(button)
		mode = button.mode

		showGoldNum(mode, seats)
	end

	local group_3 = RadioButtonGroup.new({
		[CheckBox_Room_Pay_Type_1] = room_pay_type_selected,
		[CheckBox_Room_Pay_Type_2] = room_pay_type_selected,
	})

	CheckBox_Room_Pay_Type_1.mode = 1
	CheckBox_Room_Pay_Type_2.mode = 2

	local node_3 = cc.uiloader:seekNodeByNameFast(ui_SSS, "node_3")
	CheckBox_Room_Pay_Type_1.text = cc.uiloader:seekNodeByNameFast(node_3, "tx_zi_2")
	CheckBox_Room_Pay_Type_2.text = cc.uiloader:seekNodeByNameFast(node_3, "tx_zi_1")

	--默认AA支付
	if roomInfo.mode == 1 then
		CheckBox_Room_Pay_Type_1:setButtonSelected(true)
	elseif roomInfo.mode == 2 then
		CheckBox_Room_Pay_Type_2:setButtonSelected(true)
	else
		CheckBox_Room_Pay_Type_2:setButtonSelected(true)
	end

	----------------------------------------------


	--加一色 加1王 加2王---
	local CheckBox_Room_Add_Color = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Add_Color")
	local CheckBox_Room_Add_king_2 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Add_king_2")
	local CheckBox_Room_Add_king_4 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Add_king_4")

	--加一色 加1王 加2王 选择
	local function room_add_color_king_selected(event)
		if event.target:isButtonSelected() and event.target == CheckBox_Room_Add_Color then
			CheckBox_Room_Add_king_2:setButtonSelected(false)
			CheckBox_Room_Add_king_4:setButtonSelected(false)

			CheckBox_Room_Add_Color.text:setColor(cc.c3b(255,216,0))

			create_room_is_add_color_king = 2
		elseif event.target:isButtonSelected() and event.target == CheckBox_Room_Add_king_2 then
			CheckBox_Room_Add_Color:setButtonSelected(false)
			CheckBox_Room_Add_king_4:setButtonSelected(false)

			CheckBox_Room_Add_king_2.text:setColor(cc.c3b(255,216,0))

			create_room_is_add_color_king = 4		
		elseif event.target:isButtonSelected() and event.target == CheckBox_Room_Add_king_4 then
			CheckBox_Room_Add_Color:setButtonSelected(false)
			CheckBox_Room_Add_king_2:setButtonSelected(false)

			CheckBox_Room_Add_king_4.text:setColor(cc.c3b(255,216,0))

			create_room_is_add_color_king = 8
		else
			create_room_is_add_color_king = 1

			CheckBox_Room_Add_Color.text:setColor(cc.c3b(255,255,255))
			CheckBox_Room_Add_king_2.text:setColor(cc.c3b(255,255,255))
			CheckBox_Room_Add_king_4.text:setColor(cc.c3b(255,255,255))
		end
	end

	local node_4 = cc.uiloader:seekNodeByNameFast(ui_SSS, "node_4")
	CheckBox_Room_Add_Color.text = cc.uiloader:seekNodeByNameFast(node_4, "tx_zi_1")
	CheckBox_Room_Add_king_2.text = cc.uiloader:seekNodeByNameFast(node_4, "tx_zi_2")
	CheckBox_Room_Add_king_4.text = cc.uiloader:seekNodeByNameFast(node_4, "tx_zi_3")

	CheckBox_Room_Add_Color:onButtonStateChanged(room_add_color_king_selected)
	CheckBox_Room_Add_king_2:onButtonStateChanged(room_add_color_king_selected)
	CheckBox_Room_Add_king_4:onButtonStateChanged(room_add_color_king_selected)

	--默认加一色
	if roomInfo.color == 1 then
		--不加色
		create_room_is_add_color_king = 1
	elseif roomInfo.color == 2 then
		CheckBox_Room_Add_Color:setButtonSelected(true)
	elseif roomInfo.color == 4 then
		CheckBox_Room_Add_king_2:setButtonSelected(true)
	elseif roomInfo.color == 8 then
		CheckBox_Room_Add_king_4:setButtonSelected(true)
	else
		CheckBox_Room_Add_Color:setButtonSelected(true)
	end

	----------------------------------------------


	--加苍蝇---
	local CheckBox_Room_Add_Fly_10 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Add_Fly_10")
	local CheckBox_Room_Add_Fly_5 = cc.uiloader:seekNodeByNameFast(ui_SSS, "CheckBox_Room_Add_Fly_5")
	--加苍蝇选择
	local function room_add_fly_selected(event)
		if event.target:isButtonSelected() and event.target == CheckBox_Room_Add_Fly_10 then
			CheckBox_Room_Add_Fly_5:setButtonSelected(false)

			CheckBox_Room_Add_Fly_10.text:setColor(cc.c3b(255,216,0))			

			create_room_is_add_fly = 64
		elseif event.target:isButtonSelected() and event.target == CheckBox_Room_Add_Fly_5 then
			CheckBox_Room_Add_Fly_10:setButtonSelected(false)

			CheckBox_Room_Add_Fly_5.text:setColor(cc.c3b(255,216,0))
			
			create_room_is_add_fly = 128
		else
			create_room_is_add_fly = 32

			CheckBox_Room_Add_Fly_10.text:setColor(cc.c3b(255,255,255))
			CheckBox_Room_Add_Fly_5.text:setColor(cc.c3b(255,255,255))
		end
	end

	local node_4 = cc.uiloader:seekNodeByNameFast(ui_SSS, "node_4")
	CheckBox_Room_Add_Fly_10.text = cc.uiloader:seekNodeByNameFast(node_4, "tx_zi_4")
	CheckBox_Room_Add_Fly_5.text = cc.uiloader:seekNodeByNameFast(node_4, "tx_zi_5")

	CheckBox_Room_Add_Fly_10:onButtonStateChanged(room_add_fly_selected)
	CheckBox_Room_Add_Fly_5:onButtonStateChanged(room_add_fly_selected)

	--默认加苍蝇 红五
	if roomInfo.fly == 32 then
		--不加苍蝇
		create_room_is_add_fly = 32
	elseif roomInfo.fly == 64 then
		CheckBox_Room_Add_Fly_10:setButtonSelected(true)
	elseif roomInfo.fly == 128 then
		CheckBox_Room_Add_Fly_5:setButtonSelected(true)
	else
		CheckBox_Room_Add_Fly_5:setButtonSelected(true)	
	end

	----------------------------------------------

	--创建按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(ui_SSS, "btn_create_room"))
		:onButtonClicked(function()
			print(
				"房间ID = " .. roomid,
				"支付方式 = " .. mode,
				"房间局数 = " .. round,
				"房间人数 = " .. seats,
				"房间低分 = " .. base,
				"房间初始分数 = " .. count,
				"是否加色 or 王 = " .. create_room_is_add_color_king,
				"是否加苍蝇 = " .. create_room_is_add_fly
			)
			rule = create_room_is_add_color_king + create_room_is_add_fly
			PRMessage.PrivateRoomCreateReq(roomid, mode, round, seats, base, count, rule)

			--记录开房信息
			local roomInfo = {
				seats = seats,									--人数
				round = round,									--局数
				mode = mode,									--支付方式
				color = create_room_is_add_color_king,			--加一色
				fly = create_room_is_add_fly,					--苍蝇
			}
			util.GameStateSave('sssRoomInfo',roomInfo)
		end)
end

--[[ --
    * 创建NN开房界面
--]]
local function _create_nn_content(self, cfg)

	local param  =  GameData.niuniuRoomInfo
	if  param == nil then
	 	 param = {}
	 	 --设置默认值
	 	 param.bankerType={1,0,0,0}
	     param.baseScoreType={1,0,0}
	     param.doubleType={0,1}
	     param.bankscoreType={1,0,0,0}
	     param.specialType = {[1]=0,[2]=0,[3]=0}   --特殊牌型
	     param.setting={[1]=0,[2]=0}               --高级设置
	     param.seatCount = 3
	     param.baseScoreType2 = 0
	     param.roundType = 10
	     param.hostplay = false

	     --print("---------------本地没有初始房间信息------------")
	 
	end
    

    --显示已经创建过的界面
	if self.createRoomLayer.nn_content then
		self.createRoomLayer.nn_content:show()
		return
	end

	--创建nn开房界面
	local createMenu = cc.uiloader:load("Node/createRoom/nn_content.json")
	:pos(ROOM_CONTENT_POS.x, ROOM_CONTENT_POS.y)
	:addTo(self.createRoomLayer.nd_all)
	self.createRoomLayer.nn_content = createMenu



    --滚动视图
    local ItemContaner = cc.uiloader:seekNodeByNameFast(createMenu, "ItemContaner")
    ItemContaner.sbV = display.newScale9Sprite("Image/Lobby/PrivateRoom/content/img_tiao.png",0,0,cc.size(9,410)):hide():addTo(ItemContaner)
	ItemContaner.offsetV = true
    local item_4 = cc.uiloader:seekNodeByNameFast(createMenu, "item_4")
    local item_5 = cc.uiloader:seekNodeByNameFast(createMenu, "item_5")
    local item_6 = cc.uiloader:seekNodeByNameFast(createMenu, "item_6")
    local item_7 = cc.uiloader:seekNodeByNameFast(createMenu, "item_7")
     

   -- local PayCostText_2    = cc.uiloader:seekNodeByNameFast(createMenu, "PayCostText_2") --AA
   -- local PayCostText_1    = cc.uiloader:seekNodeByNameFast(createMenu, "PayCostText_1")  
    
    --刷新开房价格
	local function showGoldNum(mode, seats)
		for k,v in pairs(cfg.cost) do
			local cval = v.cval
			if mode == 1 then
				cval = cval * seats
			end

           print(k,v)
			cc.uiloader:seekNodeByNameFast(createMenu, "PayCostText_" .. k):setString("X" .. tostring(cval))
		end
	end
    
    --local AA_Base ={[10]=cfg.cost[1].cval,[20]=cfg.cost[2].cval}  
 
    --[[玩法类型按钮]]
     local btn_bks= {}  
    for i =1,4 do         
          local Btn_Bk = cc.uiloader:seekNodeByNameFast(createMenu, string.format("CheckBox_banker_%d",i))      
              Btn_Bk.bankerType = i-1
              btn_bks[i] = Btn_Bk 
          Btn_Bk.text =  cc.uiloader:seekNodeByNameFast(createMenu, string.format("Text_banker_%d",i))           
          
    end
      
    local function bank_selected(button)
        --print("bankType "..button.bankerType)

        for i=1,4 do
        	if (i-1) == button.bankerType then
        	    param.bankerType[i] = 1
        	else
        		 param.bankerType[i] =0
        	end
        	
        end
        if button.bankerType == 1 then  -- 固定庄家 
            item_4:show()
            item_5:setPositionY(-41)
            item_6:setPositionY(-196)
            item_7:setPositionY(-275)
			param.hostplay = true
        else
            item_4:hide()
            item_5:setPositionY(-41+79)
            item_6:setPositionY(-196+79)
            item_7:setPositionY(-275+79)
			param.hostplay = false
        end

    end
    local btn_bk_group = RadioButtonGroup.new({
		  [ btn_bks[1] ] = bank_selected,
    	  [ btn_bks[2] ] = bank_selected,
    	  [ btn_bks[3] ] = bank_selected,
    	  [ btn_bks[4] ] = bank_selected,
     })
     
     --设置默认值
     for i=1,4 do
     	--print("玩法 "..i.."/"..param.bankerType[i])
     	if param.bankerType[i] == 1 then
     		btn_bks[i]:setButtonSelected(true)    		
     	end     	
     end

    --人数选择
    local SeatCountBtns={}

		 SeatCountBtns[1] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_SeatCount_1")
		 SeatCountBtns[2] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_SeatCount_2")
		 SeatCountBtns[3] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_SeatCount_3")
		 SeatCountBtns[4] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_SeatCount_4")

		 SeatCountBtns[1].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_SeatCount_1")
		 SeatCountBtns[2].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_SeatCount_2")
		 SeatCountBtns[3].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_SeatCount_3")
		 SeatCountBtns[4].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_SeatCount_4")

		 SeatCountBtns[1].seatCount =3
		 SeatCountBtns[2].seatCount =4
		 SeatCountBtns[3].seatCount =5 
		 SeatCountBtns[4].seatCount =6 

    local function seatcount_selected(button)
       -- print("seatCount "..button.seatCount)
       -- closeTipLayer()
        param.seatCount = button.seatCount
        if param.roundType == nil then
        	param.roundType =10
        end
       -- PayCostText_2:setString("x"..AA_Base[param.roundType])
       -- PayCostText_1:setString("x"..button.seatCount * AA_Base[param.roundType])
       showGoldNum(param.paymode, param.seatCount)

    end

    local btn_seatCount_group = RadioButtonGroup.new({
		  [ SeatCountBtns[1] ] = seatcount_selected,
    	  [ SeatCountBtns[2] ] = seatcount_selected,
    	  [ SeatCountBtns[3] ] = seatcount_selected,
    	  [ SeatCountBtns[4] ] = seatcount_selected,
     })
    
    --设置默认值
   	SeatCountBtns[param.seatCount -2 ]:setButtonSelected(true)
  
   
    --底分选择按钮
    -- local baseScoreBtns={}
    -- local baseScoreTexts={}

		 -- baseScoreBtns[1] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BaseScore_1")
		 -- baseScoreBtns[2] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BaseScore_2")
		 -- baseScoreBtns[3] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BaseScore_3")

    --       baseScoreTexts[0] = cc.uiloader:seekNodeByNameFast(createMenu, "BankScore_2")
		 -- baseScoreTexts[1] = cc.uiloader:seekNodeByNameFast(createMenu, "BankScore_3")
		 -- baseScoreTexts[2] = cc.uiloader:seekNodeByNameFast(createMenu, "BankScore_4")

  

		 -- baseScoreBtns[1].baseScoreType =0
		 -- baseScoreBtns[2].baseScoreType =1
		 -- baseScoreBtns[3].baseScoreType =2  


	   --  local function baseScore_selected(button)
	   --      print("baseScoreType "..button.baseScoreType)
	   --      param.baseScoreType2 = button.baseScoreType

	   --       for i=1,3 do
	   --      	if (i-1) == button.baseScoreType then
	   --      	    param.baseScoreType[i] = 1
	   --      	else
	   --      		 param.baseScoreType[i] =0
	   --      	end       	
	   --      end
	   --      --处理下庄分数
	   --      if button.baseScoreType ==0 then
	  --        baseScoreTexts[0]:setString(":100")
			--  baseScoreTexts[1]:setString(":200")
			--  baseScoreTexts[2]:setString(":300")
			
		   --      end

		   --       if button.baseScoreType ==1 then
			  --        baseScoreTexts[0]:setString(":100")
					--  baseScoreTexts[1]:setString(":300")
					--  baseScoreTexts[2]:setString(":500")
		   --      end

		   --       if button.baseScoreType ==2 then
			  --        baseScoreTexts[0]:setString(":100")
					--  baseScoreTexts[1]:setString(":300")
					--  baseScoreTexts[2]:setString(":1000")
		   --      end



		   --  end
		   --  local btn_baseScore_group = RadioButtonGroup.new({
				 --  [ baseScoreBtns[1] ] = baseScore_selected,
		   --  	  [ baseScoreBtns[2] ] = baseScore_selected,
		   --  	  [ baseScoreBtns[3] ] = baseScore_selected,
		   --   })
		   --  baseScoreBtns[param.baseScoreType2+1]:setButtonSelected(true)
    --局数选择按钮
    local roundBtns ={}
    local roundTexts={}
    roundBtns[1] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_RoundCount_1")
    roundBtns[2] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_RoundCount_2")

    roundBtns[1].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_RoundCount_1")
    roundBtns[2].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_RoundCount_2")


    local PayCount_1 = cc.uiloader:seekNodeByNameFast(createMenu, "PayCount_1")
    local PayCount_2 = cc.uiloader:seekNodeByNameFast(createMenu, "PayCount_2")
   
    roundBtns[1].roundType =10
    roundBtns[2].roundType =20
     -- roundBtns[3].roundType =30

    local function round_selected(button)
        print("roundType "..button.roundType)
        param.roundType = button.roundType
        --PayCostText_2:setString("x"..AA_Base[param.roundType])
       -- PayCostText_1:setString("x"..param.seatCount*AA_Base[param.roundType] )
    end
    local btn_round_group = RadioButtonGroup.new({
		  [  roundBtns[1] ] = round_selected,
    	  [  roundBtns[2] ] = round_selected,
    	 -- [  roundBtns[3] ] = round_selected,		 
     })
    roundBtns[param.roundType/10]:setButtonSelected(true)

    -- 房费
	local CheckBox_PayMod_1 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_PayMod_1") 
	local CheckBox_PayMod_2 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_PayMod_2")
	CheckBox_PayMod_1.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_PayMod_1") 
	CheckBox_PayMod_2.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_PayMod_2") 


	CheckBox_PayMod_1.paymode =1   -- 房住支付
	CheckBox_PayMod_2.paymode =2   -- AA支付

    local function paymod_selected(button)
        print("paymode "..button.paymode)
        param.paymode = button.paymode
        showGoldNum(param.paymode, param.seatCount)

    end
    local btn_paymod_group = RadioButtonGroup.new({
		  [ CheckBox_PayMod_1 ] = paymod_selected,
    	  [ CheckBox_PayMod_2 ] = paymod_selected,	 
     })


    if param.paymode == 1 then
    	CheckBox_PayMod_1:setButtonSelected(true)
    else
    	CheckBox_PayMod_2:setButtonSelected(true)
    end
    



   --翻倍选择按钮
   
	local CheckBox_DoubleRuleTip_1 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_DoubleRuleTip_1")
	local CheckBox_DoubleRuleTip_2 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_DoubleRuleTip_2")
	CheckBox_DoubleRuleTip_1.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_DoubleRuleTip_1")
	CheckBox_DoubleRuleTip_2.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_DoubleRuleTip_2")


	CheckBox_DoubleRuleTip_1.doubletype =0  
	CheckBox_DoubleRuleTip_2.doubletype =1  

    local function doubletype_selected(button)
        print("doubletype "..button.doubletype)
        for i=1,2 do
        	if (i-1) == button.doubletype then
        	    param.doubleType[i] = 1
        	else
        		 param.doubleType[i] =0
        	end       
        end
    end
    local btn_paymod_group = RadioButtonGroup.new({
		  [ CheckBox_DoubleRuleTip_1 ] = doubletype_selected,
    	  [ CheckBox_DoubleRuleTip_2 ] = doubletype_selected,	 
     })
    


    if  param.doubleType[1] == 1 then
    	CheckBox_DoubleRuleTip_1:setButtonSelected(true)
    else
    	CheckBox_DoubleRuleTip_2:setButtonSelected(true)
    end
 
    --- 下庄分数
   

  
   local bankscoeBtns={}

   bankscoeBtns[1] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BankScore_1")
   bankscoeBtns[2] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BankScore_2")
   bankscoeBtns[3] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BankScore_3")
   bankscoeBtns[4] = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_BankScore_4")

   bankscoeBtns[1].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_BankScore_1")
   bankscoeBtns[2].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_BankScore_2")
   bankscoeBtns[3].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_BankScore_3")
   bankscoeBtns[4].text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_BankScore_4")

   bankscoeBtns[1].bankscoreType =0  
   bankscoeBtns[2].bankscoreType =1 
   bankscoeBtns[3].bankscoreType =2
   bankscoeBtns[4].bankscoreType =3


    local function bankscore_selected(button)
        print("clicked "..button.bankscoreType)

      --  param.bankscoreType = button.bankscoreType

        for i=1,4 do
        	if (i-1) == button.bankscoreType then
        	    param.bankscoreType[i] = 1
        	else
        		 param.bankscoreType[i] =0
        	end       
        end
    end

    local btn_paymod_group = RadioButtonGroup.new({
		  [ bankscoeBtns[1] ] = bankscore_selected,
    	  [ bankscoeBtns[2] ] = bankscore_selected,
    	  [ bankscoeBtns[3] ] = bankscore_selected,
    	  [ bankscoeBtns[4] ] = bankscore_selected,
     })


    for i=1,4 do
    	if  param.bankscoreType[i] == 1 then
    		bankscoeBtns[i]:setButtonSelected(true)
    	end
    end


    
	-----------特殊牌型
   local CheckBox_Special_1 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_Special_1") --炸弹
   local CheckBox_Special_2 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_Special_2") --五花牛
   local CheckBox_Special_3 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_Special_3") --五小牛
   CheckBox_Special_1.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_Special_1") --炸弹
   CheckBox_Special_2.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_Special_2")
   CheckBox_Special_3.text = cc.uiloader:seekNodeByNameFast(createMenu, "Text_Special_3")
   
	CheckBox_Special_1.SpecialType =0   
	CheckBox_Special_2.SpecialType =1 
	CheckBox_Special_3.SpecialType =2

    local CheckBox_Setting_1 = cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_Setting_1")   
    local CheckBox_Setting_2= cc.uiloader:seekNodeByNameFast(createMenu, "CheckBox_Setting_2")
    CheckBox_Setting_1.text =  cc.uiloader:seekNodeByNameFast(createMenu, "Text_Setting_1") 
    CheckBox_Setting_2.text =  cc.uiloader:seekNodeByNameFast(createMenu, "Text_Setting_2")    

    CheckBox_Special_1:onButtonClicked(function() 
                
          if CheckBox_Special_1:isButtonSelected() then
          	  param.specialType[1]=1 
          	  CheckBox_Special_1.text:setColor(cc.c3b(255, 215, 0))                  	
          else
          	param.specialType[1]=0  
          	 CheckBox_Special_1.text:setColor(cc.c3b(255, 255, 255))            	
          end

    end)
    CheckBox_Special_2:onButtonClicked(function() 
                 
          if CheckBox_Special_2:isButtonSelected() then
             param.specialType[2]=1 
             CheckBox_Setting_2:setButtonSelected(false)
             CheckBox_Setting_2.text:setColor(cc.c3b(255, 255, 255))   
             CheckBox_Special_2.text:setColor(cc.c3b(255, 215, 0))     

          else
          	  param.specialType[2]=0 
          	  CheckBox_Special_2.text:setColor(cc.c3b(255, 255, 255))             	         	 
          end

    end)
    CheckBox_Special_3:onButtonClicked(function()                
          if CheckBox_Special_3:isButtonSelected() then
          	 
             CheckBox_Special_3.text:setColor(cc.c3b(255, 215, 0))     
          	 param.specialType[3]=1
          else
          	
             CheckBox_Special_3.text:setColor(cc.c3b(255, 255, 255))     
          	 param.specialType[3]=0
          end

    end)
	--------高级选项
    CheckBox_Setting_1:onButtonClicked(function() 
            
          if CheckBox_Setting_1:isButtonSelected() then
          	
          	 CheckBox_Setting_1.text:setColor(cc.c3b(255, 215, 0))     
          	 param.setting[1]=1
          else
          
             CheckBox_Setting_1.text:setColor(cc.c3b(255, 255, 255))     
          	 param.setting[1]=0
          end

    end)

    CheckBox_Setting_2:onButtonClicked(function() 
                
          if CheckBox_Setting_2:isButtonSelected() then
          	
          	 CheckBox_Special_2:setButtonSelected(false)
          	 CheckBox_Special_2.text:setColor(cc.c3b(255, 255, 255))   
          	 param.setting[2]=1
          	 CheckBox_Setting_2.text:setColor(cc.c3b(255, 215, 0))    
          else
          	 
             CheckBox_Setting_2.text:setColor(cc.c3b(255, 255, 255))    
          	 param.setting[2]=0
          end

    end)


    --设置默认值

    if param.specialType[1] == 1 then
    	CheckBox_Special_1:setButtonSelected(true)
    	CheckBox_Special_1.text:setColor(cc.c3b(255, 215, 0)) 
    end
    if param.specialType[2] == 1 then
    	CheckBox_Special_2:setButtonSelected(true)
    	CheckBox_Special_2.text:setColor(cc.c3b(255, 215, 0)) 
    end
    if param.specialType[3] == 1 then
    	CheckBox_Special_3:setButtonSelected(true)
    	CheckBox_Special_3.text:setColor(cc.c3b(255, 215, 0)) 
    end



    if param.setting[1] == 1 then
    	CheckBox_Setting_1:setButtonSelected(true)
    	CheckBox_Setting_1.text:setColor(cc.c3b(255, 215, 0)) 
    end
    if param.setting[2] == 1 then
    	CheckBox_Setting_2:setButtonSelected(true)
    	CheckBox_Setting_2.text:setColor(cc.c3b(255, 215, 0)) 
    end




	---------创建房间
	local create_btn = 	cc.uiloader:seekNodeByNameFast(createMenu, "btn_create_room")

	print("param.hostplay",param.hostplay)

	create_btn:onButtonClicked(function()
		 --print("---------------------")
	     --print(param.baseScoreType2+1)
	     local rule =  code.encode({param.bankerType,param.baseScoreType,param.bankscoreType,param.doubleType, param.specialType, param.setting})     
	     -- print(rule)
	     PRMessage.PrivateRoomCreateReq(31600, param.paymode , param.roundType , param.seatCount, param.baseScoreType2+1, 0--[[param.base_count]], rule, param.hostplay)

	    end)

	util.BtnScaleFun(create_btn)
    --记录房间信息 
    util.GameStateSave('niuniuRoomInfo',param)
end

--[[ --
    * 创建DDZ开房界面
--]]
local function _create_ddz_content(self, param)
	local roomInfo = GameData.ddzRoomInfo or {}

	--显示已经创建过的界面
	if self.createRoomLayer.ddz_content then
		self.createRoomLayer.ddz_content:show()
		return
	end

	--创建ddz开房界面
	local ui_DDZ = cc.uiloader:load("Node/createRoom/ddz_content.json")
	:pos(ROOM_CONTENT_POS.x, ROOM_CONTENT_POS.y)
	:addTo(self.createRoomLayer.nd_all)
	self.createRoomLayer.ddz_content = ui_DDZ

	--滑块
	-- local scroll_view = cc.uiloader:seekNodeByNameFast(ui_DDZ, "scroll_view")
	-- scroll_view.sbV = display.newScale9Sprite("Image/Lobby/PrivateRoom/content/img_tiao.png", 0,0,cc.size(9,420)):addTo(scroll_view):hide()
	-- scroll_view.offsetV = true

	local roomid = param.roomid 					--房间ID
	local mode = 1 									--支付类型 1 = 房主支付 2 = AA支付
	local round = 0  								--游戏局数
	local seats = 0 								--玩家人数
	local base = param.customization.base[1]  		--低分
	local count = param.customization.count[1]	 	--初始分数	
	local rule = 0

	--刷新开房价格
	local function showGoldNum(mode, seats)
		for k,v in pairs(param.cost) do
			local cval = v.cval
			if mode == 1 then
				cval = cval * seats
			end

			cc.uiloader:seekNodeByNameFast(ui_DDZ, "tx_diamonds_" .. k):setString("X" .. tostring(cval) .. " ）")
		end
	end

	--选择玩法---
	local CheckBox_Room_3_1 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_3_1")
	local CheckBox_Room_3_2 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_3_2")
	local CheckBox_Room_4_2 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_4_2")

	--房间游戏玩法选择
	local function room_player_num_selected(button)
		seats = button.seats
		rule = button.rule

		showGoldNum(mode, seats)
	end

	local group_1 = RadioButtonGroup.new({
		[CheckBox_Room_3_1] = room_player_num_selected,
		[CheckBox_Room_3_2] = room_player_num_selected,
		[CheckBox_Room_4_2] = room_player_num_selected,
	})

	CheckBox_Room_3_1.seats = 3
	CheckBox_Room_3_1.rule = 1
	CheckBox_Room_3_2.seats = 3
	CheckBox_Room_3_2.rule = 2
	CheckBox_Room_4_2.seats = 4
	CheckBox_Room_4_2.rule = 4

	local node_1 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "node_1")
	CheckBox_Room_3_1.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_1")
	CheckBox_Room_3_2.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_2")
	CheckBox_Room_4_2.text = cc.uiloader:seekNodeByNameFast(node_1, "tx_zi_3")

	--默认3人1副牌
	if roomInfo.rule == 1 then
		CheckBox_Room_3_1:setButtonSelected(true)
	elseif roomInfo.rule == 2 then
		CheckBox_Room_3_2:setButtonSelected(true)
	elseif roomInfo.rule == 4 then
		CheckBox_Room_4_2:setButtonSelected(true)
	else
		CheckBox_Room_3_1:setButtonSelected(true)
	end

	----------------------------------------------


	--选择局数---
	local CheckBox_Room_Game_Num_1 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_Game_Num_1")
	local CheckBox_Room_Game_Num_2 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_Game_Num_2")
	local CheckBox_Room_Game_Num_3 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_Game_Num_3")

	--房间局数选择
	local function room_game_num_selected(button)
		round = button.round
	end

	local group_2 = RadioButtonGroup.new({
		[CheckBox_Room_Game_Num_1] = room_game_num_selected,
		[CheckBox_Room_Game_Num_2] = room_game_num_selected,
		[CheckBox_Room_Game_Num_3] = room_game_num_selected,
	})

	CheckBox_Room_Game_Num_1.round = 4
	CheckBox_Room_Game_Num_2.round = 8
	CheckBox_Room_Game_Num_3.round = 16

	local node_2 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "node_2")
	CheckBox_Room_Game_Num_1.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_1")
	CheckBox_Room_Game_Num_2.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_2")
	CheckBox_Room_Game_Num_3.text = cc.uiloader:seekNodeByNameFast(node_2, "tx_zi_3")

	--默认10局
	if roomInfo.round == 4 then
		CheckBox_Room_Game_Num_1:setButtonSelected(true)
	elseif roomInfo.round == 8 then
		CheckBox_Room_Game_Num_2:setButtonSelected(true)
	elseif roomInfo.round == 16 then
		CheckBox_Room_Game_Num_3:setButtonSelected(true)
	else
		CheckBox_Room_Game_Num_1:setButtonSelected(true)
	end

	----------------------------------------------


	--支付方式---
	local CheckBox_Room_Pay_Type_1 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_Pay_Type_1")
	local CheckBox_Room_Pay_Type_2 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "CheckBox_Room_Pay_Type_2")

	--支付方式选择
	local function room_pay_type_selected(button)
		mode = button.mode

		showGoldNum(mode, seats)
	end

	local group_3 = RadioButtonGroup.new({
		[CheckBox_Room_Pay_Type_1] = room_pay_type_selected,
		[CheckBox_Room_Pay_Type_2] = room_pay_type_selected,
	})

	CheckBox_Room_Pay_Type_1.mode = 1
	CheckBox_Room_Pay_Type_2.mode = 2

	local node_3 = cc.uiloader:seekNodeByNameFast(ui_DDZ, "node_3")
	CheckBox_Room_Pay_Type_1.text = cc.uiloader:seekNodeByNameFast(node_3, "tx_zi_2")
	CheckBox_Room_Pay_Type_2.text = cc.uiloader:seekNodeByNameFast(node_3, "tx_zi_1")

	--默认AA支付
	if roomInfo.mode == 1 then
		CheckBox_Room_Pay_Type_1:setButtonSelected(true)
	elseif roomInfo.mode == 2 then
		CheckBox_Room_Pay_Type_2:setButtonSelected(true)
	else
		CheckBox_Room_Pay_Type_2:setButtonSelected(true)
	end

	----------------------------------------------	


	--创建按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(ui_DDZ, "btn_create_room"))
		:onButtonClicked(function()
			print(
				"房间ID = " .. roomid,
				"支付方式 = " .. mode,
				"房间局数 = " .. round,
				"房间人数 = " .. seats,
				"房间低分 = " .. base,
				"房间初始分数 = " .. count,
				"房间玩法 ＝ " .. rule
			)
			PRMessage.PrivateRoomCreateReq(roomid, mode, round, seats, base, count, rule)

			--记录开房信息
			local roomInfo = {
				seats = seats,									--人数
				round = round,									--局数
				mode = mode,									--支付方式
				rule = rule,									--玩法
			}
			util.GameStateSave('ddzRoomInfo',roomInfo)
		end)
end

--[[ --
    * 显示创建房间
--]]
function LobbyScene:showCreateMenu()
	print("LobbyScene:showCreateMenu---")

	if app.constant.isOpening == true then
          return
    end

	sound_common.menu()

	local createRoomLayer = cc.uiloader:load("Layer/CreateRoomLayer.json"):addTo(self)
	self.createRoomLayer = createRoomLayer
	
	-- --执行标题动作
	-- _play_title_action(cc.uiloader:seekNodeByNameFast(createRoomLayer, "nd_title"))

	-- --选择游戏
	-- local function game_selected(button)
	-- 	--获取配置信息
	-- 	local param
	-- 	for i,v in pairs(PRConfig) do
	-- 		if v.gameid == button.gameid then
	-- 			param = v
	-- 			break
	-- 		end
	-- 	end

	-- 	if not param then
	-- 		print("服务器没有对应的游戏配置。。。")
	-- 		return
	-- 	end
		
	-- 	--隐藏所有开房界面
	-- 	_hide_all_content(self)

	-- 	--创建开房界面
	-- 	if button.gameid == 101 then
	-- 		_create_symj_content(self, param)
	-- 	elseif button.gameid == 106 then
	-- 		_create_sss_content(self, param)
	-- 	elseif button.gameid == 116 then
	-- 		_create_nn_content(self, param)
	-- 	elseif button.gameid == 110 then
	-- 		_create_ddz_content(self, param)
	-- 	end
	-- end

	-- local list_ment = cc.uiloader:seekNodeByNameFast(createRoomLayer, "list_ment")
	-- local group = RadioButtonGroup.new()
	-- local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
	-- for _,conf in ipairs(platConfig.game) do
	-- 	--创建复选按钮
	-- 	local images = {
	-- 		off = conf.Image_off,
	-- 		off_pressed = conf.Image_on,
	-- 		off_disabled = conf.Image_off,
	-- 		on = conf.Image_on,
	-- 		on_pressed = conf.Image_on,
	-- 		on_disabled = conf.Image_on,
	-- 	}
	-- 	local checkBox = cc.ui.UICheckBoxButton.new(images)

	-- 	--添加复选按钮
	-- 	group:addButtons({[checkBox] = game_selected})

	-- 	--保存gameid
	-- 	checkBox.gameid = conf.gameid

	-- 	--添加Item
	-- 	local item = list_ment:newItem()
	-- 	item:addContent(checkBox)
	-- 	item:setItemSize(232, 88)
	-- 	list_ment:addItem(item)

	-- 	--默认显示配置的第一个
	-- 	if not group:getSelected() then
	-- 		checkBox:setButtonSelected(true)
	-- 	end
	-- end

	-- list_ment:reload()
	

    --房间参数
    local param  
	if  param == nil then
	 	 param = {}
	 	 --设置默认值
	 	 param.bankerType={1,0,0,0}
	     param.baseScoreType={1,0,0}
	     param.doubleType={0,1}
	     param.bankscoreType={1,0,0,0}
	     param.specialType = {[1]=0,[2]=0,[3]=0}   --特殊牌型
	     param.setting={[1]=0,[2]=0}               --高级设置
	     param.seatCount = 3
	     param.paymode   = 2
	     param.baseScoreType2 = 0
	     param.roundType = 10
	     param.hostplay = false

	     --print("---------------本地没有初始房间信息------------")
	 
	end

	--关闭按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(createRoomLayer, "Btn_closed"))
		:onButtonClicked(function ()
			createRoomLayer:removeSelf()
		end)
    
   
	    --[[玩法类型按钮]]
    local btn_bks= {}  
    for i =1,4 do         
          local Btn_Bk = cc.uiloader:seekNodeByNameFast(createRoomLayer, string.format("CheckBox_Banker_%d",i))      
              Btn_Bk.bankerType = i-1
              btn_bks[i] = Btn_Bk 
         
    end


     local function bank_selected(button)
        print("bankType "..button.bankerType)

        for i=1,4 do
        	if (i-1) == button.bankerType then
        	    param.bankerType[i] = 1
        	else
        		 param.bankerType[i] =0
        	end
        	
        end
        if button.bankerType == 1 then  -- 固定庄家 
            -- item_4:show()
            -- item_5:setPositionY(-41)
            -- item_6:setPositionY(-196)
            -- item_7:setPositionY(-275)
			param.hostplay = true
        else
            -- item_4:hide()
            -- item_5:setPositionY(-41+79)
            -- item_6:setPositionY(-196+79)
            -- item_7:setPositionY(-275+79)
			param.hostplay = false
        end


    end
    local btn_bk_group = RadioButtonGroup.new({
		  [ btn_bks[1] ] = bank_selected,
    	  [ btn_bks[2] ] = bank_selected,
    	  [ btn_bks[3] ] = bank_selected,
    	  [ btn_bks[4] ] = bank_selected,
     })
     

     btn_bks[1]:setButtonSelected(true)



    -----创建房间
	local create_btn = 	cc.uiloader:seekNodeByNameFast(createRoomLayer, "Btn_create")

	

	create_btn:onButtonClicked(function()
		 print("---------------------")
	    -- print(param.baseScoreType2+1)
	     --dump(param)
	     local rule =  code.encode({param.bankerType,param.baseScoreType,param.bankscoreType,param.doubleType, param.specialType, param.setting})     
	      print(rule)
	     PRMessage.PrivateRoomCreateReq(31600, param.paymode , param.roundType , param.seatCount, param.baseScoreType2+1, 0--[[param.base_count]], rule, param.hostplay)

	    end)

	util.BtnScaleFun(create_btn)








end
-----------------------------------------加入房间-----------------------------------------

--[[ --
    * 显示输入密码界面
--]]
function LobbyScene:showLoginRoom()
	if app.constant.isOpening == true then
          return
    end
	sound_common.menu()

	--界面
	local createMenu = cc.uiloader:load("Layer/AddRoomLayer.json"):addTo(self)
	--createMenu:setPosition(display.width/2, display.height/2)
	
	self.scene.privateRoomLogin = createMenu
	
	self:onLoginRoom()

	--关闭按钮
	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(createMenu, "Btn_Close"))
		:onButtonClicked(
			function ()
				createMenu:removeFromParent()
				self.scene.privateRoomLogin = nil
				gID = nil

				-- local scale2_star = cc.ScaleTo:create(0.2,0.1)
				-- transition.execute(popBoxNode, scale2_star,{
				-- 		easing = "sineOut",
				-- 		onComplete = function()
				-- 			createMenu:removeFromParent()
				-- 			self.scene.privateRoomLogin = nil
				-- 			gID = nil
				-- 		end
				-- 	})
				sound_common:cancel()
			end
		)
end

--[[ --
    * 密码按键
--]]
function LobbyScene:onLoginRoom()
	
    local subNode = self.scene.privateRoomLogin
	local input = {}
	for i = 1,6 do
		input[i] = cc.uiloader:seekNodeByNameFast(subNode, string.format("AtlasLabel_%d",i))
		input[i]:setString("")
		--input[i]:hide()
	end

	local input_btn = {}
	for i = 1,10 do
		input_btn[i] = cc.uiloader:seekNodeByNameFast(subNode, string.format("Btn_Num_%d",i - 1))
		input_btn[i]:onButtonClicked(function()
			print("iiii:" .. tostring(i - 1))
			local isEnterGame = true
			for j = 1,6 do
				if input[j]:getString() == "" then
					input[j]:setString(tostring(i - 1))
					
					if j ~= 6 then
						isEnterGame = false					
					end
					break
				end
			end
			if isEnterGame then
				local table_code = ""
				for i = 1,6 do
					local num = input[i]:getString()
					if num ~= "" then
						table_code = table_code .. num
					else
						ErrorLayer.new(app.lang.roomid_cnt_failed):addTo(self)
						return
					end
				end
				ProgressLayer.new(app.lang.enter_private_room, app.constant.network_loading)
					:setName("password_enter_room")
					:addTo(self,100)				
				PRMessage.EnterPrivateRoomReq(table_code)
			end
		end)
		util.BtnScaleFun(input_btn[i])
	end

	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(subNode, "Button_ReInput"))
		:onButtonClicked(
			function()
				for i = 1,6 do
					input[i]:setString("")
					
				end
			end
		)

	util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(subNode, "Button_Chess"))
		:onButtonClicked(
			function()
				for i = 6,1,-1 do
					if input[i]:getString() ~= "" then
						input[i]:setString("")
						
						break
					end
				end
			end
		)
end

--[[ --
    * 清理密码
--]]
function LobbyScene:clearLoginPassword()
	if self.scene.privateRoomLogin then
		for i=1,6 do
			cc.uiloader:seekNodeByNameFast(self.scene.privateRoomLogin.LoginRoomLayer, string.format("Text_%d",i)):setString("")
		end
	end

	local progressLayer = self:getChildByName("password_enter_room")
	if progressLayer then
		progressLayer:removeSelf()
	end
end





return LobbyScene
