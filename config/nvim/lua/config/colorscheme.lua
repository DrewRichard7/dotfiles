return {
  {
    "folke/tokyonight.nvim",
    enabled = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- local bg = "#011628"
      -- local bg_dark = "#011423"
      -- local bg_highlight = "#143652"
      -- local bg_search = "#0A64AC"
      -- local bg_visual = "#275378"
      -- local fg = "#CBE0F0"
      -- local fg_dark = "#B4D0E9"
      -- local fg_gutter = "#627E97"
      -- local border = "#547998"

      require("tokyonight").setup({
        style = "night",
        transparent = true,
        terminal_colors = true,
        styles = {
          sidebars = "transparent",
          floats = "transpsrent",
        },
        -- on_colors = function(colors)
        --   colors.bg = bg
        --   colors.bg_dark = bg_dark
        --   colors.bg_float = bg_dark
        --   colors.bg_highlight = bg_highlight
        --   colors.bg_popup = bg_dark
        --   colors.bg_search = bg_search
        --   colors.bg_sidebar = bg_dark
        --   colors.bg_statusline = bg_dark
        --   colors.bg_visual = bg_visual
        --   colors.border = border
        --   colors.fg = fg
        --   colors.fg_dark = fg_dark
        --   colors.fg_float = fg
        --   colors.fg_gutter = fg_gutter
        --   colors.fg_sidebar = fg_dark
        -- end,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight-night]])
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#00DD96", bg = "NONE" })
      vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    lazy = false,  -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- set colorscheme and overwrite highlights
      vim.cmd.colorscheme("catppuccin-mocha")
      local colors = require("catppuccin.palettes.mocha")
      vim.api.nvim_set_hl(0, "Tabline", { fg = colors.green, bg = colors.mantle })
      vim.api.nvim_set_hl(0, "TermCursor", { fg = "#A6E3A1", bg = "#A6E3A1" })
    end,
  },
  -- this one is pretty good.
  {
    "bluz71/vim-moonfly-colors",
    enabled = false,
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("moonfly")
    end,
  },
  {
    "bluz71/vim-nightfly-colors",
    enabled = false,
    name = "nightfly",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nightfly")
    end,
  },

  {
    {
      "rose-pine/neovim",
      enabled = false,
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({
          variant = "auto", -- auto, main, moon, or dawn
          dark_variant = "main", -- main, moon, or dawn
          dim_inactive_windows = false,
          extend_background_behind_borders = true,

          enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true,  -- Handle deprecated options automatically
          },

          styles = {
            bold = true,
            italic = true,
            transparency = false,
          },

          groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
          },

          palette = {
            main = {
              base = "#000000", -- Set background to pure black
            },
            moon = {
              base = "#000000", -- Set background to pure black
            },
            dawn = {
              base = "#000000", -- Set background to pure black
            },
          },

          -- NOTE: Highlight groups are extended (merged) by default. Disable this
          -- per group via `inherit = false`
          highlight_groups = {
            Normal = { bg = "#000000" }, -- Set background to pure black
            NormalFloat = { bg = "#000000" }, -- Set floating window background to pure black
            Visual = { bg = "#ffffff", fg = "#ffffff", bold = true },
          },

          before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --   highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --   highlight.fg = palette.foam
            -- end
          end,
        })
        vim.cmd("colorscheme rose-pine")
      end,
    },
  },
  {
    {
      "rebelot/kanagawa.nvim",
      enabled = false,
      lazy = false, -- Or false if you load it immediately
      priority = 1000, -- Load early
      config = function()
        require("kanagawa").setup({
          compile = false, -- Enable this if you encounter slowness (requires :KanagawaCompile)
          undercurl = true,
          -- Corrected keys to camelCase below:
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = true, -- Explicitly set background to non-transparent
          dimInactive = false, -- Corrected key
          terminalColors = true, -- Corrected key
          theme = "wave",   -- Or "dragon", "lotus" - choose your preferred variant
          background = {    -- Force dark theme regardless of vim.o.background
            dark = "wave",  -- Match the theme name above
            light = "lotus", -- Fallback for light mode (won't be used if dark is forced)
          },
          colors = {        -- Keep your gutter setting
            palette = {},   -- We use overrides below, so keep this empty or remove
            theme = {
              all = {
                ui = {
                  bg_gutter = "none", -- Make gutter transparent to use Normal bg
                },
              },
            },
          },
          overrides = function(colors)
            -- The 'colors' argument contains the calculated palette for the theme
            return {
              Visual = {
                bg = "#87ceeb",
              },
            }
          end,
        })

        -- Apply the colorscheme
        vim.cmd.colorscheme("kanagawa")

        -- Your custom terminal cursor highlight (keep if you like it)
        vim.api.nvim_set_hl(0, "TermCursor", { fg = "#A6E3A1", bg = "#A6E3A1" })
      end,
    },
  },
  {
    "olimorris/onedarkpro.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
  },

  {
    "neanias/everforest-nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
  },
  -- color html colors
  {
    "NvChad/nvim-colorizer.lua",
    enabled = true,
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,      -- #RGB hex codes
        RRGGBB = true,   -- #RRGGBB hex codes
        names = false,   -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = false,  -- CSS rgb() and rgba() functions
        hsl_fn = false,  -- CSS hsl() and hsla() functions
        css = false,     -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false,  -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false,                           -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■",
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
        -- all the sub-options of filetypes apply to buftypes
      },
      buftypes = {},
    },
  },
}
