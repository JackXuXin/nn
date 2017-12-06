#include "lua_HclcData_auto.hpp"
#include "HclcData.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_HclcData_HclcData_getListen(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_getListen'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_getListen'", nullptr);
            return 0;
        }
        YVListenFun* ret = cobj->getListen();
        object_to_luaval<YVListenFun>(tolua_S, "YVListenFun",(YVListenFun*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:getListen",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_getListen'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_callLuaFunction(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_callLuaFunction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        int arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunction"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunction"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "yvcc.HclcData:callLuaFunction");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunction'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunction(arg0, arg1, arg2);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:callLuaFunction",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_callLuaFunction'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_agreeFriend(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_agreeFriend'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "yvcc.HclcData:agreeFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_agreeFriend'", nullptr);
            return 0;
        }
        bool ret = cobj->agreeFriend(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:agreeFriend",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_agreeFriend'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_callLuaFunctionReq(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_callLuaFunctionReq'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 9) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        const char* arg3;
        const char* arg4;
        const char* arg5;
        const char* arg6;
        const char* arg7;
        const char* arg8;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg2 = arg2_tmp.c_str();

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg3 = arg3_tmp.c_str();

        std::string arg4_tmp; ok &= luaval_to_std_string(tolua_S, 6, &arg4_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg4 = arg4_tmp.c_str();

        std::string arg5_tmp; ok &= luaval_to_std_string(tolua_S, 7, &arg5_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg5 = arg5_tmp.c_str();

        std::string arg6_tmp; ok &= luaval_to_std_string(tolua_S, 8, &arg6_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg6 = arg6_tmp.c_str();

        std::string arg7_tmp; ok &= luaval_to_std_string(tolua_S, 9, &arg7_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg7 = arg7_tmp.c_str();

        std::string arg8_tmp; ok &= luaval_to_std_string(tolua_S, 10, &arg8_tmp, "yvcc.HclcData:callLuaFunctionReq"); arg8 = arg8_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionReq'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionReq(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:callLuaFunctionReq",argc, 9);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_callLuaFunctionReq'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_ModchannalId(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_ModchannalId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        bool arg0;
        int arg1;
        const char* arg2;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "yvcc.HclcData:ModchannalId");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "yvcc.HclcData:ModchannalId");

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "yvcc.HclcData:ModchannalId"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_ModchannalId'", nullptr);
            return 0;
        }
        cobj->ModchannalId(arg0, arg1, arg2);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:ModchannalId",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_ModchannalId'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_getLuaVarOneOfTable(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_getLuaVarOneOfTable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:getLuaVarOneOfTable"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:getLuaVarOneOfTable"); arg1 = arg1_tmp.c_str();

        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "yvcc.HclcData:getLuaVarOneOfTable"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_getLuaVarOneOfTable'", nullptr);
            return 0;
        }
        const char* ret = cobj->getLuaVarOneOfTable(arg0, arg1, arg2);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:getLuaVarOneOfTable",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_getLuaVarOneOfTable'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_callCppFunction(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_callCppFunction'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callCppFunction"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callCppFunction'", nullptr);
            return 0;
        }
        cobj->callCppFunction(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:callCppFunction",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_callCppFunction'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_InitSdk(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_InitSdk'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_InitSdk'", nullptr);
            return 0;
        }
        cobj->InitSdk();
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:InitSdk",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_InitSdk'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_opposeFriend(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_opposeFriend'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "yvcc.HclcData:opposeFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_opposeFriend'", nullptr);
            return 0;
        }
        bool ret = cobj->opposeFriend(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:opposeFriend",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_opposeFriend'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_setCurPlayID(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_setCurPlayID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:setCurPlayID");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_setCurPlayID'", nullptr);
            return 0;
        }
        cobj->setCurPlayID(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:setCurPlayID",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_setCurPlayID'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_getLuaVarTable(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_getLuaVarTable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:getLuaVarTable"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:getLuaVarTable"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_getLuaVarTable'", nullptr);
            return 0;
        }
        const char* ret = cobj->getLuaVarTable(arg0, arg1);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:getLuaVarTable",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_getLuaVarTable'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_modifyUserInfo(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.HclcData:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.HclcData:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.HclcData:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.HclcData:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
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

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_uint32(tolua_S, 6,&arg4, "yvcc.HclcData:modifyUserInfo");

        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "yvcc.HclcData:modifyUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_modifyUserInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->modifyUserInfo(arg0, arg1, arg2, arg3, arg4, arg5);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:modifyUserInfo",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_modifyUserInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_addFriend(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_addFriend'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "yvcc.HclcData:addFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_addFriend'", nullptr);
            return 0;
        }
        bool ret = cobj->addFriend(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:addFriend",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_addFriend'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_callLuaFunctionOne(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_callLuaFunctionOne'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        const char* arg0;
        const char* arg1;
        unsigned long long arg2;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionOne"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionOne"); arg1 = arg1_tmp.c_str();

        #pragma warning NO CONVERSION TO NATIVE FOR unsigned long long
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionOne'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionOne(arg0, arg1, arg2);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    if (argc == 4) 
    {
        const char* arg0;
        const char* arg1;
        unsigned long long arg2;
        bool arg3;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionOne"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionOne"); arg1 = arg1_tmp.c_str();

        #pragma warning NO CONVERSION TO NATIVE FOR unsigned long long
		ok = false;

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "yvcc.HclcData:callLuaFunctionOne");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionOne'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionOne(arg0, arg1, arg2, arg3);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:callLuaFunctionOne",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_callLuaFunctionOne'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_delFriend(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_delFriend'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "yvcc.HclcData:delFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_delFriend'", nullptr);
            return 0;
        }
        bool ret = cobj->delFriend(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:delFriend",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_delFriend'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_getLuaVarString(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_getLuaVarString'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        const char* arg0;
        const char* arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:getLuaVarString"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:getLuaVarString"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_getLuaVarString'", nullptr);
            return 0;
        }
        const char* ret = cobj->getLuaVarString(arg0, arg1);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:getLuaVarString",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_getLuaVarString'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_callLuaFunctionTwo(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_callLuaFunctionTwo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 6) 
    {
        const char* arg0;
        const char* arg1;
        unsigned int arg2;
        const char* arg3;
        const char* arg4;
        const char* arg5;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_uint32(tolua_S, 4,&arg2, "yvcc.HclcData:callLuaFunctionTwo");

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg3 = arg3_tmp.c_str();

        std::string arg4_tmp; ok &= luaval_to_std_string(tolua_S, 6, &arg4_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg4 = arg4_tmp.c_str();

        std::string arg5_tmp; ok &= luaval_to_std_string(tolua_S, 7, &arg5_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg5 = arg5_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionTwo'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionTwo(arg0, arg1, arg2, arg3, arg4, arg5);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    if (argc == 7) 
    {
        const char* arg0;
        const char* arg1;
        unsigned int arg2;
        const char* arg3;
        const char* arg4;
        const char* arg5;
        bool arg6;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_uint32(tolua_S, 4,&arg2, "yvcc.HclcData:callLuaFunctionTwo");

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg3 = arg3_tmp.c_str();

        std::string arg4_tmp; ok &= luaval_to_std_string(tolua_S, 6, &arg4_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg4 = arg4_tmp.c_str();

        std::string arg5_tmp; ok &= luaval_to_std_string(tolua_S, 7, &arg5_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg5 = arg5_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 8,&arg6, "yvcc.HclcData:callLuaFunctionTwo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionTwo'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionTwo(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    if (argc == 8) 
    {
        const char* arg0;
        const char* arg1;
        unsigned int arg2;
        const char* arg3;
        const char* arg4;
        const char* arg5;
        bool arg6;
        bool arg7;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_uint32(tolua_S, 4,&arg2, "yvcc.HclcData:callLuaFunctionTwo");

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg3 = arg3_tmp.c_str();

        std::string arg4_tmp; ok &= luaval_to_std_string(tolua_S, 6, &arg4_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg4 = arg4_tmp.c_str();

        std::string arg5_tmp; ok &= luaval_to_std_string(tolua_S, 7, &arg5_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg5 = arg5_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 8,&arg6, "yvcc.HclcData:callLuaFunctionTwo");

        ok &= luaval_to_boolean(tolua_S, 9,&arg7, "yvcc.HclcData:callLuaFunctionTwo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionTwo'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionTwo(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    if (argc == 9) 
    {
        const char* arg0;
        const char* arg1;
        unsigned int arg2;
        const char* arg3;
        const char* arg4;
        const char* arg5;
        bool arg6;
        bool arg7;
        bool arg8;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg0 = arg0_tmp.c_str();

        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg1 = arg1_tmp.c_str();

        ok &= luaval_to_uint32(tolua_S, 4,&arg2, "yvcc.HclcData:callLuaFunctionTwo");

        std::string arg3_tmp; ok &= luaval_to_std_string(tolua_S, 5, &arg3_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg3 = arg3_tmp.c_str();

        std::string arg4_tmp; ok &= luaval_to_std_string(tolua_S, 6, &arg4_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg4 = arg4_tmp.c_str();

        std::string arg5_tmp; ok &= luaval_to_std_string(tolua_S, 7, &arg5_tmp, "yvcc.HclcData:callLuaFunctionTwo"); arg5 = arg5_tmp.c_str();

        ok &= luaval_to_boolean(tolua_S, 8,&arg6, "yvcc.HclcData:callLuaFunctionTwo");

        ok &= luaval_to_boolean(tolua_S, 9,&arg7, "yvcc.HclcData:callLuaFunctionTwo");

        ok &= luaval_to_boolean(tolua_S, 10,&arg8, "yvcc.HclcData:callLuaFunctionTwo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_callLuaFunctionTwo'", nullptr);
            return 0;
        }
        const char* ret = cobj->callLuaFunctionTwo(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:callLuaFunctionTwo",argc, 6);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_callLuaFunctionTwo'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_isGetFriendInfo(lua_State* tolua_S)
{
    int argc = 0;
    YVSDK::HclcData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (YVSDK::HclcData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HclcData_HclcData_isGetFriendInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "yvcc.HclcData:isGetFriendInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_isGetFriendInfo'", nullptr);
            return 0;
        }
        bool ret = cobj->isGetFriendInfo(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "yvcc.HclcData:isGetFriendInfo",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_isGetFriendInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_HclcData_HclcData_sharedHD(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"yvcc.HclcData",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HclcData_HclcData_sharedHD'", nullptr);
            return 0;
        }
        YVSDK::HclcData* ret = YVSDK::HclcData::sharedHD();
        object_to_luaval<YVSDK::HclcData>(tolua_S, "yvcc.HclcData",(YVSDK::HclcData*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "yvcc.HclcData:sharedHD",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HclcData_HclcData_sharedHD'.",&tolua_err);
#endif
    return 0;
}
static int lua_HclcData_HclcData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (HclcData)");
    return 0;
}

int lua_register_HclcData_HclcData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"yvcc.HclcData");
    tolua_cclass(tolua_S,"HclcData","yvcc.HclcData","",nullptr);

    tolua_beginmodule(tolua_S,"HclcData");
        tolua_function(tolua_S,"getListen",lua_HclcData_HclcData_getListen);
        tolua_function(tolua_S,"callLuaFunction",lua_HclcData_HclcData_callLuaFunction);
        tolua_function(tolua_S,"agreeFriend",lua_HclcData_HclcData_agreeFriend);
        tolua_function(tolua_S,"callLuaFunctionReq",lua_HclcData_HclcData_callLuaFunctionReq);
        tolua_function(tolua_S,"ModchannalId",lua_HclcData_HclcData_ModchannalId);
        tolua_function(tolua_S,"getLuaVarOneOfTable",lua_HclcData_HclcData_getLuaVarOneOfTable);
        tolua_function(tolua_S,"callCppFunction",lua_HclcData_HclcData_callCppFunction);
        tolua_function(tolua_S,"InitSdk",lua_HclcData_HclcData_InitSdk);
        tolua_function(tolua_S,"opposeFriend",lua_HclcData_HclcData_opposeFriend);
        tolua_function(tolua_S,"setCurPlayID",lua_HclcData_HclcData_setCurPlayID);
        tolua_function(tolua_S,"getLuaVarTable",lua_HclcData_HclcData_getLuaVarTable);
        tolua_function(tolua_S,"modifyUserInfo",lua_HclcData_HclcData_modifyUserInfo);
        tolua_function(tolua_S,"addFriend",lua_HclcData_HclcData_addFriend);
        tolua_function(tolua_S,"callLuaFunctionOne",lua_HclcData_HclcData_callLuaFunctionOne);
        tolua_function(tolua_S,"delFriend",lua_HclcData_HclcData_delFriend);
        tolua_function(tolua_S,"getLuaVarString",lua_HclcData_HclcData_getLuaVarString);
        tolua_function(tolua_S,"callLuaFunctionTwo",lua_HclcData_HclcData_callLuaFunctionTwo);
        tolua_function(tolua_S,"isGetFriendInfo",lua_HclcData_HclcData_isGetFriendInfo);
        tolua_function(tolua_S,"sharedHD", lua_HclcData_HclcData_sharedHD);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(YVSDK::HclcData).name();
    g_luaType[typeName] = "yvcc.HclcData";
    g_typeCast["HclcData"] = "yvcc.HclcData";
    return 1;
}
TOLUA_API int register_all_HclcData(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_HclcData_HclcData(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

