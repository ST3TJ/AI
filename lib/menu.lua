local menu = {}

menu.main = function()
    printf('Menu actions\n1. Activate AI\n2. EXPLODE')
    local action = io.read()
    if action == '1' then
        local data = map:heap()
        AI:Setup(data, 3, { 192, 48, 10 })
        AI:Main()
        local output = AI:GetOutput()
        print(unpack(output:GetValues()))
    elseif action == '2' then
        love.event.quit()
    end
    in_menu = false
end

return menu