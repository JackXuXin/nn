#include "lua_YVPlatform_auto.hpp"
#include "YVPlatform.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_YVPlatform_YVPlatform_destory(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlatform_YVPlatform_destory'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_destory'", nullptr);
            return 0;
        }
        bool ret = cobj->destory();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlatform:destory",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_destory'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlatform_YVPlatform_modifyUserInfo(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlatform:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlatform:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlatform:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0, arg1, arg2, arg3);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 5) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        unsigned int arg4;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlatform:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0, arg1, arg2, arg3, arg4);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 6) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        unsigned int arg4;
        std::string arg5;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlatform:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "yvcc.YVPlatform:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0, arg1, arg2, arg3, arg4, arg5);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlatform:modifyUserInfo",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_modifyUserInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlatform_YVPlatform_init(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlatform_YVPlatform_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlatform:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_init'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlatform_YVPlatform_updateSdk(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlatform_YVPlatform_updateSdk'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "yvcc.YVPlatform:updateSdk");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_updateSdk'", nullptr);
            return 0;
        }
        cobj->updateSdk(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlatform:updateSdk",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_updateSdk'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlatform_YVPlatform_getMsgDispatcher(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlatform_YVPlatform_getMsgDispatcher'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_getMsgDispatcher'", nullptr);
            return 0;
        }
        YVSDK::YVMsgDispatcher* ret = cobj->getMsgDispatcher();
        object_to_luaval<YVSDK::YVMsgDispatcher>(tolua_S, "yvcc.YVMsgDispatcher",(YVSDK::YVMsgDispatcher*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlatform:getMsgDispatcher",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_getMsgDispatcher'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlatform_YVPlatform_getChannelId(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlatform* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlatform*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlatform_YVPlatform_getChannelId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlatform:getChannelId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_getChannelId'", nullptr);
            return 0;
        }
        int ret = cobj->getChannelId(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlatform:getChannelId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_getChannelId'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlatform_YVPlatform_getPlayerManager(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_getPlayerManager'", nullptr);
            return 0;
        }
        YVSDK::YVPlayerManager* ret = YVSDK::YVPlatform::getPlayerManager();
        object_to_luaval<YVSDK::YVPlayerManager>(tolua_S, "yvcc.YVPlayerManager",(YVSDK::YVPlayerManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "yvcc.YVPlatform:getPlayerManager",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_getPlayerManager'.",&tolua_err);
#endif
    return 0;
}
int lua_YVPlatform_YVPlatform_getSingletonPtr(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"yvcc.YVPlatform",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlatform_YVPlatform_getSingletonPtr'", nullptr);
            return 0;
        }
        YVSDK::YVPlatform* ret = YVSDK::YVPlatform::getSingletonPtr();
        object_to_luaval<YVSDK::YVPlatform>(tolua_S, "yvcc.YVPlatform",(YVSDK::YVPlatform*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "yvcc.YVPlatform:getSingletonPtr",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlatform_YVPlatform_getSingletonPtr'.",&tolua_err);
#endif
    return 0;
}
static int lua_YVPlatform_YVPlatform_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (YVPlatform)");
    return 0;
}

int lua_register_YVPlatform_YVPlatform(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"yvcc.YVPlatform");
    tolua_cclass(tolua_S,"YVPlatform","yvcc.YVPlatform","yvcc.YVUInfoManager",nullptr);

    tolua_beginmodule(tolua_S,"YVPlatform");
        tolua_function(tolua_S,"destory",lua_YVPlatform_YVPlatform_destory);
        tolua_function(tolua_S,"modifyUserInfo",lua_YVPlatform_YVPlatform_modifyUserInfo);
        tolua_function(tolua_S,"init",lua_YVPlatform_YVPlatform_init);
        tolua_function(tolua_S,"updateSdk",lua_YVPlatform_YVPlatform_updateSdk);
        tolua_function(tolua_S,"getMsgDispatcher",lua_YVPlatform_YVPlatform_getMsgDispatcher);
        tolua_function(tolua_S,"getChannelId",lua_YVPlatform_YVPlatform_getChannelId);
        tolua_function(tolua_S,"getPlayerManager", lua_YVPlatform_YVPlatform_getPlayerManager);
        tolua_function(tolua_S,"getSingletonPtr", lua_YVPlatform_YVPlatform_getSingletonPtr);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(YVSDK::YVPlatform).name();
    g_luaType[typeName] = "yvcc.YVPlatform";
    g_typeCast["YVPlatform"] = "yvcc.YVPlatform";
    return 1;
}
TOLUA_API int register_all_YVPlatform(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_YVPlatform_YVPlatform(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

