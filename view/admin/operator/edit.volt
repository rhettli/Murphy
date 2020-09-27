
{% local t=simple_form(operator, {login_at_text='登录时间', data='登录地区'}) %}


{% t.input('username',{ label='用户名',width='100%' }) %}

{% if data.operator then t.input('password_',{ label='密码（不为空则修改）',width='100%' }) endif %}

<!-- table索引必须大于0 最大为：[1]-->

{% t.select('operator_role_id',{  label='角色' , collection= _render_model( 'operator_role','id','name') } ) %}

{% t.select('status',{  label='状态' } ) %}
<!-- t.select('status',{  label='状态', collection = { [2] ="无效" , [1] ="有效" } } ) -->
{% t.submit('保存') %}

{% t.render() %}
