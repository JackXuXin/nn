--
-- Author: peter
-- Date: 2017-03-06 14:32:00
--

local ACTION_PATH = {
	{"Image/SRDDZ/duang/Bomb/Bomb.plist","Image/SRDDZ/duang/Bomb/Bomb.pvr.ccz"},
	{"Image/SRDDZ/duang/KingBomb/kingBomb_01.plist","Image/SRDDZ/duang/KingBomb/kingBomb_01.pvr.ccz"},
	{"Image/SRDDZ/duang/KingBomb/kingBomb_02.plist","Image/SRDDZ/duang/KingBomb/kingBomb_02.pvr.ccz"},
	{"Image/SRDDZ/duang/KingBomb/kingBomb_03.plist","Image/SRDDZ/duang/KingBomb/kingBomb_03.pvr.ccz"},
	{"Image/SRDDZ/duang/Flame/Flame.plist","Image/SRDDZ/duang/Flame/Flame.pvr.ccz"},
}

local gameScene = nil

local SRDDZ_ActionMgr = {}

function SRDDZ_ActionMgr:init(scene)
	gameScene = scene

	for index,path in ipairs(ACTION_PATH) do
		display.addSpriteFrames(path[1],path[2])
	end
end

function SRDDZ_ActionMgr:clear()
	for index,path in ipairs(ACTION_PATH) do
		display.removeSpriteFramesWithFile(path[1],path[2])
	end
end

--[[
	* 播放炸弹动画
--]]
function SRDDZ_ActionMgr:playBombAction()
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
	gameScene.SRDDZ_Audio.playSoundWithPath(gameScene.SRDDZ_Audio.preloadResPath.SRDDZ_SOUND_BOOM)
	sprite1:runAction(sequence)
end

--[[
	* 播放天王炸弹动画
--]]
function SRDDZ_ActionMgr:playKingBombAction()
	local sprite1 = display.newSprite("#rocket_fire_anim_1.png")
	sprite1:setLocalZOrder(1999)
	sprite1:pos(640,280)
	sprite1:setVisible(false)
	sprite1:addTo(gameScene.root)

	local sprite2 = display.newSprite("#rocket_piece_anim_1.png")
	sprite2:setLocalZOrder(1999)
	sprite2:pos(640,290)
	sprite2:setVisible(false)
	sprite2:addTo(gameScene.root)

	local sprite3 = display.newSprite("#rocket_piece_anim_1.png")
	sprite3:setLocalZOrder(1999)
	sprite3:pos(640,250)

	local rocket = display.newSprite("Image/SRDDZ/duang/KingBomb/rocket_icon.png")
	rocket:setLocalZOrder(1999)
	rocket:pos(640,430)
	rocket:addTo(gameScene.root)

	local callfunc = cc.CallFunc:create(function()
		sprite3:removeFromParent()

		local frames_1 = display.newFrames("rocket_fire_anim_%d.png", 1, 29)
		local animation_1 = display.newAnimation(frames_1, 0.01)
		local animate_1 = cc.Animate:create(animation_1)
		sprite1:setVisible(true)
		sprite1:runAction(cca.seq{animate_1,cc.RemoveSelf:create(true)})

		local frames_2 = display.newFrames("rocket_piece_anim_%d.png", 1, 8)
		local animation_2 = display.newAnimation(frames_2, 0.04)
		local animate_2 = cc.Animate:create(animation_2)
		sprite2:setVisible(true)
		sprite2:runAction(cca.seq{animate_2,cc.RemoveSelf:create(true)})

		local sequence = cca.seq{cc.EaseSineIn:create(cca.moveTo(0.4, 640, display.height+rocket:getContentSize().height/2)),cc.RemoveSelf:create(true)}
		rocket:runAction(sequence)
	end)

	local frames_3 = display.newFrames("rocket_smoke_anim_%d.png", 1, 10)
	local animation_3 = display.newAnimation(frames_3, 0.05)
	local animate_3 = cc.Animate:create(animation_3)
	sprite3:addTo(gameScene.root)
	sprite3:runAction(cca.seq({animate_3,callfunc}))
end

return SRDDZ_ActionMgr