
-- package.path = package.path..';/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio/lualibs/mobdebug/?.lua;'
-- require("mobdebug").start()

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")

    -- local message = msg
    --  -- report lua exception
    -- buglyReportLuaException(tostring(message), debug.traceback())

end

--获取上次热更的状态
local lastHotState = cc.UserDefault:getInstance():getIntegerForKey("HotState")

print("lastHotState:",lastHotState)
-- 热更状态为0－热更未成功，1-热更成功
if lastHotState == 0 then

	 local new_version = cc.FileUtils:getInstance():getWritablePath().."new_version/"
	 print("new_version:" .. new_version)
	 cc.FileUtils:getInstance():removeDirectory(new_version)
	 print("删掉下载未完成的new_version")
	 
end

package.path = cc.FileUtils:getInstance():getWritablePath().."new_version/src/;" .. package.path .. ";src/"
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."new_version/res");
cc.FileUtils:getInstance():setPopupNotify(false)
require("app.MyApp").new():run()
