
Ì

game.protogame"B

SetSession
session (Rsession
clientid (Rclientid"Þ
TableStateInfo
session (Rsession
table (Rtable
state (Rstate7
player (2.game.TableStateInfo.PlayerInfoRplayer
round (Rround¶

PlayerInfo
seat (Rseat
uid (Ruid
name (	Rname
gold (	Rgold
ready (Rready
sex (Rsex
viptype (Rviptype
imageid (	Rimageid"˜
TableSitdown
session (Rsession
table (Rtable
seat (Rseat5
player (2.game.TableSitdown.PlayerInfoRplayerŒ

PlayerInfo
uid (Ruid
name (	Rname
gold (	Rgold
sex (Rsex
viptype (Rviptype
imageid (	Rimageid"¿

UpdateSeat
session (Rsession
table (Rtable
finish (Rfinish3
player (2.game.UpdateSeat.PlayerInfoRplayer4

PlayerInfo
seat (Rseat
gold (	Rgold"P

TableSitup
session (Rsession
table (Rtable
seat (Rseat"O
	SeatReady
session (Rsession
table (Rtable
seat (Rseat"A
TableStateStart
session (Rsession
table (Rtable"?
TableStateEnd
session (Rsession
table (Rtable"P

ManagedNtf
session (Rsession
seat (Rseat
state (Rstate"î

SitdownReq
session (Rsession
table (Rtable
seat (Rseat
sitpwd (	Rsitpwd.
rule (2.game.SitdownReq.TableRuleRruleÓ
	TableRule

minwinrate (R
minwinrate 
maxfleerate (Rmaxfleerate
minscore (Rminscore
maxscore (Rmaxscore

noblackman (R
noblackman
nosameip (Rnosameip
pwd (	Rpwd"„

SitdownRep
session (Rsession
result (Rresult
table (Rtable
seat (Rseat
watching (Rwatching"$
SitupReq
session (Rsession"<
SitupRep
session (Rsession
result (Rresult"'
RoomSession
session (Rsession"(
LeaveRoomReq
session (Rsession"@
LeaveRoomRep
session (Rsession
result (Rresult"$
ReadyReq
session (Rsession"<
ReadyRep
session (Rsession
result (Rresult"x
DismissGameReq
session (Rsession
	privateid (R	privateid
seat (Rseat
nickname (	Rnickname"
DismissGameRep
session (Rsession
	privateid (R	privateid
seat (Rseat
result (Rresult
nickname (	Rnickname"@
ChatInfo
chattype (Rchattype
content (	Rcontent"_
ChatReq
session (Rsession"
info (2.game.ChatInfoRinfo
toseat (Rtoseat";
ChatRep
session (Rsession
result (Rresult"{
ChatMsg
session (Rsession"
info (2.game.ChatInfoRinfo
fromseat (Rfromseat
toseat (Rtoseat