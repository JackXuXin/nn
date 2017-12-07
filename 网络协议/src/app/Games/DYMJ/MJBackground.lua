local MJBackground = class("MJBackground",function()
    return display.newSprite()
end)

function MJBackground:ctor()
    display.newSprite("ShYMJ/DYResult/game_bg.png")
    :pos(display.cx, display.cy)
    :addTo(self)
    
    -- shymjIcon = display.newSprite("ShYMJ/img_GameUI_Bg_ycmj.png")
    -- :pos(display.cx, display.cy + 34)
    -- :addTo(self)
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