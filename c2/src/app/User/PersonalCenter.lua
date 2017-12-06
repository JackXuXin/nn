local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local UserMessage = require("app.net.UserMessage")
local AvatarConfig = require("app.config.AvatarConfig")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local util = require("app.Common.util")
local crypt = require("crypt")

local ProgressLayer = require("app.layers.ProgressLayer")
local ErrorLayer = require("app.layers.ErrorLayer")

local sound_common = require("app.Common.sound_common")
local NetSprite = require("app.config.NetSprite")

local Player = app.userdata.Player
local Account = app.userdata.Account
local progressTag = 10000

--utf8字符串截取
local function utf8sub(str,s,e)
	local tab = {}
	local c = ""
	for uchar in string.gfind(str,"[%z\1-\127\194-\244][\128-\191]*") do
		tab[#tab + 1] = uchar
	end
	for i = s, #tab do
		c = c .. tab[i]
		if i >= e then
			break
		end
	end
	return c
end

--check emoji
local function checkEmoji(str)

	local nums = string.utf8len(str)

	for i = 1,nums do
		print("char" .. i .. ":" .. string.sub(str,i,1))
	end

	for i = 1,nums do
		local word = utf8sub(str,i,i)
		if string.len(word) >= 4 then
			return true
		end
	end

	return false
end

local function checkNick(str)
	local nums = string.utf8len(str)
	print("nums:" .. nums)
	for i = 1,#str do
		 local curByte = string.byte(str, i)
		 if curByte == 237 or curByte == 226 or curByte == 240 then
		 	return false
		 end
	end
	return true
end

function LobbyScene:updateGoldAndDiamond()


	 -- if self.scene.money_Lobby ~= nil and Player.gold ~= "" then

	 -- 	 local gold = util.setGold(Player.gold)

  --        self.scene.money_Lobby:setString(gold)

  --   end
    if self.scene.dam_Lobby ~= nil and Player.diamond ~= "" then

    	local dam = util.setGold(Player.diamond)
    	print("updateGoldAndDiamond-dam = ",dam)

         self.scene.dam_Lobby:setString(dam)

    end

end

function LobbyScene:selectSysHeadPic( index )

    
	--self.curheadPic = AvatarConfig:getAvatar(sex, score, viptype)



end

function LobbyScene:showPersonalCenter()
	sound_common.menu()
	if self.scene.personalCenter then
		self.scene.personalCenter:removeFromParent()
		self.scene.personalCenter = nil
	end
	
	local personalCenter = cc.uiloader:load("Layer/Lobby/PersonalCenterLayer.json"):addTo(self)
	self.scene.personalCenter = personalCenter

	personalCenter.popBoxNode = cc.uiloader:seekNodeByNameFast(personalCenter, "PopBoxNode")
	personalCenter.popBoxNode:setScale(0)
	transition.scaleTo(personalCenter.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

	-- cc.uiloader:seekNodeByNameFast(personalCenter, "Title"):setString(app.lang.personal_center)
	local title = cc.uiloader:seekNodeByNameFast(personalCenter, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/PersonalCenter/personal_title.png",cc.rect(0,0,145,37))
    title:setSpriteFrame(frame)
	local closeBtn = cc.uiloader:seekNodeByNameFast(personalCenter, "Close"):onButtonClicked(function ()
		self:closePersonalCenter()
		sound_common:cancel()
	end)

	util.BtnScaleFun(closeBtn)
	
	cc.uiloader:seekNodeByNameFast(personalCenter, "Account"):setString(Account.account)
	cc.uiloader:seekNodeByNameFast(personalCenter, "ID"):setString(Player.uid)

	--add by whb 160921
	local  passStr = "*"
	for i=1,#Account.password do
				--print("passStr:" .. passStr)
				passStr = passStr .. "*"
			end
    cc.uiloader:seekNodeByNameFast(personalCenter, "Txt_PassWord"):setString(passStr)
	--add end

	local avatarImage = cc.uiloader:seekNodeByNameFast(personalCenter, "Image_Avatar")
	local avatarBG = cc.uiloader:seekNodeByNameFast(personalCenter, "Image_ABG")
	local selectFemale = cc.uiloader:seekNodeByNameFast(personalCenter, "SelectFemale")
	local selectMale = cc.uiloader:seekNodeByNameFast(personalCenter, "SelectMale")
	selectFemale.sex = 1
	selectMale.sex = 2

	local changeAvatar = function (button)
		local sex = button.sex
		if not sex then
			return
		end
		local image = AvatarConfig:getAvatar(sex, checkint(Player.gold), Player.viptype)

		if app.constant.isWchatLogin then

					--modify by whb 0417
			if app.constant.wChatInfo.icon then

		        local url = app.constant.wChatInfo.icon
		        local subUrl = string.sub(url,1,-2)
            	 url = subUrl .. 132
           		 print("newUrl:",url)
		        print("oldImage:",image)
		        local icontest = NetSprite.new(url,image):addTo(personalCenter)
		        image = icontest:getTexture()
		        icontest:hide()

		        print("wimage:",image)

		        local size = avatarImage:getContentSize()
           		avatarImage:setScale(184/size.width,184/size.height)

		        avatarImage:setTexture(image)

		        avatarBG:hide()

		        local sprite = display.newSprite("Image/Common/Avatar/img_iconK.png") --创建下载成功的sprite
		        if sprite ~= nil then
		        	local size = avatarImage:getContentSize()
		            sprite:setPosition(size.width/2+1,size.height/2)
		            sprite:setScale(1.02)
		            sprite:addTo(avatarImage)
		        end
		    else 

		    	avatarBG:hide()
		    	rect = cc.rect(0, 0, 188, 188)
	       		frame = cc.SpriteFrame:create(image, rect)
				avatarImage:setSpriteFrame(frame)

		    end

		else
			avatarBG:hide()
			rect = cc.rect(0, 0, 188, 188)
	        frame = cc.SpriteFrame:create(image, rect)
			avatarImage:setSpriteFrame(frame)
		end

	end

	personalCenter.group = RadioButtonGroup.new({
		[selectFemale] = changeAvatar,
		[selectMale] = changeAvatar,
	})
	if Player.sex == selectFemale.sex then
		selectFemale:setButtonSelected(true)
	else
		selectMale:setButtonSelected(true)
	end

	local copyBtn = cc.uiloader:seekNodeByNameFast(personalCenter, "Copy")
		:onButtonClicked(function ()
			for k,v in pairs(Account) do
				print(k)
			end
			util.copyToClipboard("昵称：" .. util.checkNickName(Player.nickname) .. " ID：" .. Account.uid)
			ErrorLayer.new(app.lang.copy_acccount_id):addTo(self)
		end)

    util.BtnScaleFun(copyBtn)

	local nicknameInput = cc.uiloader:seekNodeByNameFast(personalCenter, "NicknameInput")
	self.scene.personalCenter.nicknameInput = nicknameInput
	nicknameInput:setString(util.checkNickName(Player.nickname))

	-- if app.constant.isWchatLogin then

	-- 	nicknameInput:setString(app.constant.wChatInfo.nick)

	-- end


	--self.scene.money = cc.uiloader:seekNodeByNameFast(personalCenter, "AtlasLabel_Money")
	--self.scene.diamond = cc.uiloader:seekNodeByNameFast(personalCenter, "AtlasLabel_Diamond")
	--更新金币和钻石
	--print("updateMoney----")
	--self:updateGoldAndDiamond()

	-- local btn_Add = cc.uiloader:seekNodeByNameFast(personalCenter, "AddGold")
	-- --self.scene.add = btn_Add
	-- btn_Add:setTag(1)
 --    btn_Add:onButtonClicked(handler(self, self.showRecharge))

 --    local btn_Diamond = cc.uiloader:seekNodeByNameFast(personalCenter, "AddDiamond")
 --    btn_Diamond:setTag(2)
 --    self.scene.addDiamond = btn_Diamond
 --    btn_Diamond:onButtonClicked(handler(self, self.showRecharge))
--modify by whb 161031

    local text_Vip = cc.uiloader:seekNodeByNameFast(personalCenter, "Text_Vip")
    local dayNum = cc.uiloader:seekNodeByNameFast(personalCenter, "Text_DayNum")
	local day = cc.uiloader:seekNodeByNameFast(personalCenter, "Text_Day")
	local text_Vip2 = cc.uiloader:seekNodeByNameFast(personalCenter, "Text_Vip2")
	

      print("Player.vipdays:viptype:" .. Player.vipdays .. Player.viptype)
    if Player.viptype > 0 then
       nicknameInput:setColor(cc.c3b(255, 0, 0))

       if text_Vip ~= nil  and dayNum ~= nil and day~= nil then
       
	       	dayNum:setString(Player.vipdays)

		    local x,y = dayNum:getPosition()
			local daySize = dayNum:getContentSize()
			day:setPositionX(daySize.width+x+3)

			text_Vip:show()
	       	dayNum:show()
	       	day:show()
	       	text_Vip2:hide()

	       	if Player.vipdays == 0 then
	       	 text_Vip2:show()
             text_Vip2:setString(app.lang.vip_tip2)
             text_Vip2:setColor(cc.c3b(251, 132, 132))
             dayNum:hide()
	       	 day:hide()
	       	 text_Vip:hide()
	       	else
	       	 text_Vip:setString(app.lang.vip_tip1)
	       	end
       end
    else
    	if text_Vip ~= nil  and dayNum ~= nil and day~= nil then
       
	       	text_Vip:hide()
	       	dayNum:hide()
	       	day:hide()
	       	text_Vip2:hide()
       end

    end


--modify end
	local changeBtn = cc.uiloader:seekNodeByNameFast(personalCenter, "ChangeNickname")
		:onButtonClicked(function ()
			nicknameInput:attachWithIME()
		end)

	util.BtnScaleFun(changeBtn)

	local saveBtn = cc.uiloader:seekNodeByNameFast(personalCenter, "Save")
		:onButtonClicked(function ()
			local sex, nickname

			local modifyNick = nicknameInput:getString()

			if not util.checkEmoji(modifyNick) then
				print("app.lang.update_userinfo_nick_error2222")
				local text = app.lang.update_userinfo_nick_error
				ErrorLayer.new(text):addTo(self)
				return
			end

			print("nick name len:" .. #modifyNick)
			if #modifyNick > 18 then
				local text = app.lang.update_userinfo_nick_toolang
				ErrorLayer.new(text):addTo(self)
				return
			end

			if #modifyNick < 9 then
				local text = app.lang.update_userinfo_nick_tooshort
				ErrorLayer.new(text):addTo(self)
				return
			end

			if modifyNick ~= util.checkNickName(Player.nickname) then
				nickname = crypt.base64encode(modifyNick)
			end

			local sexSelected = personalCenter.group:getSelected()
			if sexSelected and sexSelected.sex ~= Player.sex then
				sex = sexSelected.sex
			end

			if sex or nickname then
				print("llll nickname:" .. modifyNick)
				self.isModifying = true
				UserMessage.ModifyUserInfoReq(sex, nickname)
				ProgressLayer.new(app.lang.save_loading):addTo(self, nil, progressTag)
			else
				self:closePersonalCenter()
			end
		end)

		util.BtnScaleFun(saveBtn)

		--add by whb 160920
		print("channel:" .. Account.channel)
		local  btn_ModifyPass = cc.uiloader:seekNodeByNameFast(personalCenter, "Btn_ModifyPass")
		if Account.channel ~= "game" then
			btn_ModifyPass:hide()
		end
		btn_ModifyPass:onButtonClicked(function ()
			self:ShowModifyPassMenu()
		end)

		util.BtnScaleFun(btn_ModifyPass)
		
		--add end
end

function LobbyScene:closePersonalCenter()
	if self.scene.personalCenter then
		self.scene.personalCenter.nicknameInput:didNotSelectSelf()
		transition.scaleTo(self.scene.personalCenter.popBoxNode, {
			scale = 0, 
			time = app.constant.lobby_popbox_trasition_time,
			easing = "backIn",
			onComplete = function ()

				--重置金币和钻石变量
				self.scene.money = nil
				self.scene.diamond = nil
				self.scene.personalCenter:removeFromParent()
				self.scene.personalCenter = nil
			end,
		})
	end
end

-- msg
function LobbyScene:ModifyUserInfoRep(msg, oldmsg)
	self:closeProgressLayer()

	print("ModifyUserInfoRep:",msg.result)
	--dump(oldmsg)

	local text
	if msg.result == 0 then
		text = app.lang.update_userinfo_success

		local lastNick = util.checkNickName(Player.nickname)

		if oldmsg.sex then
			Player.sex = oldmsg.sex
			--print("ModifyUserInfoRep-Player.sex:",Player.sex)
			self:sexChanged()
		end
		if oldmsg.nickname then
			Player.nickname = crypt.base64decode(oldmsg.nickname)

			--print("ModifyUserInfoRep-Player.nickname:",Player.nickname)
			self:nicknameChanged()
		end

		self:closePersonalCenter()

--add by whb update friend nickinfo

	if  app.constant.isLoginChat  and lastNick ~= util.checkNickName(Player.nickname) then

		if device.platform ~= "ios" and  device.platform ~= "android" then 
       		 return
    	end

		local nname = util.checkNickName(Player.nickname)
		local playerManner = yvcc.YVPlatform:getPlayerManager()
		print("playerManner----")
		local hcData = yvcc.HclcData:sharedHD()
		local isModify = hcData:modifyUserInfo(nname)
		print("isModify:",isModify)
		if isModify then

			playerManner:modifyNickName(nname)

			playerManner:cpLogout()
			--更新用户消息
			loginYvSys()
			print("modifyFriendNick-----")
		end
	end
--add end

	elseif msg.result == 1 then
		text = app.lang.update_userinfo_sex_error
	elseif msg.result == 2 then
		-- imageid
	elseif msg.result == 3 then
		print("app.lang.update_userinfo_nick_error1111")
		text = app.lang.update_userinfo_nick_error
	elseif msg.result == 4 then
		text = app.lang.update_userinfo_nick_repeat
	end

	if text and self.isModifying then
		ErrorLayer.new(text):addTo(self)
	end
end

--add by whb 160920
function LobbyScene:ShowModifyPassMenu()

	local popBoxLayer = cc.uiloader:load("Layer/PopBoxLayer.json"):addTo(self)

	self.scene.modifyPass = popBoxLayer

	print("ShowModifyPassMenu:", popBoxLayer)
	popBoxLayer.popBoxNode = cc.uiloader:seekNodeByNameFast(popBoxLayer, "Node")
	popBoxLayer.popBoxNode:setScale(0)
	transition.scaleTo(popBoxLayer.popBoxNode, {scale = 1, time = app.constant.lobby_popbox_trasition_time})

	-- cc.uiloader:seekNodeByNameFast(popBoxLayer, "Title"):setString(app.lang.modify_password_tip)
	local title = cc.uiloader:seekNodeByNameFast(popBoxLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/PersonalCenter/modifyPass_title.png",cc.rect(0,0,144,38))
    title:setSpriteFrame(frame)
    local closeBtn = cc.uiloader:seekNodeByNameFast(popBoxLayer, "Close"):onButtonClicked(
    	function()
    		self:closeModifyPassMenu()
    		sound_common.cancel()
    	end
    )

    util.BtnScaleFun(closeBtn)

	local parentSize = popBoxLayer.popBoxNode:getContentSize()
	local subNode = cc.uiloader:load("Node/SafeBoxPassNode.json")
		:addTo(popBoxLayer.popBoxNode)
		:setPosition(parentSize.width / 2, parentSize.height / 2 - 45)

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
	self.scene.modifyPass.editBoxes = setmetatable({oldPwdInput, newPwdInput, confirmPwdInput}, {__mode == "v"})

	local sureBtn = cc.uiloader:seekNodeByNameFast(subNode, "ModifyPassword")
		:onButtonClicked(function ()

			self:disableModifyMenuInputTouch()
			local oldPwd = oldPwdInput:getString()
			local newPwd = newPwdInput:getString()
			local confirmPwd = confirmPwdInput:getString()
			print("ShowModifyPassMenu:Account.password", Account.password)
			print("ShowModifyPassMenu:oldPwd,newPwd,confirmPwd", oldPwd,newPwd,confirmPwd)
			if #oldPwd == 0 or #newPwd == 0 or #confirmPwd == 0 then
				ErrorLayer.new(app.lang.password_nil, nil, nil, handler(self, self.enableModifyMenuInputTouch)):addTo(self)
			elseif #oldPwd < 6 or #oldPwd > 20 or #newPwd < 6 or #newPwd > 20 or #confirmPwd < 6 or #confirmPwd > 20
				or string.find(oldPwd, "[%W]") or string.find(newPwd, "[%W]") or string.find(confirmPwd, "[%W]") then
				ErrorLayer.new(app.lang.password_error, nil, nil, handler(self, self.enableModifyMenuInputTouch)):addTo(self)
			elseif newPwd ~= confirmPwd then
				ErrorLayer.new(app.lang.modify_password_confirm_error, nil, nil, handler(self, self.enableModifyMenuInputTouch)):addTo(self)
			elseif oldPwd ~= Account.password then
				ErrorLayer.new(app.lang.modify_loginpwd_error, nil, nil, handler(self, self.enableModifyMenuInputTouch)):addTo(self)
			else
				ProgressLayer.new(app.lang.default_loading, nil, nil, handler(self, self.enableModifyMenuInputTouch))
					:addTo(self, nil, progressTag)

				--modify by whb 160921
				UserMessage.ModifyPwdReq(1, Account.password, newPwd)
				--modify end
			end
		end)

		util.BtnScaleFun(sureBtn)
end

function LobbyScene:disableModifyMenuInputTouch()
	if self.scene.modifyPass and self.scene.modifyPass.editBoxes then
		for i,v in ipairs(self.scene.modifyPass.editBoxes) do
			v:setTouchEnabled(false)
		end
	end
end

function LobbyScene:enableModifyMenuInputTouch()
	if self.scene.modifyPass and self.scene.modifyPass.editBoxes then
		for i,v in ipairs(self.scene.modifyPass.editBoxes) do
			v:setTouchEnabled(true)
		end
	end
end

function LobbyScene:ModifyLoginPwdRep(msg, oldmsg)
	self:closeProgressLayer()
	if msg.result == 0 then
		--Player.secondpwd = nil
		self:closeModifyPassMenu()
		ErrorLayer.new(app.lang.modify_loginpass_success):addTo(self)
	else
		ErrorLayer.new(app.lang.modify_loginpwd_failed, nil, nil, handler(self, self.enableModifyMenuInputTouch)):addTo(self)
	end
end

function LobbyScene:closeModifyPassMenu()

	if self.scene.modifyPass then
		transition.scaleTo(self.scene.modifyPass.popBoxNode, {
					scale = 0, 
					time = app.constant.lobby_popbox_trasition_time,
					easing = "backIn",
					onComplete = function ()
						self.scene.modifyPass:removeFromParent()
						self.scene.modifyPass = nil
						
		end})
	end
end

--add end

return LobbyScene