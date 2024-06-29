local menu = {}

menu.actions = {
    ---@param throw? boolean
    ---@return number|nil
    function(throw)
        throw = throw == nil and true or throw

        --[[
            @ если сетапить руками, то оно логично ломается если не ресетать значения
            @ при этом если их ресетать, то оно все равно ломается
            @ если сетапить через :Setup, то оно работает в любом случае
            @ колдовство ебучее
        ]]
        local data = map:heap()
        local layers = { 256, 128, 10 }
        AI:Setup(data, #layers, layers)
        AI:Main()

        local guess = { value = 0, digit = nil }
        local output = AI:GetOutput()
        local values = output:GetValues()
        local formatted_values = {}

        AI:ResetValues()

        for k, v in ipairs(values) do
            if v > guess.value then
                guess.value = v
                guess.digit = k - 1
            end
            table.insert(formatted_values, string.format('%d: %.2f', k - 1, v))
        end

        if throw then
            print(table.concat(formatted_values, '\n'))
            printf('Final guess: %s', guess.digit)
        end

        return guess.digit
    end,

    function()
        AI:Reset()
    end,

    function()
        map:init()
    end,

    function()
        local real_digit = tonumber(input('Write a number that you drew:'))
        while true do
            local guess = menu.actions[1](false)

            if real_digit ~= guess then
                printf('Real: %s | Guessed: %s', real_digit, guess)
                AI:Reset()
            else
                printf('Found!')
                break
            end
        end
    end,

    function()
        -- Reserved for future use
    end,

    function()
        love.event.quit()
    end
}

menu.main = function()
    printf('Menu actions\n1. Activate AI\n2. Reset AI\n3. Clear canvas\n4. Auto Train\n5. Continue\n6. Exit')
    local choice = tonumber(io.read())

    local action = menu.actions[choice]
    if not action then
        printf('Action with index %s does not exist', choice)
        return
    end

    action()
    in_menu = false
end

return menu
