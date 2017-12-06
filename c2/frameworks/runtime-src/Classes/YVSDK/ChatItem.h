#ifndef _CHATITEM_H_
#define _CHATITEM_H_
#include "cocos2d.h"

#include "../YVSDK/YVSDK.h"

class ChatItem
	:public cocos2d::Node,
	public YVSDK::YVListern::YVDownLoadFileListern,
	public YVSDK::YVListern::YVUpdateUserInfoListern,
	public YVSDK::YVListern::YVFinishPlayListern
{

public:
    ChatItem();
	virtual ~ChatItem();
	virtual bool init();
	//设置消息信息
	void setChatMessage(YVSDK::YVMessagePtr, bool flag, bool chatflag, bool isNew = false);
	//获取显示的消息内容 
	YVSDK::YVMessagePtr getChatMessage();

	//播放语音接口
	void playVoice();

	//是否显示菊花；
	void setWaitAnim(bool isShow);

	void delaytime(float ft);

	//显示自已语音识别
	void setChatMsg(YVSDK::YVMessagePtr);

	bool getautoplayvoid();
	void setautoplayvoid(bool autoplay);

	bool IsautoplayVoid();
	void MutUpdate(float dt);

	YVSDK::YVUInfoPtr getuserinfo();
    
    void PlayVoiceBegin( uint64_t playID );
    void PlayVoiceEnd( uint64_t playID );
    
    void SethasPlay(){ m_bIsHasPlay = true; };
    bool isHasPlay() { return m_bIsHasPlay; };
    
    bool isFriend() { return friendchatflag; };
	
//重新设置尺寸

	bool isGroupItem;

//声音是否处理下载状态
	bool isDownIng()
	{
		return  m_voicePath != NULL &&
			(m_voicePath->getState() == YVSDK::BothExistState ||
			m_voicePath->getState() == YVSDK::OnlyLocalState)
			? false : true;
	}
    bool isSendMessage(YVSDK::YVMessagePtr);

    uint64_t m_nPlayID;
    YVSDK::YVMessagePtr m_msg;
    std::string m_extNickStr;

protected:
	//void setUserInfo(YVSDK::YVUInfoPtr);

	void onDownLoadFileListern(YVSDK::YVFilePathPtr);
	void onUpdateUserInfoListern(YVSDK::YVUInfoPtr);
	void onFinishPlayListern(YVSDK::StartPlayVoiceRespond*);
	//初使化消息头信息
	void initMessageHeader(YVSDK::YVMessagePtr);


	//初使化发送类消息内容
	void initMessageContent(YVSDK::YVMessagePtr, bool flag);
	void initTextMessage(std::string&); //YVSDK::YVTextMessagePtr
	void initVoiceMessage(YVSDK::YVVoiceMessagePtr,bool flag);
	void initPicMessage(YVSDK::YVImageMessagePtr);

	bool m_isSendItem;
	bool friendchatflag;
	cocos2d::Node* m_rootNode;
	YVSDK::YVFilePathPtr m_voicePath;
	std::string m_voiceText;
    
	int downloadNum;

	YVSDK::YVFilePathPtr m_headIocnPath;

	YVSDK::YVUInfoPtr userinfo;
	YVSDK::YVVoiceMessagePtr m_Message;

	bool m_isShowWaitAnim;
	bool m_isVoiceMssage;
	bool m_Playover;
	bool isplaying;
    
    bool m_bIsHasPlay;
	
};
#endif
