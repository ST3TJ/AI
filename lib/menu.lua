local menu = {}
local text = [[
Menu actions
  1. Activate AI
  2. Reset AI
  3. Clear canvas
  4. Auto Train
  5. Dump number
  6. Continue
  7. Exit
]]

menu.actions = {
    ---@param throw? boolean
    ---@return number|nil
    function(throw)
        throw = throw == nil and true or throw

        local data = map:heap()
        local layers = { 16, 16, 10 }
        AI:Setup(data, #layers, layers)
        AI:Main()

        local guess = { value = 0, digit = nil }
        local output = AI:GetOutput()
        local values = output:GetValues()
        local formatted_values = {}

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
    end, -- Activate AI

    function()
        AI:Reset()
    end, -- Reset AI

    function()
        map:init()
    end, -- Clear canvas

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
    end, -- Auto train

    function()
        local digit = input("Enter digit that you drew: ")
        local directory = string.format("dataset/%d", digit)

        local fileCount = engine.count_files_in_dir(directory)

        local path = string.format("%s/%d.lua", directory, fileCount + 1)
        local dump = map:dump()

        local file = io.open(path, "w")
        if file then
            file:write(dump)
            file:close()
            print("The file was successfully created by the path: " .. path)
        else
            print("Failed to create a file by the path: " .. path)
        end
    end, -- Dump number

    function()
        -- 1488
    end, -- Continue

    function()
        love.event.quit()
    end -- Exit
}

menu.main = function()
    printf(text)
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
