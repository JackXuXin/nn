require "lfs"

local GameState = require("framework.cc.utils.GameState")

local NetSprite = class("NetSprite",function()
	return display.newSprite()
end)

local netSpritesCach = app.gameData:get("netSprites")
if netSpritesCach == nil then
	netSpritesCach = {}
	app.gameData:set("netSprites", netSpritesCach)
end

function NetSprite:ctor(url,size,callback)--创建NetSprite

	--获取本地存储目录
	
	self.path = device.writablePath.."netSprite/" 

	if not io.exists(self.path) then
		lfs.mkdir(self.path) --目录不存在，创建此目录
	end
	self.url  = url
	self.imageBg = imageBg
	self.callback = callback
	self.size = size
	self:createSprite()
end

function NetSprite:getUrlMd5()

	local tempMd5 = nil

	tempMd5 = crypto.md5(self.url)

	print("-------self.url----------")
		print(self.url)
		print(tempMd5)
	print("-------self.url----------")

    for i=1,#netSpritesCach do
        if netSpritesCach[i] == tempMd5 then
            return true,self.path..tempMd5..".png" --存在，返回本地存储文件完整路径
        end
    end
	return false,self.path..tempMd5..".png" --不存在，返回将要存储的文件路径备用
end

function NetSprite:setUrlMd5(isOvertime)
	if not isOvertime then --如果不是超时
		table.insert(netSpritesCach,crypto.md5(self.url)) 
		app.gameData:set("netSprites", netSpritesCach)
	end
end

function NetSprite:onFinishRequest( event )
	local _,fileName = self:getUrlMd5()
	print("---------------下载网络图片------------------")
	print("Enter-onRequestFinished-----")
    print("fileNamenn-----",fileName)
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
    	print("times:",times)
    end
  
    local isOvertime = (times == 60) --是否超时
   -- if self.isSave == nil then
    	self:setUrlMd5(isOvertime) --保存md5
	--end
	
    self:updateTexture(fileName) --更新纹理
   
     if self.callback then
    	self.callback(self)
    end
end

function NetSprite:createSprite()
	local isExist,fileName = self:getUrlMd5()

	print("isExist,", isExist)
	print(self.url)
	if isExist then 
		self:updateTexture(fileName) 
		self.callback(self)
	else 
		if network.getInternetConnectionStatus() == cc.kCCNetworkStatusNotReachable then
			print("not net")
			return
		end

		local request = network.createHTTPRequest(handler(self, self.onFinishRequest),self.url, "GET")
		request:start()
	end
end

function NetSprite:onRequestFinished(event,fileName)
	
  
    print("---------------下载网络图片2------------------")
   
end

function NetSprite:updateTexture(fileName)
	print("创建图片")
	print("updateTexture-fileName00:", fileName)
	local sprite = display.newSprite(fileName) --创建下载成功的sprite
	if not sprite then return end
	local texture = sprite:getTexture()--获取纹理
	local sizeImg = texture:getContentSize()
	self:setTexture(texture)--更新自身纹理
	self:setContentSize(sizeImg)
	self:setTextureRect(cc.rect(0,0,sizeImg.width,sizeImg.height))
	self:setScale(self.size.width/sizeImg.width,self.size.height/sizeImg.height)
end


return NetSprite