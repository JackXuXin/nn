local SSSScene = package.loaded["app.scenes.SSSScene"] or {}

local ErrorLayer = require("app.layers.ErrorLayer")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local msgWorker = require("app.net.MsgWorker")
local logic = require ("app.Games.SSS.lg_13shui")
local sound = require("app.Games.SSS.sound_sss")
local util = require("app.Common.util")
local Player = app.userdata.Player


local MAX_PALYER = 5            --最大玩家数
local MAX_CARD = 13             --最大手牌数

local texture                   --牌纹理

local frameWidth = 117          --牌宽
local frameHeight = 161         --牌高
local SPECIAL_CARD = 0x3A       --特殊牌 黑桃10
local mycards                   --自己的手牌Sprite
local othercards                --其他玩家手牌背
local selectedCards = {}        --当前选择的手牌
local showCards = {             --面板上展示的牌
            [1] = {},
            [2] = {},
            [3] = {}
            }

local sortType = 1              --0,表示按花色排序；1，表示按值排序
local groupType = 0             --0表示手动摆牌，1表示自动摆牌

local comCards = {}
local comCardsTypeImg = {}      --比牌过程中显示牌的类型图片
local comIndex = 1

local daoResult = {}
local allResult = {}
local typeResult = {}           --特殊牌型文字
local typeBG = {}               --特殊牌型底图

local allDatas                  --自己的手牌数据

local spriteKillAll             --红出

local insertCard = {            --上中下三道的牌型
    [1] = {},
    [2] = {},
    [3] = {}
}
local allCards = {}             --发牌状态下的所有牌
local CARDS_ZORDER = 400 


local errors_num = {
    "上道需要3张牌",
    "中道需要5张牌",
    "下道需要5张牌"
}

local type_img = {
    "type_danzhang.png",
    "type_duizi.png",
    "type_liadui.png",
    "type_santiao.png",
    "type_shunzi.png",
    "type_tonghua.png",
    "type_hulu.png",
    "type_zhadan.png",
    "type_tonghuashun.png",
    "type_wuzha.png",
}

local type_special_img = {
    [0x22] = "Image/SSS/type_img/type_quanhong.png",
    [0x24] = "Image/SSS/type_img/type_quanhei.png",
    [0x26] = "Image/SSS/type_img/type_quanhongyidianhei.png",
    [0x28] = "Image/SSS/type_img/type_quanheiyidianhong.png",
    [0x2A] = "Image/SSS/type_img/type_yitiaolong.png",
    [0x2C] = "Image/SSS/type_img/type_wuduiyike.png",
    [0x2E] = "Image/SSS/type_img/type_quanxiao.png",
    [0x30] = "Image/SSS/type_img/type_quanda.png",
    [0x32] = "Image/SSS/type_img/type_liuduiban.png",
    [0x34] = "Image/SSS/type_img/type_banxiao.png",
    [0x36] = "Image/SSS/type_img/type_banda.png",
    [0x38] = "Image/SSS/type_img/type_santonghua.png",
    [0x3A] = "Image/SSS/type_img/type_sanshunzi.png",
}


local type_result = {
    [1] = "散牌",
    [2] = "对子",
    [3] = "两对",
    [4] = "三条",
    [5] = "顺子",
    [6] = "同花",
    [7] = "葫芦",
    [8] = "炸弹",
    [9] = "同花顺",
    [10] = "五张炸",

    [0x20] = "青龙",
    [0x22] = "全红",
    [0x24] = "全黑",
    [0x26] = "全红一点黑",
    [0x28] = "全黑一点红",
    [0x2A] = "一条龙",
    [0x2C] = "五对一刻",
    [0x2E] = "全小",
    [0x30] = "全大",
    [0x32] = "六对半",
    [0x34] = "半小",
    [0x36] = "半大",
    [0x38] = "三花",
    [0x3A] = "三顺",
}

--local funcs_free = {logic.extract_dui_zi,logic.extract_dui_zi,logic.extract_3_tiao,logic.extract_shun_zi,
--        logic.extract_tong_hua,logic.extract_hu_lu,logic.extract_4_tiao,logic.extract_tong_hua_shun}
local funcs_free = {            --获取牌型方法s
        logic.extract_dui_zi_ex,
        logic.extract_2_dui_ex,
        logic.extract_3_tiao_ex,
        logic.extract_shun_zi,
        logic.extract_tong_hua,
        logic.extract_hu_lu,
        logic.extract_4_tiao_ex,
        logic.extract_tong_hua_shun,
        logic.extract_bomb,
    }

local btns_free = {}            --手动摆牌按钮
local btns_auto = {}            --自动摆牌按钮
local img_light = {}            --已经没有了，后面会删掉

--[[ --
    * 获取花色
    @param int card 牌值
--]]
local function get_card_color(card)
    return math.floor(card/16)
end

--[[ --
    * 创建一张牌
    @param int mask 花色
    @param int value 牌值
--]]
local function createCard(mask,value)
    if texture == nil then
        cc.Director:getInstance():getTextureCache():removeTextureForKey("Image/SSS/card.png")
        texture = cc.Director:getInstance():getTextureCache():addImage("Image/SSS/card.png")
    end

    if value == 0x0f and (mask == -1 or mask == 4) then
        value = 2
    end

    local frame = cc.SpriteFrame:createWithTexture(texture,cc.rect((value - 1) * frameWidth,mask * frameHeight,frameWidth,frameHeight))
    return frame
end

--[[ --
    * 创建一张牌背
--]]
local function createBackCard()
    return createCard(4,3)
end

--[[ --
    * Sprite 与 point 碰撞检测
--]]
local function isTouchInSprite(sprite,x,y)
    return sprite:hitTest(cc.p(x,y))
end

--[[ --
    * 从cards删除一张牌
--]]
local function removeCard(cards,card)
    for i = #cards,1,-1 do
        if cards[i] == card then
            table.remove(cards,i)
        end
    end
end

--[[ --
    * 牌选择动画
--]]
local function cardStatusChange(card)
    sound.touch_card()

    if not card.selected then
        transition.execute(card, cc.MoveBy:create(0.15, cc.p(0, 40)), {
                                delay = 0,
                                easing = nil,
                                onComplete = function()
                                end,
                            })
        table.insert(selectedCards,card)
    else
        transition.execute(card, cc.MoveBy:create(0.15, cc.p(0, -40)), {
                                delay = 0,
                                easing = nil,
                                onComplete = function()
                                end,
                            })
        removeCard(selectedCards,card)
    end
    card.selected = not card.selected
end

function SSSScene:setCardsTexture()
    cc.Director:getInstance():getTextureCache():removeTextureForKey("Image/SSS/card.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("Image/SSS/card.png")
end

function SSSScene:reLoadCardsTexture()
    texture = cc.Director:getInstance():getTextureCache():addImage("Image/SSS/card.png")
end

--[[ --
    * 触摸牌
--]]
function SSSScene:touchCard(x,y)
    if not mycards then return end
    for i = #mycards,1,-1 do
        local sprite = mycards[i]
        --找到触摸的牌
        if isTouchInSprite(sprite,x,y) then
            if sprite.canStatusChanged then
                sprite.canStatusChanged = false
                cardStatusChange(sprite)
            end
            break
        end
    end
end

--[[ --
    * 触摸牌
--]]
local function resetCardStatus()
    if not mycards then return end
    for i = #mycards,1,-1 do
        local sprite = mycards[i]
        sprite.canStatusChanged = true
    end
end

--[[ --
    * 排序从花色
--]]
local function sortCardByColor(cards)
    for i = 1,#cards do
        for j = i + 1,#cards do
            if get_card_color(cards[j].data) < get_card_color(cards[i].data) or 
                (get_card_color(cards[j].data) == get_card_color(cards[i].data) and 
                    logic.get_card_logic_value(cards[j].data) < logic.get_card_logic_value(cards[i].data)) then
            --if cards[j].data < cards[i].data then
                local temp = cards[j]
                local iIndex = cards[i].index
                local jIndex = cards[j].index
                cards[j] = cards[i]
                cards[i] = temp
                cards[i].index = jIndex
                cards[j].index = iIndex
            end
        end
        --cards[i]:setLocalZOrder(i)
    end
end

--[[ --
    * 排序从牌值
--]]
local function sortCardByValue(cards)
    for i = 1,#cards do

        for j = i + 1,#cards do

            if logic.get_card_logic_value(cards[j].data) > logic.get_card_logic_value(cards[i].data) or 
                (logic.get_card_logic_value(cards[j].data) == logic.get_card_logic_value(cards[i].data) and 
                    get_card_color(cards[j].data) > get_card_color(cards[i].data)) then
                local temp = cards[j]
                local iIndex = cards[i].index
                local jIndex = cards[j].index
                cards[j] = cards[i]
                cards[i] = temp
                cards[i].index = jIndex
                cards[j].index = iIndex
            end
        end
    end
end

--[[ --
    * 排序牌
--]]
local function sortCard(cards)
    if sortType == 0 then
        sortCardByColor(cards)
    else
        sortCardByValue(cards)
    end
end

--[[ --
    * 排序牌(按照道数)
--]]
local function sortCardForDao(cards)
    local selectedData = {}
    for k,v in pairs(cards) do
        table.insert(selectedData,v.data)
    end
    local sData = logic.sort_card_type(selectedData)

    for i = 1,#cards do
        for j = 1,#sData do
            if cards[i].data == sData[j] then
                cards[i].temp_Index = j
            end
        end
    end
    for k,v in pairs(cards) do
        print("k:" .. k .. ",v:" .. v.temp_Index .. ",data:" .. v.data)
    end
    for i = 1,#cards do
        for j = i + 1,#cards do
            if cards[j].temp_Index < cards[i].temp_Index then
                local temp = cards[j]
                local iIndex = cards[i].index
                local jIndex = cards[j].index
                cards[j] = cards[i]
                cards[i] = temp
                cards[i].index = jIndex
                cards[j].index = iIndex
            end
        end
    end
    for i = 1,#cards do
        for j = i + 1,#cards do
            if cards[j].index < cards[i].index then
                local temp = cards[j].index
                cards[j].index = cards[i].index
                cards[i].index = temp
            end
        end
    end
    for k,v in pairs(cards) do
        v:setLocalZOrder(CARDS_ZORDER + v.index)
        print("k2:" .. k .. ",v:" .. v.temp_Index .. ",data:" .. v.data)
    end
end

--[[ --
    * 排序牌数据for花色
--]]
local function sortDataByColor(cards)
    print("------------sortDataByColor------------------","排序牌数据for花色")

    for i = 1,#cards do
        for j = i + 1,#cards do
            if get_card_color(cards[j]) < get_card_color(cards[i]) or 
                (get_card_color(cards[j]) == get_card_color(cards[i]) and 
                    logic.get_card_logic_value(cards[j]) < logic.get_card_logic_value(cards[i])) then
                local temp = cards[j]
                cards[j] = cards[i]
                cards[i] = temp
            end
        end
    end
end


--[[ --
    * 排序牌数据for牌值
--]]
local function sortDataByValue(cards)
    print("------------sortDataByValue------------------","排序牌数据for牌值")

    for i = 1,#cards do
        for j = i + 1,#cards do
            if logic.get_card_logic_value(cards[j]) > logic.get_card_logic_value(cards[i]) or 
                (logic.get_card_logic_value(cards[j]) == logic.get_card_logic_value(cards[i]) and 
                    get_card_color(cards[j])  > get_card_color(cards[i])) then
                local temp = cards[j]
                cards[j] = cards[i]
                cards[i] = temp
            end
        end
    end
end

--[[ --
    * 排序牌数据
--]]
local function sortData(cards)
    print("------------sortData------------------","排序牌数据(根据排序类型：sortType)")

    --0,表示按花色排序；1，表示按值排序
    if sortType == 0 then
        sortDataByColor(cards)
    else
        sortDataByValue(cards)
    end
end

--[[ --
    * 设置所有手牌缩头，清理选择状态
--]]
local function resetMycardPos()
    print("---------resetMycardPos---------","设置所有手牌缩头，清理选择状态")

    if mycards then
        local count = #mycards
        for i = 1,count do
            local sprite = mycards[i]
            sprite.index = i
            sprite.selected = false
            local posx = display.cx + (i - math.modf(count / 2) - 1) * 73
            local posy = 162
            sprite:stopAllActions()
            transition.execute(sprite, cc.MoveTo:create(0.15, cc.p(posx, posy)), {
                delay = 0,
                easing = nil,
                onComplete = function()                    
                end,
            })
        end
    end
end

--重置所有牌的位置
local function resetAllMyCardPos()
    for i=1,#insertCard do
        for j=1,#insertCard[i] do
            table.insert(mycards, insertCard[i][j])
        end
    end

    if mycards then
        local count = #mycards
        for i = 1,count do
            local sprite = mycards[i]
            sprite.index = i
            sprite.selected = false
            local posx = display.cx + (i - math.modf(count / 2) - 1) * 60 - 20
            local posy = 150
            sprite:setPosition(cc.p(posx,posy))
            sprite:setLocalZOrder(CARDS_ZORDER+i)
        end
    end
end

local function handCardInfo(seatId,index)
    local posx = 0
    local posy = 0
    local rotate = 0
    if seatId == 1 then
        posx = display.cx + (index - 7) * 73
        posy = 162
    elseif seatId == 2 then
        posx = 1100
        posy = display.cy + (index - 7) *15 + 30
        rotate = 90
    elseif seatId == 3 then
        posx = display.cx + (index - 7) * 15
        posy = 650
    else
        posx = 180
        posy = display.cy + (index - 7) *15 + 30
        rotate = 90
    end
    return {posx = posx,posy = posy,rotate = rotate}
end

function SSSScene:_touch(event)
    -- print("----------------" .. event.y )
    -- print("----------------" .. event.x )
        
    if event.y > 300 and (event.x >1000 or event.x < 360) then
        if event.name == "ended" then
            for i = 1,#selectedCards do
                local card = selectedCards[i]
                transition.execute(card, cc.MoveBy:create(0.15, cc.p(0, -40)), {
                    delay = 0,
                    easing = nil,
                    onComplete = function()
                    end,
                })

                card.selected = false
                card.canStatusChanged = true
            end
            selectedCards = {}
        end
        return true
    end
    --print("event name:" .. event.name)

    if event.name == "began" then
        self:touchCard(event.x,event.y)
        return true
    elseif event.name == "moved" then
        self:touchCard(event.x,event.y)
    elseif event.name == "ended" then
        resetCardStatus()
    elseif event.name == "canceled" then
        resetCardStatus()
    end
end

--[[ --
    * 显示马牌信息
--]]
function SSSScene:showMaPaiImg()
    cc.uiloader:seekNodeByNameFast(self.scene, "tx_add_card"):show()

    if self.game_fly_card == 0 then
        return 
    end

    local img = cc.uiloader:seekNodeByNameFast(self.scene, "mapaiImage") 
    if img then
        img:setSpriteFrame(createCard(get_card_color(self.game_fly_card),logic.get_card_value(self.game_fly_card))) 
        img:setScale(0.45)
        img:show()

        cc.uiloader:seekNodeByNameFast(self.scene, "mapaiText"):show()
    end
end

--[[ --
    * 获取自己牌数据
--]]
local function getMyData()
    print("------------getMyData------------------","获取自己牌数据")
    
    local c = {}
    for i = 1,#mycards do
        table.insert(c,mycards[i].data)
    end
    table.map(c,function(v,k) return {num = logic.get_card_value(v),color = get_card_color(v)} end)
    return c
end

local function tableCard2intCard(cards)
    local retCards = {}
    for _, card in ipairs(cards) do
        table.insert(retCards, card.color * 16 + card.num)
    end
    return retCards
end

local function intCard2tableCard(cards)
    local retCards = {}
    for _, card in ipairs(cards) do
        table.insert(retCards, {num = logic.get_card_value(card), color = get_card_color(card)})
    end
    return retCards
end

--[[ --
    * 刷新按钮点击状态
--]]
local function updateBtnsState()
    print("------------updateBtnsState------------------","刷新按钮点击状态")
  
    --获取手牌数据
    local _cards = tableCard2intCard(getMyData())

    --获取牌型状态
    local _states = {}
    for i,fun_name in ipairs(funcs_free) do
        local _,type_num = fun_name(_cards)
        _states[i] = #type_num ~= 0
    end

    --设置按钮状态
    for i=1,#_states do
        if i <= #btns_free then
            if btns_free[i] then
                btns_free[i]:setButtonEnabled(_states[i])
            end
        end
    end

--[[  
    for i = 1,#btns_free do
        local _t = funcs_free[i](getMyData())
        if #_t == 0 then
            btns_free[i]:setButtonEnabled(false)
        else
            btns_free[i]:setButtonEnabled(true)
        end
    end
--]]

end

--[[ --
    * 刷新自动选牌型按钮状态  废弃
--]]
function SSSScene:updateBtnsState_auto()
    if not self.card_types_auto then
        self.card_types_auto = logic.open_card_client(allDatas)
    end

    local btn_cnt = #self.card_types_auto
    if btn_cnt > 4 then btn_cnt = 4 end
    for i = 1,btn_cnt do
        local btn = btns_auto[i]
        btn:show()
        local front = logic.get_card_type(logic.copy_table_part(self.card_types_auto[i],1,3))
        local mid = logic.get_card_type(logic.copy_table_part(self.card_types_auto[i],4,5))
        local behind = logic.get_card_type(logic.copy_table_part(self.card_types_auto[i],9,5))

        local fLabel = btn:getChildByTag(1)
        local mLabel = btn:getChildByTag(2)
        local bLabel = btn:getChildByTag(3)
        local color_mid
        if mid == 8 or mid == 9 then
            color_mid = cc.c3b(255, 233, 84)
        else
            color_mid = cc.c3b(255, 255, 255)
        end
        local color_behind
        if behind == 8 or behind == 9 then
            color_behind = cc.c3b(255, 233, 84)
        else
            color_behind = cc.c3b(255, 255, 255)
        end
        fLabel:setString(tostring(type_result[front]))
        mLabel:setString(tostring(type_result[mid]))
        mLabel:setColor(color_mid)
        bLabel:setString(tostring(type_result[behind]))
        bLabel:setColor(color_behind)
    end
end

--[[ --
    * 添加苍蝇标记
    @param number  data  牌值 
    @param cc.Sprite  ui_card  要添加标记的牌
--]]
function SSSScene:add_special_card_sign(data,ui_card)
    if self.game_fly_card == data then
        local mask = display.newSprite("Image/SSS/mapai_mask.png")
        mask:setAnchorPoint(0,1)
        mask:setPosition(5,frameHeight - 5)
        mask:addTo(ui_card)
    end
end

--[[ --
    * 发牌
    @param table mycardData 自己的手牌
--]]
function SSSScene:onSendCard(mycardData)
    print("------------SSSScene:onSendCard------------------","发牌")

    -- mycardData = {
    --     1,2,3,4,5,2,3,4,5,6,34,18,2
    -- }

    -- mycardData = {
    --     28,59,43,11,58,42,26,10,10,38,6,37,36
    -- }

    -- mycardData = {
    --     49,60,44,28,12,41,11,58,57,43,56,54,37
    -- }

    -- mycardData = {
    --     40,18,36,51,61,44,56,1,24,53,29,41,20
    -- }

    print("------------我的手牌2-------------")
    dump(mycardData)
    print("-------------------------")

    --init card on table center
    allDatas = mycardData           --自己的手牌数据
    mycards = {}                    --自己的手牌Sprite
    othercards = {}                 --其他玩家手牌背
    sortType = 1                    --按大小排序aaS
    --排序
    sortData(mycardData)

    print("------------我的手牌3-------------")
    dump(mycardData)
    print("-------------------------")

    --创建52张牌背
    for i = 1,#mycardData * MAX_PALYER do
        local frame = createBackCard()
        local card = display.newSprite(frame)
        card:setScale(0.5)
        card:setPosition(cc.p(display.cx + (i - 27) * 15,display.cy))
        self.scene:addChild(card,53 - i)
        card:hide()
        table.insert(allCards,card)
    end

    --发牌到玩家手里
    for j=1,#mycardData do
        for i=1,MAX_PALYER do
            if self:isValidSeat(self:getRealSeat(i)) then
                local index = (j - 1) * 4 + i
                --local index = #cards
                local sprite = allCards[1]
                table.remove(allCards,1)
                local handCardInfos = handCardInfo(i,j)
                local posx = handCardInfos.posx
                local posy = handCardInfos.posy
                local rotate = handCardInfos.rotate

                transition.execute(sprite, cc.Spawn:create(cc.MoveTo:create(0.05, cc.p(posx, posy)),cc.RotateTo:create(0.05,rotate)), {
                    delay = index * 0.02,
                    easing = nil,
                    onComplete = function()
                        sprite:setLocalZOrder(index)
                        if i == 1 then
                            sound.send_card()
                            local data = mycardData[j]

                            print("牌值 =  " .. data)

                            sprite:setSpriteFrame(createCard(get_card_color(data),logic.get_card_value(data)))
                            sprite:setScale(1)
                            sprite:show()
                            sprite.data = data
                            sprite.selected = false
                            sprite:setLocalZOrder(CARDS_ZORDER+j)
                            sprite.index = j
                            sprite.canStatusChanged = true

                            --苍蝇标示
                            self:add_special_card_sign(data,sprite)

                            table.insert(mycards,sprite)

                            --发牌结束
                            if j == MAX_CARD then
                                for i = 1,#allCards do                                 
                                    allCards[i]:hide()
                                end            
                                --显示摆牌界面                  
                                local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG"):show()
                                cc.uiloader:seekNodeByNameFast(centerBG, "bg"):show()
                                --显示状态
                                self:onSendCardEnd()
                                --显示摆牌按钮
                                self:showTypeBtn()
                            end
                        else
                            table.insert(othercards,sprite)
                        end
                    end,
                })
            end
        end
    end
end

--从选牌界面取消选择的牌型
local function restoreCard(index)
    print("restore index:" .. tostring(index) .. ",count:" .. tostring(#insertCard[index]))
    for i = #insertCard[index],1,-1 do
        local sprite = insertCard[index][i]
        sprite:setScale(1)
        sprite.selected = false
        sprite:setLocalZOrder(CARDS_ZORDER +30 -i)
        sprite:show()
        sprite.canStatusChanged = true
        table.insert(mycards,sprite)
        table.remove(insertCard[index],i)
    end
end

function SSSScene:restoreAll()
    for i = 1,3 do
        restoreCard(i)
    end
    self:mySort()
    updateBtnsState()
    self:initSelectBtnState()
     --清除按钮上的子物体
    for i=1,3 do
       for j=1,#showCards[i] do
        showCards[i][j]:removeFromParent()
      end
    end  
    showCards = 
    { 
        [1] ={},
        [2] ={},
        [3] ={}
    }
end

--[[ --
    * 获取所有展示牌值
    @param number index 道
--]]
function SSSScene:getCenterCards()
    local cards = {}
    for i = 1,#insertCard do
        for j = 1,#insertCard[i] do
            table.insert(cards,insertCard[i][j].data)
        end
    end
    return cards
end

--[[ --
    * 获取index对应道的牌值
    @param number index 道
--]]
function SSSScene:getCenterCardsByIndex(index)
    print("SSSScene:getCenterCardsByIndex index = " .. index)

    local cards = {}
   -- for i = 1,#insertCard do
        for j = 1,#insertCard[index] do
            table.insert(cards,insertCard[index][j].data)
        end
   -- end
    return cards
end

function SSSScene:checkCenterCard()
    local cards = self:getCenterCards()
    return logic.check_3_dao_card_type(cards)
end

--[[ --
    * 选牌型
    @param number index 1 = 上 2 = 中 3 = 下
--]]
function SSSScene:onCenterBtnClicked(index)
    local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")
    local parent = cc.uiloader:seekNodeByNameFast(centerBG, string.format("Button_%d",index))
    local card_dx  = {76,78,89}

    if #insertCard[index] == 0 then  --如果当前没选择任何牌型
        --该道牌数
        local targetNum = 3      
        if index == 2 then
            targetNum = 5          
        elseif index == 3 then
            targetNum = 5          
        end

        --没有选择任何牌
        if #selectedCards ~= targetNum then
            ErrorLayer.new(errors_num[index]):addTo(self.scene,500)
            return
        end

        --sortCard(selectedCards)
        --排序
        sortCardForDao(selectedCards)

        for i = #selectedCards,1,-1 do
            --创建新的牌显示在选牌界面上
            local sprite = selectedCards[i]           
            local new_sp = display.newSprite(sprite:getSpriteFrame())
            new_sp:addTo(parent)
            new_sp:setScale(1.077)  
            new_sp:setPosition( (i-1)  * card_dx[index] + new_sp:getContentSize().width/2 ,1)  
            new_sp:setLocalZOrder(i)  
            
            --苍蝇标示
            self:add_special_card_sign(sprite.data,new_sp)
            
            --去掉展示的牌
            sprite:hide()
            table.remove(mycards,sprite.index)
            --存储新创建的牌
            table.insert(showCards[index],new_sp)
            --存储展示牌
            table.insert(insertCard[index],sprite)
        end
        
        if #insertCard[1] > 0 and #insertCard[2] > 0 and #insertCard[3] > 0 then   --显示完成按钮
            self:showBtnConfirm()
        else
            --手牌缩头 重置手牌位置
            resetMycardPos()
            --剩下最后一道自动选择
            if #insertCard[1] > 0 and #insertCard[2] > 0 then
                selectedCards = mycards
                self:setSigned(false)
                self:onCenterBtnClicked(3)
            elseif #insertCard[1] > 0 and #insertCard[3] > 0 then
                selectedCards = mycards
                self:setSigned(false)
                self:onCenterBtnClicked(2)
            elseif #insertCard[2] > 0 and #insertCard[3] > 0 then
                selectedCards = mycards
                self:setSigned(false)
                self:onCenterBtnClicked(1)
            end
        end

        selectedCards = {}
        --刷新按钮状态
        updateBtnsState()
        --刷新选择按钮状态
        self:updateSelectBtnState(index,true)
        --显示牌型
        self:showCardsType(index,true)     
    elseif not self.isOk then           --清理已经选择的牌型
        restoreCard(index)  --从选牌界面取消选择的牌型
        --清理当前选择的牌
        for i = 1,#selectedCards do
            selectedCards[i].selected = false
            selectedCards[i].canStatusChanged = true
        end
        selectedCards = {}

        sortType = 1
        self:mySort()   --排序
        self:hideBtnConfirm()  --隐藏完成按钮 And 取消按钮
        updateBtnsState()   --刷新选择牌型按钮状态
        --清除按钮上的子物体
        for i=1,#showCards[index] do
            showCards[index][i]:removeFromParent()
        end
        showCards[index] = {}
        self:updateSelectBtnState(index,false)      --刷新对号按钮状态
        self:showCardsType(index,false)        --隐藏牌型
    end

    self:resetTypeFreeBtnClickCnt()
   
    print("onCenterBtnClicked:" .. tostring(#mycards))
end

--[[ --
    * 刷新对号按钮状态
    @param number index 道
    @param boolean state 可点击状态
--]]
function SSSScene:updateSelectBtnState(index,state)
      local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")
      local btn = cc.uiloader:seekNodeByNameFast(centerBG, string.format("ok_btn_%d",index)) 
      btn:show()
      btn:setButtonEnabled(state)     
end

function SSSScene:initSelectBtnState()
      local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")
      for i=1,3 do
          local btn = cc.uiloader:seekNodeByNameFast(centerBG, string.format("ok_btn_%d",i)) 
          btn:setButtonEnabled(false)
          local cardTypeImg = cc.uiloader:seekNodeByNameFast(centerBG, string.format("card_type_%d",i)) 
          cardTypeImg:hide()
      end        
end

--[[ --
    * 显示展示牌型
    @param number index 道
    @param boolean state 显示状态
--]]
function SSSScene:showCardsType(index,state)
    print("SSSScene:showCardsType","显示展示牌型")

    local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")
    local cardTypeImg = cc.uiloader:seekNodeByNameFast(centerBG, string.format("card_type_%d",index))
    --隐藏
    if not state then
        cardTypeImg:hide()
        return
    end


    local cards = self:getCenterCardsByIndex(index) 
    --隐藏
    if  #cards == 0 then
        cardTypeImg:hide()
        return
    end
    
    --获取牌型index
    local card_type = logic.get_card_type(cards)
    print("牌型："..card_type)
    --显示牌型
    if cardTypeImg then
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(type_img[card_type])
        cardTypeImg:setSpriteFrame(frame)
        cardTypeImg:show()
    end
end


function SSSScene:mySort()
    print("mycards count:" .. tostring(#mycards))

    sortCard(mycards)
    for i = 1,#mycards do
        mycards[i]:setLocalZOrder(CARDS_ZORDER + i)
    end
    resetMycardPos()
end

function SSSScene:SortForColor()
    sortType = 0
    self:mySort()
end

function SSSScene:SortForValue()
    sortType = 1
    self:mySort()
end

function SSSScene:onBtnSpClicked(card_values)
    --清除已选的
    --清除按钮上的子物体
    for index=1,3 do
        for i=1,#showCards[index] do
            showCards[index][i]:removeFromParent()
        end
        showCards[index] = {}
    end
    resetAllMyCardPos()
    local allCards = {}
    for _,v in pairs(mycards) do

        table.insert(allCards,v)
    end
    mycards = {}
    for i = 1,#insertCard do
        for _,c in pairs(insertCard[i]) do
            table.insert(allCards,c)
        end
        insertCard[i] = {}
    end

    local f_cards_data = logic.copy_table_part(card_values,1,3)
    f_cards_data = logic.sort_card_type(f_cards_data)
    local m_cards_data = logic.copy_table_part(card_values,4,5)
    m_cards_data = logic.sort_card_type(m_cards_data)
    local b_cards_data = logic.copy_table_part(card_values,9,5)
    b_cards_data = logic.sort_card_type(b_cards_data)
    local all = {f_cards_data ,m_cards_data,b_cards_data}


    local  card_dx  = {76,78,89}
    local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG")
   
    for i = 1,#insertCard do
        local parent = cc.uiloader:seekNodeByNameFast(centerBG, string.format("Button_%d",i))    
        for j = 1,#all[i] do
            local sprite
            for k = 1,#allCards do                
                if allCards[k].data == all[i][j]  then
                    sprite = allCards[k]
                    if not sprite.selected then
                        sprite.selected = true
                        break   
                    end                  
                end
            end
            if not sprite then 
                print("Error:card not found!")
                return 
            end
            local new_sp = display.newSprite(sprite:getSpriteFrame())
            new_sp:addTo(parent)
            new_sp:setScale(1.077)
            new_sp:setPosition( (j-1)  * card_dx[i] + new_sp:getContentSize().width/2 ,-1)
            new_sp:setLocalZOrder(j)

            --苍蝇标示
            self:add_special_card_sign(sprite.data,new_sp)

            sprite:hide()
            table.insert(showCards[i],new_sp)
            table.insert(insertCard[i],sprite)
        end
    end


    selectedCards = {}
    updateBtnsState()
    for i=1,3 do
        self:updateSelectBtnState(i,true)
    end  
    -- self:showBtnConfirm()
end

--[[ --
    * 创建自动选牌型按钮 废弃
--]]
function SSSScene:createAutoBtn()
    if #btns_auto == 0 then
        for i=1,4 do
            local typeBg = cc.ui.UIPushButton.new({
                normal = "Image/SSS/cardtype_normal.png",
                pressed = "Image/SSS/cardtype_down.png"
                })
            :pos(display.cx + (i * 2 - 5) * 130,230)
            :addTo(self.scene)
            :hide()
            :onButtonClicked(function(event)
                sound.btn_type_2()
                self:setSigned(false)
                self:onBtnSpClicked(self.card_types_auto[i])
            end)
            table.insert(btns_auto,typeBg)

            for j = 1,3 do
                cc.ui.UILabel.new({
                    text = "", 
                    size = 26, 
                    color = cc.c3b(255,255,255)
                })
                :pos((j - 2) * 70,5)
                :addTo(typeBg)
                :setAnchorPoint(cc.p(0.5,0.5))
                :setTag(j)
            end
        end
    end
    self:updateBtnsState_auto()
end

function SSSScene:onSignClicked()
    self:setSigned(true)

    local after_sort_data,sp_type = logic.sort_special_card(allDatas)

    if sp_type ~= CARD_TYPE.CARD_TYPE_NULL then
        self:onBtnSpClicked(after_sort_data)
        ErrorLayer.new("报到：" .. tostring(type_result[sp_type])):addTo(self.scene,500)
    end
end

--[[ --
    * 重新设置选择牌型按钮Cnt
--]]
function SSSScene:resetTypeFreeBtnClickCnt(thisIndex)
    print("---------SSSScene:resetTypeFreeBtnClickCnt---------","重新设置选择牌型按钮Cnt")

    for k,v in pairs(btns_free) do
        if k ~= thisIndex or thisIndex == nil then
            v.clickCnt = 0
        end
    end
end

--[[ --
    * 选择牌型按钮回调
--]]
function SSSScene:onFreeBtnCallback(event)
    print("---------SSSScene:onFreeBtnCallback---------","选择牌型按钮回调 index:"..event.target.index)

    --获取对应牌型
    local i = event.target.index
    sound.btn_type()
    self:resetTypeFreeBtnClickCnt(i)

    -- dump(tableCard2intCard(getMyData()),"tableCard2intCard(getMyData())")

    local cardTypes = funcs_free[i](tableCard2intCard(getMyData()))

    -- dump(cardTypes,"cardTypes")

    cardTypes = intCard2tableCard(cardTypes)

    local c = {}

    -- if i == 5 then         --如果是 同花
    --     local isKing = false

    --     for k,card in pairs(cardTypes) do
    --         if card.color == 4 then
    --             isKing = true
    --             break
    --         end
    --     end

    --     local mycards = getMyData()

    --     for i=0,3 do
    --         local t = {}
    --         for _,card in ipairs(mycards) do
    --             if isKing then
    --                 if card.color == 4 or card.color == i then
    --                     table.insert(t,card)
    --                 end
    --             else
    --                 if card.color == i then
    --                     table.insert(t,card)
    --                 end
    --             end
    --         end

    --         if #t > 4 then
    --             table.insert(c, t)
    --         end
    --     end
    -- else                   --每5张提取
    --     local size = #cardTypes / 5
    --     for i=1,size do
    --         c[i] = {}
    --         for _=1,5 do
    --             local card = table.remove(cardTypes,1)
    --             table.insert(c[i],card)
    --         end
    --     end
    -- end

    local size = #cardTypes / 5
    for i=1,size do
        c[i] = {}
        for _=1,5 do
            local card = table.remove(cardTypes,1)
            table.insert(c[i],card)
        end
    end

    cardTypes = {}

    btns_free[i].clickCnt = btns_free[i].clickCnt+1
    if btns_free[i].clickCnt  > #c then
        btns_free[i].clickCnt = 1
    end

    --取消所有牌的选择
    resetMycardPos()
    for i = 1,#selectedCards do
        selectedCards[i].selected = false
    end
    selectedCards = {}

    if #c == 0 then
        print("error：#c == 0")
        return
    end

    local _card = c[btns_free[i].clickCnt]  --对应牌型的牌
    
    for i=1,#_card do
        for j=1,#mycards do
            local data = _card[i].color*16 + _card[i].num
            if mycards[j].data == data and not mycards[j].selected then
                --位置
                local card = mycards[j]
                local cPosX = card:getPositionX()
                -- local cPosY = card:getPositionY()
                --动画
                card:stopAllActions()
                transition.execute(card, cc.MoveTo:create(0.15, cc.p(cPosX, 202)), {
                    delay = 0,
                    easing = nil,
                    onComplete = function()
                    end,
                })
                --插入
                table.insert(selectedCards,card)
                card.selected = true
                break
            end
        end
    end
end

--[[ --
    * 创建选择牌型按钮
--]]
function SSSScene:createFreeBtn()
    print("------------SSSScene:createFreeBtn------------------","创建选择牌型按钮")

    --牌型按钮数
    local count = 9
    --间距
    local btns_width_distance = 142
    --排列按钮位置
    local btns_width = 0
    --如果是人民广场房间 或 不加一色 不显示五张炸按钮 

    print("self.room_is_add_color = ",self.room_is_add_color)
    if not self.room_is_add_color then
        count = 8
        btns_width_distance = 162
    end

    if #btns_free == 0 then
        for i = 1,count do
            --资源
            local btn_res_n  = string.format("Image/SSS/btn_cardtype_%d_0.png", i)
            local btn_res_p  = string.format("Image/SSS/btn_cardtype_%d_1.png", i)
            local btn_res_d = nil
            if i == 7 or i == 8 or i == 9 then
                btn_res_d  = string.format("Image/SSS/btn_cardtype_%d_2.png", i)
            else
                btn_res_d  = string.format("Image/SSS/btn_cardtype_%d_1.png", i)
            end

            --创建按钮
            local bgBtn = cc.ui.UIPushButton.new({normal = btn_res_n,pressed = btn_res_p,disabled = btn_res_d})
                :setAnchorPoint(0,0)
                :pos(btns_width,2)
                :addTo(self.scene,CARDS_ZORDER+40)
                :onButtonClicked(handler(self,self.onFreeBtnCallback))

            --下一个按钮的位置
            btns_width = btns_width+btns_width_distance
            --同一个牌型，多组选择下标
            bgBtn.clickCnt = 0
            --牌型方法下标（funcs_free）
            bgBtn.index = i
            --插入
            table.insert(btns_free,bgBtn)
        end
    else
        --直接显示
        for i = 1,#btns_free do
            btns_free[i]:show()
        end
    end
    --刷新按钮点击状态
    updateBtnsState()
end

--[[ --
    * 显示摆牌按钮
--]]
function SSSScene:showTypeBtn()
    print("------------SSSScene:showTypeBtn------------------","显示摆牌按钮")

    --groupType 0表示手动摆牌，1表示自动摆牌
    if groupType == 0 then
        self:createFreeBtn()
        --隐藏自动摆牌
        for i = 1,#btns_auto do
            btns_auto[i]:hide()
        end
    else
        -- self:createAutoBtn()
        -- --隐藏手动摆牌        
        -- for i = 1,#btns_free do
        --     btns_free[i]:hide()
        -- end
    end
end

function SSSScene:hideTypeBtn()
    for i = 1,#btns_auto do
        btns_auto[i]:hide()
    end
    for i = 1,#btns_free do
        btns_free[i]:hide()
    end
end

function SSSScene:showFree()
    groupType = 0
    self:showTypeBtn()
end

function SSSScene:showAuto()
    groupType = 1
    self:showTypeBtn()
end

local function getPosCompareCard(seatId)
    local posx = 0
    local posy = 0
    if seatId == 1 then
        posx = display.cx -50
        posy = 260
    elseif seatId == 2 then
        posx = 940
        posy = display.cy + 100
    elseif seatId == 3 then
        posx = display.cx -50
        posy = 680
    else
        posx = 250
        posy = display.cy + 100
    end

    return cc.p(posx,posy)
end

local function getPosCompareCardEx(seatId)
    local posx = 0
    local posy = 0
    if seatId == 1 then
        posx = 640
        posy = 222
    elseif seatId == 2 then
        posx = 975
        posy = 455
    elseif seatId == 3 then
        posx = 640
        posy = 708
    else
        posx = 299
        posy = 455
    end

    return cc.p(posx,posy)
end

function SSSScene:getPosLeastCard(seatId)
    local posx = 0
    local posy = 0
    if seatId == 1 then
        posx = display.cx
        posy = 260
    elseif seatId == 2 then
        posx = 1030
        posy = display.cy 
    elseif seatId == 3 then
        posx = display.cx 
        posy = 650
    else
        posx = 250
        posy = display.cy 
    end

    return cc.p(posx,posy)
end


function SSSScene:addWater(pos,isWin)

    for i = 1,2 do
        local img
        if isWin then
            img = "Image/SSS/water_yellow.png"
        else
            img = "Image/SSS/water_green.png"
        end
        local water = display.newSprite(img)
        water:setPosition(pos)
        self.scene:addChild(water,100)
        water:setOpacity(0)

        local action_scale = cc.Spawn:create(cc.ScaleTo:create(0.6,3.0),cc.FadeOut:create(0.6))
        local action_all = cc.Sequence:create(cc.FadeIn:create(0.01),action_scale)

        transition.execute(water, action_all, {
            delay = (i - 1) * 0.3,
            easing = nil,
            onComplete = function()
                water:removeFromParent()
        end})
    end
end

--[[ --
    * 显示这一道的牌型 ， 水数动画
    @param number seatId 椅子号
    @param number result 水数
--]]
function SSSScene:showShuiAction(seatId,result)
    --水数显示动画
    local text_r = tostring(result)
    local resultColor = cc.c3b(0,255,252)
    if result > 0 then
        text_r = "+" .. text_r
        resultColor = cc.c3b(246,255,0)
    end
    local pos_x = daoResult[seatId]:getPositionX()
    local pos_y = daoResult[seatId]:getPositionY()
    daoResult[seatId]:setPosition(cc.p(pos_x,pos_y + 120))
    daoResult[seatId]:setString(tostring(text_r))
    daoResult[seatId]:setColor(resultColor)

    transition.execute(daoResult[seatId], cc.MoveTo:create(0.6, cc.p(pos_x, pos_y)), {
        delay = 0,
        easing = nil,
        onComplete = function()
            daoResult[seatId]:setString("")
            local c = allResult[seatId].count + result
            local text_all = tostring(c)
            local allColor = cc.c3b(0,255,252)
            local isWin = false
            if c > 0 then
                isWin = true
                text_all = "+" .. text_all
                allColor = cc.c3b(246,255,0)
            end
            allResult[seatId]:setString(tostring(text_all))
            allResult[seatId].count = c
            allResult[seatId]:setColor(allColor)

            --add anim
            self:addWater(cc.p(allResult[seatId]:getPositionX(),allResult[seatId]:getPositionY() - 20),isWin)
    end})
end

--[[ --
    * 显示这一道的牌型 ， 水数
    @param number seatId 椅子号
    @param number result 水数
    @param number _type 牌型
    @param number index  1 = 上 2 = 中 3 = 下 
--]]
function SSSScene:showDao(seatId,result,_type,index)
    _type = _type or 0
    index = index or 0
    print("------------SSSScene:showDao------------------","显示这一道的牌型 ， 水数："..seatId.."/"..result.."/".._type.."/"..index)

    sound.compare()

    --显示index道牌型
    if index ~= 0 then
        local typeImg = comCardsTypeImg[seatId][index]
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(type_img[_type])
        if frame then
            typeImg:setSpriteFrame(frame)
            typeImg:show()
        end 
    end

    --如果是特殊牌型
    if _type ~= 0 and _type > 10 then
        typeResult[seatId]:setString(type_result[_type])
        typeBG[seatId]:show()
        -- local img = display.newSprite(type_special_img[_type])
        -- if img and not typeBG[seatId]:isVisible() then
        --     typeBG[seatId]:setSpriteFrame(img:getSpriteFrame())
        --     typeBG[seatId]:show()
        -- end
    end
    
    --刷新当前水数
    if seatId == 1 then -- 玩家自己
        if self._matchid then
            self:updateMatchScore(result, false)            
        else
            self:updateRecordInfo(result)     
        end
    end

    self:showShuiAction(seatId,result)
end

--[[ --
    * 显示上中下三道牌
    @param table infos 显示信息
    @param number index  1 = 上 2 = 中 3 = 下 
--]]
function SSSScene:compareCard(infos,index)
    print("------------SSSScene:compareCard------------------","显示上中下三道牌")

    --显示信息
    local n = {3,5,5}
    local start = 1
    if index == 2 then
        start = 4
    elseif index == 3 then
        start = 9
    end
  
    for i = 1,MAX_PALYER do
        if self:isValidSeat(self:getRealSeat(i)) then
            local _t    --牌型
            local r     --水数
            local userInfo = infos[self:getRealSeat(i)]  --用户信息

            if not userInfo.special_card_type or userInfo.special_card_type == 0 then         --没有特殊牌型
                local cinfo = userInfo.cardinfos[index]                 --index道牌信息
                local cs = logic.sort_card_type(cinfo.cardvalues)       --index道牌值s
                r = cinfo.shuicnt                                       --index道水数
                _t = cinfo.cardtype                                     --index道牌型
                local csSprites = comCards[i]
                for k = 1,n[index] do
                    local sprite = csSprites[k + start - 1]     --牌Sprite
                    local data = cs[k]                          --牌值
                        
                    --显示牌
                    sprite:setSpriteFrame(createCard(get_card_color(data),logic.get_card_value(data)))
                    sprite:show()

                    --苍蝇标示
                    self:add_special_card_sign(data,sprite)
                end
                --显示这一道的牌型 ，水数
                self:showDao(i,r,_t,index)
            else
                if index == 1 then
                    local cardinfos = {}
                    for k = 1,3 do
                        --dump(userInfo.cardinfos[k])
                        table.insertto(cardinfos,userInfo.cardinfos[k].cardvalues)
                    end
                    --dump(cardinfos)
                    local csSprites = comCards[i]
                    for k = 1,MAX_CARD do
                        local sprite = csSprites[k]
                        local data = cardinfos[k]
                        sprite:setSpriteFrame(createCard(get_card_color(data),logic.get_card_value(data)))
                        sprite:show()
                    end
                    _t = userInfo.special_card_type
                    r = 0
                    self:showDao(i,r,_t,index)
                elseif index == 3 then
                    _t = userInfo.special_card_type
                    r = userInfo.total_shui_cnt
                    self:showDao(i,r,_t,index)
                else
                    _t = userInfo.special_card_type
                    r = 0
                    self:showDao(i,r,_t,index)
                end
            end
        end
    end
end

--[[ --
    * 比牌
--]]
function SSSScene:compare(infos,daqianginfos,quanleidainfos)
    --msgWorker.sleep()
    --停止倒计时
    self:clearTime()
    --清理游戏状态
    self:clearGameState()
    --隐藏做牌界面
    cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG"):hide()

    --1 座位 移动位置
    --cc.uiloader:seekNodeByNameFast(self.scene, "User_1"):pos(415, 96.43)

    local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, "User_1"):show()
       transition.execute(
                            player_ui, 
                            cc.MoveTo:create(0.5, cc.p(415, 96.43)), {
                                delay = 0,
                                easing = nil,
                                onComplete = function()                    
                                end,
                            }
                        )
    
    --remove 所有牌
    for k,v in pairs(othercards) do
        v:removeFromParent()
    end
    othercards = {}
    for k,v in pairs(mycards) do
        v:removeFromParent()
    end
    mycards = {}
    selectedCards = {}
    for _,v in pairs(insertCard) do
        for _,s in pairs(v) do
            s:removeFromParent()
        end
    end

    local n = {3,5,5}
    for i = 1,MAX_PALYER do
        if self:isValidSeat(self:getRealSeat(i)) then
            --隐藏 配牌 完成 文字
            self:setComplete(i,false)
            self:setPeipai(i,false)

            --玩家信息
            local userInfo = infos[self:getRealSeat(i)]

            --创建牌的背面
            comCards[i] = {}
            local cPos = getPosCompareCardEx(i)
            local posx = cPos.x
            local posy = cPos.y
            for j = 1,#n do
                for k = 1,n[j] do
                    local sprite = display.newSprite(createBackCard())
                    local core = math.ceil( n[j] / 2 )
                    local spacing = 0
                    if j == 1 or j == 2 then
                        spacing = 40
                    elseif j == 3 then
                        spacing = 50
                    end
                    sprite:pos(posx + (k - core) * spacing,  posy - j * 50)
                    sprite:scale(0.66)
                    sprite:hide()
                    self.scene:addChild(sprite)
                    table.insert(comCards[i],sprite)
                end
            end
            -- 每个玩家3道
            comCardsTypeImg[i] = {}
            for j=1,3 do
                local sprite = display.newSprite("#"..type_img[1])
                if 1 == i then
                    sprite:setPosition(posx + 200,posy - (j-1)*60 - 20)
                end
                if 2 == i then
                    sprite:setPosition(posx - 200,posy - (j-1)*60 - 20)
                end
                if 3 == i then
                    sprite:setPosition(posx - 200,posy - (j-1)*60 - 20)
                end
                if 4 == i then
                    sprite:setPosition(posx + 200,posy - (j-1)*60 - 20)
                end
                sprite:hide()
                sprite:setScale(0.85)
                self.scene:addChild(sprite,CARDS_ZORDER+50)
                table.insert(comCardsTypeImg[i],sprite)
            end

            --道数
            local spacing = 0
            if i == 1 or i == 4 then
                spacing = 280
            else
                spacing = -280
            end
            local label = cc.ui.UILabel.new({
                    --color = cc.c3b(255,189,0), 
                    size = 45, 
                    text = "", 
                })
                :addTo(self.scene,100)
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(posx + spacing,posy - 80)
            daoResult[i] = label

            local label_all = cc.ui.UILabel.new({
                    --color = cc.c3b(26,193,189), 
                    size = 45, 
                    text = "", 
                })
                :addTo(self.scene)
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(posx + spacing,posy - 80)
            label_all.count = 0
            allResult[i] = label_all

            --特殊牌型
            local type_color
            local img_type_bg
            local type_pos_y = 0

            if userInfo.special_card_type and userInfo.special_card_type ~= 0 then
                img_type_bg = "Image/SSS/type_sp.png"
                type_color = cc.c3b(255,0,0)
                type_pos_y = 5
            else
                img_type_bg = "Image/SSS/type_sp.png"
                type_color = cc.c3b(255,0,0)
                type_pos_y = 5
            end

            --特殊牌型文字
            local label_type = cc.ui.UILabel.new({
                    color = type_color, 
                    size = 30, 
                    text = "", 
                })
                :addTo(self.scene,1)
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(posx,posy-170 + type_pos_y)
                :scale(0.7)
                -- :hide()
                typeResult[i] = label_type

            --特殊牌型图片
            local tSpite = display.newSprite(img_type_bg)
            tSpite:setPosition(posx,posy-170)
            tSpite:addTo(self.scene)
            tSpite:scale(0.7)
            tSpite:hide()
            typeBG[i] = tSpite

            -- if i == 2 or i == 3 then
            --     tSpite:setPosition(posx-165,posy-140)
            --     tSpite:setAnchorPoint(cc.p(1,0.5))
            -- else
            --     tSpite:setPosition(posx+165,posy-140)
            --     tSpite:setAnchorPoint(cc.p(0,0.5))
            -- end
            -- tSpite:scale(0.93)
        end
    end

    --显示牌
    local comIndex = 0
    local isKill = false

    local count = 0
    self.chandle = scheduler.scheduleGlobal(function()
        if #comCards == 0 then
            scheduler.unscheduleGlobal(self.chandle)
            self.chandle = nil
            comIndex = 0
            count = 0
        end
        count = count + 1
        if count ~= 2 and (count - 2) % 3 ~= 0 then
            return 
        end
        comIndex = comIndex + 1

        if comIndex <= 3 then   --显示每道的牌值，牌型，水数
            self:compareCard(infos,comIndex)
        else   --打枪
            -- for k,v in pairs(typeResult) do
            --     v:hide()
            -- end
            -- for k,v in pairs(typeBG) do
            --     v:hide()
            -- end
            if #daqianginfos > 0 and comIndex - 3 <= #daqianginfos then
                local daqiang = daqianginfos[comIndex - 3]
                local from = self:getViewSeat(daqiang.from_seatid)
                local to = self:getViewSeat(daqiang.to_seatid)
                local shui = daqiang.da_qiang_extra_shuicnt
                self:killOne(from,to,shui)
                isKill = true
            else
                scheduler.unscheduleGlobal(self.chandle)
                self.chandle = nil
                comIndex = 0

                if quanleidainfos and #quanleidainfos ~= 0 then
                    self:showKillAll(quanleidainfos)
                end
            end
        end
    end, 1)
end

--[[ --
    * 显示胜负结果界面
    @param table scoreInfos 结算信息
--]]
function SSSScene:showResult(scoreInfos, table_code, gameround)
   -- self:onRestart()
    local resultLayer = cc.uiloader:seekNodeByNameFast(self.scene, "ResultLayer")

    local userCount = #scoreInfos

    --隐藏结算界面玩家信息
    for i=1,MAX_PALYER do
        local node = cc.uiloader:seekNodeByNameFast(resultLayer, string.format("UserInfo_%d", i))
        if node then
           node:hide()
        end
    end

   local index = 1
   local start_x = 0
   local dX = 0
   
    --获取第一个显示玩家信息的位置
    if userCount == 2 then
        start_x = display.cx - 122
        dX = 244
    end
    if userCount == 3 then
        start_x = display.cx - 180
        dX = 180
    end
    if userCount == 4 then
        start_x = display.cx - 240
        dX = 168
    end

   for i = 1,MAX_PALYER do   
        local node = cc.uiloader:seekNodeByNameFast(resultLayer, string.format("UserInfo_%d", i))

       -- if self:isValidSeat()  and index <= userCount then
        if i <= userCount then
            --显示 设置位置
            node:show()
            local px = start_x + dX * (index-1)
            node:setPosition(cc.p(px,426))
                                           
            print("-----------------seatId = " .. scoreInfos[i].seatid .. "view seat"..self:getViewSeat(scoreInfos[i].seatid))
            --从游戏场景里获取玩家的头像 名称
            local player_ui = cc.uiloader:seekNodeByNameFast(self.scene, string.format("User_%d",self:getViewSeat(scoreInfos[i].seatid)))
            local por = cc.uiloader:seekNodeByNameFast(player_ui, "Image_Por")
            local nickname = cc.uiloader:seekNodeByNameFast(player_ui, "Text_nickname")
            --设置到面板上
            local HeadIconImg = cc.uiloader:seekNodeByNameFast(node, "HeadIconImg")
            local NickNameText = cc.uiloader:seekNodeByNameFast(node, "NickNameText")
            local GoldText = cc.uiloader:seekNodeByNameFast(node, "GoldText")
            local Me = cc.uiloader:seekNodeByNameFast(node, "me"):hide()

            --头像
            local WXHEAD = por:getParent():getChildByName("WXHEAD")
            if WXHEAD then
                HeadIconImg:setSpriteFrame(WXHEAD:getSpriteFrame():clone())
                HeadIconImg:setScale(0.73)
            else
                HeadIconImg:setSpriteFrame(por:getSpriteFrame():clone())
                HeadIconImg:setScale(0.54)
            end

            --昵称
            local nick  = nickname:getString()
            NickNameText:setString(nick)

            --分数
            local num_score = tonumber(scoreInfos[i].score)
            local s = util.num2str_thousand(num_score)
            if num_score > 0 then
                s = "+" .. s
                GoldText:setColor(cc.c3b(255,198,0))
            else
                GoldText:setColor(cc.c3b(0,255,234))
            end
            GoldText:setString(s)

            --如果是自己
            if util.checkNickName(nick) == util.checkNickName(Player.nickname) then
                --【我】图片
                Me:show()

                --输赢标题
                local ResultBg = cc.uiloader:seekNodeByNameFast(resultLayer, "Title")
                if num_score >= 0 then                
                      local rect = cc.rect(0, 0, 530, 122)
                      local frame = cc.SpriteFrame:create("Image/SSS/Victory.png", rect)         
                      ResultBg:setSpriteFrame(frame)
                else                    
                      local rect = cc.rect(0, 0, 530, 122)
                      local frame = cc.SpriteFrame:create("Image/SSS/Failure.png", rect)         
                      ResultBg:setSpriteFrame(frame)
                end
            end
            index = index+1
        end
    end

    local SeeLayer = cc.uiloader:seekNodeByNameFast(self.scene, "SeeLayer")
    local btn_confirm = cc.uiloader:seekNodeByNameFast(SeeLayer, "btn_confirm")

    local SureNextBtn = cc.uiloader:seekNodeByNameFast(resultLayer, "SureNextBtn")
    local ExitBtn = cc.uiloader:seekNodeByNameFast(resultLayer, "ExitBtn")

    if gameround == self.current_Ju_Shu or self._matchid then
        btn_confirm:hide()
        SureNextBtn:hide()
        ExitBtn:pos(640, 215.46)
    else
        btn_confirm:show()
        SureNextBtn:show()
        ExitBtn:pos(496.53, 215.46)
    end

    cc.uiloader:seekNodeByNameFast(self.scene, "SeeLayer"):show()
end

function SSSScene:killOne(from,to,shuicnt)
    
    sound.daqiang(self:getSex(from))

    scheduler.performWithDelayGlobal(function()
        local fPos = getPosCompareCard(from)
        local posx = fPos.x
        local posy = fPos.y
        local rotate = 0
        local isFlip = false
        if from == 1 then
            if to == 2 then
                rotate = 140
                isFlip = true
            elseif to == 3 then
                rotate = 90
            elseif to == 4 then
                rotate = 35
            end
        elseif from == 2 then
            if to == 1 then
                rotate = -35
            elseif to == 2 then
                rotate = 0
            elseif to == 3 then
                rotate = 35
            end
        elseif from == 3 then
            if to == 1 then
                rotate = 270
                --isFlip = true
            elseif to == 2 then
                rotate = 210
                isFlip = true
            elseif to == 4 then
                rotate = -35
            end
        else
            if to == 1 then
                rotate = 220
                isFlip = true
            elseif to == 3 then
                rotate = 155
                isFlip = true
            elseif to == 2 then
                rotate = 180
                isFlip = true
            end
            
        end

        --涉及到玩家
        if from == 1 then
            if self._matchid then
                self:updateMatchScore(shuicnt, false)
            else
                self:updateRecordInfo(shuicnt)         
            end
        end
        if to == 1 then
            if self._matchid then
                self:updateMatchScore(-shuicnt, false)
            else
                self:updateRecordInfo(-shuicnt)          
            end
        end

        self:showShuiAction(from,shuicnt)
        self:showShuiAction(to,-shuicnt)

        local tPos = getPosCompareCardEx(to)
        local to_posx = tPos.x
        local to_posy = tPos.y

        local sp = display.newSprite("Image/SSS/qiang_1.png")
        sp:setPosition(cc.p(posx,posy - 80))
        sp:setAnchorPoint(cc.p(0.8,0.5))
        sp:setRotation(rotate)
        sp:setFlippedY(isFlip)
        self.scene:addChild(sp)
        
        local frames = {}
        for i=1,6 do
            local frameName = "Image/SSS/qiang_" .. i .. ".png"
            local t = cc.Director:getInstance():getTextureCache():addImage(frameName)
            local frame = cc.SpriteFrame:createWithTexture(t,cc.rect(0,0,379,162))
            table.insert(frames,frame)
        end
        local animation = display.newAnimation(frames, 0.2 / 6)
        sp:playAnimationForever(animation)

        local holes = {}
        for i = 1,10 do
            local rand_x = math.random(1,170)
            local rand_y = math.random(1,130)
            local hole = display.newSprite("Image/SSS/qiangyan_1.png")
            hole:setPosition(cc.p(to_posx + rand_x - 85,to_posy - rand_y - 30))
            self.scene:addChild(hole)
            hole:setOpacity(0)
            table.insert(holes,hole)

            transition.execute(hole, cc.Sequence:create(cc.FadeIn:create(0.02),cc.DelayTime:create(0.2)), {
                delay = 0.05 * i,
                easing = nil,
                onComplete = function()
                    if i == 10 then
                      --  self:showDao(from,shuicnt)
                      --  self:showDao(to,-shuicnt)
                        sp:stopAllActions()
                        sp:removeFromParent()
                        for j = 1,#holes do
                            holes[j]:removeFromParent()
                        end
                    end
            end})
        end
        
        sound.da_qiang()
    end,1.0)
end

function SSSScene:showKillAll(quanleidainfos)
    sound.quan_lei_da()
    --红出背景
    spriteKillAll = display.newSprite("Image/SSS/killall_bg.png")
    spriteKillAll:setPosition(cc.p(display.cx,display.cy + 50))
    self.scene:addChild(spriteKillAll,1000)
    --红出文字
    display.newSprite("Image/SSS/killall.png")
        :pos(spriteKillAll:getContentSize().width/2,spriteKillAll:getContentSize().height/2+20)
        :addTo(spriteKillAll)

    spriteKillAll:setScale(0.1)
    transition.execute(spriteKillAll, cc.ScaleTo:create(0.8,1.0), {
        delay = 0,
        easing = "backOut",
        onComplete = function()
            scheduler.performWithDelayGlobal(handler(self,self.removeKillAll),2.0)
    end})

    local qld_loseCnt = 0           --全垒打水数
    local qld_seatid = 0            --全垒打椅子号
    local to_qld_shuicnt = 0        --被打水数
    local to_qld_seatid = 0         --被打椅子号
    for k,v in pairs(quanleidainfos) do
        qld_seatid = v.from_seatid
        to_qld_shuicnt = v.da_qiang_extra_shuicnt
        to_qld_seatid = v.to_seatid
        self:showDao(self:getViewSeat(to_qld_seatid),-to_qld_shuicnt)
        qld_loseCnt = qld_loseCnt + to_qld_shuicnt
    end

    self:showDao(self:getViewSeat(qld_seatid),qld_loseCnt)
end

function SSSScene:removeKillAll()
    print("SSSScene:removeKillAll()")
    msgWorker.wakeup()
    if spriteKillAll then
        spriteKillAll:removeFromParent()
        spriteKillAll = nil
    end
end

function SSSScene:onGameScene(isSceneOpencard,msg)
    --设置个人信息显示状态
    self:setMyInfoShowState(not isSceneOpencard,cc.p(415, 96.43))

    if isSceneOpencard then     --恢复配牌场景

        mycards = {}
        othercards = {}
        --sortData(mycardData)

        for i = 1,MAX_PALYER do
            local realSeat = self:getRealSeat(i)
            local viewSeat = self:getViewSeat(realSeat)
            if self:isValidSeat(realSeat) then

                local isOpen = false 
                for j = 1,#msg.playerinfos do
                    if msg.playerinfos[j].seatid == realSeat then
                        isOpen = msg.playerinfos[j].is_open_card
                    end
                end
                if i == 1 then      --自己
                    local centerBG = cc.uiloader:seekNodeByNameFast(self.scene, "Image_DaoBG"):show()
                    if isOpen then  --已经选好牌
                        self.isOk = true
                        local n = {3,5,5}
                        local card_dx  = {76,78,89}
                        for k = 1,#n do
                            local index = 1
                            if k == 2 then
                                index = 4
                            elseif k == 3 then
                                index = 9
                            end

                            local parent = cc.uiloader:seekNodeByNameFast(centerBG, string.format("Button_%d",k))
                            cc.uiloader:seekNodeByNameFast(centerBG, "bg"):hide()
                            centerBG:pos(0,-155)

                            for x = 1,n[k] do
                                local data = msg.after_cards[index + x - 1]
                                local frame = createCard(get_card_color(data),logic.get_card_value(data))
                                local card = display.newSprite(frame)
                                card:setPosition( (x-1)  * card_dx[k] + card:getContentSize().width/2 ,-1)
                                card:setScale(1.077)
                                card:addTo(parent,CARDS_ZORDER+x)
                                card.data = data
                                table.insert(insertCard[k],card)
                            end
                        end

                        for index,_ in ipairs(insertCard) do
                            --显示每道牌型
                            self:showCardsType(index,true)
                        end

                    else
                        dump(msg.after_cards,"msg.after_cards")
                        print(#msg.after_cards)
                        sortData(msg.after_cards)
                        allDatas = msg.after_cards
                        for x = 1,MAX_CARD do
                            local handCardInfos = handCardInfo(i,x)
                            local posx = handCardInfos.posx
                            local posy = handCardInfos.posy
                            local rotate = handCardInfos.rotate

                            local data = msg.after_cards[x]
                            local frame = createCard(get_card_color(data),logic.get_card_value(data))
                            local card = display.newSprite(frame)
                            card:setScale(1)
                            card.data = data
                            card.selected = false
                            card.index = x
                            card.canStatusChanged = true
                            card:setPosition(posx,posy)
                            self.scene:addChild(card,CARDS_ZORDER+x)
                            table.insert(mycards,card)
                        end
                        self:onSendCardEnd()
                        self:showTypeBtn()
                    end
                else  --别人的手牌
                    for x = 1,MAX_CARD do
                        local handCardInfos = handCardInfo(i,x)
                        local posx = handCardInfos.posx
                        local posy = handCardInfos.posy
                        local rotate = handCardInfos.rotate

                        local frame = createBackCard()
                        local card = display.newSprite(frame)
                        card:hide()
                        card:setScale(0.5)
                        card:setPosition(posx,posy)
                        card:setRotation(rotate)
                        self.scene:addChild(card,CARDS_ZORDER+x)
                        table.insert(othercards,card)
                    end
                    if isOpen then
                        self:setComplete(viewSeat,true)
                        self:setPeipai(viewSeat,false)
                        self:setGameState(realSeat,2)
                    else
                        self:setComplete(viewSeat,false)
                        self:setPeipai(viewSeat,true)
                        self:setGameState(realSeat,1)
                    end 
                end
            end
        end
    else   --恢复比牌场景
        --比牌场景牌位置 牌型
        local n = {3,5,5}
        for i = 1,MAX_PALYER do
            local realSeat = self:getRealSeat(i)
            if self:isValidSeat(realSeat) then
                --恢复牌
                comCards[i] = {}
                local cPos = getPosCompareCardEx(i)
                local posx = cPos.x
                local posy = cPos.y
                for j = 1,#n do
                    for k = 1,n[j] do
                        local index = 1
                        if j == 2 then
                            index = 4
                        elseif j == 3 then
                            index = 9
                        end
                        local data = msg.playerinfos[realSeat].after_cards[index + k - 1]
                        local frame = createCard(get_card_color(data),logic.get_card_value(data))
                        local sprite = display.newSprite(frame)

                        local core = math.ceil( n[j] / 2 )
                        local spacing = 0
                        if j == 1 or j == 2 then
                            spacing = 40
                        elseif j == 3 then
                            spacing = 50
                        end
                        sprite:pos(posx + (k - core) * spacing,  posy - j * 50)
                        sprite:scale(0.66)
                        self.scene:addChild(sprite)
                        table.insert(comCards[i],sprite)
                    end
                end

                --恢复牌型


                --总水数 废弃
                local label_all = cc.ui.UILabel.new({
                    color = cc.c3b(26,193,189), 
                    size = 30, 
                    text = tostring(msg.playerinfos[realSeat].total_shui_cnt), 
                })
                :addTo(self.scene)
                :setAnchorPoint(cc.p(0.5, 0.5))
                :setPosition(posx + 160,posy - 140)
                label_all.count = 0
                allResult[i] = label_all
                label_all:hide()
            end
        end
    end
end

function SSSScene:clearCards()
    --frameWidth = nil
    --frameHeight = nil

    mycards = nil
    othercards = nil
    selectedCards = {}

    comCards = {}
    if self.chandle then
        scheduler.unscheduleGlobal(self.chandle)
        self.chandle = nil
        comIndex = 1
    end

    daoResult = {}
    allResult = {}
    typeResult = {}
    typeBG = {}

    spriteKillAll = nil
    insertCard = {
        [1] = {},
        [2] = {},
        [3] = {}
    }
    daoResult = {}
    allResult = {}
    typeResult = {}
    typeBG = {}
    allDatas = nil
    btns_free = {}
    btns_auto = {}
    img_light = {}

    --清除按钮上的子物体
    for i=1,3 do
       for j=1,#showCards[i] do
        showCards[i][j]:removeFromParent()
      end
    end  
    showCards = 
    { 
    [1] ={},
    [2] ={},
    [3] ={}
    }
    for _,v in pairs(comCardsTypeImg) do
        for _,c in pairs(v) do
            c:removeFromParent()
        end
    end
    comCardsTypeImg = {}

   
    for i=1,#allCards do
       allCards[i]:removeFromParent()
    end
    allCards ={}

    self.card_types_auto = nil
end

function SSSScene:restartCards()
    mycards = {}
    othercards = {}
    insertCard = {
        [1] = {},
        [2] = {},
        [3] = {}
    }
    for _,v in pairs(comCards) do
        for _,c in pairs(v) do
            c:removeFromParent()
        end
    end
    comCards = {}
    comIndex = 1
    for _,v in pairs(daoResult) do
        v:removeFromParent()
    end
    daoResult = {}
    for _,v in pairs(allResult) do
        v:removeFromParent()
    end
    allResult = {}
    for _,v in pairs(typeResult) do
        v:removeFromParent()
    end
    typeResult = {}
    for _,v in pairs(typeBG) do
        v:removeFromParent()
    end
    typeBG = {}
    allDatas = nil

    for k,v in pairs(img_light) do
        v:removeFromParent()
    end
    img_light = {}
     --清除按钮上的子物体
    for i=1,3 do
       for j=1,#showCards[i] do
        if showCards[i][j] then
           showCards[i][j]:removeFromParent()
        end
        
      end
    end  
    showCards = 
    { 
    [1] ={},
    [2] ={},
    [3] ={}
    }
    for _,v in pairs(comCardsTypeImg) do
        for _,c in pairs(v) do
            c:removeFromParent()
        end
    end
    comCardsTypeImg = {}

   
    for i=1,#allCards do
       allCards[i]:removeFromParent()
    end
    allCards ={}



    self:initSelectBtnState()
    self.card_types_auto = nil
end

return SSSScene