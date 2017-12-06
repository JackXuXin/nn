--
-- Author: peter
-- Date: 2017-02-17 13:50:51
--

local SRDDZ_PlayerInfo = class("SRDDZ_PlayerInfo")

--[[
	* 对象构造函数
	* @param table data  玩家数据
--]]
function SRDDZ_PlayerInfo:ctor(data)
	self.mGold = data.player.gold 		--金币数
	self.mName = data.player.name     	--名字
	self.sex = data.player.sex  		--性别  1 = 女
	self.ready = data.player.ready	    --是否已经准备 0没准备 1已准备
	self.seat = data.seat 		--本地椅子号
	self.viptype = data.player.viptype 		--本地椅子号
	self.imageid = data.player.imageid
	self.mIsTuoGuan = false     --是否开启托管
	self.mIsLandlord = false   --是不是地主
end

return SRDDZ_PlayerInfo