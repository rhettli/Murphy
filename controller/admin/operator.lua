local _M = {}

-- here defined the operator permission item use []  (使用[]来定义一个权限)
-- use p: I: (使用P: 开头表示权限类，I:开头表示权限类中的项目)

-- [P:operator|管理员]
function _M:new()
    return self
end

function _M:a()
    print('bb')
end

-- [I:update|更新]
function _M:update()
    local id = http_params('id')
    assert(is_valid(id), 'no id')

    local Member = _new_model('operator')

    local memberObj = Member:findFirstById(http_params('id'))
    if is_valid(memberObj) then
        self:assign(memberObj, 'member')
        print(json_encode(memberObj))
        memberObj:Save()
    end

    return self:renderJSON()
end

-- [I:create|更新]
function _M:create()
end

-- [I:edit|更新]
function _M:edit()
    local id = http_params('id')
    assert(is_valid(id), 'no id')

    local _operator = self:model('operator')
    print('model new:=', json_encode(_operator))

    local operator = _operator:findFirstById(id)

    assert(operator, 'not find member with id:' .. id)

    self:view('operator', operator):render("admin.operator.edit")
end

function _M:loginAction()

    local username = http_params('username');
    local password = http_params('password');

    local ip = http_ip()

    Operators = _new_model('model.operators')

    local operator = Operators:findFirst()

    if not is_valid(operator) then
        operator = Operators:new();
        operator.username = 'admin';
        operator.password = md5(password);
        operator.password_updated_at = time();
        operator.status = 1;
        operator.role = 'admin';
        operator.ip = ip;
        operator.created_at = time();
        operator.updated_at = time();
        operator.save();
    end

    operator = Operators:findFirstBy('username', username)


    -- //        echoLine(Operators :: findFirstByUsername('admin'));
    -- //        echoLine(Operators ::findFirstById(1));

    if not is_valid(operator) or md5(password) ~= operator.password then
        http_session('operator_psw', '');
        return self:renderJSON({}, '用户不存在或密码不正确');
    end

    if (operator.isBlocked()) then
        http_session('operator_psw', '');
        return self:renderJSON({  }, '帐号被禁用');
    end

    operator.ip = ip;
    operator.active_at = time();
    operator:update();

    --if (class_exists('OperatorLoginHistories')) {
    --    OperatorLoginHistories :: record(operator, ip);
    --}

    http_session('operator_id', operator.id);

    --this.session.set('operator_login_ip', ip);

    if (time() - operator.password_updated_at > 3600 * 24 * 30) then
        http_redirect('/admin/home/reset_password')
    end

    http_session('operator_md5', operator.md5);

    http_redirect('/admin/dashboard')

end

-- [I:list|列表页]
function _M:index()

    local cond = self:getConditions('operator');
    print('got conditions:==', json_encode(cond))

    local page = http_params('page') or 1
    page = page == '' and 1 or page

    local m = self:model('operator')
    print(m.member)
    local res = m:findPagination(cond, page * 1, 30)

    self:view('operators', res):render("admin.operator.index")
end

return _extend(_M, "controller.admin.base")
