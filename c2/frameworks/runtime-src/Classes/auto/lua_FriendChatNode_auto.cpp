#include "lua_FriendChatNode_auto.hpp"
#include "FriendChatNode.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_FriendChatNode_FriendChatNode_sendText(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_sendText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "FriendChatNode:sendText");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_sendText'", nullptr);
            return 0;
        }
        cobj->sendText(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:sendText",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_sendText'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_InitTempChatData(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_InitTempChatData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "FriendChatNode:InitTempChatData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_InitTempChatData'", nullptr);
            return 0;
        }
        cobj->InitTempChatData(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:InitTempChatData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_InitTempChatData'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_sendPic(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_sendPic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "FriendChatNode:sendPic");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_sendPic'", nullptr);
            return 0;
        }
        cobj->sendPic(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:sendPic",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_sendPic'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_setChatUid(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_setChatUid'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "FriendChatNode:setChatUid");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_setChatUid'", nullptr);
            return 0;
        }
        cobj->setChatUid(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:setChatUid",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_setChatUid'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_BeginVoice(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_BeginVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_BeginVoice'", nullptr);
            return 0;
        }
        cobj->BeginVoice();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:BeginVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_BeginVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_setisvoiceAutoplay(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_setisvoiceAutoplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "FriendChatNode:setisvoiceAutoplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_setisvoiceAutoplay'", nullptr);
            return 0;
        }
        cobj->setisvoiceAutoplay(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:setisvoiceAutoplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_setisvoiceAutoplay'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_getFriendChatUid(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_getFriendChatUid'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_getFriendChatUid'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->getFriendChatUid();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:getFriendChatUid",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_getFriendChatUid'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_getHistoryIndex(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_getHistoryIndex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_getHistoryIndex'", nullptr);
            return 0;
        }
        long long ret = cobj->getHistoryIndex();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:getHistoryIndex",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_getHistoryIndex'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_init(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_init'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_EndVoice(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_EndVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "FriendChatNode:EndVoice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_EndVoice'", nullptr);
            return 0;
        }
        cobj->EndVoice(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:EndVoice",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_EndVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_CancelVoice(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_CancelVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_CancelVoice'", nullptr);
            return 0;
        }
        cobj->CancelVoice();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:CancelVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_CancelVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_clickMoreButton(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_clickMoreButton'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_clickMoreButton'", nullptr);
            return 0;
        }
        cobj->clickMoreButton();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:clickMoreButton",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_clickMoreButton'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_releaseVoiceList(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_releaseVoiceList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_releaseVoiceList'", nullptr);
            return 0;
        }
        cobj->releaseVoiceList();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:releaseVoiceList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_releaseVoiceList'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_PlayVoice(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_PlayVoice'", nullptr);
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

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "FriendChatNode:PlayVoice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_PlayVoice'", nullptr);
            return 0;
        }
        cobj->PlayVoice(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:PlayVoice",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_PlayVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_onExit(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_onExit'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_onExit'", nullptr);
            return 0;
        }
        cobj->onExit();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:onExit",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_onExit'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_setFrindChat(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_setFrindChat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "FriendChatNode:setFrindChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_setFrindChat'", nullptr);
            return 0;
        }
        cobj->setFrindChat(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:setFrindChat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_setFrindChat'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_getBeforeMsg(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_getBeforeMsg'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_getBeforeMsg'", nullptr);
            return 0;
        }
        cobj->getBeforeMsg();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:getBeforeMsg",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_getBeforeMsg'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_PlayVoiceEx(lua_State* tolua_S)
{
    int argc = 0;
    FriendChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (FriendChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_FriendChatNode_FriendChatNode_PlayVoiceEx'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        std::string arg0;
        bool arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "FriendChatNode:PlayVoiceEx");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "FriendChatNode:PlayVoiceEx");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_PlayVoiceEx'", nullptr);
            return 0;
        }
        cobj->PlayVoiceEx(arg0, arg1);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "FriendChatNode:PlayVoiceEx",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_PlayVoiceEx'.",&tolua_err);
#endif

    return 0;
}
int lua_FriendChatNode_FriendChatNode_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"FriendChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_FriendChatNode_FriendChatNode_create'", nullptr);
            return 0;
        }
        FriendChatNode* ret = FriendChatNode::create();
        object_to_luaval<FriendChatNode>(tolua_S, "FriendChatNode",(FriendChatNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "FriendChatNode:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_FriendChatNode_FriendChatNode_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_FriendChatNode_FriendChatNode_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (FriendChatNode)");
    return 0;
}

int lua_register_FriendChatNode_FriendChatNode(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"FriendChatNode");
    tolua_cclass(tolua_S,"FriendChatNode","FriendChatNode","YVChatNode",nullptr);

    tolua_beginmodule(tolua_S,"FriendChatNode");
        tolua_function(tolua_S,"sendText",lua_FriendChatNode_FriendChatNode_sendText);
        tolua_function(tolua_S,"InitTempChatData",lua_FriendChatNode_FriendChatNode_InitTempChatData);
        tolua_function(tolua_S,"sendPic",lua_FriendChatNode_FriendChatNode_sendPic);
        tolua_function(tolua_S,"setChatUid",lua_FriendChatNode_FriendChatNode_setChatUid);
        tolua_function(tolua_S,"BeginVoice",lua_FriendChatNode_FriendChatNode_BeginVoice);
        tolua_function(tolua_S,"setisvoiceAutoplay",lua_FriendChatNode_FriendChatNode_setisvoiceAutoplay);
        tolua_function(tolua_S,"getFriendChatUid",lua_FriendChatNode_FriendChatNode_getFriendChatUid);
        tolua_function(tolua_S,"getHistoryIndex",lua_FriendChatNode_FriendChatNode_getHistoryIndex);
        tolua_function(tolua_S,"init",lua_FriendChatNode_FriendChatNode_init);
        tolua_function(tolua_S,"EndVoice",lua_FriendChatNode_FriendChatNode_EndVoice);
        tolua_function(tolua_S,"CancelVoice",lua_FriendChatNode_FriendChatNode_CancelVoice);
        tolua_function(tolua_S,"clickMoreButton",lua_FriendChatNode_FriendChatNode_clickMoreButton);
        tolua_function(tolua_S,"releaseVoiceList",lua_FriendChatNode_FriendChatNode_releaseVoiceList);
        tolua_function(tolua_S,"PlayVoice",lua_FriendChatNode_FriendChatNode_PlayVoice);
        tolua_function(tolua_S,"onExit",lua_FriendChatNode_FriendChatNode_onExit);
        tolua_function(tolua_S,"setFrindChat",lua_FriendChatNode_FriendChatNode_setFrindChat);
        tolua_function(tolua_S,"getBeforeMsg",lua_FriendChatNode_FriendChatNode_getBeforeMsg);
        tolua_function(tolua_S,"PlayVoiceEx",lua_FriendChatNode_FriendChatNode_PlayVoiceEx);
        tolua_function(tolua_S,"create", lua_FriendChatNode_FriendChatNode_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(FriendChatNode).name();
    g_luaType[typeName] = "FriendChatNode";
    g_typeCast["FriendChatNode"] = "FriendChatNode";
    return 1;
}
TOLUA_API int register_all_FriendChatNode(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_FriendChatNode_FriendChatNode(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

