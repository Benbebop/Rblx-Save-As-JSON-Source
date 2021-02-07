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

function readIni(file)
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

local SAJ = {}

function SAJ.setup(apiDumpContent)
	local classIndex = {}

	for i=1,#dumpContent do
		classIndex[apiDumpContent[i].Name] = i
	end

	for i=1,#dumpContent do
		local class = apiDumpContent[i]
		local superclass = class
		local properties = {}
		repeat 
			for i,v in pairs(superclass.Members) do
				if v.MemberType == "Property" then
					properties[#properties + 1] = v.Name
				end
			end
			superclass = apiDumpContent[classIndex[superclass.Superclass]]
		until superclass == nil
		ClassProperties[class.Name] = properties
	end
end

function SAJ.decode(content)
	local localIndex = {}
	local parented = {}
	for i,v in pairs(content) do
		local bool, object = pcall(function()return Instance.new(v.ClassName) end)
		if bool then
			localIndex[i] = object
			if content[v.Parent] == nil then
				object.Parent = workspace
				parented[i] = workspace
			end
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
		local bool, result = pcall(function()assert(localIndex[content[i]]) end)
		if bool then
			v.Parent = localIndex[content[i]]
		end
	end
end

function SAJ.encode(tbl, compression) -- compression can be "none" (all properties), "lossless" (removes default values), or "lossy" (compresses some values)
	if compression == nil then
		compression = "none"
	end
	if compression == "none" then
		
	elseif compression == "lossless" then
	
	elseif compression == "lossy" then
	
	end
end

return JSONHierarchy
