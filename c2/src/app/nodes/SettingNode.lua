local SettingNode = class("SettingNode", function ()
	return cc.uiloader:load("Node/SettingNode.json")
end)

local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local sound_common = require("app.Common.sound_common")

function SettingNode:ctor(soundChangeCallback, exitCallback, time)
	-- has sound tag
	self.sound = true

	local background = cc.uiloader:seekNodeByNameFast(self, "Setting_Background")

	-- open or close setting node
	local openSetting = cc.uiloader:seekNodeByNameFast(background, "OpenSetting")
	local closeSetting = cc.uiloader:seekNodeByNameFast(background, "CloseSetting")
	openSetting:onButtonClicked(function ()
		openSetting:setTouchEnabled(false)
		transition.moveTo(self, {
			x = self:getPositionX() - background:getBoundingBox().width, 
			time = time or 0.5,
			onComplete = function ()
				openSetting:setTouchEnabled(true)
				openSetting:hide()
				closeSetting:show()
			end,
		})
	end)
	closeSetting:onButtonClicked(function ()
		closeSetting:setTouchEnabled(false)
		transition.moveTo(self, {
			x = self:getPositionX() + background:getBoundingBox().width, 
			time = time or 0.5,
			onComplete = function ()
				closeSetting:setTouchEnabled(true)
				closeSetting:hide()
				openSetting:show()
			end,
		})
	end)

	-- exit table
	local exit = cc.uiloader:seekNodeByNameFast(background, "Exit")
	
	exit:onButtonClicked(function ()
	
		local scene = display.getRunningScene()

		if scene then

			MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips, 
				MiddlePopBoxLayer.ConfirmTable, true, nil, exitCallback)
			  
				--Fsound_common.confirm()
			:addTo(scene)
		end
	end)

	-- open or close volumn
	local openVolumn = cc.uiloader:seekNodeByNameFast(background, "OpenVolumn")
	local closeVolumn = cc.uiloader:seekNodeByNameFast(background, "CloseVolumn")
	openVolumn:onButtonClicked(function ()
		openVolumn:hide()
		closeVolumn:show()
		self.sound = true
		soundChangeCallback(self.sound)
	end)
	closeVolumn:onButtonClicked(function ()
		closeVolumn:hide()
		openVolumn:show()
		self.sound = false
		soundChangeCallback(self.sound)
	end)
end

function SettingNode:hasSound()
	return self.sound
end

return SettingNode