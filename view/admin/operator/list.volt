{% if _is_allowed('operator','new') then%}
    <a href="/admin/operators/new" class="modal_action">新建</a>
{% endif %}

{% macro edit(op) %}
    {% if _is_allowed('operator','edit') then %}
        <a class="modal_action" href="/admin/operator/edit?id={{ op.id }}">编辑</a>
    {% endif %}
{% /macro %}

{% simple_table(operators, {id='ID', username='昵称',role='角色',
    ip='注册ip',active_at_time='激活时间',created_at_time='创建时间' ,edit='操作' }) %}
