local BRNNScene = package.loaded["app.scenes.BRNNScene"] or {}

local util = require("app.Common.util")
local RoomConfig = require("app.config.RoomConfig")
local ErrorLayer = require("app.layers.ErrorLayer")
local MiddlePopBoxLayer = require("app.layers.MiddlePopBoxLayer")
local crypt = require("crypt")

local Player = app.userdata.Player

function BRNNScene:addSettingLayer()
	audio.playMusic("Sound/BRNN/bairen_bg.mp3", true)
	local settingNode = require("app.nodes.SettingNode")
	print(settingNode)
	local settings = settingNode.new(function(sound)
		if sound then
			audio.setMusicVolume(1.0)
			audio.playMusic("Sound/BRNN/bairen_bg.mp3", true)
			audio.setSoundsVolume(1.0)
		else
			audio.setMusicVolume(0)
			audio.stopMusic()
			audio.setSoundsVolume(0)
			audio.stopAllSounds()
		end
	end, function()
		self:sendLeaveGame()
	end)
	settings:addTo(self)
	settings:setAnchorPoint(cc.p(0, 0.5))
	settings:setPosition(display.right, display.cy)
end

function BRNNScene:playSounds(sounds)
	if audio.getSoundsVolume() > 0 then
		audio.playSound(sounds)
	end
end

function BRNNScene:showHistoryLayer()
	if not self.historyLayer then
		self.historyLayer = cc.uiloader:load("Layer/Game/BRNN/HistoryLayer.json"):addTo(self)

		local background = cc.uiloader:seekNodeByNameFast(self.historyLayer, "Background")
		background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			self.historyLayer:removeFromParent()
			self.historyLayer = nil
			return true
		end)
	end
	if self.params.historyGameId ~= self.params.gameId then
		self:HistoryReq()
	end
	self:updateHistoryLayer()
end

function BRNNScene:updateHistoryLayer()

	local function newHistorySprite(result, x, y)
		if not result then
			return
		end

		if result == 1 then -- fail
			return display.newSprite("Image/BRNN/bairen_pic_0.png", x, y)
		else
			return display.newSprite("Image/BRNN/bairen_pic_1.png", x, y)
		end
	end

	if not self.historyLayer or not self.params.history then
		return
	end

	if self.historyLayer.sprites then
		for _,v in ipairs(self.historyLayer.sprites) do
			v:removeFromParent()
		end
	end
	self.historyLayer.sprites = {}

	local background = cc.uiloader:seekNodeByNameFast(self.historyLayer, "History_Background")
	for i=math.min(#self.params.history, 10), 1, -1  do
		local results = self.params.history[i].results
		local x = 675 - (44 + 9)*i

		local tian = newHistorySprite(results[1], x, 325.5)
		if tian then
			table.insert(self.historyLayer.sprites, tian:addTo(background))
		end
		local di = newHistorySprite(results[2], x, 232.5)
		if di then
			table.insert(self.historyLayer.sprites, di:addTo(background))
		end
		local xuan = newHistorySprite(results[3], x, 139.5)
		if xuan then
			table.insert(self.historyLayer.sprites, xuan:addTo(background))
		end
		local huang = newHistorySprite(results[4], x, 46.5)
		if huang then
			table.insert(self.historyLayer.sprites, huang:addTo(background))
		end
	end
end

function BRNNScene:showRankLayer()
	if not self.rankLayer then
		self.rankLayer = cc.uiloader:load("Layer/Game/BRNN/RankLayer.json"):addTo(self)

		local background = cc.uiloader:seekNodeByNameFast(self.rankLayer, "Background")
		background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			self.rankLayer:removeFromParent()
			self.rankLayer = nil
			return true
		end)
	end
	self:RankListReq()
	self:updateRankLayer()
end

function BRNNScene:updateRankLayer()

	local function newRankSprites(index, gold, viptype)
		local rankSprite, nameSprite, goldSprite
		local color = cc.c3b(93, 190, 247)

print("updateRankLayer----" .. viptype)
--modify by whb 161031
    if viptype ~= nil and viptype > 0 then
       color = cc.c3b(251, 132, 132)
    end
--modify end

		if index == 1 then
			color = cc.c3b(243, 247, 84)

			rankSprite = display.newSprite("Image/BRNN/bairen_pic_huangguan.png")
		else
			rankSprite = display.newTTFLabel({ text=tostring(index), color=color, align=cc.TEXT_ALIGNMENT_CENTER })
		end

		nameSprite = display.newTTFLabel({ text="", color=color, align=cc.TEXT_ALIGNMENT_LEFT })
		goldSprite = display.newTTFLabel({ text=util.toDotNum(gold), color=color, align=cc.TEXT_ALIGNMENT_LEFT })

		return rankSprite, nameSprite, goldSprite
	end

	if not self.rankLayer or not self.params.rank then
		return
	end
	
	local scrollView = cc.uiloader:seekNodeByNameFast(self.rankLayer, "ScrollView")
	local emptyNode = scrollView:getScrollNode()
	emptyNode:removeAllChildren()
    emptyNode:setContentSize(480, 445)

	local height = scrollView:getCascadeBoundingBox().height
    for i,v in ipairs(self.params.rank) do
    	local name = crypt.base64decode(v.nickname)
    	local rankSprite, nameSprite, goldSprite = newRankSprites(i, v.gold, v.viptype)
    	nameSprite:setAnchorPoint(cc.p(0, 0.5))

    	local y = height - 20 - (i - 1) * 45
    	rankSprite:addTo(emptyNode):setPosition(20, y)
    	
    	goldSprite:setAnchorPoint(cc.p(1, 0.5))
    	goldSprite:addTo(emptyNode):setPosition(460, y)

    	local nameWidth = 370 - 55 - goldSprite:getContentSize().width - 20
    	local maxNameNumber = math.ceil(nameWidth / 24)
    	local nameNumber = string.utf8len(name)
    	-- if maxNameNumber < nameNumber then
	    -- 	name = string.sub(name, 1, util.utf8IndexToByte(name, maxNameNumber)) .. "..."
	    -- end
	    
    	nameSprite:setString(util.checkNickName(name))
    	nameSprite:addTo(emptyNode):setPosition(55, y)
    	nameSprite:setMaxLineWidth(nameWidth)
    	nameSprite:setLineBreakWithoutSpace(false)
    end
end

function BRNNScene:showHelpLayer()
	if not self.helpLayer then
		self.helpLayer = cc.uiloader:load("Layer/Game/BRNN/HelpLayer.json"):addTo(self)

		local background = cc.uiloader:seekNodeByNameFast(self.helpLayer, "Background")
		background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			self.helpLayer:removeFromParent()
			self.helpLayer = nil
			return true
		end)

		local help = cc.uiloader:seekNodeByNameFast(self.helpLayer, "Help")
		help:setPosition(640, -360)
		transition.moveTo(help, { y = 360, time = 0.3 })
	end
end

function BRNNScene:showBankerList()
	if not self.bankerListLayer then
		self.bankerListLayer = cc.uiloader:load("Layer/Game/BRNN/BankerListLayer.json"):addTo(self)

		local background = cc.uiloader:seekNodeByNameFast(self.bankerListLayer, "Background")
		background:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
			self.bankerListLayer:removeFromParent()
			self.bankerListLayer = nil
			return true
		end)

		self.bankerListLayer.leastGold = cc.uiloader:seekNodeByNameFast(self.bankerListLayer, "LeastGold")
		self.bankerListLayer.leastGold:setString(tostring(checkint(self.params.minGold)))

		self.bankerListLayer.list = {}
		for i=1,5 do
			local list = {}
			table.insert(self.bankerListLayer.list, list)
			table.insert(list, cc.uiloader:seekNodeByNameFast(self.bankerListLayer, "Banker_Name_"..i))
			table.insert(list, cc.uiloader:seekNodeByNameFast(self.bankerListLayer, "Banker_Gold_"..i))
		end

		self.bankerListLayer.operatorPanel = cc.uiloader:seekNodeByNameFast(self.bankerListLayer, "OperatorPanel")
	end

	self:BankerListReq()
end

function BRNNScene:updateBankerList()
	if not self.bankerListLayer then
		return
	end

	self.bankerListLayer.leastGold:setString(tostring(checkint(self.params.minGold)))

	local canApply = true
	for i=1,5 do
		local nameLabel = self.bankerListLayer.list[i][1]
		local goldLabel = self.bankerListLayer.list[i][2]
		if self.params.bankerList and self.params.bankerList[i] then
			nameLabel:show()
			goldLabel:show()

			nameLabel:setString(i .. "   " .. util.checkNickName(crypt.base64decode(self.params.bankerList[i].nickname)) or "")
			goldLabel:setString(util.toDotNum(self.params.bankerList[i].gold))

			if self.params.bankerList[i].uid == Player.uid then
				canApply = false
			end
		else
			nameLabel:hide()
			goldLabel:hide()
		end
	end

	self.bankerListLayer.operatorPanel:removeAllChildren()
	local button
	if canApply then
		button = cc.ui.UIPushButton.new({ 
            normal = "Image/BRNN/Player/bairen_btn_shenqingshangzhuang01.png", 
            pressed = "Image/BRNN/Player/bairen_btn_shenqingshangzhuang02.png", 
        })
        button:onButtonClicked(function ()
        	self:BankerReq(1)
        end)
	else
		button = cc.ui.UIPushButton.new({ 
            normal = "Image/BRNN/Player/bairen_btn_woyaoxiazhuang01.png", 
            pressed = "Image/BRNN/Player/bairen_btn_woyaoxiazhuang02.png", 
        })
        button:onButtonClicked(function ()
        	self:BankerReq(0)
        end)
	end
	button:addTo(self.bankerListLayer.operatorPanel)
	local panelSize = self.bankerListLayer.operatorPanel:getContentSize()
	button:setPosition(panelSize.width / 2, panelSize.height / 2)
end

function BRNNScene:giveUpBanker()
	local layer
	layer = MiddlePopBoxLayer.new(app.lang.system, app.lang.giveup_banker, 
        MiddlePopBoxLayer.ConfirmDefault, true, nil, function ()
        	layer:removeFromParent()
    		self:BankerReq(0)
        end)
    :addTo(self)
end

function BRNNScene:bankerReqError(error)
	if self.bankerListLayer then
		self.bankerListLayer:removeFromParent()
		self.bankerListLayer = nil
	end

	MiddlePopBoxLayer.new(app.lang.system, error, MiddlePopBoxLayer.ConfirmSingle, true):addTo(self)
end

return BRNNScene