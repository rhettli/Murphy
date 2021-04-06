<a href="/admin/operator_roles/new" class="modal_action">新建角色</a>
{% macro authrize_link(operator_role) %}
    <a href="/admin/operator_roles/edit_permissions/{{ operator_role.id }}" class="modal_action">后台管理授权({{ operator_role.id }})</a>
{% /macro %}

{{ simple_table(operator_roles,['id':'id','角色名称': 'name','状态':'status_text','创建时间':'created_at_text','授权':'authrize_link','编辑': 'edit_link']) }}