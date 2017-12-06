#include "lua_YVPlayerManager_auto.hpp"
#include "YVPlayerManager.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_YVPlayerManager_YVPlayerManager_addYYLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_addYYLoginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YVListern::YVYYLoginListern* arg0;

        ok &= luaval_to_object<YVSDK::YVListern::YVYYLoginListern>(tolua_S, 2, "yvcc.YVListern::YVYYLoginListern",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_addYYLoginListern'", nullptr);
            return 0;
        }
        cobj->addYYLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:addYYLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_addYYLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfo(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        unsigned int arg0;
        std::string arg1;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:GetCpuUserinfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:GetCpuUserinfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfo'", nullptr);
            return 0;
        }
        bool ret = cobj->GetCpuUserinfo(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:GetCpuUserinfo",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfo'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_yyLogin(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_yyLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        std::string arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "yvcc.YVPlayerManager:yyLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:yyLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_yyLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->yyLogin(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:yyLogin",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_yyLogin'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_destory(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_destory'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_destory'", nullptr);
            return 0;
        }
        bool ret = cobj->destory();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:destory",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_destory'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_modifyNickName(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:modifyNickName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
            return 0;
        }
        cobj->modifyNickName(arg0);
        return 0;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:modifyNickName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
            return 0;
        }
        cobj->modifyNickName(arg0, arg1);
        return 0;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:modifyNickName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
            return 0;
        }
        cobj->modifyNickName(arg0, arg1, arg2);
        return 0;
    }
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:modifyNickName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
            return 0;
        }
        cobj->modifyNickName(arg0, arg1, arg2, arg3);
        return 0;
    }
    if (argc == 5) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        unsigned int arg4;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlayerManager:modifyNickName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
            return 0;
        }
        cobj->modifyNickName(arg0, arg1, arg2, arg3, arg4);
        return 0;
    }
    if (argc == 6) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        unsigned int arg4;
        std::string arg5;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlayerManager:modifyNickName");

        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "yvcc.YVPlayerManager:modifyNickName");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'", nullptr);
            return 0;
        }
        cobj->modifyNickName(arg0, arg1, arg2, arg3, arg4, arg5);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:modifyNickName",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_modifyNickName'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_cpLogout(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_cpLogout'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogout'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogout();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:cpLogout",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_cpLogout'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_delYYLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_delYYLoginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YVListern::YVYYLoginListern* arg0;

        ok &= luaval_to_object<YVSDK::YVListern::YVYYLoginListern>(tolua_S, 2, "yvcc.YVListern::YVYYLoginListern",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_delYYLoginListern'", nullptr);
            return 0;
        }
        cobj->delYYLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:delYYLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_delYYLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_init(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_init'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_callGetCpuUserListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_callGetCpuUserListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::GetCpmsgRepond* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR GetCpmsgRepond*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_callGetCpuUserListern'", nullptr);
            return 0;
        }
        cobj->callGetCpuUserListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:callGetCpuUserListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_callGetCpuUserListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfoResponce(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfoResponce'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YaYaRespondBase* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR YaYaRespondBase*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfoResponce'", nullptr);
            return 0;
        }
        cobj->GetCpuUserinfoResponce(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:GetCpuUserinfoResponce",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfoResponce'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_cpLoginResponce(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_cpLoginResponce'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YaYaRespondBase* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR YaYaRespondBase*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLoginResponce'", nullptr);
            return 0;
        }
        cobj->cpLoginResponce(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:cpLoginResponce",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_cpLoginResponce'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_callYYLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_callYYLoginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::LoginResponse* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR LoginResponse*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_callYYLoginListern'", nullptr);
            return 0;
        }
        cobj->callYYLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:callYYLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_callYYLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_delGetCpuUserListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_delGetCpuUserListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YVListern::YVGetCpuUserListern* arg0;

        ok &= luaval_to_object<YVSDK::YVListern::YVGetCpuUserListern>(tolua_S, 2, "yvcc.YVListern::YVGetCpuUserListern",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_delGetCpuUserListern'", nullptr);
            return 0;
        }
        cobj->delGetCpuUserListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:delGetCpuUserListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_delGetCpuUserListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_loginResponceCallback(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_loginResponceCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YaYaRespondBase* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR YaYaRespondBase*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_loginResponceCallback'", nullptr);
            return 0;
        }
        cobj->loginResponceCallback(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:loginResponceCallback",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_loginResponceCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_delCPLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_delCPLoginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YVListern::YVCPLoginListern* arg0;

        ok &= luaval_to_object<YVSDK::YVListern::YVCPLoginListern>(tolua_S, 2, "yvcc.YVListern::YVCPLoginListern",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_delCPLoginListern'", nullptr);
            return 0;
        }
        cobj->delCPLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:delCPLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_delCPLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_callCPLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_callCPLoginListern'", nullptr);
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
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_callCPLoginListern'", nullptr);
            return 0;
        }
        cobj->callCPLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:callCPLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_callCPLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_addCPLoginListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_addCPLoginListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YVListern::YVCPLoginListern* arg0;

        ok &= luaval_to_object<YVSDK::YVListern::YVCPLoginListern>(tolua_S, 2, "yvcc.YVListern::YVCPLoginListern",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_addCPLoginListern'", nullptr);
            return 0;
        }
        cobj->addCPLoginListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:addCPLoginListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_addCPLoginListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_addGetCpuUserListern(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_addGetCpuUserListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::YVListern::YVGetCpuUserListern* arg0;

        ok &= luaval_to_object<YVSDK::YVListern::YVGetCpuUserListern>(tolua_S, 2, "yvcc.YVListern::YVGetCpuUserListern",&arg0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_addGetCpuUserListern'", nullptr);
            return 0;
        }
        cobj->addGetCpuUserListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:addGetCpuUserListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_addGetCpuUserListern'.",&tolua_err);
#endif

    return 0;
}
int lua_YVPlayerManager_YVPlayerManager_cpLogin(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::YVPlayerManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.YVPlayerManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::YVPlayerManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 3) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0, arg1, arg2, arg3);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0, arg1, arg2, arg3, arg4);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0, arg1, arg2, arg3, arg4, arg5);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    if (argc == 7) 
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        unsigned int arg4;
        std::string arg5;
        std::string arg6;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "yvcc.YVPlayerManager:cpLogin");

        ok &= luaval_to_std_string(tolua_S, 8,&arg6, "yvcc.YVPlayerManager:cpLogin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'", nullptr);
            return 0;
        }
        bool ret = cobj->cpLogin(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.YVPlayerManager:cpLogin",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_YVPlayerManager_YVPlayerManager_cpLogin'.",&tolua_err);
#endif

    return 0;
}
static int lua_YVPlayerManager_YVPlayerManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (YVPlayerManager)");
    return 0;
}

int lua_register_YVPlayerManager_YVPlayerManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"yvcc.YVPlayerManager");
    tolua_cclass(tolua_S,"YVPlayerManager","yvcc.YVPlayerManager","",nullptr);

    tolua_beginmodule(tolua_S,"YVPlayerManager");
        tolua_function(tolua_S,"addYYLoginListern",lua_YVPlayerManager_YVPlayerManager_addYYLoginListern);
        tolua_function(tolua_S,"GetCpuUserinfo",lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfo);
        tolua_function(tolua_S,"yyLogin",lua_YVPlayerManager_YVPlayerManager_yyLogin);
        tolua_function(tolua_S,"destory",lua_YVPlayerManager_YVPlayerManager_destory);
        tolua_function(tolua_S,"modifyNickName",lua_YVPlayerManager_YVPlayerManager_modifyNickName);
        tolua_function(tolua_S,"cpLogout",lua_YVPlayerManager_YVPlayerManager_cpLogout);
        tolua_function(tolua_S,"delYYLoginListern",lua_YVPlayerManager_YVPlayerManager_delYYLoginListern);
        tolua_function(tolua_S,"init",lua_YVPlayerManager_YVPlayerManager_init);
        tolua_function(tolua_S,"callGetCpuUserListern",lua_YVPlayerManager_YVPlayerManager_callGetCpuUserListern);
        tolua_function(tolua_S,"GetCpuUserinfoResponce",lua_YVPlayerManager_YVPlayerManager_GetCpuUserinfoResponce);
        tolua_function(tolua_S,"cpLoginResponce",lua_YVPlayerManager_YVPlayerManager_cpLoginResponce);
        tolua_function(tolua_S,"callYYLoginListern",lua_YVPlayerManager_YVPlayerManager_callYYLoginListern);
        tolua_function(tolua_S,"delGetCpuUserListern",lua_YVPlayerManager_YVPlayerManager_delGetCpuUserListern);
        tolua_function(tolua_S,"loginResponceCallback",lua_YVPlayerManager_YVPlayerManager_loginResponceCallback);
        tolua_function(tolua_S,"delCPLoginListern",lua_YVPlayerManager_YVPlayerManager_delCPLoginListern);
        tolua_function(tolua_S,"callCPLoginListern",lua_YVPlayerManager_YVPlayerManager_callCPLoginListern);
        tolua_function(tolua_S,"addCPLoginListern",lua_YVPlayerManager_YVPlayerManager_addCPLoginListern);
        tolua_function(tolua_S,"addGetCpuUserListern",lua_YVPlayerManager_YVPlayerManager_addGetCpuUserListern);
        tolua_function(tolua_S,"cpLogin",lua_YVPlayerManager_YVPlayerManager_cpLogin);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(YVSDK::YVPlayerManager).name();
    g_luaType[typeName] = "yvcc.YVPlayerManager";
    g_typeCast["YVPlayerManager"] = "yvcc.YVPlayerManager";
    return 1;
}
TOLUA_API int register_all_YVPlayerManager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_YVPlayerManager_YVPlayerManager(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

