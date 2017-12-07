--
-- Author: peter
-- Date: 2017-04-21 09:55:19
--
local AvatarConfig = require("app.config.AvatarConfig")
local util = require("app.Common.util")
local userdata = require("app.UserData")
local msgMgr = require("app.room.msgMgr")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local message = require("app.net.Message")			    --通信

local gameScene = nil

local WRNN_uiPlayerInfos = {}




function WRNN_uiPlayerInfos:init(scene)
	gameScene = scene

	self.ui_infos = {}  --每个玩家的UI信息
	self.ui_sits = {}   --旁观可见椅子

	for i=1,gameScene.WRNN_Const.MAX_PLAYER_NUMBER do

		-- print("--------"..i)
		local user_info_ui = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_player_info_" .. i)
		self.ui_infos[i] = {
			ui_body = user_info_ui,
			k_tx_user_name = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_tx_user_name"),   --名字
			k_tx_user_silver = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_tx_user_silver"), --金币
			k_sp_ready = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_ready"),  --准备标示
			k_sp_touxiang_bg = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_touxiang_bg"),  --头像背景
			k_sp_touxiang = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_touxiang"),   --头像
			k_sp_XiaZhuBG = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_XiaZhuBG"),   --下注分数背景
			k_sp_GoldIcon = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_GoldIcon"),   --金币icon
			k_tx_XiaZhu_Num = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_tx_XiaZhu_Num"),   --下注分数
			k_AddScore_Bg =  cc.uiloader:seekNodeByNameFast(user_info_ui, "k_img_result_bg_1"),   --结算分数
			k_ReduceScore_Bg =  cc.uiloader:seekNodeByNameFast(user_info_ui, "k_img_result_bg_2"),   --结算分数
			k_AddNum =  cc.uiloader:seekNodeByNameFast(user_info_ui, "AddNum"),   --结算分数
			k_ReduceNum =  cc.uiloader:seekNodeByNameFast(user_info_ui, "ReduceNum"),   --结算分数
			k_sp_lostline =  cc.uiloader:seekNodeByNameFast(user_info_ui, "k_sp_lostline"),   --离线标志
			k_node_effect_think = cc.uiloader:seekNodeByNameFast(user_info_ui, "k_node_effect_think"),   --算牌中特效父物体           
            effect_1 = cc.uiloader:seekNodeByNameFast(user_info_ui, "effect_1"),       			
			effect_2 = cc.uiloader:seekNodeByNameFast(user_info_ui, "effect_2"),
			effect_3 = cc.uiloader:seekNodeByNameFast(user_info_ui, "effect_3"),
			     
		}

		user_info_ui:setLocalZOrder(10)
		user_info_ui:setVisible(false)

		--椅子
		cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_sits_sp"):setLocalZOrder(10):hide()
		self.ui_sits[i] = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_sp_sit_" .. i)
		self.ui_sits[i]:setTouchEnabled(true)
		self.ui_sits[i]:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
		self.ui_sits[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) 
				if event.name == "began" then
					return true
				elseif event.name == "ended" then
					local tableId = gameScene.tableId
					local session = msgMgr:get_room_session()

					--gameScene.WRNN_Message.dispatchGame("room.LeaveGame")
					gameScene:clearScene(true)
					message.sendMessage("game.SitupReq", {session=session})
					message.unregisterHandle()

					local seat = gameScene.WRNN_Util.convertSeatToTable(i)
					print("旁观请求坐下 session=" .. session .. ",table=" .. tableId .. ",seat=" .. seat)
					message.sendMessage("game.SitdownReq", {
		                session = session, 
		                table = tableId, 
		                seat = seat, 
		                rule = userdata.Room.tableRule,
		            })
				end
			end)
	end
end

function WRNN_uiPlayerInfos:clear()
end

--[[
	* 显示玩家UI信息
	* @param table playerInfo  显示UI玩家的信息 昵称 金币等等
--]]
function WRNN_uiPlayerInfos:showPlayerInfoUI(playerInfo)
	--print("椅子号 = " .. playerInfo.seat .. "  "  ..playerInfo.name)

	--名字
	self.ui_infos[playerInfo.seat].k_tx_user_name:setString(util.checkNickName(playerInfo.name))
	--金币
	self.ui_infos[playerInfo.seat].k_tx_user_silver:setString(gameScene.WRNN_Util.num2str(playerInfo.gold))
	--准备
	self.ui_infos[playerInfo.seat].k_sp_ready:setVisible(playerInfo:isReadyState())
	self.ui_infos[playerInfo.seat].k_sp_ready:setLocalZOrder(10)
	--下注金额背景
	self.ui_infos[playerInfo.seat].k_sp_XiaZhuBG:setVisible(false)
	self.ui_infos[playerInfo.seat].k_sp_GoldIcon:setVisible(false)
	--下注金额
	self.ui_infos[playerInfo.seat].k_tx_XiaZhu_Num:setString("")
	self.ui_infos[playerInfo.seat].k_AddScore_Bg:setVisible(false)
	self.ui_infos[playerInfo.seat].k_ReduceScore_Bg:setVisible(false)
    --离线标志
	self.ui_infos[playerInfo.seat].k_sp_lostline:setVisible(false)
	self.ui_infos[playerInfo.seat].k_node_effect_think:setVisible(false)
	self.ui_infos[playerInfo.seat].k_node_effect_think:setLocalZOrder(11)
	self.ui_infos[playerInfo.seat].k_sp_lostline:setLocalZOrder(12)

	--头像背景
	-- local image = AvatarConfig:getAvatarBG(playerInfo.sex, playerInfo.gold, 0, 1)
 --    local rect = cc.rect(0, 0, 105, 105)
 --    local frame = cc.SpriteFrame:create(image, rect)
    --self.ui_infos[playerInfo.seat].k_sp_touxiang_bg:setSpriteFrame(frame)
    self.ui_infos[playerInfo.seat].k_sp_touxiang_bg:hide()

	--微信头像设置
    local img_userinfobg = self.ui_infos[playerInfo.seat].ui_body
    local img_touXiang = self.ui_infos[playerInfo.seat].k_sp_touxiang

	img_touXiang:show()
	--头像
	image = AvatarConfig:getAvatar(playerInfo.sex, playerInfo.gold, playerInfo.viptype)
    rect = cc.rect(0, 0, 188, 188)
    frame = cc.SpriteFrame:create(image, rect)
    self.ui_infos[playerInfo.seat].k_sp_touxiang:setSpriteFrame(frame)
    self.ui_infos[playerInfo.seat].k_sp_touxiang:setScale(0.4734)

	util.setHeadImage(img_userinfobg, playerInfo.imageid, img_touXiang, image, 1)

    self.ui_infos[playerInfo.seat].ui_body:setVisible(true)

    --隐藏可坐下
	if gameScene.watching == true then
		self.ui_sits[playerInfo.seat]:hide()
	end
end

--[[
	* 隐藏玩家UI信息(玩家离开)
	* @param int seatId  椅子号
--]]
function WRNN_uiPlayerInfos:hidePlayerInfoUI(seatId)
	self.ui_infos[seatId].ui_body:setVisible(false)

    local img_userinfobg = self.ui_infos[seatId].ui_body
    util.setImageNodeHide(img_userinfobg, 1)
	--显示可坐下
	if gameScene.watching == true then
		self.ui_sits[seatId]:show()
	end
end

--[[
	* 显示旁观椅子
--]]
function WRNN_uiPlayerInfos:showSits()
	cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_sits_sp"):show()
end

--[[
	* 隐藏所有玩家准备标示
--]]
function WRNN_uiPlayerInfos:hideAllPlayerReadyMark()
	for _,ui_info in pairs(self.ui_infos) do
		ui_info.k_sp_ready:setVisible(false)
	end
end

function WRNN_uiPlayerInfos:hidePlayerReadyMark(seat,visible)
	self.ui_infos[seat].k_sp_ready:setVisible(visible)
end

--[[
	* 显示下注数
	* table seats 当前参与游戏的玩家椅子号
--]]
function WRNN_uiPlayerInfos:showBetNum()
	
  --    local playerInfos =gameScene.WRNN_PlayerMgr.playerInfos
  --    for i=1,#playerInfos do
  --    	local info = playerInfos[i]
  --    	local seat = gameScene.WRNN_Util.convertSeatToPlayer(info.seat)

  --    	print("-------显示下注背景"..seat)
		-- --如果不是庄家
		-- if not gameScene.WRNN_PlayerMgr.playerInfos[seat]:isBankerIdentity() then
		-- 	self.ui_infos[seat].k_sp_XiaZhuBG:setVisible(true)
		-- 	self.ui_infos[seat].k_sp_GoldIcon:setVisible(true)
		-- 	self.ui_infos[seat].k_tx_XiaZhu_Num:setString("")
		-- end
  --    end
end

--[[
	* 刷新玩家下注数
	* @param number seatId 椅子号
	* @param number gold 下注金币数
--]]
function WRNN_uiPlayerInfos:updatePlayerBetUI(seatId,gold)
	local str = self.ui_infos[seatId].k_tx_XiaZhu_Num:getString()
	str = string.gsub(str, ",", "")
	local betGold = tonumber(str) or 0
	if gold ~= 0 then
		gold = gold + betGold
		self.ui_infos[seatId].k_tx_XiaZhu_Num:setString(gameScene.WRNN_Util.num2str(gold))
	    self.ui_infos[seatId].k_sp_XiaZhuBG:setVisible(true)
	    self.ui_infos[seatId].k_sp_GoldIcon:setVisible(true)
	end
end


--[[
	* 刷新玩家金币
	* @param number seatId 椅子号
	* @param number gold 金币数
--]]
function WRNN_uiPlayerInfos:udpatePlayerGoldUI(seatId,gold)

	-- self.ui_infos[seatId].k_sp_XiaZhuBG:setVisible(true)
	-- self.ui_infos[seatId].k_sp_GoldIcon:setVisible(true)
	self.ui_infos[seatId].k_tx_user_silver:setString(gameScene.WRNN_Util.num2str(gold))
end

--[[回复场景时候 恢复下注数据]]
function WRNN_uiPlayerInfos:updatePlayerBetUI_2(banker_seat,seatId,gold)
	
        if seatId ~= banker_seat then --不是庄家
        	
        	if  gold > 0  then
        		self.ui_infos[seatId].k_tx_XiaZhu_Num:setString(gameScene.WRNN_Util.num2str(gold))
        		self.ui_infos[seatId].k_sp_XiaZhuBG:setVisible(true)
				self.ui_infos[seatId].k_sp_GoldIcon:setVisible(true)
        	end
            
		else
			self.ui_infos[seatId].k_tx_XiaZhu_Num:setString("")
            self.ui_infos[seatId].k_sp_XiaZhuBG:setVisible(false)
			self.ui_infos[seatId].k_sp_GoldIcon:setVisible(false)
        end

end




--[[
	* 隐藏所有下注数字
--]]
function WRNN_uiPlayerInfos:hideAllBetNum()
	for _,ui_info in pairs(self.ui_infos) do
		ui_info.k_sp_GoldIcon:setVisible(false)
		ui_info.k_sp_XiaZhuBG:setVisible(false)
		ui_info.k_tx_XiaZhu_Num:setString("")
	end
end

--[[获取玩家金币位置  下注数字的位置]]
function WRNN_uiPlayerInfos:getGoldPos(seat)     
       local parent =  self.ui_infos[seat].k_sp_GoldIcon:getParent()
      

       local to_pos = cc.p(parent:getPositionX() + self.ui_infos[seat].k_sp_GoldIcon:getPositionX(),parent:getPositionY() + self.ui_infos[seat].k_sp_GoldIcon:getPositionY())
       local from_pos = cc.p(parent:getPositionX() + self.ui_infos[seat].k_tx_user_silver:getPositionX(),parent:getPositionY() + self.ui_infos[seat].k_tx_user_silver:getPositionY())
    return from_pos,to_pos
end


--获取头像的中心位置
function WRNN_uiPlayerInfos:getHeadIconPos(seat)
	 local parent =  self.ui_infos[seat].k_sp_GoldIcon:getParent()
	 local pos = cc.p(parent:getPositionX()+self.ui_infos[seat].k_sp_touxiang_bg:getPositionX(),parent:getPositionY()+self.ui_infos[seat].k_sp_touxiang_bg:getPositionY())
     return pos
end


--控制金币icon显示

function WRNN_uiPlayerInfos:setGoldIconVisable(seat,visible) 
         self.ui_infos[seat].k_sp_GoldIcon:setVisible(visible)
end

--结算显示输赢数字
function WRNN_uiPlayerInfos:setResultNum(seat,num) 
         if num < 0 then
         	self.ui_infos[seat].k_AddScore_Bg:hide()
         	self.ui_infos[seat].k_ReduceScore_Bg:show()
         	self.ui_infos[seat].k_ReduceNum:setString(""..math.abs(num))
         else
         	self.ui_infos[seat].k_AddScore_Bg:show()
         	self.ui_infos[seat].k_ReduceScore_Bg:hide()
         	self.ui_infos[seat].k_AddNum:setString(""..math.abs(num))      	
         end      
end

function WRNN_uiPlayerInfos:closeAllResultNum() 
        for i=1,#self.ui_infos do
        	self.ui_infos[i].k_AddScore_Bg:hide()
         	self.ui_infos[i].k_ReduceScore_Bg:hide()
        end
end


--显示算牌中动画
function WRNN_uiPlayerInfos:showThinkCardAnimation(seat,visible)
     if visible then
     	self.ui_infos[seat].k_node_effect_think:show()
        local items = {self.ui_infos[seat].effect_1,self.ui_infos[seat].effect_2,self.ui_infos[seat].effect_3}
       
     	gameScene.WRNN_Util.showThinkCardTypeAnimation(self.ui_infos[seat].k_node_effect_think ,items, 0.5)
    else
       self.ui_infos[seat].k_node_effect_think:hide()
       self.ui_infos[seat].effect_1:stopAllActions()
       self.ui_infos[seat].effect_2:stopAllActions()
       self.ui_infos[seat].effect_3:stopAllActions()

    end
end
function WRNN_uiPlayerInfos:setLostLineVisible(seat,visible)
       self.ui_infos[seat].k_sp_lostline:setVisible(visible)
       if visible then
       	   self:showThinkCardAnimation(seat,false)

       end
end

--返回用户头像spriteFrame  不能用
function WRNN_uiPlayerInfos:getHeadIconSpriteFrame(seat)

     --    local  parent  = self.ui_infos[seat].k_sp_touxiang
	    -- local WXHEAD = parent:getChildByName("WXHEAD")
	    -- if WXHEAD ~= nil then
	    --    return WXHEAD:getSpriteFrame()
	    -- else
	    -- 	return parent:getSpriteFrame()
	    -- end  
	--	return  self.ui_infos[seat].k_sp_touxiang:getSpriteFrame()--getSpriteFrame()
	return nil
end

return WRNN_uiPlayerInfos