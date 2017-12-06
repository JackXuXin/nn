#include "lua_SearchListNode_auto.hpp"
#include "SearchListNode.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_SearchListNode_SearchListNode_init(lua_State* tolua_S)
{
    int argc = 0;
    SearchListNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SearchListNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SearchListNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_SearchListNode_SearchListNode_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_SearchListNode_SearchListNode_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SearchListNode:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_SearchListNode_SearchListNode_init'.",&tolua_err);
#endif

    return 0;
}
int lua_SearchListNode_SearchListNode_searchFriendByNick(lua_State* tolua_S)
{
    int argc = 0;
    SearchListNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SearchListNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SearchListNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_SearchListNode_SearchListNode_searchFriendByNick'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "SearchListNode:searchFriendByNick");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_SearchListNode_SearchListNode_searchFriendByNick'", nullptr);
            return 0;
        }
        cobj->searchFriendByNick(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SearchListNode:searchFriendByNick",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_SearchListNode_SearchListNode_searchFriendByNick'.",&tolua_err);
#endif

    return 0;
}
int lua_SearchListNode_SearchListNode_onSearchFriendRetListern(lua_State* tolua_S)
{
    int argc = 0;
    SearchListNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SearchListNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SearchListNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_SearchListNode_SearchListNode_onSearchFriendRetListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::SearchFriendRespond* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR SearchFriendRespond*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_SearchListNode_SearchListNode_onSearchFriendRetListern'", nullptr);
            return 0;
        }
        cobj->onSearchFriendRetListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SearchListNode:onSearchFriendRetListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_SearchListNode_SearchListNode_onSearchFriendRetListern'.",&tolua_err);
#endif

    return 0;
}
int lua_SearchListNode_SearchListNode_onRecommendFriendRetListern(lua_State* tolua_S)
{
    int argc = 0;
    SearchListNode* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"SearchListNode",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (SearchListNode*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_SearchListNode_SearchListNode_onRecommendFriendRetListern'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        YVSDK::RecommendFriendRespond* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR RecommendFriendRespond*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_SearchListNode_SearchListNode_onRecommendFriendRetListern'", nullptr);
            return 0;
        }
        cobj->onRecommendFriendRetListern(arg0);
        return 0;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "SearchListNode:onRecommendFriendRetListern",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_SearchListNode_SearchListNode_onRecommendFriendRetListern'.",&tolua_err);
#endif

    return 0;
}
int lua_SearchListNode_SearchListNode_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"SearchListNode",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_SearchListNode_SearchListNode_create'", nullptr);
            return 0;
        }
        SearchListNode* ret = SearchListNode::create();
        object_to_luaval<SearchListNode>(tolua_S, "SearchListNode",(SearchListNode*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "SearchListNode:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_SearchListNode_SearchListNode_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_SearchListNode_SearchListNode_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (SearchListNode)");
    return 0;
}

int lua_register_SearchListNode_SearchListNode(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"SearchListNode");
    tolua_cclass(tolua_S,"SearchListNode","SearchListNode","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"SearchListNode");
        tolua_function(tolua_S,"init",lua_SearchListNode_SearchListNode_init);
        tolua_function(tolua_S,"searchFriendByNick",lua_SearchListNode_SearchListNode_searchFriendByNick);
        tolua_function(tolua_S,"onSearchFriendRetListern",lua_SearchListNode_SearchListNode_onSearchFriendRetListern);
        tolua_function(tolua_S,"onRecommendFriendRetListern",lua_SearchListNode_SearchListNode_onRecommendFriendRetListern);
        tolua_function(tolua_S,"create", lua_SearchListNode_SearchListNode_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(SearchListNode).name();
    g_luaType[typeName] = "SearchListNode";
    g_typeCast["SearchListNode"] = "SearchListNode";
    return 1;
}
TOLUA_API int register_all_SearchListNode(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"yvcc",0);
	tolua_beginmodule(tolua_S,"yvcc");

	lua_register_SearchListNode_SearchListNode(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

