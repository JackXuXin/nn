--搓牌效果



local mode ={}

local M_PI = 3.1415
local m_pBgSprite
local m_sGridSize
local m_pForeSprite 
local m_pBgSprite
local mHOffsetX
local mHOffsetY
local mVOffsetX
local mVOffsetY



local function vertex( position,pTarget)  
    local g = pTarget:getGrid()  
    return g:vertex(position)  
end  

local function originalVertex(position,pTarget)  
  
    local g = pTarget:getGrid()  
    return g:originalVertex(position)  
end  
 
local function setVertex(position, vertex,pTarget)  
  
    local g  = pTarget:getGrid();  
    g:setVertex(position, vertex);  
end  
  



function mode:calculateHorizontalVertexPoints(offsetX,flag)    
    local  R = 50       
    if flag then 
      
        local  theta = M_PI / 6.0    --弧度
        local  agle  = 180/M_PI * theta
        local   b = (m_pBgSprite:getContentSize().width - offsetX * 1.4) * math.sin(agle)   --sinf(theta);  
          
        for  i = 1, m_sGridSize.width do  
          
            for  j = 1 ,m_sGridSize.height do
              
                -- Get original vertex  
                local p = originalVertex(cc.p(i ,j),m_pForeSprite) 
                  
                local  x = (p.y + b) / math.tan(agle) 
                  
                local pivotX = x + (p.x - x) * math.cos(agle) * math.cos(agle) 
                local pivotY = pivotX * math.tan(agle) - b  
                  
                local l = (p.x - pivotX) / math.sin(agle)  
                local alpha = l / R 
                local alpha_a = 180/M_PI * alpha 
                if l >= 0  then
                   
	                    if alpha > M_PI then 
	                        p.x = mHOffsetX + pivotX - R * (alpha - M_PI) * math.sin(agle)  
	                        p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle)  
	                        p.z = 2 * R / 9  
	                      
	                    else if alpha <= M_PI  then                      
	                        p.x = mHOffsetX + pivotX + R * math.sin(alpha_a) * math.sin(agle)  
	                        p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * math.cos(agle)  
	                        p.z = (R - R * math.cos(agle)) / 9  
	                    end  
                  
                else 
                  
                    p.x =  p.x + mHOffsetX  
                    p.y =  p.y + mHOffsetY  
                end  
                  
                -- Set new coords  
                setVertex(cc.p(i, j), p,m_pForeSprite)  
                  
                  
            end  
        end  
          
        for  i = 1, m_sGridSize.width do  
          
            for  j = 1,m_sGridSize.height do
              
                -- Get original vertex  
                local   p = originalVertex(cc.p(i ,j),m_pBgSprite)
                local  x = (p.y + b) / math.tan(agle)  
                  
                local pivotX = x + (p.x - x) * math.cos(agle) * math.cos(agle)  
                local  pivotY = pivotX * math.tan(agle) - b  
                  
                local l = (p.x - pivotX) / math.sin(agle)  
                local alpha = l / R 
                local alpha_a = 180/M_PI * alpha 
                if (l >= 0) then
                    if (alpha > M_PI) then
                        p.x = mHOffsetX + pivotX - R * (alpha - M_PI) * math.sin(agle)  
                        p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle) 
                        p.z = 2 * R / 9 
 
                    else if (alpha <= M_PI)  then
                     
                        p.x = mHOffsetX + pivotX + R * math.sin(alpha_a) * sinf(agle)  
                        p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * cosf(agle)  
                        p.z = R - R * math.cos(alpha_a)) / 9  
                    end 
                  
                else  
                  
                    p.x = p.x + mHOffsetX  
                    p.y = p.y + mHOffsetY  
                end  
                  
                setVertex(cc.p(i, j), p,m_pBgSprite) 
                                   
                  
            end  
        end  
          
      
    else  
      
        local  theta = M_PI / 6.0 
        local  agle  = 180/M_PI * theta
        local  b = math.abs(offsetX * 0.8) 
        for i = 1 , m_sGridSize.width  do
          
            for  j = 1, m_sGridSize.height do
              
                -- Get original vertex  
                local p = originalVertex(cc.p(i ,j),m_pForeSprite)  
                  
                local x = (p.y - b) / - math.tan(agle)  
                  
                local pivotX = p.x + (x - p.x) * math.sin(agle) * math.sin(agle)  
                local pivotY = pivotX * -math.tan(agle) + b  
                  
                local l = (pivotX - p.x) / math.sin(agle)  
                local alpha = l / R
                local alpha_a = 180/M_PI * alpha  


                if (l >= 0) then
                    if (alpha > M_PI) then
                        p.x = mHOffsetX + pivotX + R * (alpha - M_PI) * math.sin(agle)  
                        p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle) 
                        p.z = 2 * R / 9 
                     
                    else if (alpha <= M_PI)   then
                      
                        p.x = mHOffsetX + pivotX - R * math.sin(alpha_a) * math.sin(agle)  
                        p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * math.cos(agle)  
                        p.z = (R - R * math.cos(alpha_a)) / 9  
                    end 
                
                else  
                
                    p.x = p.x+mHOffsetX  
                    p.y = p.y+mHOffsetY 
                end 
                  
                -- Set new coords  
                setVertex(cc.p(i, j), p,m_pForeSprite)  
                  
                  
            end  
        end  
          
        for i = 1 ,m_sGridSize.width do  
          
            for  j = 1, m_sGridSize.height do
              
                -- Get original vertex  
                local p = originalVertex(ccp(i ,j),m_pBgSprite)  
                  
                local x = (p.y - b) / -math.tan(agle)  
                  
                local pivotX = p.x + (x - p.x) * math.sin(agle) * math.sin(agle) 
                local pivotY = pivotX * -math.tan(agle) + b  
                  
                local l = (pivotX - p.x) / math.sin(agle)  
                local alpha = l / R 
                local alpha_a = 180/M_PI * alpha  
                if (l >= 0)  then  
                    if (alpha > M_PI) then
                        p.x = mHOffsetX + pivotX + R * (alpha - M_PI) * math.sin(agle) 
                        p.y = mHOffsetY + pivotY + R * (alpha - M_PI) * math.cos(agle)  
                        p.z = 2 * R / 9 
                     
                    else if (alpha <= M_PI) then 
                      
                        p.x = mHOffsetX + pivotX - R * math.sin(alpha_a) * math.sin(agle) 
                        p.y = mHOffsetY + pivotY - R * math.sin(alpha_a) * math.cos(agle)  
                        p.z = (R - R * math.cos(alpha_a)) / 9  
                    end  
                  
                else  
                  
                    p.x = p.x+mHOffsetX  
                    p.y = p.y+mHOffsetY  
                end  
  
                  
                setVertex(cc.p(i, j), p,m_pBgSprite)  
            end 
        end  
    end  
      
    
end  
  
function mode:calculateVerticalVertexPoints( offsetY)  
  
    local R2 = 50  
    local pivotY = offsetY + mVOffsetY  
      
      
    for  i = 1, m_sGridSize.width do
      
        for j = 1,m_sGridSize.height do
          
            -- Get original vertex  
            local p = originalVertex(cc.p(i ,j),m_pForeSpriteVertical)  
            local l = pivotY - p.y  
            local alpha = l / R2
            local alpha_a = 180/M_PI * alpha 

            if (l >= 0) then 
                if (alpha > M_PI) then
                    p.z = 2 * R2 / 9  
                    p.y = mVOffsetY + pivotY + R2 * (alpha - M_PI) 
                    p.x = p.x + mVOffsetX;  
               
                else if (alpha <= M_PI) then
                 
                    p.z = (R2 - R2 * math.cos(alpha_a))/9  
                    p.y = mVOffsetY + pivotY - R2 * math.sin(alpha_a)                       
                    p.x = p.x +mVOffsetX  
                end  
             
            else  
             
                p.x = p.x + mVOffsetX  
                p.y = p.y + mVOffsetY  
            end  
              
              
            -- Set new coords  
            setVertex(cc.p(i, j), p,m_pForeSpriteVertical);  
              
              
        end  
    end  
      
    for i = 1, m_sGridSize.width do
      
        for j = 1, m_sGridSize.height do
          
            -- Get original vertex  
            local p = originalVertex(cc.p(i ,j),m_pBgSpriteVertical) 
            local l = pivotY - p.y 
            local alpha = l / R2
            local alpha_a = 180/M_PI * alpha 

            if (l >= 0)  then
                if (alpha > M_PI) then 
                    p.z = 2 * R2 / 9  
                    p.y = mVOffsetY + pivotY + R2 * (alpha - M_PI)  
                    p.x = p.x + mVOffsetX  
                  
                else if (alpha <= M_PI)  then
                  
                    p.z = (R2 - R2 * math.cos(alpha_a))/9  
                    p.y = mVOffsetY + pivotY - R2 * math.sin(alpha_a)  
                      
                    p.x = p.x + mVOffsetX  
                end  
              
            else  
              
                p.x = p.x +mVOffsetX  
                p.y = p.y +mVOffsetY  
            end           
            -- // Set new coords  
            setVertex(cc.p(i, j), p,m_pBgSpriteVertical)  
              
              
              
        end  
    end  
end  





return mode

