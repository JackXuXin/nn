--
-- Author: peter
-- Date: 2017-03-21 13:32:51
--

local ACTION_PATH = {
	{"Image/WL/duang/Bomb/Bomb.plist","Image/WL/duang/Bomb/Bomb.pvr.ccz"},
	{"Image/WL/duang/Flame/Flame.plist","Image/WL/duang/Flame/Flame.pvr.ccz"},
}

local gameScene = nil

local WL_ActionMgr = {}

function WL_ActionMgr:init(scene)
	gameScene = scene

	for index,path in ipairs(ACTION_PATH) do
		display.addSpriteFrames(path[1],path[2])
	end
end

function WL_ActionMgr:clear()
	for index,path in ipairs(ACTION_PATH) do
		display.removeSpriteFramesWithFile(path[1],path[2])
	end
end

--[[
	* 播放炸弹动画
--]]
function WL_ActionMgr:playBombAction()
	local frames = display.newFrames("lord_anim_bomb_frame%d.png", 1, 19)
	local animation = display.newAnimation(frames, 0.05)
	local animate = cc.Animate:create(animation)

	local sprite1 = display.newSprite("#lord_anim_bomb_frame1.png")
	sprite1:setLocalZOrder(1999)
	sprite1:center()
	sprite1:addTo(gameScene.root)

	local callfunc = cc.CallFunc:create(function()
		sprite1:removeFromParent()
	end)

	local sequence = cca.seq({animate,callfunc})
	sprite1:runAction(sequence)

	--音效
	gameScene.WL_Audio.playSoundWithPath(gameScene.WL_Audio.preloadResPath.WL_SOUND_BOOM)
end

return WL_ActionMgr