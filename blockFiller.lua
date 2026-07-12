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
        sleep(0.5)
    end
    turtle.forward()
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
    end
    -- End of column condition
    if x == targetX then
        -- Turn, move Z forward 1, turn, continue on x
        if leftTurn then
            turtle.turnLeft()
            digForward()
            turtle.turnLeft()
            leftTurn = false
        else
            turtle.turnRight()
            digForward()
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

while running do
    x, y, z = gps.locate()
    zigZagToLocation()
end
