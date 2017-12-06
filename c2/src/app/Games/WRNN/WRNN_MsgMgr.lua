--
-- Author: peter
-- Date: 2017-04-20 13:53:18
--
local scheduler = require("framework.scheduler")
local errorLayer = require("app.layers.ErrorLayer")
local gameScene = nil
local session = 0    --数据校验

local roomMsg = {}
local wrnnMsg = {}

local handlers = {room=roomMsg, WRNN=wrnnMsg}

local WRNN_MsgMgr = {}

function WRNN_MsgMgr:init(scene)
	gameScene = scene
end

function WRNN_MsgMgr:clear()

end

-- ------------------------------ 五人牛牛消息 回复------------------------------


function wrnnMsg.Start(msg)
         gameScene.roominfo.curRoomRound = msg.ref or 0
         gameScene.WRNN_uiOperates:setCurrentRound(""..gameScene.roominfo.curRoomRound)
end
--允许抢庄
function wrnnMsg.AllowRunFor(msg)--RushBankerNotify(msg)
	print("开始抢庄")
   

	--如果没有旁观恢复参与游戏状态
	if not gameScene.watching then
		gameScene.status = 0
	else

		print("AllowRunFor")
		--清理庄家标签
		gameScene.WRNN_PlayerMgr:showBankerMark(gameScene.bankerSeat,nil,false)
       
	end

    

    if gameScene.roominfo.banker_type == 4 then  --明牌抢庄
        
         gameScene.WRNN_PlayerMgr:showBankerMark(gameScene.bankerSeat,nil,false)

    else
   	
		  --清除桌面的的牌
		  gameScene.WRNN_CardMgr:clearAllCardInfo()

		  gameScene.WRNN_uiPlayerInfos:hideAllBetNum()
		  gameScene.WRNN_uiPlayerInfos:closeAllResultNum()
		   --隐藏下庄按钮
		  gameScene.WRNN_uiOperates:setOverBankerBtn(false)   	
   end
    
	--显示抢庄按钮
	gameScene.WRNN_uiOperates:showOperates_01(true)
    --清除抢庄文字
    gameScene.WRNN_PlayerMgr:clearRobBankerState()
	--隐藏等待其他玩家 
	gameScene.WRNN_uiTableInfos:showWaitState(false)
	--隐藏准备标示
	gameScene.WRNN_uiPlayerInfos:hideAllPlayerReadyMark()
	gameScene.WRNN_uiTableInfos:setTipInfo("请操作抢庄：")
	gameScene.WRNN_uiTableInfos:startTimer(msg.time)

end
--抢庄
function wrnnMsg.RunFor(msg)--RushBankerRep(msg)
	msg.seatid = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat)

	if msg.select then
		print("玩家" .. msg.seatid .. "发起了抢庄")
	else 
		print("玩家" .. msg.seatid .. "发起了不抢庄")
	end

	--隐藏抢庄按钮
	if msg.seatid == 1  then
		gameScene.WRNN_uiOperates:showOperates_01(false)
		gameScene.WRNN_uiTableInfos:setTipInfo("等待其他人操作抢庄：")
	   
	end

	--显示抢庄状态 抢庄 不抢
	gameScene.WRNN_PlayerMgr:showRobBankerState(msg.seatid,msg.select)

	--关闭倒计时
	gameScene.WRNN_PlayerMgr:showPlayerTimer(msg.seatid, 0)
end

function wrnnMsg.AllowBet(msg)--BetBegin(msg)



--	dump(msg,"AllowBet")
    gameScene.WRNN_uiPlayerInfos:hideAllPlayerReadyMark()
    gameScene.WRNN_uiPlayerInfos:hideAllBetNum()
    --设置下注按钮数字
    gameScene.WRNN_uiOperates:setBetButton(msg.bets)

   
   if gameScene.roominfo.banker_type == 1 then  --通比牛牛
   	
        gameScene.bankerSeat = nil
            --庄家标志重置
            for k,v in ipairs(gameScene.WRNN_PlayerMgr.playerInfos)  do
            	print(k)
            	v:setBankerIdentity(false)
            end

                if not gameScene.watching then							
							gameScene.WRNN_uiOperates:showOperates_02(true)																
							gameScene.WRNN_uiTableInfos:setTipInfo("请下注：")
							gameScene.WRNN_uiTableInfos:startTimer(msg.time)

			    else
					gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_01)
				end
				--显示下注背景 数字
              --  gameScene.WRNN_uiPlayerInfos:showBetNum()
   end


    if gameScene.roominfo.banker_type == 2  then --固定庄家模式  
    	  gameScene.bankerSeat = gameScene.WRNN_Util.convertSeatToPlayer(msg.banker)
            --庄家标志重置
            for k,v in ipairs(gameScene.WRNN_PlayerMgr.playerInfos)  do
            	print(k)
            	v:setBankerIdentity(false)
            end
            --显示庄家标签
			gameScene.WRNN_PlayerMgr:showBankerMark(gameScene.bankerSeat,nil,true)

	        gameScene.WRNN_PlayerMgr.playerInfos[gameScene.bankerSeat]:setBankerIdentity(true)
                if not gameScene.watching then
						if not gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then							
							gameScene.WRNN_uiOperates:showOperates_02(true)																
							gameScene.WRNN_uiTableInfos:setTipInfo("请下注：")
							gameScene.WRNN_uiTableInfos:startTimer(msg.time)

						else
							
							gameScene.WRNN_uiTableInfos:setTipInfo("请等待闲家下注")
							gameScene.WRNN_uiTableInfos:startTimer(msg.time)
						end

			    else
					gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_01)
				end
				--显示下注背景 数字
               -- gameScene.WRNN_uiPlayerInfos:showBetNum()
    end


   if  gameScene.roominfo.banker_type  == 3 or gameScene.roominfo.banker_type == 4 then  -- 自由抢庄模式 或者是  明牌抢庄
   	                
   	                print("banker_seat "..msg.banker)
					--本局最大下注数
	
					--隐藏抢庄按钮
					gameScene.WRNN_uiOperates:showOperates_01(false)
                    
                    --庄家标志重置
                    for k,v in ipairs(gameScene.WRNN_PlayerMgr.playerInfos)  do
                    	print(k)
                    	v:setBankerIdentity(false)
                    end
       
					--设置庄家
					gameScene.bankerSeat = gameScene.WRNN_Util.convertSeatToPlayer(msg.banker)
					gameScene.WRNN_PlayerMgr.playerInfos[gameScene.bankerSeat]:setBankerIdentity(true)

					

					--随机效果显示庄家
					local randBankerBG = nil
					local index = 0
					local seat = 0

					local count = 0
					gameScene.root:schedule(function()
						if randBankerBG then
							randBankerBG:removeFromParent()
							randBankerBG = nil
						end
						local randNum = 0
						repeat
				   			randNum = math.random(1,#msg.run_fors)
						until index ~= randNum
						index = randNum

						seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.run_fors[index])

						local ui_body = gameScene.WRNN_uiPlayerInfos.ui_infos[seat].ui_body
						
						randBankerBG = display.newSprite(gameScene.WRNN_Const.PATH.IMG_HEIGHT_BANKER_BG,-6,-4)
						randBankerBG:setAnchorPoint(0,0)
						randBankerBG:setScale(0.85,0.9)

						count = count + 1
						if count >= #msg.run_fors * 6 or #msg.run_fors <= 1 then
							--最后一次给庄家
							gameScene.root:stopAllActions()
							
							ui_body = gameScene.WRNN_uiPlayerInfos.ui_infos[gameScene.bankerSeat].ui_body
							-- if gameScene.bankerSeat == 1 then
							-- 	randBankerBG = display.newSprite(gameScene.WRNN_Const.PATH.IMG_WIDTH_BANKER_BG,129,60):addTo(ui_body)
							-- else
							-- 	randBankerBG = display.newSprite(gameScene.WRNN_Const.PATH.IMG_HEIGHT_BANKER_BG,129,60):addTo(ui_body)
							-- 	randBankerBG:setScaleX(0.9)
							-- end
						     randBankerBG = display.newSprite(gameScene.WRNN_Const.PATH.IMG_HEIGHT_BANKER_BG,-6,-4)
						     randBankerBG:setAnchorPoint(0,0)
						     randBankerBG:setScale(0.85,0.9)
						     randBankerBG:addTo(ui_body)

							 randBankerBG:runAction(cca.seq({cca.delay(0.1),cca.removeSelf()}))

							--显示庄家标签
							gameScene.WRNN_PlayerMgr:showBankerMark(gameScene.bankerSeat,msg.bei,true)
							-- --清理抢庄状态文字
					 		gameScene.WRNN_PlayerMgr:clearRobBankerState()

							--显示下注倒计时
							--gameScene.WRNN_PlayerMgr:showPlayerTimer(1,msg.time)

							--如果不是庄家显示下注按钮 and 显示提示文字
							if not gameScene.watching then
								if not gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then
								    print("不是庄家")									
									gameScene.WRNN_uiOperates:showOperates_02(true)
									--gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_02)
									gameScene.WRNN_uiTableInfos:setTipInfo("请下注：")
									gameScene.WRNN_uiTableInfos:startTimer(msg.time)

								else
									--gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_01)
									gameScene.WRNN_uiTableInfos:setTipInfo("请等待闲家下注")
									gameScene.WRNN_uiTableInfos:startTimer(msg.time)
									print("是庄家")	
								end

							else
								gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_01)
							end

							--gameScene.WRNN_uiPlayerInfos:showBetNum()
							return 
						end

						randBankerBG:addTo(ui_body)

					 end,0.1)

    end

end

function wrnnMsg.Deal(msg)
	print("开始发牌")
	gameScene.OpenCardState = false
	--隐藏下注按钮
	gameScene.WRNN_uiOperates:showOperates_02(false)

    --清理抢庄状态文字
    gameScene.WRNN_PlayerMgr:clearRobBankerState()

    if gameScene.roominfo.banker_type == 1 then --通比牛牛
    		--隐藏准备标示
	    gameScene.WRNN_uiPlayerInfos:hideAllPlayerReadyMark()
    end

    local d_time = 0.5
    if gameScene.roominfo.banker_type  == 4 then
    	d_time= 0.01
    	if gameScene.SendCardTimes >=2 then
    		gameScene.SendCardTimes =0
    	end
    	gameScene.SendCardTimes = gameScene.SendCardTimes + 1
    end


    if gameScene.SendCardTimes > 1 then 	
       --补上最后一张牌
        local time ,cards
        for i=1,#msg.players do   
	          	 local seat = msg.players[i].seat                  	         
	             if seat ==  gameScene.seatIndex then --本人
	             	cards = msg.players[i].cards
	             	dump(cards)
	             	time = msg.players[i].time
	             end
	    end 

       local cardInfo = cards[5]
       local num,color = gameScene.WRNN_Util.getCardNumAndColor(cardInfo)
       local cards_sprite = gameScene.WRNN_CardMgr.ui_cards[1][5]
       cards_sprite:setValue(cardInfo)
       --显示翻牌按钮
		gameScene.WRNN_uiOperates:setCuopaiButtonVisable(true)
		gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)
        gameScene.WRNN_uiTableInfos:setTipInfo("查看手牌：")
        gameScene.WRNN_uiTableInfos:startTimer(time)
      
    else
         --清除上次的牌        
         --清除桌面的的牌
		  gameScene.WRNN_CardMgr:clearAllCardInfo()
 
        if gameScene.roominfo.banker_type  == 4 then
		   gameScene.WRNN_uiPlayerInfos:hideAllBetNum()
		end

 
		  gameScene.WRNN_uiPlayerInfos:closeAllResultNum()
		   --隐藏下庄按钮
		  gameScene.WRNN_uiOperates:setOverBankerBtn(false)




	       --延时0.5秒发牌
	    local delaytime = cc.DelayTime:create(d_time)
	    local callback = cc.CallFunc:create(function()
	  		  local seats = {} 
	  		  local cards 
	  		  local time  
	          for i=1,#msg.players do   
	          	 local seat = msg.players[i].seat                  	
	           	 seats[i] = seat
	             if seat ==  gameScene.seatIndex then --本人
	             	cards = msg.players[i].cards
	             	time = msg.players[i].time
	             end
	          end 
	    	  --发牌
			  gameScene.WRNN_CardMgr:sendPlayerCard(seats, cards,time)
			  --隐藏提示
			  gameScene.WRNN_uiTableInfos:closeTip()
			 
	    end)
	    local action = cc.Sequence:create(delaytime,callback)
	    transition.execute(gameScene, action)
    end
    
	
end

function wrnnMsg.Bet(msg)

	msg.seatid = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat)

	if msg.seatid == 1  then
		gameScene.WRNN_uiOperates:showOperates_02(false)
	end
	print("玩家" .. msg.seatid .. "成功的下注了 <<<" .. msg.bet .. ">>> 个筹码")
    local function callback()
    	  --显示筹码
		gameScene.WRNN_PlayerMgr:showPlayerBetNum(msg.seatid,true,msg.bet)
		
		--刷新下注数
	 	--gameScene.WRNN_uiPlayerInfos:updatePlayerBetUI(msg.seatid,msg.bet)
	 	--刷新金币数
	 	local playerinfo = gameScene.WRNN_PlayerMgr:getPlayerInfoWithSeatID(msg.seatid)
	 	local gold = playerinfo:getGold()
	 	playerinfo:setGold(gold - msg.bet)
	 	gameScene.WRNN_uiPlayerInfos:udpatePlayerGoldUI(msg.seatid,gold - msg.bet )  	 	
    end
 	
    --金币动画
   local from_pos , to_pos = gameScene.WRNN_uiPlayerInfos:getGoldPos(msg.seatid)
   gameScene.WRNN_Util.showGoldAnimation(gameScene,msg.bet,from_pos,to_pos,callback)


end
--提示牌型回复
function wrnnMsg.Spy(msg)
        local cards_sprite = gameScene.WRNN_CardMgr.ui_cards[1]
        local  style = gameScene.WRNN_Util.getIndexByStringCardStyle(msg.style)
      --  print("提示牌型回复  "..msg.style.."/"..style)  
        if style ~= 0 then  --有牛 
            if style <= 9 then --牛一到牛9  位置重新排列下
	        	for i=1,#cards_sprite do
	        		local cardinfo = msg.cards[i]
	        		cards_sprite[i]:showFront(cardinfo)
	        		if i <=3 then
	        		  cards_sprite[i]:setPositionY(100+20)
	        	    end	        	
	        			       	 
	        	end
            end 
        end  
       gameScene.WRNN_CardMgr:setGamePlayerCardType(1,style)
end
--结算
function wrnnMsg.EndGame(msg)--BetResult(msg)

    	--更新回合数据
   

    local banker_seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.banker)
    local banker_pos = gameScene.WRNN_uiPlayerInfos:getHeadIconPos(banker_seat)
    local banker_score =0
    
    gameScene.WRNN_uiTableInfos:setTipInfo("开始比牌")
    gameScene.WRNN_uiTableInfos:closeTimeInfo()
    local index = 0
    for i=1,#msg.players do
    	local score = tonumber(msg.players[i].score)  
        local seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.players[i].seat)
        index = index+1  
        if seat ~= banker_seat then
        	    local function callback()	        	  
	                gameScene.WRNN_uiPlayerInfos:setResultNum(seat,score)
                    if index == #msg.players then
                        --显示庄家分数
                        gameScene.WRNN_uiPlayerInfos:setResultNum(banker_seat,banker_score)
                     
                        --下一回合 TODO
                        if gameScene.roominfo.curRoomRound < gameScene.roominfo.gameround then
                                                        
	                             -- if gameScene.ReConnectState == true and gameScene.ReadyState == true then	                                
	                             -- 	gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(false)
	                             -- 	print("-------------离线重连-------设置准备按钮--------false---")
	                             -- else
	                             	gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(true)
	                             -- end

                            if msg.dismiss == 1 then  -- 1表示庄家可以下庄
                               if gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then
                               	  gameScene.WRNN_uiOperates:setOverBankerBtn(true)
                               end
                            end                           
                        	gameScene.WRNN_uiTableInfos:setTipInfo("请准备")
    						--gameScene.WRNN_uiTableInfos:startTimer(10)
                        else
                            --房局结束 查看战绩 或者返回 大厅
					       -- gameScene.WRNN_uiOperates:setRecordBtnViable(true)
					        gameScene.WRNN_uiTableInfos:closeTip()
                        end
                                           
                    end

        		end
        	    local pos =  gameScene.WRNN_uiPlayerInfos:getHeadIconPos(seat)
	            if score < 0 then
	               gameScene.WRNN_Util.showGoldAnimation(gameScene,math.abs(score),pos,banker_pos,callback)
	            else	              
                    gameScene.WRNN_Util.showGoldAnimation(gameScene,math.abs(score),banker_pos,pos,callback)
	            end
	    else   	
	    	banker_score = score
	    	
        end 

    end

end




--场景恢复
function wrnnMsg.RushScence(msg)
	print("恢复抢庄场景",msg.time)

	gameScene.status = msg.status

	gameScene.WRNN_uiOperates:showStartReady(false)
	gameScene.WRNN_uiTableInfos:showWaitState(false)

	--恢复抢庄状态
	for _,v in pairs(msg.playerOperates) do
		local seat = gameScene.WRNN_Util.convertSeatToPlayer(v.seatid)

		if seat == 1 and  v.operate == 0 then
			--恢复抢庄按钮
			gameScene.WRNN_uiOperates:showOperates_01(true)
		end

		if v.operate  then   --抢庄
			gameScene.WRNN_PlayerMgr:showRobBankerState(seat,v.operate)
		else  --没操作
			gameScene.WRNN_PlayerMgr:showPlayerTimer(seat, msg.time)
		end
	end
end
-- // 游戏信息. 断线重进之后
-- message GameInfo {

-- 	message Player {
-- 		required int32 seat = 1;
-- 		repeated int32 cards = 2;	// 手牌
-- 		optional int32 run_for = 3;	// 抢庄 0表示还未选择, 1表示抢, 2表示不抢
-- 		optional int32 bet = 4;		// 下注
-- 		optional string style = 5;	// 玩家已开牌才有牌型
-- 	}
	
-- 	required int32 session = 1;
-- 	required string stage = 2;	// wait_run_for, wait_bet, wait_open, wait_ready
-- 	repeated Player players = 3;
-- 	optional int32 banker = 4;
-- 	optional int32 time = 5;
-- }
function wrnnMsg.GameInfo(msg)
	print("游戏信息. 断线重进之后")
	dump(msg," 游戏信息. 断线重进之后")

    
   if gameScene.ReadyState == true then
   	  gameScene.ReConnectState = true
   end

   gameScene.roominfo.curRoomRound = msg.ref or 0
   gameScene.WRNN_uiOperates:setCurrentRound(""..gameScene.roominfo.curRoomRound)
   gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(false)
    --隐藏房间号复制按钮
   gameScene.WRNN_uiOperates:setRoomIdBtnVisible(false)
   gameScene.stage = msg.stage

   
    --清除上次的牌        
	gameScene.WRNN_CardMgr:clearAllCardInfo()
    if gameScene.roominfo.banker_type  == 4 then
	   gameScene.WRNN_uiPlayerInfos:hideAllBetNum()
	end
	gameScene.WRNN_uiPlayerInfos:closeAllResultNum()
	   --隐藏下庄按钮
	gameScene.WRNN_uiOperates:setOverBankerBtn(false)
    gameScene.WRNN_uiOperates:setCuopaiButtonVisable(false)
	gameScene.WRNN_uiOperates:setCardShowButtonVisable(false)















	--恢复庄家 不是等待抢庄
	if gameScene.stage ~= "wait_run_for"  and msg.banker and msg.banker ~=0 then

         if gameScene.roominfo.banker_type ~= 1 then  --通比牛牛
                local baker_seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.banker)
				gameScene.WRNN_PlayerMgr:showBankerMark(baker_seat,msg.bei,true)
				if gameScene.WRNN_PlayerMgr.playerInfos[baker_seat] then
				   gameScene.WRNN_PlayerMgr.playerInfos[baker_seat]:setBankerIdentity(true)
				end
         end

	
	end
	if gameScene.stage == "wait_run_for" then

	      if not msg.banker or msg.banker == 0 then
	      	--显示抢庄按钮
			gameScene.WRNN_uiOperates:showOperates_01(true)
			--隐藏等待其他玩家 
			gameScene.WRNN_uiTableInfos:showWaitState(false)
			--隐藏准备标示
			gameScene.WRNN_uiPlayerInfos:hideAllPlayerReadyMark()
			gameScene.WRNN_uiTableInfos:setTipInfo("请操作抢庄：")
			gameScene.WRNN_uiTableInfos:startTimer(msg.time)

	      end	
          if gameScene.roominfo.banker_type == 4 then  --明牌抢庄
             --恢复牌
              gameScene.SendCardTimes = gameScene.SendCardTimes + 1
              for i=1,#msg.players do   
		        local seat = msg.players[i].seat                  		       	
		        local local_seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)		
				gameScene.WRNN_CardMgr:sendPlayerCard3(seat, msg.players[i].cards ,msg.players[i].style)      
		      end

          
          end



	end
	
	--文字信息
	if baker_seat ~= 1 then
		gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_02)
	else	
		gameScene.WRNN_uiTableInfos:showPromptInfo_1(gameScene.WRNN_Const.Game_INFO_01)
	end

	--恢复下注 (如果还没有发牌 and 如果不是庄家)
	if gameScene.stage == "wait_bet" and  baker_seat ~= 1 then
		-- gameScene.WRNN_uiPlayerInfos:showBetNum()
		-- gameScene.WRNN_uiOperates:showOperates_02(true)
	end
   
    if gameScene.stage == "wait_ready"  then  -- 1表示庄家可以下庄
         for i=1,#msg.players do   
	      	 local seat = msg.players[i].seat                  		     
	         if seat ==  gameScene.seatIndex then --本人


                  --  gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(true)
	         	
	         	    if msg.players[i].dismiss and msg.players[i].dismiss == 1 then
	         	    	if gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then
					       	 gameScene.WRNN_uiOperates:setOverBankerBtn(true)
					    end
	         	    end	         
	         end	      
	      end
          --处理等待结果的显示各个玩家的牌
          if gameScene.roominfo.curRoomRound > 0 then
          	  gameScene.WRNN_uiPlayerInfos:showBetNum()		  
		      for i=1,#msg.players do   
		        local seat = msg.players[i].seat                  		       	
		        local local_seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)
		        --恢复下注数据
				gameScene.WRNN_uiPlayerInfos:updatePlayerBetUI_2(msg.banker,local_seat,msg.players[i].bet)  
				gameScene.WRNN_CardMgr:sendPlayerCard2(seat, msg.players[i].cards ,msg.players[i].style)      
		      end
          end



    end  

	  --恢复牌
    if gameScene.stage == "wait_open"  then         
          print("------恢复场景之恢复牌------")	
	      gameScene.WRNN_uiPlayerInfos:showBetNum()	


	      for i=1,#msg.players do   
	        local seat = msg.players[i].seat                  		       	
	        local local_seat = gameScene.WRNN_Util.convertSeatToPlayer(seat)
	        --恢复下注数据
			gameScene.WRNN_uiPlayerInfos:updatePlayerBetUI_2(msg.banker,local_seat,msg.players[i].bet)  
			gameScene.WRNN_CardMgr:sendPlayerCard2(seat, msg.players[i].cards ,msg.players[i].style)      
	      end

          
	 end
    
     	
end

--旁观用户结算刷新金币数据
function wrnnMsg.NotifyGoldToWatcher(msg)
	--print("刷新金币数据")

	for _,info in pairs(msg.playerGolds) do
		local seatid = gameScene.WRNN_Util.convertSeatToPlayer(info.seatid)

		if gameScene.watching then
			gameScene.WRNN_PlayerMgr:getPlayerInfoWithSeatID(seatid):setGold(info.gold)
			gameScene.WRNN_uiPlayerInfos:udpatePlayerGoldUI(seatid,info.gold)
		end
	end
end

--可以开始游戏
function wrnnMsg.CanBeginGameNotify(msg)
	    -- print("------CanBeginGameNotify------")
	     gameScene.WRNN_uiOperates:setStartGameBtnEnable(true,true) 
end

--亮牌操作
function wrnnMsg.Open(msg)

	--dump(msg,"开牌")
     
     local seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat) 
     local  style = gameScene.WRNN_Util.getIndexByStringCardStyle(msg.style)
     print("style   "..style)
     if seat == 1 then --本人
     	 gameScene.WRNN_uiOperates:setCardShowButtonVisable(false) -- 隐藏亮牌按钮
     	 gameScene.WRNN_uiOperates:setCuopaiButtonVisable(false)   -- 隐藏搓牌按钮
     	 gameScene.WRNN_uiOperates:CuoPaiLayerCloseShutDown()      -- 关闭搓牌界面         

     	        local cards_sprite = gameScene.WRNN_CardMgr.ui_cards[1] 
        		for i=1,#cards_sprite do
	        		local cardinfo = msg.cards[i]
	        		--print("cardinfo="..cardinfo)
	        		cards_sprite[i]:showFront(cardinfo)	        		    		        			       	 
	        	end
     	 	gameScene.WRNN_CardMgr:resetSelfCardsPosByOther()   	
     	 -- end
     end
     gameScene.WRNN_CardMgr:setGamePlayerCardType(seat,style,msg.cards) 
     --隐藏算牌中 动画
     gameScene.WRNN_uiPlayerInfos:showThinkCardAnimation(seat,false)
     if seat == 1 then
     	gameScene.WRNN_uiTableInfos:setTipInfo("请等待其他玩家摊牌：")
     	gameScene.OpenCardState = true
     end

    
        
end


--查询上局回顾回复
function wrnnMsg.LastReview(msg)
       
      -- dump(msg,"上局回顾")
      gameScene.WRNN_uiOperates:setLastBackLook(msg)
end
--提前下庄通知
function wrnnMsg.Dismiss(msg)
	  if not gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then
	  	  gameScene.WRNN_uiOperates:setTipLayerinfo(2,msg.time)	  	  
	  end
     
     
end

--[[房间结算]]
function wrnnMsg.EndRoom(msg)
	 
   -- dump(msg,"房间结算")
	 for i=1,#msg.players do 	
	 	local seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.players[i].seat) 
	 	local score = tonumber(msg.players[i].score)
	 	local roomer = false
	 	if msg.players[i].seat == 1 then
	 		roomer = true
	 	end
        gameScene.WRNN_uiOperates:setRecordScore(i,seat,score,roomer)
	 end
     gameScene.WRNN_uiOperates:setAutobackTime(msg.time)
     gameScene.WRNN_uiOperates:setRecordLayerVisiable(true)

     
end




-- ------------------------------ 框架消息 回复------------------------------
--[[
	* 初始化游戏
	* @param table msg  消息数据
--]]
function roomMsg.PrivateRoomEnter(msg)
	--dump(msg)
    
	
end
function roomMsg.InitPrivateRoom(msg)

  
   	gameScene.seatIndex = msg.seatid
	gameScene.tableId = msg.tableid
	gameScene.session = msg.table_session
	gameScene.room_session = msg.room_Session
	gameScene.watching = msg.watching
    gameScene.roominfo.customization = msg.customization
    gameScene.roominfo.table_code  = msg.table_code
    gameScene.roominfo.gameround = msg.gameround
    gameScene.roominfo.max_player = msg.max_player
    gameScene.roominfo.pay_type = msg.pay_type
    gameScene.game_state = msg.game_state
    --app.constant.curRoomRound = msg.curround
    gameScene.roominfo.curRoomRound = 0
    gameScene.WRNN_uiOperates:setCurrentRound(""..gameScene.roominfo.curRoomRound)

 --   --如果不是旁观
	-- if not msg.watching then
 --    	gameScene.WRNN_uiOperates:showStartReady(true) 
 --    else
 --    	--显示坐下
 --    	gameScene.WRNN_uiPlayerInfos:showSits()
 --    end

    if gameScene.seatIndex == 1 then
       gameScene.WRNN_uiOperates:setStartGameBtnEnable(true,false) 
       gameScene.WRNN_uiSettings:setDissolveBtnEnable(true)
    
    else
       gameScene.WRNN_uiTableInfos:closeTip()
    end
    --print(gameScene.roominfo.customization.."gameScene.roominfo.customization")
    gameScene.WRNN_uiOperates:showRoomInfo()

end

function roomMsg.InitGameScenes(msg)
	print("初始化游戏场景，自己的椅子号:"..msg.seat)

	gameScene.seatIndex = msg.seat
	gameScene.tableId = msg.table_id
	gameScene.session = msg.session
	gameScene.watching = msg.watching
	app.constant.curRoomRound = 0

	-- --如果不是旁观
	-- if not msg.watching then
 --    	gameScene.WRNN_uiOperates:showStartReady(true) 
 --    else
 --    	--显示坐下
 --    	gameScene.WRNN_uiPlayerInfos:showSits()
 --    end
end


function roomMsg.TableStateInfo(msg)

	--dump(msg,"桌子状态信息")

  
     gameScene.roominfo.curRoomRound = msg.round
     gameScene.WRNN_uiOperates:setCurrentRound(""..gameScene.roominfo.curRoomRound)
     gameScene.WRNN_uiOperates:setRoomIdBtnVisible(false) -- 隐藏复制房间号按钮
   
     if gameScene.roominfo.curRoomRound >= 1 then --上局回顾按钮显示
     	gameScene.WRNN_uiSettings:setReviewBtnEnable(true)
     end

    



end

--[[
	* 有玩家进入桌子
	* @param table msg  消息数据
--]]
function roomMsg.EnterGame(msg)

	msg.seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat)

	print("椅子号: " .. msg.seat .. " 的玩家进入")
	print("gameScene.game_state"..gameScene.game_state)
  --  dump(msg)
	--玩家坐下
	gameScene.WRNN_PlayerMgr:playerSeatDown(msg)


           if msg.player.ready > 0  then --已准备
                  	if  msg.seat == 1  then
                  	 gameScene.ReadyState = true
                     gameScene.WRNN_uiOperates:showStartReady(false) -- 隐藏坐下按钮 
                     gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(false)            
               		end       
                    gameScene.WRNN_uiPlayerInfos:hidePlayerReadyMark(gameScene.WRNN_Util.convertSeatToPlayer(msg.seat),true)-- 显示准备标志          
           else  -- 未准备
           	    

           	         if msg.seat == 1  then
           	         	gameScene.ReadyState = false
           	         end
                  if gameScene.game_state == 0  then
                        if  msg.seat == 1  then       
                         gameScene.WRNN_uiOperates:showStartReady(true) -- 隐藏坐下按钮
                         gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(false)          
               		    end 
               		   
                  else

                  	 if  msg.seat == 1  then
                         gameScene.WRNN_uiOperates:showStartReady(false) -- 隐藏坐下按钮
                         gameScene.WRNN_uiOperates:setNextStartReadyBtnVisible(true)
                         gameScene.WRNN_uiOperates:setInvite_friendBtn(false) --隐藏微信邀请按钮
                         
               		 end   
                  end
           end


     	   --if gameScene.seatIndex == 1  then
              gameScene.WRNN_uiSettings:setDissolveBtnEnable(true)
     	  -- end



end

--[[
	* 有玩家离开桌子
	* @param table msg  消息数据
--]]
function roomMsg.LeaveGame(msg)
	--dump(msg,"LeaveGame")




    -- if gameScene.game_state == 0 and msg.seat == gameScene.seatIndex then        
    --         errorLayer.new(app.lang.room_owner_leave, nil, nil, function()
    --            gameScene.WRNN_Message.dispatchPrivateRoom("room.LeaveGame", gameScene.WRNN_Const.REQUEST_INFO_01,gameScene)
    --         end):addTo(gameScene.root,5000)

    --     end
    msg.seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat)
	print("椅子号: " .. msg.seat .. " 的玩家离开")
	gameScene.WRNN_PlayerMgr:playerLeave(msg.seat)

end






function roomMsg.UpdateSeat(msg)

	   -- dump(msg,"更新座位跟金币")
     
        for i=1,#msg.player do       	
        	local player = msg.player[i]
        	local seat = gameScene.WRNN_Util.convertSeatToPlayer(player.seat) 
        	local gold =tonumber(player.gold)   
            gameScene.WRNN_PlayerMgr:setPlayerGold(seat,gold)
            gameScene.WRNN_uiPlayerInfos:udpatePlayerGoldUI(seat,gold)        
        end
	    if msg.finish ~=0 then  --房间结束或解散
		     for i=1,#msg.player do
	              local player = msg.player[i]
	        	  local seat = gameScene.WRNN_Util.convertSeatToPlayer(player.seat) 
	              local gold =tonumber(player.gold)
	              gameScene.WRNN_uiOperates:setRecordScore(i,seat,gold) 
		     end
		end
      

end

--[[通知某个玩家掉线]]
function roomMsg.ManagedNtf(msg)
	  --dump(msg,"ManagedNtf")
      local seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat)
      if msg.state  == 1 then
      	gameScene.WRNN_uiPlayerInfos:setLostLineVisible(seat,true)
      	gameScene.WRNN_uiPlayerInfos:hidePlayerReadyMark(seat,false)
      end
      if msg.state  == 2 then
      	gameScene.WRNN_uiPlayerInfos:setLostLineVisible(seat,false)
      	gameScene.WRNN_uiPlayerInfos:showThinkCardAnimation(seat,false)

      end
      
end

function roomMsg.PrivateStart(msg)
         gameScene.game_state = 1
end
--[[
	* 准备请求的个人回复
	* @param table msg  消息数据
--]]
function roomMsg.ReadyRep(msg)

 --    gameScene.WRNN_uiTableInfos:setTipInfo("请等待其他玩家准备")
	-- if gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then
 --      gameScene.WRNN_uiOperates:setOverBankerBtn(false) --隐藏下庄按钮
 --    end
	-- --隐藏准备按钮
	-- gameScene.WRNN_uiOperates:showStartReady(false)
	-- --TODO 开始按钮居中动画
 --    gameScene.WRNN_uiOperates:MoveStartBtnCenter()
 --     if gameScene.roominfo.curRoomRound >=1 then --上局回顾按钮显示
 --     	gameScene.WRNN_uiSettings:setReviewBtnEnable(true)
 --     end
end
function roomMsg.ChatMsg(msg)
       if gameScene.room_session == msg.session then  

             msg.fromseat=gameScene.WRNN_Util.convertSeatToPlayer(msg.fromseat)
             msg.toseat=gameScene.WRNN_Util.convertSeatToPlayer(msg.toseat)

             if msg.info.chattype == 1 then
                   gameScene:playEmotion(tonumber(msg.info.content), msg.fromseat, msg.toseat)
             end
       end
end
--[[
	* 有玩家准备游戏
	* @param table msg  消息数据
--]]
function roomMsg.Ready(msg)
	msg.seat = gameScene.WRNN_Util.convertSeatToPlayer(msg.seat)
	print("椅子号: " .. msg.seat .. " 的玩家已准备游戏")

	--显示准备标示
	gameScene.WRNN_PlayerMgr:playerReady(msg.seat,true)

    if msg.seat == 1 then --本人
		    	 gameScene.WRNN_uiTableInfos:setTipInfo("请等待其他玩家准备")
			if gameScene.WRNN_PlayerMgr.playerInfos[1]:isBankerIdentity() then
		      gameScene.WRNN_uiOperates:setOverBankerBtn(false) --隐藏下庄按钮
		    end
			--隐藏准备按钮
			gameScene.WRNN_uiOperates:showStartReady(false)
			gameScene.ReConnectState = false
			--TODO 开始按钮居中动画
		    gameScene.WRNN_uiOperates:MoveStartBtnCenter()
		     if gameScene.roominfo.curRoomRound >=1 then --上局回顾按钮显示
		     	gameScene.WRNN_uiSettings:setReviewBtnEnable(true)
		     end
    end
	




end


function WRNN_MsgMgr:dispatchMessage(name,msg)
	if msg then
		print("-------WRNN MESSAGE -----name --"..name)
        --dump(msg, name)
    else
        print("error: 调用 WRNN_MsgMgr:dispatchMessage 方法时 参数msg ~= true  name = " .. name)
    end


	local clsName, funcName = name:match "([^.]*).(.*)"
	print(clsName,funcName)
	if handlers[clsName] then
		--如果是游戏消息则校验数据
		if clsName == "WRNN" then
			if gameScene.session == msg.session then
				handlers[clsName][funcName](msg)
			end
		else
			handlers[clsName][funcName](msg)
		end

	end
end



return WRNN_MsgMgr