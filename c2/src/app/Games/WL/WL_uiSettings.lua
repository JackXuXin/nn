--
-- Author: peter
-- Date: 2017-03-10 19:58:30
--

local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")

local gameScene = nil

local WL_uiSettings = {}

function WL_uiSettings:init(scene)
	gameScene = scene

	self.btn_settings = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_settings")
    self.btn_settings:setLocalZOrder(10)
	self.con_settings = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_container_settings")
	self.con_settings:setLocalZOrder(10)
	self.btn_sound = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_sound")
	self.btn_exit = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_exit")
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
end

function WL_uiSettings:clear()
end

function WL_uiSettings:update()
	if gameScene.WL_Util.hasSound() then
		self.btn_sound:setButtonImage("normal", gameScene.WL_Const.PATH.BTN_SOUND_NORMAL, true)
    	self.btn_sound:setButtonImage("pressed", gameScene.WL_Const.PATH.BTN_SOUND_PRESSED, true)
    else
    	self.btn_sound:setButtonImage("normal", gameScene.WL_Const.PATH.BTN_MUTE_NORMAL, true)
    	self.btn_sound:setButtonImage("pressed", gameScene.WL_Const.PATH.BTN_MUTE_PRESSED, true)
	end

	if self.is_settings_upped then
		self.btn_settings:setButtonImage("normal", gameScene.WL_Const.PATH.BTN_CCDOWN_NORMAL, true)
	else
		self.btn_settings:setButtonImage("normal", gameScene.WL_Const.PATH.BTN_CCUP_NORMAL, true)
	end
end

function WL_uiSettings:clickSettings()
	self.is_settings_upped = not self.is_settings_upped
	self:showSettings(not self.is_settings_upped)
	self:update()
end

function WL_uiSettings:clickSound()
	if self.btn_sound == nil then 
		return 
	end

	gameScene.WL_Util.switchSound()
	self:update()
end

function WL_uiSettings:clickExit()
	print("clickExit")

	-- exit reminder
    MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()
			-- send leave table msg to server then quit table
			gameScene.WL_Message.dispatchGame("room.LeaveGame",gameScene.WL_Const.REQUEST_INFO_01)
        end)
    :addTo(gameScene)
end

function WL_uiSettings:showSettings(flag)
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

return WL_uiSettings