local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local comUtil = require("app.Common.util")
local util = require("app.Games.HkFiveCard.util")

local _toDotNum = comUtil.toDotNum

local scene = nil
local uiTableInfos = {}

function uiTableInfos:init(tableScene)
	scene = tableScene
	self.lb_table_total_chip = cc.uiloader:seekNodeByName(scene.root, "lb_table_total_chip")
	self.lb_table_base_chip = cc.uiloader:seekNodeByName(scene.root, "lb_table_base_chip")
	self.lb_table_max_chip = cc.uiloader:seekNodeByName(scene.root, "lb_table_max_chip")
	self.lb_table_total_chip:setString("")
	self.lb_table_base_chip:setString("")
	self.lb_table_max_chip:setString("")

	return self
end

function uiTableInfos:clear()
	
end

-- now, update total chip info only
function uiTableInfos:update()
	local sum = 0
	for k, v in pairs(vars.players) do
		if v and v.ingame then
			sum = sum + v:total_chip()
		end
	end
	self.lb_table_total_chip:setString(util.num2str(sum))
	self.lb_table_base_chip:setString(util.num2str(vars.base_chip))
	self.lb_table_max_chip:setString(util.num2str(vars.max_chip))
end

return uiTableInfos
