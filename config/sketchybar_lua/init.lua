-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("colors")
require("icons")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
-- -- ~/.config/sketchybar/init.lua
-- print("SketchyBar: Loading main init.lua...")
--
-- -- Require the sketchybar module first
-- local sbar_ok, sbar_module = pcall(require, "sketchybar")
-- if not sbar_ok then error("SketchyBar core module failed to load.") end
-- _G.sbar = sbar_module -- Keep sbar global
-- print("SketchyBar: Loaded sketchybar module.")
--
-- -- Begin config
-- print("SketchyBar: Beginning configuration...")
-- sbar.begin_config()
--
-- -- Use pcall for safer loading
-- local function safe_require(module_name)
--   local ok, result = pcall(require, module_name)
--   if not ok then
--     print("SketchyBar FATAL: Failed to load required module '" .. module_name .. "': " .. tostring(result))
--     pcall(sbar.add, "item",
--       {
--         name = "load_error_" .. module_name:gsub("%.", "_"),
--         label = "ERR: " .. module_name,
--         color = "0xffff0000",
--         position =
--         "center"
--       })
--   else
--     print("SketchyBar: Loaded module '" .. module_name .. "' successfully.")
--   end
-- end
--
-- -- Load base configs and dependencies in correct order
-- print("SketchyBar: Loading bar settings...")
-- safe_require("bar")
-- print("SketchyBar: Loading defaults...")
-- safe_require("default")
-- print("SketchyBar: Loading colors...")
-- safe_require("colors") -- Load it so it's available for subsequent requires if needed by others
-- print("SketchyBar: Loading icons...")
-- safe_require("icons")  -- Load it so it's available for subsequent requires if needed by others
--
-- -- Load Items AFTER dependencies are loaded
-- print("SketchyBar: Loading items...")
-- safe_require("items") -- This will load items/init.lua -> items/media.lua etc.
--
-- -- End config
-- print("SketchyBar: Ending configuration block.")
-- sbar.end_config()
--
-- -- Start event loop
-- print("SketchyBar: Starting event loop...")
-- sbar.event_loop()
