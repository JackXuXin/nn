--
-- Author: peter
-- Date: 2017-02-17 11:40:19
--

local msgWorker = require("app.net.MsgWorker")          --注册监听
local utilCom = require("app.Common.util")
local Share = require("app.User.Share")

local Modular = {
    {name =  "SRDDZ_MsgMgr",path = "app.Games.SRDDZ.SRDDZ_MsgMgr"},
    {name =  "SRDDZ_PlayerMgr",path = "app.Games.SRDDZ.SRDDZ_PlayerMgr"},
    {name =  "SRDDZ_uiPlayerInfos",path = "app.Games.SRDDZ.SRDDZ_uiPlayerInfos"},
    {name =  "SRDDZ_uiOperates",path = "app.Games.SRDDZ.SRDDZ_uiOperates"},
    {name =  "SRDDZ_uiSettings",path = "app.Games.SRDDZ.SRDDZ_uiSettings"},
    {name =  "SRDDZ_CardMgr",path = "app.Games.SRDDZ.SRDDZ_CardMgr"},
    {name =  "SRDDZ_CardTouchMsg",path = "app.Games.SRDDZ.SRDDZ_CardTouchMsg"},
    {name =  "SRDDZ_uiPlayerCardBack",path = "app.Games.SRDDZ.SRDDZ_uiPlayerCardBack"},
    {name =  "SRDDZ_uiTableInfos",path = "app.Games.SRDDZ.SRDDZ_uiTableInfos"},
    {name =  "SRDDZ_uiResults",path = "app.Games.SRDDZ.SRDDZ_uiResults"},
    {name =  "SRDDZ_Audio",path = "app.Games.SRDDZ.SRDDZ_Audio"},
    {name =  "SRDDZ_ActionMgr",path = "app.Games.SRDDZ.SRDDZ_ActionMgr"},
}

local SRDDZScene = class("SRDDZScene",function()
		return display.newScene("SRDDZScene")
	end)

function SRDDZScene:ctor()
	self.root = cc.uiloader:load("Scene/SRDDZScene.json"):addTo(self)

    for k,v in ipairs(Modular) do
        self[v.name] = require(v.path)
        self[v.name]:init(self)
    end

    local SRDDZ_Util = require("app.Games.SRDDZ.SRDDZ_Util")
    SRDDZ_Util:init()

    msgWorker.init("SRDDZ", handler(self.SRDDZ_MsgMgr, self.SRDDZ_MsgMgr.dispatchMessage))

     --截屏分享
    Share.SetGameShareBtn(true, self.root, display.right-237, display.top-48)

    if utilCom.UserInfo.watching == false then

         -- 设置语音聊天按钮
         utilCom.SetVoiceBtn(self,self.root)

    end
   

end

function SRDDZScene:onEnter()
	print("进入 四人斗地主 场景")
 --   self.SRDDZ_PlayerMgr:showPlayerResultsCards()

 --   self.SRDDZ_uiResults:showGameResult(true,{records={{name = "a",baseScore=-10,score=-10,bLandlord=true,seat = 1},{name = "aasdgdgas",baseScore=10,score=10,bLandlord=true},{name = "dfhdsfha",baseScore=10,score=10,bLandlord=true}}})
end

function SRDDZScene:onExit()
	for k,v in ipairs(Modular) do
        self[v.name]:clear()
    end
end

return SRDDZScene