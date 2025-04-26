#!/usr/bin/env luajit

local tbl = require("c-structer.structer")
local utl = require("c-structer.structer_utils")
local cfg = require("example_config")


local Constructor, vals = tbl.create_struct(cfg)
local Model = Constructor(vals)
print(Model)
print("\nInstance:\n", Model)
print("\nSize: ", Model:size())
Model:create_binary("foo.bin")
print(Model:create_hashfile("foo.bin"))
