#!/usr/bin/env luajit

local tbl = require("c-structer.structer")
local cfg = require("example_config")

local Constructor, vals = tbl.create_struct(cfg)
local Model = Constructor(vals)
Model.fout.col = 16
Model:table()
print(Model)
print("hash: ", Model:hash())
print("file: ", Model.tbin)
print("algo: ", Model.algo)
