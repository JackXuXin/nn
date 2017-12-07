
ò
PrivateRoom.protoPrivateRoom"
PrivateRoomConfigReq".
PrivateRoomConfigRep
config (	Rconfig"î
PrivateRoomCreateReq
gameid (Rgameid
seat_cnt (RseatCnt

carry_gold (R	carryGold

game_round (R	gameRound
time (Rtime
fee (Rfee
pay_type (RpayType$
customization (Rcustomization"}
PrivateRoomCreateRep
result (Rresult
gameid (Rgameid

table_code (	R	tableCode
seatid (Rseatid"P
PrivateRoomEnterReq
clientid (Rclientid

table_code (	R	tableCode"†
PrivateRoomEnterRep
session (Rsession
result (Rresult
gameid (Rgameid
tableid (Rtableid
seatid (Rseatid

table_code (	R	tableCode#
table_session (RtableSession
pian_cnt (RpianCnt
	gameround	 (R	gameround
seat_cnt
 (RseatCnt$
customization (Rcustomization
pay_type (RpayType
curround (Rcurround"å
PrivateRoomTableStateInfo
session (Rsession
table (Rtable
state (RstateI
player (21.PrivateRoom.PrivateRoomTableStateInfo.PlayerInfoRplayer¶

PlayerInfo
seat (Rseat
uid (Ruid
name (	Rname
gold (	Rgold
ready (Rready
sex (Rsex
viptype (Rviptype
imageid (	Rimageid"ð
PrivateRoomGameScore
session (Rsession
tableid (RtableidM

playerInfo (2-.PrivateRoom.PrivateRoomGameScore.PlayerScoreR
playerInfo
	nextround (R	nextround7
PlayerScore
seat (Rseat
score (Rscore"ö
PrivateRoomTableStart
session (Rsession
table (Rtable
state (Rstate
my_seat (RmySeatE
player (2-.PrivateRoom.PrivateRoomTableStart.PlayerInfoRplayer¶

PlayerInfo
seat (Rseat
uid (Ruid
name (	Rname
gold (	Rgold
ready (Rready
sex (Rsex
viptype (Rviptype
imageid (	Rimageid"/
PrivateRoomLeaveReq
session (Rsession"u
PrivateRoomLeaveRep
session (Rsession
result (Rresult
seat (Rseat
tableid (Rtableid"/
PrivateRoomReadyReq
session (Rsession"u
PrivateRoomReadyRep
session (Rsession
seat (Rseat
tableid (Rtableid
result (Rresult"3
PrivateRoomManualEndAsk
session (Rsession"]
PrivateRoomManualEndAws
session (Rsession
seat (Rseat
agree (Ragree"^
PrivateRoomManualEndResult
session (Rsession
seat (Rseat
name (	Rname"B
PrivateRoomEnd
session (Rsession
reason (Rreason"à
PrivateRoomGameRecords
session (RsessionP
gameRecords (2..PrivateRoom.PrivateRoomGameRecords.GameRecordRgameRecordsÙ

GameRecord
gameid (Rgameid
	tablecode (	R	tablecode
	gameround (R	gameround
gametime (	Rgametimea
playerRecords (2;.PrivateRoom.PrivateRoomGameRecords.GameRecord.PlayerRecordRplayerRecordsx
PlayerRecord
seat (Rseat
name (	Rname
score (Rscore
sex (Rsex
imageid (	Rimageid