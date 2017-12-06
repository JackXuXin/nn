--
-- Author: peter
-- Date: 2017-04-21 09:47:57
--

local WRNN_PlayerInfo = class("WRNN_PlayerInfo")
local utilCom = require("app.Common.util")

function WRNN_PlayerInfo:ctor(data)
	self.gold = tonumber(data.player.gold) 		--金币数
	self.name = utilCom.checkNickName(data.player.name)     	--名字
	self.sex = data.player.sex  		--性别  1 = 女
	self.ready = data.player.ready	    --是否已经准备 0没准备 1已准备
	self.viptype = data.player.viptype 		--vip 类型
	self.imageid = data.player.imageid
	self.seat = data.seat 
	self.uid  = data.player.uid	 or 0 			
	self.isBanker = false   --是不是庄家

end

--[[
	* 设置准备状态
	* @param number ready 准备状态   0没准备 1已准备
--]]
function WRNN_PlayerInfo:setReadyState(ready)
	self.ready = ready
end

--[[
	* 获取准备状态
	@return boolean --准备状态
--]]
function WRNN_PlayerInfo:isReadyState()
	return self.ready == 1
end

--[[
	* 获取金币数
	* @return number 金币
--]]
function WRNN_PlayerInfo:getGold()
	return self.gold
end

--[[
	* 设置金币数
	* @param number gold 金币
--]]
function WRNN_PlayerInfo:setGold(gold)
	self.gold = gold
end

--[[
	* 获取庄家身份
	* @return bool 庄家身份
--]]
function WRNN_PlayerInfo:isBankerIdentity()
	return self.isBanker
end

--[[
	* 设置庄家身份
	* @param bool banker 庄家身份
--]]
function WRNN_PlayerInfo:setBankerIdentity(banker)
	self.isBanker = banker
end

--[[
	* 玩家名字
	@return stirng 玩家名字
--]]
function WRNN_PlayerInfo:getName()
	return self.name
end

--[[
	* 获取性别
	@return int 性别 1 == 女
--]]
function WRNN_PlayerInfo:getSex()
	return self.sex
end

function WRNN_PlayerInfo:getImgId()
	return self.imageid
end

return WRNN_PlayerInfo