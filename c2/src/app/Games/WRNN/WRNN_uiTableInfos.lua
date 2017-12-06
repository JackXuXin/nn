--
-- Author: peter
-- Date: 2017-04-21 13:55:24
--
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local gameScene = nil

local WRNN_uiTableInfos = {}

function WRNN_uiTableInfos:init(scene)
	gameScene = scene
    
    --[[
	--等待其他玩家准备
	self.k_nd_DengDai = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_nd_DengDai")
	self:showWaitState(true)

	--提示信息
	self.k_tx_prompt_info_1 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_tx_prompt_info_1")
	self.k_tx_prompt_info_1:setString("")
	self.k_tx_prompt_info_1:setLocalZOrder(10)

	self.k_tx_prompt_info_2 = cc.uiloader:seekNodeByNameFast(gameScene.root, "k_tx_prompt_info_2")
	self.k_tx_prompt_info_2:setString("")
	self.k_tx_prompt_info_2:setLocalZOrder(10)
    --]]
    self.TableTipNode =cc.uiloader:seekNodeByNameFast(gameScene.root, "TableTipNode")
    self.TableTipNode:setLocalZOrder(2000-1)
    self.TablenfoTipText = cc.uiloader:seekNodeByNameFast(gameScene.root, "TablenfoTipText")
    self.TablenfoTimeText = cc.uiloader:seekNodeByNameFast(gameScene.root, "TablenfoTimeText")
    self.TablenfoTimeText:hide()



end

function WRNN_uiTableInfos:clear()
end

--[[
	* 显示等待其他玩家准备
	* @param boolean flag  显示状态
--]]
function WRNN_uiTableInfos:showWaitState(flag)
	-- if flag then
	-- 	--先隐藏3个点
	-- 	for i=1,3 do
	-- 		cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. i):setVisible(false)
	-- 	end

	-- 	--执行点点点动画
	-- 	local count = 0
	-- 	self.k_nd_DengDai:schedule(
	-- 		function()
	-- 			count = count + 1
	-- 			if count > 3 then
	-- 				for i=1,3 do
	-- 					cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. i):setVisible(false)
	-- 				end
	-- 				count = 0
	-- 				return
	-- 			end

	-- 			cc.uiloader:seekNodeByName(self.k_nd_DengDai, "k_tx_DengDai_0" .. count):setVisible(true)

	-- 		end,0.4)
	-- else
	-- 	self.k_nd_DengDai:stopAllActions()
	-- end

	-- self.k_nd_DengDai:setVisible(flag)
	self.TableTipNode:setVisible(flag)
end

--[[
	* 显示提示信息
	* @param string info 信息
	* @param boolean isPlay 是否执行渐隐动画
--]]
function WRNN_uiTableInfos:showPromptInfo_1(info)
	-- info = info or ""

	-- self.k_tx_prompt_info_1:setString(info)
end

function WRNN_uiTableInfos:showPromptInfo_2(info)
	-- info = info or ""

	-- if info ~= "" then
	-- 	transition.stopTarget(self.k_tx_prompt_info_2)
	-- 	self.k_tx_prompt_info_2:setOpacity(255)
	-- 	transition.fadeOut(self.k_tx_prompt_info_2,{time = 1.5})
	-- end

	-- self.k_tx_prompt_info_2:setString(info)
end

function WRNN_uiTableInfos:showPromptInfo_3(info)
	-- info = info or ""

	-- if info ~= "" then
	-- 	transition.stopTarget(self.k_tx_prompt_info_2)
	-- 	self.k_tx_prompt_info_2:setOpacity(255)
	-- 	self.k_tx_prompt_info_2:runAction(cca.seq({cca.delay(0.8),cca.fadeOut(1)}))
	-- end

	-- self.k_tx_prompt_info_2:setString(info)
end

function WRNN_uiTableInfos:setTipInfo(info)
	     self.TableTipNode:setVisible(true)
         self.TablenfoTipText:show()
         self.TablenfoTipText:setString(info)
end
function WRNN_uiTableInfos:startTimer(time)
     
         if time <=0 then
         	return 
         end
         self.TablenfoTimeText:show()
         self.TablenfoTimeText:setString(""..time) 
         self.TablenfoTimeText:stopAllActions()      
          --定时器
         local countDown = time
         self.TablenfoTimeText:schedule(function()
    	     countDown = countDown - 1
    	     self.TablenfoTimeText:setString(""..countDown)  

              if countDown <= 3 then
              	  gameScene.WRNN_Audio.playSoundWithPath(gameScene.WRNN_Audio.preloadResPath.WRNN_SOUND_countdown)              	
              end
		      if countDown == 0 then
		    	self.TablenfoTimeText:stopAllActions()
		    	self.TablenfoTimeText:hide()
		    	self.TableTipNode:setVisible(false)
		      end
    end,1.0)



end
function WRNN_uiTableInfos:closeTipInfo()
         self.TablenfoTipText:hide()        
end
function WRNN_uiTableInfos:closeTimeInfo()
         self.TablenfoTimeText:hide() 
         self.TablenfoTimeText:stopAllActions()              
end
function WRNN_uiTableInfos:closeTip()
	self.TablenfoTimeText:stopAllActions()      
    self.TableTipNode:setVisible(false)

end

return WRNN_uiTableInfos