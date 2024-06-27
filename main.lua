require('header')

function love.draw()
    input.get()

    if not in_menu then
        map:act()
    else
        menu.main()
    end

    map:draw()
end