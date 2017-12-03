local CardTestScene = class("CardTestScene", function ()
    return display.newScene("CardTestScene")
end)

local CardLayer = require("app.layers.CardLayer")

function CardTestScene:ctor()

end

function CardTestScene:showCard(  )
	app:createView("Card", {num = 3, color = 2})
   	:pos(display.cx - 300, display.cy)
    :addTo(self)
end

function CardTestScene:showCards(  )
	local cards = {
		{num = 5, color = 4},{num = 5, color = 5}
	}
	CardLayer.new(cards):addTo(self):pos(255,display.height - 638)
end

function CardTestScene:onEnter()
   self:showCards()
end

return CardTestScene
