#ifndef _YVSDK_YVPLATFORM_H_
#define _YVSDK_YVPLATFORM_H_
#include "YVManager/YVManager.h"

#define  _YVSDK_USE_LBS_   //开启LBS定位功能,如果不需要此功能，可以注释此处
#define  _YVSDK_USE_GROUP_ //开启群功能,如果不需要此功能，可以注释此处

namespace YVSDK
{ 
	class YVMsgDispatcher;
	
	class YVPlatform
		:public YVUInfoManager,
		public YVFileManager,
		public YVConfigManager,
		public YVPlayerManager,
		public YVContactManager,
		public YVChannalChatManager,
		public YVToolManager,
		public YVFriendChatManager,
		public YVLbsManager,
		public YVGroupUserManager
	{
	public:
		static YVPlatform* getSingletonPtr();
		~YVPlatform();
		bool init();
		bool destory();
        
        bool modifyUserInfo(std::string nickname, const std::string & iconUrl = "", const std::string & level = "", const std::string & vip="", uint8 sex = 0, const std::string & ext = "");
      
        static YVPlayerManager* getPlayerManager();
        
        int getChannelId(std::string &channestr){ return getChannelIdByKey(channestr); };

		//请使用定时器调用它，建议每帧调用一次
		void updateSdk(float dt);
		//获取事件派发器
		YVMsgDispatcher* getMsgDispatcher();
	private:
		YVPlatform();

		YVMsgDispatcher* m_msgDispatcher;
		static YVPlatform* s_YVPlatformPtr;
		bool _isInit;
        
	};
}
#endif
