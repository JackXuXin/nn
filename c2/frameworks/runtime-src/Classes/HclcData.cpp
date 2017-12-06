//
//  HclcData.cpp
//  CppLua
//
//  Created by Himi on 13-4-17.
//
//

#include "HclcData.h"
#include "CCLuaEngine.h"

bool HclcData::_isFirst;
bool HclcData::isHasOpen;
bool HclcData::isOpen2;
bool HclcData::isOpenLobby;
bool HclcData::isOpenUtil;
HclcData* HclcData::_shared;

HclcData* HclcData::sharedHD(){
    if(!_isFirst){
        _shared = new HclcData();
        _isFirst = true;
        isHasOpen = false;
        isOpen2 = false;
        isOpenLobby = false;
        isOpenUtil = false;
    }
    return _shared;
}


void HclcData::InitSdk()
{
    plistener = new YVListenFun();
    YVPlayerManager* platform = YVPlatform::getSingletonPtr();
    platform->addCPLoginListern(plistener);

}


const char* HclcData::getLuaVarString(const char* luaFileName,const char* varName){
    
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return NULL;
    }
    
    lua_settop(ls, 0);
    lua_getglobal(ls, varName);
    
    int statesCode = lua_isstring(ls, 1);
    if(statesCode!=1){
        CCLOG("Open Lua Error: %i", statesCode);
        return NULL;
    }
    
    const char* str = lua_tostring(ls, 1);
    lua_pop(ls, 1);
    
    return str;
}

const char* HclcData::getLuaVarOneOfTable(const char* luaFileName,const char* varName,const char* keyName){
    
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename(luaFileName);
    
    if(!isHasOpen)
    {
        int isOpen = luaL_dofile(ls, fullPath.c_str());
        if(isOpen!=0){
            CCLOG("Open Lua Error: %i", isOpen);
            //return NULL;
        }
        
        isHasOpen = true;
    }
    
    lua_getglobal(ls, varName);
    
    int statesCode = lua_istable(ls, -1);
    if(statesCode!=1){
        CCLOG("Open Lua Error: %i", statesCode);
        return NULL;
    }
    
    lua_pushstring(ls, keyName);
    lua_gettable(ls, -2);
    const char* valueString = lua_tostring(ls, -1);
    
    lua_pop(ls, -1);
    
    return valueString;
}

const char* HclcData::getLuaVarTable(const char* luaFileName,const char* varName){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return NULL;
    }
    
    lua_getglobal(ls, varName);
    
    int it = lua_gettop(ls);
    lua_pushnil(ls);
    
    string result="";
    
    while(lua_next(ls, it))
    {
        string key = lua_tostring(ls, -2);
        string value = lua_tostring(ls, -1);
        
        result=result+key+":"+value+"\t";
        
        lua_pop(ls, 1);
    }
    lua_pop(ls, 1);
    
    return result.c_str();
}

const char* HclcData::callLuaFunction(const char* luaFileName,const char* functionName,int num){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = -1;
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename(luaFileName);
    
    if(!isHasOpen)
    {
        isOpen = luaL_dofile(ls, fullPath.c_str());
        if (isOpen != 0)
        {
            CCLOG("Open Lua Error: %s", fullPath.c_str());
        }
        isHasOpen = true;
    }
    
    lua_getglobal(ls, functionName);
    
   // lua_pushstring(ls, "Himi");
    lua_pushnumber(ls, num);
   // lua_pushboolean(ls, true);
    
    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    
    int a = lua_pcall(ls, 1, 0, 0);
    CCLOG("Open lua_pcall: %i", a);
    
    const char* iResult = lua_tostring(ls, -1);
    
   // lua_close(ls);
    
    return iResult;
}

const char* HclcData::callLuaFunctionReq(const char* luaFileName,const char* functionName, const char* gameid, const char* roomid, const char* uid, const char* session, const char* tableid, const char* seatid, const char* password)
{
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = -1;
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename(luaFileName);
    
    std::string fullPath1 = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
    
    if(strcmp(fullPath.c_str(),fullPath1.c_str())==0)
    {
        if(!isOpenLobby)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpenLobby = true;
        }
    }
    
    lua_getglobal(ls, functionName);
    
    lua_pushstring(ls, gameid);
    lua_pushstring(ls, roomid);
    lua_pushstring(ls, uid);
    lua_pushstring(ls, session);
    lua_pushstring(ls, tableid);
    lua_pushstring(ls, seatid);
    lua_pushstring(ls, password);

    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    
    int a = lua_pcall(ls, 7, 1, 0);
    CCLOG("Req-Open lua_pcall: %i", a);
    
    const char* iResult = lua_tostring(ls, -1);
    
    return iResult;

}

const char* HclcData::callLuaFunctionTwo(const char* luaFileName,const char* functionName,uint32_t uid, const char* cpUid, const char* nickName, const char* iconImage, const bool isAgree, const bool isState, const bool isUpdate )
{
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = -1;
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename(luaFileName);

    std::string fullPath1 = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
   // std::string fullPath2 = utils->fullPathForFilename("src/app/Common/util.lua");
    
    if(strcmp(fullPath.c_str(),fullPath1.c_str())==0)
    {
        if(!isOpenLobby)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpenLobby = true;
        }
    }
    else
    {
        if(!isOpen2)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpen2 = true;
        }
        
    }


    lua_getglobal(ls, functionName);
    
    // lua_pushstring(ls, "Himi");
    lua_pushnumber(ls, uid);
    lua_pushstring(ls, cpUid);
    lua_pushstring(ls, nickName);
    lua_pushstring(ls, iconImage);
    lua_pushboolean(ls, isAgree);
    lua_pushboolean(ls, isState);
    lua_pushboolean(ls, isUpdate);
    
    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    
    int a = lua_pcall(ls, 7, 1, 0);
    CCLOG("Open lua_pcall: %i", a);
    
    const char* iResult = lua_tostring(ls, -1);
    
    // lua_close(ls);
    
    return iResult;

}

const char* HclcData::callLuaFunctionOne(const char* luaFileName,const char* functionName,uint64_t num, bool isExt){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = -1;
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename(luaFileName);
    
    std::string fullPath1 = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
    std::string fullPath2 = utils->fullPathForFilename("src/app/Common/util.lua");
    
    
    if(strcmp(fullPath.c_str(),fullPath1.c_str())==0)
    {
        if(!isOpenLobby)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpenLobby = true;
        }
    }
    else if(strcmp(fullPath.c_str(),fullPath2.c_str())==0)
    {
        if(!isOpenUtil)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpenUtil = true;
        }

    }
    
    lua_getglobal(ls, functionName);
    
    // lua_pushstring(ls, "Himi");
    lua_pushnumber(ls, num);
    lua_pushboolean(ls, isExt);
    
    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    
    int a = lua_pcall(ls, 2, 1, 0);
    CCLOG("Open lua_pcall: %i", a);
    
    const char* iResult = lua_tostring(ls, -1);
    
    // lua_close(ls);
    
    return iResult;
}

const char* HclcData::callLuaFunctionEx(const char* luaFileName,const char* functionName, YVSDK::YVMessagePtr msg, bool sendItemflag, bool friendflag, const char* nickName, int time, const char* gameID, const char* iconImage, bool ishasVoice, bool flag, const char* msgText){
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    int isOpen = -1;
    cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
    std::string fullPath = utils->fullPathForFilename(luaFileName);
    
    std::string fullPath1 = utils->fullPathForFilename("src/app/scenes/LobbyScene.lua");
    std::string fullPath2 = utils->fullPathForFilename("src/app/Common/util.lua");
    
    
    if(strcmp(fullPath.c_str(),fullPath1.c_str())==0)
    {
        if(!isOpenLobby)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpenLobby = true;
        }
    }
    else if(strcmp(fullPath.c_str(),fullPath2.c_str())==0)
    {
        if(!isOpenUtil)
        {
            isOpen = luaL_dofile(ls, fullPath.c_str());
            if (isOpen != 0)
            {
                CCLOG("Open Lua Error: %s", fullPath.c_str());
            }
            isOpenUtil = true;
        }
        
    }

//    
//    if(!isHasOpen)
//    {
//        isOpen = luaL_dofile(ls, fullPath.c_str());
//        if (isOpen != 0)
//        {
//            CCLOG("Open Lua Error: %s", fullPath.c_str());
//        }
//        isHasOpen = true;
//    }
    
    //#endif
    
    lua_getglobal(ls, functionName);
    
    lua_pushstring(ls, nickName);
    lua_pushboolean(ls, sendItemflag);
    lua_pushboolean(ls, friendflag);
    lua_pushnumber(ls, time);
    lua_pushstring(ls, gameID);
    lua_pushstring(ls, iconImage);
    lua_pushboolean(ls, ishasVoice);
    lua_pushboolean(ls, flag);
    lua_pushstring(ls, msgText);
    
    lua_pushnumber(ls, msg->id);
    lua_pushnumber(ls, msg->sendId);
    lua_pushnumber(ls, msg->recvId);
    lua_pushnumber(ls, (int)msg->type);
    lua_pushnumber(ls, (int)msg->state);
    lua_pushnumber(ls, msg->sendTime);
    lua_pushnumber(ls, msg->playState);
    
    CCLOG("msg:%s,%d,%d",nickName,sendItemflag,friendflag);
    CCLOG("msg:%llu,%d,%d,%d,%d,%d,%d",msg->id,msg->sendId,msg->recvId,msg->type,msg->state,msg->sendTime, msg->playState);
    // lua_pushboolean(ls, true);
    
    /*
     lua_call
     第一个参数:函数的参数个数
     第二个参数:函数返回值个数
     */
    
    int a = lua_pcall(ls, 16, 1, 0);
    CCLOG("Open lua_pcall: %i", a);
    
    const char* iResult = lua_tostring(ls, -1);
    
    CCLOG("iResult: %s", iResult);
    
    //lua_close(ls);
    
    return iResult;
}

void  HclcData::callCppFunction(const char* luaFileName){
    
    lua_State*  ls = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    
    /*
     Lua调用的C++的函数必须是静态的
     */
    lua_register(ls, "cppFunction", cppFunction);
    
    int isOpen = luaL_dofile(ls, getFileFullPath(luaFileName));
    if(isOpen!=0){
        CCLOG("Open Lua Error: %i", isOpen);
        return;
    }
}

int HclcData::cppFunction(lua_State* ls){
    int luaNum = (int)lua_tonumber(ls, 1);
    std::string str = lua_tostring(ls, 2);
    CCLOG("Lua调用cpp函数时传来的两个参数： %i  %s",luaNum,str.c_str());
    
    /*
     返给Lua的值
     */
    lua_pushnumber(ls, 321);
    lua_pushstring(ls, "Himi");
    
    /*
     返给Lua值个数
     */
    return 2;
}

bool HclcData::isGetFriendInfo(uint32 uid)
{
    bool isGet = false;
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    if (platform->getFriendInfo(uid) != NULL)
    {
        isGet = true;
    }

    return isGet;
}

bool HclcData::addFriend(uint32 uid)
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    bool b = platform->addFriend(uid);
    return b;
}

bool HclcData::agreeFriend(uint32 uid)
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    bool isSend = platform->agreeFriend(uid);

    return isSend;
}

bool HclcData::opposeFriend(uint32 uid)
{
     YVPlatform* platform = YVPlatform::getSingletonPtr();
    
     bool isSend = platform->opposeFriend(uid);
    
    return isSend;
    
}

bool HclcData::delFriend(uint32 uid)
{
     YVPlatform* platform = YVPlatform::getSingletonPtr();
    
     bool res = platform->delFriend(uid);
    
     return res;
}

void HclcData::ModchannalId(bool isadd, int nChId, const char* chanstr)
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    
    platform->ModchannalId(isadd, nChId, chanstr);
    
}

 bool HclcData::modifyUserInfo(std::string nickname, const std::string & iconUrl, const std::string & level, const std::string & vip, uint8 sex, const std::string & ext)
{
    YVPlatform* platform = YVPlatform::getSingletonPtr();
    
    return platform->modifyUserInfo(nickname);
}

void HclcData::setCurPlayID(std::string msgIDStr)
{
    
    std::stringstream strValue;
    
    strValue << msgIDStr;
    
    uint64_t  playID = 0;
    
    strValue >> playID;


    m_nCurPlayID = playID;
}

const char* HclcData::getFileFullPath(const char* fileName){
    return cocos2d::FileUtils::getInstance()->fullPathForFilename(fileName).c_str();
}

HclcData::~HclcData(){
    
    CC_SAFE_DELETE(_shared);
    _shared=NULL;
}
