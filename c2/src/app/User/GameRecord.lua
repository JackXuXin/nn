local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local util = require("app.Common.util")
local sound_common = require("app.Common.sound_common")
local PlatConfig = require("app.config.PlatformConfig")
local AvatarConfig = require("app.config.AvatarConfig")
local crypt = require("crypt")
local PRMessage = require("app.net.PRMessage")
local RoomConfig = require("app.config.RoomConfig")
local MathBit = require("app.Common.MathBit")

local Player = app.userdata.Player

local _profile_record_infos = {}            --预览战绩信息
local _ui_scroll_contents = {}              --详细战绩 scroll 中的 内容

local _ui_switch_btn = nil                  --当前选中的箭头按钮

local ACTION_TIME = 0.2                     --动画速度
local CONTENT_HEIGHT = 478                  --内容宽度


ui_record_scroll = nil

--[[ --
    * 获取自己的椅子号
    @param  table  infos  战绩信息
--]]
local function _getMySeat(infos)
    for _,v in pairs(infos) do
        if v.uid == Player.uid then
            return v.seat
        end
    end
end

--[[ --
    * 获取对应自己的椅子号
    @param  table  infos  战绩信息
    @param  number  realSeat  要转换的椅子号
    @param  number  seatCount  椅子数
--]]
local function _getViewSeat(infos, realSeat, seatCount)
    local mySeat
    if type(infos) ~= "table" then
        mySeat = infos
    else
        mySeat = _getMySeat(infos)
    end

    return (realSeat + seatCount - mySeat) % seatCount + 1
end

--[[ --
    * 创建内容
    @param  table  playerRecords  玩家信息
    @param  number  tablecode  房间号
    @param  number  gameround  局数
--]]
local function _createCentent(playerRecords,tablecode,gameround)
    print("_createCentent---")

	local content = cc.uiloader:load("Node/CreatePRoom_Record_Page.json")
    local content_node = cc.uiloader:seekNodeByNameFast(content,"content_node"):hide()

    -- content:performWithDelay(function ()
    --     content_node:show()
    -- end,ACTION_TIME+0.05)

	-- cc.uiloader:seekNodeByNameFast(content, "ui_num"):setString(tablecode)
	-- if gameround == 100 then
	-- 	cc.uiloader:seekNodeByNameFast(content, "ui_count"):setString(gameround .. "分局")
	-- else
	-- 	cc.uiloader:seekNodeByNameFast(content, "ui_count"):setString(gameround .. "局")
	-- end

	-- if #playerRecords == 2 then
	-- 	cc.uiloader:seekNodeByNameFast(content, "record_info_03"):hide()
	-- 	cc.uiloader:seekNodeByNameFast(content, "record_info_04"):hide()
	-- elseif #playerRecords == 3 then
	-- 	cc.uiloader:seekNodeByNameFast(content, "record_info_04"):hide()
	-- end

	-- for k,v in pairs(playerRecords) do
	-- 	local record_info = cc.uiloader:seekNodeByNameFast(content, "record_info_0" .. k)
	-- 	record_info:show()

	-- 	--头像
	-- 	local ui_head = cc.uiloader:seekNodeByNameFast(record_info, "ui_head")
	-- 	local image = AvatarConfig:getAvatar(v.sex, 1000, 0)
	-- 	local rect = cc.rect(0, 0, 178, 176)
	-- 	local newAvatar = cc.SpriteFrame:create(image, rect)
	-- 	ui_head:setSpriteFrame(newAvatar)

	-- 	--微信头像设置
	-- 	local imageNode = ui_head:getParent()
	-- 	print("v.imageid = ", v.imageid)
    --     --设置微信头像
    --     util.setHeadImage(imageNode, v.imageid, ui_head, image)

	-- 	--名字
	-- 	cc.uiloader:seekNodeByNameFast(record_info, "ui_name"):setString(util.checkNickName(crypt.base64decode(v.nickname)))

	-- 	--分数正负
	-- 	local ui_symbol = nil
	-- 	if tonumber(v.score) >= 0 then
	-- 		ui_symbol = display.newSprite("Image/PrivateRoom/img_jia.png")
	-- 		cc.uiloader:seekNodeByNameFast(record_info, "ui_score_jia"):setString(tostring(math.abs(v.score)))
	-- 		cc.uiloader:seekNodeByNameFast(record_info, "ui_score_jia"):show()
	-- 		cc.uiloader:seekNodeByNameFast(record_info, "ui_score_jian"):hide()
	-- 	else
	-- 		ui_symbol = display.newSprite("Image/PrivateRoom/img_jian.png")
	-- 		cc.uiloader:seekNodeByNameFast(record_info, "ui_score_jian"):setString(tostring(math.abs(v.score)))
	-- 		cc.uiloader:seekNodeByNameFast(record_info, "ui_score_jian"):show()
	-- 		cc.uiloader:seekNodeByNameFast(record_info, "ui_score_jia"):hide()
	-- 	end
	-- 	cc.uiloader:seekNodeByNameFast(record_info, "ui_symbol"):setSpriteFrame(ui_symbol:getSpriteFrame())
	-- end

	return content
end

--[[ --
    * 获取插入战绩位置
--]]
local function _getInsertPos(index)
    print("_getInsertPos",  "index = " .. index)

    local height = 0

    for i,ui_content in ipairs(_ui_scroll_contents) do
        if i < index then
            height = height + ui_content:getContentSize().height
        end
    end

    return height + ((index - 2) * 5)
end

--[[ --
    * 移除一条战绩
--]]
local function _removeScrollContent(removePos)
    print("_removeScrollContent---","removePos = " .. removePos)

    --移除内容
    local sep = cca.seq{cca.scaleBy(ACTION_TIME,1,0), cca.removeSelf(), cca.callFunc(function ()
        table.remove(_ui_scroll_contents, removePos)
    end)}
    _ui_scroll_contents[removePos]:runAction(sep)

    --调整位置
    for pos,ui_content in pairs(_ui_scroll_contents) do
        if pos >= removePos then
            ui_content:moveBy(ACTION_TIME,0,CONTENT_HEIGHT)
        end
    end
end

--[[ --
    * 插入一条战绩
--]]
local function _insertScrollContent(insertPos)
    print("_insertScrollContent---","insertPos = " .. insertPos)

    --获取当前显示List
    local Y = _getInsertPos(insertPos) * -1

    print("Y = " .. Y)

    --创建内容
    local ui_content = _createCentent()
        :setScaleY(0)
        :setLocalZOrder(-1)
        :pos(0,Y)
        :scaleTo(ACTION_TIME,1)

    --添加内容
    ui_record_scroll:getScrollNode():add(ui_content)
    table.insert(_ui_scroll_contents, insertPos, ui_content)

    --调整位置
    for pos,ui_content in pairs(_ui_scroll_contents) do
        if pos > insertPos then
           -- ui_content:pos(ui_content:getPositionX(),ui_content:getPositionY()-CONTENT_HEIGHT)
            ui_content:moveBy(ACTION_TIME,0,-CONTENT_HEIGHT)
        end
    end
end

--[[ --
    * Push一条信息 箭头按钮回调
--]]
local function _onPushListViewItem(event)
    print("_onPushListViewItem---")

    for k,v in pairs(_ui_scroll_contents) do
        if v:getNumberOfRunningActions() > 0 then
            return
        end
    end

    local index = event.target.index                    --当前Item的Index

    --箭头方向变化
	local scaling = event.target:getScale() * -1
	event.target:scale(scaling)

	--点开
	if scaling < 0 then

        --如果当前有选中的 移除
		if _ui_switch_btn then
            _removeScrollContent(_ui_switch_btn.index+1)
            _ui_switch_btn:scale(1)

            _ui_switch_btn:performWithDelay(
                function()
                    _insertScrollContent(index+1)
                    _ui_switch_btn = event.target
                end, ACTION_TIME)

            return
		end

        -- --插入
        _insertScrollContent(index+1)
		_ui_switch_btn = event.target
	else
        -- --移除
        _removeScrollContent(index+1)
        _ui_switch_btn = nil
	end
end

--[[ --
    * 显示战绩
--]]
function LobbyScene:showGameRecordMenu()
    print("LobbyScene:showGameRecordMenu---")
    
    sound_common.menu()

    --创建界面
    local GameRecord = cc.uiloader:load("Layer/Lobby/GameRecordLayer.json"):addTo(self)
    cc.uiloader:seekNodeByNameFast(GameRecord,"tx_Prompt"):hide()

    --关闭按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(GameRecord, "btn_Close"))
        :onButtonClicked(
        function ()
            sound_common:cancel()

            self.scene.GameRecord:removeFromParent()
            self.scene.GameRecord = nil

            --清理数据
            _profile_record_infos = {}

            _ui_switch_btn = nil
        end)

    self.scene.GameRecord = GameRecord
end

--[[ --
    * 创建游戏预览战绩信息
    @param  table  profileinfos  ID对应的游戏信息
--]]
function LobbyScene:createProfileGameRecord(profileinfos, progressLayer)
    print("LobbyScene:createProfileGameRecord---")

    local ui_record_list = cc.uiloader:seekNodeByNameFast(self.scene.GameRecord,"list_Record_ment")
    ui_record_list:hide()
    if #profileinfos > 1 then
        ui_record_list:setBounceable(true)
    end

    --渠道配置信息
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)

    --自己在第一个
    for k,v in ipairs(profileinfos) do
        local record = {}

        for _,vv in pairs(v.record) do
            local seat = _getViewSeat(v.record,vv.seat,#v.record)
            record[seat] = vv
        end
            
        profileinfos[k].record = record
        --dump(record,"record")
    end

    --List添加战绩Item
    for _,v in ipairs(profileinfos) do
     
        local ui_content = cc.uiloader:load("Node/Game_Record_Template.json")
        cc.uiloader:seekNodeByNameFast(ui_content,"player_record_1"):hide()
        cc.uiloader:seekNodeByNameFast(ui_content,"player_record_2"):hide()
        cc.uiloader:seekNodeByNameFast(ui_content,"player_record_3"):hide()
        cc.uiloader:seekNodeByNameFast(ui_content,"player_record_4"):hide()
        cc.uiloader:seekNodeByNameFast(ui_content,"player_record_5"):hide()
        cc.uiloader:seekNodeByNameFast(ui_content,"player_record_6"):hide()
  
        --游戏名称
        local game_name = RoomConfig:getGameNameWithGameId(v.gameid)
        cc.uiloader:seekNodeByNameFast(ui_content,"tx_game_name"):setString("游戏：" .. game_name)

        --房号
        cc.uiloader:seekNodeByNameFast(ui_content,"tx_privateid"):setString("房号：" .. v.privateid)

        --局数
        cc.uiloader:seekNodeByNameFast(ui_content,"tx_round"):setString("局数：" .. v.round)

        --规则
        local text_rule = "玩法："
        if v.gameid == 101 then          --上虞麻将
            --花
            if MathBit.andOp(v.rule,2) == 2 then
                text_rule = text_rule .. " 2花"
            elseif MathBit.andOp(v.rule,4) == 4 then
                text_rule = text_rule .. " 3花"
            elseif MathBit.andOp(v.rule,8) == 8 then
                text_rule = text_rule .. " 4花"
            elseif MathBit.andOp(v.rule,16) == 16 then
                text_rule = text_rule .. " 5花"
            end

            if MathBit.andOp(v.rule,1) == 1 then                              --是否超一进十
                text_rule = text_rule .. " 超一进十"
            end
        elseif v.gameid == 103 then      --嵊州麻将
            if MathBit.andOp(v.rule,1) == 1 then
                text_rule = text_rule .. " 算分1-3-5"
            elseif MathBit.andOp(v.rule,2) == 2 then
                text_rule = text_rule .. " 算分2-5-15"
            end
        elseif v.gameid == 106 then      --罗松
            if MathBit.andOp(v.rule,2) == 2 then                --是否加一色
                text_rule = text_rule .. " 加一色"
            elseif MathBit.andOp(v.rule,4) == 4 then            --是否加1王
                text_rule = text_rule .. " 加1王"
            elseif MathBit.andOp(v.rule,8) == 8 then            --是否加2王
                text_rule = text_rule .. " 加2王"
            end

            if MathBit.andOp(v.rule,64) == 64 or MathBit.andOp(v.rule,128) == 128 then     --是否带苍蝇
                text_rule = text_rule .. " 带苍蝇"
            end
        elseif v.gameid == 116 then      --牛魔王
            local code = require("app.Common.code")
            local info =code.decode(v.rule)

            if info[1][1] == 1 then
               text_rule =text_rule.."通比牛牛"              
            end
            if info[1][2] == 1 then
               text_rule =text_rule.."固定庄家"             
            end
            if info[1][3] == 1 then
               text_rule =text_rule.."自由抢庄" 
            end
            if info[1][4] == 1 then
              text_rule =text_rule.."明牌抢庄"              
            end
        elseif v.gameid == 110 then      --斗地主
            

            if MathBit.andOp(v.rule,1) == 1 then
                text_rule = text_rule .. " 3人一副牌"
            elseif MathBit.andOp(v.rule,2) == 2 then
                text_rule = text_rule .. " 3人两副牌"
            elseif MathBit.andOp(v.rule,4) == 4 then
                text_rule = text_rule .. " 4人两副牌"
            end
    
        end

           
       

        if text_rule == "玩法：" then
            text_rule = "玩法：正常"
        end
        cc.uiloader:seekNodeByNameFast(ui_content,"tx_game_rule"):setString(text_rule)
        
        --时间
        cc.uiloader:seekNodeByNameFast(ui_content,"tx_game_time"):setString(v.time)
        
        --详细信息按钮监听
        cc.uiloader:seekNodeByNameFast(ui_content,"btn_specific")
            :onButtonClicked(
                function(event)
                    PRMessage.PrivateGameRecordDetailReq(v.gameid,v.tableindex)
                end
            )

        
        for i,info in ipairs(v.record) do
            local ui_player = cc.uiloader:seekNodeByNameFast(ui_content,"player_record_" .. i):show()
            --头像
            local ui_head = cc.uiloader:seekNodeByNameFast(ui_player, "img_head")
            local image = AvatarConfig:getAvatar(info.sex, 0, 0)
            local rect = cc.rect(0, 0, 178, 176)
            local newAvatar = cc.SpriteFrame:create(image, rect)
            ui_head:setSpriteFrame(newAvatar)

            --微信头像设置
            local imageNode = ui_head:getParent()
            -- print("info.imageid = ", info.imageid)
            --设置微信头像
            util.setHeadImage(imageNode, info.imageid, ui_head, image)

            --名字
            cc.uiloader:seekNodeByNameFast(ui_player,"tx_name"):setString(util.checkNickName(crypt.base64decode(info.nickname)))

            --UID
            cc.uiloader:seekNodeByNameFast(ui_player,"tx_uid"):setString("UID：" .. info.uid)

            --分数
            local ui_symbol = nil
            if tonumber(info.score) >= 0 then
                ui_symbol = display.newSprite("Image/PrivateRoom/img_jia.png")
                cc.uiloader:seekNodeByNameFast(ui_player, "ui_score_jia"):setString(tostring(math.abs(info.score)))
                cc.uiloader:seekNodeByNameFast(ui_player, "ui_score_jia"):show()
                cc.uiloader:seekNodeByNameFast(ui_player, "ui_score_jian"):hide()
            else
                ui_symbol = display.newSprite("Image/PrivateRoom/img_jian.png")
                cc.uiloader:seekNodeByNameFast(ui_player, "ui_score_jian"):setString(tostring(math.abs(info.score)))
                cc.uiloader:seekNodeByNameFast(ui_player, "ui_score_jian"):show()
                cc.uiloader:seekNodeByNameFast(ui_player, "ui_score_jia"):hide()
            end
            cc.uiloader:seekNodeByNameFast(ui_player, "ui_symbol"):setSpriteFrame(ui_symbol:getSpriteFrame())
        end

        local item = ui_record_list:newItem()
  
      
        item:setItemSize(1225,557+10)
    
        item:addContent(ui_content)   
        ui_record_list:addItem(item)
	end


    --记录信息
    _profile_record_infos = profileinfos
    --加载List
    ui_record_list:reload()

    --移除 数据加载
    self.scene.GameRecord:performWithDelay(function ()
        if #profileinfos <= 0 then
            cc.uiloader:seekNodeByNameFast(self.scene.GameRecord,"tx_Prompt"):show()
        else
            ui_record_list:show()
        end

        if progressLayer then
            progressLayer:removeSelf()
            progressLayer = nil
        end
    end,0.1)
end

--[[ --
    * 创建单局详细信息内容
    @param  number  mySeat  自己的椅子号
    @param  number  round  局数
    @param  table  scores  分数
--]]
local function _createSpecificCentent(mySeat, round, scores)
    round = round or 0

    local ui_content = cc.uiloader:load("Node/Game_Specific_Record_Template.json")
    cc.uiloader:seekNodeByNameFast(ui_content,"tx_round_score_3"):hide()
    cc.uiloader:seekNodeByNameFast(ui_content,"tx_round_score_4"):hide()
    cc.uiloader:seekNodeByNameFast(ui_content,"tx_round_score_5"):hide()
    cc.uiloader:seekNodeByNameFast(ui_content,"tx_round_score_6"):hide()

    --局数
    cc.uiloader:seekNodeByNameFast(ui_content, "tx_round"):setString("第" .. round .. "局")

    --分数
    for k,v in ipairs(scores) do
        --自己分数在最前面
        local seat = _getViewSeat(mySeat,v.seat,#scores)
        if tonumber(v.score) >= 0 then
            v.score = '+' .. v.score
        end
        cc.uiloader:seekNodeByNameFast(ui_content, "tx_round_score_" .. seat):setString(v.score):show()
    end

    return ui_content
end

--[[ --
    * 创建单局详细信息
    @param  int  gameid  游戏ID
    @param  table  rounds  gameid对应的游戏信息
--]]
function LobbyScene:createSpecificGameRecord(tableindex, gameid, rounds, progressLayer)
    self.scene.GameRecord:hide()

    local layer = cc.uiloader:load("Layer/Lobby/GameSpecificRecordLayer.json"):addTo(self)
    cc.uiloader:seekNodeByNameFast(layer,"tx_name_3"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"tx_name_4"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"tx_name_5"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"tx_name_6"):hide()

    cc.uiloader:seekNodeByNameFast(layer,"tx_score_3"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"tx_score_4"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"tx_score_5"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"tx_score_6"):hide()

    cc.uiloader:seekNodeByNameFast(layer,"Node_1"):hide()
    cc.uiloader:seekNodeByNameFast(layer,"Node_2"):hide()

    --关闭按钮
    util.BtnScaleFun(cc.uiloader:seekNodeByNameFast(layer, "btn_Close"))
        :onButtonClicked(
            function ()
                _ui_scroll_contents = {}
                ui_record_scroll = nil
                _ui_switch_btn = nil
                self.scene.GameRecord:show()
                layer:removeSelf()
            end
        )

    --名字 and 总战绩
    local mySeat
    for _,v in pairs(_profile_record_infos) do
        if v.tableindex == tableindex and v.gameid == gameid then
            mySeat = v.record[1].seat
            for i,vv in ipairs(v.record) do
                cc.uiloader:seekNodeByNameFast(layer,"tx_name_" .. i):setString(util.checkNickName(crypt.base64decode(vv.nickname))):show()

                if tonumber(vv.score) >= 0 then
                    cc.uiloader:seekNodeByNameFast(layer,"tx_score_" .. i):setString("+" .. vv.score):show()
                else
                    cc.uiloader:seekNodeByNameFast(layer,"tx_score_" .. i):setString(vv.score):show()
                end
            end
        end
    end

    --Scroll添加战绩Item---
    local emptyNode = cc.Node:create():pos(1225/2,480)
    local CENTENT_HEIGHT = 120
    for i,v in ipairs(rounds) do
        local ui_content = _createSpecificCentent(mySeat, v.round, v.scores)
            :pos(0,(i-1)*CENTENT_HEIGHT*-1)
            :addTo(emptyNode)

        local ui_switch = cc.uiloader:seekNodeByNameFast(ui_content,"btn_switch")
			:onButtonClicked(_onPushListViewItem)
            :hide()
        ui_switch.index = i

        _ui_scroll_contents[i] = cc.uiloader:seekNodeByNameFast(ui_content,"img_record_bg")
    end

    --创建Scroll
    ui_record_scroll = cc.ui.UIScrollView.new({viewRect = cc.rect(0, 0, 1225, 480), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
        :pos(25,90)
        :addTo(layer)
        :addScrollNode(emptyNode)
        :setBounceable(false)

    if #rounds > 3 then
        ui_record_scroll:setBounceable(true)
    end

    ------------------------------
    

    --移除 数据加载
    layer:performWithDelay(function ()
        ui_record_scroll:show()
        cc.uiloader:seekNodeByNameFast(layer,"Node_1"):show()
        cc.uiloader:seekNodeByNameFast(layer,"Node_2"):show()
        if progressLayer then
            progressLayer:removeSelf()
            progressLayer = nil
        end
    end,0.1)
end

return LobbyScene




-- --[[ --
--     * 创建游戏标签按钮
-- --]]
-- function LobbyScene:createBtnWithGameId()
--     print("LobbyScene:createBtnWithGameId---")
    
--     --渠道配置信息
--     local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
--     --游戏按钮列表
--     local MenuList = cc.uiloader:seekNodeByNameFast(self.scene.GameRecord, "MenuList")

--     for _,v in ipairs(platConfig.game) do
--         local ui_game_but = nil

--         --创建gameid对应游戏按钮
--         if v.gameid == 108 then
--             ui_game_but = cc.ui.UIPushButton.new({normal="Image/PrivateRoom/item_cxmj_1.png",pressed="Image/PrivateRoom/item_cxmj.png",disabled="Image/PrivateRoom/item_cxmj.png"},{scale9 = true})
--         elseif v.gameid == 115 then
--             ui_game_but = cc.ui.UIPushButton.new({normal="Image/PrivateRoom/item_njmj_1.png",pressed="Image/PrivateRoom/item_njmj.png",disabled="Image/PrivateRoom/item_njmj.png"},{scale9 = true})
--         elseif v.gameid == 101 then
--             ui_game_but = cc.ui.UIPushButton.new({normal="Image/PrivateRoom/item_symj_1.png",pressed="Image/PrivateRoom/item_symj.png",disabled="Image/PrivateRoom/item_symj.png"},{scale9 = true})
--         elseif v.gameid == 103 then
--             ui_game_but = cc.ui.UIPushButton.new({normal="Image/PrivateRoom/item_shzmj_1.png",pressed="Image/PrivateRoom/item_shzmj.png",disabled="Image/PrivateRoom/item_shzmj.png"},{scale9 = true})
--         elseif v.gameid == 106 then  --SSS
--             ui_game_but = cc.ui.UIPushButton.new({normal="Image/PrivateRoom/item_sss_1.png",pressed="Image/PrivateRoom/item_sss.png",disabled="Image/PrivateRoom/item_sss.png"},{scale9 = true})
--         end

--         if ui_game_but then
--             --第一次打开默认选择
--             if #_ui_record_btns == 0 then
--                 ui_game_but:setButtonEnabled(false)
--             end
--             table.insert(_ui_record_btns,ui_game_but)
    
--             --添加Item 到 List
--             local ui_item = MenuList:newItem()
-- 			ui_item:addContent(ui_game_but)
-- 			ui_item:setItemSize(215,68)
-- 			MenuList:addItem(ui_item)

--             --游戏列表按钮监听
--             ui_game_but:onButtonClicked(
--                 function(event)
--                     local gameid = v.gameid
                    
--                     --设置游戏按钮状态
--                     _setGameBtnState(event.target)
                    
--                     --显示战绩信息
--                     if not _profile_record_infos[gameid] then        --发送请求战绩信息
--                         PRMessage.newItem()
--                     end

--                     --移除当前显示Scroll战绩
--                     if _ui_switch_btn then
--                         _removeScrollContent(_ui_switch_btn.index+1,false)
--                         _ui_switch_btn:scale(1.1)
--                         _ui_switch_btn = nil
--                     end

--                     --设置预览战绩Scroll显示状态
--                     _setProfileGameRecordState(gameid)
--                 end
--             )
--         end
--     end

--     MenuList:reload()
-- end




-- --[[ --
--     * 创建游戏预览战绩信息
--     @param  table  profileinfos  ID对应的游戏信息
-- --]]
-- function LobbyScene:createProfileGameRecordaa(profileinfos, progressLayer)
--     print("LobbyScene:createProfileGameRecord---")

--     local emptyNode = cc.Node:create():pos(352,504)
--     _ui_scroll_contents[gameid] = {}

--     --Scroll添加战绩Item
--     local count = 0
--     local CENTENT_HEIGHT = 64
--     for _,v in pairs(profileinfos) do

--         --内容---
-- 		local ui_content = display.newSprite("Image/PrivateRoom/img_record_time_bg.png")
--             :setAnchorPoint(cc.p(0.5,1))
--             :pos(0,count*CENTENT_HEIGHT*-1)
--             :addTo(emptyNode)

-- 		local ui_time = cc.ui.UILabel.new({text = v.time,size = 28})
-- 			:setAnchorPoint(cc.p(0.5,0.5))
-- 			:pos(300,32)
-- 			:addTo(ui_content)

-- 		local ui_switch = cc.ui.UIPushButton.new("Image/PrivateRoom/img_record_switch.png")
--             :scale(1.1)
-- 			:pos(640,30)
-- 			:addTo(ui_content)
-- 			:onButtonClicked(_onPushListViewItem)

--         local aaa = cc.ui.UIPushButton.new("Image/PrivateRoom/img_record_switch.png")
--             :scale(1.1)
-- 			:pos(550,30)
-- 			:addTo(ui_content)
-- 			:onButtonClicked(function()
--                 PRMessage.PrivateGameRecordDetailReq(gameid,v.tableindex)
--             end)
--         -----------------------------------
        
--         count = count + 1
--         _ui_scroll_contents[gameid][count] = ui_content
--         ui_switch.record = v.record                             --预览战绩信息
--         ui_switch.privateid = v.privateid                       --房间号
--         ui_switch.round = v.round                               --局数
--         ui_switch.index = count
-- 	end

--     --创建Scroll
--     local ui_record_scroll = cc.ui.UIScrollView.new({viewRect = cc.rect(0, 0, 704, 504), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
--         :setBounceable(true)
--         :pos(404,85)
--         :addTo(self.scene.GameRecord)
--         :addScrollNode(emptyNode)
--         :hide()
        
--     --记录信息
--     _profile_record_infos[gameid] = profileinfos or {}
--     _ui_record_scrolls[gameid] = ui_record_scroll


--     --移除 数据加载
--     emptyNode:performWithDelay(function ()
--         ui_record_scroll:show()

--         if progressLayer then
--             progressLayer:removeSelf()
--             progressLayer = nil
--         end
--     end,0.3)
-- end