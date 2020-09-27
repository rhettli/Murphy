local _M = {}

function _M:new(o)
    o = o or {}
    print('self:==', json_encode(self))

    --    self.__index = self
    --    setmetatable(self, o)
    --for k, v in pairs(o) do
    --    self[k] = v
    --end

    _merge_left(self, o)

    return self
end

function _M:getConditions(value_name)
    local tb = { conditions = '' }
    local params = http_params(value_name)
    local bind = {}
    local filter = { eq = '=', gte = '>=', gt = '>', lt = '<', lte = '<=', neq = '!=', like = 'like' }
    if 'table' == type(params) then
        for i, v in pairs(params) do
            if is_valid(v) then
                i = str_split(i, '_')[1]
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
    local params = http_params(value_name .. '[]')

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

function _M:view(name, data)
    if not self._view then
        self._view = _import('lib.view'):new()
    end

    self._view.view[name] = data
    return self
end

return _extend(_M, "lib.controller")
