local CStructer = {}
local ffi = require("ffi")
local utl = require("c-structer.structer_utils")

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

local function create_binary(self, filename)
    local file = assert(io.open(filename, "wb"))
    file:write(ffi.string(self.raw, self:size()))
    file:close()
end

local function peek(self, col, fmt)
    col = col or 8
    fmt = fmt or "%02X"
    local out = {}
    for i = 0, self:size() - 1 do
        out[#out + 1] = string.format(fmt, self.raw[i])
        out[#out + 1] = ((i + 1) % col == 0) and "\n" or " "
    end
    return table.concat(out)
end

local function create_hashfile(self, filename)
    utl._compute_hash_table("shasum -a 256", filename)
end

local _metatable = {
    __index = {
        create_binary = create_binary,
        create_hashfile = create_hashfile,
        size = function(self) return ffi.sizeof(self) end,
    },
    __tostring = peek,
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
