-- 继承model

local _M = {}

function _M:new(o)

    return self
end

function _M:beforeSave()
    print('before save...')
end

function _M:afterSave()

    print('after save...')
end

return _extend(_M, 'lib.model', 'operator_permission')
