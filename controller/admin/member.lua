local _M = {}

-- [P:member|用户成员]
function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

-- [I:update|更新]
function _M:update()
    local id = http_params('id')
    assert(id, 'no id')

    local Member = _new_model('member')

    local memberObj = Member:findFirstById(http_params('id'))
    if is_valid(memberObj) then
        self:assign(memberObj, 'member')
        print(json_encode(memberObj))
        memberObj:save()
    end

    return self:renderJSON()
end

--[I:create|创建]
function _M:create()

end

--[I:edit|编辑]
function _M:edit()
    local id = http_params('id')
    assert(is_valid(id), 'no id')

    local _Member = _new_model('member')

    local member = _Member:findFirstById(id)

    assert(member, 'not find member with id:' .. id)

    self:view('member', member):render("admin.member.edit")
end

--[I:list|首页]
function _M:index()

    _cw_package = self:model('member')

    local cond = self:getConditions('member');
    print('got conditions:==', json_encode(cond))

    local page = http_params('page') or 1
    if  not is_valid(page) then
        page=1
    end

    print('page',page)

    local res = _cw_package:findPagination(cond,  page*1, 30)

    self:view('members', res):render("admin.member.index")

end

return _extend(_M, "controller.admin.base")

