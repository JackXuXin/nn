--与   同为1，则为1

--或   有一个为1，则为1

--非   true为 false，其余为true

--异或 相同为0，不同为1

local MathBit = {}

local function __andBit(left,right)    --与
    return (left == 1 and right == 1) and 1 or 0
end

local function __orBit(left, right)    --或
    return (left == 1 or right == 1) and 1 or 0
end

local function __xorBit(left, right)   --异或
    return (left + right) == 1 and 1 or 0
end

local function __base(left, right, op) --对每一位进行op运算，然后将值返回
    if left < right then
        left, right = right, left
    end
    local res = 0
    local shift = 1
    while left ~= 0 do
        local ra = left % 2    --取得每一位(最右边)
        local rb = right % 2
        res = shift * op(ra,rb) + res
        shift = shift * 2
        left = math.modf( left / 2)  --右移
        right = math.modf( right / 2)
    end
    return res
end

--按位与
function MathBit.andOp(left, right)
    return __base(left, right, __andBit)
end

--按位或
function MathBit.orOp(left, right)
    return __base(left, right, __orBit)
end

--按位异或
function MathBit.xorOp(left, right)
    return __base(left, right, __xorBit)
end

--按位取反
function MathBit.notOp(left)
    return left > 0 and -(left + 1) or -left - 1
end

function MathBit.lShiftOp(left, num)  --left左移num位
    return left * (2 ^ num)
end

function MathBit.rShiftOp(left,num)  --right右移num位
    return math.floor(left / (2 ^ num))
end

return MathBit