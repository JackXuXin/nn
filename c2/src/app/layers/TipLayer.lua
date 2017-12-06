local TipLayer = class("TipLayer", function ()
	return cc.uiloader:load("Node/TipNode.json")
end)

function TipLayer:ctor(text, delay, fadeTime)
	local body = cc.uiloader:seekNodeByName(self, "Body")
	local label = cc.uiloader:seekNodeByName(self, "Tips")

	-- change body size
	label:setString(text)
	local newWidth = 240 + label:getContentSize().width
	local _, height = body:getLayoutSize()
	body:setLayoutSize(newWidth, height)

	-- translate
	transition.fadeOut(body, {
		delay = delay or 1,
		time = fadeTime or 0,
		onComplete = function ()
			self:stop()
		end,
	})

	self:setTouchEnabled(false)
end

function TipLayer:stop()
	transition.stopTarget(self)

	self:removeFromParent()
end

return TipLayer