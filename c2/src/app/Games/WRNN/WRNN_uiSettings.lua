--
-- Author: peter
-- Date: 2017-04-21 11:10:53
--
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local comUtil = require("app.Common.util")
local sound_common = require("app.Common.sound_common")

local gameScene = nil

local has_sound = nil

local WRNN_uiSettings = {}

function WRNN_uiSettings:init(scene)
	gameScene = scene
    

    local setBg = cc.uiloader:seekNodeByNameFast(gameScene.root, "settingBg")
    setBg:setLocalZOrder(1003)
	--设置按钮
	self.k_btn_settings = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_settings")
	self.k_btn_settings:onButtonClicked(handler(self,self.clickSetting))

	--设置功能背景
	self.k_container_settings = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_container_settings")
	--self.k_container_settings:setVisible(false)
	self.k_container_settings:setLocalZOrder(1002)


	self.touchLayer = cc.uiloader:seekNodeByNameFast(self.k_container_settings, "TouchLayer")
    self.touchLayer:hide()


	self.is_ui_settings_show = false

	--声音按钮
	self.k_btn_sound = cc.uiloader:seekNodeByName(self.k_container_settings, "k_btn_sound")
	self.k_btn_sound:onButtonClicked(handler(self,self.clickSound))

	--退出按钮
	self.k_btn_exit = cc.uiloader:seekNodeByName(self.k_container_settings, "k_btn_exit")
	self.k_btn_exit:onButtonClicked(handler(self,self.clickEdit))
    comUtil.BtnScaleFun(self.k_btn_exit)

    --解散房间
    self.k_btn_jsroom = cc.uiloader:seekNodeByName(self.k_container_settings, "k_btn_jsroom")
	self.k_btn_jsroom:onButtonClicked(handler(self,self.clickDissolveRoom))
     comUtil.BtnScaleFun(self.k_btn_jsroom)

    --游戏设置
    self.k_btn_setting = cc.uiloader:seekNodeByName(self.k_container_settings, "k_btn_setting")
	self.k_btn_setting:onButtonClicked(handler(self,self.clickSoundSetting))
    comUtil.BtnScaleFun(self.k_btn_setting)
    --上局回顾
    self.k_btn_review = cc.uiloader:seekNodeByName(self.k_container_settings, "k_btn_review")
	self.k_btn_review:onButtonClicked(handler(self,self.clickReview))
    comUtil.BtnScaleFun(self.k_btn_review)
    --游戏规则
    self.k_btn_rule = cc.uiloader:seekNodeByName(self.k_container_settings, "k_btn_rule")
    self.k_btn_rule:onButtonClicked(handler(self,self.clickGameRule))
    comUtil.BtnScaleFun(self.k_btn_rule)
    self:setDissolveBtnEnable(false)
    self:setReviewBtnEnable(false)




	has_sound = app.constant.voiceOn
	self:update()


	
    self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT,
                                function(event)
                if event.name == "began" then
                       self:clickSetting()
                  return true
                end               
                end)
   

end

function WRNN_uiSettings:clear()
end

function WRNN_uiSettings:clickSetting()
    gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
    
    self.is_ui_settings_show = not self.is_ui_settings_show
    if self.is_ui_settings_show then
    	self.touchLayer:show()
    	self.touchLayer:setTouchEnabled(true)
        self.k_container_settings:moveBy(0.2,-400,0)
    else
        self.touchLayer:hide()
    	self.touchLayer:setTouchEnabled(false)
        self.k_container_settings:moveBy(0.2,400,0)
    end
	--self.k_container_settings:setVisible(self.is_ui_settings_show)
	self:update()
end

function WRNN_uiSettings:clickSound()
	has_sound = not has_sound

    app.constant.voiceOn = has_sound
    comUtil.GameStateSave("voiceOn",app.constant.voiceOn)
    sound_common.setVoiceState(app.constant.voiceOn)

    if has_sound then
        audio.setSoundsVolume(1.0)
    else
        audio.setSoundsVolume(0.0)
    end

    self:update()
end

function WRNN_uiSettings:clickEdit()

    gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
	local pop = nil
    pop = MiddlePopBoxLayer.new(app.lang.exit, app.lang.exit_tips,
        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()

        	pop:removeFromParent()
        	pop = nil
        	gameScene.WRNN_Message.dispatchPrivateRoom("room.LeaveGame",gameScene.WRNN_Const.REQUEST_INFO_01,gameScene)
        end)
    :addTo(gameScene)
end

function WRNN_uiSettings:update()
	local PATH = gameScene.WRNN_Const.PATH

	if has_sound then
		self.k_btn_sound:setButtonImage("normal", PATH.BTN_SOUND_NORMAL, true)
    	self.k_btn_sound:setButtonImage("pressed", PATH.BTN_SOUND_PRESSED, true)
    else
    	self.k_btn_sound:setButtonImage("normal", PATH.BTN_MUTE_NORMAL, true)
    	self.k_btn_sound:setButtonImage("pressed", PATH.BTN_MUTE_PRESSED, true)
	end

	if self.is_ui_settings_show then
		self.k_btn_settings:setButtonImage("normal", PATH.BTN_CCUP_NORMAL, true)
    	self.k_btn_settings:setButtonImage("pressed", PATH.BTN_CCUP_NORMAL, true)
	else
    	self.k_btn_settings:setButtonImage("normal", PATH.BTN_CCDOWN_NORMAL, true)
    	self.k_btn_settings:setButtonImage("pressed", PATH.BTN_CCDOWN_NORMAL, true)

	end
end

--设置解散按钮灰色
function WRNN_uiSettings:setDissolveBtnEnable(enabled)
	     self.k_btn_jsroom:setButtonEnabled(enabled)
         if not enabled then
				local lable = self.k_btn_jsroom:getButtonLabel("normal")
				lable:setColor(cc.c3b(117, 116, 113))				
		 else
		 		local lable = self.k_btn_jsroom:getButtonLabel("normal")
				lable:setColor(cc.c3b(255, 246, 214))     			     
         end
end
--设置上局回顾按钮状态
function WRNN_uiSettings:setReviewBtnEnable(enabled)

	     print("设置上局回顾按钮状态")
	     self.k_btn_review:setButtonEnabled(enabled)
         if not enabled then
				local lable = self.k_btn_review:getButtonLabel("normal")
				lable:setColor(cc.c3b(117, 116, 113))				
		 else
		 		local lable = self.k_btn_review:getButtonLabel("normal")
				lable:setColor(cc.c3b(255, 246, 214))     			     
         end
end


--[[解散房间]]
function WRNN_uiSettings:clickDissolveRoom()
	    gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
        local pop = nil
	    pop = MiddlePopBoxLayer.new(app.lang.exit, app.lang.room_dissolution,
	        MiddlePopBoxLayer.ConfirmTable, true, nil, function ()

	        	pop:removeFromParent()
	        	pop = nil	          
             
                gameScene.WRNN_Message.sendMessage("game.DismissGameReq", {session = gameScene.room_session,privateid = gameScene.roominfo.table_code,seat = gameScene.seatIndex,})
                -- print("发送解散房间消息")
                -- print("session = ".. gameScene.session)
                -- print("privateid = "..gameScene.roominfo.table_code)
                -- print("seat = ".. gameScene.seatIndex)
               
	        end)
	    :addTo(gameScene)
end

--[[游戏设置]]
function WRNN_uiSettings:clickSoundSetting()
         
end

--[[上局回顾]]
function WRNN_uiSettings:clickReview()
         


          gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
          gameScene.WRNN_Message.sendMessage("WRNN.LastReviewReq", {session = gameScene.session})
end
--[[]]
function WRNN_uiSettings:clickGameRule()   


          gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)

         
    print("showRuleMenu----")
    local ruleLayer = cc.uiloader:load("Layer/Game/NNGameRuleLayer.json"):addTo(gameScene.root,6100)
    self.ruleLayer = ruleLayer

    local popBoxNode = cc.uiloader:seekNodeByNameFast(ruleLayer, "PopBoxNode")
    popBoxNode:setScale(0)

    local title = cc.uiloader:seekNodeByNameFast(ruleLayer, "Image_Title")
    local frame = cc.SpriteFrame:create("Image/Lobby/ruleImg/img_RuleTitle.png",cc.rect(0,0,77,38))
    title:setSpriteFrame(frame)
    



    transition.scaleTo(popBoxNode, {
        scale = 1,
        time = app.constant.lobby_popbox_trasition_time,
        onComplete = function ()

        end
    })

    local close = cc.uiloader:seekNodeByNameFast(ruleLayer, "Close")
    :onButtonClicked(
        function ()

          self.ruleLayer:removeFromParent()
          self.ruleLayer = nil
          sound_common:cancel()

        end)
    comUtil.BtnScaleFun(close)

    local CardList = cc.uiloader:seekNodeByNameFast(ruleLayer, "CardList")
    CardList:show()



end






return WRNN_uiSettings