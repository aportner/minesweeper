return function(oldTable)
    local newTable = {}

    for k, v in pairs(oldTable) do
        newTable[k] = v
    end

    return newTable
end