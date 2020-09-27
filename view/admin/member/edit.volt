{% local t=simple_form(member, {login_at_text='登录时间', data='登录地区'}) %}


{% t.input('nickname',{ label='昵称',width='50%' }) %}
{% t.input('email',{ label='邮箱',width='50%' }) %}


<!-- table索引必须大于0 最为：[1]-->

{% t.select('status',{  label='状态' } ) %}
<!-- t.select('status',{  label='状态', collection = { [2] ="无效" , [1] ="有效" } } ) -->


{% t.submit('保存') %}
{% t.render() %}
