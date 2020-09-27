local _M = { }

function _M:new(o, params)
    params = params or {}

    --self.__index = self

    o = o or {}
    _merge_left(o, self)
    setmetatable(o, self)
    return o
end

function _M:model(name)
    return _new_model(name)
end

function _M:renderJSON(arr, msg, code)
    print(arr, msg, code)

    arr = arr or {}
    http_header('Content-Type', 'application/json')
    out({ msg = msg or arr.msg or '', data = arr.data or arr, code = code or arr.code or 0 })

end

return _M
