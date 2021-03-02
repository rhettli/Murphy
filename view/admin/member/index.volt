
<form action="/admin/member/index" method="get" class="search_form" autocomplete="off" id="search_form">
    <label for="id_eq">Id</label>
    <input name="member[id_eq]" type="text" id="id_eq"/>

    <label for="email_eq">Email</label>
    <input name="member[email_eq]" type="text" id="email_eq"/>

    <button type="submit" class="ui button">搜索</button>
 </form>


{% macro edit(op) %}

<br/><a href="/admin/member/edit?id={{op.id}}" class='modal_action'>编辑</a>

{% endmacro %}

{% macro user_info_(op) %}
<img class='avatar' src="http://oilcn.cn-sh2.ufileos.com/{{op.avatar}}" style='width:100px;height:100px'/>
{% endmacro %}

{% macro user_details(op) %}
昵称:{{op.nickname}}<br/>
性别:{{op.sex_text}}<br/>


{% endmacro %}

{% simple_table(members, {id='ID', user_info_='用户头像', user_details='详细',email='邮箱',reg_ip='注册ip',
status_text='状态',created_at_time='创建时间',edit='操作' }) %}