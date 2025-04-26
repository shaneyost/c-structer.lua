local CStructer = {}
local ffi = require("ffi")

function CStructer._compute_hash_table(hash_cmd, filename)
    assert(type(hash_cmd) == "string", "Error: bad type for hash_cmd")
    assert(type(filename) == "string", "Error: bad type for filename")

    local full_cmd = string.format('%s "%s" 2>/dev/null', hash_cmd, filename)

    local handle = io.popen(full_cmd, "r")
    if not handle then
        return nil, "Error: failed to open process"
    end

    local output = handle:read("*a") or ""
    local ok, _, exit_code = handle:close()

    if not ok then
        return nil, string.format("Error: command failed to run (%d)", exit_code or -1)
    end

    local digest = output:match("^(%x+)")
    if not digest then
        return nil, "Error: failed to extract digest from output:\n" .. output
    end

    return digest, nil
end

function CStructer._compute_hash_table(hash_cmd, filename)
    assert(type(hash_cmd) == "string", "Error: bad type for hash_cmd")
    assert(type(filename) == "string", "Error: bad type for filename")

    local full_cmd = string.format('%s "%s"', hash_cmd, filename)
    local handle = io.popen(full_cmd)
    if not handle then
        return nil, "Error: failed to open process"
    end

    local output = handle:read("*a")
    local ok = handle:close()

    if not ok then
        return nil, "Error: command failed to run: " .. full_cmd
    end

    local digest = output:match("^(%x+)")
    if not digest then
        return nil, "Error: failed to extract digest from output:\n" .. output
    end

    return digest, nil
end

function CStructer._extract_validate_struct_type(struct_data)
    assert(type(struct_data) == "table", "Error: bad type for struct_data")
    local struct_type = struct_data[1].sdef
    for _, member in ipairs(struct_data) do
        assert(member.sdef == struct_type, "Error: unmatched name")
    end
    return struct_type
end

function CStructer._extract_validate_struct_size(struct_data)
    assert(type(struct_data) == "table", "Error: bad type for struct_data")
    local size = 0
    for _, member in ipairs(struct_data) do
        size = size + ffi.sizeof(member.type)
    end
    return size
end

function CStructer._extract_validate_struct_init(struct_data)
    local vals = {}
    for _, member in ipairs(struct_data) do
        table.insert(vals, member.init)
    end
    return vals
end

function CStructer._extract_validate_struct_mems(struct_data)
    assert(type(struct_data) == "table", "Error: bad type for struct_data")
    local members, indent = {}, "       "
    for _, member in ipairs(struct_data) do
        local m = string.format(indent .. "%s %s;", member.type, member.name)
        table.insert(members, m)
    end
    return table.concat(members, "\n")
end

return CStructer
