local x, y, z
local startX, startY, startZ = gps.locate()
local endX, endY, endZ = 0, 0, 0
local targetX, targetY, targetZ = endX, endY, endZ
local diffX, diffY, diffZ = startX - endX, startY - endY, startZ - endZ
local running = true

local forwardX = true
local leftTurn = true

local function digForward()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()
end

local function equipStoneBlock()
    local itemDetail = turtle.getItemDetail(nil, true)
    if itemDetail == nil or not (itemDetail["tags"]["forge:stone"] or itemDetail["tags"]["forge:cobblestone"]) then
        for i = 1, 16, 1 do
            local itemDetails = turtle.getItemDetail(i, true)
            if itemDetails ~= nil then
                local itemTags = itemDetails["tags"]
                if itemTags["forge:stone"] or itemTags["forge:cobblestone"] then
                    turtle.select(i)
                    return
                end
            end
        end
        print("Error: out of stone or cobblestone type blocks.")
    end
end

local function placeBlockAboveIfWater()
    local blockPresent, blockData = turtle.inspectUp()
    if blockData.name == "minecraft:water" then
        equipStoneBlock()
        turtle.placeUp()
    end
end

local function zigZagToLocation()
    -- End condition
    if x == targetX and y == endY and z == endZ then
        running = false
        return
    end
    -- End of row and column condition
    if x == targetX and z == endZ then
        -- Descend
        if turtle.detectDown() then
            turtle.digDown()
        end
        turtle.down()
        -- U-turn
        turtle.turnLeft()
        turtle.turnLeft()
        -- Swap start and end (Lua evaluates left side first, can swap without temp vars)
        startX, endX = endX, startX
        startZ, endZ = endZ, startZ
        if targetX == endX and targetX == x then
            targetX = startX
        elseif targetX == startX and targetX == x then
            targetX = endX
        end
    -- End of column condition
    elseif x == targetX then
        -- Turn, move Z forward 1, turn, continue on x
        if leftTurn then
            turtle.turnLeft()
            digForward()
            placeBlockAboveIfWater()
            turtle.turnLeft()
            leftTurn = false
        else
            turtle.turnRight()
            digForward()
            placeBlockAboveIfWater()
            turtle.turnRight()
            leftTurn = true
        end
        if targetX == endX then
            targetX = startX
        else
            targetX = endX
        end
    else
        digForward()
    end
end

if endX == 0 and endY == 0 and endZ == 0 then
    print("Error: missing coordinates at top of file.")
    return
end
while running do
    x, y, z = gps.locate()
    zigZagToLocation()
    placeBlockAboveIfWater()
end
