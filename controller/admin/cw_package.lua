local _M = {  }

function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function _M:update()
    local id = http_params('id')
    assert(is_valid(id), 'no id')

    local _cw_package = _new_model('cw_package')

    local new_cw_package = _cw_package:findFirstById(http_params('id'))
    if is_valid(new_cw_package) then
        self:assign(new_cw_package, 'cw_package')
        print(json_encode(new_cw_package))
        new_cw_package:save()
    end

    return self:renderJSON()
end

function _M:create()

end

function _M:edit()
    local id = http_params('id')
    assert(is_valid(id), 'no id')

    local Member = _new_model('cw_package')

    local member = Member:findFirstById(http_params('id'))

    print('member edit:=====', json_encode(member))
    print('member STATUS_TEXT:=====', member.STATUS_TEXT)

    self:view('cw_package', member):render("admin.cw_package.edit")

end

function _M:index()
    _cw_package = _new_model('cw_package')

    local cond = self:getConditions('cw_package');
    print('got conditions:==', json_encode(cond))

    local page = http_params('page')
    page = page ~= "" and page or 1
    local res = _cw_package:findPagination(cond, page * 1, 30)

    self:view('cw_packages', res):render("admin.cw_package.index")
end

return _extend(_M, "controller.admin.base")