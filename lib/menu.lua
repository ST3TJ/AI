local menu = {}

menu.main = function()
    printf('Menu actions\n1. Activate AI\n2. EXPLODE')
    local action = io.read()
    if action == '1' then
        AI:Setup({1, 0, 1, 0.5}, 3, { 192, 48, 10 })
        AI:Main()
        print(unpack(AI:GetOutput()))
    elseif action == '2' then
        love.event.quit()
    end
    in_menu = false
end

return menu