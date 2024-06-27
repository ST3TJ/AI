require('header')

function love.draw()
    input.get()

    if not in_menu then
        map:act()
    else
        printf('Menu actions\n1. Activate AI')
        local action = io.read()
        -- AI fn
        in_menu = false
    end

    map:draw()
end