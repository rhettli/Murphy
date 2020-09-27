-- 继承model

local _M = {}

function _M:new(o)
    o = o or {}
    --setmetatable(o, self)

    --_merge(self,o)

    self.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }

    return self
end

--_M.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }

function _M:toJson()
    return {
        id = self.id,
        nickname = self.nickname,
        email = self.email
    }
end

return _extend(_M, 'lib.model', 'operator')
