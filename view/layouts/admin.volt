<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ admin_name }}管理后台</title>

    <script src="/static/js/jquery/1.11.2/jquery.min.js"></script>
    <script src="/static/js/vue/2.0.5/vue.min.js"></script>
    <script src="/static/js/jquery.form/3.51.0/jquery.form.js"></script>
    <script src="/static/js/wangEditor.min.js"></script>
    <script src="/static/framework/bootstrap.select/1.13.7/js/bootstrap-select.min.js"></script>
    <script src="/static/framework/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    <script src="/static/framework/bootstrap.datepicker/1.4.0/js/bootstrap-datetimepicker.min.js"></script>
    <script src="/static/framework/bootstrap.datepicker/1.4.0/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="/static/framework/bootstrap.datepicker/1.5.0/js/bootstrap-datepicker.min.js"></script>
    <script src="/static/framework/bootstrap.datepicker/1.5.0/locales/bootstrap-datepicker.zh-CN.min.js"></script>
    <script src="/static/js/juicer/0.6.9/juicer-min.js"></script><script src="/static/js/echarts/3.7.2/echarts.js"></script>
    <script src="/static/js/echarts/3.7.2/chalk.js"></script><script src="/static/js/echarts/3.7.2/china.js"></script>
    <script src="/static/js/admin.js"></script>
    <script src="/static/framework/bootstrap.select/1.13.7/js/i18n/defaults-zh_CN.min.js"></script>

    <link rel="stylesheet" type="text/css" href="/static/framework/bootstrap/3.3.4/css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="/static/framework/bootstrap.datepicker/1.4.0/css/bootstrap-datetimepicker.min.css"></style>
    <link rel="stylesheet" type="text/css" href="/static/framework/bootstrap.datepicker/1.5.0/css/bootstrap-datepicker.min.css"></link>
    <link rel="stylesheet" type="text/css" href="/static/framework/bootstrap.select/1.13.7/css/bootstrap-select.min.css"></link>
    <link rel="stylesheet" type="text/css" href="/static/css/admin.css"></link>

</head>
<body>

<nav class="navbar navbar-default navbar-static-top {%if is_development  then %}dev_navbar{% endif %}" role="navigation"
     style="padding-left: 10px;padding-right: 10px;">

    <ul class="nav navbar-nav">
        {%if _is_allowed('product_channels','index')  then %}
            <li>
                <a href="/admin/product_channels">产品渠道</a>
            </li>
        {% endif %}

        {%if _is_allowed('users','index') or _is_allowed('devices','index')  then %}
            <li>
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">用户<b class="caret"></b></a>
                <ul class="dropdown-menu">
                    {%if _is_allowed('users','index')  then %}
                        <li>
                            <a href="/admin/member">用户列表</a>
                        </li>
                    {% endif %}
                    {%if _is_allowed('sms_histories','index')  then %}
                        <li><a href="/admin/sms_histories">短信验证列表</a></li>
                    {% endif %}
                </ul>
            </li>
        {% endif %}

        {%if _is_allowed('products','index') or _is_allowed('banners','index') or _is_allowed('skus','index') or _is_allowed('third_photo','index')  then %}
            <li>
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">项目管理<b class="caret"></b></a>
                <ul class="dropdown-menu">
                    {%if _is_allowed('cw_package','index')  then %}
                        <li>
                            <a href="/admin/cw_package">依赖包列表</a>
                        </li>
                    {% endif %}
                    {%if _is_allowed('city_positions','index')  then %}
                        <li>
                            <a href="/admin/city_positions">开放城市列表</a>
                        </li>
                    {% endif %}
                    {%if _is_allowed('enters','index')  then %}
                    <li>
                        <a href="/admin/enters">来源访问</a>
                    </li>
                    {% endif %}

                    {%if _is_allowed('report','index')  then %}
                    <li>
                        <a href="/admin/report">行为监测</a>
                    </li>
                    {% endif %}
                </ul>
            </li>
        {% endif %}

        <!--微信管理-->
        {%if _is_allowed('weixin_menu_templates','index') or _is_allowed('push_messages','index') or _is_allowed('weixin_template_messages','index')  then %}
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">微信管理<b class="caret"></b></a>
                <ul class="dropdown-menu">
                    {%if _is_allowed('weixin_menu_templates','index')  then %}
                        <li><a href="/admin/weixin_menu_templates">微信菜单模板</a></li>
                    {% endif %}
                    {%if _is_allowed('push_messages','index')  then %}
                        <li><a href="/admin/push_messages">离线消息配置</a></li>
                    {% endif %}
                    {%if _is_allowed('weixin_kefu_messages','index')  then %}
                        <li><a href="/admin/weixin_kefu_messages">发送客服消息</a></li>
                    {% endif %}
                    {%if _is_allowed('weixin_template_messages','index')  then %}
                        <li><a href="/admin/weixin_template_messages">发送模板消息</a></li>
                    {% endif %}
                    {%if _is_allowed('ge_tui_messages','index')  then %}
                        <li><a href="/admin/ge_tui_messages">发送个推消息</a></li>
                    {% endif %}
                </ul>
            </li>
        {% endif %}

        <!-- 统计 -->
        {%if _is_allowed('stats','hours') or _is_allowed('stats','days')  then %}

            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    统计<b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    {%if _is_allowed('stats','hours')  then %}
                        <li><a href="/admin/stats/hours">小时统计</a></li>
                    {% endif %}
                    {%if _is_allowed('stats','days')  then %}
                        <li><a href="/admin/stats/days">按天统计</a></li>
                    {% endif %}
                    {%if _is_allowed('active_users','day_rank_list')  then %}
                        <li><a href="/admin/active_users/day_rank_list">在线用户统计</a></li>
                    {% endif %}
                    {%if _is_allowed('sms_histories','push_stat')  then %}
                        <li class="dropdown-submenu">
                            <a href="javascript:;" tabindex="-1">短信下发统计</a>
                            <ul class="dropdown-menu">
                                {%if _is_allowed('sms_histories','login_stat')  then %}
                                    <li><a href="/admin/sms_histories/login_stat">登录按天统计</a></li>
                                {% endif %}
                                {%if _is_allowed('sms_histories','login_hout_stat')  then %}
                                    <li><a href="/admin/sms_histories/login_hour_stat">登录小时统计</a></li>
                                {% endif %}
                            </ul>
                        </li>
                    {% endif %}

                    {%if _is_allowed('wap_visits', 'index')  then %}
                        <li><a href="/admin/wap_visits">SEM落地页统计</a></li>
                    {% endif %}
                    {%if _is_allowed('word_visits', 'index')  then %}
                        <li><a href="/admin/word_visits">SEM关键词统计</a></li>
                    {% endif %}
                </ul>
            </li>
        {% endif %}

        <!-- 系统 -->
        {% if _is_allowed('operators','index') or _is_allowed('partners','index') or _is_allowed('sms_channels','index')
        or _is_allowed('provinces','index') or _is_allowed('protocol_urls','index') or _is_allowed('banners','index')
        or _is_allowed('soft_versions','index') or _is_allowed('sms_channels','index') or _is_allowed('partner_urls','index')
        or _is_allowed('marketing_configs','index') or _is_allowed('cooperate', 'index') then %}

            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    系统<b class="caret"></b>
                </a>
                <ul class="dropdown-menu">
                    {%if _is_allowed('operators','index') or _is_allowed('operators','operator_login_histories')  then %}
                        <li class="dropdown-submenu">
                            <a href="javascript:;" tabindex="-1">操作员管理</a>
                            <ul class="dropdown-menu">
                                {%if _is_allowed('operator','index')  then %}
                                    <li><a href="/admin/operator">操作员列表</a></li>
                                {% endif %}
                                {%if _is_allowed('operator','index')  then %}
                                    <li><a href="/admin/operator_role">角色权限</a></li>
                                {% endif %}
                                {%if _is_allowed('operator_login_histories','operator_login_histories')  then %}
                                    <li><a href="/admin/operator_login_histories">登录记录</a></li>
                                {% endif %}
                                {%if _is_allowed('operating_records','index')  then %}
                                    <li><a href="/admin/operating_record">操作记录</a></li>
                                {% endif %}
                            </ul>
                        </li>
                    {% endif %}
                    {%if _is_allowed('partners','index')  then %}
                        <li><a href="/admin/partners">推广渠道</a></li>
                    {% endif %}
                    {%if _is_allowed('channel_soft_versions','index')  then %}
                        <li><a href="/admin/channel_soft_versions">推广渠道包</a></li>
                    {% endif %}
                    {%if _is_allowed('partner_urls', 'index')  then %}
                        <li><a href="/admin/partner_urls">推广链接生成</a></li>
                    {% endif %}

                    {%if _is_allowed('marketing_configs', 'index')  then %}
                        <li><a href="/admin/marketing_configs">腾讯marketing配置</a></li>
                    {% endif %}
                    {%if _is_allowed('sms_channels','index')  then %}
                        <li><a href="/admin/sms_channels">短信渠道</a></li>
                    {% endif %}
                    {%if _is_allowed('payment_channels','index')  then %}
                        <li><a href="/admin/payment_channels">支付渠道</a></li>
                    {% endif %}
                    {%if _is_allowed('provinces','index')  then %}
                        <li><a href="/admin/provinces">省市管理</a></li>
                    {% endif %}
                    {%if _is_allowed('soft_versions','index')  then %}
                        <li><a href="/admin/soft_versions">软件升级管理</a></li>
                    {% endif %}
                    {%if _is_allowed('export_histories','index')  then %}
                        <li><a href="/admin/export_histories">导出记录</a></li>
                    {% endif %}

                </ul>
            </li>
        {% endif %}


        <!--监控管理-->
        {%if _is_allowed('monitor','redis')  then %}
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">监控<b class="caret"></b></a>
                <ul class="dropdown-menu">
                    {%if _is_allowed('monitor','redis')  then %}
                        <li><a href="/admin/monitor/redis" target="_blank">异步监控</a></li>
                    {% endif %}
                    {%if _is_allowed('monitor','process')  then %}
                        <li><a href="/admin/monitor/process" target="_blank">进程监控</a></li>
                    {% endif %}
                    {%if _is_allowed('monitor','log')  then %}
                        <li><a href="/admin/monitor/log" target="_blank">日志监控</a></li>
                    {% endif %}
                </ul>
            </li>
        {% endif %}

    </ul>

    <ul class="nav navbar-nav navbar-right">
        <li><a>{{ operator_username }}</a></li>
        <li><a href="/admin/home/logout">注销</a></li>
    </ul>

    {%if _is_allowed('document_articles','index')  then %}
        <ul class="nav navbar-nav navbar-right">
            <li>
                <a target="_blank" href="/admin/document_articles/index?action={{ controller_name }}" >文档管理</a>
            </li>
        </ul>
    {% endif %}
</nav>

<div style="padding:0 15px;">
    {{#content#}}
</div>

</body>
</html>