-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git Blame for current file", noremap = true, silent = true })
