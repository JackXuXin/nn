local PreloadRes = {}

PreloadRes.LobbyResName = {
    EnterRoomBtn = "Image/Public/img_newMainMenu_EnterRoomBtn.png",
    RoomState = "Image/Public/img_newMainMenu_RoomBurthenMark.png",
    BurthenMark = "Image/Public/img_newMainMenu_GameBurthenMark.png",
    PopularityMark = "Image/Public/img_newMainMenu_GamePopularityMark.png",
}
PreloadRes.LobbyRes = {
    [PreloadRes.LobbyResName.EnterRoomBtn] = {
        width = 651, 
        height = 117, 
        number = nil,
    },
    [PreloadRes.LobbyResName.RoomState] = {
        width = 63, 
        height = 117, 
    },
    [PreloadRes.LobbyResName.BurthenMark] = {
        width = 17, 
        height = 17, 
    },
    [PreloadRes.LobbyResName.PopularityMark] = {
        width = 75, 
        height = 29, 
    },
}

PreloadRes.BRNNResName = {
    Scores = "Image/BRNN/numScore.png",
}
PreloadRes.BRNNRes = {
    [PreloadRes.BRNNResName.Scores] = {
        width = 22, 
        height = 30, 
    },
    
}

--add by whb 0927

  PreloadRes.HonorResName = 
  {
    HonorBg = "Image/HonorLayer/HonorLayer.png",
    HonorPic = "Image/HonorLayer/",
    changeBg = "Image/HonorLayer/changeBg.png",
    btn_exchange1 = "Image/HonorLayer/btn_exchange1.png",
    btn_exchange2 = "Image/HonorLayer/btn_exchange2.png",
    exchange_name = "荣誉值兑换旺豆",
  }

  PreloadRes.HonorRes = 
  {
    [1] = {
        width = 117, 
        height = 100, 
        name = "IPhone 7",
        value = 100000000 
    },
    [2] = {
        width = 84, 
        height = 87, 
        name = "IPhone 6S",
        value = 80000000
    },
    [3] = {
        width = 76, 
        height = 80, 
        name = "iPhone SE",
        value = 60000000
    },
    [4] = {
        width = 74, 
        height = 95, 
        name = "iPad mini 4",
        value = 60000000 
    },
    [5] = {      
        width = 67, 
        height = 86, 
        name = "iPad mini 2",
        value = 40000000 
    },
    [6] = {
        width = 129, 
        height = 78, 
        name = "Apple Watch",
        value = 40000000 
    },
    [7] = {
        width = 122, 
        height = 78, 
        name = "小米九号平衡车",
        value = 40000000 
    },
    [8] = {
        width = 124, 
        height = 81, 
        name = "小米盒子3S",
        value = 7000000
    },
    [9] = {
        width = 97, 
        height = 84, 
        name = "小米床头灯",
        value = 5000000
    },
    [10] = {
        width = 66, 
        height = 99, 
        name = "小米体脂秤",
        value = 4000000
    },
    [11] = {
        width = 91, 
        height = 98, 
        name = "小米LED写字灯",
        value = 3600000 
    },
    [12] = {
        width = 82, 
        height = 92, 
        name = "小米手环2",
        value = 3200000 
    },
    [13] = {
        width = 84, 
        height = 88, 
        name = "小米路由器",
        value = 2000000
    },
    [14] = {
        width = 93, 
        height = 82, 
        name = "小米移动电源",
        value = 1000000 
    },
    [15] = {
        width = 55, 
        height = 105, 
        name = "小米wifi放大器",
        value = 1000000 
    },
  }

    PreloadRes.ChargeResName = 
  {
    ChargeBg = "Image/Pay/item/add_bg.png",
    ChargePic = "Image/Pay/item/add_",
  }

   PreloadRes.AddChargeRes = 
  {
    [1] = {
        width = 100, 
        height = 22,
        text = "多送1.2万",
    },
    [2] = {
        width = 83, 
        height = 22,
        text = "多送6万",
    },
    [3] = {
        width = 114, 
        height = 22,
        text = "多送15.6万",
    },
    [4] = {
        width = 97, 
        height = 22,
        text = "多送32万",
    },
    [5] = {
        width = 132, 
        height = 22,
        text = "多送177.6万",
    },
    [6] = {
        width = 107, 
        height = 20,
        text = "送30天会员",
    }

  }

--add end

return PreloadRes