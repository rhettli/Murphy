local pairs = pairs
local assert = assert
local print = print
local pcall = pcall
local escape = escape
local is_valid = is_valid
local json_decode = json_decode
local rtrim = rtrim
local str_pos = str_pos
local file_exist = file_exist

local _import = _import
local _new_model = _new_model
local _DIR = _DIR

local M = {}

function M:new(o, _table)
    o = o or {}
    --    setmetatable(self,o)
    --    self.__index = self

    self.snap = {}

    self.__index = function(a, f)

        print('==index==:', f)
        local arr = _str_split(f, '_')
        local lens = #arr
        local r

        if 'id' == arr[1] or 'id' == arr[lens] then
            return
        end

        if #arr > 1 then
            if arr[lens] == 'text' then
                local filed = arr[lens - 1]
                local item = tonumber(o[filed])
                r = o[str_to_upper(arr[lens - 1]) .. '_TEXT'][item]
                --print('text inner:', _json_encode(r))
            elseif arr[lens] == 'array' then
                r = o[str_to_upper(arr[lens - 1]) .. '_TEXT']
                print('==index== array inner:', _json_encode(r))
            elseif arr[lens] == 'time' then
                r = date('Y-m-d H:i:s', o[join(table_sub_to_right(arr, lens - 1), '_')])
                --print('time:==', o[join(table_sub_to_right(arr, lens - 1), '_')])
            elseif arr[lens] == 'model' then

            elseif lens > 3 and arr[lens - 2] == 'sub' then
                -- username_sub_0_12
                r = str_sub(o[join(table_sub_to_right(arr, lens - 3), '_')], arr[lens - 1], arr[lens])
            elseif lens > 2 and arr[lens - 1] == 'sub' then
                -- username_sub_0
                r = str_sub(o[join(table_sub_to_right(arr, lens - 2), '_')], 0, arr[lens - 1])
            else
                --local obj_id = o[join(table_sub_to_right(arr, lens - 1), '_') .. '_id']
                --print('==index== obj:==', obj_id)
                --if obj_id then
                --    return _new_model(self._table):new():findById(obj_id)
                --end
            end
        else

            local obj_id = o[arr[1] .. '_id']
            print('==index== obj:==', obj_id)
            if obj_id then
                return _new_model(self._table):new():findById(obj_id)
            end

        end
        print('==index== __r:==', a, f, r)

        return r
    end

    if _table then
        self._table = _table
        local metadata_file = _DIR .. '/runtime/metadata/' .. self._table .. '.lua'
        if not file_exist(metadata_file) then
            local c = _import('lib.db'):new()
            if c.db ~= nil then
                local fieldType = function(t)
                    if str_pos(t, 'char') > -1 or str_pos(t, 'text') > -1 then
                        return 'text'
                    elseif str_pos(t, 'int') > -1 or str_pos(t, 'decimal') > -1 or str_pos(t, 'double') > -1 or str_pos(t, 'float') > -1
                            or str_pos(t, 'long') > -1 or str_pos(t, 'numeric') > -1 then
                        return 'number'
                    else
                        return t
                    end
                end
                --  show create table
                local tbl_struct = {}
                --local ind = 1
                pcall(function()
                    c:query(' desc  ' .. _table, function(res_)
                        local name = res_.Field
                        --print('call back:', _json_encode(res_), "\n")
                        tbl_struct[name] = {}
                        tbl_struct[name].type = fieldType(res_.Type)
                        tbl_struct[name].name = name
                    end)
                end)
                c:close()

                if tbl_struct then
                    local ser = 'return [[' .. serialize(tbl_struct) .. ']]'
                    local e = file_put_contents(metadata_file, ser)
                    local ff = _DIR .. '/runtime/metadata'
                    if not e and not file_exist(ff) then
                        print('write file fail,try to create folder and try again')
                        mkdir(_DIR .. '/runtime')
                        local e, r = mkdir(ff)
                        print('mkdir:==', e, r)
                        e = file_put_contents(metadata_file, ser)
                        print('file_write again:==', e)
                        assert(e, 'can not mkdir :' .. ff)
                    end
                end
                print("sql id count:", tbl_struct)
            else
                print("connect mysql fail", err)
            end

            print('not exists:', self._table)
        end
    end

    for i, v in pairs(self) do
        if not o[i] then
            o[i] = v
        end
    end

    -- setmetatable behind data transfer
    setmetatable(o, self)

    --o = self
    return o
end

function M:checkValue(val, type_)

    print('checkValue:==', val, type(val), type_)

    assert(type(val) ~= 'table', _json_encode(val))

    if 'number' == type_ then
        return tonumber(val)
    elseif 'text' == type_ then
        return '"' .. escape(val or '') .. '"'
    else
        return '"' .. escape(val or '') .. '"'
    end
end

--Todo here can use require,use lua file instead json file.
function M:metatable()
    if self._metatable ~= nil then
        return self._metatable
    end

    local rmt = _import('runtime.metadata.' .. self._table) -- json_decode(_file_get_contents(_DIR .. '/runtime/metadata/' .. self._table))
    assert(rmt, 'metadata not find')
    self._metatable = unserialize(rmt)
    return self._metatable
end

function M:old(filed)
    return self.snap[filed]
end

-- 异步执行代码
function M:async(delay, params)
    _stack()
end

function M:_doSave()
    local metadata_file = self:metatable()
    --out(metadata_file)
    local insert = 'insert %s(%s)values(%s)';
    local field = ''
    local values = ''
    for key, v in pairs(metadata_file) do
        if key ~= 'id' then
            local val = self[key] or ''
            if val ~= '' then
                field = field .. '`' .. key .. '`'
                values = values .. self:checkValue(val, v.type) --v.type
                field = field .. ','
                values = values .. ','
            end
        end
    end

    insert = string.format(insert, self._table, rtrim(field, ','), rtrim(values, ','))
    print(insert)

    _import('lib.db'):new():with(function(c)
        c:query(insert, function(res_)
            --out('call back:', res_, "\n")
        end)
        c:query('select last_insert_id() as id;', function(res_)
            self['id'] = res_.id
            print('call back:', self['id'], "\n")
        end)
    end)             :close()

    return true
end

function M:_doUpdate(p)
    local metadata_file = self:metatable()
    --out(metadata_file)
    local update = 'update %s set %s where id=%s';
    local field = ''
    --local values = ''
    for i, v in pairs(metadata_file) do
        print(i, v)
        if i ~= 'id' then
            print("n o:==", self:checkValue(self[i], v.type), self:checkValue(self:old(i), v.type))
            local res = self:checkValue(self[i], v.type)
            if res ~= self:checkValue(self:old(i), v.type) then
                field = field .. '`' .. i .. '`=' .. res .. ',' --v.type
            end
        end
    end

    if field == '' then
        return true
    end

    update = string.format(update, self._table, rtrim(field, ','), self.id)
    print('_doUpdate:==', update)

    _import('lib.db'):new():with(function(c)
        if c ~= nil then
            c:query(update, function(res_)
                --print('call back:', res_, "\n")
            end)
        end
    end)             :close()

    if not e then
        return false
    end

    local _reds = redis_cache0()    -- _import('lib.redis'):new()
    _reds:with(function(rds)
        local r = rds:exec('EXPIRE', '__model_cache' .. self._table .. self.id, 0)
        print('EXPIRE:==', r)
    end) :close()

    if not e then
        return false
    end

    return true
end

-- todo 插入的值要防止sql注入
function M:save()
    --    assert(obj, 'need self instance')

    print(' self.beforeSave:===', self.beforeSave)
    if self.beforeSave then
        self:beforeSave()
    end

    if _is_valid(self.id) then
        if not self:_doUpdate() then
            return false
        end
    else
        if not self:_doSave() then
            return false
        end
    end

    print('asave:===', self.afterSave)
    if self.afterSave then
        self:afterSave()
    end

    return true
end

function M:_render(res_)
    local mod = self:new(nil, self._table)
    for k, p in pairs(res_) do
        for i, v in pairs(self:metatable()) do
            if v.name == k then
                --out(v,k,p)
                if 'number' == v.type then
                    mod[v.name] = p * 1
                elseif 'text' == v.type then
                    mod[v.name] = p
                else
                    mod[v.name] = p
                end
            end
        end
    end
    return mod
end

function M:findFirstById(id)
    return self:findFirstBy('id', id)
end

function M:findFirstBy(filed, val)
    assert(filed, 'findFirsBy params $1 empty')
    assert(val, 'findFirsBy params $2 empty')
    local binds = {}
    binds[filed] = val
    print('findFirstBy:==', _json_encode(binds), filed, val)

    local ids = self:_query({ columns = 'id', conditions = filed .. "=:" .. filed .. ':', bind = binds })

    local res = self:findByIds(ids)
    if not res[1] then
        return nil
    end

    print('+++table:==', self._table)
    local mod = _new_model(self._table)  --self:new(nil, self._table)

    for i, v in pairs(res[1]) do
        mod[i] = v
    end

    --print(_json_encode(mod))
    --print('get status_text:==', mod.status_text)
    --print(mod.__index({}, 'status_text'))
    return mod
end

function M:delete(p)
    if self.beforeDelete then
        self:beforeDelete()
    end
    local c = self:db()
    if c ~= nil then
        c:query('delete ' .. self._table .. ' where id=' .. self.id, function(res_)
            out('call back:', res_, "\n")
        end)
    end
    c:close()
    if self.afterDelete then
        self:afterDelete()
    end
    return true
end

function M:update(p)
    return self:save(p)
end

function M:_toObj(ars)
    local rt = {}
    print(_json_encode(ars))
    for _, v in pairs(ars) do
        local mod = _new_model(self._table)
        mod.snap = v
        for n, m in pairs(v) do
            mod[n] = m
        end
        rt[#rt + 1] = mod
    end
    return rt
end

function M:findByIds(ids)
    local prefix = self._table
    local not_find_ids = {}
    local rt = {}
    local ids_list = ''

    -- use redis cache or not
    local _reds = redis_cache0()  -- _import('lib.redis'):new()

    local fc = function()
        if _reds then
            print("findByIds:==", _json_encode(ids))
            for _, id in pairs(ids) do
                local res = _reds:exec('get', '__model_cache' .. prefix .. id)
                if _is_valid(res) then
                    rt[#rt + 1] = json_decode(res)
                else
                    not_find_ids[id] = { i = #rt + 1 }
                    rt[#rt + 1] = 0
                    ids_list = ids_list .. id .. ','
                end
            end
        else
            print('Alert: not use redis cache,you must use redis for db cache to improve performence')
            for _, id in pairs(ids) do
                not_find_ids[id] = { i = #rt + 1 }
                rt[#rt + 1] = 0
                ids_list = ids_list .. id .. ','
            end
        end

        if ids_list ~= '' then
            local second_finds = self:_query({ conditions = 'id in (' .. rtrim(ids_list, ',') .. ')' })
            if #second_finds > 0 then
                for _, item in pairs(second_finds) do
                    if _reds then
                        local res = _reds:exec('SETEX', '__model_cache' .. prefix .. item.id, 7200, _json_encode(item))
                        print('set to cache:', res)
                    end

                    rt[not_find_ids[item.id].i] = item
                end
            end
        end
    end

    pcall(fc)

    if _reds then
        _reds:close()
    end

    return self:_toObj(rt)
end

function M:findById(id)
    return self:findByIds({ id })[1] or {}
end

--分页查找
function M:findPagination(cond, page, per_page)
    per_page = per_page or 20
    page = page or 1
    if per_page > 10000 then
        assert(false, 'you can not render to much rows')
    end

    local total_entries

    if _is_valid(cond['conditions']) then
        total_entries = self:_query({ columns = 'count(id) as num', conditions = cond['conditions'], bind = cond['bind'] });
    else
        total_entries = self:_query({ columns = 'count(id) as num' });
    end
    total_entries = total_entries[1].num

    local offset = (page - 1) * per_page;
    local new_cond = array_merge(cond, { columns = 'id', limit = { number = per_page, offset = offset } })
    local ids = self:_query(new_cond)
    local res = self:findByIds(ids)
    --print("find_pagination:===", _json_encode(res))

    return {
        entry = res,
        total = total_entries,
        per_page = per_page,
        page = page,
        len = function()
            return #res
        end,
        each = function(callBack)
            assert(callBack, 'each need a callback func')
            for i, v in pairs(res) do
                callBack(i, v)
            end
        end
    }
end

function M:count(cond)
    return _import('lib.db'):new():withClose(function(c)
        cond = cond or {}
        local conditions = cond.conditions or ''
        local bind = cond.bind
        if bind and #bind > 0 then
            for i, v in pairs(bind) do
                conditions = _str_replace(conditions, ':' .. i .. ':', v)
            end
        end
        if _is_valid(conditions) then
            conditions = ' where ' .. conditions
        end
        local sql = 'select count(id) as num from ' .. self._table .. conditions
        print('count sql:' .. sql)
        local num = 0
        c:query(sql, function(res_)
            num = res_.num
        end)
        c:close()
        print('count:==' .. num)
        return num
    end)
end

--  find all rows
--  avoid use this function,you should use findPagination instead
--  cond = { conditions = 'id>10 and created_at> :created_at: ', order = 'id desc', bind = { created_at = _time() } }
function M:find(cond)
    cond = cond or {}
    local ids = self:_query({ conditions = cond.conditions, bind = cond.bind, columns = 'id' })
    if ids and #ids > 0 then
        local objs = self:findByIds(ids)
        return objs
    end
    return nil
end

--  find first rows
--  avoid use this function,you should use findPagination instead
--  cond = { conditions = 'id>10 and created_at> :created_at: ', order = 'id desc', bind = { created_at = _time() } }
function M:findFirst(cond)
    cond = cond or {}
    local ids = self:_query({ conditions = cond.conditions, bind = cond.bind, columns = 'id', limit = 1 })
    if ids and #ids > 0 then
        print(_json_encode(ids))
        local objs = self:findByIds(ids)
        print(_json_encode(objs))
        return objs[1]
    end
    return nil
end

function M:_query(cond)
    if type(cond) ~= 'table' then
        return
    end

    local conditions = cond.conditions or ''
    local order = cond.order or ''
    local bind = cond.bind
    local limit = cond.limit or ''
    local filed = cond.columns or '*'

    print('find cond:==', _json_encode(cond))

    if _is_valid(limit) then
        if type(limit) ~= "table" then
            limit = { number = limit, offset = 0 }
        end
        limit = ' limit ' .. tonumber(limit.offset) .. ',' .. tonumber(limit.number)
    end
    local res = {}
    _import('lib.db'):new():with(function(c)
        print('_is_valid(conditions) ===', _is_valid(conditions))
        if _is_valid(conditions) then
            if _is_valid(bind) then
                print('====================1')
                local metadata_file = self:metatable()
                for i, v in pairs(bind) do
                    print('+++++++++++++++++++', i, v)
                    conditions = _str_replace(conditions, ':' .. i .. ':', self:checkValue(v, metadata_file[i].type))
                end
            else
                print('====================')
            end
            conditions = ' where ' .. conditions
        end

        if _is_valid(order) then
            order = ' order by ' .. escape(order)
        end

        -- here just find id ,and resolve all data from redis
        print('query:===', filed, self._table, conditions, order, _json_encode(limit))
        local sql = 'select ' .. filed .. ' from ' .. self._table .. conditions .. order .. limit
        print('Exec sql:==', sql)
        if 'id' == filed then
            c:query(sql, function(res_)
                res[#res + 1] = res_.id
            end)
        else
            c:query(sql, function(res_)
                res[#res + 1] = res_
            end)
        end
    end)             :close()

    return res
end

return M
