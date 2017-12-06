#include "lua_YVListenFun_auto.hpp"
#include "YVListenFun.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_YVListenFun_YVListenFun_onCPLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_onCPLoginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::CPLoginResponce* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR CPLoginResponce*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_onCPLoginListern'", nullptr);
            return 0;
        }
        cobj->onCPLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:onCPLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_onCPLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVListenFun_YVListenFun_getChannalNode(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_getChannalNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_getChannalNode'", nullptr);
            return 0;
        }
        ChannalChatNode* ret = cobj->getChannalNode();
        object_to_luaval<ChannalChatNode>(tolua_S, "ChannalChatNode",(ChannalChatNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:getChannalNode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_getChannalNode'.",&tolua_err);
#endif

    return 0;
}
int lua_YVListenFun_YVListenFun_getFriendListNode(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_getFriendListNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_getFriendListNode'", nullptr);
            return 0;
        }
        FriendListNode* ret = cobj->getFriendListNode();
        object_to_luaval<FriendListNode>(tolua_S, "FriendListNode",(FriendListNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:getFriendListNode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_getFriendListNode'.",&tolua_err);
#endif

    return 0;
}
int lua_YVListenFun_YVListenFun_getFriendChatNode(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_getFriendChatNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "YVListenFun:getFriendChatNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_getFriendChatNode'", nullptr);
            return 0;
        }
        FriendChatNode* ret = cobj->getFriendChatNode(arg0);
        object_to_luaval<FriendChatNode>(tolua_S, "FriendChatNode",(FriendChatNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:getFriendChatNode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_getFriendChatNode'.",&tolua_err);
#endif

    return 0;
}
int lua_YVListenFun_YVListenFun_openFriendChat(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_openFriendChat'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "YVListenFun:openFriendChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_openFriendChat'", nullptr);
            return 0;
        }
        cobj->openFriendChat(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:openFriendChat",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_openFriendChat'.",&tolua_err);
#endif

    return 0;
}
int lua_YVListenFun_YVListenFun_releaseAllNode(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_releaseAllNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_releaseAllNode'", nullptr);
            return 0;
        }
        cobj->releaseAllNode();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:releaseAllNode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_releaseAllNode'.",&tolua_err);
#endif

    return 0;
}
int lua_YVListenFun_YVListenFun_getSearchListNode(lua_State* tolua_S)
{
    int argc = 0;
    YVListenFun* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"YVListenFun",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVListenFun*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVListenFun_YVListenFun_getSearchListNode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVListenFun_YVListenFun_getSearchListNode'", nullptr);
            return 0;
        }
        SearchListNode* ret = cobj->getSearchListNode();
        object_to_luaval<SearchListNode>(tolua_S, "SearchListNode",(SearchListNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "YVListenFun:getSearchListNode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVListenFun_YVListenFun_getSearchListNode'.",&tolua_err);
#endif

    return 0;
}
static int lua_YVListenFun_YVListenFun_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (YVListenFun)");
    return 0;
}

int lua_register_YVListenFun_YVListenFun(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"YVListenFun");
    tolua_cclass(tolua_S,"YVListenFun","YVListenFun","yvcc.YVListern::YVCPLoginListern",nullptr);

    tolua_beginmodule(tolua_S,"YVListenFun");
        tolua_function(tolua_S,"onCPLoginListern",lua_YVListenFun_YVListenFun_onCPLoginListern);
        tolua_function(tolua_S,"getChannalNode",lua_YVListenFun_YVListenFun_getChannalNode);
        tolua_function(tolua_S,"getFriendListNode",lua_YVListenFun_YVListenFun_getFriendListNode);
        tolua_function(tolua_S,"getFriendChatNode",lua_YVListenFun_YVListenFun_getFriendChatNode);
        tolua_function(tolua_S,"openFriendChat",lua_YVListenFun_YVListenFun_openFriendChat);
        tolua_function(tolua_S,"releaseAllNode",lua_YVListenFun_YVListenFun_releaseAllNode);
        tolua_function(tolua_S,"getSearchListNode",lua_YVListenFun_YVListenFun_getSearchListNode);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(YVListenFun).name();
    g_luaType[typeName] = "YVListenFun";
    g_typeCast["YVListenFun"] = "YVListenFun";
    return 1;
}
TOLUA_API int register_all_YVListenFun(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_YVListenFun_YVListenFun(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

