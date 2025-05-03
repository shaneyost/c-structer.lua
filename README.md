# c-structer.lua

An example of LuaJIT's FFI implemented as a table generation tool. Create a 
runtime around your configs to modify and generate tables for C app/lib 
initialization.

```mermaid
flowchart TD
  subgraph CONFIG
    direction TB
    CFG[Model your C structure via a Lua table ...\n
```lua
return {
  {
    type = "float",
    name = "float_v",
    init = 3.14,
    sdef = "Model_u",
  },
  {
    type = "int8_t",
    name = "int8_v",
    init = -42,
    sdef = "Model_u"
  }
}
```]
  end

  subgraph RUNTIME
    direction TB
    RUNTIME_CODE[Create a c-type constructor and allocate/initialize memory for new table object ...\n
```lua
local tbl = require("c-structer.structer")
local cfg = require("example_config")

local Constructor, vals = tbl.create_struct(cfg)
local Model = Constructor(vals)

Model.float_v = -3.14
print(Model.float_v)
Model:table()
```]
  end

  subgraph OUTPUTS
    direction TB
    BIN1[TABLE1.BIN]
    BIN2[TABLE2.BIN]
    BIN3[TABLE3.BIN\nHex: D6 C3 F5 48 40]
    SHA[SHA256 (crcs.txt)\n
445e...3306 table1.bin\n
2342...a45f table2.bin\n
c34c...6c22 table3.bin]
  end

  CONFIG --> RUNTIME
  RUNTIME --> OUTPUTS
  OUTPUTS --> SHA
```
