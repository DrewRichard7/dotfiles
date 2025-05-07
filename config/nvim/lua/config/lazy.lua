-- package manager: lazy.nvim -- plugins will go inside this section
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    --[[
    -- this colorscheme plugin is laoded here because we want it to load before other plugins. The format is different than normal plugin syntax. Here we are specifying where to pulll the theme from, and then setting the config to a function that runs the vim command to set the theme. After that, i'll import the rest of my plugins.
    --]]
    -- {
    --   "folke/tokyonight.nvim", config = function() vim.cmd.colorscheme "tokyonight" end
    -- }, -- this basically just clones the repo into ~/.local/share/nvim
    require("config.colorscheme"),
    {
      "nvim-lua/plenary.nvim"
    }, -- lua functions that many plugins use
    {
      "christoomey/vim-tmux-navigator"
    }, -- don't use tmux much but i migth start, this makes nav easier in tmux
    {
      import = "config.plugins"
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------
