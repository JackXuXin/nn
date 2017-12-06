local comUtil = require("app.Common.util")

local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local sound_common = require("app.Common.sound_common")
local util = require("app.Common.util")

local PATH = consts.PATH
local scheduler = vars.scheduler

-- jetton value
local JETTON_VAL_MAP = {
	1,5,10,50,100,500,1000,5000,10000,50000,100000,500000,1000000,5000000
}


local util = {}

util.action_bg_frames = {}
util.action_font_frames = {}
util.card_type_frames = {}
util.time_num_frames = {}
util.jetton_frames = {}
util.card_frames = {} -- card 90-117*120-161

function util.preload()
	local res = {
		{image = PATH.IMGS_ACTION_BG, width = 126, height = 56, number = 6},
		{image = PATH.IMGS_ACTION_FONT, width = 68, height = 30, number = 5},
		{image = PATH.IMGS_CARD_TYPE, width = 97, height = 36, number = 9},
		{image = PATH.IMGS_TIME_NUM, width = 22, height = 30, number = 10},
		{image = PATH.IMGS_JETTON, width = 60, height = 60, number = 14},
		{image = PATH.IMGS_CARD, width = 117, height = 161, number = 65},
	}

	comUtil.loadImagesAsyn(res, function ()
		util.action_bg_frames = display.newFrames(PATH.IMGS_ACTION_BG.."[%d]", 1, 6)
		util.action_font_frames = display.newFrames(PATH.IMGS_ACTION_FONT.."[%d]", 1, 5)
		util.card_type_frames = display.newFrames(PATH.IMGS_CARD_TYPE.."[%d]", 1, 9)
		util.time_num_frames = display.newFrames(PATH.IMGS_TIME_NUM.."[%d]", 1, 10)
		for i = 0, 10 do -- set [10] to nil by the way.
			util.time_num_frames[i] = util.time_num_frames[i+1]
		end
		util.jetton_frames = display.newFrames(PATH.IMGS_JETTON.."[%d]", 1, 9)
		util.card_frames = display.newFrames(PATH.IMGS_CARD.."[%d]", 1, 65)
		print("hk five card image resources load done.")
	end)
end

function util.init()
	print("util init ... "..device.platform)
	util.initFrames()

	if device.platform == "ios" then
		util.preloadSounds()
	end
end

function util.clear()
	--TODO: ...

end

-- standard pack image file.
local function sliceHorizontalFrames(filepath, startIdx, endIdx, width, height)
	local frames = {}
	local texture = cc.Director:getInstance():getTextureCache():addImage(filepath)
	local rect = nil
	for i = startIdx, endIdx do
		rect = cc.rect(width*(i-startIdx), 0, width, height)
		frames[i] = cc.SpriteFrame:createWithTexture(texture, rect)
		cc.SpriteFrameCache:getInstance():addSpriteFrame(frames[i], filepath..i)
	end
	return frames
end

local function sliceCardFrames(filepath, width, height)
	local frames = {}
	local texture = cc.Director:getInstance():getTextureCache():addImage(filepath)
	local rect = nil
	for row = 1, 5 do
		for col = 1, 13 do
			rect = cc.rect(width*(col-1), height*(row-1), width, height)
			frames[#frames+1] = cc.SpriteFrame:createWithTexture(texture, rect)
			cc.SpriteFrameCache:getInstance():addSpriteFrame(frames[#frames], filepath..#frames)
		end
	end
	return frames
end

function util.initFrames()
	util.action_bg_frames = sliceHorizontalFrames(PATH.IMGS_ACTION_BG, 1, 6, 126, 56)
	util.action_font_frames = sliceHorizontalFrames(PATH.IMGS_ACTION_FONT, 1, 5, 68, 30)
	util.card_type_frames = sliceHorizontalFrames(PATH.IMGS_CARD_TYPE, 1, 9, 97, 36)
	util.time_num_frames = sliceHorizontalFrames(PATH.IMGS_TIME_NUM, 0, 9, 22, 30)
	util.jetton_frames = sliceHorizontalFrames(PATH.IMGS_JETTON, 1, 14, 60, 60)
	util.card_frames = sliceCardFrames(PATH.IMGS_CARD, 117, 161)
end

function util.preloadSounds()
	audio.preloadSound(PATH.WAV_SEND_CARD)
	audio.preloadSound(PATH.WAV_GAME_START)
	audio.preloadSound(PATH.WAV_GAME_END)
	audio.preloadSound(PATH.WAV_GAME_WARN)
	audio.preloadSound(PATH.WAV_GAME_WIN)
	audio.preloadSound(PATH.WAV_GAME_LOSE)
	audio.preloadSound(PATH.WAV_NO_RAISE)
	audio.preloadSound(PATH.WAV_RAISE_SCORE)
	audio.preloadSound(PATH.WAV_FOLLOW)
	audio.preloadSound(PATH.WAV_SHOW_HAND)
	audio.preloadSound(PATH.WAV_GIVE_UP)
end

local has_sound = nil
function util.switchSound()
	has_sound = not has_sound

	app.constant.voiceOn = has_sound
	comUtil.GameStateSave("voiceOn",app.constant.voiceOn)
	sound_common.setVoiceState(app.constant.voiceOn)
	
	if has_sound then
		audio.setSoundsVolume(1.0)
	else
		audio.setSoundsVolume(0.0)
	end
end

function util.hasSound()
	print("has sound : " .. tostring(has_sound))
	return has_sound
end

function util.init_autio()
	has_sound = app.constant.voiceOn
end

function util.clear()
	has_sound = nil
end

function util.playSound(soundFilePath, loop)
	if has_sound then
		return audio.playSound(soundFilePath, loop)
	end
	return nil
end

function util.num2str(val)
	--return "["..comUtil.toDotNum(val).."]"
	--return tostring(comUtil.toDotNum(val))

	if not val or type(val) == "string" then
		val = checkint(val)
	end

	if math.abs(val) < 10000 then
		return tostring(val)
	end

	local symbol = ""
    if val < 0 then
        symbol = "-"
        val = -val
    end

    local ret = nil 
    while val >= 10000 do
        local k = string.format("%04d", val%10000)
        if not ret then
            ret = k
        else
            ret = k .. "," .. ret
        end
        val = math.floor(val/10000)
    end
    return string.format("%s%d", symbol, val)..","..ret
end

function util.nextSeat(curSeat)
	return curSeat % consts.MAX_PLAYER_NUM + 1
end

local function nextSeatByStep(curSeat, step)
	return (curSeat+consts.MAX_PLAYER_NUM-1+step) % consts.MAX_PLAYER_NUM + 1
end

local seat_d = 0
local my_sub_seat = 1 -- I always in my first seat.
local my_server_seat = 1 -- useless here
function util.setMyServerSeat(svrSeatId)
	seat_d = svrSeatId - my_sub_seat -- in [0,consts.MAX_PLAYER_NUM)
	my_server_seat = svrSeatId
end

-- server seat id to subjective seat id
function util.toSubSeatId(svrSeatId)
	-- return nextSeatByStep(svrSeatId,-seat_d)
	return (svrSeatId+consts.MAX_PLAYER_NUM-1-seat_d)%consts.MAX_PLAYER_NUM + 1
end

-- subjective seat id to server seat id
function util.toSvrSeatId(subSeatId)
	-- return nextSeatByStep(subSeatId,seat_d)
	return (subSeatId+consts.MAX_PLAYER_NUM-1+seat_d)%consts.MAX_PLAYER_NUM + 1
end

local jetton_side = 45
local pool_begin_x = display.width*(9/25.0)+jetton_side/2.0
local pool_end_x = display.width - pool_begin_x
local pool_heigth = display.height*(1/3.0)-jetton_side  + 25
local pool_begin_y = display.height*(9/21)+jetton_side/2.0 + 20
local pool_end_y = pool_begin_y + pool_heigth + 20

-- print("pool_x range:", pool_begin_x, pool_end_x)
-- print("pool_y range:", pool_begin_y, pool_end_y)

function util.randPoolX()
	-- return pool_begin_x
	return math.random(pool_begin_x, pool_end_x)
end

function util.randPoolY()
	-- return pool_end_y
	return math.random(pool_begin_y, pool_end_y)
end

function util.poolWH()
	return pool_end_x - pool_begin_x, pool_end_y - pool_begin_y
end

function util.poolPos()
	return pool_begin_x, pool_begin_y
end

local dealer_pos_x = display.cx
local dealer_pos_y = display.height-161/2
function util.dealerPos()
	return dealer_pos_x, dealer_pos_y
end

function util.jettonPickForVal(val)
	local ret = {}
	local jetton_val = 0
    for i = #JETTON_VAL_MAP, 1, -1 do
    	jetton_val = JETTON_VAL_MAP[i]
    	if val >= jetton_val then 
    		local k = math.floor(val/jetton_val)
    		ret[#ret+1] = {
    			jettonIdx = i, 
    			jettonVal = jetton_val,
    			jettonCnt = k
    		}
    		val = val - k*jetton_val
    	end
    end
    return ret
end

function util.rotate(x, y, angle)
	local r = math.rad(angle)
	return x*math.cos(r)+y*math.sin(r), y*math.cos(r)-x*math.sin(r)
end

function util.reRotate(x, y, angle)
	return util.rotate(x, y, 720-angle)
end

function util.cardFrame(suit, number)
	if number == nil then
		return util.card_frames[suit]
	end
	return util.card_frames[(suit-1)*13+number]
end

function util.cardBackFrame()
	return util.cardFrame(5,3)
end

function util.suitAndNumber(svrCardVal)
	if svrCardVal == nil or svrCardVal == 0 then
		return 5, 3 -- card back index
	end
	local suit = (svrCardVal % 10) + 1
	local number = math.floor(svrCardVal / 10)
	if number == 14 then -- A
		number = 1
	end
	return suit, number
end

-- ------------------------ extend standard library ------------------------
--TODO: move some shared place
function table.exist(t, value)
	-- print("run table.exist() in the special util...")
	for _, v in pairs(t) do 
		if v == value then return true end
	end
	return false
end

function table.arraycopy(array, index, len)
    local newtable = {}
    len = len or 0
    index = index or 1
    if len == 0 then
        len = #array - index + 1
    end
    for i = index, index + len - 1 do
        newtable[i-index+1] = array[i]
    end
    return newtable
end

-- --------------------------------------------------------------------------

function util.test ()
	printf("HkFiveCard util hello %s!", "world")

	-- print("cc.PACKAGE_NAME:", cc.PACKAGE_NAME)

	-- local tb = {table=nil}
	-- local table = 123
	-- tb.table = table
	-- dump(tb)
	-- dump(table)

	-- for i = 1, 10 do
	-- 	print("rand"..i, math.random())
	-- end

	-- local ta = {1,2,3}
	-- local tb = {7,8,9}
	-- table.insert(ta, 11)
	-- table.insert(ta, tb)
	-- dump(ta)
	-- dump(tb)

	-- print("\n\nCoroutine Test")
	-- local co
	-- co = coroutine.create(function(msg)
	-- 	for i = 1, 3 do 
	-- 		printf("%s --- co:%s run:%d", os.time(), msg, i)
	-- 		scheduler.performWithDelay(function()
	-- 			print(os.time(), "time:"..i, "up")
	-- 			local r, p1 = coroutine.resume(co, "r_param1", "r_param2")
	-- 			print(os.time(), "resume"..i.." return:", r, p1, "\n")
	-- 		end, 1)
	-- 		print(os.time(), "... yielding ...")
	-- 		local rp1, rp2 = coroutine.yield("y_param:"..i)
	-- 		print(os.time(), "yield return:", rp1, rp2)
	-- 	end
	-- 	return 42
	-- end)
	-- print(co, type(co), coroutine.status(co))
	-- print(os.time(), "co start !!! resume0")
	-- local r, p1 = coroutine.resume(co, "MyCo")
	-- print(os.time(), "resume0 return:", r, p1, "\n")


    -- print("["..comUtil.toDotNum(123456789000).."]")
    -- print("["..comUtil.toDotNum(123).."]")
    -- print("["..comUtil.toDotNum(0).."]")
    -- print("["..comUtil.toDotNum(1000).."]")


    -- print("jetton size:", #JETTON_VAL_MAP)
    -- for i = #JETTON_VAL_MAP, 1, -1 do
    -- 	print(JETTON_VAL_MAP[i])
    -- end
    -- local ret = util.jettonPickForVal(99999)
    -- print(#ret)
    -- dump(ret)


    -- print(math.cos(0), math.cos(math.rad(30)), math.cos(math.rad(60)), math.cos(math.rad(90)))
    -- print(math.sin(0), math.sin(math.rad(30)), math.sin(math.rad(60)), math.sin(math.rad(90)))
end


util.init()
return util