local errors = require("app.Common.errors")
local scheduler = require("framework.scheduler")
local ErrorLayer = require("app.layers.ErrorLayer")
local RequestLayer = require("app.layers.RequestLayer")
local RoomConfig = require("app.config.RoomConfig")
local AvatarConfig = require("app.config.AvatarConfig")

local GameState = require("framework.cc.utils.GameState")
local PlatConfig = require("app.config.PlatformConfig")
local NetSprite = require("app.config.NetSprite")
local MathBit = require("app.Common.MathBit")
local sound_common = require("app.Common.sound_common")


local util = {}
--local isRecording = false
--local isStopRecord = false
local isAutoPlay = true
local isShow = false
local isOpenRecord = false
local isOpenRequest = false
 util.UserInfo = {}
local curChannal = nil
local Player = app.userdata.Player
 chatItem = {name = "xiaonan",age = "20"}

 local emotionInfo = {[1] = {ani_name = "tuoxie", aniBegin = "", aniRun = "tuoxie1", runAniDelay = 0, aniEnd = "tuoxie", soundBegin = "", soundEnd = "tuoxie"},
                      [2] = {ani_name = "egg", aniBegin = "", aniRun = "egg1", runAniDelay = 0, aniEnd = "egg", soundBegin = "", soundEnd = "egg"},
                      [3] = {ani_name = "futou", aniBegin = "", aniRun = "futou1", runAniDelay = 0, aniEnd = "futou", soundBegin = "", soundEnd = "futou"},
                      [4] = {ani_name = "hua", aniBegin = "", aniRun = "hua1", runAniDelay = 0, aniEnd = "hua", soundBegin = "", soundEnd = "hua"},
                      [5] = {ani_name = "jiubei", aniBegin = "", aniRun = "jiubei1", runAniDelay = 0, aniEnd = "jiubei", soundBegin = "", soundEnd = "ganbei"},
                      [6] = {ani_name = "poshui", aniBegin = "", aniRun = "poshui", runAniDelay = 0, aniEnd = "poshui", soundBegin = "", soundEnd = "poshui"},
                      [7] = {ani_name = "qian", aniBegin = "", aniRun = "qian1", runAniDelay = 0, aniEnd = "qian", soundBegin = "", soundEnd = "money"},
                      [8] = {ani_name = "zhuantou", aniBegin = "", aniRun = "zhuantou1", runAniDelay = 0, aniEnd = "zhuantou", soundBegin = "", soundEnd = "glass"}, }

--cc.p(50, 50), (1150,500)
function util.showEmotionsLayer(sceneNode, LayerNode, direct)
    -- if direct == 1 then
    -- end
    if LayerNode == nil or sceneNode == nil then
        return
    end

    local emotionList = cc.ui.UIScrollView.new({
        viewRect = cc.rect(15, 12, 335, 152),
        bgColor = cc.c4b(255,255,255,0),
    })
    emotionList:addTo(LayerNode)
    emotionList:setDirection(1)
    emotionList:setBounceable(false)

    local emptyNode = cc.Node:create()
    emptyNode:setPosition(15, 12)
    emptyNode:setContentSize(335, 152)
    emotionList:addScrollNode(emptyNode)

    local height = emotionList:getCascadeBoundingBox().height
    for i=1, 8 do

        local bg = display.newScale9Sprite("Image/PrivateRoom/img_EmoKuang.png", math.mod(i - 1,4) * (82+2), height - math.floor((i - 1) / 4) * (73+4))
        :addTo(emptyNode)
        :setAnchorPoint(0,1)

        local emotion_btn = cc.ui.UIPushButton.new({ normal = "Image/PrivateRoom/emo" .. i .. ".png", pressed = "Image/PrivateRoom/emo" .. i .. ".png" })
            :onButtonClicked(function()
                print("emotion--i = ",i)
                --util.RunEmotionInfo(sceneNode, i, beginPos, endPos)
                sceneNode:SendEmotion(i, direct)
                LayerNode:hide()
             end)
            :pos(41,37)
            :addTo(bg)
            util.BtnScaleFun(emotion_btn)

    end


end

function util.getToSeat(direct, max_player, seatIndex, flag)
    local leftSeat = 0
    local rightSeat = 0
    local topSeat = 0
    print("getToSeat-max,sea",max_player, seatIndex)
    if max_player == 2 then
        if seatIndex == 1 then
            topSeat = 2
            if flag ~= nil then
                rightSeat = 2
            end
        else
            topSeat = 1
            if flag ~= nil then
                rightSeat = 1
            end
        end
    elseif max_player == 3 then
        if seatIndex == 1 then
            topSeat = 3
            rightSeat = 2
        elseif seatIndex == 2 then
            topSeat = 1
            rightSeat = 3
        else
            topSeat = 2
            rightSeat = 1
        end
    elseif max_player == 4 then
        if seatIndex == 1 then
            rightSeat = 2
            topSeat = 3
            leftSeat = 4
        elseif seatIndex == 2 then
            rightSeat = 3
            topSeat = 4
            leftSeat = 1
        elseif seatIndex == 3 then
            rightSeat = 4
            topSeat = 1
            leftSeat = 2
        else
            rightSeat = 1
            topSeat = 2
            leftSeat = 3
        end
    end
    if direct == "left" then
        return leftSeat
    elseif direct == "right" then
        return rightSeat
    elseif direct == "top" then
        return topSeat
    elseif direct == "bottom" then
        return seatIndex
    end
end

function getAngleByPos(p1,p2)
    local p = {}
    p.x = p2.x - p1.x
    p.y = p2.y - p1.y

    local r = math.atan2(p.y,p.x)*180/math.pi
    --print("夹角[-180 - 180]:",r)
    return r
end

function util.reSetEmotion()
    util.armature2 = nil
    util.armature3 = nil
end

function util.RunEmotionInfo(rootNode, index, beginPos, endPos)

    if rootNode == nil then
        return
    end
--or util.armature3 ~= nil
    if util.armature2 ~= nil or util.armature3 ~= nil then
        print("RunEmotionInfo--- more---")
        return
    end

    local emoInfo = emotionInfo[index]
    local ani_name = emoInfo.ani_name
    local aniStr2 = emoInfo.aniRun
    local aniStr = emoInfo.aniBegin
    local aniStr3 = emoInfo.aniEnd
    local runAniDelay = emoInfo.runAniDelay
    local soundBegin = emoInfo.soundBegin
    local soundEnd = emoInfo.soundEnd

    local manager = ccs.ArmatureDataManager:getInstance()
        manager:addArmatureFileInfo("Image/emoAni/" .. ani_name .."/" .. ani_name .. ".ExportJson")

        local armature = nil
        if aniStr ~= "" then
            armature = ccs.Armature:create(ani_name)
            armature:setPosition(beginPos)
            armature:getAnimation():play(aniStr)
            rootNode:addChild(armature, 10)

            if aniStr == "jiqiang2" then
                local r = getAngleByPos(endPos, beginPos)
                armature:setRotation(-r-180)
            end

            sound_common.emoSound(soundBegin)
        end

        local armature2 = nil
        if aniStr2 ~= "" then
             armature2 = ccs.Armature:create(ani_name)
             util.armature2 = armature2
             if aniStr2 == "poshui" then
                armature2:getAnimation():gotoAndPlay(0)
             else
                armature2:getAnimation():play(aniStr2)
             end

             armature2:setPosition(beginPos)
             --armature2:getAnimation():setSpeedScale(2)

             local r = getAngleByPos(endPos, beginPos)
             if aniStr2 ~= "jiubei1" and aniStr2 ~= "poshui" and aniStr2 ~= "hua1" then
                armature2:setRotation(-r-180)
             end
             rootNode:addChild(armature2, 10)
             armature2:hide()
        end

         local armature3 = ccs.Armature:create(ani_name)
         util.armature3 = armature3
         armature3:setPosition(endPos)
         armature3:hide()
         rootNode:addChild(armature3, 10)

        if armature2 ~= nil then
            if runAniDelay == 0 then
                armature2:show()
                local ret_star = cc.RotateBy:create(0.5,640)
                local  pt = cc.MoveTo:create(0.5,endPos)
                local spawn_star = nil
                if aniStr2 == "egg1" or aniStr2 == "tuoxie1" or aniStr2 == "qian1" or aniStr2 == "zhuantou1" then
                    spawn_star = cc.Spawn:create(pt,ret_star)
                else
                    spawn_star = pt
                end
                transition.execute(armature2, spawn_star, {
                delay = 0,
                easing = nil,
                onComplete = function()
                     armature2:removeFromParent()
                     util.armature2 = nil
                     armature3:show()
                     armature3:getAnimation():play(aniStr3)
                     sound_common.emoSound(soundEnd)
                     --print("aniRun--onComplete------")
                end,
                })
            else
                scheduler.performWithDelayGlobal(
                function()
                    if util.armature2 ~= nil then
                        util.armature2:show()
                        local  pt = cc.MoveTo:create(0.5,endPos)
                        transition.execute(util.armature2, pt, {
                        delay = 0,
                        easing = nil,
                        onComplete = function()
                             util.armature2:removeFromParent()
                             util.armature2 = nil
                             if util.armature3 ~= nil then
                                util.armature3:show()
                                util.armature3:getAnimation():play(aniStr3)
                             end
                             sound_common.emoSound(soundEnd)
                            -- print("aniRun--onComplete------")
                        end,
                        })
                    end
                    

                end,runAniDelay)
            end
        else
            scheduler.performWithDelayGlobal(
                function()
                    if util.armature3 ~= nil then
                        util.armature3:show()
                        util.armature3:getAnimation():play(aniStr3)
                    end
                     sound_common.emoSound(soundEnd)
                end,runAniDelay)
        end

        local function animationEvent(armatureBack, movementType,movementID)
              local id = movementID
              --print("Armature-id------", id)
              if movementType == ccs. MovementEventType.start then
                   -- print("Armature-start--", id)
              elseif movementType == ccs.MovementEventType.complete then
                    --print("Armature-complete--", id)
                    if id == aniStr3 then
                        if armature ~= nil then
                             armature:getAnimation():stop()
                             armature:removeFromParent()
                        end
                        if armature3 ~= nil then
                            armature3:getAnimation():stop()
                            armature3:removeFromParent()
                            util.armature3 = nil
                        end
                    end
              elseif movementType == ccs. MovementEventType.loopComplete then
                    if id == aniStr then
                        if armature ~= nil then
                             armature:getAnimation():stop()
                        end
                    end

                    if id == aniStr3 then
                        if armature ~= nil then
                             armature:getAnimation():stop()
                             armature:removeFromParent()
                        end
                        if armature3 ~= nil then
                            armature3:getAnimation():stop()
                            armature3:removeFromParent()
                            util.armature3 = nil
                        end
                    end
                     --print("Armature-loopComplete--", id)
              end
        end
        if armature ~= nil then
            armature:getAnimation():setMovementEventCallFunc(animationEvent)
        end

        armature3:getAnimation():setMovementEventCallFunc(animationEvent)

end

function util.hello ()
    print("hello common util !")
end

function util.error(err_code)
    -- dump(errors)
    local err_str = errors.str(err_code)
    if err_str then
        return app.lang.errors[err_str]
    end
    return "unknown error."
end

-- 返回千分位数字 10,000,000
function util.toDotNum(num)
    if not num or type(num) == "string" then
        num = checkint(num)
    end

    if math.abs(num) < 1000 then
        return tostring(num)
    end

    local symbol = ""
    if num < 0 then
        symbol = "-"
        num = -num
    end

    local ret = nil
    while num >= 1000 do
        local k = string.format("%03d", num%1000)
        if not ret then
            ret = k
        else
            ret = k .. "," .. ret
        end
        num = math.floor(num/1000)
    end
    return string.format("%s%d", symbol, num)..","..ret
end

function util.toChineseCapital(num)
    local cnum = {"零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"}
    local cunit = {"拾", "佰", "仟", "万", "拾", "佰", "仟", "亿"}

    num = math.floor(num)
    local result = ""
    local zero = true
    local count = 0
    local whole = ""
    while num > 0 do
        local n = num % 10 + 1
        if n == 1 then
            if count > 0 and count % 4 == 0 then
                if count % 8 == 0 then
                    whole = cunit[8]
                else
                    whole = cunit[4]
                end
            end

            if not zero and count % 4 ~= 0 then
                result = cnum[n] .. result
            end
            zero = true
        else
            local c = count % 8
            if count > 0 and c == 0 then
                c = 8
            end
            if c == 4 or c == 8 then
                whole = ""
            end
            local unit = cunit[c] or ""
            result = string.format("%s%s%s%s", cnum[n], unit, whole, result)
            zero = false
            whole = ""
        end
        count = count + 1
        num = math.floor(num / 10)
    end
    return result
end

function util.copyToClipboard(string)
    if device.platform == "ios" then
        luaoc.callStaticMethod("LuaOcUtil", "copyToClipBoard", {string = string})
    elseif device.platform == "android" then
        print("string type:" .. type(string))
        luaj.callStaticMethod("app/LuaOcUtil", "copyToClipBoard", {string})
    else
        print("util.copyToClipboard is not supported on " .. device.platform)
    end
end

function util.getVersion()
    local ret
    if device.platform == "ios" then
        _, ret = luaoc.callStaticMethod("LuaOcUtil", "getBundleVersion")
    elseif device.platform == "android" then
        _, ret = luaj.callStaticMethod("app/LuaOcUtil", "getBundleVersion", nil, "()I")
    end

    return checkint(ret)
end
--分割字符
function util.LuaSplit(str,split)
    local lcSubStrTab = {}
    while true do
        local lcPos = string.find(str,split)
        if not lcPos then
            lcSubStrTab[#lcSubStrTab+1] =  str
            break
        end
        local lcSubStr  = string.sub(str,1,lcPos-1)
        lcSubStrTab[#lcSubStrTab+1] = lcSubStr
        str = string.sub(str,lcPos+1,#str)
    end
    return lcSubStrTab
end
--移除字符
function util.LuaReomve(str,remove)
    local lcSubStrTab = {}
    while true do
        local lcPos = string.find(str,remove)
        if not lcPos then
            lcSubStrTab[#lcSubStrTab+1] =  str
            break
        end
        local lcSubStr  = string.sub(str,1,lcPos-1)
        lcSubStrTab[#lcSubStrTab+1] = lcSubStr
        str = string.sub(str,lcPos+1,#str)
    end
    local lcMergeStr =""
    local lci = 1
    while true do
        if lcSubStrTab[lci] then
            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]
            lci = lci + 1
        else
            break
        end
    end
    return lcMergeStr
end
function util.createInput(parent, options, callback)
    local editBox = cc.ui.UIInput.new({
                UIInputType = 2,
                size = (options and options.size) or parent:getContentSize(),
                x =  0,
                y =  parent:getContentSize().height / 2-2,
                listener = function(editbox, eventType)
                    if eventType == 1 then
                        -- if  options.maxLen then
                        --     local text=editbox:getString()
                        --     text=util.LuaReomve(text,"\n")
                        --     local result,line_num=util.stringFormat(text,options.maxLen)
                        --     editbox:setString(result)
                        -- end
                        if callback then
                            callback()
                        end

                    elseif eventType == 2 then
                        if options and options.maxLen then
                            local text=editbox:getString()
                            text=util.LuaReomve(text,"\n")
                            local result,line_num=util.stringFormat(text,options.maxLen)
                            editbox:setString(result)
                        end

                    end
                end
            }):addTo(parent, -1)
--or cc.c4b(255,255,255, 255)
    editBox:setAnchorPoint(cc.p(0, 0.5))
    editBox:setTextColor((options and options.color) or cc.c4b(255,255,255, 255))

    editBox:setMaxLengthEnabled(true)
    editBox:setMaxLength((options and options.maxLength) or 20)
    editBox:setFontSize((options and options.fontSize) or 30)
    editBox:setPlaceHolder((options and options.placeHolder) or "")


    -- eventType == 0 -- attach IME
    -- eventType == 1 -- detach IME
    -- eventType == 2 -- insert text
    -- eventType == 3 -- delete text
    if options and options.mode then
        if options.mode == cc.EDITBOX_INPUT_MODE_NUMERIC then
            editBox:addEventListener(function(editbox, eventType)
                if eventType == 1 then

                    editBox:setString(tostring(tonumber(editBox:getString()) or ""))
                end
            end)
        end
    end

    if options and options.password then
        editBox:setPasswordEnabled(true)
        editBox:setPasswordStyleText(options.passwordChar or "*")

        -- editBox:addEventListener(function(editbox, eventType)
        --     if eventType == 0 then
        --         editBox:setString("")
        --     end
        -- end)
    end

    return editBox
end

function util.createInputEx(parent, options,image)
    local editBox = cc.ui.UIInput.new({
                UIInputType = 1,
                size = (options and options.size) or parent:getContentSize(),
                x = 0,
                y = parent:getContentSize().height / 2,
                image = image,
                listener = function(event, editbox)   --监听事件
                    if event == "began" then          --点击editBox时触发（触发顺序1）
                        --self:onEditBoxBegan(editbox)
                    elseif event == "ended" then        --输入结束时触发 （触发顺序3）
                        --self:onEditBoxEnded(editbox)
                    elseif event == "return" then        --输入结束时触发（触发顺序4）
                        --self:onEditBoxReturn(editbox)
                    elseif event == "changed" then       --输入结束时触发（触发顺序2）

                        --self:onif edEditBoxChanged(editbox)
                    else
                        printf("EditBox event %s", tostring(event))
                    end
                end
            }):addTo(parent)

    editBox:setAnchorPoint(cc.p(0, 0.5))
    editBox:setFontColor(cc.c4b(112,128,144, 255))
    editBox:setMaxLength((options and options.maxLength) or 20)
   -- editBox:setTextColor(cc.c4b(112,128,144, 255))

    --editBox:setMaxLengthEnabled(true)
    --editBox:setMaxLength((options and options.maxLength) or 20)
    editBox:setFontSize((options and options.fontSize) or 30)
    editBox:setPlaceHolder((options and options.placeHolder) or "")


    -- eventType == 0 -- attach IME
    -- eventType == 1 -- detach IME
    -- eventType == 2 -- insert text
    -- eventType == 3 -- delete text
    -- if options and options.mode then
    --     if options.mode == cc.EDITBOX_INPUT_MODE_NUMERIC then
    --         editBox:addEventListener(function(editbox, eventType)
    --             if eventType == 1 then
    --                 editBox:setString(tostring(tonumber(editBox:getString()) or ""))
    --             end
    --         end)
    --     end
    -- end

    if options and options.password then
        editBox:setPasswordEnabled(true)
        editBox:setPasswordStyleText(options.passwordChar or "*")

        -- editBox:addEventListener(function(editbox, eventType)
        --     if eventType == 0 then
        --         editBox:setString("")
        --     end
        -- end)
    end

    return editBox
end

-- 根据key获取table的某个值，如果tb某个元素等于则key返回，deep是最大深度
function util.findRootByLeaf(tb, key, value, deep)
    if type(tb) ~= "table" or deep < 1 then
        return
    end

    deep = deep or 1
    if tb[key] == value then
        return key, value
    end

    for k,v in pairs(tb) do
        local ok = util.findRootByLeaf(v, key, value, deep - 1)
        if ok then
            return k, v
        end
    end
end

function util.loadImagesAsyn(preloadRes, finishCallback)
    local count = 0

    function loadFinish()
        count = count - 1
        if count <= 0 then
            count = math.huge
            if finishCallback then
                finishCallback()
            end
        end
    end

    function loadSingleImage(imagePath)
        display.addImageAsync(imagePath, function (texture)
            local rect = cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh())
            local frame = cc.SpriteFrame:createWithTexture(texture, rect)
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, imagePath)

            loadFinish()
        end)
    end

    function loadCombineImage(imagePath, conf)
        local width = conf.width
        local height = conf.height
        local index = conf.index
        local number = conf.number or math.huge

        display.addImageAsync(imagePath, function (texture)
            local line = math.floor(texture:getPixelsHigh() / height)
            local column = math.floor(texture:getPixelsWide() / width)

            local function parse()
                for i=1,line do
                    for j=1,column do
                        local idx = (i - 1) * column + j
                        if not index or idx == index then
                            local rect = cc.rect(width * (j - 1), height * (i - 1), width, height)
                            local frame = cc.SpriteFrame:createWithTexture(texture, rect)
                            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, imagePath .. "[" .. idx .. "]")
                            number = number - 1
                        end

                        if (index and idx == index) or (number <= 0) then
                            return
                        end
                    end
                end
            end

            parse()
            loadFinish()
        end)
    end

    for k,v in pairs(checktable(preloadRes)) do
        count = count + 1

        if v.plist then
            -- plist image
        else
            if v.width and v.height then
                loadCombineImage(k, v)
            else
                loadSingleImage(k)
            end
        end
    end
end

function util.loadImagesSyn(preloadRes)

    function loadSingleImage(imagePath)
        local texture = cc.Director:getInstance():getTextureCache():addImage(imagePath)
        local rect = cc.rect(0, 0, texture:getPixelsWide(), texture:getPixelsHigh())
        local frame = cc.SpriteFrame:createWithTexture(texture, rect)
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, imagePath)
    end

    function loadCombineImage(imagePath, conf)
        local width = conf.width
        local height = conf.height
        local index = conf.index
        local number = conf.number or math.huge

        local texture = cc.Director:getInstance():getTextureCache():addImage(imagePath)

        local line = math.floor(texture:getPixelsHigh() / height)
        local column = math.floor(texture:getPixelsWide() / width)

        local function parse()
            for i=1,line do
                for j=1,column do
                    local idx = (i - 1) * column + j
                    if not index or idx == index then
                        local rect = cc.rect(width * (j - 1), height * (i - 1), width, height)
                        local frame = cc.SpriteFrame:createWithTexture(texture, rect)
                        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, imagePath .. "[" .. idx .. "]")
                        number = number - 1
                    end

                    if (index and idx == index) or (number <= 0) then
                        return
                    end
                end
            end
        end

        parse()
    end

    for k,v in pairs(checktable(preloadRes)) do
        if v.plist then
            -- plist image
        else
            if v.width and v.height then
                loadCombineImage(k, v)
            else
                loadSingleImage(k)
            end
        end
    end
end

function util.removeImages(preloadRes)
    for k,v in pairs(checktable(preloadRes)) do
        if v.plist then
            -- plist image
        else
            local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(k)
            if v.width and v.height and texture then
                local line = math.floor(texture:getPixelsHigh() / v.height)
                local column = math.floor(texture:getPixelsWide() / v.width)
                for i=1,line do
                    for j=1,column do
                        local name = k .. "[" .. ((i - 1) * column + j) .. "]"
                        cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(name)
                    end
                end
                cc.Director:getInstance():getTextureCache():removeTextureForKey(k)
            else
                display.removeSpriteFrameByImageName(k)
            end
        end
    end
end

function util.getSpriteFrameFromCache(name, conf, number)
    local spriteName
    if type(number) == "number" then
        spriteName = name .. "[" .. number .. "]"
    else
        spriteName = name
    end

    local spriteFrame = display.newSpriteFrame(spriteName)
    if spriteFrame then
        return spriteFrame
    end

    conf.index = number
    util.loadImagesSyn({ [name] = conf })
    return display.newSpriteFrame(spriteName)
end

function util.fromhex(str)
    return str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end)
end

function util.tohex(str)
    return str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end)
end

function util.utf8IndexToByte(str, index)
    local len  = string.len(str)
    local left = 1
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left <= len do
        if cnt >= index then
            break
        end

        local tmp = string.byte(str, left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left + i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return left - 1
end

local function isByteSp(byte)
    return (byte == 237 or byte == 226 or byte == 240)
end

function util.checkEmoji(str)
    --local nums = string.utf8len(str)
    if #str == 0 then
        return false
    end

    for i = 1,#str do
         local curByte = string.byte(str, i)
         print("byte"..i..":"..curByte)
         if isByteSp(curByte) then
            return false
         end
    end
    return true
end

local function loopCheck(str)
    s = str
    for i = 1,#str do
        local curByte = string.byte(str, i)
        if isByteSp(curByte) then
            local result,replaceCount = string.gsub(str, string.char(curByte), string.char(239),1)
            curByte = string.byte(result, i + 1)
            result,replaceCount = string.gsub(result, string.char(curByte), string.char(188),1)
            curByte = string.byte(result, i + 2)
            result,replaceCount = string.gsub(result, string.char(curByte), string.char(159),1)
            s = result
            loopCheck(result)
            break
        end
    end
    return s
end

function util.checkWchatNick(str)
    --微信名称
    local nickname = ""
    local index = 1
    while index <= #str do
        local byte = string.byte(str,index)
        if MathBit.andOp(byte,252) == 252 then
            nickname = nickname .. "*"
            index = index + 6
        elseif MathBit.andOp(byte,248) == 248 then
            nickname = nickname .. "*"
            index = index + 5
        elseif MathBit.andOp(byte,240) == 240 then
            nickname = nickname .. "*"
            index = index + 4
        elseif MathBit.andOp(byte,224) == 224 then
            nickname = nickname .. string.sub(str,index,index+2)
            index = index + 3
        elseif MathBit.andOp(byte,192) == 192 then
            nickname = nickname .. string.sub(str,index,index+1)
            index = index + 2
        else
            nickname = nickname .. string.sub(str,index,index)
            index = index + 1
        end
    end

    return nickname

end

function util.checkNickName(str, length)

    if device.platform == "android" then
        local anstr = util.checkWchatNick(str)
        return anstr
    end

    if length ~= nil and length>0 then

        return util.stringFormatEx(str, length)

    end

    return str
    -- local str_checked = loopCheck(str)
    -- return str_checked
end

local function displayMatchTip(name)
    local scene = display.getRunningScene()

    local nodeTip = display.newSprite("Image/Match/textbg_1.png")
    nodeTip:setPosition(640,480)
    scene:addChild(nodeTip,10)

    local label = cc.ui.UILabel.new({
        color = cc.c3b(255,0,0),
        size = 30,
        text = name .. "即将开始，请参赛玩家进入比赛房间准备！",
    })
    :addTo(nodeTip)
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(640,50)

    transition.fadeOut(nodeTip, {
        time = 2.0,
        delay = 3.0,
        onComplete = function ()
            nodeTip:removeFromParent()
            nodeTip = nil
        end,
    })
    transition.fadeOut(label, {
        time = 2.0,
        delay = 3.0,
        onComplete = function ()
        end,
    })
    print("displayMatchTip")
end

local function matchStartSchedule()
    -- body
    local RoomConfig = require("app.config.RoomConfig")
    local web = require("app.net.web")

    web.getServerTime(function (time)
        --print("server time:" .. time)
        local sTime = os.date("*t", time)

        --local displays = {}
        for _,config in ipairs(RoomConfig) do
            if config.matchroom then
                for k,v in pairs(config.matchroom) do

                    if v.startHour == sTime.hour and v.startMinute == sTime.min + 5 then
                        displayMatchTip(v.name)
                    end

                end
            end
        end
    end)
end

function util.matchSchedule()

    if not util.matchScheduler then
        local RoomConfig = require("app.config.RoomConfig")
        local web = require("app.net.web")

        web.getServerTime(function (time)

            local sTime = os.date("*t", time)
            --print("server sTime.hour:" .. sTime.hour)
            --print("server sTime.minute:" .. sTime.min)

            --local displays = {}
            for _,config in ipairs(RoomConfig) do
                if config.matchroom then
                    for k,v in pairs(config.matchroom) do

                        if v.invisible == nil or v.invisible ~= 1 then

                            if v.startHour == sTime.hour and v.startMinute < sTime.min + 5 and v.startMinute > sTime.min then
                                displayMatchTip(v.name)
                            end

                        end

                    end
                end
            end
        end)

        util.matchScheduler = scheduler.scheduleGlobal(matchStartSchedule, 60.0)
    end
    --displayMatchTip("上虞麻将")
end

function util.unscheduleMatch()
    -- body
    if util.matchScheduler then
        scheduler.unscheduleGlobal(util.matchScheduler)
        util.matchScheduler = nil
    end
end

local function playNotice(info,runningScene,func,noticeRoot)
--    print("播放公告！！！！！！！！")
    if not noticeRoot or not runningScene then
        return
    end

    if not info then
        if func then
            runningScene:performWithDelay(func,2)
            return
        end
    end

    noticeRoot:setVisible(true)

    local k_tx_Notice = cc.uiloader:seekNodeByNameFast(noticeRoot, "k_tx_Notice")
    k_tx_Notice:setString(info.content)

    local x = (cc.uiloader:seekNodeByNameFast(noticeRoot, "k_image_NoticeBg"):getContentSize().width + k_tx_Notice:getContentSize().width) * -1
    local y = 0

    local lb_width = k_tx_Notice:getCascadeBoundingBox().size.width
    local delay = (1 + lb_width/display.width) * 8

    local action = cc.Sequence:create(
        cc.MoveBy:create(delay, cc.p(x,y)),
        cc.CallFunc:create(
            function ()
                k_tx_Notice:setPositionX(k_tx_Notice:getPositionX() - x)
            end
        ),
        cc.MoveBy:create(delay, cc.p(x,y)),
        cc.CallFunc:create(
            function ()
                k_tx_Notice:setPositionX(k_tx_Notice:getPositionX() - x)
                noticeRoot:setVisible(false)
                if func then
                    runningScene:performWithDelay(func,60)
                end
            end
        )
    )

    transition.execute(k_tx_Notice, action)
end

function util.RunHorn(msg,runningScene,sceneRoot)
    if not runningScene then
        return
    end
    --print("RunHorn runningScene.name = " .. runningScene.name)
    --dump(msg)

    local isGameScene = false   --runningScene 是不是游戏场景
    if runningScene.name ~= "LobbyScene" and runningScene.name ~= "RoomScene" then
        isGameScene = true
    end

    if msg == nil then   --  进入场景的时候 msg 会是空值
        app.userdata.Player.isStartPlayNotice = false   --重置公告播放
        if #app.userdata.Player.noticeInfos == 0 then   --没有需要播放的公告
            return
        end

        if isGameScene then  -- 如果是游戏场景直接返回
            return
        end
    else
        if msg.gameid == 0  then  -- 插入gameid 为 0 的全局公告
            table.insert(app.userdata.Player.noticeInfos,msg)   --需要播放的公告插入到公告表中
        end

        if runningScene.name == "LoginScene" then  --如果是登陆场景 直接返回
            return
        end

        if isGameScene then  -- 在游戏场景
            if not runningScene.noticeInfos then   --创建游戏场景播放公告的表
                runningScene.noticeInfos = {}
                app.userdata.Player.isStartPlayNotice = false
            end
            table.insert(runningScene.noticeInfos,msg)  -- 插入
        end
    end

    --开始播放公告
    if not app.userdata.Player.isStartPlayNotice then
        app.userdata.Player.isStartPlayNotice = true

        --创建公告UI
        local noticeRoot = cc.uiloader:load("Node/NoticeNode.json")
        if sceneRoot then
            noticeRoot:addTo(sceneRoot)
        else
            noticeRoot:addTo(runningScene)
        end

        -- 根据gameid 设置 公告的位置 ， 图片资源
        if runningScene.name == "LobbyScene" then  -- 在首页
            --设置公告栏位置
            noticeRoot:pos(display.cx,610)
            --公告文字颜色
            cc.uiloader:seekNodeByNameFast(noticeRoot, "k_tx_Notice"):setColor(display.COLOR_WHITE)
        elseif runningScene.name == "RoomScene" then  -- 在大厅
            noticeRoot:pos(display.cx,23)

            --蓝条背景
            -- local bg = cc.uiloader:seekNodeByNameFast(noticeRoot, "k_image_NoticeBg")
            -- local horn_bg = display.newScale9Sprite("Image/Public/NotificationBackground.png", 0, 0, cc.size(1280, 46))
            --     :setAnchorPoint(cc.p(0,0))
            --     :addTo(bg)
            -- --喇叭图标
            -- local horn = display.newSprite("Image/Public/Loudspeaker.png", 0, 0)
            --     :setAnchorPoint(cc.p(0,0))
            --     :addTo(bg)
            --公告文字颜色
            cc.uiloader:seekNodeByNameFast(noticeRoot, "k_tx_Notice"):setColor(display.COLOR_WHITE)
        else  -- 在游戏中
            --重新设置文字遮罩的大小
            cc.uiloader:seekNodeByNameFast(noticeRoot, "k_img_defaultBg"):setVisible(false)
            local size =  cc.uiloader:seekNodeByNameFast(noticeRoot, "k_layout_textMake"):getContentSize()
            size.width = size.width - 20
            cc.uiloader:seekNodeByNameFast(noticeRoot, "k_layout_textMake"):setContentSize(size)
            --黑色透明背景
            local bg = cc.uiloader:seekNodeByNameFast(noticeRoot, "k_image_NoticeBg")
            local horn_bg = display.newScale9Sprite("Image/Public/gameSceneNoticeBg.png", 0, 0, cc.size(1280, 46))
                :setAnchorPoint(cc.p(0,0))
                :addTo(bg)
            noticeRoot:pos(display.cx,560)
        end

       local index = 0  --循环播放公告的下标
       local func       --循环播放公告的回调相隔 60 秒调用一次
       func = function()
            index = index + 1
            if isGameScene then   -- 如果是 游戏场景 播放公告结束之后 清理掉公告UI and 数据
                if index > #runningScene.noticeInfos then
                    noticeRoot:removeFromParent()
                    runningScene.noticeInfos = nil
                    return
                end
                playNotice(runningScene.noticeInfos[index],runningScene,func,noticeRoot)
            else
                if index > #app.userdata.Player.noticeInfos then
                    index = 1
                end
                playNotice(app.userdata.Player.noticeInfos[index],runningScene,func,noticeRoot)
            end
       end
       func()
    end
end

--移除id_list中得公告信息
function util.removeNotice(id_list)
    for _,id in ipairs(id_list) do
        for k,v in ipairs(app.userdata.Player.noticeInfos) do
            if id == v.id then
                table.remove(app.userdata.Player.noticeInfos,k)
            end
        end

        for k,v in ipairs(app.userdata.Player.noticeInfosEx) do
            if id == v.id then
                table.remove(app.userdata.Player.noticeInfosEx,k)
            end
        end
    end
end

function util.IsShowVoiceBtn(isVisible, sceneRoot)

    if chatVoiceLayer == nil then
        return
    end

    local btnVoice = sceneRoot:getChildByName("voiceRoot")
    if btnVoice ~= nil then
        btnVoice:setVisible(isVisible)
    end

end
--添加游戏中语音和聊天按钮
function util.SetVoiceBtn(runningScene,sceneRoot)

    --审核专用
    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    if platConfig ~= nil and platConfig.isAppStore ~= nil then
        if platConfig.isAppStore == true then
            return
        end
    end

--     if device.platform ~= "ios" and  device.platform ~= "android" then
--         return
--     end

-- --ping

    isOpenRecord = false
    isOpenRequest = false

   if app.constant.isOpenYvSys == false then

      return

   end

    if runningScene == nil or sceneRoot == nil then
        return
    end

    util.curScene = runningScene

    print("Scenename:" .. runningScene.name)
--or runningScene.name == "LobbyScene"
    if runningScene.name == "SRDDZScene" or runningScene.name == "SSSScene" or runningScene.name == "HkFiveCardScene" or
        runningScene.name == "ShYMJScene" or runningScene.name == "YCMJScene" or runningScene.name == "WLScene" or runningScene.name == "NJMJScene" or
        runningScene.name == "WRNNScene" or runningScene.name == "CXMJScene" or runningScene.name == "DDZScene" then

        if chatVoiceLayer == nil then

            print("Scenename11111:" .. runningScene.name)

           chatVoiceLayer = cc.uiloader:load("Layer/ChatMenu/ChatVoiceLayer.json"):addTo(util.curScene,3000)

           ChannelMsgIndex = 0

           local image = cc.uiloader:seekNodeByNameFast(chatVoiceLayer, "Image_Open")

           image:setColor(cc.c3b(173, 98, 60))

           local clickChangeState = function (event)

                local image = cc.uiloader:seekNodeByNameFast(chatVoiceLayer, "Image_Open")
                local btn_Control = cc.uiloader:seekNodeByNameFast(chatVoiceLayer, "Button_Control")

                 image:setColor(cc.c3b(173, 98, 60))

                 local rect = cc.rect(0, 0, 60, 28)
                 local  frame = nil

                 isAutoPlay = not isAutoPlay

                 if isAutoPlay then

                    rect = cc.rect(0, 0, 60, 28)

                    frame = cc.SpriteFrame:create("Image/ChatFriend/img_Open.png", rect)
                    image:setPositionX(412)
                    btn_Control:setPositionX(484)

                 else

                    rect = cc.rect(0, 0, 60, 30)

                    frame = cc.SpriteFrame:create("Image/ChatFriend/img_Close.png", rect)

                    image:setPositionX(466)
                    btn_Control:setPositionX(392)

                 end

                 image:setSpriteFrame(frame)

                  local stype = app.constant.chatType

                 local istance = yvcc.HclcData:sharedHD():getListen()

                --local nYvID = app.constant.m_curYvID

                 -- local pChatNode =  istance:getFriendChatNode(nYvID)


                 --  if stype == 1 then

                 --    if pChatNode then

                 --        pChatNode:setisvoiceAutoplay(isAutoPlay)

                 --    else

                 --        print("can not find Friend setisvoiceAutoplay")

                 --    end

                 -- else

                local pChannalNode = istance:getChannalNode()
                if pChannalNode ~= nil then
                    pChannalNode:setisvoiceAutoplay(isAutoPlay)
                end
                -- end

           end

           local btn_ChangeState = cc.uiloader:seekNodeByNameFast(chatVoiceLayer, "Button_ChangeState")
           btn_ChangeState:onButtonClicked(clickChangeState)

        end

        local voiceRoot = nil

        if runningScene.name == "SRDDZScene" or runningScene.name == "SSSScene" or runningScene.name == "HkFiveCardScene" or
            runningScene.name == "ShYMJScene" or runningScene.name == "YCMJScene" or runningScene.name == "WLScene" or runningScene.name == "NJMJScene" or
            runningScene.name == "WRNNScene" or runningScene.name == "CXMJScene"  or runningScene.name == "DDZScene" then

            voiceRoot = cc.uiloader:load("Node/Btn_VoiceType1.json")
            voiceRoot:setName("voiceRoot")
        end

        print("VoickRoot:",voiceRoot)

        voiceRoot:addTo(sceneRoot,100)

        local btn_Record1 = cc.uiloader:seekNodeByNameFast(voiceRoot, "Button_Record1")
        btn_Record1:setButtonSize(75, 76)

        if runningScene.name == "SSSScene" then


            -- btn_Record1:setButtonImage(cc.ui.UIPushButton.NORMAL, "Image/ChatFriend/btn_Record1s.png")
            -- btn_Record1:setButtonImage(cc.ui.UIPushButton.PRESSED, "Image/ChatFriend/btn_Record1s.png")
            -- btn_Record1:setButtonImage(cc.ui.UIPushButton.DISABLED, "Image/ChatFriend/btn_Record1s.png")
        end

        util.BtnScaleFun(btn_Record1)

        local img_Recording = display.newSprite("Image/ChatFriend/recording.png")
        img_Recording:addTo(util.curScene,20000)
        img_Recording:setPosition(display.cx,display.cy)
        img_Recording:hide()

        local clickVoice = function (event)

            if event.target == btn_Record1 then

                app.constant.chatType = 0

                util:ShowChatVoiceLayer(sceneRoot)
                print("clickRecord1------")
            end

        end

        isRecording = false
        isStopRecord = false
        local moveX
        local moveY

        local voiceCallback = function(event)

            if app.constant.isLoginChat == false then
                 ErrorLayer.new(app.lang.init_fChatFailed, nil, nil, nil, 1):addTo(util.curScene)
                 return
            end



            if event.name == "PRESSED_EVENT" then  --按下
                if img_Recording ~= nil then
                    img_Recording:show()
                end

                moveX = event.x
                moveY = event.y

                --如果频道未正常切换，在录音时在切换一次
                if util.openChannel == false and curChannal ~= nil then
                     print("openChannel again!-------")
                     util.OpenChannel(curChannal)
                end

                app.constant.chatType = 0

                util:SendVoice()
                print("按下按钮")
            elseif event.name == "RELEASE_EVENT" then   --释放
                isRecording = false

                if img_Recording ~= nil then

                    img_Recording:hide()

                end

                if isStopRecord then

                    isStopRecord = false
                    return
                end

                if math.abs(moveY-event.y)>40 then
                    print("取消点击")
                    util:CancelVoice()
                else
                    print("放开按钮")
                    util:EndVoice()
                end

                -- if event.touchInTarget then   --发送语音
                --     print("放开按钮")
                --     util:EndVoice()
                -- else   --取消语音
                --     print("取消点击")
                --     util:CancelVoice()
                -- end
            end
        end

       local  btn_Voice = nil

        if runningScene.name == "SSSScene" then

            --语音按钮
            btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice1.png",pressed="Image/ChatFriend/btn_voice1.png",disabled="Image/ChatFriend/btn_voice1s.png"})
            util.BtnScaleFun(btn_Voice)

            if btn_Voice ~= nil then
                btn_Voice:setPosition(1210,78)
            end

            btn_Record1:setPosition(1210,175)

        elseif runningScene.name == "HkFiveCardScene" then

            --btn_Voice = ccui.Button:create("Image/ChatFriend/btn_voice1.png","Image/ChatFriend/btn_voice11.png")
            btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice1.png",pressed="Image/ChatFriend/btn_voice1.png",disabled="Image/ChatFriend/btn_voice1.png"})

            if btn_Voice ~= nil then

                btn_Voice:setPosition(265,160)

                btn_Record1:setPosition(785,665)

            end
        elseif runningScene.name == "ShYMJScene" or runningScene.name == "YCMJScene" or runningScene.name == "NJMJScene" or runningScene.name == "CXMJScene" then

           -- btn_Voice = ccui.Button:create("Image/ChatFriend/btn_voice1.png","Image/ChatFriend/btn_voice11.png")
            btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice1.png",pressed="Image/ChatFriend/btn_voice1.png",disabled="Image/ChatFriend/btn_voice1.png"})
            util.BtnScaleFun(btn_Voice)

            if btn_Voice ~= nil then

                btn_Voice:setAnchorPoint(cc.p(0.5,0.5))
    --1211
                btn_Voice:setPosition(1222.55,258)

                btn_Record1:setPosition(1222.55,300.22)
                btn_Record1:hide()

            end
        elseif runningScene.name == "SRDDZScene" then
           -- btn_Voice = ccui.Button:create("Image/ChatFriend/btn_voice1.png","Image/ChatFriend/btn_voice11.png")
           btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice1.png",pressed="Image/ChatFriend/btn_voice1.png",disabled="Image/ChatFriend/btn_voice1.png"})

            if btn_Voice ~= nil then

                btn_Voice:setAnchorPoint(cc.p(0.5,1))
    --1211
                btn_Voice:setPosition(268,278)

                btn_Record1:setPosition(1128,668)

            end
        elseif runningScene.name == "WLScene" then
           -- btn_Voice = ccui.Button:create("Image/ChatFriend/btn_voice1.png","Image/ChatFriend/btn_voice11.png")
            btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice1.png",pressed="Image/ChatFriend/btn_voice1.png",disabled="Image/ChatFriend/btn_voice1.png"})

            if btn_Voice ~= nil then

            btn_Voice:setAnchorPoint(cc.p(0.5,0.5))
--1211
            btn_Voice:setPosition(150,143)

            btn_Record1:setAnchorPoint(cc.p(0.5,0.5))

            btn_Record1:setPosition(1125,654)

            end
        elseif runningScene.name == "WRNNScene" then
           -- btn_Voice = ccui.Button:create("Image/ChatFriend/btn_voice1.png","Image/ChatFriend/btn_voice11.png")
            btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice1.png",pressed="Image/ChatFriend/btn_voice1.png",disabled="Image/ChatFriend/btn_voice1.png"})

            if btn_Voice ~= nil then
                btn_Voice:setPosition(1210,78)
            end
            btn_Record1:setPosition(1210,175)
        elseif runningScene.name == "DDZScene" then
           -- btn_Voice = ccui.Button:create("Image/ChatFriend/btn_voice1.png","Image/ChatFriend/btn_voice11.png")
            btn_Voice = cc.ui.UIPushButton.new({normal="Image/ChatFriend/btn_voice_ddz.png",pressed="Image/ChatFriend/btn_voice_ddz.png",disabled="Image/ChatFriend/btn_voice_ddz.png"})

            if btn_Voice ~= nil then
                btn_Voice:setPosition(1230,280)
            end
            
            btn_Record1:setButtonImage(cc.ui.UIPushButton.NORMAL, "Image/ChatFriend/btn_Record_ddz.png")
            btn_Record1:setButtonImage(cc.ui.UIPushButton.PRESSED, "Image/ChatFriend/btn_Record_ddz.png")
            btn_Record1:setButtonImage(cc.ui.UIPushButton.DISABLED, "Image/ChatFriend/btn_Record_ddz.png")
            btn_Record1:setButtonSize(92, 92)
            btn_Record1:setPosition(1230,370)
        end

         if btn_Voice ~= nil then

            voiceRoot:addChild(btn_Voice,100)

            --btn_Voice:setPosition(61,224)

            btn_Voice:onButtonPressed(voiceCallback)
            btn_Voice:onButtonRelease(voiceCallback)
            --btn_Voice:addTouchEventListener(voiceCallback)

            print("btn_Voice---create")
        end

      --btn_Voice:onButtonPressed(btnPressed)
      --btn_Voice:onButtonRelease(btnRelease)
        btn_Record1:onButtonClicked(clickVoice)

        if requestFriendLayer == nil then

            requestFriendLayer = cc.uiloader:load("Layer/ChatMenu/FriendRequestLayer.json"):addTo(sceneRoot,11200)

            requestFrindList = {}
            requestFriendIndex = 0
            selectRequestList = {}

         end

            --初始化邀请列表
            --ResetRequestList()

         local btn_Request = nil

         if runningScene.name == "SSSScene" then
            --邀请好友按钮
            btn_Request = cc.ui.UIPushButton.new({
                    normal = "Image/ChatFriend/btn_Request1s.png",
                    pressed = "Image/ChatFriend/btn_Request2s.png",
                    disabled = "Image/ChatFriend/btn_Request1s.png"
                })
                :addTo(sceneRoot)

            util.BtnScaleFun(btn_Request)
            btn_Request:setPosition(450, 184.25)
         elseif runningScene.name == "HkFiveCardScene" then

            btn_Request = cc.ui.UIPushButton.new({
            normal = "Image/ChatFriend/btn_Request1.png",
            pressed = "Image/ChatFriend/btn_Request2.png",
            disabled = "Image/ChatFriend/btn_Request1.png"
            }):addTo(sceneRoot)

            btn_Request:setLocalZOrder(30000)
            btn_Request:setPosition(display.cx - 150, 122.68)

        elseif runningScene.name == "ShYMJScene" or runningScene.name == "YCMJScene" or runningScene.name == "NJMJScene" or runningScene.name == "CXMJScene" or runningScene.name == "DDZScene" then

            btn_Request = cc.ui.UIPushButton.new({
            normal = "Image/ChatFriend/btn_Request1.png",
            pressed = "Image/ChatFriend/btn_Request2.png",
            disabled = "Image/ChatFriend/btn_Request1.png"
            }):addTo(sceneRoot)

            btn_Request:setPosition(display.cx - 150, display.bottom + 120)

        elseif runningScene.name == "SRDDZScene" then
            btn_Request = cc.ui.UIPushButton.new({
            normal = "Image/ChatFriend/btn_Request1.png",
            pressed = "Image/ChatFriend/btn_Request2.png",
            disabled = "Image/ChatFriend/btn_Request1.png"
            }):addTo(sceneRoot)

            btn_Request:setPosition(display.cx - 145, 236.80)
        elseif runningScene.name == "WLScene" then
            btn_Request = cc.ui.UIPushButton.new({
            normal = "Image/ChatFriend/btn_Request1.png",
            pressed = "Image/ChatFriend/btn_Request2.png",
            disabled = "Image/ChatFriend/btn_Request1.png"
            }):addTo(sceneRoot)

            btn_Request:setPosition(510, 190.18)
        elseif runningScene.name == "WRNNScene" then
            btn_Request = cc.ui.UIPushButton.new({
            normal = "Image/ChatFriend/btn_Request1.png",
            pressed = "Image/ChatFriend/btn_Request2.png",
            disabled = "Image/ChatFriend/btn_Request1.png"
            }):addTo(sceneRoot)

            btn_Request:setPosition(-1040, 187.77)
        end

        if btn_Request then
            btn_Request:hide()
        end

        util.requestBtn = btn_Request

            print("btn_Request:",btn_Request)

             local requestCallback = function (event)

                --util:ShowRequestLayer(sceneRoot)
                print("requestBtn------")

             end


             btn_Request:onButtonClicked(requestCallback)

            local  button_ReqOk = cc.uiloader:seekNodeByNameFast( requestFriendLayer, "Button_ReqOk")

            local requestOk = function (event)

                print("requestOk------")

                local num = #selectRequestList

                if num == 0 then

                    if util.curScene ~= nil then

                     ErrorLayer.new(app.lang.selectFriend, nil, nil, nil):addTo(util.curScene)

                    end
                    return

                end

                --dump(util.UserInfo)

                --dump(selectRequestList)

                onReuestInvitation()

             end

            if button_ReqOk then
                button_ReqOk:onButtonClicked(requestOk)
            end


             local  button_ReqWchat = cc.uiloader:seekNodeByNameFast( requestFriendLayer, "Button_ReqWchat")

              local requestWChat = function (event)

                print("requestWChat------")
                requestFriendWeixin(false, Player.uid, util.checkNickName(Player.nickname))

             end

             if button_ReqWchat then
                 button_ReqWchat:onButtonClicked(requestWChat)
             end


    end

end

function util.SetRequestBtnShow()

    if util.requestBtn == nil then

        return

    end


    util.requestBtn:show()

end

function util.SetRequestBtnHide()

    if util.requestBtn == nil then

        return

    end

    util.requestBtn:hide()
end


function selectRequestItem( id )

     if requestFriendLayer == nil then

        return

    end

    print("selectItem:id", id)

    local  list_view = cc.uiloader:seekNodeByNameFast( requestFriendLayer, "ListView_ShowFriend")

    for k,v in pairs(requestFrindList) do

        if requestFrindList[k].yvID == id then

            print("item is equeal")

           local item = list_view.items_[requestFrindList[k].index]:getChildByTag(tonumber(id))
            if item == nil then

                print("item is null")
                return
            end

            local img_seleOk = cc.uiloader:seekNodeByNameFast( item, "img_seleOk")

            local ishas = false
            local index = 0

            for k,v in pairs(selectRequestList) do

                    if selectRequestList[k].yvID == id then

                       ishas = true
                       index = k
                       break

                    end

            end

            if not ishas then

                local msg = { yvID = id, uid = requestFrindList[k].uid }
                table.insert(selectRequestList, msg)

            else

                table.remove(selectRequestList,index)

            end

            img_seleOk:setVisible(not ishas)

           return

        end

    end
    -- body
end

function ResetRequestList()

    if requestFriendLayer == nil then

        return

    end

    local  list_view = cc.uiloader:seekNodeByNameFast( requestFriendLayer, "ListView_ShowFriend")

    if list_view == nil then

        return

     end

    list_view:removeAllItems()

    requestFrindList = {}
    requestFriendIndex = 0
    selectRequestList = {}

     for k,v in pairs(friendList) do

        if friendList[k].isline == true then

           RequestFriendList(friendList[k].yvID, friendList[k].uid, friendList[k].nickname, friendList[k].icon)

        end

    end

end

function RequestFriendList(yvID, uid, nickname, icon)

    if requestFriendLayer == nil then

        return

    end

   if uid == nil then

        print("this friend uid is nil")

   end

    print("util:RequestFriendList:----", yvID, uid, nickname, icon)


    for k,v in pairs(requestFrindList) do

        if requestFrindList[k].yvID == yvID then

           return

        end

    end

     local  list_view = cc.uiloader:seekNodeByNameFast( requestFriendLayer, "ListView_ShowFriend")

    if list_view ~= nil then

          local oneItem = nil

          local listItemLayout = list_view:newItem()

          local  button_SelectItem = nil

          oneItem = cc.uiloader:load("Node/Friend_RequestItem.json")

          local ClickSele = function (event)

                print("ClickSele------")

                local id = event.target:getTag()

                selectRequestItem(id)

          end

          local button_Select = cc.uiloader:seekNodeByNameFast( oneItem, "Button_Select")
          button_Select:onButtonClicked(ClickSele)
          button_Select:setTag(yvID)

          --选中好友
          list_view:onScroll(function (event)
           if event.name == "clicked" then

                print("clickRItem------:", event.x,event.y)
                for i,v in ipairs(list_view.items_) do
                    if v:hitTest(cc.p(event.x,event.y)) then

                        print("item:i",v:getTag())


                        local id = v:getTag()

                        selectRequestItem(id)

                        return
                    end
                  end
              end

           end)

          local text_Nick = cc.uiloader:seekNodeByNameFast( oneItem, "Text_Nick")
          text_Nick:setString(util.checkNickName(nickname))

          local text_ID_Value = cc.uiloader:seekNodeByNameFast( oneItem, "Text_ID_Value")
          text_ID_Value:setString(uid)

          local sprite_Head = cc.uiloader:seekNodeByNameFast( oneItem, "Sprite_Head")
          local Sprite_sbg = cc.uiloader:seekNodeByNameFast( oneItem, "Sprite_sbg")

          local isWeiChat = util.isWeiIcon(icon)

          if isWeiChat == false then

              rect = cc.rect(0, 0, 178, 176)
              frame = cc.SpriteFrame:create(icon, rect)
              sprite_Head:setSpriteFrame(frame)

              rect2 = cc.rect(0, 0, 105, 105)
              local iconBg = AvatarConfig:getBgByRolesUrl(icon)
              frame2 = cc.SpriteFrame:create(iconBg, rect2)
              Sprite_sbg:setSpriteFrame(frame2)

          else

            local newImage = AvatarConfig:getAvatar(2, 1000, 0)

            util.setHeadImage(sprite_Head:getParent(), icon, sprite_Head, newImage, 1, Sprite_sbg)

          end


          listItemLayout:addChild(oneItem,1,yvID)
          oneItem:setAnchorPoint(0.5,0.5)
          listItemLayout:setItemSize(573, 101)
          --oneItem:setPositionX(2.5)
          listItemLayout:setTag(yvID)
          listItemLayout:setPosition(0, requestFriendIndex*102)

          list_view:addItem(listItemLayout)

          requestFriendIndex = requestFriendIndex+1
          print("requestFriendIndex:",requestFriendIndex)

          local pos = list_view:getItemPos(listItemLayout)

          local msg = { yvID = yvID, uid = uid, nickname = nickname, icon = icon, index = pos}

          table.insert(requestFrindList, msg)

         local view = list_view:getViewRect()
         list_view:getScrollNode():setPositionX(view.x)

         list_view:getScrollNode():setPositionY(520-(requestFriendIndex-1)*102)

     end

end

function util.OpenChannel(channelID)

    if device.platform ~= "ios" and  device.platform ~= "android" then
        return
    end

    curChannal = channelID

--ping
   if app.constant.isLoginChat == false then
        util.openChannel = false
        return
   end
--end

    if util.openChannel == true then
        return
    end

    print("OpenChannel:",channelID)

    local hcData = yvcc.HclcData:sharedHD()

    local cId = 1

    hcData:ModchannalId(true, cId, channelID)

    local istance = hcData:getListen()

    local pChannalNode = istance:getChannalNode()

    pChannalNode:setisvoiceAutoplay(true)
    pChannalNode:SetCurChannalIndex(cId)
    pChannalNode:SetCurChannalStr(channelID)

    print("OpenChannel-result:",1)

    util.openChannel = true


end

function util.CloseChannel(isNot)
    util.UserInfo = {}
    if isNot == nil then
        util.curScene = {}
        --清除语音list
        util.DestroyChatVoiceLayer()
    end

    if device.platform ~= "ios" and  device.platform ~= "android" then

        return
    end

--ping
   if app.constant.isLoginChat == false then

        return

   end
-- --end

--     if util.openChannel == false then
--         return
--     end
    
    print("CloseChannel----")
    

    local hcData = yvcc.HclcData:sharedHD()

    local istance = hcData:getListen()

    local pChannalNode = istance:getChannalNode()

    local cId = 1

    if curChannal ~= nil then
        hcData:ModchannalId(false, cId, curChannal)
    end

    pChannalNode:setisvoiceAutoplay(false)

    pChannalNode:releaseVoiceList()

    print("SCloseChannel:",1,curChannal)
    util.openChannel = false
    curChannal = nil

end

function StopVoiceCallback(result, isstop)

    isRecording = result
    isStopRecord = istex

    print("StopVoice---isRecord:isStop:", isRecording, isStopRecord)


end

--开始录音公共函数- type:1 游戏语音,type:2 好友语音
function util.SendVoice()


    if isStopRecord then

         return

    end

    if isRecording then

         return

    end

     local stype = app.constant.chatType

     local nYvID = app.constant.m_curYvID

     print("SendVoice:, curYvID:", app.constant.chatType, nYvID)

     local istance = yvcc.HclcData:sharedHD():getListen()

     local pChatNode =  istance:getFriendChatNode(nYvID)

     local pChannalNode = istance:getChannalNode()

     if stype == 1 then

            if pChatNode then

                pChatNode:setisvoiceAutoplay(false)
                pChatNode:setFrindChat(false)
                pChatNode:BeginVoice()

            else

                print("can not find Friend SendVoice")

            end

     else

          pChannalNode:setFrindChat(false)
        --开始录音
          pChannalNode:BeginVoice()

     end


    isRecordVoice = true


end

--结束录音
function util:EndVoice(nick)

     local stype = app.constant.chatType
     local nickName = util.checkNickName(Player.nickname)

     local istance = yvcc.HclcData:sharedHD():getListen()
     local nYvID = app.constant.m_curYvID
     local pChatNode = istance:getFriendChatNode(nYvID)

     local pChannalNode = istance:getChannalNode()

     if stype == 1 then

        pChatNode:EndVoice(nickName)

     else

          --结束录音
        pChannalNode:EndVoice(nickName)

     end
end

--取消录音
 function util:CancelVoice()

    local nYvID = app.constant.m_curYvID
    local stype = app.constant.chatType


    local istance = yvcc.HclcData:sharedHD():getListen()
    local pChatNode =  istance:getFriendChatNode(nYvID)


     if stype == 1 then

        pChatNode:CancelVoice()

     else

        local pChannalNode = istance:getChannalNode()
          --结束录音
        pChannalNode:CancelVoice()

     end

end


function util:DestroyChatVoiceLayer()

    if chatVoiceLayer == nil then

        return

    end

    if requestFriendLayer == nil then

        return

    end

  --  chatVoiceLayer:removeFromParent()
    chatVoiceLayer = nil
    ChannelMsgIndex = 0

  --  requestFriendLayer:removeFromParent()
    requestFriendLayer = nil


    requestFrindList = {}
    requestFriendIndex = 0

    selectRequestList = {}

end

function util:ShowRequestLayer(sceneRoot)

     if requestFriendLayer == nil then

        return

    end

    --local myxml = cc.FileUtils:getInstance():getStringFromFile("Image/ChatFriend/emotions/FaceConfig.xml");
    --print(myxml)
    if isOpenRequest == true then
        return
    end


    local imgBg = ccui.ImageView:create()
  --local imgBg = ccui.ImageView:create("Image/Public/Tips_Body_Square.png")

    local Image_ShowFriend = cc.uiloader:seekNodeByNameFast(requestFriendLayer, "Image_ShowFriend")
    print("requestFriendLayer:" .. type(requestFriendLayer))
    print("Image_ShowFriend:" .. type(Image_ShowFriend))


    local  action = cc.MoveTo:create(0.4, cc.p(631, 360))

        --img_ShowVoice:runAction(action)

    transition.execute(Image_ShowFriend, action, {
        easing = "sineIn",
        onComplete = function()
            print("move completed")

            --重置邀请列表
            ResetRequestList()

            --testList()
        end,
    })

    isOpenRequest = true

    --imgBg:loadTexture("Image/Public/Tips_Body_Square.png")

    imgBg:setScale9Enabled(true)

    imgBg:setContentSize(641,720)
    imgBg:setAnchorPoint(0,0.5)
    imgBg:setPosition(0,360)
    imgBg:setTouchEnabled(true)

    Image_ShowFriend:setLocalZOrder(2)

    requestFriendLayer:addChild(imgBg)

    imgBg:addTouchEventListener(function (sender,eventType)

        if eventType == ccui.TouchEventType.ended then

                local Image_ShowFriend = cc.uiloader:seekNodeByNameFast(requestFriendLayer, "Image_ShowFriend")
                local  action1 = cc.MoveTo:create(0.3, cc.p(1280, 360))
                transition.execute(Image_ShowFriend, action1, {
                easing = "sineInOut",
                onComplete = function()
                    print("move completed--")

                    if imgBg ~= nil then

                        imgBg:removeFromParent()
                        imgBg = nil

                    end

                    isOpenRequest = false
                end,
            })

         end
    end)



end

function util:ShowChatVoiceLayer(sceneRoot)

    if chatVoiceLayer == nil then

        return

    end

    if isOpenRecord then

        return

    end

    local imgBg = ccui.ImageView:create()
  --local imgBg = ccui.ImageView:create("Image/Public/Tips_Body_Square.png")

  print("chatVoiceLayer:",chatVoiceLayer)

    local img_ShowVoice = cc.uiloader:seekNodeByNameFast(chatVoiceLayer, "Image_ShowVoice")

    print("img_ShowVoice:",img_ShowVoice)

  --  img_ShowVoice:setTouchEnabled(true)

    local  action = cc.MoveTo:create(0.4, cc.p(631, 360))


    transition.execute(img_ShowVoice, action, {
        easing = "sineIn",
        onComplete = function()
            print("move completed")

            --testList()
        end,
    })


    isOpenRecord = true

    --imgBg:loadTexture("Image/Public/Tips_Body_Square.png")

    imgBg:setScale9Enabled(true)

    imgBg:setContentSize(641,720)
    imgBg:setAnchorPoint(0,0.5)
    imgBg:setPosition(0,360)
    imgBg:setTouchEnabled(true)

    img_ShowVoice:setLocalZOrder(2)

    chatVoiceLayer:addChild(imgBg,20000)

    imgBg:addTouchEventListener(function (sender,eventType)

        if eventType == ccui.TouchEventType.ended then

                local img_ShowVoice = cc.uiloader:seekNodeByNameFast(chatVoiceLayer, "Image_ShowVoice")
                local  action1 = cc.MoveTo:create(0.3, cc.p(1280, 360))
                transition.execute(img_ShowVoice, action1, {
                easing = "sineInOut",
                onComplete = function()
                    print("move completed--")
                    isOpenRecord = false
                    if imgBg ~= nil then

                        imgBg:removeFromParent()
                        imgBg = nil

                    end

                    --chatVoiceLayer:removeFromParent()
                end,
            })

         end
    end)



end

function ShowChatVoiceLayer(Num)

   print("ShowChatVoiceLayer:",Num)

   return 100

end

function getIsHasItem(msgId)

    if chatVoiceLayer == nil then

        return

    end

    local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

    if list_view == nil then
        print("list_view is nil")
        return
    end

    print("getIsHasItem is Run")

    for i,v in ipairs(list_view.items_) do
        local tagID = v:getTag()
        if msgId == tagID then
             return 1
        end
    end

    print("getIsHasItem find no id item")

   return 0

end


-- --显示下载完成的声音按钮
function SetShowVoiceBtn(msgId)

     if chatVoiceLayer == nil then

        return

     end

     local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

    if list_view == nil then
        print("list_view is nil")
        return
    end


    for i,v in ipairs(list_view.items_) do
        local tagID = v:getTag()
        if msgId == tagID then

          local item = v:getChildByTag(tagID)

          local btn_PlayVoice = item:getChildByTag(msgId)

          if btn_PlayVoice ~= nil then

             btn_PlayVoice:show()

             print("SetShowVoiceBtn------")
          end

             return 1
        end
    end

    return 0

end

function OpenWaitAnim(msgId, isSend)

    if chatVoiceLayer == nil then

        return

    end

    local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

    if list_view == nil then
        print("list_view is nil")
        return
    end

    local item = nil

    for i,v in ipairs(list_view.items_) do
        local tagID = v:getTag()
        if msgId == tagID then

           item = v:getChildByTag(tagID)

            print("SetWaitAnim------",item)

            break
        end
    end

     if item ~= nil then

         local  btn_PlayVoice = item:getChildByTag(msgId)

         if btn_PlayVoice ~= nil then

            local waitAction = display.newSprite("Image/ChatFriend/wait.png")
            waitAction:setAnchorPoint(cc.p(0.5,0.5))
            waitAction:setScale(0.5)
            local w = btn_PlayVoice:getCascadeBoundingBox().size.width
            if isSend then
                waitAction:pos(btn_PlayVoice:getPositionX()-w/2-15, btn_PlayVoice:getPositionY())
            else
                waitAction:pos(btn_PlayVoice:getPositionX()+w/2+15, btn_PlayVoice:getPositionY())
            end

            item:addChild(waitAction, 0, 5555)
            print("WaitAnim--add--")

            local action = cc.RepeatForever:create(cca.rotateBy(0.05, 10))

             waitAction:runAction(action)

          end
    end

end

function CloseWaitAnim(msgId, isSend)

     if chatVoiceLayer == nil then

        return

    end

    local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

    if list_view == nil then
        print("list_view is nil")
        return
    end

    local item = nil

    for i,v in ipairs(list_view.items_) do
        local tagID = v:getTag()
        if msgId == tagID then

           item = v:getChildByTag(tagID)

            print("CloseWaitAnim------",item)

            break
        end
    end

     if item ~= nil then

         local  waitAction = item:getChildByTag(5555)

         if waitAction ~= nil then

            waitAction:stopAllActions()
            waitAction:removeFromParent()

            print("CloseWaitAnim111111------")

         end
    end

end

-- 显示播放声音动画
function ShowPlayAction(msgId, isSend)

     if chatVoiceLayer == nil then

        return

     end

     local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

    if list_view == nil then
        print("list_view is nil")
        return
    end

    local item = nil

    for i,v in ipairs(list_view.items_) do
        local tagID = v:getTag()
        if msgId == tagID then

           item = v:getChildByTag(tagID)

            print("ShowPlayAction------",item)

            break
        end
    end

    if item ~= nil then

         local  btn_PlayVoice = item:getChildByTag(msgId)

         if btn_PlayVoice ~= nil then

            local playAction = display.newSprite("Image/ChatFriend/playImg3.png")
            playAction:setAnchorPoint(cc.p(1,0.5))
            --local w = btn_PlayVoice:getCascadeBoundingBox().size.width
            if isSend then

                playAction:pos(btn_PlayVoice:getPositionX()-10, btn_PlayVoice:getPositionY())
            else
                playAction:pos(btn_PlayVoice:getPositionX()+30, btn_PlayVoice:getPositionY())
                playAction:setFlippedX(true)
            end

             print("ShowPlayAction-11-----")

            item:addChild(playAction, 0, 9999)

            local  actionShow = item:getChildByTag(10000)
             if actionShow then
                actionShow:hide()
             end

            local animation = cc.Animation:create()
            for i=1,3 do
                local sprite = display.newSprite("Image/ChatFriend/playImg" .. i .. ".png")
                animation:addSpriteFrame(sprite:getSpriteFrame())
            end
            animation:setDelayPerUnit(0.2)

             local animate = cc.Animate:create(animation);
             playAction:runAction(cc.RepeatForever:create(animate))

          end
    end

    return 0

end
 -- 停止播放声音动画
function StopPlayAction(msgId)

     if chatVoiceLayer == nil then

        return

     end

     local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

    if list_view == nil then
        print("list_view is nil")
        return
    end

    local item = nil

    for i,v in ipairs(list_view.items_) do
        local tagID = v:getTag()
        if msgId == tagID then

             item = v:getChildByTag(tagID)

             print("StopPlayAction------")

             break
        end
    end

    if item ~= nil then

         local  playAction = item:getChildByTag(9999)

         local  actionShow = item:getChildByTag(10000)
         if actionShow then
            actionShow:show()
         end

         if playAction ~= nil then

            playAction:stopAllActions()
            playAction:removeFromParent()

            print("StopPlayAction1111------")

         end

    end


    return 0

end


function setChatMessage(nickName, sendItem, friendFlag, timeLong, gameID, iconImage, ishasVoice, isnew, msgText, ...)

    if app.constant.enterGameUInfo ~= nil then
        dump(app.constant.enterGameUInfo,"setChat = ")
    end

    print("nickName = ", nickName)

    local isInRoom = false
    for k,v in pairs(app.constant.enterGameUInfo) do

            if util.checkNickName(app.constant.enterGameUInfo[k].nickname) == util.checkNickName(nickName) then
               isInRoom = true
               break
            end

    end
    if isInRoom == false then

        return
    end

    if chatVoiceLayer == nil then

        return

    end

   local chatIndex = { id = 1, sendId = 2, recvId = 3, mType = 1, state = 5, sendTime = 6, playState = 7}
   local chatMsg = { }

   for i,v in ipairs{...} do

        chatMsg[i] = v

        print(i,v)

   end

   print("nickName:sendItem:friendFlag", nickName, sendItem, friendFlag)
   print("gameID:iconImage:ishasVoice:isnew:", gameID, iconImage, ishasVoice, isnew)

   print("chatMsg.id:", chatMsg[chatIndex.id])
   print("chatMsg.sendId:", chatMsg[chatIndex.sendId])
   print("chatMsg.recvId:", chatMsg[chatIndex.recvId])
   print("chatMsg.mType:", chatMsg[chatIndex.mType])
   print("chatMsg.state:", chatMsg[chatIndex.state])
   print("chatMsg.sendTime:", chatMsg[chatIndex.sendTime])
   print("chatMsg.playState:", chatMsg[chatIndex.playState])


   local list_view = cc.uiloader:seekNodeByNameFast( chatVoiceLayer, "ListView_ShowVoice")

   print("chatVoiceLayer:",  chatVoiceLayer)

   if list_view ~= nil then

      local oneItem = nil

      local listItemLayout = list_view:newItem()

      local  btn_PlayVoice = nil
      --local  panel_SendItem = nil
      --local  panel_RecvItem = nil

      if sendItem then

            oneItem = cc.uiloader:load("Node/Chat_SendItem.json")

            --Panel_SendItem = cc.uiloader:seekNodeByNameFast( oneItem, "Panel_SendItem")

            print("panel_SendItem:", oneItem)

            btn_PlayVoice = ccui.Button:create("Image/ChatFriend/btn_Send1.png","Image/ChatFriend/btn_Send2.png")

      else

           oneItem = cc.uiloader:load("Node/Chat_RecvItem.json")

           --panel_RecvItem = cc.uiloader:seekNodeByNameFast( oneItem, "Panel_RecvItem")

           print("panel_RecvItem:", oneItem)

           btn_PlayVoice = ccui.Button:create("Image/ChatFriend/btn_Recv1.png","Image/ChatFriend/btn_Recv2.png")

           btn_PlayVoice:setFlippedX(true)

      end

      --local  btn_PlayVoice = cc.uiloader:seekNodeByNameFast( oneItem, "Button_PlayVoice")


        --播放录音
        local playVoice = function (sender,eventType)

            --print(sender:getTag())

            local voiceID = sender:getTag()

             voiceID = voiceID .. ""

            --msgID = msgID .. ""

            print("PlayVoice--------:", voiceID)


            local stype = app.constant.chatType

            local istance = yvcc.HclcData:sharedHD():getListen()

             local nYvID = app.constant.m_curYvID

            local pChatNode =  istance:getFriendChatNode(nYvID)

            if eventType == ccui.TouchEventType.began then

                if stype == 1 then

                    if pChatNode then

                        pChatNode:PlayVoiceEx(voiceID, true)

                    else

                        print("can not find Friend SendVoice")

                    end

                 else

                    local pChannalNode = istance:getChannalNode()
                     --播放录音
                     pChannalNode:PlayVoiceEx(voiceID, true)

                 end
            elseif eventType == ccui.TouchEventType.ended then

                yvcc.HclcData:sharedHD():setCurPlayID(voiceID)

                if stype == 1 then

                    if pChatNode then

                        pChatNode:PlayVoiceEx(voiceID, false)

                    else

                        print("can not find Friend SendVoice")

                    end

                 else

                    local pChannalNode = istance:getChannalNode()
                     --播放录音
                     pChannalNode:PlayVoiceEx(voiceID, false)

                 end

            end

        end


          local text_Time = cc.uiloader:seekNodeByNameFast( oneItem, "Text_Time")

         -- local strTime = os.date("%H:%M:%S", chatMsg[chatIndex.sendTime])
          text_Time:setString(timeLong .. " \" ")

          local scaleX = timeLong/60

          print("scaleX:", scaleX)

          local text_SendTime = cc.uiloader:seekNodeByNameFast( oneItem, "Text_SendTime")
          local strTime = os.date("%H:%M:%S", chatMsg[chatIndex.sendTime])
           text_SendTime:setString(strTime)


         if btn_PlayVoice ~= nil then

            if sendItem then
               oneItem:addChild(btn_PlayVoice, 0, chatMsg[chatIndex.id])
               btn_PlayVoice:setPosition(455,37)
               btn_PlayVoice:setAnchorPoint(1, 0.5)
               btn_PlayVoice:setScaleX(1+scaleX)
               local w = btn_PlayVoice:getCascadeBoundingBox().size.width
               text_Time:setPositionX(btn_PlayVoice:getPositionX()-w-5)

            else
               oneItem:addChild(btn_PlayVoice, 0, chatMsg[chatIndex.id])
               btn_PlayVoice:setPosition(114,37)
               btn_PlayVoice:setAnchorPoint(1, 0.5)
               btn_PlayVoice:setScaleX(1+scaleX)
               local w = btn_PlayVoice:getCascadeBoundingBox().size.width
               text_Time:setPositionX(btn_PlayVoice:getPositionX()+w+5)
            end

            btn_PlayVoice:setTag(tonumber(chatMsg[chatIndex.id]))
            btn_PlayVoice:addTouchEventListener(playVoice)


             local playAction = display.newSprite("Image/ChatFriend/playImg3.png")
            playAction:setAnchorPoint(cc.p(1,0.5))
            --local w = btn_PlayVoice:getCascadeBoundingBox().size.width
            if sendItem then

                playAction:pos(btn_PlayVoice:getPositionX()-10, btn_PlayVoice:getPositionY())
            else
                playAction:pos(btn_PlayVoice:getPositionX()+30, btn_PlayVoice:getPositionY())
                playAction:setFlippedX(true)

            end

             print("ShowPlayAction-11-----")

             oneItem:addChild(playAction, 1000, 10000)


        end

      if ishasVoice then

        btn_PlayVoice:show()

      else

        btn_PlayVoice:hide()

        print("Wait Down voice!")
        -- 显示等待下载到提示

      end

      local newNick = util.checkNickName(nickName)
      local newImage = iconImage

      local imageid = nil

      --if not sendItem then

         for k,v in pairs(app.constant.enterGameUInfo) do

            if app.constant.enterGameUInfo[k].nickname == nickName then

                newNick = nickName

                 print("newNick," .. newNick)

                local gold = app.constant.enterGameUInfo[k].gold
                local sex = app.constant.enterGameUInfo[k].sex
                local viptype = app.constant.enterGameUInfo[k].viptype

                newImage = AvatarConfig:getAvatar(sex, gold, viptype)

                imageid = app.constant.enterGameUInfo[k].imageid

               break

            end

         end

      --end

      local text_Nick = cc.uiloader:seekNodeByNameFast( oneItem, "Text_Nick")
      text_Nick:setString(newNick)

      local sprite_Head = cc.uiloader:seekNodeByNameFast( oneItem, "Sprite_Head")
      local Sprite_sbg = cc.uiloader:seekNodeByNameFast( oneItem, "Sprite_sbg")

      local isWeiChat = util.isWeiIcon(iconImage)

      if isWeiChat == false then

        if imageid ~= nil and imageid ~= "" then
             util.setHeadImage(sprite_Head:getParent(), imageid, sprite_Head, newImage, 1, Sprite_sbg)
        else
             rect = cc.rect(0, 0, 178, 176)
             frame = cc.SpriteFrame:create(newImage, rect)
             sprite_Head:setSpriteFrame(frame)

             rect2 = cc.rect(0, 0, 105, 105)
             local iconBg = AvatarConfig:getBgByRolesUrl(newImage)
             frame2 = cc.SpriteFrame:create(iconBg, rect2)
             Sprite_sbg:setSpriteFrame(frame2)
        end

      else
            util.setHeadImage(sprite_Head:getParent(), iconImage, sprite_Head, newImage, 1, Sprite_sbg)
      end

      listItemLayout:addChild(oneItem,0,chatMsg[chatIndex.id])
      oneItem:setAnchorPoint(0.5,0.5)
      listItemLayout:setItemSize(526, 110)
      listItemLayout:setTag(chatMsg[chatIndex.id])

      local  off = #(list_view.items_)
      print("off:",off)

      if off >= 10 then
        list_view:removeItem(list_view.items_[1], true)

      end

      --listItemLayout:setPosition(0, ChannelMsgIndex*113)

      listItemLayout:setPosition(0, -(ChannelMsgIndex)*113)

      print("x1,y1",listItemLayout:getPositionX(),listItemLayout:getPositionY())

     -- listItemLayout:setContent()
      list_view:addItem(listItemLayout)

      ChannelMsgIndex = ChannelMsgIndex+1

     local view = list_view:getViewRect()
     list_view:getScrollNode():setPositionX(view.x)

     --list_view:resetPosition()

    local poinY = (ChannelMsgIndex-1)*113

    if poinY > 460 then

        list_view:getScrollNode():setPositionY(view.y+poinY)
    else

        list_view:getScrollNode():setPositionY(530)
    end


      print("list_view:", list_view)

    end


   return 1

end

function util.setRequestLayer(runningScene, sureCallBack)

    -- if app.constant.gameid == 0 then
    --     print("game ID is error!")
    --     return
    -- end

    if runningScene == nil then

        return
    end

    local requestRoot = runningScene:getChildByTag(1000)

    if requestRoot == nil then

        requestRoot = RequestLayer.new(app.lang.requestTitle, nil,
        RequestLayer.ConfirmDefault, true, nil, sureCallBack, nil)
        :addTo(runningScene, 100, 1000)

    else

        return

    end

    local text_Cotent = cc.uiloader:seekNodeByNameFast(requestRoot, "Text_Cotent")
    local image_Bg = cc.uiloader:seekNodeByNameFast(requestRoot, "Image_Bg")

    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(text_Cotent:getWidth(), text_Cotent:getHeight()))
    local font = text_Cotent:getSystemFontName()
    local fontsize = text_Cotent:getSystemFontSize()


    print("gameid:",app.constant.requestInfo.gameid)
    print("nickName:",app.constant.requestInfo.nickname)

    local nick = "{" .. app.constant.requestInfo.nickname .. "}"
    local roomid = app.constant.requestInfo.roomid
    local gameid = app.constant.requestInfo.gameid

    local config = RoomConfig:getGameConfig(gameid)

    local re1 = ccui.RichElementText:create( 1, cc.c3b(77, 77, 77), 255, "您的好友",font, fontsize )
    local re2 = ccui.RichElementText:create( 2, cc.c3b(230, 149, 159), 255, nick, font, fontsize )
    local re3 = ccui.RichElementText:create( 3, cc.c3b(77, 77, 77), 255, "正在邀请您进入", font, fontsize )
    local re4 = ccui.RichElementText:create( 4, cc.c3b(2, 151,  214), 255, config.name, font, fontsize )
    local re5 = ccui.RichElementText:create( 5, cc.c3b(77, 77, 77), 255, "游戏的", font, fontsize )
    local re6 = ccui.RichElementText:create( 6, cc.c3b(228,  189, 105), 255, roomid, font, fontsize )
    local re7 = ccui.RichElementText:create( 7, cc.c3b(77, 77, 77), 255, "房间进行游戏", font, fontsize )

    richText:pushBackElement(re1)
    richText:insertElement(re2, 1)
    richText:pushBackElement(re3)
    richText:pushBackElement(re4)
    richText:pushBackElement(re5)
    richText:pushBackElement(re6)
    richText:pushBackElement(re7)
  --richText:insertElement(reimg, 2)

    richText:setLocalZOrder(10)
    richText:setPosition( text_Cotent:getPosition() )
    richText:addTo(image_Bg)

end

function util.setPublickInfoLayer(runningScene, sureCallBack)

    -- if app.constant.gameid == 0 then
    --     print("game ID is error!")
    --     return
    -- end

    if runningScene == nil then

        return
    end

    local requestRoot = runningScene:getChildByTag(1000)

    if requestRoot == nil then

        requestRoot = RequestLayer.new(app.lang.requestTitle, nil,
        RequestLayer.ConfirmSingle, true, true, sureCallBack, nil)
        :addTo(runningScene, 100, 1000)

    else

        return

    end

    local text_Cotent = cc.uiloader:seekNodeByNameFast(requestRoot, "Text_Cotent")
    local image_Bg = cc.uiloader:seekNodeByNameFast(requestRoot, "Image_Bg")
    local sure = cc.uiloader:seekNodeByNameFast(requestRoot, "Button_Sure")
    util.BtnScaleFun(sure,sure:getScale())

    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(text_Cotent:getWidth()+20, text_Cotent:getHeight()))
    local font = text_Cotent:getSystemFontName()
    local fontsize = text_Cotent:getSystemFontSize()

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)

    local name = "“ " .. platConfig.name .. "游戏" .. " ”"
    local publickId = "“ " .. platConfig.public_id .. " ”"
    local roomid = app.constant.requestInfo.roomid
    local gameid = app.constant.requestInfo.gameid

    local config = RoomConfig:getGameConfig(gameid)

    local re1 = ccui.RichElementText:create( 1, cc.c3b(107, 10, 3), 255, "暂不支持直接关注公众号，请打开微信搜索 ",font, fontsize )
    local re2 = ccui.RichElementText:create( 2, cc.c3b(255, 0, 21), 255, name, font, fontsize )
    local re3 = ccui.RichElementText:create( 3, cc.c3b(107, 10, 3), 255, " 或 ", font, fontsize )
    local re4 = ccui.RichElementText:create( 4, cc.c3b(255, 0, 21), 255, publickId, font, fontsize )
    local re5 = ccui.RichElementText:create( 5, cc.c3b(107, 10, 3), 255, "点击关注，谢谢！", font, fontsize )

    richText:pushBackElement(re1)
    richText:insertElement(re2, 1)
    richText:pushBackElement(re3)
    richText:pushBackElement(re4)
    richText:pushBackElement(re5)
    -- richText:pushBackElement(re6)
    -- richText:pushBackElement(re7)
  --richText:insertElement(reimg, 2)

    richText:setLocalZOrder(10)
    richText:setPosition( text_Cotent:getPosition() )
    richText:addTo(image_Bg)

end

function util.setRichText(pareNode, pos, textTable, textWidth, textHeight, fontSize)

    if pareNode == nil then
        return
    end

    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(textWidth, textHeight))
    local font = "Arial"
    local fontsize = fontSize

    local textCount = #textTable
    for i = 1, textCount do
        local re1 = ccui.RichElementText:create( i, textTable[i].color, 255, textTable[i].text, font, fontsize )
        richText:pushBackElement(re1)
    end

    richText:setLocalZOrder(10)
    richText:setAnchorPoint(cc.p(0.5, 0.5))
    richText:setPosition(pos)
    richText:addTo(pareNode)

end

function util.stringFormatEx(inputstr,maxLen)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
    -- local ml = maxLen

    local line_num = 1
    local result = ""

    local function add_newLine(inputstr,index)
        local len = #inputstr

        if len <= maxLen then
            result = inputstr
        end

        local width = 0
        local i = 1
        while (i<=len)
        do
            local curByte = string.byte(inputstr, i)
            local byteCount = 1;
            if curByte>0 and curByte<=127 then
                byteCount = 1                                               --1字节字符
            elseif curByte>=192 and curByte<223 then
                byteCount = 2                                               --双字节字符
            elseif curByte>=224 and curByte<239 then
                byteCount = 3                                               --汉字
            elseif curByte>=240 and curByte<=247 then
                byteCount = 4
            else
                byteCount = 1                                         --todo                                               --4字节字符
            end

            if i + byteCount - 1 > maxLen then
                local front = string.sub(inputstr,index,i - 1)
                local behind = string.sub(inputstr,i,-1)
                line_num = line_num + 1
                result = result .. front .. ".."
                -- if #behind <= maxLen then
                --     result = result .. behind
                -- else
                --     add_newLine(behind,1)
                -- end
                -- break
                return result
            end
            -- local char = string.sub(inputstr, i, i+byteCount-1)
            -- print(char)                                                --看看这个字是什么
            i = i + byteCount                                             --create置下一字节的索引
            width = width + 1                                             -- 字符的个数（长度）
        end
    end

    add_newLine(inputstr,1)
    print("line_num:" .. line_num)
    return result
end

--字符串inputstr的字符长度如果大于maxLen，则在maxLen位置后加换行符'\n',
--如果maxLen+1处是多字节字符，则在这个字符前加换行符
function util.stringFormat(inputstr,maxLen)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
    -- local ml = maxLen

    local line_num = 1
    local result = ""

    local function add_newLine(inputstr,index)
        local len = #inputstr

        if len <= maxLen then
            result = inputstr
        end

        local width = 0
        local i = 1
        while (i<=len)
        do
            local curByte = string.byte(inputstr, i)
            local byteCount = 1;
            if curByte>0 and curByte<=127 then
                byteCount = 1                                               --1字节字符
            elseif curByte>=192 and curByte<223 then
                byteCount = 2                                               --双字节字符
            elseif curByte>=224 and curByte<239 then
                byteCount = 3                                               --汉字
            elseif curByte>=240 and curByte<=247 then
                byteCount = 4                                               --4字节字符
            end

            if i + byteCount - 1 > maxLen then
                local front = string.sub(inputstr,index,i - 1)
                local behind = string.sub(inputstr,i,-1)
                line_num = line_num + 1
                result = result .. front .. "\n"
                if #behind <= maxLen then
                    result = result .. behind
                else
                    add_newLine(behind,1)
                end
                break
            end
            -- local char = string.sub(inputstr, i, i+byteCount-1)
            -- print(char)                                                          --看看这个字是什么
            i = i + byteCount                                             --create置下一字节的索引
            width = width + 1                                             -- 字符的个数（长度）
        end
    end

    add_newLine(inputstr,1)
    print("line_num:" .. line_num)
    return result,line_num
end

function util.getByteLen(str)
    local len = #str
    local byteLen = 0
    for i = 1,len do
        local curByte = string.byte(str, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1                                               --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2                                               --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3                                               --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                               --4字节字符
        end
        byteLen = byteLen + byteCount
    end
    return byteLen
end
--初始化GameState
function util.GameStateInit()
    GameState.init(function(param)
        local returnValue=nil
        if param.errorCode then
            print("error:" .. tostring(param.errorCode))
        else
            -- crypto
            if param.name=="save" then
                local str=json.encode(param.values)
                str=crypto.encryptXXTEA(str, "aaddcc")
                returnValue={data=str}
            elseif param.name=="load" then
                local str=crypto.decryptXXTEA(param.values.data, "aaddcc")
                returnValue=json.decode(str)
            end
            -- returnValue=param.values
        end
        return returnValue
    end, "localdata","4321dcba")
    GameData=GameState.load()
    if not GameData then
        GameData={}
    end
   -- dump(GameData)
    --默认声音开关打开
    if GameData.musicOn == nil then
        app.constant.musicOn = true
    else
        app.constant.musicOn = GameData.musicOn
    end
    if GameData.voiceOn == nil then
        app.constant.voiceOn = true
    else
        app.constant.voiceOn = GameData.voiceOn
    end
end

function util.GameStateSave(key,value)
    GameData[key]=value
    GameState.save(GameData)
end

function util.num2str(val,sign)
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
            ret = k .. sign .. ret
        end
        val = math.floor(val/10000)
    end
    return string.format("%s%d", symbol, val)..sign..ret
end

function util.num2str_atlas(val)
    return util.num2str(val,":")
end

function util.num2str_text(val)
    return util.num2str(val,",")
end

function util.num2str_thousand(val)
    if not val or type(val) == "string" then
        val = checkint(val)
    end

    local symbol = ""

    if val < 0 then
        symbol = "-"
    end

    local gold = math.abs(val)
    if gold < 10000 then
        return symbol .. gold
    else
        local wan = math.floor(gold/10000)
        local qian = math.floor((gold % 10000) / 1000)
        if qian == 0 then
            return symbol .. wan .. "万"
        else
            return symbol .. wan .. "." .. qian .. "万"
        end
    end
end


-- function util.getLastLoginDay()

--     local lastloginTime = cc.UserDefault:getInstance():getDataForKey("LoginTime")

--     local pretime = os.time(lastloginTime)
--     print(os.date("08 Olympic Games time is %x", pretime))

--     -- 现在的时间
--     local timetable = os.date("*t");
--     local nowtime = os.time(timetable)
--     print(os.date("now time is %c", nowtime))

--     local difft = os.difftime(nowtime, pretime)

--     local day = difft/(24*60*60)

--     print("现在和过去差几天:", day)


-- end

function util.DEBUG_LOG(text)
    local path = cc.FileUtils:getInstance():getWritablePath() .. "debugLogaaa.txt"
    print("可写路径 = " .. path)
    local f = io.open(path,"a")
    if f then

        print("开始写文件")

        text = '\n' .. text
        f:write(text)

        print("写文件结束")
    end

    io.close(f)
end

function util.setImageNodeHide(bgRoot, tag)

     if bgRoot == nil then

        return

     end

    local icon = bgRoot:getChildByTag(10000+tag)

    if icon ~= nil then

         print("icon---")

        icon:removeFromParent()

    end


end

--http://wx.qlogo.cn/mmopen/BmTDvkQTDBkKqLgEaSlCflPEkkqvfRXDiblicgSqPYIIvCkUxgMiarnsKVCr6vJcvDUhohfsyHRYESx8bsIcfqPLdYLfBgq8XpC/0

function util.isWeiIcon(imageid)


    print("imageid = ",imageid)

    if imageid ~= nil and imageid ~= "" then

        local a = string.byte(imageid,-1)
        a = string.char(a)

        print("a = ", a)

        if a == "0" then

          return true

        end

    end

    return false

end

function util.CircleProgress()


    local pro = CCProgressTimer:create(Sprite)
    pro:setType(kCCProgressTimerTypeRadial)
    pro:setPercentage(0)

end

function util.clearActivityImage(bgRoot, tag)

     if bgRoot == nil then

        return

     end

    local icon = bgRoot:getChildByTag(30000+tag)

    if icon ~= nil then

        icon:removeFromParent()

    end


end

function util.preDownActivety(bgroot,activityName)

    local tempMd5 = crypto.md5(activityName)

    local dirname = cc.FileUtils:getInstance():getWritablePath().."netActivity/tempMd5.png"

    if GameData.netSprite ~= nil then

        for i=1,#(GameData.netSprite) do
            if GameData.netSprite[i] == tempMd5 then

                print("delte has activity----")
                cc.FileUtils:getInstance():removeFile(dirname)
                GameData.netSprite[i] = nil

            end
        end

    end

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)
    local urlStr = platConfig.activityImg
    local image = "Platform_Src/Image/active.png"

    util.setActivityImage(bgroot, urlStr, nil, image, 1, nil, activityName)

end

function util.preDownloading(bgroot,loadingName)

    local platConfig = PlatConfig:getPlatConfig(CONFIG_APP_CHANNEL)

    local tempMd5 = crypto.md5(loadingName)

    local firename = cc.FileUtils:getInstance():getWritablePath().."netActivity/tempMd5.png"

    if GameData.netSprite ~= nil then

        for i=1,#(GameData.netSprite) do
            if GameData.netSprite[i] == tempMd5 then

                print("delte has loadimage----")
                cc.FileUtils:getInstance():removeFile(firename)
                GameData.netSprite[i] = nil

            end
        end

    end

    local lastloadRand = cc.UserDefault:getInstance():getIntegerForKey("LoadRand")
    if lastloadRand == nil or lastloadRand == 0 then
        lastloadRand = 1
    end
    lastloadRand = (lastloadRand+1) % 3 + 1
    cc.UserDefault:getInstance():setIntegerForKey("LoadRand", lastloadRand)

    print("lastloadRand = ", lastloadRand)


    local urlStr = platConfig.loadingImg[lastloadRand]
    local image = "Platform_Src/Image/loading.png"

    util.setActivityImage(bgroot, urlStr, nil, image, 100+lastloadRand, nil, loadingName, true)

end

function util.setActivityImage(bgRoot, imageid, img_head, image, tag, img_bg, activityName, preDown)


    if preDown and activityName ~= nil then

        local icontest = NetSprite.new(imageid, image, nil, activityName):addTo(bgRoot, 30000+tag)
        icontest:hide()

        return

    end

    if bgRoot == nil or img_head == nil then

        return

     end

     if tag == nil then

        tag = 1

      end

    local img_userinfobg = bgRoot
    local img_touXiang = img_head
    if imageid ~= nil and imageid ~= "" then

        local url = imageid
        -- local subUrl = string.sub(url,1,-2)
        -- local url = subUrl .. 132
        print("newUrl:",url)
        local icontest = NetSprite.new(url,image, img_touXiang, activityName):addTo(img_userinfobg, img_touXiang:getLocalZOrder(), tag+20000)
        local size = img_touXiang:getContentSize()
        print("local img-size:",size.width, size.height)
        icontest:setPosition(img_touXiang:getPosition())

        local sizeImg = icontest:getContentSize()
        icontest:setScale(img_touXiang:getScaleX()*(size.width/sizeImg.width),img_touXiang:getScaleY()*(size.height/sizeImg.height))

        img_touXiang:hide()
        if img_bg then
          img_bg:hide()
        end

    else

        img_touXiang:show()
        if img_bg then
          img_bg:show()
        end
    end

end

function util.setHeadImage(bgRoot, imageid, img_head, image, tag, img_bg, imageBg)

     -- if bgRoot ~= nil then

     --    return

     -- end

    if bgRoot == nil or img_head == nil  then

        return

     end

     if tag == nil then

        tag = 1

      end

    local img_userinfobg = bgRoot
    local img_touXiang = img_head
    if imageid ~= nil and imageid ~= "" then

        local url = imageid
        local subUrl = string.sub(url,1,-2)
        local url = subUrl .. 132
        print("newUrl:",url)
        print("tag--:", tag)
        local icontest = img_userinfobg:getChildByTag(tag+10000)
        if icontest == nil then
            icontest = NetSprite.new(url,image, img_touXiang):addTo(img_userinfobg, img_touXiang:getLocalZOrder(), tag+10000)
        end

        local size = img_touXiang:getContentSize()
        print("image-size:",size.width, size.height)
        icontest:setPosition(img_touXiang:getPosition())
        icontest:setName("WXHEAD")
        --icontest:setScale(size.width/132,size.height/132)

        local sizeImg = icontest:getContentSize()

        icontest:setScale(img_touXiang:getScaleX()*(size.width/sizeImg.width),img_touXiang:getScaleY()*(size.height/sizeImg.height))
        icontest:show()

        img_touXiang:hide()
        if img_bg ~= 1000 and img_bg then
          img_bg:hide()
        end

         if img_bg == 1000 then

             img_touXiang:show()
             img_touXiang:setTexture(icontest:getTexture())
        end
    else

        img_touXiang:show()
        if img_bg ~= 1000 and img_bg then
          img_bg:show()
        end
    end

end

function util.filter_spec_chars(s)
    local ss = {}
    for k = 1, #s do
        local c = string.byte(s,k)
        if not c then break end
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then
            table.insert(ss, string.char(c))
        elseif c>=228 and c<=233 then
            local c1 = string.byte(s,k+1)
            local c2 = string.byte(s,k+2)
            if c1 and c2 then
                local a1,a2,a3,a4 = 128,191,128,191
                if c == 228 then a1 = 184
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165
                end
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then
                    k = k + 2
                    table.insert(ss, string.char(c,c1,c2))
                end
            end
        end
    end
    return table.concat(ss)
end

local tokenCryptKey = "toKey431"
--读取
function util.read_wx_refresh_token()
   -- return cc.UserDefault:getInstance():getStringForKey("refresh_token")

    local f = io.open(device.writablePath .. "token","r")
    if f then
        local token = f:read("*all")
        if token ~= "" then
            token = crypt.base64decode(token)
            token = crypt.desdecode(tokenCryptKey, token)
        end

        f:close()
        return token
    end
end

--改写
function util.write_wx_refresh_token(token)
    token = token or ""
    -- cc.UserDefault:getInstance():setStringForKey("refresh_token", token)
    -- cc.UserDefault:getInstance():flush()

    local f = io.open(device.writablePath .. "token","w")
    if f then
        if not token or token == "" then
            return
        end

        token = crypt.desencode(tokenCryptKey, token)
        token = crypt.base64encode(token)
        f:write(token)
        f:close()
    end
end

function util.BtnScaleFunEx(button)

    if button == nil then

        return

    end

     button:onButtonPressed( function (event)  button:setScale(button:getScaleX()*0.92)   end)
     button:onButtonRelease( function (event)  button:setScale(1.0)  end)

end

function util.BtnScaleFun(button, scale2, scale3)
    if button == nil then
        return
    end

    scale3 = scale3 or 0.88

    local scale = 1.0
    if scale2 ~= nil then
        scale = scale2
    end

    button:onButtonPressed( function (event)  button:setScale(button:getScaleX()*scale3)   end)
    button:onButtonRelease( function (event)  button:setScale(scale)  end)

    return button
end

function util.setGold(val)

    print("val= ",val)


     if not val or type(val) == "string" then
        val = checkint(val)
    end

    if math.abs(val) <= 10000 then
        return tostring(val)
    end

    if val < 0 then
       val = 0
    end

    local a = 0

     if val >= 100000000 then

        a = val/100000000

        a = string.format("%0.2f", a)

        return a .. "亿"

     elseif val >= 10000000 then

        a = val/10000000

        a = string.format("%0.2f", a)

        return a .. "千万"

    elseif val >= 1000000 then

        a = val/1000000

        a = string.format("%0.2f", a)

        return a .. "百万"

    elseif val > 10000 then

        a = val/10000

        a = string.format("%0.2f", a)

        return a .. "万"

    end


end

function util.SetStroke(param)

     if param.root == nil then

        return

     end

      local quickLabel = cc.ui.UILabel.newTTFLabel_({
        text = param.text,
       -- color = cc.c3b(253,214,163),
        font = "Arial",
        --font = "font/lantinghei.TTF",
        size = param.size,
        align = cc.TEXT_ALIGNMENT_CENTER,
        x = param.x,
        y = param.y
    }):addTo(param.root, 1)
     --quickLabel:setTextColor(cc.c4b(255,255,255,255))
     --quickLabel:enableOutline(cc.c4b(221,124,64,255), 2)
      quickLabel:setTextColor(param.color1)
      quickLabel:enableOutline(param.color2, param.w)

      return quickLabel

end

function util.setMenuAni(setNode, onComplete)

    app.constant.isOpening = true
    setNode:setScale(0)
    local callback = cc.CallFunc:create(function()
          app.constant.isOpening = false
    end)
    local scale1_star = cc.ScaleTo:create(0.2,1.1)
    local scale2_star = cc.ScaleTo:create(0.2,1.0)
    local scale_star = cc.Sequence:create(scale1_star, scale2_star, callback)
    transition.execute(setNode, scale_star, {onComplete = onComplete})

end

function util.setMenuAniEx(setNode, onComplete)
    app.constant.isOpening = true
    setNode:setScale(0.7)
    transition.scaleTo(setNode, {
        scale = 1, 
        easing = "backOut",
        time = 0.2,
        onComplete = function()
            app.constant.isOpening = false
        end
    })

    return setNode
end

function util.test_bit(customization, index)
    return math.floor(customization / math.pow(2, index - 1)) % 2
end

function getUsedSrc(srcName)
    local curRound = app.constant.gameround
    print("curRound = ",curRound)
    if curRound ~= nil then
        if curRound%2 == 1 then
            local imgName = srcName .. "_h.png"
            return imgName
        end
        return srcName .. ".png"
    end
    return srcName .. ".png"
end

function util.isBaiJiaXing(str, xsTable)

    local x1 = string.sub(str,1,3)
    local x2 = string.sub(str,1,6)
    for i = 1, #xsTable do
        if xsTable[i] == x1 or xsTable[i] == x2 then
           --print("xsName:"..xsTable[i])
           return true
        end
    end
    return false
end

function util.isZhongWen(str)
    local len = #str
    local byteLen = 0
    for i = 1,len, 3 do
        local curByte = string.byte(str, i)
        --local byteCount = 1
        --print("curByte = ,i = ",curByte,i)
        if curByte>=228 and curByte<=233 then
            local c1 = string.byte(str,i+1)
            local c2 = string.byte(str,i+2)
            --print("c1 = ,c2 = ",c1,c2)
            if c1 and c2 then
                local a1,a2 = 128,191
                if c1>=a1 and c1<=a2 and c2>=a1 and c2<=a2 then
                    byteLen = byteLen+1                         --汉字
                end
            end
        else
            return 0                                        --todo                                               --4字节字符
        end
    end
    print("zhongCount = ",byteLen)
    return byteLen
end

--身份实名验证系统
function util.verifyIDCard(idcard)

    --只支持18位身份证的验证
    --[[
    #身份证18位编码规则：dddddd yyyymmdd xxx y
    #dddddd：地区码
    #yyyymmdd: 出生年月日
    #xxx:顺序类编码，无法确定，奇数为男，偶数为女
    #y: 校验码，该位数值可通过前17位计算获得
    #<p />
    #18位号码加权因子为(从右到左) Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2,1 ]
    #验证位 Y = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ]
    #校验位计算公式：Y_P = mod( ∑(Ai×Wi),11 )
    #i为身份证号码从右往左数的 2...18 位; Y_P为脚丫校验码所在校验码数组位置
    参考代码:
          https://github.com/yujinqiu/idlint
    ]]
    local string_len = string.len
    local tonumber = tonumber

    -- // wi =2(n-1)(mod 11)
    local wi = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 };
    -- // verify digit
    local vi= { '1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2' };

    local function isBirthDate(date)
        local year = tonumber(date:sub(1,4))
        local month = tonumber(date:sub(5,6))
        local day = tonumber(date:sub(7,8))
        if year < 1900 or year > 2100 or month >12 or month < 1 then
            return false
        end
        -- //月份天数表
        local month_days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        local bLeapYear = (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
        if bLeapYear  then
            month_days[2] = 29;
        end

        if day > month_days[month] or day < 1 then
            return false
        end

        return true
    end

    local function isAllNumberOrWithXInEnd( str )
        local ret = str:match("%d+X?")
        return ret == str
    end


    local function checkSum(idcard)
        -- copy from http://stackoverflow.com/questions/829063/how-to-iterate-individual-characters-in-lua-string
        local nums = {}
        local _idcard = idcard:sub(1,17)
        for ch in _idcard:gmatch"." do
            table.insert(nums,tonumber(ch))
        end
        local sum = 0
        for i,k in ipairs(nums) do
            sum = sum + k * wi[i]
        end

        return vi [sum % 11+1] == idcard:sub(18,18 )
    end

    local err_success = 0
    local err_length = 1
    local err_province = 2
    local err_birth_date = 3
    local err_code_sum = 4
    local err_unknow_charactor = 5


    if string_len(idcard) ~= 18 then
        return err_length
    end

    if not isAllNumberOrWithXInEnd(idcard) then
        return err_unknow_charactor
    end
    -- //第1-2位为省级行政区划代码，[11, 65] (第一位华北区1，东北区2，华东区3，中南区4，西南区5，西北区6)
    local nProvince = tonumber(idcard:sub(1, 2))
    if (nProvince < 11 or nProvince > 65) then
        return err_province
    end
    -- //第3-4为为地级行政区划代码，第5-6位为县级行政区划代码因为经常有调整，这块就不做校验
    -- //第7-10位为出生年份；//第11-12位为出生月份 //第13-14为出生日期
    if not isBirthDate(idcard:sub(7,14)) then
        return err_birth_date
    end

    if not checkSum(idcard) then
        return err_code_sum
    end

    return err_success

end


util.hello()
return util