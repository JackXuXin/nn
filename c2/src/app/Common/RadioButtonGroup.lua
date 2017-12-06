local RadioButtonGroup = {}

--[[
	－ 单选按钮组管理器，仅支持UICheckBoxButton。
	－ 参数 checkboxButtons 格式：
		1、	单独的UICheckBoxButton ，表示{checkboxButtons = false}，见2
		2、	传入数组：
			{
				UICheckBoxButton1 = callback1, 
				UICheckBoxButton2 = callback2,
				UICheckBoxButton3 = false, 
			}
			将数组内的button加入组内。callback不为false时表示当元素被选中时调用，callback参数为UICheckBoxButton。

	－ 方法 addButtons 可多次执行
--]]

function RadioButtonGroup.new(checkboxButtons)
	local group = {}
	group.buttons_ = setmetatable({}, {__mode = "k"})
	group.selected_ = nil

	function group:addButtons(checkboxButtons)
		if not checkboxButtons then
			return
		end
		
		if type(checkboxButtons) == "userdata" and iskindof(checkboxButtons, "UICheckBoxButton") then
			checkboxButtons = {checkboxButtons = false}
		end

		if type(checkboxButtons) == "table" then
			for button,callback in pairs(checkboxButtons) do
				if iskindof(button, "UICheckBoxButton") then
					local callbacks = {
						button:addEventListener(cc.ui.UICheckBoxButton.STATE_CHANGED_EVENT, handler(self, self.onClick)),
						callback or nil,
					}

					self.buttons_[button] = callbacks
				end
			end
		end
	end

	function group:removeButton(arrayButtons)
		if type(arrayButtons) == "userdata" and iskindof(arrayButtons, "UICheckBoxButton") then
			arrayButtons = {arrayButtons}
		end

		if type(arrayButtons) == "table" then
			for _,button in ipairs(arrayButtons) do
				local callbacks = self.buttons_[button]
				if callbacks then
					button:removeEventListener(callbacks[1])
					button:removeEventListener(callbacks[2])

					self.buttons_[button] = nil

					if self.selected_ == tostring(button) then
						self.selected_ = nil
					end
				end
			end
		end
	end

	function group:clear()
		for button,callbacks in pairs(self.buttons_) do
			button:removeEventListener(callbacks[1])
			button:removeEventListener(callbacks[2])
		end
		self.buttons_ = {}
		self.selected_ = nil
	end

	function group:onClick(event)
		if not event.target:isButtonSelected() then
			return
		end

		self.selected_ = tostring(event.target)

		event.target:setTouchEnabled(false)
		local userCallback
		for button,callbacks in pairs(self.buttons_) do
			if button ~= event.target then
				button:setButtonSelected(false)
				button:setTouchEnabled(true)
				if button.text then
					button.text:setColor(cc.c3b(255,255,255))
				end
			else
				userCallback = callbacks[2]
				if button.text then
					button.text:setColor(cc.c3b(255,216,0))
				end
			end
		end

		if userCallback then
			userCallback(event.target)
		end
	end

	function group:getSelected()
		for button,_ in pairs(self.buttons_) do
			if self.selected_ == tostring(button) then
				return button
			end
		end

		return nil
	end

	group:addButtons(checkboxButtons)
	return group
end

return RadioButtonGroup