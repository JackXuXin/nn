local ResourceController = class("ResourceController", function ()
    return {}
end)

function ResourceController:ctor(  )
	self.loadedResource = {}
end

function ResourceController:loadPlist(path, name)
	if self.loadedResource[path..name] == nil then
		display.addSpriteFrames(path.."/"..name..".plist", path.."/"..name..".png")
		self.loadedResource[path..name] = true
	end
end

function ResourceController:getAnimation( name, count, internal )
	local animate = display.getAnimationCache(name)
	if animate == nil then
		local frames = display.newFrames(name.."_%d.png", 1,count)
		animate = display.newAnimation(frames, internal == nil and 0.2 or internal)
		display.setAnimationCache(name, animate)
	end
	return animate
end

return ResourceController:new()