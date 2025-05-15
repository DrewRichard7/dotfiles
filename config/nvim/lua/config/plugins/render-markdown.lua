return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
    ft = { 'md', 'markdown', 'qmd', 'quarto' },
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    config = function()
      require('render-markdown').setup({
        file_types = { 'markdown', 'quarto' },

        completions = {
          -- Settings for blink.cmp completions source
          blink = { enabled = true },
          -- Settings for coq_nvim completions source
          coq = { enabled = false },
          -- Settings for in-process language server completions
          lsp = { enabled = false },
          filter = {
            callout = function()
              -- example to exclude obsidian callouts
              return value.category ~= 'obsidian'
              -- return true
            end,
            checkbox = function()
              return true
            end,
          },
        },
        heading = {
          enable = true,
          levels = { 1, 2, 3, 4, 5, 6 },
          icons = { "󰊠󰁕 ", "󰊠󰶻 ", "󰊠󰐃 ", "󰐃 ", "󰗉 ", "󰶼 ", },
          conceal = true,
        },
        checkbox = {
          enabled = false,
        }
      })
    end
  }
}
