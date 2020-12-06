local class_member = {}

function class_member:new(o)
    o = o or {}
    --setmetatable(o, self)
    --self.__index = self

    self.version0 = "1"

    return self
end

-- default time 30min
function class_member:createShortPsw()
    local psw = _http_params('psw')
    local sp = _http_params('sp')
    local sp_expire_at = _http_params('sp_expire_at')
    if _is_valid(sp_expire_at) then
        sp_expire_at = _time() + sp_expire_at * 60
    else
        sp_expire_at = _time() + 30 * 60
    end

    local member = self:currentMember()
    if member.password ~= psw then
        return self:renderJSON(nil, 'login password error', -1)
    end
    member.sp = sp
    member.sp_expire_at = sp_expire_at
    member:save()
    return self:renderJSON(nil, '')

end

function class_member:logout()
    local member_id = self:currentMemberId()

    local sid = _http_params('sid')

    local m_sid = self:model('sid'):findFirstBy('sid', sid)
    if not m_sid then
        return self:renderJSON(nil, 'ok')
    end
    if m_sid.member_id == member_id then
        m_sid.sid = ''
        m_sid:save()
    else
        return self:renderJSON(nil, 'fail,can not logout other user')
    end

    return self:renderJSON(nil, 'ok')
end

function class_member:login()
    --local e = _http_params('2')
    local email = _http_params('email')
    local psw = _http_params('psw')

    local device_no = _http_params('device_no')
    local platform = _http_params('platform')

    print('before login:===', email, e, psw, platform, device_no)

    if platform and not in_array(platform, { 'windows', 'drawin', 'linux' }) then
        return self:renderJSON(nil, 'login fail:[0p]', -1)
    end

    if not _is_valid(device_no) or #device_no < 8 then
        device_no = nil
    end

    if not _is_valid(email, psw) then
        return self:renderJSON(nil, 'email or psw empty!', -1)
    end

    _cw_package = _new_model('member')

    local member = _cw_package:findFirstBy('email', email)
    if not member or member.password ~= md5(psw) then
        return self:renderJSON(nil, 'login fail:' .. md5(psw), -1)
    end

    member.last_at = _time()

    -- get current member id
    --local member_id = self:currentMemberId()
    local member_id = member.id

    -- generate sid [生成sid]
    local _Sid = _new_model('sid')

    local json = member:toJson()
    local sid = _Sid:generateSid(member_id)
    member.sid = sid

    local device_id
    if device_no then
        local _Device = _new_model('device')
        local device = _Device:findFirstBy('device_no', device_no)
        if _is_valid(device) then
            -- update last login time [更新这个设备的最后登录时间]
            device.last_at = _time()
            device.member_id = member_id
            device.sid = sid
            -- a platform can not be change after record to DB
            if device.platform ~= platform then
                return self:renderJSON(nil, 'fail[03]', -1)
            end
            device:save()

            device_id = device.id
            -- update member's device_id
            member.device_id = device.id
        else
            _Device.sid = sid
            _Device.platform = platform
            _Device.device_no = device_no
            _Device.created_at = _time()
            _Device.member_id = member_id
            _Device.last_at = _time()
            _Device.ip = _http_ip()
            _Device.status = 1
            _Device:save()

            device_id = _Device.id
            -- update member's device_id
            member.device_id = _Device.id
        end
    end


    -- if sid have device_id ,then it is single login or it is mulit login [sid 有设备id表示只能单点登录，单点登录会互相挤掉线，否则就是多端登录]
    -- if not get prams of device_no,just new instance of sid[没有设备号参数，新加入一个sid实例]
    local sidWhere = ''
    if device_id then
        sidWhere = ' device_id="' .. device_id .. '"'
    else
        sidWhere = ' device_id is null'
    end

    local old_sid = _Sid:findFirst({ conditions = 'member_id=' .. member_id .. ' and ' .. sidWhere })

    if _is_valid(old_sid) then
        old_sid.sid = sid
        old_sid:save()
    else
        _Sid.member_id = member_id
        _Sid.sid = sid
        if device_id then
            _Sid.device_id = device_id
        end
        _Sid.created_at = _time()
        _Sid:save()
    end

    member:save()

    json.sid = sid
    return self:renderJSON(json, '')
end

return _extend(class_member, "controller.api.base")