-- example: require("app.layers.ErrorLayer").new("msg", 1, 2) 

local ErrorLayer = class("ErrorLayer", function ()
	return cc.uiloader:load("Layer/ErrorLayer.json")
end)

function ErrorLayer:ctor(text, fadeTime, delay, finishCallback, type)
	self.finishCallback = finishCallback

	local background = cc.uiloader:seekNodeByName(self, "Background")
	local body = cc.uiloader:seekNodeByName(self, "Body")
	local label = cc.uiloader:seekNodeByName(self, "Error")

	-- change body size
	label:setString(text)
	local newWidth = 60 + label:getContentSize().width
	local newHeight = 50 + label:getContentSize().height
	body:setLayoutSize(newWidth, newHeight)

	if type ~= nil and type == 1 then

		local time = delay or 1

		-- self.handler = scheduler.scheduleGlobal(function ()
		-- 	self:stop()
		-- end, time)

		background:setOpacity(0)

		-- local sequence = transition.sequence({cc.DelayTime:create(time)})
  --       transition.execute(body, sequence, {
		-- onComplete = function ()
		-- 		self:stop()
		-- 		end
		-- })

		transition.fadeOut(body, {
			time = fadeTime or 0.5,
			delay = delay or 1,
			onComplete = function ()
				self:stop()
			end,
		})

	else
			-- translate
		transition.fadeOut(body, {
			time = fadeTime or 0.5,
			delay = delay or 1,
			onComplete = function ()
				self:stop()
			end,
		})

		self:setTouchEnabled(true)
	    self:setTouchSwallowEnabled(true)
		background:setTouchEnabled(true)
	    background:setTouchSwallowEnabled(true)
		background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			print(event.name)
			self:stop()
			return true
		end)

	end
end

function ErrorLayer:stop()
	transition.stopTarget(self)

	if self.finishCallback then
		self.finishCallback()
	end

	if self.handler then

		scheduler.unscheduleGlobal(self.handler)
		self.handler = nil
	end

	self:removeFromParent()
end

return ErrorLayer