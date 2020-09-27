local _M = {  }

function _M:new()
    self. model_name = 'cw_package'

    return self
end


return _extend(_M, "controller.admin.base")