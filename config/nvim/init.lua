-- This is going to be a well documented neovim config.

-- vim options, keymaps & autocommands config below
-- ----------------------------------------------------------------
-- ----------------------------------------------------------------
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set default slime_cell_delimiter (fallback)
vim.g.slime_cell_delimiter = "```" -- Or whatever you want as the default

-- package manager: lazy.nvim
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------
require("config.lazy")
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------

local wk = require("which-key")
local ms = vim.lsp.protocol.Methods

-- makes neovim transparent to have the terminal's background
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })

-- sets the color of floating window borders
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#00DD96", bg = "NONE" })
-- another good option: "#A5DCFF"
-- sets border color of floating telescope windows
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#00DD96", bg = "NONE" })

-- line number options
vim.opt.number = true
vim.opt.relativenumber = true

-- adjusting default tabs and indentation
vim.opt.tabstop = 4 -- tabs, not indents
vim.opt.shiftwidth = 4 -- indents, not tabs
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting a new line

-- enable mouse mode
vim.opt.mouse = "a"

-- after status line installed, enable below to disable showing mode
vim.opt.showmode = false

-- show which line your cursor is on
vim.opt.cursorline = true

-- minimal number of screen lines to keep below the cursor
vim.opt.scrolloff = 10

-- show dialog for confirmation of unsaved changes
vim.opt.confirm = true

-- use system clipbaord, delete if you want separate clipboards
vim.opt.clipboard:append("unnamedplus") -- use system clipboard

-- Lua initialization file
vim.g.moonflyNormalFloat = true

-- split right and below by default
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Add paths for user-installed luarocks (Lua 5.1)
local user_lua_path =
	"/Users/drewrichard/.luarocks/share/lua/5.1/?.lua;/Users/drewrichard/.luarocks/share/lua/5.1/?/init.lua"
local user_c_path = "/Users/drewrichard/.luarocks/lib/lua/5.1/?.so"

package.path = package.path .. ";" .. user_lua_path
package.cpath = package.cpath .. ";" .. user_c_path

-- KEYMAPS ---------------------------------------------------------
-- keymap for exiting insert mode with jk
vim.keymap.set("i", "jk", "<ESC>", { desc = "exit insert mode with jk" })

-- center cursor on scroll
vim.keymap.set({ "n", "v" }, "j", "jzz", { desc = "center cursor on vertical scroll" })
vim.keymap.set({ "n", "v" }, "k", "kzz", { desc = "center cursor on vertical scroll" })

-- center cursor on half page scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "center cursor on half page scroll" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "center cursor on half page scroll" })

-- insert new line without exiting normal mode
vim.keymap.set("n", "<leader>o", "o<ESC>", { desc = "new line under cursor" })
vim.keymap.set("n", "<leader>O", "O<ESC>", { desc = "new line over cursor" })

-- source current file
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "source current file" })

-- source neovim init.lua
vim.keymap.set(
	"n",
	"<space><space>c",
	"<cmd>source ~/.config/nvim/init.lua<CR>",
	{ desc = "source file: neovim init.lua" }
)

-- source current line and selected lines
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "execute current line" })
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "execute current selection" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- pipe operator |>
vim.keymap.set("i", "<m-m>", "|>", { desc = "insert pipe operator" })

-- keep selections with indenting
vim.keymap.set("v", ">", ">gv", { desc = "keep selection after indent" })
vim.keymap.set("v", "<", "<gv", { desc = "keep selection after unindent" })

-- save file with ctrl-s
vim.keymap.set({ "n", "i" }, "<C-s>", "<ESC>:update<CR><esc>", { desc = "save with ctrl-s" })

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- resize windows with <shift> arrows
vim.keymap.set("n", "<S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<S-Down>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<leader>tw", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- set local buffer wrapped text
vim.keymap.set("n", "<leader>wp", "<cmd>setlocal wrap<CR>", { desc = "[w]ra[p] text enabled" })

local nmap = function(key, effect)
	vim.keymap.set("n", key, effect, { silent = true, noremap = true })
end

-- Move between windows using <ctrl> direction
nmap("<C-j>", "<C-W>j")
nmap("<C-k>", "<C-W>k")
nmap("<C-h>", "<C-W>h")
nmap("<C-l>", "<C-W>l")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- --AUTOCOMMANDS---------------------------------------------------
-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- remove line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "remove line numbers in terminal",
	group = vim.api.nvim_create_augroup("kickstart-term", { clear = true }),
	callback = function()
		vim.wo.number = false
	end,
})

-- Set conceal level for markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
})

-- below are some quarto specific commands and functions
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------

vim.g["quarto_is_r_mode"] = nil -- This removes or unsets the global variable quarto_is_r_mode.
vim.g["reticulate_running"] = false -- This sets the global variable reticulate_running to false.

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
local function send_cell()
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

--- Send code to terminal with vim-slime
--- If an R terminal has been opend, this is in r_mode
--- and will handle python code via reticulate when sent
--- from a python chunk.
local slime_send_region_cmd = ":<C-u>call slime#send_op(visualmode(), 1)<CR>"
slime_send_region_cmd = vim.api.nvim_replace_termcodes(slime_send_region_cmd, true, false, true)
local function send_region()
	-- if filetyps is not quarto, just send_region
	if vim.bo.filetype ~= "quarto" or vim.b["quarto_is_r_mode"] == nil then
		vim.cmd("normal" .. slime_send_region_cmd)
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
		vim.cmd("normal" .. slime_send_region_cmd)
	end
end

local imap = function(key, effect)
	vim.keymap.set("i", key, effect, { silent = true, noremap = true })
end

-- send code with ctrl+Enter
-- just like in e.g. RStudio
-- needs kitty (or other terminal) config:
-- map shift+enter send_text all \x1b[13;2u
-- map ctrl+enter send_text all \x1b[13;5u
nmap("<c-cr>", send_cell)
nmap("<s-cr>", send_cell)
imap("<c-cr>", send_cell)
imap("<s-cr>", send_cell)

local is_code_chunk = function()
	local current, _ = require("otter.keeper").get_current_language_context()
	if current then
		return true
	else
		return false
	end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
local insert_code_chunk = function(lang)
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

local insert_r_chunk = function()
	insert_code_chunk("r")
end

local insert_py_chunk = function()
	insert_code_chunk("python")
end

-- normal mode
wk.add({
	{ "<c-LeftMouse>", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition" },
	{ "<c-q>", "<cmd>q<cr>", desc = "close buffer" },
	{ "<cm-i>", insert_py_chunk, desc = "python code chunk" },
	{ "<m-I>", insert_py_chunk, desc = "python code chunk" },
	{ "<m-i>", insert_r_chunk, desc = "r code chunk" },
}, { mode = "n", silent = true })

-- visual mode
wk.add({
	{
		mode = { "v" },
		{ "<cr>", send_region, desc = "run code region" },
	},
})

-- insert mode
wk.add({
	{
		mode = { "i" },
		{ "<cm-i>", insert_py_chunk, desc = "python code chunk" },
		{ "<C-->", " <- ", desc = "assign" },
		{ "<m-I>", insert_py_chunk, desc = "python code chunk" },
		{ "<m-i>", insert_r_chunk, desc = "r code chunk" },
	},
}, { mode = "i" })

local function new_terminal(lang)
	vim.cmd("vsplit term://" .. lang)
end

local function new_terminal_python()
	new_terminal("python")
end

local function new_terminal_r()
	new_terminal("R --no-save")
end

local function new_terminal_ipython()
	new_terminal("ipython --no-confirm-exit")
end

-- normal mode with <leader>
wk.add({
	{
		{ "<leader><cr>", send_cell, desc = "run code cell" },
		{ "<leader>c", group = "[c]ode / [c]ell / [c]hunk" },
		{ "<leader>ci", new_terminal_ipython, desc = "new [i]python terminal" },
		{ "<leader>cj", new_terminal_julia, desc = "new [j]ulia terminal" },
		{ "<leader>cn", new_terminal_shell, desc = "[n]ew terminal with shell" },
		{ "<leader>cp", new_terminal_python, desc = "new [p]ython terminal" },
		{ "<leader>cr", new_terminal_r, desc = "new [R] terminal" },
		{ "<leader>f<space>", "<cmd>Telescope buffers<cr>", desc = "[ ] buffers" },
		{ "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "git [c]ommits" },
		{ "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "[j]umplist" },
		{ "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "[l]oclist" },
		{ "<leader>fm", "<cmd>Telescope marks<cr>", desc = "[m]arks" },
		{ "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "[q]uickfix" },
		{ "<leader>g", group = "[g]it" },
		{ "<leader>gd", group = "[d]iff" },
		{ "<leader>gdc", ":DiffviewClose<cr>", desc = "[c]lose" },
		{ "<leader>gdo", ":DiffviewOpen<cr>", desc = "[o]pen" },
		{ "<leader>gs", ":Gitsigns<cr>", desc = "git [s]igns" },
		{ "<leader>i", group = "[i]mage" },
		{ "<leader>l", group = "[l]anguage/lsp" },
		{ "<leader>ld", group = "[d]iagnostics" },
		{
			"<leader>ldd",
			function()
				vim.diagnostic.enable(false)
			end,
			desc = "[d]isable",
		},
		{ "<leader>lde", vim.diagnostic.enable, desc = "[e]nable" },
		{ "<leader>le", vim.diagnostic.open_float, desc = "diagnostics (show hover [e]rror)" },
		{ "<leader>lg", ":Neogen<cr>", desc = "neo[g]en docstring" },
		{ "<leader>o", group = "[o]tter & c[o]de" },
		{ "<leader>oa", require("otter").activate, desc = "otter [a]ctivate" },
		{ "<leader>oc", "O# %%<cr>", desc = "magic [c]omment code chunk # %%" },
		{ "<leader>od", require("otter").activate, desc = "otter [d]eactivate" },
		{ "<leader>op", insert_py_chunk, desc = "[p]ython code chunk" },
		{ "<leader>or", insert_r_chunk, desc = "[r] code chunk" },
		{ "<leader>q", group = "[q]uarto" },
		{
			"<leader>qE",
			function()
				require("otter").export(true)
			end,
			desc = "[E]xport with overwrite",
		},
		{ "<leader>qa", ":QuartoActivate<cr>", desc = "[a]ctivate" },
		{ "<leader>qe", require("otter").export, desc = "[e]xport" },
		{ "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "[p]review" },
		{ "<leader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "[q]uiet preview" },
		{ "<leader>qr", group = "[r]un" },
		{ "<leader>qra", ":QuartoSendAll<cr>", desc = "run [a]ll" },
		{ "<leader>qrb", ":QuartoSendBelow<cr>", desc = "run [b]elow" },
		{ "<leader>qrr", ":QuartoSendAbove<cr>", desc = "to cu[r]sor" },
	},
}, { mode = "n" })
