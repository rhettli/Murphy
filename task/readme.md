> task任务创建目录，请勿修改sys目录下的文件内容，如果你知道是做什么的

## 创建task文件：

**1.)直接使用命令行创建`woo murphy task new [task file name] [task function]`**

> 比如(task function 支持多个，多个请使用逗号分割)：
>
> woo murphy task new member find,add,del,forbidden,update

### 上述命令执行完毕将会在task目录下生成一个member.woo文件，文件的内容为：

```lua
return {
    find = function(lan)

    end,
    add = function(lan)

    end,
    del = function(lan)

    end,
    forbidden = function(lan)

    end,
    update = function(lan)

    end
} 
```

**2.)调用member.woo内的list方法：`woo murphy member find [arg1] [arg2] [arg3] [...]`**
> arg1 arg2 arg3 ... 是传入参数，可以省略

## 可以加入自己的修改来查询成员

```lua
return {
    find = function(lan)
        local args = _args()
        if #args < 2 then
            print(({ en = 'need key and value', zh = '缺少待查询的字段和值' })[lan])
            return
        end
        
        -- 如果使用命令 woo murphy find id 100
        local filed = args[1] -- filed=id
        local value = args[2] -- value=100

        -- 这里使用__model中的魔术方法可以取到member对象，进而查询
        local member = __model.member:findFirstBy(filed, value)
        _out(member)
    end,
    add = function(lan)

    end,
    del = function(lan)

    end,
    forbidden = function(lan)

    end,
    update = function(lan)

    end
} 
```

### 如果想查询id=100的用户的信息:`woo murphy member find id 100`
### 如果在unix系统中murphy可以直接执行，那么命令可以简化为:`./murphy member find id 100`
