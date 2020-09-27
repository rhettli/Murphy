-- 继承model

local _M = {}

function _M:new(o)
    o = o or {}
    --setmetatable(o, self)
    --self.__index = self
    -- use for edit page:/admin/member/edit
    self.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }
    self.SEX_TEXT = { [1] = '男', [2] = '女', [0] = '未知' }

    return self
end


--_M.STATUS_TEXT = { [1] = '有效', [2] = '已禁用' }

function _M:beforeSave()
    print('before save...')
end

function _M:afterSave()

    print('after save...')
end

function _M:toJson()
    return {
        id = self.id,
        nickname = self.nickname,
        email = self.email
    }
end

function _M:p123()
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

return _extend(_M, 'lib.model', 'member')
