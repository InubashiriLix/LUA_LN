require("luasql.mysql")

env = luasql.mysql()
conn = env:connect("", "root", "Lix0123456789", "127.0.0.1", "3306")
conn:execute("CREATE DATABASE IF NOT EXISTS test")
cur = conn:execute("select * from test")
