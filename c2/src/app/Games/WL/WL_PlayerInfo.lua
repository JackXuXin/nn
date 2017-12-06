--
-- Author: peter
-- Date: 2017-03-10 17:07:33
--

local WL_PlayerInfo = class("WL_PlayerInfo")

--[[
	* 对象构造函数
	* @param table data  玩家数据
--]]
function WL_PlayerInfo:ctor(data)
	self.gold = data.player.gold 		--金币数
	self.name = data.player.name     	--名字
	self.sex = data.player.sex  		--性别  1 = 女
	self.ready = data.player.ready	    --是否已经准备 0没准备 1已准备
	self.viptype = data.player.viptype 		--vip 类型
	self.seat = data.seat 				--本地椅子号
	self.isTuoGuan = false     		--是否开启托管
	self.imageid = data.imageid
end

--[[
	* 设置准备状态
	* @param number ready 准备状态   0没准备 1已准备
--]]
function WL_PlayerInfo:setReadyState(ready)
	self.ready = ready
end

--[[
	* 获取准备状态
	@return boolean --准备状态
--]]
function WL_PlayerInfo:isReadyState()
	return self.ready == 1
end

--[[
	* 玩家名字
	@return stirng 玩家名字
--]]
function WL_PlayerInfo:getName()
	return self.name
end

--[[
	* 设置托管状态
	* @param boolean flag 开启状态
--]]
function WL_PlayerInfo:setTuoGuan(flag)
	self.isTuoGuan = flag
end

--[[
	* 获取托管状态
--]]
function WL_PlayerInfo:getTuoGuan()
	return self.isTuoGuan
end

--[[
	* 获取性别
--]]
function WL_PlayerInfo:getSex()
	return self.sex
end 

return WL_PlayerInfo