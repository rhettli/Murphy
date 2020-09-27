-- 继承model

local _M = {}

function _M:new(o)
    o = o or {}

    return self
end


_M.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }

function _M:beforeSave()
    print('before save...')
end

function _M:afterSave()

    print('after save...')
end

function _M:toJson()
    return {
        id = self.id,
    }
end

return _extend(_M, 'lib.model', 'im_msg')