-- 异步函数
--go(function(r1, r2)
--    print('==', r1, r2)
--    --out(r1, r2, "|789")
--
--    --return "--"
--end, 'hello', 87654)

local base64 = base64_encode('hello world!')
-- 把数据写到文件

out(base64 .. " \r\n")

local decode = base64_decode(base64)
out(decode .. " \r\n")

out(http_request('path') .. " path\r\n")
out(http_request('host') .. " host\r\n")
out(http_request('uri') .. " uri\r\n")
out(http_params('op') .. " params op\r\n")

out(_time() .. "\r\n")
