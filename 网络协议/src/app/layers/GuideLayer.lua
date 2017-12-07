
local GuideLayer = class("GuideLayer", function ()
	return cc.uiloader:load("Layer/Guide/GuideLayer.json")
end)

local guideInfo = require("app.Guide")

local item = {}
local itemListen = {}

local Account = app.userdata.Account

function GuideLayer:ctor(text, fadeTime, delay, finishCallback)
	self.finishCallback = finishCallback

	local account = Account.account

	print("GuideLayer:ctor--:"..account)

	-- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_FreeGold",0)
	-- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_Honor",0)
	-- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_Sign",0)
	-- cc.UserDefault:getInstance():setIntegerForKey(account .. "guide_Bind",0)

	guideInfo.guide_FreeGold = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_FreeGold")
	guideInfo.guide_Honor = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_Honor")
	guideInfo.guide_Sign = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_Sign")
	guideInfo.guide_Bind = cc.UserDefault:getInstance():getIntegerForKey(account .. "guide_Bind")

	print("GuideLayer--FreeGold:",guideInfo.guide_FreeGold)
	print("GuideLayer--guide_Honor:",guideInfo.guide_Honor)
	print("GuideLayer--guide_Sign:",guideInfo.guide_Sign)
	print("GuideLayer--guide_Bind:",guideInfo.guide_Bind)

	local background = cc.uiloader:seekNodeByName(self, "Background")
	background:setTouchEnabled(true)
	background:setTouchSwallowEnabled(true)

	print("GuideLayer--background:",background)

	self.pnl_FreeGold = cc.uiloader:seekNodeByName(self, "Pnl_FreeGold")
	self.pnl_Honor = cc.uiloader:seekNodeByName(self, "Pnl_Honor")
	self.pnl_Sign = cc.uiloader:seekNodeByName(self, "Pnl_Sign")
	self.pnl_Bind = cc.uiloader:seekNodeByName(self, "Pnl_Bind")

	self.btn_FreeGold = cc.uiloader:seekNodeByNameFast(self.pnl_FreeGold, "Btn_FreeGold")
	self.btn_Honor = cc.uiloader:seekNodeByNameFast(self.pnl_Honor, "Btn_Honor")
	self.btn_Sign = cc.uiloader:seekNodeByNameFast(self.pnl_Sign, "Btn_Sign")
	self.btn_Bind = cc.uiloader:seekNodeByNameFast(self.pnl_Bind, "Btn_Bind")

    self.sp_freeGold_Hand = cc.uiloader:seekNodeByNameFast(self.pnl_FreeGold, "Sprite_Hand")
	self.sp_Honor_Hand = cc.uiloader:seekNodeByNameFast(self.pnl_Honor, "Sprite_Hand_D")
	self.sp_Sign_Hand = cc.uiloader:seekNodeByNameFast(self.pnl_Sign, "Sprite_Hand")
	self.sp_Bind_Hand = cc.uiloader:seekNodeByNameFast(self.pnl_Bind, "Sprite_Hand")

	self.btn_FreeGold:setTouchSwallowEnabled(true)
	self.btn_Honor:setTouchSwallowEnabled(true)
	self.btn_Sign:setTouchSwallowEnabled(true)
	self.btn_Bind:setTouchSwallowEnabled(true)

	item.freeGold = self.btn_FreeGold
	item.honor = self.btn_Honor
	item.sign = self.btn_Sign
	item.bind = self.btn_Bind

	self:ShowLayer()

	local sequence = transition.sequence({	cc.MoveBy:create(0.2, cc.p(10.0, 10.0)), cc.DelayTime:create(0.1),	
		cc.MoveBy:create(0.2, cc.p(-10.0, -10.0)),})
	self.sp_freeGold_Hand:runAction(cc.RepeatForever:create(sequence))

	local sequence2 = transition.sequence({	cc.MoveBy:create(0.2, cc.p(-10.0, 10.0)), cc.DelayTime:create(0.1),	
		cc.MoveBy:create(0.2, cc.p(10.0, -10.0)),})
	self.sp_Honor_Hand:runAction(cc.RepeatForever:create(sequence2))

	local sequence3 = transition.sequence({	cc.MoveBy:create(0.2, cc.p(-10.0, 10.0)), cc.DelayTime:create(0.1),	
		cc.MoveBy:create(0.2, cc.p(10.0, -10.0)),})
	local sequence4 = transition.sequence({	cc.MoveBy:create(0.2, cc.p(-10.0, 10.0)), cc.DelayTime:create(0.1),	
		cc.MoveBy:create(0.2, cc.p(10.0, -10.0)),})
	self.sp_Sign_Hand:runAction(cc.RepeatForever:create(sequence3))
	self.sp_Bind_Hand:runAction(cc.RepeatForever:create(sequence4))

	--transition.moveTo(spriteself.sp_freeGold_Hand, {x = display.cx, y = display.cy, time = 1.5})

	-- -- change body size
	-- label:setString(text)
	-- local newWidth = 60 + label:getContentSize().width
	-- local newHeight = 50 + label:getContentSize().height
	-- body:setLayoutSize(newWidth, newHeight)

	-- translate
	-- transition.fadeOut(body, {
	-- 	time = fadeTime or 0.5,
	-- 	delay = delay or 1,
	-- 	onComplete = function ()
	-- 		self:stop()
	-- 	end,
	-- })

	-- self:setTouchEnabled(true)
 --    self:setTouchSwallowEnabled(true)
	-- background:setTouchEnabled(true)
 --    background:setTouchSwallowEnabled(true)
	-- background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	-- 	print(event.name)
	-- 	self:stop()
	-- 	return true
	-- end)
end

function GuideLayer:SetItemPos( itemName, itemPosX, itemPosY, onClickCallBack )

    print("GuideLayer:SetItemPos:itemName:" ..itemName)
	print("GuideLayer:SetItemPos:x=,y=," ,itemPosX, itemPosY)
    if item[itemName] ~= nil then

   	item[itemName]:getParent():setPosition(itemPosX, itemPosY)

   	if onClickCallBack ~= nil and itemListen[itemName] == nil then
   	item[itemName]:onButtonClicked(onClickCallBack)
   	itemListen[itemName] = onClickCallBack
    end

   end

end

function GuideLayer:HideLayer()

	print("GuideLayer:HideLayer:")
	self:setVisible(false)
end

function GuideLayer:ShowLayer()

    item.freeGold:getParent():hide()
	item.honor:getParent():hide()
	item.sign:getParent():hide()
	item.bind:getParent():hide()

	if guideInfo.guide_CurMenu == guideInfo.guideMenu[1] then 

        if guideInfo.guide_FreeGold == 0 then

           item.freeGold:getParent():show()

        end

        if guideInfo.guide_Honor == 0 then

        	item.honor:getParent():show()

        end

    elseif guideInfo.guide_CurMenu == guideInfo.guideMenu[2] then

    	if guideInfo.guide_Sign == 0 then

           item.sign:getParent():show()

        end

    elseif guideInfo.guide_CurMenu == guideInfo.guideMenu[3] then

    	if guideInfo.guide_Bind == 0 then

           item.bind:getParent():show()

        end
     
    end

	print("GuideLayer:ShowLayer:")
	self:setVisible(true)
end

function GuideLayer:stop()

	transition.stopTarget(self)

	item = {}
	itemListen = {}

	print("GuideLayer:stop:")
	-- if self.finishCallback then
	-- 	self.finishCallback()
	-- end

	self:removeFromParent()
	--self = nil
end

return GuideLayer