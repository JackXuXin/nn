//
//  YVListenFun.h
//  client
//
//  Created by queyou on 16/12/19.
//
//

#ifndef YVChatNode_h
#define YVChatNode_h

#include <stdio.h>
#include "cocos2d.h"
#include "../YVSDK/YVSDK.h"
#include "ChatItem.h"

using namespace YVSDK;

class YVChatNode : public cocos2d::Node,
                    public YVListern::YVStopRecordListern
{
public:
    
    ~YVChatNode();
    virtual bool init();
    
    void onStopRecordListern(RecordStopNotify*);
    void recordingTimeUpdate(float dt);
    
    void setParent(cocos2d::Node* parent);
    void removeFromParent();

    virtual void sendVoice(YVSDK::YVFilePathPtr voicePath, float voiceTime){};
    
    //按钮松开触发消息发送
    void sendVoice(bool isSend);
    
    void BeginVoice( void );
    
    void EndVoice( std::string extStr );
    
    void CancelVoice( void );
    
   // void addContextItem(ChatItem* item, int index);
    void addContextItem(ChatItem* item);
    
public:
    
    bool isRecordVoice;
    
    ChatItem* getItemByMsgEx(YVSDK::YVMessagePtr);
    ChatItem* getItemByMsg(uint64_t msgID);
    
    void setisvoiceAutoplay(bool flag);
    
    void autoPlayeVoice(float dt);
    
    void releaseVoiceList();
    
    void setFrindChat(bool isFriend);

    
protected:
    
    float m_recordingTime;
    std::string m_recordingPath;
    bool m_isSendVoice;
    
    float m_chatViewH;
    
    bool isFriendChat;
    
    std::string m_extStr;
    
    //自动播放功能
    
    std::vector<ChatItem*> m_voiceList;
    std::vector<ChatItem*> m_tempVoiceList;
    bool TempAutoPlay;
    bool isAutoPlayVoice;
    bool isFromStopBtn;
    bool isFromTouchAutoVoice;

    
private:
    
    
};


#endif /* YVChatNode_h */
