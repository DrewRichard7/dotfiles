return {
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    enabled = true,
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = true, -- defined in init.lua as true
        -- using a Nerd Font: set icons.keys to an empty table will use the
        -- default which-key.nvim defined Nerd Font icons
        keys = true and {},
      },
    },
  },
}
