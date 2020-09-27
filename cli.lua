--out(DIR, VENDOR)

print(_DIR, dir())

require('vendor.autoload')
require('lib.core')
require('conf.defined')

if is_cli() == false then
    print('error,mush cli can run cli cmd file')
    return
end

local arg = args()
if #arg < 1 then
    return
end

arg[1] = 'index'
arg[2] = 'admin'


-- task start
if arg[1] == "task" and arg[2] == "start" then

elseif arg[1] == "queue" then
    -- queue start
    local queue = _import('lib.queue')
    queue:new()
    if arg[2] == "start" then
        queue:start()
    elseif arg[2] == "status" then
        queue:status()
    elseif arg[2] == "exit" then
        queue:exit()
    end
elseif arg[1] == "index" and arg[2] == "admin" then
    file_in_folder(_DIR .. '/controller/admin', function(f, is_folder)
        f = str_replace(f, '\\', '/')
        local res = str_split(f, '/')
        --print(res[#res])
        local p_name = res[#res]
        p_name = str_split(p_name, '.')[1]
        if res[#res] ~= 'operator.lua' then
            return
        end
        if not is_folder then
            local content = file_get_contents(f)
            if is_valid(content) then
                local a_arr = str_split(content, '\n')
                local p = ''
                local i = {}
                local is_lock_item = ''
                for _, v in pairs(a_arr) do
                    print('v:================',v)
                    if not is_valid(p) then
                        print('p:================',p)
                        local r = re_match(v, '-- *?\\[P:(.+?)\\]')
                        if is_valid(r) then
                            print('===0', serialize(r))
                            p = r[2]

                            local op_permission = _new_model('operator_permission')
                            local omp = op_permission:findFirst({ conditions = 'p="' .. p_name .. '" and i is null' })
                            if not is_valid(omp) then
                                op_permission.p = p_name
                                op_permission.name = p
                                op_permission.created_at = time()
                                op_permission:save()
                            end
                        end
                    else
                        print('r:================')
                        local r = re_match(v, '-- *?\\[I:(.+?)\\]')
                        if is_valid(r) then
                            print('===1', serialize(r))
                            is_lock_item = r[2]
                        elseif is_valid(is_lock_item) then
                            --function _M:update()
                            local r1 = re_match(v, 'function.+?:(.+?)\\(')
                            print('is_lock_item:===',is_lock_item,v)
                            print(serialize(r1))

                            if is_valid(r1) then
                                print('===2', serialize(r1))

                                local op_permission = _new_model('operator_permission')
                                local omp = op_permission:findFirst({ conditions = 'p="' .. p_name .. '" and i="' .. r1[2] .. '"' })
                                if not is_valid(omp) then
                                    op_permission = _new_model('operator_permission')
                                    op_permission.p = p_name
                                    op_permission.i = r1[2]
                                    op_permission.name = is_lock_item
                                    op_permission.created_at = time()
                                    op_permission:save()
                                else
                                    print('omp2:')
                                end
                                is_lock_item = ''
                            end
                        end
                    end
                end
                print('=== end',p_name)
            end
        end
        --print(f, r)
    end)
end
