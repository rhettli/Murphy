local _M = {
}

function _M:new(o, params)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.queue_name = '_queue_name_default'

    return self
end

function _M.run(action, params)

end

-- 动作 参数
function _M:delay(action, params)
    -- 默认default队列中去

    local redis = _import('lib.redis'):new()
    local j = json_encode({ action = action, params = params })

    redis:exec('lpush', self.queue_name, j)
    redis:close()
    return true
end

-- 动作 参数
function _M:push(action, params)
    -- 默认default队列中去

    local redis = _import('lib.redis'):new()
    local j = json_encode({ action = action, params = params })

    redis:exec('lpush', self.queue_name, j)
    redis:close()
    return true
end

function _M:start(p)
    local redis = _import('lib.redis'):new()

    print('queue is start ok')
    while true
    do
        -- 这里循环取出队列数据 处理
        _try_lock('_lock_key_QUEUE_DEFAULT_', nil, function()
            local res = redis:exec('brpop', self.queue_name)
            if res ~= '' then
                local js = json_decode(res)
                local action = str_split(js.action, '.')
                if #action < 2 then
                    action[2] = 'handler'
                end
                local params = js.params

                local exec_queue = "local ctrl = _import('queue.%s');ctrl:new();return ctrl:%s,ctrl;"
                exec_queue = string.format(exec_queue, action[1], action[2])
                local call, obj = loadstring(exec_queue)()
                pcall(call, obj, params)

            end
        end)
        sleep(100)
    end

end

return _M