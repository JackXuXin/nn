local web = {}

function web.checkResponse(event)
    --dump(event)
    if event.name == "progress" then
        return 0
    end

    local request = event.request
    local ok = (event.name == "completed")
    if not ok then
        return -1
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then
        return -1
    end

    return 1
end

function web.getServerTime(callback)
    local reqTime = network.createHTTPRequest(function (event)
        local result = web.checkResponse(event)
        if result == 0 then
            return
        elseif result == -1 then
            if callback then
	            callback(0)
	        end
            return
        end

        local response = event.request:getResponseString()
        local time = math.floor(checknumber(response))

        if callback then
            callback(time)
        end

    end, "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/hello", "GET")

    reqTime:start()
end

return web