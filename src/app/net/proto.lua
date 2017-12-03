local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}


.PlayerInfo {
	seat 0 : integer
	uid 1 : integer
	name 2 : string
	gold 3 : integer
	ready 4 : integer
	sex 5 : integer
	viptype 6 : integer
	headimgurl 7 : string
}

Handshake 1 {
	request {
		key 0 : string
	}
	response {
		result 0 : string
	}
}

Heartbeat 2 {
	request {
		index 0 : integer
	}
	response {
		index 0 : integer
	}
}

UserInfo 3 {
	request {
		addr 0 : integer
	}
	response {
		uid 0 : integer
		nickname 1 : string
		money 2 : integer
		gold 3 : string
		exp 4 : integer
		vipexp 5 : integer
		sex 6 : integer
		imageid 7 : string
		havesecondpwd 8 : integer
		isbinding 9 : integer
		honor 10 : integer
		bankgold 11 : string
		supid 12 : integer
		viptype 13 : integer
		vipdays 14 : integer
		dynamicpwd 15 : string
		diamond 16 : integer
		suqq 17 : string
		suweixin 18 : string 
	}
}

ServerAddr 4 {
	request {}
	response {
		.ServerMap {
	        name 0 : string
	        addr 1 : integer
    	}
    	addrs 0 : *ServerMap
	}
}

ModifyUserdata 5 {
	request {
		nickname 0 : string
		headimgurl 1 : string
		addr 2 : integer
	}
	response {}
}


Create 10 {
	request {
		gameid 0 : integer 
		seat_cnt 1 : integer
		game_round 2 : integer
		time 3 : integer
		mode 4 : integer
		uid 5 : integer
	}

	response {
		result 0 : string
		gameid 1 : integer
		table_code 2 : string
	}
}

Enter 11 {
	request {
		table_code 0 : string
		uid 1 : integer
	}

	response {
		table_addr 0 : integer
		result 1 : string 					
		gameid 2 : integer
		tableid 3 : integer
		seatid 4 : integer
		table_code 5 : string 			
		gameround 6 : integer				
		seat_cnt 7 : integer				
		time 8 : integer
		mode 9 : integer
		curround 10 : integer
	}
}

QueryTablePlayer 12 {
	request {
		addr 0 : integer
		uid 1 : integer
	}
	response {
		table 0 : integer
		state 1 : integer
		players 2 : *PlayerInfo
		start 3 : boolean
		curPlayer 4 : integer
	}
}

QueryIsInGame 13 {
	request {
		uid 0 : integer
	}
	response {
		table_code 0 : string		
	}
}

Leave 14 {
	request {
		uid 0 : integer
	}
}

Ready 15 {
	request {
		addr 0 : integer
	}
}

EndRoomReq 16 {
	request {
		seat 0 : integer
		addr 1 : integer
	}
}

EndRoomRep 17 {
	request {
		seat 0 : integer
		agree 1 : boolean
		addr 2 : integer
	}
}

Again 18 {
	request {}	
	response {
		result 0 : string
	}
}

.TableInfo {
	table_code 0 : string
	playerCount 1 : integer
	round 2 : integer
	seatCount 3 : integer
	time 4 : integer
}

TableList 19 {
	request {}
	response {
		tables 0 : *TableInfo
	}
}

CreateDummy 20 {
	request {
		gameid 0 : integer 
		seat_cnt 1 : integer
		game_round 2 : integer
		time 3 : integer
		mode 4 : integer
		uid 5 : integer
	}

	response {
		result 0 : string
		table_code 1 : string
		playerCount 2 : integer
		round 3 : integer
		seatCount 4 : integer
		time 5 : integer
	}
}


.Card {
	num 0 : integer
	color 1 : integer
}

Handout 26 {
	request {
		addr 0 : integer 
		cards 1 : *Card 
	}
}


._6jtPlayerInfo {
	score 0 : integer 
	leastCardNum 1 : integer
	outcards 2 : *Card
	isFirst 3 : boolean
	seat 4 : integer
}

.Curcard {
	seat 0 : integer 
	cards 1 : *Card
}

QueryGamescene 27 {
	request {
		addr 0 : integer
	}
	response {
		players 0 : *_6jtPlayerInfo
		handcards 1 : *Card
		tableScore 2 : integer
		curcard 3 : Curcard
		curPlayer 4 : integer
		state 5 : string
	}
}

QueryGameResult 28 {
	request {
		addr 0 : integer
	}
	response {
		scores 0 : *integer
		winScore 1 : integer
		loseScore 2 : integer
		inScores 3 : *integer
	}
}

]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}


.PlayerInfo {
	seat 0 : integer
	uid 1 : integer
	name 2 : string
	gold 3 : integer
	ready 4 : integer
	sex 5 : integer
	viptype 6 : integer
	headimgurl 7 : string
}


Kick 1 {
	request {}
}

ServerAddr 2 {
	request {
		.ServerMap {
	        name 0 : string
	        addr 1 : integer
    	}
    	addrs 0 : *ServerMap
	}
}

GameStart 12 {
	request {
		uid 0 : integer
	}
}

Leave 13 {
	request {
		seat 0 : integer
	}
}

PlayerJoin 14 {
	request {
		player 0 : PlayerInfo
	}
}

EndRoomReq 15 {
	request {
		seat 0 : integer
	}
}

EndRoomRep 16 {
	request {
		seat 0 : integer
		agree 1 : boolean
	}
}

EndRoom 17 {
	request {
		table_code 0 : string
	}
}

CanAgain 18 {
	request {}	
}

.Card {
	num 0 : integer
	color 1 : integer
}

.Curcard {
	seat 0 : integer 
	cards 1 : *Card
}

DrawTeam 25 {
	request {
		red 0 : *integer
		blue 1 : *integer
		cards 2 : *Card
	}
}

Deal 26 {
	request {
		cards 0 : *Card
		curPlayer 1 : integer
	}
}

OpenCardInfo 27 {
	request {
		card 0 : Card
		index 1 : integer
	}
}

Handout 28 {
	request {
		cards 0 : *Card 
		seat 1 : integer
		curPlayer 2 : integer
		result 3 : integer
		score 4 : integer
		roundWinner 5 : integer
		curcard 6 : Curcard
	}
}

GameResult 29 {
	request {
		scores 0 : *integer
		winScore 1 : integer
		loseScore 2 : integer
		inScores 3 : *integer
	}
}



]]

return proto
