local consts = {

	MAX_PLAYER_NUM = 5,

}

consts.TIME_GAP = {
	THROW_JETS = 0.3,
	PUSH_JETTON = 0.5,
	JETS_TO_POOL = 0.35,
	POOL_TO_PLAYER = 0.1,
	SEND_CARD = 0.25,
	CARD_FLY = 0.1,
}

consts.PATH = {
	-- button image file path
	BTN_CCDOWN_NORMAL = 'Image/HkFiveCard/button/button_ccdown_norma.png',
	BTN_CCDOWN_PRESSED = 'Image/HkFiveCard/button/button_ccdown_selected.png',
	BTN_CCUP_NORMAL = 'Image/HkFiveCard/button/button_ccup_norma.png',
	BTN_CCUP_PRESSED = 'Image/HkFiveCard/button/button_ccup_selected.png',
	BTN_SOUND_NORMAL = 'Image/HkFiveCard/button/button_sound_normal.png',
	BTN_SOUND_PRESSED = 'Image/HkFiveCard/button/button_sound_selected.png',
	BTN_MUTE_NORMAL = 'Image/HkFiveCard/button/button_mute_normal.png',
	BTN_MUTE_PRESSED = 'Image/HkFiveCard/button/button_mute_selected.png',

	-- sprite image file path
	IMG_DEFAULT = "Default/Sprite.png",
	IMG_SHOW_HAND = 'Image/HkFiveCard/gameui/image_show_hand.png',
	IMG_WAITING_WORDS = 'Image/HkFiveCard/gameui/img_GameUI_WaitPlayer.png',
	IMG_WAITING_DOT = 'Image/HkFiveCard/gameui/img_GameUI_WaitDian.png',
	IMG_READY = 'Image/HkFiveCard/gameui/img_GameUI_ready.png', 
	IMG_RESULT_WIN = 'Image/HkFiveCard/gameresult/GAME_RESULT_WIN.png',
	IMG_RESULT_LOSE = 'Image/HkFiveCard/gameresult/GAME_RESULT_LOSE.png',

	-- image packed file path
	IMGS_ACTION_BG = 'Image/HkFiveCard/gameui/image_action_back.png',
	IMGS_ACTION_FONT ='Image/HkFiveCard/gameui/image_action_font.png',
	IMGS_CARD_TYPE = 'Image/HkFiveCard/gameui/image_card_type.png',
	IMGS_TIME_NUM = 'Image/HkFiveCard/gameui/img_GameUI_Time_Number.png',
	IMGS_JETTON = 'Image/HkFiveCard/gameui/JETTON_VIEW.png',
	IMGS_CARD = 'Image/HkFiveCard/card/img_card.png',

	-- sound file path
	WAV_SEND_CARD = 'Sound/HkFiveCard/SEND_CARD.wav',
	WAV_GAME_START = 'Sound/HkFiveCard/GAME_START.wav',
	WAV_GAME_END = 'Sound/HkFiveCard/GAME_END.wav',
	WAV_GAME_WARN = 'Sound/HkFiveCard/GAME_WARN.wav',
	WAV_GAME_WIN = 'Sound/HkFiveCard/GAME_WIN.wav',
	WAV_GAME_LOSE = 'Sound/HkFiveCard/GAME_LOSE.wav',
	WAV_NO_RAISE = 'Sound/HkFiveCard/NO_ADD.wav',
	WAV_RAISE_SCORE = 'Sound/HkFiveCard/ADD_SCORE.wav',
	WAV_FOLLOW = 'Sound/HkFiveCard/FOLLOW.wav',
	WAV_SHOW_HAND = 'Sound/HkFiveCard/SHOW_HAND.wav',
	WAV_GIVE_UP = 'Sound/HkFiveCard/GIVE_UP.wav',
}


return consts