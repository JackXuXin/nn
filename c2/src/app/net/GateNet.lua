local GateNet = {}

local net = require("framework.cc.net.init")
local crypt = require("crypt")
local Message = require("app.net.Message")
local Msgprotocol = require("app.net.Msgprotocol")
local scheduler = require("framework.scheduler")


GateNet.EVENT_DATA = net.SocketTCP.EVENT_CONNECTED
GateNet.EVENT_CLOSE = net.SocketTCP.EVENT_CLOSE
GateNet.EVENT_CLOSED = net.SocketTCP.EVENT_CLOSED
GateNet.EVENT_CONNECTED = net.SocketTCP.EVENT_CONNECTED
GateNet.EVENT_CONNECT_FAILURE = net.SocketTCP.EVENT_CONNECT_FAILURE

local param = {}
local msgWaitReconnct = {}
local firstReconnect = 0
--local isHasConnected = false
local sendTime = 0
local receiveTime = 0

local function recvData(data)
    local id = 256*data:byte(1) + data:byte(2)
    return id, data:sub(3, #data)
end

local function gotoLoginScene()

	print("gotoLoginScene------")
	-- 验证失败，退出到登陆界面
	if display.getRunningScene().name ~= "LoginScene" then
		cc.Director:getInstance():popToRootScene()
		app:enterScene("LoginScene", nil, "fade", 0.5)
	end
end

local function gotoLobbyScene()
	--重连进入大厅
	local scene = display.getRunningScene().name
	-- if  scene ~= "LoginScene" and scene ~= "LobbyScene" then
	-- 	cc.Director:getInstance():popToRootScene()
	-- 	app:enterScene("LobbyScene", nil, "fade", 0.5)
	-- end
	if  scene == "LoginScene" then
		cc.Director:getInstance():popToRootScene()
		app:enterScene("LobbyScene", nil, "fade", 0.5)
	end
end

local function schedulerReconnect()
	if param.reconnect == true then 
		param.gateSocket = nil
		param.isConnected = false
		param.isAuth = false

		print("schedulerReconnect0000------")

		-- reconnect per 5 seconds
		if not param.reconnectScheduler then
			local delay = scheduler.performWithDelayGlobal(
			function ()
	    			GateNet.reconnect()
					param.reconnectScheduler = scheduler.scheduleGlobal(GateNet.reconnect, 5)
	    	end, 0.2)
		end
	elseif param.reconnect == false then

		print("schedulerReconnect111------")
		-- unscheduler reconnect
		if param.reconnectScheduler then
			scheduler.unscheduleGlobal(param.reconnectScheduler)
			param.reconnectScheduler = nil
		end

		gotoLoginScene()
	end

	param.reconnect = nil
end

local function auth()

	print("gate auth00000--",param.gateSocket,param.isConnected,param.isAuth)

	if param.gateSocket ~= nil then
		local isConnect = param.gateSocket:isConnect()
		print("auth,isConnect:",isConnect)
		if not isConnect then
			return false
		end
	end

	if not param.gateSocket or not param.isConnected or param.isAuth then

		return false
	end

	print("gate auth1111")

	if not app.userdata.Account.uid or not app.userdata.Account.token then
		gotoLoginScene()
		return
	end

	--isHasConnected = true

	print("gate auth2222")

	param.index = (param.index or 0) + 1
	local hmac = crypt.hmac_hash(app.userdata.Account.token, app.userdata.Account.uid .. ":" .. param.index)
	local cmd = string.char(0, 0) 
	local message = string.format("%s%d:%d:%s:%s", cmd, app.userdata.Account.uid, 
		param.index, crypt.base64encode(hmac), app.userdata.Account.secret)
	print("gate auth,message:",message)
  
	GateNet.sendData(message)

	print("gate auth3333")
end

local function heartbeat()
	if not param.isAuth or not param.isConnected then
		if param.scheduler ~= nil then
			scheduler.unscheduleGlobal(param.scheduler)
			param.scheduler = nil
		end
		return
	end

	if param.lastHearTime + 60 < os.time() then
		print("heartbeat-outTime---")
		GateNet.disconnect(4)
		--GateNet.disconnect(3)
		return
	end

	if param.gateSocket ~= nil then
		local t0 = param.gateSocket:getTime()
		if sendTime == 0 then
			sendTime = t0
			--print("sendTime = ", sendTime .. "ms")
		end
	end

	local id = 2

	local netState = network.getInternetConnectionStatus()
	--print("netState = ",netState)
	if param.lastHearTime + 6 < os.time() and (netState == 2 or netState == 0) and app.constant.lastNetState ~= netState then
		print("outTime-11111--",netState,app.constant.lastNetState)
		if app.constant.delayTime < 1000 then
			app.constant.delayTime = app.constant.delayTime+1000
		end
		app.constant.lastNetState = netState
		GateNet.disconnect(4)
		--GateNet.disconnect(3)
		return
	end

	GateNet.sendData(string.char(math.floor(id/256)%256) .. string.char(id%256))
end

local function authReconectFun()

	-- GateNet.disconnect(4)
	if param.gateSocket then
		param.gateSocket:disconnect()
	end
	param.isAuth = false
	print("continue---reconnect---")
	param.gateSocket = nil
	param.reconnect = true
	local delay = scheduler.performWithDelayGlobal(
	function ()
	    GateNet.reconnect()
	end, 0.2)

end

local function receive(event)
	--print("receive ddddd")
	--print("receive event.data".. event.data)
	param.gateBuff = (param.gateBuff or "") .. event.data
    local len = #param.gateBuff
    while (len > 2) do
        local size = 256 * param.gateBuff:byte(1) + param.gateBuff:byte(2)
        if (len < 2 + size) then
            return
        end

        local id, data = recvData(param.gateBuff:sub(3, 2+size))
        --NOTE: update buff before process data.
       -- print("param.gateBuff:",#param.gateBuff)
        --print("param.size:".. tostring(size))
        param.gateBuff = param.gateBuff:sub(3 + size, #param.gateBuff)
        len = #param.gateBuff

        if not param.isAuth then

        	--print("receive 11111111,id,data:",id, data)
        	--print(id, type(id), Msgprotocol["AuthGateSuccess"], type(Msgprotocol["AuthGateSuccess"]))
        	if id == Msgprotocol["AuthGateSuccess"] then
        		print("GateNet.auth success!", data)

        		-- unscheduler reconnect
        		if param.reconnectScheduler then
        			scheduler.unscheduleGlobal(param.reconnectScheduler)
        			param.reconnectScheduler = nil
        			param.reconnect = true
        			--gotoLobbyScene()
        		end

        		--param.reconnect = true
        		param.isAuth = true
        		Message.net = GateNet
        		if param.scheduler ~= nil then
        			scheduler.unscheduleGlobal(param.scheduler)
        			param.scheduler = nil
        		end
        		print("receive:update-----")
        		GateNet.update()
        		param.scheduler = scheduler.scheduleGlobal(heartbeat, 5.0)

        		-- 如果有存储待发送消息，继续发送
        		if #msgWaitReconnct > 0 then
        			for i,v in ipairs(msgWaitReconnct) do
						param.gateSocket:send(v)
        			end
        			msgWaitReconnct = {}
        		end
        		app.constant.delayTime = 50+math.random(50)

        		-- 通知当前界面连接成功
				Message.notifyScene("socket", GateNet.EVENT_CONNECTED)
        	else
        		print("GateNet.auth failed!", data)
        		print("reconnect-firstReconnect!", firstReconnect)

        		-- 验证失败，退出到登陆界面
        		GateNet.disconnect()
				gotoLoginScene()
        	end

    		if param.authCallback then
    			param.authCallback(param.isAuth, data)
    			param.authCallback = nil
    		end
        else
        	Message.dispatch(id, data)
        end
    end
end

local function close(event)
	print("gate close")
	param.gateSocket = nil
	param.isConnected = false
	param.isAuth = false
	msgWaitReconnct = {}

	Message.notifyScene("socket", GateNet.EVENT_CLOSE)
end

local function closed(event)
	print("gate closed", param.reconnect)
	Message.notifyScene("socket", GateNet.EVENT_CLOSED)

	schedulerReconnect()
end

local function connected(event)
	print("gate connected")
	param.isConnected = true
	--if isHasConnected == false then
	local isSucc = auth()
	if isSucc == false then
		authReconectFun()
	end
	--end
end

local function error(event)
	print("gate error", param.reconnect)
	Message.notifyScene("socket", GateNet.EVENT_CONNECT_FAILURE)

	schedulerReconnect()
end

function GateNet.sendData(data)
    local buff = string.char(math.floor(#data/256)%256) .. string.char(#data%256) .. data

    -- 重连
	if display.getRunningScene() ~= "LoginScene" and (not param.gateSocket or not param.isConnected) then
		GateNet.reconnect()
		if #msgWaitReconnct < 10 then
			table.insert(msgWaitReconnct, buff)
		end
		sendTime = 0
		return false
	end
	--print("gate auth44444,date:",data)
    --print("gate auth44444,buff:",buff)
	param.gateSocket:send(buff)
	return true
end

function GateNet.connect(authCallback)
	if param.gateSocket then
		return false
	end

	param = {}
	param.authCallback = authCallback
	param.reconnect = true
	print("GateNet.connect-----")
	GateNet.update()

	GateNet.realConnect()
	return true
end

function GateNet.reconnect()
	if param.gateSocket then
		return false
	end
	print("GateNet.connect000-----")
	GateNet.update()
	GateNet.realConnect()
    return true
end

function GateNet.realConnect()
	param.gateSocket = net.SocketTCP.new(ip, port, false)
	param.gateSocket:setName("GateTCP")
	param.gateSocket:setConnFailTime(2)
	param.gateSocket:setReconnTime(2)

	param.gateSocket:addEventListener(net.SocketTCP.EVENT_DATA, receive)
	param.gateSocket:addEventListener(net.SocketTCP.EVENT_CLOSE, close)
	param.gateSocket:addEventListener(net.SocketTCP.EVENT_CLOSED, closed)
	param.gateSocket:addEventListener(net.SocketTCP.EVENT_CONNECTED, connected)
	param.gateSocket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, error)

    print("gate realConnect:")
    local flag = param.gateSocket:connect(GATE_SERVER.ip, GATE_SERVER.port)
    if tonumber(flag) == 2 then
    	print("gate realConnect:",flag)
    	param.gateSocket = nil 

    end
end

function GateNet.disconnect(type)
	print("GateNet.disconnect-type = ", type)
	param.reconnect = (type == 4)
	print("GateNet.disconnect-param.reconnect = ", param.reconnect)
	if param.gateSocket then
		--param.gateSocket:closeEx()
		param.gateSocket:disconnect()
		param.gateSocket = nil
	end
end

function GateNet.update()
	--print("GateNet.update---111")
	if param.gateSocket ~= nil then
		local t0 = param.gateSocket:getTime()
		receiveTime = t0
		if sendTime ~= 0 then
			app.constant.delayTime = math.ceil((receiveTime-sendTime)*1000)
			sendTime = 0
			--print("receiveTime = ", receiveTime .. "ms")
			--print("delayTime = ", app.constant.delayTime .. "ms")
		end
	end
	local netState = network.getInternetConnectionStatus()
    app.constant.lastNetState = netState
	param.lastHearTime = os.time()
	app.constant.lastHearTime = param.lastHearTime
end

return GateNet