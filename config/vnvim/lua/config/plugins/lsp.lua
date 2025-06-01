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
			{ "saghen/blink.cmp" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lsp_flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 150,
			}

			local function get_lsp_opts(server_specific_opts)
				local base_opts = {
					capabilities = capabilities,
					flags = lsp_flags,
				}
				return vim.tbl_deep_extend("force", {}, base_opts, server_specific_opts or {})
			end

			-- Lua
			local lua_ls_settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
					runtime = { version = "LuaJIT" },
					diagnostics = { disable = { "trailing-space" } },
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("lua", true),
					},
					doc = { privateName = { "^_" } },
					telemetry = { enable = false },
				},
			}
			require("lspconfig").lua_ls.setup(get_lsp_opts({ settings = lua_ls_settings }))

			-- Python
			require("lspconfig").pyright.setup(get_lsp_opts())
			require("lspconfig").ruff.setup(get_lsp_opts({
				init_options = {
					settings = { lineLength = 80 },
				},
				-- Disable formatting capability for Ruff LSP to avoid conflicts with none-ls
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
				end,
			}))

			-- R
			require("lspconfig").r_language_server.setup(get_lsp_opts({
				settings = {
					r = {
						lsp = {
							rich_documentation = true,
							diagnostics = true,
							lint = {
								linters = "lintr::default_linters",
							},
						},
					},
				},
			}))

			-- Rust
			require("lspconfig").rust_analyzer.setup(get_lsp_opts({
				settings = {
					["rust-analyzer"] = {
						diagnostics = { enable = true },
					},
				},
			}))

			-- HTML
			require("lspconfig").html.setup(get_lsp_opts())

			-- YAML
			require("lspconfig").yamlls.setup(get_lsp_opts({
				settings = {
					yaml = {
						schemaStore = {
							enable = true,
							url = "",
						},
					},
				},
			}))

			-- JSON
			require("lspconfig").jsonls.setup(get_lsp_opts())

			-- TOML
			require("lspconfig").taplo.setup(get_lsp_opts())

			-- LSP Attach Autocommand for Formatting (skip Python, let none-ls handle it)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttachFormatting", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf
					if not client then
						return
					end

					-- Only set up format-on-save for non-Python filetypes
					if vim.bo[bufnr].filetype ~= "python" and client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							group = vim.api.nvim_create_augroup("UserLspFormatOnSave_" .. bufnr, { clear = true }),
							callback = function()
								vim.lsp.buf.format({
									bufnr = bufnr,
									client_id = client.id,
									timeout_ms = 2000,
								})
							end,
						})
					end
				end,
			})

			-- Keymap for Manual Formatting (let none-ls handle Python)
			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				if vim.bo.filetype == "python" then
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == "null-ls"
						end,
						timeout_ms = 2000,
					})
				else
					vim.lsp.buf.format({ timeout_ms = 2000 })
				end
			end, { desc = "[L]SP [F]ormat" })

			-- Mason Setup
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
					"pyright",
					"ruff",
					"r_language_server",
					"rust_analyzer",
					"html",
					"yamlls",
					"jsonls",
					"taplo",
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"ruff",
					"stylua",
					"isort",
					"tree-sitter-cli",
					"r-languageserver",
				},
				auto_update = true,
			})

			-- Improved Hover and Signature Help Handlers, Diagnostic Config
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				max_width = 80,
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
				max_width = 80,
			})
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
				},
			})
		end,
	},
}
