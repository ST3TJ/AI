local menu = {}

menu.actions = {
    function()
        local data = map:heap()
        AI:Setup(data, 3, { 192, 48, 10 })
        AI:Main()
        local guess = { value = 0, digit = nil }
        local output = AI:GetOutput()
        local values = table.foreach(
            output:GetValues(),
            function(k, v)
                if v > guess.value then
                    guess.value = v
                    guess.digit = k - 1
                end
                return string.format('\n%s: %.2f', k - 1, v)
            end
        )
        print(unpack(values))
        printf('Final guess: %s', guess.digit)
    end,
    function()
        map:init()
    end,
    function()
        AI:Reset()
    end,
    function()
        love.event.quit()
    end
}

menu.main = function()
    printf('Menu actions\n1. Activate AI\n2. Clear canvas\n3. Reset AI\n4. Exit')
    local action = io.read()
    menu.actions[tonumber(action)]()
    in_menu = false
end

return menu