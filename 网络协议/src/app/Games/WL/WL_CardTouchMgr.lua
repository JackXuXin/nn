--
-- Author: peter
-- Date: 2017-03-13 17:49:21
--

local gameScene = nil

local select_UI_Card = nil

local WL_CardTouchMgr = {}

function WL_CardTouchMgr:init(scene)
	gameScene = scene

	self:setRootTouchEnabled(false)
	gameScene.root:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	gameScene.root:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.touchEventCallback))
end

function WL_CardTouchMgr:clear()
end

--[[
	* touch点击事件监听
	* @param table event  事件信息
--]]
function WL_CardTouchMgr:touchEventCallback(event)
	if event.name == "began" then
		return self:began(event)
	elseif event.name == "ended" then
		-- if not gameScene.root:isTouchEnabled() then
  --           return 
  --       end

        self:ended(event)
	end
end

--[[
	* touch按下
	* @param table event  事件信息
--]]
function WL_CardTouchMgr:began(event)
	local ui_cards = gameScene.WL_CardMgr.ui_cards

	for index=#ui_cards,1,-1 do
		if cc.rectContainsPoint(ui_cards[index].touchRect,cc.p(event.x,event.y)) then
            select_UI_Card = ui_cards[index]

            -- --点击的牌已经被选中 （直接返回）
            -- if select_UI_Card:isCardLuTou() then
            -- 	gameScene.WL_CardMgr:setPlayerAllCardSuoTou()
            -- 	gameScene.WL_uiOperates:updateEnabledState(cardInfos,{})
            -- 	return  false
            -- end

            ui_cards[index]:setColor(gameScene.WL_Const.CARD_SELECT_COLOR)
            return true
        end
	end

    gameScene.WL_CardMgr:setPlayerAllCardSuoTou()
    gameScene.WL_uiOperates:updateEnabledState()

    return false
end

--[[
	* touch弹起
	* @param table event  事件信息
--]]
function WL_CardTouchMgr:ended(event)
	if select_UI_Card:isCardLuTou() then
        gameScene.WL_CardMgr:setPlayerAllCardSuoTou()
        gameScene.WL_uiOperates:updateEnabledState(cardInfos,{})
        return
    end

	local ui_cards = gameScene.WL_CardMgr.ui_cards

	select_UI_Card:setColor(gameScene.WL_Const.CARD_RELEASE_COLOR)

	local cardInfos = gameScene.WL_CardMgr:setPlayerCardLuTou(select_UI_Card:getCardNum())

	gameScene.WL_uiOperates:updateEnabledState(cardInfos)
end

--[[
    * 设置点击触摸开启状态
    * @param boolean isEnabled  事件信息
--]]
function WL_CardTouchMgr:setRootTouchEnabled(isEnabled)
    if not isEnabled then
        gameScene.WL_CardMgr:setPlayerAllCardSuoTou()
    end

    -- if isEnabled and gameScene.SRDDZ_PlayerMgr:getPlayerInfoWithSeatID(1).mIsTuoGuan then
    --     return
    -- end

    gameScene.root:setTouchEnabled(isEnabled)
end

return WL_CardTouchMgr