-- simple config
-- return {
--   { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
--     -- for complete functionality (language features)
--     'quarto-dev/quarto-nvim',
--     enabled = true,
--     ft = { 'quarto', 'markdown' },
--     dev = false,
--     opts = {},
--     lazy = true,
--     dependencies = {
--       -- for language features in code cells
--       'jmbuhr/otter.nvim',
--     },
--   },
-- }



return {
  -- Quarto language features and code cell support
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    opts = {},
    dependencies = { "jmbuhr/otter.nvim" },
  },

  -- Open .ipynb as .qmd and vice versa
  {
    "GCBallesteros/jupytext.nvim",
    opts = {
      custom_language_formatting = {
        python = { extension = "qmd", style = "quarto", force_ft = "quarto" },
        r = { extension = "qmd", style = "quarto", force_ft = "quarto" },
      },
    },
  },

  -- Send code to external terminal (IPython, R, etc.)
  {
    "jpalardy/vim-slime",
    enabled = true,
    init = function()
      vim.b["quarto_is_python_chunk"] = false
      Quarto_is_in_python_chunk = function()
        require("otter.tools.functions").is_otter_language_context "python"
      end
      vim.cmd [[
        let g:slime_dispatch_ipython_pause = 100
        function SlimeOverride_EscapeText_quarto(text)
          call v:lua.Quarto_is_in_python_chunk()
          if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
            return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
          else
            if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
              return [a:text, "\n"]
            else
              return [a:text]
            end
          end
        endfunction
      ]]
      vim.g.slime_target = "neovim"
      vim.g.slime_no_mappings = true
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = true
      local function mark_terminal()
        local job_id = vim.b.terminal_job_id
        vim.print("job_id: " .. job_id)
      end
      local function set_terminal()
        vim.fn.call("slime#config", {})
      end
      vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
      vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
    end,
  },

  -- Paste/drag images into markdown/quarto/latex
  {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = { dir_path = "img" },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = { download_images = false },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = { download_images = false },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },

  -- Inline math rendering in markdown/quarto/latex
  {
    "jbyuki/nabla.nvim",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "latex" },
        auto_install = true,
        sync_install = false,
      })
    end,
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', { desc = "toggle [m]ath equations" } },
      { "<leader>p",  ':lua require("nabla").popup()<cr>',     { desc = "NablaPopUp" }, },
    },
  },

  -- In-editor code execution with output (including images)
  {
    "benlubas/molten-nvim",
    enabled = true,
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
    end,
    keys = {
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" }),
      vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
        { silent = true, desc = "run operator selection" }),
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" }),
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" }),
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "evaluate visual selection" }),
    },
  },
}
