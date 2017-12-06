local LoginNet = {}

local net = require("framework.cc.net.init")
local crypt = require("crypt")
local util = require("app.Common.util")
local web = require("app.net.web")

local Account = app.userdata.Account

local function report(callback, result, tip, ...)
	if callback then
		callback(result, tip, ...)
	end
end

local function auth(callback, time, msg, params)
    local request = network.createHTTPRequest(function (event)
        local result = web.checkResponse(event)
        print("result222:"..result)
        if result == 0 then
            return
        elseif result == -1 then
            report(callback, false, code)
            return
        end

        -- 请求成功，显示服务端返回的内容
        local response = event.request:getResponseString()
        print("resp:"..response)

        

--modify by whb 2016 1202

        local str = response

        local ferror = string.find(str, "error")

        local tip

        if ferror ~= nil then

            local _, flogin = string.find(str, "login=")

            local _, fregister = string.find(str, "register=")

            local _, fother = string.find(str, "other=")

            if flogin ~= nil then
             
                tip = string.sub(str, flogin+1)

                print("ceshi:" .. tip)

            elseif fregister ~= nil then

                tip = string.sub(str, fregister+1)

                print("ceshi2:" .. tip)

            elseif fother ~= nil then

                tip = string.sub(str, fother+1)

                print("ceshi3:" .. tip)

            end

            report(callback, false, tip)

            return;

        end

--modigfy end
        if response == "login account no record" then
            report(callback, false, code)
            return
        end
        
        response = crypt.base64decode(response)
        response = crypt.my_decode(time, response)
        print("success", response)
            -- parse response
        local resp = {}
        for i,v in ipairs(string.split(response, "&")) do
            local key,value = string.match(v, "([^=]*)=(.*)")
            print(key, value)
            resp[key] = value
        end

        -- check sign
        local sign = "result="..resp.result.."&uid="..resp.uid.."&token="..resp.token
        sign = crypt.base64encode(crypt.hmac_sha1("hash_key", sign))

        if sign ~= resp.sign then
            report(callback, false)
            return
        end

        Account.account = params.account
        Account.password = params.password
        Account.channel = params.channel
        Account.uid = tonumber(resp.uid)
        Account.token = crypt.base64decode(resp.token)
        Account.secret = resp.secret

   --modify by whb 161020
        Account.app_channel = params.app_channel

    --end

        if CONFIG_APP_CHANNEL ~= "3553" and (device.platform == "android" or device.platform == "ios") then
             buglySetUserId(CONFIG_APP_CHANNEL .. "-" .. CONFIG_VERSION_ID .. "-id:" .. Account.uid )
        end

        dump(resp)

        report(callback, true)

    end, "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/login", "POST")

    request:addPOSTValue("time", tostring(time))
    request:addPOSTValue("content", msg)
    request:start()
    print("login-request--begin---")

   -- print("77--resp:"..resp)

end

function LoginNet.auth(callback, params)
    web.getServerTime(function (time)
        if time <= 0 then
            return
        end

        params.version = util.getVersion()
        params.platform = device.platform
        local msg = json.encode(params)

        msg = crypt.my_encode(time, msg)
        msg = util.tohex(msg)

        print("77--auth:"..params.app_channel)

        auth(callback, time, msg, params)
    end)
end


local function getCode(callback, time, msg, params)
    local request = network.createHTTPRequest(function (event)
        local result = web.checkResponse(event)
        print("getCode--result:"..result)
        if result == 0 then
            return
        elseif result == -1 then
            report(callback, false, code)
            return
        end

        -- 请求成功，显示服务端返回的内容
        local response = event.request:getResponseString()
        print("resp:"..response)


        local str = response

        local ferror = string.find(str, "error")

        local tip

        if ferror ~= nil then

            local _, fcode = string.find(str, "code=")

            if fcode ~= nil then
             
            tip = string.sub(str, fcode+1)

            print("code-ceshi:" .. tip)

            end

            report(callback, false, tip)

            return

        end

        print("code----:",params.mobile)

        -- response = util.fromhex(response)
        -- --response = crypt.base64decode(response)
        -- response = crypt.my_decode(time, response)
        -- print("getCode-success:", response)
        --     -- parse response
        -- local resp = {}
        -- for i,v in ipairs(string.split(response, "&")) do
        --     local key,value = string.match(v, "([^=]*)=(.*)")
        --     print(key, value)
        --     resp[key] = value
        -- end

        -- dump(resp)

        report(callback, true)

    end, "http://"..LOGIN_SERVER.ip..":"..LOGIN_SERVER.port.."/getVerificationCode", "POST")

    request:addPOSTValue("time", tostring(time))
    request:addPOSTValue("content", msg)
    print("conten:",msg)
    request:start()


end


function LoginNet.getCode(callback, params)
    web.getServerTime(function (time)
        if time <= 0 then
            return
        end

        local msg = json.encode(params)

        msg = crypt.my_encode(time, msg)
        msg = util.tohex(msg)

        getCode(callback, time, msg, params)

    end)
end

return LoginNet