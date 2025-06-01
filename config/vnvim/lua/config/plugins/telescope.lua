return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = true,
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup {
        -- pickers = {
        --   find_files = {
        --     theme = "ivy" -- changes picker to raise from bottom rather than in window
        --   }
        -- },
        extensions = {
          fzf = {}
        }
      }


      defaults = {
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        border = true,
      }
      require("telescope").load_extension("fzf")

      vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "find help" })
      vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "find files" })
      -- you can define a local variable as a function to shorten later calls, i.e. :
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [B]uffers' })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set("n", "<leader>fn", function()
          local opts = require("telescope.builtin").find_files {
            cwd = vim.fn.stdpath("config")
          }
          require("telescope.builtin").find_files(opts)
        end,
        { desc = "find files in nvim config" })
      require "config.plugins.telescope.multigrep".setup()
    end
  }
}
