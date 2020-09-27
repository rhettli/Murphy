

{% local f = simple_form([ 'admin', device ], ['class':'ajax_model_form']) %}

{{ f.select('status',['label': '状态','collection': Devices.STATUS]) }}

{{ f.input('ip',['label': 'IP地址']) }}

{{ f.submit('保存') }}

{{ f.render() }}





local f = simple_form([ 'admin', device ], ['class':'ajax_model_form'])
f.select()
f.input()
f.submit()
f.render()

