local MJBackground = class("MJBackground",function()
    return display.newSprite()
end)

function MJBackground:ctor()
    -- display.newSprite("ShYMJ/img_GameUI_Bottom.png")
    -- :pos(display.cx, display.cy)
    -- :addTo(self)
    -- --背景图标
    -- shymjIcon = display.newSprite("ShYMJ/img_GameUI_Bg_HShMJ.png")
    -- :pos(display.cx, display.cy + 34)
    -- :addTo(self)

    display.newSprite("ShYMJ/NJResult/game_bg.png")
    :pos(display.cx, display.cy)
    :addTo(self)
end

function MJBackground:setMajiang(key)
	
end

function MJBackground:clear()
	shzhmjIcon = nil
	shymjIcon = nil
end

function MJBackground:restart()
end

function MJBackground:init(callback)
    self.callBack = callback
    return self
end

return MJBackground