local menu = {}

menu.actions = {
    function()
        local data = map:heap()
        AI:Setup(data, 3, { 192, 48, 10 })
        AI:Main()
        local output = AI:GetOutput()
        local values = table.foreach(
            output:GetValues(),
            function(k, v)
                return string.format('\n%s: %.2f', k - 1, v)
            end
        )
        print(unpack(values))
    end,
    function()
        map:init()
    end,
    function()
        love.event.quit()
    end
}

menu.main = function()
    printf('Menu actions\n1. Activate AI\n2. Clear canvas\n3. Exit')
    local action = io.read()
    menu.actions[tonumber(action)]()
    in_menu = false
end

return menu