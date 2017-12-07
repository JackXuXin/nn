--
-- Author: peter
-- Date: 2017-04-21 16:28:16
--

local ACTION_PATH = {
	{"Image/WRNN/duang/Flame/Flame.plist","Image/WRNN/duang/Flame/Flame.pvr.ccz"},
}

local gameScene = nil

local WRNN_ActionMgr = {}

function WRNN_ActionMgr:init(scene)
	gameScene = scene

	for index,path in ipairs(ACTION_PATH) do
		display.addSpriteFrames(path[1],path[2])
	end
end

function WRNN_ActionMgr:clear()
	for index,path in ipairs(ACTION_PATH) do
		display.removeSpriteFramesWithFile(path[1],path[2])
	end
end

return WRNN_ActionMgr