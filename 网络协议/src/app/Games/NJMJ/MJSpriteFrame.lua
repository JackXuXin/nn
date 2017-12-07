local MJSpriteFrame = class("MJSpriteFrame")
function MJSpriteFrame:ctor()
    --加载手牌的背景资源
    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 74, 126))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai.png")
    for i = 1, 5 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(72*(j-1), 89*(i-1), 72, 89))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_Hua.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 23, 35))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_Hua.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX_Hua.png")
    for i = 1, 3 do
        for j = 1, 4 do
            if i == 1 and j < 4 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 4*16+4+j))
            elseif i == 2 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+j))
            elseif i == 3 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(31*(j-1), 37*(i-1), 31, 37))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX_Hua%d.png", 5*16+4+j))
            end
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 40, 61))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiSX.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(36*(j-1), 44.6*(i-1), 36, 44.6))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiSX%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_mydaopai_cpg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 74))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_mydaopai_cpg.png")
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_daocpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(60*(j-1), 48*(i-1), 60, 48))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_daocpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_backcard.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 60, 98))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_backcard.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 60, 98))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(56*(j-1), 69.2*(i-1), 56, 69.2))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_cpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tanpai_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 74, 126))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tanpai_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tanpai_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 74, 126))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tanpai_hun_cai.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun.png")

    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_up_card_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_up_card_hun_cai.png")


    texture = cc.Director:getInstance():getTextureCache():addImage("Platform_Src/ShYMJ/img_spe_pangguan_card.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 61, 69))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "Platform_Src/ShYMJ/img_spe_pangguan_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card_shadow.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 74, 126))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_shadow.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/MJ_jiantou.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 41))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/MJ_jiantou.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/NJ_outCard_shadow.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 40, 61))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/NJ_outCard_shadow.png")

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 26, 58))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiZY_Hua.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 31, 27))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiZY_Hua.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiZY_Hua.png")
    for i = 1, 3 do
        for j = 1, 4 do
            if i == 1 and j < 4 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 4*16+4+j))
            elseif i == 2 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 5*16+j))
            elseif i == 3 then
                frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(46*(j-1), 29*(i-1), 46, 29))
                cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY_Hua%d.png", 5*16+4+j))
            end
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_paichiZY.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_paichiZY.png")


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvaluePaichiZY.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(37*(j-1), 30*(i-1), 37, 30))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvaluePaichiZY%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY_daopai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 50))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY_daopai.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalueZY_DaoPaicpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(30*(j-1), 37.2*(i-1), 30, 37.2))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalueZY_DaoPaicpg%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiZY_cpg_back.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiZY_cpg_back.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_cpgZY.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_cpgZY.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalueZY_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(37*(j-1), 30*(i-1), 37, 30))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalueZY_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card_spe_hun.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card_spe_hun.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_left_card_spe_hun_cai.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 46, 44))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_left_card_spe_hun_cai.png")


    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/NJ_outCard_shadow2.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 48, 46))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/NJ_outCard_shadow2.png")
   
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_sendcardframe.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 116, 156))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_sendcardframe.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_0.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 158))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_0.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_1.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_1.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_2.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_2.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_3.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_3.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_4.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 200, 182))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_4.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_5.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 110, 76))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_5.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_9.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 190, 148))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_9.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_10.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 277, 182))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_10.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/ani_special_circle.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 126, 124))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/ani_special_circle.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/text_gangqian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 68, 28))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/text_gangqian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_ready.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 78, 40))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_ready.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitPlayer.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 307, 54))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitPlayer.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_zhuang.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 48, 50))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_zhuang.png")
    

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_WaitDian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 16, 16))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_WaitDian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_GameUI_EmptyDian.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 10, 9))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_GameUI_EmptyDian.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_tuoguan_zhi.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 117, 68))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_tuoguan_zhi.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/bixiahu.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 92, 38))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/bixiahu.png")

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/zuoshang.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 171, 70))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/zuoshang.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/DYResult/img_card_result.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 43, 62))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/DYResult/img_card_result.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/Hu.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 42, 43))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/Hu.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_tuzhang1.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 271, 215))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_cardvalue_tuzhang1.png")

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_right_card.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 26, 58))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_right_card.png")

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_normal_card_up.png")
    local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 38, 63))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_normal_card_up.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_top.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_top.png")
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_UpZY.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(30*(j-1), 24*(i-1), 30, 24))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_UpZY%d.png", i*16+j))
        end
    end
    
    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_paichiSX_cpg_back.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 52))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_paichiSX_cpg_back.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_spe_Up_cpg.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 32, 50))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/img_spe_Up_cpg.png")

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_cardvalue_shoupai_cpg.png")
    for i = 1, 4 do
        for j = 1, 9 do
            frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(32*(j-1), 39.6*(i-1), 32, 39.6))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_cardvalue_shoupai_cpg%d.png", i*16+j))
        end
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/NJResult/NJ_outCard_shadow3.png")
    frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(0, 0, 36, 56))
    cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, "ShYMJ/NJResult/NJ_outCard_shadow3.png")

    local texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_dice_rotate.png")
    for i = 1, 9 do
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect((i-1)*50, 0, 50, 54))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_dice_rotate%d.png", i))
    end

    texture = cc.Director:getInstance():getTextureCache():addImage("ShYMJ/img_dice_normal.png")
    for i = 1, 6 do
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect((i-1)*52, 0, 52, 52))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("ShYMJ/img_dice_normal%d.png", i))
    end

end

function MJSpriteFrame:init(callback)
    self.callBack = callback
    return self
end

return MJSpriteFrame