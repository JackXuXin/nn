local logger = {}

local std_print = print
local std_printf = printf

-- if val of t has nil, table.concat will crushed.
local function concat(t) 
    local ret = ""
    for _, v in pairs(t) do
        if string.len(ret) == 0 then
            ret = tostring(v)
        else
            ret = ret .. " " .. tostring(v)
        end
    end
    return ret
end

local function timestamp()
    t = os.date("*t")
    return string.format("[%04d-%02d-%02d %02d:%02d:%02d]", 
        t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function src_line(debug_level)
    local info = debug.getinfo(debug_level)
    local filename = string.match(info.short_src, "[^/.]+.lua")
    return string.format("[%s:%d]", filename, info.currentline)
end

local function log_output(level, fmt, ...)
    std_print(timestamp().." "..level.." "..src_line(4).." "..string.format(tostring(fmt), ...))
end

function logger.debug(fmt, ...)
    log_output("[DEBUG]", fmt, ...)
end

function logger.info(fmt, ...)
    log_output("[INFO]", fmt, ...)
end

function logger.warn(fmt, ...)
    log_output("[WARN]", fmt, ...)
end

function logger.error(fmt, ...)
    log_output("[ERROR]", fmt, ...)
end

function logger.fatal(fmt, ...)
    log_output("[FATAL]", fmt, ...)
end

function logger.reset()
    print = std_print
    printf = std_printf
end

local function output(...)
    -- let output no tab on MACOSX
    std_print(timestamp().." [DEBUG] "..src_line(3).." "..concat({...}))
end

local function outputf(fmt, ...)
    std_print(timestamp().." [DEBUG] "..src_line(3).." "..string.format(tostring(fmt), ...))
end

--HACK: hook the std print.
print = output
printf = outputf


return logger