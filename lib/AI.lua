---@class Neuron
---@field weights number[]
---@field bias number

local AI = {
    layers = {},
    setuped = false,
}

function AI:Activate(value)
    return math.max(0, value)
end

---@param connections_amount number
---@param randomize boolean
---@return Neuron
function AI:CreateNeuron(connections_amount, randomize)
    local neuron = {
        weights = {},
        bias = randomize and math.random(-1, 1) or 0,
        value = 0
    }

    for i = 1, connections_amount do
        neuron.weights[i] = randomize and math.random(-1, 1) or 0
    end

    neuron.value = neuron.bias

    return neuron
end

---@param data table
function AI:AddInputLayer(data)
    self.layers[1] = {}

    for i = 1, #data do
        self.layers[1][i] = data[i]
    end
end

---@param size number
function AI:AddLayer(size)
    table.insert(self.layers, {})
    local id = #self.layers
    local connections_amount = #self.layers[id - 1]

    for _ = 1, #size do
        table.insert(self.layers[id], self:CreateNeuron(connections_amount, true))
    end
end

---@param data any
---@param layers_amount number
---@param layers_sizes number[]
function AI:Setup(data, layers_amount, layers_sizes)
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

    

    return true
end

function AI:GetOutput()
    return self.layers[#self.layers]
end

return AI