---@class Neuron
---@field weights number[]
---@field bias number
---@field value number

---@class Layer
---@field GetValues fun(self: Layer): number[] Return value of neurons containing in layer
---@field neurons Neuron[]

local AI = {
    ---@type Layer[]
    layers = {},
    setuped = false,
    step = 2, -- ignore input layer
}

---@param x number
---@return number
function AI:Activate(x)
    -- math.max(0, value)
    return 1 / (1 + math.exp(-x))
end

---@param id integer
---@return Layer
function AI:GetLayer(id)
    return self.layers[id]
end

---@param connections_amount number
---@param randomize boolean
---@return Neuron
function AI:CreateNeuron(connections_amount, randomize)
    local neuron = {
        weights = {},
        bias = randomize and (math.random() - math.random()) or 0,
        value = 0
    }

    for i = 1, connections_amount do
        neuron.weights[i] = randomize and (math.random() - math.random()) or 0
    end

    neuron.value = neuron.bias

    return neuron
end

---@param data table
function AI:AddInputLayer(data)
    self.layers[1] = {
        neurons = {}
    }

    for i = 1, #data do
        table.insert(self.layers[1].neurons, { value = data[i] })
    end
end

---@param size number
function AI:AddLayer(size)
    table.insert(self.layers, {
        GetValues = function(self)
            local values = {}
            for _, neuron in ipairs(self.neurons) do
                table.insert(values, neuron.value)
            end
            return values
        end,
        neurons = {},
    })

    local id = #self.layers
    local connections_amount = #self:GetLayer(id - 1).neurons -- Amount of neurons on previous layer

    for _ = 1, size do
        table.insert(self:GetLayer(id).neurons, self:CreateNeuron(connections_amount, true))
    end
end

function AI:Reset()
    self.layers = {}
    self.setuped = false
    self.step = 2
end

---@param data any
---@param layers_amount number
---@param layers_sizes number[]
function AI:Setup(data, layers_amount, layers_sizes)
    if self.setuped then
        return
    end
    self:AddInputLayer(data)
    for i = 1, layers_amount do
        self:AddLayer(layers_sizes[i])
    end
    self.setuped = true
end

function AI:Main()
    if not self.setuped then
        return
    end

    while true do
        local previous_layer = self.layers[self.step - 1]
        local current_layer = self.layers[self.step]

        for _, neuron in ipairs(current_layer.neurons) do
            for i, weight in ipairs(neuron.weights) do
                neuron.value = neuron.value + previous_layer.neurons[i].value * weight
            end
            neuron.value = self:Activate(neuron.value)
        end

        self.step = self.step + 1

        if self.step > #self.layers then
            break
        end
    end

    self.step = 2

    return true
end

---@return Layer
function AI:GetOutput()
    return self.layers[#self.layers]
end

return AI