-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set default slime_cell_delimiter (fallback)
vim.g.slime_cell_delimiter = "```" -- Or whatever you want as the default

-- Filetype-specific slime_cell_delimiter settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.g.slime_cell_delimiter = "\\s\\=#%%"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "r",
  callback = function()
    vim.g.slime_cell_delimiter = "#' ---"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto",
  callback = function()
    vim.g.slime_cell_delimiter = "```"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rmarkdown",
  callback = function()
    vim.g.slime_cell_delimiter = "```"
  end,
})

-- chad's default init code below
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
-- vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
