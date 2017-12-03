local RoomCreateLayer = class("RoomCreateLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)
local privateRoomController = require("app.controllers.PrivateRoomController")

function RoomCreateLayer:ctor()
	display.newRect(cc.rect(0, 0, 1280, 720),{fillColor = cc.c4f(0,0,0,0.5)}):addTo(self, -1)

	local images = {
		off = "Image/check.png",
		off_pressed = "Image/check.png",
		off_disable = "Image/check.png",
		on = "Image/check_press.png",
		on_pressed = "Image/check_press.png",
		on_disable = "Image/check_press.png"
	}


	self.aaDiamondText = cc.uiloader:seekNodeByName(self, "num_diamond_AA")
	self.ownerDiamondText = cc.uiloader:seekNodeByName(self, "num_diamond_owner")
	self.aaDiamond = cc.uiloader:seekNodeByName(self, "zhuanshi_icon_AA")
	self.ownerDiamond = cc.uiloader:seekNodeByName(self, "zhuanshi_icon_owner")

	cc.uiloader:seekNodeByName(self, "close"):onButtonClicked(handler(self, self.close))

	local roundGroup = cc.ui.UICheckBoxButtonGroup.new(display.LEFT_TO_RIGHT)
		:addButton(cc.ui.UICheckBoxButton.new(images):setButtonLabel(cc.ui.UILabel.new({text = "2局", color = cc.c3b(173, 173, 173), size = 30})):setButtonLabelOffset(25, 0))
		:addButton(cc.ui.UICheckBoxButton.new(images):setButtonLabel(cc.ui.UILabel.new({text = "4局", color = cc.c3b(173, 173, 173), size = 30})):setButtonLabelOffset(25, 0))
		:addButton(cc.ui.UICheckBoxButton.new(images):setButtonLabel(cc.ui.UILabel.new({text = "8局", color = cc.c3b(173, 173, 173), size = 30})):setButtonLabelOffset(25, 0))
		:setButtonsLayoutMargin(0,75,0,0)

	roundGroup:addTo(self):pos(460, 595)
	roundGroup:onButtonSelectChanged(handler(self, self.onButtonSelectRound))
	roundGroup:getButtonAtIndex(1):setButtonSelected(true)

	local modeGroup = cc.ui.UICheckBoxButtonGroup.new(display.LEFT_TO_RIGHT)
		:addButton(cc.ui.UICheckBoxButton.new(images):setButtonLabel(cc.ui.UILabel.new({text = "房主支付", color = cc.c3b(173, 173, 173), size = 30})):setButtonLabelOffset(25, 0))
		:addButton(cc.ui.UICheckBoxButton.new(images):setButtonLabel(cc.ui.UILabel.new({text = "AA支付", color = cc.c3b(173, 173, 173), size = 30})):setButtonLabelOffset(25, 0))
		:setButtonsLayoutMargin(0,150,0,0)

	modeGroup:addTo(self):pos(425, 490)
	modeGroup:onButtonSelectChanged(handler(self, self.onButtonSelectGroup))
	modeGroup:getButtonAtIndex(1):setButtonSelected(true)

	cc.uiloader:seekNodeByName(self, "create"):onButtonClicked(handler(self, self.create))
	cc.uiloader:seekNodeByName(self, "createDummy"):onButtonClicked(handler(self, self.createDummy))
end

function RoomCreateLayer:create(  )
	privateRoomController:create(self.round, self.mode)
end

function RoomCreateLayer:createDummy(  )
	privateRoomController:createDummy(self.round, 1, handler(self, self.addTable))
end

function RoomCreateLayer:addTable( ok, msg )
	if not ok then
		return 
	end

	if msg.result == "success" then
		self:getParent():addTable(msg)
	else
		print(msg.result)
	end
	self:removeSelf()
end

function RoomCreateLayer:onButtonSelectRound( event )
	self.round = 2 ^ event.selected 
	self:setDiamondCount()
	print(self.round)
end

function RoomCreateLayer:onButtonSelectGroup( event )
	self.mode = event.selected
	self:setDiamondCount()
	-- print(self.mode)
end

function RoomCreateLayer:getRoundBottonClicked( target )
	for i=1,3 do
		if target:getName() == "round_"..2^i then
			target:setSelected(true)
		else
			target:setSelected(false)
		end
	end
end

function RoomCreateLayer:close(  )
	self:removeSelf()
end

function RoomCreateLayer:getDiamondCount(  )
	print("count = ", self.round * (self.mode == 1 and 6 or 1) * 5)
	return self.round * (self.mode == 1 and 6 or 1) * 5
end

function RoomCreateLayer:setDiamondCount(  )
	if self.mode == 1 then
		self.aaDiamond:setVisible(false)
		self.aaDiamondText:setVisible(false)
		self.ownerDiamondText:setVisible(true)
		self.ownerDiamond:setVisible(true)
		self.ownerDiamondText:setString("X"..self:getDiamondCount())
	elseif self.mode == 2 then
		self.ownerDiamondText:setVisible(false)
		self.ownerDiamond:setVisible(false)
		self.aaDiamond:setVisible(true)
		self.aaDiamondText:setVisible(true)
		self.aaDiamondText:setString("X"..self:getDiamondCount())
	end
end


return RoomCreateLayer
