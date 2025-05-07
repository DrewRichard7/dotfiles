-- Mini.nvim is a library of plugins, we'll just call what we want here
-- https://github.com/echasnovski/mini.nvim
return {
  {
    "echasnovski/mini.nvim",
    enabled = true, -- change to false to disable icons
    config = function()
      local statusline = require "mini.statusline"
      statusline.setup { use_icons = true }

      local surround = require "mini.surround"
      surround.setup {
        -- No need to copy this inside `setup()`. Will be used automatically.
        {
          -- Add custom surroundings to be used on top of builtin ones. For more
          -- information with examples, see `:h MiniSurround.config`.
          custom_surroundings = nil,

          -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
          highlight_duration = 500,

          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            add = 'sa',    -- Add surrounding in Normal and Visual modes
            delete = 'sd', -- Delete surrounding
            find = 'sf',   -- Find surrounding (to the right)
            find_left = 'sF', -- Find surrounding (to the left)
            highlight = 'sh', -- Highlight surrounding
            replace = 'sr', -- Replace surrounding
            update_n_lines = 'sn', -- Update `n_lines`

            suffix_last = 'l', -- Suffix to search with "prev" method
            suffix_next = 'n', -- Suffix to search with "next" method
          },

          -- Number of lines within which surrounding is searched
          n_lines = 20,

          -- Whether to respect selection type:
          -- - Place surroundings on separate lines in linewise mode.
          -- - Place surroundings on each line in blockwise mode.
          respect_selection_type = false,

          -- How to search for surrounding (first inside current line, then inside
          -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
          -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
          -- see `:h MiniSurround.config`.
          search_method = 'cover',

          -- Whether to disable showing non-error feedback
          -- This also affects (purely informational) helper messages shown after
          -- idle time if user input is required.
          silent = false,
        }
      }

      local pairs = require "mini.pairs"
      pairs.setup {}

      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      -- local ai = require "mini.ai"
      -- ai.setup {}

      local indent = require "mini.indentscope"
      indent.setup {
        symbol = '│',
        draw = {
          animation = function() return 22 end, -- returns the duration in milliseconds
        },
      }

      -- Define custom highlight groups
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#B9F3FB", bg = "NONE" }) -- Light MDR blue for indent line animations
    end
  },
}
