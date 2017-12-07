return
{
	[1] = {
		{gold = 100000, 		image = "Image/Common/Avatar/female_1.png"},
		{gold = 1000000, 		image = "Image/Common/Avatar/female_2.png"},
		{gold = 5000000, 		image = "Image/Common/Avatar/female_3.png"},
		{gold = 10000000, 		image = "Image/Common/Avatar/female_4.png"},
		{gold = 0, 				image = "Image/Common/Avatar/female_5.png"},
	},
	[2] = {
		{gold = 100000, 		image = "Image/Common/Avatar/male_1.png"},
		{gold = 1000000, 		image = "Image/Common/Avatar/male_2.png"},
		{gold = 5000000, 		image = "Image/Common/Avatar/male_3.png"},
		{gold = 10000000, 		image = "Image/Common/Avatar/male_4.png"},
		{gold = 0, 				image = "Image/Common/Avatar/male_5.png"},
	},

	getAvatar = function(self, sex, gold, viptype)

--modify by whb 161028
         if viptype > 0 then

          local vipImg = "Image/Common/Avatar/rich_god_2.png"
          return vipImg

         end
--end
		local t = self[sex]
		if not t or #t == 0 then
			logger.error("error! sex:%s", tostring(sex))
			return self[1][1].image
		end

		gold = checkint(gold)
		for i,v in ipairs(t) do
			if gold < v.gold then
				return v.image
			end
		end

		return t[#t].image
	end,


-- 	--circle:0是直角，1是圆角
-- 	getAvatarBG = function(self, sex, gold, viptype,circle)

-- --modify by yh
--          if viptype > 0 then
--          	if circle == 1 then
--          		return "Image/Common/Avatar/Cai_BG.png"
--           	else
--           		return "Image/Common/Avatar/Cai_BG.png"
--           	end
--          end
-- --end
-- 		local t = self[circle + 3]
-- 		if not t or #t == 0 then
-- 			logger.error("error! circle:%s", tostring(circle))
-- 			return self[3][1].image
-- 		end

-- 		gold = checkint(gold)
-- 		for i,v in ipairs(t) do
-- 			if gold < v.gold then
-- 				return v.image
-- 			end
-- 		end

-- 		return t[#t].image
-- 	end,

-- 	getRoomAvatar = function(self, sex, gold, viptype)

-- --modify by yh
--          if viptype > 0 then
--          	return "Image/Common/Avatar/rich_god_1.png"
--          end
-- --end
-- 		local t = self[sex + 4]
-- 		if not t or #t == 0 then
-- 			logger.error("error! sex:%s", tostring(sex))
-- 			return self[5][1].image
-- 		end

-- 		gold = checkint(gold)
-- 		for i,v in ipairs(t) do
-- 			if gold < v.gold then
-- 				return v.image
-- 			end
-- 		end

-- 		return t[#t].image
-- 	end,

	getBgByRolesUrl = function(self, iconUrl)

	    local fwoman = string.find(iconUrl, "female")

	    local fman = string.find(iconUrl, "male")

	    local tip = ""

	    if fwoman ~= nil then

            local _, fw = string.find(iconUrl, "female_")

            if fw ~= nil then
             
	            tip = string.sub(iconUrl, fw+1)

	            print("ceshi:" .. tip)

            end

        elseif fman ~= nil then

        	local _, fw = string.find(iconUrl, "male_")

            if fw ~= nil then
             
	            tip = string.sub(iconUrl, fw+1)

	            print("ceshi:" .. tip)

       		 end

        else

        	return self[3][1].image

        end

         return "Image/Common/Avatar/bg_circle_" .. tip
	end,
}