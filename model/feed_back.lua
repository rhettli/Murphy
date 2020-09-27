-- 继承model

local _M = {}

function _M:new(o)
    o = o or {}
    --setmetatable(o, self)
    --self.__index = self
    -- use for edit page:/admin/member/edit

    return self
end

_M.STATUS_TEXT = { [0] = '待审核', [1] = '有效', [2] = '已禁用' }

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

return _extend(_M, 'lib.model', 'feed_back')
