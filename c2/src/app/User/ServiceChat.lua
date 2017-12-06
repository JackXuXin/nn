--local LobbyScene = package.loaded["app.scenes.LobbyScene"] or {}


-- luaStr  = "I' m Himi"
 
-- luaStr2 = "are you ok!"
 
-- luaTable={age = 23,name="Himi",sex="男"}

--local textLayer
 
-- function luaLogString(_logStr,_logNum,_logBool)
 
--     print("Lua 脚本打印从C传来的字符串：",_logStr,_logNum,_logBool)
--     return "call lua function OK"
-- end
 
-- function call_Cpp(_logStr,_logNum,_logBool)
--     num,str = cppFunction(999,"I'm a lua string")
--     print("从cpp函数中获得两个返回值：",num,str)
-- end


function setChatNum(chatNum)

   print("imgInfo:",imgInfo)
   if imgInfo == nil or textLayer == nil then
   	return
   end

   if chatNum == 0 then
   	imgInfo:hide()
   else
   	imgInfo:show()
   end

   textLayer:setString(chatNum)
   --print("self.scene:",self.scene)
    --self.scene.bg = cc.uiloader:seekNodeByNameFast(self.scene, "Background")
    print("Service:setChatNum:",chatNum)

end


-- function LobbyScene:getTxtLayer()

--      local textLayer = cc.uiloader:seekNodeByNameFast(self.scene, "Txt_Num")

--      print("LobbyScene:getTxtLayer:",textLayer)

-- end

--return LobbyScene