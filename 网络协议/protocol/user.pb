
Ò'

user.protouser"#
UserInfoRequest
uid (Ruid"§
UserInfoResonpse
uid (Ruid
nickname (	Rnickname
money (Rmoney
gold (	Rgold
exp (Rexp
vipexp (Rvipexp
sex (Rsex
imageid (	Rimageid$
havesecondpwd	 (Rhavesecondpwd
	isbinding
 (R	isbinding
honor (:-1Rhonor
bankgold (	Rbankgold
supid (Rsupid
viptype (Rviptype
vipdays (Rvipdays

dynamicpwd (	R
dynamicpwd"[
ModifyUserInfoReq
nickname (	Rnickname
sex (Rsex
imageid (	Rimageid"+
ModifyUserInfoRep
result (Rresult"
CheckReconnectReq"a
CheckReconnectRep
roomid (Rroomid
session (Rsession
clientid (Rclientid"[
ReconnectTableReq
session (Rsession
result (Rresult
index (Rindex"+
ReconnectTableRep
result (Rresult"
RoomListReq"õ
RoomListRep
config (	Rconfig7
players (2.user.RoomListRep.RoomPlayersRplayers;
RoomPlayers
roomid (Rroomid
count (Rcount"F
QuickJoinRequest
roomid (Rroomid
clientid (Rclientid"_
QuickJoinResonpse
result (Rresult
clientid (Rclientid
roomid (Rroomid"F
EnterRoomRequest
roomid (Rroomid
clientid (Rclientid"_
EnterRoomResonpse
result (Rresult
clientid (Rclientid
roomid (Rroomid"+
PlayersAmountReq
game_id (RgameId"|
PlayersAmountRep/
info (2.user.PlayersAmountRep.InfoRinfo7
Info
room_id (RroomId
amount (Ramount"%
CheckSecondPwdReq
pwd (	Rpwd"+
CheckSecondPwdRep
result (Rresult"U
	SetPwdReq
pwdtype (Rpwdtype
oldpwd (	Roldpwd
newpwd (	Rnewpwd"=
	SetPwdRep
result (Rresult
pwdtype (Rpwdtype"N
BankOperateReq
optype (Roptype
gold (	Rgold
pwd (	Rpwd"X
BankOperateRep
result (Rresult
gold (	Rgold
bankgold (	Rbankgold"N
BindingDeviceReq
optype (Roptype
key (	Rkey
pwd (	Rpwd"E
GiveGoldReq
uid (Ruid
gold (	Rgold
pwd (	Rpwd"Å
GiveGoldRes
result (Rresult
bankgold (	Rbankgold
subgold (	Rsubgold
fee (	Rfee
time (	Rtime"*
BindingDeviceRep
result (Rresult"B
MatchSignupReq
optype (Roptype
matchid (Rmatchid"B
MatchSignupRep
result (Rresult
matchid (Rmatchid"?
MatchStartNtf
matchid (Rmatchid
subid (Rsubid"E
EnterMatchReq
clientid (Rclientid
matchid (Rmatchid"A
EnterMatchRep
result (Rresult
matchid (Rmatchid"t
MatchInfoNtf
clientid (Rclientid
optype (Roptype
timeout (Rtimeout
params (Rparams",
QueryFreezeGoldReq
optype (Roptype"l
QueryFreezeGoldRep
optype (Roptype
	canfreeze (	R	canfreeze 
totalfrozen (	Rtotalfrozen"'
RechargeReq
orderid (Rorderid"%
RechargeRep
result (Rresult"#
BindUserReq
supid (Rsupid"%
BindUserRep
result (Rresult"!
SigninInfoReq
uid (Ruid"ú
SigninInfoRep!
signin_today (RsigninToday
signin_gold (	R
signinGold6
continuous_signin_count (RcontinuousSigninCount
signin_days (R
signinDays0
residual_grant_count (RresidualGrantCount

grant_gold (	R	grantGold

share_gold (	R	shareGold"
	SigninReq
uid (Ruid"=
	SigninRep
result (Rresult
addgold (	Raddgold"
GetGrantReq
uid (Ruid"q
GetGrantRep
result (Rresult
addgold (	Raddgold0
residual_grant_count (RresidualGrantCount" 
ShareGameReq
uid (Ruid"_
ShareGameRep
result (Rresult
addgold (	Raddgold

check_code (	R	checkCode"#
ExchangeReq
honor (Rhonor"%
ExchangeRep
result (Rresult"π
PublishNotice;
notice_list (2.user.PublishNotice.NoticeR
noticeListk
Notice
id (Rid
app_channel (	R
appChannel
gameid (Rgameid
content (	Rcontent"*
UnpublishNotice
id_list (RidList"=
OpenSesameReq
pwd (	Rpwd
clientid (Rclientid"s
OpenSesameRep
result (Rresult
clientid (Rclientid
roomid (Rroomid
gameid (Rgameid"E
BackupFriendshipReq
optype (Roptype
friend (Rfriend"-
BackupFriendshipRep
result (Rresult"‡
InviteFriendsReq
nickname (	Rnickname
gameid (Rgameid
roomid (Rroomid
tableid (Rtableid
seatid (Rseatid
friends (Rfriends
session (Rsession
password (	Rpassword"*
InviteFriendsRep
result (Rresult"“

Invitation
uid (Ruid
nickname (	Rnickname
gameid (Rgameid
roomid (Rroomid
tableid (Rtableid
seatid (Rseatid
session (Rsession
password (	Rpassword" 

AddGoldReq
gold (Rgold"

ChartReq"◊
ChartRep:
moneyCharts (2.user.ChartRep.ChartItemRmoneyCharts<
winnerCharts (2.user.ChartRep.ChartItemRwinnerChartsQ
	ChartItem
nickname (	Rnickname
head (	Rhead
money (Rmoney