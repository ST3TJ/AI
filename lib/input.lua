local input = {}

input.get = function()
    if love.keyboard.isDown(ESCAPE_BUTTON) then
        in_menu = true
    end
end

return input