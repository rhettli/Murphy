--[ 'admin', device ], ['class':'ajax_model_form']

return function(data, obj, params)
    local res_ = ""
    local url = obj
    if data[obj].id then
        url = url .. '/update?id=' .. data[obj].id
    else
        url = url .. '/save'
    end

    local _form_header = [[
            <form class="simple_form edit_user ajax_model_form" data-model="user"
            method="POST" action="/admin/]] .. url .. [["
            accept-charset="UTF-8" id="edit_user" novalidate="novalidate" autocomplete="off">]]

    local _footer = [[</form>]]

    local htmlRender = {
        hidden = function(name)
            res_ = res_ .. '<input name="' .. name .. '" type="hidden" value="' .. data[obj][name] .. '">'
        end,
        input = function(name, attr)
            --out(obj, name, attr)
            --'ip',['label': 'IP地址']
            local r = [[
            <div class="form-group string optional user_user_type"
              style="padding-left: 2px; padding-right: 2px;float:left;width:%s">
              <label class="string optional control-label" for="%s">%s</label>

                <div> <input type="text" class=" input optional form-control" id="%s"
                 name="%s[%s]" value="%s"></div>
                 </div>
              ]]

            res_ = res_ .. string.format(r, attr.width or '100%', name, attr.label or '', name, obj, name, data[obj][name] or '')
        end,
        submit = function(label)
            res_ = res_ .. '<input type="submit" class="btn btn-default " value="' .. label .. '">'
        end,
        render = function()
            out(_form_header .. res_ .. _footer)
        end,
        select = function(name, attr)
            local str = [[<div class="form-group string optional user_user_type"
              style="padding-left: 2px; padding-right: 2px;float:left;width:%s">
              <label class="string optional control-label" for="%s">%s</label>
              <div> <select class="  select optional form-control" id="%s"
              name="%s[%s]">%s</select>
            </div></div>
            <div class="error_reason" style="color: red;"></div>]]
            local collection = ""

            local col

            if type(attr.collection) == 'table' then
                col = attr.collection
                print('table collection render:',name..'_text')
            elseif attr.collection then
                col = data[obj][attr.collection]
                print('collection render:',name..'_text')
            else
                col = data[obj][name .. '_array']
                print('text render:',name..'_array')
            end

            print('collection:',json_encode(col) )

            for i, v in pairs(col) do
                --out('---------' .. i .. v)
                --out('--=--' .. i .. ':' .. data[obj][name])

                if i .. '' == (data[obj][name] or '') .. '' then
                    collection = collection .. '<option value="' .. i .. '" selected="selected">' .. v .. '</option>'
                else
                    collection = collection .. '<option value="' .. i .. '">' .. v .. '</option>'
                end
            end
            res_ = res_ .. string.format(str, '100%', name, attr.label, data[obj][name], obj, name, collection)
        end
    }
    return htmlRender
end
