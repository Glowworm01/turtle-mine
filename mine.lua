print("Press enter to start mining:")
io.read()

local fuelLimit = turtle.getFuelLimit()
local blockBlacklist = {'minecraft:cobblestone', 'minecraft:stone', 'minecraft:dirt', 'minecraft:gravel', 'rustic:slate', 'chisel:basalt2'}
local fuelList =  {'minecraft:coal', 'minecraft:coal_block', 'minecraft:stick', 'minecraft:planks', 'minecraft:log', 'ic2:coke', 'railcraft:fuel_coke'}

local has_value = function(tab, val) --I stole most of this
    for index, value in ipairs(tab) do
        return value == val
    end

    return false
end

local checkBlock = function()
    success, block = turtle.inspect()
    if success then
        if has_value(blockBlacklist, block.name) == false then
            turtle.dig()
        end
    end
end

local checkDown = function()
    success, block = turtle.inspectDown()
    if success then
        if has_value(blockBlacklist, block.name) == false then
            turtle.digDown()
        end
    end
end

local checkUp = function()
    success, block = turtle.inspectUp()
    if success then
        if has_value(blockBlacklist, block.name) == false then
            turtle.digUp()
        end
    end
end

local search = function()
    checkDown()
    turtle.turnLeft()
    checkBlock()
    turtle.up()
    checkBlock()
    checkUp()
    for i=1, 2 do
        turtle.turnRight()
    end
    checkBlock()
    turtle.down()
    checkBlock()
    turtle.turnLeft()
end

local cleanInventory = function()
    for i=1, 16 do
        turtle.select(i)
        selectedItem = turtle.getItemDetail()
        if selectedItem ~= nil then
            if has_value(blockBlacklist, selectedItem.name) then
                turtle.drop(selectedItem.count)
            end
        end
    end
end

local attemptRefuel = function()
    fuelLevel = turtle.getFuelLevel()
    print('Attempting to refuel...')
    for i=1, 16 do
        turtle.select(i)
        selectedItem=turtle.getItemDetail()
        if selectedItem ~= nil then
            if has_value(fuelList, selectedItem.name) then
                turtle.refuel()
            end
        end
    end
    if fuelLevel < turtle.getFuelLevel() then
        print('Refueled!')
        return true
    end
end

local breakBlock = function()
    turtle.dig()
    turtle.digUp()
end

while true do
    selectedItem = turtle.getItemDetail()
    fuelLevel = turtle.getFuelLevel()
    blockCount = 0

    attemptRefuel()
    fuelLevel = turtle.getFuelLevel()

    print('Current fuel level is', fuelLevel,'/',fuelLimit)
    returnFuel = math.floor((fuelLevel + 0.5)/4)

    while fuelLevel > returnFuel do
        breakBlock()
        search()
        cleanInventory()
        if turtle.forward() then
            fuelLevel = turtle.getFuelLevel()
            blockCount = blockCount + 1
        end
        print('Will continue for', (fuelLevel - returnFuel), 'blocks')
    end

    turtle.turnRight()
    turtle.turnRight()

    while blockCount > 0 do
        if turtle.forward() then
            blockCount = blockCount - 1
            print('Heading home,', blockCount, 'blocks left')
        end
        turtle.dig()
    end
end