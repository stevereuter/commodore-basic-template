-- in Aseprite, go to File->Scripts->Open Scripts Folder, add this file to that folder and restart Aseprite.
-- This will now show in the File->Scripts menu.
-- Then you can select a character layer and click the script from the menu
-- to export the characters as DATA statements in a .bas file.

-- This script creates character bytes for a standard hi-res character set.
-- The sprite size must be a grid of 8x8 character cells.
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
local celX = cel.position.x
local celY = cel.position.y

if (sprite.width % 8) ~= 0 or (sprite.height % 8) ~= 0 then
    return app.alert("Sprite size must be a multiple of 8 in both width and height.")
end

local output = "# C64 Standard Character Data Export from Aseprite\n"
output = output .. "# Layer: " .. layer.name .. "\n"
output = output .. "# Grid: " .. (sprite.width / 8) .. "x" .. (sprite.height / 8) .. " characters\n"

local charsPerRow = sprite.width / 8
local charRows = sprite.height / 8
local totalChars = charsPerRow * charRows

for charIndex = 0, totalChars - 1 do
    local charX = (charIndex % charsPerRow) * 8
    local charY = math.floor(charIndex / charsPerRow) * 8

    output = output .. "data "

    for y = 0, 7 do
        local byteValue = 0
        for x = 0, 7 do
            -- Read pixel and build byte using C64 bit weights.
            local sampleX = charX + x - celX
            local sampleY = charY + y - celY
            local pixel = 0

            if sampleX >= 0 and sampleX < image.width and sampleY >= 0 and sampleY < image.height then
                pixel = image:getPixel(sampleX, sampleY)
            end

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
app.alert("Exported " .. totalChars .. " characters successfully from layer '" .. layer.name .. "'.\nSaved: " .. outputPath)
