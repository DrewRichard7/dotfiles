-- edit your file tree like a buffer
-- https://github.com/stevearc/oil.nvim
return {
  {
    'stevearc/oil.nvim',
    enabled = true,
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      require("oil").setup {
        view_options = {
          show_hidden = true
        },
      }
      -- open parent directory in floating window
      vim.keymap.set("n", "\\", require("oil").toggle_float, { desc = "toggle floating oil" })
    end
  },
}
