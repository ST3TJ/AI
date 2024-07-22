local map = {}

function map:init()
    self.width = math.floor(window[1] / SCALE)
    self.height = math.floor(window[2] / SCALE)
    for x = 0, self.width do
        self[x] = {}
        for y = 0, self.height do
            self[x][y] = 0
        end
    end
end

function map:draw()
    for x = 0, self.width do
        for y = 0, self.height do
            local alpha = self[x][y]

            if alpha > 0 then
                love.graphics.setColor(1, 1, 1, alpha)
                love.graphics.rectangle('fill', x * SCALE, y * SCALE, SCALE, SCALE)
            end
        end
    end

    if not (DRAW_NETWORK and AI.setuped) then
        return
    end

    AI:AddInputLayer(map:heap())
    AI:Main()
    for x, layer in pairs(AI.layers) do
        for y, value in pairs(layer:GetValues()) do
            love.graphics.setColor(value, value, value)
            love.graphics.circle('fill', x * 10, y * 10, 3)
        end
    end
end

function map:act()
    if not love.mouse.isDown(0x1) then
        return
    end

    local x, y = love.mouse.getPosition()
    x = math.floor(x / SCALE)
    y = math.floor(y / SCALE)

    if BRUSH_SIZE == 1 then
        self[x][y] = 1
    elseif BRUSH_SIZE > 1 then
        local radius = math.floor(.5 + BRUSH_SIZE / 2)

        for i = -radius, radius do
            for j = -radius, radius do
                local distance = math.sqrt(i * i + j * j)
                if i * i + j * j <= radius ^ 2 then
                    local bx, by = x + i, y + j
                    if bx >= 0 and bx <= self.width and by >= 0 and by <= self.height then
                        self[bx][by] = math.min(1, self[bx][by] + 1 - (distance / radius))
                    end
                end
            end
        end
    end
end

---@return number[]
function map:heap()
    local heap = {}
    for x = 0, self.width do
        for y = 0, self.height do
            local alpha = self[x][y]
            table.insert(heap, alpha)
        end
    end
    return heap
end

---@return string
function map:dump()
    local dump = 'return {\n';

    for x = 0, #map do
        for y = 0, #map[x] do
            dump = string.format('%s%.2f,', dump, map[x][y])
        end
        dump = dump .. '\n'
    end

    dump = dump .. '\n}'

    return dump
end

map:init()

return map
