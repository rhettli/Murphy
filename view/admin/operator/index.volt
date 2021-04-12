<!DOCTYPE html>
            <html lang="zh-CN">
            <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta http-equiv="refresh" content="300">
            <title>管理后台</title>
<script src="/static/js/jquery/1.11.2/jquery.min.js" type="text/javascript"></script>
<script src="/static/js/jquery.form/3.51.0/jquery.form.js" type="text/javascript"></script>
<script src="/static/framework/bootstrap/3.3.4/js/bootstrap.min.js" type="text/javascript"></script>
<script src="/static/js/admin.js" type="text/javascript"></script>
<link href="/static/framework/bootstrap/3.3.4/css/bootstrap.min.css" media="all" rel="stylesheet" />

</head>
            <body>
<div style="width: 250px; margin: 100px auto;">
                            <form action="/admin/operator/login" id="login_form" class="ajax_form" method="post">
                                <div class="form-group">
                                    <input name="username" type="text" class="form-control" placeholder="用户"/>
                                </div>
                                <div class="form-group">
                                    <input type="password" name="password" class="form-control" placeholder="密码"/>
                                </div>
                                <input type="submit" class="btn btn-primary" value="登录"/>
                                <div class="error_reason"></div>
                            </form>
                    </div>
               </body>
</html>