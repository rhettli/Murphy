_import = function(path)
    local p = path  --_dir_name ..
    _remove_package_cache(p)
    print('import:==', p)

    local res = require(p)
    return res
end

_merge_left = function(a, b)
    for i, v in pairs(b) do
        if not a[i] and i ~= 'new' then
            a[i] = v
        end
    end
    return a
end

_extend = function(model_self, model_name, ...)
    _remove_package_cache(model_name)
    print('extend:==', model_name)
    local r = _import(model_name):new(model_self, ...)
    return r
end

_new = function(path)
    return _new_model(path)
end

_render_model = function(model, key, value)
    local _operator_role = _new_model(model)
    local opRole = _operator_role:find()
    local select_items = {}
    for _, v in pairs(opRole) do
        select_items[v[key]] = v[value]
    end
    --print(json_encode(select_items))
    return select_items
end

_new_model = function(path)
    local p = 'model.' .. path
    _remove_package_cache(p)
    local res = _import(p):new()
    return res
end

_try_lock = function(lock_key, request_id, func, ...)
    if func == nil then
        assert(false, 'params 2 must be func')
    end
    if nil == request_id then
        request_id = time(true)
    end

    local sleep = sleep
    local SET_IF_NOT_EXIST = "NX";
    local SET_WITH_EXPIRE_TIME = "PX";

    local RELEASE_SUCCESS = 1;
    local LOCK_SUCCESS = "OK";

    local expireTime = 10000

    local redis = _import('lib.redis'):new('redis0')

    while true do
        --枷锁
        local r = redis:exec('set', lock_key, request_id, SET_IF_NOT_EXIST, SET_WITH_EXPIRE_TIME, expireTime)
        if LOCK_SUCCESS == r then
            local status, rf = pcall(func, ...)

            -- 解锁
            local script = "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end";
            local result = redis:eval(script, lock_key, request_id);
            redis:close()
            print("\n", 'eveal:', result, "\n")
            if RELEASE_SUCCESS ~= result * 1 then
                assert(false, 'redis unlock error')
            end
            -- 解锁完毕后，判断回调是否成功，失败直接终止程序
            if status == false then
                assert(false, "cal func err," .. debug.traceback())
            end

            return rf
        else
            sleep(10)
        end
    end
end

function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
            end
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

function unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = loadstring(lua)
    if func == nil then
        return nil
    end
    return func()
end

-- 测试代码如下
--data = {["a"] = "a", ["b"] = "b", [1] = 1, [2] = 2, ["t"] = {1, 2, 3}}
--local sz = serialize(data)
--print(sz)
--print("---------")
--print(serialize(unserialize(sz)))
