--
-- 麻将私人房战绩
-- Date: 2017-05-18 14:49:55
--

local MJPRoomRecord = class("MJPRoomRecord",function()
    return display.newNode()
end)

local AvatarConfig = require("app.config.AvatarConfig")
local message = require("app.net.Message")
local crypt = require("crypt")
local Share = require("app.User.Share")
local util = require("app.Common.util")

--战绩信息
local ui_players = {}
--局数
local ui_room_type = nil
--房间ID
local ui_room_id = nil

--战绩信息背景位置
local rectrd_bg_pos = {
	{190,367},
	{482,367},
	{767,367},
	{1059,367},
}

--最终得分颜色
local score_color = {
	cc.c3b(245,229,227),
	cc.c3b(224,240,255),
	cc.c3b(255,234,244),
	cc.c3b(220,231,218),
}

function MJPRoomRecord:ctor()
end

function MJPRoomRecord:showPrivateRoomRecord(flag,msg)

	self:setVisible(flag)
	if not flag then
		return 
	end

	--房间号
	if ui_room_id then
		ui_room_id:setString("房间号:" .. msg.tablecode)
	end

	--局数
	if ui_room_type then
        if msg.gameround ~= 100 then
            ui_room_type:setString(msg.gameround .. "局")
        else
            ui_room_type:setString(msg.gameround .. "分局")
        end
	end

	for _,info in pairs(msg.infos) do
		--头像
		local image = AvatarConfig:getAvatar(info.sex, 100, 0)
    	local rect = cc.rect(0, 0, 178, 176)
    	local frame_head = cc.SpriteFrame:create(image, rect)
		ui_players[info.seat].ui_head:setSpriteFrame(frame_head)
        
        local headNode = ui_players[info.seat].ui_head:getParent()
         --设置微信头像
        --util.setHeadImage(headNode, info.imageid, frame_head, image)

		-- --名字
		ui_players[info.seat].ui_name:setString(util.checkNickName(crypt.base64decode(info.name)))

		-- --自摸次数
		ui_players[info.seat].ui_feel_num:setString(info.zi_mo .. "次")

		-- --打糊次数
		ui_players[info.seat].ui_paste_num:setString(info.jie_pao .. "次")

		-- --点炮次数
		ui_players[info.seat].ui_cannon_num:setString(info.dian_pao .. "次")

		-- --分数
		ui_players[info.seat].ui_score_num:setString(info.socre .. "分")

		--显示
		ui_players[info.seat].ui_node:setVisible(true)

		if #msg.infos == 2 then
			if info.seat == 1 then
				ui_players[info.seat].ui_node:pos(240,0)
			elseif info.seat == 2 then
				ui_players[info.seat].ui_node:pos(380,0)
			end
		else
			ui_players[info.seat].ui_node:pos(0,0)
		end
	end

end

function MJPRoomRecord:init(callback)
    self.callback = callback
    local size = self.callback:getContentSize()
    print(size.width,size.height)

    --背景
    display.newSprite("res/ShYMJ/PrivateRoomRectrd/img_rectrd_layer_bg.png")
    	:center()
    	:addTo(self)
    	--:opacity(0)
    	:setTouchEnabled(true)
    	-- :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	-- 		print("我被点了")
    	-- 		-- if event.name == "began" then
    	-- 		-- 	return true
    	-- 		-- end
    	-- 	end)

    --标题
    display.newSprite("res/ShYMJ/PrivateRoomRectrd/img_top_bg.png")
    	:center()
    	:addTo(self)

    --局数	
    ui_room_type = display.newTTFLabel({text = "8局",size = 30})
    	:pos(1209,683)
    	:addTo(self)

    --房间ID
    ui_room_id = display.newTTFLabel({text = "房间号:123456",color = cc.c3b(122,223,232),size = 30})
    	:pos(120,683)
    	:addTo(self)

    --战绩信息
    for i=1,4 do
    	if not ui_players[seat] then
			ui_players[i] = {}
		end

    	ui_players[i].ui_node = display.newNode()
    		:pos(0,0)
    		:addTo(self)
    		:setVisible(false)

    	--头像白色底图
    	local ui_head_bg = display.newSprite("res/ShYMJ/PrivateRoomRectrd/img_head_bg.png")
    		:pos(rectrd_bg_pos[i][1]-0.5,rectrd_bg_pos[i][2] + 111)
    		:addTo(ui_players[i].ui_node)

    	--战绩信息背景
    	local ui_rectrd_info_bg = display.newSprite("res/ShYMJ/PrivateRoomRectrd/img_rectrd_info_bg_0" .. i ..".png")
    		:pos(rectrd_bg_pos[i][1],rectrd_bg_pos[i][2])
    		:addTo(ui_players[i].ui_node)

    	--名字背景
    	local ui_name_bg = display.newSprite("res/ShYMJ/PrivateRoomRectrd/img_name_bg.png")
    		:pos(117,226)
    		:addTo(ui_rectrd_info_bg)


    	local x = 97
    	--自摸次数字
    	display.newTTFLabel({text = "自摸次数：",size = 20})
    		:pos(x,187)
    		:addTo(ui_rectrd_info_bg)
    	--打糊次数字
    	display.newTTFLabel({text = "打糊次数：",size = 20})
    		:pos(x,151)
    		:addTo(ui_rectrd_info_bg)
    	--点炮次数字
    	display.newTTFLabel({text = "点炮次数：",size = 20})
    		:pos(x,115)
    		:addTo(ui_rectrd_info_bg)
    	--分数字
    	display.newTTFLabel({text = "分数：",size = 30,color = score_color[i]})
    		:pos(83,52)
    		:addTo(ui_rectrd_info_bg)


    	--头像
   	 	ui_players[i].ui_head = display.newSprite("res/Image/Common/Avatar/female_1.png")
        	:pos(ui_head_bg:getContentSize().width/2,ui_head_bg:getContentSize().height/2)
        	:addTo(ui_head_bg)

    	--名字
    	ui_players[i].ui_name = display.newTTFLabel({text = "我姓小，叫小花",size = 23})
    		:pos(ui_name_bg:getContentSize().width/2,ui_name_bg:getContentSize().height/2)
    		:addTo(ui_name_bg)

    	--自摸次数
    	ui_players[i].ui_feel_num = display.newTTFLabel({text = "3次",size = 20})
    		:setAnchorPoint(0,0.5)
    		:pos(x+55,187)
    		:addTo(ui_rectrd_info_bg)

		--打糊次数
		ui_players[i].ui_paste_num = display.newTTFLabel({text = "3次",size = 20})
			:setAnchorPoint(0,0.5)
    		:pos(x+55,151)
    		:addTo(ui_rectrd_info_bg)

		--点炮次数
		ui_players[i].ui_cannon_num = display.newTTFLabel({text = "3次",size = 20})
			:setAnchorPoint(0,0.5)
    		:pos(x+55,115)
    		:addTo(ui_rectrd_info_bg)

		--分数
		ui_players[i].ui_score_num = display.newTTFLabel({text = "140分",size = 30,color = score_color[i]})
			:setAnchorPoint(0,0.5)
    		:pos(120,52)
    		:addTo(ui_rectrd_info_bg)
    end

    --退出按钮
    cc.ui.UIPushButton.new({
    	normal = "res/ShYMJ/PrivateRoomRectrd/btn_exit_01.png",
    	pressed = "res/ShYMJ/PrivateRoomRectrd/btn_exit_02.png",
    	},{scale9 = true})
    	:pos(427,68)
    	:addTo(self)
    	:onButtonClicked(function(event)
    			message.dispatchPrivateRoom("room.ExitTable", {})
    		end)

    --分享按钮
    cc.ui.UIPushButton.new({
    	normal = "res/ShYMJ/PrivateRoomRectrd/btn_share_rectrd_01.png",
    	pressed = "res/ShYMJ/PrivateRoomRectrd/btn_share_rectrd_02.png",
    	},{scale9 = true})
    	:pos(855,68)
    	:addTo(self)
    	:onButtonClicked(function(event)
    		print("分享战绩")
            Share.createGameShareLayer():addTo(self)
    		end)

    return self
end

function MJPRoomRecord:clear()
	ui_players = {}
	ui_room_type = nil
	ui_room_id = nil
end

return MJPRoomRecord