local _M = {}

-- here defined the operator permission item use []  (使用[]来定义一个权限)
-- use p: I: (使用P: 开头表示权限类，I:开头表示权限类中的项目)

-- [P:operator|管理员]
function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

-- [I:update|更新]
function _M:update()
    local id = _http_params('id')
    assert(_is_valid(id), 'no id')

    local Member = _new_model('operator_permission')

    local memberObj = Member:findFirstById(_http_params('id'))
    if _is_valid(memberObj) then
        self:assign(memberObj, 'member')
        print(_json_encode(memberObj))
        memberObj:Save()
    end

    return self:renderJSON()
end

-- [I:create|更新]
function _M:create()
end

-- [I:edit|更新]
function _M:edit()
    local id = _http_params('id')
    assert(_is_valid(id), 'no id')

    local _operator = self:model('operator_permission')
    print('model new:=',_json_encode(_operator))

    local operator = _operator:findFirstById(id)

    assert(operator, 'not find member with id:' .. id)

    self:view('operator_permission', operator):render("admin.operator.edit")
end

-- [I:list|列表页]
function _M:index()

    local cond = self:getConditions('operator_permission');
    print('got conditions:==', _json_encode(cond))

    local page = _http_params('page') or 1

    local m = self:model('operator_permission')
    print(m.member)
    local res = m:findPagination(cond, page * 1, 30)

    self:view('operator_permissions', res):render("admin.operator.index")
end

return _extend(_M, "controller.admin.base")
