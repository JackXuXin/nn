local conf = {}

--上虞麻将ID段是10100~10199
--五张ID段10200~10299
--嵊州麻将ID段是10300~10399
--牛牛ID段是10500~10599

--gameid 游戏ID，每个游戏不要重复
--roomid 房间ID，和game_conf.lua、room_conf.lua的房间ID一致
--name 房间名字
--gold 最低进入金币
--tables 房间桌子数
--seats 每桌座位数
--seatslayout 每桌座位布局
--maxRoomPlayer 房间最大人数，用于客户端展现UI
--gamekey 游戏关键字，特定游戏有需要再使用，一种标识
--layout 每个座位的详细配置
  -- width 座位宽度
  -- height 座位高度
  -- table 座位图片及位置
  -- lock 带密码的图片及位置
  -- seat 每个座位图片及位置
  -- name 每个座位的玩家名字位置及位置
  -- hand 每个座位的玩家准备后举手图片及位置

conf[10200] = {
  gameid = 102,
  roomid = 10200,
  name = "冒险岛",
  gold = 1000,
  tables = 60,
  seats = 5,
  seatslayout = {{1,2,3,4,5},{1,3},{1,2,3,4,5}},
  goldseq = {10000,10000,1000000},
  maxRoomPlayer = 240, -- 房间最大人数，用于客户端展现UI
  layout = {
    width = 426,
    height = 360,
    table = {idle = "Image/Common/Table/Image_Table_Unplay.png", busy = "Image/Common/Table/Image_Table_Playing.png", posx = 160+52, posy = 180},
    lock = {icon = "Image/Common/Table/Image_Table_Lock.png", posx=160+80, posy=180-30},
    seat = {
      {id=1, posx=290+22, posy=63+30,icon="Image/Common/Table/chair_1.png"},
      {id=2, posx=360+2, posy=240,icon="Image/Common/Table/chair_2.png"},
      {id=3, posx=160+52, posy=285,icon="Image/Common/Table/chair_3.png"},
      {id=4, posx=-40+102, posy=240,icon="Image/Common/Table/chair_4.png"},
      {id=5, posx=30+82, posy=63+30,icon="Image/Common/Table/chair_5.png"}
    },
    name = {
      {id=1, point="center", posx=290+22, posy=63+90},
      {id=2, point="center", posx=360+2, posy=300},
      {id=3, point="center", posx=160+52, posy=345},
      {id=4, point="center", posx=-40+102, posy=300},
      {id=5, point="center", posx=30+82, posy=63+90},
    },
    hand = {
      {id=1, icon="Image/Common/Table/Image_Ready.png", posx=290+22-30, posy=63+30-60},
      {id=2, icon="Image/Common/Table/Image_Ready.png", posx=360+2-30, posy=260-80},
      {id=3, icon="Image/Common/Table/Image_Ready.png", posx=160+52-30, posy=285-60},
      {id=4, icon="Image/Common/Table/Image_Ready.png", posx=-40+102-30, posy=260-80},
      {id=5, icon="Image/Common/Table/Image_Ready.png", posx=30+82-30, posy=63+30-60},
    }
  }
}

conf[10600] = {
  gameid = 106,
  roomid = 10600,
  name = "桃花岛",
  gold = 1000,
  tables = 60,
  seats = 4,
  seatslayout = {{1,2,3,4},{1,2,3,4},{1,2,3,4}},
  goldseq = {10000,100000,1000000},
  maxRoomPlayer = 500,
  gamekey = "sss",
  layout = {
    width = 426,
    height = 410,
    table = {idle = "ShYMJ/Image_Table_Playing.png", busy = "ShYMJ/Image_Table_Unplay.png", posx = 160+52, posy = 190},
    lock = {icon = "Image/Common/Table/Image_Table_Lock.png", posx=215, posy=155},
    seat = {
      {id=1, posx=212, posy=75, icon="ShYMJ/Image_chair_down.png"},
      {id=2, posx=345, posy=190, icon="ShYMJ/Image_chair_right.png"},
      {id=3, posx=212, posy=305, icon="ShYMJ/Image_chair_up.png"},
      {id=4, posx=80, posy=190, icon="ShYMJ/Image_chair_left.png"}
    },
    name = {
      {id=1, point="left", posx= 212, posy=135},
      {id=2, point="center", posx= 345, posy=250},
      {id=3, point="right", posx= 212, posy=365},
      {id=4, point="center", posx= 80, posy=250},
    },
    hand = {
      {id=1, icon="Image/Common/Table/Image_Ready.png", posx=182, posy=15},
      {id=2, icon="Image/Common/Table/Image_Ready.png", posx=315, posy=130},
      {id=3, icon="Image/Common/Table/Image_Ready.png", posx=182, posy=245},
      {id=4, icon="Image/Common/Table/Image_Ready.png", posx=50, posy=130},
    }
  }
}

conf[10800] = {
  gameid = 108,
  roomid = 10800,
  name = "桃花岛",
  gold = 1000,
  tables = 60,
  seats = 4,
  seatslayout = {{1,2,3,4},{1,3},{1,3}},
  goldseq = {10000,10000,10000},
  maxRoomPlayer = 500,
  gamekey = "ycmj",
  fixedbase = 200,
  layout = {
    width = 426,
    height = 410,
    table = {idle = "ShYMJ/Image_Table_Playing.png", busy = "ShYMJ/Image_Table_Unplay.png", posx = 160+52, posy = 190},
    lock = {icon = "Image/Common/Table/Image_Table_Lock.png", posx=215, posy=155},
    seat = {
      {id=1, posx=212, posy=75, icon="ShYMJ/Image_chair_down.png"},
      {id=2, posx=345, posy=190, icon="ShYMJ/Image_chair_right.png"},
      {id=3, posx=212, posy=305, icon="ShYMJ/Image_chair_up.png"},
      {id=4, posx=80, posy=190, icon="ShYMJ/Image_chair_left.png"}
    },
    name = {
      {id=1, point="left", posx= 212, posy=135},
      {id=2, point="center", posx= 345, posy=250},
      {id=3, point="right", posx= 212, posy=365},
      {id=4, point="center", posx= 80, posy=250},
    },
    hand = {
      {id=1, icon="Image/Common/Table/Image_Ready.png", posx=182, posy=15},
      {id=2, icon="Image/Common/Table/Image_Ready.png", posx=315, posy=130},
      {id=3, icon="Image/Common/Table/Image_Ready.png", posx=182, posy=245},
      {id=4, icon="Image/Common/Table/Image_Ready.png", posx=50, posy=130},
    }
  }
}

conf[11100] = {
  gameid = 111,
  roomid = 11100,
  name = "海纳百川",
  gold = 1000,
  tables = 60,
  seats = 4,
  seatslayout = {{1,2,3,4},{1,2,3,4},{1,2,3,4}},
  goldseq = {10000,10000,10000},
  maxRoomPlayer = 500,
  gamekey = "srddz",
  fixedbase = 1000,
  layout = {
    width = 426,
    height = 410,
    table = {idle = "ShYMJ/Image_Table_Playing.png", busy = "ShYMJ/Image_Table_Unplay.png", posx = 160+52, posy = 190},
    lock = {icon = "Image/Common/Table/Image_Table_Lock.png", posx=215, posy=155},
    seat = {
      {id=1, posx=212, posy=75, icon="ShYMJ/Image_chair_down.png"},
      {id=2, posx=345, posy=190, icon="ShYMJ/Image_chair_right.png"},
      {id=3, posx=212, posy=305, icon="ShYMJ/Image_chair_up.png"},
      {id=4, posx=80, posy=190, icon="ShYMJ/Image_chair_left.png"}
    },
    name = {
      {id=1, point="left", posx= 212, posy=135},
      {id=2, point="center", posx= 345, posy=250},
      {id=3, point="right", posx= 212, posy=365},
      {id=4, point="center", posx= 80, posy=250},
    },
    hand = {
      {id=1, icon="Image/Common/Table/Image_Ready.png", posx=182, posy=15},
      {id=2, icon="Image/Common/Table/Image_Ready.png", posx=315, posy=130},
      {id=3, icon="Image/Common/Table/Image_Ready.png", posx=182, posy=245},
      {id=4, icon="Image/Common/Table/Image_Ready.png", posx=50, posy=130},
    }
  }
}



return conf
