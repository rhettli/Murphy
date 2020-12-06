-- you can use redis or ssdb cache to improve performance

return {
    cloud_file_path='#home#/Desktop/cloud_file_path/',
    database = {
        adapter = 'mysql',
        conn = "root:H987hgbrfd2387/*-451sd@(passer.top:3366)/wooyri?charset=utf8&parseTime=True&loc=Local"
    },
    ssdb0 = {
        addr = '127.0.0.1:8888',
        psw = '',
        db = 0
    },
    redis0 = {
        addr = '127.0.0.1:6379',
        psw = '',
        db = 0
    },
}