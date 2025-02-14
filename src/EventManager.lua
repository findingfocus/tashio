Event.on('event-test', function (testValue)
    local name = 'testing'
    local testData = {1, 2, 3}
    local testValue = testValue

    local data = {}
    table.insert(data, 'name: ' .. name)
    table.insert(data, 'testData: ' .. Inspect(testData))
    table.insert(data, 'dt: ' .. Inspect(testValue))
    return data
end)
