-- init.lua: Single-file Neovim configuration
-- This file merges all plugins, keymaps, LSP, Python, Telescope, and UI settings from your modular config into one file.
-- It is heavily documented and preserves all current functionality, especially for Python and Telescope.

-- =====================
-- 1. BASIC VIM SETTINGS
-- =====================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.splitbelow = true
vim.opt.splitright = true

-- needed for zen mode (theprimeagen)
function ColorMyPencils(color)
	color = color or "bamboo"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
-- =====================
-- 2. PLUGIN MANAGER: lazy.nvim
-- =====================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Using lazy.nvim
	{
		"ribru17/bamboo.nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").setup({
				style = "multiplex",
				lualine = {
					transparent = true,
				},
			})
			require("bamboo").load()
		end,
	},
	{
		"rose-pine/neovim",
		enabled = false,
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				styles = {
					italic = false,
				},
			})

			ColorMyPencils()
		end,
	},
	-- Colorscheme: Kanagawa
	{
		"rebelot/kanagawa.nvim",
		enabled = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = true },
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				transparent = true,
				dimInactive = false,
				terminalColors = true,
				theme = "wave",
				background = { dark = "wave", light = "lotus" },
				colors = {
					-- palette = {},
					theme = { all = { ui = { bg_gutter = "none" } } },
				},
				overrides = function(colors)
					return { Visual = { bg = "#87ceeb" } }
				end,
			})
			vim.cmd.colorscheme("kanagawa")
			vim.api.nvim_set_hl(0, "TermCursor", { fg = "#A6E3A1", bg = "#A6E3A1" })
		end,
	},
	-- Colorizer
	{ "NvChad/nvim-colorizer.lua", opts = { filetypes = { "*" }, user_default_options = { mode = "background" } } },
	-- notification handler
	{
		"j-hui/fidget.nvim",
		event = "VimEnter",
		opts = {
			progress = {
				display = {
					render_limit = 1,
					done_ttl = 2,
					done_icon = "✔",
				},
				ignore = {
					["*"] = { "*" },
				},
			},
			notification = {
				override_vim_notify = true,
				window = {
					max_width = 40,
					max_height = 5,
				},
			},
		},
		config = function(_, opts)
			require("fidget").setup(opts)
			vim.api.nvim_set_hl(0, "FidgetTitle", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "FidgetTask", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "FidgetNotification", { bg = "NONE" })
		end,
	},
	-- Telescope and extensions
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "bottom_pane",
					layout_config = {
						height = 0.4,
					},
					previewer = true,
				},
				extensions = { fzf = {} },
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("harpoon")
			require("telescope").load_extension("fidget")
			-- Multigrep extension
			local multigrep_loader = require("telescope.pickers")
				and require("telescope.finders")
				and require("telescope.make_entry")
				and require("telescope.config").values
				and function()
					local function live_multigrep(opts)
						opts = opts or {}
						opts.cwd = opts.cwd or vim.uv.cwd()
						local pickers = require("telescope.pickers")
						local finders = require("telescope.finders")
						local make_entry = require("telescope.make_entry")
						local conf = require("telescope.config").values

						local finder = finders.new_async_job({
							command_generator = function(prompt)
								if not prompt or prompt == "" then
									return nil
								end
								local pieces = vim.split(prompt, "  ")
								local args = {
									"rg",
									"--color=never",
									"--no-heading",
									"--with-filename",
									"--line-number",
									"--column",
									"--smart-case",
								}
								if pieces[1] then
									table.insert(args, "-e")
									table.insert(args, pieces[1])
								end
								if pieces[2] then
									table.insert(args, "-g")
									table.insert(args, pieces[2])
								end
								return args
							end,
							entry_maker = make_entry.gen_from_vimgrep(opts),
							cwd = opts.cwd,
						})

						pickers
							.new(opts, {
								debounce = 100,
								prompt_title = "MultiGrep",
								finder = finder,
								previewer = conf.grep_previewer(opts),
								sorter = require("telescope.sorters").empty(),
							})
							:find()
					end

					vim.keymap.set("n", "<leader>fg", live_multigrep, { desc = "live multigrep" })
				end
			if multigrep_loader then
				multigrep_loader()
			end
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>n", ":Telescope fidget<CR>", { desc = "Notification History" })
			vim.keymap.set("n", "<leader>td", ":Telescope diagnostics<CR>", { desc = "diagnostics" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy({}))
			end, { desc = "[/] Fuzzily search in current buffer" })
			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[F]ind [N]eovim files" })
		end,
	},
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- modules = {},
				-- ignore_install = {},
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"python",
					"r",
					"rust",
				},
				sync_install = true,
				auto_install = true,
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	-- LSP, Mason, Python, Ruff, R, etc.
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
			},
			{ "saghen/blink.cmp", version = "v0.*" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "stevearc/conform.nvim" },
		},
		config = function()
			-- Capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local blink_ok, blink = pcall(require, "blink.cmp")
			if blink_ok then
				capabilities = blink.get_lsp_capabilities()
			end

			-- LSP keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
					map("gy", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
				end,
			})

			-- Diagnostics UI
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded" },
			})
			vim.lsp.handlers.hover = { border = "rounded", max_width = 80 }
			vim.lsp.handlers.signature_help = { border = "rounded", max_width = 80 }

			-- Base config function
			local function get_opts(server_opts)
				return vim.tbl_deep_extend("force", { capabilities = capabilities }, server_opts or {})
			end

			-- Configure servers
			vim.lsp.config(
				"lua_ls",
				get_opts({
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							runtime = { version = "LuaJIT" },
							diagnostics = { disable = { "trailing-space", "missing-fields" } },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("lua", true),
							},
							doc = { privateName = { "^_" } },
							telemetry = { enable = false },
						},
					},
				})
			)

			vim.lsp.config("pyright", get_opts())

			vim.lsp.config(
				"ruff",
				get_opts({
					init_options = { settings = { lineLength = 80 } },
				})
			)

			vim.lsp.config(
				"rust_analyzer",
				get_opts({
					settings = { ["rust-analyzer"] = { diagnostics = { enable = true } } },
				})
			)

			vim.lsp.config("html", get_opts())

			vim.lsp.config(
				"yamlls",
				get_opts({
					settings = { yaml = { schemaStore = { enable = true, url = "" } } },
				})
			)

			vim.lsp.config("jsonls", get_opts())
			vim.lsp.config("taplo", get_opts())

			-- Enable all configured servers
			vim.lsp.enable({
				"lua_ls",
				"pyright",
				"ruff",
				"rust_analyzer",
				"html",
				"yamlls",
				"jsonls",
				"taplo",
			})

			-- Mason
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
				ensure_installed = { "lua_ls", "pyright", "ruff", "rust_analyzer", "html", "yamlls", "jsonls", "taplo" },
			})

			require("mason-tool-installer").setup({
				ensure_installed = { "ruff", "stylua", "isort", "tree-sitter-cli" },
				auto_update = true,
			})

			-- Conform formatting
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_format" },
					lua = { "stylua" },
					json = { "jq" },
					yaml = { "prettier" },
					html = { "prettier" },
					toml = { "taplo" },
				},
				format_on_save = { timeout_ms = 2000, lsp_fallback = true },
			})

			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				require("conform").format({ lsp_fallback = true, timeout_ms = 2000 })
			end, { desc = "[L]SP [F]ormat" })
		end,
	},
	{ -- highlight markdown headings and code blocks etc.
		"lukas-reineke/headlines.nvim",
		enabled = true,
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("headlines").setup({
				quarto = {
					query = vim.treesitter.query.parse("markdown", [[(fenced_code_block) @codeblock]]),
					codeblock_highlight = "CodeBlock",
					treesitter_language = "markdown",
				},
				markdown = {
					query = vim.treesitter.query.parse("markdown", [[(fenced_code_block) @codeblock]]),
					codeblock_highlight = "CodeBlock",
				},
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = true,
		ft = { "md", "markdown", "qmd", "quarto", "copilot-chat" },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		config = function()
			require("render-markdown").setup({
				file_types = { "markdown", "quarto", "copilot-chat" },
				completions = { -- Settings for blink.cmp completions source
					blink = { enabled = true }, -- Settings for coq_nvim completions source
					coq = { enabled = false }, -- Settings for in-process language server completions
					lsp = { enabled = false },
					filter = {
						callout = function() -- example to exclude obsidian callouts
							return value.category ~= "obsidian" -- return true
						end,
						checkbox = function()
							return true
						end,
					},
				},
				heading = {
					enable = true,
					levels = { 1, 2, 3, 4, 5, 6 },
					icons = { "󰊠󰁕 ", "󰊠󰶻 ", "󰊠󰐃 ", "󰐃 ", "󰗉 ", "󰶼 " },
					conceal = true,
				},
				checkbox = {
					enabled = false,
				},
			})
		end,
	},
	-- GitHub Copilot
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		opts = {
			-- See Configuration section for options
		},
		vim.keymap.set("n", "<leader>cp", ":CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" }),
		-- Quick chat keybinding
		vim.keymap.set("n", "<leader>cq", function()
			local input = vim.fn.input("Quick Chat: ")
			if input ~= "" then
				require("CopilotChat").ask(input, {
					selection = require("CopilotChat.selection").buffer,
				})
			end
		end, { desc = "CopilotChat - Quick chat" }),
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = true, auto_trigger = true },
			panel = { enabled = true, auto_refresh = true },
			filetypes = {
				yaml = true,
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
				["fugitive"] = false,
				["neo-tree"] = false,
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)
			-- You may need to run :Copilot auth or :Copilot setup
			vim.keymap.set("i", "<C-f>", function()
				require("copilot.suggestion").accept_line()
			end)
		end,
	},
	-- blink-cmp-copilot
	{
		"giuxtaposition/blink-cmp-copilot",
	},
	-- Completion (blink.cmp, Copilot, etc.)
	{
		"saghen/blink.cmp",
		enabled = true,
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
			"zbirenbaum/copilot.lua",
		},
		build = "cargo build --release",

		version = "*",

		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Copilot"
							for _, item in ipairs(items) do
								item.kind = kind_idx
							end
							return items
						end,
					},
				},
			},
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					Copilot = "",
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒓",

					Field = "󰜢",
					Variable = "󰆦",
					Property = "󰖷",

					Class = "󱡠",
					Interface = "󱡠",
					Struct = "󱡠",
					Module = "󰅩",

					Unit = "󰪚",
					Value = "󰦨",
					Enum = "󰦨",
					EnumMember = "󰦨",

					Keyword = "󰻾",
					Constant = "󰏿",

					Snippet = "󱄽",
					Color = "󰏘",
					File = "󰈔",
					Reference = "󰬲",
					Folder = "󰉋",
					Event = "󱐋",
					Operator = "󰪚",
					TypeParameter = "󰬛",
				},
			},

			signature = { enabled = true },

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		config = function()
			-- NOTE: add opts inside setup() if probs
			require("blink.cmp").setup()
		end,
	},
	-- TODO: comments
	{
		-- TODO: comments

		"folke/todo-comments.nvim",
		enabled = true,
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
		vim.keymap.set("n", "]t", function()
			require("todo-comments").jump_next()
		end, { desc = "Next todo comment" }),

		vim.keymap.set("n", "[t", function()
			require("todo-comments").jump_prev()
		end, { desc = "Previous todo comment" }),

		vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find todo comments" }),

		-- You can also specify a list of valid jump keywords

		vim.keymap.set("n", "<leader>]t", function()
			require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
		end, { desc = "Next error/warning todo comment" }),
	},
	-- NVIM surround (more similar to vim-surround)
	{
		"kylechui/nvim-surround",
		-- version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	-- Mini.nvim (statusline, surround, etc.)
	{
		"echasnovski/mini.statusline",
		enabled = true,
		event = "VeryLazy",
		config = function()
			require("mini.statusline").setup({
				use_icons = true,
				content = {
					active = function(args)
						args = args or {}
						local mode, diagnostics, filename, fileinfo, location =
							MiniStatusline.section_mode(args),
							MiniStatusline.section_diagnostics(args),
							MiniStatusline.section_filename(args),
							MiniStatusline.section_fileinfo(args),
							MiniStatusline.section_location(args)
						return MiniStatusline.combine_groups({
							{ hl = "MiniStatuslineMode", strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = "MiniStatuslineLocation", strings = { location } },
						})
					end,
				},
			})
			-- Custom highlights for each mode (transparent backgrounds)
			vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = "#ccc9c0", bg = "NONE", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = "#2e2e2e", bg = "#DED157", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = "#2e2e2e", bg = "#569CD6", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = "#2e2e2e", bg = "#CE9178", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = "#2e2e2e", bg = "#4EC9B0", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = "#2e2e2e", bg = "#75beff", bold = true })
			vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = "#6A9955", bg = "NONE", italic = true })
			-- Optional: tweak other statusline sections for consistency
			vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = "#DED157", bg = "NONE" })
			vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = "#569CD6", bg = "NONE" })
			vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = "#4EC9B0", bg = "NONE" })
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = "*",
		config = function()
			require("mini.indentscope").setup({
				symbol = "│",
				draw = {
					animation = function()
						return 10
					end, -- returns the duration in milliseconds
				},
			})
		end,
	},
	-- Snacks (zen, etc.)
	{
		"folke/snacks.nvim",
		enabled = true,
		priority = 999,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			picker = { enabled = true },
		},
		keys = {
			{
				"<leader>z",
				function()
					require("snacks").zen()
				end,
				desc = "Toggle Zen Mode",
			},
		},
		config = function(_, opts) -- Ensure setup is called if plugin expects it
			require("snacks").setup(opts)
		end,
	},
	-- Harpoon (with Telescope integration)
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "add file to harpoon list" })
			vim.keymap.set("n", "<m-j>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<m-k>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<m-l>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<m-h>", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)
			local conf_ok, conf = pcall(require, "telescope.config")
			if not conf_ok then
				return
			end
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end
				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({ results = file_paths }),
						previewer = conf.values.file_previewer({}),
						sorter = conf.values.generic_sorter({}),
					})
					:find()
			end
			vim.keymap.set("n", "<C-t>", function()
				toggle_telescope(harpoon:list())
			end, { desc = "Open harpoon window" })
		end,
		vim.keymap.set("n", "<C-e>", function()
			require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
		end),
	},
	-- Trouble (diagnostics, quickfix)
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<CR>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble quickfix toggle<CR>",
				desc = "Quickfix (Trouble)",
			},
		},
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"laytan/cloak.nvim",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
				highlight_group = "Comment",
				patterns = {
					{
						-- Match any file starting with ".env".
						-- This can be a table to match multiple file patterns.
						file_pattern = {
							".env*",
							"wrangler.toml",
							".dev.vars",
						},
						-- Match an equals sign and any character after it.
						-- This can also be a table of patterns to cloak,
						-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
						cloak_pattern = "=.+",
					},
				},
			})
		end,
		vim.keymap.set("n", "<leader>cl", ":CloackToggle<CR>", { desc = "Toggle Cloak.nvim" }),
	},
	-- git signs
	{ "lewis6991/gitsigns.nvim" },
	{
		"christoomey/vim-tmux-navigator",
		vim.keymap.set("n", "<C-S-h>", ":TmuxNavigateLeft<CR>"),
		vim.keymap.set("n", "<C-S-j>", ":TmuxNavigateDown<CR>"),
		vim.keymap.set("n", "<C-S-k>", ":TmuxNavigateUp<CR>"),
		vim.keymap.set("n", "<C-S-l>", ":TmuxNavigateRight<CR>"),
	},
	{
		"kdheepak/lazygit.nvim",
		enabled = true,
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
  -- stylua: ignore
  keys = {
    { "zk",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "Zk",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
	},
	{
		"sphamba/smear-cursor.nvim",
		enabled = true,
		opts = {
			legacy_computing_symbols_support = true,
		},
	},
	-- WhichKey
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Load when Neovim UI is ready
		config = function()
			vim.defer_fn(function()
				local wk = require("which-key")
				wk.setup({})

				-- Your which-key mappings, moved here
				-- Ensure helper functions are accessible (they are global in your config)

				wk.add({
					{
						{ "<leader>f<space>", "<cmd>Telescope buffers<cr>", desc = "[ ] buffers" },
						{ "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "git [c]ommits" },
						{ "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "[j]umplist" },
						{ "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "[l]oclist" },
						{ "<leader>fm", "<cmd>Telescope marks<cr>", desc = "[m]arks" },
						{ "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "[q]uickfix" },
						{
							"<leader>le",
							vim.diagnostic.open_float,
							desc = "diagnostics (show hover [e]rror)",
						},
					},
				}, { mode = "n" })
			end, 100) -- Defer slightly to ensure other things are loaded
		end,
	},
})
-- for my custom colortheme:
if use_mytheme then
	apply_mytheme()
end
-- restore it
-- =====================
-- 3. KEYMAPS & AUTOCMDS
-- =====================

-- Keymap: <leader>br to show current git branch
vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Show git branches" })

-- Helper functions for basic keymaps (if not used by which-key, can stay here)
local nmap = function(key, effect)
	vim.keymap.set("n", key, effect, { silent = true, noremap = true })
end

-- Basic keymaps (not managed by which-key)
vim.keymap.set("i", "jk", "<ESC>", { desc = "exit insert mode with jk" })
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("j", "jzz") -- Consider if these jzz/kzz are desired globally
nmap("k", "kzz")

vim.keymap.set("n", "<C-S-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-S-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-S-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-S-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>o", "o<ESC>", { desc = "new line under cursor" })
vim.keymap.set("n", "<leader>O", "O<ESC>", { desc = "new line over cursor" })
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "source current file" })
vim.keymap.set(
	"n",
	"<space><space>c",
	"<cmd>source ~/.dotfiles/config/nvim/init.lua<CR>",
	{ desc = "source file: neovim init.lua" }
)
vim.keymap.set("n", "<space>x", ":lua vim.cmd('.lua')<CR>", { desc = "execute current line" }) -- Corrected to execute current line as Lua
vim.keymap.set(
	"v",
	"<space>x",
	":lua vim.api.nvim_command('lua ' .. table.concat(vim.api.nvim_buf_get_lines(0, vim.fn.line(\"'<\") - 1, vim.fn.line(\"'>\"), false), '\\n'))<CR>",
	{ desc = "execute current selection as Lua" }
) -- More robust visual selection execution
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "<m-m>", "|>", { desc = "insert pipe operator" })
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" })
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>")
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tw", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
vim.keymap.set("n", "<leader>wp", "<cmd>setlocal wrap<CR>", { desc = "[w]ra[p] text enabled" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "\\", ":Explore<CR>", { desc = "Open netrw file explorer" })

-- Autocommands & ft_settings

local ft_settings = vim.api.nvim_create_augroup("MyFtSettings", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Remove trailing whitespace on save",
	group = vim.api.nvim_create_augroup("remove-trailing-whitespace", { clear = true }),
	callback = function()
		local current_file = vim.fn.expand("%:p")
		if not current_file:match("%.md$") then
			vim.cmd([[%s/\s\+$//e]])
		end
	end,
})
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "remove line numbers in terminal",
	group = vim.api.nvim_create_augroup("kickstart-term", { clear = true }),
	callback = function()
		vim.wo.number = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.wo.wrap = true
		vim.opt_local.shiftwidth = 2
		vim.wo.linebreak = true
		vim.wo.breakindent = true
		vim.wo.showbreak = "|"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = ft_settings,
	pattern = { "lua", "vim", "r", "rmd" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = true
		vim.notify("ft_settings applied", vim.log.levels.INFO)
	end,
})

-- =====================
-- Fidget Messages to Buffer
-- =====================
-- Function to open Fidget notification history in a buffer
local function show_messages()
	local output = vim.fn.execute("messages")
	local lines = vim.split(output, "\n", { plain = true })

	-- make sure we always have at least one line to display
	if #lines == 0 then
		lines = { "" }
	end

	-- create a scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_call(buf, function()
		vim.opt_local.bufhidden = "wipe"
		vim.opt_local.buftype = "nofile"
		vim.opt_local.swapfile = false
	end)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- get UI dims
	local ui = vim.api.nvim_list_uis()[1]
	local max_len = 0
	for _, l in ipairs(lines) do
		max_len = math.max(max_len, #l)
	end

	-- compute unclamped size
	local want_w = max_len
	local want_h = #lines

	-- clamp to screen with a minimum of 1
	local width = math.max(1, math.min(want_w, ui.width - 4))
	local height = math.max(1, math.min(want_h, ui.height / 2))

	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})

	-- disable wrap
	vim.api.nvim_win_call(win, function()
		vim.wo.wrap = false
	end)

	-- close on <q>
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("Messages", show_messages, {
	desc = "Show :messages output in a floating window",
})
vim.keymap.set("n", "<leader>n", show_messages, { desc = "Show :messages output" })
-- =====================
-- 4. Floaterminal
-- =====================

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}
local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.9)
	local height = opts.height or math.floor(vim.o.lines * 0.6)

	-- calculate position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	--create a buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- no file, scratch buffer
	end

	-- define window config
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	-- create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return {
		buf = buf,
		win = win,
	}
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({
			buf = state.floating.buf,
		})
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.term()
		end
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t", "i" }, "<space>\\", toggle_terminal, { desc = "toggle floating terminal" })

----------------------------------------------------------------------
----------------------------------------------------------------------
-- term "from bottom"
local bottom_term = {
	buf = -1,
	win = -1,
}

local function toggle_bottom_terminal()
	-- If open, close it
	if vim.api.nvim_win_is_valid(bottom_term.win) then
		vim.api.nvim_win_hide(bottom_term.win)
		bottom_term.win = -1
		return
	end

	local height = math.floor(vim.o.lines * 0.3)
	local width = vim.o.columns

	-- Reuse buffer if valid, else create new
	if not vim.api.nvim_buf_is_valid(bottom_term.buf) then
		bottom_term.buf = vim.api.nvim_create_buf(false, true)
	end

	bottom_term.win = vim.api.nvim_open_win(bottom_term.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = vim.o.lines - height - 2,
		col = 0,
		style = "minimal",
		border = { "", "═", "", "", "", "", "", "" },
	})

	-- Start terminal if not already started
	if vim.bo[bottom_term.buf].buftype ~= "terminal" then
		vim.cmd("terminal")
	end

	vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("BottomTerm", toggle_bottom_terminal, {})
vim.keymap.set({ "n", "t", "i" }, "<space>--", toggle_bottom_terminal, { desc = "toggle bottom terminal" })
