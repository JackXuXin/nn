
local consts = require("app.Games.HkFiveCard.constants")
local vars = require("app.Games.HkFiveCard.variables")

local ErrorLayer = require("app.layers.ErrorLayer")
local util = require("app.Games.HkFiveCard.util")
local msgMgr = require("app.Games.HkFiveCard.msgMgr")
local utilCom = require("app.Common.util")

local TEST_RUNNING = false

-- server op define
-- 1:加注 2:跟注 3:弃牌 4:过牌 5:showhand
local SOP_RAISE = 1
local SOP_FOLLOW = 2
local SOP_GIVEUP = 3
local SOP_NO_RAISE = 4
local SOP_SHOWHAND = 5
local CARD_NUM_TO_SHOWHAND = 3

-- raise array
local OP_RAISE_TOTAL_NUM = 4
local MULTIPY_OF_BASE = 4


local scene = nil
local uiOperates = {}

function uiOperates:init(tableScene)
	scene = tableScene

	self.btn_start_ready = cc.uiloader:seekNodeByNameFast(scene.root, "btn_start_ready")
	self.btn_start_ready:setLocalZOrder(101)
	self.btn_start_ready:onButtonClicked(function() self:clickStartReady() end)
	self.btn_start_ready:setVisible(false)

	-- self.btn_invitation_ready = cc.uiloader:seekNodeByNameFast(scene.root, "btn_invitation_ready")
	-- self.btn_invitation_ready:setLocalZOrder(101)
	-- self.btn_invitation_ready:onButtonClicked(function() self:clickInvitationReady() end)
	-- self.btn_invitation_ready:setVisible(false)

	-- operate panel
	self.player_op_panel = cc.uiloader:seekNodeByNameFast(scene.root, "player_op_panel")
	self.player_op_panel:setVisible(false)

	-- operate buttons
	self.op_btns = {
		[SOP_RAISE]={}, [SOP_FOLLOW]={}, [SOP_GIVEUP]={}, [SOP_NO_RAISE]={}, [SOP_SHOWHAND]={}
	}
	for i = 1, OP_RAISE_TOTAL_NUM do 
		local btn_raise = cc.uiloader:seekNodeByNameFast(self.player_op_panel, "Button_raise_"..i)
		btn_raise:onButtonClicked(function() self:clickRaise(i) end)
		btn_raise:setButtonLabelString(tostring(i*100))
		table.insert(self.op_btns[SOP_RAISE], btn_raise)
	end
	local btn_no_raise = cc.uiloader:seekNodeByNameFast(self.player_op_panel, "Button_no_raise")
	local btn_follow = cc.uiloader:seekNodeByNameFast(self.player_op_panel, "Button_follow")
	local btn_giveup = cc.uiloader:seekNodeByNameFast(self.player_op_panel, "Button_giveup")
	local btn_showhand = cc.uiloader:seekNodeByNameFast(self.player_op_panel, "Button_showhand")
	btn_no_raise:onButtonClicked(function() self:clickNoRaise() end)
	btn_follow:onButtonClicked(function() self:clickFollow() end)
	btn_giveup:onButtonClicked(function() self:clickGiveup() end)
	btn_showhand:onButtonClicked(function() self:clickShowhand() end)
	table.insert(self.op_btns[SOP_NO_RAISE], btn_no_raise)
	table.insert(self.op_btns[SOP_FOLLOW], btn_follow)
	table.insert(self.op_btns[SOP_GIVEUP], btn_giveup)
	table.insert(self.op_btns[SOP_SHOWHAND], btn_showhand)

	return self
end

function uiOperates:clear()
	
end

-- 1:加注 2:跟注 3:弃牌 4:过牌 5:showhand
function uiOperates:showOpPanel(flag, oplist)
	flag = flag or false
	if vars.watching then
		flag = false
	end
	
	print("showOpPanel:", flag, oplist)
	self.player_op_panel:setVisible(flag)
	if not flag then 
		return 
	end

	if oplist == nil then -- default oplist
		oplist = {SOP_RAISE, SOP_GIVEUP, SOP_NO_RAISE}
		if #vars.players[1].cards >= CARD_NUM_TO_SHOWHAND then 
			table.insert(oplist, SOP_SHOWHAND)
		end
	end

	print("oplist:", table.concat(oplist, ","))
	-- set op btns by oplist
	for op, btns in pairs(self.op_btns) do
		local is_op_valid = table.exist(oplist, op)
		for i, btn in pairs(btns) do
			btn:setButtonEnabled(is_op_valid)
			if is_op_valid then -- valid then visible
				btn:setVisible(true)
			end
			-- if can't follow, invisible it 
			if op == SOP_FOLLOW and not is_op_valid then
				btn:setVisible(false)
			end 
			if op == SOP_RAISE then
				btn:setButtonLabelString(tostring(vars.raise_options[i]))
				print("vars.raise_options[i]:" .. tostring(vars.raise_options[i]))
				print("vars.last_chip:" .. tostring(vars.last_chip))
				print("vars.base_chip:" .. tostring(vars.base_chip))
				print("MULTIPY_OF_BASE:" .. tostring(MULTIPY_OF_BASE))
				if vars.raise_options[i] + vars.last_chip > vars.base_chip * MULTIPY_OF_BASE then
					btn:setButtonEnabled(false)
				end
				local player = vars.players[1]
				if player then
					print("player.prechip:" .. tostring(player.prechip))
					print("vars.raise_options[i]:" .. tostring(vars.raise_options[i]))
					print("vars.last_chip:" .. tostring(vars.last_chip))
					print("player.curchip:" .. tostring(player.curchip))
					print("player.gold:" .. tostring(player.gold))
				end
				if player and player.prechip + vars.raise_options[i] + vars.last_chip - player.curchip > player.gold then
					btn:setButtonEnabled(false)
				end
			end
		end
	end
end

function uiOperates:showReadyBtn(flag)
	if vars.watching then
		self.btn_start_ready:setVisible(false)
		--self.btn_invitation_ready:setVisible(false)
		 utilCom.SetRequestBtnHide()
		return
	end
	print("set ready button visible:", flag)
	self.btn_start_ready:setVisible(flag)
	--self.btn_invitation_ready:setVisible(flag)

	if flag then
		utilCom.SetRequestBtnShow()
	else
		utilCom.SetRequestBtnHide()
	end

	if flag then --HACK: show ready btn, must close op panel
		self.player_op_panel:setVisible(false)
	end
end

function uiOperates:clickStartReady()
	print("on player start ready")

	if TEST_RUNNING then
		require("app.Games.HkFiveCard.test"):sendMsg("ready")
		self:showOpPanel(false)
		return
	end

	local player = vars.players[1]
	if player and not vars.watching and player.gold < vars.room_gold then
		print("not enough gold.")
		ErrorLayer.new(app.lang.table_gold_lack, nil, nil, function()
			msgMgr:sendExitTable()
		end):addTo(scene)
		return
	end

	msgMgr:sendReadyRequest()
end

--邀请好友
function uiOperates:clickInvitationReady()

end

function uiOperates:clickRaise(idx)
	print("click raise")

	if TEST_RUNNING then
		require("app.Games.HkFiveCard.test"):sendMsg("raise", 888)
		self:showOpPanel(false)
		return
	end

	local raise_val = vars.raise_options[idx]
	msgMgr:sendOpReq({optype=SOP_RAISE, opvalue=raise_val})
end

function uiOperates:clickNoRaise()
	print("click no raise")

	if TEST_RUNNING then 
		require("app.Games.HkFiveCard.test"):sendMsg("noraise")
		self:showOpPanel(false)
		return
	end

	msgMgr:sendOpReq({optype=SOP_NO_RAISE})
end

function uiOperates:clickFollow()
	print("click follow")

	if TEST_RUNNING then
		require("app.Games.HkFiveCard.test"):sendMsg("follow", 8888)
		self:showOpPanel(false)
		return
	end

	msgMgr:sendOpReq({optype=SOP_FOLLOW})
end

function uiOperates:clickShowhand()
	print("click showhand")

	if TEST_RUNNING then
		require("app.Games.HkFiveCard.test"):sendMsg("showhand", 88888)
		self:showOpPanel(false)
		return
	end

	msgMgr:sendOpReq({optype=SOP_SHOWHAND})
end

function uiOperates:clickGiveup()
	print("click give up")

	if TEST_RUNNING then
		require("app.Games.HkFiveCard.test"):sendMsg("giveup")
		self:showOpPanel(false)
		return
	end

	msgMgr:sendOpReq({optype=SOP_GIVEUP})
end

return uiOperates