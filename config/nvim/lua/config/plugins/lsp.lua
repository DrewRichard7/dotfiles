-- LSP via nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig
-- below is the simple config in TJ Devries youtube series building neovim from scratch. I'm going to comment it out and then copy and ewdit a new version of this.
-- ---------------------------------------------------------------------
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       {
--         "folke/lazydev.nvim",
--         ft = "lua",
--         opts = {
--           library = {
--             { path = "${3rd}/luv/library", words = { "vim%.uv" } },
--           },
--         },
--       },
--     },
--     config = function()
--       require("lspconfig").lua_ls.setup {}
--
--       vim.api.nvim_create_autocmd("LspAttach", {
--         callback = function(args)
--           local client = vim.lsp.get_client_by_id(args.data.client_id)
--           if not client then return end
--
--           if client.supports_method("textDocument/formatting", 0) then
--             vim.api.nvim_create_autocmd("BufWritePre", {
--               buffer = args.buf,
--               callback = function()
--                 vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
--               end,
--             })
--           end
--         end,
--       })
--     end
--   },
-- }
-----------------------------------------------------------------------

return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "saghen/blink.cmp"
      },
      {
        "williamboman/mason.nvim"
      },
      {
        "williamboman/mason-lspconfig.nvim"
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim"
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }
      require("lspconfig").lua_ls.setup {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              disable = { 'trailing-space' },
            },
            workspace = {
              checkThirdParty = false,
            },
            doc = {
              privateName = { '^_' },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      require("lspconfig").pyright.setup {
        capabilities = capabilities,
        flags = lsp_flags,
      }

      require("lspconfig").ruff.setup {
        capabilities = capabilities,
        flags = lsp_flags,
        init_options = {
          settings = {
            lineLength = 80,
          }
        }
      }

      require("lspconfig").r_language_server.setup {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          r = {
            lsp = {
              rich_documentation = true,
              diagnostics = true, -- Explicitly enable diagnostics
              lint = {            -- Correctly nested lint settings
                linters = "lintr::default_linters",
                -- delay = 1500 -- Or your preferred delay
              }
            }
          }
        }
      }

      require("lspconfig").rust_analyzer.setup {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = true,
            },
          },
        },
      }

      require("lspconfig").yamlls.setup {
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = '',
            },
          },
        },
      }

      require("lspconfig").jsonls.setup {
        capabilities = capabilities,
        flags = lsp_flags,
      }

      require("lspconfig").dotls.setup {
        capabilities = capabilities,
        flags = lsp_flags,
      }

      require("lspconfig").ts_ls.setup {
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { 'js', 'javascript', 'typescript', 'ojs' },
      }
      require('lspconfig').html.setup {
        capabilities = capabilities,
        flags = lsp_flags,
      }

      require 'lspconfig'.java_language_server.setup {
        capabilities = capabilities,
        flags = lsp_flags,
      }



      --[[the following function and statements collect existing Lua runtime files in Neovim.
    Checks if Quarto is installed:
        If not installed, it notifies the user.
        If installed, it adds Quarto-specific Lua paths to the runtime.
    This allows Neovim’s LSP to recognize and provide autocompletion, diagnostics, and other features for Quarto documents.]] --
      local function get_quarto_resource_path()
        local function strsplit(s, delimiter)
          local result = {}
          for match in (s .. delimiter):gmatch('(.-)' .. delimiter) do
            table.insert(result, match)
          end
          return result
        end

        local f = assert(io.popen('quarto --paths', 'r'))
        local s = assert(f:read '*a')
        f:close()
        return strsplit(s, '\n')[2]
      end

      local lua_library_files = vim.api.nvim_get_runtime_file('', true)
      local lua_plugin_paths = {}
      local resource_path = get_quarto_resource_path()
      if resource_path == nil then
        vim.notify_once 'quarto not found, lua library files not loaded'
      else
        table.insert(lua_library_files, resource_path .. '/lua-types')
        table.insert(lua_plugin_paths, resource_path .. '/lua-plugin/plugin.lua')
      end



      -- LSP attach autocommand
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.supports_method("textDocument/formatting", 0) then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })

      vim.keymap.set({ "n", "v" }, '<leader>lf', vim.lsp.buf.format, { desc = '[l]sp [f]ormat' })

      -- Set up Mason
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "pyright",
          "r_language_server",
          "yamlls",
          "jsonls",
          "ruff",
        },
      })

      -- More comprehensive tool installation
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- "black",
          "ruff",
          "stylua",
          "shfmt",
          "isort",
          "tree-sitter-cli",
          "jupytext",
          "r-languageserver"
        },
        auto_update = true,
      })
      -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
      --   { border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } })
      -- vim.lsp.handlers['textDocument/signatureHelp'] =
      --     vim.lsp.with(vim.lsp.handlers.signature_help, { border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } })
      -- Improved hover and signature help handlers
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
      })
      vim.diagnostic.config({
        float = {
          border = "rounded", -- Or your preferred style
          -- source = "always",
        },
      })
    end
  },
}
