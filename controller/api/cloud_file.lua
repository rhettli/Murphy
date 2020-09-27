local class_member = {}

function class_member:new(o)
    o = o or {}

    self.psw = "/*415 saj25?>j|\\"
    self.version = "1"
    local conf = _import('conf.conf')
    conf.cloud_file_path = str_replace(conf.cloud_file_path, '#home#', home())
    self._conf = conf
    return self
end

function class_member:token()
    local t = require('oshine/cw_jwt'):new(self.psw, self.psw, 'nonce')

    local r = t:encode({ ip = http_ip(), member_id = self:currentMemberId() }, 5 * 60)
    return self:renderJSON({ r }, 'ok')
end

function class_member:delete()
    local p = http_params('file_id', 'short_psw')

end

function class_member:list()
    local p = http_params('path', 'folder')
    local member_id = self:currentMemberId()
    local cf = _new_model('cloud_file')
    p.folder = p.folder or '/'
    local cond
    if p.folder == '/' then
        cond = { conditions = 'member_id=:member_id: and pid=0',
                 bind = { member_id = member_id } }
    else
        local f = cf:findFirst({ conditions = 'member_id=:member_id: and folder=:folder: and is_folder=1',
                                 bind = { folder = p.folder, member_id = member_id } })
        if not is_valid(f) then
            return self:renderJSON(nil, 'path invalid', -1)
        end
        cond = { conditions = 'member_id=:member_id: and pid=:pid:',
                 bind = { pid = f.id, member_id = member_id } }
    end

    --self:model()

    local cloud_file = cf:findPagination(cond, 1, 1000)
    local r = {}
    if cloud_file.len() then
        cloud_file.each(function(i, cfle)
            r[1 + #r] = cfle:toJson()
        end)
    end
    print('p==============', json_encode(p))
    return self:renderJSON(r, '')
end

function class_member:upload()
    local p = http_params('short_psw', 'path', 'file:file[]')
    if is_valid(p['file[]']) then
        local cf = _new_model('cloud_file')
        local member_id = self:currentMemberId()
        local cloud_file_parent = cf:findFirst({ conditions = 'member_id=:member_id: and folder=:folder: and is_folder=1',
                                                 bind = { folder = p.path, member_id = member_id } })
        if not is_valid(cloud_file_parent) then
            return self:renderJSON(nil, 'the upload folder not exists ,please created first', -1)
        end

        for i, v in pairs(p['file[]']) do
            local cftmp = _new_model('cloud_file')
            cftmp.md5 = file_md5(v['temp'])
            -- 一个用户的相同目录中存在相同的文件，那么覆盖这个文件，md5不一致删除之前的文件
            local find_exit_already_have = cftmp:findFirst(
                    { conditions = 'member_id=:member_id: and folder=:folder: and name=:name: and is_folder=0',
                      bind = { size = v['size'], folder = p.path, member_id = member_id, name = v['name'] } })

            -- 已经存在目录中的文件，可能是引用
            if is_valid(find_exit_already_have) and find_exit_already_have.md5 ~= cftmp.md5 then
                -- 删除文件之前先判断是否还有其他引用
                local find_exit_refer = cftmp:findFirst(
                        { conditions = 'refer_id=:refer_id: and is_folder=0',
                          bind = { refer_id = find_exit_already_have.id } })
                if not is_valid(find_exit_refer) then
                    -- no refer ,delete[没有引用，删除]
                    local to_be_del_file = self._conf.cloud_file_path .. '/' .. cftmp.md5
                    if not delete(to_be_del_file) then
                        assert(false, 'delete file fail:' .. to_be_del_file)
                    end
                end
            end

            -- find refer【查找引用】
            local find_exit_cloud_file = cftmp:findFirst(
                    { conditions = 'md5=:md5: and size=:size: and is_folder=0',
                      bind = { size = v['size'], md5 = cftmp.md5 } })
            if is_valid(find_exit_cloud_file) then
                cftmp.refer_id = find_exit_cloud_file.id
            end

            cftmp.member_id = member_id
            cftmp.pid = cloud_file_parent.id
            cftmp.name = v['name']
            cftmp.size = v['size']

            cftmp.mime = file_name(v['name'])
            cftmp.folder = cloud_file_parent['folder']

            --    local path_ = ' copy  "' .. str_replace(v['temp'], '/', '\\') .. '"' .. ' "' .. self._conf.cloud_file_path .. '' .. cftmp.md5 .. '"'
            --    local r = exec({ "powershell", "-Command", path_ })
            local to_be_save = self._conf.cloud_file_path .. '' .. cftmp.md5
            if copy(v['temp'], to_be_save) then
                if not cftmp:save() then
                    print('save cloud_file db fail:==', json_encode(cftmp.snap))
                end
            else
                assert(false, 'copy file fail:==' .. v['temp'] .. to_be_save)
            end

            print('copy ok:==', r, v['temp'], self._conf.cloud_file_path .. '/' .. cftmp.md5)

        end
    end

    return self:renderJSON(nil, '')
end

function class_member:download()
    local file_id = http_params('file_id')
    local token = http_params('token')

    local t = require('oshine/cw_jwt'):new(self.psw, self.psw, 'nonce')
    if not is_valid(token) then
        return self:renderJSON(nil, 'token fail', -1)
    else
        local r, e = t:decode({ ip = http_ip() })
        if e ~= nil or http_ip() ~= r.ip or r.member_id ~= self:currentMemberId() then
            return self:renderJSON(nil, e or 'err', -1)
        end

    end

    if not is_valid(file_id) then
        return self:renderJSON(nil, 'fail:', -1)
    end
    local cf = _new_model('cloud_file')
    local cloud_file = cf:findFirstBy('id', file_id)
    if not is_valid(cloud_file) then
        return self:renderJSON(nil, 'file not find:', -1)
    end
    cloud_file.download_times = cloud_file.download_times + 1
    cloud_file:save()

    return http_send_file(cloud_file.folder .. cloud_file.name)
end

return _extend(class_member, "controller.api.base")