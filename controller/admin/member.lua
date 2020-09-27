local _M = {}

-- [P:member|用户成员]
function _M:new()
    self.model_name = 'member'

    return self
end

--[I:update/更新|update]
--[I:create/创建|create]
--[I:edit/编辑|edit]
--[I:list/列表页面|index]

return _extend(_M, "controller.admin.base")

