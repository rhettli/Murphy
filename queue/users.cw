
local q_user = {
}

function q_user:new(o, params)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.params = params
    return o
end


function q_user:sendGift(p)
    return http_params(p)
end

return q_user