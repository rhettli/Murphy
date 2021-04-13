
<form action="/admin/action/" method="get" class="search_form" autocomplete="off" id="search_form">
    <label for="id_eq">Id</label>
    <input name="device[id_eq]" type="text" id="id_eq"/>

    <label for="member_id">ver</label>
    <input name="device[member_id_eq]" type="text" id="member_id"/>

    <button type="submit" class="ui button">搜索</button>
 </form>


{% macro member(op) %}
{{op.member.nickname}}
{% /macro %}


{% simple_table(actions, {id='ID', member='用户', doing='做什么事',created_at_time='创建时间' }) %}
