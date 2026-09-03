local map = vim.keymap.set 

-- clear explorer highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- oil explorer
map("n", "<leader>e", "<cmd>Oil<cr>")

-- telescope search
map("n", "<leader><leader>", function()
	require("telescope.builtin").find_files()
end)

-- grep project
map("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end)

-- buffers
map("n", "<leader>b", function()
	require("telescope.builtin").buffers()
end)

-- mason
map("n", "<leader>pm", "<cmd>Mason<cr>")

