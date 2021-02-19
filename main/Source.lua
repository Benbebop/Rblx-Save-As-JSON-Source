local httpService = game:GetService("HttpService") -- Requires HTTPService but whatever I'm not coding around it
local studioservice = game:GetService("StudioService")

local compressQuality = 0

local nonpc = {"\0", "\a", "\b", "\t", "\n", "\v", "\f", "\r"}
local basedictcompress = {}
local basedictdecompress = {}
for i = 0, 255 do
	local ic, iic = string.char(i), string.char(i, 0)
	basedictcompress[ic] = iic
	basedictdecompress[iic] = ic
end

local function dictAddA(str, dict, a, b)
	if a >= 256 then
		a, b = 0, b+1
		if b >= 256 then
			dict = {}
			b = 1
		end
	end
	dict[str] = string.char(a,b)
	a = a+1
	return dict, a, b
end

function compressString(input)
	if type(input) ~= "string" then
		return nil, "string expected, got "..type(input)
	end
	local len = #input
	if len <= 1 then
		return "u"..input
	end

	local dict = {}
	local a, b = 0, 1

	local result = {"c"}
	local resultlen = 1
	local n = 2
	local word = ""
	for i = 1, len do
		local c = string.sub(input, i, i)
		local wc = word..c
		if not (basedictcompress[wc] or dict[wc]) then
			local write = basedictcompress[word] or dict[word]
			if not write then
				return nil, "algorithm error, could not fetch word"
			end
			result[n] = write
			resultlen = resultlen + #write
			n = n+1
			if  len <= resultlen then
				return "u"..input
			end
			dict, a, b = dictAddA(wc, dict, a, b)
			word = c
		else
			word = wc
		end
	end
	result[n] = basedictcompress[word] or dict[word]
	resultlen = resultlen+#result[n]
	n = n+1
	if  len <= resultlen then
		return "u"..input
	end
	return table.concat(result)
end

local function dictAddB(str, dict, a, b)
	if a >= 256 then
		a, b = 0, b+1
		if b >= 256 then
			dict = {}
			b = 1
		end
	end
	dict[string.char(a,b)] = str
	a = a+1
	return dict, a, b
end

function decompressString(input)
	if type(input) ~= "string" then
		return nil, "string expected, got "..type(input)
	end

	if #input < 1 then
		return nil, "invalid input - not a compressed string"
	end

	local control = string.sub(input, 1, 1)
	if control == "u" then
		return string.sub(input, 2)
	elseif control ~= "c" then
		return nil, "invalid input - not a compressed string"
	end
	input = string.sub(input, 2)
	local len = #input

	if len < 2 then
		return nil, "invalid input - not a compressed string"
	end

	local dict = {}
	local a, b = 0, 1

	local result = {}
	local n = 1
	local last = string.sub(input, 1, 2)
	result[n] = basedictdecompress[last] or dict[last]
	n = n+1
	for i = 3, len, 2 do
		local code = string.sub(input, i, i+1)
		local lastStr = basedictdecompress[last] or dict[last]
		if not lastStr then
			return nil, "could not find last from dict. Invalid input?"
		end
		local toAdd = basedictdecompress[code] or dict[code]
		if toAdd then
			result[n] = toAdd
			n = n+1
			dict, a, b = dictAddB(lastStr..string.sub(toAdd, 1, 1), dict, a, b)
		else
			local tmp = lastStr..string.sub(lastStr, 1, 1)
			result[n] = tmp
			n = n+1
			dict, a, b = dictAddB(tmp, dict, a, b)
		end
		last = code
	end
	return table.concat(result)
end

local dataTypeFunctions = {
	["encode"] = {
		["Axes"] = function(v)return {v.X, v.Y, v.Z, v.Top, v.Bottom, v.Left, v.Right, v.Back, v.Front} end,
		["BrickColor"] = function(v)return tostring(v) end,
		["boolean"] = function(v)return v end,
		["CatalogSearchParams"] = function(v)return nil end,
		["CFrame"] = function(v)return table.pack(v:GetComponents()) end,
		["Color3"] = function(v)return {v.r, v.g, v.b} end,
		["ColorSequence"] = function(v) local keys = v.Keypoints local value = {} for j,x in ipairs(keys) do value[j] = {x.Time, {x.Value.r, x.Value.g, x.Value.b}} end return value end,
		["ColorSequenceKeypoint"] = function(v)return nil end,
		["DateTime"] = function(v)return nil end,
		["DockWidgetPluginGuiInfo"] = function(v)return nil end,
		["Enum"] = function(v)return nil end,
		["EnumItem"] = function(v)return {v.EnumType, v.Name} end,
		["Enums"] = function(v)return nil end,
		["Faces"] = function(v)return {v.Top, v.Bottom, v.Left, v.Right, v.Back, v.Front} end,
		["function"] = function(v)return nil end,
		["Instance"] = function(v)return v:GetDebugId() end,
		["nil"] = function(v)return nil end,
		["number"] = function(v)return v end,
		["NumberRange"] = function(v)return {v.Min, v.Max} end,
		["NumberSequence"] = function(v) local keys = v.Keypoints local value = {} for j,x in ipairs(keys) do value[j] = {x.Time, x.Value, x.Envelope} end return value end,
		["NumberSequenceKeypoint"] = function(v)return nil end,
		["PathWaypoint"] = function(v)return nil end,
		["PhysicalProperties"] = function(v)return {v.Density, v.Friction, v.Elasticity, v.FrictionWeight, v.ElasticityWeight} end,
		["Random"] = function(v)return nil end,
		["Ray"] = function(v)return nil end,
		["RaycastParams"] = function(v)return nil end,
		["RaycastResult"] = function(v)return nil end,
		["RBXScriptConnection"] = function(v)return nil end,
		["RBXScriptSignal"] = function(v)return nil end,
		["Rect"] = function(v)return {v.Min.X, v.Min.Y, v.Max.X, v.Max.Y} end,
		["Region3"] = function(v)return nil end,
		["Region3int16"] = function(v)return nil end,
		["string"] = function(v)return v end,
		["table"] = function(v)return v end,
		["TweenInfo"] = function(v)return nil end,
		["UDim"] = function(v)return {v.Scale, v.Offset} end,
		["UDim2"] = function(v)return {v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset} end,
		["userdata"] = function(v)return nil end,
		["Vector2"] = function(v)return {v.X, v.Y} end,
		["Vector2int16"] = function(v)return {v.X, v.Y} end,
		["Vector3"] = function(v)return {v.X, v.Y, v.Z} end,
		["Vector3int16"] = function(v)return {v.X, v.Y, v.Z} end
	},
	["decode"] = {
		["Axes"] = function(v)return Axes.new(table.unpack(v, 1, 9)) end,
		["BrickColor"] = function(v)return tostring(v) end,
		["boolean"] = function(v)return v end,
		["CatalogSearchParams"] = function(v)return nil end,
		["CFrame"] = function(v)return CFrame.new(table.unpack(v, 1, 12)) end,
		["Color3"] = function(v)return Color3.new(table.unpack(v, 1, 3)) end,
		["ColorSequence"] = function(v) local value = {} for j,x in ipairs(v) do value[j] = ColorSequenceKeypoint.new(x[1], Color3.new(table.unpack(x[2], 1, 3))) end return ColorSequence.new(value) end,
		["ColorSequenceKeypoint"] = function(v)return nil end,
		["DateTime"] = function(v)return nil end,
		["DockWidgetPluginGuiInfo"] = function(v)return nil end,
		["Enum"] = function(v)return nil end,
		["EnumItem"] = function(v)return Enum[v[1]][v[2]] end,
		["Enums"] = function(v)return nil end,
		["Faces"] = function(v)return Faces.new(table.unpack(v, 1, 6)) end,
		["function"] = function(v)return nil end,
		["Instance"] = function(v)return v end,
		["nil"] = function(v)return nil end,
		["number"] = function(v)return v end,
		["NumberRange"] = function(v)return NumberRange.new(table.unpack(v, 1, 2)) end,
		["NumberSequence"] = function(v) local value = {} for j,x in ipairs(v) do value[j] = NumberSequenceKeypoint.new(table.unpack(x, 1, 3)) end return NumberSequence.new(value) end,
		["NumberSequenceKeypoint"] = function(v)return nil end,
		["PathWaypoint"] = function(v)return nil end,
		["PhysicalProperties"] = function(v)return PhysicalProperties.new(table.unpack(v, 1, 5)) end,
		["Random"] = function(v)return nil end,
		["Ray"] = function(v)return nil end,
		["RaycastParams"] = function(v)return nil end,
		["RaycastResult"] = function(v)return nil end,
		["RBXScriptConnection"] = function(v)return nil end,
		["RBXScriptSignal"] = function(v)return nil end,
		["Rect"] = function(v)return Rect.new(table.unpack(v, 1, 4)) end,
		["Region3"] = function(v)return nil end,
		["Region3int16"] = function(v)return nil end,
		["string"] = function(v)return v end,
		["table"] = function(v)return v end,
		["TweenInfo"] = function(v)return nil end,
		["UDim"] = function(v)return UDim.new(table.unpack(v, 1, 2)) end,
		["UDim2"] = function(v)return UDim2.new(table.unpack(v, 1, 4)) end,
		["userdata"] = function(v)return nil end,
		["Vector2"] = function(v)return Vector2.new(table.unpack(v, 1, 2)) end,
		["Vector2int16"] = function(v)return Vector2int16.new(table.unpack(v, 1, 2)) end,
		["Vector3"] = function(v)return Vector3.new(table.unpack(v, 1, 3)) end,
		["Vector3int16"] = function(v)return Vector3int16.new(table.unpack(v, 1, 3)) end
	},
	["compress"] = {
		["Axes"] = function(v)return v end,
		["BrickColor"] = function(v)return v.Number end,
		["boolean"] = function(v)return v end,
		["CatalogSearchParams"] = function(v)return nil end,
		["CFrame"] = function(v)local components = table.pack(v:GetComponents()) for j,x in pairs(components) do components[j] = compressValue(x) end return CFrame.new(table.unpack(components)) end,
		["Color3"] = function(v)return Color3.new(compressValue(v.r), compressValue(v.g), compressValue(v.b)) end,
		["ColorSequence"] = function(v)local keys = v.Keypoints value = {} for j,x in ipairs(keys) do value[j] = ColorSequenceKeypoint.new(compressValue(x.Time), Color3.new(compressValue(x.Value.r), compressValue(x.Value.g), compressValue(x.Value.b)))end return ColorSequence.new(value) end,
		["ColorSequenceKeypoint"] = function(v)return nil end,
		["DateTime"] = function(v)return nil end,
		["DockWidgetPluginGuiInfo"] = function(v)return nil end,
		["Enum"] = function(v)return nil end,
		["EnumItem"] = function(v)return v end,
		["Enums"] = function(v)return nil end,
		["Faces"] = function(v)return v end,
		["function"] = function(v)return nil end,
		["Instance"] = function(v)return v end,
		["nil"] = function(v)return nil end,
		["number"] = function(v)return compressValue(v) end,
		["NumberRange"] = function(v)return NumberRange.new(compressValue(v.Min), compressValue(v.Max)) end,
		["NumberSequence"] = function(v)local keys = v.Keypoints value = {} for j,x in ipairs(keys) do value[j] = NumberSequenceKeypoint.new(compressValue(x.Time), compressValue(x.Value), compressValue(x.Envelope))end return NumberSequence.new(value) end,
		["NumberSequenceKeypoint"] = function(v)return nil end,
		["PathWaypoint"] = function(v)return nil end,
		["PhysicalProperties"] = function(v)return PhysicalProperties.new(compressValue(v.Density), compressValue(v.Friction), compressValue(v.Elasticity), compressValue(v.FrictionWeight), compressValue(v.ElasticityWeight)) end,
		["Random"] = function(v)return nil end,
		["Ray"] = function(v)return nil end,
		["RaycastParams"] = function(v)return nil end,
		["RaycastResult"] = function(v)return nil end,
		["RBXScriptConnection"] = function(v)return nil end,
		["RBXScriptSignal"] = function(v)return nil end,
		["Rect"] = function(v)return Rect.new(compressValue(v.Min.X), compressValue(v.Min.Y), compressValue(v.Max.X), compressValue(v.Max.Y)) end,
		["Region3"] = function(v)return nil end,
		["Region3int16"] = function(v)return nil end,
		["string"] = function(v)if #v > 2097152 then warn("string value too long, truncating") return string.sub(v, 1, 2097152) end return string.sub(v, 1, 2097152) end,
		["table"] = function(v)return v end,
		["TweenInfo"] = function(v)return nil end,
		["UDim"] = function(v)return UDim.new(compressValue(v.Scale), compressValue(v.Offset)) end,
		["UDim2"] = function(v)return UDim2.new(compressValue(v.X.Scale), compressValue(v.X.Offset), compressValue(v.Y.Scale), compressValue(v.Y.Offset)) end,
		["userdata"] = function(v)return nil end,
		["Vector2"] = function(v)return Vector2.new(compressValue(v.X), compressValue(v.Y)) end,
		["Vector2int16"] = function(v)return Vector2int16.new(compressValue(v.X), compressValue(v.Y)) end,
		["Vector3"] = function(v)return Vector3.new(compressValue(v.X), compressValue(v.Y), compressValue(v.Z)) end,
		["Vector3int16"] = function(v)return Vector3int16.new(compressValue(v.X), compressValue(v.Y), compressValue(v.Z)) end
	}
}

local toolbar = plugin:CreateToolbar("JSON Hierarchy")

local ClassProperties = {}

local scriptSourceLimit = 199999

local LIP = {};

--- Returns a table containing all the data from the INI file.
--@param fileName The name of the INI file to parse. [string]
--@return The table containing all data from the INI file. [table]
function LIP.load(file)
	local data = {};
	local section;
	for _,line in ipairs(string.split(file, "\n")) do
		local tempSection = string.match(line, '%[.+%]')
		if tempSection ~= nil then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			data[section] = data[section] or {};
		end
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if param and value ~= nil then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[section][param] = string.gsub(value, "[\r\n]", " ");
		end
	end
	return data;
end

function newDump(dumpContent, announce)
	local classIndex = {}

	for i=1,#dumpContent do
		classIndex[dumpContent[i].Name] = i
	end

	for i=1,#dumpContent do
		local class = dumpContent[i]
		local superclass = class
		local properties = {}
		repeat 
			for i,v in pairs(superclass.Members) do
				if v.MemberType == "Property" then
					properties[#properties + 1] = v.Name
				end
			end
			superclass = dumpContent[classIndex[superclass.Superclass]]
		until superclass == nil
		ClassProperties[class.Name] = properties
	end
	if announce == "_default" then
		print("Loaded default library")
	elseif announce ~= nil then
		print("Succesfully loaded library " .. announce)
	end
end

local Data = httpService:JSONDecode(httpService:GetAsync("https://raw.githubusercontent.com/Benbebop/Roblox-Repositories/main/APIDump.json"))["Classes"]

newDump(Data)

local importDump = toolbar:CreateButton("Manage Libraries", "Import a custom API Dump. You can use a .json file or a shortcut to a webpage (.url file).", "rbxassetid://6356177049")

importDump.ClickableWhenViewportHidden = true

local Export = toolbar:CreateButton("Export Complete JSON", "Export selected hierarchy as a .lua file (Rename to .json after saving). Stores all properties.", "rbxassetid://6347850604")

Export.ClickableWhenViewportHidden = true

local compressedExport = toolbar:CreateButton("Export Lossless JSON", "Compress (lossless) then export selected hierarchy as a .lua file (Rename to .json after saving). Only stores properties that are different then default.", "rbxassetid://6356137634")

compressedExport.ClickableWhenViewportHidden = true

local lossyExport = toolbar:CreateButton("Export Compressed JSON", "Compress then export selected hierarchy as a .lua file (Rename to .json after saving). Only stores properties that are different then default and truncates numbers.", "rbxassetid://6356126701")

lossyExport.ClickableWhenViewportHidden = true

local jsonImport = toolbar:CreateButton("Import JSON File", "Import a JSON hierarchy into the workspace.", "rbxassetid://6356873036")

jsonImport.ClickableWhenViewportHidden = true

local GitHub = toolbar:CreateButton("View Source Code", "", "rbxassetid://6357471307")

GitHub.ClickableWhenViewportHidden = true

local copyWidget = plugin:CreateDockWidgetPluginGui("copyWidget", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 100))

copyWidget.Title = "JSON Data"

local Box = Instance.new("TextBox", copyWidget)
Box.TextEditable = false
Box.ClearTextOnFocus = false
Box.BackgroundTransparency = 1
Box.Size = UDim2.new(1,0,1,-14)
Box.Position = UDim2.new(0,0,0,14)
Box.TextWrapped = true
Box.TextXAlignment = Enum.TextXAlignment.Left
Box.TextYAlignment = Enum.TextYAlignment.Top
Box.TextTruncate = Enum.TextTruncate.AtEnd

local Size = Instance.new("TextLabel", copyWidget)
Size.BackgroundTransparency = 1
Size.Size = UDim2.new(1,0,0,14)

local GitHubWidget = plugin:CreateDockWidgetPluginGui("GitHubWidget", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 500, 14, 500, 14))

GitHubWidget.Title = "Link"

local LinkBox = Instance.new("TextBox", GitHubWidget)
LinkBox.TextEditable = false
LinkBox.ClearTextOnFocus = false
LinkBox.BackgroundTransparency = 1
LinkBox.TextXAlignment = Enum.TextXAlignment.Left
LinkBox.Size = UDim2.new(1,0,0,14)
LinkBox.Text = "https://github.com/Benbebop/Rblx-Save-As-JSON-Source.git"

function update(value) -- Update JSON interface
	Box.Text = string.sub(value, 1, scriptSourceLimit)
	local fileSize = #value
	local fileSizeTruncated = fileSize
	local fileSizeString
	if fileSize > 1.126e+15 then
		fileSizeString = " PiB *Seriously, how is your computer even functioning?"
		fileSizeTruncated = fileSize / 1.126e+15
	elseif fileSize > 1e+15 then
		fileSizeString = " PB"
		fileSizeTruncated = fileSize / 1e+15
	elseif fileSize > 1e+12 then
		fileSizeString = " TB"
		fileSizeTruncated = fileSize / 1e+12
	elseif fileSize > 1e+9 then
		fileSizeString = " GB"
		fileSizeTruncated = fileSize / 1e+9
	elseif fileSize > 1e+6 then
		fileSizeString = " MB"
		fileSizeTruncated = fileSize / 1e+6
	elseif fileSize > 1e+3 then
		fileSizeString = " KB"
		fileSizeTruncated = fileSize / 1e+3
	else
		fileSizeString = " B"
		fileSizeTruncated = fileSize
	end
	if fileSize >= scriptSourceLimit then
		warn("Your hierarchy is too big (" .. math.floor(fileSizeTruncated * 1e+2) / 1e+2 .. fileSizeString .. "). You'll need to take this up with Roblox as it's out of my control.")
	end
	Size.Text = "File Size = " .. fileSizeTruncated .. fileSizeString
end

function createHierarchy(selection) -- hierarchy algorithum
	local decendants = {}
	for i,v in pairs(selection) do
		for l,k in pairs(selection) do
			if not pcall(function() return v:IsAncestorOf(k) end) then
				table.remove(selection, l)
			elseif not pcall(function() return v:IsDescendantOf(k) end) then
				table.remove(selection, i)
			elseif v:IsAncestorOf(k) then
				table.remove(selection, l)
			elseif v:IsDescendantOf(k) then
				table.remove(selection, i)
			else
				local _decendants = v:GetDescendants()
				for j,x in pairs(_decendants) do
					decendants[#decendants + 1] = x
				end
			end
		end
	end
	for i,v in pairs(decendants) do
		selection[#selection + 1] = v
	end
	local dir = {}
	for i,v in pairs(selection) do
		local bool, properties = pcall(function()return ClassProperties[v.ClassName] end)
		if bool then
			local debugId = v:GetDebugId()
			dir[debugId] = {}
			if properties == nil then
				warn("sorry, we dont support that type! (" .. v.ClassName .. ")")
			else
				for l,k in pairs(properties) do
					if pcall(function() return v[k] end) then
						dir[debugId][k] = v[k]
					else
						
					end
				end
				dir[debugId]["ClassName"] = v.ClassName
			end
		end
	end 
	return dir
end

function encodeValues(dir)
	for i,v in pairs(dir) do
		for l,k in pairs(v) do
			dir[i][l] = dataTypeFunctions.encode[typeof(k)](k)
		end
	end
	return dir
end

function removeUnchanged(dir) -- removes values that are the same as default, minus ClassName
	for i,v in pairs(dir) do
		local bool, defaults = pcall(function() return Instance.new(v.ClassName) end)
		if bool then
			for l,k in pairs(v) do
				if k == defaults[l] and l ~= "ClassName" then
					dir[i][l] = nil
				end
			end
		end
	end
	return dir
end

function compressValue(value, level)
	if level == nil then
		level = compressQuality
	end
	local integer = math.floor(value * 10^level + 0.5)
	return integer * 10^(-level)
end

Export.Click:Connect(function() 
	Export:SetActive(false)
	local json = httpService:JSONEncode(encodeValues(createHierarchy(game.Selection:Get())))
	copyWidget.Enabled = true
	update(json)
	local data = Instance.new("Script", copyWidget)
	data.Source = string.sub(json, 1, scriptSourceLimit)
	game:GetService("Selection"):Set({data})
	plugin:PromptSaveSelection("robloxHierarchy")
	data:Destroy()
end)

compressedExport.Click:Connect(function() 
	compressedExport:SetActive(false)
	local json = httpService:JSONEncode(encodeValues(removeUnchanged(createHierarchy(game.Selection:Get()))))
	copyWidget.Enabled = true
	update(json)
	local data = Instance.new("Script", copyWidget)
	data.Source = string.sub(json, 1, scriptSourceLimit)
	game:GetService("Selection"):Set({data})
	plugin:PromptSaveSelection("robloxHierarchy")
	data:Destroy()
end)

lossyExport.Click:Connect(function() 
	lossyExport:SetActive(false)
	local hierarchy = removeUnchanged(createHierarchy(game.Selection:Get()))
	for i,v in pairs(hierarchy) do
		for l,k in pairs(v) do
			if l == "Source" then
				hierarchy[i][l] = k
			else
				hierarchy[i][l] = dataTypeFunctions.compress[typeof(k)](k)
			end
		end
	end
	local dir = httpService:JSONEncode(encodeValues(hierarchy))
	copyWidget.Enabled = true
	update(dir)
	local data = Instance.new("Script", copyWidget)
	data.Source = string.sub(dir, 1, scriptSourceLimit)
	game:GetService("Selection"):Set({data})
	plugin:PromptSaveSelection("robloxHierarchy")
	data:Destroy()
end)

importDump.Click:Connect(function() 
	importDump:SetActive(false)
	local file = studioservice:PromptImportFile({"json", "url"})
	if file == nil then
		newDump(Data, "_default")
	elseif string.lower(string.sub(file.Name, -3, -1)) == "url" then
		local content = LIP.load(file:GetBinaryContents())
		if pcall(function()return content["[InternetShortcut]"]["URL"] end) then
			local url = string.gsub(content["[InternetShortcut]"]["URL"], "%s$", "")
			newDump(httpService:JSONDecode(httpService:GetAsync(url))["Classes"], url)
		end
	else
		newDump(httpService:JSONDecode(file:GetBinaryContents())["Classes"], file.Name)
	end
end)

jsonImport.Click:Connect(function() 
	local file = studioservice:PromptImportFile({"json", "lua"})
	if file ~= nil then
		local content = httpService:JSONDecode(file:GetBinaryContents())
		local localIndex = {}
		for i,v in pairs(content) do
			local bool, object = pcall(function()return Instance.new(v.ClassName) end)
			if bool then
				localIndex[i] = {["instance"] = object, ["parent"] = v.Parent}
				for l,k in pairs(v) do
					if l ~= "Parent" then
						local bool, result = pcall(dataTypeFunctions.decode[typeof(object[l])], k)
						if bool then
							pcall(function() object[l] = result end)
						end
					end
				end
			end
		end
		for i,v in pairs(localIndex) do
			if pcall(function() assert(localIndex[v["parent"]]["instance"]) end) then
				v.instance.Parent = localIndex[v.parent].instance
			elseif v.parent ~= nil then
				v.instance.Parent = workspace
			end
		end
	end
end)

GitHub.Click:Connect(function() 
	GitHubWidget.Enabled = true
	GitHub:SetActive(false)
end)
