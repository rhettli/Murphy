-- 继承model

local _M = {}

function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    -- use for edit page:/admin/member/edit
    self.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }

    return o
end

--_M.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }

function _M:toJson()
    return {
        id = self.id,
        nickname = self.nickname,
        email = self.email
    }
end

return _extend(_M, 'lib.model', 'operator_role')
