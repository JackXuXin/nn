--
-- Author: peter
-- Date: 2017-04-24 09:56:13
--

local scheduler = require("framework.scheduler")

local gameScene = nil

local sendCardPos = {
    {370,100},	--1	
    {888,300},  --2	
	{798,436},  --3
	{576,500},  --4
	{356,436},  --5
	{260,300},  --6

}

local WRNN_CardMgr = {}

function WRNN_CardMgr:init(scene)
	gameScene = scene

	self.ui_cards = {}  --每个玩家的手牌
	self.ui_cardType = {}  --牌型的UI显示
	self.ui_cardTypeBG = {}  --牌型的UI显示背景

end

function WRNN_CardMgr:clear()
end

--[[
	* 发牌
	* @param table seats 发牌玩家的椅子号
	* @param table cards 自己手牌的信息
--]]
function WRNN_CardMgr:sendPlayerCard(seats,cards,time)

	--排序发牌顺序
	local count = 0
	local delay = 0
	local CARD_WIDTH_DISTANCE = 0
	local moveActionTime = 0.1

	local CardIndex = 0  

	for index,cardInfo in pairs(cards) do
		index = index - 1
		for _,seat in pairs(seats) do
			seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)
    		delay = delay + moveActionTime
    		scheduler.performWithDelayGlobal(function()
    			local ui_card = nil
				if seat == 1 then
					ui_card = gameScene.WRNN_Card.new(cardInfo)
					ui_card:setScale(0.84)
                    if gameScene.roominfo.banker_type  ~= 4 then
                       ui_card:showLast()
                    end
				    ui_card.self = true 
					CARD_WIDTH_DISTANCE = 98
					if cardInfo ~= 0 then  
					    CardIndex = CardIndex + 1
					    --print("----CardIndex ----" ..CardIndex)
					end
				else
					ui_card = gameScene.WRNN_Card.new()
					ui_card:setScale(0.63)
					CARD_WIDTH_DISTANCE = 34
				end
				ui_card:pos(640,360)
				ui_card:addTo(gameScene.root)

				if not self.ui_cards[seat] then
					self.ui_cards[seat] = {}
				end
				table.insert(self.ui_cards[seat],ui_card)
				local action = cc.Sequence:create(
					cc.MoveTo:create(moveActionTime, cc.p(sendCardPos[seat][1] + index * CARD_WIDTH_DISTANCE,sendCardPos[seat][2])), 
					cc.CallFunc:create(function()
						
						count = count + 1
                        
                        if ui_card.self and  ui_card.self == true then
                        	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_SEND_CARD)
                        end
                        
	
						if count == #seats * 5 then

							if gameScene.roominfo.banker_type  == 4 then
							    --显示前4张
							    if CardIndex == 5 then
							    	--显示牌型完成
							    	gameScene.SendCardTimes = 2
									gameScene.WRNN_uiOperates:setCuopaiButtonVisable(false)
		    						gameScene.WRNN_uiOperates:setCardShowButtonVisable(true)
							    end


							else
								--显示牌型完成
								gameScene.WRNN_uiOperates:setCuopaiButtonVisable(true)
	    						gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)
	                            gameScene.WRNN_uiTableInfos:setTipInfo("查看手牌：")
	                            gameScene.WRNN_uiTableInfos:startTimer(time)
							end
							



                            --其他玩家显示 算牌中动画
                            --Todo
                            for _,seat3 in pairs(seats) do
									local seat_temp = gameScene.WRNN_Util.convertSeatToPlayer(seat3)
									if seat_temp ~=1 then
										gameScene.WRNN_uiPlayerInfos:showThinkCardAnimation(seat_temp, true)
									end
							end


						end
					end)
				)
    			transition.execute(ui_card, action)
			end, delay)
		end
	end
    
	self:showGamePlayerCardType(seats)


end


--[[
	* 恢复场景发牌
    * style = nil 说明还未开牌
--]]
function WRNN_CardMgr:sendPlayerCard2(seat,cards,style)

      
       local CARD_WIDTH_DISTANCE = 0
       seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)
      for index,cardInfo in pairs(cards) do
		  index = index - 1
            
	        local ui_card = nil
	        if style and style ~="" then
	        	ui_card = gameScene.WRNN_Card.new(cardInfo)
	        else
	        	ui_card = gameScene.WRNN_Card.new(cardInfo)
               if gameScene.roominfo.banker_type ~= 4 then  --明牌抢庄
               	  ui_card:showLast()
               end
	        	


	        end
	        if seat == 1 then
	        	ui_card:setScale(0.84)
		 		CARD_WIDTH_DISTANCE = 98
		 	else
		 		ui_card:setScale(0.63)
		 		CARD_WIDTH_DISTANCE = 34
	        end
	   		ui_card:pos(sendCardPos[seat][1] + index * CARD_WIDTH_DISTANCE,sendCardPos[seat][2])  
		    ui_card:addTo(gameScene.root)
	    	if not self.ui_cards[seat] then
	    	 	self.ui_cards[seat] = {}
		 	end
			table.insert(self.ui_cards[seat],ui_card)


       end
       if seat == 1 then --本人
               if style and style ~="" then  --已经开牌
               	  gameScene.WRNN_uiOperates:setCuopaiButtonVisable(false)
     			  gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)
     			else   -- 未开牌 显示搓牌按钮
     			    gameScene.WRNN_uiOperates:setCuopaiButtonVisable(true)
         			gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)
               end	
       end
      self:showGameAlongPlayerCardType(seat)
      self:setGamePlayerCardType2(seat,style,cards)


end
--明牌抢庄断线重连后恢复牌
function WRNN_CardMgr:sendPlayerCard3(seat,cards,style)

       
       local CARD_WIDTH_DISTANCE = 0
       seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)
      for index,cardInfo in pairs(cards) do
		  index = index - 1
            
	        local ui_card = nil
	        if style and style ~="" then
	        	ui_card = gameScene.WRNN_Card.new(cardInfo)
	        else
	        	ui_card = gameScene.WRNN_Card.new(cardInfo)
	        	-- ui_card:showLast()
	        end
	        if seat == 1 then
	        	ui_card:setScale(0.84)
		 		CARD_WIDTH_DISTANCE = 98
		 	else
		 		ui_card:setScale(0.63)
		 		CARD_WIDTH_DISTANCE = 34
	        end
	   		ui_card:pos(sendCardPos[seat][1] + index * CARD_WIDTH_DISTANCE,sendCardPos[seat][2])  
		    ui_card:addTo(gameScene.root)
	    	if not self.ui_cards[seat] then
	    	 	self.ui_cards[seat] = {}
		 	end
			table.insert(self.ui_cards[seat],ui_card)


       end
       if seat == 1 then --本人
               if style and style ~="" then  --已经开牌
               	  gameScene.WRNN_uiOperates:setCuopaiButtonVisable(false)
     			  gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)
     			else   -- 未开牌 显示搓牌按钮
     			    gameScene.WRNN_uiOperates:setCuopaiButtonVisable(false)
         			gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)
               end	
       end
      self:showGameAlongPlayerCardType(seat)
      self:setGamePlayerCardType2(seat,style,cards)


end






--[[
	* 显示牌型
	* @param table seats 游戏玩家椅子号
--]]
function WRNN_CardMgr:showGamePlayerCardType(seats)
    print("--------showGamePlayerCardType---------")

	for _,v in pairs(seats) do
		local seat = 0
		if type(v) == "table" then
			seat = v.seatid
		else
			seat = v
		end
		seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)

		self.ui_cardTypeBG[seat] = display.newSprite(gameScene.WRNN_Const.PATH.IMG_CARD_TYPE_BG)
		self.ui_cardType[seat] = display.newSprite(gameScene.WRNN_Const.PATH.TX_CARD_TYPE_NO)
		self.ui_cardTypeBG[seat]:setLocalZOrder(200)
		self.ui_cardType[seat]:setLocalZOrder(200)
		self.ui_cardTypeBG[seat]:hide()
		self.ui_cardType[seat]:hide()


		if seat == 1 then
			self.ui_cardTypeBG[seat]:pos(sendCardPos[seat][1]+240,sendCardPos[seat][2]-41)
			self.ui_cardType[seat]:pos(sendCardPos[seat][1]+240,sendCardPos[seat][2]-41)
		else
			self.ui_cardTypeBG[seat]:pos(sendCardPos[seat][1]+70,sendCardPos[seat][2]-23)
			self.ui_cardType[seat]:pos(sendCardPos[seat][1]+70,sendCardPos[seat][2]-23)
		end

		self.ui_cardTypeBG[seat]:addTo(gameScene.root)
		self.ui_cardType[seat]:addTo(gameScene.root)
	end
end

function WRNN_CardMgr:showGameAlongPlayerCardType(seat)

		self.ui_cardTypeBG[seat] = display.newSprite(gameScene.WRNN_Const.PATH.IMG_CARD_TYPE_BG)
		self.ui_cardType[seat] = display.newSprite(gameScene.WRNN_Const.PATH.TX_CARD_TYPE_NO)
		self.ui_cardTypeBG[seat]:setLocalZOrder(200)
		self.ui_cardType[seat]:setLocalZOrder(200)
		self.ui_cardTypeBG[seat]:hide()
		self.ui_cardType[seat]:hide()


		if seat == 1 then
			self.ui_cardTypeBG[seat]:pos(sendCardPos[seat][1]+240,sendCardPos[seat][2]-41)
			self.ui_cardType[seat]:pos(sendCardPos[seat][1]+240,sendCardPos[seat][2]-41)
		else
			self.ui_cardTypeBG[seat]:pos(sendCardPos[seat][1]+70,sendCardPos[seat][2]-23)
			self.ui_cardType[seat]:pos(sendCardPos[seat][1]+70,sendCardPos[seat][2]-23)
		end

		self.ui_cardTypeBG[seat]:addTo(gameScene.root)
		self.ui_cardType[seat]:addTo(gameScene.root)

end
--[[
	* 设置牌型
	* @param number seat 椅子号
	* @param number cardType 牌型
	* @param table cards 5张牌信息
--]]
function WRNN_CardMgr:setGamePlayerCardType(seat,cardType,cards)

	local spriteFrame = display.newSprite(gameScene.WRNN_Const.PATH["TX_CARD_TYPE_" .. cardType])
	self.ui_cardType[seat]:setSpriteFrame(spriteFrame:getSpriteFrame())
	self.ui_cardTypeBG[seat]:show()
	self.ui_cardType[seat]:show()
	--性别
	local soundName = ""
	if gameScene.WRNN_PlayerMgr:getPlayerInfoWithSeatID(seat):getSex() == 1 then  -- 女
		soundName = "WRNN_SOUND_FEMALE_NIU_"
	else
		soundName = "WRNN_SOUND_MALE_NIU_"
	end
	gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath[soundName .. cardType])
	--显示牌
	if seat ~= 1 then
		for index,cardInfo in pairs(cards) do
			if self.ui_cards[seat] then
				self.ui_cards[seat][index]:showFront(cardInfo)
			end
		end
	end
	
    
end

function WRNN_CardMgr:setGamePlayerCardType2(seat,cardType,cards)

    if  not cardType  or cardType == "" then
       return 
    end
    print("cardType")
    print(cardType)

    local  cardType = gameScene.WRNN_Util.getIndexByStringCardStyle(cardType)
	local spriteFrame = display.newSprite(gameScene.WRNN_Const.PATH["TX_CARD_TYPE_" .. cardType])
	self.ui_cardType[seat]:setSpriteFrame(spriteFrame:getSpriteFrame())
	self.ui_cardTypeBG[seat]:show()
	self.ui_cardType[seat]:show()
	-- --性别
	-- local soundName = ""
	-- if gameScene.WRNN_PlayerMgr:getPlayerInfoWithSeatID(seat):getSex() == 1 then  -- 女
	-- 	soundName = "WRNN_SOUND_FEMALE_NIU_"
	-- else
	-- 	soundName = "WRNN_SOUND_MALE_NIU_"
	-- end
	-- gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath[soundName .. cardType])
	--显示牌
	--if seat ~= 1 then
		for index,cardInfo in pairs(cards) do
			if self.ui_cards[seat] then
				self.ui_cards[seat][index]:showFront(cardInfo)
			end
		end
	--end
  
end
--[[
	* 清理数据
--]]
function WRNN_CardMgr:clearAllCardInfo()

	print("清理牌的数据")
	for _,ui_cards in pairs(self.ui_cards) do
		for _,ui_card in pairs(ui_cards) do
			ui_card:removeFromParent()
		end
	end

	self.ui_cards = {}

	for _,ui_cardType in pairs(self.ui_cardType) do
		ui_cardType:removeFromParent()
	end

	self.ui_cardType = {}

	for _,ui_cardTypeBG in pairs(self.ui_cardTypeBG) do
		ui_cardTypeBG:removeFromParent()
	end

	self.ui_cardTypeBG = {}
end



--搓牌后恢复牌的位置
function WRNN_CardMgr:resetSelfCardsPos()
    local cards = self.ui_cards[1]
    for i=1,#cards do
       local c  = cards[i]
       c:setAnchorPoint(0.5,0.5)
       c:setScale(0.84)
       c:setLocalZOrder(50)
       c:setRotation(0)
	   CARD_WIDTH_DISTANCE = 98
       c:pos(sendCardPos[1][1] - 80 + i * CARD_WIDTH_DISTANCE,sendCardPos[1][2])
    end
end
--牌排序后亮牌
function WRNN_CardMgr:resetSelfCardsPosByniu(temp)
    local cards = self.ui_cards[1]             
                local index =1
                for i=1,#cards do
			        local c  = cards[i]
			        c:setAnchorPoint(0.5,0.5)
			        c:setScale(0.84)
			        c:setLocalZOrder(50)
				    CARD_WIDTH_DISTANCE = 98*0.6

                    local  find  = false
                    for k=#temp,1,-1 do	              	
					    local v = temp[k]
						if c.cardinfo == v then								 	   			     	   
						   c:pos(sendCardPos[1][1] + (2+k) * CARD_WIDTH_DISTANCE +20,sendCardPos[1][2])	
						   find = true
						   c:setLocalZOrder(53+k)					                             
                           break
						end		      			            	
                    end
                    if not find then
                    	c:pos(sendCardPos[1][1] + index * CARD_WIDTH_DISTANCE,sendCardPos[1][2])
                    	index =index + 1
                    	c:setLocalZOrder(50+index)
                    end                             			    	    
                end
end
--亮牌后其他牌的位置变化
function WRNN_CardMgr:resetSelfCardsPosByOther()
    local cards = self.ui_cards[1]             
                local index =1
                for i=1,#cards do
			        local c  = cards[i]
			        c:setAnchorPoint(0.5,0.5)
			        c:setScale(0.84)
			        c:setLocalZOrder(50)
				    CARD_WIDTH_DISTANCE = 98*0.6

                    c:pos(sendCardPos[1][1]+50 + index * CARD_WIDTH_DISTANCE+20,sendCardPos[1][2])
                    index =index + 1
                    c:setLocalZOrder(50+index)                                               			    	    
                end
end

--显示牌
function WRNN_CardMgr:showSelfCards()
    local cards = self.ui_cards[1]
    for i=1,#cards do
       local c  = cards[i]
       c:showFront()
    end
end









return WRNN_CardMgr