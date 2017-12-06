local MJFlower = class("MJFlower",function()
    return display.newSprite()
end)

local FlowerTab={}
FlowerTab.ListView={}
FlowerTab.Card={}
local FlowerLayer

local ShowFlowerBtn
local HideFlowerBtn

function MJFlower:ctor()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_Hua.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 23, 35))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_Hua.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX_Hua.png")
    for i = 1, 3 do
        for j = 1, 4 do
            if i == 1 and j < 4 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 4*16+4+j))
            elseif i == 2 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+j))
            elseif i == 3 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+4+j))
            end
        end
    end
    --花牌显示按钮
    ShowFlowerBtn=cc.ui.UIPushButton.new({ normal = "ShYMJ/button_kaishi_normal.png", pressed = "ShYMJ/button_kaishi_selected.png" })
    :onButtonClicked(function()
            self:ShowFlowerLayer()
     end)
    :pos(display.left+100, display.top - 100)
    :addTo(self)

    HideFlowerBtn=cc.ui.UIPushButton.new({ normal = "ShYMJ/button_kaishi_normal.png", pressed = "ShYMJ/button_kaishi_selected.png" })
    :onButtonClicked(function()
            self:HideFlowerLayer()
     end)
    :hide()
    :pos(display.left+100, display.top - 100)
    :addTo(self)

    --初始化花排列表
    self:FlowerLayer()


    -- local FlowerView=display.newSprite()

end
--初始化花牌列表
function MJFlower:FlowerLayer()
    --花牌layer的根节点
    FlowerLayer = display.newSprite()
    :hide()
    :pos(display.left+100,display.top + 300)
    :addTo(self)

    for i=1,4 do
        FlowerTab.ListView[i]=nil
        FlowerTab.ListView[i]=cc.ui.UIListView.new({
     　　direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
     　　alignment = cc.ui.UIListView.ALIGNMENT_LEFT,
     　　viewRect = cc.rect(0,0,bg:getContentSize().width - 28, bg:getContentSize().height-88),
        })
        :pos()
        :addTo(FlowerLayer)
    end
    
end
function MJFlower:SwitchButton()

end
--花排列表的出现显示动作
function MJFlower:ShowFlowerLayer()

    ShowFlowerBtn:hide()
    HideFlowerBtn:show()
    local imgBg = ccui.ImageView:create()
    local  action = cc.MoveTo:create(0.4, cc.p(687, 360))

    transition.execute(FlowerLayer, action, {
        easing = "sineIn",
        onComplete = function()
            print("move FlowerLayer")
        end,
    })
    imgBg:setScale9Enabled(true)
    imgBg:setContentSize(697,720)
    imgBg:setAnchorPoint(0,0.5)
    imgBg:setPosition(0,360)
    imgBg:setTouchEnabled(true)

    FlowerLayer:setLocalZOrder(2)


    imgBg:addTouchEventListener(function (sender,eventType)

        if eventType == ccui.TouchEventType.ended then

            self:HideFlowerLayer() 
            if imgBg~=nil then
                    
                imgBg:removeFromParent()
                imgBg=nil
            end

        end
    end)


    
end
function MJFlower:HideFlowerLayer()
    ShowFlowerBtn:show()
    HideFlowerBtn:hide()

    local  action1 = cc.MoveTo:create(0.3, cc.p(1280, 360))
    transition.execute(FlowerLayer, action1, {
        easing = "sineInOut",
        onComplete = function()
        print("move FlowerLayer--")  
    end})
end

function MJFlower:addName(name,seat)

end

function MJFlower:addFlower(card,seat)
    

    local count = #FlowerTab.Card
    local sprite = display.newSprite("#ShYMJ/img_spe_paichiSX_Hua.png")
    display.newSprite(string.format("#ShYMJ/img_cardvaluePaichiSX_Hua%d.png", card))
    :pos(12, 23)
    :addTo(sprite)
    table.insert(FlowerTab.Card[seat], count+1, {val=card, sprite=sprite})


    local margin = {top = 0,bottom = 0,left = 0,right = 0}
    local listItem = FlowerTab.ListView[seat]:newItem(sprite)
    listItem:setMargin(margin) --设置间隔 
    listItem:setItemSize(sprite:getContentSize().width, sprite:getContentSize().height)
end

function MJFlower:clear()

    FlowerTab={}
    FlowerLayer=nil
end

function MJFlower:restart()
    FlowerTab={}
    for i=1,4 do
        FlowerTab.ListView[i]:removeAllItems()
    end
end

function MJFlower:init(callback)
    self.callBack = callback
    return self
end

return MJFlower