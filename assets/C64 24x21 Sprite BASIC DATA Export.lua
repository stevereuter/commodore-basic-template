-- in Aseprite, go to File->Scripts->Open Scripts Folder, add this file to that folder and restart Aseprite.
-- This will now show in the File->Scripts menu.
-- Then select a sprite layer and click the script from the menu
-- to export one C64 24x21 hi-res sprite as DATA statements in a .bas file.

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
	return app.alert("Please select a cel on the sprite layer first.")
end

if sprite.width ~= 24 or sprite.height ~= 21 then
	return app.alert("Sprite size must be exactly 24x21 pixels for C64 sprite export.")
end

local image = cel.image
local celX = cel.position.x
local celY = cel.position.y

local output = "# C64 24x21 Sprite Data Export from Aseprite\n"
output = output .. "# Layer: " .. layer.name .. "\n"
output = output .. "# Format: 7 data lines, 3 sprite rows per line\n"

for block = 0, 6 do
	output = output .. "data "
	local values = {}

	-- Each block contains 3 pixel rows; each row is 3 bytes (24 pixels).
	for rowInBlock = 0, 2 do
		local y = block * 3 + rowInBlock

		for byteIndex = 0, 2 do
			local byteValue = 0

			for bit = 0, 7 do
				local x = byteIndex * 8 + bit
				local sampleX = x - celX
				local sampleY = y - celY
				local pixel = 0

				if sampleX >= 0 and sampleX < image.width and sampleY >= 0 and sampleY < image.height then
					pixel = image:getPixel(sampleX, sampleY)
				end

				if pixel > 0 then
					byteValue = byteValue + (2 ^ (7 - bit))
				end
			end

			table.insert(values, string.format("%d", byteValue))
		end
	end

	output = output .. table.concat(values, ",") .. "\n"
end

-- Save the file for VS64 BASIC
local safeLayerName = layer.name:gsub("[^%w%-_]", "_")
local outputPath = sprite.filename:gsub("%.aseprite$", "_" .. safeLayerName .. "_c64_sprite.bas")
local file = io.open(outputPath, "w")

if not file then
	return app.alert("Unable to write output file:\n" .. outputPath)
end

file:write(output)
file:close()
app.alert("Exported C64 sprite data successfully from layer '" .. layer.name .. "'.\nSaved: " .. outputPath)
