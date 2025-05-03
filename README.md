# c-structer.lua

An example of LuaJIT's FFI implemented as a table generation tool. Create a 
runtime around your configs to modify and generate tables for C app/lib 
initialization.

```mermaid
flowchart TD
  CONFIG[CONFIG]
  RUNTIME[RUNTIME]
  OUTPUTS[OUTPUTS]

  CFG[Model C struct as Lua table:\ntype=float, name=float_v, init=3.14\n...\ntype=int8_t, name=int8_v, init=-42]
  CODE[Require structer module\nCreate struct + constructor\nAssign/init values\nCall :table() method]

  BIN1[TABLE1.BIN]
  BIN2[TABLE2.BIN]
  BIN3[TABLE3.BIN\nHex: D6 C3 F5 48 40]
  SHA[crcs.txt (SHA256)\n445e.. table1.bin\n2342.. table2.bin\nc34c.. table3.bin]

  CONFIG --> CFG
  CFG --> RUNTIME
  RUNTIME --> CODE
  CODE --> OUTPUTS
  OUTPUTS --> BIN1
  OUTPUTS --> BIN2
  OUTPUTS --> BIN3
  OUTPUTS --> SHA

```
