#ifndef __CHANANALCHATNODE_H_
#define __CHANANALCHATNODE_H_
#include <string>
#include "YVChatNode.h"
#include "YVSDK.h"

class ChannalChatNode
	:public YVChatNode,
	public YVSDK::YVListern::YVChannelChatListern,
	public YVSDK::YVListern::YVChannelHistoryChatListern,
	public YVSDK::YVListern::YVChannelChatStateListern,
	public YVSDK::YVListern::YVModChannelIdListern,
	public YVSDK::YVListern::YVChannalloginListern,
	public YVSDK::YVListern::YVRecordVoiceListern
{
public:
	void setParent(cocos2d::Node* parent);
	void removeFromParent();
    

	void onChannelChatListern(YVSDK::YVMessagePtr);
    void onChannelHistoryChatListern(YVSDK::YVMessageListPtr);
	void onChannelChatStateListern(YVSDK::YVMessagePtr);
	void onModChannelIdListern(YVSDK::ModChannelIdRespond*);
	void onChannalloginListern(YVSDK::ChanngelLonginRespond*);

	void onRecordVoiceListern(YVSDK::RecordVoiceNotify*);
    
    void PlayVoice(uint64_t msgID, bool isBegin);
    void PlayVoiceEx(std::string msgIDStr, bool isBegin);

//	void onHttpRequestCompleted(HttpClient *sender, HttpResponse *response);
	~ChannalChatNode();
	virtual bool init();
	virtual void onEnter();
	virtual void onExit();
	CREATE_FUNC(ChannalChatNode);
	virtual void sendText();
	//录音发送
	virtual void sendVoice(YVSDK::YVFilePathPtr voicePath, float voiceTime);
    
    void BeginVoice( void ){ YVChatNode::BeginVoice(); };
    
    void EndVoice( std::string extStr ){ YVChatNode::EndVoice(extStr); };
    
    void CancelVoice( void ){ YVChatNode::CancelVoice(); };

    void setFrindChat(bool isFriend){ YVChatNode::setFrindChat(isFriend); };
    
    void setisvoiceAutoplay(bool flag){ YVChatNode::setisvoiceAutoplay(flag); };
    
    void releaseVoiceList(){ YVChatNode::releaseVoiceList(); };
    
    void SetCurChannalIndex(int nIndex){ m_curChannalIndex = nIndex; };
    void SetCurChannalStr(std::string str ){ m_curChannalStr = str; };
    std::string GetCurChannalStr(){ return m_curChannalStr; };
	
	//显示接收过来的数据 
	//void  showRecvMessage(YVSDK::YVMessagePtr);
	void getChannalHistoryD();
	void getChannalHistory(float dt);
    
    int m_curChannalIndex;
    std::string m_curChannalStr;

};
    
#endif
