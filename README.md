# Murphy

#### 安装与运行
```
cwm install oshine/murphy
cd oshine_murphy
cw cli set database [这里数据库用户名] [这里数据库密码]
cw cli init
cw ./
```

然后访问http://127.0.0.1:8008


如果 更新了

cw cli clear cache

新建数据库更新脚本：
```
cw cli generate sql create_table_user
# 将会在db文件夹里面生成： create_table_user_20200212091214.sql 这样的一个文件
# 在这个文件里面写好sql更新脚本
# 在服务器上面：git pull && cw cli sql update
```