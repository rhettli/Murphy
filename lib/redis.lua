local _M = {
}
-- redis or ssdb cache instance
function _M:new(point)

    --local o = o or {
    --setmetatable(o, self)
    --self.__index = self
    --self.__call = with

    self.rds = 0
    self:_connect(point)
    if not self.rds then
        return nil
    end

    return self
end

function _M:_connect(point)
    local redis = require('redis'):new()
    local conf = _import('conf.conf')
    local res = redis:open(conf[point].addr, conf[point].addr.psw, conf[point].addr.db)
    if res then
        self.rds = redis
    else
        self.rds = nil
        print('connect to redis fail')
    end
end

-- only exec one times
function _M:with(fc)
    assert(type(fc) == 'function', 'with params #1 must a function.')

    self.e, self.r = pcall(fc, self.rds)

    return self
end

function _M:exec(...)
    return self.rds:exec(...)
end

function _M:eval(...)
    return self.rds:eval(...)
end

function _M:close()
    if not self.rds then
        return
    end
    local r = self.rds:close()
    self.rds = nil
    return r
end

return _M