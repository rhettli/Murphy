-- 继承model

local _M = _extend('lib.model', 'users')

function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.version = "1"
    return o
end

function _M:run()
    out('self.vendor')
end

function _M:index()
    local op = _request:get("l")
    out(op, "\n")
    --out('hello world!')

    local gorm = require('gorm')
    c = gorm.new()
    local ok, err = c:open("mysql", "root:my-secret-pw@(localhost)/wooyri?charset=utf8&parseTime=True&loc=Local")
    if ok then
        local sql_id_count = 0
        c:query('SELECT * FROM wooyri.users ', function(res_)
            out('call back:', res_)
            sql_id_count = sql_id_count + res_.id
        end)
        out("sql id count:", sql_id_count)
    else
        out("connect mysql fail" .. err)
    end
end

return _M