local _M = {  }

-- [P:article|文章]
-- [I:update/更新|update]
-- [I:create/创建|create]
-- [I:edit/编辑|edit]
-- [I:list/列表页面|index]

function _M:new()
    self. model_name = 'article'

    return self
end


return _extend(_M, "controller.admin.base")
