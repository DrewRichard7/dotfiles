-- local colors = require("colors")
-- local settings = require("settings")
--
-- local front_app = sbar.add("item", "front_app", {
--   display = "active",
--   icon = { drawing = false },
--   label = {
--     font = {
--       style = settings.font.style_map["Black"],
--       size = 12.0,
--     },
--   },
--   updates = true,
-- })
--
-- front_app:subscribe("front_app_switched", function(env)
--   front_app:set({ label = { string = env.INFO } })
-- end)
--
-- front_app:subscribe("mouse.clicked", function(env)
--   sbar.trigger("swap_menus_and_spaces")
-- end)
local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
    color = colors.darkblue, -- Initial color setting (good practice)
  },
  updates = true,
  padding_left = 0,
  padding_right = 8,
  background = {
    color = colors.bluealt,
    border_color = colors.black,
    border_width = 1,
    -- corner_radius = 5, -- Optional
  }
})

front_app:subscribe("front_app_switched", function(env)
  -- Update BOTH the string AND the color
  front_app:set({
    label = {
      string = env.INFO,
      color = colors.darkblue -- Re-apply the color here!
    }
  })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

-- Optional bracket for double border (uncomment if desired)
-- sbar.add("bracket", { front_app.name }, {
--   background = {
--     color = colors.transparent,
--     border_color = colors.grey,
--     border_width = 1,
--     -- corner_radius = 5, -- Optional
--   }
-- })
