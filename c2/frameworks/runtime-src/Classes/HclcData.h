//
//  HclcData.h
//  CppLua
//
//  Created by Himi on 13-4-17.
//
//

#ifndef __CppLua__HclcData__
#define __CppLua__HclcData__

#include "cocos2d.h"
using namespace cocos2d;
using namespace std;
#include "YVSDK.h"
#include "YVListenFun.h"

extern "C" {
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
};

namespace YVSDK
{

class HclcData{
public:
    static HclcData* sharedHD();
    
    //------------  c++ -> lua ------------//
    
    /*
     getLuaVarString : 调用lua全局string
     
     luaFileName  = lua文件名
     varName = 所要取Lua中的变量名
     */
    const char* getLuaVarString(const char* luaFileName,const char* varName);
    
    /*
     getLuaVarOneOfTable : 调用lua全局table中的一个元素
     
     luaFileName  = lua文件名
     varName = 所要取Lua中的table变量名
     keyName = 所要取Lua中的table中某一个元素的Key
     */
    const char* getLuaVarOneOfTable(const char* luaFileName,const char* varName,const char* keyName);
    
    /*
     getLuaVarTable : 调用lua全局table
     
     luaFileName  = lua文件名
     varName = 所要取的table变量名
     
     （注：返回的是所有的数据，童鞋们可以自己使用Map等处理）
     */
    const char* getLuaVarTable(const char* luaFileName,const char* varName);
    
    /*
     callLuaFunction : 调用lua函数
     
     luaFileName  = lua文件名
     functionName = 所要调用Lua中的的函数名
     */
    const char* callLuaFunctionReq(const char* luaFileName,const char* functionName, const char* gameid, const char* roomid, const char* uid, const char* session, const char* tableid, const char* seatid, const char* password);
    const char* callLuaFunction(const char* luaFileName,const char* functionName,int num);
    const char* callLuaFunctionOne(const char* luaFileName,const char* functionName,uint64_t num, bool isExt = false);
    const char* callLuaFunctionTwo(const char* luaFileName,const char* functionName,uint32_t uid, const char* cpUid, const char* nickName, const char* iconImage, const bool isAgree = false, const bool isState = false, const bool isUpdate = false);
    
    const char* callLuaFunctionEx(const char* luaFileName,const char* functionName, YVSDK::YVMessagePtr msg, bool sendItemflag, bool friendflag, const char* nickName, int time, const char* gameID, const char* iconImage,bool ishasVoice, bool flag, const char* msgText);
    
    //------------  lua -> c++ ------------//
    
    void callCppFunction(const char* luaFileName);
    
    void InitSdk();
    
    void setCurPlayID(std::string msgIDStr);
    
    YVListenFun * getListen(){ return plistener; };
    
    bool isGetFriendInfo(uint32 uid);
    
    bool addFriend(uint32 uid);
    
    bool agreeFriend(uint32 uid);

    bool opposeFriend(uint32 uid);
    
    bool delFriend(uint32 uid);
    
    void ModchannalId(bool isadd, int nChId, const char* chanstr);
    
    bool modifyUserInfo(std::string nickname, const std::string & iconUrl = "", const std::string & level = "", const std::string & vip="", uint8 sex = 0, const std::string & ext = "");
    
    int loginYvSysCallback;
    int sendVoiceCallback;
    int findCallback;
    int addFriendCallback;
    uint64_t m_nCurPlayID;
    
private:
    static int cppFunction(lua_State* ls);
    
    static bool _isFirst;
    static bool isHasOpen;
    static bool isOpenLobby;
    static bool isOpenUtil;
    static bool isOpen2;
    static HclcData* _shared;
    const char* getFileFullPath(const char* fileName);
    ~HclcData();
    
    YVListenFun * plistener;

};
    
}

#endif /* defined(__CppLua__HclcData__) */
