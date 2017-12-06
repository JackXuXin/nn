--
-- Author: peter
-- Date: 2017-02-22 15:35:03
--

local SRDDZ_Const = require("app.Games.SRDDZ.SRDDZ_Const")
local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")

local lg = require("app.Games.SRDDZ.lg_4ddz")

local gameScene = nil

local selectCards = {}

local SRDDZ_CardTouchMsg = {}

function SRDDZ_CardTouchMsg:init(scene)
	gameScene = scene

    self.PinningCardInfo = {}

	--监听点击事件
 --   gameScene.root:setTouchEnabled(true)
	self:setRootTouchEnabled(false)
	gameScene.root:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	gameScene.root:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.touchEventCallback))
end

function SRDDZ_CardTouchMsg:clear()
    self.PinningCardInfo = {}
    selectCards = {}
end

--[[
    * 设置点击触摸开启状态
    * @param boolean isEnabled  事件信息
--]]
function SRDDZ_CardTouchMsg:setRootTouchEnabled(isEnabled)
    if not isEnabled then
        gameScene.SRDDZ_CardMgr:setPlayerCardAllSuoTou()
    end

    if isEnabled and gameScene.SRDDZ_PlayerMgr:getPlayerInfoWithSeatID(1).mIsTuoGuan then
        return
    end
    gameScene.root:setTouchEnabled(isEnabled)
end

--[[
	* touch点击事件监听
	* @param table event  事件信息
--]]
function SRDDZ_CardTouchMsg:touchEventCallback(event)
	if event.name == "began" then
		return self:began(event)
	elseif event.name == "moved" then
		if not gameScene.root:isTouchEnabled() then
            return
        end

        self:moved(event)
	else
		if not gameScene.root:isTouchEnabled() then
            return 
        end

        self:ended(event)
	end
end

--[[
	* touch按下
	* @param table event  事件信息
--]]
function SRDDZ_CardTouchMsg:began(event)
    local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
    for k,v in ipairs(ui_cards) do
        if cc.rectContainsPoint(v.m_touchRect,cc.p(event.x,event.y)) then
            table.insert(selectCards,v)
            v:setColor(SRDDZ_Const.CARD_SELECT_COLOR)
            return true
        end
    end

    gameScene.SRDDZ_CardMgr:setPlayerCardAllSuoTou()
    selectCards = {}

    if SRDDZ_Util.isChuPai then
        gameScene.SRDDZ_PlayerMgr:showPlayerChuPai(self.PinningCardInfo)
    end

    return false
end

--[[
	* touch移动
	* @param table event  事件信息
--]]
function SRDDZ_CardTouchMsg:moved(event)
		--如果当前选择的牌是最后一张 就直接返回
	if #selectCards ~= 0 then
        local back = selectCards[#selectCards]
        if cc.rectContainsPoint(back.m_touchRect,cc.p(event.x,event.y)) then
            return
        end
    end

    --找到当前选择的牌
    local card = nil
    local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
    for k,v in ipairs(ui_cards) do
        if cc.rectContainsPoint(v.m_touchRect,cc.p(event.x,event.y)) then
        	card = v
        	break
        end
    end

    --如果没有选中任何牌就直接返回
    if not card then
    	return
    end

    --判断当前选择的牌是否需要存储
    local isInsert = true
    for k,v in ipairs(selectCards) do
        if v == card then
           	isInsert = false
            break
        end
    end

    --如果需要存储
    if isInsert then
        table.insert(selectCards,card)
        card:setColor(SRDDZ_Const.CARD_SELECT_COLOR)
    end

    --获取 第一张选择的牌 与 最后一张选择的牌的 x 位置
    local x1 = selectCards[1].m_touchRect.x
    local x2 = card.m_touchRect.x
    if x1 > x2 then
        x1,x2 = x2,x1
    end

    --存储 第一张选择的牌 与 最后一张选择的牌  x 之内的牌
    local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
    for k,v in ipairs(ui_cards) do
        if v.m_touchRect.x > x1 and v.m_touchRect.x < x2 then
            isInsert = true
            for kk,vv in ipairs(selectCards) do
                if v == vv then
                    isInsert = false 
                    break
                end
            end
            if isInsert then
                table.insert(selectCards,v)
                v:setColor(SRDDZ_Const.CARD_SELECT_COLOR)
            end
        end
    end

    --释放 第一张选择的牌 与 最后一张选择的牌  x 之外的牌
    local index = 1
    while index <= #selectCards do
        if selectCards[index].m_touchRect.x < x1 or selectCards[index].m_touchRect.x > x2 then
            selectCards[index]:setColor(SRDDZ_Const.CARD_RELEASE_COLOR)
            table.remove(selectCards,index)
        else
            index = index + 1
        end
    end
end

--[[
	* touch弹起
	* @param table event  事件信息
--]]
function SRDDZ_CardTouchMsg:ended(event)
	--智能提取牌型
    if not self:ZhiNengTiQu() then
        --没找到智能提取的牌
        for k,v in ipairs(selectCards) do
            v:setColor(SRDDZ_Const.CARD_RELEASE_COLOR)
            v:setCardSelectState()
        end
    end

    gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_HIT_CARD)

    selectCards = {}

    if SRDDZ_Util.isChuPai then
        gameScene.SRDDZ_PlayerMgr:showPlayerChuPai(self.PinningCardInfo)
    end
end

--[[
    * 智能提取牌型
--]]
function SRDDZ_CardTouchMsg:ZhiNengTiQu()
    local ui_cards = gameScene.SRDDZ_uiPlayerInfos.ui_infos[1].ui_cards
    for k,v in ipairs(ui_cards) do
        if v:isCardLuTou() then
            return false
        end
    end

    local TiQuCard = {}
    for k,v in ipairs(selectCards) do
        table.insert(TiQuCard,{num = v:getCardNum(),color = v:getCardColor()})
    end

    --提取
    local cards = lg.findSequence(self.PinningCardInfo,TiQuCard)
    if cards == nil or #cards == 0 then
        dump(cards,"没有找到智能提取的牌")
        return  false
    end

    dump(cards,"智能提取的牌")
    for k,v in ipairs(selectCards) do
        v:setColor(SRDDZ_Const.CARD_RELEASE_COLOR)
    end

    gameScene.SRDDZ_CardMgr:setPlayerCardLuTou(cards,selectCards)

    return true
end

return SRDDZ_CardTouchMsg