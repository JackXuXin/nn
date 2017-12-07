require "lfs"

local GameState = require("framework.cc.utils.GameState")

local NetSprite = class("NetSprite",function()
	return display.newSprite()
end)

function NetSprite:ctor(url, waitUrl, imgTouXiang ,isSave)--创建NetSprite

	--获取本地存储目录
	
	self.path = device.writablePath.."netSprite/" 
	if isSave ~= nil then

		self.path = device.writablePath.."netActivity/" 

	end

	if not io.exists(self.path) then
		lfs.mkdir(self.path) --目录不存在，创建此目录
	end
	self.url  = url
	self.waitUrl = waitUrl
	self.imgTouXiang = imgTouXiang
	self.isSave = isSave
	self.imageBg = imageBg
	self:createSprite()
end

function NetSprite:getUrlMd5()

	local tempMd5 = nil

	if self.isSave ~= nil then

		tempMd5 = crypto.md5(self.isSave)
		print("self.issave"  .. self.isSave)

	else

		tempMd5 = crypto.md5(self.url)

	end

    if GameData.netSprite == nil then --判断本地保存数据是否存在
        GameData.netSprite = {} --如果不存在，先创建netSprite数组，保存
        GameState.save(GameData)
	else
        for i=1,#(GameData.netSprite) do
            if GameData.netSprite[i] == tempMd5 then
                return true,self.path..tempMd5..".png" --存在，返回本地存储文件完整路径
            end
        end
	end
	return false,self.path..tempMd5..".png" --不存在，返回将要存储的文件路径备用
end

function NetSprite:setUrlMd5(isOvertime)
	if not isOvertime then --如果不是超时
		if self.isSave ~= nil then

			table.insert(GameData.netSprite,crypto.md5(self.isSave)) --保存下载后的文件MD5值

		else

			table.insert(GameData.netSprite,crypto.md5(self.url)) --保存下载后的文件MD5值

		end
		GameState.save(GameData)
	end
end

function NetSprite:createSprite()
	local isExist,fileName = self:getUrlMd5()

	print("isExist,", isExist)

	if isExist then --如果存在，直接更新纹理
		self:updateTexture(fileName) 
	else --如果不存在，启动http下载
		if self.waitUrl ~= nil then
			print("mo ren ----image---")
			self:updateTexture(self.waitUrl) 
		end
		if network.getInternetConnectionStatus() == cc.kCCNetworkStatusNotReachable then
			print("not net")
			return
		end

		local request = network.createHTTPRequest(function(event)
			--local scene = display.getRunningScene()
			print("requestWchatImage-----")
			if self.onRequestFinished then
				self:onRequestFinished(event,fileName)
			end
		  end,self.url, "GET")
		request:start()
	end
end

function NetSprite:onRequestFinished(event,fileName)
	
	print("Enter-onRequestFinished-----")
	--print("fileNamenn-----",fileName)
    local ok = (event.name == "completed")
    local request = event.request
    if not ok then
    	print("not ok-----")
        -- 请求失败，显示错误代码和错误消息
        print(request:getErrorCode(), request:getErrorMessage())
        return
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        print(code)
        return
    end

    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    print(response)
    
    --保存下载数据到本地文件，如果不成功，重试30次。
    local times = 1 
    while (not request:saveResponseData(fileName)) and times < 60 do
    	times = times + 1
    	--print("times:",times)
    end
    local isOvertime = (times == 60) --是否超时
   -- if self.isSave == nil then
    	self:setUrlMd5(isOvertime) --保存md5
	--end
    self:updateTexture(fileName) --更新纹理
end

function NetSprite:updateTexture(fileName)
	print("updateTexture-fileName00:", fileName)
	local sprite = display.newSprite(fileName) --创建下载成功的sprite
	if not sprite then return end
	local texture = sprite:getTexture()--获取纹理
	local sizeImg = texture:getContentSize()
	self:setTexture(texture)--更新自身纹理
	self:setContentSize(sizeImg)
	self:setTextureRect(cc.rect(0,0,sizeImg.width,sizeImg.height))

	if self.imgTouXiang ~= nil then

		local size = self.imgTouXiang:getContentSize()
		local scalex = self.imgTouXiang:getScaleX()*(size.width/sizeImg.width)
		local scaley = self.imgTouXiang:getScaleY()*(size.height/sizeImg.height)
		--print("updateTexture:scale=", scalex, scaley)
        self:setScale(self.imgTouXiang:getScaleX()*(size.width/sizeImg.width),self.imgTouXiang:getScaleY()*(size.height/sizeImg.height))

	end
	
end


return NetSprite