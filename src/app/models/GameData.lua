local GameData = class("GameData", function ()
    return {}
end)

local GameState_ = require("framework.cc.utils.GameState")

function GameData:ctor(  )
	print("ini game data", GameState_)
	GameState_.init(handler(self, self.init_), "data.txt", "12345678")
	print("end init game data")
	self.data = GameState_.load()
	if self.data == nil then
		self.data = {}
		GameState_.save(self.data)
	end
end

function GameData:init_( param )
	if param.errorCode then
	else
		if param.name == "save" then
			return self:save_(param.values)
		elseif param.name == "load" then
			return self:load_(param.values.data)
		end
	end
end

function GameData:save_( values )
	local str = json.encode(values)
	str = crypto.encryptXXTEA(str, "addd")
	return {data = str}
end

function GameData:load_( data )
	local str = crypto.decryptXXTEA(data, "addd")
	return json.decode(str)
end

------------------  public  ----------------------------

function GameData:set( key, value )
	self.data[key] = value
	GameState_.save(self.data)
end

function GameData:get( key )
	return self.data[key]
end

return GameData:new()