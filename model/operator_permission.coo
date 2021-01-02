-- 继承model

local _M = {}

function _M:new(o)

    return self
end

function _M:_beforeSave()
    print('before save...')
end

function _M:_afterSave()

    print('after save...')
end

return _extend(_M, 'lib.model', 'operator_permission')
