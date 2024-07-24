---@class Neuron
---@field weights number[]
---@field bias number
---@field value number
---@field method string

---@class Layer
---@field getValues fun(self: Layer): number[] Return value of neurons containing in layer
---@field resetValues fun(self: Layer) Reset values of neurons containing in layer
---@field neurons Neuron[]

local AI = {
    ---@type Layer[]
    layers = {},
    mistake = { value = 0, div = 0 },
    setuped = false,
    filterSize = 3,
    stride = 1,
    padding = 0,
}

---@param x number
---@param method? string
---@return number
function AI:activate(x, method)
    if method == 'relu' then
        return math.max(0, x)
    else
        return 1 / (1 + math.exp(-x))
    end
end

---@param id integer
---@return Layer
function AI:getLayer(id)
    return AI.layers[id]
end

---@return number
function AI:random()
    return ( math.random() - math.random() ) * 10
end

---@param connectionsAmount number
---@param randomize? boolean
---@param method? string
---@return Neuron
function AI:createNeuron(connectionsAmount, randomize, method)
    local neuron = {
        weights = {},
        bias = randomize and AI:random() or 0,
        value = 0,
        method = method or 'sigmoid'
    }

    for i = 1, connectionsAmount do
        neuron.weights[i] = randomize and AI:random() or 0
    end

    return neuron
end

---@return Layer
function AI:createBaseLayer()
    return {
        ---@param self Layer
        getValues = function(self)
            local values = {}
            for _, neuron in ipairs(self.neurons) do
                table.insert(values, neuron.value)
            end
            return values
        end,
        ---@param self Layer
        resetValues = function(self)
            for _, neuron in ipairs(self.neurons) do
                neuron.value = 0
            end
        end,
        neurons = {},
    }
end

---@param data number[]
function AI:addInputLayer(data)
    AI.layers[1] = AI:createBaseLayer()

    for i = 1, #data do
        table.insert(AI.layers[1].neurons, { value = data[i], weights = {}, bias = data[i] })
    end
end

---@param size number
---@param method? string
function AI:addLayer(size, method)
    local previousLayerSize = #AI:getLayer(#AI.layers).neurons

    table.insert(AI.layers, AI:createBaseLayer())

    local id = #AI.layers
    for _ = 1, size do
        table.insert(AI:getLayer(id).neurons, AI:createNeuron(previousLayerSize, true, method))
    end
end

function AI:reset()
    AI.layers = {}
    AI.setuped = false
end

---@param data number[]
---@param layersAmount number
---@param layersSizes number[]
function AI:setup(data, layersAmount, layersSizes)
    if AI.setuped then
        return
    end
    AI:addInputLayer(data)
    for i = 1, layersAmount do
        AI:addLayer(layersSizes[i])
    end
    AI.setuped = true
end

---@param input number[]
---@param filter number[]
---@return number[]
function AI:applyFilter(input, filter)
    local filterSize = AI.filterSize
    local stride = AI.stride
    local padding = AI.padding

    local inputSize = #input
    local outputSize = math.floor((inputSize - filterSize + 2 * padding) / stride + 1)
    local output = {}

    for i = 1, outputSize do
        output[i] = {}
        for j = 1, outputSize do
            local sum = 0
            for fi = 1, filterSize do
                for fj = 1, filterSize do
                    local inputX = (i - 1) * stride + fi
                    local inputY = (j - 1) * stride + fj
                    if inputX <= inputSize and inputY <= inputSize then
                        sum = sum + input[inputX][inputY] * filter[fi][fj]
                    end
                end
            end
            output[i][j] = AI:activate(sum)
        end
    end

    return output
end

function AI:resetValues()
    for step = 2, #AI.layers do
        AI.layers[step]:resetValues()
    end
end

function AI:main()
    if not AI.setuped then
        return
    end

    -- Forward pass through the remaining layers
    for step = 2, #AI.layers do
        local previousLayer = AI:getLayer(step - 1)
        local currentLayer = AI:getLayer(step)

        for _, neuron in ipairs(currentLayer.neurons) do
            neuron.value = neuron.bias
            for i, weight in ipairs(neuron.weights) do
                neuron.value = neuron.value + previousLayer.neurons[i].value * weight
            end
            neuron.value = AI:activate(neuron.value, neuron.method)
        end
    end

    return true
end

---@param real number[]  -- Real values (for example, class labels)
---@param suggest Layer  -- The output layer of the neural network
function AI:updateMistake(real, suggest)
    local sumError = 0
    local values = suggest:getValues()

    assert(#real == #values, "The length of real values and suggested values must match")

    for i = 1, #real do
        local error = real[i] - values[i]
        sumError = sumError + error^2
    end

    AI.mistake.value = AI.mistake.value + sumError
    AI.mistake.div = AI.mistake.div + 1
end

function AI:getAvgMistake()
    if AI.mistake.div == 0 then
        return 0
    end
    return AI.mistake.value / AI.mistake.div
end

---@return Layer
function AI:getOutput()
    return AI.layers[#AI.layers]
end

return AI
