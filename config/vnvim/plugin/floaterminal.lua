vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

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
vim.keymap.set({ "n", "t", "i" }, "<space>-", toggle_bottom_terminal, { desc = "toggle bottom terminal" })
