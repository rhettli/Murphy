
{% macro edit(item) %}
{% if !item.status %}
<a href="/admin/business_photo/pass?id={{item.id}}">通过</a>
{% endif %}
{% endmacro %}


{% macro photo_img(item) %}
<img src="{{item.photo}}" style="width:80px;"/>
{% endmacro %}

{{ simple_table(busi_photo, [
'ID': 'id', '上传用户': 'member_id',
'商户': 'business_information_id','图片': 'photo_img','状态': 'status_text','操作': 'edit']) }}

<script>

</script>