# c-structer.lua

An example of LuaJIT's FFI implemented as a table generation tool. Create a 
runtime around your configs to modify and generate tables for C app/lib 
initialization.

1. Create a lua config

```Lua
return {
    {
        type = "uint32_t",
        name = "uint32_v",
        init = 0xDEADBEEF,
        sdef = "Model_u"
    },
    {
        type = "uint32_t",
        name = "uint32_v",
        init = 0xDEADBEEF,
        sdef = "Model_u",
    },
    {
        type = "int8_t",
        name = "int8_v",
        init = -42,
        sdef = "Model_u"
    }
}

```

2. Create a lua app

```Lua
#!/usr/bin/env luajit
local tbl = require("c-structer.structer")
local cfg = require("example_config")

-- Create constructor, instantiate an object of table
local Constructor, vals = tbl.create_struct(cfg)
local Model = Constructor(vals)

-- Object accesses
print(Model.int8_v)
Model.int8_v = 42
print(Model.int8_v)

-- Modify/Call metatable attributes
Model.fout.col = 8
Model:table()
print(Model)
print("hash: ", Model:hash())
print("file: ", Model.tbin)
print("algo: ", Model.algo)
```
