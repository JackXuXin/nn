#include "lua_YVChatNode_auto.hpp"
#include "YVChatNode.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_YVChatNode_YVChatNode_setisvoiceAutoplay(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_setisvoiceAutoplay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "YVChatNode:setisvoiceAutoplay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_setisvoiceAutoplay'", nullptr);
            return 0;
        }
        cobj->setisvoiceAutoplay(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:setisvoiceAutoplay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_setisvoiceAutoplay'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_setFrindChat(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_setFrindChat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "YVChatNode:setFrindChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_setFrindChat'", nullptr);
            return 0;
        }
        cobj->setFrindChat(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:setFrindChat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_setFrindChat'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_removeFromParent(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_removeFromParent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_removeFromParent'", nullptr);
            return 0;
        }
        cobj->removeFromParent();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:removeFromParent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_removeFromParent'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_setParent(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_setParent'", nullptr);
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
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_setParent'", nullptr);
            return 0;
        }
        cobj->setParent(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:setParent",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_setParent'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_onStopRecordListern(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_onStopRecordListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::RecordStopNotify* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR RecordStopNotify*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_onStopRecordListern'", nullptr);
            return 0;
        }
        cobj->onStopRecordListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:onStopRecordListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_onStopRecordListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_releaseVoiceList(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_releaseVoiceList'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_releaseVoiceList'", nullptr);
            return 0;
        }
        cobj->releaseVoiceList();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:releaseVoiceList",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_releaseVoiceList'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_autoPlayeVoice(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_autoPlayeVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "YVChatNode:autoPlayeVoice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_autoPlayeVoice'", nullptr);
            return 0;
        }
        cobj->autoPlayeVoice(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:autoPlayeVoice",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_autoPlayeVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_init(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_init'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_addContextItem(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_addContextItem'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        ChatItem* arg0;

        ok &= luaval_to_object<ChatItem>(tolua_S, 2, "ChatItem",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_addContextItem'", nullptr);
            return 0;
        }
        cobj->addContextItem(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:addContextItem",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_addContextItem'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_getItemByMsg(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_getItemByMsg'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned long long arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR unsigned long long
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_getItemByMsg'", nullptr);
            return 0;
        }
        ChatItem* ret = cobj->getItemByMsg(arg0);
        object_to_luaval<ChatItem>(tolua_S, "ChatItem",(ChatItem*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:getItemByMsg",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_getItemByMsg'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_BeginVoice(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_BeginVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_BeginVoice'", nullptr);
            return 0;
        }
        cobj->BeginVoice();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:BeginVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_BeginVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_recordingTimeUpdate(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_recordingTimeUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "YVChatNode:recordingTimeUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_recordingTimeUpdate'", nullptr);
            return 0;
        }
        cobj->recordingTimeUpdate(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:recordingTimeUpdate",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_recordingTimeUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_EndVoice(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_EndVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "YVChatNode:EndVoice");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_EndVoice'", nullptr);
            return 0;
        }
        cobj->EndVoice(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:EndVoice",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_EndVoice'.",&tolua_err);
#endif

    return 0;
}
int lua_YVChatNode_YVChatNode_CancelVoice(lua_State* tolua_S)
{
    int argc = 0;
    YVChatNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVChatNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVChatNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVChatNode_YVChatNode_CancelVoice'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVChatNode_YVChatNode_CancelVoice'", nullptr);
            return 0;
        }
        cobj->CancelVoice();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVChatNode:CancelVoice",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVChatNode_YVChatNode_CancelVoice'.",&tolua_err);
#endif

    return 0;
}
static int lua_YVChatNode_YVChatNode_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (YVChatNode)");
    return 0;
}

int lua_register_YVChatNode_YVChatNode(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"YVChatNode");
    tolua_cclass(tolua_S,"YVChatNode","YVChatNode","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"YVChatNode");
        tolua_function(tolua_S,"setisvoiceAutoplay",lua_YVChatNode_YVChatNode_setisvoiceAutoplay);
        tolua_function(tolua_S,"setFrindChat",lua_YVChatNode_YVChatNode_setFrindChat);
        tolua_function(tolua_S,"removeFromParent",lua_YVChatNode_YVChatNode_removeFromParent);
        tolua_function(tolua_S,"setParent",lua_YVChatNode_YVChatNode_setParent);
        tolua_function(tolua_S,"onStopRecordListern",lua_YVChatNode_YVChatNode_onStopRecordListern);
        tolua_function(tolua_S,"releaseVoiceList",lua_YVChatNode_YVChatNode_releaseVoiceList);
        tolua_function(tolua_S,"autoPlayeVoice",lua_YVChatNode_YVChatNode_autoPlayeVoice);
        tolua_function(tolua_S,"init",lua_YVChatNode_YVChatNode_init);
        tolua_function(tolua_S,"addContextItem",lua_YVChatNode_YVChatNode_addContextItem);
        tolua_function(tolua_S,"getItemByMsg",lua_YVChatNode_YVChatNode_getItemByMsg);
        tolua_function(tolua_S,"BeginVoice",lua_YVChatNode_YVChatNode_BeginVoice);
        tolua_function(tolua_S,"recordingTimeUpdate",lua_YVChatNode_YVChatNode_recordingTimeUpdate);
        tolua_function(tolua_S,"EndVoice",lua_YVChatNode_YVChatNode_EndVoice);
        tolua_function(tolua_S,"CancelVoice",lua_YVChatNode_YVChatNode_CancelVoice);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(YVChatNode).name();
    g_luaType[typeName] = "YVChatNode";
    g_typeCast["YVChatNode"] = "YVChatNode";
    return 1;
}
TOLUA_API int register_all_YVChatNode(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_YVChatNode_YVChatNode(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

