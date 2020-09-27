--out(DIR, VENDOR)

_curr_func = function()
    return debug.traceback()
end

install_dir = home() .. '/cwm/'
package.path = _DIR .. '/vendor/?.lua;' .. install_dir .. '/?.lua;' .. _DIR .. '\\?.lua;'

print(package.path)

-- 刚开始只有这里使用路径
require('vendor.autoload')
require('lib.core')
require('conf.defined')


--index.lua?_url=/foo/bar?op=123
local uri = http_request('uri')
--out("uri:", uri, "\r\n")
local params = str_split(uri, "?")
--out(params)
local controller = str_split(params[2], "=")[2]
--out('ctrl:', controller, "\r\n")

-- 定义全局变量,请求句柄
_request = _import('lib.request')
_request:new(params[3])

local func_arr = str_split(controller, '/')
local file = ""
local method = ""

--out('3', func_arr, "\r\n")
if #func_arr == 3 then
    --/foo/
    if func_arr[3] == "" then
        func_arr[3] = "index"
    end
    file = '/' .. func_arr[2] .. '/' .. func_arr[3]
    method = "index"
elseif #func_arr == 4 then
    --/foo/bar/
    if func_arr[4] == "" then
        func_arr[4] = "index"
    end
    file = '/' .. func_arr[2] .. '/' .. func_arr[3]
    method = func_arr[4]
elseif #func_arr == 2 then
    --/foo
    if func_arr[2] == "" then
        func_arr[2] = "index"
    end
    func_arr[3] = "index"

    file = '/' .. func_arr[2]
    method = func_arr[3]
end

local middleware = _import('middleware.base')
if false == middleware.handler(file, method) then
    return
end

print('request in:==', file, method)

-- 这里使用 _require_controller ，防止缓存已经存在的包
local run_str = "local ctrl = _import('controller%s');ctrl:new();return ctrl:%s();"

-- defined global var
_ACCESS_FILE = file
_ACCESS_METHOD = method

run_str = string.format(run_str, file, method)

--out("\r\n", run_str, "\r\n")

local call, obj = loadstring(run_str)()
--out(call)
--pcall(call, ctrl, params)



--out(http_request('host'), "\r\n")
--out(http_request('path'), "\r\n")


--http_tpl('index.html',{title="Coder wooyri language."})

