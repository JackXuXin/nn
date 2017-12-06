#ifndef _YVSDK_YVPLAYERMANAGER_H_
#define _YVSDK_YVPLAYERMANAGER_H_
#include <string>
#include "YVListern/YVListern.h"
namespace YVSDK
{
	struct YaYaRespondBase;

	class YVPlayerManager
	{
	public:
		bool init();
		bool destory();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

		//注意性别sex 参数 0:无定义， 1：女， 2:男
		bool cpLogin(const std::string& uidStr, const std::string& nameStr = "", const std::string& level = "", const std::string& vip = ""
			, uint8 sex = 0, const std::string& iconUrl = "",const std::string& ext = "");

		bool yyLogin(int userId, const std::string& passWord);

		void loginResponceCallback(YaYaRespondBase*);
		void cpLoginResponce(YaYaRespondBase*);

		const YVUInfoPtr getLoginUserInfo();
		bool cpLogout();
		bool GetCpuUserinfo(uint32 appid, const std::string& uid);
		void modifyNickName(const std::string& nickname, const std::string& level = "", const std::string& vip = "", const std::string& headicon="",uint8 sex = 0, const std::string& ext = "");
		void GetCpuUserinfoResponce(YaYaRespondBase* respond);

		InitListern(CPLogin, CPLoginResponce*);
		InitListern(YYLogin, LoginResponse*);
		InitListern(GetCpuUser, GetCpmsgRepond*);
	private:
		//登录的那个用户的基本信息//
		YVUInfoPtr m_loginUserInfo;
	};
}
#endif
