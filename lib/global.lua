math.randomseed(os.time())
window = { love.graphics.getDimensions() }
in_menu = false

function printf(...)
    print(string.format(...))
end

---@param s? string
---@param ... any
---@return any
function input(s, ...)
    if s then
        printf(s, ...)
    end
    return io.read()
end

---Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments
---@param list table
---@param f function
---@return table
---@diagnostic disable-next-line: duplicate-set-field
function table.foreach(list, f)
    for k, v in pairs(list) do
        list[k] = f(k, v);
    end;
    return list;
end;