local x, y, z
local startX, startY, startZ = gps.locate()
local endX, endY, endZ = 21, 77, -36
local targetX, targetY, targetZ = endX, endY, endZ
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
    if x == targetX and y == targetY and z == targetZ then
        running = false
    end
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

    sleep(0.5)
end
