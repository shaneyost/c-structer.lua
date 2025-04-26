#!/usr/bin/env luajit

local tbl = require("c-structer.structer")
local cfg = require("example_config")


local Constructor, vals = tbl.create_struct(cfg)
local Model = Constructor(vals)
Model:create_binary("foo.bin")
Model:create_hashfile("foo.bin")
