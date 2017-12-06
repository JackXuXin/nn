local bit = {}

local function check_int(n)
 -- checking not float
 if(n - math.floor(n) > 0) then
  error("trying to use bitwise operation on non-integer!")
 end
end

function bit.tobits(n)
 check_int(n)
 if(n < 0) then
  -- negative
  return bit.tobits(bit.bnot(math.abs(n)) + 1)
 end
 -- to bits table
 local tbl = {}
 local cnt = 1
 while (n > 0) do
  -- local last = math.mod(n,2)
  local last = n%2
  if(last == 1) then
   tbl[cnt] = 1
  else
   tbl[cnt] = 0
  end
  n = (n-last)/2
  cnt = cnt + 1
 end

 return tbl
end

function bit.tonumber(tbl)
 local n = #tbl

 local rslt = 0
 local power = 1
 for i = 1, n do
  rslt = rslt + tbl[i]*power
  power = power*2
 end
 
 return rslt
end

local function expand(tbl_m, tbl_n)
 local big = {}
 local small = {}
 if(#tbl_m > #tbl_n) then
  big = tbl_m
  small = tbl_n
 else
  big = tbl_n
  small = tbl_m
 end
 -- expand small
 for i = #small + 1, #big do
  small[i] = 0
 end

end

function bit.bor(m, n)
 local tbl_m = bit.tobits(m)
 local tbl_n = bit.tobits(n)
 expand(tbl_m, tbl_n)

 local tbl = {}
 local rslt = math.max(#tbl_m, #tbl_n)
 for i = 1, rslt do
  if(tbl_m[i]== 0 and tbl_n[i] == 0) then
   tbl[i] = 0
  else
   tbl[i] = 1
  end
 end
 
 return bit.tonumber(tbl)
end

function bit.band(m, n)
 local tbl_m = bit.tobits(m)
 local tbl_n = bit.tobits(n)
 expand(tbl_m, tbl_n) 

 local tbl = {}
 local rslt = math.max(#tbl_m, #tbl_n)
 for i = 1, rslt do
  if(tbl_m[i]== 0 or tbl_n[i] == 0) then
   tbl[i] = 0
  else
   tbl[i] = 1
  end
 end

 return bit.tonumber(tbl)
end

function bit.bnot(n)
 
 local tbl = bit.tobits(n)
 local size = math.max(#tbl, 32)
 for i = 1, size do
  if(tbl[i] == 1) then 
   tbl[i] = 0
  else
   tbl[i] = 1
  end
 end
 return bit.tonumber(tbl)
end

function bit.xor(m, n)
 local tbl_m = bit.tobits(m)
 local tbl_n = bit.tobits(n)
 expand(tbl_m, tbl_n) 

 local tbl = {}
 local rslt = math.max(#tbl_m, #tbl_n)
 for i = 1, rslt do
  if(tbl_m[i] ~= tbl_n[i]) then
   tbl[i] = 1
  else
   tbl[i] = 0
  end
 end
 
 --table.foreach(tbl, print)

 return bit.tonumber(tbl)
end

function bit.rshift(n, bits)
 check_int(n)
 
 local high_bit = 0
 if(n < 0) then
  -- negative
  n = bit.bnot(math.abs(n)) + 1
  high_bit = 2147483648 -- 0x80000000
 end

 for i=1, bits do
  n = n/2
  n = bit.bor(math.floor(n), high_bit)
 end
 return math.floor(n)
end

-- logic rightshift assures zero filling shift
function bit.lrshift(n, bits)
 check_int(n)
 if(n < 0) then
  -- negative
  n = bit.bnot(math.abs(n)) + 1
 end
 for i=1, bits do
  n = n/2
 end
 return math.floor(n)
end

function bit.lshift(n, bits)
 check_int(n)
 
 if(n < 0) then
  -- negative
  n = bit.bnot(math.abs(n)) + 1
 end

 for i=1, bits do
  n = n*2
 end
 return bit.band(n, 4294967295) -- 0xFFFFFFFF
end

function bit.xor2(m, n)
 local rhs = bit.bor(bit.bnot(m), bit.bnot(n))
 local lhs = bit.bor(m, n)
 local rslt = bit.band(lhs, rhs)
 return rslt
end

return bit