local _M = {}

function _M:new(o)
    o = o or {}
    print('self:==', _json_encode(o))
    print('self:==', _json_encode(self))

    o = o:new()

    _merge_left(self, o)

    return self
end

function _M:a()
    print('aa')
end

function _M:getConditions(value_name)
    local tb = { conditions = '' }
    local params = _http_params(value_name)
    local bind = {}
    local filter = { eq = '=', gte = '>=', gt = '>', lt = '<', lte = '<=', neq = '!=', like = 'like' }
    if 'table' == type(params) then
        for i, v in pairs(params) do
            if _is_valid(v) then
                i = _str_split(i, '_')[1]
                tb.conditions = tb.conditions .. ' ' .. i .. filter[#i] .. ':' .. v .. ': and'
                bind[i] = v
            end
        end
    end
    tb.conditions = rtrim(tb.conditions, 'and')
    tb.bind = bind
    return tb
end

function _M:assign(object, value_name)
    local params = _http_params(value_name .. '[]')

    assert('table' == type(params), 'params must model table')

    for i, v in pairs(params) do
        object[i] = v
    end
end

function _M:render(tpl, dt)
    if not self._view then
        self._view = _import('lib.view'):new()
    end
    if dt then
        self._view = dt
    end
    self._view:render(tpl)
end

function _M:update()
    local id = _http_params('id')
    assert(_is_valid(id), 'no id')

    local _model = _new_model(self.model_name)

    local model = _model:findFirstById(_http_params('id'))
    if _is_valid(model) then
        self:assign(model, self.model_name)

        self:_beforeUpdate(model)

        model:save()
    end
    return self:renderJSON()
end

function _M:create()

end

function _M:edit()
    local id = _http_params('id')
    assert(_is_valid(id), 'no id')

    local new_model = _new_model(self.model_name)

    local model = new_model:findFirstById(_http_params('id'))

    self:_beforeEdit(model)

    self:view(self.model_name, model):render('admin.' .. self.model_name .. '.edit')
end

-- suggest overwrite
function _M:_beforeUpdate(model)
end
-- suggest overwrite
function _M:_beforeEdit(model)
end
-- suggest overwrite
function _M:_beforeIndex(model)
end

function _M:index()
    print(self.model_name)
    _cw_package = _new_model(self.model_name)

    local cond = self:getConditions(self.model_name);
    print('got conditions:==', _json_encode(cond))

    local page = _http_params('page')
    page = page == '' and 1 or page
    local res = _cw_package:findPagination(cond, page * 1, 30)

    self:_beforeIndex(res)

    self:view(self.model_name .. 's', res):render("admin." .. self.model_name .. ".index")
end

function _M:view(name, data)
    if not self._view then
        self._view = _import('lib.view'):new()
    end

    self._view.view[name] = data
    return self
end

return _extend(_M, "lib.controller")
