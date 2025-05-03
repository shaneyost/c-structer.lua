#!/usr/bin/env luajit
local tbl = require("cstructer.structer")
local cfg = require("example_config")

local Constructor, Values = tbl.create_struct(cfg)
local Model = Constructor(Values)

print(Model)
print(Model.int8_v)
Model.int8_v = 10
print(Model)
print(Model.int8_v)

Model:table()
print("hash: ", Model:hash())
print("file: ", Model.tbin)
print("algo: ", Model.algo)
