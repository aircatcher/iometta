function redHue(x)
--x is percentage. Algorythm based on graph analysis
	local y
	if ( x <= 1/6  or  x >= 5/6 ) then
		y = 1
	elseif ( x >= 2/6  and x <= 4/6 ) then
		y = 0
	elseif ( x > 1/6 and x < 2/6 ) then
		y = (1 - 6 * (x - 1/6))
	elseif ( x > 4/6 and x < 5/6) then
		y = (6 * (x - 4/6))
	end
	return y * 255
end

function greenHue(x)
--x is percentage. Algorythm based on graph analysis
	local y
	if ( x >= 1/6 and x <= 3/6 ) then
		y = 1
	elseif ( x >= 4/6) then
		y = 0
	elseif ( x < 1/6 ) then
		y = x * 6
	elseif ( x > 3/6 and x < 4/6) then
		y = (1 - 6 * (x - 3/6))
	end
	return y * 255
end

function blueHue(x)
--x is percentage. Algorythm based on graph analysis
	local y
	if ( x <= 2/6 ) then
		y = 0
	elseif ( x >= 3/6 and x  <= 5/6 ) then
		y = 1
	elseif ( x >= 5/6) then
		y = (1 - 6  * (x - 5/6))
	elseif ( x > 2/6 and x < 3/6) then
		y = 6 * (x - 2/6)
	end
	return y * 255
end

--[[deprecated ParseColor function
function ParseColor(c)
--parse color segments from string 'c' then return table of 3 numbers (base 10)
	local rgb = {}
--	SKIN:Bang('!Log', c, 'Debug')
	local result = {}
	if (string.find(c, ",") ~= nil) then
		--find comma & extract substring
		local comma = string.find(c, ",")
		rgb[1] = tonumber(string.sub(c, 1, (comma-1)), 10)
		--find 2nd comma & extract substring
		comma = string.find(c, ",", comma)
		rgb[2] = tonumber(string.sub(c, comma+1, string.find(c, ",", comma+1)-1), 10)
		--extract substring from last comma to string.len(c)
		comma = string.find(c, ",", comma+1)
		rgb[3] = tonumber(string.sub(c, comma+1, -1), 10)
	else
		--assumes a 6 digit hex code
		rgb[1] = tonumber(string.sub(c, 1, 2), 16)
		rgb[2] = tonumber(string.sub(c, 3, 4), 16)
		rgb[3] = tonumber(string.sub(c, 5, 6), 16)
	end--end make table of {red, green, blue}

	return rgb
end--end parse color
]]--

function getHue(rgb)
	
	local hue
	if rgb[1] >= rgb[2] and rgb[2] >= rgb[3] then
		hue = (((rgb[2] - rgb[3]) / (rgb[1] - rgb[3])))
	elseif rgb[2] >= rgb[1] and rgb[1] >= rgb[3] then
		hue = (((rgb[1] - rgb[3]) / (rgb[2] - rgb[3])) + 1)
	elseif rgb[2] >= rgb[3] and rgb[3] >= rgb[1] then
		hue = (((rgb[2] - rgb[1]) / (rgb[2] - rgb[1])) + 2)
	elseif rgb[3] >= rgb[2] and rgb[2] >= rgb[1] then
		hue = (((rgb[2] - rgb[1]) / (rgb[3] - rgb[1])) + 3)
	elseif rgb[3] >= rgb[1] and rgb[1] >= rgb[2] then
		hue = (((rgb[1] - rgb[2]) / (rgb[3] - rgb[2])) + 4)
	elseif rgb[1] >= rgb[3] and rgb[3] >= rgb[2] then
		hue = (((rgb[3] - rgb[2]) / (rgb[1] - rgb[2])) + 5)
	end

	if hue < 0.0 then
		hue = hue + 6
	end

	return hue / 6
	
end

function getSat(rgb)
	local Min = math.min(tonumber(rgb[1]), tonumber(rgb[2]), tonumber(rgb[3])) / 255
	local Max = math.max(tonumber(rgb[1]), tonumber(rgb[2]), tonumber(rgb[3])) / 255
	local chroma = Max - Min
--	SKIN:Bang('!Log', "Min = " .. Min, 'Debug')
--	SKIN:Bang('!Log', "Max = " .. Max, 'Debug')
	return chroma / Max
end

function getVal(rgb)
	local Max = math.max(tonumber(rgb[1]), tonumber(rgb[2]), tonumber(rgb[3])) / 255
	return Max
end

function RGBtoHex(color) 
--[[ 
Converts RGB colors to HEX. Code snippet from rainmeter.net
Modified to set variables 'Hue' & 'ActiveHex'
]]--
	local hex = {}
	local rgb = {}
	for seg in color:gmatch('%d+') do
		table.insert(hex, ('%02X'):format(tonumber(seg)))
		table.insert(rgb, tonumber(seg))
	end
--[[for debug
	for i = 1, 3, 1 do
		SKIN:Bang('!Log', i .. " = " .. rgb[i], 'Debug')
	end--debug result
]]--
	Hue = getHue(rgb)
	Sat = getSat(rgb)
	Val = getVal(rgb)
	SKIN:Bang('!SetVariable', 'ActiveHex', table.concat(hex) )
	SKIN:Bang('!SetVariable', 'Hue', Hue)
	SKIN:Bang('!SetVariable', 'Sat', Sat)
	SKIN:Bang('!SetVariable', 'Val', Val)
end

function HexToRGB(color)
--[[ 
Converts HEX colors to RGB. Code snippet from rainmeter.net
Modified to set variables 'Hue' & 'ActiveRGB'
]]--
	local rgb = {}
	for seg in color:gmatch('..') do
		table.insert(rgb, tonumber(seg, 16))
	end
--[[for debug
	for i = 1, 3, 1 do
		SKIN:Bang('!Log', i .. " = " .. rgb[i], 'Debug')
	end--debug result
]]--
	Hue = getHue(rgb)
	Sat = getSat(rgb)
	Val = getVal(rgb)
	SKIN:Bang('!SetVariable', 'ActiveRGB', table.concat(rgb, ',') )
	SKIN:Bang('!SetVariable', 'Hue', Hue)
	SKIN:Bang('!SetVariable', 'Sat', Sat)
	SKIN:Bang('!SetVariable', 'Val', Val)
end

function HSVtoRGB()
	local h = Hue * 6
	local chroma = Val * Sat
	local mid = chroma * (1 - math.abs(h % 2 - 1))
	local Match = Val - chroma
--[[for Debug
	SKIN:Bang('!Log', "h = " .. h, 'Debug')
	SKIN:Bang('!Log', "Chroma = " .. chroma, 'Debug')
	SKIN:Bang('!Log', "mid = " .. mid, 'Debug')
	SKIN:Bang('!Log', "match = " .. Match, 'Debug')
]]--
	local rgb = {}
	if 0 <= h and h < 1 then
		rgb[1] = 255 * (chroma + Match)
		rgb[2] = 255 * (mid + Match)
		rgb[3] = 255 * (0 + Match)
	elseif 1 <= h and h < 2 then
		rgb[1] = 255 * (mid + Match)
		rgb[2] = 255 * (chroma + Match)
		rgb[3] = 255 * (0 + Match)
	elseif 2 <= h and h < 3 then
		rgb[1] = 255 * (0 + Match)
		rgb[2] = 255 * (chroma + Match)
		rgb[3] = 255 * (mid + Match)
	elseif 3 <= h and h < 4 then
		rgb[1] = 255 * (0 + Match)
		rgb[2] = 255 * (mid + Match)
		rgb[3] = 255 * (chroma + Match)
	elseif 4 <= h and h < 5 then
		rgb[1] = 255 * (mid + Match)
		rgb[2] = 255 * (0 + Match)
		rgb[3] = 255 * (chroma + Match)
	elseif 5 <= h and h <= 6 then
		rgb[1] = 255 * (chroma + Match)
		rgb[2] = 255 * (0 + Match)
		rgb[3] = 255 * (mid + Match)
	end--set rgb table
--[[for Debug
	for i = 1, 3, 1 do
		SKIN:Bang('!Log', i .. " = " .. rgb[i], 'Debug')
	end
]]--
	local hex = {}
	for i = 1, 3, 1 do
		table.insert(hex, ('%02X'):format(math.floor(rgb[i] + 0.5)))
		rgb[i] = math.floor(rgb[i] + 0.5)
	end
	SKIN:Bang('!SetVariable', 'ActiveRGB', table.concat(rgb, ',') )
	SKIN:Bang('!SetVariable', 'ActiveHex', table.concat(hex) )

end

function Update()
	--hue, saturation, annd value must be a percentage in range 0.0 - 1.0
	Hue = tonumber(SKIN:GetVariable('Hue'))
	Sat = tonumber(SKIN:GetVariable('Sat'))
	Val = tonumber(SKIN:GetVariable('Val'))
	hueColor = { ('%02X'):format(math.floor(redHue(Hue) + 0.5)), ('%02X'):format(math.floor(greenHue(Hue) + 0.5)), ('%02X'):format(math.floor(blueHue(Hue) + 0.5)) }
	SKIN:Bang('!SetVariable', 'HueColor', table.concat(hueColor) )

	return hueColor
end