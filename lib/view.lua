local _M = {}

function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.view = {}

    return o
end

function _M:findNext(flag, i)
    for n = i, #self.arr, 1 do
        local index = str_index(item, flag)
        if index >= 0 then
            return index
        end
    end
end


-- Todo write tpl to static file
function _M:render(tpl)
    http_header('Content-Type', 'text/html;charset=utf-8')

    -- todo 根据controller动态加载目录

    tpl = _str_replace(tpl, ".", "/") .. '.volt'

    local view_file = _DIR .. '/view/' .. tpl
    local f = _file_get_contents(view_file)
    if not f then
        assert(false, 'view not exist:' .. view_file)
    end

    if http_header('x-requested-with') ~= 'XMLHttpRequest' then
        parent_tpl = _DIR .. '/view/layouts/' .. str_sub_to_right(tpl, '/') .. '.volt';
        local admin_content = _file_get_contents(parent_tpl)
        admin_content = _str_split(admin_content, '{{#content#}}')
        f = admin_content[1] .. f .. admin_content[2]
    end

    self.arr = _str_split(f, "\n")

    local str = ""
    local if_count = 0
    local macro_count = ''
    local macro = {} -- macro defined code list
    local ignore = false
    local contact = false
    local item = ""
    for i, item1 in ipairs(self.arr) do
        --out(contact, item, item1, "--------------------------")
        if contact then
            item = item .. item1
            contact = false
        else
            item = item1
        end

        repeat

            local left_equal_flag_index = -1
            local left_express_flag_index = -1

            if item ~= "" and item ~= "\n" and item ~= "\r" then
                left_equal_flag_index = str_index(item, '{{')
                left_express_flag_index = str_index(item, '{%')
            else
                --out('no item:'..item)
            end

            local left_real_index = 0
            local right_real_index = 0

            local is_express = false

            if left_equal_flag_index > -1 or left_express_flag_index > -1 then
                if left_equal_flag_index > left_express_flag_index then
                    if left_express_flag_index >= 0 then
                        is_express = true
                        left_real_index = left_express_flag_index
                        right_real_index = str_index(item, '%}', left_real_index)
                    else
                        left_real_index = left_equal_flag_index

                        right_real_index = str_index(item, '}}', left_real_index)
                    end
                else
                    if left_equal_flag_index >= 0 then
                        left_real_index = left_equal_flag_index

                        right_real_index = str_index(item, '}}', left_real_index)
                    else
                        is_express = true
                        left_real_index = left_express_flag_index
                        right_real_index = str_index(item, '%}', left_real_index + 2)
                        --out('+++' .. right_real_index .. ':' .. item)
                    end
                end

                if right_real_index < 0 then
                    contact = true
                    --assert(false, "template format err:" .. item)
                end

                if contact == false then
                    -- match {% %}
                    if is_express then
                        --out(left_equal_flag_index .. ',' .. left_express_flag_index .. ',' .. left_real_index .. ',' .. right_real_index .. ' ' .. item)

                        local item_seq = str_sub(item, left_real_index + 2, right_real_index)

                        --if str_index(item_seq, '{%') > -1 then
                        --    --assert(false, '{% can in {%')
                        --end

                        local ind_end_if = str_index(item_seq, " endif")
                        local ind_if = str_index(item_seq, "if ")
                        if ind_end_if >= 0 and ind_if >= 0 and ind_end_if > ind_if then
                            print(item)
                            right_real_index = right_real_index - 2
                            item = _str_replace(item, 'endif', 'end')
                        elseif ind_end_if >= 0 then
                            -- end if
                            if_count = if_count - 1
                            item = _str_replace(item, 'endif', 'end')
                            right_real_index = right_real_index - 2

                        elseif ind_if >= 0 then
                            -- if
                            if_count = if_count + 1
                            --out('if ++' .. item .. ':' .. item_seq)

                        elseif str_index(item_seq, "endmacro ") >= 0 then
                            -- macro
                            if macro_count == '' then
                                assert(false, "macro defined err")
                            end
                            macro_count = ''
                            ignore = true
                        elseif str_index(item_seq, "macro ") >= 0 then
                            -- macro
                            if macro_count ~= '' then
                                assert(false, "macro defined err")
                            end
                            local f = _re_match(item, 'macro *(.*?)\\((.*?)\\)')
                            --print('f:=======',_json_encode(f))
                            macro_count = f[1][2]
                            macro[f[1][2]] = { param = f[1][3] } --{% macro edit(op) %}
                            ignore = true

                            --elseif macro_count ~= "" and str_index(item_seq, "endmacro ") < 0 and str_index(item_seq, "macro ") < 0 then
                            --    assert(false, "can not contain other {% %} flag in macro.")
                        elseif str_index(item_seq, "simple_form") >= 0 then
                            -- form
                            item = str_replace_re(item, 'simple_form\\((.*?),', 'simple_form\(data,"${1}",')
                            right_real_index = 7 + right_real_index
                        elseif str_index(item_seq, "simple_table") >= 0 then
                            -- form
                            item = str_replace_re(item, 'simple_table\\((.*?),', 'simple_table\(data,macro,"${1}",')
                            --out(item)
                            right_real_index = 13 + right_real_index
                        end

                        if true == ignore then
                            ignore = false
                        else
                            if left_real_index > 0 then
                                local r = str_sub(item, nil, left_real_index)
                                --out(r)
                                str = str .. 'out([[' .. r .. ']]);'
                            end

                            local r1 = str_sub(item, left_real_index + 2, right_real_index)
                            --out('++++', item,r1)
                            str = str .. r1 .. ';'
                        end

                        -- {% t.submit('保存') %}
                    else
                        -- {{ name }}
                        if macro_count ~= "" then
                            if macro[macro_count].code == nil then
                                macro[macro_count].code = '""'
                            end

                            --{% macro edit(op) %}
                            --用户Id:{{op.id}}
                            --用户昵称:{{op.name}}<br/>
                            --{% endmacro %}

                            if left_real_index > 0 then
                                local r = str_sub(item, nil, left_real_index)
                                --str = str .. 'out([[' .. r .. ']]);'
                                macro[macro_count].code = macro[macro_count].code .. '..[[' .. r .. ']]'
                            end

                            local r1 = str_sub(item, left_real_index + 2, right_real_index)
                            --str = str .. 'out(' .. r1 .. ');'
                            macro[macro_count].code = macro[macro_count].code .. '..(' .. r1..' or [[]])'

                        else
                            if left_real_index > 0 then
                                local r = str_sub(item, nil, left_real_index)
                                str = str .. 'out([[' .. r .. ']]);'
                            end

                            local r1 = str_sub(item, left_real_index + 2, right_real_index)
                            str = str .. 'out(data.' .. r1 .. ');'
                        end
                    end

                    item = str_sub(item, right_real_index + 2, nil)
                    --out('===' .. item)
                end

            else
                if contact == false then
                    if item ~= "\r" and item ~= '' and item ~= '\n' then
                        if macro_count ~= "" then
                            if macro[macro_count].code == nil then
                                macro[macro_count].code = '""'
                            end

                            macro[macro_count].code = macro[macro_count].code .. '..[[' .. item .. ']]'

                        else
                            str = str .. 'out([[' .. item .. ']]);'
                        end
                    end
                    item = ""
                end
            end
            str = str .. "\n"

        until item == "" or contact == true
    end
    -- if seg march
    if if_count ~= 0 then
        assert(false, 'if not match' .. if_count)
    end

    local macro_str = base64_encode(_json_encode(macro))

    str = 'return function (data) local macro=[[' .. macro_str .. ']];local simple_table=_import("lib.view_tpl.simple_table");' ..
            'local simple_form=_import("lib.view_tpl.simple_form");' .. str .. ' end'

    --out('', 'Render string:', str)

    local r = loadstring(str)()
    local t1, t2 = pcall(r, self.view)
    print('view done:', t1, t2)

    out('<!--', http_request('path'))
    out(http_request('host'))
    out(http_request('uri'))
    out(_http_params('member[email_eq]'))
    out(_http_params('member'))
    out(_http_params('email_eq'))
    --collectgarbage()
end

return _M
