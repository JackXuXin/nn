#include "lua_ChannalChatNode_auto.hpp"
#include "ChannalChatNode.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_ChannalChatNode_ChannalChatNode_onEnter(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_onEnter'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_onEnter'", nullptr);
            return 0;
        }
        cobj->onEnter();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:onEnter",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_onEnter'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_sendText(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_sendText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_sendText'", nullptr);
            return 0;
        }
        cobj->sendText();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:sendText",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_sendText'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_GetCurChannalStr(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_GetCurChannalStr'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_GetCurChannalStr'", nullptr);
            return 0;
        }
        std::string ret = cobj->GetCurChannalStr();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:GetCurChannalStr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_GetCurChannalStr'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_BeginVoice(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_BeginVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_BeginVoice'", nullptr);
            return 0;
        }
        cobj->BeginVoice();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:BeginVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_BeginVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_setisvoiceAutoplay(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_setisvoiceAutoplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "ChannalChatNode:setisvoiceAutoplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_setisvoiceAutoplay'", nullptr);
            return 0;
        }
        cobj->setisvoiceAutoplay(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:setisvoiceAutoplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_setisvoiceAutoplay'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_onChannalloginListern(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_onChannalloginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::ChanngelLonginRespond* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR ChanngelLonginRespond*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_onChannalloginListern'", nullptr);
            return 0;
        }
        cobj->onChannalloginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:onChannalloginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_onChannalloginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_SetCurChannalIndex(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_SetCurChannalIndex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ChannalChatNode:SetCurChannalIndex");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_SetCurChannalIndex'", nullptr);
            return 0;
        }
        cobj->SetCurChannalIndex(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:SetCurChannalIndex",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_SetCurChannalIndex'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_PlayVoice(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_PlayVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        unsigned long long arg0;
        bool arg1;

        #pragma warning NO CONVERSION TO NATIVE FOR unsigned long long
		ok = false;

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "ChannalChatNode:PlayVoice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_PlayVoice'", nullptr);
            return 0;
        }
        cobj->PlayVoice(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:PlayVoice",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_PlayVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_setParent(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_setParent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_setParent'", nullptr);
            return 0;
        }
        cobj->setParent(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:setParent",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_setParent'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_onModChannelIdListern(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_onModChannelIdListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::ModChannelIdRespond* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR ModChannelIdRespond*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_onModChannelIdListern'", nullptr);
            return 0;
        }
        cobj->onModChannelIdListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:onModChannelIdListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_onModChannelIdListern'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_init(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_init'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_EndVoice(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_EndVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ChannalChatNode:EndVoice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_EndVoice'", nullptr);
            return 0;
        }
        cobj->EndVoice(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:EndVoice",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_EndVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_CancelVoice(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_CancelVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_CancelVoice'", nullptr);
            return 0;
        }
        cobj->CancelVoice();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:CancelVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_CancelVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_getChannalHistoryD(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_getChannalHistoryD'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_getChannalHistoryD'", nullptr);
            return 0;
        }
        cobj->getChannalHistoryD();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:getChannalHistoryD",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_getChannalHistoryD'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_removeFromParent(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_removeFromParent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_removeFromParent'", nullptr);
            return 0;
        }
        cobj->removeFromParent();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:removeFromParent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_removeFromParent'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_getChannalHistory(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_getChannalHistory'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "ChannalChatNode:getChannalHistory");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_getChannalHistory'", nullptr);
            return 0;
        }
        cobj->getChannalHistory(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:getChannalHistory",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_getChannalHistory'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_releaseVoiceList(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_releaseVoiceList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_releaseVoiceList'", nullptr);
            return 0;
        }
        cobj->releaseVoiceList();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:releaseVoiceList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_releaseVoiceList'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_onRecordVoiceListern(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_onRecordVoiceListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::RecordVoiceNotify* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR RecordVoiceNotify*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_onRecordVoiceListern'", nullptr);
            return 0;
        }
        cobj->onRecordVoiceListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:onRecordVoiceListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_onRecordVoiceListern'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_onExit(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_onExit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_onExit'", nullptr);
            return 0;
        }
        cobj->onExit();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:onExit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_onExit'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_setFrindChat(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_setFrindChat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "ChannalChatNode:setFrindChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_setFrindChat'", nullptr);
            return 0;
        }
        cobj->setFrindChat(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:setFrindChat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_setFrindChat'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_PlayVoiceEx(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_PlayVoiceEx'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ChannalChatNode:PlayVoiceEx");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "ChannalChatNode:PlayVoiceEx");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_PlayVoiceEx'", nullptr);
            return 0;
        }
        cobj->PlayVoiceEx(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:PlayVoiceEx",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_PlayVoiceEx'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_SetCurChannalStr(lua_State* tolua_S)
{
    int argc = 0;
    ChannalChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ChannalChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_ChannalChatNode_ChannalChatNode_SetCurChannalStr'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ChannalChatNode:SetCurChannalStr");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_SetCurChannalStr'", nullptr);
            return 0;
        }
        cobj->SetCurChannalStr(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ChannalChatNode:SetCurChannalStr",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_SetCurChannalStr'.",&tolua_err);
#endif

    return 0;
}
int lua_ChannalChatNode_ChannalChatNode_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ChannalChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_ChannalChatNode_ChannalChatNode_create'", nullptr);
            return 0;
        }
        ChannalChatNode* ret = ChannalChatNode::create();
        object_to_luaval<ChannalChatNode>(tolua_S, "ChannalChatNode",(ChannalChatNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ChannalChatNode:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_ChannalChatNode_ChannalChatNode_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_ChannalChatNode_ChannalChatNode_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ChannalChatNode)");
    return 0;
}

int lua_register_ChannalChatNode_ChannalChatNode(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ChannalChatNode");
    tolua_cclass(tolua_S,"ChannalChatNode","ChannalChatNode","YVChatNode",nullptr);

    tolua_beginmodule(tolua_S,"ChannalChatNode");
        tolua_function(tolua_S,"onEnter",lua_ChannalChatNode_ChannalChatNode_onEnter);
        tolua_function(tolua_S,"sendText",lua_ChannalChatNode_ChannalChatNode_sendText);
        tolua_function(tolua_S,"GetCurChannalStr",lua_ChannalChatNode_ChannalChatNode_GetCurChannalStr);
        tolua_function(tolua_S,"BeginVoice",lua_ChannalChatNode_ChannalChatNode_BeginVoice);
        tolua_function(tolua_S,"setisvoiceAutoplay",lua_ChannalChatNode_ChannalChatNode_setisvoiceAutoplay);
        tolua_function(tolua_S,"onChannalloginListern",lua_ChannalChatNode_ChannalChatNode_onChannalloginListern);
        tolua_function(tolua_S,"SetCurChannalIndex",lua_ChannalChatNode_ChannalChatNode_SetCurChannalIndex);
        tolua_function(tolua_S,"PlayVoice",lua_ChannalChatNode_ChannalChatNode_PlayVoice);
        tolua_function(tolua_S,"setParent",lua_ChannalChatNode_ChannalChatNode_setParent);
        tolua_function(tolua_S,"onModChannelIdListern",lua_ChannalChatNode_ChannalChatNode_onModChannelIdListern);
        tolua_function(tolua_S,"init",lua_ChannalChatNode_ChannalChatNode_init);
        tolua_function(tolua_S,"EndVoice",lua_ChannalChatNode_ChannalChatNode_EndVoice);
        tolua_function(tolua_S,"CancelVoice",lua_ChannalChatNode_ChannalChatNode_CancelVoice);
        tolua_function(tolua_S,"getChannalHistoryD",lua_ChannalChatNode_ChannalChatNode_getChannalHistoryD);
        tolua_function(tolua_S,"removeFromParent",lua_ChannalChatNode_ChannalChatNode_removeFromParent);
        tolua_function(tolua_S,"getChannalHistory",lua_ChannalChatNode_ChannalChatNode_getChannalHistory);
        tolua_function(tolua_S,"releaseVoiceList",lua_ChannalChatNode_ChannalChatNode_releaseVoiceList);
        tolua_function(tolua_S,"onRecordVoiceListern",lua_ChannalChatNode_ChannalChatNode_onRecordVoiceListern);
        tolua_function(tolua_S,"onExit",lua_ChannalChatNode_ChannalChatNode_onExit);
        tolua_function(tolua_S,"setFrindChat",lua_ChannalChatNode_ChannalChatNode_setFrindChat);
        tolua_function(tolua_S,"PlayVoiceEx",lua_ChannalChatNode_ChannalChatNode_PlayVoiceEx);
        tolua_function(tolua_S,"SetCurChannalStr",lua_ChannalChatNode_ChannalChatNode_SetCurChannalStr);
        tolua_function(tolua_S,"create", lua_ChannalChatNode_ChannalChatNode_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ChannalChatNode).name();
    g_luaType[typeName] = "ChannalChatNode";
    g_typeCast["ChannalChatNode"] = "ChannalChatNode";
    return 1;
}
TOLUA_API int register_all_ChannalChatNode(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_ChannalChatNode_ChannalChatNode(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

