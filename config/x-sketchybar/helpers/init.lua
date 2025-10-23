-- -- Add the sketchybar module to the package cpath
-- package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
--
-- os.execute("(cd helpers && make)")
-- ~/.config/sketchybar/helpers/init.lua
print("SketchyBar: Loading helpers/init.lua...")

-- Add the sketchybar module to the package cpath (Existing line)
print("SketchyBar: Modifying package.cpath...")
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- *** Add the ./lib directory to the Lua module search path ***
-- This allows `require("dkjson")` (or other libs in ./lib) to work later.
-- The './' assumes SketchyBar's working directory is ~/.config/sketchybar/
print("SketchyBar: Modifying package.path to include ./lib/")
package.path = package.path .. ';./lib/?.lua'
-- If you add other library paths later (e.g., ./plugins), append them here:
-- package.path = package.path .. ';./lib/?.lua;./plugins/?.lua'

-- Compile helper binaries (Existing line)
print("SketchyBar: Running make in helpers directory...")
-- Use pcall for safety in case make fails or isn't needed
local make_ok, make_err = pcall(os.execute, "(cd helpers && make)")
if not make_ok or make_err ~= 0 then -- os.execute often returns 0 on success
  print("SketchyBar Warning: 'make' command in helpers failed or returned non-zero. Error: " .. tostring(make_err))
else
  print("SketchyBar: 'make' command in helpers completed.")
end

print("SketchyBar: helpers/init.lua finished.")
