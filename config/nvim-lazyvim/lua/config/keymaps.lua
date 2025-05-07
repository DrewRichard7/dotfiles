-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- center cursor on half page scroll
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "keeps half page down scroll centered on screen" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "keeps half page up scroll centered on screen" })

-- center cursor remap
keymap.set("n", "j", "jzz", { desc = "scroll down and center cursor" })
keymap.set("n", "k", "kzz", { desc = "scroll up and center cursor" })

-- visual mode keymaps
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move block down" }) -- moves highlighted code down by line
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move block up" }) -- moves highlighted code up

-- insert new line without leaving normal mode
keymap.set("n", "<leader>>o", "o<Esc>", { desc = "insert new line under cursor" }) -- insert a new blank line under cursor

keymap.set("n", "<leader>O", "O<Esc>", { desc = "insert new line above cursor" }) -- insert a new line above the cursor
