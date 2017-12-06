

local bit = require("app.Common.lg_bit")



local code = {}

function code.encode(params)

	local v = 0

	for _,param in pairs(params) do
		v = bit.xor(bit.lshift(v, #param), bit.tonumber(param))
	end

	return v
end

function code.decode(rule)
	
	-- tb 每个选项的个数 比如: {4,3,4,2,3,2}
	
	-- 玩法 4
	-- 底分 3
	-- 下庄分数 4
	-- 翻倍规则 2
	-- 特殊牌型 3
	-- 高级选项 2
	local tb = {4,3,4,2,3,2}
   
	local params = {}
	
	for idx,n in pairs(tb) do
		local o = 0
		for i=idx,#tb do
			o = o + tb[i]
		end
		table.insert(params, bit.tobits(bit.rshift(bit.lshift(rule, 32-o),32-n)))
	end

	return params
end

return code

--common.decode(common.encode({{0,0,0,1}, {0,1,0}, {0,0,0,1}, {0,0}, {0,1,1}, {0,0}}), {4,3,4,2,3,2})













