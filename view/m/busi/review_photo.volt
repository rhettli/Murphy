
<style>
    img{
        width: 100%;
    }
    .remove{
        color: brown;
        position: absolute;
        padding: 1px 7px;
        border-radius: 1rem;
        top: 5px;
        right: 5px;
        font-size: .5rem;
        cursor: pointer;
        background-color: antiquewhite;
    }
</style>


{% for val in photos %}
            <div style="padding-bottom:6px;">
            <div style="position:relative;"> <img src="{{val}}"/>
                <span class="remove" onclick="remove_pic('{{val}}',{{business_info.id}})">remove</span>
            </div>
            </div>
{% endfor %}


        {% set f = simple_form([ 'admin', business_info ], ['class':'ajax_model_form']) %}

        {{ f.file('avatar',['label':'上传商户图片']) }}
        {{ f.hidden('op')}}
<input type="hidden" value="{{uid}}" name="uid"/>
        {{ f.hidden('id')}}
        {{ f.submit('保存') }}

        {{ f.end }}

<script type="text/javascript">
let uid="{{uid}}";
function remove_pic(img,id) {
    //利用对话框返回的值 （true 或者 false）
    if (confirm("你确定提交删除吗？")) {

    } else {
        return;
    }


    console.log(img, id);
    $.ajax({
        url: "/admin/business_informations/delete_photo?id=" + id, data: {"img": img,uid}, success: function () {
            location.reload();
        }
    });
}

</script>
