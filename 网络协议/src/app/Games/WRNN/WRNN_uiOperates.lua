--
-- Author: peter
-- Date: 2017-04-21 10:11:12
--
local utilCom = require("app.Common.util")
local util = require("app.Common.util")
local AvatarConfig = require("app.config.AvatarConfig")
local code = require("app.Common.code")
local scheduler = require("framework.scheduler")
local Share = require("app.User.Share")
local sound_common = require("app.Common.sound_common")

local gameScene = nil

local currentBetGold = 0  --当前下注金额

local WRNN_uiOperates = {}


local score_btns ={}
local basescore = {[1]={1,2,3,4,5},[2]={1,2,3,4,5},[3]={1,2,3,4,5}}

local Cuopai_Open_State = false  --搓牌状态




 
function WRNN_uiOperates:init(scene)
	gameScene = scene

    --房间信息
    self.Text_RoomCode = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_RoomCode")
    self.Text_BankerType = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_BankerType")
    self.Text_BaseScore = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_BaseScore")
    self.Text_CurrentRound = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_CurrentRound")
    self.Text_Round = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_Round")

    self.Text_OverBankerTip = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_OverBankerTip")
    self.Text_OverBanker = cc.uiloader:seekNodeByNameFast(gameScene.root, "Text_OverBanker")

    
    self.Text_RoomCode:hide()
    self.Text_BankerType:hide()
    self.Text_BaseScore:hide()
    self.Text_CurrentRound:hide()
    self.Text_Round:hide()
    self.Text_OverBankerTip:hide()
    self.Text_OverBanker:hide()


	--准备按钮 
	self.k_btn_start_ready = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_start_ready")
	self.k_btn_start_ready:setVisible(false)
	self.k_btn_start_ready:onButtonClicked(handler(self,self.clickStartReady))
  util.BtnScaleFun(self.k_btn_start_ready)
   
 --    --开始游戏按钮
	-- self.k_btn_start_game = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_start_game")
	-- self.k_btn_start_game:setVisible(false)
	-- self.k_btn_start_game:onButtonClicked(handler(self,self.clickStartGame))

    --下一局准备按钮
  self.k_btn_next_ready = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_next_ready")
	self.k_btn_next_ready:setVisible(false)
	self.k_btn_next_ready:onButtonClicked(handler(self,self.clickNextStartReady))
  util.BtnScaleFun(self.k_btn_next_ready)
  
    
  --下庄按钮
  self.k_btn_overbanker = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_overbanker")
  self.k_btn_overbanker:setVisible(false)
  self.k_btn_overbanker:onButtonClicked(handler(self,self.clickOverBanker))
  util.BtnScaleFun(self.k_btn_overbanker)
  


    --搓牌按钮
    self.Btn_CuoPai = cc.uiloader:seekNodeByNameFast(gameScene.root, "Btn_CuoPai")
	self.Btn_CuoPai:setVisible(false)
	self.Btn_CuoPai:onButtonClicked(handler(self,self.clickCuoPaiButton))
  util.BtnScaleFun(self.Btn_CuoPai)
	--翻牌按钮
    self.Btn_FanPai = cc.uiloader:seekNodeByNameFast(gameScene.root, "Btn_FanPai")
	self.Btn_FanPai:setVisible(false)
	self.Btn_FanPai:onButtonClicked(handler(self,self.clickFanPaiButton))
  util.BtnScaleFun(self.Btn_FanPai)

    --提示按钮
    self.Btn_CardTip = cc.uiloader:seekNodeByNameFast(gameScene.root, "Btn_Tip")
	self.Btn_CardTip:setVisible(false)
	self.Btn_CardTip:onButtonClicked(handler(self,self.clickCardTipButton))
   util.BtnScaleFun(self.Btn_CardTip)
    --亮牌按钮
    self.Btn_CardShow = cc.uiloader:seekNodeByNameFast(gameScene.root, "Btn_Show")
	self.Btn_CardShow:setVisible(false)
	self.Btn_CardShow:onButtonClicked(handler(self,self.clickCardShowButton))
   util.BtnScaleFun(self.Btn_CardShow)
   
    --搓牌界面
  self.CuoPaiLayer = cc.uiloader:seekNodeByNameFast(gameScene.root, "CuoPaiLayer")
	self.CuoPaiLayer:setVisible(false)
	self.CuoPaiLayer:setLocalZOrder(2000)
    local btn_closeCuopaiLayer = cc.uiloader:seekNodeByNameFast(self.CuoPaiLayer, "CloseButton")
	btn_closeCuopaiLayer:onButtonClicked(handler(self,self.clickCuoPaiLayerCloseButton))
   


--微信邀请好友
  self.k_btn_invite_friend = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_invite_friend")
  self.k_btn_invite_friend:setVisible(false)
  util.BtnScaleFun(self.k_btn_invite_friend)
  self.k_btn_invite_friend:onButtonClicked(function() 
         print("shareBtn clicked")
        Share.requestWChatFriend( gameScene.roominfo.table_code, gameScene.roominfo.max_player, 
          gameScene.roominfo.gameround, 116, gameScene.roominfo.pay_type, gameScene.roominfo.customization)
        
  end)
  -- if util.requestBtn then
  --  util.requestBtn:onButtonClicked(function() 
  --     print("shareBtn clicked")
  --     Share.requestWChatFriend( gameScene.roominfo.table_code, gameScene.roominfo.max_player, gameScene.roominfo.gameround, 116, gameScene.roominfo.pay_type, gameScene.roominfo.customization)

  -- end)
  -- end
  util.requestBtn = self.k_btn_invite_friend
  
	--自由抢庄按钮显示
	self.k_nd_operation_01 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_operation_01")
	self.k_nd_operation_01:setVisible(false)

    --明牌抢庄按钮显示
  self.k_nd_operation_03 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_operation_03")
  self.k_nd_operation_03:setVisible(false)
  self.k_nd_operation_03:setLocalZOrder(2010)

	--下注s按钮显示按钮显示
	self.k_nd_operation_02 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_operation_02")
	self.k_nd_operation_02:setVisible(false)
  self.k_nd_operation_02:setLocalZOrder(2010)

	--抢庄按钮
	self.k_btn_Qiang = cc.uiloader:seekNodeByName(self.k_nd_operation_01, "k_btn_Qiang")
	self.k_btn_Qiang:onButtonClicked(handler(self,self.clickQiang))
  util.BtnScaleFun(self.k_btn_Qiang)
	--不抢庄按钮
	self.k_btn_BuQiang = cc.uiloader:seekNodeByName(self.k_nd_operation_01, "k_btn_BuQiang")
	self.k_btn_BuQiang:onButtonClicked(handler(self,self.clickBuQiang))
  util.BtnScaleFun(self.k_btn_BuQiang)

  --明牌抢庄按钮
  for i=0,4 do
      local s = string.format("fanbei_%d", i)
      print(s)
      local btn = cc.uiloader:seekNodeByName(self.k_nd_operation_03, s)
      util.BtnScaleFun(btn)
      btn:onButtonClicked(function() 

              print("明牌抢庄按钮选择   " ..i)
               gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
              if i == 0 then   --不抢庄
               gameScene.WRNN_Message.sendMessage("WRNN.RunFor",{
                  session = gameScene.session,
                  seat = gameScene.seatIndex,
                  select = 0,
                },gameScene.WRNN_Const.REQUEST_INFO_03)

              else
                gameScene.WRNN_Message.sendMessage("WRNN.RunFor",{
                  session = gameScene.session,
                  seat = gameScene.seatIndex,
                  select = i,
                },gameScene.WRNN_Const.REQUEST_INFO_02)
               
              end


      end)     
  end



	--规则按钮
	self.k_btn_rule = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_rule")
	self.k_btn_rule:onButtonClicked(handler(self,self.clickRule))
  util.BtnScaleFun(self.k_btn_rule)
	--下注区域监听
	self.k_img_Bet_Rect = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_img_Bet_Rect")
	self.k_img_Bet_Rect:setTouchEnabled(false)
	self.k_img_Bet_Rect:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)


  --上局回顾界面
  self.LookBackLayer = cc.uiloader:seekNodeByNameFast(gameScene.root, "LookBackLayer")

  self.LookBackLayer:setLocalZOrder(4500)


   self.touchLayer = cc.uiloader:seekNodeByNameFast(self.LookBackLayer, "TouchLayer")
   self.touchLayer:hide()
      self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT,
                                function(event)
                if event.name == "began" then
                    
                    if self.touchLayer:isVisible() then
                       self.touchLayer:hide()
                       self.touchLayer:setTouchEnabled(false)
                       self.LookBackLayer:moveBy(0.1,658,0)
                       self.LookBackLayerOpenSate = not self.LookBackLayerOpenSate                    
                    end
                  return true
                end               
                end)

       -- --关闭按钮
       --  cc.uiloader:seekNodeByNameFast(self.LookBackLayer, "CloseBtn")
       --  :onButtonClicked(function()   
       --     --self.LookBackLayer:hide()
       --     self.LookBackLayerOpenSate = not self.LookBackLayerOpenSate
       --     if self.LookBackLayerOpenSate == false then
       --       self.LookBackLayer:moveBy(0.2,658,0)  
       --     end
          
       --   end)




        

         self.LookBackLayer.items ={}
         for i=1,6 do
            local item  = cc.uiloader:seekNodeByNameFast(self.LookBackLayer,string.format("item_%d",i))
            item.select = cc.uiloader:seekNodeByNameFast(item,"select")
            item.head_icon = cc.uiloader:seekNodeByNameFast(item,"icon")
            item.nick_name = cc.uiloader:seekNodeByNameFast(item,"nameText")       
            item.Score = cc.uiloader:seekNodeByNameFast(item,"scoreText")
            item.banker_icon = cc.uiloader:seekNodeByNameFast(item,"banker_icon")
            item.gold_icon = cc.uiloader:seekNodeByNameFast(item,"gold_icon")
            item.lastScoreText = cc.uiloader:seekNodeByNameFast(item,"LastScoreText")
            item.cardcontener = cc.uiloader:seekNodeByNameFast(item,"cardcontener")

            item:hide()
            self.LookBackLayer.items[i] = item
        end


    




  --查看战绩
  self.k_btn_Record = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_Record")
  self.k_btn_Record:setVisible(false)
  self.k_btn_Record:setLocalZOrder(4000)
  self.k_btn_Record:onButtonClicked(handler(self,self.clickRecord))
  --返回大厅
  self.k_btn_BackHome = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_btn_BackHome")
  self.k_btn_BackHome:setVisible(false)
  self.k_btn_BackHome:setLocalZOrder(4000)
  self.k_btn_BackHome:onButtonClicked(handler(self,self.backHome))

  --战绩页面
  self.RecordLayer = cc.uiloader:seekNodeByNameFast(gameScene.root, "RecordLayer")
  self.RecordLayer:hide()
  self.RecordLayer:setLocalZOrder(5000)
       
        self.RecordLayer.RoomIdText = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "RoomIdText")
        self.RecordLayer.RoundText = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "RoundText")
        self.RecordLayer.BaseScoreText = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "BaseScoreText")
        self.RecordLayer.BankerTypeText = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "BankerTypeText")

        self.RecordLayer.TimeText = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "TimeText")

        self.RecordLayer.Autoback_Text = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "Autoback_Text")

        --返回大厅
        local back_dt = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "BackHomeBtn")
        back_dt:onButtonClicked(handler(self,self.backHome))
        --微信分享
        local wxs = cc.uiloader:seekNodeByNameFast(self.RecordLayer, "WxShareBtn")
        wxs:onButtonClicked(function()   
            Share.createGameShareLayer():addTo(gameScene)
          print("click wx ")
         end)

        util.BtnScaleFun(back_dt)
        util.BtnScaleFun(wxs)
    
        self.RecordLayer.items ={}
        for i=1,6 do
            local item  = cc.uiloader:seekNodeByNameFast(self.RecordLayer,string.format("item_%d",i))
            item.head_icon = cc.uiloader:seekNodeByNameFast(item,"head_icon")
            item.nick_name = cc.uiloader:seekNodeByNameFast(item,"nick_name")
            item.id = cc.uiloader:seekNodeByNameFast(item,"id")
            item.Type_1 = cc.uiloader:seekNodeByNameFast(item,"Type_1")
            item.Type_2 = cc.uiloader:seekNodeByNameFast(item,"Type_2")
            item.Score = cc.uiloader:seekNodeByNameFast(item,"Score")
            item.roomer = cc.uiloader:seekNodeByNameFast(item,"roomer")
            item:hide()
            self.RecordLayer.items[i] = item
        end

--TipLayer
      self.TipLayer = cc.uiloader:seekNodeByNameFast(gameScene.root, "TipLayer")
      self.TipLayer:hide()
      self.TipLayer:setLocalZOrder(5000)
      self.TipLayer.TextInfo = cc.uiloader:seekNodeByNameFast(self.TipLayer, "TextInfo")

        self.TipLayer.Btn_Sure = cc.uiloader:seekNodeByNameFast(self.TipLayer, "Btn_Sure")
        self.TipLayer.Btn_Cancel = cc.uiloader:seekNodeByNameFast(self.TipLayer, "Btn_Cancel")
        self.TipLayer.Btn_Sure_1 = cc.uiloader:seekNodeByNameFast(self.TipLayer, "Btn_Sure_1")
        self.TipLayer.TimerText = cc.uiloader:seekNodeByNameFast(self.TipLayer, "TimerText")
        self.TipLayer.Btn_Sure:hide()
        self.TipLayer.Btn_Cancel:hide()
        self.TipLayer.Btn_Sure_1:hide()
        self.TipLayer.TimerText:setString("")

        util.BtnScaleFun(self.TipLayer.Btn_Sure)
        util.BtnScaleFun(self.TipLayer.Btn_Cancel)
        util.BtnScaleFun(self.TipLayer.Btn_Sure_1)

        self.TipLayer.Btn_Sure:onButtonClicked(function()  
                                               self.TipLayer:hide() 

        gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
        gameScene.WRNN_Message.sendMessage("WRNN.Dismiss",{session = gameScene.session},"发送下庄消息")

                                               end)
        self.TipLayer.Btn_Cancel:onButtonClicked(function() 
                                                self.TipLayer:hide() 

                                                end)

        self.TipLayer.Btn_Sure_1:onButtonClicked(function() 
                                                  self.TipLayer:hide() 
                                                  self.TipLayer.Btn_Sure_1:stopAllActions()
                                                  gameScene.WRNN_Message.sendMessage("WRNN.SureDismiss",{session = gameScene.session},"发送 同意下庄 消息")
                                               end)

 
      --Todo 根据房间配置来生成下注按钮
      for i=1,5 do
      	 score_btns[i] =  cc.uiloader:seekNodeByName(self.k_nd_operation_02, "Btn_Score_" .. i)      	        
      	 score_btns[i]:setButtonLabelString("normal", ""..i)
      	 score_btns[i]:setButtonLabelString("pressed", ""..i)
      	 score_btns[i]:setButtonLabelString("disabled", ""..i)  
         util.BtnScaleFun(score_btns[i])   	
      	 score_btns[i]:onButtonClicked(function(button) 
                self.k_nd_operation_02:hide()
             --   print(score_btns[i].score)
                  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
                gameScene.WRNN_Message.sendMessage("WRNN.Bet",{
						session = gameScene.session,
						bet = score_btns[i].score 
						},gameScene.WRNN_Const.REQUEST_INFO_04)
      	end)
      end

   

 --   local RubCardFunc = require("app.Common.RubCardEffectLayer")


   -- --显示搓牌效果
   --  local layer = RubCardFunc("res/Image/WRNN/test/card.plist","res/Image/WRNN/test/card.png", "pai_bg.png", "pai_1.png", 2.0)
   --  self:addChild(layer)
  



  
end

function WRNN_uiOperates:clear()
end


--show room info 
function WRNN_uiOperates:showRoomInfo()
	    
    self.Text_RoomCode:setString(tostring(gameScene.roominfo.table_code))   
    local customization = gameScene.roominfo.customization
 -- 玩法  底分  下庄分数  翻倍规则 特殊牌型 高级选项             
 --decode(encode({{0,0,0}, {0,1,0}, {0,0,0,0}, {0,0}, {0,0,0}, {0,0}}))
    local info =code.decode(customization)
   -- dump(info,"=====")

    local param ={}
    if info[1][1] == 1 then
       param.baker_type ="通比牛牛"
       gameScene.roominfo.banker_type = 1
    end
    if info[1][2] == 1 then
       param.baker_type ="固定庄家"
        gameScene.roominfo.banker_type = 2
    end
    if info[1][3] == 1 then
       param.baker_type ="自由抢庄"
        gameScene.roominfo.banker_type = 3
    end
    if info[1][4] == 1 then
       param.baker_type ="明牌抢庄"
        gameScene.roominfo.banker_type = 4
    end
    
    self.Text_BankerType:setString(param.baker_type)
    self.Text_CurrentRound:setString("0")
    self.Text_Round:setString("/"..gameScene.roominfo.gameround)

    self.Text_RoomCode:show()
    self.Text_BankerType:show()
    self.Text_BaseScore:show()
    self.Text_CurrentRound:show()
    self.Text_Round:show()
   



    --设置规则信息

   local double_rule1 = "牛牛x3 牛九x2 牛八x2 牛七x2"
   local double_rule2 = "牛牛x5 牛九x4 牛八x3 牛七x2"

    if info[2][1] == 1  then
       param.baseScore = "1/2/3/4/5" 
       gameScene.roominfo.baseScore = 1 
    end
    if info[2][2] == 1  then
       param.baseScore = "1/2/3/4/5" 
       gameScene.roominfo.baseScore = 2 
    end
    if info[2][3] == 1  then
       param.baseScore = "1/2/3/4/5" 
       gameScene.roominfo.baseScore = 3 
    end
    self.Text_BaseScore:setString(param.baseScore)

     if info[1][2] == 1 then --固定庄家
      self.Text_OverBankerTip:show()
      self.Text_OverBanker:show()
      local score ={[1]={"无","-100","-200","-300"},
                    [2]={"无","-100","-300","-500"},
                    [3]={"无","-100","-300","-1000"},
                   }
       local base_score_type = 1
       for i=1,4 do
          if  info[3][i] == 1 then
             base_score_type = i
             break
          end    
       end
      self.Text_OverBanker:setString(score[gameScene.roominfo.baseScore][base_score_type])

    end



    if info[4][1] == 1  then
       param.doubletype = double_rule1
    else 
       param.doubletype = double_rule2
    end
    if gameScene.roominfo.pay_type == 1 then
    	param.paymode = "房主支付"
    else
    	param.paymode = "AA支付"
    end
   
    -- for i=1,5 do
    -- 	 local score  = basescore[gameScene.roominfo.baseScore][i]
    --   	 score_btns[i]:setButtonLabelString("normal", ""..score)
    --   	 score_btns[i]:setButtonLabelString("pressed", ""..score)
    --   	 score_btns[i]:setButtonLabelString("disabled", ""..score)
    --   	 score_btns[i].score = score
    -- end
    
    --特殊玩法
    param.special =""
    if info[5][1] == 1 then
    	param.special = param.special .. "五花牛(5倍)"
    end
    if info[5][2] == 1 then
    	param.special = param.special .. " 炸弹(5倍)"
    end
    if info[5][3] == 1 then
    	param.special = param.special .. " 五小牛(8倍)"
    end

    if info[6][2] and info[6][2] ==1 then
        param.special = param.special .. " 去花牌"
    end

    gameScene.WRNN_uiRule:setRuleInfo(param)

    if info[6][1] and info[6][1] ==1 then
    	gameScene.cuopaiEnable = false
    end
   
       --战绩详情里的参数
     self.RecordLayer.RoomIdText:setString(tostring(gameScene.roominfo.table_code))
     self.RecordLayer.RoundText:setString(tostring(gameScene.roominfo.gameround))
     self.RecordLayer.BaseScoreText:setString(param.baseScore)
     self.RecordLayer.BankerTypeText:setString(param.baker_type)


end

--更新当前局数
function WRNN_uiOperates:setCurrentRound(round)
    self.Text_CurrentRound:setString(round)
end


--[[
	* 开始游戏按钮回调
--]]
function WRNN_uiOperates:clickStartReady()
	--print("点击了准备按钮")


	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)

	gameScene.WRNN_Message.dispatchGame("room.ReadyReq",gameScene.WRNN_Const.REQUEST_INFO_00)

end
function WRNN_uiOperates:setRoomIdBtnVisible(visible)
    
end

function WRNN_uiOperates:clickStartGame()
	print("点击了开始游戏按钮")
	
	self.k_btn_start_game:hide()
  --隐藏准备提示
  local seat = gameScene.WRNN_Util.convertSeatToPlayer(gameScene.seatIndex)
  gameScene.WRNN_PlayerMgr:playerReady(seat,false)
  gameScene.WRNN_Message.sendMessage("WRNN.BeginGameReq",{session = gameScene.session},"发送 开始游戏 请求")




  

end
--下一局准备
function WRNN_uiOperates:clickNextStartReady()
	--print("点击了下一局准备按钮")



	self.k_btn_next_ready:hide()
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
  gameScene.WRNN_Message.dispatchGame("room.ReadyReq",gameScene.WRNN_Const.REQUEST_INFO_00)

end
function WRNN_uiOperates:setNextStartReadyBtnVisible(visible)

     self.k_btn_next_ready:setVisible(visible)
end

--移动开始按钮到中间位置
function WRNN_uiOperates:MoveStartBtnCenter()
      -- local move = cc.MoveTo:create(0.2,cc.p(640,194))
      -- --self.k_btn_start_game:setVisible(true)
      -- transition.execute(self.k_btn_start_game, move)
end

--设置开始按钮的可见与可用
function WRNN_uiOperates:setStartGameBtnEnable(visible,enabled)
	     -- self.k_btn_start_game:setVisible(visible)
	     -- self.k_btn_start_game:setButtonEnabled(enabled)
end

--[[
   * copy roomid 
--]]
local coint_count = 0
function WRNN_uiOperates:clickCopyButton()
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
	util.copyToClipboard(gameScene.roominfo.roomid)
	ErrorLayer.new(app.lang.copy_acccount_id):addTo(self)
                    

end


--[[
	* 抢庄按钮回调
--]]
function WRNN_uiOperates:clickQiang()
	print("点击了抢庄按钮")


	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)

	gameScene.WRNN_Message.sendMessage("WRNN.RunFor",{
			session = gameScene.session,
      seat = gameScene.seatIndex,
			select = 1,
		},gameScene.WRNN_Const.REQUEST_INFO_02)
end

--[[
	* 不抢庄按钮回调
--]]
function WRNN_uiOperates:clickBuQiang()
	print("点击了不抢庄")

	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)

	gameScene.WRNN_Message.sendMessage("WRNN.RunFor",{
			session = gameScene.session,
      seat = gameScene.seatIndex,
			select = 0,
		},gameScene.WRNN_Const.REQUEST_INFO_03)
end






--[[
	* 规则按钮回调
--]]
function WRNN_uiOperates:clickRule()
	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)

	gameScene.WRNN_uiRule:showGameRule(true)
end

--[[
	* 显示 准备按钮
	* @param bool flag  显示状态
--]]
function WRNN_uiOperates:showStartReady(flag)
	self.k_btn_start_ready:setVisible(flag)

	if not flag then
		utilCom.SetRequestBtnHide()
	else
		utilCom.SetRequestBtnShow()
	end
end

--[[
	* 显示抢庄,不抢牌按钮
	* @param bool flag  显示状态
--]]
function WRNN_uiOperates:showOperates_01(flag)
	--未参与游戏
	if gameScene.status ~= 0 then
		return 
	end

  if gameScene.roominfo.banker_type == 4 then -- 明牌抢庄
      self.k_nd_operation_03:setVisible(flag)
  else
      self.k_nd_operation_01:setVisible(flag)
  end





   if flag == true then
    gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_DINGDING)
  end
end

--[[
	* 显示 下注精灵按钮
	* @param bool flag  显示状态
--]]
function WRNN_uiOperates:showOperates_02(flag)

	self.k_nd_operation_02:setVisible(flag)
  if flag == true then
    gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_DINGDING)
  end

end

--[[
	* 设置下注状态
	* @param bool flag  下注状态
--]]
function WRNN_uiOperates:setBetState(flag)
	self.k_img_Bet_Rect:setTouchEnabled(flag)
end

--[[
	* 设置下注金额
	* @param number gold  下注金额
--]]
function WRNN_uiOperates:setBetGold(gold)
	if gold == 1000 or gold == 10000 or gold == 100000 or gold == 500000 or gold == 1000000 or gold == 5000000 then
		currentBetGold = gold
		local ui_sp_bet_btn = cc.uiloader:seekNodeByName(self.k_nd_operation_02, "k_sp_" .. gold)
		--self.k_sp_jetton_effect:pos(ui_sp_bet_btn:getPositionX()-3,ui_sp_bet_btn:getPositionY()+1)
		--self.k_sp_jetton_effect:setVisible(true)
	end

	if gold == 0 then
		currentBetGold = gold
		--self.k_sp_jetton_effect:setVisible(false)
	end
end


function WRNN_uiOperates:setCuopaiButtonVisable(state)
         
         self.Btn_CuoPai:setVisible(state)
         self.Btn_FanPai:setVisible(state)
         if gameScene.cuopaiEnable == false then
         	self.Btn_CuoPai:setVisible(false)
         end

end
function WRNN_uiOperates:setCardShowButtonVisable(state)

         self.Btn_CardTip:setVisible(state)
         self.Btn_CardShow:setVisible(state)
end



--搓牌
function WRNN_uiOperates:clickCuoPaiButton()
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
  Cuopai_Open_State = true
  if gameScene.OpenCardState == true then
  return
  end   

        self:setCuopaiButtonVisable(false)
        local cards = gameScene.WRNN_CardMgr.ui_cards[1]  
   --搓牌有2种  明牌抢庄  跟普通抢庄
       
       if gameScene.roominfo.banker_type == 4  then  --明牌抢庄

                local count =0
                local showCount = 3 -- 搓过的牌
                for i=#cards,1,-1 do  

                  local move = cc.MoveTo:create(0.2 + i*0.02, cc.p(800,-50))
                  local scale = cc.ScaleTo:create(0.2+i*0.02,0)
                  local spawn = cc.Sequence:create(move,scale)
                    local action = cc.Sequence:create(
                  spawn, 
                  cc.CallFunc:create(function()
                    count = count + 1
                    if count == #cards  then
                                    --显示牌
                                    for k=#cards,1,-1 do
                                      local card = cards[k]
                                        card:setLocalZOrder(2001)
                                         if k >=4  then
                                            card:setScale(2.0)
                                            card:setRotation(-k*1)
                                            card:setAnchorPoint(0,0)
                                            card:showFront()
                                            card:setPosition(cc.p(620-2*k,-20-k*2))
                                            card:setTouchEnabled(true)

                                         else
                                            card:setScale(2.0)
                                            card:setAnchorPoint(0,0)
                                            card:showFront()
                                            card:setPosition(cc.p(980-240*k,400))
                                           

                                         end

                                        card.ShowState = false  -- 是否显示过  当4张牌都被搓过 那么关闭错牌界面
                                        local c = {}                           
                                              card:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                                                              if event.name == "began" then                            
                                                                                  c.x = event.x
                                                                                  c.y = event.y
                                                                return true
                                                              end
                                                              if event.name == "moved" then
                                                                                 local dx = event.x - c.x
                                                                                 local dy = event.y - c.y
                                                                                 local D = math.pow(dx, 2) + math.pow(dy, 2)  
                                                                               --  print(D)
                                                                                 if D > 15 then
                                                                                     card:setPosition(card:getPositionX()+dx,card:getPositionY()+dy)
                                                                                     c.x = event.x
                                                                                     c.y = event.y
                                                                                     if not card.ShowState  then
                                                                                        card.ShowState = true
                                                                                        showCount = showCount+1
                                                                                          
                                                                                      end 
                                                                                 end
                                                                                                                                         
                                                              end
                                                              if event.name == "ended" then

                                                              if showCount >=4 then --遍历所有的牌 关闭触摸响应

                                                                      self:clickCuoPaiLayerCloseButton()
                                                                    --关闭搓牌界面                              
                                                                end  
                                                              end
                                              end)
                                    end
                       self.CuoPaiLayer:show()
                    end
                  end)
                )
                                 
                 
               transition.execute(cards[i], action)




                end






      else
    
                local count =0
                local showCount =0 -- 搓过的牌
                for i=#cards,1,-1 do  
                  local move = cc.MoveTo:create(0.2 + i*0.02, cc.p(800,-50))
                  local scale = cc.ScaleTo:create(0.2+i*0.02,0)
                  local spawn = cc.Sequence:create(move,scale)
                    local action = cc.Sequence:create(
                  spawn, 
                  cc.CallFunc:create(function()
                    count = count + 1
                    if count == #cards  then
                                    --显示牌
                                    for k=#cards,1,-1 do
                                      local card = cards[k]
                                        card:setLocalZOrder(2001)
                                        card:setScale(2.0)
                                        card:setRotation(-k*1)
                                        card:setAnchorPoint(0,0)
                                        card:showFront()
                                        card:setPosition(cc.p(620-2*k,-20-k*2))
                                        card:setTouchEnabled(true)
                                        card.ShowState = false  -- 是否显示过  当4张牌都被搓过 那么关闭错牌界面
                                        local c = {}                           
                        card:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                        if event.name == "began" then                            
                                            c.x = event.x
                                            c.y = event.y
                          return true
                        end
                        if event.name == "moved" then
                                           local dx = event.x - c.x
                                           local dy = event.y - c.y
                                           local D = math.pow(dx, 2) + math.pow(dy, 2)  
                                         --  print(D)
                                           if D > 15 then
                                               card:setPosition(card:getPositionX()+dx,card:getPositionY()+dy)
                                               c.x = event.x
                                               c.y = event.y
                                               if not card.ShowState  then
                                                  card.ShowState = true
                                                  showCount = showCount+1
                                                    
                                                end 
                                           end
                                                                                                   
                        end
                                        if event.name == "ended" then

                                        if showCount >=4 then --遍历所有的牌 关闭触摸响应

                                                self:clickCuoPaiLayerCloseButton()
                                              --关闭搓牌界面                              
                                          end  
                                        end
                        end)
                                    end
                       self.CuoPaiLayer:show()
                    end
                  end)
                )
                 
                    transition.execute(cards[i], action)

                end

       end
       
  








       
 
       
      
end

--翻牌
function WRNN_uiOperates:clickFanPaiButton()
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
  if gameScene.OpenCardState == true then
  return
  end 

        self:setCuopaiButtonVisable(false)
        local cards = gameScene.WRNN_CardMgr.ui_cards[1]
        local scale = 0.84
        
                for i=1,#cards do

                    local s1 = cc.ScaleTo:create(0.3,0,scale)
                    local action1 = cc.Sequence:create(s1, 
                    cc.CallFunc:create(function() 
                                  if i == #cards then
                                     --self:setCardShowButtonVisable(true)
                                      gameScene.WRNN_CardMgr:showSelfCards()
                                  end
                    end))

                    local s2 = cc.ScaleTo:create(0.3,scale,scale)
                    local action2 = cc.Sequence:create(action1,s2, 
                    cc.CallFunc:create(function() 
                                if i == #cards then
                                   self:setCardShowButtonVisable(true)           
                                end
                     end))

                   
                    if gameScene.roominfo.banker_type  == 4 then 
                           if i == #cards then
                             transition.execute(cards[i], action2)
                           end
                                          
                    else
                       transition.execute(cards[i], action2)
                    end
                    




                end

 



        




	
end
--提示牌型

function WRNN_uiOperates:clickCardTipButton()
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
  gameScene.WRNN_Message.sendMessage("WRNN.Spy",{session = gameScene.session},"发送 提示牌型 请求")
 
end
--亮牌
function WRNN_uiOperates:clickCardShowButton()
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
  gameScene.WRNN_Message.sendMessage("WRNN.Open",{session = gameScene.session},"发送 亮牌 请求")	

end

--关闭搓牌界面
function WRNN_uiOperates:clickCuoPaiLayerCloseButton()
  if Cuopai_Open_State == false then
    return
  end
  Cuopai_Open_State = false
  if gameScene.OpenCardState == true then
  return
  end 
  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
    local cards = gameScene.WRNN_CardMgr.ui_cards[1]
    local count =0
    for i=1,#cards do
	    cards[i]:setTouchEnabled(false)
      cards[i]:setScale(2.0)
	    cards[i]:setRotation(30 - i*10)
	    cards[i]:setPosition(640 -5*i,-20-i*3)
            local delay  = cc.DelayTime:create(1)
            local rotation = cc.RotateTo:create(0.2,0)
            local move = cc.MoveTo:create(0.3 , cc.p(640,-50))
        	local scale = cc.ScaleTo:create(0.3,0)
        	local spawn = cc.Sequence:create(move,scale)
            local   action = cc.Sequence:create(delay,rotation,spawn, 
					    cc.CallFunc:create(function()
                        count =count+1
	                        if count == #cards then
	                        	self.CuoPaiLayer:hide()
	     					    self:setCardShowButtonVisable(true)
	     					    --显示牌到桌面上
	     					    gameScene.WRNN_CardMgr:resetSelfCardsPos()
	                        end                   
                        end)		
			        )
        transition.execute(cards[i], action)
    end  	
end
--
function WRNN_uiOperates:CuoPaiLayerCloseShutDown()
         
        -- if self.CuoPaiLayer:isVisible() then
              local cards = gameScene.WRNN_CardMgr.ui_cards[1]
              for i=1,#cards do
                cards[i]:setTouchEnabled(false)
                cards[i]:stopAllActions()
              end
              self.CuoPaiLayer:hide()  
             gameScene.WRNN_CardMgr:resetSelfCardsPos()
        -- end
         
end


--设置查看战绩 跟返回大厅 按钮
function WRNN_uiOperates:setRecordBtnViable(visible)
          self.k_btn_BackHome:show()
          self.k_btn_Record:show()
end

function WRNN_uiOperates:clickRecord()
        self.RecordLayer:show()
end


--设置战绩详情页面的分数
function WRNN_uiOperates:setRecordScore(index,seat,score,roomer)
          
          local item =  self.RecordLayer.items[index]   
          local info = gameScene.WRNN_PlayerMgr.playerInfos[seat]
           item.nick_name:setString(util.checkNickName(info.name))

            --头像
           local  image = AvatarConfig:getAvatar(info.sex, info.gold, info.viptype)
           local  rect = cc.rect(0, 0, 188, 188)
           local  frame = cc.SpriteFrame:create(image, rect)
           item.head_icon:setSpriteFrame(frame)
           item.head_icon:setScale(0.4734)
            util.setHeadImage(item, info.imageid, item.head_icon, image, 1)

           item.id:setString(""..info.uid)
           item.Type_1:hide()
           item.Type_2:hide()
           item.roomer:hide()
           item:show()
           if roomer then
            item.roomer:show()
            item.roomer:setLocalZOrder(10001)
            else
            item.roomer:hide()
           end

         --分数     
         if score > 0 then
            item.Score:setString("+"..score)
            item.Score:setColor(cc.c3b(207, 12, 8))
            item.Type_1:show()
         else
            item.Score:setString(""..score)
            item.Score:setColor(cc.c3b(37, 210, 37))
            item.Type_2:show()
         end
        
            
end

function WRNN_uiOperates:setAutobackTime(time)
      
        if time then
          self.RecordLayer.TimeText:setString(time)
        end
      
        local Time = 30
        self.RecordLayer.Autoback_Text:schedule(function() 
            Time = Time -1
            --print("time"..Time)
            self.RecordLayer.Autoback_Text:setString("("..Time.."s后自动返回大厅）")
           if Time <=0 then
                            
              self:backHome()
           end

       end,1) 
      sound_common.total_result_bg()


end



function WRNN_uiOperates:setRecordLayerVisiable(visiable)
         self.RecordLayer:setVisible(visiable)
end

function WRNN_uiOperates:backHome()
        self.RecordLayer.Autoback_Text:stopAllActions()
        gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_TOUCH)
        gameScene.WRNN_Message.dispatchPrivateRoom("room.LeaveGame",gameScene.WRNN_Const.REQUEST_INFO_01,gameScene)
end



--展示上局回顾里的牌
local function createUserCards(parent,cards,style)

       parent:removeAllChildren()
       local style = gameScene.WRNN_Util.getIndexByStringCardStyle(style)
       local CARD_WIDTH_DISTANCE =  34
       local dy = 0
       for i=1,#cards do
         local card  = cards[i]
         local ui_card = gameScene.WRNN_Card.new(card)
         print(i,card)
          ui_card:setScale(0.5)
          if style > 0 and style <= 9 and i > 3 then --后2张提起
             dy = 10
          end
          ui_card:pos(0+(i-1)*CARD_WIDTH_DISTANCE,0+dy)
          ui_card:addTo(parent,i) 


       end
      local cardtypeBg = display.newSprite(gameScene.WRNN_Const.PATH["TX_CARD_TYPE_BG"])
      local cardtype = display.newSprite(gameScene.WRNN_Const.PATH["TX_CARD_TYPE_" .. style])
      cardtypeBg:pos(80,-10)
      cardtypeBg:setScale(0.5)
      cardtype:setScale(0.5)
      cardtype:pos(80,-10)
      cardtypeBg:addTo(parent,6)
      cardtype:addTo(parent,7)

end
--上局回顾回顾相关UI
function WRNN_uiOperates:setLastBackLook(msg)
         -- dump(msg,"上局回复") 
         for i=1,#msg.players do
            
            local  player = msg.players[i]

            local  item =  self.LookBackLayer.items[i] 
            local  seat = gameScene.WRNN_Util.convertSeatToPlayer(player.seat)
            local  info = gameScene.WRNN_PlayerMgr.playerInfos[seat]
            if seat == 1 then
               item.select:show()
            else
               item.select:hide()
            end


            --头像
           local  image = AvatarConfig:getAvatar(info.sex, info.gold, info.viptype)
           local  rect = cc.rect(0, 0, 188, 188)
           local  frame = cc.SpriteFrame:create(image, rect)
            item.head_icon:setSpriteFrame(frame)
            item.head_icon:setScale(0.3734)
            util.setHeadImage(item, info.imageid, item.head_icon, image, 1)

            item.nick_name:setString(util.checkNickName(info.name))
            if  player.seat ~= msg.banker then
              item.banker_icon:hide()
              item.gold_icon:show()
            else

              if gameScene.roominfo.banker_type == 1 then
                 item.banker_icon:hide()
                 item.gold_icon:show()
              else                
                 item.banker_icon:show()
                 item.gold_icon:hide()
              end
              
             
            end
            local total_gold = info:getGold()
            if  total_gold >= 0 then
                item.Score:setString("+"..total_gold)
            else
                item.Score:setString(""..total_gold) 
            end
            local last_gold = tonumber(player.score)
            if  last_gold >= 0 then
                item.lastScoreText:setString("+"..last_gold)
                item.lastScoreText:setColor(cc.c3b(7, 199, 241))
            else
                item.lastScoreText:setString(""..last_gold) 
                item.lastScoreText:setColor(cc.c3b(255, 235, 0))
            end

            createUserCards(item.cardcontener,player.cards,player.style)

            item:show()
         end  
          self.LookBackLayerOpenSate = not self.LookBackLayerOpenSate

          if self.LookBackLayerOpenSate then
             self.LookBackLayer:moveBy(0.2,-658,0)
             self.touchLayer:show()
             self.touchLayer:setTouchEnabled(true)
          end
                  
end

function WRNN_uiOperates:setTipLayerinfo(type,time) -- 1 2
        local info = "庄家确定下庄将以当前成绩结算并解散房间"
        if type == 1 then --庄家
            info = "下庄后将以当前成绩结算并解散房间，是否确定下庄？"
            self.TipLayer.Btn_Sure:show()
            self.TipLayer.Btn_Cancel:show()
            self.TipLayer.Btn_Sure_1:hide()
            self.TipLayer.TimerText:setString("")
        else
          self.TipLayer.Btn_Sure:hide()
          self.TipLayer.Btn_Cancel:hide()
          self.TipLayer.Btn_Sure_1:show()
          self.TipLayer.TimerText:setString("("..time.."s)")
          local  count = time
          self.TipLayer.Btn_Sure_1:schedule(function()
              --  print("倒计时 "..count)
                count = count -1
                self.TipLayer.TimerText:setString("("..count.."s)")
               if count <=0 then
                self.TipLayer.Btn_Sure_1:stopAllActions()
                 self.TipLayer:hide()
                 gameScene.WRNN_Message.sendMessage("WRNN.SureDismiss",{session = gameScene.session},"发送 同意下庄 消息") 
               end
                       
         end,1)
        end
        self.TipLayer.TextInfo:setString(info)
        self.TipLayer:show()
end

--下庄按钮显示
function WRNN_uiOperates:setOverBankerBtn(visible)

      self.k_btn_overbanker:setVisible(visible)

end

--下zhuang按钮
function WRNN_uiOperates:clickOverBanker()
        self:setTipLayerinfo(1)       
end
--
function WRNN_uiOperates:setInvite_friendBtn(visible)
         self.k_btn_invite_friend:setVisible(visible)
end



function WRNN_uiOperates:setBetButton(bets)

          if #bets == 1 then

            for i=1,5 do
                 score_btns[i]:hide()
            end
            --显示中间的按钮
            local score = bets[1]
            score_btns[3]:show()
            score_btns[3]:setButtonLabelString("normal", ""..score)
            score_btns[3]:setButtonLabelString("pressed", ""..score)
            score_btns[3]:setButtonLabelString("disabled", ""..score)
            score_btns[3].score = score
          else
              for i=1,5 do

                  if i <= #bets then
                       local score = bets[i]
                       score_btns[i]:setButtonLabelString("normal", ""..score)
                       score_btns[i]:setButtonLabelString("pressed", ""..score)
                       score_btns[i]:setButtonLabelString("disabled", ""..score)
                       score_btns[i].score = score
                       score_btns[i]:show()
                  else
                     score_btns[i]:hide()
                  end
                
                
              end


          end

    

end





return WRNN_uiOperates