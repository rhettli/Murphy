local _M = {}

function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function _M:update()
    local id = _http_params('id')
    assert(_is_valid(id), 'no id')

    local Member = _new_model('member')

    local memberObj = Member:findFirstById(_http_params('id'))
    if _is_valid(memberObj) then
        self:assign(memberObj, 'member')
        print(_json_encode(memberObj))
        memberObj:save()
    end

    return self:renderJSON()
end

function _M:create()

end

function _M:edit()
    local id = _http_params('id')
    assert(_is_valid(id), 'no id')

    local v = _import('lib.view'):new()

    local Member = _new_model('member')

    local member = Member:findFirstById(_http_params('id'))
    v.view['member'] = member

    print('member edit:=====', _json_encode(member))
    print('member STATUS_TEXT:=====', member.STATUS_TEXT)

    v:render("admin.member.edit")
end

function _M:index()
    _cw_package = _new_model('member')

    local v = _import('lib.view'):new()

    --local cond= self:assign()

    local cond = self:getConditions('member');
    print('got conditions:==', _json_encode(cond))

    local page = _http_params('page')
    page = page or 1
    print('page:==', page)
    local res = _cw_package:find_pagination(cond, page * 1, 30)

    v.view['members'] = res

    v:render("admin.member.index")

end

return _extend("controller.admin.base")