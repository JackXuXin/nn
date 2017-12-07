--
-- Author: peter
-- Date: 2017-02-17 13:52:57
--


local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
local SRDDZ_Message = require("app.Games.SRDDZ.SRDDZ_Message")
local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")

local PATH = SRDDZ_Const.PATH

local gameScene = nil

local SRDDZ_uiSettings = {}

function SRDDZ_uiSettings:init(tableScene)
	gameScene = tableScene
    self.btn_settings = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_settings")
    self.btn_settings:setLocalZOrder(10)
	self.con_settings = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_container_settings")
	self.con_settings:setLocalZOrder(10)
	self.btn_sound = cc.uiloader:seekNodeByName(gameScene.root, "k_btn_sound")
	self.btn_exit = cc.uiloader:seekNodeByName(gameScene.root, "k_btn_exit")
    self.btn_settings:onButtonClicked(function() self:clickSettings() end)
    self.btn_sound:onButtonClicked(function() self:clickSound() end)
    self.btn_exit:onButtonClicked(function() self:clickExit() end)

    self.is_settings_upped = true
    self.out_of_screen = self.con_settings:getPositionY()
    				+ self.con_settings:getContentSize().height
    				- display.height
    self.settings_move_dis = self.con_settings:getContentSize().height 
					- self.btn_settings:getCascadeBoundingBox().size.height * 0.9
					- self.out_of_screen

	self:showSettings(false)
	SRDDZ_Util.init_autio()
	self:update()
	return self
end

function SRDDZ_uiSettings:clear()
	SRDDZ_Util.clear()
end

function SRDDZ_uiSettings:update()
	if SRDDZ_Util.hasSound() then
		self.btn_sound:setButtonImage("normal", PATH.BTN_SOUND_NORMAL, true)
    	self.btn_sound:setButtonImage("pressed", PATH.BTN_SOUND_PRESSED, true)
    else
    	self.btn_sound:setButtonImage("normal", PATH.BTN_MUTE_NORMAL, true)
    	self.btn_sound:setButtonImage("pressed", PATH.BTN_MUTE_PRESSED, true)
	end

	if self.is_settings_upped then
		self.btn_settings:setButtonImage("normal", PATH.BTN_CCDOWN_NORMAL, true)
	else
		self.btn_settings:setButtonImage("normal", PATH.BTN_CCUP_NORMAL, true)
	end
end

function SRDDZ_uiSettings:clickSettings()
	self.is_settings_upped = not self.is_settings_upped
	self:showSettings(not self.is_settings_upped)
	self:update()

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

function SRDDZ_uiSettings:clickSound()
	if self.btn_sound == nil then 
		return 
	end

	SRDDZ_Util.switchSound()
	self:update()

	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

function SRDDZ_uiSettings:clickExit()
	print("clickExit")
    
    local pop = nil
	-- exit reminder
    pop = MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()

        	pop:removeFromParent()
       		pop = nil
			-- send leave table msg to server then quit table
			SRDDZ_Message.dispatchGame("room.LeaveGame",SRDDZ_Const.REQUEST_INFO_01)
        end)
    :addTo(gameScene)

    gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BEHAVIOR)
end

function SRDDZ_uiSettings:showSettings(flag)
	self.btn_sound:setVisible(flag)
	self.btn_sound:setButtonEnabled(flag)
	self.btn_exit:setVisible(flag)
	self.btn_exit:setButtonEnabled(flag)

	self.con_settings:setVisible(flag)

	-- if flag then
	-- 	self.con_settings:setPositionY(self.con_settings:getPositionY() - self.settings_move_dis)
	-- else
	-- 	self.con_settings:setPositionY(self.con_settings:getPositionY() + self.settings_move_dis)
	-- end
end


return SRDDZ_uiSettings
