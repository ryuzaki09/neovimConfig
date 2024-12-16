-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
map("n", "gt", "<cmd>bnext<cr>")
map("n", "<C-n>", "<cmd>Neotree toggle<CR>")
map("n", "\\p", "<cmd>LazyFormat<cr>")
