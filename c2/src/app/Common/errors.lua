local errors = nil

-- common error codes.
local common_error = {
    "unknown",
    "lack_gold",
}


-- gate server
local gate_error = {
}


-- login server
local login_error = {
}


-- game server
local room_error = {   
    "enter_failed",
    "wrong_roomid",
    "room_is_full",
    "room_maintaining",
    "gaming_other_room",
    "gen_private_failed",
    "no_table_available",
    "table_min_win_rate",
    "table_max_flee_rate",
    "table_min_score",
    "table_max_score",
    "table_no_sameip",
    "table_pwd_need",
    "table_pwd_error",
    "create_failed",
    "room_rule_error",
    "host_private_exist",
    "wrong_privateid",
    "no_stay_room",
}

local table_error = {  
	  "table_locked",
    "wrong_seat",
    "game_started",
    "freeze_gold_failed",
    "was_readied",
    "invalid_player",
    "no_lookon_yet",
    "gaming_other_else",
    "gaming_cannot_dismiss",
    "no_right_dismiss", -- 无权发起解散请求
    "invalid_privateid",
    "no_seat_available",
    "start_failed",
    "no_start_gold",
    "table_dismissed",
    "table_wait_host",
    "player_sit_seat",
    "player_req_dismiss", -- 已有玩家发起解散请求
    "success_req_dismiss",  -- 解散请求收到，已转发其他玩家
    "success_reject_dismiss", -- 拒绝解散成功
    "no_req_dismiss", -- 无人申请解散
    "repeat_req_dismiss", -- 重复解散申请
    "reject_req_dismiss", -- 某玩家拒绝解散
    "wait_rep_dismiss", -- 等待解散结果
    "success_dismiss",
    "finish_game_over", -- 正常结束
    "finish_zero_gold",
    "finish_dismiss", -- 解散结束（游戏开始）
    "finish_timeout", -- 过期结束
    "finish_host_dismiss",  -- 房主解散（游戏未开始）
    "finish_long_time_no_playing",
    "continue_timeout",
    "cancel_privateid_failed",
    "can_not_watch",
}

local game_error = {
    "lack_gold_banker",
}

setmetatable(gate_error, {__index = common_error})
setmetatable(login_error, {__index = common_error})
setmetatable(room_error, {__index = common_error})
setmetatable(table_error, {__index = common_error})
setmetatable(game_error, {__index = common_error})

errors = {
    common_error, gate_error, login_error, room_error, table_error, game_error,
}

-- for exprot
errors.COMMON = common_error
errors.GATE = gate_error
errors.LOGIN = login_error
errors.ROOM = room_error
errors.TABLE = table_error
errors.GAME = game_error

-- for convenince
errors.ALL = {}

-- build map index, for all error tables.
local idx = 1
for _, t in ipairs(errors) do
    for i = 1, #t do
        v = t[i]
        if t[v] then
            if LOG_ERROR then
                LOG_ERROR("duplilcated error code:%s", tostring(v))
            end
        else
            t[v] = idx
            errors.ALL[v] = idx
            errors.ALL[idx] = v
            idx = idx + 1
        end
    end
end

function errors.str(err_code)
    if type(err_code) ~= "number" then
        return "invalid err_code:"..tostring(err_code)
    end
    local str = errors.ALL[err_code]
    if str == nil then
        return "invalid err_code:"..tostring(err_code)
    end
    return str
end

return errors
