local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local Message = require("app.net.Message")
local UserMessage = require("app.net.UserMessage")
local ProgressLayer = require("app.layers.ProgressLayer")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local ErrorLayer = require("app.layers.ErrorLayer")

local util = require("app.Common.util")
local crypt = require("crypt")

local sound_common = require("app.Common.sound_common")

local Player = app.userdata.Player
local Account = app.userdata.Account
local progressTag = 10000

local maxOperateGold = 999999999999


local function checkGoldUpper(gold)
	if gold > maxOperateGold then
		gold = maxOperateGold
	end
	return gold
end

function LobbyScene:closeExchangeMenu()

	if self.scene.ExchangeMenu then
		transition.scaleTo(self.scene.ExchangeMenu.popBoxNode, {
					scale = 0, 
					time = app.constant.lobby_popbox_trasition_time,
					easing = "backIn",
					onComplete = function ()
						self.scene.ExchangeMenu:removeFromParent()
						self.scene.ExchangeMenu = nil
						
		end})

		
	end
end

function LobbyScene:disableExchangeInputTouch()
	if self.scene.ExchangeMenu and self.scene.ExchangeMenu.editBoxes then
		for i,v in ipairs(self.scene.ExchangeMenu.editBoxes) do
			v:setTouchEnabled(false)
		end
	end
end

function LobbyScene:enableExchangeInputTouch()
	if self.scene.ExchangeMenu and self.scene.ExchangeMenu.editBoxes then
		for i,v in ipairs(self.scene.ExchangeMenu.editBoxes) do
			v:setTouchEnabled(true)
		end
	end
end

function LobbyScene:ExchangeRep(msg, oldmsg)

	print("LobbyScene:ExchangeRep, msg.result:", msg.result)
	
	self:closeProgressLayer()
	if msg.result == 0 then
		self:closeExchangeMenu()
		ErrorLayer.new(app.lang.exchange_success):addTo(self)
	else
		ErrorLayer.new(app.lang.exchange_error, nil, nil, handler(self, self.enableExchangeInputTouch)):addTo(self)
	end

end

function LobbyScene:showExchangeMenu()

    print("showExchangeMenu------")

    if self.scene.honorLayer ~= nil then
    	self.scene.honorLayer:removeFromParent()
    end

    local popBoxLayer = cc.uiloader:load("Layer/PopBoxLayer.json"):addTo(self)

    self.scene.ExchangeMenu = popBoxLayer

    popBoxLayer.popBoxNode = cc.uiloader:seekNodeByNameFast(popBoxLayer, "Node")
    popBoxLayer.popBoxNode:setScale(0)
    transition.scaleTo(popBoxLayer.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

    -- local title = cc.uiloader:seekNodeByNameFast(popBoxLayer, "Title"):setString(app.lang.exchange_honor)
    -- title:show()

    local title = cc.uiloader:seekNodeByNameFast(popBoxLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/HonorLayer/exchange_title.png",cc.rect(0,0,168,45))
    title:setSpriteFrame(frame)

    cc.uiloader:seekNodeByNameFast(popBoxLayer, "Close"):onButtonClicked(
    	function()
    		self:closeExchangeMenu()
    		sound_common.cancel()
    	end)


    local parentSize = popBoxLayer.popBoxNode:getContentSize()
    local subNode = cc.uiloader:load("Node/ExchangeHonor.json")
        :addTo(popBoxLayer.popBoxNode)
        :setPosition(parentSize.width / 2, parentSize.height / 2 - 40)

    local numberPanel = cc.uiloader:seekNodeByNameFast(subNode, "NumberPanel")
    local numberInput = util.createInput(numberPanel, {
            mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
            maxLength = app.constant.gold_length,
            placeHolder = "请输入兑换数额",
        })
    self.scene.ExchangeMenu.editBoxes = setmetatable({numberInput}, {__mode == "v"})


    cc.uiloader:seekNodeByNameFast(subNode, "Text_HonorValue"):setString(util.num2str_text(Player.honor))

    local btn100W = cc.uiloader:seekNodeByNameFast(subNode, "100W")
	local btn500W = cc.uiloader:seekNodeByNameFast(subNode, "500W")
	local btn1000W = cc.uiloader:seekNodeByNameFast(subNode, "1000W")
	local btn5000W = cc.uiloader:seekNodeByNameFast(subNode, "5000W")

	local addNumber = function (event)
		local number = checkint(numberInput:getString())
		if event.target == btn100W then
			number = number + 100 * 10000
		elseif event.target == btn500W then
			number = number + 500 * 10000
		elseif event.target == btn1000W then
			number = number + 1000 * 10000
		elseif event.target == btn5000W then
			number = number + 5000 * 10000
		end

		number = checkGoldUpper(number)
		numberInput:setString(tostring(number))
	end

	btn100W:onButtonClicked(addNumber)
	btn500W:onButtonClicked(addNumber)
	btn1000W:onButtonClicked(addNumber)
	btn5000W:onButtonClicked(addNumber)

	local btnAllHonor = cc.uiloader:seekNodeByNameFast(subNode, "Btn_GetAllHonor")
	local setNumber = function (event)
		if event.target == btnAllHonor then
			numberInput:setString(tostring(checkGoldUpper(checkint(Player.honor))))
		end
	end
	btnAllHonor:onButtonClicked(setNumber)

	cc.uiloader:seekNodeByNameFast(subNode, "Btn_ExchangeHonor")
		:onButtonClicked(function ()

			self:disableExchangeInputTouch()
			
			local number = math.floor(checknumber(numberInput:getString()))
			if number == 0 then
				ErrorLayer.new(app.lang.exchange_number_0, nil, nil, handler(self, self.enableExchangeInputTouch)):addTo(self)
				return
			elseif number > checkint(Player.honor) then
				ErrorLayer.new(app.lang.exchange_honor_error, nil, nil, handler(self, self.enableExchangeInputTouch)):addTo(self)
				return
			end

			ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableExchangeInputTouch))
				:addTo(self, nil, progressTag)

			UserMessage.ExchangeHonorReq(number)
		end)

end

function LobbyScene:showSafeBox()
	if self.scene.safeBox then
		self.scene.safeBox:removeFromParent()
		self.scene.safeBox = nil
	end

	if Player.secondpwd then
		self:showSafeBoxLayer()
	else
		self:showAuthLayer()
	end
end

function LobbyScene:showAuthLayer()
	sound_common.menu()
	local authLayer = cc.uiloader:load("Layer/Lobby/SafeBoxAuthLayer.json"):addTo(self)
	self.scene.safeBox = authLayer

	authLayer.popBoxNode = cc.uiloader:seekNodeByNameFast(authLayer, "PopBoxNode")
	authLayer.popBoxNode:setScale(0)
	transition.scaleTo(authLayer.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

	-- cc.uiloader:seekNodeByNameFast(authLayer, "Title"):setString(app.lang.login_safebox)
	local title_sprite = cc.uiloader:seekNodeByNameFast(authLayer, "Image_Title")
    local s = display.newSprite("Image/SafeBox/safebox_title.png")
    local frame = s:getSpriteFrame()
    title_sprite:setSpriteFrame(frame)

	cc.uiloader:seekNodeByNameFast(authLayer, "Close"):onButtonClicked(
		function()
			self:closeSafeBox()
			sound_common.cancel()
		end)
	cc.uiloader:seekNodeByNameFast(authLayer, "Cancel"):onButtonClicked(
		function()
			self:closeSafeBox()
			sound_common.cancel()
		end)

	local passwordPanel = cc.uiloader:seekNodeByNameFast(authLayer, "PasswordPanel")
	local passwordInput = util.createInput(passwordPanel, {
			password = true,
			placeHolder = "请输入保险箱密码",
		})
	self.scene.safeBox.editBoxes = setmetatable({passwordInput}, {__mode == "v"})
    if DEVELOPMENT then
        --passwordInput:setString("123456")
    end

	cc.uiloader:seekNodeByNameFast(authLayer, "Confirm")
		:onButtonClicked(function ()
			sound_common.confirm()
			local password = passwordInput:getString()
			self:disableSafeBoxInputTouch()
			if password == "" then
				ErrorLayer.new(app.lang.password_nil, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif #password < 6 or #password > 20 or string.find(password, "[%W]") then
				ErrorLayer.new(app.lang.secondpwd_format_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			else
				self.scene.safeBox.checkPwd = password
				Message.sendMessage("user.CheckSecondPwdReq", {pwd = password})
				ProgressLayer.new(app.lang.login_bank_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
					:addTo(self, nil, progressTag)
			end
		end)
end

function LobbyScene:showSafeBoxLayer()
	local safeBoxLayer = cc.uiloader:load("Layer/Lobby/SafeBoxLayer.json"):addTo(self)
	self.scene.safeBox = safeBoxLayer

	safeBoxLayer.popBoxNode = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "PopBoxNode")
	safeBoxLayer.popBoxNode:setScale(0)
	transition.scaleTo(safeBoxLayer.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

	-- cc.uiloader:seekNodeByNameFast(safeBoxLayer, "Title"):setString(app.lang.safebox)
	cc.uiloader:seekNodeByNameFast(safeBoxLayer, "Close"):onButtonClicked(
		function()
			self:closeSafeBox()
			sound_common.cancel()
		end)

	local accessMenu = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "Access")
	local giveMenu = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "Give")
	local passMenu = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "Pass")
	local giveDiaMenu = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "Give_D")

	local img_dz_9 = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "img_dz_9")
	local img_wz_11 = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "img_wz_11")

	local img_password_10 = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "img_password_10")
	local img_access_8 = cc.uiloader:seekNodeByNameFast(safeBoxLayer, "img_access_8")
	
	if Player.viptype == nil or Player.viptype <= 0 then

		if Account.tags.give_gold_tag ~= nil and Account.tags.give_gold_tag == "1" then
	        giveMenu:show()
	        giveDiaMenu:show()
	        img_dz_9:show()
	        img_wz_11:show()

	    else
	    	if Account.tags.give_gold_tag == nil then
	    		giveMenu:show()
	    		giveDiaMenu:show()
	    		img_dz_9:show()
	        	img_wz_11:show()
	    	else
	    		giveMenu:hide()
	    		giveDiaMenu:hide()
	    		img_dz_9:hide()
	            img_wz_11:hide()
	            accessMenu:setPosition(giveMenu:getPosition())
	            img_access_8:setPosition(img_wz_11:getPosition())

	            passMenu:setPosition(giveDiaMenu:getPosition())
	            img_password_10:setPosition(img_dz_9:getPosition())

	    	end
	        
	    end
	end
	
	local menuClick = function (button)
		if safeBoxLayer.subNode then
			safeBoxLayer.subNode:removeFromParent()
			safeBoxLayer.subNode = nil
		end

		if button == accessMenu then
			self:showAccessMenu()
		elseif button == giveMenu then
			self:showGiveMenu()
		elseif button == passMenu then
			self:showPassMenu()
		elseif button == giveDiaMenu then
			self:showGiveDiaMenu()
		end
	end

	safeBoxLayer.group = RadioButtonGroup.new({
		[accessMenu] = menuClick,
		[giveMenu] = menuClick,
		[giveDiaMenu] = menuClick,
		[passMenu] = menuClick,
	})

	accessMenu:setButtonSelected(true)
end

function LobbyScene:showAccessMenu()
	local parentSize = self.scene.safeBox.popBoxNode:getContentSize()
	local subNode = cc.uiloader:load("Node/SafeBoxAccessNode.json")
		:addTo(self.scene.safeBox.popBoxNode)
		:setPosition(parentSize.width / 2 - 60, parentSize.height / 2 + 50)
	self.scene.safeBox.subNode = subNode

	cc.uiloader:seekNodeByNameFast(subNode, "BankGold"):setString(util.num2str_text(Player.bankgold))
	cc.uiloader:seekNodeByNameFast(subNode, "Gold"):setString(util.num2str_text(Player.gold))

	local numberPanel = cc.uiloader:seekNodeByNameFast(subNode, "NumberPanel")
	local numberInput = util.createInput(numberPanel, {
			mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
			maxLength = app.constant.gold_length,
			placeHolder = "请输入旺豆数额",
		})
	self.scene.safeBox.editBoxes = setmetatable({numberInput}, {__mode == "v"})

	local btn100W = cc.uiloader:seekNodeByNameFast(subNode, "100W")
	local btn500W = cc.uiloader:seekNodeByNameFast(subNode, "500W")
	local btn1000W = cc.uiloader:seekNodeByNameFast(subNode, "1000W")
	local btn5000W = cc.uiloader:seekNodeByNameFast(subNode, "5000W")

	local addNumber = function (event)
		local number = checkint(numberInput:getString())
		if event.target == btn100W then
			number = number + 100 * 10000
		elseif event.target == btn500W then
			number = number + 500 * 10000
		elseif event.target == btn1000W then
			number = number + 1000 * 10000
		elseif event.target == btn5000W then
			number = number + 5000 * 10000
		end

		number = checkGoldUpper(number)
		numberInput:setString(tostring(number))
	end
	btn100W:onButtonClicked(addNumber)
	btn500W:onButtonClicked(addNumber)
	btn1000W:onButtonClicked(addNumber)
	btn5000W:onButtonClicked(addNumber)

	local btnAllGame = cc.uiloader:seekNodeByNameFast(subNode, "AllGame")
	local btnAllBank = cc.uiloader:seekNodeByNameFast(subNode, "AllBank")
	local setNumber = function (event)
		if event.target == btnAllGame then
			numberInput:setString(tostring(checkGoldUpper(checkint(Player.gold))))
		elseif event.target == btnAllBank then
			numberInput:setString(tostring(checkGoldUpper(checkint(Player.bankgold))))
		end
	end
	btnAllGame:onButtonClicked(setNumber)
	btnAllBank:onButtonClicked(setNumber)

	cc.uiloader:seekNodeByNameFast(subNode, "SaveToBank")
		:onButtonClicked(function ()
			self:disableSafeBoxInputTouch()
			
			local number = math.floor(checknumber(numberInput:getString()))
			if number <= 0 then
				ErrorLayer.new(app.lang.save_gold_number_0, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			-- elseif number < 10000 then
			-- 	ErrorLayer.new(app.lang.save_gold_number_less1W, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif number > checkint(Player.gold) then
				ErrorLayer.new(app.lang.save_gold_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			else
				ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
					:addTo(self, nil, progressTag)
				UserMessage.BankSaveGold(number)
			end
		end)

	cc.uiloader:seekNodeByNameFast(subNode, "PickToGame")
		:onButtonClicked(function ()
			self:disableSafeBoxInputTouch()
			
			local number = math.floor(checknumber(numberInput:getString()))
			if number <= 0 then
				ErrorLayer.new(app.lang.pick_gold_number_0, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			-- elseif number < 10000 then
			-- 	ErrorLayer.new(app.lang.pick_gold_number_less1W, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif number > checkint(Player.bankgold) then
				ErrorLayer.new(app.lang.pick_gold_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			else
				ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
					:addTo(self, nil, progressTag)
				UserMessage.BankPickGold(number)
			end
		end)
end


function LobbyScene:showGiveDiaMenu()
	local parentSize = self.scene.safeBox.popBoxNode:getContentSize()
	local subNode = cc.uiloader:load("Node/SafeBoxGiveDiaNode.json")
		:addTo(self.scene.safeBox.popBoxNode)
		:setPosition(parentSize.width / 2 - 60, parentSize.height / 2 + 13)
	self.scene.safeBox.subNode = subNode

	cc.uiloader:seekNodeByNameFast(subNode, "UserDiamond"):setString(util.num2str_text(Player.diamond))

	local IDPanel = cc.uiloader:seekNodeByNameFast(subNode, "IDPanel")
	local idInput = util.createInput(IDPanel, {
			mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
			maxLength = app.constant.id_length,
			placeHolder = "请输入玩家ID",
		})
	local numberPanel = cc.uiloader:seekNodeByNameFast(subNode, "NumberPanel")
	local numberInput = util.createInput(numberPanel, {
			mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
			maxLength = app.constant.gold_length,
			placeHolder = "请输入钻石数额，十个起赠",
		})
	self.scene.safeBox.editBoxes = setmetatable({idInput, numberInput}, {__mode == "v"})

    if DEVELOPMENT then
        -- idInput:setString("28")
        -- numberInput:setString("0")
    end

	subNode.nickname = cc.uiloader:seekNodeByNameFast(subNode, "Nickname")
	cc.uiloader:seekNodeByNameFast(subNode, "GetNickname")
		:onButtonClicked(function ()
			local id = math.floor(checknumber(idInput:getString()))
			if id == 0 then
				ErrorLayer.new(app.lang.give_gold_nickname_nil, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif id == Player.uid then
				ErrorLayer.new(app.lang.give_dia_self, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif id ~= subNode.otherId then
				subNode.otherId = id
				subNode.otherName = nil
				ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
					:addTo(self, nil, progressTag)
				UserMessage.UserInfoRequest(id)
			end
		end)

	local btn10ge = cc.uiloader:seekNodeByNameFast(subNode, "10ge")
	local btn20ge = cc.uiloader:seekNodeByNameFast(subNode, "20ge")
	local btn50ge = cc.uiloader:seekNodeByNameFast(subNode, "50ge")
	local btn100ge = cc.uiloader:seekNodeByNameFast(subNode, "100ge")

	local addNumber = function (event)
		local number = math.floor(checknumber(numberInput:getString()))
		if event.target == btn10ge then
			number = number + 10
		elseif event.target == btn20ge then
			number = number + 20
		elseif event.target == btn50ge then
			number = number + 50
		elseif event.target == btn100ge then
			number = number + 100
		end

		number = checkGoldUpper(number)
		numberInput:setString(tostring(number))
	end
	btn10ge:onButtonClicked(addNumber)
	btn20ge:onButtonClicked(addNumber)
	btn50ge:onButtonClicked(addNumber)
	btn100ge:onButtonClicked(addNumber)

	cc.uiloader:seekNodeByNameFast(subNode, "GiveDiaGold")
		:onButtonClicked(function ()
			local number = math.floor(checknumber(numberInput:getString()))
			if number == 0 then
				ErrorLayer.new(app.lang.give_dia_number_0, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			elseif number < 10 then
				ErrorLayer.new(app.lang.give_dia_number_less10ge, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			elseif number > checkint(Player.diamond) then
				ErrorLayer.new(app.lang.give_dia_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			end

			local id = math.floor(checknumber(idInput:getString()))
			if not subNode.otherId or not subNode.otherName or subNode.otherId ~= id then
				subNode.otherId = nil
				subNode.otherName = nil
				subNode.nickname:setString("")

				ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			end

			ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
				:addTo(self, nil, progressTag)
			UserMessage.UserInfoRequest(subNode.otherId)
			UserMessage.GiveDiamondReq(subNode.otherId, number)
		end)
end

function LobbyScene:showGiveMenu()
	local parentSize = self.scene.safeBox.popBoxNode:getContentSize()
	local subNode = cc.uiloader:load("Node/SafeBoxGiveNode.json")
		:addTo(self.scene.safeBox.popBoxNode)
		:setPosition(parentSize.width / 2 - 60, parentSize.height / 2 + 13)
	self.scene.safeBox.subNode = subNode

	cc.uiloader:seekNodeByNameFast(subNode, "BankGold"):setString(util.num2str_text(Player.bankgold))

	local IDPanel = cc.uiloader:seekNodeByNameFast(subNode, "IDPanel")
	local idInput = util.createInput(IDPanel, {
			mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
			maxLength = app.constant.id_length,
			placeHolder = "请输入玩家ID",
		})
	local numberPanel = cc.uiloader:seekNodeByNameFast(subNode, "NumberPanel")
	local numberInput = util.createInput(numberPanel, {
			mode = cc.EDITBOX_INPUT_MODE_NUMERIC,
			maxLength = app.constant.gold_length,
			placeHolder = "请输入旺豆数额",
		})
	self.scene.safeBox.editBoxes = setmetatable({idInput, numberInput}, {__mode == "v"})

    if DEVELOPMENT then
        -- idInput:setString("28")
        -- numberInput:setString("0")
    end

	subNode.nickname = cc.uiloader:seekNodeByNameFast(subNode, "Nickname")
	cc.uiloader:seekNodeByNameFast(subNode, "GetNickname")
		:onButtonClicked(function ()
			local id = math.floor(checknumber(idInput:getString()))
			if id == 0 then
				ErrorLayer.new(app.lang.give_gold_nickname_nil, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif id == Player.uid then
				ErrorLayer.new(app.lang.give_gold_self, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif id ~= subNode.otherId then
				subNode.otherId = id
				subNode.otherName = nil
				ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
					:addTo(self, nil, progressTag)
				UserMessage.UserInfoRequest(id)
			end
		end)

	local btn100W = cc.uiloader:seekNodeByNameFast(subNode, "100W")
	local btn500W = cc.uiloader:seekNodeByNameFast(subNode, "500W")
	local btn1000W = cc.uiloader:seekNodeByNameFast(subNode, "1000W")
	local btn5000W = cc.uiloader:seekNodeByNameFast(subNode, "5000W")

	local addNumber = function (event)
		local number = math.floor(checknumber(numberInput:getString()))
		if event.target == btn100W then
			number = number + 100 * 10000
		elseif event.target == btn500W then
			number = number + 500 * 10000
		elseif event.target == btn1000W then
			number = number + 1000 * 10000
		elseif event.target == btn5000W then
			number = number + 5000 * 10000
		end

		number = checkGoldUpper(number)
		numberInput:setString(tostring(number))
	end
	btn100W:onButtonClicked(addNumber)
	btn500W:onButtonClicked(addNumber)
	btn1000W:onButtonClicked(addNumber)
	btn5000W:onButtonClicked(addNumber)

	cc.uiloader:seekNodeByNameFast(subNode, "GiveGold")
		:onButtonClicked(function ()
			local number = math.floor(checknumber(numberInput:getString()))
			if number == 0 then
				ErrorLayer.new(app.lang.give_gold_number_0, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			elseif number < 100000 then
				ErrorLayer.new(app.lang.give_gold_number_less10W, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			elseif number > checkint(Player.bankgold) then
				ErrorLayer.new(app.lang.give_gold_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			end

			local id = math.floor(checknumber(idInput:getString()))
			if not subNode.otherId or not subNode.otherName or subNode.otherId ~= id then
				subNode.otherId = nil
				subNode.otherName = nil
				subNode.nickname:setString("")

				ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
				return
			end

			ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
				:addTo(self, nil, progressTag)
			UserMessage.UserInfoRequest(subNode.otherId)
			UserMessage.GiveGoldReq(subNode.otherId, number)
		end)
end

function LobbyScene:showPassMenu()
	local parentSize = self.scene.safeBox.popBoxNode:getContentSize()
	local subNode = cc.uiloader:load("Node/SafeBoxPassNode.json")
		:addTo(self.scene.safeBox.popBoxNode)
		:setPosition(parentSize.width / 2, parentSize.height / 2 - 40)
	self.scene.safeBox.subNode = subNode

	local oldPasswordPanel = cc.uiloader:seekNodeByNameFast(subNode, "OldPasswordPanel")
	local oldPwdInput = util.createInput(oldPasswordPanel, {
			password = true,
			placeHolder = "请输入原密码",
		})
	local newPasswordPanel = cc.uiloader:seekNodeByNameFast(subNode, "NewPasswordPanel")
	local newPwdInput = util.createInput(newPasswordPanel, {
			password = true,
			placeHolder = "请输入新密码",
		})
	local confirmPasswordPanel = cc.uiloader:seekNodeByNameFast(subNode, "ConfirmPasswordPanel")
	local confirmPwdInput = util.createInput(confirmPasswordPanel, {
			password = true,
			placeHolder = "请确认新密码",
		})
	self.scene.safeBox.editBoxes = setmetatable({oldPwdInput, newPwdInput, confirmPwdInput}, {__mode == "v"})

	cc.uiloader:seekNodeByNameFast(subNode, "ModifyPassword")
		:onButtonClicked(function ()
			local oldPwd = oldPwdInput:getString()
			local newPwd = newPwdInput:getString()
			local confirmPwd = confirmPwdInput:getString()
			if #oldPwd == 0 or #newPwd == 0 or #confirmPwd == 0 then
				ErrorLayer.new(app.lang.password_nil, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif #oldPwd < 6 or #oldPwd > 20 or #newPwd < 6 or #newPwd > 20 or #confirmPwd < 6 or #confirmPwd > 20
				or string.find(oldPwd, "[%W]") or string.find(newPwd, "[%W]") or string.find(confirmPwd, "[%W]") then
				ErrorLayer.new(app.lang.password_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif newPwd ~= confirmPwd then
				ErrorLayer.new(app.lang.modify_password_confirm_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			elseif oldPwd ~= Player.secondpwd then
				ErrorLayer.new(app.lang.modify_password_old_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
			else
				ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableSafeBoxInputTouch))
					:addTo(self, nil, progressTag)
			    --modify by whb 160921
				UserMessage.ModifyPwdReq(2, Player.secondpwd, newPwd)
				--modify end
			end
		end)
end

function LobbyScene:showPayment(id, nickname, gold, finalgold, fee, time)
	local paymentLayer = cc.uiloader:load("Layer/Lobby/SafeBoxPaymentLayer.json"):addTo(self)
	self.scene.safeBox = paymentLayer

	paymentLayer.popBoxNode = cc.uiloader:seekNodeByNameFast(paymentLayer, "PopBoxNode")
	paymentLayer.popBoxNode:setScale(0)
	transition.scaleTo(paymentLayer.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

	-- cc.uiloader:seekNodeByNameFast(paymentLayer, "Title"):setString(app.lang.payment)
	-- cc.uiloader:seekNodeByNameFast(paymentLayer, "Close"):onButtonClicked(handler(self, self.closeSafeBox))
	cc.uiloader:seekNodeByNameFast(paymentLayer, "Confirm"):onButtonClicked(
		function()
			self:closeSafeBox()
			sound_common.confirm()
		end)

	print("gold:" .. gold)
	cc.uiloader:seekNodeByNameFast(paymentLayer, "GiveNickname"):setString(util.checkNickName(Player.nickname))
	cc.uiloader:seekNodeByNameFast(paymentLayer, "ReceiveID"):setString(tostring(id))
	cc.uiloader:seekNodeByNameFast(paymentLayer, "ReceiveNickname"):setString(nickname)
	cc.uiloader:seekNodeByNameFast(paymentLayer, "Gold"):setString(util.toDotNum(gold))
	cc.uiloader:seekNodeByNameFast(paymentLayer, "FinalGold"):setString(util.toDotNum(finalgold))
	cc.uiloader:seekNodeByNameFast(paymentLayer, "Fee"):setString(util.toDotNum(fee))
	cc.uiloader:seekNodeByNameFast(paymentLayer, "Capital"):setString(util.toChineseCapital(finalgold))
	time = util.stringFormat(time,11)
	cc.uiloader:seekNodeByNameFast(paymentLayer, "Time"):setString(time)
end

function LobbyScene:closeSafeBox(_, callback, ...)
	local param = {...}
	if self.scene.safeBox then
		transition.scaleTo(self.scene.safeBox.popBoxNode, {
			scale = 0, 
			time = app.constant.lobby_popbox_trasition_time,
			easing = "backIn",
			onComplete = function ()
				self.scene.safeBox:removeFromParent()
				self.scene.safeBox = nil
				
				if callback then
					callback(unpack(param))
				end
			end,
		})
	end
end

function LobbyScene:disableSafeBoxInputTouch()
	if self.scene.safeBox and self.scene.safeBox.editBoxes then
		for i,v in ipairs(self.scene.safeBox.editBoxes) do
			v:setTouchEnabled(false)
		end
	end
end

function LobbyScene:enableSafeBoxInputTouch()
	if self.scene.safeBox and self.scene.safeBox.editBoxes then
		for i,v in ipairs(self.scene.safeBox.editBoxes) do
			v:setTouchEnabled(true)
		end
	end
end

-- msg
function LobbyScene:CheckSecondPwdRep(msg)
	self:closeProgressLayer()

	if msg.result == 0 and self.scene.safeBox.checkPwd then
		Player.secondpwd = self.scene.safeBox.checkPwd
		self:closeSafeBox(nil, handler(self, self.showSafeBoxLayer))
	else
		ErrorLayer.new(app.lang.secondpwd_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	end
end

function LobbyScene:BankOperateRep(msg, oldmsg)
	self:closeProgressLayer()
	if msg.result == 0 then
		self:moneyChanged()
		
		local text
		if oldmsg.optype == 1 then
			text = app.lang.save_gold_success
		elseif oldmsg.optype == 2 then
			text = app.lang.pick_gold_success
		end

		if self.scene.safeBox and self.scene.safeBox.group then
			local button = self.scene.safeBox.group:getSelected()
			button:setButtonSelected(false)
			button:setButtonSelected(true)
			ErrorLayer.new(text, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
		end
	elseif msg.result == 2 then
		ErrorLayer.new(app.lang.pick_save_gold_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	elseif msg.result == 3 then
		ErrorLayer.new(app.lang.secondpwd_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	else
		self:enableSafeBoxInputTouch()
	end
end

--modify by whb 1600921

function LobbyScene:SetPwdRep(msg, oldmsg)

	print("LobbyScene:SetPwdRep msg.pwdtype, msg.result:",msg.pwdtype, msg.result)
	if msg.pwdtype == 2 then
		self:closeProgressLayer()
		if msg.result == 0 then
			Player.secondpwd = nil
			self:closeSafeBox()
			ErrorLayer.new(app.lang.modify_password_success):addTo(self)
		else
			ErrorLayer.new(app.lang.secondpwd_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
		end
	else
		self:ModifyLoginPwdRep(msg, oldmsg)
	end
	
end
--modify end 

function LobbyScene:SafeBoxOtherUserInfoResonpse(msg, oldmsg)
	local safeBox = self.scene.safeBox

	if not safeBox then return end

	if oldmsg.uid == Player.uid then
		return
	end

	self:closeProgressLayer()

	if safeBox and safeBox.subNode and safeBox.subNode.otherId == oldmsg.uid and not safeBox.subNode.otherName then
		if msg.uid ~= 0 then
			safeBox.subNode.otherName = crypt.base64decode(msg.nickname)
			safeBox.subNode.nickname:setString(util.checkNickName(safeBox.subNode.otherName))
		else
			safeBox.subNode.nickname:setString("该用户不存在")
		end
	end
end

function LobbyScene:SafeBoxUserInfoUpdate()
	local safeBox = self.scene.safeBox
	if safeBox and safeBox.subNode then
		local bankGoldLable = cc.uiloader:seekNodeByNameFast(safeBox.subNode, "BankGold")
		if bankGoldLable then
			bankGoldLable:setString(util.num2str_text(Player.bankgold))
		end
	end
end

function LobbyScene:GiveGoldRes(msg, oldmsg)
	if oldmsg.uid == Player.uid then
		return
	end
	self:closeProgressLayer()

	local safeBox = self.scene.safeBox
	if not safeBox or not safeBox.subNode or safeBox.subNode.otherId ~= oldmsg.uid or not safeBox.subNode.otherName then
		ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
		return
	end

	if msg.result == 0 then
		local uid = safeBox.subNode.otherId
		local nickname = safeBox.subNode.otherName
		local gold = msg.subgold
		local fee = msg.fee
		local finalGold = gold
		local time = msg.time or ""
		self:closeSafeBox(nil, handler(self, self.showPayment), uid, nickname,gold, finalGold, fee, time)
	elseif msg.result == 1 then
		ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
		
		if self.scene.safeBox and self.scene.safeBox.group then
			local button = self.scene.safeBox.group:getSelected()
			button:setButtonSelected(false)
			button:setButtonSelected(true)
		end
	elseif msg.result == 2 then
		ErrorLayer.new(app.lang.give_dia_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	elseif msg.result == 3 then
		ErrorLayer.new(app.lang.secondpwd_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	end
end

function LobbyScene:GiveDiamondRep(msg, oldmsg)
	if oldmsg.uid == Player.uid then
		return
	end
	self:closeProgressLayer()

	local safeBox = self.scene.safeBox
	if not safeBox or not safeBox.subNode or safeBox.subNode.otherId ~= oldmsg.uid or not safeBox.subNode.otherName then
		ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
		return
	end

	if msg.result == 0 then
		local uid = safeBox.subNode.otherId
		local nickname = safeBox.subNode.otherName
		local diamond = msg.subdiamond
		local fee = msg.fee
		local time = msg.time or ""
		self:closeSafeBox(nil, handler(self, self.showPayment), uid, nickname, diamond, diamond, fee, time)
	elseif msg.result == 1 then
		ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
		
		if self.scene.safeBox and self.scene.safeBox.group then
			local button = self.scene.safeBox.group:getSelected()
			button:setButtonSelected(false)
			button:setButtonSelected(true)
		end
	elseif msg.result == 2 then
		ErrorLayer.new(app.lang.give_gold_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	elseif msg.result == 3 then
		ErrorLayer.new(app.lang.secondpwd_error, nil, nil, handler(self, self.enableSafeBoxInputTouch)):addTo(self)
	end
end

return LobbyScene