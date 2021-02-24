# Murphy
>by liyanxi:oshine@wooyri.com


#### 安装与运行
```
wpm install oshine/murphy
cd oshine_murphy
cw cli set database [这里数据库用户名] [这里数据库密码]
cw cli init
cw ./
```

然后访问http://127.0.0.1:8008


如果 更新了控制层中的admin类需要重新索引下权限
`woo cli index`

清除是数据库缓存和模板缓存
woo cli clear cache

新建数据库更新脚本：

1.  `woo cli generate sql create_table_user`
2.  将会在db文件夹里面生成： create_table_user_20200212091214.sql 这样的一个文件
3.  在这个文件里面写好sql更新脚本
4.  在服务器上面：`git pull && cw cli sql update`

### 目录结构说明
```
conf            配置项目
 |————  conf.lua   
 |————  define.lua  
           |———  acl.php   后台角色配置
           |———  config.php   各种第三方账户,缓存服务器,数据库账户配置文件
           |———  defined.php  项目中所有常量定义文件
           |———  router.php   整个系统的路由配置
 |————  controllers  控制器总目录
           |———  ./admin/     后台管理的控制器目录
           |———  ./api/       手机客户端API控制器目录
           |———  ./m         手机WAP站控制器目录
           |———  ./test      测试代码控制器目录
           |———  DebugController.php   调试用
           |———  ApplicationController.php  总控制器
           |———  QueueController.php   对列控制器
 |————   models      Model存放目录
           |———  ./paygateway            支付网关
           |———  ./smsgateway            短信发送网关
           |———  ./thidrgateway          第三方登录网关
           |———  BaseModel.php           所有Model的基类,对数据库和redis,ssdb进行了封装
           |———  DatabaseModel.php       对数据库相关操作封装,BaseModel里会使用到
           |———  DelayedObject.php       对异步操作的相关封装,BaseModel里会使用到
           |———  Mailers.php             邮件发送类
           |———  NullObject.php          空对象类,BaseModel里会使用
           |———  PaginationModel.php     分页工具类
           |———  Pushers.php             消息推送类
           |———  StoreFile.php           第三方存储平台操作类
 |—————   tasks      命令行任务(处理批量,耗时的任务)
           |———  fixTask.php             数据修复任务,如果数据有错误,比如通过生日计算用户的年龄
 |—————   views      视图总目录
           |———  admin          后台的所有视图

 public          对外开放目录,仅此目录里的文件是可以被访问的
    |————   index.php           入口文件
    |————   ./js                外部使用的js总目录
```