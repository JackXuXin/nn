local Account = class("Account", cc.mvc.ModelBase)

Account.schema = clone(cc.mvc.ModelBase.schema)
Account.schema["openid"] = {"string"} 
Account.schema["assessToken"] = {"string"} 
Account.schema["platform"] = {"string"} 
Account.schema["secret"] = {"string"} 

function Account:ctor(properties, events, callbacks)
    Account.super.ctor(self, properties)
    self.index = 0
end

function Account:getKey(  )
	-- self.index = self.index + 1
	-- local handshake = string.format("%s@%s#%s:%d", crypt.base64encode(self.user_), crypt.base64encode(self.server_),crypt.base64encode(self.subid_) , self.index)
	-- local hmac = crypt.hmac64(crypt.hashkey(handshake), self.secret_)
	-- return handshake .. ":" .. crypt.base64encode(hmac)
	return self.openid_..":"..crypt.hexencode(self.secret_)
end

return Account