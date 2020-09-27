local _M = {}

function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    --self.__call = with
    self.db = 0
    self:_connect()
    return o
end

function _M:_connect()
    local gorm = require('gorm')
    local c = gorm.new()
    local conf = _import('conf.conf')
    local ok, err = c:open(conf.database.adapter, conf.database.conn)
    print(ok, err)
    if ok then
        print('mysql ok')
        self.db = c
    else
        self.db = nil
    end
end

-- only exec one times
function _M:with(fc)

    assert(type(fc) == 'function', 'params #1 must function')
    assert(self.db, 'db connect fail')
    local e
    e, self.r = pcall(fc, self.db)

    assert(e, 'db exec fail' ..( self.r or ''))
    return self
end

function _M:withClose(fc)
    self:with(fc)
    self.db:close()
    return self.r
end

function _M:query(...)
    return self.db:query(...)
end

function _M:close()
    if not self.db then
        return
    end
    local r = self.db:close()
    self.db = nil
    return r
end

return _M