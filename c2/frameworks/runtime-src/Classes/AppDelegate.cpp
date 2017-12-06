#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "lua_module_register.h"


// extra lua module
#include "cocos2dx_extra.h"
#include "lua_extensions/lua_extensions_more.h"
#include "luabinding/lua_cocos2dx_extension_filter_auto.hpp"
#include "luabinding/lua_cocos2dx_extension_nanovg_auto.hpp"
#include "luabinding/lua_cocos2dx_extension_nanovg_manual.hpp"
#include "luabinding/cocos2dx_extra_luabinding.h"
#include "luabinding/HelperFunc_luabinding.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "luabinding/cocos2dx_extra_ios_iap_luabinding.h"
#endif
#define ANYSDK_DEFINE 0
#if ANYSDK_DEFINE > 0
#include "anysdkbindings.h"
#include "anysdk_manual_bindings.h"
#endif

#include "YVPlatform.h"
#include "HclcData.h"
#include "auto/lua_YVPlayerManager_auto.hpp"
#include "auto/lua_YVPlatform_auto.hpp"
#include "auto/lua_ChannalChatNode_auto.hpp"
#include "auto/lua_FriendChatNode_auto.hpp"
#include "auto/lua_SearchListNode_auto.hpp"
#include "auto/lua_YVChatNode_auto.hpp"
#include "auto/lua_YVListenFun_auto.hpp"
#include "auto/lua_HclcData_auto.hpp"

// 导入头文件 CrashReport.h
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "bugly/CrashReport.h"
#include "bugly/lua/BuglyLuaAgent.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CrashReport.h"
#include "BuglyLuaAgent.h"
#endif


using namespace CocosDenshion;

USING_NS_CC;
using namespace std;
using namespace  YVSDK;


//=========================云娃SDK事件Dispatch类==================================
class DispatchMsgNode : public cocos2d::Node
{
public:
    bool init()
    {
        isschedule = false;
        return  Node::init();
    }
    CREATE_FUNC(DispatchMsgNode);
    void startDispatch()
    {
        if (isschedule) return;
        isschedule = true;
        cocos2d::Director::getInstance()->getScheduler()->schedule(schedule_selector(DispatchMsgNode::update), this, 0, false);
    }
    void stopDispatch()
    {
        if (!isschedule) return;
        isschedule = false;
        cocos2d::Director::getInstance()->getScheduler()->unschedule(schedule_selector(DispatchMsgNode::update), this);
    }
    void update(float dt)
    {
        YVSDK::YVPlatform::getSingletonPtr()->updateSdk(dt);
    }
private:
    bool isschedule;
    
};


static void quick_module_register(lua_State *L)
{
    luaopen_lua_extensions_more(L);

    lua_getglobal(L, "_G");
    if (lua_istable(L, -1))//stack:...,_G,
    {
        register_all_quick_manual(L);
        // extra
        luaopen_cocos2dx_extra_luabinding(L);
        register_all_cocos2dx_extension_filter(L);
        register_all_cocos2dx_extension_nanovg(L);
        register_all_cocos2dx_extension_nanovg_manual(L);
        luaopen_HelperFunc_luabinding(L);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        luaopen_cocos2dx_extra_ios_iap_luabinding(L);
#endif
    }
    lua_pop(L, 1);
}

//
AppDelegate::AppDelegate()
{
    m_dispathMsgNode = NULL;
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
    
    
// add by whb 1219
    
    if (m_dispathMsgNode != NULL)
    {
        m_dispathMsgNode->stopDispatch();
        m_dispathMsgNode->release();
        m_dispathMsgNode = NULL;
    }
    
// add end
    
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = { 8, 8, 8, 8, 24, 8 };

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
    
    // Init the Bugly
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CrashReport::initCrashReport("967828f1f8", false);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CrashReport::initCrashReport("c51e083bdc", false);
#endif
    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();    
    if(!glview) {
        string title = "zdclient";
        glview = cocos2d::GLViewImpl::create(title.c_str());
        director->setOpenGLView(glview);
        director->startAnimation();
    }
   
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
    
    //add by whb 0215
    
    register_all_YVPlayerManager(L);
    register_all_YVPlatform(L);
   // register_all_ChatItem(L);
    register_all_FriendChatNode(L);
    register_all_ChannalChatNode(L);
    register_all_SearchListNode(L);
    register_all_YVChatNode(L);
    register_all_YVListenFun(L);
    register_all_HclcData(L);
    //add end

    // use Quick-Cocos2d-X
    quick_module_register(L);

    LuaStack* stack = engine->getLuaStack();
#if ANYSDK_DEFINE > 0
    lua_getglobal(stack->getLuaState(), "_G");
    tolua_anysdk_open(stack->getLuaState());
    tolua_anysdk_manual_open(stack->getLuaState());
    lua_pop(stack->getLuaState(), 1);
#endif
    
// add by whb 1219
    
    HclcData::sharedHD()->InitSdk();

    if (m_dispathMsgNode == NULL)
    {
        YVPlatform* platform = YVPlatform::getSingletonPtr();
        cocos2d::FileUtils *utils = cocos2d::FileUtils::getInstance();
        std:string writePath =  utils->getWritablePath();

        platform->setConfig(ConfigAppid, 1001201); //基本配置
        platform->setConfig(ConfigTempPath,writePath.c_str());
        platform->setConfig(ConfigIsTest, false);
        //platform->setConfig(ConfigChannelKey, "0x001", NULL);
        platform->setConfig(ConfigServerId, "1");
        platform->setConfig(ConfigSpeechWhenSend, false);
        platform->init();
        
        m_dispathMsgNode = DispatchMsgNode::create();
        m_dispathMsgNode->retain();
        m_dispathMsgNode->startDispatch();
        
    }
    
    
    // register lua exception handler with lua engine
    BuglyLuaAgent::registerLuaExceptionHandler(engine);
// add end

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());
    
    //FileUtils::getInstance()->setResourceEncryptKeyAndSign("test", "XXTEA");
#if 1
    // use luajit bytecode package
    stack->setXXTEAKeyAndSign("RAWSTONE_JNGAME", "2016");
    
//#ifdef CC_TARGET_OS_IPHONE
//    if (sizeof(long) == 4) {
//        stack->loadChunksFromZIP("res/game.zip");
//    } else {
//        stack->loadChunksFromZIP("res/game64.zip");
//    }
//#else
//    // android, mac, win32, etc
//    stack->loadChunksFromZIP("res/game.zip");
//#endif
    stack->executeString("require 'src.main'");
#else // #if 0
    // use discrete files
    engine->executeScriptFile("src/main.lua");
#endif

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();
    Director::getInstance()->pause();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    SimpleAudioEngine::getInstance()->pauseAllEffects();

    Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->resume();
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    SimpleAudioEngine::getInstance()->resumeAllEffects();

    Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");
}
