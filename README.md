# Source Code for the plugin [Save as JSON](https://www.roblox.com/library/6347791050)

## Source.lua

Source.lua is the raw source code, nothing added or modified.

## Module.lua

Module.lua is for use in-game, in a module script. 

First get the latest API dump, fetch the current [version hash](http://setup.roblox.com/versionQTStudio) then fetch the latest API dump by replacing **<HASH\>** in the following URL with the retrieved version hash:
  
`http://setup.roblox.com/<HASH>-API-Dump.json`

Then require Module.lua and call `setup()`.

*Ex.*
```lua
local saveAsJSON = require(module)

saveAsJSON:setup(dumpContent)
```

You can now use ether `decode()` or `encode()` depending on what you want.

*Ex.*
```lua
local saveAsJSON = require(module)

saveAsJSON:setup(dumpContent)

--[[encode takes a table of instances to encode and a "compression mode". Compression mode can be:
- "none" (all properties)
- "lossless" (removes unchanged values)
- "lossy" (compresses some values)]]

local JSONData = saveAsJSON:encode({game.Workspace.Part}, "none") 

-- decode just takes JSON data as a string

saveAsJSON:decode(JSONData) 
```

## jsonExtendedDataTypes.lua

jsonExtendedDataTypes is all the functions I use to convert Roblox data types to JSON compatable data types. This is applicable to any JSON project, that's why its a seperate script.

Require the module then index the functions via whatever `typeOf(value)` spits out.
