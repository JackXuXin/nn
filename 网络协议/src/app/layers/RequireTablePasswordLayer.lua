local RequireTablePasswordLayer = class("RequireTablePasswordLayer", function ()
    return cc.uiloader:load("Layer/Game/RequireTablePasswordLayer.json")
end)

local sound_common = require("app.Common.sound_common")

function RequireTablePasswordLayer:ctor(confirmCallback)
    print("type of confirmCallback:", type(confirmCallback))
    local node = cc.uiloader:seekNodeByNameFast(self, "Node")

    local close = function ()
        self:removeFromParent()
        sound_common.cancel()
    end

    cc.uiloader:seekNodeByNameFast(self, "Close"):onButtonClicked(close)
    cc.uiloader:seekNodeByNameFast(self, "Cancel"):onButtonClicked(close)

    local pwdInput = cc.uiloader:seekNodeByNameFast(self, "Pwd_Input")
    assert(pwdInput)

    local confirm = cc.uiloader:seekNodeByNameFast(self, "Confirm")
    confirm:onButtonClicked(function()
        if confirmCallback then
            confirmCallback(pwdInput:getString())
        end
        sound_common.confirm()
    end)
end

return RequireTablePasswordLayer