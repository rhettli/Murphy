local _M = { }

function _M:new()
    self. model_name = 'cw_version'

    return self
end

function _M:beforeUpdate()

end

function _M:beforeEdit()

end

function _M:beforeCreate()

end
function _M:beforeIndex()
    print('===index before===')
end

return _extend(_M, "controller.admin.base")