local Userinfo = class("Userinfo", cc.mvc.ModelBase)

Userinfo.schema = clone(cc.mvc.ModelBase.schema)
Userinfo.schema["nickname"] = {"string"} 
Userinfo.schema["headimgurl"] = {"string"} 
Userinfo.schema["sex"] = {"number"} 

function Userinfo:ctor(properties, events, callbacks)
    Userinfo.super.ctor(self, properties)
end

function Userinfo:getKey(  )
	-- self.index = self.index + 1
	-- local handshake = string.format("%s@%s#%s:%d", crypt.base64encode(self.user_), crypt.base64encode(self.server_),crypt.base64encode(self.subid_) , self.index)
	-- local hmac = crypt.hmac64(crypt.hashkey(handshake), self.secret_)
	-- return handshake .. ":" .. crypt.base64encode(hmac)
	return self.user_..":"..crypt.hexencode(self.secret_)
end

return Userinfo