require('header')

function love.draw()
    if engine.get_key_state(ESCAPE_BUTTON) ~= 0 then
        in_menu = true
    end

    if not in_menu then
        map:act()
    else
        menu.main()
    end

    map:draw()
end