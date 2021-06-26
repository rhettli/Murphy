# Murphy
>by liyanxi:oshine@wooyri.com
>非常完善的woo web框架,名字灵感来自星际穿越女主角

#### 安装与运行
```
wpm install oshine/murphy
cd murphy
woo murphy install [数据库用户名] [数据库密码] [数据库类型：mysql 或 postgres]
woo ./
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

```
