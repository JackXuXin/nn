
local SysinfoLayer = class("SysinfoLayer", function(layerFile)
    return cc.uiloader:load(layerFile)
end)

function SysinfoLayer:ctor(_,param)
	self.time = cc.uiloader:seekNodeByNameFast(self, "time")
	self.time:setString(os.date("%H:%M", os.time()))
	self:startTick()
end

function SysinfoLayer:startTick(  )
	if not self.timeStart then
        self:schedule(handler(self, self.tick), 1)
        self.timeStart = true
    end
end

function SysinfoLayer:tick(  )
	self.time:setString(os.date("%H:%M", os.time()))
end


return SysinfoLayer
