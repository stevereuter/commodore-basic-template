-- in Aseprite, go to File->Scripts->Open Scripts Folder, add this file to that folder and restart Aseprite.
-- This will now show in the File->Scripts menu.
-- Then you can select a 128x128 character layer and click the script from the menu
-- to export the characters as DATA statements in a .bas file.

-- This script creates character bytes for a standard hi-res character set.
-- The selected layer must contain a full 16x16 grid of 8x8 characters (256 total).
local sprite = app.activeSprite
local layer = app.activeLayer
local cel = app.activeCel

if not sprite then
    return app.alert("Please open a sprite first.")
end

if not layer or layer.isTilemap then
    return app.alert("Please select a regular image layer, not a tilemap.")
end

if not cel or cel.layer ~= layer then
    return app.alert("Please select a cel on the character layer first.")
end

local image = cel.image
if image.width ~= 128 or image.height ~= 128 then
    return app.alert("Layer image must be exactly 128x128 pixels (16x16 characters).")
end

local output = "# C64 Standard Character Data Export from Aseprite\n"
output = output .. "# Layer: " .. layer.name .. "\n"

local charsPerRow = 16
local totalChars = 256

for charIndex = 0, totalChars - 1 do
    local charX = (charIndex % charsPerRow) * 8
    local charY = math.floor(charIndex / charsPerRow) * 8

    output = output .. "data "

    for y = 0, 7 do
        local byteValue = 0
        for x = 0, 7 do
            -- Read pixel and build byte using C64 bit weights.
            local pixel = image:getPixel(charX + x, charY + y)
            if pixel > 0 then
                byteValue = byteValue + (2 ^ (7 - x))
            end
        end
        output = output .. string.format("%d", byteValue) .. (y < 7 and "," or "")
    end
    output = output .. "\n"
end

-- Save the file for VS64 BASIC
local safeLayerName = layer.name:gsub("[^%w%-_]", "_")
local outputPath = sprite.filename:gsub("%.aseprite$", "_" .. safeLayerName .. "_c64_chars.bas")
local file = io.open(outputPath, "w")

if not file then
    return app.alert("Unable to write output file:\n" .. outputPath)
end

file:write(output)
file:close()
app.alert("Exported 256 characters successfully from layer '" .. layer.name .. "'.\nSaved: " .. outputPath)
