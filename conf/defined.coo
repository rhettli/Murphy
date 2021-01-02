-- here defined global function [这里定义全局函数]

--- get ssdb0 handler,config it at conf/conf.lua [获取ssdb链接句柄,在conf/conf.lua中配置 ssdb0]
ssdb_cache0 = function()
    return _import('lib.redis'):new('ssdb0')
end

--- get redis0 handler [获取redis链接句柄]
redis_cache0 = function()
    return _import('lib.redis'):new('redis0')
end

--- get redis0 handler [获取redis链接句柄,共数据存储使用]
data_cache0 = redis_cache0

--- table slice [table截取到右边给定位置]
--- table_sub_to_right({1，2},2)={1}
table_sub_to_right = function(t, r)
    local res = {}
    for i, v in pairs(t) do
        if i <= r then
            res[i] = v
        end
    end
    return res
end

end_with = function(str, to)
    return str_index(str, to) == len(str) - len(to)
end

begin_with = function(str, to)
    return str_index(str, to) == 0
end

_is_allowed = function(path, p)


    return 1
end

--- str slice to give index [string截取到右边给定位置]
--- str_sub_to_right('123/321','/')='123'
str_sub_to_right = function(str, to, skip)
    if skip and tonumber(skip) > 0 then
        local i = 1
        local right_index = -1
        while i < skip do
            right_index = str_index(str, to, right_index)
            if right_index < 0 then
                return str
            end
            i = i + 1
        end

        return str_sub(str, 0, right_index)
    end

    return str_sub(str, 0, str_index(str, to))
end

-- todo

str_sub_to_left = function(str, to)
    return str_sub(str, str_rindex(str, to) + 1, #str)
end

end_of_day = function()

end

end_of_month = function()

end

end_of_week = function()

end

begin_of_month = function()

end

begin_of_day = function()

end
