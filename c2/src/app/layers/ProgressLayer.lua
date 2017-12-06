local ProgressLayer = class("ProgressLayer", function ()
	return cc.uiloader:load("Layer/TipsLayer.json")
end)

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local ErrorLayer = import(".ErrorLayer")

function ProgressLayer:ctor(text, timeout, timeoutCallback, finishCallback)
	timeout = timeout or app.constant.network_loading
	self.timeoutCallback = timeoutCallback or handler(self, self.defaultTimeoutCallback)
	self.finishCallback = finishCallback

	self.loading = cc.uiloader:seekNodeByName(self, "Loading")
	self.body = cc.uiloader:seekNodeByName(self, "Body")
	self.tips = cc.uiloader:seekNodeByName(self, "Tips")

    if timeout == -1 then

    	 local action = cc.RepeatForever:create(cca.rotateBy(0.05, 10))
		transition.execute(self.loading, action)

    else

		local action = cc.Repeat:create(cca.rotateBy(0.05, 10), timeout / 0.05)
		transition.execute(self.loading, action, {
		onComplete = function ()
			if self.timeoutCallback then
				self.timeoutCallback()
			end
			ProgressLayer.removeProgressLayer(self)
		end

		})

    end


	self:setText(text)
end

function ProgressLayer:defaultTimeoutCallback()
	if self:getParent() then
	    ErrorLayer.new(app.lang.network_disabled):addTo(self:getParent())
    end
end

function ProgressLayer:setText(text)
	self.tips:setString(text)
	local newWidth = 80 + self.loading:getContentSize().width + self.tips:getContentSize().width
	local _, height = self.body:getLayoutSize()
	self.body:setLayoutSize(newWidth, height)
end

-- use this to remove ProgressLayer
function ProgressLayer.removeProgressLayer(progressLayer)
	if progressLayer and not tolua.isnull(progressLayer) and iskindof(progressLayer, "ProgressLayer") then
		if progressLayer.finishCallback then
			progressLayer.finishCallback()
		end
		progressLayer:removeFromParent()
	end
end

return ProgressLayer