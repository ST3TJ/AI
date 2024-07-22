---@class Neuron
---@field weights number[]
---@field bias number
---@field value number
---@field method string

---@class Layer
---@field GetValues fun(self: Layer): number[] Return value of neurons containing in layer
---@field ResetValues fun(self: Layer) Reset values of neurons containing in layer
---@field neurons Neuron[]

local AI = {
    ---@type Layer[]
    layers = {},
    setuped = false,
    filter_size = 3,
    stride = 1,
    padding = 0
}

---@param x number
---@param method? string
---@return number
function AI:Activate(x, method)
    if method == 'relu' then
        return math.max(0, x)
    else
        return 1 / (1 + math.exp(-x))
    end
end

---@param id integer
---@return Layer
function AI:GetLayer(id)
    return AI.layers[id]
end

---@return number
function AI:Random()
    return math.random() - math.random()
end

---@param connections_amount number
---@param randomize? boolean
---@param method? string
---@return Neuron
function AI:CreateNeuron(connections_amount, randomize, method)
    local neuron = {
        weights = {},
        bias = randomize and AI:Random() or 0,
        value = 0,
        method = method,
    }

    for i = 1, connections_amount do
        neuron.weights[i] = randomize and AI:Random() or 0
    end

    return neuron
end

---@return Layer
function AI:CreateBaseLayer()
    return {
        ---@param self Layer
        GetValues = function(self)
            local values = {}
            for _, neuron in ipairs(self.neurons) do
                table.insert(values, neuron.value)
            end
            return values
        end,
        ---@param self Layer
        ResetValues = function(self)
            for _, neuron in ipairs(self.neurons) do
                neuron.value = 0
            end
        end,
        neurons = {},
    }
end

---@param data number[]
function AI:AddInputLayer(data)
    AI.layers[1] = AI:CreateBaseLayer()

    for i = 1, #data do
        table.insert(AI.layers[1].neurons, { value = data[i], weights = {}, bias = 0 })
    end
end

---@param size number
---@param method? string
function AI:AddLayer(size, method)
    local previous_layer_size = #AI:GetLayer(#AI.layers).neurons

    table.insert(AI.layers, AI:CreateBaseLayer())

    local id = #AI.layers
    for _ = 1, size do
        table.insert(AI:GetLayer(id).neurons, AI:CreateNeuron(previous_layer_size, true, method))
    end
end

function AI:Reset()
    AI.layers = {}
    AI.setuped = false
end

---@param data number[]
---@param layers_amount number
---@param layers_sizes number[]
function AI:Setup(data, layers_amount, layers_sizes)
    if AI.setuped then
        return
    end
    AI:AddInputLayer(data)
    for i = 1, layers_amount do
        AI:AddLayer(layers_sizes[i])
    end
    AI.setuped = true
end

---@param input number[]
---@param filter number[]
---@return number[]
function AI:ApplyFilter(input, filter)
    local filter_size = AI.filter_size
    local stride = AI.stride
    local padding = AI.padding

    local input_size = #input
    local output_size = math.floor((input_size - filter_size + 2 * padding) / stride + 1)
    local output = {}

    for i = 1, output_size do
        output[i] = {}
        for j = 1, output_size do
            local sum = 0
            for fi = 1, filter_size do
                for fj = 1, filter_size do
                    local input_x = (i - 1) * stride + fi
                    local input_y = (j - 1) * stride + fj
                    if input_x <= input_size and input_y <= input_size then
                        sum = sum + input[input_x][input_y] * filter[fi][fj]
                    end
                end
            end
            output[i][j] = AI:Activate(sum)
        end
    end

    return output
end

function AI:ResetValues()
    for step = 2, #AI.layers do
        AI.layers[step]:ResetValues()
    end
end

function AI:Main()
    if not AI.setuped then
        return
    end

    --[[
    Eto prosto pizda kakayto 😢

    local filters = {
        {
            {1, 0, -1},
            {1, 0, -1},
            {1, 0, -1}
        },
        {
            {1, 1, 1},
            {0, 0, 0},
            {-1, -1, -1}
        }
    }

    local input_layer = AI:GetLayer(1)
    local input_values = input_layer:GetValues()

    local conv_output = {}
    for _, filter in ipairs(filters) do
        local result = AI:ApplyFilter(input_values, filter)
        table.insert(conv_output, result)
    end

    -- Flatten convolution output and set as input to the next layer
    local flat_conv_output = {}
    for _, feature_map in ipairs(conv_output) do
        for i = 1, #feature_map do
            for j = 1, #feature_map[i] do
                table.insert(flat_conv_output, feature_map[i][j])
            end
        end
    end

    -- Create a new input layer with the flattened convolution output
    AI.layers[2] = AI:CreateBaseLayer()
    for _, value in ipairs(flat_conv_output) do
        table.insert(AI.layers[2].neurons, { value = value, weights = {}, bias = 0 })
    end
    ]]

    -- Forward pass through the remaining layers
    for step = 2, #AI.layers do
        local previous_layer = AI:GetLayer(step - 1)
        local current_layer = AI:GetLayer(step)

        for _, neuron in ipairs(current_layer.neurons) do
            neuron.value = neuron.bias
            for i, weight in ipairs(neuron.weights) do
                neuron.value = neuron.value + previous_layer.neurons[i].value * weight
            end
            neuron.value = AI:Activate(neuron.value, neuron.method)
        end
    end

    return true
end

---@return Layer
function AI:GetOutput()
    return AI.layers[#AI.layers]
end

return AI