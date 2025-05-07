return {
  -- conform - autoformatter on save
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
      },

      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  -- lsp
  {
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      -- Main LSP Configuration
      "neovim/nvim-lspconfig",
      dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        { "j-hui/fidget.nvim", opts = {} },

        "hrsh7th/cmp-nvim-lsp",
      },
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc, mode)
              mode = mode or "n"
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
            end

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

            -- Find references for the word under your cursor.
            map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

            -- WARN: This is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

            -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
            ---@param client vim.lsp.Client
            ---@param method vim.lsp.protocol.Method
            ---@param bufnr? integer some lsp support methods only in specific files
            ---@return boolean
            local function client_supports_method(client, method, bufnr)
              if vim.fn.has "nvim-0.11" == 1 then
                return client:supports_method(method, bufnr)
              else
                return client.supports_method(method, { bufnr = bufnr })
              end
            end

            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if
              client
              and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
            then
              local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
                end,
              })
            end

            -- This may be unwanted, since they displace some of your code
            if
              client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
            then
              map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, "[T]oggle Inlay [H]ints")
            end
          end,
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = "rounded", source = "if_many" },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚 ",
              [vim.diagnostic.severity.WARN] = "󰀪 ",
              [vim.diagnostic.severity.INFO] = "󰋽 ",
              [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
          } or {},
          virtual_text = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        local servers = {
          -- clangd = {},
          -- gopls = {},
          pyright = {},
          rust_analyzer = {},
          r_language_server = {
            settings = {
              lintr = {
                delay = 1000,
              },
            },
          },

          lua_ls = {
            -- cmd = { ... },
            -- filetypes = { ... },
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                diagnostics = {
                  disable = { "missing-fields" },
                  globals = { "vim", "require", "Snacks" },
                },
              },
            },
          },
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          "stylua", -- Used to format Lua code
        })
        require("mason-tool-installer").setup { ensure_installed = ensure_installed }

        require("mason-lspconfig").setup {
          ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
          automatic_installation = false,
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
              require("lspconfig")[server_name].setup(server)
            end,
          },
        }
      end,
    },
  },
  -- treesitter
  {
    { -- Highlight, edit, and navigate code
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      main = "nvim-treesitter.configs", -- Sets main module to use for opts
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      opts = {
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "html",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "query",
          "vim",
          "vimdoc",
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "ruby" },
        },
        indent = { enable = true, disable = { "ruby" } },
      },
    },
  },
  {

    -- quarto-nvim
    { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
      -- for complete functionality (language features)
      "quarto-dev/quarto-nvim",
      ft = { "quarto", "markdown" },
      dev = false,
      opts = {},
      lazy = true,
      dependencies = {
        -- for language features in code cells
        "jmbuhr/otter.nvim",
      },
    },

    { -- directly open ipynb files as quarto docuements
      -- and convert back behind the scenes
      "GCBallesteros/jupytext.nvim",
      opts = {
        custom_language_formatting = {
          python = {
            extension = "qmd",
            style = "quarto",
            force_ft = "quarto",
          },
          r = {
            extension = "qmd",
            style = "quarto",
            force_ft = "quarto",
          },
        },
      },
    },

    { -- send code from python/r/qmd documets to a terminal or REPL
      -- like ipython, R, bash
      "jpalardy/vim-slime",
      dev = false,
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
      endfunction      ]]

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

    { -- paste an image from the clipboard or drag-and-drop
      "HakonHarnes/img-clip.nvim",
      event = "BufEnter",
      ft = { "markdown", "quarto", "latex" },
      opts = {
        default = {
          dir_path = "img",
        },
        filetypes = {
          markdown = {
            url_encode_path = true,
            template = "![$CURSOR]($FILE_PATH)",
            drag_and_drop = {
              download_images = false,
            },
          },
          quarto = {
            url_encode_path = true,
            template = "![$CURSOR]($FILE_PATH)",
            drag_and_drop = {
              download_images = false,
            },
          },
        },
      },
      config = function(_, opts)
        require("img-clip").setup(opts)
        vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
      end,
    },

    { -- preview equations
      "jbyuki/nabla.nvim",
      keys = {
        { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
      },
    },

    {
      "benlubas/molten-nvim",
      enabled = false,
      build = ":UpdateRemotePlugins",
      init = function()
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 20
        vim.g.molten_auto_open_output = false
      end,
      keys = {
        { "<leader>mi", ":MoltenInit<cr>", desc = "[m]olten [i]nit" },
        {
          "<leader>mv",
          ":<C-u>MoltenEvaluateVisual<cr>",
          mode = "v",
          desc = "molten eval visual",
        },
        { "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
      },
    },
  },
  -- Highlight todo, notes, etc in comments
  {
  { 'folke/todo-comments.nvim', 
      event = 'VimEnter', 
      dependencies = { 'nvim-lua/plenary.nvim' }, 
      opts = { signs = false } },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  }

}
