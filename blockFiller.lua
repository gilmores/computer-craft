local x, y, z
 
while true do
    x, y, z = gps.locate()
    print("x: "..x)
    print("y: "..y)
    print("z: "..z)
    sleep(1)
end
 
local function moveToLocation()
 
end
 