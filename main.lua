require('header')

function love.draw()
    if love.keyboard.isDown(ESCAPE_BUTTON) then
        in_menu = true
    end

    if not in_menu then
        map:act()
    else
        menu.main()
    end

    map:draw()
end