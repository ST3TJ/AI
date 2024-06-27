require('header')

function love.draw()
    map:act()
    map:draw()
end