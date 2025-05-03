local CStructer = {}
local ffi = require("ffi")
local utl = require("cstructer.structer_utils")

local function create_cdef(struct_mems, struct_type, struct_size)
    local cdef = string.format(
        [[
typedef union
{
    struct __attribute__((__packed__))
    {
%s
    };
    uint8_t raw[%d];
} %s;
]],
        struct_mems,
        struct_size,
        struct_type
    )
    return cdef
end

local function _create_table_file(self)
    local file = assert(io.open(self.tbin, "wb"))
    file:write(ffi.string(self.raw, self:size()))
    file:close()
end

local function _create_hash(self)
    local cmd = string.format('%s "%s"', self.algo, self.tbin)
    local handle = assert(io.popen(cmd), "Error: failed open process")
    local output = handle:read("*a") or ""
    local ok, _, ecode = handle:close()
    assert(ok, string.format("Error: command failed (%d)", ecode or -1))
    local hash = output:match("^(%x+)")
    assert(hash, "Error: failed to extract hash from:\n" .. output)
    return hash
end

local function _peek(self)
    local out = {}
    for i = 0, self:size() - 1 do
        out[#out + 1] = string.format(self.fout.fmt, self.raw[i])
        out[#out + 1] = ((i + 1) % self.fout.col == 0) and "\n" or " "
    end
    return table.concat(out)
end

local _metatable = {
    __index = {
        tbin  = "table.bin",
        algo  = "shasum -a 256",
        fout  = {fmt="%02X", col=8},
        table = _create_table_file,
        hash  = _create_hash,
        size  = function(self) return ffi.sizeof(self) end,
    },
    __tostring = _peek,
}

function CStructer.create_struct(struct_data)
    local struct_size = utl._extract_validate_struct_size(struct_data)
    local struct_type = utl._extract_validate_struct_type(struct_data)
    local struct_vals = utl._extract_validate_struct_init(struct_data)
    local struct_mems = utl._extract_validate_struct_mems(struct_data)
    local struct_cdef = create_cdef(struct_mems, struct_type, struct_size)
    ffi.cdef(struct_cdef)
    return ffi.metatype(ffi.typeof(struct_type), _metatable), struct_vals
end

return CStructer
