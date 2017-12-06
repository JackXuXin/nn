--
-- Author: peter
-- Date: 2017-03-10 10:33:12
--

local msgWorker = require("app.net.MsgWorker")          --注册监听
local util = require("app.Common.util")

local Modular = {
    {name = "WL_MsgMgr",path = "app.Games.WL.WL_MsgMgr"},
    {name = "WL_Const",path = "app.Games.WL.WL_Const"},
    {name = "WL_Util",path = "app.Games.WL.WL_Util"},
    {name = "WL_PlayerMgr",path = "app.Games.WL.WL_PlayerMgr"},
    {name = "WL_PlayerInfo",path = "app.Games.WL.WL_PlayerInfo"},
    {name = "WL_uiPlayerInfos",path = "app.Games.WL.WL_uiPlayerInfos"},
    {name = "WL_uiOperates",path = "app.Games.WL.WL_uiOperates"},
    {name = "WL_uiSettings",path = "app.Games.WL.WL_uiSettings"},
    {name = "WL_Message",path = "app.Games.WL.WL_Message"},
    {name = "WL_CardMgr",path = "app.Games.WL.WL_CardMgr"},
    {name = "WL_Card",path = "app.Games.WL.WL_Card"},
    {name = "WL_CardTouchMgr",path = "app.Games.WL.WL_CardTouchMgr"},
    {name = "WL_uiPlayerCardBack",path = "app.Games.WL.WL_uiPlayerCardBack"},
    {name = "WL_uiTableInfos",path = "app.Games.WL.WL_uiTableInfos"},
    {name = "WL_uiResults",path = "app.Games.WL.WL_uiResults"},
    {name = "WL_Audio",path = "app.Games.WL.WL_Audio"},
    {name = "WL_ActionMgr",path = "app.Games.WL.WL_ActionMgr"},
}

local WLScene = class("WLScene",function()
		return display.newScene("WLScene")
	end)

function WLScene:ctor()
	self.root = cc.uiloader:load("Scene/WLScene.json"):addTo(self)

	self.seatIndex = 0
	self.session = 0
    self.openCardTime = 0

    for k,v in ipairs(Modular) do
        self[v.name] = require(v.path)
        if self[v.name]["init"] then
             self[v.name]:init(self)
        end
    end

    msgWorker.init("WL", handler(self.WL_MsgMgr, self.WL_MsgMgr.dispatchMessage))

    if util.UserInfo.watching == false then

         -- 设置语音聊天按钮
         util.SetVoiceBtn(self,self.root)
         util.SetRequestBtnShow()

    end
end

function WLScene:onEnter()
	print("进入 乌龙 场景")

    -- local cards = {}
    -- for i=1,54 do
    --     if i < 15 then
    --         table.insert(cards, math.random(1,1))
    --     elseif i < 30 then
    --         table.insert(cards, math.random(17,29))
    --     elseif i < 45 then
    --         table.insert(cards, math.random(33,46))
    --     else
    --        table.insert(cards, math.random(49,51))
    --     end
    -- end

    -- self.WL_CardMgr:sendPlayerCard(cards,1)

    -- self.WL_PlayerMgr:showPlayerChuPaiUI(1,{11,12,13,11,12,13,6,4})
    -- self.WL_PlayerMgr:showPlayerChuPaiUI(2,{12,12,11,12,11,12,11,12,11,12,12,8,9,9})
    -- self.WL_PlayerMgr:showPlayerChuPaiUI(3,{12,2,3,4,5,5,6})
    -- self.WL_PlayerMgr:showPlayerChuPaiUI(4,{1,2,3,4,5,5,6,4,7,7,12,8,9,9})
    --self.WL_PlayerMgr:showPlayerTimer(1,11)

    -- self.WL_uiPlayerCardBack:showPlayerCardBack(true)

    --结算测试
    -- self.WL_uiResults:showGameResult(true,{
    --     {name = "0",seat =1,score = 0,bonus = 0,total = 0},
    --     {name = "0",seat =2,score = 0,bonus = 0,total = 0},
    --     {name = "0",seat =3,score = 0,bonus = 0,total = 0},
    --     {name = "0",seat =4,score = 0,bonus = 0,total = 0},
    --     })

end

function WLScene:onExit()
	for k,v in ipairs(Modular) do
        if  self[v.name]["clear"] then
            self[v.name]:clear()
        end
    end
end

return WLScene