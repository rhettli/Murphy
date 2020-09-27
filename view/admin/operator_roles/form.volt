{% set f = simple_form(['admin',operator_role],['method':'post', 'class':'ajax_model_form']) %}
{{ f.input('name', ['label': '名称']) }}
{{ f.select('status', ['label': '状态', 'collection': OperatorRoles.STATUS]) }}
{% if operator_role.id == '' %}
    <div class="form-group string optional operator_role_status"><label class="string optional control-label"
                                                                        for="operator_role_status">复制角色权限</label>
        <div><select class="  select optional form-control" id="operator_role_status" name="copy_operator_role_id">
                {{ options(operator_roles,0,'id','name') }}
            </select>
        </div>
    </div>
{% endif %}
{{ f.submit('保存') }}
<div class="error_reason" style="color: red;"></div>
{{ f.end }}