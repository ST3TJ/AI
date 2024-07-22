ffi = require('ffi')

ffi.cdef[[
    short GetAsyncKeyState(int vKey);
]]

local engine = {
    ---@param code integer
    ---@return integer
    get_key_state = function(code)
        return ffi.C.GetAsyncKeyState(code)
    end,
    ---@param dir string
    ---@return number
    count_files_in_dir = function(dir)
        local count = 0
        local p = io.popen('dir "' .. dir .. '" /b /a-d 2>nul | find /c /v ""')
        if p then
            count = tonumber(p:read("*a"))
            p:close()
        end
        return count or 0
    end
}

return engine