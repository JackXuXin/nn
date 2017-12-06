--
-- K
-- Date: 2017-01-05 14:17:42
-- 结算图层
--

local DDZ_SettlementLayer =  class("DDZ_SettlementLayer",function()
		return cc.uiloader:load("Layer/Game/DDZ/SettlementLayer.json")
	end)

local DDZ_Message = require("app.Games.DDZ.DDZ_Message")
local DDZ_Audio = require("app.Games.DDZ.DDZ_Audio")
local util = require("app.Common.util")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local sound_common = require("app.Common.sound_common")
local startButton
local leaveButton

-- start --

--------------------------------
-- 创建一个结算图层
-- @function create
-- @param userdata  sceneSelf    	 当前场景
-- @param table SettlementInfo   	 结算信息

-- end --

function DDZ_SettlementLayer:create()
	local layer = DDZ_SettlementLayer.new()

	-- layer:init(sceneSelf,SettlementInfo)
	return layer
end

-- start --

--------------------------------
-- 构造函数   定义一些成员变量
-- @function ctor

-- end --

function DDZ_SettlementLayer:ctor()
	self.m_sceneSelf = nil
	--监听按钮事件
	startButton = cc.uiloader:seekNodeByNameFast(self, "k_btn_ZaiLai")
	leaveButton = cc.uiloader:seekNodeByNameFast(self, "k_btn_TuiChu")
	leaveButton:onButtonClicked(handler(self,self.clickTuiChu))
	startButton:onButtonClicked(handler(self,self.clickZaiLai))
end

-- start --

--------------------------------
-- 创建一个结算图层
-- @function init
-- @param userdata  sceneSelf    	 当前场景
-- @param table SettlementInfo   	 结算信息

-- end --

function DDZ_SettlementLayer:init(sceneSelf,SettlementInfo)
	-- dump(SettlementInfo, "SettlementInfo")
	self.m_sceneSelf = sceneSelf

	if self.m_sceneSelf.maxPlayer>3 or self.m_sceneSelf.maxCards == 108 then
		cc.uiloader:seekNodeByNameFast(self, "title_1"):setVisible(false) --包含倍数
		cc.uiloader:seekNodeByNameFast(self, "title_2"):setVisible(true)
		local title = cc.uiloader:seekNodeByNameFast(self, "title_2")
		for i=1,4 do
			cc.uiloader:seekNodeByNameFast(title, "hang_" ..i):setVisible(false)
		end

		for k,v in ipairs(SettlementInfo.player) do
			local seat = self.m_sceneSelf:convertSeatToPlayer(v.seat)
			if seat == 1 then
				if tonumber(v.score)>0 then
					local img_bg = cc.uiloader:seekNodeByNameFast(self, "img_bg")
				    local frame = cc.SpriteFrame:create("Image/DDZ/result/victoty_BG.png",cc.rect(0,0,1278,670))
				    img_bg:setSpriteFrame(frame)
				else
					local img_bg = cc.uiloader:seekNodeByNameFast(self, "img_bg")
				    local frame = cc.SpriteFrame:create("Image/DDZ/result/fail_BG.png",cc.rect(0,0,1278,670))
				    img_bg:setSpriteFrame(frame)
				end
			end

			local name = crypt.base64decode(v.name)
	        name = util.checkNickName(name)
	        local hang = cc.uiloader:seekNodeByNameFast(title, "hang_" ..v.seat)
	        print("v.seat",v.seat)
	        print("SettlementInfo.dizhu",SettlementInfo.dizhu)
	        hang:setVisible(true)
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_name"):setString(name)									--名字
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_DiFen"):setString(tostring(SettlementInfo.di))	  	--低分
			-- cc.uiloader:seekNodeByNameFast(hang, "k_tx_BeiShu"):setString("X" .. tostring(SettlementInfo.bei))			--倍数
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_FenShu"):setString(tostring(v.score))						--分数
			cc.uiloader:seekNodeByNameFast(hang,"zhuang_icon"):setVisible(false)
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_name"):setColor(cc.c3b(255,255,255))						--名字
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_DiFen"):setColor(cc.c3b(255,255,255))			  		--低分
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_FenShu"):setColor(cc.c3b(255,255,255))
			if SettlementInfo.dizhu == v.seat then --如果是地主  文字的颜色变一下
				cc.uiloader:seekNodeByNameFast(hang,"zhuang_icon"):setVisible(true)
				
			end
			if v.seat == self.m_sceneSelf.seatIndex then
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_name"):setColor(cc.c3b(224,172,76))						--名字
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_DiFen"):setColor(cc.c3b(224,172,76))			  		--低分
				-- cc.uiloader:seekNodeByNameFast(hang, "k_tx_BeiShu"):setColor(cc.c3b(224,172,76))					--倍数
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_FenShu"):setColor(cc.c3b(224,172,76))					--分数
			end
		end
		
	else
		cc.uiloader:seekNodeByNameFast(self, "title_1"):setVisible(true) --包含倍数
		cc.uiloader:seekNodeByNameFast(self, "title_2"):setVisible(false) --不包含倍数
		local title = cc.uiloader:seekNodeByNameFast(self, "title_1")
		for i=1,4 do
			cc.uiloader:seekNodeByNameFast(title, "hang_" ..i):setVisible(false)
		end
		for k,v in ipairs(SettlementInfo.player) do

			local seat = self.m_sceneSelf:convertSeatToPlayer(v.seat)
			if seat == 1 then
				if tonumber(v.score) >0 then
					local img_bg = cc.uiloader:seekNodeByNameFast(self, "img_bg")
				    local frame = cc.SpriteFrame:create("Image/DDZ/result/victoty_BG.png",cc.rect(0,0,1278,670))
				    img_bg:setSpriteFrame(frame)
				else
					local img_bg = cc.uiloader:seekNodeByNameFast(self, "img_bg")
				    local frame = cc.SpriteFrame:create("Image/DDZ/result/fail_BG.png",cc.rect(0,0,1278,670))
				    img_bg:setSpriteFrame(frame)
				end
			end

			local name = crypt.base64decode(v.name)
	        name = util.checkNickName(name)
	        local hang = cc.uiloader:seekNodeByNameFast(title, "hang_" ..v.seat)
	        print("v.seat",v.seat)
	        print("SettlementInfo.dizhu",SettlementInfo.dizhu)
	        hang:setVisible(true)
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_name"):setString(name)									--名字
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_DiFen"):setString(tostring(SettlementInfo.di))	  	--低分
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_BeiShu"):setString("X" .. tostring(SettlementInfo.bei))			--倍数
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_FenShu"):setString(tostring(v.score))						--分数
			cc.uiloader:seekNodeByNameFast(hang,"zhuang_icon"):setVisible(false)
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_name"):setColor(cc.c3b(255,255,255))						--名字
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_DiFen"):setColor(cc.c3b(255,255,255))			  		--低分
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_BeiShu"):setColor(cc.c3b(255,255,255))					--倍数
			cc.uiloader:seekNodeByNameFast(hang, "k_tx_FenShu"):setColor(cc.c3b(255,255,255))					--分数
			if SettlementInfo.dizhu == v.seat then --如果是地主  文字的颜色变一下
				cc.uiloader:seekNodeByNameFast(hang,"zhuang_icon"):setVisible(true)
				
			end
			if v.seat == self.m_sceneSelf.seatIndex then
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_name"):setColor(cc.c3b(224,172,76))						--名字
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_DiFen"):setColor(cc.c3b(224,172,76))			  		--低分
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_BeiShu"):setColor(cc.c3b(224,172,76))					--倍数
				cc.uiloader:seekNodeByNameFast(hang, "k_tx_FenShu"):setColor(cc.c3b(224,172,76))					--分数
			end
		end
		
	end
	

	
end

-- start --

--------------------------------
-- 退出房间 按钮回调
-- @function clickTuiChu

-- end --
function DDZ_SettlementLayer:hideButton()
	startButton:hide()
	leaveButton:hide()
end
function DDZ_SettlementLayer:clickTuiChu()
	print("clickTuiChu")
	MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()
            sound_common.confirm()
            -- send leave table msg to server then quit table
            self.m_sceneSelf:onLeave()
        end)
    :addTo(self)
	

	-- self:removeFromParent()
end

-- start --

--------------------------------
-- 再来一局 按钮回调
-- @function clickTuiChu

-- end --
function DDZ_SettlementLayer:clickZaiLai()
	self.m_sceneSelf:againStart()
	self.m_sceneSelf:ReadyNextRound()
	audio.stopAllSounds()
	DDZ_Audio.playSoundWithPath(DDZ_Audio.preloadResPath.DDZ_SOUND_CONTINUE)

	self:hide()
end
function DDZ_SettlementLayer:clear()
    startButton=nil
    leaveButton=nil
end

return DDZ_SettlementLayer


