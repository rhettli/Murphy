local skip_router = {
    member = { 'login', 'reg' },
    pay = { 'start', 'status' },
    cw_package = { 'search' },
}

local class_base = {}

function class_base:new(o)
    o = o or {}
    --setmetatable(o, self)
    --self.__index = self
    --
    --local sid = http_params('sid')
    --if not is_valid(sid) then
    --    return nil
    --end


    if not self:checkRouter() then
        print('router check fail')
        if not self:checkAuth() then
            self:renderJSON(nil, 'Auth Fail.', -1)
            assert(false, 'auth fail exit')
        end

    end

    if o.new then
        o:new()
    end
    _merge_left(o, self)

    return o
end

-- check short psw [检查短密码]
function class_base:checkShortPsw()
    local _res_check_psw = self._res_check_psw

    if _res_check_psw ~= nil then
        return _res_check_psw[1], _res_check_psw[2]
    end
    local sp = http_params('sp')
    if not is_valid(sp) then
        _res_check_psw = { false, 'sp invalid' }
    end
    local member = self:currentMember()
    if not is_valid(member.sp) then
        _res_check_psw = { false, 'no sp' }
    end
    if member.sp ~= sp then
        _res_check_psw = { false, 'sp invalid' }
    elseif member.sp_expire_time > time() then
        _res_check_psw = { true }
    else
        _res_check_psw = { false, 'sp expire' }
    end
    self._res_check_psw = _res_check_psw
    return _res_check_psw[1], _res_check_psw[2]
end

--- enable this function ,you must config redis in conf/conf.lua [检查某个key是否达到足够的total次数，在in_second秒内]
function class_base:checkEnoughTimes(key, total, in_second)
    local ch = redis_cache0()
    if ch then
        key = '__check_lock' .. key
        total = total or 50
        in_second = in_second or 5
        local r = ch:exec('get', key)
        if r == nil then
            local res = ch:exec('SETEX', key, in_second, 1)
            --print('set to cache:', res)
        else
            if tonumber(r) > total then
                return true
            end
            local res = ch:exec('incr', key)
            --print('set to cache:', res)
            return false
        end
    end
    print('Call check,must config [redis0] at conf/conf.lua')
    return true
end

function class_base:currentMember()
    return _new_model('member'):findFirstBy('id', self:currentMemberId())
end

function class_base:currentMemberId()
    if self._sid then
        return self._sid
    end
    local sid = http_params('sid')
    sid = str_split(sid, '.')
    if sid[1] then
        sid[1] = tonumber(sid[1])
        self._sid = sid[1]
        return sid[1]
    end
end

function class_base:checkAuth()
    local sid = http_params('sid')
    if sid then
        local member = _new_model('member'):findFirstBy('id', str_split(sid, '.')[1])
        if is_valid(member) and member.sid == sid then
            return true
        end
    end
    return false
end

function class_base:checkRouter()
    if skip_router then
        for i, v in pairs(skip_router) do
            local action = str_sub_to_left(_ACCESS_FILE, '/')
            print('action:==', action)
            print(_ACCESS_FILE, _ACCESS_METHOD)
            if action == i then
                for k, p in pairs(v) do
                    if p == _ACCESS_METHOD then
                        return true
                    end
                end
            end
        end
    end
    return false
end

return _extend(class_base, "lib.controller", { skip_router = skip_router })