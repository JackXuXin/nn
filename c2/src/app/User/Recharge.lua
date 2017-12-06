local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}

local UserMessage = require("app.net.UserMessage")
local util = require("app.Common.util")
local RadioButtonGroup = require("app.Common.RadioButtonGroup")
local ProgressLayer = require("app.layers.ProgressLayer")
local ErrorLayer = require("app.layers.ErrorLayer")
local web = require("app.net.web")
local crypt = require("crypt")
local scheduler = require("framework.scheduler")
local PreloadRes = require("app.config.PreloadRes")

local sound_common = require("app.Common.sound_common")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local PlatConfig = require("app.config.PlatformConfig")

local Player = app.userdata.Player


local Goods = app.userdata.Goods
local Account = app.userdata.Account

local opened = false
local geted = false
local productType = { [1] = "gold", [2] = "diamond" }
local curProductType = 2


local progressLayer
local queryHandler
local queryHandlerEx
local queryHandlerStart
local isCanQuery = true

local function closeProgressLayer()
    if not progressLayer then
        return
    end
    ProgressLayer.removeProgressLayer(progressLayer)
    progressLayer = nil
end

local function addProgressLayer(parent, text)
    if progressLayer then
        closeProgressLayer()
    end
    local f
    if text then
        f = function() 
            ErrorLayer.new(text):addTo(parent)
        end
    else
        f = function() end
    end
    progressLayer = ProgressLayer.new(app.lang.call_recharge_loading, app.constant.network_loading, f):addTo(parent)
end

local function addProgressLayer_iap(parent, text)
    if progressLayer then
        closeProgressLayer()
    end
    local f
    if text then
        f = function() 
            ErrorLayer.new(text):addTo(parent)
        end
    else
        f = function() end
    end
    progressLayer = ProgressLayer.new(app.lang.call_recharge_loading, -1, f):addTo(parent)
end

local function startQueryOrder(func)
    if queryHandler then
        return
    end
    queryHandler = scheduler.scheduleGlobal(func, 2)
end

local function endQueryOrder()
    if not queryHandler then
        return
    end
    scheduler.unscheduleGlobal(queryHandler)
    queryHandler = nil
end

local function startQueryOrderEx(func)
    if queryHandlerEx then
        return
    end
    queryHandlerEx = scheduler.scheduleGlobal(func, 420)
end

local function endQueryOrderEx()
    if not queryHandlerEx then
        return
    end
    print("end--order----")
    scheduler.unscheduleGlobal(queryHandlerEx)
    queryHandlerEx = nil
end

local function reStartQueryOrder(func)
    if queryHandlerStart then
        return
    end
    queryHandlerStart = scheduler.scheduleGlobal(func, 300)
end

local function endReStartQueryOrder()
    if not queryHandlerStart then
        return
    end
    print("end--order----")
    scheduler.unscheduleGlobal(queryHandlerStart)
    queryHandlerStart = nil
end

function LobbyScene:showRecharge(event)
    sound_common.menu()
    local rechargeLayer = cc.uiloader:load("Layer/Lobby/RechargeLayer.json"):addTo(self)
    self.scene.rechargeLayer = rechargeLayer

--打开支付时，发起一次订单检测，七分钟内再次打开界面不会发送
    if isCanQuery == true then
        --print("query--order----")
        self:checkOrder()
        startQueryOrderEx(
        function ()
            --print("can-query-order---")
            endQueryOrderEx()
            isCanQuery = true
        end)
        isCanQuery = false
    end

    print("button.type:",event.target:getTag())
    curProductType = event.target:getTag()

    local Panel_bond1 = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Panel_bond1")
    local Panel_bond2 = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Panel_bond2")
    Panel_bond1:hide()
    Panel_bond2:hide()

    local close = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Close")
        :onButtonClicked(function ()
            sound_common.cancel()
            rechargeLayer:removeFromParent()
            self.scene.rechargeLayer = nil
            opened = false
            geted = false
        end)

    util.BtnScaleFun(close)

    local popBoxNode = cc.uiloader:seekNodeByNameFast(rechargeLayer, "PopBoxNode")
    popBoxNode:setScale(0.8)
    transition.scaleTo(popBoxNode, {
        scale = 1, 
        time = app.constant.lobby_popbox_trasition_time,
        onComplete = function ()
            opened = true
            
            ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
            :addTo(self,nil,2188)
            if geted then
                local progressLayer = self:getChildByTag(2188)
                if progressLayer then
                    ProgressLayer.removeProgressLayer(progressLayer)
                end
                self:showChannelsList()
            end
        end
    })

    self:getGoodsList()
end

function LobbyScene:getGoodsList()
	local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/recharge/goodslist?platform="
		..device.platform.."&version="..util.getVersion().."&app_channel="..CONFIG_APP_CHANNEL
    -- local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/recharge/goodslist?platform="
    --     .."ios".."&version="..util.getVersion().."&app_channel="..CONFIG_APP_CHANNEL
    print("GoodsListurl:"..url)
    local request = network.createHTTPRequest(function (event)
        local result = web.checkResponse(event)
        print("get goods result:"..result)
        if result == 0 then
            return
        elseif result == -1 then
            return
        end

        local response = event.request:getResponseString()
        --print("resp:"..response)

        local goods = json.decode(response)
        dump(goods)
        Goods:init()
        local tmp = {}
        local i = 1
        for _,v in ipairs(goods) do
        	local channel = v.Channel
        	local index = tmp[channel]
        	if not index then
        		tmp[channel] = i
        		index = i
        		Goods.list[channel] = {}
        		Goods.channels[index] = channel
        		i = i + 1
        	end

        	local list = Goods.list[channel]
        	table.insert(list, v)
        end

        geted = true
        local progressLayer = self:getChildByTag(2188)
        if progressLayer then
            ProgressLayer.removeProgressLayer(progressLayer)
        end
        if opened then
            self:showChannelsList()
        end

    end, url, "GET")

    request:start()
end

function LobbyScene:showChargeProduct(checkbox)

    local rechargeLayer = self.scene.rechargeLayer
    if not rechargeLayer or not checkbox or not checkbox.index then
        return
    end

    local index = checkbox.index
    print("showChargeProduct:", index)

    curProductType = index

    if rechargeLayer.group ~= nil then

        local curSelectBtn = rechargeLayer.group:getSelected()

        self:showGoodsList(curSelectBtn)

    end

end

function LobbyScene:showChannelsList()
	local rechargeLayer = self.scene.rechargeLayer
	if not rechargeLayer then
		return
	end

    --temp
    -- table.insert(Goods.channels,"alipay")

    dump(Goods.channels)
	local channelList = cc.uiloader:seekNodeByNameFast(rechargeLayer, "ChannelList")

	local list = self.scene.accountList
    channelList:getScrollNode():removeAllChildren()

    local x = channelList:getCascadeBoundingBox().width / 2
    local height = channelList:getCascadeBoundingBox().height
    print("recharge x:" .. x,"height:" .. height)
    local firstButton
    local title = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Image_Title")
    rechargeLayer.group = RadioButtonGroup.new()

    local cnt_goods = 0
    for i,v in ipairs(Goods.channels) do
    	local selected, unselected
    	if v == "weixin" then
            if Account.tags.recharge_tag == "1" then
                unselected = "Image/Pay/Button_weixin_0.png"
                selected = "Image/Pay/Button_weixin_1.png"
            end
        elseif v == "alipay" and device.platform  ~= "ios" then
            if Account.tags.recharge_tag == "1" then
                unselected = "Image/Pay/Button_zhifubao_0.png"
                selected = "Image/Pay/Button_zhifubao_1.png"
            end
        elseif v == "apple" and CONFIG_APP_CHANNEL ~= "3554" then
                unselected = "Image/Pay/Button_ApplePay_0.png"
                selected = "Image/Pay/Button_ApplePay_1.png"
    	end

        if selected and unselected then
            cnt_goods = cnt_goods + 1
            local checkbox = cc.ui.UICheckBoxButton.new({
                off = unselected,
                off_pressed = selected,
                off_disabled = unselected,
                on = {selected, selected},
                on_pressed = {unselected, selected},
                on_disabled = {unselected, unselected},
            })
            checkbox:addTo(channelList:getScrollNode())
            checkbox:setPosition(x, height - 72 - (cnt_goods - 1) * 83)
            checkbox.channel = v

            -- if i == 3 then
            --     rechargeLayer.group:addButtons({
            --         [checkbox] = handler(self, self.showInBrowser)
            --     })
            -- else
                rechargeLayer.group:addButtons({
                    [checkbox] = handler(self, self.showGoodsList)
                })
            -- end

        	if cnt_goods == 1 then
                firstButton = checkbox
        	end

        end
    end

    local lineNum = cnt_goods
  
    for i = 1,4 do

        local line = cc.uiloader:seekNodeByNameFast(rechargeLayer, "img_Rline_" .. i)
        if i<= lineNum+1 then
             if line ~= nil then
                 line:show()
             end
        else
            if line ~= nil then
                line:hide()
            end
        end

    end

    if firstButton then
        firstButton:setButtonSelected(true)
    end
end
--
function LobbyScene:generalizeClick(button)
    if Player.supid ~= -1 then
        self:BindingSucceed()
        return
    end
    local rechargeLayer = self.scene.rechargeLayer
    if not rechargeLayer or not button then
        return
    end

    local popBoxNode = cc.uiloader:seekNodeByNameFast(rechargeLayer, "PopBoxNode")
    if rechargeLayer.goodsList then
        rechargeLayer.goodsList:removeFromParent()
        rechargeLayer.goodsList = nil
    end
    --隐藏标题
    local title = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Image_Title")
    title:hide()

    

    local generalize_RootNode = display.newNode()
    :addTo(popBoxNode)

    rechargeLayer.goodsList = generalize_RootNode

    local title_Bg = display.newSprite("Image/Pay/title_Bg.png")
    :setPosition(20,275)
    :addTo(generalize_RootNode)

    local title_sp = display.newSprite("Image/Pay/Binding_title.png")
    :setPosition(331/2,50)
    :addTo(title_Bg)

    local generalize_beijing = display.newScale9Sprite("Image/Pay/beijing.png", 0, 0, cc.size(600, 500),purpose)
        :setPosition(118,-43)
        :addTo(generalize_RootNode)

    local generalize_BG = display.newSprite("Image/Pay/generalize_BG.png")
    :setPosition(118,50)
    :addTo(generalize_RootNode)

    local generalize_01 = display.newSprite("Image/Pay/generalize_01.png")
    :setPosition(34,0)
    :addTo(generalize_RootNode)

    --输入框节点
    local input_node = display.newNode()
    :setPosition(170,21)
    :addTo(generalize_01)
    

    local input = util.createInput(input_node, {maxLength = 10,
                        fontSize = 20,
                        size = cc.size(234,39),
                    }
                        )
    --获取昵称按钮
    local Button_GetName = cc.ui.UIPushButton.new({ normal = "Image/HonorLayer/getname_0.png", pressed = "Image/HonorLayer/getname_1.png" })
    :onButtonClicked(function()
        local userid = input:getString()
        print("userid:"..userid)

        local id = math.floor(checknumber(input:getString()))
        if id == 0 then
            ErrorLayer.new(app.lang.give_gold_nickname_nil, nil, nil, nil):addTo(self)
        elseif id == Player.uid then
            ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
        else
            ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                :addTo(self,nil,3462)
            UserMessage.UserInfoRequest(id)
        end
     end)
    :pos(330, 0)
    :setScale(0.8)
    :addTo(generalize_RootNode)

    local generalize_02 = display.newSprite("Image/Pay/generalize_02.png")
    :setPosition(-100,-60)
    :addTo(generalize_RootNode)

    local text_name = cc.ui.UILabel.new({
            text = "", 
            size = 30, 
            color = cc.c3b(75,22,3)
            })
        :addTo(generalize_RootNode)
        :setAnchorPoint(0,0.5)
        :setPosition(5,-60)

    self.scene.rechargeLayer.text_nickname = text_name
    --绑定按钮
    local Button_Binding = cc.ui.UIPushButton.new({ normal = "Image/Pay/Binding_Btn1.png", pressed = "Image/Pay/Binding_Btn2.png" })
    :onButtonClicked(function()
        local userid = input:getString()
        print("userid:"..userid)
        --send request

        if self.scene.rechargeLayer.text_nickname:getString() == "" then
            ErrorLayer.new(app.lang.give_gold_nickname_error, nil, nil, nil):addTo(self)
            return
        end

        local id = math.floor(checknumber(input:getString()))
        if id == 0 then
            ErrorLayer.new(app.lang.give_gold_nickname_nil, nil, nil, nil):addTo(self)
        elseif id == Player.uid then
            ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
        else
            ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                :addTo(self,nil,3463)
            self.bindId = id
            UserMessage.BindUserReq(id)
        end
     end)
    :pos(130, -210)
    :addTo(generalize_RootNode) 
    

end

function LobbyScene:BindingSucceed()
    local rechargeLayer = self.scene.rechargeLayer
    if not rechargeLayer  then
        return
    end

    local popBoxNode = cc.uiloader:seekNodeByNameFast(rechargeLayer, "PopBoxNode")
    if rechargeLayer.goodsList then
        rechargeLayer.goodsList:removeFromParent()
        rechargeLayer.goodsList = nil
    end
    --隐藏标题
    local title = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Image_Title")
    title:hide()

    local generalize_RootNode = display.newNode()
    :addTo(popBoxNode)

    rechargeLayer.goodsList = generalize_RootNode

    local title_Bg = display.newSprite("Image/Pay/title_Bg.png")
    :setPosition(20,275)
    :addTo(generalize_RootNode)

    local title_sp = display.newSprite("Image/Pay/Binding_title.png")
    :setPosition(331/2,50)
    :addTo(title_Bg)

    local generalize_beijing = display.newScale9Sprite("Image/Pay/beijing.png", 0, 0, cc.size(600, 500),purpose)
        :setPosition(118,-43)
        :addTo(generalize_RootNode)

    local generalize_BG = display.newSprite("Image/Pay/generalize_BG.png")
    :setPosition(118,50)
    :addTo(generalize_RootNode)

    local generalize_01 = display.newSprite("Image/Pay/generalize_01.png")
    :setPosition(110,0)
    :addTo(generalize_RootNode)

    local text_name = cc.ui.UILabel.new({
            text = "", 
            size = 30, 
            color = cc.c3b(75,22,3)
            })
        :addTo(generalize_RootNode)
        :setAnchorPoint(0.5,0.5)
        :setPosition(190,0)

    
    if Player.supid == -2 then
        text_name:setString(app.lang.bind_topest)
        
    else
        text_name:setString(tostring(Player.supid))
        
    end
    
end

function LobbyScene:showInBrowser(button)
    local url = "http://pay.wangwang68.com/"
    device.openURL(url)
end

function LobbyScene:showGoodsList(button)
	local rechargeLayer = self.scene.rechargeLayer
	if not rechargeLayer or not button or not button.channel then
		return
	end

    local channel = button.channel

    local popBoxNode = cc.uiloader:seekNodeByNameFast(rechargeLayer, "PopBoxNode")
    if rechargeLayer.goodsList then
        rechargeLayer.goodsList:removeFromParent()
        rechargeLayer.goodsList = nil
    end

    print("channel:" .. channel)
    -- if channel == "alipay" then
    --     self:showWebGoods(popBoxNode)
    --     return
    -- end
    --显示标题
    local title = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Image_Title")
    title:show()

    local goodsList = cc.ui.UIScrollView.new({ 
        --viewRect = cc.rect(-185, -293, 607, 497),
        viewRect = cc.rect(-378, -333, 968, 580),
        bgColor = cc.c4b(255,255,255,0),
        --bg = "Image/Pay/goods_bg.png",
    })
    goodsList:addTo(popBoxNode)
    goodsList:setDirection(1)
    goodsList:setBounceable(false)
    rechargeLayer.goodsList = goodsList

    local Panel_bond1 = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Panel_bond1")
    local Panel_bond2 = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Panel_bond2")
    Panel_bond1:hide()
    Panel_bond2:hide()

    local emptyNode = cc.Node:create()
    --emptyNode:setPosition(-185, -293)
    --emptyNode:setContentSize(585, 490)
    emptyNode:setPosition(-378, -333)
    emptyNode:setContentSize(968, 580)
    goodsList:addScrollNode(emptyNode)


	local list = self.scene.accountList

    local x = 100
    local height = goodsList:getCascadeBoundingBox().height - 0
   
    local goods = Goods.list[channel]
   -- dump(goods)
    --local pType = "gold"
    local index = 0
    for i,v in ipairs(goods) do

        if  v.Type == productType[curProductType] then

            index = index + 1

            local pbI = i

            if curProductType == 2 then

                pbI = index

            end

            --local bg = display.newScale9Sprite("Image/Pay/beijing.png", 100 + math.mod(pbI - 1,3) * (177+25), height - math.floor((pbI - 1) / 3) * (234+20))
            local bg = display.newScale9Sprite("Image/Pay/beijing.png", 112 + math.mod(pbI - 1,4) * (204+45), height - math.floor((pbI - 1) / 4) * (270+30))
            :addTo(emptyNode)
            bg:setAnchorPoint(0.5,1)

            local contentSize = bg:getContentSize()

            local isShowGold = false
            local isShowVip = false

            --v.ExtraType = "diamond"
            --v.ExtraVal = 20

            if v.ExtraType ~= nil then

              if v.ExtraType=="gold" and v.ExtraVal>0 then
                
                isShowGold = true

               elseif v.ExtraType=="vip1" and v.ExtraVal>0 then

                isShowVip = true

                elseif v.ExtraType=="diamond" and v.ExtraVal>0 then
                
                isShowGold = true

               end
            end

            local nameStr = i
            local btnStr = i
            local nameGift = ""
            if v.Val ~= nil then
                nameGift = "多送" .. tostring(v.ExtraVal * v.Val / 100 / 10000) .. "万"
            else
                nameGift = "多送" .. tostring(v.ExtraVal * v.Gold / 100 / 10000) .. "万"
            end
-- 如果是钻石
            if curProductType == 2 then

                nameStr = curProductType .. index
                btnStr = curProductType .. index
                nameGift = "多送" .. tostring(math.ceil(v.ExtraVal * v.Val/100)) .. "个"
            end

           -- and v.Channel == "apple"
             -- if v.Id == "wwcx_good_3" or v.Id == "wwyy_good_3" or v.Id == "wwsx_good_2" or v.Id =="jnjmj_goods_3" or v.Id =="hhsz_goods_2" then
             --     nameStr = 12
             -- elseif v.Id == "wwcx_good_2" or v.Id == "wwyy_good_2" or v.Id == "wwsx_good_1" or v.Id == "jnjmj_goods_2" or v.Id =="hhsz_goods_1"then
             --     nameStr = 31
             -- end

             if v.Channel == "apple" then

                if nameStr == "21" or nameStr == "22" then

                    display.newScale9Sprite("Image/Pay/item/context_" .. nameStr .."_0.png")
                    :addTo(bg):setPosition(108,106)
                    :setAnchorPoint(0.5, 0)
                     btnStr = btnStr .. "0"

                else

                    display.newScale9Sprite("Image/Pay/item/context_" .. nameStr ..".png")
                    :addTo(bg):setPosition(108,106)
                    :setAnchorPoint(0.5, 0)

                end

             else

                display.newScale9Sprite("Image/Pay/item/context_" .. nameStr ..".png")
                :addTo(bg):setPosition(108,106)
                :setAnchorPoint(0.5, 0)

             end

            local gold_bg = display.newScale9Sprite("Image/Pay/item/img_GoldNum.png")
            :addTo(bg):setPosition(102,91)
            local text = cc.ui.UILabel.new({color=cc.c3b(255,208,58), size=20, text=string.format("%d个钻石", v.Val), align=cc.ui.TEXT_ALIGN_CENTER})
            text:setAnchorPoint(0.5,0.5)
            :pos(102,90)
            :addTo(bg)
            local buy_btn = cc.ui.UIPushButton.new({ normal = "Image/Pay/item/btn_" .. btnStr .. ".png", pressed = "Image/Pay/item/btn_" .. btnStr .. ".png" })
            :onButtonClicked(function()
                local gs = Goods.list[channel][i]
                 dump(gs,"gs = ")
                 local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
                 --if gs and (device.platform == "android" or device.platform == "ios") then
                 if gs then

                        print("platConfig.isAppStore = ",platConfig.isAppStore)
                        self:recharge(gs)
                        -- if Player.supid ~= -1 then
                        --     self:recharge(gs)
                        -- else
                        --     if platConfig.isAppStore == false then
                        --         self:turnBindMenu(1, gs)
                        --     else
                        --         self:recharge(gs)
                        --     end
                        -- end
                       -- self:recharge(gs)
                 end
             end)
            :pos(103,39)
            :addTo(bg)
            util.BtnScaleFun(buy_btn)

            if Player.supid ~= -1 and (isShowGold or isShowVip) then

                local b = display.newScale9Sprite("Image/Pay/item/add_bg.png")
                :addTo(bg):setPosition(104,231)
               -- b:setFlippedY(true)

                local str
                if isShowGold then
                    str = nameGift
                else
                    str = "送" .. tostring(v.ExtraVal) .. "天会员"
                end

                local textAdd = display.newTTFLabel({
                    text = str,
                    color = cc.c3b(0xFF, 0xFF, 0xFF),
                    size = 20,
                    valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
                    x = 104,
                    y = 237,
                })
                :addTo(bg)
                textAdd:setAnchorPoint(0.5,0.5)
                
            end

        end

    end
end

function LobbyScene:turnBindMenu(Ttype, curSelectProduct)
    local rechargeLayer = self.scene.rechargeLayer
    if rechargeLayer == nil then
        return
    end

    local Panel_bond1 = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Panel_bond1")
    local Panel_bond2 = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Panel_bond2")

    if Ttype == 1 then

        rechargeLayer.goodsList:hide()

        local Text_Money = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Text_Money")
        local Text_DamNum = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Text_DamNum")
        local Text_AddNum = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Text_AddNum")
        local Button_NowBond = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Button_NowBond")
        local Button_NowBuy = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Button_NowBuy")

        Button_NowBond:onButtonClicked(
            function()
                self:turnBindMenu(2, curSelectProduct)
             end)
       Button_NowBuy:onButtonClicked(
            function()
                self:recharge(curSelectProduct)
             end)

        util.BtnScaleFun(Button_NowBond)
        util.BtnScaleFun(Button_NowBuy)

        if curSelectProduct ~= nil then

            local money = "￥" .. curSelectProduct.Money/100 .. "="

            Text_Money:setString(money)
            Text_DamNum:setString(tostring(curSelectProduct.Val))
            Text_AddNum:setString(tostring(math.ceil(curSelectProduct.ExtraVal * curSelectProduct.Val/100)))

        end

        Panel_bond1:show()
        Panel_bond2:hide()

    elseif Ttype == 2 then

        local Button_RtoB = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Button_RtoB")
        local Button_Bind = cc.uiloader:seekNodeByNameFast(rechargeLayer, "Button_Bind")
        local RequestInputPanel = cc.uiloader:seekNodeByNameFast(rechargeLayer, "RequestInputPanel")
        local RequestInput = util.createInput(RequestInputPanel, { color = cc.c4b(255,255,255, 255), mode = cc.EDITBOX_INPUT_MODE_NUMERIC })


        Button_RtoB:onButtonClicked(
            function()
                self:turnBindMenu(3, curSelectProduct)
             end)
       Button_Bind:onButtonClicked(
            function()

                local bondid = RequestInput:getString()
                print("bondid:"..bondid)

                local id = math.floor(checknumber(bondid))
                if id == 0 then
                    ErrorLayer.new(app.lang.bind_error_null, nil, nil, nil):addTo(self)
                elseif id == Player.uid then
                    ErrorLayer.new(app.lang.bind_cannot_self, nil, nil, nil):addTo(self)
                else
                    ProgressLayer.new(app.lang.default_loading, nil, nil, nil)
                        :addTo(self,nil,3462)
                    self.bindId = id
                    UserMessage.BindUserReq(id)
                end

            end)

        util.BtnScaleFun(Button_RtoB)
        util.BtnScaleFun(Button_Bind)

       -- rechargeLayer.goodsList:hide()
        Panel_bond1:hide()
        Panel_bond2:show()

    else

        rechargeLayer.goodsList:show()
        Panel_bond1:hide()
        Panel_bond2:hide()

    end

    --


end

function LobbyScene:showWebGoods(parent)
    if device.platform == "android" or device.platform == "ios" then
        local webview = ccexp.WebView:create()
        parent:addChild(webview)
        webview:setVisible(true)
        webview:setScalesPageToFit(true)
        webview:setContentSize(cc.size(607,497)) -- 一定要设置大小才能显示
        webview:reload()
        webview:setAnchorPoint(cc.p(0, 0))
        webview:setPosition(-200, -250)
        local rule = "http://pay.wangwang68.com/"
        webview:loadFile(rule)
    end
end

function LobbyScene:recharge_iap(orderId, goodId)
    addProgressLayer_iap(self, app.lang.recharge_timeout)
    function callback_iap(param)
        local result = param.result or 0
        if result == 0 then

            closeProgressLayer()
            addProgressLayer(self, app.lang.recharge_timeout)
            local counts = 4
            startQueryOrder(function ()
                UserMessage.RechargeReq(orderId)
                counts = counts - 1
                if counts == 0 then
                    endQueryOrder()
                end
            end)

            --UserMessage.RechargeReq(orderId)

            print("recharge_iap----")
           
            --ErrorLayer.new(app.lang.recharge_success):addTo(self)

            -- Player.gold = Player.gold+(goods.Gold + goods.Gold * goods.ExtraVal / 100)

            -- self:moneyChanged()

            -- UserMessage.AddGoldReq(goods.Gold + goods.Gold * goods.ExtraVal / 100)

        else
            closeProgressLayer()
            ErrorLayer.new(app.lang.recharge_cancel):addTo(self)
        end
    end

    local OrderStr = cc.UserDefault:getInstance():getStringForKey("OrderStr")

    print("OrderStr:",OrderStr)

    if OrderStr ~= "" and  OrderStr ~= nil and OrderStr ~= "0" then

       local popbox = nil

       popbox =  MiddlePopBoxLayer.new(app.lang.buyTitle, app.lang.buy_tips,
            MiddlePopBoxLayer.ConfirmTable, true, nil, function ()

            cc.UserDefault:getInstance():setStringForKey("OrderStr", "0")

            popbox:removeFromParent()
            popbox = nil

            local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/recharge/verifyiap"
            local params = {}
            print("goodId11:",goodId)
            local a = string.byte(goodId,-1)
            a = string.char(a)
            print("a:",a)

            params.index = a
            params.callback = callback_iap
            params.url = url
            params.order = orderId
            luaoc.callStaticMethod("RootViewController", "onIAP", params)
                
            end , function()
            
                popbox:removeFromParent()
                popbox = nil   
                closeProgressLayer() 
            end)
        :addTo(self)

        return
    end

    local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/recharge/verifyiap"
    local params = {}
    print("goodId222:",goodId)
    local a = string.byte(goodId,-1)
    a = string.char(a)
    print("a:",a)

    params.index = a
    params.callback = callback_iap
    params.url = url
    params.order = orderId
    luaoc.callStaticMethod("RootViewController", "onIAP", params)
    --iap
    --dump(goods)
   
end

function LobbyScene:recharge(goods)
    addProgressLayer(self, app.lang.network_disabled)

    web.getServerTime(function (time)
        if time <= 0 then
            return
        end

        params = {
            uid = Account.uid,
            goods_id = goods.Id,
        }

        print("uid:"..Account.uid..",goodsid:"..goods.Id)

        local msg = json.encode(params)
        dump(msg)
        msg = crypt.my_encode(time, msg)
        msg = util.tohex(msg)

        -- new order
        local request = network.createHTTPRequest(function (event)
            local result = web.checkResponse(event)
            print("recharge result:"..result)
            if result == 0 then
                return
            elseif result == -1 then
                closeProgressLayer()
                ErrorLayer.new(app.lang.recharge_fail):addTo(self)
                return
            end

            local response = event.request:getResponseString()
            print("recharge resp:"..response)
            if not response or response == "" then
                closeProgressLayer()
                ErrorLayer.new(app.lang.recharge_fail):addTo(self)
                return
            end

            response = util.fromhex(response)
            response = crypt.my_decode(time, response)

            local params = json.decode(response)

            self:clientRecharge(params, goods)

        end, "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/recharge/new", "POST")

        request:addPOSTValue("time", time)
        request:addPOSTValue("content", msg)
        request:start()
    end)
end

function LobbyScene:clientRecharge(params, goods)
    -- addProgressLayer(self)
    closeProgressLayer()

    local orderId = params.Id
    
    function callback(param)
        if device.platform == "android" then
            param = json.decode(param)
            if param.result == 1002 then
                param.result = 0
            end
        end

        local result = param.result or 0
        if result == 0 then
            addProgressLayer(self, app.lang.recharge_timeout)
            local counts = 4
            startQueryOrder(function ()
                UserMessage.RechargeReq(orderId)
                counts = counts - 1
                if counts == 0 then
                    endQueryOrder()
                end
            end)
        else
            closeProgressLayer()
            ErrorLayer.new(app.lang.recharge_cancel):addTo(self)
        end
    end

    --5分钟后忽略回调，发起订单查询
    if goods.Channel == "weixin" then

        print("reStartQueryOrder---")
        reStartQueryOrder(
        function ()
            print("endReStartQueryOrder---")
            self:checkOrder()
            endReStartQueryOrder()
        end)

    end 

    if device.platform == "ios" then
        params.callback = callback
        dump(params)
        if goods.Channel == "weixin" then
            luaoc.callStaticMethod("WeixinSDK", "recharge", params)
        elseif goods.Channel == "alipay" then
            --luaoc.callStaticMethod("AliSDK", "recharge", params)
        elseif goods.Channel == "apple" then
            self:recharge_iap(orderId,goods.Id)
            --luaoc.callStaticMethod("RootViewController", "onAlipay", params)
        end 
    elseif device.platform == "android" then
        local str = json.encode(params)
        if goods.Channel == "weixin" then
            luaj.callStaticMethod("app/WeixinSDK", "recharge", { str, callback })
        elseif goods.Channel == "alipay" then
            luaj.callStaticMethod("app/AliSDK", "recharge", { str, callback })
        end
    end
end

function LobbyScene:checkOrder()

    --询问订单结果
    UserMessage.RechargeReq()

    -- local url = "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/recharge/checkOrder?uid="..Account.uid

    -- local request = network.createHTTPRequest(function (event)
    --     local result = web.checkResponse(event)
    --     if result == 0 then
    --         return
    --     elseif result == -1 then
    --         return
    --     end

    --     local response = event.request:getResponseString()
    --     print("checkOrder", response)

    --     UserMessage.RechargeReq()

    -- end, url, "GET")

    -- request:start()
end

function LobbyScene:RechargeRep(msg, oldmsg)
    print("RechargeRep:", msg.result)
    if msg.result > 0 then
        endQueryOrder()
        closeProgressLayer()
        ErrorLayer.new(app.lang.recharge_success):addTo(self)
    end
end

return LobbyScene