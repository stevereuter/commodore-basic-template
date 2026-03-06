-- in Aseprite, go to File->Scripts->Open Scripts Folder, add this file to that folder and restart Aseprite.
-- This will now show in the File->Scripts menu.
-- Then you can select the Tilemap and click the script from the menu to export the characters as data statement in a .bas file.

-- This script is for creating character bytes for a standard hi res character set. One character per data statement (256 line)
local sprite = app.activeSprite
local layer = app.activeLayer

if not layer or not layer.isTilemap then
    return app.alert("Please select a Tilemap layer first.")
end

local tileset = layer.tileset
local output = "# C64 Standard Character Data Export from Aseprite\n"

-- The C64 index we are currently writing (starting at 0)
local c64Index = 0

-- Start at 1 to skip the system's default empty tile (Tile 0), we actually need this at 32.
for i = 1, #tileset - 1 do
    -- We've reached index 32 and it needs to be a space,
    -- Aseprite ignores empty tiles so it's not included.
    if c64Index == 32 then
        output = output .. "data 0,0,0,0,0,0,0,0\n"
        c64Index = c64Index + 1
    end
    
    local tileImage = tileset:getTile(i)
    output = output .. "data "
    
    for y = 0, 7 do
        local byteValue = 0
        for x = 0, 7 do
            -- Get pixel and add to byte using C64 bit weights
            local pixel = tileImage:getPixel(x, y)
            if pixel > 0 then
                byteValue = byteValue + (2 ^ (7 - x))
            end
        end
        output = output .. string.format("%d", byteValue) .. (y < 7 and "," or "")
    end
    output = output .. "\n"
    c64Index = c64Index + 1
end

-- Save the file for VS64 BASIC
local file = io.open(sprite.filename:gsub(".aseprite", ".bas"), "w")
file:write(output)
file:close()
app.alert("Exported tiles 1 to " .. (#tileset-1) .. " with C64 index 32 successfully!")
