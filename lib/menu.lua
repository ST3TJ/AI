local menu = {}

menu.actions = {
    ---@param throw? boolean
    ---@return number|nil
    function(throw)
        if type(throw) == 'nil' then
            throw = true
        end
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
        if throw then
            ---@cast values string[]
            print(unpack(values))
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
        local real_digit = tonumber(input('Write a number that you drawed'))
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
    end,
    function()
        love.event.quit()
    end
}

menu.main = function()
    printf('Menu actions\n1. Activate AI\n2. Reset AI\n3. Clear canvas\n4. Auto Train\n5. Continue\n6. Exit')
    local choose = io.read()
    local action = menu.actions[tonumber(choose)]
    if not action then
        printf('Action with index %s does not exists', choose)
        return
    end
    action()
    in_menu = false
end

return menu