#ifndef __FRIENDCHATCHATNODE_H_
#define __FRIENDCHATCHATNODE_H_
#include "YVChatNode.h"
#include "../YVSDK/YVSDK.h"

struct ChatMessageOwner;
class ChatMessageBase;
struct UserInfoRet;


class FriendChatNode
	:public YVChatNode,
	public YVSDK::YVListern::YVFriendChatListern,
	public YVSDK::YVListern::YVFriendHistoryChatListern,
	public YVSDK::YVListern::YVUpdateUserInfoListern,
	public YVSDK::YVListern::YVFriendChatStateListern
{
public:

	~FriendChatNode();
	virtual bool init();
	virtual void onExit();
	virtual void sendText(std::string &strMsg);
	virtual void sendPic(std::string &picPath);
	//录音发送
	virtual void sendVoice(YVSDK::YVFilePathPtr voicePath, float voiceTime);

	void clickMoreButton();
	CREATE_FUNC(FriendChatNode);
	void setChatUid(uint32 uid);

	void getBeforeMsg();
	long long getHistoryIndex();
    
    YVSDK::uint32 getFriendChatUid(){ return m_chatWithUid; };
    void PlayVoice(uint64_t msgID, bool isBegin);
    
    void PlayVoiceEx(std::string msgIDStr, bool isBegin);
    
    void InitTempChatData(uint32 uid);
    
    void BeginVoice( void ){ YVChatNode::BeginVoice(); };
    
    void EndVoice( std::string extStr ){ YVChatNode::EndVoice(extStr); };
    
    void CancelVoice( void ){ YVChatNode::CancelVoice(); };
    
    void setFrindChat(bool isFriend){ YVChatNode::setFrindChat(isFriend); };
    
    void setisvoiceAutoplay(bool flag){ YVChatNode::setisvoiceAutoplay(flag); };
    
    void releaseVoiceList(){ YVChatNode::releaseVoiceList(); };
    
	//监听的事件 
	void onFriendChatListern(YVSDK::YVMessagePtr) ;
	void onFriendHistoryChatListern(YVSDK::YVMessageListPtr);
	void onUpdateUserInfoListern(YVSDK::YVUInfoPtr);
	void onFriendChatStateListern(YVSDK::YVMessagePtr);
private:
	YVSDK::uint32 m_chatWithUid;
	YVSDK::YVUInfoPtr uinfo;
    YVSDK::uint32 indexTemp;
};
    

#endif
