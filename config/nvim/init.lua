-- init.lua: Single-file Neovim configuration
-- This file merges all plugins, keymaps, LSP, Python, Telescope, and UI settings from your modular config into one file.
-- It is heavily documented and preserves all current functionality, especially for Python and Telescope.

-- =====================
-- 1. BASIC VIM SETTINGS
-- =====================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.slime_cell_delimiter = "```"
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

-- Floating window border colors
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#00DD96", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#00DD96", bg = "NONE" })

local general_augroup = vim.api.nvim_create_augroup("MyGeneralSetupAu", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = general_augroup,
	pattern = "*.ipynb",
	command = "setlocal filetype=quarto",
	desc = "Treat .ipynb as quarto files",
})

vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
	local buffer = args.buf

	local wid = nil
	local win_ids = vim.api.nvim_list_wins() -- Get all window IDs
	for _, win_id in ipairs(win_ids) do
		local win_bufnr = vim.api.nvim_win_get_buf(win_id)
		if win_bufnr == buffer then
			wid = win_id
		end
	end

	if wid == nil then
		return
	end

	vim.schedule(function()
		if vim.api.nvim_win_is_valid(wid) then
			vim.api.nvim_set_current_win(wid)
		end
	end)
end

local function create_nav_options(name)
	return {
		group = "DapGroup",
		pattern = string.format("*%s*", name),
		callback = navigate,
	}
end

-- needed for zen mode (theprimeagen)
function ColorMyPencils(color)
	color = color or "kanagawa"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
--=========================================================
------------------- MY CUSTOM COLORTHEME __________________
--=========================================================
local use_mytheme = true -- set to true to enable

local function apply_mytheme()
	local colors = {
		fg = "#ccc9c0",
		cursor = "#aeafad",
		comment = "#6A9955",
		keyword = "#569CD6",
		string = "#CE9178",
		number = "#B5CEA8",
		func = "#DED157",
		type = "#4EC9B0",
		variable = "#9CDCFE",
		constant = "#4FC1FF",
		operator = "#f200ff",
		error = "#f47171",
		warning = "#cca700",
		info = "#75beff",
		hint = "#81c164",
		visual = "#fdef9f",
		linehl = "#4a442c",
		search = "#515c6a",
		matchparen = "#006400",
	}

	local set = vim.api.nvim_set_hl

	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.termguicolors = true
	vim.g.colors_name = "mytheme"

	-- UI (all bg = "NONE" for transparency)
	set(0, "Normal", { fg = colors.fg, bg = "NONE" })
	set(0, "NormalNC", { fg = colors.fg, bg = "NONE" })
	set(0, "NormalFloat", { fg = colors.fg, bg = "NONE" })
	set(0, "FloatBorder", { fg = "#00DD96", bg = "NONE" })
	set(0, "TelescopeBorder", { fg = "#00DD96", bg = "NONE" })
	set(0, "Cursor", { fg = "NONE", bg = colors.cursor })
	set(0, "CursorLine", { bg = "NONE" })
	set(0, "CursorColumn", { bg = "NONE" })
	set(0, "Visual", { bg = "NONE", underline = true, reverse = true })
	set(0, "LineNr", { fg = "#a2905e", bg = "NONE" })
	set(0, "CursorLineNr", { fg = "#79dca5", bg = "NONE" })
	set(0, "VertSplit", { fg = "#ffe96e", bg = "NONE" })
	set(0, "StatusLine", { fg = colors.fg, bg = "NONE" })
	set(0, "StatusLineNC", { fg = "#fffae9", bg = "NONE" })
	set(0, "Pmenu", { fg = colors.fg, bg = "NONE" })
	set(0, "PmenuSel", { fg = "#fffae9", bg = "#333333" })
	set(0, "Search", { bg = colors.search, fg = colors.fg })
	set(0, "IncSearch", { bg = colors.search, fg = colors.fg })
	set(0, "MatchParen", { bg = colors.matchparen, underline = true })
	set(0, "Error", { fg = colors.error, bold = true, bg = "NONE" })
	set(0, "WarningMsg", { fg = colors.warning, bold = true, bg = "NONE" })
	set(0, "InfoMsg", { fg = colors.info, bg = "NONE" })
	set(0, "HintMsg", { fg = colors.hint, bg = "NONE" })

	-- Syntax
	set(0, "Comment", { fg = colors.comment, italic = true, bg = "NONE" })
	set(0, "Constant", { fg = colors.constant, bg = "NONE" })
	set(0, "String", { fg = colors.string, bg = "NONE" })
	set(0, "Character", { fg = colors.string, bg = "NONE" })
	set(0, "Number", { fg = colors.number, bg = "NONE" })
	set(0, "Boolean", { fg = colors.number, bg = "NONE" })
	set(0, "Identifier", { fg = colors.variable, bg = "NONE" })
	set(0, "Function", { fg = colors.func, italic = true, bg = "NONE" })
	set(0, "Statement", { fg = colors.keyword, bg = "NONE" })
	set(0, "Conditional", { fg = colors.keyword, bg = "NONE" })
	set(0, "Repeat", { fg = colors.keyword, bg = "NONE" })
	set(0, "Label", { fg = "#C8C8C8", bg = "NONE" })
	set(0, "Operator", { fg = colors.operator, bg = "NONE" })
	set(0, "Keyword", { fg = colors.keyword, bg = "NONE" })
	set(0, "Exception", { fg = colors.keyword, bg = "NONE" })
	set(0, "PreProc", { fg = colors.keyword, bg = "NONE" })
	set(0, "Type", { fg = colors.type, bg = "NONE" })
	set(0, "StorageClass", { fg = colors.type, bg = "NONE" })
	set(0, "Structure", { fg = "#3acfa7", bold = true, bg = "NONE" })
	set(0, "Typedef", { fg = colors.type, bg = "NONE" })
	set(0, "Special", { fg = "#D7BA7D", bg = "NONE" })
	set(0, "Underlined", { underline = true, bg = "NONE" })
	set(0, "Ignore", { fg = "#8c8c8c", bg = "NONE" })
	set(0, "ErrorMsg", { fg = colors.error, bold = true, bg = "NONE" })
	set(0, "Todo", { fg = "#fffae9", bg = "#653723", bold = true })

	-- Treesitter (nvim 0.5+)
	set(0, "@comment", { fg = colors.comment, italic = true, bg = "NONE" })
	set(0, "@keyword", { fg = colors.keyword, bg = "NONE" })
	set(0, "@string", { fg = colors.string, bg = "NONE" })
	set(0, "@number", { fg = colors.number, bg = "NONE" })
	set(0, "@function", { fg = colors.func, italic = true, bg = "NONE" })
	set(0, "@type", { fg = colors.type, bg = "NONE" })
	set(0, "@variable", { fg = colors.variable, bg = "NONE" })
	set(0, "@constant", { fg = colors.constant, bg = "NONE" })
	set(0, "@operator", { fg = colors.operator, bg = "NONE" })
	set(0, "@property", { fg = "#b790ff", italic = true, bg = "NONE" })
	set(0, "@field", { fg = "#42a3ff", italic = true, bg = "NONE" })
	set(0, "@parameter", { fg = "#8be4d8", italic = true, bg = "NONE" })
	set(0, "@enum", { fg = "#3dbbff", bold = true, bg = "NONE" })
	set(0, "@enumMember", { fg = "#3dbbff", bg = "NONE" })
	set(0, "@interface", { fg = "#ffea00", bg = "NONE" })
	set(0, "@namespace", { fg = "#51b7a3", bg = "NONE" })
	set(0, "@class", { fg = "#00d885", bg = "NONE" })
	set(0, "@struct", { fg = "#3acfa7", bold = true, bg = "NONE" })

	-- Diagnostics
	set(0, "DiagnosticError", { fg = colors.error, bg = "NONE" })
	set(0, "DiagnosticWarn", { fg = colors.warning, bg = "NONE" })
	set(0, "DiagnosticInfo", { fg = colors.info, bg = "NONE" })
	set(0, "DiagnosticHint", { fg = colors.hint, bg = "NONE" })

	-- Git
	set(0, "DiffAdd", { bg = "NONE" })
	set(0, "DiffChange", { bg = "NONE" })
	set(0, "DiffDelete", { bg = "NONE" })
	set(0, "DiffText", { bg = "NONE" })

	-- Terminal colors
	vim.g.terminal_color_0 = "#000000"
	vim.g.terminal_color_1 = "#cd3131"
	vim.g.terminal_color_2 = "#0dbc79"
	vim.g.terminal_color_3 = "#e5e510"
	vim.g.terminal_color_4 = "#2472c8"
	vim.g.terminal_color_5 = "#bc3fbc"
	vim.g.terminal_color_6 = "#11a8cd"
	vim.g.terminal_color_7 = "#e5e5e5"
	vim.g.terminal_color_8 = "#666666"
	vim.g.terminal_color_9 = "#f14c4c"
	vim.g.terminal_color_10 = "#23d18b"
	vim.g.terminal_color_11 = "#f5f543"
	vim.g.terminal_color_12 = "#3b8eea"
	vim.g.terminal_color_13 = "#d670d6"
	vim.g.terminal_color_14 = "#29b8db"
	vim.g.terminal_color_15 = "#e5e5e5"
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
	-- Colorscheme: Kanagawa (enabled)
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
	-- Add this to your lazy.nvim plugin list
	{
		"j-hui/fidget.nvim",
		opts = {
			progress = {
				display = {
					render_limit = 1,
					done_ttl = 1,
					done_icon = "✔",
				},
				ignore = {
					"lua_ls",
				},
			},
			notification = {
				override_vim_notify = true,
			},
		},
		config = function(_, opts)
			require("fidget").setup(opts)
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
			require("telescope").setup({ extensions = { fzf = {} } })
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
				builtin.current_buffer_fuzzy_find(
					require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
				)
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
				opts = {
					library = {
						{
							path = "${3rd}/luv/library",
							words = { "vim%.uv" },
						},
					},
				},
			},
			{ "saghen/blink.cmp" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "stevearc/conform.nvim" },
		},
		config = function()
			-- LSP capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
			if blink_cmp_ok then
				capabilities = blink_cmp.get_lsp_capabilities()
			else
				vim.notify("blink.cmp not found for LSP capabilities, using default.", vim.log.levels.WARN)
			end

			local lsp_flags = { allow_incremental_sync = true, debounce_text_changes = 150 }
			local function get_lsp_opts(server_specific_opts)
				local base_opts = { capabilities = capabilities, flags = lsp_flags }
				return vim.tbl_deep_extend("force", {}, base_opts, server_specific_opts or {})
			end
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- A helper function to simplify setting keymaps.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					--
					-- Go-to Commands
					--
					-- Jumps to the definition of the word under your cursor.
					map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")

					-- Jumps to the implementation of the word under yourcursor.
					-- This is the mapping you requested.
					map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

					-- Jumps to the type definition of the word under your cursor.
					map("gy", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")

					-- Finds references for the word under your cursor in a Telescope list.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					--
					-- Action Commands
					--
					-- Renames the variable under your cursor across files.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Executes a code action, like refactoring or fixing a diagnostic.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

					--
					-- Informational Commands
					--
					-- Shows hover documentation for the word under your cursor.
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					-- Shows signature help for the function call you are in.
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
				end,
			})
			-- LSP server setups
			require("lspconfig").lua_ls.setup(get_lsp_opts({
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						diagnostics = {
							disable = { "trailing-space", "missing-fields" },
						},
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("lua", true),
						},
						doc = { privateName = { "^_" } },
						telemetry = { enable = false },
					},
				},
			}))
			require("lspconfig").pyright.setup(get_lsp_opts())
			require("lspconfig").ruff.setup(get_lsp_opts({
				init_options = { settings = { lineLength = 80 } },
				-- This is the key change:
				-- We explicitly tell the ruff LSP server NOT to provide formatting.
				-- This makes conform.nvim the sole authority for formatting Python files.
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			}))
			require("lspconfig").r_language_server.setup(get_lsp_opts({
				settings = {
					r = {
						lsp = {
							rich_documentation = true,
							diagnostics = true,
							lint = { linters = "lintr::default_linters" },
						},
					},
				},
			}))
			require("lspconfig").rust_analyzer.setup(get_lsp_opts({
				settings = { ["rust-analyzer"] = { diagnostics = { enable = true } } },
			}))
			require("lspconfig").html.setup(get_lsp_opts())
			require("lspconfig").yamlls.setup(get_lsp_opts({
				settings = { yaml = { schemaStore = { enable = true, url = "" } } },
			}))
			require("lspconfig").jsonls.setup(get_lsp_opts())
			require("lspconfig").taplo.setup(get_lsp_opts())

			-- Formatting: stevearc/conform.nvim
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_format" },
					lua = { "stylua" },
					json = { "jq" },
					yaml = { "prettier" },
					html = { "prettier" },
					toml = { "taplo" },
					-- Add more as needed
				},
				-- Optionally, configure formatters here
				formatters = {
					ruff_format = {},
					stylua = {},
					jq = {},
					prettier = {},
					taplo = {},
				},
			})
			-- format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						timeout_ms = 2000,
					})
				end,
			})
			-- Keymap: format on demand
			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				require("conform").format({
					lsp_fallback = true,
					timeout_ms = 2000,
				})
			end, { desc = "[L]SP [F]ormat" })

			-- Mason setup
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
				automatic_enable = true,
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

			-- LSP UI/diagnostics
			vim.lsp.handlers.hover = {
				border = "rounded",
				max_width = 80,
			}
			vim.lsp.handlers.signature_help = {
				border = "rounded",
				max_width = 80,
			}
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded" },
			})
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
					selection = require("CopilotChat.select").buffer,
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

		vim.keymap.set("n", "]t", function()
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
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-;>", function()
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
		},
	},

	-- Quarto, Otter, Jupytext, Slime, etc. (Python/R/Quarto integration)
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		opts = {},
		dependencies = { "jmbuhr/otter.nvim" },
		config = function(_, opts)
			require("quarto").setup(opts)
		end, -- Ensure setup is called
	},
	{
		"GCBallesteros/jupytext.nvim",
		enabled = true,
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
		config = function(_, opts)
			require("jupytext").setup(opts)
		end,
	},
	{
		"jpalardy/vim-slime",
		enabled = true,
		init = function()
			-- This Lua function will be called from Vimscript to check the context.
			-- It needs to be global for v:lua to access it.
			_G.SlimeHelper_is_otter_python_context = function()
				local otter_ok, otter_tools = pcall(require, "otter.tools.functions")
				if otter_ok then
					return otter_tools.is_otter_language_context("python")
				end
				-- Silently return false if otter is not available or errors.
				-- A vim.notify could be added here for debugging if needed.
				return false
			end

			local vimscript_block = [[
let g:slime_dispatch_ipython_pause = 100
function! SlimeOverride_EscapeText_quarto(text)
  " Update the buffer-local variable with the current context from Lua
  let b:quarto_is_python_chunk = v:lua.SlimeHelper_is_otter_python_context()

  if exists('g:slime_python_ipython') && len(split(a:text, '\n')) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
    return ['%cpaste -q\n', g:slime_dispatch_ipython_pause, a:text, '--', '\n']
  elseif exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk " R mode trying to send Python (e.g. reticulate)
    return [a:text, '\n'] " Or specific handling for reticulate if different
  else " Default, or non-Python chunk in Quarto, or not a Quarto file
    return [a:text]
  endif
endfunction
]]
			-- Use nvim_exec to define the Vimscript function. It handles multi-line strings well.
			vim.cmd(vimscript_block)

			vim.g.slime_target = "neovim"
			vim.g.slime_no_mappings = true
			vim.g.slime_python_ipython = 1 -- Default to Python/IPython if available
		end,
		config = function()
			-- These settings are applied after the plugin loads
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
				quarto = { url_encode_path = true, template = "![$CURSOR]($FILE_PATH)" },
			},
		},
		config = function(_, opts)
			require("img-clip").setup(opts)
		end,
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
	},
	-- nvim dap DAP (debugger)
	{
		{
			"mfussenegger/nvim-dap",
			lazy = false,
			config = function()
				local dap = require("dap")
				dap.set_log_level("DEBUG")

				vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
				vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
				vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
				vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
				vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
				vim.keymap.set("n", "<leader>B", function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end, { desc = "Debug: Set Conditional Breakpoint" })
			end,
		},

		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
			config = function()
				local dap = require("dap")
				local dapui = require("dapui")
				local function layout(name)
					return {
						elements = {
							{ id = name },
						},
						enter = true,
						size = 40,
						position = "right",
					}
				end
				local name_to_layout = {
					repl = { layout = layout("repl"), index = 0 },
					stacks = { layout = layout("stacks"), index = 0 },
					scopes = { layout = layout("scopes"), index = 0 },
					console = { layout = layout("console"), index = 0 },
					watches = { layout = layout("watches"), index = 0 },
					breakpoints = { layout = layout("breakpoints"), index = 0 },
				}
				local layouts = {}

				for name, config in pairs(name_to_layout) do
					table.insert(layouts, config.layout)
					name_to_layout[name].index = #layouts
				end

				local function toggle_debug_ui(name)
					dapui.close()
					local layout_config = name_to_layout[name]

					if layout_config == nil then
						error(string.format("bad name: %s", name))
					end

					local uis = vim.api.nvim_list_uis()[1]
					if uis ~= nil then
						layout_config.size = uis.width
					end

					pcall(dapui.toggle, layout_config.index)
				end

				vim.keymap.set("n", "<leader>dr", function()
					toggle_debug_ui("repl")
				end, { desc = "Debug: toggle repl ui" })
				vim.keymap.set("n", "<leader>ds", function()
					toggle_debug_ui("stacks")
				end, { desc = "Debug: toggle stacks ui" })
				vim.keymap.set("n", "<leader>dw", function()
					toggle_debug_ui("watches")
				end, { desc = "Debug: toggle watches ui" })
				vim.keymap.set("n", "<leader>db", function()
					toggle_debug_ui("breakpoints")
				end, { desc = "Debug: toggle breakpoints ui" })
				vim.keymap.set("n", "<leader>dS", function()
					toggle_debug_ui("scopes")
				end, { desc = "Debug: toggle scopes ui" })
				vim.keymap.set("n", "<leader>dc", function()
					toggle_debug_ui("console")
				end, { desc = "Debug: toggle console ui" })

				vim.api.nvim_create_autocmd("BufEnter", {
					group = "DapGroup",
					pattern = "*dap-repl*",
					callback = function()
						vim.wo.wrap = true
					end,
				})

				vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
				vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

				dapui.setup({
					layouts = layouts,
					enter = true,
				})

				dap.listeners.before.event_terminated.dapui_config = function()
					dapui.close()
				end
				dap.listeners.before.event_exited.dapui_config = function()
					dapui.close()
				end

				dap.listeners.after.event_output.dapui_config = function(_, body)
					if body.category == "console" then
						dapui.eval(body.output) -- Sends stdout/stderr to Console
					end
				end
			end,
		},

		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = {
				"williamboman/mason.nvim",
				"mfussenegger/nvim-dap",
				"neovim/nvim-lspconfig",
			},
			config = function()
				require("mason-nvim-dap").setup({
					ensure_installed = {
						"debugpy",
						"local-lua-debugger-vscode",
					},
					automatic_installation = true,
					handlers = {
						function(config)
							require("mason-nvim-dap").default_setup(config)
						end,
						delve = function(config)
							table.insert(config.configurations, 1, {
								args = function()
									return vim.split(vim.fn.input("args> "), " ")
								end,
								type = "delve",
								name = "file",
								request = "launch",
								program = "${file}",
								outputMode = "remote",
							})
							table.insert(config.configurations, 1, {
								args = function()
									return vim.split(vim.fn.input("args> "), " ")
								end,
								type = "delve",
								name = "file args",
								request = "launch",
								program = "${file}",
								outputMode = "remote",
							})
							require("mason-nvim-dap").default_setup(config)
						end,
					},
				})
			end,
		},
	},
	-- git signs
	{ "lewis6991/gitsigns.nvim" },
	-- vim fugitive (git related)
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

			local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

			local autocmd = vim.api.nvim_create_autocmd
			autocmd("BufWinEnter", {
				group = ThePrimeagen_Fugitive,
				pattern = "*",
				callback = function()
					if vim.bo.ft ~= "fugitive" then
						return
					end

					local bufnr = vim.api.nvim_get_current_buf()
					local opts = { buffer = bufnr, remap = false }
					vim.keymap.set("n", "<leader>p", function()
						vim.cmd.Git("push")
					end, opts)

					-- rebase always
					vim.keymap.set("n", "<leader>P", function()
						vim.cmd.Git({ "pull", "--rebase" })
					end, opts)

					-- NOTE: It allows me to easily set the branch i am pushing and any tracking
					-- needed if i did not set the branch up correctly
					-- vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
				end,
			})

			vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
			vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
		end,
	},
	-- Zen mode (not to be confused with mini.zen though similar)

	{
		"folke/zen-mode.nvim",
		config = function()
			vim.keymap.set("n", "<leader>zz", function()
				require("zen-mode").setup({
					window = {
						width = 90,
						options = {},
					},
				})
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = true
				vim.wo.rnu = true
				ColorMyPencils()
			end)

			vim.keymap.set("n", "<leader>zZ", function()
				require("zen-mode").setup({
					window = {
						width = 80,
						options = {},
					},
				})
				require("zen-mode").toggle()
				vim.wo.wrap = false
				vim.wo.number = false
				vim.wo.rnu = false
				vim.opt.colorcolumn = "0"
				ColorMyPencils()
			end)
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		vim.keymap.set("n", "<C-S-h>", ":TmuxNavigateLeft<CR>"),
		vim.keymap.set("n", "<C-S-j>", ":TmuxNavigateDown<CR>"),
		vim.keymap.set("n", "<C-S-k>", ":TmuxNavigateUp<CR>"),
		vim.keymap.set("n", "<C-S-l>", ":TmuxNavigateRight<CR>"),
	},
	-- vim-test and vimux
	{
		"vim-test/vim-test",
		dependencies = {
			"preservim/vimux",
		},
		vim.keymap.set("n", "<leader>Tn", ":TestNearest<CR>", { desc = "Run nearest test" }),
		vim.keymap.set("n", "<leader>Tf", ":TestFile<CR>", { desc = "Run tests in file" }),
		vim.keymap.set("n", "<leader>Ts", ":TestSuite<CR>", { desc = "Run test suite" }),
		vim.keymap.set("n", "<leader>Tl", ":TestLast<CR>", { desc = "Run last test" }),
		vim.keymap.set("n", "<leader>Tv", ":TestVisit<CR>", { desc = "Visit test file" }),
		vim.cmd("let test#strategy = 'vimux'"),
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
				wk.setup({
					-- Add any specific which-key options here, e.g.:
					-- window = { border = "rounded", winblend = 0 },
					-- layout = { spacing = 6 },
				})

				-- Your which-key mappings, moved here
				-- Ensure helper functions are accessible (they are global in your config)
				wk.add({
					{ "<c-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition" },
					{ "<c-q>", "<cmd>q<cr>", desc = "close buffer" },
					{ "<cm-i>", insert_py_chunk, desc = "python code chunk" },
					{ "<m-I>", insert_py_chunk, desc = "python code chunk" },
					{ "<m-i>", insert_r_chunk, desc = "r code chunk" },
				}, { mode = "n", silent = true })

				wk.add({
					{ mode = { "v" }, { "<cr>", send_region, desc = "run code region" } },
				})

				wk.add({
					{
						mode = { "i" },
						{ "<cm-i>", insert_py_chunk, desc = "python code chunk" },
						{ "<C-->", " <- ", desc = "assign" },
						{ "<m-I>", insert_py_chunk, desc = "python code chunk" },
						{ "<m-i>", insert_r_chunk, desc = "r code chunk" },
					},
				}, { mode = "i" })

				wk.add({
					{
						{ "<leader><cr>", send_cell, desc = "run code cell" },
						{ "<leader>c", group = "[c]ode / [c]ell / [c]hunk" },
						{
							"<leader>ci",
							new_terminal_ipython,
							desc = "new [i]python terminal",
						},
						-- {
						-- 	"<leader>cp",
						-- 	new_terminal_python,
						-- 	desc = "new [p]ython terminal",
						-- },
						{ "<leader>cr", new_terminal_r, desc = "new [R] terminal" },
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
						{
							"<leader>op",
							insert_py_chunk,
							desc = "[p]ython code chunk",
						},
						{ "<leader>or", insert_r_chunk, desc = "[r] code chunk" },
						{ "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "[p]review" },
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

-- Function to show current git branch using fidget.nvim
local function show_git_branch()
	local branch = vim.fn.systemlist("git branch --show-current")[1] or ""
	if branch == "" then
		require("fidget").notify("Not in a git repository", vim.log.levels.INFO, { title = "Git Branch" })
	else
		require("fidget").notify("Current branch: " .. branch, vim.log.levels.INFO, { title = "Git Branch" })
	end
end
-- Keymap: <leader>br to show current git branch
vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Show git branches" })

-- Helper functions for basic keymaps (if not used by which-key, can stay here)
local nmap = function(key, effect)
	vim.keymap.set("n", key, effect, { silent = true, noremap = true })
end
local imap = function(key, effect)
	vim.keymap.set("i", key, effect, { silent = true, noremap = true })
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
	"<cmd>source ~/.config/nvim/init2.lua<CR>",
	{ desc = "source file: neovim init2.lua" }
)
vim.keymap.set("n", "<space>x", ":lua vim.cmd('.lua')<CR>", { desc = "execute current line" }) -- Corrected to execute current line as Lua
vim.keymap.set(
	"v",
	"<space>x",
	":lua vim.api.nvim_command('lua ' .. table.concat(vim.api.nvim_buf_get_lines(0, vim.fn.line(\"'<\") - 1, vim.fn.line(\"'>\"), false), '\\n'))<CR>",
	{ desc = "execute current selection as Lua" }
) -- More robust visual selection execution
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-S-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-S-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-S-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-S-k>", "<C-w><C-k>")
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
vim.api.nvim_create_autocmd("FileType", {
	group = ft_settings,
	pattern = "python",
	callback = function()
		vim.b.slime_cell_delimiter = "#\\s\\=%%"
		vim.notify("Python ft_settings applied", vim.log.levels.INFO)
	end,
})

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
		border = "single",
	})

	-- Start terminal if not already started
	if vim.bo[bottom_term.buf].buftype ~= "terminal" then
		vim.fn.termopen(vim.o.shell)
	end

	vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("BottomTerm", toggle_bottom_terminal, {})
vim.keymap.set({ "n", "t", "i" }, "<space>--", toggle_bottom_terminal, { desc = "toggle bottom terminal" })

-- =====================
-- 5. PYTHON/QUARTO/CHUNK HELPERS
-- =====================
-- These functions are defined globally and used by which-key mappings and vim-slime
vim.g["quarto_is_r_mode"] = nil
vim.g["reticulate_running"] = false

function send_cell() -- Made global for which-key
	if vim.b["quarto_is_r_mode"] == nil then
		vim.fn["slime#send_cell"]()
		return
	end
	if vim.b["quarto_is_r_mode"] == true then
		vim.g.slime_python_ipython = 0
		local is_python = require("otter.tools.functions").is_otter_language_context("python")
		if is_python and not vim.b["reticulate_running"] then
			vim.fn["slime#send"]("reticulate::repl_python()" .. "\r")
			vim.b["reticulate_running"] = true
		end
		if not is_python and vim.b["reticulate_running"] then
			vim.fn["slime#send"]("exit" .. "\r")
			vim.b["reticulate_running"] = false
		end
		vim.fn["slime#send_cell"]()
	end
end

local slime_send_region_cmd_str = ":<C-u>call slime#send_op(visualmode(), 1)<CR>"
local slime_send_region_cmd_termcodes = vim.api.nvim_replace_termcodes(slime_send_region_cmd_str, true, false, true)
function send_region() -- Made global
	if vim.bo.filetype ~= "quarto" or vim.b["quarto_is_r_mode"] == nil then
		vim.cmd("normal!" .. slime_send_region_cmd_termcodes)
		return
	end
	if vim.b["quarto_is_r_mode"] == true then
		vim.g.slime_python_ipython = 0
		local is_python = require("otter.tools.functions").is_otter_language_context("python")
		if is_python and not vim.b["reticulate_running"] then
			vim.fn["slime#send"]("reticulate::repl_python()" .. "\r")
			vim.b["reticulate_running"] = true
		end
		if not is_python and vim.b["reticulate_running"] then
			vim.fn["slime#send"]("exit" .. "\r")
			vim.b["reticulate_running"] = false
		end
		vim.cmd("normal!" .. slime_send_region_cmd_termcodes)
	end
end

function is_code_chunk() -- Made global
	local current_ctx_ok, otter_keeper = pcall(require, "otter.keeper")
	if not current_ctx_ok then
		return false
	end
	local current, _ = otter_keeper.get_current_language_context()
	return current ~= nil
end

function insert_code_chunk(lang) -- Made global
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
	local keys
	if is_code_chunk() then
		keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
	else
		keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
	end
	keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

function insert_r_chunk()
	insert_code_chunk("r")
end -- Made global

function insert_py_chunk()
	insert_code_chunk("python")
end -- Made global

local function new_terminal(lang)
	vim.cmd("vsplit term://" .. lang)
end -- This can stay local if only used by the next functions
function new_terminal_python()
	new_terminal("python")
end -- Made global

function new_terminal_r()
	new_terminal("R --no-save")
end -- Made global

function new_terminal_ipython()
	new_terminal("ipython --no-confirm-exit")
end -- Made global
